import express from 'express';
import Book from '../models/Book';
import { authMiddleware, librarianOnly } from '../middleware/authMiddleware';

const router = express.Router();

// "C" Only Libratian Can Add Books
router.post('/books', authMiddleware, librarianOnly, async (req, res) => {
    try {
        const { title, author, publicationDate, quantity } = req.body;
        const newBook = new Book({
            title,
            author,
            publicationDate: new Date(publicationDate),
            quantity,
        });

        const savedBook = await newBook.save();
        res.status(201).json(savedBook);
    } catch (error) {
        res.status(500).json({ error: 'Failed to add book' });
    }
});

// "R" List of books
router.get('/books', async (req, res) => {
    try {
        const books = await Book.find();
        res.status(200).json(books);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch books' });
    }
});

// "R" Searching books
router.get('/books/search', async (req, res) => {
    try {
        const { criteria, keyword } = req.query;

        if (!criteria || !keyword) {
            return res.status(400).json({ error: 'Invalid search parameters' });
        }

        const searchQuery: Record<string, any> = {};
        searchQuery[criteria as string] = { $regex: keyword as string, $options: 'i' };

        const books = await Book.find(searchQuery);
        res.status(200).json(books);
    } catch (error) {
        res.status(500).json({ error: 'Failed to search books' });
    }
});

// "R" Book Deatils
router.get('/books/:bookId', async (req, res) => {
    try {
        const { bookId } = req.params;
        const book = await Book.findById(bookId);

        if (!book) {
            return res.status(404).json({ error: 'Book not found' });
        }

        res.status(200).json(book);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch book details' });
    }
});

// "U"  Only Libratian Can Update Book Details
router.put('/books/:bookId', authMiddleware, librarianOnly, async (req, res) => {
    try {
        const { bookId } = req.params;
        const updatedDetails = req.body;

        const updatedBook = await Book.findByIdAndUpdate(bookId, updatedDetails, { new: true });

        if (!updatedBook) {
            return res.status(404).json({ error: 'Book not found' });
        }

        res.status(200).json(updatedBook);
    } catch (error) {
        res.status(500).json({ error: 'Failed to update book details' });
    }
});

// "D"  Only Libratian Can Delete Books
router.delete('/books/:bookId', authMiddleware, librarianOnly, async (req, res) => {
    try {
        const { bookId } = req.params;

        const deletedBook = await Book.findByIdAndDelete(bookId);

        if (!deletedBook) {
            return res.status(404).json({ error: 'Book not found' });
        }

        res.status(200).json({ message: 'Book removed successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Failed to remove book' });
    }
});

export default router;
