Remembering IT by Leonardo Boselli begins here.

"Rimpiazza 'Non puoi vedere nulla del genere' con un messaggio che ricorda al giocatore dove ha visto per l'ultima volta l'oggetto con cui vuole interagire. L'unica modifica è la traduzione."

"basato su Remembering by Aaron Reed."

Section - Inclusions

Include Italian by Leonardo Boselli.
Include Epistemology by Eric Eve.

Section - Grammar Line

Understand "esamina [any seen thing]" or "x [any seen thing]" or "guarda [any seen thing]" or "guarda [art-det] [any seen thing]" or "take [any seen thing]" or "take [art-det] [any seen thing]" or "lascia [any seen thing]" or "lascia [art-det] [any seen thing]" as remembering.

Section - The Remembering Action

Remembering is an action applying to one thing.

A procedural rule while remembering (this is the allow remembering faraway things rule): ignore the basic accessibility rule.

The remembering action has a room called the remembered spot.

Carry out remembering:
	if noun is a person:
		if there is a character of noun in Table of Remembered NPC Locations:
			change the remembered spot to the area corresponding to a character of noun in Table of Remembered NPC Locations;
	otherwise:
		change the remembered spot to location of noun.

Report remembering:     
	if the remembered spot is a room:
		say "[=> the noun]L[']ultima volta che [if the noun is plural-named]l[genderity] [otherwise]l['][end if]hai vist[genderity], [the noun] [was|were] [if remembered spot is location]proprio qui[otherwise][in-prep the remembered spot][end if].";
	otherwise:
		say "Non ricordi la posizione [di-prep the noun] al momento."

[Rule for printing the name of a room (called area) while remembering (this is the printing the name of a room while remembering rule): say "nel [printed name of the area]".]

[ Since we've used an "any" grammar token, we'll get the "That noun did not make sense in that context." message for any unrecognized word or not visible noun. Restore this to the normal behavior. Note: if your game features other uses of "any" tokens, you'll need to replace this rule. ]

Rule for printing a parser error when parser error is noun did not make sense in that context (this is the replace did not make sense in that context rule):
	say "Non puoi vedere nulla del genere."

Section - Avoiding Disambiguation

 [In practice, it doesn't really matter which of several unavailable items the player was referring to; it's quite annoying to be asked which one you meant and then told it isn't there anyway. Since the parser expects the next move after asking a disambiguation question to be a response, we silently perform an invisible action before returning control to the player.] 

Rule for asking which do you mean while remembering (this is the don't disambiguate while remembering rule):
	say "Non l[genderity] vedi più.";
	now skip-command is true.

skip-command is a truth state that varies.

Rule for reading a command when skip-command is true (this is the prevent remembering disambiguation problems rule):
	now skip-command is false;
	change the text of the player's command to "do#nothing".
	
Doing-nothing is an action out of world applying to nothing. Understand "do#nothing" as doing-nothing. Carry out doing-nothing: do nothing.  

Section - People and Animals

Definition: a person is nonplayer if it is not the player.

Every turn when at least one nonplayer person is visible (this is the note position of remembered people rule):
	repeat with chap running through visible nonplayer persons:
		if there is a character of chap in Table of Remembered NPC Locations:
			choose row with a character of chap in Table of Remembered NPC Locations;
			change area entry to location;
		otherwise:
			if the number of blank rows in Table of Remembered NPC Locations is at least 1:
				choose a blank row in Table of Remembered NPC Locations;
				change character entry to chap;
				change area entry to location.

Table of Remembered NPC Locations
character	area
a person		a room
with 20 blank rows.

Remembering IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Remembering bu Aaron Reed.