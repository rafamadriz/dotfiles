```
   ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
   ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
   ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
   ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██╗██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
```

> There's no place like ~/

This is my personal repository for configuration files of all the programs I use on a daily basis. This setup aims to be minimal while being pleasing to the eye and functional. The current colorscheme is based on [Nord](https://www.nordtheme.com/), but I plan to add more colorschemes (next is [Gruvbox](https://github.com/morhetz/gruvbox#dark-mode-1)) to my setup and maybe create an script to easily apply the new selected theme to all programs (polybar, terminal, rofi, firefox, GTK theme, etc).

| Program            | Name                                                           |
| :----------------- | :------------------------------------------------------------- |
| Linux Distribution | [Arch Linux](https://www.archlinux.org/)                       |
| Window Manager     | [bspwm](https://github.com/baskerville/bspwm)                  |
| Bar                | [polybar](https://github.com/jaagr/polybar)                    |
| Program Launcher   | [rofi](https://github.com/DaveDavenport/rofi)                  |
| Web Browser        | [Firefox](https://www.mozilla.org/en-US/firefox/new/)          |
| Code Editor        | [Nvim](https://neovim.io/)                                     |
| Terminal font      | [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads) |
| Shell              | [zsh](https://www.zsh.org/)                                    |
| Terminal Emulator  | [Kitty](https://sw.kovidgoyal.net/kitty/)                      |
| Music Player       | [ncmpcpp/mpd](https://github.com/ncmpcpp/ncmpcpp)              |
| RSS reader         | [newsboat](https://newsboat.org/)                              |

I try to have a very clean `$HOME` folder so all configs that can be in `~/.config/` are, and some environmental variables have been set in `~/.zshenv` to move configs into `~/.config/`

### Install dotfiles with all dependencies.

I have a very rudimentary install script that can:

- Install all my dotfiles in the correct file structure.
- Install all necessary dependencies.
- Install configuration files that give some sane defaults for `root`, like for example a decent `.bashrc` with a colored prompt and settings for `nvim` including a colorscheme. I did this mainly to have sane nvim defaults and a decent prompt for whenever I was doing something as root, like editing files that are not in `~/`

###### NOTE: The install script may overwrite files that you don't want to be overwritten, this script is mainly to be used in a clean new install of Arch Linux.

To download the script:

```sh
curl -LO https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/rais.sh
```

And then run the script with.

```sh
sh rais.sh
```

### Gallery

![2021-Mar-31_7](https://user-images.githubusercontent.com/67771985/114281723-89bdf480-9a2f-11eb-8642-f106f1dd0919.png)

![2021-Mar-31_5](https://user-images.githubusercontent.com/67771985/114281749-b4a84880-9a2f-11eb-8752-b83d9d6d857f.png)

![2021-Mar-31_6](https://user-images.githubusercontent.com/67771985/114281796-f9cc7a80-9a2f-11eb-9de3-7e0560705138.png)

![2021-Mar-31_3](https://user-images.githubusercontent.com/67771985/114281807-051fa600-9a30-11eb-9c3f-7bbc573a2a4f.png)

![screenshot](https://user-images.githubusercontent.com/67771985/114281830-26809200-9a30-11eb-83c7-aad203fed2ca.png)

![2021-03-31-114908_1920x1080_scrot](https://user-images.githubusercontent.com/67771985/114281849-4912ab00-9a30-11eb-9b9c-5a57f800b1fa.png)
![2021-Mar-31_4](https://user-images.githubusercontent.com/67771985/114281866-621b5c00-9a30-11eb-8302-e0455bf95a10.png)

![2021-Mar-31_1](https://user-images.githubusercontent.com/67771985/114281939-c5a58980-9a30-11eb-80c5-11161d769669.png)

![2021-Mar-31_2](https://user-images.githubusercontent.com/67771985/114281923-ac9cd880-9a30-11eb-9453-8dca3e5b1272.png)
