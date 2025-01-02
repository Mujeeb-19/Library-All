// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../utils.dart';

// class BookDetailsScreen extends StatefulWidget {
//   final Map book;
//   final String token;
//   final String role;

//   const BookDetailsScreen({
//     super.key,
//     required this.book,
//     required this.token,
//     required this.role,
//   });

//   @override
//   _BookDetailsScreenState createState() => _BookDetailsScreenState();
// }

// class _BookDetailsScreenState extends State<BookDetailsScreen> {
//   late TextEditingController titleController;
//   late TextEditingController authorController;
//   late TextEditingController publicationDateController;
//   late TextEditingController quantityController;

//   bool get isLibrarian => (widget.role == 'librarian');

//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController(text: widget.book['title']);
//     authorController = TextEditingController(text: widget.book['author']);
//     publicationDateController = TextEditingController(
//         text: _formatDate(widget.book['publicationDate']));
//     quantityController =
//         TextEditingController(text: widget.book['quantity']?.toString() ?? '0');
//   }

//   String _formatDate(String? isoDateString) {
//     if (isoDateString == null) return '';
//     final parts = isoDateString.split('T');
//     return parts.isNotEmpty ? parts[0] : isoDateString;
//   }

//   Future<void> updateBook() async {
//     try {
//       final response = await http.put(
//         Uri.parse('http://localhost:3000/api/books/${widget.book['_id']}'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${widget.token}',
//         },
//         body: json.encode({
//           'title': titleController.text,
//           'author': authorController.text,
//           'publicationDate': publicationDateController.text,
//           'quantity': int.tryParse(quantityController.text) ?? 0,
//         }),
//       );

//       final data = json.decode(response.body);
//       if (response.statusCode == 200) {
//         Navigator.pop(context, true);
//       } else {
//         final errorMsg = parseBackendError(data);
//         _showErrorSnackBar(errorMsg);
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error updating book: $e');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Details'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                   enabled: isLibrarian,
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: authorController,
//                   decoration: const InputDecoration(labelText: 'Author'),
//                   enabled: isLibrarian,
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: publicationDateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Publication Date (YYYY-MM-DD)',
//                   ),
//                   enabled: isLibrarian,
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: quantityController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Quantity'),
//                   enabled: isLibrarian,
//                 ),
//                 const SizedBox(height: 20),
//                 if (isLibrarian)
//                   ElevatedButton(
//                     onPressed: updateBook,
//                     child: const Text('Update Book'),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/screens/book_details_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';

class BookDetailsScreen extends StatefulWidget {
  final Map book;
  final String token;
  final String role;

  const BookDetailsScreen({
    super.key,
    required this.book,
    required this.token,
    required this.role,
  });

  @override
  BookDetailsScreenState createState() => BookDetailsScreenState();
}

class BookDetailsScreenState extends State<BookDetailsScreen> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController publicationDateController;
  late TextEditingController quantityController;

  bool get isLibrarian => widget.role == 'librarian';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book['title']);
    authorController = TextEditingController(text: widget.book['author']);
    publicationDateController = TextEditingController(
        text: _formatDate(widget.book['publicationDate']));
    quantityController =
        TextEditingController(text: widget.book['quantity']?.toString() ?? '0');
  }

  String _formatDate(String? isoDateString) {
    if (isoDateString == null) return '';
    final parts = isoDateString.split('T');
    return parts.isNotEmpty ? parts[0] : isoDateString;
  }

  Future<void> updateBook() async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/books/${widget.book['_id']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'title': titleController.text,
          'author': authorController.text,
          'publicationDate': publicationDateController.text,
          'quantity': int.tryParse(quantityController.text) ?? 0,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        final errorMsg = parseBackendError(data);
        _showErrorSnackBar(errorMsg);
      }
    } catch (e) {
      _showErrorSnackBar('Error updating book: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  enabled: isLibrarian,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                  enabled: isLibrarian,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: publicationDateController,
                  decoration: const InputDecoration(
                    labelText: 'Publication Date (YYYY-MM-DD)',
                  ),
                  enabled: isLibrarian,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  enabled: isLibrarian,
                ),
                const SizedBox(height: 20),
                if (isLibrarian)
                  ElevatedButton(
                    onPressed: updateBook,
                    child: const Text('Update Book'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
