#!/bin/sh
# claude-orkestra doktoru: araçlar kurulu mu, oturum açık mı?
# Kullanım: sh doktor.sh           kota harcamaz
#           sh doktor.sh --canli   Codex ve Gemini'ye birer küçük soru sorar (az kota harcar)
set -u
kok=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sk="$kok/.claude/skills"
canli=0
[ "${1:-}" = --canli ] && canli=1

iyi() { printf '  ✓ %s\n' "$1"; }
kotu() { printf '  ✗ %s\n' "$1"; }
not_() { printf '  - %s\n' "$1"; }

hazir=""; eksik=""; claude_var=0

echo "claude-orkestra doktoru"
echo
echo "Yönetici"
if command -v claude >/dev/null 2>&1; then
  iyi "Claude Code $(claude --version 2>/dev/null | head -n 1)"
  claude_var=1
else
  kotu "Claude Code yok. Kurulum: curl -fsSL https://claude.ai/install.sh | bash"
fi

echo
echo "İşçiler"
codex_msj=$(sh "$sk/codex-devret/devret.sh" --kontrol 2>&1); codex_d=$?
if [ "$codex_d" -eq 0 ]; then iyi "$codex_msj"; hazir="$hazir Codex"; else kotu "$codex_msj"; eksik="$eksik Codex"; fi
gemini_msj=$(sh "$sk/gemini-devret/devret.sh" --kontrol 2>&1); gemini_d=$?
if [ "$gemini_d" -eq 0 ]; then iyi "$gemini_msj"; hazir="$hazir Gemini"; else kotu "$gemini_msj"; eksik="$eksik Gemini"; fi

echo
echo "İsteğe bağlı"
if command -v testsprite >/dev/null 2>&1; then
  if testsprite auth status >/dev/null 2>&1; then
    iyi "TestSprite CLI $(testsprite --version 2>/dev/null), anahtar tanımlı"; hazir="$hazir TestSprite"
  else
    not_ "TestSprite CLI kurulu, anahtar yok. Terminalde: testsprite setup"
  fi
else
  not_ "TestSprite CLI yok: npm install -g @testsprite/testsprite-cli (test işi için, şart değil)"
fi
if command -v git >/dev/null 2>&1; then iyi "git (değişiklikleri denetlemek için)"; else not_ "git yok: Codex'in değişikliğini görmek zorlaşır"; fi
if command -v node >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1; then
  iyi "node ya da python3 (Gemini yanıtını okumak için)"
else
  kotu "node da python3 de yok: Gemini betiği yanıtı okuyamaz"
fi
if command -v ffmpeg >/dev/null 2>&1; then iyi "ffmpeg (Claude'un videodan kare alıp doğrulaması için)"; else not_ "ffmpeg yok: video işinde Claude kareyi kendisi doğrulayamaz"; fi

echo
echo "Skill'ler"
if [ -f "$HOME/.claude/skills/yonet/SKILL.md" ]; then
  iyi "tüm projelerde kurulu (~/.claude/skills)"
else
  not_ "yalnız bu klasörde hazır. Diğer projeler için: sh kur.sh"
fi

if [ "$canli" = 1 ]; then
  echo
  echo "Canlı deneme (az kota harcar)"
  gecici=$(mktemp -d)
  if [ "$codex_d" -eq 0 ]; then
    cevap=$(printf 'Yalnız TAMAM kelimesini yaz, başka bir şey yapma.' | sh "$sk/codex-devret/devret.sh" --klasor "$gecici" --efor low - 2>&1)
    case "$cevap" in *TAMAM*) iyi "Codex cevap verdi: $(echo "$cevap" | sed -n '2p') $(echo "$cevap" | sed -n '1s/^== Codex özeti \(.*\) ==$/\1/p')" ;; *) kotu "Codex cevabı beklenmedik:"; echo "$cevap" | tail -n 5 ;; esac
  fi
  if [ "$gemini_d" -eq 0 ]; then
    cevap=$(printf 'Yalnız TAMAM kelimesini yaz.' | sh "$sk/gemini-devret/devret.sh" --klasor "$gecici" - 2>&1)
    case "$cevap" in *TAMAM*) iyi "Gemini cevap verdi: $(echo "$cevap" | sed -n '2p') $(echo "$cevap" | sed -n '1s/^== Gemini raporu \(.*\) ==$/\1/p')" ;; *) kotu "Gemini cevabı beklenmedik:"; echo "$cevap" | tail -n 5 ;; esac
  fi
  rm -rf "$gecici"
fi

echo
echo "Hazır:${hazir:- yok}"
[ -n "$eksik" ] && echo "Eksik:$eksik (hepsi şart değil; eksik olanın işini Claude kendisi yapar)"
if [ "$claude_var" = 1 ] && { [ "$codex_d" -eq 0 ] || [ "$gemini_d" -eq 0 ]; }; then
  [ "$canli" = 1 ] || echo "Gerçek bir soruyla denemek için: sh doktor.sh --canli"
  exit 0
fi
echo "En az Claude Code ve bir işçi (Codex ya da Gemini) gerekli. Kurulum: README.md"
exit 1
