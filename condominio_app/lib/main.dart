import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,  //Cambiar
        ),
        useMaterial3: true,
        primaryColor: Colors.blueAccent, //Cambiar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent, // Cambiar
          foregroundColor: Colors.white, // Color del texto del AppBar
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent, // Cambiar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blueAccent,
          elevation: 0
        ),
      ),
      home: const ExpensaScreen()
    );
  }
}


