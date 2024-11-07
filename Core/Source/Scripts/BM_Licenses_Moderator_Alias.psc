Scriptname BM_Licenses_Moderator_Alias extends ReferenceAlias  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto

Event OnPlayerLoadGame()
    OnLoad()
EndEvent

Function OnLoad()
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

    TrackInternalStatus_LPO()
    
    bmlUtility.refreshInventoryEventFilters()
EndFunction

Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
    ; book items do not pass inventory event if respective license feature is disabled or license is invalid/expired
    if (item as Book)
        if (item == bmlUtility.BM_ArmorLicense)
            licenses.ArmorLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 1)
        elseIf (item == bmlUtility.BM_BikiniLicense)
            licenses.BikiniLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 2)
        elseIf (item == bmlUtility.BM_ClothingLicense)
            licenses.ClothingLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 3)
        elseIf (item == bmlUtility.BM_MagicLicense)
            licenses.MagicLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 4)
        elseIf (item == bmlUtility.BM_WeaponLicense)
            licenses.WeaponLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 5)
        elseIf (item == bmlUtility.BM_CraftingLicense)
            licenses.CraftingLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 6)
        elseIf (item == bmlUtility.BM_TravelPermit)
            licenses.TravelPermit = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 7)
        elseIf (item == bmlUtility.BM_CollarExemption)
            licenses.CollarExemption = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 8)
        elseIf (item == bmlUtility.BM_Insurance)
            licenses.Insurance = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 9)
        elseIf (item == bmlUtility.BM_CurfewExemption)
            licenses.CurfewExemption = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 10)
        elseIf (item == bmlUtility.BM_TradingLicense)
            licenses.TradingLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 11)
        elseIf (item == bmlUtility.BM_WhoreLicense)
            licenses.WhoreLicense = true
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", 12)
        endif
        RefreshLicenseValidity()
    endif
endEvent

Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
    ; book items do not pass inventory event if respective license feature is disabled or license is invalid/expired
    if (item as Book)
        if (item == bmlUtility.BM_ArmorLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_ArmorLicense) < 1)
            licenses.ArmorLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 1)
        elseIf (item == bmlUtility.BM_BikiniLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_BikiniLicense) < 1)
            licenses.BikiniLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 2)
        elseIf (item == bmlUtility.BM_ClothingLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_ClothingLicense) < 1)
            licenses.ClothingLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 3)
        elseIf (item == bmlUtility.BM_MagicLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_MagicLicense) < 1)
            licenses.MagicLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 4)
        elseIf (item == bmlUtility.BM_WeaponLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_WeaponLicense) < 1)
            licenses.WeaponLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 5)
        elseIf (item == bmlUtility.BM_CraftingLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_CraftingLicense) < 1)
            licenses.CraftingLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 6)
        elseIf (item == bmlUtility.BM_TravelPermit) && (self.GetActorRef().GetItemCount(bmlUtility.BM_TravelPermit) < 1)
            licenses.TravelPermit = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 7)
        elseIf (item == bmlUtility.BM_CollarExemption) && (self.GetActorRef().GetItemCount(bmlUtility.BM_CollarExemption) < 1)
            licenses.CollarExemption = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 8)
        elseIf (item == bmlUtility.BM_Insurance) && (self.GetActorRef().GetItemCount(bmlUtility.BM_Insurance) < 1)
            licenses.Insurance = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 9)
        elseIf (item == bmlUtility.BM_CurfewExemption) && (self.GetActorRef().GetItemCount(bmlUtility.BM_CurfewExemption) < 1)
            licenses.CurfewExemption = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 10)
        elseIf (item == bmlUtility.BM_TradingLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_TradingLicense) < 1)
            licenses.TradingLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 11)
        elseIf (item == bmlUtility.BM_WhoreLicense) && (self.GetActorRef().GetItemCount(bmlUtility.BM_WhoreLicense) < 1)
            licenses.WhoreLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 12)
        endif
        RefreshLicenseValidity()
    endif
endEvent

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
    RegisterForModEvent("SLScene_Start", "SLScene_OnStart")
    RegisterForModEvent("SLScene_End", "SLScene_OnEnd")
EndFunction

Function SLScene_OnStart(Form FormRef, int tid)
    bmlUtility.LogTrace("SLScene_OnStart")
    bmlUtility.BM_IsInAnimation.SetValue(1.0)
EndFunction

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

; ---------- Event Reception ----------
Function TrackInternalStatus_LPO() ; Licenses
    RegisterForModEvent("BM-LPO_ConfrontationEnd", "LPO_OnConfrontationEnd")
    RegisterForModEvent("BM-LPO_LicensePurchased", "LPO_OnLicensePurchased")
EndFunction

Event LPO_OnConfrontationEnd(int aiArg1)
    bmlUtility.LogTrace("LPO_OnConfrontationEnd")
    if aiArg1 == 1
        bmlUtility.DF_AdjustResistance(8.0 * (1.0 + (bmlUtility.CountActiveViolations() / bmlUtility.CountValidLicenses())))
    endIf
EndEvent

Event LPO_OnLicensePurchased(int aiArg1)
    bmlUtility.LogTrace("LPO_OnLicensePurchased")
    bmlUtility.DF_AdjustResistance(2.0 * bmlUtility.CountActiveLicenses())
EndEvent
; ------------------------------