#!/bin/bash
set -eux

CONF_ROOT=${PWD}

replace_conf_root() {
    target_file=$1
    tpl_file="${target_file}.tpl"
    cp $tpl_file $target_file
    sed -i "s|CONF_ROOT=|CONF_ROOT=${CONF_ROOT}|g" $target_file
}


# Configure and copy wrappers script
wrappers_path="${CONF_ROOT}/wrappers.bash"
replace_conf_root $wrappers_path
cp $wrappers_path ~/.local/bin


# Configure bashrc and add source statement
bashrc_onur_path="${CONF_ROOT}/bashrc.onur"
replace_conf_root $bashrc_onur_path

bashrc_path="${HOME}/.bashrc"
if [[ -z $(grep $bashrc_onur_path $bashrc_path) ]]; then
    echo "source ${bashrc_onur_path}" >> $bashrc_path
fi


# Configure and copy i3
python3 i3_configure.py
mkdir -p ~/.config/i3
cp i3/{config,i3status.conf} ~/.config/i3


# Configure rofi
rofi_conf_path="${CONF_ROOT}/rofi/config"
rofi_conf_tpl_path="${rofi_conf_path}.tpl"
rofi_theme_path="${CONF_ROOT}/rofi/Monokai-onur.rasi"
cp $rofi_conf_tpl_path $rofi_conf_path
echo "rofi.theme: ${rofi_theme_path}" >> ${rofi_conf_path}

