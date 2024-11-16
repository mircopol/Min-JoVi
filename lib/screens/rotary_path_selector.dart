import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RotaryPathSelector extends StatefulWidget {
  const RotaryPathSelector({Key? key}) : super(key: key);

  @override
  _RotaryPathSelectorState createState() => _RotaryPathSelectorState();
}

class _RotaryPathSelectorState extends State<RotaryPathSelector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _startRotation = 0.0;
  double _rotation = 0.0;
  
  final List<String> paths = [
    'Daily Journaling',
    'Fitness',
    'Mental Health',
    'Business',
    'Your Own Goal',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _startRotation = _rotation;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final center = renderBox.size.center(Offset.zero);
    final touchPoint = details.localPosition;
    
    final angle = atan2(
      touchPoint.dy - center.dy,
      touchPoint.dx - center.dx,
    );
    
    setState(() {
      _rotation = _startRotation + angle;
      // Dodaj wibrację przy każdym znaczącym ruchu
      HapticFeedback.mediumImpact();
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Dodaj dźwięk przy zakończeniu ruchu
    SystemSound.play(SystemSoundType.click);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Choose Your Path',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Transform.rotate(
                      angle: _rotation,
                      child: CustomPaint(
                        painter: RotaryPainter(paths: paths),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RotaryPainter extends CustomPainter {
  final List<String> paths;
  
  RotaryPainter({required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Rysuj półkole
    final rect = Rect.fromCircle(center: center, radius: radius - 20);
    canvas.drawArc(rect, -pi/2, pi, false, paint);

    // Rysuj znaczniki i tekst
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < paths.length; i++) {
      final angle = -pi/2 + (pi * i / (paths.length - 1));
      final markerPoint = Offset(
        center.dx + (radius - 40) * cos(angle),
        center.dy + (radius - 40) * sin(angle),
      );

      // Rysuj znacznik
      canvas.drawCircle(markerPoint, 5, paint..style = PaintingStyle.fill);

      // Rysuj tekst
      textPainter.text = TextSpan(
        text: paths[i],
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      
      final textPoint = Offset(
        markerPoint.dx - textPainter.width / 2,
        markerPoint.dy - 20,
      );
      textPainter.paint(canvas, textPoint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}