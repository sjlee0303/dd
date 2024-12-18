import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 추가

class ImageService {
  Future<String> translateToEnglish(String koreanText) async {
    final response = await http.post(
      Uri.parse(
          'https://translation.googleapis.com/language/translate/v2?key=AIzaSyAgrjR9nFqQ2puWX124xsUw7XZmZY0rnys'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'q': koreanText,
        'source': 'ko',
        'target': 'en',
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      print('번역 실패: ${response.body}');
      throw Exception('Failed to translate text: ${response.body}');
    }
  }

  Future<String> refinePrompt(String koreanPrompt) async {
    String englishPrompt = await translateToEnglish(koreanPrompt);
    return "This image should depict " +
        englishPrompt +
        " with a detailed and realistic style. It should include vivid colors and natural lighting. " +
        "The main object should be at the center of the frame, with a warm and inviting atmosphere.";
  }

  Future<String?> generateImage(String prompt) async {
    String refinedPrompt = await refinePrompt(prompt);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer (edit here)',
      },
      body: jsonEncode({'prompt': refinedPrompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String imageUrl = data['data'][0]['url'];
      print('Generated Image URL: $imageUrl');
      return imageUrl;
    } else {
      print('이미지 생성 실패!!');
      print('API 응답: ${response.body}');
      throw Exception('Failed to generate image: ${response.body}');
    }
  }
}
