;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname BM_D_WalkAway_Kinky Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
RegisterForSingleUpdate(5.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
BM_D_RestrictWalkaway.SetValue(0.0)
BM_D_ForceArrest.SetValue(0.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdate()
    if !(BM_D_RestrictWalkaway.GetValue() as bool)
        licenses.FinishConfrontation(Speaker, -1)
        BM_D_RestrictWalkaway.SetValue(0.0)
        BM_D_ForceArrest.SetValue(0.0)
        getOwningQuest().stop()
    endIf
EndEvent

Actor Speaker
BM_Licenses Property licenses Auto
GlobalVariable Property BM_D_ForceArrest Auto
GlobalVariable Property BM_D_RestrictWalkaway Auto
