import 'package:flutter/material.dart';

class FadeEntryWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeEntryWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
  });

  @override
  State<FadeEntryWrapper> createState() => _FadeEntryWrapperState();
}

class _FadeEntryWrapperState extends State<FadeEntryWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos FadeTransition para opacidad y SlideTransition para un efecto sutil de subida
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03), // Empieza un poco más abajo (5%)
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}