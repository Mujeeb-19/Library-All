import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';

class AddBookScreen extends StatefulWidget {
  final String token;

  const AddBookScreen({super.key, required this.token});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String publicationDate = '';
  int quantity = 0;

  Future<void> addBook() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/books'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'title': title,
          'author': author,
          'publicationDate': publicationDate,
          'quantity': quantity,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        final errorMsg = parseBackendError(data);
        _showErrorSnackBar(errorMsg);
      }
    } catch (e) {
      _showErrorSnackBar('Error adding book: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (value) => title = value,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Enter a title'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Author'),
                    onChanged: (value) => author = value,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Enter an author'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Publication Date (YYYY-MM-DD)'),
                    onChanged: (value) => publicationDate = value,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Enter a date'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => quantity = int.tryParse(value) ?? 0,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        addBook();
                      }
                    },
                    child: const Text('Add Book'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
