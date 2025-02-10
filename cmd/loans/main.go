package main

import (
	"errors"
	"log"
	"time"

	"github.com/gocql/gocql"
)

// BorrowBookCommand represents the input for borrowing a book
type BorrowBookCommand struct {
	BorrowerID gocql.UUID
	BookID     gocql.UUID
}

// ErrTooManyBooksCheckedOut indicates the borrower has reached their limit
var ErrTooManyBooksCheckedOut = errors.New("borrower has reached maximum number of checked out books")

func handleBorrowBook(session *gocql.Session, cmd BorrowBookCommand) error {
	// First check if borrower can take out more books
	var checkedOutBooks int
	if err := session.Query(
		`SELECT checked_out_books FROM borrower_book_count WHERE id = ?`,
		cmd.BorrowerID,
	).Scan(&checkedOutBooks); err != nil {
		return err
	}

	if checkedOutBooks >= 2 {
		return ErrTooManyBooksCheckedOut
	}

	// Create batch of updates
	batch := session.NewBatch(gocql.LoggedBatch)

	// Update borrower's checked out book count
	batch.Query(
		`UPDATE borrower_book_count SET checked_out_books = checked_out_books + 1 WHERE id = ?`,
		cmd.BorrowerID,
	)

	// Update book location
	batch.Query(
		`UPDATE book_locations 
		SET current_location_type = 'checked_out', 
		    current_location_id = ? 
		WHERE book_id = ?`,
		cmd.BorrowerID, cmd.BookID,
	)

	// Get borrower info
	var borrowerName, borrowerEmail string
	if err := session.Query(
		`SELECT name, email_address FROM borrower WHERE id = ?`,
		cmd.BorrowerID,
	).Scan(&borrowerName, &borrowerEmail); err != nil {
		return err
	}

	// Get book info
	var bookTitle, authorFirstName, authorSurname string
	if err := session.Query(
		`SELECT title, author_first_name, author_surname FROM book_locations WHERE book_id = ?`,
		cmd.BookID,
	).Scan(&bookTitle, &authorFirstName, &authorSurname); err != nil {
		return err
	}

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

	// Execute all updates atomically
	if err := session.ExecuteBatch(batch); err != nil {
		return err
	}

	return nil
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
}
