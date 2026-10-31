" ******************************************************
" Checklist Plugin - Markdown & Plain Text Task Lists
" Inspired by https://github.com/evansalter/vim-checklist
" ******************************************************

" Filetypes where checklist newline continuation and buffer mappings are active
let g:checklist_filetypes = get(g:, 'checklist_filetypes', ['markdown', 'text'])

function! s:isChecklistFileType()
	return index(g:checklist_filetypes, &filetype) != -1
endfunction

" Handle smart Enter key in insert mode for checklist items
function! s:checklistNewline()
	if !s:isChecklistFileType()
		return "\n"
	endif

	let l:line = getline('.')

	" 1. If line is an empty checkbox item, clear the checkbox to stop the list
	if l:line =~# '^\s*\([*+-]\s\+\)\?\[[ xX]\]\s*$'
		call setline('.', substitute(l:line, '\([*+-]\s\+\)\?\[[ xX]\]\s*$', '', ''))
		return ""
	endif

	" 2. If line starts with a checkbox item, continue list on next line with [ ]
	let l:match = matchstr(l:line, '^\s*\zs\([*+-]\s\+\)\?\[[ xX]\]')
	if !empty(l:match)
		let l:prefix = substitute(l:match, '\[[xX]\]', '[ ]', '') . ' '
		if !&autoindent
			let l:prefix = matchstr(l:line, '^\s*') . l:prefix
		endif
		return "\n" . l:prefix
	endif

	" 3. Default newline
	return "\n"
endfunction

" Toggle [ ] <-> [x] or add checkbox to current line / selection
function! ToggleCheckbox() range
	let l:start = a:firstline
	let l:end = a:lastline

	for l:lnum in range(l:start, l:end)
		let l:line = getline(l:lnum)

		" Unchecked box -> checked box ([ ] -> [x])
		if l:line =~# '^\(\s*\([*+-]\s\+\)\?\)\[ \]'
			let l:newline = substitute(l:line, '^\(\s*\([*+-]\s\+\)\?\)\[ \]', '\1[x]', '')
			call setline(l:lnum, l:newline)
		" Checked box -> unchecked box ([x] or [X] -> [ ])
		elseif l:line =~# '^\(\s*\([*+-]\s\+\)\?\)\[[xX]\]'
			let l:newline = substitute(l:line, '^\(\s*\([*+-]\s\+\)\?\)\[[xX]\]', '\1[ ]', '')
			call setline(l:lnum, l:newline)
		" Bullet without checkbox -> add [ ]
		elseif l:line =~# '^\(\s*[*+-]\s\+\)'
			let l:newline = substitute(l:line, '^\(\s*[*+-]\s\+\)', '\1[ ] ', '')
			call setline(l:lnum, l:newline)
		" Non-empty plain text -> prepend '- [ ] '
		elseif l:line =~# '\S'
			let l:newline = substitute(l:line, '^\(\s*\)', '\1- [ ] ', '')
			call setline(l:lnum, l:newline)
		endif
	endfor
endfunction

" User command
command! -range ToggleCheckbox <line1>,<line2>call ToggleCheckbox()

" Global leader mappings for convenience
nnoremap <silent> <Leader>x :ToggleCheckbox<CR>
vnoremap <silent> <Leader>x :ToggleCheckbox<CR>

" Buffer-local Enter key mapping scoped strictly to checklist filetypes
function! s:setupChecklistBuffer()
	inoremap <buffer> <CR> <C-r>=<SID>checklistNewline()<CR>
endfunction

augroup ChecklistAutoCmds
	autocmd!
	autocmd FileType * if s:isChecklistFileType() | call s:setupChecklistBuffer() | endif
augroup END
