// Bağımlılıksız testler: node test.js
const assert = require('node:assert/strict');
const { araToplam, indirim } = require('./sepet');
const { odeme, kargoUcreti } = require('./odeme');

const testler = [
  ['ara toplam adetleri sayar', () =>
    assert.equal(araToplam([{ fiyat: 100, adet: 2 }, { fiyat: 50, adet: 1 }]), 250)],
  ['HOSGELDIN 250 TL ve üstünde 50 düşer', () => assert.equal(indirim(300, 'HOSGELDIN'), 50)],
  ['HOSGELDIN 250 TL altında düşmez', () => assert.equal(indirim(200, 'HOSGELDIN'), 0)],
  ['YUZDE10 yüzde 10 düşer', () => assert.equal(indirim(300, 'YUZDE10'), 30)],
  ['geçersiz kod 0', () => assert.equal(indirim(300, 'YOKBOYLE'), 0)],
  ['500 TL tam sınırda kargo bedava', () => assert.equal(kargoUcreti(500), 0)],
  ['uçtan uca ödeme', () =>
    assert.deepEqual(odeme([{ fiyat: 200, adet: 2 }, { fiyat: 100, adet: 1 }], 'YUZDE10'),
      { ara: 500, indirim: 50, kdvli: 540, kargo: 0, toplam: 540 })],
];

let gecen = 0;
for (const [ad, fn] of testler) {
  try {
    fn();
    gecen += 1;
    console.log(`✓ ${ad}`);
  } catch (hata) {
    console.log(`✗ ${ad}: ${hata.message.split('\n')[0]}`);
  }
}
console.log(`\n${gecen}/${testler.length} test geçti`);
process.exit(gecen === testler.length ? 0 : 1);
