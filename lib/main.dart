import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_wars_quiz_app/stars.dart';
import 'dart:math' as math;
import 'package:star_wars_quiz_app/home/images_game_container.dart';
import 'package:star_wars_quiz_app/home/worlds_game_container.dart';
import 'package:star_wars_quiz_app/starwars_logo.dart';
import 'package:star_wars_quiz_app/settings.dart';
import 'package:star_wars_quiz_app/audio_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _starCount = 300;

  List<Widget>? _stars;

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

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

  @override
  void initState() {
    super.initState();
    // _playThemeMusic();
    AudioController().play();
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Opacity(
      opacity: 1,
      child: Scaffold(
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

            Column(
              children: [
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(top: 150.0),
                    child: const StarWarsLogo(),
                  ),
                ),
                const SizedBox(height: 70.0),
                /////////////////////////////////////////////////////////////////////////////////////// FIRST OPTION TO PLAY WITH IMAGES
                ImagesGameContainer(),
                /////////////////////////////////////////////////////////////////////////////////////// THIRD OPTION TO PLAY WITH WORLDS
                WorldsGameContainer(),
                const SizedBox(height: 14.0),
              ],
            ),

            Align(
              // Using this allow me to place my settings image to the bottom left corner
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SettingsWidget();
                      },
                    );
                  },

                  borderRadius: BorderRadius.circular(
                    // Add effect after the tap
                    10,
                  ),
                  child: SizedBox(
                    width: tablet ? 100 : 55.0,
                    height: tablet ? 100 : 55.0,
                    child: SvgPicture.asset(
                      "images/settingsSVG.svg",
                      width: tablet ? 100 : 55.0,
                      height: tablet ? 100 : 55.0,
                    ),
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
