import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.transparent,
      elevation: 0.0, // Remove shadow
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 45.0, right: 35, left: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/arrow_left.svg', color: Colors.white),
              onPressed: () {
                  // Use Navigator.pop to navigate back
                Get.back();
              },
            ),
            const Text(
              "SuperPal",
              style: TextStyle(
                  fontSize: 31.0,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: SvgPicture.asset('assets/icons/account.svg', color: Colors.white),
              onPressed: () {
                Get.toNamed('/account');
              },
            ),
          ],
        ),
      ),
    );
  }
}
