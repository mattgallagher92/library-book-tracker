-- Borrower table
CREATE TABLE IF NOT EXISTS library.borrower (
    id uuid,
    name text,
    email_address text,
    checked_out_books int,
    PRIMARY KEY (id)
);

-- Storage bin table
CREATE TABLE IF NOT EXISTS library.storage_bin (
    terminal_id uuid,
    capacity int,
    current_count int,
    PRIMARY KEY (terminal_id)
);

-- Book locations table
CREATE TABLE IF NOT EXISTS library.book_locations (
    book_id uuid,
    title text,
    author_surname text,
    author_first_name text,
    assigned_shelf_label text,
    current_location_type text,
    current_location_id text,
    PRIMARY KEY (book_id, author_surname, author_first_name, title)
);

-- Create indexes for book_locations
CREATE INDEX IF NOT EXISTS book_locations_title_idx
    ON library.book_locations (title)
    USING 'sai';
CREATE INDEX IF NOT EXISTS book_locations_current_location_type_idx
    ON library.book_locations (current_location_type)
    USING 'sai';
CREATE INDEX IF NOT EXISTS book_locations_current_location_id_idx
    ON library.book_locations (current_location_id)
    USING 'sai';

-- Pagers table
CREATE TABLE IF NOT EXISTS library.pagers (
    id uuid,
    status text,
    PRIMARY KEY (id, status)
);

-- Loans table
CREATE TABLE IF NOT EXISTS library.loans (
    borrower_id uuid,
    due_date timestamp,
    book_id uuid,
    borrower_name text,
    borrower_email text,
    book_title text,
    book_author text,
    returned_date timestamp,
    PRIMARY KEY (borrower_id, due_date, book_id)
);
