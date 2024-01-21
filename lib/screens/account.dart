import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return const Column(
      children: [
        CustomAppBar(),
        Expanded(
          child: Center(
            child: Text(
              'Account Screen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
