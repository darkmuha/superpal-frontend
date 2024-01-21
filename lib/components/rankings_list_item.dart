import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final String number;
  final String name;
  final String age;
  final String rank;
  final String trainingDuration;
  final String gymName;
  final String imageUrl;
  final bool isUser;

  const CustomRow({
    super.key,
    required this.number,
    required this.name,
    required this.age,
    required this.rank,
    required this.trainingDuration,
    required this.gymName,
    required this.imageUrl,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          number,
          style: TextStyle(
            color: isUser ? const Color(0xFFFF4E4E) : Colors.white,
            fontSize: 47,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 15),
        Container(
          width: 310,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(160),
            borderRadius: BorderRadius.circular(41.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          age,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          rank,
                          style: const TextStyle(
                            color: Color(0xFFFF4E4E),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          trainingDuration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    gymName,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
