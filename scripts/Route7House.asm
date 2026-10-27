Route7House_Script:
	jp EnableAutoTextBoxDrawing

Route7House_TextPointers:
	def_text_pointers
	dw_const Route7HouseTradeGirlText, TEXT_ROUTE7HOUSE_TRADE_GIRL

Route7HouseTradeGirlText:
	text_asm
	ld a, TRADE_FOR_DRIPPY
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
