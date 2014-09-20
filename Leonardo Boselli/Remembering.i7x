Version 9/140430 of Remembering by Leonardo Boselli begins here.

"Just copied from Version 9/140430 of Remembering by Aaron Reed with 'Include Epistemology' removed (because of incompatibilities with 'Conversation Package'). Replaces 'You can't see any such thing' for a seen but out-of-scope noun with a message acknowledging that the parser recognizes the object. With Glulx, also keeps track of where the player last saw that object."

[Changelog:
 -- Version 9: Updated for latest build and made adaptive. 
 -- Version 8: Made reporting remembered locations into an activity.
 -- Version 7: updated rule names to be consistent
 -- Version 6: Added second example; Updated for Player Experience Upgrade compatibility; altered disambiguation rejection message to be more helpful; updated the default reference to a prior location to stop pretending it can generate natural-sounding English with the wide variety of possible room names; removed broken code trying to skip a disambiguation question. 
 -- Version 5: Included all grammar lines for examine, get, and drop. Understand "look for" or "find" something.
 -- Version 4: Updated to use no deprecated features
 -- Version 3: Updated for build 6859

]

Chapter - Compatibility

Section - Inclusions

[Include Version 6 of Epistemology by Eric Eve.] [*LEO* REMOVED as explained above]

Section - Parser Speak (for use without Keyword Interface by Aaron Reed)

To say as the parser: do nothing. To say as normal: do nothing.


Chapter - Remembering Main

Section - Grammar Line

[Future: any way to make this work for any reference to an object?]

Understand
"examine [any seen thing]" or
"x [any seen thing]" or
"[any seen thing]" or  [*LEO* added]
"look at/for [any seen thing]" or
"take [any seen thing]" or
"get [any seen thing]" or
"pick up [any seen thing]" or
"pick [any seen thing] up" or
"drop [any seen thing]" or
"put down [any seen thing]" or
"put [any seen thing] down" or
"drop [any seen thing] away" or
"drop away [any seen thing]" or
"find [any seen thing]" or
"where is/are [any seen thing]" as remembering.

Section - The Remembering Action

Remembering is an action applying to one thing.

The allow remembering faraway things rule is listed instead of the basic accessibility rule in the action-processing rules.

This is the allow remembering faraway things rule:
	unless remembering, abide by the basic accessibility rule.

Report remembering (this is the Remembering generic report remembering rule): say "[as the parser][We] [can't see] [the noun] any more.[as normal][line break]" (A).

Chapter - Fixes

Section - Fix in this context message

[ Since we've used an "any" grammar token, we'll get the "That noun did not make sense in that context." message for any unrecognized word or not visible noun. Restore this to the normal behavior. Note: if your game features other uses of "any" tokens, you'll need to replace this rule. ]

Rule for printing a parser error when the latest parser error is the noun did not make sense in that context error (this is the Remembering replace did not make sense in that context rule):
	now the latest parser error is the can't see any such thing error;
	make no decision.

Section - Avoiding Disambiguation

 [In practice, it doesn't really matter which of several unavailable items the player was referring to; it's quite annoying to be asked which one you meant and then told it isn't there anyway. Unfortunately, there's no easy way to bypass the disambiguation process since it's hard-coded into the Inform 6 templates. Here we do a trick, simply printing a refusal message instead of the disambiguation question. This mostly works, EXCEPT if the player tries to type a direction word: since directions aren't understood as verbs, the parser tries to insert the command into the misunderstood line, leading to "You can't see any such thing."]

Rule for asking which do you mean while remembering (this is the Remembering don't disambiguate while remembering rule): say "[as the parser]That's not something [we] [can see].[as normal][line break]" (A).

Chapter - Keeping Track (for Glulx only)

Section - The Remembered Location

Every thing has an object called the remembered location. The remembered location of a thing is usually nothing.

Section - Rules

Last when play begins (this is the Remembering update remembered positions for first turn rule):
	follow the Remembering update remembered positions of things rule.

Every turn (this is the Remembering update remembered positions of things rule):
	unless in darkness:
		repeat with item running through things that are enclosed by the location:
			if remembered location of item is not holder of item:
				if item is visible:
					now the remembered location of item is the holder of item.

First report remembering (this is the Remembering specific report remembering rule):
	if remembered location of noun is nothing, continue the action;
	say "[as the parser]The last time [we] [saw] [the noun], [they] [was-were of noun] [in the remembered location of noun].[as normal][line break]" (A);
	stop the action. 

To decide whether (item - an object) acts plural: 
	if the item is plural-named or the item is ambiguously plural:
		yes;
	no.

To say saw:
	if the story tense is future tense:
		say "will have seen";
	else:
		say "saw".

To say was-were of (N - an object):
	if the story tense is future tense:
		say "will have been";
	otherwise if N acts plural:
		say "were";
	otherwise:
		say "was".

To say in the (place - an object):
	carry out the saying the location name activity with place.
		

Section - The Activity
	
saying the location name of something is an activity on objects.

For saying the location name of a room (called place) (this is the Remembering saying room name rule): say "in [the place]" (A).

For saying the location name of the location (this is the Remembering saying current location name rule): say "right here" (A).

For saying the location name of a person (called subject) (this is the Remembering saying person name rule): say "in the possession of [the subject]" (A).

[***]
Definition: a person is is-player if it is the player.
For saying the location name of an is-player person (this is the Remembering saying player name rule): say "in your possession" (A).
[***For saying the location name of a person who is the player (this is the Remembering saying player name rule): say "in your possession" (A).]

For saying the location name of a container (called the holder) (this is the Remembering saying container name rule): say "in [the holder]" (A).

For saying the location name of a supporter (called the holder) (this is the Remembering saying supporter name rule): say "on [the holder]" (A).


Remembering ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 9/140430 of Remembering by Aaron Reed.