all: start files
	@echo "run `make gui' to setup gui environment"

mac: mac-start files


#############
### start ###
#############

start: lang lang-util clis service
	chsh -s /bin/zsh

lang: rust
	sudo pacman -S python go nodejs npm texlive-core

rust:
	curl https://sh.rustup.rs -sSf | sh
	~/.cargo/bin/rustup update
	~/.cargo/bin/rustup install nightly

lang-util: py
	sudo pacman -S texlive-latexextra texlive-genericextra

py:
	sudo pacman -S ipython python-pip python-virtualenv
	pip install --upgrade pip # arch repo can be outdated
	sudo pip install ptpython
	virtualenv ~/.py

clis: pacaur
	sudo pacman -S git hub zsh wget tree tmux gnupg neovim jq
	cargo install ripgrep

pacaur:
	git clone https://aur.archlinux.org/cower.git
	cd cower && makepkg -si
	git clone https://aur.archlinux.org/pacaur.git
	cd pacaur && makepkg -si
	rm -rf cower pacaur

service:
	sudo pacman -S openssh mosh
	systemctl enable sshd


#################
### mac-start ###
#################

mac-start: brew mac-lang mac-clis alacritty
	chsh -s /bin/zsh

brew:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

mac-lang: mac-py rust
	brew install go
	brew cask install mactex

mac-py:
	brew install python3
	pip3 install virtualenv ipython ptpython
	virtualenv ~/.py

mac-clis:
	brew install hub wget tree tmux neovim reattach-to-user-namespace pass jq mosh
	cargo install ripgrep


#############
### files ###
#############

files: sh bins vim
	cp gitconfig ~/.gitconfig
	cp tmux.conf ~/.tmux.conf

sh:
	hub clone --recursive lucasem/zsh ~/.zsh && ln -s ~/.zsh/zshrc ~/.zshrc
	echo "source ~/.zsh/aliases.zsh" >>~/.bashrc
	echo "source ~/.zsh/environment.zsh" >>~/.bashrc
	source ~/.bashrc

bins:
	mkdir -p ~/bin
	curl -LSso ~/bin/diff-highlight http://github.com/git/git/raw/3dbfe2b8ae94cbdae5f3d32581aedaa5510fdc87/contrib/diff-highlight/diff-highlight
	curl -LSso ~/bin/tobase https://raw.githubusercontent.com/lucasem/tobase/master/tobase
	chmod +x ~/bin/diff-highlight ~/bin/tobase
	cp bin/* ~/bin/

vim: vim-config vim-langservers

vim-config:
	mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.config
	if [ `uname` = "Darwin" ]; then sed -i '' s/unknown-linux-musl/apple-darwin/ init.vim ; fi
	cp init.vim ~/.vim/init.vim
	curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -sfLo ~/.vim/autoload/plug.vim --create-dirs
	ln -s ~/.vim ~/.config/nvim
	ln -s ~/.vim/init.vim ~/.vimrc
	nvim --headless +PlugInstall +UpdateRemotePlugins +qa

vim-langservers:
	source ~/.py/bin/activate
	pip install neovim python-language-server
	rustup install nightly-2018-01-20
	rustup run nightly-2018-01-20 cargo install rustfmt-nightly
	rustup component add rls-preview rust-analysis rust-src --toolchain nightly-2018-01-20
	npm i -g javascript-typescript-langserver
	go get -u github.com/sourcegraph/go-langserver
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

applications: alacritty
	sudo pacman -S firefox
	pacaur -S slack-beta

alacritty:
	hub clone jwilm/alacritty
	cd alacritty && cargo build --release
	mkdir -p /usr/local/bin
	sudo mv alacritty/target/release/alacritty /usr/local/bin/alacritty
	rm -rf alacritty
	mkdir -p ~/.config/alacritty
	cp alacritty.yml ~/.config/alacritty/alacritty.yml
