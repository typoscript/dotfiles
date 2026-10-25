" cterm and gui values are from Xterm256 Colors
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim

" Selected Text
hi Visual ctermbg=240

" Cursorline
hi CursorLine cterm=NONE cterm=bold ctermbg=black	" cterm removes underline
hi CursorLineNr cterm=NONE cterm=bold ctermfg=yellow " Remove underline for current line num

" Auto Completion Menu
hi Pmenu ctermbg=white
hi PmenuSel ctermbg=195

hi clear SpellBad " Remove spelling error highlighting
hi Search ctermbg=LightYellow ctermfg=black " Search Highlighting

" ******************************************************
" Statusline
" ******************************************************
hi statusline cterm=bold

" Statusline Groups from statusline.vim
hi statusline_mode cterm=bold ctermfg=black ctermbg=46
hi statusline_path ctermfg=white ctermbg=102

" ******************************************************
" Netrw
" ******************************************************
" Marked dir & file in Netrw
hi netrwMarkFile ctermfg=red

" Directory in Netrw
hi Directory ctermfg=220
