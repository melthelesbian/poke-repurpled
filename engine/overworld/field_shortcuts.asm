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
	call EnableShortcutText
	ld hl, TextNoBike ; if no bike
	call PrintText
	jr .cleanUp
.hasBike
	call EnableShortcutText
	call UseItem
.cleanUp
	call CloseShortcutText
	ret

TextNoBike:
	text "<PLAYER> doesn't"
	line "havea BICYCLE."
	done

TryFishingRod::
    ld a, FISHING_ROD
    ld [wCurItem], a
	ld [wPseudoItemID], a
	ld [wd11e], a ; store item ID for GetItemName
	call GetItemName
	call CopyToStringBuffer ; copy name to wStringBuffer
.tryForRod
	ld b, FISHING_ROD
	call IsItemInBag
	jr nz, .hasRod
	ret
.hasRod
	call EnableShortcutText
	call UseItem
	call CloseShortcutText
    ld a, 1
    and a ; non-zero
	ret

EnableShortcutText: ; Gets everything setup to let you display text properly
	call DisableAutoTextBoxDrawing
	ld a, 1 ; not 0
	ld [hSpriteIndexOrTextID], a
	farcall DisplayTextIDInit
	jp EnableAutoTextBoxDrawing

CloseShortcutText: ; Closes the text out properly to prevent glitches
	ldh a, [hLoadedROMBank]
	push af
	jp CloseTextDisplay
