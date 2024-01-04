import 'package:flutter/material.dart';
import 'components/bottom_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        body: const Center(
          child: Text('Your content goes here'),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}