Scriptname BM_ME_DetectStateWater extends activemagiceffect  

import Utility
import PO3_SKSEFunctions

BM_Licenses_Utility Property bmlUtility Auto
Message Property BM_Licenses_MessageWaterWarn  Auto
FormList Property BM_LicenseBooks  Auto
Actor TargetActor

Event OnEffectStart(Actor akTarget, Actor akCaster)
    TargetActor = akTarget
	RegisterForSingleUpdate(0.1)
EndEvent

Event OnUpdate()
	if IsActorInWater(TargetActor)
		CheckWaterDamage()
		RegisterForSingleUpdate(30.0)
	endIf
EndEvent

Function CheckWaterDamage()
    int random = RandomInt(1,100)
    if (random < 50) || (IsActorUnderwater(TargetActor) && random < 75)
        DestroyRandomLicense()
    endIf
EndFunction

Function DestroyRandomLicense()
    Form kRandomLicense = BM_LicenseBooks.GetAt(RandomInt(0, BM_LicenseBooks.GetSize() - 1))
    if TargetActor.getItemCount(kRandomLicense) > 0
        TargetActor.removeItem(kRandomLicense, 1, true)
        bmlUtility.GameMessage(BM_Licenses_MessageWaterWarn)
        bmlUtility.LogNotification("Water damage destroyed your " + kRandomLicense.GetName() + ".")
    endIf
Endfunction  
