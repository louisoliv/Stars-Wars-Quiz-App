import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:star_wars_quiz_app/quizzes/quiz_worlds_dialog_results.dart';

class QuizWorlds extends StatefulWidget {
  final int guesses;

  const QuizWorlds({Key? key, required this.guesses}) : super(key: key);

  @override
  State<QuizWorlds> createState() => QuizWindow();
}

class World {
  int id;
  String image;
  String clue;
  String answer;

  World(this.id, this.image, this.clue, this.answer);
}

List<World> worlds = [
  World(
    1,
    "images_planets/naboo.jpg",
    "Padme's homeworld and we see it in Star Wars 1 The Phantom Menace",
    "Naboo",
  ),
  World(
    2,
    "images_planets/tatooine.jpg",
    "The desert world where it all began. 🌵☀️",
    "Tatooine",
  ),
  World(
    3,
    "images_planets/coruscant.jpeg",
    "A city-wide planet, home to the Galactic Senate. 🏙️🏛️",
    "Coruscant",
  ),
  World(
    4,
    "images_planets/dagobah.jpg",
    "A swampy, foggy planet where a wise Jedi master lived in exile. 🐸🌫️",
    "Dagobah",
  ),
  World(
    5,
    "images_planets/endor.jpeg",
    "A lush jungle moon that hosted the Ewoks. 🌳🐻",
    "Endor",
  ),
  World(
    6,
    "images_planets/kamino.jpg",
    "An ocean-covered world home to the clone army. 🌊⛈️",
    "Kamino",
  ),
  World(
    7,
    "images_planets/hoth.jpg",
    "A snowy battlefield where the Rebels fought off AT-ATs. ❄️⚔️",
    "Hoth",
  ),
  World(
    8,
    "images_planets/mustafar.jpeg",
    "A volcanic planet, the site of an iconic duel. 🌋🔥",
    "Mustafar",
  ),
  World(
    9,
    "images_planets/bespin.jpg",
    "A mining colony in the clouds, ruled by a smooth-talking administrator. ☁️⛏️",
    "Bespin",
  ),
  World(
    10,
    "images_planets/korriban.jpeg",
    "The birthplace of the Sith, filled with ancient dark side secrets. 🏜️🖤",
    "Korriban",
  ),
  World(
    11,
    "images_planets/ach-to.jpg",
    "A remote planet where Jedi Luke Skywalker went into hiding. 🏝️⛰️",
    "Ahch-To",
  ),

  World(
    12,
    "images_planets/alderaan.jpeg",
    "A capital planet destroyed by the first Death Star. 🏠💥",
    "Alderaan",
  ),

  World(
    13,
    "images_planets/kashyyk.jpg",
    "A world of towering trees, inhabited by fierce warriors. 🌲⚔️",
    "Kashyyyk",
  ),

  World(
    14,
    "images_planets/jakku.jpeg",
    "A junkyard planet where a certain scavenger grew up. ♻️🚀",
    "Jakku",
  ),

  World(
    15,
    "images_planets/crait.jpg",
    "A cold planet with red soil beneath its salty surface. ❄️🔴",
    "Crait",
  ),

  World(
    16,
    "images_planets/corellia.jpg",
    "A planet ruled by crime syndicates, where Han Solo ran into trouble. 🎲🔫",
    "Corellia",
  ),

  World(
    17,
    "images_planets/scarif.jpeg",
    "A war-torn world where Jyn Erso and the Rebels stole the Death Star plans. 🌴🏴‍☠️",
    "Scarif",
  ),

  World(
    18,
    "images_planets/yavin.jpg",
    "A forested planet where the Jedi Temple was burned down by the Sith. 🌳🔥",
    "Yavin 4",
  ),

  World(
    19,
    "images_planets/ilum.jpg",
    "A frozen wasteland where Starkiller Base was built. ❄️🌑",
    "Ilum",
  ),

  World(
    20,
    "images_planets/jedha.jpeg",
    "A remote world where Jedi trained in the High Republic era. 📜🌟",
    "Jedha",
  ),

  World(
    21,
    "images_planets/felucia.jpeg",
    "A planet full of jungles and swamps where the Clone Wars raged. 🌿💥",
    "Felucia",
  ),

  World(
    22,
    "images_planets/exegol.jpg",
    "A Sith homeworld with a fleet hidden beneath the ice. ❄️🚀",
    "Exegol",
  ),

  World(
    23,
    "images_planets/death-star.jpeg",
    "A planet-sized weapon that could destroy entire star systems. 🛠️💀",
    "The Death Star",
  ),

  World(
    24,
    "images_planets/starkiller-base.jpeg",
    "A planet-sized weapon that could destroy entire star systems. 🛠️💀",
    "Starkiller",
  ),
];

class QuizWindow extends State<QuizWorlds> with SingleTickerProviderStateMixin {
  final player = AudioPlayer();

  List<World> availableWorlds = List.from(worlds);
  World? randomWorld;
  final _random = Random();
  List<int> arrayIndUsed = [];
  List<String?> arrayNameUsed = [];
  List<dynamic>? starWarsCharacters;
  Map<String, dynamic>? randomCharacter;
  List<dynamic> uniqueCharacters = [];
  Set<String> usedImages = {};

  final answerText = TextEditingController();
  String text = "";
  bool answered = false;
  bool isButtonEnabled = false;
  int counter = 0;
  int goodResponse = 0;
  int badResponse = 0;
  int guesses = 10;
  String timerResponseString = "";
  int timerResponseInt = 0;
  int imageWidth = 0;
  int imageHeight = 0;
  String feedbackMessage = ""; // Will be used to give the answer after the try

  bool animateCorrect = false;
  late AnimationController _borderAnimationController;
  late Animation<Color?> _borderColorAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.pause();

    _borderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true); // Loop with blinking effect
    _borderColorAnimation = ColorTween(
      begin: Colors.greenAccent.shade100,
      end: Colors.greenAccent,
    ).animate(_borderAnimationController);

    guesses = widget.guesses;
    getNewWorld(); // Initialize randomWorld inside state
    answerText.addListener(() {
      setState(() {
        isButtonEnabled = answerText.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _borderAnimationController.dispose();
    super.dispose();
  }

  void getNewWorld() {
    if (availableWorlds.isEmpty) {
      availableWorlds = List.from(worlds);
    }

    setState(() {
      int index = _random.nextInt(availableWorlds.length);

      randomWorld = availableWorlds.removeAt(
        index,
      ); // Update the world on button press
      arrayIndUsed.add(index);
      arrayNameUsed.add(randomWorld?.answer);
    });
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Guess the Star Wars World"),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            randomWorld != null && availableWorlds.isNotEmpty
                ? Column(
                  children: [
                    const SizedBox(height: 20.0),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: tablet ? 450 : 250,
                      height: tablet ? 350 : 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              animateCorrect
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                          width: 6,
                        ),
                      ),
                      child: Image.asset(randomWorld!.image, fit: BoxFit.cover),
                    ),

                    const SizedBox(height: 20.0),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ), // To prevent text from touching the edges
                      child: Text(
                        randomWorld?.clue ?? "No more planets",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Courier',
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    const SizedBox(height: 20.0),

                    Center(
                      child: SizedBox(
                        width: 200.0,
                        height: 60.0,
                        child: TextField(
                          controller: answerText,
                          decoration: InputDecoration(
                            hintText: 'Tape ta réponse...',
                            hintStyle: TextStyle(
                              color: Colors.greenAccent.shade100,
                            ),
                            filled: true,
                            fillColor: Colors.black87,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'Courier',
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    if (feedbackMessage.isNotEmpty)
                      Text(
                        feedbackMessage,
                        style: TextStyle(
                          color:
                              feedbackMessage.startsWith("Correct")
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                    ElevatedButton(
                      onPressed:
                          isButtonEnabled
                              ? () {
                                if (counter >= guesses) return;

                                setState(() {
                                  text = answerText.text.trim().toLowerCase();
                                  answered = true;

                                  if (randomWorld != null &&
                                      randomWorld!.answer.toLowerCase() ==
                                          text) {
                                    goodResponse++;
                                    feedbackMessage = "Correct !";
                                    setState(() {
                                      animateCorrect = true;
                                    });
                                  } else {
                                    badResponse++;
                                    feedbackMessage =
                                        "Wrong ! It was ${randomWorld?.answer}";
                                  }

                                  Future.delayed(
                                    Duration(milliseconds: 500),
                                    () {
                                      setState(() {
                                        animateCorrect = false;
                                      });
                                    },
                                  );

                                  counter++; // Increment after every answer
                                  answerText.clear();

                                  // Move to next question after a short delay
                                  if (counter < guesses) {
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {
                                        feedbackMessage =
                                            ""; // Hide feedback before new question
                                        getNewWorld(); // Change the question with another wolrd
                                      });
                                    });
                                  } else {
                                    // Quiz terminé
                                    Future.delayed(Duration(seconds: 2), () {
                                      dialogResuslts(
                                        context,
                                        goodResponse,
                                        widget.guesses,
                                        badResponse,
                                      );
                                    });
                                  }
                                });
                              }
                              : null, // Disables the button when `isButtonEnabled` is `false`
                      child: Text("Send"),
                    ),

                    const SizedBox(height: 20.0),
                  ],
                )
                : Center(
                  child: Text(
                    "NO MORE PLANETS TO GUESS",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
