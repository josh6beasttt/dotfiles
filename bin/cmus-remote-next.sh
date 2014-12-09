cmus-remote -n
notify-send "Now Playing" "$(cmus-remote -Q | grep tag | head -n 3 | sort -r | cut -d ' ' -f 3-)"
