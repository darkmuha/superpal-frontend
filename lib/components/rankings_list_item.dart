import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final String? number;
  final String name;
  final String age;
  final String rank;
  final String trainingDuration;
  final String gymName;
  final String? workoutDay;
  final String? workoutTime;
  final String imageUrl;
  final bool isUser;
  final double detailsWidth;
  final double imageSize;
  final double spacebetweenDetailsAndGym;

  const CustomRow({
    Key? key,
    this.number,
    required this.name,
    required this.age,
    required this.rank,
    required this.trainingDuration,
    required this.gymName,
    this.workoutDay,
    this.workoutTime,
    required this.imageUrl,
    this.isUser = false,
    this.detailsWidth = 310,
    this.imageSize = 44,
    this.spacebetweenDetailsAndGym = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (number != null) ...[
          Text(
            number!,
            style: TextStyle(
              color: isUser ? const Color(0xFFFF4E4E) : Colors.white,
              fontSize: 47,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 15),
        ],
        Container(
          width: detailsWidth,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(160),
            borderRadius:
                BorderRadius.circular(41.0 + (workoutDay != null ? 2 : 0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: detailsWidth - imageSize - 50,
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
                  SizedBox(height: spacebetweenDetailsAndGym),
                  Text(
                    gymName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  if (workoutDay != null && workoutTime != null) ...[
                    const SizedBox(width: 58),
                    Text(
                      '$workoutDay: $workoutTime',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
