CREATE TABLE IF NOT EXISTS library.borrower (
    id uuid,
    name text,
    email_address text,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS library.borrower_book_count (
    id uuid,
    checked_out_books counter,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS library.storage_bin (
    terminal_id uuid,
    capacity int,
    current_count int,
    PRIMARY KEY (terminal_id)
);

CREATE TABLE IF NOT EXISTS library.book_locations (
    book_id uuid,
    title text,
    author_surname text,
    author_first_name text,
    assigned_shelf_label text,
    current_location_type text,
    current_location_id text,
    PRIMARY KEY (book_id)
);

-- Indexes for book_locations
CREATE INDEX IF NOT EXISTS book_locations_author_surname_idx
    ON library.book_locations (author_surname)
    USING 'sai';
CREATE INDEX IF NOT EXISTS book_locations_author_first_name_idx
    ON library.book_locations (author_first_name)
    USING 'sai';
CREATE INDEX IF NOT EXISTS book_locations_title_idx
    ON library.book_locations (title)
    USING 'sai';
CREATE INDEX IF NOT EXISTS book_locations_current_location_type_idx
    ON library.book_locations (current_location_type)
    USING 'sai';
CREATE INDEX IF NOT EXISTS book_locations_current_location_id_idx
    ON library.book_locations (current_location_id)
    USING 'sai';

CREATE TABLE IF NOT EXISTS library.pagers (
    id uuid,
    status text,
    PRIMARY KEY (id, status)
);

CREATE TABLE IF NOT EXISTS library.loans (
    borrower_id uuid,
    due_date timestamp,
    book_id uuid,
    borrower_name text,
    borrower_email text,
    book_title text,
    book_author text,
    returned_date timestamp,
    due_soon_notification_sent boolean,
    PRIMARY KEY (borrower_id, due_date, book_id)
);

-- Index for querying loans by due date
CREATE CUSTOM INDEX IF NOT EXISTS loans_by_due_date 
ON library.loans(due_date) 
USING 'StorageAttachedIndex';

-- Index for querying loans by notification status
CREATE CUSTOM INDEX IF NOT EXISTS loans_by_notification_status
ON library.loans(due_soon_notification_sent)
USING 'StorageAttachedIndex';
