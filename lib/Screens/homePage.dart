import 'package:animate_do/animate_do.dart';
import 'package:echo_ai/services.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:typed_data';

import '../Utils/utilities.dart';

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
  bool isLoading = false;

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
        title: FadeInDown(
          child: const Text(
            'Shimmer',
            style: TextStyle(
                fontFamily: 'cera', fontSize: 25, color: Colors.black),
          ),
        ),
        leading: FadeInLeft(
            child: const Icon(Icons.menu, size: 30, color: Colors.black)),
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
                ZoomIn(
                  child: Center(
                      child: Image.asset(
                    'assets/images/ai image.png',
                    scale: 5,
                  )),
                ),

                //initial greeting message
                ZoomIn(
                  child: Visibility(
                    visible: generatedImage == null,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.black54, width: 2),
                        borderRadius: BorderRadius.circular(20)
                            .copyWith(topLeft: Radius.zero),
                      ),
                      child: (isLoading == true && generatedContent == null)
                          ? const CircularIndicatorWithMessage()
                          : Text(
                              generatedContent == null
                                  ? 'Good morning, what task can i do for you?'
                                  : generatedContent!,
                              style: TextStyle(
                                fontFamily: 'cera',
                                fontSize: generatedContent == null ? 20 : 17,
                              ),
                            ),
                    ),
                  ),
                ),

                if (generatedImage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    margin: const EdgeInsets.only(top: 30, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.black54, width: 2),
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topLeft: Radius.zero),
                    ),
                    child: (isLoading == true && generatedImage == null)
                        ? const CircularIndicatorWithMessage()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(generatedImage!)),
                  ),

                Visibility(
                  visible: (generatedContent == null && generatedImage == null),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SlideInLeft(
                          child: const Text(
                            'Here are few suggestions',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'cera',
                            ),
                          ),
                        ),
                      ),
                      SlideInLeft(
                        delay: const Duration(milliseconds: 300),
                        child: const FeatureBox(
                          title: 'Gemini ',
                          subtitle:
                              'A smarter way to stay organized and informed with Gemini',
                          color: Color(0xFFDB8882),
                        ),
                      ),
                      SlideInLeft(
                        delay: const Duration(milliseconds: 600),
                        child: const FeatureBox(
                          title: 'Stability AI',
                          subtitle:
                              'Get inspired and stay creative with your personal assistant powered by Stability AI',
                          color: Color(0xFF8887AF),
                        ),
                      ),
                      SlideInLeft(
                        delay: const Duration(milliseconds: 900),
                        child: const FeatureBox(
                          title: 'Smart Voice Assistant',
                          subtitle:
                              'Get a both of best worlds with a voice assistant powered by Gemini and Stability AI',
                          color: Color(0xFF5D86C5),
                        ),
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
        child: ZoomIn(
          child: FloatingActionButton(
            backgroundColor: Colors.black87,
            onPressed: () async {
              if (!isListening) {
                await startListening();
              } else {
                await stopListening();
                setState(() {
                  isLoading = true;
                });
                if (lastWords.isNotEmpty && lastWords.split(' ').length > 2) {
                  await Future.delayed(Duration(seconds: 1));
                  print("Sending lastWords to GeminiAPIService: $lastWords");
                  dynamic response =
                      await geminiAPIService.isArtOrNot(lastWords);
                  print("GeminiAPIService response: ${response.runtimeType}");
                  // print("GeminiAPIService response: $response");

                  if (response is Uint8List) {
                    setState(() {
                      generatedImage = response;
                      generatedContent = null;
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      generatedContent = response;
                      generatedImage = null;
                      isLoading = false;
                    });
                  }
                } else {
                  setState(() {
                    generatedContent =
                        'An internal error occurred, ask any question...';
                    isLoading = false;
                  });
                }
              }
            },
            child: Icon(
              isListening ? Icons.stop : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
