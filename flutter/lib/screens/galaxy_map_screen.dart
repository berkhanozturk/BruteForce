import 'dart:math';
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:zeynepgpt_ui/screens/odak_modulu_screen.dart';
import 'package:zeynepgpt_ui/screens/mesh_galaxy_screen.dart';

class GalaxyMapScreen extends StatefulWidget {
  final String zihinTipi;
  const GalaxyMapScreen({super.key, required this.zihinTipi});

  @override
  State<GalaxyMapScreen> createState() => _GalaxyMapScreenState();
}

class _GalaxyMapScreenState extends State<GalaxyMapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dinamik yıldız parçacık arka planı
          Positioned.fill(
            child: CircularParticle(
              awayRadius: 80,
              numberOfParticles: 150,
              speedOfParticles: 0.9,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              particleColor: Colors.white.withOpacity(0.4),
              awayAnimationDuration: const Duration(milliseconds: 800),
              maxParticleSize: 3,
              isRandSize: true,
              isRandomColor: false,
              connectDots: false,
            ),
          ),

          // Galaksi haritası görseli
          Positioned.fill(
            child: Image.asset('assets/galaxy_map.jpeg', fit: BoxFit.cover),
          ),

          // Başlık + Butonlar
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Galaksi Haritası",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 1. Satır Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStarButton(
                      context,
                      "🌟 Odak Galaksisi",
                      widget.zihinTipi == 'Odaklı',
                      OdakModuluScreen(zihinTipi: widget.zihinTipi),
                    ),
                    _buildStarButton(
                      context,
                      "💫 Keşif Alanı",
                      widget.zihinTipi == 'Keşifçi',
                      PlaceholderScreen(
                        title: "Keşif Modülü",
                        zihinTipi: widget.zihinTipi,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 2. Satır Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStarButton(
                      context,
                      "💓 Duygu Modülü",
                      widget.zihinTipi == 'Duyusal',
                      PlaceholderScreen(
                        title: "Duygu Modülü",
                        zihinTipi: widget.zihinTipi,
                      ),
                    ),
                    _buildStarButton(
                      context,
                      "⚡ Eylem Arenası",
                      widget.zihinTipi == 'Eylemci',
                      PlaceholderScreen(
                        title: "Eylem Modülü",
                        zihinTipi: widget.zihinTipi,
                      ),
                    ),
                    _buildStarButton(
                      context,
                      "🪐 Mesh Ağı Simülasyonu",
                      true,
                      const MeshGalaxyScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Alt mentör mesajı
          Positioned(
            bottom: 30,
            left: 20,
            child: Text(
              "🧭 Hazırsan ışınlanmaya başlayabiliriz 🌌",
              style: TextStyle(
                color: Colors.white70.withOpacity(_glowAnimation.value),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarButton(
    BuildContext context,
    String label,
    bool highlight,
    Widget screen,
  ) {
    return ScaleTransition(
      scale: _glowAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(
                _glowAnimation.value * 0.8,
              ),
              blurRadius: 20 * _glowAnimation.value,
              spreadRadius: 5 * _glowAnimation.value,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          gradient:
              highlight
                  ? RadialGradient(
                    colors: [
                      Colors.deepPurpleAccent.withOpacity(0.8),
                      Colors.deepPurple.withOpacity(0.5),
                    ],
                  )
                  : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.withOpacity(0.85),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 20,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder ekran – diğer modüller için geçici içerik
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String zihinTipi;
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.zihinTipi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "$title içeriği yakında burada olacak!\nZihin tipi: $zihinTipi",
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
