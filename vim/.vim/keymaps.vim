" ******************************************************
" Keymaps (merged mappings.vim, abbrevs.vim, snippets.vim)
" ******************************************************

" Normal / Insert Mode Navigation
inoremap jk <Esc>
inoremap a' <Esc><S-a>

" Cancel command in Command-line Mode
cnoremap qq <C-c>

" Delete line without storing into default register
nnoremap d_ "_dd

" Copy from current column to end of line
nnoremap Y y$

" Command-line Mode Navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" ******************************************************
" Leader Switches
" ******************************************************
nnoremap <Leader>nh :noh<Return>
nnoremap <Leader>l  :set list<Cr>
nnoremap <Leader>nl :set nolist<Cr>

" File Explorer (Netrw)
nnoremap <Leader>e :Lex<Cr>
nnoremap - :e %:h<Cr>

" Window Quit
nnoremap <Leader>qa :qa!<Cr>
nnoremap <Leader>qq :q<Cr>

" Window Navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Window Resize
nnoremap <Up>    <C-w>+
nnoremap <Down>  <C-w>-
nnoremap <Left>  <C-w><
nnoremap <Right> <C-w>>

" ******************************************************
" Shortcuts & Aliases
" ******************************************************
nnoremap ; :
vnoremap ; :
cnoremap vt vert
vnoremap <Leader><Leader> <Esc>

" Command-line Abbreviations (Only expand at command position)
function! s:cmdAlias(from, to)
	return (getcmdtype() ==# ':' && getcmdline() ==# a:from) ? a:to : a:from
endfunction

cnoreabbrev <expr> vrc <SID>cmdAlias('vrc', 'tabe ~/.vimrc')
cnoreabbrev <expr> tv  <SID>cmdAlias('tv', 'tabe ~/.vimrc')
cnoreabbrev <expr> th  <SID>cmdAlias('th', 'tab help')
cnoreabbrev <expr> vp  (getcmdtype() ==# ':' && getcmdline() =~# '\<vp$') ? '~/.vim/' : 'vp'

" ******************************************************
" Code Snippets (snippets.vim) - Portable relative path
" ******************************************************
let s:snip_dir = expand('<sfile>:p:h') . '/snippets'
execute 'nnoremap snp.html :r ' . s:snip_dir . '/skeleton.html<CR>'
execute 'nnoremap snp.java :r ' . s:snip_dir . '/skeleton.java<CR>'
execute 'nnoremap snp.rfc  :r ' . s:snip_dir . '/skeleton-react.js<CR>'

" ******************************************************
" Brackets and Quotes Surrounding
" ******************************************************
" Surround inner word (ciw)
nnoremap sw" ciw""<Esc>hpl
nnoremap sw' ciw''<Esc>hpl
nnoremap sw( ciw()<Esc>hpl
nnoremap sw[ ciw[]<Esc>hpl
nnoremap sw{ ciw{}<Esc>hpl

" Surround a word with trailing whitespace (caw) - replaces "aw/'aw to prevent hijacking registers/marks
nnoremap sa" caw""<Esc>hpl
nnoremap sa' caw''<Esc>hpl
nnoremap sa( caw()<Esc>hpl
nnoremap sa[ caw[]<Esc>hpl
nnoremap sa{ caw{}<Esc>hpl

" ******************************************************
" Auto Close Pairs & Smart Brackets (Zero Latency)
" ******************************************************
function! s:closePair(char)
	let l:line = getline('.')
	let l:col = col('.')
	if l:line[l:col - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction

function! s:quotePair(char)
	let l:line = getline('.')
	let l:col = col('.')
	let l:nextChar = l:line[l:col - 1]
	if l:nextChar == a:char
		return "\<Right>"
	" Do not auto-pair apostrophes in English contractions (e.g., don't, it's)
	elseif a:char == "'" && l:col > 1 && l:line[l:col - 2] =~# '\w'
		return "'"
	else
		return a:char . a:char . "\<Left>"
	endif
endfunction

function! s:backspacePair()
	let l:line = getline('.')
	let l:col = col('.')
	if l:col > 1
		let l:prevChar = l:line[l:col - 2]
		let l:nextChar = l:line[l:col - 1]
		if (l:prevChar == '(' && l:nextChar == ')') ||
		 \ (l:prevChar == '[' && l:nextChar == ']') ||
		 \ (l:prevChar == '{' && l:nextChar == '}') ||
		 \ (l:prevChar == '"' && l:nextChar == '"') ||
		 \ (l:prevChar == "'" && l:nextChar == "'") ||
		 \ (l:prevChar == '`' && l:nextChar == '`')
			return "\<Right>\<BS>\<BS>"
		endif
	endif
	return "\<BS>"
endfunction

function! s:smartEnter()
	let l:line = getline('.')
	let l:col = col('.')
	if l:col > 1
		let l:prevChar = l:line[l:col - 2]
		let l:nextChar = l:line[l:col - 1]
		if (l:prevChar == '{' && l:nextChar == '}') ||
		 \ (l:prevChar == '(' && l:nextChar == ')') ||
		 \ (l:prevChar == '[' && l:nextChar == ']')
			return "\<CR>\<Esc>O"
		endif
	endif
	return "\<CR>"
endfunction

" Opening pairs
inoremap <silent> ( ()<Left>
inoremap <silent> [ []<Left>
inoremap <silent> { {}<Left>

" Closing pairs (step-over if already present)
inoremap <silent> ) <C-r>=<SID>closePair(')')<CR>
inoremap <silent> ] <C-r>=<SID>closePair(']')<CR>
inoremap <silent> } <C-r>=<SID>closePair('}')<CR>

" Quotes (auto-pair or step-over)
inoremap <silent> " <C-r>=<SID>quotePair('"')<CR>
inoremap <silent> ' <C-r>=<SID>quotePair("'")<CR>
inoremap <silent> ` <C-r>=<SID>quotePair('`')<CR>

" Smart Enter between bracket pairs
inoremap <silent> <CR> <C-r>=<SID>smartEnter()<CR>

" Smart Backspace (delete pair together)
inoremap <silent> <BS> <C-r>=<SID>backspacePair()<CR>
