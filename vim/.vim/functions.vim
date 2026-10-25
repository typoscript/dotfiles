" ******************************************************
" Functions - :call [function] to execute it
" Util Functions Only
" ******************************************************
function CopyFuncReturnVal(func)
	let funcReturnVal = a:func
	execute ":redir @+ | echo ".string(funcReturnVal). " | redir END"
endfunction

function ShowErrMsg(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction
