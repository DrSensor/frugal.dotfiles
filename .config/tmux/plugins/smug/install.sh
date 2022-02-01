BINARY=$HOME/.local/bin/smug

if [ ! -f "$BINARY" ]; then
  echo "==> Installing smug"
  curl -L https://github.com/ivaaaan/smug/releases/latest/download/smug_$(
    curl -s https://api.github.com/repos/ivaaaan/smug/releases/latest \
    | jq -r '.tag_name' \
    | cut -c2- \
  )_Linux_x86_64.tar.gz | tar zxv -C $(dirname $BINARY)
fi
