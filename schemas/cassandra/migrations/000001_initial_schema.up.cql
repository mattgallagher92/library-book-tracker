-- Books table for basic book information
CREATE TABLE IF NOT EXISTS library.books (
    book_id uuid,
    title text,
    author text,
    PRIMARY KEY (book_id)
);

-- Track loans by borrower for quick loan count checks
CREATE TABLE IF NOT EXISTS library.loans_by_borrower (
    borrower_id uuid,
    book_id uuid,
    due_date timestamp,
    returned_date timestamp,
    PRIMARY KEY (borrower_id, book_id)
);

-- TODO: consider merging into books table.
-- Track current location of each book
CREATE TABLE IF NOT EXISTS library.book_locations (
    book_id uuid,
    location_type text,
    location_detail text,
    PRIMARY KEY (book_id)
);

-- Track terminal bin contents and capacity
CREATE TABLE IF NOT EXISTS library.terminal_bins (
    terminal_id uuid,
    current_count int,
    capacity int,
    book_ids set<uuid>,
    PRIMARY KEY (terminal_id)
);
