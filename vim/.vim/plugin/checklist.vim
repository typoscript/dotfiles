" Inspired by https://github.com/evansalter/vim-checklist

function! s:hasCheckbox(lineText)
	" Match either "[ ]" or "[x]"
	if matchstr(a:lineText, '\[[ x]\]') == ""
		return 0
	else
		return 1
endfunction

function! s:createCheckBox()
	let currentLineNum = line('.')
	let currentLineText = getline(currentLineNum)
	let checkboxStr = '[ ]'

	call setline('.', checkboxStr . '  ' . currentLineText)
endfunction

function! s:checklistNewline()
	let currentLineNum = line('.')
	let prevLineNum = currentLineNum - 1

	let prevLineText = getline(prevLineNum)

	if s:hasCheckbox(prevLineText)
		call s:createCheckBox()
		call cursor(currentLineNum, 99)
	endif
endfunction

function! ToggleCheckbox()
	let currentLineNum = line('.')
	let currentLineText = getline(currentLineNum)

	if s:hasCheckbox(currentLineText)
		if matchstr(currentLineText, '\[x\]') == ""
			let line = substitute(currentLineText, '\[ \]', '\[x\]', '')
		else
			let line = substitute(currentLineText, '\[x\]', '\[ \]', '')
		endif

		call setline(currentLineNum, line)
	endif
endfunction

inoremap <CR> <CR><Esc>:call <SID>checklistNewline()<CR>i
