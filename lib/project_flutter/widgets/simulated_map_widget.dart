import 'package:flutter/material.dart';

class MapMarker {
  final String label;
  final int aqi;
  final Offset position; // normalized 0.0 to 1.0 coordinates
  final Color color;

  MapMarker({
    required this.label,
    required this.aqi,
    required this.position,
    required this.color,
  });
}

class SimulatedMapWidget extends StatelessWidget {
  final List<MapMarker> markers;
  final Function(MapMarker)? onMarkerTap;

  const SimulatedMapWidget({
    super.key,
    required this.markers,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFE2F1ED), // Light teal background representing land
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // 1. Draw Map Vectors (roads, rivers, parks) using CustomPaint
                Positioned.fill(
                  child: CustomPaint(
                    painter: MapBackgroundPainter(),
                  ),
                ),
                // 2. Render Markers
                ...markers.map((marker) {
                  final x = marker.position.dx * constraints.maxWidth;
                  final y = marker.position.dy * constraints.maxHeight;

                  return Positioned(
                    left: x - 25,
                    top: y - 25,
                    child: GestureDetector(
                      onTap: () {
                        if (onMarkerTap != null) {
                          onMarkerTap!(marker);
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: marker.color,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  child: Text(
                                    '${marker.aqi}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  marker.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Pin pointer
                          CustomPaint(
                            size: const Size(10, 6),
                            painter: PinPointerPainter(color: marker.color),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final riverPaint = Paint()
      ..color = const Color(0xFF90CAF9).withOpacity(0.6)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final narrowRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final forestPaint = Paint()
      ..color = const Color(0xFFA5D6A7).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw Parks (forest areas)
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.1, size.width * 0.3, size.height * 0.2),
      forestPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.75),
      size.width * 0.2,
      forestPaint,
    );

    // Draw River
    final riverPath = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(
        size.width * 0.3, size.height * 0.25,
        size.width * 0.4, size.height * 0.65,
        size.width, size.height * 0.6,
      );
    canvas.drawPath(riverPath, riverPaint);

    // Draw Primary Roads
    final roadPath1 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.2, size.height);
    canvas.drawPath(roadPath1, roadPaint);

    final roadPath2 = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5);
    canvas.drawPath(roadPath2, roadPaint);

    // Draw Secondary Roads
    final roadPath3 = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.15, size.width, size.height * 0.8);
    canvas.drawPath(roadPath3, narrowRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PinPointerPainter extends CustomPainter {
  final Color color;

  PinPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
