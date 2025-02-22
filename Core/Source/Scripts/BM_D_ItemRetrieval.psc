;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname BM_D_ItemRetrieval Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
licenses.BM_ItemConfiscationChest.RemoveAllItems(ItemRetrievalActor, false, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Form[] ValidatedForms = licenses.bmlUtility.GetViolatingItemsAll(ItemRetrievalActor, false)
SPE_ObjectRef.RemoveItems(ItemRetrievalActor, ValidatedForms, licenses.BM_ItemConfiscationChest)
ItemRetrievalActor.ShowGiftMenu(false, none, true, false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

BM_Licenses Property licenses Auto
Actor Property ItemRetrievalActor Auto