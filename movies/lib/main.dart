import 'package:flutter/material.dart';
import 'package:movies/screens/home_page.dart';
import 'package:movies/widgets/film_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
    );
  }
}
