import 'package:flutter/material.dart';

import 'color_theme.dart';
import 'utilities.dart';

class StarsLoadCircular extends StatefulWidget {
  final double? size;
  const StarsLoadCircular({Key? key, this.size}) : super(key: key);

  @override
  _StarsLoadCircularState createState() => _StarsLoadCircularState();
}

class _StarsLoadCircularState extends State<StarsLoadCircular>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    animationController.forward();
    animationController.addListener(() {
      // setState(() {
      if (animationController.status == AnimationStatus.completed) {
        animationController.repeat();
      }
      // });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
          child: Icon(
            Icons.star_outline_rounded,
            color: primary,
            size: widget.size ?? wXD(25, context),
          ),
        ),
      ),
    );
  }
}
