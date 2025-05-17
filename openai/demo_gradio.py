# 📁 Dosya: demo_gradio.py (güncel + anı butonu entegre)

import gradio as gr
from gpt.hybrid_mentor import hybrid_mentor
from gpt.mentor_icerik import gpt_mentor
from gpt.internet_kontrol import internet_var_mi
from gpt.mesh_analiz import mesh_kolektif_mesaj, mesh_verisi
from gpt.kullanici_verisi import veri_yukle, veri_kaydet, gorev_ekle, basari_ekle
from gpt.anilar_modulu import son_anilari_kaydet, anilari_uret

zihin_tipleri = ["Keşifçi", "Odaklı", "Duyusal", "Eylemci"]
ogrenme_hizlari = ["Yavaş", "Dengeli", "Hızlı"]
konular = ["Karar Verme", "Zaman Yönetimi", "İçsel Motivasyon", "Hedef Belirleme"]

is_online = internet_var_mi()

if is_online:
    def mentor_arayuz(zihin, hiz, konu, mesaj):
        try:
            yanit = hybrid_mentor(zihin, hiz, konu, mesaj)
            puan = 80
        except Exception as e:
            yanit = gpt_mentor(konu, zihin, hiz)
            puan = 60

        veri = veri_yukle()
        gorev_ekle(veri, ad=konu, konu=konu, puan=puan)
        basari_ekle(veri, konu, puan)
        veri_kaydet(veri)

        mesh = mesh_kolektif_mesaj(zihin, konu, mesh_verisi)
        return f"{yanit}\n\n📡 Mesh:\n{mesh}"

    def anilar_goster():
        veri = veri_yukle()
        son_anilari_kaydet(veri)
        veri_kaydet(veri)
        anilar = anilari_uret(veri)
        return "\n\n".join(anilar)

    demo = gr.TabbedInterface(
        [
            gr.Interface(
                fn=mentor_arayuz,
                inputs=[
                    gr.Dropdown(zihin_tipleri, label="🧠 Zihin Tipi"),
                    gr.Dropdown(ogrenme_hizlari, label="⚡ Öğrenme Hızı"),
                    gr.Dropdown(konular, label="📚 Konu"),
                    gr.Textbox(label="💬 Mentora Mesajın")
                ],
                outputs=gr.Textbox(label="🧠 Mentor Yanıtı"),
                title="ZeynepGPT - Online Hibrit Mentör"
            ),
            gr.Interface(
                fn=anilar_goster,
                inputs=[],
                outputs=gr.Textbox(label="📖 Anıların"),
                title="Theatre of Echoes"
            )
        ],
        tab_names=["Mentor", "Anılar"]
    )
else:
    def offline_arayuz(zihin, hiz, konu):
        yanit = gpt_mentor(konu, zihin, hiz)
        puan = 50

        veri = veri_yukle()
        gorev_ekle(veri, ad=konu, konu=konu, puan=puan)
        basari_ekle(veri, konu, puan)
        veri_kaydet(veri)

        mesh = mesh_kolektif_mesaj(zihin, konu, mesh_verisi)
        return f"📄 {yanit}\n\n📡 Mesh:\n{mesh}"

    def anilar_goster():
        veri = veri_yukle()
        son_anilari_kaydet(veri)
        veri_kaydet(veri)
        anilar = anilari_uret(veri)
        return "\n\n".join(anilar)

    demo = gr.TabbedInterface(
        [
            gr.Interface(
                fn=offline_arayuz,
                inputs=[
                    gr.Dropdown(zihin_tipleri, label="🧠 Zihin Tipi"),
                    gr.Dropdown(ogrenme_hizlari, label="⚡ Öğrenme Hızı"),
                    gr.Dropdown(konular, label="📚 Konu")
                ],
                outputs=gr.Textbox(label="📄 Offline Mentor Yanıtı"),
                title="ZeynepGPT - Offline Mod"
            ),
            gr.Interface(
                fn=anilar_goster,
                inputs=[],
                outputs=gr.Textbox(label="📖 Anıların"),
                title="Theatre of Echoes"
            )
        ],
        tab_names=["Mentor", "Anılar"]
    )

if __name__ == "__main__":
    demo.launch(server_port=7860, inbrowser=True)
