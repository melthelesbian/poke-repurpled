	object_const_def
	const_export LAVENDERSHRINE_CHANNELER1
	const_export LAVENDERSHRINE_CHANNELER2

LavenderShrine_Object:
	db $1 ; border block

	def_warp_events
	warp_event  4,  9, LAST_MAP, 7
	warp_event  5,  9, LAST_MAP, 7

	def_bg_events

	def_object_events
	object_event  4,  6, SPRITE_CHANNELER, WALK, ANY_DIR, TEXT_LAVENDERSHRINE_CHANNELER1
	object_event  5,  4, SPRITE_CHANNELER, STAY, LEFT, TEXT_LAVENDERSHRINE_CHANNELER2

	def_warps_to LAVENDER_SHRINE
