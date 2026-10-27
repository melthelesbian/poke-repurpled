CeladonLab_Script:
	jp EnableAutoTextBoxDrawing

CeladonLab_TextPointers:
	def_text_pointers
	dw_const CeladonLabFossilScientistText, TEXT_CELADONLAB_FOSSIL_SCIENTIST
	dw_const CeladonLabResearchScientistText, TEXT_CELADONLAB_RESEARCH_SCIENTIST
	dw_const CeladonLabTypeScientistText, TEXT_CELADONLAB_TYPE_SCIENTIST
	dw_const CeladonLabStudentText, TEXT_CELADONLAB_STUDENT

CeladonLabResearchScientistText:
	text "I'm doing cutting-"
	line "edge research!"

	para "Unfortunately, I"
	line "can't tell you"
	cont "about it."
	done

CeladonLabTypeScientistText:
	text "I study #MON"
	line "types!"

	para "The discovery of"
	line "STEEL, FAIRY and"
	cont "DARK types took"
	cont "us by surprise!"
	done

CeladonLabStudentText:
	text "I'm just a student"
	line "visiting the lab!"

	para "I would love to"
	line "work here someday"
	cont "but I still have"
	cont "a lot to learn."
	done

CeladonLabFossilScientistText:
	text_asm
	CheckEvent EVENT_GAVE_FOSSIL_TO_CELADON_LAB
	jr nz, .check_done_reviving
	ld hl, .Text
	call PrintText
	call CeladonLab_GetFossilsInBag
	ld a, [wFilteredBagItemsCount]
	and a
	jr z, .no_fossils
	farcall GiveFossilToCeladonLab
	jr .done
.no_fossils
	ld hl, .NoFossilsText
	call PrintText
.done
	jp TextScriptEnd
.check_done_reviving
	CheckEventAfterBranchReuseA EVENT_CELADON_LAB_STILL_REVIVING_FOSSIL, EVENT_GAVE_FOSSIL_TO_CELADON_LAB
	jr z, .done_reviving
	ld hl, .GoForAWalkText
	call PrintText
	jr .done
.done_reviving
	farcall LoadCeladonLabFossilItemAndMonName
	ld hl, .FossilIsBackToLifeText
	call PrintText
	SetEvent EVENT_CELADON_LAB_HANDING_OVER_FOSSIL_MON
	ld a, [wCeladonLabFossilMon]
	ld b, a
	ld c, 5
	call GivePokemon
	jr nc, .done
	ResetEvents EVENT_GAVE_FOSSIL_TO_CELADON_LAB, EVENT_CELADON_LAB_STILL_REVIVING_FOSSIL, EVENT_CELADON_LAB_HANDING_OVER_FOSSIL_MON
	jr .done

.Text:
	text_far _CeladonLabFossilScientistText
	text_end

.NoFossilsText:
	text_far _CeladonLabFossilScientistNoFossilsText
	text_end

.GoForAWalkText:
	text_far _CeladonLabFossilScientistGoForAWalkText
	text_end

.FossilIsBackToLifeText:
	text_far _CeladonLabFossilScientistFossilIsBackToLifeText
	text_end

CeladonLab_GetFossilsInBag:
; Build a list of fossils and Ancient Hair in the player's bag.
	xor a
	ld [wFilteredBagItemsCount], a
	ld de, wFilteredBagItems
	ld hl, .FossilsList
.loop
	ld a, [hli]
	and a
	jr z, .done
	push hl
	push de
	ld [wd11e], a
	ld b, a
	predef GetQuantityOfItemInBag
	pop de
	pop hl
	ld a, b
	and a
	jr z, .loop
	ld a, [wd11e]
	ld [de], a
	inc de
	push hl
	ld hl, wFilteredBagItemsCount
	inc [hl]
	pop hl
	jr .loop
.done
	ld a, $ff
	ld [de], a
	ret

.FossilsList:
	db DOME_FOSSIL
	db HELIX_FOSSIL
	db OLD_AMBER
	db 0 ; end
