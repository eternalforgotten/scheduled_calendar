import 'package:flutter/material.dart';

class HeroAnimation extends StatelessWidget {
  final Widget child;
  final Object tag;
  final bool isHorizontalCalendar;

  const HeroAnimation({
    super.key,
    required this.child,
    required this.tag,
    required this.isHorizontalCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return isHorizontalCalendar
            ? toHeroContext.widget
            : FadeTransition(
                opacity:
                    const AlwaysStoppedAnimation(0), // No animation while pop
                child: toHeroContext.widget,
              );
      },
      child: Material(
        // Need for correct display of fonts during transition
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}