import 'package:flutter/material.dart';

class IntroductionSection extends StatefulWidget {
  const IntroductionSection({super.key});

  @override
  _IntroductionSectionState createState() => _IntroductionSectionState();
}

class _IntroductionSectionState extends State<IntroductionSection> with TickerProviderStateMixin {
  static const Color customBlue = Color(0xFF354960);
  static const String textToAnimate =
      "Streamline operations across your enterprise with SimpleTicket: The AI-powered platform for service management, automation, and insights.";

  late AnimationController _textController;
  late String _displayedText;

  @override
  void initState() {
    super.initState();
    _displayedText = "";

    // Set up the animation controller for letter-by-letter display
    _textController = AnimationController(
      duration: Duration(milliseconds: textToAnimate.length * 10), // Adjust speed
      vsync: this,
    );

    _textController.addListener(() {
      setState(() {
        final int currentIndex =
            (_textController.value * textToAnimate.length).floor();
        _displayedText = textToAnimate.substring(0, currentIndex);
      });
    });

    // Start the animation
    _textController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _textController,
                curve: Curves.easeOut,
              )),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _textController,
                  curve: Curves.easeIn,
                ),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "FOR YOUR TEAM",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _textController,
                curve: Curves.easeOut,
              )),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _textController,
                  curve: Curves.easeIn,
                ),
                child: Text(
                  _displayedText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}