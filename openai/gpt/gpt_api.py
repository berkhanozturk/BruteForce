import openai
import os
from openai import OpenAI
from gpt.mesh_analiz import mesh_guncelle


# Anahtar .env'den alınacaksa:
from dotenv import load_dotenv
load_dotenv()

api_key = os.getenv("OPENAI_API_KEY") or "sk-..."  # doğrudan da verebilirsin
client = OpenAI(api_key=api_key)

def gpt_mentorluk_mesaji(zihin_tipi, ogrenme_hizi, konu, kullanici_mesaji, model="gpt-3.5-turbo"):
    prompt = f"""
Sen bir yapay zekâ destekli eğitim mentörüsün.

Kullanıcının zihin tipi: {zihin_tipi}
Öğrenme hızı: {ogrenme_hizi}
Konu: {konu}
Kullanıcının sorusu: "{kullanici_mesaji}"

Bu bilgilere göre kişisel, destekleyici ve içgörü dolu bir cevap ver.
    """

    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": "Sen kişiselleştirilmiş bir mentor yapay zekasısın."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=400
    )

    return response.choices[0].message.content

def gpt_cevabi_uret(soru, zihin_tipi="Keşifçi", konu="Bilinmeyen", hiz="orta"):
    return gpt_mentorluk_mesaji(zihin_tipi, hiz, konu, soru)
