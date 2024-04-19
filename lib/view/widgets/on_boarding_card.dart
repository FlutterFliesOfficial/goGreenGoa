import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final Onboarding onboarding;

  const OnboardingCard({
    required this.onboarding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Text(
            onboarding.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Text(
            onboarding.description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class Onboarding {
  String title;
  String description;
  String image;

  Onboarding({
    required this.image,
    required this.title,
    required this.description,
  });
}

class FadeInDown extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeInDown({
    required this.child,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  _FadeInDownState createState() => _FadeInDownState();
}

class _FadeInDownState extends State<FadeInDown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0.0, -50 + (50 * _animation.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class FadeInUp extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeInUp({
    required this.child,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  _FadeInUpState createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0.0, 50 - (50 * _animation.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
