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

+space::
{
Send _
return
}

#g::
{
    run c:/autohotkeyscripts/Matt.ahk
	return
}

#b::
SetTitleMatchMode, 2
IfWinExist, blinds.html - Google Chrome
{
	WinGetActiveTitle, Title
	WinClose, blinds.html - Google Chrome
	WinClose, blinds2.html - Google Chrome
	WinActivate, %Title%
	return
}
else 
{
	IfWinExist, blinds2.html - Google Chrome
	{
		WinGetActiveTitle, Title
		WinClose, blinds.html - Google Chrome
		WinClose, blinds2.html - Google Chrome
		WinActivate, %Title%
		return
	}	
	else

	{
		WinGetActiveTitle, Title
		run chrome
		WinWait, New Tab - Google Chrome,,5
		WinActivate, New Tab - Google Chrome
		WinMove, New Tab - Google Chrome,,-1011,-73,960,1052,,
		Send ^l
		Send C:/Users/matt.goldfarb/Desktop/blinds.html
		Send {Enter}
		WinWait, blinds.html - Google Chrome,,5
		Send {F11}
		run chrome
		WinWait, New Tab - Google Chrome,,5
		WinActivate, New Tab - Google Chrome
		WinMove, New Tab - Google Chrome,,3885,-73,960,1052,,
		Send ^l
		Send C:/Users/matt.goldfarb/Desktop/blinds2.html
		Send {Enter}
		WinWait, blinds2.html - Google Chrome,,5s
		Send {F11}	
		WinActivate, %Title%
		return
	}

}

^#d::
{
	IfWinNotExist, "file://localhost/C:/Users/matt.goldfarb/Desktop/creek.html - Opera"
	{
		run, "C:\Program Files (x86)\Opera\opera.exe"
		WinWait, "Speed Dial - Opera"
		WinActivate, "Speed Dial - Opera"
		Send ^l
		Send C:/Users/matt.goldfarb/Desktop/creek.html
		Send {Enter}
		run, "C:\Program Files (x86)\Opera\OperaLauncher.exe"
		WinWait, "file://localhost/C:/Users/matt.goldfarb/Desktop/creek.html - Opera"
	}
	WinActivate, "file://localhost/C:/Users/matt.goldfarb/Desktop/creek.html - Opera"
	WinMove, "file://localhost/C:/Users/matt.goldfarb/Desktop/creek.html - Opera",,3840,802,1080,668
	return
}

^#s::
{
	IfWinNotExist, Spotify 
	{
		run C:\Users\matt.goldfarb\AppData\Roaming\Spotify\spotify.exe
		WinWait, Spotify
	}
	WinActivate, Spotify
	WinMove, Spotify,,3840,802,1080,668
	return
}

#c::
SetTitleMatchMode, 2
IfWinNotExist, https://localhost/ensurecacheiswarm.aspx - Google Chrome
{
	WinGetActiveTitle, Title
	run chrome
	WinWait, New Tab - Google Chrome,,5
	WinActivate, New Tab - Google Chrome
	Send ^l
	Send https://localhost/ensurecacheiswarm.aspx
	Send {Enter}
	WinWait, https://localhost/ensurecacheiswarm.aspx - Google Chrome,,5
	WinMove, https://localhost/ensurecacheiswarm.aspx - Google Chrome,,4560,-450,360,480,,
	WinActivate, %Title%
	return
}
else
{
	WinGetActiveTitle, Title
	WinActivate,https://localhost/ensurecacheiswarm.aspx - Google Chrome
	WinMove, https://localhost/ensurecacheiswarm.aspx - Google Chrome,,4560,-450,360,480,,
	Click, 4790, 120
	WinActivate,https://localhost/ensurecacheiswarm.aspx - Google Chrome
	Send ^r
	WinActivate, %Title%
	return
}


^+c::
{
Send, ^c
Sleep 50
Run, http://www.google.com/search?q=%clipboard%
Return
}

^+v::
{
Send, ^c
Sleep 50
Run, http:/www.google.com/search?q=msdn+%clipboard%&btnI
Return
}

!+q::
WinGetActiveTitle, Title
WinMove, %Title%,,-840,300,600,600,,
return

!+w::
WinGetActiveTitle, Title
WinMove, %Title%,,627,300,600,600,,
return

!+e::
WinGetActiveTitle, Title
WinMove, %Title%,,2528,300,600,600,,
return

!+r::
WinGetActiveTitle, Title
WinMove, %Title%,,4121,300,600,600,,
return

!+a::
WinGetActiveTitle, Title
WinMaximize, %Title%
return

!+z::
WinGetActiveTitle, Title
WinRestore, %Title%
return

!+s::
WinGetActiveTitle, Title
WinMaximize, %Title%
WinGetActiveStats, Title, width, height, x, y
width:=width/2
WinRestore, %Title%
WinMove, %Title%,,%x%,%y%,%width%,%height%
return
