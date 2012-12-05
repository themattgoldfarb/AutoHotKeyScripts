; Launch console if necessary; hide/show on Win+`
#Space::
DetectHiddenWindows, on
IfWinExist ahk_class mintty
{
	IfWinActive ahk_class mintty
	  {
			WinHide ahk_class mintty
			; need to move the focus somewhere else.
			WinActivate ahk_class Shell_TrayWnd
		}
	else
	  {
	    WinShow ahk_class mintty
	    WinActivate ahk_class mintty
		WinMove, A,,0,40,1920,520
		Winset, Alwaysontop, , A
		Winset, Style, -0xC00000, a
	  }
}
else
{
	Run mintty
	WinWait, ahk_class mintty
	WinActivate ahk_class mintty
	WinMove, A,,0,40,1920,520
	Winset, Alwaysontop, , A
	Winset, Style, -0xC00000, a
}
DetectHiddenWindows, off
return


^!Space::
DetectHiddenWindows, on
IfWinExist ahk_class  Console_2_Main
{
	IfWinActive ahk_class  Console_2_Main
	  {
			WinHide ahk_class  Console_2_Main
			; need to move the focus somewhere else.
			WinActivate ahk_class Shell_TrayWnd
		}
	else
	  {
	    WinShow ahk_class  Console_2_Main
	    WinActivate ahk_class  Console_2_Main
		WinMove, A,,0,40,1920,520
		Winset, Alwaysontop, , A
		Winset, Style, -0xC00000, a
	  }
}
else
{
	Run console  
	WinWait, ahk_class  Console_2_Main
	WinActivate ahk_class  Console_2_Main
	WinMove, A,,0,40,1920,520
	Winset, Alwaysontop, , A
	Winset, Style, -0xC00000, a
}

DetectHiddenWindows, off
return

#q::
Winset, Style, ^0xC00000, a
return

