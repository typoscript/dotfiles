" ******************************************************
" UI - Highlights & Statusline
" ******************************************************

" Mode mapping dictionary for Statusline
let g:currentMode = {
  \ 'n'      : 'NORMAL',
  \ 'v'      : 'VISUAL',
  \ 'V'      : 'V·LINE',
  \ "\<C-V>" : 'V·BLOCK',
  \ 's'      : 'SELECT',
  \ 'S'      : 'S·LINE',
  \ "\<C-S>" : 'S·BLOCK',
  \ 'i'      : 'INSERT',
  \ 'R'      : 'REPLACE',
  \ 'Rv'     : 'V·REPLACE',
  \ 'c'      : 'COMMAND',
  \ }

" Highlight Groups
hi Visual ctermbg=240
hi CursorLine cterm=NONE cterm=bold ctermbg=black
hi CursorLineNr cterm=NONE cterm=bold ctermfg=yellow
hi Pmenu ctermbg=white
hi PmenuSel ctermbg=195
hi clear SpellBad
hi Search ctermbg=LightYellow ctermfg=black

" Statusline Highlight Groups
hi statusline cterm=bold
hi statusline_mode cterm=bold ctermfg=black ctermbg=46
hi statusline_path ctermfg=white ctermbg=102

" Netrw Highlight
hi netrwMarkFile ctermfg=red
hi Directory ctermfg=220

" ******************************************************
" Statusline Helpers
" ******************************************************
function! StatuslineModTime()
	let l:file = expand('%')
	if !empty(l:file)
		let l:time = getftime(l:file)
		if l:time > 0
			return ' [' . strftime('%b %d %a %H:%M', l:time) . ']'
		endif
	endif
	return ''
endfunction

function! StatuslineFileSize()
	let l:file = expand('%')
	if !empty(l:file) && filereadable(l:file)
		let l:size = getfsize(l:file)
		if l:size > 0
			if exists('*ConvertByteToMegaByte')
				return printf(' | %.2fMB', ConvertByteToMegaByte(l:size))
			else
				return printf(' | %.2fMB', l:size / 1000000.0)
			endif
		endif
	endif
	return ''
endfunction

" ******************************************************
" Statusline Setup
" ******************************************************
set laststatus=2 " Always show statusline

set statusline=
set statusline+=%#statusline_mode#
set statusline+=\ %n
set statusline+=\ %{get(g:currentMode,\ mode(),\ mode())}
set statusline+=\ %m
set statusline+=%*

set statusline+=%#statusline_path#
set statusline+=\ %F
set statusline+=%*

set statusline+=%=
set statusline+=\ Ln:\ %l,\ Col:\ %c
set statusline+=\ \|\ %p%%
set statusline+=\ \|\ %Y
set statusline+=\ \|\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=%{StatuslineFileSize()}
set statusline+=%{StatuslineModTime()}
