import 'package:flutter/material.dart';
import 'dart:math' as math;

class SunTrajectoryPainter extends CustomPainter {
  final String sunriseTime;
  final String sunsetTime;
  final DateTime currentTime;
  final bool isDaytime;
  final Color trajectoryColor;
  final Color passedTrajectoryColor;
  final Color sunColor;

  SunTrajectoryPainter({
    required this.sunriseTime,
    required this.sunsetTime,
    required this.currentTime,
    required this.isDaytime,
    this.trajectoryColor = Colors.grey,
    this.passedTrajectoryColor = Colors.yellow,
    this.sunColor = Colors.orange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = math.min(size.width / 2 - 20, size.height - 40);

    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw the semi-circle trajectory (dotted line)
    paint.color = trajectoryColor;
    paint.strokeCap = StrokeCap.round;

    // Draw dotted semi-circle
    for (double i = 0; i <= math.pi; i += 0.1) {
      final startX = center.dx + radius * math.cos(i);
      final startY = center.dy - radius * math.sin(i);

      final endX = center.dx + radius * math.cos(i + 0.1);
      final endY = center.dy - radius * math.sin(i + 0.1);

      // Draw dash
      if ((i / 0.1).toInt().isEven) {
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    }

    // Calculate sun position
    final sunPosition = _calculateSunPosition(
      sunriseTime,
      sunsetTime,
      currentTime,
      center,
      radius,
    );

    // Draw passed trajectory (colored line)
    if (sunPosition.angle > 0) {
      paint.color = passedTrajectoryColor;
      paint.style = PaintingStyle.stroke;

      final rect = Rect.fromCircle(center: center, radius: radius);
      final startAngle = math.pi;
      final sweepAngle = math.pi - sunPosition.angle;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }

    // Draw sunrise time
    final sunrisePainter = TextPainter(
      text: TextSpan(
        text: sunriseTime,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    sunrisePainter.layout();
    sunrisePainter.paint(
      canvas,
      Offset(center.dx - radius - 20, center.dy - 10),
    );

    // Draw sunset time
    final sunsetPainter = TextPainter(
      text: TextSpan(
        text: sunsetTime,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    sunsetPainter.layout();
    sunsetPainter.paint(
      canvas,
      Offset(center.dx + radius + 10, center.dy - 10),
    );

    // Draw sun/moon
    paint.color = sunColor;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(sunPosition.position, 10, paint);
  }

  SunPosition _calculateSunPosition(
    String sunrise,
    String sunset,
    DateTime currentTime,
    Offset center,
    double radius,
  ) {
    try {
      // Parse sunrise and sunset times
      final sunriseParts = sunrise.split(':');
      final sunsetParts = sunset.split(':');

      if (sunriseParts.length < 2 || sunsetParts.length < 2) {
        return SunPosition(const Offset(0, 0), 0);
      }

      final sunriseHour = int.parse(sunriseParts[0]);
      final sunriseMinute = int.parse(sunriseParts[1]);
      final sunsetHour = int.parse(sunsetParts[0]);
      final sunsetMinute = int.parse(sunsetParts[1]);

      // Convert to DateTime for today
      final today = DateTime.now();
      final sunriseDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        sunriseHour,
        sunriseMinute,
      );
      final sunsetDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        sunsetHour,
        sunsetMinute,
      );

      // Handle case where sunset is next day (crosses midnight)
      final adjustedSunset = sunsetDateTime.isBefore(sunriseDateTime)
          ? sunsetDateTime.add(const Duration(days: 1))
          : sunsetDateTime;

      // Calculate total daylight duration
      final totalDuration = adjustedSunset.difference(sunriseDateTime);
      final elapsedDuration = currentTime.difference(sunriseDateTime);

      // Calculate angle (0 to pi radians for semi-circle)
      double angle = 0;
      if (elapsedDuration.isNegative) {
        angle = 0; // Before sunrise
      } else if (elapsedDuration > totalDuration) {
        angle = math.pi; // After sunset
      } else {
        final progress = elapsedDuration.inSeconds / totalDuration.inSeconds;
        angle = progress * math.pi;
      }

      // Calculate position on semi-circle
      final x = center.dx + radius * math.cos(math.pi - angle);
      final y = center.dy - radius * math.sin(angle);

      return SunPosition(Offset(x, y), angle);
    } catch (e) {
      // Return default position if parsing fails
      return SunPosition(Offset(center.dx - radius, center.dy), 0);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SunPosition {
  final Offset position;
  final double angle;

  SunPosition(this.position, this.angle);
}
