Scriptname BM_Licenses_Moderator_Alias extends ReferenceAlias  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto

Event OnPlayerLoadGame()
    if bmlUtility.Licenses_State && Quest.GetQuest("BM_Licenses_MCM").IsRunning()
        bmlUtility.ReloadMCMVariables()
    endIf

    TrackPlayerStatus_SL()
    TrackPlayerStatus_OS()
    TrackPlayerStatus_POP()
    TrackPlayerStatus_DHLP()
    TrackPlayerStatus_SS()
    TrackPlayerStatus_PA()
    TrackPlayerStatus_DIN()
    
    bmlUtility.refreshInventoryEventFilters()
EndEvent

Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
    ; book items do not pass inventory event if respective license feature is disabled or license is invalid/expired
    if (item as Book)
        if (item == bmlUtility.BM_ArmorLicense)
            licenses.hasArmorLicense = true
        elseIf (item == bmlUtility.BM_BikiniLicense)
            licenses.hasBikiniLicense = true
        elseIf (item == bmlUtility.BM_ClothingLicense)
            licenses.hasClothingLicense = true
        elseIf (item == bmlUtility.BM_MagicLicense)
            licenses.hasMagicLicense = true
        elseIf (item == bmlUtility.BM_WeaponLicense)
            licenses.hasWeaponLicense = true
        elseIf (item == bmlUtility.BM_CraftingLicense)
            licenses.hasCraftingLicense = true
        elseIf (item == bmlUtility.BM_TradingLicense)
            licenses.hasTradingLicense = true
        elseIf (item == bmlUtility.BM_WhoreLicense)
            licenses.hasWhoreLicense = true
        elseIf (item == bmlUtility.BM_TravelPermit)
            licenses.hasTravelPermit = true
        elseIf (item == bmlUtility.BM_CollarExemption)
            licenses.hasCollarExemption = true
        elseIf (item == bmlUtility.BM_Insurance)
            licenses.hasInsurance = true
        elseIf (item == bmlUtility.BM_CurfewExemption)
            licenses.hasCurfewExemption = true
        endif
        RefreshLicenseValidity()
    endif
endEvent

Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
    ; book items do not pass inventory event if respective license feature is disabled or license is invalid/expired
    if (item as Book)
        if (item == bmlUtility.BM_ArmorLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_ArmorLicense) < 1)
            licenses.hasArmorLicense = false
        elseIf (item == bmlUtility.BM_BikiniLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_BikiniLicense) < 1)
            licenses.hasBikiniLicense = false
        elseIf (item == bmlUtility.BM_ClothingLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_ClothingLicense) < 1)
            licenses.hasClothingLicense = false
        elseIf (item == bmlUtility.BM_MagicLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_MagicLicense) < 1)
            licenses.hasMagicLicense = false
        elseIf (item == bmlUtility.BM_WeaponLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_WeaponLicense) < 1)
            licenses.hasWeaponLicense = false
        elseIf (item == bmlUtility.BM_CraftingLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_CraftingLicense) < 1)
            licenses.hasCraftingLicense = false
        elseIf (item == bmlUtility.BM_TradingLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_TradingLicense) < 1)
            licenses.hasTradingLicense = false
        elseIf (item == bmlUtility.BM_WhoreLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_WhoreLicense) < 1)
            licenses.hasWhoreLicense = false
        elseIf (item == bmlUtility.BM_TravelPermit) && (self.GetActorRef().GetItemCount(bmlUtility.BM_TravelPermit) < 1)
            licenses.hasTravelPermit = false
        elseIf (item == bmlUtility.BM_CollarExemption) && (self.GetActorRef().GetItemCount(bmlUtility.BM_CollarExemption) < 1)
            licenses.hasCollarExemption = false
        elseIf (item == bmlUtility.BM_Insurance) && (self.GetActorRef().GetItemCount(bmlUtility.BM_Insurance) < 1)
            licenses.hasInsurance = false
        elseIf (item == bmlUtility.BM_CurfewExemption) && (self.GetActorRef().GetItemCount(bmlUtility.BM_CurfewExemption) < 1)
            licenses.hasCurfewExemption = false
        endif
        RefreshLicenseValidity()
    endif
endEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    bmlUtility.CheckProximity()
    bmlUtility.CheckThaneship()
    RefreshLicenseValidity()
EndEvent

Function RefreshLicenseValidity()
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnUpdate()
    bmlUtility.ModeratorUpdater()
EndEvent

; ---------- Event Mitigation ----------
Function TrackPlayerStatus_SL() ; SexLab
    SexLabFramework SexLab = (Game.GetFormFromFile(0x000D62, "SexLab.esm") as Quest) as SexLabFramework
    if SexLab
        SexLab.TrackActor(self.GetActorRef(), "SLScene")
    endIf
    RegisterForModEvent("SLScene_Added", "SLScene_OnAdded")
    RegisterForModEvent("SLScene_End", "SLScene_OnEnd")
EndFunction

Event SLScene_OnAdded(Form FormRef, int tid)
    bmlUtility.LogTrace("SLScene_OnAdded")
    bmlUtility.BM_IsInAnimation.SetValue(1.0)
EndEvent

Event SLScene_OnEnd(Form FormRef, int tid)
    bmlUtility.LogTrace("SLScene_OnEnd")
    bmlUtility.BM_IsInAnimation.SetValue(0.0)
EndEvent

Function TrackPlayerStatus_OS() ; OStim
    RegisterForModEvent("ostim_start", "OStim_OnStart")
    RegisterForModEvent("ostim_end", "OStim_OnEnd")
EndFunction

Event OStim_OnStart(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("OStim_OnStart")
    bmlUtility.BM_IsInAnimation.SetValue(1.0)
EndEvent

Event OStim_OnEnd(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("OStim_OnEnd")
    bmlUtility.BM_IsInAnimation.SetValue(0.0)
EndEvent

Function TrackPlayerStatus_POP() ; Prison Overhaul Patched
    RegisterForModEvent("xpoSubArrestPC", "xpo_OnSubArrestPC")
    RegisterForModEvent("xpoArrestPC", "xpo_OnArrestPC")
    RegisterForModEvent("xpoPCisFree", "xpo_OnPCisFree")
    RegisterForModEvent("xpoSceneDone", "xpo_OnSceneDone")
EndFunction

Event xpo_OnSubArrestPC(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("xpo_OnSubArrestPC")
    licenses.PlayerJailed(true)
EndEvent

Event xpo_OnArrestPC(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("xpo_OnArrestPC")
    licenses.PlayerJailed(true)
EndEvent

Event xpo_OnPCisFree(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("xpo_OnPCisFree")
    bmlUtility.BM_IsInJail.SetValue(0.0)
EndEvent

Event xpo_OnSceneDone(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("xpo_OnSceneDone")
    if StorageUtil.GetIntValue(licenses.playerRef.GetActorRef(), "xpoPCArrestStart") == 1 || StorageUtil.GetIntValue(licenses.playerRef.GetActorRef(), "xpoPCArrested")  == 1
        bmlUtility.BM_IsInJail.SetValue(1.0)
    else
        bmlUtility.BM_IsInJail.SetValue(0.0)
    endIf
EndEvent

Function TrackPlayerStatus_DHLP() ; Deviously Helpless (standardized event)
    RegisterForModEvent("dhlp-Suspend", "DHLP_OnSuspend")
    RegisterForModEvent("dhlp-Resume", "DHLP_OnResume")
EndFunction

Event DHLP_OnSuspend(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("DHLP_OnSuspend")
    bmlUtility.BM_IsInDHLPEvent.SetValue(1.0)
    licenses.ResetViolations(-1)
EndEvent

Event DHLP_OnResume(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("DHLP_OnResume")
    bmlUtility.BM_IsInDHLPEvent.SetValue(0.0)
EndEvent

Function TrackPlayerStatus_SS() ; Simple Slavery
    RegisterForModEvent("SSLV Entry", "SSLV_OnEntry")
    RegisterForModEvent("SSLV Exit", "SSLV_OnExit")
EndFunction

Event SSLV_OnEntry(String eventName, String argStr, Float argNum, Form sender)
    bmlUtility.LogTrace("SSLV_OnEntry")
    bmlUtility.BM_IsInSSLV.SetValue(1.0)
    licenses.ResetViolations(-1)
EndEvent 

Event SSLV_OnExit(Form sender, String outcome)
    bmlUtility.LogTrace("SSLV_OnExit")
    bmlUtility.BM_IsInSSLV.SetValue(0.0)
EndEvent 

Function TrackPlayerStatus_PA() ; Prison Alternative
    RegisterForModEvent("pamaPA_ImprisonementStart", "pamaPA_OnImprisonementStart")
    RegisterForModEvent("pamaPA_ImprisonementEnd", "pamaPA_OnImprisonementEnd")
EndFunction

Event pamaPA_OnImprisonementStart(string eventName, string strArg, float numArg, Form sender)
    bmlUtility.LogTrace("pamaPA_OnImprisonementStart")
    licenses.PlayerJailed(true)
EndEvent

Event pamaPA_OnImprisonementEnd(string eventName, string strArg, float numArg, Form sender)
    bmlUtility.LogTrace("pamaPA_OnImprisonementEnd")
    bmlUtility.BM_IsInJail.SetValue(0.0)
EndEvent

Function TrackPlayerStatus_DIN() ; Devious Interests
    RegisterForModEvent("DIN_Freed", "DIN_OnFreed")
EndFunction

Event DIN_OnFreed(string eventName, string strArg, float numArg, Form sender)
    bmlUtility.LogTrace("DIN_OnFreed")
    bmlUtility.BM_IsInJail.SetValue(0.0)
EndEvent
; ------------------------------