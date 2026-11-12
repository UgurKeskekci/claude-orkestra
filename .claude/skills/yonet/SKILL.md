---
name: yonet
description: Büyük, çok adımlı bir işi yönetici gibi böler ve dağıtır. Ağır okuma, video izleme ve araştırmayı Gemini'ye, çok dosyalı kod işini Codex'e, tarayıcı testini TestSprite'a (isteğe bağlı) verir; Codex ve Gemini yoksa okumayı Haiku, kodu Sonnet alt ajanına verir; sonucu denetler, kararı kendisi verir. "yönet", "işi böl", "dağıt", "orkestra", "limitim bitmesin" denince ya da büyük bir iş geldiğinde kullan. claude-orkestra parçası.
---

# Yönet

Sen bir şirketin yöneticisi gibisin: plan yapar, işi dağıtır, sonucu kontrol eder, kararı verirsin.
Emeği (uzun okuma, izleme, çok dosyalı kod, test koşturma) başkaları yapar. Limitin karar ve kalite
kontrolüne kalır.

## 1. Kim hazır?

Kardeş skill'lerin betikleriyle kontrol et. `<skills klasörü>` bu skill'in klasörünün bir üstüdür
(ör. `~/.claude/skills` ya da projede `.claude/skills`):

```bash
sh <skills klasörü>/codex-devret/devret.sh --kontrol
sh <skills klasörü>/gemini-devret/devret.sh --kontrol
command -v testsprite >/dev/null && testsprite auth status >/dev/null 2>&1 && echo "TestSprite hazır"
```

Codex yoksa kod işi `sonnet-yazici`, Gemini yoksa okuma işi `haiku-okuyucu` alt ajanına gider (`kur.sh`
ile gelir). İkisi de yoksa sadece Claude modunda çalışırsın: kullanıcıya bir kez söyle, işi yine böl.
Video izleme Gemini'siz olmaz; gerekirse ffmpeg ile kare alıp kendin bakarsın.

## 2. Böl

İşi parçalara ayır ve kullanıcıya tek tablo göster:

| Parça | Kim | Neden | Çıktı |
| --- | --- | --- | --- |
| Rakip oyunların videolarını izle, mekanikleri çıkar | Gemini | uzun video, çok okuma | saniyeli not listesi |
| Ekonomi tablosunu koda dök, testleri yaz | Codex | çok dosyalı kod | diff + test sonucu |
| Uygulamayı tarayıcıda test et | TestSprite | tıkla/ekran görüntüsü döngüsü | hata özeti |
| Plan, birleştirme, son karar | Sen | karar | kullanıcıya rapor |

Bölme ölçütü:
- **Gemini:** video/ses izlemek, uzun belge ya da çok dosya okumak, internet araştırması, ikinci göz denetimi.
  Kod yazdırma.
- **Codex:** birden fazla dosyaya dokunan düzeltme, yeni özellik, test yazımı, refactor, kod incelemesi.
- **TestSprite:** gerçek tarayıcıda uçtan uca test (kuruluysa).
- **Haiku / Sonnet (Codex ya da Gemini yoksa):** okuma, arama, test sonucu getirme `haiku-okuyucu`; çok
  dosyalı kod `sonnet-yazici`. Çağırırken model seçme, alt ajan dosyasındaki model geçerli.
- **Sen:** plan, karar, kalite kontrolü, küçük ve tek dosyalık işler, kullanıcıyla konuşma.

İş büyükse ya da geri dönüşü zorsa (silme, yayına alma, çok dosyayı değiştirme) tabloyu gösterip onay al.
Değilse tabloyu gösterip başla.

## 3. Brifle ve dağıt

- Her parça için ilgili skill'in `brifler/` şablonundan kısa brif yaz, `.orkestra/brif-<ad>.md` olarak kaydet.
- Brif hedefli olsun: okunacak dosyalar, beklenen çıktı biçimi, dokunulmayacak yerler, doğrulama komutu.
- Bağımsız parçaları aynı anda başlat (Bash `run_in_background`). Aynı dosyalara iki ajan aynı anda yazmasın.
- Sıra gerekiyorsa bekle: önce araştırma (Gemini), sonra kod (Codex), sonra test.

## 4. Denetle

- Codex ya da Sonnet: `git diff` ve testleri kendin çalıştır.
- Gemini: rapordaki en önemli 1-2 iddiayı karede, satırda ya da kaynakta doğrula.
- Kritik değişiklikte çapraz denetim: Codex'in işini Gemini'ye (`denetle.md`), Gemini'nin bulgusunu
  Codex'e (`kod-incele.md`) baktır. Kodu yazan model kendi hatasını kolay görmez.
- Sonucu körü körüne kabul etme. Yanlış öneriyi gerekçesiyle ele.

## 5. Döngüye girme

Aynı parça için en fazla 2 düzelt-denetle turu. Sonra kalan küçük işi kendin bitir ya da kullanıcıya sor.
"O onu düzeltir, bu bunu düzeltir" diye dönmek hem kotayı hem zamanı yer.

## 6. Raporla

Kullanıcıya kısaca: kim ne yaptı, sen neyi doğruladın, ne kaldı, sıradaki karar ne.
Ölçmediğin bir şeyi (hız, kalite puanı, jeton tasarrufu) yazma; betiklerin bastığı jeton sayısını
olduğu gibi aktarabilirsin.
