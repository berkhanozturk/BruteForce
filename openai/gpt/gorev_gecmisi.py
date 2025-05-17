def gorev_ozeti_etkisi(gorev_gecmisi):
    if not gorev_gecmisi:
        return "📂 Henüz görev geçmişin bulunmuyor. Bugün bir başlangıç olabilir."

    son_gorev = gorev_gecmisi[-1]
    if son_gorev.get("tamamlandi", False):
        return f"✅ Son görevini başarıyla tamamladın: {son_gorev['ad']}. Bunu unutma, devam et."
    else:
        return f"📌 Son görev yarım kalmış olabilir: {son_gorev['ad']}. Belki şimdi tamamlama zamanı."


def gorev_etiketi(gorev):
    # Görev içeriğine göre kısa etiket üretir (isteğe bağlı destek fonksiyon)
    if "karar" in gorev.lower():
        return "Karar Verme"
    elif "zaman" in gorev.lower():
        return "Zaman Yönetimi"
    elif "motive" in gorev.lower():
        return "İçsel Motivasyon"
    else:
        return "Genel Görev"
