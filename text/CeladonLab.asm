_CeladonLabFossilScientistText::
	text "Welcome!"

	para "I am a researcher,"
	line "we revive rare"
	cont "#MON fossils!"

	para "Do you have a"
	line "fossil for me?"
	prompt

_CeladonLabFossilScientistNoFossilsText::
	text "No? That's too"
	line "bad."
	done

_CeladonLabFossilScientistGoForAWalkText::
	text "It takes a bit of"
	line "time!"

	para "Go walk for a"
	line "little while!"
	done

_CeladonLabFossilScientistFossilIsBackToLifeText::
	text "Welcome back, your"
	line "fossil is ready!"

	para "The @ "
	text_ram wStringBuffer
	text_start
	line "was revived!"

	para "How incredible!"
	prompt

_CeladonLabFossilScientistSeesFossilText::
	text "Oh! That is"
	line "@"
	text_ram wNameBuffer
	text "!"

	para "It's a fossil of"
	line "@"
	text_ram wStringBuffer
	text "!"

	para "Our Resurrection"
	line "Machine will make"
	cont "that #MON live"
	cont "again!"
	done

_CeladonLabFossilScientistTakesFossilText::
	text "<PLAYER> handed"
	line "over @"
	text_ram wNameBuffer
	text "!"
	prompt

_CeladonLabFossilScientistComeAgainText::
	text "Please come back"
	line "again soon!"
	done
