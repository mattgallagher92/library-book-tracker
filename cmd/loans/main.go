package main

import (
	"context"
	"errors"
	"log"
	"net"
	"os"
	"time"

	"github.com/gocql/gocql"
	"github.com/mattgallagher92/library-book-tracker/internal/config"
	loansv1 "github.com/mattgallagher92/library-book-tracker/proto/loans/v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"
)

// BorrowBookCommand represents the input for borrowing a book
type BorrowBookCommand struct {
	BorrowerID gocql.UUID
	BookID     gocql.UUID
}

// ErrTooManyBooksCheckedOut indicates the borrower has reached their limit
var ErrTooManyBooksCheckedOut = errors.New("borrower has reached maximum number of checked out books")

func handleBorrowBook(session *gocql.Session, cmd BorrowBookCommand) error {
	log.Printf("Starting borrow book process for borrower %s and book %s", cmd.BorrowerID, cmd.BookID)

	// First check if borrower can take out more books
	var checkedOutBooks int
	if err := session.Query(
		`SELECT checked_out_books FROM borrower_book_count WHERE id = ?`,
		cmd.BorrowerID,
	).Scan(&checkedOutBooks); err != nil {
		return err
	}
	log.Printf("Borrower %s currently has %d books checked out", cmd.BorrowerID, checkedOutBooks)

	if checkedOutBooks >= 2 {
		log.Printf("Borrower %s has reached maximum number of books (2)", cmd.BorrowerID)
		return ErrTooManyBooksCheckedOut
	}

	// Create batch of updates
	batch := session.NewBatch(gocql.LoggedBatch)

	// Update borrower's checked out book count
	batch.Query(
		`UPDATE borrower_book_count SET checked_out_books = checked_out_books + 1 WHERE id = ?`,
		cmd.BorrowerID,
	)
	log.Printf("Added checked_out_books increment to batch for borrower %s", cmd.BorrowerID)

	// Update book location
	batch.Query(
		`UPDATE book_locations 
		SET current_location_type = 'checked_out', 
		    current_location_id = ? 
		WHERE book_id = ?`,
		cmd.BorrowerID, cmd.BookID,
	)
	log.Printf("Added book location update to batch for %s to checked out with %s", cmd.BookID, cmd.BorrowerID)

	// Get borrower info
	var borrowerName, borrowerEmail string
	if err := session.Query(
		`SELECT name, email_address FROM borrower WHERE id = ?`,
		cmd.BorrowerID,
	).Scan(&borrowerName, &borrowerEmail); err != nil {
		return err
	}
	log.Printf("Retrieved borrower details for %s", cmd.BorrowerID)

	// Get book info
	var bookTitle, authorFirstName, authorSurname string
	if err := session.Query(
		`SELECT title, author_first_name, author_surname FROM book_locations WHERE book_id = ?`,
		cmd.BookID,
	).Scan(&bookTitle, &authorFirstName, &authorSurname); err != nil {
		return err
	}
	log.Printf("Retrieved book details for %s", cmd.BookID)

	// Create loan record
	dueDate := time.Now().AddDate(0, 0, 7) // 1 week loan duration
	batch.Query(
		`INSERT INTO loans (
			borrower_id, due_date, book_id,
			borrower_name, borrower_email,
			book_title, book_author
		) VALUES (?, ?, ?, ?, ?, ?, ?)`,
		cmd.BorrowerID, dueDate, cmd.BookID,
		borrowerName, borrowerEmail,
		bookTitle, authorFirstName+" "+authorSurname,
	)
	log.Printf("Added loan record creation to batch for book %s and borrower %s with due date %s",
		cmd.BookID, cmd.BorrowerID, dueDate.Format(time.RFC3339))

	// Execute all updates atomically
	if err := session.ExecuteBatch(batch); err != nil {
		log.Printf("Failed to execute batch for book %s and borrower %s: %v", cmd.BookID, cmd.BorrowerID, err)
		return err
	}
	log.Printf("Successfully completed borrow book process for borrower %s and book %s", cmd.BorrowerID, cmd.BookID)

	return nil
}

// loansServer implements the LoansService gRPC service
type loansServer struct {
	loansv1.UnimplementedLoansServiceServer
	session *gocql.Session
}

// BorrowBook implements the gRPC method for borrowing a book
func (s *loansServer) BorrowBook(ctx context.Context, req *loansv1.BorrowBookRequest) (*loansv1.BorrowBookResponse, error) {
	borrowerID, err := gocql.ParseUUID(req.BorrowerId)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid borrower ID: %v", err)
	}

	bookID, err := gocql.ParseUUID(req.BookId)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid book ID: %v", err)
	}

	cmd := BorrowBookCommand{
		BorrowerID: borrowerID,
		BookID:     bookID,
	}

	if err := handleBorrowBook(s.session, cmd); err != nil {
		if err == ErrTooManyBooksCheckedOut {
			return nil, status.Error(codes.FailedPrecondition, err.Error())
		}
		return nil, status.Errorf(codes.Internal, "failed to borrow book: %v", err)
	}

	dueDate := time.Now().AddDate(0, 0, 7).Format(time.RFC3339)
	return &loansv1.BorrowBookResponse{
		DueDate: dueDate,
	}, nil
}

func main() {
	log.Println("Loans service starting...")

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

	log.Println("Connected to Cassandra successfully")

	// Create gRPC server
	server := grpc.NewServer()
	loansv1.RegisterLoansServiceServer(server, &loansServer{
		session: session,
	})

	// Start listening for gRPC requests
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// Enable reflection in development mode
	if os.Getenv("ENV") != "production" {
		reflection.Register(server)
		log.Println("gRPC reflection enabled for development")
	}

	log.Printf("Server listening on :50051")
	if err := server.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
