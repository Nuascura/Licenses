Scriptname BM_ME_HostLicenseTemplateBridge extends activemagiceffect  

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
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.ArmorLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_2
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.BikiniLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_3
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.BikiniExemption = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_4
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.ClothingLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_5
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.MagicLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_6
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.WeaponLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_7
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.CraftingLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_8
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.TravelPermit = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_9
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.CollarExemption = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_10
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.Insurance = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_11
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.CurfewExemption = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_12
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.TradingLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState
State LicenseBridge_13
    Event OnBeginState()
        InventoryStateChange(true)
    EndEvent
    Function InventoryStateChange(Bool heldState)
        licenses.WhoreLicense = heldState
    EndFunction
    Event OnEndState()
        InventoryStateChange(false)
    EndEvent
EndState