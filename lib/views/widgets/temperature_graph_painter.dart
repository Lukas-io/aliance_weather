import 'package:flutter/material.dart';
import 'package:aliance_weather/models/forecast_model.dart' as forecast;

class TemperatureGraphPainter extends CustomPainter {
  final List<forecast.HourlyForecast> hourlyData;
  final int currentTimeIndex;
  final Color lineColor;
  final Color fillColor;
  final Color currentTimeIndicatorColor;

  TemperatureGraphPainter({
    required this.hourlyData,
    required this.currentTimeIndex,
    this.lineColor = Colors.blue,
    this.fillColor = Colors.transparent,
    this.currentTimeIndicatorColor = Colors.orange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hourlyData.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Find min and max temperatures for scaling
    double minTemp = hourlyData.first.temp;
    double maxTemp = hourlyData.first.temp;

    for (final hour in hourlyData) {
      if (hour.temp < minTemp) minTemp = hour.temp;
      if (hour.temp > maxTemp) maxTemp = hour.temp;
    }

    // Add some padding to the range
    final tempRange = (maxTemp - minTemp).abs();
    minTemp -= tempRange * 0.1;
    maxTemp += tempRange * 0.1;

    if (tempRange == 0) {
      minTemp -= 1;
      maxTemp += 1;
    }

    // Calculate points
    final points = <Offset>[];
    final double widthPerHour = size.width / (hourlyData.length - 1);

    for (int i = 0; i < hourlyData.length; i++) {
      final hour = hourlyData[i];
      final x = i * widthPerHour;
      // Invert Y axis (0 is top, size.height is bottom)
      final y =
          size.height -
          30 -
          ((hour.temp - minTemp) / (maxTemp - minTemp)) * (size.height - 60);
      points.add(Offset(x, y));
    }

    // Draw the line
    if (points.isNotEmpty) {
      final path = Path();
      final fillPath = Path();

      path.moveTo(points[0].dx, points[0].dy);
      fillPath.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
        fillPath.lineTo(points[i].dx, points[i].dy);
      }

      // Close the fill path
      fillPath.lineTo(points.last.dx, size.height - 30);
      fillPath.lineTo(points.first.dx, size.height - 30);
      fillPath.close();

      // Draw fill
      canvas.drawPath(fillPath, fillPaint);

      // Draw line
      paint.color = lineColor;
      canvas.drawPath(path, paint);
    }

    // Draw data points, temperatures, and icons
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final hour = hourlyData[i];

      // Draw weather icon placeholder
      // Note: We can't directly draw SVGs on canvas, so we'll draw a colored circle instead
      // In the widget, we'll position SVGs over these points
      paint.color = lineColor;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(point.dx, point.dy - 20), 8, paint);

      // Draw max and min temperatures
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${hour.temp.toStringAsFixed(0)}°',
          style: const TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(point.dx - 10, point.dy - 40));

      // Draw time
      final hourText = '${hour.time.hour}:00';
      final timeTextPainter = TextPainter(
        text: TextSpan(
          text: hourText,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      timeTextPainter.layout();
      timeTextPainter.paint(canvas, Offset(point.dx - 10, size.height - 20));
    }

    // Draw current time indicator (dial/radar effect)
    if (currentTimeIndex >= 0 && currentTimeIndex < points.length) {
      final currentPoint = points[currentTimeIndex];

      // Draw outer circle (loosely opaque)
      paint.color = currentTimeIndicatorColor.withValues(alpha: 0.3);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 15, paint);

      // Draw inner circle (solid)
      paint.color = currentTimeIndicatorColor;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
