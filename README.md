# config

My Arch/Parabola and macOS configurations.

```sh
git clone git@github.com:lucasem/config
```

The main resource here is the [`Makefile`](./Makefile) which has a few
primary targets shown below. There are many other useful targets (e.g.
`files` or `vim`) that are used by the primary ones — take a look at the
Makefile to see what other targets there are, and what they do.

# Primary targets

### Arch Linux or Parabola GNU/Linux-libre

Before doing anything more: install sudo, enable privileges for a new user,
and log in as that user.

```sh
# install and configure most things (e.g. vim, zsh, git)
make
# setup gui (xorg, xmonad) for a macbook or VMWare vm
make gui-mac
make gui-vm
```

### macOS

Only one primary target for macs:

```sh
make mac
```
