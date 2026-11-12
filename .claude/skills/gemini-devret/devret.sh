#!/bin/sh
# claude-orkestra: Gemini'ye (Antigravity CLI, agy) brif verir; okur, izler, araştırır, rapor yazar.
# Kullanım: sh devret.sh [--klasor DIR] [--ekle DIR]... [--model AD] [--efor low|medium|high] BRIF.md
#           BRIF yerine - verirseniz brif stdin'den okunur. --kontrol: agy kurulu mu, oturum açık mı.
# Gemini'ye kod yazdırmayın. Video okumak için agy izinleri otomatik onaylanır; bu yüzden betik,
# Gemini bir dosyayı değiştirirse sonunda UYARI basar.
set -eu

klasor=$(pwd); model=""; efor=""; kontrol=0; ekler=""
while [ $# -gt 0 ]; do
  case "$1" in
    --klasor) klasor=$2; shift 2 ;;
    --ekle) ekler="$ekler
$2"; shift 2 ;;
    --model) model=$2; shift 2 ;;
    --efor) efor=$2; shift 2 ;;
    --kontrol) kontrol=1; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    --) shift; break ;;
    -) break ;;
    -*) echo "Bilinmeyen seçenek: $1" >&2; exit 2 ;;
    *) break ;;
  esac
done

agy_bul() {
  if [ -n "${AGY_BIN:-}" ]; then echo "$AGY_BIN"; return 0; fi
  command -v agy 2>/dev/null && return 0
  [ -x "$HOME/.local/bin/agy" ] && { echo "$HOME/.local/bin/agy"; return 0; }
  return 1
}

agy=$(agy_bul) || {
  echo "Antigravity CLI (agy) bulunamadı. Kurulum: curl -fsSL https://antigravity.google/cli/install.sh | bash" >&2
  echo "Sonra bir kez agy yazıp Google hesabınızla giriş yapın." >&2
  exit 3
}

# Süre sınırı (perl varsa): süre dolunca komutu durdurur
sinirla() {
  s=$1; shift
  if command -v perl >/dev/null 2>&1; then
    perl -e 'alarm shift; exec @ARGV' "$s" "$@"
  else
    "$@"
  fi
}

if [ "$kontrol" = 1 ]; then
  gecici=$(mktemp)
  sinirla 40 "$agy" models < /dev/null > "$gecici" 2>&1 || true
  if grep -q "$(printf '\t')" "$gecici"; then
    echo "Gemini hazır ($agy). Modeller: agy models"; rm -f "$gecici"; exit 0
  fi
  echo "agy kurulu ama model listesi gelmedi (oturum kapalı olabilir). Terminalde bir kez: agy" >&2
  tail -n 3 "$gecici" >&2; rm -f "$gecici"; exit 4
fi

[ $# -eq 1 ] || { echo 'Kullanım: sh devret.sh [--klasor DIR] [--ekle DIR] BRIF.md' >&2; exit 2; }
if [ "$1" = - ]; then
  brif=$(cat)
else
  [ -f "$1" ] || { echo "Brif dosyası yok: $1" >&2; exit 2; }
  brif=$(cat "$1")
fi
[ -d "$klasor" ] || { echo "Klasör yok: $klasor" >&2; exit 2; }
klasor=$(cd "$klasor" && pwd)

cikti_dir="$klasor/.orkestra"
mkdir -p "$cikti_dir"
[ -f "$cikti_dir/.gitignore" ] || printf '*\n' > "$cikti_dir/.gitignore"
zaman=$(date +%Y%m%d-%H%M%S)
rapor="$cikti_dir/gemini-$zaman.md"
ham="$cikti_dir/gemini-$zaman.json"
hata="$cikti_dir/gemini-$zaman.log"
isaret="$cikti_dir/.basla-$zaman"
: > "$isaret"

istem="Sen başka bir modele çalışan yardımcı bir ajansın. İşin okumak, izlemek, araştırmak ve rapor yazmak.
Hiçbir dosyayı oluşturma, değiştirme ya da silme; komutla da dosya yazma. Kod yazma.
Uydurma: görmediğini, duymadığını, bulamadığını yazma; emin olmadığın yeri belirt.
Cevabın doğrudan rapor olsun, giriş ve kapanış cümlesi yazma. Dosya yolunu link yapma, düz dosya:satır yaz.

$brif"

set -- --sandbox --dangerously-skip-permissions --output-format json
[ -n "$model" ] && set -- "$@" --model "$model"
[ -n "$efor" ] && set -- "$@" --effort "$efor"
eski_ifs=$IFS; IFS='
'
for d in $ekler; do
  [ -n "$d" ] && set -- "$@" --add-dir "$d"
done
IFS=$eski_ifs

basla=$(date +%s)
durum=0
( cd "$klasor" && "$agy" "$@" --print="$istem" < /dev/null > "$ham" 2> "$hata" ) || durum=$?
sure=$(( $(date +%s) - basla ))

# JSON'dan yanıtı ve jeton sayısını çıkar (node ya da python3)
coz() {
  if command -v node >/dev/null 2>&1; then
    node -e '
      const fs = require("fs");
      const d = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
      fs.writeFileSync(process.argv[2], String(d.response || "").trim() + "\n");
      console.log((d.status || "") + " " + ((d.usage || {}).total_tokens || ""));
    ' "$ham" "$rapor"
  else
    python3 -c '
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
open(sys.argv[2], "w", encoding="utf-8").write(str(d.get("response") or "").strip() + "\n")
print(d.get("status", ""), (d.get("usage") or {}).get("total_tokens", ""))
' "$ham" "$rapor"
  fi
}

bilgi=$(coz 2>/dev/null) || bilgi=""
if [ "$durum" -ne 0 ] || [ -z "$bilgi" ] || [ "$(wc -c < "$rapor" | tr -d ' ')" -le 1 ]; then
  echo "Gemini cevap vermedi (çıkış $durum, $sure sn). Hata kaydının sonu:" >&2
  tail -n 15 "$hata" >&2
  rm -f "$isaret"
  exit 1
fi

echo "== Gemini raporu ($sure sn) =="
cat "$rapor"
jeton=${bilgi#* }
[ -n "$jeton" ] && echo "(Gemini'nin harcadığı jeton: $jeton, Claude'un limitinden değil)"

# Koruma: Gemini dosya değiştirdi mi?
degisen=$(find "$klasor" \( -name .git -o -name node_modules -o -name .orkestra \) -prune -o \
  -type f -newer "$isaret" -print 2>/dev/null | head -n 20)
rm -f "$isaret"
if [ -n "$degisen" ]; then
  echo "UYARI: Gemini şu dosyaları değiştirdi. git diff ile bakın, istenmiyorsa geri alın:"
  echo "$degisen"
fi
echo "(Rapor: $rapor)"
