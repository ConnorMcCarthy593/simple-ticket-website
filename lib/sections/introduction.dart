import 'package:flutter/material.dart';

const double MOBILE_SCREEN_WIDTH = 600; // Define mobile breakpoint

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

    // Set up the animation controller for letter-by-letter display
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

  Widget _buildAnimatedContent(bool isMobile) {
    final titleContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "SIMPLIFY OPERATIONS",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: isMobile ? 35 : 50, // Smaller font size for mobile
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "LEVERAGE AI",
          style: TextStyle(
            color: Colors.black,
            fontSize: isMobile ? 30 : 40, // Smaller font size for mobile
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final descriptionContent = Text(
      _displayedText,
      style: TextStyle(
        color: Colors.black,
        fontSize: isMobile ? 24 : 30, // Smaller font size for mobile
        fontWeight: FontWeight.w400,
        letterSpacing: 1.2,
      ),
    );

    final slideTransition = (Widget child) => SlideTransition(
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
        child: child,
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          slideTransition(titleContent),
          const SizedBox(height: 20),
          slideTransition(descriptionContent),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: slideTransition(titleContent),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: slideTransition(descriptionContent),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < MOBILE_SCREEN_WIDTH;
        return _buildAnimatedContent(isMobile);
      },
    );
  }
}