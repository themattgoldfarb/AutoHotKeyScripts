;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#q::
Winset, Style, ^0xC00000, a
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

^!z::  ; Control+Alt+Z hotkey.
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox The color at the current cursor position is %color%.
return

^q::
	MouseGetPos, Mousex, MouseY
	PixelGetColor, color, %MouseX%, %MouseY%
	Winset, transcolor, 0x070505, A
	MsgBox The color at the current cursor position is %color%. and the title is %A%.
return

#b::
	WinGet, Style,Style, ahk_class Chrome_WidgetWin_1, Pandora 
	If( Style & 0x10000000 = "")
	{
	    WinShow, ahk_class Chrome_WidgetWin_1, Pandora
		WinActivate, ahk_class Chrome_WidgetWin_1, Pandora
	}
	Else
	{
		WinHide, ahk_class Chrome_WidgetWin_1, Pandora 
	}
return

#g::
	WinGet, Style,Style, ahk_class Chrome_WidgetWin_1, Grooveshark
	If( Style & 0x10000000 = "")
	{
	    WinShow, ahk_class Chrome_WidgetWin_1, Grooveshark
	    WinActivate, ahk_class Chrome_WidgetWin_1, Grooveshark
	}
	Else
	{
		WinHide, ahk_class Chrome_WidgetWin_1, Grooveshark
	}
return

#v::
    WinShow, ahk_class Chrome_WidgetWin_1, Vim_keyboard_shortcuts_skróty_klawiaturowe.jpg
    WinActivate, ahk_class Chrome_WidgetWin_1, Vim_keyboard_shortcuts_skróty_klawiaturowe.jpg
return

#v Up::
	WinHide, ahk_class Chrome_WidgetWin_1, Vim_keyboard_shortcuts_skróty_klawiaturowe.jpg
return

#c::
    WinShow, ahk_class Chrome_WidgetWin_1, git-cheat-sheet-medium.png
    WinActivate, ahk_class Chrome_WidgetWin_1, git-cheat-sheet-medium.png
return

#c Up::
	WinHide, ahk_class Chrome_WidgetWin_1, git-cheat-sheet-medium.png
return



^#g::
	WinShow, ahk_class Chrome_WidgetWin_1,""
	WinActivate, ahk_class Chrome_WidgetWin_1,""
return

^#b::
	WinHide, ahk_class Chrome_WidgetWin_1 
return



^+e::
	WinGet, Style,Style, ahk_class QWidget
	If( Style & 0x10000000 = "")
	{
	    WinShow, ahk_class QWidget
	}
	Else
	{
		WinHide, ahk_class QWidget 
	}
return
	

	
