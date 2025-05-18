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

  void cevapSec(String zihinTipi) {
    setState(() {
      scores[zihinTipi] = (scores[zihinTipi] ?? 0) + 1;
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        final sonuc = _enYuksekPuan();
        _gptZihinTipiniGonder(sonuc);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GalaxyMapScreen(zihinTipi: sonuc),
          ),
        );
      }
    });
  }

  String _enYuksekPuan() {
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Future<void> _gptZihinTipiniGonder(String zihinTipi) async {
    try {
      await http.post(
        Uri.parse("http://127.0.0.1:5050/api/zihin"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "zihin_tipi": zihinTipi,
          "kullanici": "ZeynepSu",
        }),
      );
    } catch (e) {
      debugPrint("API bağlantı hatası: \$e");
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
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
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
                      shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ...soru['secenekler'].entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent.withOpacity(0.8),
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () => cevapSec(entry.value),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "\${currentQuestion + 1}/\${questions.length}",
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
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
