function timer
    fish -c "sleep $argv[1] && notify-send -u critical 'timeout' $argv[2]" &
end
