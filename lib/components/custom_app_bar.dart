


import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showImage;

  CustomAppBar({required this.showImage});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: Color(0xFF35495F),
            backgroundColor: Theme.of(context).primaryColor,

      title: AnimatedSwitcher(
        duration: Duration(milliseconds: 500), // Set animation duration
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: showImage
            ? Image.network(
                'https://iili.io/26emATx.png',
                height: 80, // Adjust height as needed
                key: ValueKey<int>(1), // Ensure the widget is treated as a new widget
              )
            : Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 20, // Adjust font size as needed
                ),
                key: ValueKey<int>(0), // Ensure the widget is treated as a new widget
              ),
      ),
      actions: [],
    );
  }
}