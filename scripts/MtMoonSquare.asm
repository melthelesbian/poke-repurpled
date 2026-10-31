MtMoonSquare_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonSquareTrainerHeaders
	ld de, MtMoonSquare_ScriptPointers
	ld a, [wMtMoonSquareCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonSquareCurScript], a
	ret

MtMoonSquare_ScriptPointers:
	def_script_pointers
	dw_const MtMoonSquareDefaultScript,            SCRIPT_MTMOONSQUARE_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_MTMOONSQUARE_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_MTMOONSQUARE_END_BATTLE

MtMoonSquareDefaultScript:
	ret

MtMoonSquare_TextPointers:
	def_text_pointers
	dw_const MtMoonSquareLunaText,         TEXT_MTMOONSQUARE_LUNA
	dw_const MtMoonSquareGiftShopSignText, TEXT_MTMOONSQUARE_GIFT_SHOP_SIGN

MtMoonSquareTrainerHeaders:
	def_trainers
MtMoonSquareLunaTrainerHeader:
	trainer EVENT_BEAT_MT_MOON_SQUARE_LUNA, 0, MtMoonSquareLunaBattleText, MtMoonSquareLunaEndBattleText, MtMoonSquareLunaAfterBattleText
	db -1 ; end

MtMoonSquareLunaText:
	text_asm
	ld hl, MtMoonSquareLunaTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

MtMoonSquareLunaBattleText:
	text "LUNA: The #MON"
	line "here are so cute!"

	para "I wish my favorite"
	line "were here though."
	done

MtMoonSquareLunaEndBattleText:
	text "Oops."
	line "Cute #MON are"
	cont "tough, but you're"
	cont "tougher."
	prompt

MtMoonSquareLunaAfterBattleText:
	text "LUNA: Do you know"
	line "where I can find"
	cont "a ZIGZAGOON?"
	done

MtMoonSquareGiftShopSignText:
	text "MT. MOON SQUARE"
	line "GIFT SHOP"
	done
