" ******************************************************
" Main Vim Configuration (.vimrc)
" ******************************************************

set nocompatible         " Set Vim not to be compatible with 'vi'
runtime ftplugin/man.vim " Enable man.vim to allow ':Man [command]' in vim
syntax enable
filetype plugin indent on

" ******************************************************
" Cross-Platform Clipboard Integration (macOS / WSL / Linux)
" ******************************************************
let s:clip = '/mnt/c/Windows/System32/clip.exe'

if executable(s:clip)
  " WSL Environment
  set clipboard=unnamed
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\n")).' | '.s:clip)
  augroup END
elseif has('mac') || has('macunix') || system('uname -s') =~? 'Darwin'
  " macOS Environment (sync with pbcopy/pbpaste)
  set clipboard=unnamed,unnamedplus
else
  " Linux (X11 / Wayland)
  set clipboard^=unnamed,unnamedplus
endif

" ******************************************************
" Load Modular Configurations
" ******************************************************
source $HOME/.vim/options.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/keymaps.vim
source $HOME/.vim/ui.vim
source $HOME/.vim/autocmds.vim

" Note: Files in $HOME/.vim/plugin/*.vim are automatically
" loaded by Vim's runtimepath on startup (no manual source needed).
