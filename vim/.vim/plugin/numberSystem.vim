function IsNumBinary(num)
	let num = a:num

	while num != 0
		if (num % 10 > 1)	
			return 0
		endif

		let num /= 10
	endwhile

	return 1
endfunction
