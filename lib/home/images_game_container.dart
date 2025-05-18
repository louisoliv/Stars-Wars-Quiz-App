import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_wars_quiz_app/choices/choices_number_guesses.dart';
import 'package:audioplayers/audioplayers.dart';

class ImagesGameContainer extends StatelessWidget {
  const ImagesGameContainer({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    final bool tablet = isTablet(context);

    return Container(
      color: Colors.transparent, // Ensure no background color
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90.0,
            height: 90.0,
            child: SvgPicture.asset("images/icon_mandalorianSVG.svg"),
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
            onPressed: () async {
              player.play(AssetSource('sounds/ui_planetzoom.wav'));
              Future.delayed(const Duration(milliseconds: 100));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChoicesGuesses(),
                ), // Call the choices window to get the number of guesses
              );
            },
            child: Stack(
              children: [
                Text(
                  "IMAGES",
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
                  "IMAGES",
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
