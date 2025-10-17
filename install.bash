#!/bin/bash
set -eu

# sudo apt update
# sudo apt install i3 rofi xclip xdotool scrot pasystray blueman feh

# TODO: automate
# nvim via curl
#   nvim plug via script on github (junnegun)
#   :PlugInstall (mason, telescope, lsp, treesitter etc.)
#   TODO: patched fonts
#
# rust via rustup.sh
#
# alacritty & riggrep via git clone + cargo
#   ln -s to .local/bin
#
# fzf via script on github (junnegun)

# TODO: ln -s nvim alacritty ripgrep to $HOME/.local/bin

CONF_ROOT=${PWD}  # assuming this file is called with make

append_to_file() {
    file=$1;
    statement=$2;

    if [[ ! -f $file ]]; then
        touch $file;
    fi

    if [[ -z $(grep "$statement" $file) ]]; then
        echo $statement >> $file;
    fi
}

conf_root_path="${HOME}/.conf_root"
append_to_file $conf_root_path "export CONF_ROOT=${CONF_ROOT}";

bashrc_path="${HOME}/.bashrc"
append_to_file $bashrc_path "source $conf_root_path"
append_to_file $bashrc_path "source ${CONF_ROOT}/bashrc.onur"

mkdir -p ~/.local/bin
cp "${CONF_ROOT}/wrappers.bash" ~/.local/bin

# Configure and copy i3, restart
python3 i3_configure.py
mkdir -p ~/.config/i3
cp i3/{config,i3status.conf} ~/.config/i3
i3-msg reload > /dev/null
i3-msg restart > /dev/null

# restart picom if running, start otherwise
if [[ -n $(pidof picom) ]]; then
    killall picom
fi
picom --config ${CONF_ROOT}/picom.conf --daemon

