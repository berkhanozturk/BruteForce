import openai
import os
from dotenv import load_dotenv

# Ortam değişkenlerini yükle (.env içinden API anahtarını almak için)
load_dotenv()

# OpenAI API anahtarı alınır
api_key = os.getenv("OPENAI_API_KEY") or "sk-..."  # Dilersen doğrudan buraya da yazabilirsin
openai.api_key = api_key

def gpt_cevabi_uret(soru, zihin_tipi="Keşifçi", konu="Odaklanma", hiz="orta"):
    zihin_aciklamalari = {
        "Keşifçi": "Meraklı, sınırları zorlayan, yeni yollar denemeyi seven.",
        "Duyusal": "Duygularıyla öğrenen, empatik ve iç görü odaklı.",
        "Odaklı": "Analitik, planlı, dikkatli, verimlilik odaklı.",
        "Eylemci": "Pratik, harekete geçmeyi seven, uygulama odaklı.",
        "Çok Yönlü": "Tüm tiplerden özellikler taşıyan, dengeli düşünen."
    }

    karakter_ozeti = zihin_aciklamalari.get(zihin_tipi, "Karma yapılı bir birey.")

    prompt = f"""
Sen kişiselleştirilmiş bir eğitim mentorusün.

🧠 Kullanıcının zihin tipi: {zihin_tipi}
🧬 Zihin tipi açıklaması: {karakter_ozeti}
⚡️ Öğrenme hızı: {hiz}
📚 Konu: {konu}

Kullanıcının sorusu:
"{soru}"

Lütfen bu kişinin zihin yapısına en uygun şekilde cevap ver.
Cevabın sade, net ve bilgi dolu olsun. Uzun açıklamalardan kaçın.
1-2 cümlede özü ver, gerekiyorsa küçük bir sayısal örnek de kullan.
"""

    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "Sen kişiselleştirilmiş bir mentor yapay zekasısın."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.6,
            max_tokens=120
        )

        return response["choices"][0]["message"]["content"].strip()
    except Exception as e:
        return f"❌ GPT API Hatası: {str(e)}"
