#!/bin/bash

LAPTOP_SCREEN="DP-4"
EXTERNAL_SCREEN="HDMI-0"

CONF_ROOT=

# Wrapping commands for startup apps. *_cc suffix is for ===============
# "custom config." =====================================================

alacritty_cc() {
    ls "${CONF_ROOT}/alacritty.yml"
    alacritty --config-file "${CONF_ROOT}/alacritty.yml"
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

# Custom commands ======================================================

rofi_show() {
    rofi -config "${CONF_ROOT}/rofi/config" -show run
}

rofi_window() {
    rofi -config "${CONF_ROOT}/rofi/config" -show window
}

homescreen () {
    xrandr
    sleep 1
    xrandr --output ${EXTERNAL_SCREEN} --auto --primary --dpi 144
    xrandr --output ${LAPTOP_SCREEN}   --off
}

noscreen() {
    xrandr
    sleep 1
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

notify_control_mode_keybindings() {
    h='h - help'
    e='e - end i3 session'
    s='s - sleep'
    q='q - shutdown'
    c='c - i3 config reload'
    r='r - restart i3 session'
    j='j - lock'
    l='l - screen off'
    k='k - toggle keyboard layout'

    notify-send commands "$h\n$e\n$s\n$q\n$c\n$r\n$j\n$l\n$k"
}

screen_turn_off() {
    sleep 1 && xset dpms force off
}

lock() {
    i3lock -c 000000 && screen_turn_off
}

kbd_init() {
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

system_sleep() {
    # systemctl hibernate writes the state to disk
    # + less power consumption
    # - heavier on the disk
    # - asks for disk password if there's one

    # systemctl suspend writes the state to ram
    # + faster to wake up
    # - no effect on disk
    # - more power consumption
    systemctl suspend
}

system_shutdown() {
    systemctl poweroff
}

browsers() {
  google-chrome &
  firefox &
}

music() {
  pacmd set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
  pacmd set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo

  pacmd set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo 0
  pacmd set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 0

  spotify &
  pulseeffects &
}

eval ${1}
