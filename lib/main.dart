import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rpg/screens/home/home.dart';
import 'package:flutter_rpg/services/character_store.dart';
import 'package:flutter_rpg/services/marker_store.dart';
import 'package:flutter_rpg/shared/styled_button.dart';
import 'package:flutter_rpg/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// firebase 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // allow firebase to use platform channels to call native code to initialize itself
  // without this: firebase doesn't work correctly 
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  // MapboxOptions.setAccessToken(mapboxAccessToken);
  OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;
  // OpenAI.baseUrl = "https://api.openai.com/v1";
  OpenAI.showLogs = true; // make the package logs the operations flows and steps
  // OpenAIModelModel model = await OpenAI.instance.model.retrieve("text-davinci-003"); // Retrieves a single model 

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(context) => CharacterStore()),
      ChangeNotifierProvider(create: (context) => MarkerStore())
    ],
    child: MaterialApp(
      theme: primaryTheme,
      home: const Home()
    ),
    ),
  );
}

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();

}

class _SandboxState extends State<Sandbox> {
  late String story = "";

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        SizedBox(height: 80),

        StyledButton(
          onPressed: () async {
            OpenAICompletionModel completion = await OpenAI.instance.completion.create(
              model: "gpt-3.5-turbo-instruct",
              prompt: "Generate a short story for a character named Helen.",
              maxTokens: 200,
              temperature: 0.5,
              // n: 1,
              // stop: ["\n"],
              // echo: true,
              // seed: 42,
              // bestOf: 2,
            );
            print(completion.choices.first.text);
            
            setState(() {
              story = completion.choices.first.text;
            });
          }, 
          child: Text("OpenAI")
      ),

        SizedBox(height: 20),

        Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  story,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ),

      ],
    );
  }
}