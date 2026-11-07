" ******************************************************
" Pairs - 괄호 쌍 관련 공용 함수 (keymaps.vim, ftplugin, checklist 에서 사용)
" ******************************************************

" 괄호 쌍 사이에서 Enter: 블록을 열고 가운데 줄로 이동
"   {|}  -->  {
"               |
"             }
function! pairs#smartEnter() abort
	let l:line = getline('.')
	let l:col = col('.')
	if l:col > 1
		let l:prevChar = l:line[l:col - 2]
		let l:nextChar = l:line[l:col - 1]
		if (l:prevChar ==# '{' && l:nextChar ==# '}') ||
		 \ (l:prevChar ==# '(' && l:nextChar ==# ')') ||
		 \ (l:prevChar ==# '[' && l:nextChar ==# ']')
			return "\<CR>\<Esc>O"
		endif
	endif
	return "\<CR>"
endfunction
