" Java specific abbreviations
" sysout / sout 을 단어로 입력 후 공백이나 Tab 을 치면 System.out.println(|); 로 확장 (Enter 는 매핑되어 있어 확장되지 않음)
" (축약어라서 System.out.println 처럼 단어 일부로 입력할 때는 확장되지 않음)

" 확장을 트리거한 공백/Enter 를 삼켜서 괄호 안에 끼어들지 않게 함 (:help abbreviations)
function! s:eatchar(pat) abort
	let l:c = nr2char(getchar(0))
	return (l:c =~# a:pat) ? '' : l:c
endfunction

inoreabbrev <buffer> <silent> sysout System.out.println();<Left><Left><C-r>=<SID>eatchar('[ \t\r]')<CR>
inoreabbrev <buffer> <silent> sout   System.out.println();<Left><Left><C-r>=<SID>eatchar('[ \t\r]')<CR>
