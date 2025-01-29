import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_ticket/components/navigator.dart';

import 'pages/doc_page.dart';
import 'pages/main_page.dart';

// Define a constant for your theme color
const Color customColor = Color.fromARGB(255, 144, 162, 182);
const Color customBlue = Color(0xFF35495F); // Updated primary color

const double MOBILE_SCREEN_WIDTH = 350.0;

Future<void> main() async {
  // Ensure that dotenv is loaded before running the app
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: customBlue,
        colorScheme: const ColorScheme.light(
          primary: customBlue,
          secondary: customColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: customBlue,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: customBlue,
        ),
      ),
      home: const NavigatorScreen(),
    );
  }
}