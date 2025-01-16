import 'package:flutter/material.dart';

import 'pages/main_page.dart';

// Define a constant for your theme color
const Color customColor = Color.fromARGB(255, 144, 162, 182);
const Color customBlue = Color(0xFF35495F);  // Updated primary color

const MOBILE_SCREEN_WIDTH = 350.0;

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: customBlue,  // Primary color
        colorScheme: ColorScheme.light(
          primary: customBlue,      // Primary color in the color scheme
          secondary: customColor,   // Secondary color
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: customBlue,  // Apply the color to AppBar
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: customBlue,  // Apply to buttons
        ),
        // You can define other theme properties here as needed
      ),
      home: MainScreen(),
    );
  }
}