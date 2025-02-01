# Application spec

## User types

- Librarian
- Borrower

## Functional requirements

1. Borrowers must be able to check out books using a self-service terminal for a fixed loan duration (one week).
2. Borrowers can only have a limited number of books checked out at a time (two).
3. Borrowers must be able to return books using a self-service terminal (leaving them in its storage bin).
4. All of the library's pagers must receive notifications when a storage bin is 80% or more full, to indicate that the books need removing from the bin and returning to the shelves. (Librarians are expected to pick up a pager when they start their shift.)
5. A librarian must be able to use a self-service terminal to indicate that the books from its storage bin have been emptied onto a numbered trolley.
6. A librarian must be able to use the librarian portal to indicate that the books on a trolley have been returned to their appopriate shelves.
7. A librarian must be able to use the librarian portal to see the current location of books (on a labelled shelf, in the storage bin of a numbered self-service terminal, on a trolley or checked out by a named borrower); it should be possible to filter books to make it quick to find specific ones.
8. A borrower must receive an email notification at a fixed time interval before a book that they have borrowed is due to be returned (two days).

Simplifying assumption: there is no more than one copy of any book in the library.

Prototype requirements: 1, 2, 3, 4.
Additional MVP requirements: 5, 6, 7, 8.

## Application front-ends

- Librarian portal
- Self-service terminal (in library)

## Entities

(Redesign: foreign keys and joins aren't the way to go in Cassandra!)

- Book: author, title
- Borrower: name
- Loan: borrower ID, book ID, start date, duration
- Shelf: label
- Self-service terminal: stored book IDs
- Librarian: name
- Pager
- Notification: type (low bin capacity, return reminder), status (waiting, queued, sent), recipient type (pager, borrower), recipient ID

## Potential extensions

9. A librarian must be able to see the shelf label for a given book ID.
10. A borrower must be able to search for books, but they should only be able to see whether the book is in the library or checked out. There should be no distinction between it being on a shelf or in a storage bin and, if it is checked out, they should not see the name of the borrower who has it.
11. A borrower must receive an email notification when a book that they have registered interest in has been returned to the library.
12. Managers must be able to specify the shift patterns for librarians.
13. Librarians must be able to clock in to and out from their shift.
14. Managers must be notified if not all staff have checked in within a fixed time period of the shift start (15 minutes), to arrange for cover.
15. Support multiple copies of books.

Additional user types: manager.
Additional front-ends: public borrower web portal.
Additional entities: shift spec (e.g. every weekday 8am - 8pm); shift instance (e.g. Thu 28 Nov 8am - 8pm).
