def ogrenme_hizi_skor(skorlar):
    if not skorlar:
        return "Dengeli"
    ortalama = sum(skorlar) / len(skorlar)
    if ortalama < 40:
        return "Yavaş"
    elif ortalama > 75:
        return "Hızlı"
    return "Dengeli"

def icerik_adaptasyonu(konu, skor):
    if skor > 80:
        return f"🎯 Bu konuyu oldukça iyi kavradın: {konu}. Yeni bir modüle geçebilirsin."
    elif skor < 50:
        return f"🔁 Bu konuda tekrar yapmanı öneririm: {konu}. Alternatif anlatımlar işine yarayabilir."
    else:
        return f"➡️ {konu} konusunda ilerliyorsun. Devam et, sonra özet çıkaralım."
