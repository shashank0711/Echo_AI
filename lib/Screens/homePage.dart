import 'package:echo_ai/Screens/geminiChatPage.dart';
import 'package:echo_ai/services.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:typed_data';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  SpeechToText speechToText = SpeechToText();
  String lastWords = "";
  final GeminiAPIService geminiAPIService = GeminiAPIService();
  bool isListening =false;
  late final Uint8List? generatedImage;


  @override
  void initState() {
    super.initState();
    initSpeechtoText();
  }

  Future<void> initSpeechtoText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    setState(() {
      isListening = true;
    });
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });

    if (lastWords.isNotEmpty && lastWords.split(' ').length > 2) {
      print("Sending lastWords to GeminiAPIService: $lastWords"); // Debugging statement
      dynamic response = await geminiAPIService.isArtOrNot(lastWords);
      print("GeminiAPIService response: ${response.runtimeType}"); //
      print("GeminiAPIService response: $response"); //

      if (response is Uint8List) {
        setState(() {
          generatedImage = response;
        });
      } else {
        print("No image generated or response is not Uint8List");
      }
      // Debugging statement
    } else {
      print("No words recognized or too short"); // Debugging statement
    }
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
    print("Recognised words: $lastWords");
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alice',
          style:
              TextStyle(fontFamily: 'cera', fontSize: 25, color: Colors.black),
        ),
        leading: Icon(Icons.menu, size: 30, color: Colors.black),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //virtual assistant image
                Center(
                    child: Image.asset(
                  'assets/images/ai image.png',
                  scale: 5,
                )),

                //initial greeting message
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.zero),
                  ),
                  child: const Text(
                    'Good morning, what task can i do for you?',
                    style: TextStyle(
                      fontFamily: 'cera',
                      fontSize: 20,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Here are few suggestions',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'cera',
                    ),
                  ),
                ),

                //features list
                Container(
                  color: Colors.black,
                  height: 200,
                  width: 200,
                  child: Text(
                    lastWords,
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent.shade100,
          onPressed: () async {
            if (!isListening) {
               await startListening();
            } else {
              await stopListening();
            }
          },
          child: Icon(isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}

class featureBox extends StatelessWidget {
  const featureBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title, subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => geminiChatPage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontFamily: 'cera',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontFamily: 'cera', fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
