arch: arch-start files
	@echo "run `make gui' to setup gui environment"

ubuntu: ubuntu-start files

mac: mac-start files


##############
### ubuntu ###
##############

ubuntu-start: ubuntu-essential ubuntu-lang ubuntu-clis
	sudo chsh -s /bin/zsh

ubuntu-essential:
	sudo apt-get -y update
	sudo apt-get -y install build-essential

ubuntu-lang: rust ubuntu-py
	sudo apt-get -y install nodejs npm texlive texlive-latex-extra

ubuntu-py:
	sudo apt install python3.8-venv
	pip install --upgrade pip
	pip install ipython ptpython
	python -m venv ~/.py

ubuntu-clis:
	sudo apt install zsh mosh tmux gnupg pass jq bat ripgrep
	~/.cargo/bin/cargo install --locked zellij eza sd fd-find git-delta
	~/.cargo/bin/cargo install --locked --bin jj jj-cli

############
### arch ###
############

arch-start: arch-lang arch-lang-util arch-clis arch-service
	chsh -s /bin/zsh

arch-lang: rust
	sudo pacman -S python go nodejs npm texlive-core

arch-lang-util: arch-py
	sudo pacman -S texlive-latexextra texlive-genericextra

arch-py:
	sudo pacman -S python-pip
	pip install --upgrade pip # arch repo can be outdated
	sudo pip install ipython ptpython
	python -m venv ~/.py

arch-clis: trizen
	sudo pacman -S git zsh mosh tmux zellij gnupg pass jq eza sd bat fd ripgrep git-delta
	~/.cargo/bin/cargo install --locked --bin jj jj-cli

trizen:
	git clone https://aur.archlinux.org/trizen.git
	cd trizen && makepkg -si

arch-service:
	sudo pacman -S openssh
	sudo systemctl enable sshd

###########
### mac ###
###########

mac-start: brew mac-lang mac-clis mac-alacritty mac-hammerspoon
	chsh -s /bin/zsh

brew:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

mac-lang: mac-py
	brew install go
	brew cask install mactex

mac-py:
	brew install python3
	pip3 install virtualenv ipython ptpython
	virtualenv ~/.py

mac-clis:
	brew install mosh tmux zellij pass jq eza sd bat fd ripgrep git-delta jj

mac-alacritty:
	brew cask install alacritty

mac-hammerspoon:
	brew install hammerspoon
	mkdir -p ~/.hammerspoon
	cp hammerspoon.lua ~/.hammerspoon/init.lua

####################
### other common ###
####################

rust:
	curl https://sh.rustup.rs -sSf | sh
	~/.cargo/bin/rustup update


#############
### files ###
#############

files: sh bins vim
	cp gitconfig ~/.gitconfig
	cp tmux.conf ~/.tmux.conf
	mkdir -p ~/.config/alacritty && cp alacritty.toml ~/.config/alacritty/alacritty.toml
	cp -r zellij ~/.config/
	curl -LSso ~/.config/zellij/zjstatus.wasm https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm

sh:
	git clone --recursive https://github.com/lorepozo/zsh ~/.zsh && ln -sf ~/.zsh/zshrc ~/.zshrc
	echo "source ~/.zsh/aliases.zsh" >>~/.bashrc
	echo "source ~/.zsh/environment.zsh" >>~/.bashrc

bins:
	mkdir -p ~/bin
	curl -LSso ~/bin/tobase https://raw.githubusercontent.com/lorepozo/tobase/master/tobase
	chmod +x ~/bin/tobase
	cp bin/* ~/bin/

vim: vim-config # vim-langservers

vim-config:
	mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/.config
	if [ `uname` = "Darwin" ]; then sed -i '' s/unknown-linux-musl/apple-darwin/ init.vim ; fi
	cp init.vim ~/.vim/init.vim
	cp colors.vim ~/.vim/colors/lore.vim
	curl -LSso ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -s ~/.vim/init.vim ~/.vimrc
	vim -c PlugUpgrade -c PlugInstall -c PlugUpdate -c qa

vim-langservers:
	sudo pip3 install python-language-server
	~/.cargo/bin/rustup component add rust-src rust-analyzer
	#npm i -g javascript-typescript-langserver
	#go get -u github.com/sourcegraph/go-langserver
	cp language_client_settings.json ~/.vim/language_client_settings.json

#############
###  gui  ###
#############

gui:
	@echo "select either gui-vm or gui-mac"

gui-vm: xorg-vm gui-general
	@echo "you may need to install additional drivers"

gui-mac: xorg-mac gui-general
	@echo "you may need to install additional drivers"

gui-general: drivers xmonad applications

drivers:
	sudo pacman -S xf86-input-synaptics nvidia

xorg:
	sudo pacman -S xorg-server xorg-xinit xorg-server-utils xorg-xinit xorg-xrandr xorg-xrdb slim
	cp zlogin ~/.zlogin
	cp xinitrc ~/.xinitrc
	cp Xresources ~/.Xresources
	systemctl enable slim

xorg-vm: xorg
	[[ -f /etc/X11/xorg.conf ]] && mv /etc/X11/xorg.conf /etc/X11/xorg.old.conf
	cp xorg.vm.conf /etc/X11/xorg.conf

xorg-mac: xorg
	sudo pacman -S acpid
	systemctl enable acpid
	nvidia-xconfig
	echo "install i915 /bin/false\ninstall intel_agp /bin/false\ninstall intel_gtt /bin/false" > /etc/modprobe.d/video.conf
	setpci -v -H1 -s 00:01.00 BRIDGE_CONTROL=0
	ln -s /sys/class/backlight/gmux_backlight/brightness ~/bin/backlight_screen
	ln -s /sys/devices/platform/applesmc.768/leds/smc::kbd_backlight/brightnes ~/bin/backlight_kbd
	cp xorg.mac.conf /etc/X11/xorg.conf

xmonad:
	sudo pacman -S xmonad xmonad-contrib rofi
	mkdir -p ~/.xmonad
	cp xmonad.hs ~/.xmonad/xmonad.hs
	mkdir -p ~/.config/rofi
	cp rofi.config ~/.config/rofi/config

applications:
	sudo pacman -S firefox
	sudo pacman -S alacritty
