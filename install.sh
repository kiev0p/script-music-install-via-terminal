#!/usr/bin/env bash
set -e

SCRIPT_NAME="dow.spt"
DEST_BIN="$HOME/.local/bin"
DEST_PATH="$DEST_BIN/dow"

echo "== Instalador: meu-spotdl-tool =="

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y python3 python3-pip git ffmpeg
else
  echo "AVISO: instale python3, pip e ffmpeg manualmente."
fi

python3 -m pip install --user --upgrade spotdl

mkdir -p "$DEST_BIN"

cp "$SCRIPT_NAME" "$DEST_PATH"
chmod +x "$DEST_PATH"
echo "Script instalado em: $DEST_PATH"

add_path_if_missing() {
  local FILE="$1"
  if [ ! -f "$FILE" ]; then
    touch "$FILE"
  fi
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$FILE"; then
    echo "" >> "$FILE"
    echo "# Adicionado por meu-spotdl-tool" >> "$FILE"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$FILE"
    echo "✅ PATH adicionado em $FILE"
  fi
}

SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "zsh" ]; then
  add_path_if_missing "$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
  add_path_if_missing "$HOME/.bashrc"
else
  add_path_if_missing "$HOME/.profile"
fi

echo ""
echo "👉 Pronto! Agora pode usar o comando: dow "LINK-DO-SPOTIFY""
echo "Exemplo: dow "https://open.spotify.com/track/ID""
