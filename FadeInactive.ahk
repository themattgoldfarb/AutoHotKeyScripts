;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       WinNT
; Author:         David Earls
;
; Script Function:
;   Ghost inactive Windows like XFCE
;
; Attribution: The code to loop through windows was paraphrased from the AHK forums.
; script of Unambiguous adjusted for use with PSPad
;
; Modified by Jesse Elliott
;
; - Added configurable Fade Step for fade in and fade out
; - No longer replace the standard menu, rather 'Configure' is simply added to it
; - Added a check to make sure the system tray icon exits
; - Loop through windows much more often (every 200 ms) for better responsiveness
; - Moved processname code further down to improve performance (6% to 1% CPU)
; - Make the active window non-transparent first, before making other windows transparent
; - Make all windows in the active process (based on PID) non-transparent (i.e. Find Dialogs, menus, etc.)
; - Fixed Drag artifacts (transparent box when dragging Desktop icons)


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2
#SingleInstance, force
DetectHiddenWindows, Off 


; Configurable Values
iniread, TransLvl, fadetoblack.ini, Preferences, Transparent, 100
iniread, fadeStep, fadetoblack.ini, Preferences, FadeStep, 10
iniread, delay, fadetoblack.ini, Preferences, Delay, 0


; if the icon exists, use it
ifexist, %A_Windir%\System32\accessibilitycpl.dll
  menu, tray, icon, %A_Windir%\System32\accessibilitycpl.dll, 15


; add Configure to the standard menu  
menu, tray, add
menu, tray, add, &Configure, Configure
menu, tray, default, &Configure
menu, tray, tip, Fades Inactive Windows - Please exit properly.


OnExit, ExitRoutine
#Persistent
SetTimer, CheckIfActive, 200  ; check windows every 200 milliseconds
return


; loop through all windows
CheckIfActive:
WinGet, id, list, , , Program Manager
Loop, %id%
{
    StringTrimRight, this_id, id%a_index%, 0
    WinGetTitle, title, ahk_id %this_id%
    
    If title =
        continue

    WinGetClass class , ahk_id %this_id%

    if class = Shell_TrayWnd ; Look down
        continue
    if class = Button ; Start Menu
        continue
    if class = SysDragImage ; Drag Objects
        continue


    ; Exclusions
    winget processname, processname, ahk_id %this_id%

    if ( processname = "PSPad.exe" and class = "TApplication" )
      continue
    if (processname = "devenv.exe") ; Visual Studio doesn't support transparency (WS_EX_LAYERED is not set)
        continue


    ; Set the active window non-transparent first
    WinGet, activeTrans, Transparent, A

    if activeTrans = %TransLvl%
    {
        fadeTrans := TransLvl

        While, fadeTrans < 255
        {
            fadeTrans += fadeStep

            if (fadeTrans < 255)
            {
              Winset, Transparent, %fadeTrans%, A
              Sleep, 5
            }
        }

        ; set to 255 first as suggested in Help to avoid black background issues
        winset, Transparent, 255, ahk_id A
        winset, Transparent, Off, ahk_id A

        ; Debug Code
        ;WinGetTitle activeTitle, A
        ;WinGetClass activeClass, A
        ;winget activeProcessname, processname, A
        ;MsgBox, Activated %activeTitle%   Class: %activeClass%   Process: %activeProcessname%
    }


    ; get the active process ID to make all windows in a single process the same
    WinGet, active_pid, PID, A

    WinGet, pid, PID, ahk_id %this_id%
    WinGet, id_trans, ID, ahk_id %this_id%
    WinGet, Trans, Transparent, ahk_id %this_id%

    ; if this is a window in the active process, Set non-transparent
    if (pid = active_pid)
    {
        ; if transparent
        if Trans = %TransLvl%
        {
            fadeTrans := TransLvl

            While, fadeTrans < 255
            {
                fadeTrans += fadeStep

                if (fadeTrans < 255)
                {
                  Winset,Transparent, %fadeTrans%, ahk_id %id_trans%
                  Sleep, 5
                }
            }

            ; set to 255 first as suggested in Help to avoid black background issues
            winset, Transparent, 255, ahk_id %id_trans%
            winset, Transparent, Off, ahk_id %id_trans%

            ; Debug Code
            ;winget processname,processname, ahk_id %this_id%
            ;MsgBox, Activated %title%   Class: %class%   Process: %processname%
        }

        continue
    }


    If Trans = %TransLvl% ; already Transparent
        continue

    if delay
    {
        if wininactive%ID_trans% < %delay%
        {
            wininactive%ID_trans% += 1
            continue
        }
        else
        {
            wininactive%ID_min% = 0
        }
    }

    fadeTrans = 255

    While, fadeTrans > TransLvl
    {
        if (fadeTrans > TransLvl)
        {
          fadeTrans -= fadeStep
          Winset,Transparent, %fadeTrans%, ahk_id %id_trans%
          Sleep, 30
        }
    }

    Winset, Transparent, %TransLvl%, ahk_id %id_trans%

    ; Debug Code
    ;winget processname,processname, ahk_id %this_id%
    ;MsgBox, Faded %title%   Class: %class%   Process: %processname%
}
return


; on exit, set windows back to non-transparent
ExitRoutine:
WinGet, id, list, , , Program Manager
Loop, %id%
{
    StringTrimRight, this_id, id%a_index%, 0
    WinGetTitle, title, ahk_id %this_id%
    WinGetClass class , ahk_id %this_id%

    If title =
        continue
    if class = Shell_TrayWnd
        continue
    if class = Button ;you get a large square if you remove this.
       continue
    if class = SysDragImage ; Drag Objects
       continue

    winget processname,processname, ahk_id %this_id%

    ; Exclusions
    if ( processname = "PSPad.exe" and class = "TApplication" )
        continue
    if (processname = "devenv.exe") ; Visual Studio doesn't support transparency (WS_EX_LAYERED is not set)
        continue

    WinGet, id_trans, ID, ahk_id %this_id%

    ; set to 255 first as suggested in Help to avoid black background issues
    Winset,Transparent,255, ahk_id %id_trans%
    Winset,Transparent,off, ahk_id %id_trans%
}
ExitApp
return


Configure:
gui, add, text,,Transparency:
gui, add, text,,Ghost
gui, add, slider,x+5 vTransSlider Range20-255 tooltip,%TransLvl%
gui, add, text,x+5,HiDef
gui, add, text,xm,Fade Step:
gui, add, text,,Slow
gui, add, slider,x+5 vFadeSlider Range1-50 tooltip,%fadeStep%
gui, add, text,x+5,Fast
gui, add, text,xm,`nInactivity Delay (Seconds):
gui, add, text,,Zero
gui, add, slider,x+5 tooltip vDelaySlider Range0-90, %delay%
gui, add, text,x+5,Ninety
gui, add, button,xm,&Save
gui, show,,Configure
return ;the gui


buttonSave:
gui, submit
iniwrite, %TransSlider%, fadetoblack.ini, Preferences, Transparent
iniwrite, %FadeSlider%,  fadetoblack.ini, Preferences, FadeStep
iniwrite, %DelaySlider%, fadetoblack.ini, Preferences, Delay
reload
return