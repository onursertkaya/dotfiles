#!/bin/bash
set -eux

IS_UBUNTU=$([[ -n $(uname -a | grep '[Uu]buntu') ]] && echo true || echo false)
CONF_ROOT=${PWD}  # assuming this file is called with make

append_to_file() {
    file=$1;
    statement=$2;
    if [[ -z $(grep "$statement" $file) ]]; then
        echo $statement >> $file;
    fi
}

conf_root_path="${HOME}/.conf_root"
append_to_file $conf_root_path "export CONF_ROOT=${CONF_ROOT}";
append_to_file $conf_root_path "export IS_UBUNTU=${IS_UBUNTU}";

bashrc_path="${HOME}/.bashrc"
append_to_file $bashrc_path "source $conf_root_path"
append_to_file $bashrc_path "source ${CONF_ROOT}/bashrc.onur"

mkdir -p ~/.local/bin
cp "${CONF_ROOT}/wrappers.bash" ~/.local/bin

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
