import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/global_card.dart';
import '../sections/features_section.dart';
import '../sections/introduction.dart';
import '../sections/modules.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _controller = ScrollController();

  // Global keys to get the position of each section
  final GlobalKey _introductionKey = GlobalKey();
  final GlobalKey _modulesKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();

  bool showImage = false;

  @override
  void initState() {
    super.initState();
    // Delay the change from text to image after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showImage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 144, 162, 182),
      appBar: CustomAppBar(showImage: showImage),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntroductionSection(key: _introductionKey),
              SizedBox(height: 10),
              ModulesSection(key: _modulesKey),
              SizedBox(height: 10),
              FeaturesSection(key: _featuresKey),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
