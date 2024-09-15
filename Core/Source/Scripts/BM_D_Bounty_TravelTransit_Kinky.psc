;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname BM_D_Bounty_TravelTransit_Kinky Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if ClosestSettlementMarker.GetReference()
    Game.GetPlayer().MoveTo(ClosestSettlementMarker.GetReference())
else
    akSpeaker.GetCrimeFaction().SendPlayerToJail()
endIf
getOwningQuest().stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property ClosestSettlementMarker Auto
