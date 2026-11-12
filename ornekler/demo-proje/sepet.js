// Sepet hesapları. Kurallar: belgeler/kurallar.md
// Bu dosyada bilerek bırakılmış hatalar var (claude-orkestra demosu).

const INDIRIMLER = {
  HOSGELDIN: { tur: 'sabit', deger: 50, enAz: 250 },
  YUZDE10: { tur: 'yuzde', deger: 10 },
};

function araToplam(urunler) {
  return urunler.reduce((toplam, urun) => toplam + urun.fiyat, 0);
}

function indirim(tutar, kod) {
  const tanim = INDIRIMLER[kod];
  if (!tanim) return 0;
  if (tanim.enAz && tutar < tanim.enAz) return 0;
  const dusulecek = tanim.tur === 'yüzde' ? (tutar * tanim.deger) / 100 : tanim.deger;
  return Math.min(dusulecek, tutar);
}

module.exports = { araToplam, indirim };
