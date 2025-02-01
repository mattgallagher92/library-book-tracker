# Database schema

## Queries

These queries are required to support the main functional requirements:

1. Number of books a specific borrower already has checked out: given borrower ID, return number of currently borrowed books
2. Storage bin book count and capacity: given terminal ID, get number of books in the bin and maximum number of books a bin can store.
3. Books in a storage bin: given terminal ID, get titles and IDs of books.
4. Active pagers: the pagers in the library that are currently switched on.
5. Books on a trolley: given trolley number, get titles and IDs of books.
6. Assigned shelf for a book: given book ID get label of shelf where it should be stored.
7. Book locations: see locations of all books; location is one of shelf label, trolley number, terminal ID, borrower details (ID and name); book details include ID, title and author. Order by author surname then book title. Filter by author surname or book title or both.
8. Books which are due soon: given a due date, return all loans which are due on that date. Returned information should include borrower ID, borrower name, borrower email address, book title and book author.
9. Borrower details: given borrower ID, return borrower name and borrower email address.

## Tables

Borrower: ID, name, email address, number of checked out books. Query by ID. Partion key: ID.
Storage bin: terminal ID, capacity, current number of stored books. Query by terminal ID. Partion key: terminal ID.
Book locations: book ID, title, author surname, author first name, assigned shelf label, current location type, current location ID. Sort and filter by title and author surname. Partition key: book ID; clustering columns: author surname, author first name, book title. Index on book title. Index on current location type, current location ID pair.
Pagers: ID, status (on/off). Partition key: ID; clustering columns: status.
Loans: borrower ID, borrower name, borrower email address, book ID, book title, book author, due date, returned date. Query by due date. Partition key: borrower ID; clustering columns: due date, book ID.

### Notes

For the loans table, using due date as the partition key would cause hot spots, as only one partition would be written to and one queried each day. Need book ID in the primary key because primary keys are unique.

Clustering the book locations table on author surname then title makes sense for the default order to show book locations in. An index is required to allow filtering by book title (Cassandra only allows selecting a contiguous set of rows if there are no indexes). Book ID then makes sense as the partition key. I considered having multiple book location tables, one clustered first by title and another clustered first by author surname, but chose an index to simplify the data model.
