" HTML specific tag completion
function! s:htmlEnter()
	let l:line = getline('.')
	let l:col = col('.')
	let l:before = (l:col > 1) ? l:line[:l:col - 2] : ''

	let l:tagMatch = matchstr(l:before, '<[a-zA-Z0-9_\-]\+\%(\s\+[^>]*\)\?>$')
	if !empty(l:tagMatch)
		if l:tagMatch =~# '/>$' || l:tagMatch =~# '^</' || l:tagMatch =~# '^<[!%?]'
			return "\<CR>"
		endif
		let l:tagName = matchstr(l:tagMatch, '^<\zs[a-zA-Z0-9_\-]\+')
		let l:voidTags = ['area','base','br','col','embed','hr','img','input','link','meta','param','source','track','wbr']
		if index(l:voidTags, tolower(l:tagName)) != -1
			return "\<CR>"
		endif
		return "\<CR></" . l:tagName . ">\<Esc>O"
	endif
	return "\<CR>"
endfunction

function! s:htmlTab()
	let l:line = getline('.')
	let l:col = col('.')
	let l:before = (l:col > 1) ? l:line[:l:col - 2] : ''

	let l:tagMatch = matchstr(l:before, '<[a-zA-Z0-9_\-]\+\%(\s\+[^>]*\)\?>$')
	if !empty(l:tagMatch)
		if l:tagMatch =~# '/>$' || l:tagMatch =~# '^</' || l:tagMatch =~# '^<[!%?]'
			return "\<Tab>"
		endif
		let l:tagName = matchstr(l:tagMatch, '^<\zs[a-zA-Z0-9_\-]\+')
		let l:voidTags = ['area','base','br','col','embed','hr','img','input','link','meta','param','source','track','wbr']
		if index(l:voidTags, tolower(l:tagName)) != -1
			return "\<Tab>"
		endif
		return "</" . l:tagName . ">\<C-o>F<"
	endif
	return "\<Tab>"
endfunction

inoremap <buffer> <silent> <CR> <C-r>=<SID>htmlEnter()<CR>
inoremap <buffer> <silent> <Tab> <C-r>=<SID>htmlTab()<CR>
