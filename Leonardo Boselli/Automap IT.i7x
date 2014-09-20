Version 4/140823 of Automap IT by Leonardo Boselli begins here.

"Translation in italian of Version 4/140513 of Automap by Mark Tilford. An extension to automatically draw a map."

Include Automap by Mark Tilford.

Section 1 - Global constants, Memory management, Kinds, and verbs

To report dynamic allocation conflict:
	say "[bracket]Il tuo interprete non supporta l[']allocazione dinamica, quindi l[']estensione 'Automap' non funzionerà.[close bracket][line break]";
	now current zoom is map absent;
		
Check zooming in: if there is no dynamic allocation conflict begin; now current zoom is map zoomed in; say "Zoom in!" instead; otherwise; report dynamic allocation conflict; end if.

Check zooming out:
	if there is no dynamic allocation conflict begin; now current zoom is map zoomed out; say "Zoom out!" instead; otherwise; report dynamic allocation conflict; end if.

Understand "nascondi mappa" as zooming away.  Check zooming away: now current zoom is map absent; say "Mappa nascosta." instead.

	
Section 5 - Hyperlink specific stuff (for use with Basic Hyperlinks by Emily Short)

Check hyperlink moving to room:
	if the noun is the location, say "[regarding the player][maiuscolo][Sei][maiuscolo] già [inp the location]." instead.
	
Check hyperlink moving to room:
	while the player is not in the noun:
		let heading be the best route from the location to the noun through visited rooms, using even locked doors;
		if heading is not a direction, say "Da [qui] non [regarding the player][hai] idea di come andarci." instead;
		let destination be the room heading from the location;
		say "(verso [heading])[command clarification break]";
		try going heading;
		if the player is not in the destination, rule fails.

	
Automap IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 4/140513 of Automap by Mark Tilford.