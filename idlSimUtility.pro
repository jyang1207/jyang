; procedure to filter the bad components from a summary.txt output of *sumgalfit.txt
; and write them to a *summary_all_errors.txt file in the same directory
;
; positional parameters:
; infile - the full path filename of the component summary info (*summary.txt)
;
; named parameters:
; TODO
;			
pro write_comp_errors, infile,	DIS_LOWER_LIMIT = distLowLimit, $
								DIS_UPPER_LIMIT = distHighLimit, $
								SER_LOWER_LIMIT = sersLowLimit, $
								SER_UPPER_LIMIT = sersHighLimit, $
								MAG_LOWER_LIMIT = magLowLimit, $
								MAG_UPPER_LIMIT = magHighLimit, $
								RAD_LOWER_LIMIT = radLowLimit, $
								RAD_UPPER_LIMIT = radHighLimit

	; if an error is detected anywhere in the procedure
	; stores the detection in file_error variable
	;catch, file_error
	
	; stop execution if an error has been detected
	;if file_error NE 0 then STOP

	; read the summary.txt file, full path name is in infile parameter
	; store arrays for each field in 14 named variables (id, ts, etc.)
	readcol,infile,id,ts,age,cam,fil,px,py,mag,rad,ser,ba,ang,$
		SKIPLINE=2,FORMAT="A,A,F,A,A"

	; use above info to define output filename
	out_filename = (strmid(infile,0,strpos(infile,".",/REVERSE_SEARCH))+'_all_errors.txt') 

	; array of all records that start with a *, which indicates sersic or component seperation error
	; errors = where(strmid(id,0,1) EQ "*", errorCount)

	; open a file for writing the output		
	get_lun,outfile
	openw,outfile,out_filename

	; write the number of components with leading * to the output file
	; printf,outfile,errorCount," errors detected by sersic index and component separation (components with leading *s)"
	; printf,outfile,''

	; based on named param, write number and list of components too far from (300,300)
	if ( not(n_elements(distLowLimit) eq 0) or not(n_elements(distHighLimit) eq 0) ) then begin
		dx = (300-px)
		dy = (300-py)
		distFromCenter = (dx^2 + dy^2)^(0.5)
	endif
	
	; based on named param, write number and list of components with center distance too low
	if not(n_elements(distLowLimit) eq 0) then begin
		distLowErrors = where( ( distFromCenter LT float(distLowLimit) ), distLowCount )
		print,distLowCount," components with (x, y) position less than ",distLowLimit," from (300, 300)"
	printf,outfile,distLowCount," components with (x, y) position less than ",distLowLimit," from (300, 300)"
		for i=0,distLowCount-1 do $
			printf,outfile,id[distLowErrors[i]]," time:",ts[distLowErrors[i]],$
					" camera:",cam[distLowErrors[i]],$
					" with a position of (",px[distLowErrors[i]],",",py[distLowErrors[i]],")"
		printf,outfile,''
	endif
	
	; based on named param, write number and list of components with center distance too high
	if not(n_elements(distHighLimit) eq 0) then begin
		distHighErrors = where( ( distFromCenter GT float(distHighLimit) ), distHighCount )
		print,distHighCount," components with (x, y) position greater than ",distHighLimit," from (300, 300)"
		printf,outfile,distHighCount," components with (x, y) position greater than ",distHighLimit," from (300, 300)"
		for i=0,distHighCount-1 do $
			printf,outfile,id[distHighErrors[i]]," time:",ts[distHighErrors[i]],$
					" camera:",cam[distHighErrors[i]],$
					" with a position of (",px[distHighErrors[i]],",",py[distHighErrors[i]],")"
		printf,outfile,''
	endif
	
	; based on named param, write number and list of components with sersic index too low
	if not(n_elements(sersLowLimit) eq 0) then begin
		sersLowErrors = where( ( ser LT float(sersLowLimit) ), sersLowCount )
		print,sersLowCount," components with sersic index less than ",sersLowLimit
		printf,outfile,sersLowCount," components with sersic index less than ",sersLowLimit
		for i=0,sersLowCount-1 do $
			printf,outfile,id[sersLowErrors[i]]," time:",ts[sersLowErrors[i]],$
					" camera:",cam[sersLowErrors[i]],$
					" with a sersic index of ",ser[sersLowErrors[i]]
		printf,outfile,''
	endif

	; based on named param, write number and list of components with sersic index too high
	if not(n_elements(sersHighLimit) eq 0) then begin
		sersHighErrors = where( ( ser GT float(sersHighLimit) ), sersHighCount )
		print,sersHighCount," components with sersic index greater than ",sersHighLimit
		printf,outfile,sersHighCount," components with sersic index greater than ",sersHighLimit
		for i=0,sersHighCount-1 do $
			printf,outfile,id[sersHighErrors[i]]," time:",ts[sersHighErrors[i]],$
					" camera:",cam[sersHighErrors[i]],$
					" with a sersic index of ",ser[sersHighErrors[i]]
		printf,outfile,''
	endif
	
	; based on named param, write number and list of components with magnitude too low
	if not(n_elements(magLowLimit) eq 0) then begin
		magLowErrors = where( ( mag LT float(magLowLimit) ), magLowCount )
		print,magLowCount," components with magnitude less than ",magLowLimit
		printf,outfile,magLowCount," components with magnitude less than ",magLowLimit
		for i=0,magLowCount-1 do $
			printf,outfile,id[magLowErrors[i]]," time:",ts[magLowErrors[i]],$
					" camera:",cam[magLowErrors[i]],$
					" with a magnitude of ",mag[magLowErrors[i]]
		printf,outfile,''
	endif
	
	; based on named param, write number and list of components with magnitude too high
	if not(n_elements(magHighLimit) eq 0) then begin
		magHighErrors = where( ( mag GT float(magHighLimit) ), magHighCount )
		print,magHighCount," components with magnitude greater than ",magHighLimit
		printf,outfile,magHighCount," components with magnitude greater than ",magHighLimit
		for i=0,magHighCount-1 do $
			printf,outfile,id[magHighErrors[i]]," time:",ts[magHighErrors[i]],$
					" camera:",cam[magHighErrors[i]],$
					" with a magnitude of ",mag[magHighErrors[i]]
		printf,outfile,''
	endif
	
	; based on named param, write number and list of components with radius too low
	if not(n_elements(radLowLimit) eq 0) then begin
		radLowErrors = where( ( rad LT float(radLowLimit) ), radLowCount )
		print,radLowCount," components with radius less than ",radLowLimit
		printf,outfile,radLowCount," components with radius less than ",radLowLimit
		for i=0,radLowCount-1 do $
			printf,outfile,id[radLowErrors[i]]," time:",ts[radLowErrors[i]],$
					" camera:",cam[radLowErrors[i]],$
					" with a radius of ",rad[radLowErrors[i]]
		printf,outfile,''
	endif
	
	; based on named param, write number and list of components with radius too high
	if not(n_elements(radHighLimit) eq 0) then begin
		radHighErrors = where( ( rad GT float(radHighLimit) ), radHighCount )
		print,radHighCount," components with radius greater than ",radHighLimit
		printf,outfile,radHighCount," components with radius greater than ",radHighLimit
		for i=0,radHighCount-1 do $
			printf,outfile,id[radHighErrors[i]]," time:",ts[radHighErrors[i]],$
					" camera:",cam[radHighErrors[i]],$
					" with a radius of ",rad[radHighErrors[i]]
		printf,outfile,''
	endif
	
	; close output file
	free_lun,outfile

	; print the location of the written output file
	print,"file ",out_filename," written"
end

; procedure to plot age vs sersic index, maybe eventually allow
; parameter for y part of plot
;
; positional parameters:
; infile - the full path filename of the component summary info (*summary.txt)
;
pro plot_comp_vs_age, infile
  
	; read the summary.txt file, full path name is in infile parameter
	; store arrays for each field in 14 named variables (id, ts, etc.)
	readcol,infile,id,ts,age,cam,fil,px,py,mag,rad,ser,ba,ang,$
		SKIPLINE=2,FORMAT="A,A,F,A,A"
	
	gridDef = [1,2]
	props = {symbol:'triangle', sym_size:1.0,$
	xtitle:"Age (GYr)", ytitle:"Sersic Index", yrange:[0,5]}
	
	distlimit = 10.0
	title1 = "VELA02MRP"
	dx = (300-px)
	dy = (300-py)
	distFromCenter = (dx^2 + dy^2)^(0.5)
	x1 = age[where( (id EQ title1) and (distFromCenter LT distLimit) )]
	y1 = ser[where( (id EQ title1) and (distFromCenter LT distLimit) )]
	plot1 = SCATTERPLOT(x1, y1, TITLE=title1, LAYOUT=[gridDef,[1]], _EXTRA=props)
	  
	param1 = LINFIT(x1, y1, /Double, YFIT=fit1)
	plotFit1 = PLOT(x1, fit1, /Overplot)
	print,"slope of fit for ",title1,":",(param1[1]/param1[0])
	
	title2 = "VELA02"
	x2 = age[where( (id EQ title2) and (distFromCenter LT distLimit) )]
	y2 = ser[where( (id EQ title2) and (distFromCenter LT distLimit) )]
	plot2 = SCATTERPLOT(x2, y2, TITLE=title2, LAYOUT=[gridDef,[2]], /CURRENT, _EXTRA=props)
	  
	param2 = LINFIT(x2, y2, /Double, YFIT=fit2)
	plotFit2 = PLOT(x2, fit2, /Overplot)
	print,"slope of fit for ",title2,":",(param2[1]/param2[0])
end

; tile list of pictures
;pro tile_images,infile
  
	; http://www.exelisvis.com/docs/READ.html
;	OPENR, lun, infile, /GET_LUN
	; Read one line at a time, saving the result into array
;	imageFilenames = ''
;	line = ''
;	WHILE NOT EOF(lun) DO BEGIN & $
;		READF, lun, line & $
;		imageFilenames = [imageFilenames, line] & $
;	ENDWHILE
	; Close the file and free the file unit
;	FREE_LUN, lun
	
;	rows = FIX(n_elements(imageFilenames)^(0.5))+1
;	cols = rows
;	gridDef = [rows,cols]
;	props = {symbol:'triangle', sym_size:1.0,$
;		xtitle:"Age (GYr)", ytitle:"Sersic Index", yrange:[0,5]}
		
;	for i=1,n_elements(imageFilenames) do $
;		curImage = IMAGE(imageFilenames[i], LAYOUT=[gridDef,[i]],/CURRENT,$
;						TITLE=strmid(imageFilenames[i],$
;								strpos(imageFilenames[i],"/",/REVERSE_SEARCH),$
;								strlen(imageFilenames[i])-1))
;end