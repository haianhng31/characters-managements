// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class OpenAIService {
//   final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

//   Future<String> generateUserStory(String prompt) async {
//     try {
//       final url = Uri.parse('https://api.openai.com/v1/completions');
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: json.encode({
//           'model': 'text-davinci-002',
//           'prompt': prompt,
//           'temperature': 0.5,
//           'max_tokens': 1000,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final story = data['choices'][0]['text'];
//         return story;
//       } else {
//         throw Exception('Failed to generate user story: ${response.body}');
//       }
//     } catch (error) {
//       print('Error while generating user story from OpenAI API: $error');
//       throw Exception('Error while generating user story: $error');
//     }
//   }
// }