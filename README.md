# Install

1/ Install nix
2/ Enable nix-command and flakes
3/ Install home-manager:
```bash
nix profile install home-manager
```
4/ Install this repo as .config/home-manager
```bash
git clone http://github.com/oux/dotfiles_scripts --recurse-submodules ~/.config/home-manager
home-manager switch
```
5/ Apply dotfiles (not managed by home-manager to still have editable symlinks pointing directly to this git)
~/.config/home-manager/dotfiles/setup.sh
