#!/bin/sh
# claude-orkestra: Codex CLI'a (codex exec) brif verir, ekrana yalnız Codex'in kısa özetini basar.
# Kullanım: sh devret.sh [--yaz] [--klasor DIR] [--efor low|medium|high] [--model AD] BRIF.md
#           BRIF yerine - verirseniz brif stdin'den okunur. --kontrol: Codex kurulu mu, oturum açık mı.
# Varsayılan salt okunur (inceleme). --yaz verilirse Codex yalnız --klasor içine yazabilir.
set -eu

yaz=0; klasor=$(pwd); efor=""; model=""; kontrol=0
while [ $# -gt 0 ]; do
  case "$1" in
    --yaz) yaz=1; shift ;;
    --klasor) klasor=$2; shift 2 ;;
    --efor) efor=$2; shift 2 ;;
    --model) model=$2; shift 2 ;;
    --kontrol) kontrol=1; shift ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    --) shift; break ;;
    -) break ;;
    -*) echo "Bilinmeyen seçenek: $1" >&2; exit 2 ;;
    *) break ;;
  esac
done

codex_bul() {
  if [ -n "${CODEX_BIN:-}" ]; then echo "$CODEX_BIN"; return 0; fi
  command -v codex 2>/dev/null && return 0
  # ChatGPT masaüstü uygulaması Codex CLI'ı kendi içinde getiriyor (macOS)
  y=/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex
  [ -x "$y" ] && { echo "$y"; return 0; }
  return 1
}

codex=$(codex_bul) || {
  echo "Codex CLI bulunamadı. Kurulum: npm install -g @openai/codex, sonra: codex login" >&2
  echo "Başka yerdeyse yolunu verin: CODEX_BIN=/yol/codex" >&2
  exit 3
}

if [ "$kontrol" = 1 ]; then
  durum=$("$codex" login status 2>&1 || true)
  case "$durum" in
    *"Logged in"*) echo "Codex hazır ($codex)"; exit 0 ;;
    *) echo "Codex kurulu ama oturum kapalı. Terminalde: codex login" >&2; exit 4 ;;
  esac
fi

[ $# -eq 1 ] || { echo 'Kullanım: sh devret.sh [--yaz] [--klasor DIR] [--efor medium] BRIF.md' >&2; exit 2; }
if [ "$1" = - ]; then
  brif=$(cat)
else
  [ -f "$1" ] || { echo "Brif dosyası yok: $1" >&2; exit 2; }
  brif=$(cat "$1")
fi
[ -d "$klasor" ] || { echo "Klasör yok: $klasor" >&2; exit 2; }
klasor=$(cd "$klasor" && pwd)

# Çıktılar projede .orkestra/ altında; klasör kendini git'ten gizler
cikti_dir="$klasor/.orkestra"
mkdir -p "$cikti_dir"
[ -f "$cikti_dir/.gitignore" ] || printf '*\n' > "$cikti_dir/.gitignore"
zaman=$(date +%Y%m%d-%H%M%S)
ozet="$cikti_dir/codex-$zaman.md"
log="$cikti_dir/codex-$zaman.log"

if [ "$yaz" = 1 ]; then
  kum=workspace-write
  kural="Yalnız bu klasörde çalış: $klasor. Brifte adı geçmeyen dosyaya gerekmedikçe dokunma. Git commit atma."
else
  kum=read-only
  kural="Bu iş salt okunur: hiçbir dosyayı değiştirme, yalnız incele ve raporla."
fi

son="$kural

Son mesajın kısa olsun (en fazla 15 satır), başka bir modele rapor veriyorsun:
1. Ne yaptın / ne buldun (dosya:satır ile)
2. Nasıl doğruladın (çalıştırdığın komut ve sonucu)
3. Kalan sorun ya da emin olmadığın şey (yoksa \"yok\")"

set -- exec --cd "$klasor" --sandbox "$kum" --skip-git-repo-check --color never -o "$ozet"
[ -n "$efor" ] && set -- "$@" -c "model_reasoning_effort=$efor"
[ -n "$model" ] && set -- "$@" -m "$model"

basla=$(date +%s)
durum=0
printf '%s\n\n%s\n' "$brif" "$son" | "$codex" "$@" - > "$log" 2>&1 || durum=$?
sure=$(( $(date +%s) - basla ))

if [ "$durum" -ne 0 ] || [ ! -s "$ozet" ]; then
  echo "Codex hata verdi (çıkış $durum, $sure sn). Logun sonu:" >&2
  tail -n 20 "$log" >&2
  exit 1
fi

echo "== Codex özeti ($sure sn, $kum) =="
cat "$ozet"
[ -n "$(tail -c 1 "$ozet")" ] && echo
jeton=$(grep -A1 -i 'tokens used' "$log" | tail -n 1 | tr -d ' ' || true)
[ -n "$jeton" ] && echo "(Codex'in harcadığı jeton: $jeton, Claude'un limitinden değil)"
if [ "$yaz" = 1 ] && git -C "$klasor" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "== Değişen dosyalar (git diff --stat) =="
  git -C "$klasor" diff --stat
  git -C "$klasor" ls-files --others --exclude-standard | sed 's/^/yeni: /'
fi
echo "(Tam log: $log)"
