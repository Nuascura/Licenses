Scriptname BM_Licenses_Moderator_Alias extends ReferenceAlias  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto

Actor PlayerRef

Event OnPlayerLoadGame()
    OnLoad()
EndEvent

Function OnLoad()
    UnregisterForAllModEvents()
    PlayerRef = self.GetActorRef()

    if bmlUtility.Licenses_CachedState && bmlUtility.bmlmcm.IsRunning()
        bmlUtility.ReloadMCMVariables()
    endIf

    TrackPlayerStatus_SL()
    TrackPlayerStatus_OS()
    TrackPlayerStatus_POP()
    TrackPlayerStatus_DHLP()
    TrackPlayerStatus_SS()
    TrackPlayerStatus_PA()
    TrackPlayerStatus_DIN()
    TrackDeviousDevicesStatus_DD()

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
    if (item as Book) && (PlayerRef.GetItemCount(item) < 1)
        if (item == bmlUtility.BM_ArmorLicense)
            licenses.ArmorLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 1)
        elseIf (item == bmlUtility.BM_BikiniLicense)
            licenses.BikiniLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 2)
        elseIf (item == bmlUtility.BM_ClothingLicense)
            licenses.ClothingLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 3)
        elseIf (item == bmlUtility.BM_MagicLicense)
            licenses.MagicLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 4)
        elseIf (item == bmlUtility.BM_WeaponLicense)
            licenses.WeaponLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 5)
        elseIf (item == bmlUtility.BM_CraftingLicense)
            licenses.CraftingLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 6)
        elseIf (item == bmlUtility.BM_TravelPermit)
            licenses.TravelPermit = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 7)
        elseIf (item == bmlUtility.BM_CollarExemption)
            licenses.CollarExemption = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 8)
        elseIf (item == bmlUtility.BM_Insurance)
            licenses.Insurance = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 9)
        elseIf (item == bmlUtility.BM_CurfewExemption)
            licenses.CurfewExemption = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 10)
        elseIf (item == bmlUtility.BM_TradingLicense)
            licenses.TradingLicense = false
            bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", 11)
        elseIf (item == bmlUtility.BM_WhoreLicense)
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
    if bmlUtility.bmlmcm.SexLab_State
        (Quest.GetQuest("SexLabQuestFramework") as SexLabFramework).TrackActor(PlayerRef, "SLScene")
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
    licenses.PlayerJailed(false, false)
EndEvent

Event xpo_OnArrestPC(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("xpo_OnArrestPC")
    licenses.PlayerJailed(false, false)
EndEvent

Event xpo_OnPCisFree(String eventName, String strArg, Float numArg, Form sender)
    bmlUtility.LogTrace("xpo_OnPCisFree")
    licenses.ApplyPunishment(true)
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
    licenses.PlayerJailed(false, false)
EndEvent

Event pamaPA_OnImprisonementEnd(string eventName, string strArg, float numArg, Form sender)
    bmlUtility.LogTrace("pamaPA_OnImprisonementEnd")
    licenses.ApplyPunishment(true)
    bmlUtility.BM_IsInJail.SetValue(0.0)
EndEvent

Function TrackPlayerStatus_DIN() ; Devious Interests
    RegisterForModEvent("DIN_Jailed", "DIN_OnJailed")
    RegisterForModEvent("DIN_Freed", "DIN_OnFreed")
EndFunction

Event DIN_OnJailed(string eventName, string strArg, float numArg, Form sender)
    bmlUtility.LogTrace("DIN_OnJailed")
    licenses.PlayerJailed(false, false)
EndEvent

Event DIN_OnFreed(string eventName, string strArg, float numArg, Form sender)
    bmlUtility.LogTrace("DIN_OnFreed")
    licenses.ApplyPunishment(true)
    bmlUtility.BM_IsInJail.SetValue(0.0)
EndEvent

Function TrackDeviousDevicesStatus_DD() ; Devious Devices
    RegisterForModEvent("DDI_DeviceEquipped", "DDI_OnDeviceEquipped")
    RegisterForModEvent("DDI_DeviceRemoved", "DDI_OnDeviceRemoved")
EndFunction

Event DDI_OnDeviceEquipped(Form inventoryDevice, Form deviceKeyword, Form akActor)
    bmlUtility.LogTrace("DDI_OnDeviceEquipped")
    Utility.Wait(0.5)
    if PlayerRef.WornHasKeyword(Keyword.GetKeyword("zad_deviousCollar"))
        bmlUtility.DD_FlagPlayerCollar(true)
    endIf
EndEvent

Event DDI_OnDeviceRemoved(Form inventoryDevice, Form deviceKeyword, Form akActor)
    bmlUtility.LogTrace("DDI_OnDeviceRemoved")
    Utility.Wait(0.5)
    if !PlayerRef.WornHasKeyword(Keyword.GetKeyword("zad_deviousCollar"))
        bmlUtility.DD_FlagPlayerCollar(false)
    endIf
EndEvent
; ------------------------------

; ---------- Internal Event Reception ----------
Function TrackInternalStatus_LPO() ; Licenses
    RegisterForModEvent("BM-LPO_ConfrontationEnd", "LPO_OnConfrontationEnd")
    RegisterForModEvent("BM-LPO_LicensePurchased", "LPO_OnLicensePurchased")
EndFunction

Event LPO_OnConfrontationEnd(int aiArg1)
    bmlUtility.LogTrace("LPO_OnConfrontationEnd")
    if aiArg1 == 1 && bmlUtility.CountValidLicenses() != 0
        bmlUtility.DF_AdjustResistance(8.0 * (1.0 + (bmlUtility.CountActiveViolations() / bmlUtility.CountValidLicenses())))
    endIf
EndEvent

Event LPO_OnLicensePurchased(int aiArg1)
    bmlUtility.LogTrace("LPO_OnLicensePurchased")
    bmlUtility.DF_AdjustResistance(2.0 * bmlUtility.CountActiveLicenses())
EndEvent
; ------------------------------