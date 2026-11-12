# Claude Orkestra

Bu repo Claude Code'u yönetici yapar: ağır okuma ve izleme Gemini'ye (Antigravity CLI, `agy`), çok dosyalı
kod işi Codex'e (`codex exec`), tarayıcı testi isteğe bağlı TestSprite CLI'a gider; plan, karar ve kalite
kontrolü Claude'da kalır. Codex ve Gemini yoksa okumayı Haiku, kodu Sonnet alt ajanı yapar (sadece Claude modu).
Skill'ler `.claude/skills/`, alt ajanlar `.claude/agents/`, kurallar `yonetici-kurallari.md`, demo `ornekler/demo-proje/`.

@yonetici-kurallari.md

## Kullanıcı "bu sistemi kur" derse

Sırayla:

1. Repo yoksa klonla (`git clone https://github.com/UgurKeskekci/claude-orkestra`) ve klasöre gir.
2. `sh doktor.sh` çalıştır, sonucu kullanıcıya kısaca anlat.
3. Eksik araç varsa README'deki "Elle kurulum" komutunu söyle; kullanıcı isterse kurulum komutunu sen
   çalıştır. Giriş adımları kullanıcıya aittir: `codex login`, ilk `agy` açılışı (Google girişi),
   `testsprite setup` (API anahtarı). Şifre ya da anahtar isteme, yazma. Kullanıcının yalnız Claude aboneliği
   varsa eksik araç sorun değil: sadece Claude modu, `kur.sh` Haiku ve Sonnet alt ajanlarını kurar.
4. Kullanıcıya sor: tüm projelerde mi (`sh kur.sh`), tek projede mi (`sh kur.sh /proje/yolu`)? Kur.
5. Codex ya da Gemini kuruluysa `sh doktor.sh --canli` ile birer küçük soru sor (az kota harcar), sonucu göster.
6. İlk deneme olarak `ornekler/demo-proje/README.md` içindeki adımları öner.

Bu repodaki dosyaları değiştirirken: Türkçe metinde uzun tire ve şapkalı harf kullanma, okura "siz" diye
hitap et. Kişisel bilgi, anahtar ya da gerçek müşteri verisi ekleme; örnekler temsili olsun.
