
from flask import Flask, request, jsonify
from flask_cors import CORS
from gpt.gpt_api import gpt_cevabi_uret
from gpt.mesh_analiz import mesh_guncelle

app = Flask(__name__)
CORS(app)

@app.route("/api/cevap", methods=["POST"])
def cevap_ver():
    try:
        data = request.json
        soru = data.get("soru", "")
        zihin_tipi = data.get("zihin_tipi", "Keşifçi")
        gorev = data.get("gorev", "Bilinmeyen Görev")
        puan = data.get("puan", 50)

        # AI cevabı üret
        cevap = gpt_cevabi_uret(soru)

        # Zorlanma oranı hesapla (örnek eşik: 50)
        zorlanan_oran = 0.7 if puan < 50 else 0.3

        # Mesh'e güncelleme gönder
        mesh_guncelle(gorev, zihin_tipi, zorlanan_oran)

        return jsonify({
            "cevap": cevap,
            "mesh_durumu": f"{gorev} - {zihin_tipi} için güncellendi (%{int(zorlanan_oran * 100)} zorlanma)"
        })
    except Exception as e:
        return jsonify({"hata": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
