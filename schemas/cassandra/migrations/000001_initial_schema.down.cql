DROP INDEX IF EXISTS library.loans_by_due_date;
DROP INDEX IF EXISTS library.book_locations_current_location_id_idx;
DROP INDEX IF EXISTS library.book_locations_current_location_type_idx;
DROP INDEX IF EXISTS library.book_locations_title_idx;
DROP INDEX IF EXISTS library.book_locations_author_first_name_idx;
DROP INDEX IF EXISTS library.book_locations_author_surname_idx;
DROP TABLE IF EXISTS library.loans;
DROP TABLE IF EXISTS library.pagers;
DROP TABLE IF EXISTS library.book_locations;
DROP TABLE IF EXISTS library.storage_bin;
DROP TABLE IF EXISTS library.borrower_book_count;
DROP TABLE IF EXISTS library.borrower;
