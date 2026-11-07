" ******************************************************
" Tag Complete - HTML / JSX / TSX 닫는 태그 자동 완성
" (ftplugin/html.vim, javascriptreact.vim, typescriptreact.vim 공용)
"
"   <div>|  + <CR>   -->  <div>
"                           |
"                         </div>
"   <div>|  + <Tab>  -->  <div>|</div>
"
" a:jsx 가 참이면 식별자 바로 뒤의 '<' 는 TypeScript 제네릭으로 보고 무시한다.
"   예) Array<string>, useState<number>, Promise<void>, a<b && c>
" ******************************************************

let s:void_tags = ['area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input',
	\ 'link', 'meta', 'param', 'source', 'track', 'wbr']

" 커서 바로 앞에서 끝나는 여는 태그의 이름을 반환 (해당 없으면 '')
function! s:openTagBeforeCursor(jsx) abort
	let l:col = col('.')
	let l:before = l:col > 1 ? getline('.')[: l:col - 2] : ''

	" JSX 는 <Foo.Bar> 같은 네임스페이스 컴포넌트를 허용
	let l:name = a:jsx ? '[A-Za-z][A-Za-z0-9_.\-]*' : '[A-Za-z][A-Za-z0-9_\-]*'
	let l:pat = '<\(' . l:name . '\)\%(\s\+[^>]*\)\?>$'

	let l:start = match(l:before, l:pat)
	if l:start < 0
		return ''
	endif
	" 자체 닫힘 태그 (<br />, <Foo />)
	if l:before =~# '/>$'
		return ''
	endif
	" 제네릭: 식별자/점 바로 뒤에 붙은 '<'
	if a:jsx && l:start > 0 && l:before[l:start - 1] =~# '[A-Za-z0-9_$.]'
		return ''
	endif

	let l:tagName = matchlist(l:before[l:start :], l:pat)[1]
	if index(s:void_tags, tolower(l:tagName)) != -1
		return ''
	endif
	return l:tagName
endfunction

function! tagcomplete#enter(jsx) abort
	let l:tagName = s:openTagBeforeCursor(a:jsx)
	if empty(l:tagName)
		" 태그가 아니면 일반 smart Enter ({|} 블록 열기 등) 유지
		return pairs#smartEnter()
	endif
	return "\<CR></" . l:tagName . ">\<Esc>O"
endfunction

function! tagcomplete#tab(jsx) abort
	let l:tagName = s:openTagBeforeCursor(a:jsx)
	if empty(l:tagName)
		return "\<Tab>"
	endif
	return "</" . l:tagName . ">\<C-o>F<"
endfunction
