# glow.vim

A Vim plugin to preview Markdown files by printing the output of Glow to a terminal buffer or popup.

<img width="2480" height="1334" alt="glow" src="https://github.com/user-attachments/assets/7ce27e64-48d7-4031-b2de-db351e6ad4fa" />

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
