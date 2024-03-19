#!/bin/bash

LAPTOP_SCREEN="DP-4"
EXTERNAL_SCREEN="HDMI-0"

CONF_ROOT=$configuration_root_directory

# Wrapping commands for startup apps. *_cc suffix is for ===============
# "custom config." =====================================================

alacritty_cc() {
    $HOME/workspace/tools/alacritty/target/release/alacritty --config-file "${CONF_ROOT}/alacritty.toml"
}

compton_cc() {
    compton --config "${CONF_ROOT}/compton.conf"
}

dunst_cc() {
    # stop the dunst instance spawned by systemd, which
    # is installed by i3.
    systemctl stop dunst --user
    dunst -conf "${CONF_ROOT}/dunstrc"
}

rofi_show() {
    rofi -config "${CONF_ROOT}/rofi/config" -show drun -modi drun
}

rofi_window() {
    rofi -config "${CONF_ROOT}/rofi/config" -show window
}

rofi_control() {
    pick=$(printf '%s\n' system_hibernate system_sleep system_shutdown screen_turn_off lock kbd_toggle | rofi -config "${CONF_ROOT}/rofi/config" -dmenu)
    eval ${pick}
}

# Custom commands ======================================================
homescreen () {
    xrandr
    sleep 1
    xrandr --output ${EXTERNAL_SCREEN} --auto --primary --dpi 144
    xrandr --output ${LAPTOP_SCREEN}   --off
}

noscreen() {
    xrandr
    sleep 1

    # laptop_screen=$(xrandr | grep -oP '\w.*(?=connected.*\d{4}x\d{4})')
    xrandr --output ${LAPTOP_SCREEN}   --auto --primary --dpi 144
    xrandr --output ${EXTERNAL_SCREEN} --off
}

brightness_up() {
    curr_brightness=$(xrandr --verbose | grep -oP '(?<=Brightness:\s).*')
    increased=$(python3 -c \
        'import sys; print(min(1.0, float(sys.argv[1])+0.1))' \
        $curr_brightness)

    xrandr --output ${LAPTOP_SCREEN} --brightness $increased
}

brightness_down() {
    curr_brightness=$(xrandr --verbose | grep -oP '(?<=Brightness:\s).*')
    decreased=$(python3 -c \
        'import sys; print(max(0.1, float(sys.argv[1])-0.1))' \
        $curr_brightness)

    xrandr --output ${LAPTOP_SCREEN} --brightness $decreased
}

shot() {
    FILENAME=$(date +'%F_%H-%M-%S');
    if [[ $1 != '' ]]; then
        FILENAME=$1
    fi
    mkdir -p  ~/Pictures/ss;
    scrot -s "${HOME}/Pictures/ss/$1.png";
}

screen_turn_off() {
    sleep 1 && xset dpms force off
}

lock() {
    i3lock -c 000000 && screen_turn_off
}

kbd_init() {
    xset r rate 170 40  # time-out & repeat speed
    setxkbmap -option
    setxkbmap -layout us
}

kbd_toggle() {    
    case \
        $(setxkbmap -query | grep layout | cut -f2 -d ':' | xargs echo | cut -f1 -d ',') \
        in
    us)
        setxkbmap -layout se
        notify-send 'kbd: se'
        ;;
    se)
        setxkbmap -layout tr;
        notify-send 'kbd: tr'
        ;;
    tr)
        setxkbmap -layout us;
        notify-send 'kbd: us'
        ;;
    *)
        notify-send "ERROR";
        ;;
    esac
}

# systemctl suspend writes the state to ram
# + faster to wake up
# - no effect on disk
# - more power consumption
system_sleep() {
    systemctl suspend
}

# systemctl hibernate writes the state to disk
# + less power consumption
# - heavier on the disk
# - asks for disk password if there's one
system_hibernate() {
    systemctl hibernate
}

system_shutdown() {
    systemctl poweroff
}

pass_s() {
  bash ~/.pass
}

user_s() {
  bash ~/.user
}

pass_a() {
  bash ~/.pass_a
}

eval ${1}
