import json

# Mesh verisini dışarıdan alabileceğin fonksiyon
with open("mesh_data.json", "r", encoding="utf-8") as f:
    mesh_verisi = json.load(f)

def mesh_kolektif_mesaj(zihin_tipi, görev_adı, mesh_verisi):
    try:
        oran = mesh_verisi[görev_adı][zihin_tipi]["zorlanan_oran"]
        yuzde = int(oran * 100)
        if oran > 0.5:
            return f"⚠️ Mesh Uyarısı: {zihin_tipi.lower()}ların %{yuzde}'ı '{görev_adı}' görevinde zorlandı."
        else:
            return f"✅ Mesh Bilgisi: '{görev_adı}' görevi çoğu {zihin_tipi.lower()} için olumlu sonuç verdi (%{100 - yuzde} başarı)."
    except:
        return "📡 Mesh ağı bu görev için yeterli veri içermiyor."
    

def mesh_guncelle(gorev_adi, zihin_tipi, zorlanan_oran, json_yolu="mesh_data.json"):
    import json
    try:
        with open(json_yolu, "r", encoding="utf-8") as f:
            veri = json.load(f)
    except FileNotFoundError:
        veri = {}

    if gorev_adi not in veri:
        veri[gorev_adi] = {}

    veri[gorev_adi][zihin_tipi] = {"zorlanan_oran": zorlanan_oran}

    with open(json_yolu, "w", encoding="utf-8") as f:
        json.dump(veri, f, indent=2, ensure_ascii=False)
    
