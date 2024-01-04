import 'package:flutter/material.dart';
import 'package:superpal/components/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
          'Home Screen',
          style: TextStyle(color: Colors.red)
      ),
    );
  }
}