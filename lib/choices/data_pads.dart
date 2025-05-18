import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:star_wars_quiz_app/quizzes/quiz_images.dart'; // Assuming this includes `isTablet()` and `Quiz`

class DatapadCard extends StatefulWidget {
  final int questionCount;

  const DatapadCard({Key? key, required this.questionCount}) : super(key: key);

  @override
  State<DatapadCard> createState() => _DatapadCardState();
}

class _DatapadCardState extends State<DatapadCard> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Card(
      elevation: 5,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 96, 96, 96),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF121212).withOpacity(0.8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            _player.play(AssetSource('sounds/ui_menuMove.wav'));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (BuildContext context) =>
                        Quiz(guesses: widget.questionCount),
              ),
            );
          },
          child: SizedBox(
            width: tablet ? 225 : 150.0,
            height: tablet ? 330 : 220.0,
            child: Column(
              children: [
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.0),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            ' DATAPAD',
                            style: TextStyle(
                              fontFamily: 'CustomF',
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: tablet ? 18 : 12,
                            ),
                          ),
                          Text(
                            "Empire's property",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: tablet ? 15 : 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset("images/logo_empire.png"),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Center(
                    child: Text(
                      "${widget.questionCount}",
                      style: TextStyle(
                        letterSpacing: 4,
                        fontSize: tablet ? 96 : 64,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CustomF',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "QUESTIONS",
                      style: TextStyle(
                        fontFamily: 'CustomF',
                        letterSpacing: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: tablet ? 18 : 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
