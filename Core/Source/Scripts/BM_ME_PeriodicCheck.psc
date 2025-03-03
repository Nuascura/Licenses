Scriptname BM_ME_PeriodicCheck extends activemagiceffect  

BM_Licenses Property licenses auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Utility.IsInMenuMode()
        Utility.Wait(2.5) ; buffer if inside menu mode
    endIf
    licenses.bmlUtility.CheckLicenseStatus()
    ; this magic effect will automatically stop when NextStatusCheck updates, thus invalidating the host spell's condition.
    ; using dispel() will instead prohibit the spell from enabling this magic effect for the next cycle
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    licenses.bmlUtility.LogTrace("Ended Periodic Check Effect at time: " + licenses.bmlUtility.GameDaysPassed.GetValue())
EndEvent