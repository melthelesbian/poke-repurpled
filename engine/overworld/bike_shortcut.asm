TryRideBike::
	xor a
.setUp
	ld a, BICYCLE
	ld [wCurItem], a
	ld [wPseudoItemID], a
	ld [wd11e], a ; store item ID for GetItemName
	call GetItemName
	call CopyToStringBuffer ; copy name to wStringBuffer
.tryForBike
	ld b, BICYCLE
	call IsItemInBag
	jr nz, .hasBike
	call EnableBikeShortcutText
	ld hl, TextNoBike ; if no bike
	call PrintText
	jr .cleanUp
.hasBike
	call EnableBikeShortcutText
	call UseItem
.cleanUp
	call CloseBikeShortcutText
	ret

TextNoBike:
	text "<PLAYER> doesn't"
	line "havea BICYCLE."
	done

EnableBikeShortcutText: ; Gets everything setup to let you display text properly
	call DisableAutoTextBoxDrawing
	ld a, 1 ; not 0
	ld [hSpriteIndexOrTextID], a
	farcall DisplayTextIDInit
	jp EnableAutoTextBoxDrawing

CloseBikeShortcutText: ; Closes the text out properly to prevent glitches
	ldh a, [hLoadedROMBank]
	push af
	jp CloseTextDisplay
