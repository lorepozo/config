# config

My computer configuration.

The main resource here is the [`Makefile`](./Makefile) which has a few
primary targets shown below. There are many other useful targets (e.g.
`files` or `vim`) that are used by the primary ones — take a look at the
Makefile to see what other targets there are, and what they do.

# Primary targets

### macOS

Only one primary target for macs:

```sh
make mac
```

### Arch Linux or Parabola GNU/Linux-libre

First: install sudo, enable privileges for a new user, and log in as that user.

```sh
# install and configure most things (e.g. vim, zsh, git)
make
# setup gui (xorg, xmonad) for a macbook or VMWare vm
make gui-mac
make gui-vm
```
