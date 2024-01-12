import 'package:flutter/material.dart';
import '../components/custom_logo_button.dart';
import '../components/background_builder.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundBuilder(
              imageUrl: "assets/images/background_guy_rope_cropped.png",
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 220),

                  // Title
                  const Text(
                    'SuperPal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontFamily: 'PayToneOne',
                    ),
                  ),

                  const SizedBox(height: 210),

                  // Apple Login
                  CustomLogoButton(
                      width: (screenWidth * 0.9),
                      iconPath: "assets/icons/apple_logo.svg",
                      buttonText: 'Sign in With Apple',
                      buttonColor: Colors.white,
                      textColor: Colors.black,
                      iconWidth: 32,
                      iconHeight: 32),

                  const SizedBox(height: 7),

                  // Facebook Login
                  CustomLogoButton(
                    width: screenWidth * 0.9,
                    iconPath: "assets/icons/facebook_logo.svg",
                    buttonText: 'Continue',
                    buttonColor: const Color(0xFF356FE5),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),

                  const SizedBox(height: 7),

                  // Google Sign-In & Register
                  SizedBox(
                      width: screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Google Sign-In
                          CustomLogoButton(
                            width: screenWidth * 0.44,
                            iconPath: "assets/icons/google_icon_logo.svg",
                            buttonText: 'Continue',
                            buttonColor: Colors.white,
                            textColor: const Color(0xFF707070),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),

                          const SizedBox(height: 7),

                          // Register
                          CustomLogoButton(
                            width: screenWidth * 0.44,
                            icon: const Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 24,
                            ),
                            buttonText: 'REGISTER',
                            buttonColor: Colors.transparent,
                            textColor: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            borderColor: Colors.white,
                            borderWidth: 2,
                          ),
                        ],
                      )),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/login');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        SizedBox(width: 32),
                        Text('LOG IN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
