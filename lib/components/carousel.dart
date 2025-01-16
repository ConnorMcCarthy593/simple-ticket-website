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
    if (!_isHovering) {
      await Future.delayed(Duration(seconds: 1));
      
      if (!mounted || _isHovering) {
        return;
      }

      _animationController.forward();
    }
  }

  void _handleHoverChange(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
    
    if (isHovering) {
      _animationController.stop();
    } else {
      if (_animationController.value < 1) {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group the items into rows, each containing at most 3 items
    List<List<Widget>> groupedItems = [];
    for (int i = 0; i < widget.items.length; i += 3) {
      groupedItems.add(widget.items.sublist(i, i + 3 > widget.items.length ? widget.items.length : i + 3));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Column(
        children: groupedItems.map((rowItems) {
          return Row(
            children: rowItems
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MouseRegion(
                        onEnter: (_) {
                          _handleHoverChange(true);
                        },
                        onExit: (_) {
                          _handleHoverChange(false);
                        },
                        child: item,
                      ),
                    ))
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}