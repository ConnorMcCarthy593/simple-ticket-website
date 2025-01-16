import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class DetailedCard extends StatefulWidget {
  final String title;
  final String description;
  final String animationPath;
  final List<Map<String, dynamic>> details;

  const DetailedCard({
    required this.title,
    required this.description,
    required this.animationPath,
    required this.details,
    super.key,
  });

  @override
  _DetailedCardState createState() => _DetailedCardState();
}

class _DetailedCardState extends State<DetailedCard> {
  bool _isHovered = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay the visibility change to trigger the animation
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: screenWidth < MOBILE_SCREEN_WIDTH ? screenWidth - 50 : MOBILE_SCREEN_WIDTH, // Set a width constraint for the Stack
        height: 400, // Set a height constraint for the Stack
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              bottom: _isVisible ? 0 : -400, // Start from below the screen
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _isVisible ? 1.0 : 0.0, // Fade in the card
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Lottie.network(
                            widget.animationPath,
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Wrap the description in a Container with a fixed height
                        Container(
                          height: 100, // Fixed height for the description area
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                            // overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isHovered ? (widget.details.length * 60.0) : 0,
                width: screenWidth < 350 ? screenWidth - 20 : 350,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: _isHovered
                      ? [BoxShadow(color: Colors.black26, blurRadius: 6.0)]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.details.length,
                    itemBuilder: (context, index) {
                      final detail = widget.details[index];
                      return ListTile(
                        leading: Icon(detail['icon'], color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          detail['description'],
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}