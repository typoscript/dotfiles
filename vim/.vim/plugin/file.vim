" ******************************************************
" Show - Echo Value
" ******************************************************
function ShowCurrentFilePath()
	execute ":redir @+ | echo ".string(expand('%:p')). " | redir END"
endfunction
	
" ******************************************************
" Get - Return Result Value
" ******************************************************
function GetFileSize()
	return getfsize(expand(@%))
endfunction

" ******************************************************
" Copy - Copy Result to Clipboard
" ******************************************************
function CopyCurrentFileName()
    execute ":let @+ = fnamemodify(expand('%'), ':t')"
endfunction

command! ShowCurrentFilePath :call ShowCurrentFilePath()
command! GetFileSize :call GetFileSize()
command! CopyCurrentFileName :call CopyCurrentFileName()
