-- Seed borrowers
INSERT INTO library.borrower (id, name, email_address) VALUES (968c0ee3-fe04-4c11-90c2-7689c75056a8, 'John Smith', 'john.smith@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (41f253f2-9648-4d90-a23a-41a87310a2c7, 'Emma Wilson', 'emma.wilson@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (ac159e0f-0e89-4263-b445-2ddce98bc7f3, 'Michael Brown', 'michael.brown@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (f1be7499-30b2-49ea-81f4-a9258f4a03e3, 'Sarah Davis', 'sarah.davis@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (45c170d2-530b-4e00-9824-c41a1986a3e7, 'James Johnson', 'james.johnson@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (506c9d2c-e191-4157-ba0e-add6ed5dbc04, 'Lisa Anderson', 'lisa.anderson@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (ec57e24d-d92c-4713-ba08-6968a200345e, 'David Martinez', 'david.martinez@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (0ba907ed-c527-4c55-9624-59d04653a47c, 'Jennifer Taylor', 'jennifer.taylor@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (08a5a2d0-a062-4e38-b9da-d328e5fc4a12, 'Robert Wilson', 'robert.wilson@example.com');
INSERT INTO library.borrower (id, name, email_address) VALUES (f0fdf952-fe07-456c-9dc2-06ff4d00fb62, 'Patricia Moore', 'patricia.moore@example.com');

-- Seed book locations (grouped by author on shelves)
-- Shelf A1: Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (ebec8d06-1ef9-479c-8e47-a0141477b7c9, 'Foundation', 'Asimov', 'Isaac', 'A1', 'SHELF', 'A1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (48835334-baa5-4681-83f1-7920e40e5996, 'Foundation and Empire', 'Asimov', 'Isaac', 'A1', 'SHELF', 'A1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (80399090-25dc-4f88-b03f-de75b9dd303d, 'Second Foundation', 'Asimov', 'Isaac', 'A1', 'SHELF', 'A1');

-- Shelf A2: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (2a161877-ba45-4ce3-bbeb-1a279116a723, 'Dune', 'Herbert', 'Frank', 'A2', 'SHELF', 'A2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (e3614d84-1cb2-46e4-918f-8c03cf64f130, 'Dune Messiah', 'Herbert', 'Frank', 'A2', 'SHELF', 'A2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (d4390944-6a45-426b-8ee2-929e0b27a476, 'Children of Dune', 'Herbert', 'Frank', 'A2', 'SHELF', 'A2');

-- Shelf B1: Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (4166f95f-9337-4a95-9c94-dc0a01356c83, 'The Fellowship of the Ring', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (f996ea5b-8140-47fe-ad25-dc418e088fa9, 'The Two Towers', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (8c309bd3-c38b-4a5d-b89d-de9a24d18f9d, 'The Return of the King', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (ffa2478b-0029-45c8-ae4e-4142e84227c2, 'The Hobbit', 'Tolkien', 'J.R.R.', 'B1', 'SHELF', 'B1');

-- Shelf B2: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (6542d578-61b5-491d-befd-9a0dcc3edc93, 'A Game of Thrones', 'Martin', 'George R.R.', 'B2', 'SHELF', 'B2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (f3b7083c-7b29-4892-a85b-312f3c76c872, 'A Clash of Kings', 'Martin', 'George R.R.', 'B2', 'SHELF', 'B2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (74d29d76-a810-4781-b863-246b35056649, 'A Storm of Swords', 'Martin', 'George R.R.', 'B2', 'SHELF', 'B2');

-- Shelf C1: Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (f74efde4-a2e8-498e-900b-a3d335a66dee, 'The Murder of Roger Ackroyd', 'Christie', 'Agatha', 'C1', 'SHELF', 'C1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (c9fafea8-6ef6-4673-ba90-32e6645489db, 'Murder on the Orient Express', 'Christie', 'Agatha', 'C1', 'SHELF', 'C1');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (d0444b88-2476-49ad-9203-f3f0c8466d09, 'Death on the Nile', 'Christie', 'Agatha', 'C1', 'SHELF', 'C1');

-- Shelf A3: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (9c2efa9b-44ef-4894-8763-379b0478c677, 'Neuromancer', 'Gibson', 'William', 'A3', 'SHELF', 'A3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (ddda449c-753c-465b-afe5-336fb6150a4e, 'Count Zero', 'Gibson', 'William', 'A3', 'SHELF', 'A3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (023184c6-7190-47c4-8831-6a1ba75efcd7, 'Mona Lisa Overdrive', 'Gibson', 'William', 'A3', 'SHELF', 'A3');

-- Shelf A4: More Science Fiction
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (9069409a-cd15-4f57-8710-4aa51296a0c2, 'The Left Hand of Darkness', 'Le Guin', 'Ursula K.', 'A4', 'SHELF', 'A4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (d2d17aa0-98a6-4fb8-a138-fa77302668ad, 'The Dispossessed', 'Le Guin', 'Ursula K.', 'A4', 'SHELF', 'A4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (8ad9f785-1ca9-4ee7-a5c4-53c1c70f51c1, 'The Word for World is Forest', 'Le Guin', 'Ursula K.', 'A4', 'SHELF', 'A4');

-- Shelf B3: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (8840f27a-197b-47fd-b736-ea9b4dccb0d5, 'The Name of the Wind', 'Rothfuss', 'Patrick', 'B3', 'SHELF', 'B3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (db3cff29-c600-4ee4-8cf1-0d93309a8744, 'The Wise Man''s Fear', 'Rothfuss', 'Patrick', 'B3', 'SHELF', 'B3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (b82f3185-f982-4f31-ad3e-58decbc2fa30, 'The Slow Regard of Silent Things', 'Rothfuss', 'Patrick', 'B3', 'SHELF', 'B3');

-- Shelf B4: More Fantasy
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (9f811091-ac3b-4f97-a86f-bd72f59b2dd4, 'The Way of Kings', 'Sanderson', 'Brandon', 'B4', 'SHELF', 'B4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (0f58e7a5-0ae0-45e8-aa9b-d79bad29c1dd, 'Words of Radiance', 'Sanderson', 'Brandon', 'B4', 'SHELF', 'B4');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (14bfa381-bbaf-44fd-8a34-02d1f7e2a024, 'Oathbringer', 'Sanderson', 'Brandon', 'B4', 'SHELF', 'B4');

-- Shelf C2: More Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (cf79971a-772b-482e-8078-b03e3cb1ede6, 'The Big Sleep', 'Chandler', 'Raymond', 'C2', 'SHELF', 'C2');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (725caea8-beb5-4fcc-aed6-eb530fe876fc, 'The Long Goodbye', 'Chandler', 'Raymond', 'C2', 'SHELF', 'C2');

-- Shelf C3: More Mystery
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (d106a71b-d12b-4b55-be4e-6ddd22f65f03, 'The Girl with the Dragon Tattoo', 'Larsson', 'Stieg', 'C3', 'SHELF', 'C3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (d57f8e39-afd7-4fd0-8aa8-2925a60f590f, 'The Girl Who Played with Fire', 'Larsson', 'Stieg', 'C3', 'SHELF', 'C3');
INSERT INTO library.book_locations (book_id, title, author_surname, author_first_name, assigned_shelf_label, current_location_type, current_location_id)
VALUES (6cc6708b-e6f1-4bf9-b4ee-ee42f1087227, 'The Girl Who Kicked the Hornets'' Nest', 'Larsson', 'Stieg', 'C3', 'SHELF', 'C3');

