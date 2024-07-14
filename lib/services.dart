import 'dart:convert';
import 'dart:typed_data';
import 'package:echo_ai/secrets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;



class GeminiAPIService {
  final List<Content> contents = [];
  Uint8List? image;


  //to determine whether we have to use the gemini api or the stability ai api
  Future<Object?> isArtOrNot(String message) async {
    try{
      if (message.isEmpty) {
        return "An internal error occurred";
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiAPIKey);
      final content = [Content.text("'$message' Does this message want to generate an AI picture, image, art, or anything similar? Simply answer with a yes or a no.")];
      final response = await model.generateContent(content);

      String? firstResult = response.text;
      firstResult = firstResult?.trim();

      // print(firstResult);

      switch(firstResult){
        case 'Yes.':
        case 'yes.':
        case 'yes' :
        case 'Yes' :
          final  res = await stabilityAIAPI (message);
          return res;

        default :
          final res = await geminiAPI (message);
          return res;
      }


    }catch(e){
      return e.toString();
    }
  }


  //gemini AI service to generate response
  Future<String?> geminiAPI(message) async {

    contents.add(Content.text(message));

    try{
      if (message.isEmpty) {
        return "An internal error occurred";
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiAPIKey);
      final content = contents;
      final response = await model.generateContent(content);

      String? geminiAPIResult = response.text;

      return geminiAPIResult;

    }catch(e){
      return e.toString();
    }
  }


  //stability AI API to generate image
  Future<dynamic> stabilityAIAPI(String message) async {
    contents.add(Content.text(message));

    try{
      final response = await http.post(
          Uri.parse(
              'https://api.stability.ai/v1alpha/generation/stable-diffusion-512-v2-1/text-to-image'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "image/png",
            "Authorization": "Bearer $stabilityAIAPIKey"
          },
          body: jsonEncode({
            "text_prompts": [
              {
                "text": message,
                "weight": 1,
              }
            ],
            "cfg_scale": 7,
            "height": 1024,
            "width": 1024,
            "samples": 1,
            "steps": 30,
          }));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print("Image generated successfully");
       return response.bodyBytes;
      } else {
        print("failed to generate image");
        return null;
      }
    }catch(e) {
      return e.toString();
    }
    // return imageData;
  }
}

