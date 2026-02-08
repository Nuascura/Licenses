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
EndFunction

Function RefreshLicenseValidity()
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnUpdate()
    bmlUtility.ModeratorUpdater()
EndEvent

; ---------- Event Mitigation ----------
Function TrackPlayerStatus_SL() ; SexLab
    RegisterForModEvent("PlayerTrack_Start", "PlayerTrack_OnStart")
    RegisterForModEvent("PlayerTrack_End", "PlayerTrack_OnEnd")
EndFunction

Function PlayerTrack_OnStart(Form FormRef, int tid)
    bmlUtility.LogTrace("PlayerTrack_OnStart")
    bmlUtility.BM_IsInAnimation.SetValue(1.0)
EndFunction

Event PlayerTrack_OnEnd(Form FormRef, int tid)
    bmlUtility.LogTrace("PlayerTrack_OnEnd")
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