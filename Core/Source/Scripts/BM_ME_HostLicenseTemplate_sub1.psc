Scriptname BM_ME_HostLicenseTemplate_sub1 extends activemagiceffect  

BM_Licenses Property licenses Auto
BM_Licenses_Utility Property bmlUtility Auto

Function InventoryStateChange(Bool heldState)
    bmlUtility.LogTrace("Failed to process new license inventory state. Host MGEF is associated with an unsigned license.")
EndFunction

Function PushStatusUpdate(Bool abHeldState, Int ID)
    InventoryStateChange(abHeldState)
    if abHeldState
        bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", ID)
    else
        bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", ID)
    endIf
    bmlUtility.bmlModeratorAlias.RefreshLicenseValidity()
EndFunction

; ------------------------------

State LicenseBridge_1
    Function InventoryStateChange(Bool heldState)
        licenses.ArmorLicense = heldState
    EndFunction
EndState
State LicenseBridge_2
    Function InventoryStateChange(Bool heldState)
        licenses.BikiniLicense = heldState
    EndFunction
EndState
State LicenseBridge_3
    Function InventoryStateChange(Bool heldState)
        licenses.BikiniExemption = heldState
    EndFunction
EndState
State LicenseBridge_4
    Function InventoryStateChange(Bool heldState)
        licenses.ClothingLicense = heldState
    EndFunction
EndState
State LicenseBridge_5
    Function InventoryStateChange(Bool heldState)
        licenses.MagicLicense = heldState
    EndFunction
EndState
State LicenseBridge_6
    Function InventoryStateChange(Bool heldState)
        licenses.WeaponLicense = heldState
    EndFunction
EndState
State LicenseBridge_7
    Function InventoryStateChange(Bool heldState)
        licenses.CraftingLicense = heldState
    EndFunction
EndState
State LicenseBridge_8
    Function InventoryStateChange(Bool heldState)
        licenses.TravelPermit = heldState
    EndFunction
EndState
State LicenseBridge_9
    Function InventoryStateChange(Bool heldState)
        licenses.CollarExemption = heldState
    EndFunction
EndState
State LicenseBridge_10
    Function InventoryStateChange(Bool heldState)
        licenses.Insurance = heldState
    EndFunction
EndState
State LicenseBridge_11
    Function InventoryStateChange(Bool heldState)
        licenses.CurfewExemption = heldState
    EndFunction
EndState
State LicenseBridge_12
    Function InventoryStateChange(Bool heldState)
        licenses.TradingLicense = heldState
    EndFunction
EndState
State LicenseBridge_13
    Function InventoryStateChange(Bool heldState)
        licenses.WhoreLicense = heldState
    EndFunction
EndState