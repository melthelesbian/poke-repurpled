	object_const_def
	const_export CELADONLAB_FOSSIL_SCIENTIST
	const_export CELADONLAB_RESEARCH_SCIENTIST
	const_export CELADONLAB_TYPE_SCIENTIST
	const_export CELADONLAB_STUDENT

CeladonLab_Object:
	db $17 ; border block

	def_warp_events
	warp_event  4,  7, LAST_MAP, 9
	warp_event  5,  7, LAST_MAP, 9

	def_bg_events

	def_object_events
	object_event 12,  1, SPRITE_SILPH_WORKER_F, STAY, DOWN, TEXT_CELADONLAB_FOSSIL_SCIENTIST
	object_event 11,  7, SPRITE_SCIENTIST, STAY, UP, TEXT_CELADONLAB_RESEARCH_SCIENTIST
	object_event 13,  4, SPRITE_GIRL, STAY, DOWN, TEXT_CELADONLAB_TYPE_SCIENTIST
	object_event  8,  5, SPRITE_BRUNETTE_GIRL, WALK, ANY_DIR, TEXT_CELADONLAB_STUDENT

	def_warps_to CELADON_LAB
