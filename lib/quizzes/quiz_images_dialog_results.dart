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
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.cyanAccent, width: 2),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QUIZ COMPLETED',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CustomF',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Bonne(s) réponse(s) : $goodResponse.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'CustomStarJedi',
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Mauvaise(s) réponse(s) : $badResponse.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'CustomStarJedi',
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  ); // Allow to go back to the home page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomF',
                    letterSpacing: 1,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
