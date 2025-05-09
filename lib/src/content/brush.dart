import 'dart:ui';

import 'package:sketch_flow/sketch_contents.dart';

class Brush extends SketchContent {
  Brush({required super.points, required super.sketchConfig});

  @override
  void draw(Canvas canvas) {
    if (points.length < 2) return;

    for (int i=0; i<points.length-1; i++) {
      final p1 = points[i];
      final p2 = points[i+1];

      // calculation of the distance between two points
      final distance = (p2 - p1).distance;
      final speed = distance;

      double minThickness = sketchConfig.strokeThickness * 0.45;
      double maxThickness = sketchConfig.strokeThickness;

      // If draw it quickly, it becomes thinner
      double thickness = maxThickness - (speed * 0.5);

      // Avoid being too thin or too thick
      thickness = thickness.clamp(minThickness, maxThickness);

      final paint = Paint()
        ..color = sketchConfig.color.withValues(alpha: sketchConfig.opacity)
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'brush',
      'points': points.map((e) => {'dx': e.dx, 'dy': e.dy}).toList(),
      'color': sketchConfig.color.toARGB32(),
      'strokeThickness': sketchConfig.strokeThickness
    };
  }

}