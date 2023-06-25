{pkgs}:
{
  screenshot = (pkgs.writeShellScriptBin "screenshot" ''
    grim -g "$(slurp)" /home/akreuzer/Pictures/Screenshots/$(date -d "today" + "%d-%m-%Y-%H%M").png
  '');

  brightness = (pkgs.writeShellScriptBin "brightness" ''
    current_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
    max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    brightness_increment=25

    raise_brightness() {
      if [[ $current_brightness -eq $max_brightness ]]; then
        exit
      fi

      brightness=$((current_brightness + $brightness_increment))
      if [[ $brightness -gt $max_brightness ]]; then
        brightness=$max_brightness
      fi

      echo $brightness > /sys/class/backlight/intel_backlight/brightness
    }

    lower_brightness() {
      if [[ $current_brightness -eq 0 ]]; then
        exit
      fi

      brightness=$((current_brightness - $brightness_increment))
      if [[ $brightness -lt 0 ]]; then
        brightness=0
      fi

      echo $brightness > /sys/class/backlight/intel_backlight/brightness
    }

    case $1 in
      "up")
        raise_brightness
        exit
        ;;
      "down")
        lower_brightness
        exit
        ;;
      "*")
        exit
        ;;
    esac
  '');

  hypr-powersave = (pkgs.writeShellScriptBin "hypr-powersave" ''
    HYPRPSMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
    if [ "$HYPRPSMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:drop_shadow 0;\
            keyword decoration:blur 0;\
            keyword misc:vfr 1;"
        exit
    fi
    hyprctl reload
  '');

  work = (pkgs.writeShellScriptBin "work" ''
    brave --class=braveWork --profile-directory="Profile 1";
    alacritty --class=alacrittyWork -e ssh w -t tmux new-session -A -s work;
  '');
}
