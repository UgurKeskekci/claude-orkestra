---
name: codex-devret
description: Kod işini OpenAI Codex CLI'a (codex exec) brif vererek devreder ve sonucu diff ve testle denetler. Birden fazla dosyaya dokunan düzeltme, yeni özellik, test yazımı, refactor ya da kod incelemesi için kullan. "codex'e ver", "codex'e devret", "GPT düzeltsin", "kodu codex yazsın" denince ya da /yonet bir kod parçasını Codex'e verince kullan. claude-orkestra parçası.
---

# Codex'e devret

Sen yöneticisin: Codex kodu yazar, sen brifi yazar ve sonucu denetlersin. Codex'in harcadığı jeton
senin limitinden gitmez; sen yalnız onun kısa özetini ve diff'i okursun.

**Devretme:** tek dosyada birkaç satırlık düzeltme. Brif yazmak, işi yapmaktan uzun sürer; kendin yap.

## Akış

1. **Brifi yaz.** Şablonlar bu skill'in `brifler/` klasöründe:
   - `kod-duzelt.md`: hata düzeltme, özellik, test yazımı (dosya yazar, `--yaz` ister)
   - `kod-incele.md`: salt okunur inceleme, hata avı, ikinci göz
   Brifi projede `.orkestra/brif-<kisa-ad>.md` olarak kaydet. Kısa ve hedefli olsun: okunacak dosyaları
   adıyla yaz, "her şeyi oku" deme; doğrulama komutunu ve dokunulmayacak yerleri yaz. Brife şifre,
   API anahtarı, `.env` içeriği koyma.
2. **Çalıştır.** Komutlar proje kökünde. Codex işi dakikalar sürebilir: Bash'te `run_in_background`
   ile başlat, bitince çıktıyı oku. Beklerken başka bağımsız işe devam edebilirsin.

   ```bash
   sh <bu skill klasörü>/devret.sh --yaz .orkestra/brif-sepet.md      # dosya yazar
   sh <bu skill klasörü>/devret.sh .orkestra/brif-incele.md           # salt okunur
   sh <bu skill klasörü>/devret.sh --efor medium --yaz .orkestra/brif-x.md   # rutin iş, daha az kota
   ```

   Seçenekler: `--klasor DIR` (varsayılan bulunduğun klasör), `--efor low|medium|high`, `--model AD`.
   Rutin işte `--efor medium` kullan; Codex kotası da sınırsız değil.
3. **Denetle.** Codex'in özetine körü körüne güvenme:
   - `git diff` ile değişikliğe bak (betik `--stat` listesini basar). Brif dışı dosyaya dokunduysa sor.
   - Testi ya da doğrulama komutunu kendin çalıştır.
   - Büyük ya da riskli değişiklikte ikinci göz iste: `/gemini-devret` ile `denetle.md` şablonu.
4. **Döngü sınırı.** Sonuç eksikse en fazla bir tur daha, eksiği saniye/satır düzeyinde tarif eden yeni
   brifle. İkinci turdan sonra kalan küçük işi kendin bitir ya da kullanıcıya sor. Modeller birbirini
   sonsuza kadar düzeltmesin.
5. **Raporla.** Kullanıcıya kısaca: Codex ne yaptı, sen neyi doğruladın, ne kaldı.

## Kurallar

- Codex kurulu değilse ya da oturumu kapalıysa (`sh devret.sh --kontrol`) kullanıcıya söyle ve işi
  kendin yap. Kurulum: `npm install -g @openai/codex`, `codex login`.
- Betik Codex'i her zaman korumalı kipte çalıştırır (`read-only` ya da `--yaz` ile `workspace-write`).
  `--dangerously-bypass-approvals-and-sandbox` kullanma.
- Aynı dosyalara aynı anda iki ajan yazmasın.
- Çıktılar `.orkestra/` altında: `codex-<zaman>.md` özet, `.log` tam kayıt. Logu yalnız hata olursa oku.
