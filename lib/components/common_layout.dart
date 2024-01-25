import 'package:flutter/material.dart';
import 'background_builder.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_navigation_bar.dart';

class CommonLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget body;
  final String? imageUrl;
  final bool showSettings;
  final double? rightIconHeight;

  const CommonLayout({
    super.key,
    required this.selectedIndex,
    required this.body,
    this.showSettings = false,
    this.rightIconHeight,
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
                CustomAppBar(
                    showSettings: showSettings,
                    showAccountButton: !showSettings,
                    rightIconHeight: rightIconHeight),
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
