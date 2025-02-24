package main

import (
	"context"
	"flag"
	"log"
	"net"
	"os"
	"time"

	"github.com/gocql/gocql"
	"github.com/mattgallagher92/library-book-tracker/internal/config"
	timeProvider "github.com/mattgallagher92/library-book-tracker/internal/time"
	borrowernotificationv1 "github.com/mattgallagher92/library-book-tracker/proto/borrower_notification/v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"
)

type Loan struct {
	BorrowerID    gocql.UUID
	DueDate       time.Time
	BookID        gocql.UUID
	BorrowerName  string
	BorrowerEmail string
	BookTitle     string
	BookAuthor    string
}

func checkDueLoans(session *gocql.Session, provider timeProvider.Provider) error {
	now := provider.Now()
	today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	twoDaysFromNow := today.AddDate(0, 0, 2)

	log.Printf("Checking for loans due on %s", twoDaysFromNow.Format(time.RFC3339))
	// Query for loans due in 2 days that haven't been notified
	upcomingLoans := session.Query(
		`SELECT borrower_id, due_date, book_id, 
		        borrower_name, borrower_email,
		        book_title, book_author,
		        due_soon_notification_sent
		 FROM loans 
		 WHERE due_date = ? 
		   AND due_soon_notification_sent = false`,
		twoDaysFromNow,
	).Iter()
	log.Printf("Found at least %d unnotified loans due on %s", upcomingLoans.NumRows(), twoDaysFromNow.Format(time.RFC3339))

	var (
		loan             Loan
		notificationSent bool
	)
	for upcomingLoans.Scan(
		&loan.BorrowerID, &loan.DueDate, &loan.BookID,
		&loan.BorrowerName, &loan.BorrowerEmail,
		&loan.BookTitle, &loan.BookAuthor,
		&notificationSent,
	) {
		log.Printf("NOTIFICATION: Dear %s (%s), reminder that '%s' by %s is due on %s",
			loan.BorrowerName,
			loan.BorrowerEmail,
			loan.BookTitle,
			loan.BookAuthor,
			loan.DueDate.Format("2006-01-02"))

		// Mark notification as sent
		if err := session.Query(
			`UPDATE loans 
			 SET due_soon_notification_sent = true 
			 WHERE borrower_id = ? AND due_date = ? AND book_id = ?`,
			loan.BorrowerID, loan.DueDate, loan.BookID,
		).Exec(); err != nil {
			log.Printf("Failed to mark notification as sent: %v", err)
		}
	}

	return upcomingLoans.Close()
}

type notificationServer struct {
	borrowernotificationv1.UnimplementedBorrowerNotificationServiceServer
	timeProvider timeProvider.Provider
}

func (s *notificationServer) UpdateSimulatedTime(ctx context.Context, req *borrowernotificationv1.UpdateSimulatedTimeRequest) (*borrowernotificationv1.UpdateSimulatedTimeResponse, error) {
	if provider, ok := s.timeProvider.(*timeProvider.SimulatedProvider); ok {
		t, err := time.Parse(time.RFC3339, req.Timestamp)
		if err != nil {
			return nil, status.Errorf(codes.InvalidArgument, "invalid timestamp format: %v", err)
		}
		provider.SetTime(t)
		return &borrowernotificationv1.UpdateSimulatedTimeResponse{}, nil
	}
	return nil, status.Error(codes.FailedPrecondition, "time simulation not enabled")
}

func main() {
	checkInterval := flag.Int("interval", 300, "Interval between checks in seconds")
	flag.Parse()

	log.Println("Borrower notification service starting...")
	log.Printf("Will check for due loans every %d seconds", *checkInterval)

	// Load configuration
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	// Initialize Cassandra cluster config
	cluster := gocql.NewCluster(cfg.CassandraHosts...)
	cluster.Keyspace = cfg.Keyspace
	cluster.Consistency = gocql.Quorum

	// Create session
	session, err := cluster.CreateSession()
	if err != nil {
		log.Fatalf("Failed to create Cassandra session: %v", err)
	}
	defer session.Close()

	log.Println("Connected to Cassandra")

	// Initialize time provider
	var tp timeProvider.Provider
	if os.Getenv("SIMULATE_TIME") == "true" {
		log.Println("Using simulated time")
		tp = timeProvider.NewSimulatedProvider(time.Now())
	} else {
		log.Println("Using actual system time")
		tp = &timeProvider.RealProvider{}
	}

	// Create gRPC server
	server := grpc.NewServer()
	notificationSrv := &notificationServer{
		timeProvider: tp,
	}
	borrowernotificationv1.RegisterBorrowerNotificationServiceServer(server, notificationSrv)

	// Start listening for gRPC requests
	lis, err := net.Listen("tcp", ":50053")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// Enable reflection in development mode
	if os.Getenv("ENV") != "production" {
		reflection.Register(server)
		log.Println("gRPC reflection enabled for development")
	}

	log.Printf("gRPC server listening on :50053")

	// Start notification checker in a goroutine
	go func() {
		ticker := time.NewTicker(time.Duration(*checkInterval) * time.Second)
		defer ticker.Stop()

		// Do an initial check immediately
		if err := checkDueLoans(session, tp); err != nil {
			log.Printf("Error checking due loans: %v", err)
		}

		// Then check periodically
		for range ticker.C {
			if err := checkDueLoans(session, tp); err != nil {
				log.Printf("Error checking due loans: %v", err)
			}
		}
	}()

	// Start gRPC server
	if err := server.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
