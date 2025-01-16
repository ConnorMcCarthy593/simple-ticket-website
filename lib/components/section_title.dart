import 'package:flutter/material.dart';

class SectionTitle extends StatefulWidget {
  final String text;

  const SectionTitle({Key? key, required this.text}) : super(key: key);

  @override
  _SectionTitleState createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Adjust duration as needed
      vsync: this,
    );

    // Define the slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts below its position
      end: Offset.zero,          // Ends at its final position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Define the fade animation
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation with a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).primaryColor;

    return Center(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeColor,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}