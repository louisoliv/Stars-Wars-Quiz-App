import 'package:flutter/material.dart';
import 'package:star_wars_quiz_app/choices/choices_number_guesses_worlds.dart';
import 'package:audioplayers/audioplayers.dart';

class WorldsGameContainer extends StatelessWidget {
  const WorldsGameContainer({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    final bool tablet = isTablet(context);

    return Container(
      color: Colors.transparent, // Ensure no background color
      child: Row(
        mainAxisSize: MainAxisSize.min, // Avoid unnecessary space
        children: [
          SizedBox(
            width: 90.0,
            height: 90.0,
            child: Image.asset("images/world.png", width: 90.0, height: 90.0),
          ),

          const SizedBox(width: 30.0),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 10.0,
              side: BorderSide(width: 3.0, color: Colors.yellow),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () {
              player.play(
                AssetSource('sounds/ui_planetzoom.wav'),
              ); // Joue sans await
              Future.delayed(const Duration(milliseconds: 100));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChoicesGuessesWorlds(),
                ), // Call the choices window to get the number of guesses
              );
            },
            child: Stack(
              children: [
                Text(
                  "WORLDS",
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: tablet ? 40.0 : 20.0,
                    foreground:
                        Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.yellow[600]!,
                  ),
                ),
                Text(
                  "WORLDS",
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: tablet ? 40.0 : 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
