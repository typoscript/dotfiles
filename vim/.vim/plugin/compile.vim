" ******************************************************
" Compile & Run Plugin
" ******************************************************

function! Compile()
	let l:fileName = expand('%')
	if empty(l:fileName)
		echo "No file to compile/run"
		return
	endif

	" Save file if modified before running
	if &modified
		write
	endif

	let l:compilers = {
		\ 'py': 'python3',
		\ 'js': 'node',
		\ 'ts': 'ts-node',
		\ 'java': 'java',
		\ 'sh': 'bash',
		\ 'bash': 'bash',
		\ 'zsh': 'zsh',
		\ 'go': 'go run',
		\ 'rb': 'ruby',
		\ 'lua': 'lua',
		\ }

	let l:fileExtension = expand('%:e')
	if empty(l:fileExtension)
		echo "No file extension found: " . l:fileName
		return
	endif

	if has_key(l:compilers, l:fileExtension)
		let l:compilerName = l:compilers[l:fileExtension]
		execute '!' . l:compilerName . ' ' . shellescape(l:fileName)
	else
		echo "No compiler configured for extension: ." . l:fileExtension
	endif
endfunction

command! Compile call Compile()
