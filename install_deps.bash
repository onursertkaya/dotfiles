DIST=$(uname -a);

SYS_UTIL='grub intel-ucode efibootmgr os-prober
          networkmanager network-manager-applet bluez bluez-utils'
CLI_UTIL='htop gnu-netcat man-db ntfs-3g nmap sshfs tree wget curl'
CLI_DEV='git fzf bat ripgrep git-delta python-pip docker cmake base-devel perf time lua luarocks'
DESKTOP='dunst feh picom peek rofi i3lock i3status i3-wm xclip xsel xdotool xorg-server xorg-xev
         xorg-xinit xorg-xrandr libnotify light blueman scrot alsa-utils pulseaudio-alsa pasystray'
APP='firefox evince vlc'

# golang
rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz && \
    sudo chmod +x /usr/local/bin/go

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable && rustup update stable

# alacritty
pacman -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python
pushd ${PWD}
mkdir -p ../tools && cd ../tools
git clone https://github.com/alacritty/alacritty.git && cd alacritty
cargo build --release
popd

# nvim: download from github releases, place under ~/.local/bin, add +x
wget \
  https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
  ~/.local/bin/nvim.appimage && chmod +x ~/.local/bin/nvim.appimage

# vim-plug
sh -c \
    'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';

# Rest
# nvidia container toolkit: follow instructions
# /etc/systemd/logind.conf -> *Lid*=ignore -> Reboot
# sudo systemctl enable bluetooth.service
# sudo systemctl enable NetworkManager.service
