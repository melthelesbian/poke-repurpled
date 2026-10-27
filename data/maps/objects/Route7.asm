Route7_Object:
	db $f ; border block

	def_warp_events
	warp_event 38,  9, ROUTE_7_GATE, 3
	warp_event 38, 10, ROUTE_7_GATE, 4
	warp_event 31,  9, ROUTE_7_GATE, 1
	warp_event 31, 10, ROUTE_7_GATE, 2
	warp_event  5, 13, UNDERGROUND_PATH_ROUTE_7, 1
	warp_event 23,  9, ROUTE_7_HOUSE, 1

	def_bg_events
	bg_event  3, 13, TEXT_ROUTE7_UNDERGROUND_PATH_SIGN
	bg_event 25, 11, TEXT_ROUTE7_HOUSE_SIGN

	def_object_events

	def_warps_to ROUTE_7
