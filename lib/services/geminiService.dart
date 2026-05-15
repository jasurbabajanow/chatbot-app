import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final key = dotenv.env['API_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception('API_KEY not found in .env');
    }

    model = GenerativeModel(
      model: 'gemini-flash-latest', // ✅ correct name as per curl
      apiKey: key,
    );
  }

  Future<String> generate(String title, String topic) async {
    final content = [Content.text('Write a $title about $topic.')];

    final response = await model.generateContent(content);

    return response.text ?? '';
  }
}
