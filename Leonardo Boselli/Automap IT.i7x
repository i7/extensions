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

[It's necessary to modify 'Automap' by Mark Tilford]
the check moving to room rule response (A) is "[regarding the player][maiuscolo][Sei][maiuscolo] già [inp the location].".
the carry out moving to room rule response (A) is "Da [qui] non [regarding the player][hai] idea di come andarci.".
the carry out moving to room rule response (B) is "([if heading is not up and heading is not down]verso [otherwise]andando[end if][heading])[command clarification break]".

	
Automap IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 4/140513 of Automap by Mark Tilford.