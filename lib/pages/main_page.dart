import 'package:flutter/material.dart';
import 'package:simple_ticket/components/section_title.dart';
import '../components/carousel.dart';
import '../components/custom_app_bar.dart';
import '../components/global_card.dart';
import '../data.dart';
import '../sections/contact_us.dart';
import '../sections/introduction.dart';

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
  final GlobalKey _contactUsKey = GlobalKey();

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
      appBar: CustomAppBar(showImage: showImage),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              IntroductionSection(key: _introductionKey),
              SizedBox(height: 100),
              SectionTitle(text: "Modules"),
              Carousel(items: modules1),
              Carousel(items: modules2),
              SizedBox(height: 100),
              SectionTitle(text: "Features"),
              Carousel(items: features1),
              Carousel(items: features2),
              SizedBox(height: 100),
              ContactSection(key: _contactUsKey),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
