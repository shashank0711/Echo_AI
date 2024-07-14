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
  bool isListening = false;
  Uint8List? generatedImage;
  String? generatedContent;

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
      await Future.delayed(Duration(seconds: 1));
      print("Sending lastWords to GeminiAPIService: $lastWords");
      dynamic response = await geminiAPIService.isArtOrNot(lastWords);
      print("GeminiAPIService response: ${response.runtimeType}");
      // print("GeminiAPIService response: $response");

      if (response is Uint8List) {
        setState(() {
          generatedImage = response;
          generatedContent = null;
        });
      } else {
        setState(() {
          generatedContent = response;
          generatedImage = null;
        });
      }
    } else {
      setState(() {
        generatedContent = 'An internal error occurred, ask any question...';
      });
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
          'Shimmer',
          style:
              TextStyle(fontFamily: 'cera', fontSize: 25, color: Colors.black),
        ),
        leading: const Icon(Icons.menu, size: 30, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  generatedImage = null;
                  generatedContent = null;
                });
              },
              icon: const Icon(
                Icons.refresh_outlined,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.zero),
                  ),
                  child: Text(
                    generatedContent == null
                        ? 'Good morning, what task can i do for you?'
                        : generatedContent!,
                    style: TextStyle(
                      fontFamily: 'cera',
                      fontSize: generatedContent == null ? 20 : 17,
                    ),
                  ),
                ),

                if (generatedImage != null) Image.memory(generatedImage!),

                Visibility(
                  visible: generatedContent == null,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      // Container(
                      //   color: Colors.black,
                      //   height: 200,
                      //   width: 200,
                      //   child: Text(
                      //     lastWords,
                      //     style: TextStyle(color: Colors.white,fontSize: 20),
                      //   ),
                      // ),
                      FeatureBox(
                        title: 'Gemini ',
                        subtitle:
                            'A smarter way to stay organized and informed with Gemini',
                        color: Color(0xFFDB8882),
                      ),

                      FeatureBox(
                        title: 'Stability AI',
                        subtitle:
                            'Get inspired and stay creative with your personal assistant powered by Stability AI',
                        color: Color(0xFF8887AF),
                      ),

                      FeatureBox(
                        title: 'Smart Voice Assistant',
                        subtitle:
                            'Get a both of best worlds with a voice assistant powered by Gemini and Stability AI',
                        color: Color(0xFF5D86C5),
                      ),
                    ],
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
          backgroundColor: Colors.black87,
          onPressed: () async {
            if (!isListening) {
              await startListening();
            } else {
              await stopListening();
            }
          },
          child: Icon(
            isListening ? Icons.stop : Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class FeatureBox extends StatelessWidget {
  const FeatureBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title, subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                fontFamily: 'cera', fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontFamily: 'cera', fontSize: 12),
          ),
        ],
      ),
    );
  }
}
