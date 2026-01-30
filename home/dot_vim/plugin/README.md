# Vim Plugins

This directory is managed by chezmoi and contains vim-plug for plugin management.

## Plugin Manager

We use [vim-plug](https://github.com/junegunn/vim-plug) as the plugin manager.
The plug.vim file is located in `~/.vim/autoload/plug.vim`.

## Installing Plugins

Plugins are defined in `~/.vimrc`. To install them:

1. Open vim
2. Run `:PlugInstall`

## Updating Plugins

To update all plugins:

1. Open vim
2. Run `:PlugUpdate`

## Included Plugins

The following plugins are configured in the vimrc:

- **NERDTree** - File explorer sidebar
- **vim-airline** - Enhanced status line
- **vim-gitgutter** - Git diff indicators in the gutter
- **vim-fugitive** - Git wrapper
- **fzf.vim** - Fuzzy file finder
- **vim-commentary** - Easy code commenting
- **vim-surround** - Surround text with quotes/brackets
- **vim-polyglot** - Language pack for syntax highlighting
- **ale** - Asynchronous linting engine
- **vim-startify** - Start screen with recent files

## Color Schemes

Two color schemes are included:
- `onedark` - Atom's One Dark theme
- `gruvbox` - Retro groove color scheme

Set your preferred scheme in `~/.vimrc` with:
```vim
colorscheme onedark
" or
colorscheme gruvbox
```
