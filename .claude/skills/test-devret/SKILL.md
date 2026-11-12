---
name: test-devret
description: Web uygulamasının gerçek tarayıcıdaki testini TestSprite CLI'a devreder (isteğe bağlı). Claude testi kendisi koşturmaz, tarayıcı/ekran görüntüsü/log döngüsüne girmez; yalnız sonucu ve hata özetini okur, düzeltmeye karar verir. "test et", "testsprite", "testi devret", "site çalışıyor mu" denince ya da /yonet test parçasını verince kullan. claude-orkestra parçası.
---

# Testi devret (TestSprite, isteğe bağlı)

Testi Claude yaparsa tarayıcı açar, tıklar, ekran görüntüsü alır, log okur, tekrar dener: her adım
limitinden gider. Bu skill testi TestSprite CLI'a verir, sen yalnız sonucu okursun.

## Önce kontrol

```bash
command -v testsprite || echo "Kurulu değil: npm install -g @testsprite/testsprite-cli"
testsprite auth status >/dev/null 2>&1 || echo "Anahtar yok: kullanıcı terminalde testsprite setup çalıştırsın"
```

API anahtarını kullanıcı kendisi girer (`testsprite setup`); anahtarı sen isteme, yazma, brife koyma.
`testsprite setup` projeye TestSprite'ın kendi `testsprite-verify` skill'ini de kurar. O kuruluysa
ayrıntılı akış için onu izle; bu dosya kısa yoludur.

## Kısa akış

```bash
testsprite usage                                      # büyük koşudan önce kredi durumu
testsprite project list                               # proje kimliği
testsprite test list --project <proje-id>             # testler
testsprite test run <test-id> --wait --output json    # koştur, bitene kadar bekle
testsprite test failure summary <test-id>             # başarısızsa tek ekranlık özet
testsprite test rerun <test-id>                       # düzeltmeden sonra yeniden koştur
```

- `test run` çıkış kodu: 0 geçti, 1 başarısız/engellendi, 7 zaman aşımı (`testsprite test wait <run-id>`).
- `--target-url` herkese açık bir adres ister (yerel adres kabul etmez).
- Başarısız testte önce `failure summary` oku. Düzeltme çok dosyalıysa `/codex-devret` ile Codex'e ver,
  küçükse kendin yap; sonra yalnız ilgili testi yeniden koştur.
- Toplu test oluşturma ya da tüm testleri koşturma (`create-batch`, `run --all`) kredi harcar:
  kullanıcıya sormadan başlatma.

## Anahtarsız deneme

`--dry-run` ağa çıkmaz, örnek yanıt döner. Akışı öğrenmek için:

```bash
testsprite --dry-run --output text test list --project demo
testsprite --dry-run test failure summary demo-test
```

TestSprite: https://www.testsprite.com/?via=ugur-2611a
