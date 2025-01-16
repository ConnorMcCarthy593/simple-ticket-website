import 'package:flutter/material.dart';

import '../main.dart';


class IntroductionSection extends StatefulWidget {
  const IntroductionSection({super.key});

  @override
  _IntroductionSectionState createState() => _IntroductionSectionState();
}

class _IntroductionSectionState extends State<IntroductionSection> with TickerProviderStateMixin {
  static const String textToAnimate = "Streamline operations across your enterprise with SimpleTicket: The AI-powered platform for service management, automation, and insights.";

  late AnimationController _textController;
  late String _displayedText;

  @override
  void initState() {
    super.initState();
    _displayedText = "";

    _textController = AnimationController(
      duration: Duration(milliseconds: textToAnimate.length * 10), // Adjust speed
      vsync: this,
    );

    _textController.addListener(() {
      setState(() {
        final int currentIndex = (_textController.value * textToAnimate.length).floor();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < MOBILE_SCREEN_WIDTH;

    if (!isMobile) {
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
                        "SIMPLIFY OPERATIONS",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "LEVERAGE AI",
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
          SizedBox(width: 30),
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

    // Mobile layout
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideTransition(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "SIMPLIFY OPERATIONS",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "LEVERAGE AI",
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
          SizedBox(height: 30),
          SlideTransition(
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
        ],
      ),
    );
  }
}