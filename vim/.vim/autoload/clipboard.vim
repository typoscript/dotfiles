" ******************************************************
" Clipboard - 시스템 클립보드 복사 (+clipboard 없는 터미널 Vim 포함)
"
" 우선순위: Vim 내장(+clipboard) -> WSL clip.exe -> pbcopy -> wl-copy/xclip/xsel
" 텍스트는 명령 인자가 아니라 stdin 으로 넘겨 큰 yank 에서도 인자 길이 제한에 걸리지 않는다.
" ******************************************************

" WSL 의 clip.exe 경로 (테스트나 다른 경로가 필요하면 g:wsl_clip_exe 로 변경)
function! clipboard#wslClip() abort
	return get(g:, 'wsl_clip_exe', '/mnt/c/Windows/System32/clip.exe')
endfunction

function! clipboard#copy(text) abort
	if has('clipboard')
		let @+ = a:text
		return 1
	endif

	let l:clip = clipboard#wslClip()
	if executable(l:clip)
		" clip.exe 는 BOM 없는 UTF-16LE 를 Windows 코드페이지(cp949 등)와 무관하게 정확히 해석한다.
		let l:cmd = executable('iconv')
			\ ? 'iconv -f utf-8 -t utf-16le | ' . shellescape(l:clip)
			\ : shellescape(l:clip)
		call system(l:cmd, a:text)
		return v:shell_error == 0
	endif

	for l:cmd in ['pbcopy', 'wl-copy', 'xclip -selection clipboard', 'xsel --clipboard --input']
		if executable(split(l:cmd)[0])
			call system(l:cmd, a:text)
			return v:shell_error == 0
		endif
	endfor

	let @" = a:text
	echohl WarningMsg
	echo 'No system clipboard available; copied to the unnamed register instead.'
	echohl None
	return 0
endfunction
