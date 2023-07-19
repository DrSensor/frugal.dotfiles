if [ "$TERM_PROGRAM" != "vscode" ] && [ $TERM = "xterm-256color" ] || [ $TERM = "linux" ]
  exec tmux
end

# https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish#L20
set -x MANPAGER "sh -c 'col -b | bat -l man -p'"

alias project-tree "exa --git-ignore --tree --all -I .git"
alias task dstask
alias open "handlr open" # also please manually install `xdg-utils-handlr` which automatically replace😞`xdg-utils` then shim `xdg-open`

alias snippet the-way

function vi_cursor # alacritty workaround https://github.com/fish-shell/fish-shell/issues/7458
  switch $fish_bind_mode # BUG: this already fixed in the upstream but somehow it doesn't works
    case default
      printf "\e[2 q"
    case insert
      printf "\e[6 q"
    case replace_one
      printf "\e[4 q"
    case visual
      printf "\e[4 q"
  end
end

# because starship init erase fish_mode_prompt from builtin functions
builtin functions -c fish_prompt starship_prompt
function fish_prompt
  vi_cursor
  starship_prompt
end
# builtin functions -c fish_right_prompt starship_right_prompt
# function fish_right_prompt
#   vi_cursor
#   starship_right_prompt
# end


function cmdsave -d "save previous command as snippet"
  set line (echo $history[1])
  snippet cmd $line
end
function cmdsearch -d "search commands saved as snippet"
  commandline (snippet search --languages=sh --stdout)
end
function cmdsync -d "sync commands saved as snippet into GitHub Gist"
  THE_WAY_GITHUB_TOKEN=(pass gist.github.com/token) snippet sync
end

function mv--swap -d "Swap (rename) between 2 files"
  # TODO: this should be rewritten as cli via syscall renameat2(2) but with parallize batch swapping
  # example: https://gist.github.com/eatnumber1/f97ac7dad7b1f5a9721f#file-renameat2-c-L96
  mv $argv[1]    "$argv[1];"
  mv $argv[2]    $argv[1]
  mv "$argv[1];" $argv[2]
  # NEWS: seems like it's coming as `mv --swap` https://lists.gnu.org/archive/html/coreutils/2021-05/msg00030.html
end

if status is-interactive
  ## do `atuin import fish` manually in your terminal prompt
  atuin init fish | ATUIN_NOBIND=true source
  function _atuin_fzf
    set h (atuin search --cmd-only (commandline -b) | fzf)
    commandline -f repaint
    if test -n "$h"
      commandline -r $h
    end
  end
  function _atuin_fuzzy_search
    mv--swap ~/.config/atuin/config{.toml,.fuzzy.toml}
    _atuin_search
    mv--swap ~/.config/atuin/config{.toml,.fuzzy.toml}
  end
  ## keycode found via `xxd -psd`
  bind \e\[1\;2A _atuin_search        # Shift+Up
  bind \e\[1\;6A _atuin_fuzzy_search  # Ctrl+Shift+Up
  bind \e\[1\;4A _atuin_fzf           # Alt+Shift+Up
end

for dir in /opt/asdf-vm ~/.asdf
  test -d $dir && source $dir/asdf.fish && break
end

function get-twitch_token
  twitch token -u -s "chat:edit chat:read" &| grep -oP 'User Access Token: \K[a-z0-9]+'
end

function route-audio
  echo "create+mix virtual output $argv[1] with system output"

  pactl load-module module-device-manager
  pactl load-module module-null-sink sink_name=$argv[1]
  pactl load-module module-combine-sink sink_name=alsa_output.$argv[1] \
      slaves=$argv[1],alsa_output.pci-0000_00_1f.3.analog-stereo

  echo DONE
  pactl list short sinks
  # set_color green; echo "please open pavucontrol to rename '$argv[1]' sink"
  # set_color normal
end


function prepare-chat
  switch $argv[1]
    case twitch
      set -l scopes chat:edit \
                    # channel:moderate \
                    # channel_commercial \
                    # channel_editor \
                    # whispers:edit \
                    chat:read
      # TODO: parse User Authentication Agent then pipe it to xclip
      twitch token -u -s "$scopes"
      set_color green; echo "in weechat, please /secure set twitch_token (User Authentication Agent)"
      set_color normal
    case '*'
      echo "$argv[1] chat not supported"
  end
end


function projector-connected
  return (string match -q "*connected*" (xrandr --query | grep 'DP-1'))
end


function prepare-streaming
  bspc rule -r obs Pavucontrol weechat
  bspc rule -a obs desktop=8
  bspc rule -a weechat desktop=8 state=floating
  # bspc rule -a Pavucontrol desktop=7

  kitty -1 --class weechat -- weechat

  # gst-launch-1.0 -q videotestsrc pattern=black ! v4l2sink device=/dev/video99 # already set in Gstreamer source
  route-audio music
  echo "Creating virtual camera..."
  sudo modprobe v4l2loopback devices=2 video_nr=10,99 card_label="OBS Output","null" exclusive_caps=1

  # prime-run obs > /dev/null &
  # pavucontrol > /dev/null &
  if not projector-connected
    echo "Stream preview to Android..."
    livestream-to-android obs (read -P "Select network interface [usb/eth/wlan]: ")
  end
  prepare-chat twitch

  set_color green; echo "You're now ready to run OBS!"
end


function livestream-to-android
  switch $argv[1] # (read -P "Select input [obs/webcam/logitech]: ")
    case obs
      set input /dev/video10
    case webcam
      set input /dev/video0
    case logitech
      set input /dev/video2
    case '*'
      set_color red; echo "invalid input" 1>&2
      return 1
  end
  switch $argv[2] # (read -P "Select network interface [usb/eth/wlan]: ")
    case usb
      set endpoint 192.168.42.129
    case eth wlan
      set endpoint 192.168.100.3
    case '*'
      set_color red; echo "invalid network interface" 1>&2
      return 1
  end
  echo "$input is live!"
  ffmpeg -i $input \
         -preset ultrafast \
         # -crf 1 \
         -c:v libx264 -tune zerolatency \
         -hide_banner -loglevel error \
         -f mpegts udp://$endpoint:5554 &
  set_color blue; echo "!! pkill ffmpeg !! to stop livestream-to-android"
  set_color green; echo "please open <udp://$endpoint:5554> in your Android phone"
  set_color normal
end


set fish_greeting

source ~/.asdf/asdf-vm/asdf.fish
