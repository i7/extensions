Version 5 of Recorded Endings (for Glulx only) by Emily Short begins here.

"Records the endings the player encounters in multiple play-throughs to an external file; then adds an ENDINGS option to the final question to allow the player to review which endings he has seen so far."

[The File of Conclusions is called "conclusions". ]

When play begins (this is the load conclusions when starting rule):
	read the endings.

Last carry out restoring the game (this is the load conclusions when restoring rule):
	read the endings.

To read the endings:
	if the File of Conclusions exists:
		read File of Conclusions into the Table of Possible Endings.
	
To record (slug - some text) as an ending:
	read the endings; 
	let N be "[slug]";
	unless N is a description listed in the Table of Possible Endings:
		choose a blank row in the Table of Possible Endings;
		now the description entry is N;
	write File of Conclusions from the Table of Possible Endings.

Table of Possible Endings
description (indexed text)
indexed text
with 20 blank rows.	 

Table of Final Question Options (continued)
final question wording	only if victorious	topic	final response rule	final response activity
"review the ENDINGS you've seen so far"	false	"review/endings"	list endings rule	--

This is the list endings rule:
	read the endings;
	say "The endings you have encountered so far include: [paragraph break]";
	repeat through the Table of Possible Endings:
		say "  [description entry][line break]".

To decide whether (chosen ending - some text) is a used ending:  
	let N be "[chosen ending]"; 
	if N is a description listed in the Table of Possible Endings: 
		yes; 
	no. 

Recorded Endings ends here.

---- DOCUMENTATION ----

Recorded Endings is intended for use with Glulx works that can end in multiple ways. It records short text descriptions of the various endings to an external file, then allows the player an ENDINGS option when the game is over, so that he can review all of the endings he has encountered so far whether in this playthrough or in an earlier one.

To use Recorded Endings, we need only to:

1) include a line naming the file in which conclusions will be written, thus:

	The File of Conclusions is called "recconclusions". 

Everything about this line should be exactly as written *except* the name within the quotation marks, which should be something that the game author chooses.

Originally Recorded Endings declared this file itself, but the result is that if one game is played in the same directory as another that also uses Recorded Endings, the identical file names will cause bugs in whichever game is played second. Therefore we should pick a name that will be unique to this particular game, perhaps using the initials of the title or the game author in some way.

It does not matter whether the File of Conclusions is named before or after the "Include Recorded Endings" line is added.

2) tell the game what to record before each ending. So for instance if we have a sequence leading to death, we might write
	
	record "Martyrdom among the lions" as an ending;
	end the game in death.

Or again we might write

	record "Abduction by aliens" as an ending;
	end the game saying "You spend the rest of your life orbiting Alpha Centauri".

By default, Recorded Endings offers the player the ENDINGS option regardless of whether the game ended in victory. If we wish to change this so that the ENDINGS are shown only after "end the game in victory", then we might write

	When play begins:
		choose a row with a final response rule of list endings rule in the Table of Final Question Options;
		change the only if victorious entry to true.

If there are more than twenty possible endings in the game, we may need to extend the table that records them, the Table of Possible Endings. To do this, we might write

	Table of Possible Endings (continued)
	description
	--
	with 10 blank rows.

(This will actually append a total of 11 rows to the table, but that -- entry cannot be omitted or Inform will become confused about appending more blank rows to the table.)

Finally, we may want elsewhere in the game to find out whether the player has already experienced a specific ending. (Perhaps the game subtly changes descriptions after multiple playings.) For this case, we would write

	if "Turning into a pumpkin" is a used ending: ...

where "Turning into a pumpkin" is the exact text that we record when that ending occurs.

Example: * Reincarnation - We have a vial of poison that the player recognizes only on the second playthrough.

	*: "Reincarnation"
	
	Include Recorded Endings by Emily Short.

	The File of Conclusions is called "examplecon".

	The Cloudy Chamber is a room. It contains a wooden table. On the wooden table is a vial.

	The description of the vial is "It is full of a delicious-looking golden liquid."

	Instead of smelling the vial: 
		say "It smells like honey wine."

	Rule for printing the name of the vial when "Death by poison" is a used ending:
		say "vial of poison".
		
	Understand "poison" or "of poison" as the vial when "Death by poison" is a used ending.

	Instead of drinking the vial:
		if "Death by poison" is a used ending:
			say "A chill comes over you as you consider it, as though you were being warned by a previous incarnation from another lifetime: this is foul poison.";
		otherwise:
			say "You lift the vial to your lips and throw it back. The flavor is sweet on your tongue, but the effects are nearly instant...";
			record "Death by poison" as an ending;
			end the story saying "You have died by poison".
