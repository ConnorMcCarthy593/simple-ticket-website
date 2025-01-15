import 'package:flutter/material.dart';
import '../components/global_card.dart';
import '../sections/features_section.dart';
import '../sections/introduction.dart';
import '../sections/modules.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final ScrollController _controller = ScrollController();

  // Global keys to get the position of each section
  final GlobalKey _introductionKey = GlobalKey();
  final GlobalKey _modulesKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Ticket'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Introduction':
                  _scrollToSection(_introductionKey);
                  break;
                case 'Modules':
                  _scrollToSection(_modulesKey);
                  break;
                case 'Features':
                  _scrollToSection(_featuresKey);
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Introduction',
                  child: Text('Introduction'),
                ),
                const PopupMenuItem<String>(
                  value: 'Modules',
                  child: Text('Modules'),
                ),
                const PopupMenuItem<String>(
                  value: 'Features',
                  child: Text('Features'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _scrollToSection(_introductionKey),
                child: const Text(
                  'Introduction',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              IntroductionSection(key: _introductionKey),
              const SizedBox(height: 32),

              GestureDetector(
                onTap: () => _scrollToSection(_modulesKey),
                child: const Text(
                  'Modules',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ModulesSection(key: _modulesKey),
              const SizedBox(height: 32),

              GestureDetector(
                onTap: () => _scrollToSection(_featuresKey),
                child: const Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FeaturesSection(key: _featuresKey),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final offset = box.localToGlobal(Offset.zero).dy;
        _controller.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}