import 'package:flutter/material.dart';
import 'package:star_wars_quiz_app/stars.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:star_wars_quiz_app/choices/data_pads_worlds.dart';

import 'dart:math' as math;

class ChoicesGuessesWorlds extends StatefulWidget {
  const ChoicesGuessesWorlds({super.key});

  @override
  State<ChoicesGuessesWorlds> createState() => GuessesPage();
}

class GuessesPage extends State<ChoicesGuessesWorlds> {
  final int _starCount = 300;
  final player = AudioPlayer();

  List<Widget>? _stars;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // We generate our stars in this method so that it builds only once
    // but after the initState method has finished running.
    _stars = _generateStars();
  }

  List<Widget> _generateStars() {
    return List.generate(_starCount, (index) {
      List<double> xy = _getRandomPosition(context);
      return Positioned(top: xy[0], left: xy[1], child: TwinkleLittleStar());
    });
  }

  List<double> _getRandomPosition(BuildContext context) {
    // We get the dimensions of the screen and use them to generate random coordinates
    double x = MediaQuery.of(context).size.height;
    double y = MediaQuery.of(context).size.width;

    double randomX = double.parse(
      (math.Random().nextDouble() * x).toStringAsFixed(3),
    );
    double randomY = double.parse(
      (math.Random().nextDouble() * y).toStringAsFixed(3),
    );

    return [randomX, randomY];
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Opacity(
      opacity: 1,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () async {
              player.play(
                AssetSource('sounds/ui_menuBack.wav'),
              ); // Joue sans await
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Opacity(
              opacity: 1,
              child: Material(
                type: MaterialType.transparency,
                child: Stack(children: _stars!),
              ),
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 211, 240, 233),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromARGB(
                            255,
                            26,
                            26,
                            29,
                          ).withOpacity(0.7),
                        ),
                        child: Text(
                          "CHOOSE YOUR  NUMBER",
                          style: TextStyle(
                            fontFamily: 'CustomF',
                            letterSpacing: 2,
                            fontSize: tablet ? 37.5 : 25.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64FFDA),
                          ),
                        ),
                      ),

                      SizedBox(height: 50.0),

                      // First row of cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DatapadCard(questionCount: 5),
                          const SizedBox(width: 20),
                          DatapadCard(questionCount: 10),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Second row of cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DatapadCard(questionCount: 15),
                          const SizedBox(width: 20),
                          DatapadCard(questionCount: 20),
                        ],
                      ),
                    ],
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
