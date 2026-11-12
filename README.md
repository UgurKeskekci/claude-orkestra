# Claude Orkestra

Claude Code'u yönetici yapın, ağır işi Gemini ve Codex yapsın. Claude limitinin çoğu akıllı kararlarda
değil, emek isteyen işte bitiyor: yüzlerce dosyayı okumak, uzun bir videoyu kare kare izlemek, testi
tarayıcıda tekrar tekrar koşturmak. Bu repo o işi zaten ödediğiniz diğer aboneliklere devreder:

```text
                 Claude Code (Opus): plan, karar, kalite kontrolü
                 /                    |                     \
   Gemini (agy)                Codex (codex exec)        TestSprite CLI (isteğe bağlı)
   video izler, okur,          çok dosyalı kodu           uygulamayı gerçek tarayıcıda
   araştırır, denetler         düzeltir, test yazar        test eder
                 \                    |                     /
                  kısa rapor ──> Claude kontrol eder ve karar verir
```

Claude videoyu izlemez, yüz dosyayı okumaz; diğer modelin birkaç satırlık raporunu okur, önemli yeri
kendisi doğrular, kararı verir. Diğer modellerin harcadığı jeton Claude limitinizden gitmez.

Bu düzeni anlattığım video: [Claude Code Limitin Neden Bitiyor? 2 Aydır Limite Takılmadım](https://youtu.be/x3VBHymfU40)

## Neler var

| Parça | Ne işe yarar |
| --- | --- |
| [`yonetici-kurallari.md`](yonetici-kurallari.md) | Asıl iş: Claude'a kime hangi işi vereceğini söyleyen birkaç satır. `CLAUDE.md`'nize eklenir. |
| `/yonet` | Büyük işi böler: kim, ne, neden. Dağıtır, denetler, raporlar. |
| `/codex-devret` | Kod işini Codex'e brifle verir, sonra diff ve testle denetler. |
| `/gemini-devret` | Video izletir, uzun belge okutur, araştırma ya da ikinci göz denetimi yaptırır. Gemini kod yazmaz. |
| `/test-devret` | İsteğe bağlı: tarayıcı testini TestSprite CLI'a verir. |
| [`doktor.sh`](doktor.sh) | Araçlar kurulu mu, oturum açık mı, kontrol eder. |
| [`kur.sh`](kur.sh) | Skill'leri ve kuralları Claude Code'a ekler. |
| [`ornekler/demo-proje`](ornekler/demo-proje) | Bilerek hatalı küçük bir proje: ilk deneme için. |

Devasa kural dosyaları yazmanız gerekmiyor. Opus işi bölmeyi zaten iyi yapıyor; ona kimin ne yaptığını
bir kere söylemek yetiyor. Skill'ler ve betikler kolaylık: brifi dosyaya yazar, diğer modeli doğru
ayarlarla çağırır, uzun çıktıyı dosyada tutup Claude'a yalnız özeti verir.

## Ne gerekiyor

| Araç | Hesap | Şart mı |
| --- | --- | --- |
| [Claude Code](https://claude.com/claude-code) | Claude aboneliği | Evet, yönetici bu |
| [Codex CLI](https://github.com/openai/codex) | ChatGPT hesabı | Codex ya da Gemini, en az biri |
| [Antigravity CLI](https://antigravity.google) (`agy`, Gemini) | Google hesabı | Codex ya da Gemini, en az biri |
| [TestSprite CLI](https://www.testsprite.com/?via=ugur-2611a) | TestSprite hesabı | Hayır, test için |

Hepsini almak zorunda değilsiniz. Elinizde hangi abonelik varsa onu çalıştırın; kurulu olmayan aracın
işini Claude kendisi yapar. Ayrıca `git` (değişikliği denetlemek için), `node` ya da `python3` gerekir;
video işinde `ffmpeg` de işe yarar. Geliştirme ve denemeler macOS'ta yapıldı. Betikler düz POSIX `sh`;
Linux'ta ve Windows'ta (Claude Code'un kullandığı Git Bash ile) çalışması beklenir ama ayrıca denenmedi.

## 3 adımda başlayın

### 1. Repoyu Claude Code'a verin

Claude Code'u açın ve şunu yazın:

```text
https://github.com/UgurKeskekci/claude-orkestra bu sistemi kur
```

Claude repoyu indirir, `doktor.sh` ile neyin eksik olduğuna bakar, eksik aracı kurmanızı ister, skill'leri
kurar ve Codex ile Gemini'ye birer küçük deneme sorusu sorar. Giriş adımlarını (ChatGPT, Google, TestSprite
hesabı) siz yaparsınız; Claude şifre ya da anahtar istemez.

### 2. Demo projede deneyin

```bash
cp -R claude-orkestra/ornekler/demo-proje ~/orkestra-deneme
cd ~/orkestra-deneme
git init -q && git add -A && git commit -qm "ilk hal"
claude
```

Claude Code'a:

```text
/yonet testleri geçir. Sonra kodu belgeler/kurallar.md'ye göre bir de Gemini'ye denetlet.
```

Claude işi böler, düzeltmeyi Codex'e verir, testleri kendisi çalıştırır, Codex'in değişikliğini Gemini'ye
denetletir. Demoda testlerin kapsamadığı bir kural da var (indirim kodu büyük/küçük harfe duyarsız olmalı):
Codex onu da düzeltti mi, düzeltmediyse Gemini yakaladı mı, ona bakın. İkinci göz tam bu iş için.

### 3. Kendi işinizde kullanın

Kurallar yüklendikten sonra çoğu zaman komut yazmanız bile gerekmez, Claude işi kendisi dağıtır.
Elle istemek isterseniz:

```text
/gemini-devret kayit.mp4 videosunu izlesin, kesik kelime ve donuk ekranları saniyesiyle getirsin
/codex-devret ödeme akışındaki yuvarlama hatasını düzeltsin, testleri geçirsin
/yonet rakip 5 oyunun mağaza sayfalarını araştır, ekonomi tablosu çıkar, bizim oyuna uygula
```

## Elle kurulum

Her aracı bir kez kurup giriş yapın, sonra repoyu ekleyin.

**Claude Code**

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude
```

İlk açılışta Claude hesabınızla giriş yapın.

**Codex CLI (ChatGPT)**

```bash
npm install -g @openai/codex
codex login
```

`codex login` tarayıcıda ChatGPT girişini açar. ChatGPT masaüstü uygulaması kuruluysa macOS'ta Codex CLI
uygulamanın içinde de gelir; betikler onu da bulur. Başka bir yerdeyse `CODEX_BIN=/yol/codex` verin.

**Antigravity CLI (Gemini)**

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
agy
```

Windows için PowerShell: `irm https://antigravity.google/cli/install.ps1 | iex`. İlk `agy` açılışında
Google hesabınızla giriş yapıp çıkın. Hangi modellerin açık olduğunu `agy models` gösterir; kota
aboneliğinize göre değişir.

**Bu repo**

```bash
git clone https://github.com/UgurKeskekci/claude-orkestra
cd claude-orkestra
sh doktor.sh            # neyin hazır olduğunu gösterir, kota harcamaz
sh kur.sh               # tüm projeler: ~/.claude/skills ve ~/.claude/CLAUDE.md
sh doktor.sh --canli    # Codex ve Gemini'ye birer küçük soru (az kota)
```

Yalnız bir projeye kurmak için `sh kur.sh ~/projem`. Geri almak için `sh kur.sh --kaldir` (ya da
`sh kur.sh --kaldir ~/projem`). `kur.sh` var olan `CLAUDE.md`'nizi silmez: kuralları işaretli bir bloğa
yazar, eski dosyayı `~/.claude/orkestra-yedek/` altına yedekler.

## Nasıl çalışıyor

Skill'ler iki küçük betiği çağırır. Elle de kullanabilirsiniz:

```bash
# Codex: varsayılan salt okunur, --yaz ile yalnız proje klasörüne yazar
sh .claude/skills/codex-devret/devret.sh --yaz --efor medium brif.md

# Gemini: okur ve izler; proje dışındaki klasörü --ekle ile verin
sh .claude/skills/gemini-devret/devret.sh --ekle ~/Videolar brif.md
```

- Brifin sonuna betik "kısa rapor ver" kuralını ekler. Diğer modelin tüm çalışma kaydı projede `.orkestra/`
  klasörüne yazılır, Claude yalnız özeti okur. `.orkestra/` kendini git'ten gizler.
- Betikler diğer modelin harcadığı jeton sayısını basar (Claude'un limitinden gitmeyen kısım).
- Codex her zaman korumalı kipte çalışır: inceleme `read-only`, düzeltme `workspace-write`.
- Gemini'nin video okuyabilmesi için agy izinleri otomatik onaylanır. Gemini'ye yalnız okuma işi verilir;
  yine de bir dosyayı değiştirirse betik sonunda uyarı basar.
- Brif şablonları skill klasörlerinde: [Codex](.claude/skills/codex-devret/brifler/),
  [Gemini](.claude/skills/gemini-devret/brifler/). İyi brif kısadır: okunacak dosyalar, beklenen çıktı,
  dokunulmayacak yerler, doğrulama komutu.

## İşe yarayan kurallar

- **Kalite kararı Claude'da.** İşi başkası yaptı diye sonuç körü körüne kabul edilmez: diff'e bakılır,
  test çalıştırılır, önemli iddia karede ya da satırda doğrulanır.
- **Kodu yazan model kendi hatasını kolay görmez.** Kritik işte öbür modele denetletin: Codex yazar,
  Gemini bakar ya da tersi.
- **Döngüye girmeyin.** Aynı iş için en fazla iki düzelt-denetle turu. Sonra Claude kendisi karar verir.
- **Claude'un kendi alt ajanı bu iş için çözüm değil.** Alt ajan da aynı limitten yer.
- **Küçük işi devretmeyin.** Tek dosyada iki satırlık düzeltme için brif yazmak işten uzun sürer.

## Test işi: TestSprite (isteğe bağlı)

Testi Claude yaparsa tarayıcı açar, tıklar, ekran görüntüsü alır, log okur, tekrar dener; bu döngü de
limiti yer. Ben bu işi [TestSprite](https://www.testsprite.com/?via=ugur-2611a)'a veriyorum (videonun
sponsoru). Siteyi gezip testleri kendisi çıkarıyor ve gerçek tarayıcıda koşturuyor; Claude yalnız sonucu
ve hata özetini okuyup düzeltmeye karar veriyor.

```bash
npm install -g @testsprite/testsprite-cli
testsprite setup        # API anahtarınızı kendiniz girin, Claude Code skill'ini de kurar
```

Sonrası `/test-devret` ya da kısaca:

```bash
testsprite test run <test-id> --wait --output json
testsprite test failure summary <test-id>
```

Anahtar almadan akışı görmek için `testsprite --dry-run --output text test list --project demo` örnek
yanıt döner. TestSprite kullanmak şart değil; kurulu değilse Claude bu adımı atlar.

## Sık karşılaşılan sorunlar

| Sorun | Çözüm |
| --- | --- |
| `Codex CLI bulunamadı` | `npm install -g @openai/codex` ya da `CODEX_BIN=/yol/codex` |
| `Codex kurulu ama oturum kapalı` | Terminalde `codex login` |
| `agy kurulu ama model listesi gelmedi` | Terminalde bir kez `agy` yazıp Google girişini tamamlayın |
| Gemini videoyu açamadı | Tam yolu verin; video proje dışındaysa `--ekle <klasör>` |
| Codex ya da Gemini işi uzun sürüyor | Claude bu komutları arka planda çalıştırır; büyük işi daha dar brife bölün |
| Kota doldu | Rutin işte `--efor medium` ya da daha hafif model (`agy models`); o sırada işi Claude yapar |

## Dosyalar

```text
CLAUDE.md                              bu klasörde Claude'un okuduğu kurallar
yonetici-kurallari.md                  CLAUDE.md'nize eklenecek blok
doktor.sh                              kurulum ve oturum kontrolü
kur.sh                                 skill ve kural kurulumu, --kaldir
.claude/skills/yonet/                  işi böl, dağıt, denetle
.claude/skills/codex-devret/           devret.sh + brifler/
.claude/skills/gemini-devret/          devret.sh + brifler/
.claude/skills/test-devret/            TestSprite CLI akışı (isteğe bağlı)
ornekler/demo-proje/                   hatalı sepet: ilk deneme
```

Codex, Gemini ve TestSprite'a gönderdiğiniz dosyalar o hizmetlere gider. Gizli dosyaların, `.env`
içeriğinin ya da anahtarların olduğu klasörde devretme yapmayın, brife şifre koymayın. Her hizmetin
kullanım koşulları ve kotası kendi hesabınıza aittir.

Kod [MIT](LICENSE). Uğur Keşkekçi, 2026.
