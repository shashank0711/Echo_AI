import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../messages.dart';

class geminiChatPage extends StatefulWidget {
  const geminiChatPage({Key? key}) : super(key: key);

  @override
  State<geminiChatPage> createState() => _geminiChatPageState();
}

class _geminiChatPageState extends State<geminiChatPage> {

  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message(text: "hi", isUser: true),
    Message(text: "hello", isUser: false),
    Message(text: "great you?", isUser: true),
    Message(text: "fine", isUser: false),
    Message(text: "hi", isUser: true),
    Message(text: "hello", isUser: false),
    Message(text: "great you?", isUser: true),
    Message(text: "fine", isUser: false),
    Message(text: "hi", isUser: true),
    Message(text: "hello", isUser: false),
    Message(text: "great you?", isUser: true),
    Message(text: "fine", isUser: false),
    Message(text: "hi", isUser: true),
    Message(text: "hello", isUser: false),
    Message(text: "great you?", isUser: true),
    Message(text: "fine", isUser: false),
    Message(text: "hi", isUser: true),
    Message(text: "hello", isUser: false),
    Message(text: "great you?", isUser: true),
    Message(text: "fine", isUser: false),
    Message(text: "hi", isUser: true),
    Message(text: "hello", isUser: false),
    Message(text: "great you?", isUser: true),
    Message(text: "fine", isUser: false),
  ];
  bool _isLoading = false;

  // callGeminiModel() async{
  //   try{
  //     if(_controller.text.isNotEmpty){
  //       _messages.add(Message(text: _controller.text, isUser: true));
  //       _isLoading = true;
  //     }
  //
  //     final model = GenerativeModel(model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
  //     final prompt = _controller.text.trim();
  //     final content = [Content.text(prompt)];
  //     final response = await model.generateContent(content);
  //
  //     setState(() {
  //       _messages.add(Message(text: response.text!, isUser: false));
  //       _isLoading = false;
  //     });
  //
  //     _controller.clear();
  //   }
  //   catch(e){
  //     print("Error : $e");
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: GestureDetector(
           onTap: () => Navigator.pop(context),
           child: Icon(Icons.arrow_back,color: Colors.black,size: 30,)),
        title: const Text(
          'Alice',
          style: TextStyle(
            fontFamily: 'cera',
            fontSize: 25,
            color: Colors.black
          ),
        ),

        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    title: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: message.isUser
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20))
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                          child: Text(message.text,)
                      ),
                    ),
                  );
                }),
          ),

          // user input
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32, top: 16.0, left: 16.0, right: 16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      // style: Theme.of(context).textTheme.titleSmall,
                      decoration: const InputDecoration(
                          hintText: 'Write your message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            child: Image.asset('assets/images/send.png'),
                            onTap: (){},
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
