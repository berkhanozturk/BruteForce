import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'galaxy_map_screen.dart';

class LightScannerScreen extends StatefulWidget {
  const LightScannerScreen({super.key});

  @override
  State<LightScannerScreen> createState() => _LightScannerScreenState();
}

class _LightScannerScreenState extends State<LightScannerScreen> {
  int currentQuestion = 0;
  Map<String, int> scores = {
    'Keşifçi': 0,
    'Duyusal': 0,
    'Odaklı': 0,
    'Eylemci': 0,
  };

  final List<Map<String, dynamic>> questions = [
    {
      'soru': 'Yeni bir şey öğrenirken en çok hangisini yaparsın?',
      'secenekler': {
        'Deney yaparım': 'Keşifçi',
        'Duygusal bağ kurarım': 'Duyusal',
        'Anlamlandırırım ve analiz ederim': 'Odaklı',
        'Hemen uygularım': 'Eylemci',
      },
    },
    {
      'soru': 'Bir problemi çözerken hangisi seni daha çok tatmin eder?',
      'secenekler': {
        'Yeni yollar denemek': 'Keşifçi',
        'Hikaye kurmak': 'Duyusal',
        'Sebep-sonuç ilişkisi kurmak': 'Odaklı',
        'Hızlıca çözmek': 'Eylemci',
      },
    },
    {
      'soru': 'Bir projeye başlarken önce ne yaparsın?',
      'secenekler': {
        'Keşfe çıkarım': 'Keşifçi',
        'Hislerimi dinlerim': 'Duyusal',
        'Plan yaparım': 'Odaklı',
        'Hemen başlarım': 'Eylemci',
      },
    },
    {
      'soru': 'İlham aldığın anlarda ne yaparsın?',
      'secenekler': {
        'Hayal kurarım': 'Keşifçi',
        'Duygulanırım': 'Duyusal',
        'Not alır ve düzenlerim': 'Odaklı',
        'İlk adımı hemen atarım': 'Eylemci',
      },
    },
    {
      'soru': 'Zamanını planlarken hangisine öncelik verirsin?',
      'secenekler': {
        'Keşif alanlarına yer bırakmak': 'Keşifçi',
        'Kendime zaman ayırmak': 'Duyusal',
        'Verimli program yapmak': 'Odaklı',
        'Uygulamaya dökmek': 'Eylemci',
      },
    },
    {
      'soru': 'Ekip çalışmasında hangi roldesin?',
      'secenekler': {
        'Fikirleri ortaya atan': 'Keşifçi',
        'Bağ kuran': 'Duyusal',
        'Organize eden': 'Odaklı',
        'Harekete geçiren': 'Eylemci',
      },
    },
  ];

  void cevapSec(String zihinTipi) async {
    setState(() {
      scores[zihinTipi] = (scores[zihinTipi] ?? 0) + 1;
    });

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      final sonuc = _enYuksekPuan();
      await _gptZihinTipiniGonder(sonuc);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ZihinSonucEkrani(zihinTipi: sonuc),
        ),
      );
    }
  }

  String _enYuksekPuan() {
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Future<void> _gptZihinTipiniGonder(String zihinTipi) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5050/api/zihin"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "zihin_tipi": zihinTipi,
          "kullanici": "ZeynepSu",
        }),
      );
      print("✅ API cevabı: ${response.statusCode} - ${response.body}");
    } catch (e) {
      print("❌ API bağlantı hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final soru = questions[currentQuestion];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/ikinciekran.png', fit: BoxFit.cover),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black.withOpacity(0.4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    soru['soru'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ...soru['secenekler'].entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => cevapSec(entry.value),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${currentQuestion + 1}/${questions.length}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ ZihinSonucEkrani ------------------

class ZihinSonucEkrani extends StatelessWidget {
  final String zihinTipi;
  const ZihinSonucEkrani({super.key, required this.zihinTipi});

  Color getGlowColor(String type) {
    switch (type) {
      case 'Keşifçi':
        return Colors.purpleAccent;
      case 'Duyusal':
        return Colors.pinkAccent;
      case 'Odaklı':
        return Colors.blueAccent;
      case 'Eylemci':
        return Colors.orangeAccent;
      default:
        return Colors.white;
    }
  }

  String getMentorMessage(String type) {
    switch (type) {
      case 'Keşifçi':
        return 'Sen fikirlerin evreninde bir gezginsin. Hayal gücünle sınırları aşabilirsin.';
      case 'Duyusal':
        return 'Sen duyguların rehberliğinde öğrenen birisin. Empatin çok kıymetli.';
      case 'Odaklı':
        return 'Sen düzenin ve netliğin ustasısın. Ama bazen kalbini de dinlemeyi unutma.';
      case 'Eylemci':
        return 'Sen harekete geçmeden duramayan bir yıldızsın. Ancak yönünü iyi seçmelisin.';
      default:
        return 'Zihnin bir ışık, onu hangi yöne odakladığın her şeyi değiştirir.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = getGlowColor(zihinTipi);
    final mesaj = getMentorMessage(zihinTipi);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [glowColor.withOpacity(0.4), Colors.black],
                  radius: 0.85,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [glowColor.withOpacity(0.6), Colors.transparent],
                      radius: 0.9,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Sen bir $zihinTipi'sin!",
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "🧭 Mentör'den Tavsiye:\n$mesaj",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: glowColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            GalaxyMapScreen(zihinTipi: zihinTipi),
                      ),
                    );
                  },
                  child: const Text("Galaksi Haritasına Git"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
