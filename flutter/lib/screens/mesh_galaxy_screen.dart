import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String meshDurumu = "Mesh ağı hazırlanıyor...";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _generatePoints();
    _meshAgiCagir();
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

  Future<void> _meshAgiCagir() async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5050/api/mesh"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "kullanici": "ZeynepSu",
          "cihaz_sayisi": _pointCount,
          "zihin_tipi": "Odaklı"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          meshDurumu = data["mesh_durumu"] ?? "Mesh başarılı fakat mesaj alınamadı.";
        });
      } else {
        setState(() {
          meshDurumu = "❌ Sunucu hatası: \${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        meshDurumu = "❌ Bağlantı hatası: \$e";
      });
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
                  children: [
                    const Icon(Icons.wifi, color: Colors.lightBlueAccent, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      meshDurumu,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);

    final transformed = points.map((p) {
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
