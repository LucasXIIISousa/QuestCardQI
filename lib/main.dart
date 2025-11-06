import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o pacote
import 'controllers/game_controller.dart';
import 'screens/intro_screen.dart';

// 1. main agora é async e usa WidgetsFlutterBinding.ensureInitialized()
void main() async {
  // Garante que os bindings do Flutter estejam prontos antes do async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Carrega o SharedPreferences ANTES de rodar o app
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameController(sharedPreferences: prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuestCardQI',
      theme: ThemeData.dark().copyWith(primaryColor: Colors.deepOrange),
      home: const IntroVideoScreen(),
    );
  }
}
