import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CelebrationConfetti extends StatefulWidget {
  final Widget child;
  final bool shouldPlay;

  const CelebrationConfetti({
    super.key,
    required this.child,
    this.shouldPlay = false,
  });

  @override
  State<CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<CelebrationConfetti> {
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerLeft;
  late ConfettiController _controllerRight;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 3));
    _controllerLeft = ConfettiController(duration: const Duration(seconds: 3));
    _controllerRight = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void didUpdateWidget(CelebrationConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPlay && !oldWidget.shouldPlay) {
      _playConfetti();
    }
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerLeft.dispose();
    _controllerRight.dispose();
    super.dispose();
  }

  void _playConfetti() {
    _controllerCenter.play();
    _controllerLeft.play();
    _controllerRight.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Confetti central (parte superior centro)
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirection: 1.57, // radianes hacia abajo
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
            shouldLoop: false,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.error,
              Theme.of(context).colorScheme.onPrimary,
              Theme.of(context).colorScheme.onSurface,
              Theme.of(context).dividerColor,
            ],
          ),
        ),
        // Confetti izquierda
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _controllerLeft,
            blastDirection: 0.785, // 45 grados hacia derecha-abajo
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.3,
            shouldLoop: false,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.error,
              Theme.of(context).colorScheme.onSurface,
              Theme.of(context).dividerColor,
            ],
          ),
        ),
        // Confetti derecha
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _controllerRight,
            blastDirection: 2.356, // 135 grados hacia izquierda-abajo
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.3,
            shouldLoop: false,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.error,
              Theme.of(context).colorScheme.onSurface,
              Theme.of(context).dividerColor,
            ],
          ),
        ),
      ],
    );
  }
}
