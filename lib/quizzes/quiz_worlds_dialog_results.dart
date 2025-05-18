import 'package:flutter/material.dart';
import 'package:star_wars_quiz_app/main.dart';

Future<void> dialogResuslts(
  BuildContext context,
  int goodResponse,
  int guesses,
  int badResponse,
) {
  return showDialog<void>(
    context: context,
    builder:
        (_) => AlertDialog(
          insetPadding: EdgeInsets.all(10.0),
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: const BorderSide(
              color: Color.fromARGB(255, 96, 96, 96),
              width: 3,
            ),
          ),
          title: Center(
            child: Text(
              "quiz terminé !",
              style: TextStyle(
                fontFamily: 'CustomStarJedi',
                fontSize: 22,
                color: Colors.blue[100],
              ),
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bonnes réponses: $goodResponse",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'CustomStarJedi',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Mauvaises réponses: $badResponse",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'CustomStarJedi',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => MyApp()),
                );
              },
              child: Text(
                "Go home",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'CustomStarJedi',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
  );
}
