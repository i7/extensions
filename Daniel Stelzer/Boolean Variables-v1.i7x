Version 1 of Boolean Variables by Daniel Stelzer begins here.

A boolean option is a kind of thing. A boolean option can be active or inactive. A boolean option is usually inactive.

Boolean toggling is an action out of world applying to one visible thing. Understand "[any boolean option]" as boolean toggling.
Carry out boolean toggling:
	if the noun is active, now the noun is inactive;
	otherwise now the noun is active.
Report boolean toggling: say "[Noun in sentence case] [if the noun is active]on[otherwise]off[end if]."

Boolean truth setting is an action out of world applying to one visible thing. Understand "[any boolean option] on" as boolean truth setting.
Carry out boolean truth setting: now the noun is active.
Report boolean truth setting: say "[Noun in sentence case] on."

Boolean falsehood setting is an action out of world applying to one visible thing. Understand "[any boolean option] off" as boolean falsehood setting.
Carry out boolean falsehood setting: now the noun is inactive.
Report boolean falsehood setting: say "[Noun in sentence case] off."

Listing boolean options is an action out of world applying to nothing. Understand "options" as listing boolean options.
Carry out listing boolean options:
	say fixed letter spacing;
	repeat with the item running through boolean options:
		say "[if the item is active]*[otherwise] [end if] [Item in sentence case][line break]";
	say variable letter spacing.

To say (X - boolean option) in sentence case:
	say "[X]" in sentence case.

Rule for deciding whether all includes a boolean option: it does not. [Don't allow ALL to toggle all variables.]

Boolean Variables ends here.
