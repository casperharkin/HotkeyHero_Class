#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


New HotkeyHero
Exit

Class HotkeyHero {
   __New(){
      ;------------------------------------------
      ;----------------[Settings]----------------
      ;------------------------------------------

	  ; Setting up Hotkeys
      SetCapsLockState, AlwaysOff
      This.CapsHotkey := "!CapsLock"
      This.CommanderHotkey := "CapsLock & Space"
	  This.ShortCutHotKey := "s"
	  This.CommandsHotKey := "z" ;WIP

	  ;Setting Up Shortcuts
	  This.FoldersDDL := "Documents|Downloads"
	  This.ProgramsDDL := "Notepad|Chrome|Calc"
	  This.WebsitesDDL := "www.google.com|www.reddit.com"

	  ;Setting Hotstrings
	  This.Replacer := {}
	  This.AddTextReplacment("@", "myemail@email.com")
	  This.AddTextReplacment("ddd",  A_DD "/" A_MM "/" A_YYYY)
      ;------------------------------------------
      ;------------------------------------------	
      
      This.CreateHotkey(This.CapsHotkey, "CapsLockHotkeyHandler")
      This.CreateHotkey(This.CommanderHotkey, "CommanderHotkeyHandler")
      This.MainGui()
   }
   
    AddTextReplacment(hotstring, Value){
	 	This.Replacer[hotstring] := Value
    }
	

   MainGui(){
      Static
      Gui Main: +AlwaysOnTop -SysMenu +ToolWindow -caption +Border +HwndhMainGUI
      This.MainGUI := hMainGUI
      Gui Main: Margin, 16, 16
      Gui Main: Font, s11, Segoe UI
      Gui Main: Add, Text, % "xm w220 -E0x200 +Center +HWNDhTitle", Hello - How can I help?
      This.Bind(hTitle, "MoveGui")
      Gui Main: Add, Edit, % "xm w220 -E0x200 +Center vUserInputBox +HWNDhEditControl"
      This.Bind(This.hEditControl := hEditControl, "Callback")
   }
   
   CreateHotkey(Hotkey, FunctionCall, Params*){
      handler := ObjBindmethod(this, FunctionCall, Params*)
      Hotkey, % Hotkey, % handler, On
   }
   
   Bind(Hwnd, Method, Params*){
      BoundFunc := ObjBindMethod(This, Method, Params*)
      GuiControl +g, % Hwnd, % BoundFunc
   }
   
   CapsLockHotkeyHandler(){
      GetKeyState, KeyState, CapsLock, T 
      if (KeyState = "U")
		 SetCapsLockState, AlwaysOn
      else
         SetCapsLockState, AlwaysOff
   }
   
   CommanderHotkeyHandler(){
      Gui Shortcutter: Destroy
      If !WinExist("ahk_id " This.MainGUI){
         WinGetActiveTitle, GetActiveTitle
         This.ActiveTitle := GetActiveTitle
         This.GuiShow(This.MainGUI)
      }
      Else
         This.GuiClose(This.MainGUI)
   }
   
   GuiShow(GuiHwnd){
      GuiControl, Text, % This.hEditControl 
      Gui, % GuiHwnd ": Show"
   }
   
   GuiClose(GuiHwnd){
      Gui, % GuiHwnd ": Hide"
   }
   
   Callback(){
      ControlGetText, EditControlText,, % " ahk_id " This.hEditControl
      
      for hotstring in This.Replacer
      if (hotstring = EditControlText) {
         This.GuiClose(This.MainGUI)
         WinActivate, % This.ActiveTitle
         SendInput % This.Replacer[hotstring]
      }
      
      if (EditControlText =  This.CommandsHotKey) {
         This.GuiClose(This.MainGUI)
         MsgBox % "You Clicked: " This.CommandsHotKey "!"
      }else  if (EditControlText = This.ShortCutHotKey) {
         This.GuiClose(This.MainGUI)
         This.Shortcutter()
      }}
   
   MoveGui(){
      PostMessage, 0xA1, 2,
   }
   
   ShortCutChoice(){
      if (This.DDL_State = "Folders") or (This.DDL_State = "") {
         ControlGetText, selection,, % " ahk_id " This.hfolderChoice
         Run, % "C:\Users\" A_Username "\" . selection
         Gui Shortcutter: Destroy
      }
      if (This.DDL_State = "Programs"){
         ControlGetText, selection,, % " ahk_id " This.hprogramChoice
         Run, % selection
         Gui Shortcutter: Destroy
      }
      if (This.DDL_State = "Websites"){
         ControlGetText, selection,, % " ahk_id " This.hWebsitesChoice
         Run, % selection
         Gui Shortcutter: Destroy
      }
	}
   
   TabControler(){
      GuiControlGet, tabselection,, % This.hTab2
      This.DDL_State := tabselection
   }
   
   Shortcutter(){
      Static
      Gui Shortcutter: Add, Tab2, x2 y-1 w410 h60 +HwndhTab2 , Folders|Programs|Websites
      This.Bind(This.hTab2 := hTab2, "TabControler")
      
      Gui Shortcutter: +AlwaysOnTop -SysMenu +ToolWindow +caption +Border +HwndhShortCutter
      This.hShortCutter := hShortCutter
      
      Gui Shortcutter: Tab, Folders
      Gui Shortcutter: Add, DropDownList, x12 y29 w340 +HwndhfolderChoice Sort, % This.FoldersDDL
      This.Bind(This.hfolderChoice := hfolderChoice, "ShortCutChoice")
      
      Gui Shortcutter: Tab, Programs
      Gui Shortcutter: Add, DropDownList, x12 y29 w340 +HwndhprogramChoice Sort, % This.ProgramsDDL 
      This.Bind(This.hprogramChoice := hprogramChoice, "ShortCutChoice")
      
      Gui Shortcutter: Tab, Websites
      Gui Shortcutter: Add, DropDownList, x12 y29 w340 +HwndhWebsitesChoice Sort, % This.WebsitesDDL
      This.Bind(This.hWebsitesChoice := hWebsitesChoice, "ShortCutChoice")

      Gui Shortcutter: Show, w416 h63, Shortcutter
   }
  
}              
