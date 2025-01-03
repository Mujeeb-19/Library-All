import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';
import 'add_book_screen.dart';
import 'book_details_screen.dart';
import '../providers/book_provider.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  BookListScreenState createState() => BookListScreenState();
}

class BookListScreenState extends State<BookListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().fetchBooks();
    });
  }

  Future<void> logout() async {
    final bookProvider = context.read<BookProvider>();
    bookProvider.token = null;
    bookProvider.role = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final books = bookProvider.filteredBooks;
    final isLoading = bookProvider.isLoading;
    final isLibrarian = bookProvider.isLibrarian;
    final errorMsg = bookProvider.errorMessage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (errorMsg != null && errorMsg.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    });

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
                            bookProvider.filterBooks('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (query) => bookProvider.filterBooks(query),
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
            : books.isEmpty
                ? const Center(child: Text('No books available'))
                : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];

                      return Dismissible(
                        key: Key(book['_id'].toString()),
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
                          if (isLibrarian) {
                            bookProvider.deleteBook(book['_id']);
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsScreen(
                                      book: book,
                                      token: bookProvider.token ?? '',
                                      role: bookProvider.role ?? '',
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  bookProvider.fetchBooks();
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
                    builder: (context) =>
                        AddBookScreen(token: bookProvider.token ?? ''),
                  ),
                );
                if (result == true) {
                  bookProvider.fetchBooks();
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
