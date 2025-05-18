import 'package:flutter/material.dart';
import 'package:zeynepgpt_ui/screens/odak_modulu_screen.dart';

class GalaxyMapScreen extends StatelessWidget {
  final String zihinTipi;
  const GalaxyMapScreen({super.key, required this.zihinTipi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan görseli – yıldız haritası
          Positioned.fill(
            child: Image.asset('assets/galaxy_map.jpeg', fit: BoxFit.cover),
          ),

          // Görevler: Yıldızlar (butonlar)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStarButton(
                      context,
                      "🌟 Odak Galaksisi",
                      zihinTipi == 'Odaklı',
                      const OdakModuluScreen(),
                    ),
                    _buildStarButton(
                      context,
                      "💫 Keşif Alanı",
                      zihinTipi == 'Keşifçi',
                      const PlaceholderScreen(title: "Keşif Modülü"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStarButton(
                      context,
                      "💓 Duygu Modülü",
                      zihinTipi == 'Duyusal',
                      const PlaceholderScreen(title: "Duygu Modülü"),
                    ),
                    _buildStarButton(
                      context,
                      "⚡ Eylem Arenası",
                      zihinTipi == 'Eylemci',
                      const PlaceholderScreen(title: "Eylem Modülü"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Başlık
          const Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Galaksi Haritası",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
            ),
          ),

          // Mentör mesajı
          const Positioned(
            bottom: 30,
            left: 20,
            child: Text(
              "🧭 Hazırsan ışınlanmaya başlayabiliriz 🌌",
              style: TextStyle(color: Colors.white70, fontSize: 16),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        boxShadow:
            highlight
                ? [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
                : [],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 12,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Geçici placeholder ekranlar (sadece 1 modül tam olduğu için)
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "$title içeriği yakında burada olacak!",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
