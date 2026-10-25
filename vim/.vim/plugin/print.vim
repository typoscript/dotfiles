function PrtNumLineByLine(...)
	if a:0 == 1
		exe ":put=range(1,"a:1")"
	elseif a:0 == 2
		exe ":put=range("a:1","a:2")"
	else
		call ShowErrMsg("Invalid input")
	endif
endfunction

function PrtRndNumInList(listLength)
	"a:listLength is readonly variable
	let listLength = a:listLength
	let list = []

	while listLength > 0
		call add(list, rand() % 10)
		let listLength -= 1
	endwhile

	call append(".", string(list))
endfunction
