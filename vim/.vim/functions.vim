" ******************************************************
" Functions & Utility Commands
" ******************************************************

function! CopyFuncReturnVal(func)
  let funcReturnVal = a:func
  execute ":redir @+ | echo ".string(funcReturnVal). " | redir END"
endfunction

function! ShowErrMsg(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction

" Open vimrc in a new tab by typing :Vrc
command! Vrc :tabe $MYVIMRC
