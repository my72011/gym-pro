import 'package:flutter/material.dart';

class FadeScaleTransition extends StatelessWidget {
  const FadeScaleTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.92 + (0.08 * t),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    required this.child,
  }) : super(listenable: animation);

  final Widget Function(BuildContext, Widget?) builder;
  final Widget child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}