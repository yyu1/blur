;blurs center pixel of a 3x3 box

Function blur, win_vals
	flags = [[1,1,1],[1,0,1],[1,1,1]]
	index = where ((win_vals gt 0) and flags, count)

	if (count gt 0) then begin
		weights = fltarr(3,3)
		weights[1,1] = 0.8
		weights[index] = 0.2 / count
		return, weights * win_vals
	endif

	return, win_vals[1,1]	
End
