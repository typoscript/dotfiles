" ******************************************************
" Functions & Utility Commands
" ******************************************************

" 함수 반환값을 시스템 클립보드로 복사 (예: :call CopyFuncReturnVal(GetFileSize()))
function! CopyFuncReturnVal(value)
  call clipboard#copy(type(a:value) == v:t_string ? a:value : string(a:value))
endfunction

function! ShowErrMsg(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction

" Open vimrc in a new tab by typing :Vrc
command! Vrc :tabe $MYVIMRC
