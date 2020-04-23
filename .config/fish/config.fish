alias project-tree "exa --git-ignore --tree --all -I .git"

starship init fish | source
for dir in /opt/asdf-vm ~/.asdf
  test -d $dir && source $dir/asdf.fish && break
end

set fish_greeting
