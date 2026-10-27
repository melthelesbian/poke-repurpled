	object_const_def
	const_export ROUTE7HOUSE_TRADE_GIRL

Route7House_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 6
	warp_event  3,  7, LAST_MAP, 6

	def_bg_events

	def_object_events
	object_event  5,  4, SPRITE_GIRL, STAY, LEFT, TEXT_ROUTE7HOUSE_TRADE_GIRL

	def_warps_to ROUTE_7_HOUSE
