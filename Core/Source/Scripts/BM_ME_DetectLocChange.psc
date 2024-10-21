Scriptname BM_ME_DetectLocChange extends activemagiceffect  

ObjectReference Property BM_PlayerMarker  Auto  
BM_Licenses_Utility Property bmlUtility Auto
FormList Property BM_CurrentLocation auto
FormList Property BM_CurrentWorldspace auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(0.1)
    OnLocationChange(BM_PlayerMarker.GetCurrentLocation(), akTarget.GetCurrentLocation())
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    ; On the off-chance that this script still gets stuck, allow OnLocationChange() event to fire and re-sync marker with player.
    Actor akTarget = GetTargetActor()
    BM_PlayerMarker.DisableNoWait()
    if akTarget.IsInInterior()
        BM_PlayerMarker.MoveTo(akTarget, -75.0 * Math.Sin(akTarget.GetAngleZ()), -75.0 * Math.Cos(akTarget.GetAngleZ())) ; move marker 75 units behind the player to improve possible load door detection
    else
        BM_PlayerMarker.MoveTo(akTarget)
    endIf
    BM_PlayerMarker.EnableNoWait()
    bmlUtility.currLoc = akNewLoc
    bmlUtility.currSpace = akTarget.GetWorldSpace()
    BM_CurrentLocation.Revert()
    BM_CurrentLocation.AddForm(bmlUtility.currLoc)
    BM_CurrentWorldspace.Revert()
    BM_CurrentWorldspace.AddForm(bmlUtility.currSpace)
    if akOldLoc || akNewLoc
        bmlUtility.ModeratorMaintanence()
    endIf
EndEvent

; This script runs under the following primary conditions:
; IF player's CurrentLocation isn't the same as the last recorded CurrentLocation, OR
; IF player's CurrentWorldspace isn't the same as the last recorded CurrentWorldspace.
; These secondary conditions act as safeguards:
; IF player is not in the same cell as BM_PlayerMarker, AND
; IF player is at least 1000 units away from BM_PlayerMarker, AND
; IF player is in an interior, OR
; IF player location has ref type LocationCenterMarker, OR
; IF BM_PlayerMarker has ref type LocationCenterMarker.
; This script runs erroneously in the wilderness because a lack of actual Location property makes BM_CurrentLocation cache a NONE property, hence allowing MGEF to refresh at each cell change instead.
; Making sure at least one of the two subjects' locations has a LocationCenterMarker allows us to track wild cell enter AND ensure an MGEF fire in this condition is only completed once instead of per cell.
; All interior and exterior cells that have a location should also have a LocationCenterMarker. Non-locations or cells not attributed to a clear location lack a LocationCenterMarker.