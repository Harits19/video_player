import 'package:flutter/material.dart';
import 'package:my_video_player/screens/home_screen.dart';
import 'package:my_video_player/services/shared_pref_service.dart';

// TODO create history minute has been played

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initAllServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Video Player',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

Future<void> _initAllServices() async {
  await SharedPrefService.initPref();
}
