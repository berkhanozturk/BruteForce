import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'screens/lightscanner.dart';

void main() => runApp(const LuminiaGalaksiApp());

class LuminiaGalaksiApp extends StatelessWidget {
  const LuminiaGalaksiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ElegantSplashScreen(),
    );
  }
}

class ElegantSplashScreen extends StatefulWidget {
  const ElegantSplashScreen({super.key});

  @override
  State<ElegantSplashScreen> createState() => _ElegantSplashScreenState();
}

class _ElegantSplashScreenState extends State<ElegantSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  Offset pointerOffset = const Offset(0, 0);
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🔥 SplashScreen build() çalıştı");

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: MouseRegion(
        onHover: (event) => setState(() => pointerOffset = event.localPosition),
        child: Stack(
          children: [
            // 1. Parallax arka plan
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(
                  (pointerOffset.dx - screenSize.width / 2) * -0.005,
                  (pointerOffset.dy - screenSize.height / 2) * -0.005,
                ),
                child: Image.asset('assets/girisekran.jpeg', fit: BoxFit.cover),
              ),
            ),

            // 2. Yıldız tozu partikülleri
            CircularParticle(
              key: UniqueKey(),
              awayRadius: 80,
              numberOfParticles: 120,
              speedOfParticles: 0.8,
              height: screenSize.height,
              width: screenSize.width,
              particleColor: Colors.white.withOpacity(0.6),
              awayAnimationDuration: const Duration(milliseconds: 600),
              maxParticleSize: 2.5,
              isRandSize: true,
              isRandomColor: false,
              connectDots: false,
            ),

            // 3. Metinler ve buton – Fade-in animasyonla
            Center(
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Luminia’ya Hoş Geldin',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black87, blurRadius: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Zihnin bir evren.\nHer ışık bir seçim.\nHer yıldız bir yolculuk.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 🔁 MouseRegion ile uyumlu hale getirildi
                    MouseRegion(
                      onEnter: (_) => setState(() => hovering = true),
                      onExit: (_) => setState(() => hovering = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white70),
                          boxShadow:
                              hovering
                                  ? [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                  : [],
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                          ),
                          onPressed: () async {
                            print("🟢 DİYALOĞU AÇIYORUZ");

                            final result = await showDialog<bool>(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    backgroundColor: Colors.black87,
                                    title: const Text(
                                      '✨ Başlıyoruz',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: const Text(
                                      'Zihin tipin tanımlanacak. Hazır mısın?',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          print("🟣 EVET'E BASILDI");
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: const Text(
                                          'Evet',
                                          style: TextStyle(
                                            color: Colors.purpleAccent,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(ctx).pop(false),
                                        child: const Text(
                                          'Hayır',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            print("🟡 DIALOG KAPANDI. RESULT: $result");

                            if (result == true) {
                              print("🚀 SAYFA AÇILIYOR...");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LightScannerScreen(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            '✨ Yıldız Yolculuğunu Başlat',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
  }
}
