# 📁 Dosya: gpt/anilar_modulu.py (stil destekli)
# 🔹 Görev: Görev geçmişinden kişisel anlatı üretir (Theatre of Echoes)

from gpt.kullanici_verisi import anilar_guncelle
from gpt.mentor_mesaj import mentor_stili

def ozet_yap(gorev, stil="Genel"):
    ad = gorev.get("ad", "bir görev")
    konu = gorev.get("konu", "bir konu")
    puan = gorev.get("puan", 50)
    tarih = gorev.get("tarih", "belirsiz zaman")

    if puan >= 80:
        cekirdek = f"Bu görevde harika bir başarı gösterdin. {konu} konusunda ustalaşmaya başladın."
    elif puan >= 60:
        cekirdek = f"Bazı zorluklara rağmen yolunu bulmayı başardın. {konu} üzerine düşünmeye devam ediyorsun."
    else:
        cekirdek = f"Görev senin için kolay olmadı ama bu deneyim seni geliştirecek. {konu} ile yüzleştin."

    if stil == "Hikâyeci":
        return f"📜 {tarih} - {ad}:Bir zamanlar bir yolcu {konu} ile yüzleşti... {cekirdek}"
    elif stil == "Stratejist":
        return f"📊 {tarih} | Görev: {ad} | Başarı: {puan}\nStratejik analiz: {cekirdek}"
    elif stil == "Şefkatli":
        return f"🤍 {tarih} - {ad}:Hissettiğini biliyorum. {cekirdek} Unutma, ilerleme bir süreçtir."
    elif stil == "Cesur Lider":
        return f"🔥 {tarih} - {ad}:Sen karanlıkla yürüyenlerdensin. {cekirdek}"
    else:
        return f"📜 {tarih} - {ad}: {cekirdek}"

def anilari_uret(veri):
    stil = mentor_stili(veri.get("zihin_tipi", "Genel"))
    anilar = []
    for gorev in veri.get("gorev_gecmisi", []):
        anilar.append(ozet_yap(gorev, stil))
    return anilar

def son_anilari_kaydet(veri):
    yeni_anilar = anilari_uret(veri)
    for metin in yeni_anilar:
        anilar_guncelle(veri, metin)