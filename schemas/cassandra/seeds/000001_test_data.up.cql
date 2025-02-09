-- Seed borrowers
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (968c0ee3-fe04-4c11-90c2-7689c75056a8, 'John Smith', 'john.smith@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (41f253f2-9648-4d90-a23a-41a87310a2c7, 'Emma Wilson', 'emma.wilson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (ac159e0f-0e89-4263-b445-2ddce98bc7f3, 'Michael Brown', 'michael.brown@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (f1be7499-30b2-49ea-81f4-a9258f4a03e3, 'Sarah Davis', 'sarah.davis@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (45c170d2-530b-4e00-9824-c41a1986a3e7, 'James Johnson', 'james.johnson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (506c9d2c-e191-4157-ba0e-add6ed5dbc04, 'Lisa Anderson', 'lisa.anderson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (ec57e24d-d92c-4713-ba08-6968a200345e, 'David Martinez', 'david.martinez@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (0ba907ed-c527-4c55-9624-59d04653a47c, 'Jennifer Taylor', 'jennifer.taylor@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (08a5a2d0-a062-4e38-b9da-d328e5fc4a12, 'Robert Wilson', 'robert.wilson@example.com', 0);
INSERT INTO library.borrower (id, name, email_address, checked_out_books) VALUES (f0fdf952-fe07-456c-9dc2-06ff4d00fb62, 'Patricia Moore', 'patricia.moore@example.com', 0);

-- Seed book locations (grouped by author on shelves)
-- Shelf A1: Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Foundation', 'Asimov', 'Isaac', 'A1', 'SHELF', 'A1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Foundation and Empire', 'Asimov', 'Isaac', 'A1', 'SHELF', 'A1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Second Foundation', 'Asimov', 'Isaac', 'A1', 'SHELF', 'A1');

-- Shelf A2: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Dune', 'Herbert', 'Frank', 'A2', 'SHELF', 'A2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Dune Messiah', 'Herbert', 'Frank', 'A2', 'SHELF', 'A2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Children of Dune', 'Herbert', 'Frank', 'A2', 'SHELF', 'A2');

-- Shelf B1: Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Fellowship of the Ring', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Two Towers', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Return of the King', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Hobbit', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');

-- Shelf B2: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'A Game of Thrones', 'Martin', 'George R.R.', 'B2', 'SHELF', 'B2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'A Clash of Kings', 'Martin', 'George R.R.', 'B2', 'SHELF', 'B2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'A Storm of Swords', 'Martin', 'George R.R.', 'B2', 'SHELF', 'B2');

-- Shelf C1: Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Murder of Roger Ackroyd', 'Christie', 'Agatha', 'C1', 'SHELF', 'C1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Murder on the Orient Express', 'Christie', 'Agatha', 'C1', 'SHELF', 'C1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Death on the Nile', 'Christie', 'Agatha', 'C1', 'SHELF', 'C1');

-- Shelf A3: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Neuromancer', 'Gibson', 'William', 'A3', 'SHELF', 'A3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Count Zero', 'Gibson', 'William', 'A3', 'SHELF', 'A3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Mona Lisa Overdrive', 'Gibson', 'William', 'A3', 'SHELF', 'A3');

-- Shelf A4: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Left Hand of Darkness', 'Le Guin', 'Ursula K.', 'A4', 'SHELF', 'A4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Dispossessed', 'Le Guin', 'Ursula K.', 'A4', 'SHELF', 'A4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Word for World is Forest', 'Le Guin', 'Ursula K.', 'A4', 'SHELF', 'A4');

-- Shelf B3: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Name of the Wind', 'Rothfuss', 'Patrick', 'B3', 'SHELF', 'B3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Wise Man''s Fear', 'Rothfuss', 'Patrick', 'B3', 'SHELF', 'B3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Slow Regard of Silent Things', 'Rothfuss', 'Patrick', 'B3', 'SHELF', 'B3');

-- Shelf B4: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Way of Kings', 'Sanderson', 'Brandon', 'B4', 'SHELF', 'B4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Words of Radiance', 'Sanderson', 'Brandon', 'B4', 'SHELF', 'B4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Oathbringer', 'Sanderson', 'Brandon', 'B4', 'SHELF', 'B4');

-- Shelf C2: More Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Big Sleep', 'Chandler', 'Raymond', 'C2', 'SHELF', 'C2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'Farewell, My Lovely', 'Chandler', 'Raymond', 'C2', 'SHELF', 'C2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Long Goodbye', 'Chandler', 'Raymond', 'C2', 'SHELF', 'C2');

-- Shelf C3: More Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Girl with the Dragon Tattoo', 'Larsson', 'Stieg', 'C3', 'SHELF', 'C3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Girl Who Played with Fire', 'Larsson', 'Stieg', 'C3', 'SHELF', 'C3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id) 
VALUES (uuid(), 'The Girl Who Kicked the Hornets'' Nest', 'Larsson', 'Stieg', 'C3', 'SHELF', 'C3');
