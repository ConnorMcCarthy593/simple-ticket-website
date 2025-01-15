import 'package:flutter/material.dart';
import '../components/global_card.dart';

class Carousel extends StatefulWidget {
  final List<Widget> items;

  const Carousel({super.key, required this.items});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // print('initState called');
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _animationController.value * _scrollController.position.maxScrollExtent,
        );
      }
    });

    _startAutoScroll();
  }

  void _startAutoScroll() async {
    // print('_startAutoScroll called, isHovering: $_isHovering');
    
    if (!_isHovering) {
      await Future.delayed(Duration(seconds: 1));
      
      if (!mounted || _isHovering) {
        // print('Cannot start scroll - widget not mounted or hovering');
        return;
      }

      // print('Starting scroll animation');
      _animationController.forward();
    } else {
      // print('Not starting scroll - hover detected');
    }
  }

  void _handleHoverChange(bool isHovering) {
    // print('Hover state changed to: $isHovering');
    setState(() {
      _isHovering = isHovering;
    });
    
    if (isHovering) {
      // print('Pausing scroll');
      _animationController.stop();
    } else {
      // print('Resuming scroll');
      if (_animationController.value < 1) {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.items
            .map((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MouseRegion(
                    onEnter: (_) {
                      // print('Mouse entered');
                      _handleHoverChange(true);
                    },
                    onExit: (_) {
                      // print('Mouse exited');
                      _handleHoverChange(false);
                    },
                    child: item,
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  void dispose() {
    // print('Disposing widget');
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}