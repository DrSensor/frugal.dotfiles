#!/usr/bin/env bash
set -Eeu -o pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RELEASE_DIR=$CURRENT_DIR/target/release
BINARY=$RELEASE_DIR/thumbs

if [ ! -f "$BINARY" ]; then
  echo "==> Installing tmux-thumbs"
  mkdir -p $RELEASE_DIR
  curl -L https://github.com/fcsonline/tmux-thumbs/releases/latest/download/tmux-thumbs_$(\
    curl -s https://api.github.com/repos/fcsonline/tmux-thumbs/releases/latest \
    | jq -r '.tag_name' \
    | cut -c1- \
  )_x86_64-unknown-linux-musl.tar.xz | tar Jxv -C $RELEASE_DIR thumbs tmux-thumbs
  exit
fi

function get-opt-value() {
  tmux show -vg "@thumbs-${1}" 2> /dev/null
}

function get-opt-arg() {
  local opt type value
  opt="${1}"; type="${2}"
  value="$(get-opt-value "${opt}")" || true

  if [ "${type}" = string ]; then
    [ -n "${value}" ] && echo "--${opt}=${value}"
  elif [ "${type}" = boolean ]; then
    [ "${value}" = 1 ] && echo "--${opt}"
  else
    return 1
  fi
}

PARAMS=(--dir "${CURRENT_DIR}")

function add-param() {
  local type opt arg
  opt="${1}"; type="${2}"
  if arg="$(get-opt-arg "${opt}" "${type}")"; then
    PARAMS+=("${arg}")
  fi
}

add-param command        string
add-param upcase-command string
add-param multi-command  string
add-param osc52          boolean

"${RELEASE_DIR}/tmux-thumbs" "${PARAMS[@]}" || true
