"use strict";
// // import express, { Request, Response } from 'express';
// import express, { Request, Response, Router } from 'express';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// import Book from '../models/Book';
// const router = express.Router();
// // Add a Book
// router.post('/books', async (req: Request, res: Response) => {
//     try {
//         const { title, author, publicationDate, quantity } = req.body;
//         const newBook = new Book({
//             title,
//             author,
//             publicationDate: new Date(publicationDate),
//             quantity,
//         });
//         const savedBook = await newBook.save();
//         res.status(201).json(savedBook);
//     } catch (error) {
//         res.status(500).json({ error: 'Failed to add book' });
//     }
// });
// // List All Books
// router.get('/books', async (req: Request, res: Response) => {
//     try {
//         const books = await Book.find();
//         res.status(200).json(books);
//     } catch (error) {
//         res.status(500).json({ error: 'Failed to fetch books' });
//     }
// });
// export default router;
const express_1 = __importDefault(require("express"));
const Book_1 = __importDefault(require("../models/Book"));
const router = express_1.default.Router();
// Add a Book
router.post('/books', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { title, author, publicationDate, quantity } = req.body;
        const newBook = new Book_1.default({
            title,
            author,
            publicationDate: new Date(publicationDate),
            quantity,
        });
        const savedBook = yield newBook.save();
        res.status(201).json(savedBook);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to add book' });
    }
}));
// List All Books
router.get('/books', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const books = yield Book_1.default.find();
        res.status(200).json(books);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch books' });
    }
}));
// Search Books
router.get('/books/search', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { criteria, keyword } = req.query;
        if (!criteria || !keyword) {
            return res.status(400).json({ error: 'Invalid search parameters' });
        }
        const searchQuery = {};
        searchQuery[criteria] = { $regex: keyword, $options: 'i' };
        const books = yield Book_1.default.find(searchQuery);
        res.status(200).json(books);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to search books' });
    }
}));
// View Book Details
router.get('/books/:bookId', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { bookId } = req.params;
        const book = yield Book_1.default.findById(bookId);
        if (!book) {
            return res.status(404).json({ error: 'Book not found' });
        }
        res.status(200).json(book);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch book details' });
    }
}));
// Update Book Details
router.put('/books/:bookId', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { bookId } = req.params;
        const updatedDetails = req.body;
        const updatedBook = yield Book_1.default.findByIdAndUpdate(bookId, updatedDetails, { new: true });
        if (!updatedBook) {
            return res.status(404).json({ error: 'Book not found' });
        }
        res.status(200).json(updatedBook);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to update book details' });
    }
}));
// Remove Book
// Remove Book
router.delete('/books/:bookId', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { bookId } = req.params;
        const deletedBook = yield Book_1.default.findByIdAndDelete(bookId);
        if (!deletedBook) {
            return res.status(404).json({ error: 'Book not found' });
        }
        res.status(200).json({ message: 'Book removed successfully' });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to remove book' });
    }
}));
exports.default = router;
