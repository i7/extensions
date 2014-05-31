Version 4/140530 of Hiding Under IT by Leonardo Boselli begins here.

"Translation in italian of Version 4 of Hiding Under by Eric Eve.

Allows things to be hidden under other things, using a many-to-one underconcealment relation. Can be used either standalone (with basic functionality) or in conjunction with Underside (to add fuller functionality to both extensions). Version 3 of Hiding Under avoids using phrases deprecated in Version 6E59 of Inform."

Include Hiding Under by Eric Eve.

Part 2 - Phrases

To say find-hidden-under (obj - a thing):
  say  "Sotto [the obj] [regarding the player][trovi] [a list of things hidden under the obj]."

Part 4 - Standalone Material (for use without Underside by Eric Eve)

Chapter 1 - Action Definition for Putting Under

Understand "metti [things preferably held] sotto [something]" as placing it under.
Understand "metti il/lo/la/i/gli/le/l [things preferably held] sotto il/lo/la/i/gli/le/l/al/allo/alla/ai/agli/alle/all [something]" as placing it under.

standard can't put under rule response (A) is "Non [regarding the player][puoi] mettere nulla sotto [ap the second noun]."

Part 5 - Common Grammar

Understand "nascondi [things preferably held] sotto [something]" as placing it under.
Understand "nascondi il/lo/la/i/gli/le/l [things preferably held] sotto il/lo/la/i/gli/le/l/al/allo/alla/ai/agli/alle/all [something]" as placing it under.


Part 6 - Taking something that hides something underneath

Chapter 1 - Common Material

To say previously-hidden-under (obj - a thing):
	let hidden-list be the list of things hidden under the obj;
	let hidden-gender be 1; [0: male, 1: female]
	let hidden-number be 0; [0: singular, 1: plural]
	repeat with hidden-obj running through the hidden-list:
		if hidden-obj is not feminine gender:
			now hidden-gender is 0;
		if hidden-obj is plural-named:
			now hidden-number is 1;
	if the number of entries in the hidden-list is 1 and the hidden-number is 0:
		say "nascost[if hidden-gender is 0]o[otherwise]a[end if] sotto";
	otherwise:
		say "nascost[if hidden-gender is 0]i[otherwise]e[end if] sotto";

To say reveal-hidden-under (obj - a thing):
	say "[regarding the player][maiuscolo][Hai][maiuscolo] preso [the noun] scoprendo [a list of things hidden under the noun] [previously-hidden-under the noun].";


Hiding Under IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 4 of Hiding Under by Eric Eve.
