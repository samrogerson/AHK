; -------
; OPTIONS
; -------
;   Title of the game's window
DDWindowName:="Dungeon Defenders"
;   Key assigned to ready up
DDReadyKey:="h"
DDJoyReadyKey:="c"
;   Whether to try and repair buildings
DoRepair:=false
;   How many repairs
RepairLoops:=4
;   How long to wait between repairs (adjust for casting rate)
RepairWait:=1000
;   Whether to try and upgrade buildings
DoUpgrade:=false
;   How many upgrades
UpgradeLoops:=2
;   How long to wait between upgrades (adjust for casting rate)
UpgradeWait:=1000
;   true: you use left click to select things
;   false: you use the key defined by SelectKey to select things
SelectKey:="{LButton}"
;   Whether or not to take focus (required for xbox emulator controls
TakeFocus:=true
NHeroes:=2

; INTERNAL OPTION
Active:=false

; Control + Shift + g
^+g::StartAfk()
; Control + Alt + g
^!g::StopAfk()
; Control + Shift + p
^+p::ExitScript()
; Control + Shift + h
^+h::ReadyUp(true,NHeroes)
; Control + Shift + b
^+r::
    DoRepair:=!DoRepair
    Alert("Repair " . DoRepair)
    return
; Control + Shift + r
^+u::
    DoUpgrade:=!DoUpgrade
    Alert("Upgrade " . DoUpgrade)
    return
^+Up::
    NHeroes++
    Alert("NHeroes = " . NHeroes)
    return
^+Down::
    NHeroes--
    Alert("NHeroes = " . NHeroes)
    return

SendToChat(msg) {
    global DDWindowName
    ControlSend,,y,%DDWindowName%
    Sleep 500
    ControlSend,,%msg%,%DDWindowName%
    sleep 500
    ControlSend,,{Enter},%DDWindowName%
}
    
    
Alert(msg) {
    TrayTip, Afk Script, %msg%
}

ActionThenSelect(key, wait) {
    global DDWindowName, SelectKey
    ControlSend,,%key%,%DDWindowName%
    ControlSend,,%SelectKey%,%DDWindowName%
    Sleep %wait%
}


ReadyUp(takefocus=false,heroes=1) {
    global DDWindowName, DDReadyKey, DDJoyReadyKey
    SetKeyDelay,,500
    ControlSend,,%DDReadyKey%,%DDWindowName%
    if takefocus and heroes > 1 {
        WinGet, original_active, ID, A
        WinActivate, %DDWindowName%
        Loop {
            if a_index >= %heroes%
                break
            nf:=a_index+1
            SendInput {F%nf%}
            Send %DDJoyReadyKey%
        }
        SendInput {F1}
        WinActivate, ahk_id %original_active%
    }
}


Repair() {
    global Active, RepairLoops, RepairWait
    Loop, %RepairLoops% {
        if Active
            ActionThenSelect("4",RepairWait)
            ReadyUp(false)
    }
}


Upgrade() {
    global Active, UpgradeLoops, UpgradeWait
    Loop, %UpgradeLoops% {
        if Active
            ActionThenSelect("5",UpgradeWait)
            ReadyUp(false)
    }
}


StartAfk() {
    global Active, DDWindowName, DDReadyKey, DoUpgrade, DoRepair, NHeroes
    Active:=true
    Alert("Script started")
    while Active {
        ReadyUp(true,NHeroes)
        if DoUpgrade
            Upgrade()
        if DoRepair
            Repair()
        sleep 3000
    }
    Alert("Script stopped")
    Sleep 3000
}


StopAfk() {
    global Active
    Active:=false
}


ExitScript() {
    Alert("Script exiting")
    Sleep 3000
    exitapp
}
