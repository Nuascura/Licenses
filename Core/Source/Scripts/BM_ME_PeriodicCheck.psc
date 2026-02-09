Scriptname BM_ME_PeriodicCheck extends activemagiceffect  

Import Utility

BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property NextStatusCheck Auto
GlobalVariable Property NextStorageClear Auto
GlobalVariable Property GameDaysPassed Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if IsInMenuMode()
        Wait(2.5) ; buffer if inside menu mode
    endIf
    if NextStatusCheck.GetValue()
        if NextStorageClear.GetValue() > GameDaysPassed.GetValue()
            bmlUtility.CheckStorageStatus()
        endIf
        bmlUtility.CheckLicenseStatus()
    endIf
    ; this magic effect will automatically stop when NextStatusCheck updates, thus invalidating the host spell's condition.
    ; using dispel() will instead prohibit the spell from enabling this magic effect for the next cycle
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    bmlUtility.LogTrace("Ended Periodic Check Effect at time: " + GameDaysPassed.GetValue())
EndEvent