import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

/// Widget de scratch card mejorado con sonidos y efectos visuales
class ScratchCard extends StatefulWidget {
  final String hiddenText;
  final VoidCallback? onRevealed;

  const ScratchCard({
    super.key,
    required this.hiddenText,
    this.onRevealed,
  });

  @override
  State<ScratchCard> createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> with SingleTickerProviderStateMixin {
  final List<Offset> _scratchedPoints = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRevealed = false;
  bool _isScratching = false;
  double _scratchProgress = 0.0;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  static const _revealThreshold = 60;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 3).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _playScratchSound() {
    // Nota: Por ahora sin asset de sonido, pero la estructura está lista
    // _audioPlayer.play(AssetSource('sounds/scratch.mp3'), volume: 0.3);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isScratching = true;
    });
    _playScratchSound();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isRevealed) return;

    setState(() {
      _scratchedPoints.add(details.localPosition);
      _scratchProgress = math.min(_scratchedPoints.length / _revealThreshold, 1.0);
      
      if (_scratchedPoints.length > _revealThreshold && !_isRevealed) {
        _isRevealed = true;
        _isScratching = false;
        widget.onRevealed?.call();
      }
    });

    // Efecto de vibración visual
    _shakeController.forward(from: 0);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isScratching = false;
      _scratchedPoints.add(Offset.infinite); // Marcador para separar trazos
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * (math.Random().nextBool() ? 1 : -1),
            0,
          ),
          child: child,
        );
      },
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Builder(
            builder: (context) {
            // Usar MediaQuery en lugar de LayoutBuilder para evitar consultas intrínsecas
            final screenW = MediaQuery.of(context).size.width;
            final cardWidth = math.min(screenW * 0.9, 320.0);
            final maxCardHeight = MediaQuery.of(context).size.height * 0.45;
            final cardHeight = math.min(cardWidth * 0.64, maxCardHeight); // limitar altura para diálogos
            final scale = cardWidth / 280.0; // factor para escalar iconos y textos
              final theme = Theme.of(context);
              final onPrimary = theme.colorScheme.onPrimary;

            return Container(
              width: cardWidth,
              height: cardHeight,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20 * scale),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withAlpha((0.2 * 255).round()),
                    blurRadius: 12 * scale,
                    offset: Offset(0, 6 * scale),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20 * scale),
                child: Stack(
                  children: [
                    // Contenido oculto (el cupón)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                            theme.colorScheme.error,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.card_giftcard, size: 48 * scale, color: onPrimary),
                            SizedBox(height: 12 * scale),
                            Text(
                              widget.hiddenText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32 * scale,
                                fontWeight: FontWeight.bold,
                                color: onPrimary,
                                letterSpacing: 3 * scale,
                                shadows: [
                                  Shadow(
                                    color: theme.shadowColor.withAlpha((0.4 * 255).round()),
                                    offset: Offset(2 * scale, 2 * scale),
                                    blurRadius: 4 * scale,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8 * scale),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 6 * scale),
                              decoration: BoxDecoration(
                                color: onPrimary.withAlpha((0.3 * 255).round()),
                                borderRadius: BorderRadius.circular(20 * scale),
                              ),
                              child: Text(
                                '¡GANASTE!',
                                style: TextStyle(
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: onPrimary,
                                  letterSpacing: 2 * scale,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Capa de scratch (se va revelando)
                    if (!_isRevealed)
                      CustomPaint(
                        painter: _ScratchPainter(
                          _scratchedPoints,
                          strokeWidth: 45 * scale,
                          circleRadius: 22.5 * scale,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                    theme.colorScheme.onSurface.withAlpha((0.12 * 255).round()),
                                    theme.colorScheme.onSurface.withAlpha((0.08 * 255).round()),
                                    theme.colorScheme.onSurface.withAlpha((0.12 * 255).round()),
                                  ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Textura de puntos plateados
                              Positioned.fill(
                                child: CustomPaint(
                                      painter: _TexturePainter(scale, theme.colorScheme.onSurface.withAlpha((0.08 * 255).round())),
                                ),
                              ),
                              // Instrucciones
                              Center(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.8, end: _isScratching ? 1.2 : 1.0),
                                      duration: const Duration(milliseconds: 200),
                                      builder: (context, animScale, child) {
                                        return Transform.scale(
                                          scale: animScale,
                                          child: child,
                                        );
                                      },
                                        child: Icon(
                                        Icons.touch_app,
                                        size: 56 * scale,
                                        color: onPrimary.withAlpha((0.9 * 255).round()),
                                      ),
                                    ),
                                    SizedBox(height: 16 * scale),
                                    Text(
                                      '¡Rasca aquí!',
                                      style: TextStyle(
                                        fontSize: 22 * scale,
                                        fontWeight: FontWeight.bold,
                                        color: onPrimary.withAlpha((0.95 * 255).round()),
                                        letterSpacing: 1.5 * scale,
                                        shadows: [
                                          Shadow(
                                            color: theme.shadowColor.withAlpha((0.5 * 255).round()),
                                            offset: Offset(2 * scale, 2 * scale),
                                            blurRadius: 4 * scale,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8 * scale),
                                    Text(
                                      'Descubre tu premio',
                                      style: TextStyle(
                                        fontSize: 15 * scale,
                                        color: onPrimary.withAlpha((0.8 * 255).round()),
                                        letterSpacing: 0.8 * scale,
                                      ),
                                    ),
                                    SizedBox(height: 24 * scale),
                                    // Barra de progreso
                                    Container(
                                      width: cardWidth * 0.72,
                                      height: 10 * scale,
                                      decoration: BoxDecoration(
                                        color: onPrimary.withAlpha((0.3 * 255).round()),
                                        borderRadius: BorderRadius.circular(5 * scale),
                                        border: Border.all(
                                          color: onPrimary.withAlpha((0.5 * 255).round()),
                                          width: 1 * scale,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5 * scale),
                                        child: LinearProgressIndicator(
                                          value: _scratchProgress,
                                          backgroundColor: Colors.transparent,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            onPrimary.withAlpha((0.9 * 255).round()),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8 * scale),
                                    Text(
                                      '${(_scratchProgress * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 14 * scale,
                                        fontWeight: FontWeight.bold,
                                        color: onPrimary.withAlpha((0.8 * 255).round()),
                                      ),
                                    ),
                                  ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  final List<Offset> scratchedPoints;
  final double strokeWidth;
  final double circleRadius;

  _ScratchPainter(this.scratchedPoints, {this.strokeWidth = 45.0, this.circleRadius = 22.5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = ui.BlendMode.clear
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < scratchedPoints.length - 1; i++) {
      final current = scratchedPoints[i];
      final next = scratchedPoints[i + 1];
      
      if (!current.isInfinite && !next.isInfinite) {
        // Dibujar línea
        canvas.drawLine(current, next, paint);
        // Dibujar círculo en cada punto para mejor cobertura
        canvas.drawCircle(current, circleRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ScratchPainter oldDelegate) => true;
}

class _TexturePainter extends CustomPainter {
  final double scale;
  final Color dotColor;

  _TexturePainter(this.scale, this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5 * scale, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
