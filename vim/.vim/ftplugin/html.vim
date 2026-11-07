" HTML: 닫는 태그 자동 완성 (autoload/tagcomplete.vim)
inoremap <buffer> <silent> <CR>  <C-r>=tagcomplete#enter(0)<CR>
inoremap <buffer> <silent> <Tab> <C-r>=tagcomplete#tab(0)<CR>
