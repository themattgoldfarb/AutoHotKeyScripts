/*
Autohide, by Charon the Hand.

This script hides a window with {Win}F5. {Win}F6 brings up a listview with icons showing the windows that 
have been hidden. You can select one by double clicking its row or highlighting the row with arrow keys and 
hitting {Enter}. The script will keep a list of windows currently hidden; if it exits for any reason other 
than system shutdown, it writes the names of hidden windows to an .ini file. On restarting, the script reads
those values and rebuilds the listview. {Win}F7 exits the script (mostly for testing purposes). {Win}F8 
currently does nothing, but I used it extensively for testing. The hotkeys are customizable. The colors of 
the listview (background, border, text) are customizable. Currently you can hide 10 windows, but that too 
is customizable if necessary.

Credit to evl for his Alt-Tab Replacement, from which I borrowed the DllCall code to retrieve icons and much 
help in building listviews. Also to the author (can't find his/her name anywhere) of Minimize Window to Tray 
Menu from the script showcase for the trick of raising the next window in the z-order when hiding.
*/

#NoEnv
#NoTrayIcon
#InstallKeybdHook
#SingleInstance Force
DetectHiddenWindows On
SetTitleMatchMode 3
CoordMode, Mouse
OnExit, ch_SaveToIni
OnMessage( 0x06, "ch_WM_ACTIVATE" )
ch_totalWindows := 0

;================================Variables================================;

ch_hotkeyHide := "#F5"							;{Win}F5
ch_hotkeyShow := "#F6"							;{Win}F6
ch_hotkeyExit := "#F7"                         	;{Win}F7
ch_maxWindows := 10
ch_bgColor := "EBEBEB"
ch_borderColor := "B22222"
ch_textColor := "191919"

;================================Autoexecute================================;


Loop, %ch_maxWindows%							;read the ini file to see if there are any 
{                                               ;windows to be restored, then erase contents
	IniRead, ch_winNameFromIni, autohide.ini, Window%A_Index%, WinTitle
	If ch_winNameFromIni = ERROR
		continue
	IniRead, ch_winIdFromIni, autohide.ini, Window%A_Index%, WinId
	IniDelete, autohide.ini, Window%A_Index%
	Loop %ch_maxWindows%
	{
		If ch_winName%A_Index% = 
		{
			ch_winName%A_Index% := ch_winNameFromIni
			ch_winId%A_Index% := ch_winIdFromIni
			ch_winNameLength%A_Index% := StrLen(ch_winNameFromIni)
			ch_totalWindows += 1
			break
		}
	}
}
ch_BuildListView()
Hotkey, %ch_hotkeyHide%, ch_HideWindow
Hotkey, %ch_hotkeyShow%, ch_ShowWindow
Hotkey, %ch_hotkeyExit%, ch_SaveToIni
return

;================================Hotkeys================================;

#F8::
msgbox, %ch_longestName%
return

;================================Subroutines================================;

ch_HideWindow:
	WinGetTitle, ch_winName, A
	WinGetClass, ch_winClass, A
	WinGet, ch_winId, Id, A
	If ch_winClass in Progman,Shell_TrayWnd
		return
	Send, !{Esc}
	WinHide, ahk_id %ch_winId%
	Loop %ch_maxWindows%
	{
		If ch_winId%A_Index% = 					;find an empty variable and put the window name in
		{
			ch_winId%A_Index% := ch_winId
			ch_winName%A_Index% := ch_winName
			ch_winNameLength%A_Index% := StrLen(ch_winName)
			ch_totalWindows +=1
			break
		}
	}
	return

ch_ShowWindow:
	If ch_totalWindows = 0
		return
	MouseGetPos, ch_xpos, ch_ypos				;put LV right under the mouse
	ch_xpos -= 10
	ch_ypos -= 10
	ch_BuildListView()
	Gui, Show, x%ch_xpos% y%ch_ypos%
	return

ch_SaveToIni:
	If A_ExitReason in Shutdown,Exit			;if shutting down the computer, skip
		ExitApp
	Loop, %ch_maxWindows%						;if closing for any other reason, store currently 
	{                                           ;hidden windows in ini file for restoration later
		If ch_winName%A_Index% = 
			continue
		ch_outerLoopA_Index := A_Index
		Loop, %ch_maxWindows%
		{
			IniRead, ch_freeSpace, autohide.ini, Window%A_Index%, WinTitle
			If ch_freeSpace = ERROR
			{
				IniWrite, % ch_winName%ch_outerLoopA_Index%, autohide.ini, Window%A_Index%, WinTitle
				IniWrite, % ch_winId%ch_outerLoopA_Index%, autohide.ini, Window%A_Index%, WinId
				break
			}
		}
	}
	ExitApp

ch_LVMenu:
	If A_GuiEvent = DoubleClick					;restore window on double-click
	{
		ch_RestoreWindow(A_EventInfo)
	}
	return

ButtonOK:										;restore window on {Enter}
	GuiControlGet, ch_FocusedControl, FocusV
	If ch_FocusedControl <> ch_LVMenu
    	return
	else
	{
		ch_RowNum := LV_GetNext(0, "Focused")
		ch_RestoreWindow(ch_RowNum)
	}
	return

;================================Functions================================;

ch_WM_ACTIVATE(ch_wParam) 
{
	Global
	If (ch_wParam = 0) 							;if the listview loses focus, hide it
	{
		Gui, Hide
    }
} 

ch_BuildListView()
{    
	global
	Gui, Destroy
	ch_GetLongestName()
	Gui, Color, %ch_borderColor%, %ch_bgColor%
	Gui, Margin, 1,1
	Gui, +ToolWindow -Caption 
	Gui, Font, s12 c%ch_textColor%
	Gui, Add, ListView, Report -Hdr r%ch_totalWindows% w%ch_longestName% Count10 gch_LVMenu vch_LVMenu, |
	Gui, Add, Button, w0 h0 x0 y-1 Hidden Default, OK
	ch_ImageListID := IL_Create(10)  			;invisible OK button, so you can use {Enter} to select
	LV_SetImageList(ch_ImageListID) 			;Create an ImageList to hold 10 small icons.
                                                ;Assign the above ImageList to the current ListView.
	Loop, %ch_maxWindows%
	{
		If ch_winId%A_Index% = 
			continue
		ch_winName := ch_winName%A_Index%		;this whole icon routine is from evl, I don't pretend to 
		ch_winId := ch_winId%A_Index%			;understand it, I just modified it until it worked for me
		SendMessage, 0x7F, 2, 0,, ahk_id %ch_winId%
    	ch_hIcon := ErrorLevel					
    	If ( ! ch_hIcon )
    	{
       		SendMessage, 0x7F, 0, 0,, ahk_id %ch_winId%
       		ch_hIcon := ErrorLevel
       		If ( ! ch_hIcon )
       		{
           		ch_hIcon := DllCall( "GetClassLong", "uint", ch_winId, "int", -34 ) ; GCL_HICONSM is -34
           		If ( ! ch_hIcon )
           		{
               		ch_hIcon := DllCall( "LoadIcon", "uint", 0, "uint", 32512 ) ; IDI_APPLICATION is 32512
	           	}
    	   	}
    	}
   		;Add the HICON directly to the small-icon and large-icon lists.
   		;Below uses +1 to convert the returned index from zero-based to one-based:
    	;Create the new row in the ListView and assign it the icon number determined above ; Add 2 spaces for looks
  		ch_IconNumber := DllCall("ImageList_ReplaceIcon", UInt, ch_ImageListID, Int, -1, UInt, ch_hIcon) + 1
   		LV_Add("Icon" . ch_IconNumber, A_Space . A_Space . ch_winName)
   		continue
   	}
	WinGetClass, ch_winClass, ahk_id %ch_winId%
	If ch_winClass = #32770 ; fix for displaying control panel related windows (dialog class) that aren't on taskbar
	{
   		ch_IconNumber := IL_Add(ch_ImageListID, "C:\WINDOWS\system32\shell32.dll" , 217) ; generic control panel icon
   		LV_Add("Icon" . ch_IconNumber,  ch_winName)
   		
	}
	return
}

ch_RestoreWindow(ch_RowNum)
{
	global
    LV_GetText(ch_RowText, ch_RowNum, 1)  		;Get the text from the row's first field.
    StringTrimLeft, ch_RowText, ch_RowText, 2	;Remove the 2 spaces before using
    WinGet, ch_winIdToRestore, Id, %ch_RowText%	
    WinShow, ahk_id %ch_winIdToRestore%			
    LV_Delete(ch_RowNum)                 		
    Loop, %ch_maxWindows%                       ;Delete the contents of the variables so the 
    {                                           ;row doesn't get recreated in the next call
    	If ch_winName%A_Index% = %ch_RowText%
    	{
    		ch_winName%A_Index% :=  
    		ch_winId%A_Index% := 
    		ch_winNameLength%A_Index% :=   
    		ch_totalWindows -= 1 
    		break
    	}
    }
    Gui, Hide
    return
}

ch_GetLongestName()
{
	global
	ch_longestName := 0
	Loop, %ch_maxWindows%
	{
		If % ch_winName%A_Index% = 
			continue
		If % ch_winNameLength%A_Index% >= ch_longestName	
		ch_longestName := ch_winNameLength%A_Index%
	}
	If ch_longestName <= 20						;window names with fewer letters get a slightly bigger window built
		ch_longestName := ((ch_longestName + 2) * 7) + 40
	else
		ch_longestName := ((ch_longestName + 2) * 7.75)
	return
}