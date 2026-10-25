" ******************************************************
" Global Autocommands (Protected with augroup)
" ******************************************************

augroup VimUserAutoCmds
  autocmd!

  " Statusline window focus styling
  autocmd BufLeave,WinLeave * setlocal statusline=%f\ %m
  autocmd BufEnter,WinEnter * setlocal statusline=

  " Terminal statusline
  if exists('##TerminalOpen')
    autocmd TerminalOpen * setlocal statusline=%f
  endif

  " Automatically wipe Netrw buffer when leaving
  autocmd FileType netrw setlocal bufhidden=wipe
augroup END
