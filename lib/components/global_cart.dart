import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GlobalCard extends StatefulWidget {
  final String title;
  final String description;
  final String animationPath;
  final List<Map<String, dynamic>> details;

  const GlobalCard({
    required this.title,
    required this.description,
    required this.animationPath,
    required this.details,
    super.key,
  });

  @override
  _GlobalCardState createState() => _GlobalCardState();
}

class _GlobalCardState extends State<GlobalCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        clipBehavior: Clip.none, // Ensures that the animated container doesn't get clipped
        children: [
          // Card widget
          SizedBox(
            width: screenWidth < 350 ? screenWidth - 20 : 350,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lottie animation at the top
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
                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // AnimatedContainer above the Card
          Positioned(
            bottom: 0, // Start from the bottom
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
                      leading: Icon(detail['icon'], color: Colors.blue),
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
    );
  }
}