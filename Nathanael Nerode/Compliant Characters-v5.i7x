Version 5.1.230727 of Compliant Characters by Nathanael Nerode begins here.

"Report parsing errors to the player when ordering other characters to do things.  Inform 7 normally redirects these errors to 'answer <topic>' so that the character can respond to arbitrary statements.  But in an story with compliant characters who the player orders around routinely, that is frustrating to a player who has made a typo; this helps out the player.  Requires version 5 of Neutral Standard Responses.  Tested with Inform 10.1.0."

Include Neutral Standard Responses by Nathanael Nerode.  [This includes most of our callbacks into Inform 6, among other things]

Volume - Parser Errors

[
Problematically, "Jane, take hat" will fail if "hat" isn't recognized.  We want to make it clear what went wrong.

"Check an actor answering something that" usually happens in case of a parser error.
There's always a latest parser error and it's from the most recent command.

Unfortunately, per default, 'answer "blah blah blah" to Jane' triggers "answering it that", bypasses the command parser, and leaves the error set to STUCK_PE.  This is addressed in a later Volume of this extension.

It's passed through the new "ordering it that" action, which reparses it into an order.

A new patch added to Inform 7 v10 on May 23, 2022 provides us with the necessary hook to give us
"wn" (as "the extraneous word", used in Neutral Standard Responses) to allow proper parsing of errors
from commands like JOHN, TAKE BAG SDFSDFS.
]

Section - Debug Parser Errors For Commands (not for release)

[This is too useful not to have it in place, but should never be in a published game.]

The debug parser errors for commands to actors rule is listed first in the check answering it that rulebook. [ But normally does nothing ]

Check an actor answering something (called the commandee) that (this is the debug parser errors for commands to actors rule):
	If the parser error debugging option is active:
		say "- saved_oops [the misunderstood word] - oops_from [the other misunderstood word] - wn [the extraneous word] -";
	continue the action;

Section - Order of Parser Error Printing Rules

[By default we want these errors to come last.  Any earlier check rule written by the author can have "success" and authorize the otherwise-parser-error command.]
The print nothing to do error for commands to actors rule is listed last in the check answering it that rulebook.
The command to actor includes word not in scope rule is listed last in the check answering it that rulebook.
The command to actor includes word not in dictionary rule is listed last in the check answering it that rulebook.
The print parser errors for commands to actors rule is listed last in the check answering it that rulebook. [The last one likely to trigger]

[These two should never trigger, so we put them even further last]
The command to actor can't see any such thing fallback rule is listed last in the check answering it that rulebook. 
The print referred to a determination of scope error for commands to actors rule is listed last in the check answering it that rulebook.

Section - You can't see any such thing

[CANTSEE_PE]

[It's a bit silly to check whether the misunderstood word is in the dictionary twice, in two rules, but it's cheap code so we do this the "clean" way.]

Check an actor answering something (called the commandee) that when the latest parser error is the can't see any such thing error and the misunderstood word is in the dictionary (this is the command to actor includes word not in scope rule):
	say "[The commandee] [can't] see anything called '[the misunderstood word]' right [now].  [as the parser]Or I misunderstood you.[no line break][as normal][line break]" (A);
	restore the oops target;
	rule fails;

Check an actor answering something (called the commandee) that when the latest parser error is the can't see any such thing error and the misunderstood word is not in the dictionary (this is the command to actor includes word not in dictionary rule):
	if the misunderstood word is out of range:
		continue the action;
	say "[as the parser]You don't need to use the word '[the misunderstood word]' in this story.[as normal][line break]" (A);
	restore the oops target;
	rule fails;

[This shouldn't ever happen; fallback rule.  We would hit this if saved_oops was out of range, but this shouldn't happen with a CANTSEE_PE error.]

Check an actor answering something (called the commandee) that when the latest parser error is the can't see any such thing error and the misunderstood word is out of range (this is the command to actor can't see any such thing fallback rule):
	say "[The commandee] [can't] see any such thing." (A);
	rule fails;

Section - Command clarification error failthrough

[This will not normally be triggered: The parser will correctly spawn a command clarification question for this.  This is the backup in case something funny happens and command clarification doesn't happen.]

Check an actor answering something (called the commandee) that when the latest parser error is the referred to a determination of scope error (this is the print referred to a determination of scope error for commands to actors rule): [ASKSCOPE_PE]
	[This is swapped with NOTINCONTEXT_PE in the Standard Rules -- a large bug]
	say "[as the parser][The commandee] [can't] tell what [the player] [are] referring to.[as normal][line break]" (Y);
	rule fails.

Section - Nothing to do error 

[
TODO: There's some screwy complicated code in the standard parser which special-cases nothing responding to ##Remove actions.
Unfortunately, by the time we get here, the parser has trashed the real action name.
So we can't do that clever stuff.  Have to default to the non-remove messages.  (Test to see whether the Remove errors are triggered.)

In addition, for non-##Remove, the parser gave the "Nothing to do" response if multi_wanted==100.
This is... bizarre, and almost certainly an programming mistake, as it only triggers on "get 100 items", which is clearly wrong.

This leaves only one message.  It's "B" to match up with the parser error nothing rule responses, and it triggers on "get 4 items" or "get all items" (and now on get 100 items too).
]
Check an actor answering something (called the commandee) that when the latest parser error is the nothing to do error (this is the print nothing to do error for commands to actors rule): [NOTHING_PE]
	say "[as the parser][if command includes except]That excludes everything available to [the commandee].[otherwise]There is nothing available for [the commandee] to [the quoted verb].[end if][as normal][line break]" (B);
	rule fails.

Section - Parser Errors with simple implementation

[
This is the main error handling routine for printing parser errors for commands to actors.
Query whether we should run the 'printing a parser error' activity here.  We choose not to.  The story author can intercept the "answering it that" action before this in order to achieve the same effect.
The error letters are matched up strictly with parser internal error rule response letters, largely for maintenance reasons.
The really nasty bit here is line breaking.  The standard parser errors throw in a line break, and this *doesn't*, so we can't reuse the same texts.
]
Check an actor answering something (called the commandee) that (this is the print parser errors for commands to actors rule):
	if the latest parser error is:
		-- didn't understand error: [STUCK_PE]
			[In Standard Rules, this will be the case when, and only when, the player actually typed 'say "blah" to Jane' (including 'speak/answer/shout').]
			[We redirect this in a later volume, so it should never trigger: should be dead code.]
			[Code is left in in case the later volume is overriden by a game writer for their own reasons.]
			say "[as the parser]I didn't understand that order, though I thought it was an instruction addressed to [the commandee].[as normal][line break]" (A);
			set the oops target to the verb;
		-- only understood as far as error: [UPTO_PE]
			say "[as the parser]I can't understand your entire instruction to [the commandee].  The first part looked like the command '[the command understood so far]', but I didn't expect the word '[the extraneous word]' next.[as normal][line break]" (B);
		-- didn't understand that number error: [NUMBER_PE]
			say "[as the parser]I can't understand your entire instruction to [the commandee].  The first part looked like the command '[the command understood so far]', which I expected to include a number, but I didn't expect the word '[the extraneous word]' next.[as normal][line break]" (D);
[		-- can't see any such thing error: ] [CANTSEE_PE -- complex, break out into its own rule]
[		-- said too little error: ] [TOOLIT_PE -- should never trigger, dead code in I6T & Standard Rules ]
[			say "[text of the parser error internal rule response (F)]" (F); ]
		-- aren't holding that error: [NOTHELD_PE]
			say "[The commandee] [aren't] holding that." (G);
			restore the oops target;
		-- can't use multiple objects error: [MULTI_PE]
			say "[text of the parser error internal rule response (H)][line break]" (H);
		-- can only use multiple objects error: [MMULTI_PE]
			say "[text of the parser error internal rule response (I)][line break]" (I);
		-- not sure what it refers to error: [VAGUE_PE]
			say "[text of the parser error internal rule response (J)][line break]" (J);
		-- can't see it at the moment error: [ITGONE_PE]
			if the pronoun typed refers to something:
				say "[as the parser][The commandee] [can't] see ['][pronoun i6 dictionary word]['] ([the noun]) at the moment.[as normal][line break]" (K);
			otherwise:
				say "[text of the the print parser errors for commands to actors rule response (J)]";
		-- excepted something not included error: [EXCEPT_PE]
			say "[as the parser]You excepted something not included anyway; please retry your instruction to [the commandee].[as normal][line break]" (L);
		-- can only do that to something animate error: [ANIMA_PE]
			say "[as the parser][The commandee] [can] only do that to something animate.[as normal][line break]" (M);
		-- not a verb I recognise error: [VERB_PE]
			[Note that this one will catch arbitrary stuff like 'password', so it's a good hook for game writers.  Also note the British spelling of the error.]
			set the oops target to the verb;
			say "[text of the parser error internal rule response (N)][line break]" (N);
[		-- not something you need to refer to error: ] [SCENERY_PE -- should never trigger, dead code in I6T & Standard Rules -- message O]
[			say "[as the parser]That instruction to [the commandee] referred to something which you don't need to refer to in the course of this story.[as normal][line break]" (O); ]
[		-- didn't understand the way that finished error: ] [JUNKAFTER_PE -- should never trigger, dead code in I6T & Standard Rules -- message P]
		-- not enough of those available error: [TOOFEW_PE]
			say "[as the parser][if number understood is 0]None[otherwise]Only [number understood in words][end if] of those [regarding the number understood][are] available to [the commandee].[as normal][line break]" (Q);
[		-- nothing to do error: ] [NOTHING_PE -- complex, break out into its own rule]
		-- noun did not make sense in that context error: [NOTINCONTEXT_PE]
			[This is swapped with ASKSCOPE_PE in the Standard Rules -- a large bug]
			[This only triggers on pronouns which refer to out of context items.]
			say "[text of the parser error internal rule response (R)][line break]" (R);
[		-- I beg your pardon error: ] [BLANK_LINE_PE -- cannot happen in this context -- message X]
[		-- can't again the addressee error: ] [ANIMAAGAIN_PE -- cannot happen in this context -- message S]
		-- comma can't begin error: [COMMABEGIN_PE]
			say "[as the parser]Please only use one comma: 'person, command', not 'person,, command'.[as normal][line break]" (T);
[		-- can't see whom to talk to error: ] [MISSINGPERSON_PE -- cannot happen in this context -- message U]
[		-- can't talk to inanimate things error: ] [ANIMALISTEN_PE -- cannot happen in this context -- message V]
[		-- didn't understand addressee's last name error: ] [TOTALK_PE -- cannot happen in this context -- message W]
[		-- referred to a determination of scope error:] [ASKSCOPE_PE -- complex, break out into its own rule]
			[This is swapped with NOTINCONTEXT_PE in the Standard Rules -- a large bug]
		-- otherwise:
			[Someone has somehow sneaked an impossible error into here.  Pass through to the usual "You get no reply"/"You speak" responses.]
			make no decision;
	rule fails.

Volume - Determination of All for Actor

[For some reason the Standard Rules only restrict the definition of all for the player, not for all actors.  We fix this.]

[These are exact copies of the Standard Rules version with "an actor" added]
Rule for deciding whether all includes scenery 
	while an actor taking or taking off or removing
	(this is the general exclude scenery from take all rule): it does not.
Rule for deciding whether all includes people
	while an actor taking or taking off or removing
	(this is the general exclude people from take all rule): it does not.
Rule for deciding whether all includes fixed in place things
	while an actor taking or taking off or removing
	(this is the general exclude fixed in place things from take all rule): it does not.
Rule for deciding whether all includes things enclosed by the person reaching
	while an actor taking or taking off or removing
	(this is the general exclude indirect possessions from take all rule): it does not.
Rule for deciding whether all includes a person
	while an actor dropping or throwing or inserting or putting
	(this is the general exclude people from drop all rule): it does not.

Volume - Actions

Chapter - Taking

Section - Taking

Unsuccessful attempt by an actor taking (this is the actor failed to take rule):
	let rf be the reason the action failed;
	if rf is the can't take yourself rule:
		say "[The actor] [can't] take [themselves]." (A);
	else if rf is the can't take other people rule:
		say "[The actor] [can't] pick up [the noun][or it's the wrong time][or that's not the way]." (B);
	else if rf is the can't take component parts rule:
		say "[text of the can't take component parts rule response (A)][line break]" (C);
	else if rf is the general can't take people's possessions rule:
		do nothing; [N.B.: This is handled by rewriting the rule, so we don't have to compute the owner twice.]
	else if rf is the can't take items out of play rule:
		say "[as the parser][regarding the noun][Those] [aren't] available to [the actor].[as normal][line break]" (E);
	else if rf is the can't take what you're inside rule:
		say "[The actor] [would have] to get [if noun is a supporter]off[otherwise]out of[end if] [the noun] first." (F);
	else if rf is the can't take what's already taken rule:
		say "[The actor] already [have] [regarding the noun][those]." (G);
	else if rf is the can't take scenery rule:
		[Thanks to parser styling, this triggers several line break bugs.  Careful...]
		say "[as the parser][regarding the noun][Those]['re] just scenery, and [can't] be taken by [the actor].[as normal][line break]" (H);
	else if rf is the can only take things rule:
		say "[The actor] [cannot] carry [the noun]." (I);
	else if rf is the can't take what's fixed in place rule:
		say "[text of the can't take what's fixed in place rule response (A)][line break]" (J);
	else if rf is the can't exceed carrying capacity rule:
		say "[The actor] [are] carrying too many things already." (K);
	else:
		make no decision.

Section - Taking people's possessions

The general can't take people's possessions rule is listed instead of the can't take people's possessions rule in the check taking rulebook.

Check an actor taking (this is the general can't take people's possessions rule):
	let the local ceiling be the common ancestor of the actor with the noun;
	let the owner be the not-counting-parts holder of the noun;
	while the owner is not nothing and the owner is not the local ceiling:
		if the owner is a person:
			if the actor is the player:
				say "[regarding the noun][Those] [seem] to belong to [the owner]." (A);
			otherwise if the owner is the player:
				say "[The actor] [can't] take [regarding the noun][those] because [those] [seem] to belong to [us].[single action line break]" (B);
			otherwise:
				say "[The actor] [can't] take [regarding the noun][those] because [those] [seem] to belong to [the owner].[single action line break]" (C);
			stop the action;
		let the owner be the not-counting-parts holder of the owner;

Section - Taking things with people in them

[
Prohibit taking an enterable with a person in it.

Taking an enterable containing a character can cause really weird results.
* The description of the location of the player becomes odd and suggestive: "(inside the box) (inside Jane)"
* The character can "exit" and end up held by another character -- "(inside Jane)" -- which has poor implementation
* The player can end up holding another character in inventory, which also has poor implementation

So we prohibit this.
However, since this isn't a logical restriction -- it's more of a missing implementation issue -- print the message in parser-style.

Note that entering a held object requires entering the character holding it first, which is already prohibited.  Though the error message could be made less suggestive than "(entering Jane)".
]

Check an actor taking something enterable (this is the don't take things with people in them rule):
	if the noun encloses a person (called spoiler):
		if the actor is the player:
			if the noun is a supporter:
				say "[as the parser]In this story, [we] [can't] carry [the noun] while [the spoiler] is on [regarding the noun][them].[as normal]" (A); [No line break suppression here]
			otherwise:
				say "[as the parser]In this story, [we] [can't] carry [the noun] while [the spoiler] is in [regarding the noun][them].[as normal]" (B); [No line break suppression here]
		otherwise if actor is visible:
			if the noun is a supporter:
				say "[as the parser]In this story, [the actor] [can't] carry [the noun] while [the spoiler] is on [regarding the noun][them].[as normal][single action line break]" (C); [Here we need to do the line break suppression]
			otherwise:
				say "[as the parser]In this story, [the actor] [can't] carry [the noun] while [the spoiler] is in [regarding the noun][them].[as normal][single action line break]" (D); [Here we need to do the line break suppression]
		stop the action.

[This should be really late in the check rules; try everything else first, except the holdall.]
The don't take things with people in them rule is listed after the can't take what's fixed in place rule in the check taking rules.

Unsuccessful attempt by someone trying taking something enterable (this is the suppress second error for taking things with people in them rule):
	if the reason the action failed is the don't take things with people in them rule:
		do nothing; [We have already emitted the error message.  Avoid a bogus "John is unable to do that."]
	otherwise:
		make no decision.  [continue the action may be a synonym for make no decision here, but play it safe]

Section - Reorder checks for taking things you're inside

[If the player or an actor tries to take something they're inside which they can't take anyway, we want the "You can't carry that" message, not the other message.]
The can only take things rule is listed before the can't take what you're inside rule in the check taking rules.

Section - Holdall when taking

[This one requires replacing the check rule in order to explain what's happening -- because it isn't an unsuccessful attempt]

The general use holdall to avoid exceeding carrying capacity rule is listed instead of the use player's holdall to avoid exceeding carrying capacity rule in the check taking rulebook.

Check an actor taking (this is the general use holdall to avoid exceeding carrying capacity rule):
	if the number of things carried by the actor is at least the carrying capacity of the actor:
		if the actor is holding a player's holdall (called the current working sack):
			let the transferred item be nothing;
			repeat with the possible item running through things carried by the actor:
				if the possible item is not lit and the possible item is not the current working sack, let the transferred item be the possible item;
			if the transferred item is not nothing:
				if the actor is the player:
					say "(putting [the transferred item] into [the current working sack] to make room)[single action command clarification break]" (A);
				otherwise:
					say "([The actor] putting [the transferred item] into [the current working sack] to make room)[single action command clarification break]" (B);
				silently try the actor trying inserting the transferred item into the current working sack;
				if the transferred item is not in the current working sack:
					stop the action.


Chapter - Removing

Section - Debug Removing (not for release)

Unsuccessful attempt by an actor removing something from (this is the debug removing rule):
	If the parser error debugging option is active:
		say "- saved_oops [the misunderstood word] - oops_from [the other misunderstood word] - wn [the extraneous word] -";
	continue the action;

Section - Removing

Unsuccessful attempt by an actor removing something from (this is the actor failed to remove rule):
	let rf be the reason the action failed;
	if rf is the can't take component parts rule:
		if the noun is part of something (called the whole):
			[This is guaranteed]
			say "[text of the can't take component parts rule response (A)][line break]" (A);
	else if rf is the can't remove what's not inside rule:
		say "[text of the can't remove what's not inside rule response (A)][line break]" (B);
	else if rf is the can't remove from people rule:
		let the owner be the holder of the noun;
		if the owner is the player:
			say "[The actor] [can't] remove [regarding the noun][those] because [those] [seem] to belong to [us]." (C);
		otherwise:
			say "[The actor] [can't] remove [regarding the noun][those] because [those] [seem] to belong to [the owner]." (D);
	else:
		make no decision.

Chapter - Dropping

Section - Dropping

Unsuccessful attempt by an actor dropping (this is the actor failed to drop rule):
	let rf be the reason the action failed;
	if rf is the can't drop yourself rule:
		say "[The actor] [can't] drop [themselves]." (A);
	else if rf is the can't drop body parts rule:
		say "[The actor] [can't] drop part of [themselves]." (B);
	else if rf is the can't drop what's already dropped rule:
		say "[text of the can't drop what's already dropped rule response (A)]" (C);
	else if rf is the can't drop what's not held rule:
		say "[The actor] [haven't] got [regarding the noun][those]." (D);
	else if rf is the can't drop if this exceeds carrying capacity rule:
		let the receptacle be the holder of the actor;
		if the receptacle is a supporter:
			say "[text of the can't drop if this exceeds carrying capacity rule response (A)]" (E);
		otherwise if the receptacle is a container:
			say "[text of the can't drop if this exceeds carrying capacity rule response (B)]" (F);
	else:
		make no decision.

Section - Dropping Clothes

The general can't drop clothes being worn rule is listed instead of the can't drop clothes being worn rule in the check dropping rulebook.

Check an actor dropping (this is the general can't drop clothes being worn rule):
	if the actor is wearing the noun:
		if the actor is the player:
			say "(first taking [the noun] off)[command clarification break]" (A);
		otherwise:
			say "([The actor] first taking [the noun] off)[command clarification break]" (B);
		silently try the actor trying taking off the noun;
		if the actor is wearing the noun, stop the action;

Chapter - Putting (on top of supporter)

Section - Putting (on top of supporter)

Unsuccessful attempt by an actor putting something on (this is the actor failed to put on rule):
	let rf be the reason the action failed;
	if rf is the can't put something on itself rule:
		say "[The actor] [can't put] something on top of itself." (A);
	else if rf is the can't put onto what's not a supporter rule:
		say "[text of the can't put onto what's not a supporter rule response (A)]" (B);
	else if rf is the can't put if this exceeds carrying capacity rule:
		say "[text of the can't put if this exceeds carrying capacity rule response (A)]" (C);
	else:
		make no decision.

Chapter - Inserting (into container)

Section - Inserting (into container)

Unsuccessful attempt by an actor inserting something into (this is the actor failed to insert into rule):
	let rf be the reason the action failed;
	if rf is the can't insert something into itself rule:
		say "[The actor] [can't put] something inside itself." (A);
	else if rf is the can't insert into closed containers rule:
		say "[text of the can't insert into closed containers rule response (A)]" (B);
	else if rf is the can't insert into what's not a container rule:
		say "[text of the can't insert into what's not a container rule response (A)]" (C);
	else if rf is the can't insert if this exceeds carrying capacity rule:
		say "[text of the can't insert if this exceeds carrying capacity rule response (A)]" (D);
	else:
		make no decision.
			
Section - Inserting Clothes

The general can't insert clothes being worn rule is listed instead of the can't insert clothes being worn rule in the check inserting it into rulebook.

Check an actor inserting something into (this is the general can't insert clothes being worn rule):
	if the actor is wearing the noun:
		if the actor is the player:
			say "(first taking [regarding the noun][them] off)[command clarification break]" (A);
		otherwise:
			say "([The actor] first taking [regarding the noun][them] off)[command clarification break]" (B);
		silently try the actor trying taking off the noun;
		if the actor is wearing the noun, stop the action;

Chapter - Wearing

Section - Wearing

Unsuccessful attempt by an actor wearing (this is the actor failed to wear rule):
	let rf be the reason the action failed;
	if rf is the can't wear what's not clothing rule:
		say "[The actor] [can't wear] [regarding the noun][those]." (A);
	else if rf is the can't wear what's not held rule:
		say "[The actor] [aren't] holding [regarding the noun][those]." (B);
	else if rf is the can't wear what's already worn rule:
		say "[The actor] [are] already wearing [regarding the noun][those]." (C);
	else:
		make no decision.

Chapter - Taking off

Section - Taking off

Unsuccessful attempt by an actor taking off (this is the actor failed to take off rule):
	let rf be the reason the action failed;
	if rf is the can't take off what's not worn rule:
		say "[The actor] [aren't] wearing [the noun]." (A);
	else if rf is the can't exceed carrying capacity when taking off rule:
		say "[The actor] [are] carrying too many things already." (B);
	else:
		make no decision;

Section - Holdall when taking off

[We do something tricky here: we attempt to reuse the same rule in a different location.  Does this even work?  YES, YES IT DOES!!!  Yay!]

The general use holdall to avoid exceeding carrying capacity rule is listed before the can't exceed carrying capacity when taking off rule in the check taking off rulebook.

Chapter - Giving

Section - Giving

Unsuccessful attempt by an actor giving something to (this is the actor failed to give rule):
	let rf be the reason the action failed;
	if rf is the can't give what you haven't got rule:
		say "[The actor] [aren't] holding [the noun]." (A);
	else if rf is the can't give to a non-person rule:
		say "[text of the can't give to a non-person rule response (A)]" (B);
	else if rf is the can't exceed carrying capacity when giving rule:
		say "[text of the can't exceed carrying capacity when giving rule response (A)]" (C);
	else: 
		make no decision.

Section - Giving Clothes

[This is an odd one because this was reporting it, whether or not the player was the actor!  Bug in the Standard Rules, methinks.]

The general can't give clothes being worn rule is listed instead of the can't give clothes being worn rule in the check giving it to rulebook.

Check an actor giving something to (this is the general can't give clothes being worn rule):
	if the actor is wearing the noun:
		if the actor is the player:
			say "(first taking [the noun] off)[command clarification break]" (A);
		otherwise:
			say "([The actor] first taking the [the noun] off)[command clarification break]" (B);
		silently try the actor trying taking off the noun;
		if the actor is wearing the noun, stop the action;

Section - Holdall when receiving gifts

[This requires code duplication because it's the second noun which must check carrying capacity.]

Check an actor giving something to (this is the use holdall to avoid exceeding carrying capacity when receiving gifts rule):
	if the number of things carried by the second noun is at least the carrying capacity of the second noun:
		if the second noun is holding a player's holdall (called the current working sack):
			let the transferred item be nothing;
			repeat with the possible item running through things carried by the second noun:
				if the possible item is not lit and the possible item is not the current working sack, let the transferred item be the possible item;
			if the transferred item is not nothing:
				if the second noun is the player:
					say "(putting [the transferred item] into [the current working sack] to make room)[command clarification break]" (A);
				otherwise:
					say "([The second noun] putting [the transferred item] into [the current working sack] to make room)[command clarification break]" (B);
				silently try the second noun trying inserting the transferred item into the current working sack;
				if the transferred item is not in the current working sack:
					stop the action.

The use holdall to avoid exceeding carrying capacity when receiving gifts rule is listed before the can't exceed carrying capacity when giving rule in the check giving it to rulebook.

Section - Don't Block Giving

[Compliant characters accept gifts and will give things to other people.]

The block giving rule is not listed in any rulebook.

Section - Block Gifts with people in them - Should not trigger

[This usually can't trigger.  With taking of enterables prohibited, it should be impossible for someone to *have* an enterable with a person in it to *give*.]
[This can be defeated with "purloin", however, or by the author, so this is left as a backup.]

[We do not allow gifts of enterables with people in them.  These cause tricky display issues because one person can end up inside another.]

The don't accept things with people in them rule is listed last in the check giving it to rulebook.

To offer is a verb.  To decline is a verb.

Check an actor giving something enterable to (this is the don't accept things with people in them rule):
	if the noun contains a person:
		if the second noun is the player:
			say "[The noun] [look] too heavy for [us] to carry." (A);
		otherwise if the actor is the player:
			say "[We] [offer] [the noun] to [the second noun], but [the second noun] [decline], saying '[The noun] [look] too heavy to carry.'" (B);
		otherwise if actor is visible:
			say "[The actor] [offer] [the noun] to [the second noun], but [the second noun] [decline], saying '[The noun] [look] too heavy to carry.'" (C);
		stop the action;

Unsuccessful attempt by someone trying giving something enterable to (this is the suppress second error for giving things with people in them rule):
	if the reason the action failed is the don't accept things with people in them rule:
		do nothing; [We have already emitted the error message.  Avoid a bogus "John is unable to do that."]
	otherwise:
		make no decision.  [continue the action may be a synonym for make no decision here, but play it safe]

[ The below does not work: ]
[ The suppress second error for giving things with people in them rule is listed in the unsuccessful attempt rulebook. ]

Section - Unimplemented Actions

[
	These are the unimplemented actions.
	0 indicates that probably no implementation is needed.
	1 indicates that implementation is important.

Going - may be OK in standard rules
Pushing it to - 

Entering (a container) - 1
Exiting (a container) - 1
Getting off (a supporter) - 1
Opening - may be OK in standard rules
Closing - may be OK in standard rules

Taking inventory - 0
Looking - 0
Examining - 0
Looking under - 0
Searching - 0
Consulting

Listening to - (sense implementation)
Tasting - (sense implementation)
Smelling - (sense implementation) 
Touching - (sense implementation)

Answering it that ("ella, answer something to joe" -- needs a serious blocking implementation)
Telling it about ("ella, tell joe about something")
Asking it about ("ella, ask joe about something")
Asking it for ("ella, ask joe for something")
Showing

Eating
Drinking

Locking
Unlocking

Switching on
Switching off
Setting it to

Waking
Throwing
Attacking (disable at verb level)
Kissing (disable and replace at verb level)
Waiting - may be OK in standard rules
Waving -
Pulling -
Pushing - 
Turning - 
Squeezing - 
Burning -
Waking up -
Thinking -
Jumping -
Cutting -
Tying it to -
Swinging - 

Rubbing - 1
Waving hands - 
Buying -
Climbing -
Sleeping -

Saying yes - (disable at verb level)
Saying no - (disable at verb level)
Saying sorry - (disable at verb level)

]

Volume - Additional Ways To Give Orders

Chapter - Utility Phrases for Additional Ways to Give Orders

Section - Quote-stripping the topic understood

[This is of general utility.  It will strip quotes off the topic understood.  We do this before sending it back to reparse as an order.]

to say the/-- quote-stripped topic understood:
	if the topic understood exactly matches the regular expression "[quotation mark](.*)[quotation mark]":
		say "[text matching subexpression 1]";
	else if the topic understood exactly matches the regular expression "['](.*)[']":
		say "[text matching subexpression 1]";
	else:
		say "[the topic understood]";

Chapter - Core Reparsing

Section - Command Debugging

Use command debugging translates as (- CONSTANT COMMAND_DEBUGGING; -).

Section - Reparsing orders

[This is done when the action decides to kick the command back to reparse.  Sometimes we can't decide to do that until after the action has triggered.]

The special reparse flag is a truth state that varies.
The revised command text is a text that varies.

[Replace the command reading routine with one which simply processes our prepackaged command.]
For reading a command when the special reparse flag is true (this is the parse revised command rule):
	if the command debugging option is active:
		say "Revised command: [revised command text][line break]";
	change the text of the player's command to the revised command text;
	now the special reparse flag is false;

Part - Tell and Say as Orders

[ PLEASE NOTE:
	This Part contains a primer in how to transfer "the topic understood" through rules.
	It's not straightforward.  The rules have been named very carefully.
]

Chapter - Ordering it to

Section - Action and rules for ordering it to

Ordering it to is an action applying to one thing and one topic.

[Avoid bogus "John is unable to do that."  If this fails it will either give an error message or reparse, period.]
Unsuccessful attempt by someone trying ordering something to:
	do nothing;

[We need a separate case for the hilarious "actor, tell me to do something"... though arguably in some sort of S&M game this order might make sense.]
Check an actor ordering something to (this is the block ordering yourself rule):
	if the noun is the player:
		say "[as the parser]In this story [we] don't need to have someone tell [us] to do something.  Just type '[the topic understood]'.[no line break][as normal][line break]" (A);
		stop the action;

[We need separate cases for "actor, tell other person to do something", which is seriously problematic.]
Check an actor ordering something to (this is the block indirect ordering rule):
	if the actor is not the player:
		say "[as the parser]In this story you can't tell [the actor] to tell [the noun] to do something.  Try telling [the noun] to do something directly, with '[noun], [the topic understood]'.[no line break][as normal][line break]" (A);
		stop the action;

[NOTE it isn't ordering something to something.  The topic is omitted from the rule spec.]
Check ordering something to (this is the reparse as command rule):
	now the revised command text is the substituted form of "[the noun], [the quote-stripped topic understood]";
	now the special reparse flag is true;
	stop the action;	
	[TODO: Need to make sure turn count does not go up and time does not pass -- hard]

Section - Understand lines for tell, order, instruct

Understand "tell [someone] to [text]" as ordering it to.
Understand "order [someone] to [text]" as ordering it to.
Understand "instruct [someone] to [text]" as ordering it to.

Chapter - Speaking it to

Section - Diverting Explicit Answer

[In Standard Rules, "answering it that" triggers in an unfortunate way, direct from the "answer" or 'say' command -- when we want it to mainly trigger after parsing failure.]

Understand the command "answer" as something new. [This is the diversion.]
Understand the command "say" as something new.
Understand the command "shout" as something new.
Understand the command "speak" as something new.

Section - Redefining explicit answer

[We use a different verb here, and redirect in the check stage, to allow for more intervention by the game writer. This isn't always an order, necessarily.]

[If we needed a second verb with the nouns in the other order, we would use:
	Entreating it to is an action applying to one thing and one topic.
But we don't!]

[ NOTE that the "it" here will represent the topic, and not an object.]
Speaking it to is an action applying to one topic and one thing.

[ NOTE it isn't "speaking something to something" or "speaking it to something".  The topic is omitted from the rule spec. ]
Check speaking to something (called target) (this is the redirect speaking to ordering rule):
	[ Thanks to Dr. Peter Bates for figuring out the syntax on this. ]
	try ordering target to the topic understood instead; [This reverses the nouns]

Section - Understand lines for say, speak, shout, answer

Understand "speak [text] to [someone]" as speaking it to.
Understand the commands "say", "shout", and "answer" as "speak". [Similar to Standard Rules.]

Compliant Characters ends here.

---- DOCUMENTATION ----

Chapter - Why to use

Suppose you're writing an IF story with several compliant characters who do whatever you tell them to.  (Such as Infocom's Suspended.)

When writing an IF story with compliant characters who generally do what they're told, it is somewhat frustrating to type
	John, get the hat
and get the response:
	There is no reply.
When the reason is that there is no hat object.

Inform 7 normally redirects parser errors from commands like this to 'answer <topic>' so that the character can respond to arbitrary statements.  But in an story -- such as Infocom's "Suspended" -- which features compliant characters who the player orders around a lot, this is simply frustrating to a player who has made a typo or conceptual error.

This extension instead reports those parser errors.  It uses variants of the messages from Neutral Standard Responses, adapted to the context of giving other characters orders.  (It depends on Neutral Standard Responses partly because the default responses in the Standard Rules don't work very well for a Suspended-style game focused on ordering other characters around, and partly to use the low-level code there.)

This extension produces the sort of parser errors which would be given to the player by Neutral Standard Responses if she had tried to 'get the hat' herself:
	[You don't need to use the word 'hat' in this story.]
	
For the same reason, it is frustrating in a game with compliant characters to type
	John, wear the white socks
And get the rather useless response:
	John is unable to do that.

This extension provides default unsuccessful attempt responses for various actions to give more informative responses similar to those given to the player, such as:
	John can't wear the socks.
	John isn't holding the socks.
	John is already wearing the socks.
	
So far, "take", "remove", "drop", "put on (supporter)", "insert into (container)", "wear", "take off (clothes)", and "give" actions are implemented.  This is because I was writing a dress-up game where characters can be ordered to change clothes.

I haven't finished the rest of the verbs yet, though I plan to.

Chapter - How to Use

First, download:
	Neutral Standard Responses by Nathanael Nerode
	and this extension

Then add to your story file:
	Include Compliant Characters by Nathanael Nerode.

You will still have to write a persuasion rule (as documented in Writing With Inform), such as:
	Persuasion rule for asking John to try taking or removing or dropping or putting on or inserting into:
		persuasion succeeds.
	Persuasion rule for asking John to try wearing or taking off or giving:
		persuasion succeeds.

You'll also still need to write an implementation for the verbs which aren't implemented in the standard rules; but many are implemented in the Standard Rules.

Chapter - Notable restrictions

One additional restriction has been added.  A character can't pick up an enterable container which contains a person.  This is to avoid certain rather tricky situations where a person is inside a container carried by another person, which requires a complicated implementation to work right.

Chapter - Additional Ways To Give Orders

If the characters in your story are mostly there to be ordered around, it's nice if several ways of giving orders work.  While "character, command" has been the standard for a long time, Zork II used a completely different syntax -- 'tell robot "command"', which is perhaps more natural.

This extension translates
	say "command" to person [with the quotes]
	tell person "command" [with the quotes]
	order person to command
	instruct person to command
	tell person to command

Into the standard form:
	person, command
	
It also catches and rejects
	person, order/instruct/tell other person to command
	tell person to tell other person to command

It won't catch
	tell person "other person, command"
	say "other person, command" to person

These will turn into
	person, other person, command

And then fail with the usual error for that.

You can disable all of these with:
	Volume - Disabled (in place of Volume - Additional Ways To Give Orders in Compliant Characters by Nathanael Nerode)

Chapter - Holdall Enhancements

This extension makes sure a message is emitted for an actor putting something in the actor's holdall, which it isn't in the Standard Rules.

It also allows the actor to put things in the holdall to make room for clothes being removed, which was previously a missing implicit action.  (This is out of scope for this extension, perhaps, but I did it anyway.)  Likewise, someone can now put things in their holdall to make room for gifts.

Chapter - Giving

As you might expect, compliant characters accept gifts and give gifts when ordered to.  This extension eliminates the "block giving" rule and gives parser error feedback for all other gifts.

However, to avoid some real complications, a character cannot give an enterable containing a person to another person.  This is usually impossible because the character couldn't take the enterable in the first place, but if the author has overridden that, the giving rules still prohibit it.

Chapter - How to change and extend the extension's behavior

Section - Getting in before the parser errors are printed

This sort of rule is where the parser messages are printed:
	Check an actor answering something (called commandee) that when the latest parser error is the can't see any such thing error:
		say "[The commandee] can't see any such thing.";

This also short-circuits the answering process; no carry out answering or report answering rules will be run.

If you make your own check answering rules, they will go before the rules in this extension and can overrride them.  If your own check answering rule returns success, it will allow the carry out answering and report answering rules to take place.

By default the report answering rulebook contains one rule, the "block answering rule", which simply says "You speak."  But if you write your own rules, you can use this technique to allow a character to respond to one specific arbitrary topic which isn't a command (such as "veronica, 17") -- while still using this extension to check for parser errors all other commands given to veronica.

Section - Making your own unsuccessful attempt rules

Unsuccessful attempt rules are the way to get helpful "John can't wear the refrigerator" messages rather than generic "John can't do that" messages.

You may have to do this for additional verbs which I have not implemented, especially for verbs which you have given a lot of custom behavior.

There are several undocumented gotchas in doing this relating to default rulebook behavior.

Unsuccessful attempt rules which return *no decision* will pass along to the next rule, and will eventually pass through to the default "Jane can't do that" response.  ("rfalse" in I6.)
	make no decision;
But if the rule succeeds it will suppress the default response.  ("rtrue" in I6.)
	rule succeeds; [Suppresses default message]
And if the rule fails it will ALSO suppress the default response! ("rtrue" in I6.)
	rule fails; [Suppresses default message]

Extremely unfortunately, the default outcome for an unsuccessful attempt rule is success.  (This was checked by reading I6 generated source code).  This means that the default response is suppressed by the mere existence of a rule, even if it does nothing.  So this code doesn't work:
	if the reason the action failed is:
		-- the can't take off what's not worn rule:
			say "[The actor] [aren't] wearing [the noun]." (A);
Instead, it will end action processing completely, and give no output if the action failed for any reason other than the can't take off what's not worn rule -- not desirable.

So whenever you don't match your special cases and want to pass along to the default rule, you must EXPLICITLY "make no decision".

It gets worse if you use a switch statement, like this (using an explict make no decision):
	if the reason the action failed is:
		-- the can't take off what's not worn rule:
			say "[The actor] [aren't] wearing [the noun]." (A);
	make no decision;
			
The compiler adds an implicit otherwise which ends the rule.
	if the reason the action failed is:
		-- the can't take off what's not worn rule:
			say "[The actor] [aren't] wearing [the noun]." (A);
		-- otherwise:
			rule fails;
	make no decision;
	
This breaking your fallback to the default!  So you must explicitly write this:
	if the reason the action failed is:
		-- the can't take off what's not worn rule:
			say "[The actor] [aren't] wearing [the noun]." (A);
		-- otherwise:
			make no decision;

This actually worked... until Inform 10.1 which broke the switch statements.  NICE WORK, GRAHAM.  So we have to use if-else chains.

The actual code in this extension is:
	Unsuccessful attempt by an actor taking off (this is the actor failed to take off rule):
		let rf be the reason the action failed;
		if rf is the can't take off what's not worn rule:
			say "[The actor] [aren't] wearing [the noun]." (A);
		else if the can't exceed carrying capacity when taking off rule:
			say "[The actor] [are] carrying too many things already." (B);
		else:
			make no decision;

If you've already printed a failure message in a check rule, you'll need to suppress the unsuccessful attempt message, such as this example:
	Check an actor giving something enterable to (this is the don't accept things with people in them rule):
		if the noun contains a person:
			if the second noun is the player:
				say "[The noun] [look] too heavy for [us] to carry." (A);
			otherwise if the actor is the player:
				say "[We] [offer] [the noun] to [the second noun], but [the second noun] [decline], saying '[The noun] [look] too heavy to carry.'" (B);
			otherwise if actor is visible:
				say "[The actor] [offer] [the noun] to [the second noun], but [the second noun] [decline], saying '[The noun] [look] too heavy to carry.'" (C);
			stop the action;

	Unsuccessful attempt by someone trying giving something enterable to:
		if the reason the action failed is the don't accept things with people in them rule:
			do nothing; [We have already emitted the error message.  Avoid a bogus "John is unable to do that."]
		otherwise:
			make no decision.
				
If you want to override the rules in this extension, make sure your rules are listed earlier in the unsuccessful attempt rulebook.

Chapter - Say, Tell, Answer, etc.	

In addition to the usual "Jane, go north", several other ways to issue orders are implemented for player convenience:

	tell Jane to go north
	instruct Jane to go north
	order Jane to go north
	
These all pass through the "ordering it to" action in the Check stage, which rewrites it as "Jane, go north" and tells it to reparse.  You can intercept it first if you like:
	Check ordering something (called target) to (this is the new ordering rule):
		... [you can use "the topic understood" for the potential order]
	The new ordering rule is listed before the reparse as command rule in the ordering it to rulebook.

Several other methods of talking are also rewritten as commands:
	say go north to Jane
	speak go north to Jane
	answer go north to Jane
	shout go north to Jane
	
These, however, are first run through the "speaking it to" action, which redirects to the "ordering it to" action.  So you can intercept only these if you like; perhaps you don't want these to be processed as orders:
	Check speaking to something (called target) (this is the new speaking rule):
		... [you can use "the topic understood" for the potential order]
	The new speaking rule is listed before the redirect speaking to ordering rule in the speaking it to rulebook.

The reparse as command rule will also strip quotation marks from the topic, so it can successfully handle:
	tell Jane to "go north"
	instruct Jane to 'go north'
	say "go north" to Jane
	answer 'go north' to Jane
	shout "go north" to Jane

...et cetera.


Section - Stripping quotation marks from a topic

In addition to its use within the reparse as command rule, stripping quotation marks from "the topic understood" may be a generally useful thing to do.	Accordingly, it is provided as a say-phrase:
	[the/-- quote-stripped topic understood]

This will turn all of the following:
	"foo bar"
	'foo bar'
	foo bar
into the same "foo bar" (without quotation marks).

Section - Non-Commands

Even in a game with a lot of commands, you may want to handle some things not as commands.  Note that the following will not be handled as commands; this extension does not change their behavior at all:
	ask Jane about topic
	tell Jane about topic

More interesting are these cases:
	say password to Jane
	tell Jane password
	Jane, password

These will all end up in the "answering it that" action, and will be processed by this extension as a command, finally coming up with a parser error (assuming password isn't a verb!).
You can deal with this in one of three ways.

First, you could make password a verb.  

Second, you can intercept "answering it that" before this extension gets to it, just for the word "password".  Note the British spelling of recognise in the error name:
	Check an actor answering something (called the commandee) that when the latest parser error is the not a verb I recognise error (this is the divert the password rule):
		let tmp be a text;	
		now tmp is "[quote-stripped topic understood]";
		if tmp exactly matches the text "password":
			try passing the test with the commandee instead;

	Passing the test with is an action applying to one thing.

	Report passing the test with something (called the commandee):
		say "[Commandee] accepts your password!";

Third, you could intercept "answering it that" for all unknown verbs.  Again, remember the British spelling of recognise:
	Check an actor answering something (called the commandee) that when the latest parser error is the not a verb I recognise error (this is the divert the password rule):
		let tmp be a text;	
		now tmp is "[quote-stripped topic understood]";
		if tmp exactly matches the text "password":
			try passing the test with the commandee instead;
		otherwise:
			try giving incorrect password the topic understood to the commandee instead;

	Passing the test with is an action applying to one thing.

	Giving incorrect password it to is an action applying to one topic and one thing.

	Report passing the test with something (called the commandee):
		say "[Commandee] accepts your password!";

	Report giving incorrect password to something (called the commandee):
		say "[Commandee] says, 'Sorry, ['][the quote-stripped topic understood]['] is not the right password.'";	
		
Note that in this context, the topic understood is the entire statement given to the commandee.  So if you write "Jane, alpha beta gamma", the topic understood will be "alpha beta gamma".  So you can check for multi-word passwords.

Section - Disabling rules

Obviously, you can also turn off or replace the enhanced holdall rules or the rules prohibiting taking enterables containing people, by the usual methods described in Writing With Inform: "not listed in any rulebook" or "listed instead of".

The additonal ways to give orders can be disabled as noted above.

Chapter - Interactions with other Extensions

This extension depends on version 4 or later of Neutral Standard Responses by Nathanael Nerode; it uses low-level code from that extension and reuses some of those responses (so that the story author only has to override the response in one place).

Chapter - Changelog

  5.1.230727 - Release version 10.1 of Inform BROKE the switch statements on rules.
	           - Replace with else if chains.
	           - On the other hand, Parser Error Number Bugfix isn't needed any more.
	5.0.220524 - Format Changelog
	5.0.220523 - Documentation changes and cleanup now that patches to core Inform aren't needed.
	           - Requires Inform 10.1 compiled after 23 May 2022.
	           - (this was very early in the beta phase for Inform 10.1, so most copies will be fine.)
	5.0.220521 - Adaptation to Inform 10.1.0 -- requires patch to Inform.
	4/210328 - Slicker handling for "say take box to jane".
	         - Much slicker and faster handling for "say 'x' to jane" and other quotation marks typed by the player.
	         - Documentation of ways to handle passwords and similar special cases.
	         - More Chapters, Volumes, Parts, etc. for better overriding.
	3/210313 - Additional handling for "say 'x' to jane", "tell jane 'x'"
	         - Additional handling for indirect orders
	         - Additional handling for "jane, take all"
	         - Additional handling for other corner cases
	2/171007 - Update in association with version 4 of Neutral Standard Responses
	         - Fix misunderstood word reporting.
	         - Fix several tricky paragraph break errors.
	1/171003 - Fix line break issue in scenery message.
	1/171002 - First version.

Example: *** Jane - Regression test

	*: "Jane"

	Include Neutral Standard Responses by Nathanael Nerode.
	Include Compliant Characters by Nathanael Nerode.

	Jane's house is a room. "It's Jane's house."
	Jane is a person in the house. The description of Jane is "It's Jane!"
	Persuasion rule for asking Jane to try doing something:
		persuasion succeeds.

	The furniture is a plural-named scenery thing in the house. The description of the furniture is "The furniture is not meant to be used."
	The decorations is a plural-named scenery thing in the house. The description of the decorations is "Decorative."

	A banana is a thing.
	A red dress is a thing in the house.

	test scenery with "jane, take furniture/jane, take furniture and decorations".
	test cantsee with "jane, take banana/jane, take asdf/jane, take dress".
