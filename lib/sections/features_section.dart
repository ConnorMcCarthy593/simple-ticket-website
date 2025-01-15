


// Section 3: Automation
import 'package:flutter/material.dart';

import '../components/global_cart.dart';

class FeaturesSection extends StatelessWidget {

      const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
                GlobalCard(
                  title: 'Fully Automated',
                  description: 'Experience seamless automation for a variety of tasks, from sending emails to generating reports. Automate routine processes to save time, reduce human error, and increase efficiency.',
                  animationPath: 'https://lottie.host/83d6e419-0d6d-44f2-82ca-1203953dcac8/4L1XMErZg1.json',
                  details: [
                    {'icon': Icons.schedule, 'description': 'Automate scheduling'},
                    {'icon': Icons.email, 'description': 'Send emails'},
                    {'icon': Icons.report, 'description': 'Generate reports'},
                  ],
                ),
                const SizedBox(width: 16),
                GlobalCard(
                  title: 'Notifications',
                  description: 'Stay informed with real-time notifications. Receive updates and alerts for important events, tasks, and deadlines so you never miss critical information.',
                  animationPath: 'https://lottie.host/74844795-53af-4b85-bec9-9f74c15a76b4/HgOg2QI9Aw.json',
                  details: [
                    {'icon': Icons.notification_important, 'description': 'Real-time alerts'},
                    {'icon': Icons.event, 'description': 'Event updates'},
                    {'icon': Icons.task, 'description': 'Task reminders'},
                  ],
                ),
                          GlobalCard(
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
        ],
      ),
    );
  }
}
