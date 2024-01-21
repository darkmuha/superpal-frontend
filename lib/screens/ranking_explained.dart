import 'package:flutter/material.dart';
import '../components/common_layout.dart';

class RankingExplainedScreen extends StatelessWidget {
  const RankingExplainedScreen({super.key});

  Widget _columnCreator(
      List<String> items,
      Color titleColor,
      Color textColor,
      double titleFontSize,
      double textFontSize,
      FontWeight titleFontWeight,
      FontWeight textFontWeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          items[0],
          style: TextStyle(
            color: titleColor,
            fontWeight: titleFontWeight,
            fontSize: titleFontSize,
          ),
        ),
        ...items.sublist(1).map((item) => Text(
              item,
              style: TextStyle(
                color: textColor,
                fontWeight: textFontWeight,
                fontSize: textFontSize,
              ),
            )),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 54),
          const Text(
            'HEROES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 29),
          const Padding(
            padding: EdgeInsets.only(left: 62, right: 62),
            child: Text(
              'WHAT MAKES ME A HERO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 13),
          const Padding(
            padding: EdgeInsets.only(left: 23, right: 23),
            child: Text(
              'Hero Table works on a system that counts the time you spend on this app. It basically recognizes how much time you are working out and scrolling around to get information on the nutrition tips section, also interactions with your SuperPals.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 41),
          const Text(
            'RATING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _columnCreator(
                [
                  'Rank',
                  '1- Champion',
                  '2- rescuer',
                  '3- exemplar',
                  '4- Model',
                  '5- paladın',
                  '6- defender',
                  '7- guardıan',
                  '8- Warrıor'
                ],
                const Color(0xFFFF4E4E),
                Colors.white,
                16,
                14,
                FontWeight.w900,
                FontWeight.w500,
              ),
              const SizedBox(width: 46),
              _columnCreator(
                [
                  'Workout Streak',
                  '121',
                  '36-39',
                  '30-33',
                  '24-27',
                  '18-21',
                  '12-15',
                  '6-9',
                  '0-3'
                ],
                const Color(0xFFFF4E4E),
                Colors.white,
                16,
                14,
                FontWeight.w900,
                FontWeight.w400,
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/rankings_background_cropped.png',
      selectedIndex: 4,
      body: buildBody(context),
    );
  }
}
