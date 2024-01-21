import 'package:flutter/material.dart';
import 'background_builder.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_navigation_bar.dart';

class CommonLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget body;
  final String? imageUrl;

  const CommonLayout({
    super.key,
    required this.selectedIndex,
    required this.body,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            if (imageUrl != null) BackgroundBuilder(imageUrl: imageUrl!),
            Column(
              children: [
                const CustomAppBar(),
                Expanded(
                  flex: 1,
                  child: body,
                ),
                CustomBottomNavigationBar(
                  selectedIndex: selectedIndex,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
