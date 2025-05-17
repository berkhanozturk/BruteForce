from gpt.internet_kontrol import internet_var_mi
from gpt.mentor_icerik import gpt_mentor
from gpt.gpt_api import gpt_mentorluk_mesaji

def hybrid_mentor(zihin_tipi, ogrenme_hizi, konu, kullanici_mesaji):
    if internet_var_mi():
        try:
            return gpt_mentorluk_mesaji(zihin_tipi, ogrenme_hizi, konu, kullanici_mesaji)
        except Exception as e:
            offline = gpt_mentor(konu, zihin_tipi, ogrenme_hizi)
            return f"🌐 GPT hata verdi, offline moda geçildi:\n\n{offline}"
    else:
        offline = gpt_mentor(konu, zihin_tipi, ogrenme_hizi)
        return f"📴 İnternet yok, offline mentor devrede:\n\n{offline}"
