" ******************************************************
" Statusline
" ******************************************************
autocmd BufLeave,WinLeave * setlocal statusline=%f\ %m  " Set the current window to have the following statusline styling
autocmd BufEnter,WinEnter * setlocal statusline=        " Redraw the statusline when entering a new window

autocmd TerminalOpen * setlocal statusline=%f           " Redraw the statusline after exiting a Vim's Terminal

autocmd FileType netrw setlocal bufhidden=wipe          " Do not allow Netrw as a file to be saved

" ******************************************************
" Mappings for Specific File Type
" ******************************************************
" <buffer> makes autocmd only work on specified FileType
" without it, autocmd has effect on any files once the specified file has been open

" Auto close HTML tag with <Enter>
autocmd FileType html inoremap <buffer> ><Cr> ><Esc>F<lyt>o</<C-r>"><Esc>O<Tab>
autocmd FileType javascriptreact inoremap <buffer> ><Cr> ><Esc>F<lyt>o</<C-r>"><Esc>O<Tab>
autocmd FileType typescriptreact inoremap <buffer> ><Cr> ><Esc>F<lyt>o</<C-r>"><Esc>O<Tab>

" Auto close HTML tag with <Tab>
autocmd FileType html inoremap <buffer> ><Tab> ><Esc>F<lyt>A</<C-r>"><Esc>F<i
autocmd FileType javascriptreact inoremap <buffer> ><Tab> ><Esc>F<lyt>A</<C-r>"><Esc>F<i
autocmd FileType typescriptreact inoremap <buffer> ><Tab> ><Esc>F<lyt>A</<C-r>"><Esc>F<i

" Abbreivations
" println > System.out.println();
autocmd FileType java inorea <buffer> println System.out.println();<Esc><Left>i
