BINARY=$HOME/.local/bin/gitmux

if [ ! -f "$BINARY" ]; then
  echo "==> Installing gitmux"
  curl -L https://github.com/arl/gitmux/releases/latest/download/gitmux_$(\
    curl -s https://api.github.com/repos/arl/gitmux/releases/latest \
    | jq -r '.tag_name' \
    | cut -c2- \
  )_linux_amd64.tar.gz | tar zxv -C $(dirname $BINARY)
fi
