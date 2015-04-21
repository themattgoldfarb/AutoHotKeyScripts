#t::
	CustomColor = 002B36  ; Can be any RGB color (it will be made transparent below).
;	MouseGetPos X, Y 
;	X=%X%-20
	;PixelGetColor Color, %X%, %Y%, RGB
	
	WinActivate, ahk_class mintty
	WinSet, TransColor, %CustomColor%, ahk_class mintty
return

^#t::
	WinGet, active_id, ID, A
	ColorWhite = 0xFFFFFF  ; Can be any RGB color (it will be made transparent below).
	MouseGetPos X, Y 
	
	;PixelGetColor Color, %X%, %Y%, RGB
	
	WinActivate, ahk_id %active_id%
	WinSet, TransColor, %ColorWhite%, ahk_id %active_id%
	MsgBox, The active window's ID is "%active_id%"
return

#c::
	WinGet, active_id, ID, A
	MouseGetPos X, Y 
	ColorWhite = FFFFFF  ; Can be any RGB color (it will be made transparent below).
	X-=20
	PixelGetColor Color, %X%, %Y%, RGB
	WinActivate, ahk_id %active_id%
	
	WinSet, TransColor, %Color%, ahk_id %active_id%
	MsgBox, Color: "%Color%"
return

^#o::
	WinGet, active_id, ID, A
	ColorWhite = 0xFFFFFF  ; Can be any RGB color (it will be made transparent below).
	WinSet, TransColor, %ColorWhite%, ahk_id %active_id%
return

