// import 'package:flutter/material.dart';

// import '../components/global_card.dart';

// class FeaturesSection extends StatefulWidget {
//   const FeaturesSection({super.key});

//   @override
//   _FeaturesSectionState createState() => _FeaturesSectionState();
// }

// class _FeaturesSectionState extends State<FeaturesSection> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() async {
//     // Delay to ensure the widget is loaded before scrolling
//     await Future.delayed(Duration(seconds: 2));

//     // Scroll to the end of the list
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(seconds: 5), // Adjust duration as needed
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: _scrollController,
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           DetailedCard(
//             title: 'Fully Automated',
//             description: 'Experience seamless automation for a variety of tasks, from sending emails to generating reports. Automate routine processes to save time, reduce human error, and increase efficiency.',
            // animationPath: 'https://lottie.host/83d6e419-0d6d-44f2-82ca-1203953dcac8/4L1XMErZg1.json',
//             details: [
//               {'icon': Icons.schedule, 'description': 'Automate scheduling'},
//               {'icon': Icons.email, 'description': 'Send emails'},
//               {'icon': Icons.report, 'description': 'Generate reports'},
//             ],
//           ),
//           const SizedBox(width: 16),
//           DetailedCard(
//             title: 'Notifications',
//             description: 'Stay informed with real-time notifications. Receive updates and alerts for important events, tasks, and deadlines so you never miss critical information.',
//             animationPath: 'https://lottie.host/74844795-53af-4b85-bec9-9f74c15a76b4/HgOg2QI9Aw.json',
//             details: [
//               {'icon': Icons.notification_important, 'description': 'Real-time alerts'},
//               {'icon': Icons.event, 'description': 'Event updates'},
//               {'icon': Icons.task, 'description': 'Task reminders'},
//             ],
//           ),
//           DetailedCard(
//             title: 'AI Agents',
//             description: 'Deploy autonomous agents to handle data processing, customer support, and routine operations.',
//             animationPath: 'https://lottie.host/aee38d53-ce70-492c-a745-5b526199ebd0/hXQO8892mP.json',
//             details: [
//               {'icon': Icons.notifications_active, 'description': 'Monitor critical metrics with instant alerts'},
//               {'icon': Icons.event, 'description': 'Trigger automated workflows based on system events'},
//               {'icon': Icons.assistant, 'description': 'Scale operations with intelligent task handling'},
//             ],
//           ),
//           DetailedCard(
//             title: 'Access Control',
//             description: 'Manage user access with advanced controls. Ensure secure, role-based access to sensitive data and GlobalCards, empowering only authorized users with specific privileges.',
//             animationPath: 'https://lottie.host/01a7eb11-ca93-46a2-a2db-f784890a581d/ZQuuChnwIM.json',
//             details: [
//               {'icon': Icons.lock, 'description': 'Secure data'},
//               {'icon': Icons.verified_user, 'description': 'Role-based access'},
//               {'icon': Icons.shield, 'description': 'Ensure privacy'},
//             ],
//           ),

//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }




import 'package:flutter/material.dart';
import '../components/carousel.dart';
import '../components/global_card.dart';


import 'package:flutter/material.dart';




class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of items to pass to the auto-scroll component
    final List<Widget> cards = [
      DetailedCard(
        title: 'Fully Automated',
        description:
            'Experience seamless automation for a variety of tasks, from sending emails to generating reports. Automate routine processes to save time, reduce human error, and increase efficiency.',
            animationPath: 'https://lottie.host/83d6e419-0d6d-44f2-82ca-1203953dcac8/4L1XMErZg1.json',

        details: [
          {'icon': Icons.schedule, 'description': 'Automate scheduling'},
          {'icon': Icons.email, 'description': 'Send emails'},
          {'icon': Icons.report, 'description': 'Generate reports'},
        ],
      ),
      DetailedCard(
        title: 'Notifications',
        description:
            'Stay informed with real-time notifications. Receive updates and alerts for important events, tasks, and deadlines so you never miss critical information.',
        animationPath:
            'https://lottie.host/74844795-53af-4b85-bec9-9f74c15a76b4/HgOg2QI9Aw.json',
        details: [
          {'icon': Icons.notification_important, 'description': 'Real-time alerts'},
          {'icon': Icons.event, 'description': 'Event updates'},
          {'icon': Icons.task, 'description': 'Task reminders'},
        ],
      ),
      DetailedCard(
        title: 'AI Agents',
        description:
            'Deploy autonomous agents to handle data processing, customer support, and routine operations.',
        animationPath:
            'https://lottie.host/aee38d53-ce70-492c-a745-5b526199ebd0/hXQO8892mP.json',
        details: [
          {'icon': Icons.notifications_active, 'description': 'Monitor critical metrics with instant alerts'},
          {'icon': Icons.event, 'description': 'Trigger automated workflows based on system events'},
          {'icon': Icons.assistant, 'description': 'Scale operations with intelligent task handling'},
        ],
      ),
      DetailedCard(
        title: 'Access Control',
        description:
            'Manage user access with advanced controls. Ensure secure, role-based access to sensitive data and GlobalCards, empowering only authorized users with specific privileges.',
        animationPath:
            'https://lottie.host/01a7eb11-ca93-46a2-a2db-f784890a581d/ZQuuChnwIM.json',
        details: [
          {'icon': Icons.lock, 'description': 'Secure data'},
          {'icon': Icons.verified_user, 'description': 'Role-based access'},
          {'icon': Icons.shield, 'description': 'Ensure privacy'},
        ],
      ),
    ];

    return Carousel(items: cards); // Use the component
  }
}