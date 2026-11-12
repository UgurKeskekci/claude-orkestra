// Ödeme özeti: ara toplam, indirim, KDV, kargo. Kurallar: belgeler/kurallar.md

const { araToplam, indirim } = require('./sepet');

const KDV = 0.2;
const BEDAVA_KARGO_SINIRI = 500;
const KARGO = 49.9;

const yuvarla = (x) => Math.round(x * 100) / 100;

function kargoUcreti(kdvliTutar) {
  return kdvliTutar > BEDAVA_KARGO_SINIRI ? 0 : KARGO;
}

function odeme(urunler, kod) {
  const ara = yuvarla(araToplam(urunler));
  const dusen = yuvarla(indirim(ara, kod));
  const kdvli = yuvarla((ara - dusen) * (1 + KDV));
  const kargo = kargoUcreti(kdvli);
  return { ara, indirim: dusen, kdvli, kargo, toplam: yuvarla(kdvli + kargo) };
}

module.exports = { odeme, kargoUcreti };
