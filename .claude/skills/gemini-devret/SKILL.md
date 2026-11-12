---
name: gemini-devret
description: Ağır okuma ve izleme işini Gemini'ye (Antigravity CLI, agy) devreder; Gemini kod yazmaz, rapor verir. Video ya da ses izletmek, uzun belge veya çok dosya okutmak, internet araştırması, başka bir modelin işini ikinci göz olarak denetletmek için kullan. "gemini'ye izlet", "gemini okusun", "videoyu izlet", "araştırsın", "denetlet" denince ya da /yonet bir okuma/izleme parçasını Gemini'ye verince kullan. claude-orkestra parçası.
---

# Gemini'ye devret

Uzun bir videoyu kare kare izlemek ya da yüzlerce dosyayı okumak senin limitini en çok yiyen iştir.
Bunu Gemini yapar, sen yalnız raporunu okursun. Gemini'ye kod yazdırma: okur, izler, araştırır, raporlar.

## Akış

1. **Brifi yaz.** Şablonlar bu skill'in `brifler/` klasöründe:
   - `video-izle.md`: videoyu/sesi izlet, saniyeli hata listesi al
   - `belge-oku.md`: uzun belge, klasör ya da kod tabanı özeti, soruya cevap
   - `arastirma.md`: internet araştırması, rakip ya da kütüphane karşılaştırması
   - `denetle.md`: Codex'in ya da senin yaptığın işe ikinci göz
   Dosya ve videoların **tam yolunu** yaz. Brifi `.orkestra/brif-<kisa-ad>.md` olarak kaydet.
2. **Çalıştır.** Proje kökünde. Uzun video ya da büyük okuma dakikalar sürebilir: `run_in_background`.

   ```bash
   sh <bu skill klasörü>/devret.sh .orkestra/brif-video.md
   sh <bu skill klasörü>/devret.sh --ekle ~/Videolar .orkestra/brif-video.md   # proje dışı klasör
   sh <bu skill klasörü>/devret.sh --model gemini-3.8-flash-low .orkestra/brif-kisa.md   # ucuz model
   ```

   Model listesi: `agy models`. `--model` vermezsen agy'nin varsayılanı kullanılır. Basit işte hızlı
   ve ucuz model, zor izleme ve denetimde güçlü model seç.
3. **Denetle.** Raporun tamamına inanma, en önemli 1-2 iddiayı kendin doğrula:
   - Video: söylenen saniyeden kare al ve bak: `ffmpeg -ss 9.5 -i video.mp4 -frames:v 1 .orkestra/kare.png`
   - Belge/kod: rapordaki `dosya:satır` yerini aç.
   Doğrulanmayan maddeyi kullanıcıya "doğrulanmadı" diye ilet ya da ele.
4. **Koruma uyarısı.** Betik sonunda "UYARI: Gemini şu dosyaları değiştirdi" yazarsa `git diff` ile bak,
   istenmeyen değişikliği geri al ve kullanıcıya söyle.
5. **Karar sende.** Rapordan çıkan düzeltme işi kod ise `/codex-devret`, küçükse kendin yap.

## Kurallar

- agy kurulu değilse ya da oturumu kapalıysa (`sh devret.sh --kontrol`) kullanıcıya söyle, işi kendin
  yap ya da küçük parçalara böl. Kurulum: `curl -fsSL https://antigravity.google/cli/install.sh | bash`,
  sonra bir kez `agy` ile Google girişi.
- Video okumak için agy izinleri otomatik onaylanır (`--dangerously-skip-permissions`). Bu yüzden
  Gemini'yi gizli dosyaların olduğu klasörde çalıştırma; brife şifre ya da anahtar koyma.
  Verdiğin dosyalar Google'ın hizmetine gider.
- Ağır izleme ve okuma için Claude alt ajanı (Task) açma: o da senin limitinden yer.
- Çıktılar `.orkestra/` altında: `gemini-<zaman>.md` rapor, `.json` ham yanıt, `.log` hata kaydı.
