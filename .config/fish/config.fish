# https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish#L20
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

alias project-tree "exa --git-ignore --tree --all -I .git"
alias docker-compose podman-compose

starship init fish | source
/home/linuxbrew/.linuxbrew/bin/brew shellenv | source

for dir in /opt/asdf-vm ~/.asdf
  test -d $dir && source $dir/asdf.fish && break
end


function route-audio
    echo "create+mix virtual output $argv[1] with system output"

    pactl load-module module-device-manager
    pactl load-module module-null-sink sink_name=$argv[1]
    pactl load-module module-combine-sink sink_name=alsa_output.$argv[1] \
        slaves=$argv[1],alsa_output.pci-0000_00_1f.3.analog-stereo

    echo DONE
    echo "please open pavucontrol to rename $argv[1] sink"
end


set fish_greeting

source ~/.asdf/asdf-vm/asdf.fish

