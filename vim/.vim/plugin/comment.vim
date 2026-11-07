" ******************************************************
" Comment Plugin - Line & Range Commenting
"   한 줄 주석 언어:  // foo
"   블록 주석 언어:  <!-- foo -->, /* foo */ (줄마다 열고 닫음)
" ******************************************************

" filetype -> [여는 기호, 닫는 기호]
let s:commentMap = {
	\ 'c': ['//', ''],
	\ 'cpp': ['//', ''],
	\ 'java': ['//', ''],
	\ 'javascript': ['//', ''],
	\ 'typescript': ['//', ''],
	\ 'javascriptreact': ['//', ''],
	\ 'typescriptreact': ['//', ''],
	\ 'rust': ['//', ''],
	\ 'go': ['//', ''],
	\ 'php': ['//', ''],
	\ 'cs': ['//', ''],
	\ 'swift': ['//', ''],
	\ 'kotlin': ['//', ''],
	\ 'scala': ['//', ''],
	\ 'dart': ['//', ''],
	\ 'python': ['#', ''],
	\ 'sh': ['#', ''],
	\ 'bash': ['#', ''],
	\ 'zsh': ['#', ''],
	\ 'ruby': ['#', ''],
	\ 'perl': ['#', ''],
	\ 'yaml': ['#', ''],
	\ 'toml': ['#', ''],
	\ 'make': ['#', ''],
	\ 'dockerfile': ['#', ''],
	\ 'vim': ['"', ''],
	\ 'lua': ['--', ''],
	\ 'sql': ['--', ''],
	\ 'haskell': ['--', ''],
	\ 'html': ['<!--', '-->'],
	\ 'xml': ['<!--', '-->'],
	\ 'markdown': ['<!--', '-->'],
	\ 'css': ['/*', '*/'],
	\ 'scss': ['//', ''],
	\ }

" [여는 기호, 닫는 기호] 반환. 정의가 없으면 Vim 의 'commentstring' 사용 (예: '/*%s*/')
function! s:getCommentParts()
	if has_key(s:commentMap, &filetype)
		return s:commentMap[&filetype]
	endif
	if &commentstring =~# '%s'
		let l:idx = stridx(&commentstring, '%s')
		let l:left = trim(strpart(&commentstring, 0, l:idx))
		let l:right = trim(strpart(&commentstring, l:idx + 2))
		if !empty(l:left)
			return [l:left, l:right]
		endif
	endif
	return ['', '']
endfunction

" Add comment to current line or visually selected range
function! AddComment() range
	let [l:left, l:right] = s:getCommentParts()
	if empty(l:left)
		echo "No comment leader defined for filetype: " . &filetype
		return
	endif

	for l:lnum in range(a:firstline, a:lastline)
		let l:line = getline(l:lnum)
		" Skip empty lines
		if l:line =~# '^\s*$'
			continue
		endif
		let l:indent = matchstr(l:line, '^\s*')
		let l:body = strpart(l:line, len(l:indent))
		let l:newline = l:indent . l:left . ' ' . l:body . (empty(l:right) ? '' : ' ' . l:right)
		call setline(l:lnum, l:newline)
	endfor
endfunction

" Remove comment from current line or visually selected range
function! RemoveComment() range
	let [l:left, l:right] = s:getCommentParts()
	if empty(l:left)
		return
	endif
	" \V (very nomagic): 주석 기호를 정규식이 아닌 문자 그대로 비교
	let l:leftPat = '\V\^\(\s\*\)' . escape(l:left, '\') . '\s\?'
	let l:rightPat = '\V\s\?' . escape(l:right, '\') . '\s\*\$'

	for l:lnum in range(a:firstline, a:lastline)
		let l:line = getline(l:lnum)
		if l:line !~# l:leftPat
			continue
		endif
		let l:newline = substitute(l:line, l:leftPat, '\1', '')
		if !empty(l:right)
			let l:newline = substitute(l:newline, l:rightPat, '', '')
		endif
		call setline(l:lnum, l:newline)
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
