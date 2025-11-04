Scriptname BM_ME_DetectStateWater extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
Message Property BM_Licenses_MessageWaterWarn  Auto

Actor playerActor

Event OnEffectStart(Actor akTarget, Actor akCaster)
	playerActor = licenses.PlayerActorRef
	RegisterForSingleUpdate(0.1)
EndEvent

Event OnUpdate()
	if PO3_SKSEFunctions.IsActorInWater(playerActor)
		CheckWaterDamage()
		RegisterForSingleUpdate(30.0)
	endIf
EndEvent

Function CheckWaterDamage()
    int random = Utility.RandomInt(1,100)
    if (random < 50) || (PO3_SKSEFunctions.IsActorUnderwater(playerActor) && random < 75)
        DestroyRandomLicense()
    endIf
EndFunction

Function DestroyRandomLicense()
    Form kRandomLicense = bmlUtility.BM_LicenseBooks.GetAt(Utility.RandomInt(0, bmlUtility.BM_LicenseBooks.GetSize() - 1))
    if playerActor.getItemCount(kRandomLicense) > 0
        playerActor.removeItem(kRandomLicense, 1, true)
        bmlUtility.GameMessage(BM_Licenses_MessageWaterWarn)
        bmlUtility.LogNotification("Water damage destroyed your " + kRandomLicense.GetName() + ".")
    endIf
Endfunction  
