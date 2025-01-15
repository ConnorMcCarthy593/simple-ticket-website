import 'package:flutter/material.dart';

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key});
  // Define the custom color
  static const Color customBlue = Color(0xFF354960);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align both columns at the top
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.topRight, // Align the column to the top-right
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the start of the column
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevent extra space being added above
              children: [
                Text(
                  "LEVERAGE AI POWER",
                  style: TextStyle(
                    color: customBlue, 
                    fontSize: 50, 
                  ),
                ),
                Text(
                  "FOR YOUR TEAM",
                  style: TextStyle(
                    color: Colors.black, 
                    fontSize: 40, 
                  ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.topLeft, // Align text to the top-left
            child: Text(
              "Integrate AI, Data, and Workflows seamlessly into your business with SimpleTicket, the AI-driven platform for digital transformation.",
              style: TextStyle(
                color: Colors.black, // Black color
                fontSize: 20, // Larger font size
              ),
            ),
          ),
        ),
      ],
    );
  }
}