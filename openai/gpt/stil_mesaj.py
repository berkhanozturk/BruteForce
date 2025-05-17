def gpt_stili_mesaj(stil, ana_mesaj):
    if stil == "Hikâyeci":
        return f"🗺️ Bir zamanlar senin gibi bir yolcu vardı... {ana_mesaj}"
    elif stil == "Stratejist":
        return f"📊 Hedefe ulaşmak için: {ana_mesaj}"
    elif stil == "Şefkatli":
        return f"🤍 Hatırla, sen değerlisin. {ana_mesaj}"
    elif stil == "Cesur Lider":
        return f"🔥 Şimdi harekete geç: {ana_mesaj}"
    else:
        return f"🧠 {ana_mesaj}"