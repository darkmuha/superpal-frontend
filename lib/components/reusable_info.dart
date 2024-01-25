import 'package:flutter/material.dart';
import '../../../components/common_layout.dart';

class ReusableInfoScreen extends StatelessWidget {
  final String imageUrl;
  final String titleText;
  final String explanationText;
  final String usageText;

  const ReusableInfoScreen({
    super.key,
    required this.imageUrl,
    required this.titleText,
    required this.explanationText,
    required this.usageText,
  });

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/nutrition_background_cropped.png',
      selectedIndex: 3,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'NUTRITION',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
              const SizedBox(height: 34),
              Text(
                titleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 21),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 325 / 128,
                  child: ClipRect(
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'EXPLANATION',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                explanationText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              const Text(
                'USAGE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                usageText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
