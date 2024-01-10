import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_navigation_bar.dart';

class CommonLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget body;

  const CommonLayout({
    required this.selectedIndex,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
      ),
    );
  }
}
