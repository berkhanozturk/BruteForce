from gpt.mentor_icerik import gpt_mentor
from gpt.mentor_mesaj import mentor_mesaj, mentor_stili, mentor_tonu
from gpt.mesh_analiz import mesh_kolektif_mesaj, mesh_verisi
from gpt.stil_mesaj import gpt_stili_mesaj
from gpt.gorev_gecmisi import gorev_ozeti_etkisi
from gpt.ogrenme_adaptasyon import icerik_adaptasyonu

def mentor_cevabi(konu, zihin_tipi, ogrenme_hizi, skor_listesi, gorev_gecmisi):
    mesaj = gpt_mentor(konu, zihin_tipi, ogrenme_hizi)
    stil = mentor_stili(zihin_tipi)
    ton = mentor_tonu(skor_listesi)
    mesh = mesh_kolektif_mesaj(zihin_tipi, konu, mesh_verisi)
    gorev_hatirlatici = gorev_ozeti_etkisi(gorev_gecmisi)
    adaptif = icerik_adaptasyonu(konu, skor_listesi[-1] if skor_listesi else 60)

    parca = f"{mesaj}\n\n{adaptif}\n\n{gorev_hatirlatici}\n\n{mesh}"
    return gpt_stili_mesaj(stil, parca)
