Version 2.0.220521 of Verb Stripping by Nathanael Nerode begins here.

"Removes a number of verbs from the standard rules; verbs which might cause confusion in a game whose theme is not adventure."

Section - Bad Synonyms

Understand the command "hold" as something new.
Understand the commands "pay" and "offer" and "feed" as something new.
Understand the commands "describe" and "check" as something new.

Section - Talking to the parser

Understand the command "yes" as something new.
Understand the command "y" as something new.
Understand the command "no" as something new.
Understand the command "sorry" as something new.

Section - Gesticulation

Understand the command "wave" as something new.
Understand the command "adjust" as something new.
Understand the command "pull" as something new.
Understand the command "drag" as something new.
Understand the command "push" as something new.
Understand the commands "move", "shift", "clear", and "press" as something new.
Understand the command "turn" as something new.
Understand the command "rotate", "twist", "unscrew", and "screw" as something new.
Understand the command "switch" as something new.

Section - Combat

Understand the command "attack" as something new.
Understand the commands "break", "smash", "hit", "fight", "torture", "wreck", "crack", "destroy", "murder", "kill", "punch" and "thump" as something new.

Section - Random Verbs

Understand the command "shout" as something new.
Understand the command "climb" as something new.
Understand the command "scale" as something new.
Understand the command "buy" as something new.
Understand the command "purchase" as something new.
Understand the command "squeeze" as something new.
Understand the command "squash" as something new.
Understand the command "swing" as something new.

Section - Intimacy

Understand the command "kiss" as something new.
Understand the commands "embrace" and "hug" as something new.

Section - Rubbing

Understand the command "rub" as something new.
Understand the commands "shine", "polish", "sweep", "clean", "dust", "wipe" and "scrub" as something new.

Section - More random verbs

Understand the command "tie" as something new.
Understand the commands "attach" and "fasten" as something new.
Understand the command "burn" as something new.
Understand the command "light" as something new.
Understand the commands "swallow" and "sip" as something new.
Understand the command "cut" as something new.
Understand the commands "slice", "prune", and "chop" as something new.
Understand the command "jump" as something new.
Understand the commands "skip" and "hop" as something new.

Verb Stripping ends here.

---- DOCUMENTATION ----

If you're writing an adventure game, you won't want this.  This is for games with very different themes, specifically social themes.

This extension removes a lot of the verb synonyms from the standard rules, so that (for example) "dust object" is no longer a synonym for "rub object".  This is to avoid misleading reactions.

It also removes most of the verb words which just have minimal stub implementations (like jump, cut, and attach).

It removes the unimplemented kiss and embrace and hug, which in a social game should probably not be synonyms.
Likewise it removes attack and all its synonyms.

It also removes "push", which actually is implemented for shoving objects from room to room.  This is probably not the most intuitive meaning of "push" in a socially oriented game.

The selection of which verbs to leave was somewhat arbitrary, based on the game I was working on at the time.

Changelog:

	2.0.220521: Version for Inform v10 (after a version number snafu)
	1/171007: Version for Inform 6M62
