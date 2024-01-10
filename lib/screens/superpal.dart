import 'package:flutter/material.dart';
import '../components/common_layout.dart';

class SuperPalScreen extends StatelessWidget {
  const SuperPalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonLayout(
      selectedIndex: 2,
      body: Center(
        child: Text(
          'SuperPal Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
