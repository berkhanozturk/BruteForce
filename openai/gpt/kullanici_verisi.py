# 📁 Dosya: gpt/kullanici_verisi.py
# 🔹 Görev: Tüm kullanıcı verisini merkezi bir JSON dosyasında tutar ve yönetir

import json
import os
from datetime import datetime

VERI_DOSYASI = "kullanici_verisi.json"

# 📥 Veriyi yükle (dosya varsa oku, yoksa boş profil oluştur)
def veri_yukle():
    if not os.path.exists(VERI_DOSYASI):
        return {
            "id": "kullanici1",
            "zihin_tipi": None,
            "ogrenme_hizi": None,
            "gorev_gecmisi": [],
            "basari_skorlari": {},
            "anilar": [],
            "mesh_log": {}
        }
    with open(VERI_DOSYASI, "r", encoding="utf-8") as f:
        return json.load(f)

# 💾 Veriyi kaydet
def veri_kaydet(veri):
    with open(VERI_DOSYASI, "w", encoding="utf-8") as f:
        json.dump(veri, f, ensure_ascii=False, indent=2)

# ✅ Görev tamamlandığında geçmişe ekle
def gorev_ekle(veri, ad, konu, puan, tamamlandi=True):
    veri["gorev_gecmisi"].append({
        "ad": ad,
        "konu": konu,
        "puan": puan,
        "tamamlandi": tamamlandi,
        "tarih": datetime.now().strftime("%Y-%m-%d")
    })

# 📊 Başarı skoruna göre analiz veri girişi
def basari_ekle(veri, konu, puan):
    if konu not in veri["basari_skorlari"]:
        veri["basari_skorlari"][konu] = []
    veri["basari_skorlari"][konu].append(puan)

# ✨ Anı ekle (mentor hikayesi gibi)
def anilar_guncelle(veri, metin):
    veri["anilar"].append(metin)

# 🌐 Mesh verisini yerel olarak güncelle
def mesh_guncelle(veri, konu, zihin_tipi, zorlandi=False):
    if konu not in veri["mesh_log"]:
        veri["mesh_log"][konu] = {}
    if zihin_tipi not in veri["mesh_log"][konu]:
        veri["mesh_log"][konu][zihin_tipi] = {"zorlanan": 0, "tamamlayan": 0}
    if zorlandi:
        veri["mesh_log"][konu][zihin_tipi]["zorlanan"] += 1
    else:
        veri["mesh_log"][konu][zihin_tipi]["tamamlayan"] += 1
