;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname BM_D_Travel_Forfeit Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
bmlUtility.BM_ExpireTravelPermit()
if bmlUtility.licenseViolationCheckQuest.IsRunning()
    bmlUtility.licenseViolationCheckQuest.stop()
endIf
bmlUtility.savedLoc = bmlUtility.lastLoc
bmlUtility.savedSpace = bmlUtility.lastSpace
bmlUtility.GameMessage(bmlUtility.licenses.MessageTravelLocated)
bmlUtility.startViolationCheckQuest()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

BM_Licenses_Utility Property bmlUtility Auto