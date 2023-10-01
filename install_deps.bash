sudo apt update && \
sudo apt install fzf bat && \
sudo snap install ripgrep;

wget \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hermit.zip \
    -O /tmp/Hermit.zip && \
    unzip /tmp/Hermit.zip -d ~/.fonts && \
    fc-cache -f

