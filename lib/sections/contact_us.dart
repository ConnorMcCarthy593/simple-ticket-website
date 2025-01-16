import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool isHovered = false;
  final String emailAddress = 'jcasas@simple-ticket.net';

  // Function to launch the email app
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: 'subject=Contact&body=Hi there!',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  // Function to copy email to clipboard
  void _copyEmail() {
    Clipboard.setData(ClipboardData(text: emailAddress)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email address copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendEmail,
              child: const Text('Contact us'),
            ),
            if (isHovered)
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _copyEmail,
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy jcasas@simple-ticket.net email'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _sendEmail,
                        icon: const Icon(Icons.email),
                        label: const Text('Send email through outlook'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}