let mapleader = ' '

let @/="" " Remove search highlight after "source .vimrc" command

" currentMode variable for statusline
let g:currentMode = {
	\ 'n'  : 'NORMAL',
	\ 'v'  : 'VISUAL',
	\ 'V'  : 'V·LINE',
	\ '' : 'V·BLOCK',
	\ 's'  : 'SELECT',
	\ 'S'  : 'S·LINE',
	\ '' : 'S·BLOCK',
	\ 'i'  : 'INSERT',
	\ 'R'  : 'REPLACE',
	\ 'Rv' : 'V·REPLACE',
	\ 'c'  : 'COMMAND',
	\}


let g:netrw_winsize     = 30								" Set Netrw window's width to be 30
let g:netrw_liststyle   = 3									" Show tree listing in Netrw file browsing
let g:netrw_bufsettings = 'noma nomad nu nowrap ro nobl'	" Show number line to Netrw
let g:netrw_banner		= 0

let &t_SI = "\e[6 q" " Show vertical cursor in Insert Mode
let &t_EI = "\e[2 q" " Show bar cursor in other modes
