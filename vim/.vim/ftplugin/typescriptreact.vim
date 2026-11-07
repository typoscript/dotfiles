" typescriptreact: JSX 닫는 태그 자동 완성 (autoload/tagcomplete.vim, 제네릭 <T> 는 무시)
inoremap <buffer> <silent> <CR>  <C-r>=tagcomplete#enter(1)<CR>
inoremap <buffer> <silent> <Tab> <C-r>=tagcomplete#tab(1)<CR>
