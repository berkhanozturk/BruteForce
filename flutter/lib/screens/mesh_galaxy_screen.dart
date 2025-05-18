// mesh_galaxy_screen.dart – Galaktik Mesh Ağı Ekranı

import 'dart:math';
import 'package:flutter/material.dart';

class MeshGalaxyScreen extends StatefulWidget {
  const MeshGalaxyScreen({super.key});

  @override
  State<MeshGalaxyScreen> createState() => _MeshGalaxyScreenState();
}

class _MeshGalaxyScreenState extends State<MeshGalaxyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  final List<Offset> _points = [];
  final int _pointCount = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _generatePoints();
  }

  void _generatePoints() {
    final random = Random();
    for (int i = 0; i < _pointCount; i++) {
      _points.add(
        Offset(
          0.2 + 0.6 * random.nextDouble(),
          0.2 + 0.6 * random.nextDouble(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/galaxy_map.jpeg', fit: BoxFit.cover),
              ),
              CustomPaint(
                size: screenSize,
                painter: _MeshPainter(_points, _rotation.value),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wifi, color: Colors.lightBlueAccent, size: 60),
                    SizedBox(height: 12),
                    Text(
                      "Luminia Mesh Ağı Oluşturuluyor...",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // GERİ BUTONU
              Positioned(
                top: 40,
                right: 20,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final List<Offset> points;
  final double rotation;

  _MeshPainter(this.points, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueAccent.withOpacity(0.6)
          ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);

    final transformed =
        points.map((p) {
          final dx = (p.dx - 0.5) * size.width;
          final dy = (p.dy - 0.5) * size.height;
          final x = dx * cos(rotation) - dy * sin(rotation);
          final y = dx * sin(rotation) + dy * cos(rotation);
          return center + Offset(x, y);
        }).toList();

    for (final p1 in transformed) {
      for (final p2 in transformed) {
        if ((p1 - p2).distance < 150) {
          canvas.drawLine(p1, p2, paint);
        }
      }
    }

    for (final p in transformed) {
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
