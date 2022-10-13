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
    xrandr --output ${EXTERNAL_SCREEN} --auto --primary
    xrandr --output ${LAPTOP_SCREEN}   --off
}

noscreen() {
    xrandr
    sleep 1
    xrandr --output ${LAPTOP_SCREEN}   --auto --primary
    xrandr --output ${EXTERNAL_SCREEN} --off
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

function browsers() {
  # map to ctrl-shift-b
  google-chrome &
  firefox &
}

function music() {
  pacmd set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
  pacmd set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo

  pacmd set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo 0
  pacmd set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 0

  spotify &
  pulseeffects &
}

eval ${1}
