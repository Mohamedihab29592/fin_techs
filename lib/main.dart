import 'package:fin_techs/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkMode = true; // Default to dark mode

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode; // Toggle theme mode
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the themes
    final ThemeData darkTheme = ThemeData.dark();
    final ThemeData lightTheme = ThemeData.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fin Techs',
      theme: isDarkMode ? darkTheme : lightTheme, // Toggle between themes
      home: MainScreen(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
