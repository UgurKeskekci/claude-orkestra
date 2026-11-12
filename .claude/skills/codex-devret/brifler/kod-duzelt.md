# Brif: kod düzelt (Codex, --yaz)

<!-- Claude: köşeli parantezleri doldur, gereksiz satırı sil. Kısa tut. -->

## Görev
[Tek cümle: ne bozuk ya da ne isteniyor. Örnek: "test.js'deki 3 başarısız testi geçir."]

## Bağlam
- Proje: [dil, çatı, nasıl çalıştırılır]
- Önce oku: [dosya1, dosya2] (yalnız bunlar; gerekirse yanındaki dosyalara bak)
- Beklenen davranış: [kural ya da belge, ör. belgeler/kurallar.md]

## Sınırlar
- Dokunma: [dosya/klasör, ör. testlerin kendisi, public API imzaları]
- Yeni bağımlılık ekleme.
- [Kod stili, dil, yorum dili]

## Doğrulama
- Çalıştır: `[komut, ör. node test.js]` ve tüm testler geçene kadar düzelt.
- Bitince aynı komutun son çıktısını özetine yaz.
