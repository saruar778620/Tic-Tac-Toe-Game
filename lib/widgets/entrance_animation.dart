import 'package:flutter/widgets.dart';

class EntranceAnimation extends StatelessWidget {
  const EntranceAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.distance = 0.14,
  });

  final Animation<double> animation;
  final Widget child;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: Offset(0, distance),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
