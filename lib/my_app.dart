import 'package:flutter/material.dart';
import 'package:lista_de_jogos/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Jogos',
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 22, 133, 224)),
      home: const MyHomePage(title: 'Lista de Jogos'),
    );
  }
}
