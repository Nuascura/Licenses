;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname BM_D_Bounty_ForceGreet_Kinky Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
BM_D_RestrictWalkaway.SetValue(1.0)
if licenses.isTravelViolation && !licenses.isInCity && !licenses.isInTown
    BM_D_ForceArrest.SetValue(1.0)
else
    BM_D_ForceArrest.SetValue(0.0)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

BM_Licenses Property licenses Auto
GlobalVariable Property BM_D_ForceArrest Auto
GlobalVariable Property BM_D_RestrictWalkaway Auto
