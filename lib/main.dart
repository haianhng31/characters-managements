import 'package:flutter/material.dart';
import 'package:flutter_rpg/screens/home/home.dart';
import 'package:flutter_rpg/services/character_store.dart';
import 'package:flutter_rpg/services/marker_store.dart';
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
  // String mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

  // MapboxOptions.setAccessToken(mapboxAccessToken);

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