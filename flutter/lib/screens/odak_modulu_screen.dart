// odak_modulu_screen.dart – Odak Modülü Ekranı (Temel + Modüle Özel Eğitimli + ChatBot + Scroll Fix)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OdakModuluScreen extends StatefulWidget {
  const OdakModuluScreen({super.key});

  @override
  State<OdakModuluScreen> createState() => _OdakModuluScreenState();
}

class _OdakModuluScreenState extends State<OdakModuluScreen> {
  final TextEditingController _controller = TextEditingController();
  String _cevap = "";

  Future<void> _mentoraSor() async {
    final soru = _controller.text.trim();
    if (soru.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5050/api/cevap"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "soru": soru,
          "zihin_tipi": "Odaklı",
          "gorev": "📊 Veri Seti Sıralama Görevi",
          "puan": 40,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cevap = data["cevap"];
        });
      } else {
        setState(() {
          _cevap = "❌ API hatası: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _cevap = "❌ Hata: $e";
      });
    }

    _controller.clear();
  }

  Widget _buildTask(String title) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (_) {}),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/odak.jpeg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      // 👈 SCROLL ÖZELLİĞİ BURADA
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "📘 Temel Eğitimler",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTask("✅ Zaman Yönetimi 101"),
                          _buildTask("✅ Bilgi Okuryazarlığı"),
                          _buildTask("✅ Dijital Konsantrasyon Teknikleri"),

                          const SizedBox(height: 30),
                          const Text(
                            "🌟 Modüle Özel Görevler",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTask("📊 Veri Seti Sıralama Görevi"),
                          _buildTask("🧠 Odak Egzersizi (3-2-1 Tekniği)"),
                          _buildTask("📈 Dikkat Süresi Kaydı"),
                          _buildTask("🗓️ Mini Planlama Tablosu Oluştur"),

                          const SizedBox(height: 30),
                          if (_cevap.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _cevap,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Mentora bir şey sor...",
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.deepPurpleAccent,
                        ),
                        onPressed: _mentoraSor,
                      ),
                    ],
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
