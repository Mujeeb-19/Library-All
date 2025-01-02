// import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';

// void main() {
//   runApp(const LibraryManagementApp());
// }

// class LibraryManagementApp extends StatelessWidget {
//   const LibraryManagementApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Library Management',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.grey[100],
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(double.infinity, 48),
//             textStyle: const TextStyle(fontSize: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const LibraryManagementApp());
}

class LibraryManagementApp extends StatelessWidget {
  const LibraryManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Library Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
