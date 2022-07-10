#!/bin/bash

sudo apt update

sudo apt install \
    i3 dunst compton \
    pasystray pavucontrol pulseaudio pulseaudio-utils \
    nm-applet \
    feh rofi scrot

sudo apt install \
    curl wget \
    ripgrep fzf neovim git tree htop

sudo snap install code --classic
sudo snap install alacritty --classic
sudo snap install spotify
sudo snap install vlc


latest=$(sudo apt-cache search nvidia-driver | \
	 egrep '^nvidia-driver-[0-9]{3}\s' |  \
	 sort -r | head -n 1 | \
	 egrep -o 'nvidia-driver-[0-9]{3}'^C);
sudo apt install "${latest}"


sudo apt remove docker docker-engine docker.io containerd runc
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo rm -rf ~/.docker
docker run hello-world

