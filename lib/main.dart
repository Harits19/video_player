import 'package:flutter/material.dart';
import 'package:video_player/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Video Player',
      home: HomeScreen(),
    );
  }
}
