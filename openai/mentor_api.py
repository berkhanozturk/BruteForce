from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Flutter'dan erişimi sağlamak için

@app.route('/api/chat', methods=['POST'])
def chat_mentoru():
    data = request.get_json()
    user_message = data.get("message", "")

    # Dummy cevap – sonra GPT modeli ile entegre edilebilir
    cevap = generate_dummy_response(user_message)

    return jsonify({"cevap": cevap})

def generate_dummy_response(msg):
    # Şimdilik basit cevaplar
    if "görev" in msg.lower():
        return "İlk olarak 'Zaman Yönetimi 101' görevine başlayabilirsin."
    elif "motivasyon" in msg.lower():
        return "Sen bu galaksinin en parlak yıldızısın! Devam et 💫"
    elif "selam" in msg.lower():
        return "Selam! Hazırsan öğrenmeye ışınlanıyoruz. 🚀"
    else:
        return "Sorduğun şeyi tam anlayamadım ama birlikte çözebiliriz!"

if __name__ == '__main__':
    app.run(port=5050)
