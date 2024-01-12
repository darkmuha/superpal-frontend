import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
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
      ),
    );
  }
}
