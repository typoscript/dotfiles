set nocompatible         " Set Vim not to be compatible with 'vi'

runtime ftplugin/man.vim " Enable man.vim to allow 'man [shell command]' in vim

syntax enable

" ******************************************************
" Source Files (files with no dependency)
" ******************************************************
source $HOME/.vim/abbrevs.vim
source $HOME/.vim/autocmds.vim
source $HOME/.vim/commands.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/highlights.vim
source $HOME/.vim/lets.vim
source $HOME/.vim/mappings.vim
source $HOME/.vim/set.vim
source $HOME/.vim/snippets.vim
source $HOME/.vim/statuslines.vim

" ******************************************************
" Plugins
" ******************************************************
source $HOME/.vim/plugin/compile.vim
source $HOME/.vim/plugin/convertNumbers.vim
source $HOME/.vim/plugin/file.vim
source $HOME/.vim/plugin/numberSystem.vim
source $HOME/.vim/plugin/print.vim

" ******************************************************
" WSL Clipboard Integration (safe on macOS/Linux)
" ******************************************************
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\n")).' | '.s:clip)
  augroup END
endif
