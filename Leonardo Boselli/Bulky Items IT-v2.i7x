Version 2 of Bulky Items IT by Leonardo Boselli begins here.

"Basato sull'espansione Version 2 of Bulky Items by Juhana Leinonen."

"Bulky items that can be carried only if the player is not carrying anything else."


Chapter Definitions

A thing can be bulky. A thing is usually not bulky.
A thing can be insubstantial. A thing is usually not insubstantial.

Definition: a thing is substantial if it is not insubstantial.


Chapter Taking bulky items

Before taking a bulky thing when the player is carrying something substantial and the player is not carrying the noun (this is the making room before taking a bulky item rule):
	say "(prima lasci [the list of substantial things carried by the player] per liberarti le mani)[command clarification break]";
	repeat with x running through substantial things carried by the player:
		silently try dropping x;
	continue the action.

Before taking something not bulky when the player is carrying a bulky thing (this is the dropping a bulky item before taking something else rule):
	say "(prima lasci [the random bulky thing carried by the player] per liberarti le mani)[command clarification break]";
	repeat with x running through substantial things carried by the player:
		silently try dropping x;
	continue the action.

Report taking a bulky thing (this is the bulky item taken rule):
	say "Hai sollevato [the noun]." instead.

Before of taking a bulky thing while multiple taking (this is the can't lift bulky things during take all rule):
	if the player is carrying a substantial thing:
		say "Le tue mani sono già impegnate.";
		stop the action;
	continue the action.

The can't lift bulky things during take all rule is listed first in the before rules.



Chapter Multiple taking

To decide whether multiple taking:
	if the player's command includes "tutto", decide yes;
	if the player's command includes "tutto", decide yes;
	decide no.

Does the player mean taking a bulky thing while multiple taking: it is very unlikely.



Bulky Items IT ends here.



---- DOCUMENTATION ----

Leggi la documentazione originale di Bulky Items di Juhana Leinonen.
