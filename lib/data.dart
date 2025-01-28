

  import 'package:flutter/material.dart';
import 'package:simple_ticket/components/global_card.dart';

final List<Widget> modules1 = [
    DetailedCard(
      title: 'Marketing',
      description: 'Enhance your marketing efforts with targeted campaigns, detailed analytics, and automated marketing tools. Optimize your strategies to reach more customers effectively.',
      animationPath: 'https://lottie.host/bddd9424-7625-4528-bac0-4cb741f1be05/FIsyTVgp2o.json',
      details: [
        {
          'icon': Icons.campaign,
          'description': 'Targeted campaigns',
        },
        {'icon': Icons.analytics, 'description': 'Detailed analytics'},
        {'icon': Icons.email, 'description': 'Automatic notifications'},
      ],
    ),
    DetailedCard(
      title: 'Recruiting',
      description: 'Streamline your recruitment process. Post job openings, review applications, track candidates, and collaborate with your hiring team to find the perfect match for your organization.',
      animationPath: 'https://lottie.host/06922141-ea60-45da-9862-b085209f056c/RwBLNL0DZp.json',
      details: [
        {'icon': Icons.work, 'description': 'Automatically post job openings'},
        {'icon': Icons.person_search, 'description': 'Track candidates through interview/background checks'},
        {'icon': Icons.style, 'description': 'Create offer letters'},
        {'icon': Icons.group, 'description': 'Use AI based on your data to filter candidates'},
        {'icon': Icons.group, 'description': 'Automatically extract all the data from resumes'},
      ],
    ),
    DetailedCard(
      title: 'Customer Management',
      description: 'Build stronger relationships with your customers. Track interactions, manage customer data, and personalize services to improve satisfaction and retention.',
      animationPath: 'https://lottie.host/4ed7ce26-7491-4516-8c9d-ee5e0258f720/l7UQzhbH1t.json',
      details: [
        {'icon': Icons.contact_page, 'description': 'Track interactions, incidents, memberships'},
        {'icon': Icons.group, 'description': 'Manage customer segments for tailored services'},
        {'icon': Icons.history, 'description': 'Access complete service history for informed decisions'},
      ],
    ),
  ];

  final List<Widget> modules2 = [
    DetailedCard(
      title: 'Sales Management',
      description: 'Efficiently manage your sales process. From tracking leads to closing deals, streamline your sales workflow to boost performance and conversion rates.',
      animationPath: 'https://lottie.host/712ca8ea-8b00-4615-825f-ab76a3a15042/Cb4dHj5nHH.json',
      details: [
        {'icon': Icons.leaderboard, 'description': 'Track leads'},
        {'icon': Icons.stay_primary_landscape_rounded, 'description': 'Close deals'},
        {'icon': Icons.speed, 'description': 'Streamline workflow'},
      ],
    ),
    DetailedCard(
      title: 'Financial Documentation',
      description: 'Organize and manage all financial records in one place. Simplify accounting, track expenses, generate invoices, and ensure compliance with ease.',
      animationPath: 'https://lottie.host/ca635384-4d5e-4fa1-8036-62aa4316be9f/FjoUUvbQUR.json',
      details: [
        {'icon': Icons.receipt, 'description': 'Track expenses'},
        {'icon': Icons.calculate, 'description': 'Simplify accounting'},
        {'icon': Icons.checklist, 'description': 'Ensure compliance'},
        {'icon': Icons.document_scanner, 'description': 'Tax ready'},
      ],
    ),
    DetailedCard(
      title: 'Task Management',
      description: 'Efficiently manage, track, and automate tasks across your organization. The Task Management module in ServiceNow helps streamline workflows, improve collaboration, and ensure timely resolution of tasks.',
      animationPath: 'https://lottie.host/9e5ba739-65f8-4cc4-96a8-25dbeb79d0a6/tP4BkPdq3P.json',
      details: [
        {'icon': Icons.check_box, 'description': 'Track and manage tasks'},
        {'icon': Icons.work, 'description': 'Automate workflows'},
        {'icon': Icons.people, 'description': 'Collaborate across teams'},
        {'icon': Icons.timer, 'description': 'Ensure timely task resolution'},
        {'icon': Icons.priority_high, 'description': 'Set and track priorities'},
      ],
    ),
  ];

  // List of items to pass to the auto-scroll component
  final List<Widget> features1 = [
    DetailedCard(
      title: 'Fully Automated',
      description: 'Experience seamless automation for a variety of tasks, from sending emails to generating reports. Automate routine processes to save time, reduce human error, and increase efficiency.',
      animationPath: 'https://lottie.host/83d6e419-0d6d-44f2-82ca-1203953dcac8/4L1XMErZg1.json',
      details: [
        {'icon': Icons.schedule, 'description': 'Automate scheduling'},
        {'icon': Icons.email, 'description': 'Send emails'},
        {'icon': Icons.report, 'description': 'Generate reports'},
      ],
    ),
    DetailedCard(
      title: 'Notifications',
      description: 'Stay informed with real-time notifications. Receive updates and alerts for important events, tasks, and deadlines so you never miss critical information.',
      animationPath: 'https://lottie.host/74844795-53af-4b85-bec9-9f74c15a76b4/HgOg2QI9Aw.json',
      details: [
        {'icon': Icons.notification_important, 'description': 'Real-time alerts'},
        {'icon': Icons.event, 'description': 'Event updates'},
        {'icon': Icons.task, 'description': 'Task reminders'},
      ],
    ),
    DetailedCard(
      title: 'AI Agents',
      description: 'Deploy autonomous agents to handle data processing, customer support, and routine operations.',
      animationPath: 'https://lottie.host/aee38d53-ce70-492c-a745-5b526199ebd0/hXQO8892mP.json',
      details: [
        {'icon': Icons.notifications_active, 'description': 'Monitor critical metrics with instant alerts'},
        {'icon': Icons.event, 'description': 'Trigger automated workflows based on system events'},
        {'icon': Icons.assistant, 'description': 'Scale operations with intelligent task handling'},
      ],
    ),

  ];

  // List of items to pass to the auto-scroll component
  final List<Widget> features2 = [
    DetailedCard(
      title: 'Access Control',
      description: 'Manage user access with advanced controls. Ensure secure, role-based access to sensitive data and GlobalCards, empowering only authorized users with specific privileges.',
      animationPath: 'https://lottie.host/01a7eb11-ca93-46a2-a2db-f784890a581d/ZQuuChnwIM.json',
      details: [
        {'icon': Icons.lock, 'description': 'Secure data'},
        {'icon': Icons.verified_user, 'description': 'Role-based access'},
        {'icon': Icons.shield, 'description': 'Ensure privacy'},
      ],
    ),
  ];
