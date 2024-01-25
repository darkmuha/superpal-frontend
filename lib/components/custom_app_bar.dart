import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showAccountButton;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.showAccountButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 45.0, right: 25, left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (showBackButton) {
                  Get.back();
                }
              },
              child: Opacity(
                opacity: showBackButton ? 1.0 : 0.0,
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/arrow_left.svg',
                      color: Colors.white),
                  onPressed: null,
                ),
              ),
            ),
            const Text(
              "SuperPal",
              style: TextStyle(
                fontSize: 31.0,
                color: Colors.white,
                fontFamily: 'PayToneOne',
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (showAccountButton) {
                  Get.toNamed('/account');
                }
              },
              child: Opacity(
                opacity: showAccountButton ? 1.0 : 0.0,
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/account.svg',
                      color: Colors.white),
                  onPressed: null, // onPressed is disabled
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
