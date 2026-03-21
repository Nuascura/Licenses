;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname BM_D_Submission_Collar Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
BM_IsPlayerCollared.SetValue(1.0)
BM_API_DD.equipCollar(bmlInit.kzadAPI, bmlInit.kzadxAPI, SubjectActor, bmlmcm.ddFilter)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property SubjectActor auto
BM_Licenses_Init Property bmlInit auto
BM_Licenses_MCM Property bmlmcm auto
GlobalVariable Property BM_IsPlayerCollared auto