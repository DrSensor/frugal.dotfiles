alias project-tree "exa --git-ignore --tree --all -I .git"
alias docker-compose podman-compose

starship init fish | source
/home/linuxbrew/.linuxbrew/bin/brew shellenv | source
for dir in /opt/asdf-vm ~/.asdf
  test -d $dir && source $dir/asdf.fish && break
end

set fish_greeting

source ~/.asdf/asdf-vm/asdf.fish

