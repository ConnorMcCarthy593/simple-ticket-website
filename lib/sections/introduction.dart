import 'package:flutter/material.dart';

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key});
  static const Color customBlue = Color(0xFF354960);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.topRight, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, 
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
            alignment: Alignment.topLeft, 
            child: Text(
              "Streamline operations across your enterprise with SimpleTicket: The AI-powered platform for service management, automation, and insights.",
              style: TextStyle(
                color: Colors.black, 
                fontSize: 30, 
              ),
            ),
          ),
        ),
      ],
    );
  }
}