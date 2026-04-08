import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

final languageProvider = StateProvider<String>((ref) => 'en');

void main() {
  runApp(const ProviderScope(child: RsvpApp()));
}

class RsvpApp extends StatelessWidget {
  const RsvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding RSVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),

      },
    );
  }
}
