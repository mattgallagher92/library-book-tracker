-- Seed borrowers
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'John Smith', 'john.smith@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Emma Wilson', 'emma.wilson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Michael Brown', 'michael.brown@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Sarah Davis', 'sarah.davis@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'James Johnson', 'james.johnson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Lisa Anderson', 'lisa.anderson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'David Martinez', 'david.martinez@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Jennifer Taylor', 'jennifer.taylor@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Robert Wilson', 'robert.wilson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (uuid(), 'Patricia Moore', 'patricia.moore@example.com', 0);

-- Seed book locations (grouped by author on shelves)
-- Shelf A1: Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Foundation', 'Asimov', 'Isaac', 'A1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Foundation and Empire', 'Asimov', 'Isaac', 'A1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Second Foundation', 'Asimov', 'Isaac', 'A1', 'SHELF', uuid());

-- Shelf A2: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Dune', 'Herbert', 'Frank', 'A2', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Dune Messiah', 'Herbert', 'Frank', 'A2', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Children of Dune', 'Herbert', 'Frank', 'A2', 'SHELF', uuid());

-- Shelf B1: Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Fellowship of the Ring', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Two Towers', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Return of the King', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Hobbit', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', uuid());

-- Shelf B2: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'A Game of Thrones', 'Martin', 'George R.R.', 'B2', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'A Clash of Kings', 'Martin', 'George R.R.', 'B2', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'A Storm of Swords', 'Martin', 'George R.R.', 'B2', 'SHELF', uuid());

-- Shelf C1: Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Murder of Roger Ackroyd', 'Christie', 'Agatha', 'C1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Murder on the Orient Express', 'Christie', 'Agatha', 'C1', 'SHELF', uuid());
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Death on the Nile', 'Christie', 'Agatha', 'C1', 'SHELF', uuid());

-- Continue with more books...
