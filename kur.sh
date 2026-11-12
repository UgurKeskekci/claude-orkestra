#!/bin/sh
# claude-orkestra kurulumu: skill'leri, alt ajanları ve yönetici kurallarını Claude Code'a ekler.
#   sh kur.sh              tüm projeler: ~/.claude/skills + ~/.claude/agents + ~/.claude/CLAUDE.md
#   sh kur.sh ~/projem     yalnız o proje: ~/projem/.claude/skills + agents + ~/projem/CLAUDE.md
#   sh kur.sh --kaldir [~/projem]   kurulanı geri alır
# Var olan CLAUDE.md silinmez: kurallar işaretli bir bloğa yazılır, eski dosya yedeklenir.
set -eu
kok=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skilller="yonet codex-devret gemini-devret test-devret"
ajanlar="haiku-okuyucu sonnet-yazici"
bas='<!-- claude-orkestra:basla -->'
son='<!-- claude-orkestra:bitir -->'

kaldir=0
if [ "${1:-}" = --kaldir ]; then kaldir=1; shift; fi

if [ $# -ge 1 ]; then
  [ -d "$1" ] || { echo "Klasör yok: $1" >&2; exit 2; }
  proje=$(cd "$1" && pwd)
  hedef="$proje/.claude/skills"
  ajan_hedef="$proje/.claude/agents"
  kurallar="$proje/CLAUDE.md"
  yedek="$proje/.claude/orkestra-yedek"
  kapsam="yalnız $proje"
else
  hedef="$HOME/.claude/skills"
  ajan_hedef="$HOME/.claude/agents"
  kurallar="$HOME/.claude/CLAUDE.md"
  yedek="$HOME/.claude/orkestra-yedek"
  kapsam="tüm projeler"
fi
zaman=$(date +%Y%m%d-%H%M%S)

blogu_sil() {  # $1 dosya: işaretli bloğu ve dosya sonundaki boş satırları çıkarır
  awk -v b="$bas" -v s="$son" '
    $0 == b { atla = 1; next }
    $0 == s { atla = 0; next }
    atla { next }
    /^[[:space:]]*$/ { bos = bos $0 "\n"; next }
    { printf "%s", bos; bos = ""; print }
  ' "$1" > "$1.orkestra-gecici"
  mv "$1.orkestra-gecici" "$1"
}

if [ "$kaldir" = 1 ]; then
  for ad in $skilller; do
    if [ -f "$hedef/$ad/SKILL.md" ] && grep -q claude-orkestra "$hedef/$ad/SKILL.md"; then
      rm -rf "${hedef:?}/$ad"; echo "silindi: $hedef/$ad"
    fi
  done
  for ad in $ajanlar; do
    if [ -f "$ajan_hedef/$ad.md" ] && grep -q claude-orkestra "$ajan_hedef/$ad.md"; then
      rm -f "$ajan_hedef/$ad.md"; echo "silindi: $ajan_hedef/$ad.md"
    fi
  done
  if [ -f "$kurallar" ] && grep -qF "$bas" "$kurallar"; then
    mkdir -p "$yedek"; cp "$kurallar" "$yedek/CLAUDE.md.$zaman"
    blogu_sil "$kurallar"; echo "kurallar çıkarıldı: $kurallar (yedek: $yedek)"
  fi
  exit 0
fi

mkdir -p "$hedef"
for ad in $skilller; do
  if [ -d "$hedef/$ad" ] && ! grep -q claude-orkestra "$hedef/$ad/SKILL.md" 2>/dev/null; then
    # aynı adlı başka bir skill varsa üstüne yazma, yedekle
    mkdir -p "$yedek"; mv "$hedef/$ad" "$yedek/$ad.$zaman"
    echo "aynı adlı skill yedeklendi: $yedek/$ad.$zaman"
  fi
  rm -rf "${hedef:?}/$ad"
  cp -R "$kok/.claude/skills/$ad" "$hedef/$ad"
  chmod +x "$hedef/$ad"/*.sh 2>/dev/null || true
done
echo "skill'ler kuruldu ($kapsam): /yonet /codex-devret /gemini-devret /test-devret"

mkdir -p "$ajan_hedef"
for ad in $ajanlar; do
  if [ -f "$ajan_hedef/$ad.md" ] && ! grep -q claude-orkestra "$ajan_hedef/$ad.md"; then
    # aynı adlı başka bir alt ajan varsa üstüne yazma, yedekle
    mkdir -p "$yedek"; mv "$ajan_hedef/$ad.md" "$yedek/$ad.md.$zaman"
    echo "aynı adlı alt ajan yedeklendi: $yedek/$ad.md.$zaman"
  fi
  cp "$kok/.claude/agents/$ad.md" "$ajan_hedef/$ad.md"
done
echo "alt ajanlar kuruldu ($kapsam): haiku-okuyucu (Haiku) sonnet-yazici (Sonnet)"

mkdir -p "$(dirname "$kurallar")"
if [ -f "$kurallar" ]; then
  mkdir -p "$yedek"; cp "$kurallar" "$yedek/CLAUDE.md.$zaman"
  grep -qF "$bas" "$kurallar" && blogu_sil "$kurallar"
fi
{
  [ -s "$kurallar" ] && printf '\n'
  echo "$bas"
  cat "$kok/yonetici-kurallari.md"
  echo "$son"
} >> "$kurallar"
echo "yönetici kuralları eklendi: $kurallar"
[ -d "$yedek" ] && echo "önceki CLAUDE.md yedeği: $yedek"
echo
echo "Sırada: sh doktor.sh ile araçları kontrol edin, sonra Claude Code'u açıp /yonet yazın."
