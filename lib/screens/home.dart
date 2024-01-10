import 'package:flutter/material.dart';
import '../components/common_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonLayout(
      selectedIndex: 0,
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
