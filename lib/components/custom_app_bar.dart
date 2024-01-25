import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../helpers/api_requests.dart';
import '../helpers/api_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showAccountButton;
  final bool showSettings;
  final double? rightIconHeight;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.showAccountButton = true,
    this.showSettings = false,
    this.rightIconHeight = 41,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(87.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;

  @override
  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
  }

  void _showSettingsOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: 305,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF707070).withOpacity(0.6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/edit_profile');
                      print('i tapped that');
                    },
                    child: Container(
                      width: 200,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.5),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'EDIT PROFILE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  GestureDetector(
                    onTap: () async {
                      print('sup');
                      final refreshToken =
                          await storage.read(key: 'refresh') ?? '';
                      if (refreshToken != '') {
                        await apiRequests.postLogOut(refreshToken);
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.5),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'LOG OUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: widget.preferredSize.height,
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
                if (widget.showBackButton) {
                  Get.back();
                }
              },
              child: Opacity(
                opacity: widget.showBackButton ? 1.0 : 0.0,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow_left.svg',
                    color: Colors.white,
                  ),
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
                if (widget.showSettings) {
                  _showSettingsOverlay(context);
                } else if (widget.showAccountButton) {
                  Get.toNamed('/account');
                }
              },
              child: Opacity(
                opacity:
                    widget.showSettings || widget.showAccountButton ? 1.0 : 0.0,
                child: SizedBox(
                  height: widget.rightIconHeight,
                  child: SvgPicture.asset(
                    widget.showSettings
                        ? 'assets/icons/gear.svg'
                        : 'assets/icons/account.svg',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
