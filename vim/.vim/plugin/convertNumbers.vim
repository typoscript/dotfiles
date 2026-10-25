function ConvertDecimalToBinary(decimal)
	if (type(a:decimal) != 0)
		call ShowErrMsg("Input is not a number")
		return
	endif

	let decimalVal = a:decimal
	let binaryVal = 0
	let base = 1

	while decimalVal > 0
		let lastDigit = decimalVal % 2
		let decimalVal /= 2

		let binaryVal += lastDigit * base
		let base *= 10
	endwhile

	return binaryVal
endfunction

function ConvertBinaryToDecimal(binary)
	if (type(a:binary) != 0)
		call ShowErrMsg("Input is not a number")
		return
	endif

	if (!IsNumBinary(a:binary))
		call ShowErrMsg("Input is not a binary number")
		return
	endif

	let binaryVal = a:binary
	let decimalVal = 0
	let base = 1

	while binaryVal > 0
		let lastDigit = binaryVal % 10
		let binaryVal /= 10

		let decimalVal += lastDigit * base
		let base *= 2
	endwhile

	return decimalVal
endfunction


function ConvertByteToMegaByte(byte)
	return a:byte / 1000 / 1000.0
endfunction
