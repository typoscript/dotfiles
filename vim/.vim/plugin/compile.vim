function Compile()
	" Key: extension name
	" Value: compiler shell command

	let compilers = #{
		\ java: "java",
		\ js: "node",
		\ py: "python3",
		\ ts: "ts-node",
		\ }

	let fileName = @%
	let fileExtension = split(fileName, '\.')[1]

	if has_key(compilers, fileExtension)
		let compilerName = compilers[fileExtension]
		exe ":!" compilerName " " fileName
	else
		echo "Compiler not found"	
	endif
endfunction

command! Compile :call Compile()
