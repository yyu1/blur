;Conducts moving window blurring on a given input image
;Edge pixels are ignored


Pro blur_image, in_file, out_file, xdim, ydim
	;check out existance of in_file and out_file

	if (file_test(in_file) ne 1)  then begin
		print, 'Error: Input file does not exist.', in_file
		exit
	endif

	if (file_test(out_file)) then begin
		print, 'Error: Output file already exists!', out_file
	endif

	;check file size
	infile_info = file_info(in_file)
	if ((ulong(xdim)*ydim*4) ne infile_info.size) then begin
		print, 'Error: Input file size does not match dimensions given.', xdim, ydim, in_file_info.size
	endif

	print, 'Blurring image...'
	print, 'Input file: ', in_file
	print, 'Output file: ', out_file

	;Start processing
	openr, in_lun, in_file, /get_lun
	openw, out_lun, out_file, /get_lun

	out_line = fltarr(xdim)
	readu, in_lun, out_line
	writeu, out_lun, out_line

	in_line = fltarr(xdim,3)

	flag = bytarr(xdim)
	flag[1:xdim-2] = 1

	cur_win = fltarr(3,3)

	for j=1ULL, ydim-2 do begin
		if (j mod 1000 eq 0) then print, j
		;set file pointer
		point_lun, in_lun, (j-1)*xdim*ulong(4)
		readu, in_lun, in_line

		out_line[*] = in_line[*,1]
		index = where((out_line gt 0) and (flag), count)

		if (count gt 0) then begin
			for i=0ULL, count-1 do begin
				cur_win[*] = in_line[(index[i]-1):(index[i]+1),*]
				out_line[index[i]] = blur(cur_win)
			endfor
		endif

		writeu, out_lun, out_line
	endfor

	;final line
	readu, in_lun, out_line
	writeu, out_lun, out_line

	free_lun, in_lun
	free_lun, out_lun

	print, 'Done!'

End
