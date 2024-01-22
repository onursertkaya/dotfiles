# cli tools
sudo apt update && \
	sudo apt install fzf bat xclip xsel git-delta;

sudo snap install ripgrep;

# vim-plug
sh -c \
    'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';

# hermit font
wget \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hermit.zip \
    -O /tmp/Hermit.zip && \
    unzip /tmp/Hermit.zip -d ~/.fonts && \
    fc-cache -f

