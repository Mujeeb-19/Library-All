import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';
import 'add_book_screen.dart';
import 'book_details_screen.dart';

class BookListScreen extends StatefulWidget {
  final String token;
  final String role;

  const BookListScreen({super.key, required this.token, required this.role});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List books = [];
  List filteredBooks = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  bool get isLibrarian => widget.role == 'librarian';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchBooks());
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/books'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data;
          filteredBooks = data;
        });
      } else {
        // if error..
        final data = json.decode(response.body);
        showErrorSnackbar(data.toString());
      }
    } catch (e) {
      showErrorSnackbar('Error fetching books: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks = books.where((book) {
        final title = (book['title'] ?? '').toLowerCase();
        final author = (book['author'] ?? '').toLowerCase();
        return title.contains(query.toLowerCase()) ||
            author.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> deleteBook(String bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/books/$bookId'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        setState(() {
          books.removeWhere((b) => b['_id'] == bookId);
          filteredBooks.removeWhere((b) => b['_id'] == bookId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to delete. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Available For You!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Your Book Here',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            filterBooks('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: filterBooks,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredBooks.isEmpty
                ? const Center(child: Text('No books available'))
                : ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return Dismissible(
                        key: Key(book['_id'].toString()),
                        // For Librarians only
                        direction: isLibrarian
                            ? DismissDirection.endToStart
                            : DismissDirection.none,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (!isLibrarian) return false;
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                  'Are you sure you want to delete this book?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          return shouldDelete == true;
                        },
                        onDismissed: (direction) {
                          // delete the book
                          if (isLibrarian) {
                            deleteBook(book['_id']);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                backgroundColor: isLibrarian
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                child: Text(
                                  book['title'] != null
                                      ? book['title'][0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                book['title'] ?? 'No title',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Author: ${book['author'] ?? 'No author'}',
                              ),
                              trailing: Text(
                                'Qty: ${book['quantity'] ?? 0}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsScreen(
                                      book: book,
                                      token: widget.token,
                                      role: widget.role,
                                    ),
                                  ),
                                );
                                // refresh
                                if (result == true) {
                                  fetchBooks();
                                }
                              },
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideX(begin: 0.1, duration: 500.ms);
                    },
                  ),
      ),
      floatingActionButton: isLibrarian
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookScreen(token: widget.token),
                  ),
                );
                if (result == true) {
                  fetchBooks();
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
