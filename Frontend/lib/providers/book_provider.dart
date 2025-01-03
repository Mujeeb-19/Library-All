import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String parseBackendError(Map<String, dynamic> jsonData) {
  if (jsonData.containsKey('error')) {
    return jsonData['error'] as String;
  } else if (jsonData.containsKey('message')) {
    return jsonData['message'] as String;
  }
  return 'Unknown error occurred.';
}

class BookProvider extends ChangeNotifier {
  List _books = [];
  List get books => _books;

  List _filteredBooks = [];
  List get filteredBooks => _filteredBooks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? _role;

  String? get token => _token;
  String? get role => _role;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLibrarian => _role == 'librarian';

  set token(String? t) {
    _token = t;
    notifyListeners();
  }

  set role(String? r) {
    _role = r;
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/books'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _books = data;
        _filteredBooks = data;
      } else {
        final data = json.decode(response.body);
        _errorMessage = parseBackendError(data);
      }
    } catch (e) {
      _errorMessage = 'Error fetching books: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterBooks(String query) {
    _errorMessage = null;
    _filteredBooks = _books.where((book) {
      final title = (book['title'] ?? '').toLowerCase();
      final author = (book['author'] ?? '').toLowerCase();
      return title.contains(query.toLowerCase()) ||
          author.contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> deleteBook(String bookId) async {
    _errorMessage = null;
    if (_token == null) {
      _errorMessage = 'No token provided. Cannot delete.';
      notifyListeners();
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/books/$bookId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        _books.removeWhere((b) => b['_id'] == bookId);
        _filteredBooks.removeWhere((b) => b['_id'] == bookId);
      } else {
        final data = json.decode(response.body);
        _errorMessage = parseBackendError(data);
      }
    } catch (e) {
      _errorMessage = 'Error deleting book: $e';
    } finally {
      notifyListeners();
    }
  }
}
