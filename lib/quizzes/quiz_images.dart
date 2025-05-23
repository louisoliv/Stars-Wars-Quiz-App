import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:star_wars_quiz_app/quizzes/quiz_images_dialog_results.dart';

class Quiz extends StatefulWidget {
  final int guesses;

  const Quiz({Key? key, required this.guesses}) : super(key: key);

  @override
  State<Quiz> createState() => QuizWindow();
}

class QuizWindow extends State<Quiz> {
  var url = "https://akabab.github.io/starwars-api/api/all.json";

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
  int guesses = 5;
  int _start = 20;
  String timerResponseString = "";
  int timerResponseInt = 0;
  late Timer _timer;
  int imageWidth = 0;
  int imageHeight = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          timerResponseString =
              "Time's up ! It was ${randomCharacter?['name']}";
          timerResponseInt++;

          if (!answered) {
            badResponse++; // The player didn't answered in time
            incrementCounter(); // Every try is counted here
          }

          answered = false; // Reset for the next
        });

        Future.delayed(Duration(seconds: 2), () {
          if (counter < widget.guesses) {
            getRandomCharacter();
            timerResponseString = "";
          } else {
            dialogResuslts(context, goodResponse, widget.guesses, badResponse);
          }
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.pause();
    fetchData();
    guesses = widget.guesses;
    answerText.addListener(() {
      setState(() {
        isButtonEnabled = answerText.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          starWarsCharacters = data;

          uniqueCharacters =
              starWarsCharacters!
                  .where(
                    (character) =>
                        character['image'] != null &&
                        character['image'].isNotEmpty,
                  )
                  .toList();
          if (badResponse + goodResponse + counter <= widget.guesses) {
            getRandomCharacter();
          }
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error when fetching data : $e");
    }
  }

  void getRandomCharacter() async {
    if (uniqueCharacters.isNotEmpty) {
      List<dynamic> validCharacters =
          uniqueCharacters.where((character) {
            String imageUrl = character['image'];
            return imageUrl.isNotEmpty && !usedImages.contains(imageUrl);
          }).toList();

      if (validCharacters.isNotEmpty) {
        final random = Random();
        dynamic selectedCharacter;
        bool imageValid = false;

        while (!imageValid && validCharacters.isNotEmpty) {
          selectedCharacter =
              validCharacters[random.nextInt(validCharacters.length)];
          String imageUrl = selectedCharacter['image'];

          try {
            final response = await http.head(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              imageValid = true; // Image is valid
            } else {
              validCharacters.remove(
                selectedCharacter,
              ); // Remove invalid character
            }
          } catch (e) {
            validCharacters.remove(selectedCharacter);
          }
        }

        // If a valid image is found, update state
        if (imageValid) {
          setState(() {
            randomCharacter = selectedCharacter;
            usedImages.add(randomCharacter!['image']); // Mark image as used
            _start = 20;
          });

          startTimer();
        } else {
          setState(() {
            randomCharacter = null; // No valid character found
          });
        }
      } else {
        print("No more unique characters available.");
      }
    }
  }

  void _handleSubmit() {
    setState(() {
      text = answerText.text.trim().toLowerCase();
      answered = true;
      answerText.clear();

      if (text.isEmpty) {
        badResponse++;
      } else if (randomCharacter!['name'].toLowerCase().contains(text)) {
        goodResponse++;
      } else {
        badResponse++;
      }

      _start = 0; // Stop the timer
      incrementCounter(); // Count each try one time
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // backgroundColor: Colors.blue,
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
      body: Center(
        child:
            randomCharacter == null
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // STAR WARS HOLOGRAM POSTER
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.cyanAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.cyanAccent.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              "TARGET IDENTIFICATION",
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Image.network(
                              randomCharacter!['image'],
                              width: 200,
                              height: 200,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.error, color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Species: ${randomCharacter!['species'] ?? 'Unknown'}',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TIMER
                      Text(
                        "Time left: $_start sec",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TEXT FIELD
                      Container(
                        width: 250,
                        child: TextField(
                          controller: answerText,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white12,
                            hintText: 'Identify character',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.cyanAccent),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // SUBMIT BUTTON
                      ElevatedButton(
                        onPressed: isButtonEnabled ? _handleSubmit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Submit"),
                      ),

                      const SizedBox(height: 20),

                      // FEEDBACK TEXT
                      if (_start == 0)
                        Text(
                          timerResponseString,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }
}
