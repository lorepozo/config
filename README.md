# arch-init

My arch configuration. When cloning, be sure to use the recursive flag to
also download the submodules:

```sh
git clone --recursive git@github.com:lucasem/arch-init
```

The main resource here is the [`Makefile`](./Makefile) which has a few
primary targets:

```sh
# install and configure most things (e.g. vim, zsh, git)
make
# setup gui (xorg, xmonad) for a macbook or VMWare vm
make gui-mac
make gui-vm
```

There are many other useful targets (e.g. `files` or `vim`) that are covered
by the primary ones. Take a look at the Makefile to see what other targets
there are, and what they do.

