#SingleInstance Force
^!j:: Send {Down}
^!k:: Send {Up}
+!j:: Send {Down}
+!k:: Send {Up}
#!j:: Send {Down}
#!k:: Send {Up}
#Esc:: 
  if GetKeyState("CapsLock", "T") = 1
  {
    SetCapsLockState, off
  }
  else if GetKeyState("CapsLock", "F") = 0
  {
    SetCapsLockState, on
  }
return 