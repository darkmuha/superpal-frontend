import 'package:flutter/material.dart';
import '../components/common_layout.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonLayout(
      selectedIndex: 1,
      body: Center(
        child: Text(
          'Workout Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
