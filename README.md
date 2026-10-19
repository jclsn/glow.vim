# glow.vim

A Vim plugin to preview Markdown files by printing the output of Glow to a terminal buffer or popup.

<img width="2481" height="1317" alt="glow" src="https://github.com/user-attachments/assets/3d74f35b-3a24-4762-a74e-c6d506d96780" />

## Dependencies

- [glow](https://github.com/charmbracelet/glow)

## Installation

Add `jclsn/glow.vim` to your favorite plugin manager e.g. for [vim-plug](https://github.com/junegunn/vim-plug) add

```vim
Plug 'jclsn/glow.vim'
```

to your .vimrc.

## Commands

| Command | Description |
| --- | --- |
| `:Glow` | Render the current in the current buffer |
| `:Glowsplit` | Render the current file in a split |
| `:Glowpop` | Render the current file in a popup |
