#!/bin/bash

if [[ $0 != 'install.bash' ]]; then
    echo 'Must be run as ./install.bash or bash install.bash (i.e. no nested paths.)'
    exit 0
fi

set -eux

cp wrappers.bash ~/.local/bin
cp -r i3/ ~/.config


# Configure rofi
rofi_conf_path="${HOME}/conf/rofi/config"
rofi_theme_path="${HOME}/conf/rofi/Monokai-onur.rasi"
if [[ -z $(grep $rofi_theme_path $rofi_conf_path) ]]; then
    echo "rofi.theme: ${rofi_theme_path}" >> ${HOME}/conf/rofi/config
fi

# Source bashrc
bashrc_path="${HOME}/.bashrc"
bashrc_onur_path="${PWD}/bashrc.onur"
if [[ -z $(grep $bashrc_onur_path $bashrc_path) ]]; then
    echo "source ${bashrc_onur_path}" >> ~/.bashrc
fi

