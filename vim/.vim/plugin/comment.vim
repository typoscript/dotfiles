" ******************************************************
" Comment Plugin - Line & Range Commenting
" ******************************************************

let s:commentMap = {
	\ 'c': '//',
	\ 'cpp': '//',
	\ 'java': '//',
	\ 'javascript': '//',
	\ 'typescript': '//',
	\ 'javascriptreact': '//',
	\ 'typescriptreact': '//',
	\ 'rust': '//',
	\ 'go': '//',
	\ 'php': '//',
	\ 'cs': '//',
	\ 'swift': '//',
	\ 'kotlin': '//',
	\ 'scala': '//',
	\ 'dart': '//',
	\ 'python': '#',
	\ 'sh': '#',
	\ 'bash': '#',
	\ 'zsh': '#',
	\ 'ruby': '#',
	\ 'perl': '#',
	\ 'yaml': '#',
	\ 'toml': '#',
	\ 'make': '#',
	\ 'dockerfile': '#',
	\ 'vim': '"',
	\ 'lua': '--',
	\ 'sql': '--',
	\ 'haskell': '--',
	\ }

function! s:getCommentLeader()
	if has_key(s:commentMap, &filetype)
		return s:commentMap[&filetype]
	endif
	" Fallback to Vim's buffer commentstring (e.g. '/*%s*/', '# %s')
	if !empty(&commentstring) && &commentstring =~# '%s'
		let l:parts = split(&commentstring, '%s')
		if len(l:parts) > 0
			let l:leader = substitute(l:parts[0], '^\s*\|\s*$', '', 'g')
			if !empty(l:leader)
				return l:leader
			endif
		endif
	endif
	return ''
endfunction

" Add comment to current line or visually selected range
function! AddComment() range
	let l:leader = s:getCommentLeader()
	if empty(l:leader)
		echo "No comment leader defined for filetype: " . &filetype
		return
	endif
	let l:escaped = escape(l:leader, '\/*#^$.~[]')

	for l:lnum in range(a:firstline, a:lastline)
		let l:line = getline(l:lnum)
		" Skip empty lines
		if l:line =~# '^\s*$'
			continue
		endif
		let l:newline = substitute(l:line, '^\(\s*\)', '\1' . l:escaped . ' ', '')
		call setline(l:lnum, l:newline)
	endfor
endfunction

" Remove comment from current line or visually selected range
function! RemoveComment() range
	let l:leader = s:getCommentLeader()
	if empty(l:leader)
		return
	endif
	let l:escaped = escape(l:leader, '\/*#^$.~[]')

	for l:lnum in range(a:firstline, a:lastline)
		let l:line = getline(l:lnum)
		if l:line =~# '^\s*' . l:escaped
			let l:newline = substitute(l:line, '^\(\s*\)' . l:escaped . '\s\?', '\1', '')
			call setline(l:lnum, l:newline)
		endif
	endfor
endfunction

" Commands
command! -range AddComment <line1>,<line2>call AddComment()
command! -range RemoveComment <line1>,<line2>call RemoveComment()

" Key mappings (Normal & Visual mode)
nnoremap <silent> <Leader>// :call AddComment()<CR>
nnoremap <silent> <Leader>?? :call RemoveComment()<CR>
vnoremap <silent> <Leader>// :call AddComment()<CR>
vnoremap <silent> <Leader>?? :call RemoveComment()<CR>
