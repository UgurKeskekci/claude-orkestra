# Brif: ikinci göz, denetle (Gemini)

<!-- Claude: köşeli parantezleri doldur. Yapanın kim olduğunu ve neyi hedeflediğini söyle, kod geçmişini verme. -->

Başka bir model şu işi yaptı: [tek cümle görev]
Hedef: [kabul ölçütü, ör. belgeler/kurallar.md'deki kurallar, testler]
İncele: [değişen dosyalar ya da diff dosyası yolu, ör. .orkestra/son.diff] ve gerekirse [ilgili dosya]

Bul:
1. Hedefe uymayan davranış (yanlış hesap, eksik durum, kenar değer)
2. Testlerin yakalamadığı ama yanlış olan şey
3. Gereksiz ya da kapsam dışı değişiklik

Her madde: `dosya:satır · sorun · neden`, en ciddiden başla, en fazla 8 madde. Sorun yoksa "sorun bulmadım" yaz.
Düzeltme kodu yazma, yalnız raporla. Emin olmadığın maddeyi "şüpheli" diye işaretle.
