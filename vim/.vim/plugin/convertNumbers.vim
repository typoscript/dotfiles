" ******************************************************
" Number Conversion Helpers
"   :echo ConvertDecimalToBinary(10)      -> '1010'
"   :echo ConvertBinaryToDecimal('1010')  -> 10   (숫자 1010 도 허용)
"   :echo ConvertByteToMegaByte(1500000)  -> 1.5
" 2진수는 문자열로 다뤄서 큰 값(2^19 이상)에서도 정수 오버플로가 나지 않는다.
" ******************************************************

function! ConvertDecimalToBinary(decimal)
	if type(a:decimal) != v:t_number || a:decimal < 0
		call ShowErrMsg("Input is not a non-negative number")
		return ''
	endif
	return printf('%b', a:decimal)
endfunction

function! ConvertBinaryToDecimal(binary)
	if type(a:binary) != v:t_number && type(a:binary) != v:t_string
		call ShowErrMsg("Input is not a number")
		return
	endif
	let l:digits = type(a:binary) == v:t_string ? a:binary : string(a:binary)
	if l:digits !~# '^[01]\+$'
		call ShowErrMsg("Input is not a binary number")
		return
	endif
	return str2nr(l:digits, 2)
endfunction

function! ConvertByteToMegaByte(byte)
	if a:byte < 0
		return 0.0
	endif
	return a:byte / 1000000.0
endfunction
