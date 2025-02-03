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
		`SELECT checked_out_books FROM borrower WHERE id = ?`,
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
		`UPDATE borrower SET checked_out_books = checked_out_books + 1 WHERE id = ?`,
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

	// Create loan record
	dueDate := time.Now().AddDate(0, 0, 7) // 1 week loan duration
	batch.Query(
		`INSERT INTO loans (
			borrower_id, due_date, book_id, 
			borrower_name, borrower_email, 
			book_title, book_author
		) 
		SELECT ?, ?, ?,
		       b.name, b.email_address,
		       bl.title, CONCAT(bl.author_first_name, ' ', bl.author_surname)
		FROM borrower b, book_locations bl
		WHERE b.id = ? AND bl.book_id = ?`,
		cmd.BorrowerID, dueDate, cmd.BookID,
		cmd.BorrowerID, cmd.BookID,
	)

	// Execute all updates atomically
	if err := session.ExecuteBatch(batch); err != nil {
		return err
	}

	return nil
}

func main() {
	// TODO: Initialize Cassandra session and handle requests
	log.Println("Loans service starting...")
}

