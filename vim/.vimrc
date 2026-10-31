" ******************************************************
" Main Vim Configuration (.vimrc)
" ******************************************************

set nocompatible         " Set Vim not to be compatible with 'vi'
runtime ftplugin/man.vim " Enable man.vim to allow ':Man [command]' in vim
syntax enable
filetype plugin indent on

" ******************************************************
" Cross-Platform Clipboard Integration
" ******************************************************
let s:clip = '/mnt/c/Windows/System32/clip.exe'

if executable(s:clip)
  " WSL Environment
  set clipboard=unnamed
  if exists('##TextYankPost')
    augroup WSLYank
      autocmd!
      autocmd TextYankPost * if v:event.operator ==# 'y' | call system('printf %s '.shellescape(join(v:event.regcontents, "\n")).' | '.s:clip) | endif
    augroup END
  endif
elseif has('win32') || has('win64')
  " Windows Native (CMD / PowerShell / gVim)
  set clipboard=unnamed,unnamedplus
elseif has('mac') || has('macunix') || (has('unix') && system('uname -s') =~? 'Darwin')
  " macOS Environment (sync with pbcopy/pbpaste)
  set clipboard=unnamed,unnamedplus
else
  " Linux (X11 / Wayland)
  set clipboard^=unnamed,unnamedplus
endif

" ******************************************************
" Load Modular Configurations (Portable Path Detection)
" ******************************************************
let s:vim_dir = expand('<sfile>:p:h') . '/.vim'
if !isdirectory(s:vim_dir)
  let s:vim_dir = expand('$HOME/.vim')
  if !isdirectory(s:vim_dir)
    let s:vim_dir = expand('$HOME/vimfiles')
  endif
endif

for s:module in ['options.vim', 'functions.vim', 'keymaps.vim', 'ui.vim', 'autocmds.vim']
  let s:module_path = s:vim_dir . '/' . s:module
  if filereadable(s:module_path)
    execute 'source ' . fnameescape(s:module_path)
  endif
endfor

" Note: Files in <vim_dir>/plugin/*.vim are automatically
" loaded by Vim's runtimepath on startup (no manual source needed).
