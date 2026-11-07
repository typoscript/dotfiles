" ******************************************************
" Show - Echo Value
" ******************************************************
function! ShowCurrentFilePath()
	call clipboard#copy(expand('%:p'))
	echo expand('%:p')
endfunction
	
" ******************************************************
" Get - Return Result Value
" ******************************************************
function! GetFileSize()
	let l:file = expand('%')
	return empty(l:file) ? 0 : getfsize(l:file)
endfunction

" ******************************************************
" Copy - Copy Result to Clipboard
" ******************************************************
function! CopyCurrentFileName()
	let l:name = fnamemodify(expand('%'), ':t')
	call clipboard#copy(l:name)
	echo l:name
endfunction

command! ShowCurrentFilePath call ShowCurrentFilePath()
command! GetFileSize call GetFileSize()
command! CopyCurrentFileName call CopyCurrentFileName()
