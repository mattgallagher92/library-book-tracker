package main

import (
	"flag"
	"log"
	"os"
	"time"

	"github.com/gocql/gocql"
	"github.com/mattgallagher92/library-book-tracker/internal/config"
	timeProvider "github.com/mattgallagher92/library-book-tracker/internal/time"
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
	twoDaysFromNow := time.Date(
		now.Year(), now.Month(), now.Day()+2,
		0, 0, 0, 0,
		now.Location(),
	)

	// Query for loans due in 2 days
	iter := session.Query(
		`SELECT borrower_id, due_date, book_id, 
		        borrower_name, borrower_email,
		        book_title, book_author
		 FROM loans 
		 WHERE due_date = ?`,
		twoDaysFromNow,
	).Iter()

	var loan Loan
	for iter.Scan(
		&loan.BorrowerID, &loan.DueDate, &loan.BookID,
		&loan.BorrowerName, &loan.BorrowerEmail,
		&loan.BookTitle, &loan.BookAuthor,
	) {
		log.Printf("NOTIFICATION: Dear %s (%s), reminder that '%s' by %s is due on %s",
			loan.BorrowerName,
			loan.BorrowerEmail,
			loan.BookTitle,
			loan.BookAuthor,
			loan.DueDate.Format("2006-01-02"))
	}

	return iter.Close()
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
}
