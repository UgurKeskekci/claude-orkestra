# Sepet kuralları

Bu küçük mağazanın ödeme hesabı aşağıdaki kurallara uymalı. Kod `sepet.js` ve `odeme.js` içinde.

1. **Ara toplam:** her ürün için `fiyat × adet`, hepsinin toplamı.
2. **İndirim kodları:**
   - `HOSGELDIN`: ara toplam en az 250 TL ise 50 TL düşer, altındaysa hiçbir şey düşmez.
   - `YUZDE10`: ara toplamın %10'u düşer.
   - Kodlar büyük/küçük harfe duyarsızdır, baştaki ve sondaki boşluk yok sayılır (`" yuzde10 "` geçerlidir).
   - Geçersiz kod hata vermez, indirim 0 olur.
   - İndirim hiçbir zaman ara toplamı geçemez.
3. **KDV:** %20, indirimden sonra eklenir.
4. **Kargo:** KDV dahil tutar 500 TL ve üstündeyse bedava, altındaysa 49,90 TL.
5. **Yuvarlama:** tüm tutarlar kuruşa (2 basamak) yuvarlanır.
