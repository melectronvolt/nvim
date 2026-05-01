#!/usr/bin/env bash
set -euo pipefail

APP="${NVIM_APPNAME:-nvim}"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$XDG_CONFIG_HOME/$APP"
DATA_DIR="$XDG_DATA_HOME/$APP"
CACHE_DIR="$XDG_CACHE_HOME/$APP"
BASE46_CACHE="$DATA_DIR/base46"

echo "=== NvChad regenerate ==="
echo "Repo   : $REPO_DIR"
echo "Config : $CONFIG_DIR"
echo "Data   : $DATA_DIR"
echo

if ! command -v nvim >/dev/null 2>&1; then
  echo "ERREUR : nvim introuvable dans le PATH."
  exit 1
fi

if [ ! -f "$REPO_DIR/init.lua" ] || [ ! -f "$REPO_DIR/lua/chadrc.lua" ]; then
  echo "ERREUR : ce script doit être placé dans le dépôt nvim contenant init.lua et lua/chadrc.lua."
  exit 1
fi

THEME="$(grep -oE 'theme\s*=\s*"[^"]+"' "$REPO_DIR/lua/chadrc.lua" | head -n1 | sed -E 's/.*"([^"]+)".*/\1/' || true)"
echo "Thème demandé dans le repo : ${THEME:-non trouvé}"

if [ -n "${THEME:-}" ] && [ -d "$DATA_DIR/lazy/base46/lua/base46/themes" ]; then
  if [ ! -f "$DATA_DIR/lazy/base46/lua/base46/themes/$THEME.lua" ]; then
    echo "ATTENTION : le thème '$THEME' n'existe pas dans Base46 local."
    echo "Thèmes proches :"
    find "$DATA_DIR/lazy/base46/lua/base46/themes" -maxdepth 1 -type f \
      | sed 's#.*/##; s#\.lua$##' \
      | grep -i "${THEME:0:3}" || true
    exit 1
  fi
fi

echo
echo "=== Synchronisation repo -> config active ==="

mkdir -p "$CONFIG_DIR"

REPO_REAL="$(readlink -f "$REPO_DIR")"
CONFIG_REAL="$(readlink -f "$CONFIG_DIR" 2>/dev/null || true)"

if [ "$REPO_REAL" = "$CONFIG_REAL" ]; then
  echo "~/.config/$APP pointe déjà vers le dépôt. Rsync ignoré."
else
  rsync -av --delete \
    --exclude '.git/' \
    "$REPO_DIR/" \
    "$CONFIG_DIR/"
fi

echo
echo "=== Nettoyage cache Lua / Base46 ==="

rm -rf "$CACHE_DIR/luac"
rm -rf "$BASE46_CACHE"

mkdir -p "$BASE46_CACHE"

# Fichiers factices pour éviter que init.lua casse avant la régénération.
: > "$BASE46_CACHE/defaults"
: > "$BASE46_CACHE/statusline"

echo
echo "=== Régénération Base46 ==="

nvim --headless \
  +'lua local ok, base46 = pcall(require, "base46"); if not ok then error(base46) end; base46.load_all_highlights()' \
  +qa!

echo
echo "=== Vérification ==="

ls -lh "$BASE46_CACHE/defaults" "$BASE46_CACHE/statusline"

echo
echo "Thème actif lu par Nvim :"
nvim --headless +'lua local ok, cfg = pcall(require, "nvconfig"); if ok then print(cfg.base46.theme) else print("nvconfig inaccessible") end' +qa! 2>/dev/null || true

echo
echo "OK. Relance maintenant : nvim"
