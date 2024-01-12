import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../components/custom_app_bar.dart';
import '../components/background_builder.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../helpers/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> loginUser(BuildContext context) async {
    const String apiUrl = '${AppConstants.apiUrl}/authentication/login/';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var myToken = jsonResponse['tokens'];

        await storage.write(key: 'access', value: myToken['access']);
        await storage.write(key: 'refresh', value: myToken['refresh']);

        print('Login successful');
        Get.offAllNamed('/home');
      } else {
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundBuilder(
              imageUrl: "assets/images/background_guy_rope_cropped.png",
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                showAccountButton: false,
              ),
            ),
            Center(
              child: SizedBox(
                width: 0.9 * MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 220),
                    CustomTextField(
                      controller: emailController,
                      hintText: "EMAIL",
                    ),
                    const SizedBox(height: 48.5),
                    CustomTextField(
                        controller: passwordController,
                        hintText: "PASSWORD",
                        obscureText: true),
                    const SizedBox(height: 27.5),
                    CustomButton(
                        buttonText: 'LOG IN', onTap: () => loginUser(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
