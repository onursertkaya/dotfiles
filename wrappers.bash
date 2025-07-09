#!/bin/bash

LAPTOP_SCREEN="DP-4"
EXTERNAL_SCREEN="HDMI-0"

source ~/.conf_root

# Wrapping commands for startup apps. *_cc suffix is for ===============
# "custom config." =====================================================

alacritty_cc() {
    $CONF_ROOT/../tools/alacritty/target/release/alacritty --config-file "${CONF_ROOT}/alacritty.toml"
}

dunst_cc() {
    # stop the dunst instance spawned by systemd, which is installed by i3.
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
    declare -A actions=( \
        ["Turn off the screen"]="screen_turn_off" \
        ["Sleep"]="system_sleep" \
        ["Hibernate"]="system_hibernate" \
        ["Shutdown"]="system_shutdown" \
        ["Reboot"]="system_reboot" \
        ["Lock"]="lock" \
        ["Toggle keyboard"]="kbd_toggle" \
        ["Init keyboard"]="kbd_init" \
        ["Screenshot"]="shot" \
        ["Switch to external screen"]="homescreen" \
        ["Switch to main screen"]="noscreen" \
        ["Logout"]="i3_logout" \
    );
    actions_selection=( \
        'Turn off the screen' \
        'Sleep' \
        'Hibernate' \
        'Shutdown' \
        'Reboot' \
        'Lock' \
        'Toggle keyboard' \
        'Init keyboard' \
        'Screenshot' \
        'Switch to external screen' \
        'Switch to main screen' \
        'Logout' \
    );
    pick_str=$(printf '%b\n' "${actions_selection[@]}" | \
        rofi -disable-history -config "${CONF_ROOT}/rofi/config" -dmenu -p 'Control' -i);
    eval ${actions[$pick_str]}
}

# Custom commands ======================================================
noscreen() {
    xrandr 2&>1 /dev/null
    sleep 0.5
    xrandr --output ${LAPTOP_SCREEN}   --auto --primary --dpi 144 --output ${EXTERNAL_SCREEN} --off
}

homescreen () {
    xrandr 2&>1 /dev/null
    sleep 0.5
    if [[ -z $(xrandr | grep "${EXTERNAL_SCREEN} connected") ]]; then
        # fallback
        noscreen
    fi
    # xrandr --output ${EXTERNAL_SCREEN} --mode 3840x2160 --rate 30 --primary --dpi 144 --output ${LAPTOP_SCREEN} --off
    xrandr --output ${EXTERNAL_SCREEN} --auto --primary --dpi 144 --output ${LAPTOP_SCREEN} --off
}

brightness_up() {
    curr_brightness=$(xrandr --verbose | grep -oP '(?<=Brightness:\s).*')
    increased=$(python3 -c \
        'import sys; print(min(100.0, float(sys.argv[1])+10))' \
        $curr_brightness)

    xbacklight -inc $increased
}

brightness_down() {
    curr_brightness=$(xrandr --verbose | grep -oP '(?<=Brightness:\s).*')
    decreased=$(python3 -c \
        'import sys; print(max(100.0, float(sys.argv[1])-10))' \
        $curr_brightness)

    xbacklight -dec $decreased
}

rename_window() {
    xdotool set_window --name "$2" $(xdotool getactivewindow)
}

shot() {
    FILENAME=$(date +'%F_%H-%M-%S');
    if [[ $1 != '' ]]; then
        FILENAME=$1
    fi
    mkdir -p  ~/Pictures/ss;
    scrot -s "${HOME}/Pictures/ss/${FILENAME}.png";
}

beep() {
    speaker-test -t sine -f 1000 -l 1 & sleep 1 && kill -9 $!
}

screen_turn_off() {
    sleep 1 && xset dpms force off
}

lock() {
    i3lock -i ~/Downloads/wp.png && screen_turn_off
}

i3_logout() {
    i3-msg exit
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

system_reboot() {
    systemctl reboot
}
eval ${1}
