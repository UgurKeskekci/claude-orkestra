# Claude Orkestra

Bu repo Claude Code'u yönetici yapar: ağır okuma ve izleme Gemini'ye (Antigravity CLI, `agy`), çok dosyalı
kod işi Codex'e (`codex exec`), tarayıcı testi isteğe bağlı TestSprite CLI'a gider; plan, karar ve kalite
kontrolü Claude'da kalır. Skill'ler `.claude/skills/`, kurallar `yonetici-kurallari.md`, demo `ornekler/demo-proje/`.

@yonetici-kurallari.md

## Kullanıcı "bu sistemi kur" derse

Sırayla:

1. Repo yoksa klonla (`git clone https://github.com/UgurKeskekci/claude-orkestra`) ve klasöre gir.
2. `sh doktor.sh` çalıştır, sonucu kullanıcıya kısaca anlat.
3. Eksik araç varsa README'deki "Elle kurulum" komutunu söyle; kullanıcı isterse kurulum komutunu sen
   çalıştır. Giriş adımları kullanıcıya aittir: `codex login`, ilk `agy` açılışı (Google girişi),
   `testsprite setup` (API anahtarı). Şifre ya da anahtar isteme, yazma.
4. Kullanıcıya sor: tüm projelerde mi (`sh kur.sh`), tek projede mi (`sh kur.sh /proje/yolu`)? Kur.
5. `sh doktor.sh --canli` ile Codex ve Gemini'ye birer küçük soru sor (az kota harcar), sonucu göster.
6. İlk deneme olarak `ornekler/demo-proje/README.md` içindeki adımları öner.

Bu repodaki dosyaları değiştirirken: Türkçe metinde uzun tire ve şapkalı harf kullanma, okura "siz" diye
hitap et. Kişisel bilgi, anahtar ya da gerçek müşteri verisi ekleme; örnekler temsili olsun.
