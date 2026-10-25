function AddComment()
	let fileType = {
		\ 'java':		'//',
		\ 'javascript': '//',
		\ 'typescript': '//',
		\ 'python':		'#',
		\ 'vim':		'"',
		\ }

	if has_key(fileType, &ft)
		exe 'norm i'.fileType[&ft].' '
	else
		return
	endif
endfunction

function RemoveComment()
	exe 'norm xx'
endfunction

" Comment selected lines by <Leader>//
vnoremap <leader>// :call AddComment()<Enter>

" Uncomment selected lines by <Leader>??
vnoremap <leader>?? :call RemoveComment()<Enter>
