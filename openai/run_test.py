# run_test.py

from gpt.hybrid_mentor import hybrid_mentor

cevap = hybrid_mentor("Keşifçi", "Dengeli", "Zaman Yönetimi", "Bugün hiçbir şeye odaklanamıyorum.")

print("Mentör Yanıtı:\n")
print(cevap)
