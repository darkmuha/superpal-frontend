import 'package:flutter/material.dart';
import '../components/common_layout.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonLayout(
      selectedIndex: 4,
      body: Center(
        child: Text(
          'Ranking Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
