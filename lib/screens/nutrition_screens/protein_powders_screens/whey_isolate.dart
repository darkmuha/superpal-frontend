import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class WheyIsolateScreen extends StatelessWidget {
  const WheyIsolateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'WHEY ISOLATE PROTEIN',
      imageUrl: 'assets/images/whey_isolate.jpg',
      explanationText:
          'Whey protein is the fast-digesting part of dairy protein. Different forms of whey protein supplements are available, with two of the most common being whey isolate and whey concentrate.',
      usageText:
          'Whey protein has been shown to be particularly effective at increasing muscle growth when consumed right before, after or during a workout.',
    );
  }
}
