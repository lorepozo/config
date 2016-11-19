all: start files
	@echo "run `make gui' to setup gui environment"

#############
### start ###
#############

start: lang lang-util clis service

lang:
	pacman -S python nodejs npm texlive-core

lang-util: py
	pacman -S texlive-latexextra texlive-genericextra

py:
	pacman -S ipython python-pip python-virtualenv
	pip install --upgrade pip # arch repo can be outdated
	pip install ptpython
	virtualenv ~/py

clis:
	pacman -S vim git hub zsh wget tree sudo neovim
	mkdir -p ~/bin
	curl -LSso ~/bin/diff-highlight "https://github.com/git/git/raw/master/contrib/diff-highlight/diff-highlight"
	chmod +x ~/bin/diff-highlight

service:
	pacman -S openssh
	systemctl enable sshd

#############
### files ###
#############

files: vim
	cp -r zsh ~/.zsh && ln -s ~/.zsh/zshrc ~/.zshrc
	cp gitconfig ~/.gitconfig

vim:
	mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.config
	cp init.vim ~/.vim/init.vim
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	hub clone vim-airline/vim-airline ~/.vim/bundle/vim-airline
	hub clone fatih/vim-go ~/.vim/bundle/vim-go
	hub clone elzr/vim-json ~/.vim/bundle/vim-json
	hub clone plasticboy/vim-markdown ~/.vim/bundle/vim-markdown
	hub clone digitaltoad/vim-pug ~/.vim/bundle/vim-pug
	ln -s ~/.vim ~/.config/nvim
	ln -s ~/.vim/init.vim ~/.vimrc

#############
###  gui  ###
#############

gui:
	@echo "select either gui-vm or gui-mac"

gui-vm: drivers xorg-vm xmonad
	@echo "you may need to install additional drivers"

gui-mac: drivers xorg-mac xmonad
	@echo "you may need to install additional drivers"

drivers:
	pacman -S xf86-input-synaptics nvidia

xorg:
	pacman -S xorg-server xorg-xinit xorg-server-utils xorg-xinit xorg-xrandr xorg-xrdb slim
	cp zlogin ~/.zlogin
	cp xinitrc ~/.xinitrc
	cp Xresources ~/.Xresources
	systemctl enable slim

xorg-vm: xorg
	[[ -f /etc/X11/xorg.conf ]] && mv /etc/X11/xorg.conf /etc/X11/xorg.old.conf
	cp xorg.vm.conf /etc/X11/xorg.conf

xorg-mac: xorg
	pacman -S acpid
	systemctl enable acpid
	nvidia-xconfig
	echo "install i915 /bin/false\ninstall intel_agp /bin/false\ninstall intel_gtt /bin/false" > /etc/modprobe.d/video.conf
	setpci -v -H1 -s 00:01.00 BRIDGE_CONTROL=0
	ln -s /sys/class/backlight/gmux_backlight/brightness ~/bin/backlight_screen
	ln -s /sys/devices/platform/applesmc.768/leds/smc::kbd_backlight/brightnes ~/bin/backlight_kbd
	cp xorg.mac.conf /etc/X11/xorg.conf

xmonad:
	pacman -S xmonad xmonad-contrib dmenu rxvt-unicode
	mkdir -p ~/.xmonad
	cp xmonad.hs ~/.xmonad/xmonad.hs

