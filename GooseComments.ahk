;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Matt Goldfarb
;
; Script Function:
; WindowsKey+Q -> Hides the title bar of the active application
; Alt+LMouseButton -> alt window drag
; WindowKey+MouseWheel Up/Down -> change window transparency
; Ctrl+WindowKey+MouseWheel Up/Down -> Change window transparency faster
; WindowKey+O -> Make window Opaque
; Ctrl+Space -> Set active window always on top
; WindowKey+B -> toggle hide/activate Pandora (in chrome browser)
; WindowKey+G -> toggle hide/activate Grooveshark (in chrome browser)

;

+!j:: Send {Down}
+!k:: Send {Up}

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2


#q::
    WinSet, Style, ^0xC00000, a
return

^!g::
   WinSet, Style, ^0xC40000, a ; hide title bar
   ;WinSet, Style, ^0x800000, a ; hide thin-line border
   ;WinSet, Style, ^0x400000, a ; hide dialog frame
   ;WinSet, Style, ^0x040000, a ; hide thickframe/sizebox  
return


; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; by The How-To Geek
; http://www.howtogeek.com 

Alt & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return

; changing window transparencies
#WheelUp::  ; Increments transparency up by 3.375% (with wrap-around)
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans + 8
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    else
    {
        WinSet, Transparent, OFF, A
        WinSet, Transparent, 255, A
    }
return

#WheelDown::  ; Increments transparency down by 3.375% (with wrap-around)
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans - 8
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    ;else
    ;{
    ;    WinSet, Transparent, 255, A
    ;    WinSet, Transparent, OFF, A
    ;}
return

^#WheelUp::  ; Increments transparency up by 3.375% (with wrap-around)
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans + 64
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    else
    {
        WinSet, Transparent, OFF, A
        WinSet, Transparent, 255, A
    }
return

^#WheelDown::  ; Increments transparency down by 3.375% (with wrap-around)
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans - 64
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    ;else
    ;{
    ;    WinSet, Transparent, 255, A
    ;    WinSet, Transparent, OFF, A
    ;}
return


#o::  ; Reset Transparency Settings
    WinSet, Transparent, 255, A
    WinSet, Transparent, OFF, A
return



^SPACE::  
	Winset, Alwaysontop, , A
return



#b::
	WinGet, Style,Style, Pandora
	If( Style & 0x10000000 = "")
	{
	    WinShow,  Pandora
		WinActivate, Pandora
	}
	Else
	{
		WinHide, Pandora
	}
return

#g::
	SetTitleMatchMode, 2
	WinGet, Style,Style,  Grooveshark
	If( Style & 0x10000000 = "")
	{
	    WinShow,  Grooveshark
	    WinActivate,  Grooveshark
	}
	Else
	{
		WinHide,  Grooveshark
	}
return

;remap the capsLock key to send an esc
Capslock::Esc

^#t::
	WinGet, active_id, ID, A
	ColorWhite = 0xFFFFFF  ; Can be any RGB color (it will be made transparent below).
	MouseGetPos X, Y 
	
	;PixelGetColor Color, %X%, %Y%, RGB
	
	WinActivate, ahk_id %active_id%
	WinSet, TransColor, %ColorWhite%, ahk_id %active_id%
return



::ssf::select * from
::sst::select top 10 * from
::um::use metrics_datawarehouse;
::ums::use metrics_staging;
::uz::use zocdoc;

