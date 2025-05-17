def mentor_mesaj(zihin_tipi, basari_skoru):
    if zihin_tipi == "Keşifçi":
        if basari_skoru >= 80:
            return "🚀 Harikasın Keşifçi! Yeni bir bilgelik seviyesine ulaştın."
        elif basari_skoru >= 50:
            return "🧭 Yolculuk devam ediyor. Merakın seni doğru yöne götürüyor."
        else:
            return "🌪️ Her yolcu karanlık vadilerden geçer. Cesaretin ışığın olacak."
    elif zihin_tipi == "Duyusal":
        if basari_skoru >= 80:
            return "🌸 Mükemmel bir uyum! Duyularınla öğrenmenin farkını gösterdin."
        elif basari_skoru >= 50:
            return "💡 İyi gidiyorsun! Sadece biraz daha odak."
        else:
            return "🌧️ Her şey hissetmekle başlar. Daha dikkatli olabilirsin."
    elif zihin_tipi == "Odaklı":
        if basari_skoru >= 80:
            return "🎯 Harika bir isabet! Stratejin işe yarıyor."
        elif basari_skoru >= 50:
            return "🔍 Neredeyse oradaydın. Hedefi unutma!"
        else:
            return "📉 Hatalar büyümenin parçası. Tekrar dene."
    elif zihin_tipi == "Eylemci":
        if basari_skoru >= 80:
            return "🔥 Muhteşem hız ve kararlılıkla ilerledin!"
        elif basari_skoru >= 50:
            return "🏃‍♀️ Hızlıydın ama bir an dur, nefes al."
        else:
            return "💥 Hız bazen hata getirir. Denge kur, tekrar başla."

def mentor_stili(zihin_tipi):
    return {
        "Keşifçi": "Hikâyeci",
        "Odaklı": "Stratejist",
        "Duyusal": "Şefkatli",
        "Eylemci": "Cesur Lider"
    }.get(zihin_tipi, "Genel")

def mentor_tonu(basari_listesi):
    if len(basari_listesi) < 3:
        return "Nötr"
    trend = basari_listesi[-1] - basari_listesi[-3]
    if trend > 10:
        return "Gelişim"
    elif trend < -10:
        return "Destekleyici"
    else:
        return "İzleyici"
