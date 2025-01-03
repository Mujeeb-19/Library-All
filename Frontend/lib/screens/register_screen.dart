import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';
  String _selectedRole = 'patron';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _username,
          'password': _password,
          'role': _selectedRole,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        _goToLogin();
      } else {
        setState(() {
          _errorMessage = parseBackendError(data);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error registering user: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purpleAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_add),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter a username'
                            : null,
                        onChanged: (value) => _username = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_open),
                        ),
                        obscureText: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter a password'
                            : null,
                        onChanged: (value) => _password = value,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.group),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'patron',
                            child: Text('Patron'),
                          ),
                          DropdownMenuItem(
                            value: 'librarian',
                            child: Text('Librarian'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value ?? 'patron';
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  registerUser();
                                }
                              },
                              child: const Text('Register'),
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _goToLogin,
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, duration: 600.ms),
          ),
        ),
      ),
    );
  }
}
