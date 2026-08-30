import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/home/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(const SheikhHusseinApp());
}

class SheikhHusseinApp extends StatelessWidget {
  const SheikhHusseinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sheikh Hussein Border Platform',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        // استخدام اسم الخط المحلي المباشر بدون fallback
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}