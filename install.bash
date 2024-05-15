#!/bin/bash
set -eux

IS_UBUNTU=$([[ -n $(uname -a | grep '[Uu]buntu') ]] && echo true || echo false)
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
mkdir -p ~/.local/bin
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
rofi_tpl="${CONF_ROOT}/rofi/config.arch"
if [ $IS_UBUNTU = true ]; then
    rofi_tpl="${CONF_ROOT}/rofi/config.ubuntu"
fi

rofi_theme="${CONF_ROOT}/rofi/Monokai-onur.rasi"
rofi_target="${CONF_ROOT}/rofi/config"

cp $rofi_tpl $rofi_target
if [ $IS_UBUNTU = true ]; then
    echo "rofi.theme: ${rofi_theme}" >> ${rofi_target}
else
    echo '@theme' '"'${rofi_theme}'"' >> ${rofi_target}
fi
