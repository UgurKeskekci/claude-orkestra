# Demo proje: hatalı sepet

İlk deneme için küçük bir Node.js projesi. İçinde bilerek bırakılmış hatalar var: bazılarını testler
yakalıyor, en az birini yakalamıyor. Bağımlılık yok, Node.js 18 ve üstü yeter.

```bash
node test.js     # 3/7 test geçti
```

## Deneme

Repoyu bozmamak için demoyu bir kopyada çalıştırın:

```bash
cp -R ornekler/demo-proje ~/orkestra-deneme
cd ~/orkestra-deneme
git init -q && git add -A && git commit -qm "ilk hal"
claude
```

Claude Code'a şunu yazın:

```text
/yonet testleri geçir. Sonra kodu belgeler/kurallar.md'ye göre bir de Gemini'ye denetlet.
```

Beklenen akış: Claude işi böler, düzeltmeyi Codex'e verir, testleri kendisi çalıştırır, Codex'in
değişikliğini Gemini'ye denetletir. `belgeler/kurallar.md` içinde testlerin kapsamadığı bir kural var
(indirim kodu büyük/küçük harfe duyarsız): Codex onu da düzeltti mi, düzeltmediyse Gemini yakaladı mı, bakın.

Bizim denememizde (macOS, 2026-11) Codex 7/7 testi geçirdi ve harf kuralını da düzeltti. Gemini'nin
denetimi testlerin kapsamadığı bir kuruş hatası buldu: 10,05 TL'lik sepete `YUZDE10` uygulanınca indirim
1,01 yerine 1 çıkıyor. Siz denediğinizde modeller farklı şeyler bulabilir; önemli olan Claude'un her
bulguyu kendisi doğrulaması.
