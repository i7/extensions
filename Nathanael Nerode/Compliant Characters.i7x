Version 1/171002 of Compliant Characters by Nathanael Nerode begins here.

"Report parsing errors to the player when ordering other characters to do things.  Inform 7 normally redirects these errors to 'answer <topic>' so that the character can respond to arbitrary statements.  But in an story with compliant characters who the player orders around routinely, that is frustrating to a player who has made a typo; this helps out the player.  Requires Parser Error Number Bugfix and Neutral Standard Responses.  Tested with Inform 6M62."

Include Parser Error Number Bugfix by Nathanael Nerode.
Include Neutral Standard Responses by Nathanael Nerode.

Volume - Parser Errors

[
Problematically, "Barbie, take hat" will fail if "hat" isn't recognized.  We want to make it clear what went wrong.
We have to replicate most of the I6 code in "Parser Letter I".  Wonderful.
Since "check an actor answering something that" ONLY happens in case of a parser error, there's always a latest parser error and it's from the most recent command.
]

Section - Low-level Support Routines

To set the/-- oops word to the/-- verb:
	(- oops_from = verb_wordnum; -)
	
To decide if the pronoun typed refers to something:
	(- (pronoun_obj ~= NULL) -)

Section - Parser Errors with complex implementation

[Some of the error types have potentially complicated implementations and get their own rules.]

Check an actor answering something (called the commandee) that when the latest parser error is the can't see any such thing error (this is the print can't see any such thing error for commands to actors rule): [CANTSEE_PE]
	if the misunderstood word is in the dictionary:
		say "[The commandee] [can't] see anything called '[the misunderstood word]' right [now].  [as the parser]Or I misunderstood you.[no line break][as normal]" (Y);
	otherwise:
		say "[as the parser]You don't need to use the word '[the misunderstood word]' in this story.[as normal]" (Z);
	restore oops_from; [Done in standard parser]
	rule fails.

Check an actor answering something (called the commandee) that when the latest parser error is the referred to a determination of scope error (this is the print referred to a determination of scope error for commands to actors rule): [ASKSCOPE_PE]
	[This is swapped with NOTINCONTEXT_PE in the Standard Rules -- a large bug]
	[TODO: This is a tricky one, because in the parser it spawns a clarification question.  I don't know how to trigger that.  So this is a placeholder.]
	say "[as the parser][The commandee] [can't] tell what [the player] [are] referring to.[as normal]" (Y);
	rule fails.

[
TODO: There's some screwy complicated code in the standard parser which special-cases nothing responding to ##Remove actions.
Unfortunately, by the time we get here, the parser has trashed the real action name.
So we can't do that clever stuff.  Have to default to the non-remove messages.  (Test to see whether the Remove errors are triggered.

In addition, for non-##Remove, the parser gave the "Nothing to do" response if multi_wanted==100.
This is... bizarre, and almost certainly an programming mistake, as it only triggers on "get 100 items", which is clearly wrong.

This leaves only one message.  It's "B" to match up with the parser error nothing rule responses, and it triggers on "get 4 items" or "get all items" (and now on get 100 items too).
]
Check an actor answering something (called the commandee) that when the latest parser error is the nothing to do error (this is the print nothing to do error for commands to actors rule): [NOTHING_PE]
	say "[as the parser][if command includes except]That excludes everything available to [the commandee].[otherwise]There is nothing available for [the commandee] to [the quoted verb].[end if][as normal]" (B);
	rule fails.

Section - Parser Errors with simple implementation

[
This is the main error handling routine for printing parser errors for commands to actors.
Query whether we should run the 'printing a parser error' activity here.  We choose not to.  The story author can intercept the "answering it that" action before this in order to achieve the same effect.
The error letters are matched up strictly with parser internal error rule response letters, largely for maintenance reasons.
]
Check an actor answering something (called the commandee) that (this is the print parser errors for commands to actors rule):
	if the latest parser error is:
		-- didn't understand error: [STUCK_PE]
			say "[as the parser]I didn't understand that order, though I thought it was an instruction addressed to [the commandee].[as normal]" (A);
			set the oops word to the verb;
		-- only understood as far as error: [UPTO_PE]
			say "[text of the only understood as far as rule response (A)]" (B);
		-- didn't understand that number error: [NUMBER_PE]
			say "[as the parser]I can't understand your entire instruction to [the commandee].  The first part looked like the command '[the command understood so far]', but I didn't expect the word '[misunderstood word]' next.[as normal]" (D);
[		-- can't see any such thing error: ] [CANTSEE_PE -- complex, break out into its own rule]
[		-- said too little error: ] [TOOLIT_PE -- should never trigger, dead code in I6T & Standard Rules ]
[			say "[text of the parser error internal rule response (F)]" (F); ]
		-- aren't holding that error: [NOTHELD_PE]
			say "[The commandee] [aren't] holding that." (G);
			restore oops_from;
		-- can't use multiple objects error: [MULTI_PE]
			say "[text of the parser error internal rule response (H)]" (H);
		-- can only use multiple objects error: [MMULTI_PE]
			say "[text of the parser error internal rule response (I)]" (I);
		-- not sure what it refers to error: [VAGUE_PE]
			say "[text of the parser error internal rule response (J)]" (J);
		-- can't see it at the moment error: [ITGONE_PE]
			if the pronoun typed refers to something:
				say "[as the parser][The commandee] [can't] see ['][pronoun i6 dictionary word]['] ([the noun]) at the moment.[as normal]" (K);
			otherwise:
				say "[text of the the print parser errors for commands to actors rule response (J)]";
		-- excepted something not included error: [EXCEPT_PE]
			say "[as the parser]You excepted something not included anyway; please retry your instruction to [the commandee].[as normal]" (L);
		-- can only do that to something animate error: [ANIMA_PE]
			say "[as the parser][The commandee] [can] only do that to something animate.[as normal]" (M);
		-- not a verb I recognise error: [VERB_PE]
			say "[text of the parser error internal rule response (N)]" (N);
[		-- not something you need to refer to error: ] [SCENERY_PE -- should never trigger, dead code in I6T & Standard Rules -- message O]
[			say "[as the parser]That instruction to [the commandee] referred to something which you don't need to refer to in the course of this story.[as normal]" (O); ]
[		-- didn't understand the way that finished error: ] [JUNKAFTER_PE -- should never trigger, dead code in I6T & Standard Rules -- message P]
		-- not enough of those available error: [TOOFEW_PE]
			say "[as the parser][if number understood is 0]None[otherwise]Only [number understood in words][end if] of those [regarding the number understood][are] available to [the commandee].[as normal]" (Q);
[		-- nothing to do error: ] [NOTHING_PE -- complex, break out into its own rule]
		-- noun did not make sense in that context error: [NOTINCONTEXT_PE]
			[This is swapped with ASKSCOPE_PE in the Standard Rules -- a large bug]
			[This only triggers on pronouns which refer to out of context items.]
			say "[text of the parser error internal rule response (R)]" (R);
[		-- I beg your pardon error: ] [BLANK_LINE_PE -- cannot happen in this context -- message X]
[		-- can't again the addressee error: ] [ANIMAAGAIN_PE -- cannot happen in this context -- message S]
		-- comma can't begin error: [COMMABEGIN_PE]
			say "[as the parser]Please only use one comma: 'person, command', not 'person,, command'.[as normal]" (T);
[		-- can't see whom to talk to error: ] [MISSINGPERSON_PE -- cannot happen in this context -- message U]
[		-- can't talk to inanimate things error: ] [ANIMALISTEN_PE -- cannot happen in this context -- message V]
[		-- didn't understand addressee's last name error: ] [TOTALK_PE -- cannot happen in this context -- message W]
[		-- referred to a determination of scope error:] [ASKSCOPE_PE -- complex, break out into its own rule]
			[This is swapped with NOTINCONTEXT_PE in the Standard Rules -- a large bug]
		-- otherwise:
			[Someone has somehow sneaked an impossible error into here.  Pass through to the usual "You get no reply"/"You speak" responses.]
			make no decision;
	rule fails.

Section - Order of Parser Error Printing Rules

[By default we want these errors to come last.  Any earlier check rule written by the author can have "success" and authorize the otherwise-parser-error command.]

The print can't see any such thing error for commands to actors rule is listed last in the check answering it that rulebook. [4th to last]
The print nothing to do error for commands to actors rule is listed last in the check answering it that rulebook. [2nd to last]
The print parser errors for commands to actors rule is listed last in the check answering it that rulebook. [Really last]

Volume - Unsuccessful Actions

Chapter - Taking

Section - Taking

Unsuccessful attempt by an actor taking (this is the actor failed to take rule):
	if the reason the action failed is:
		-- the can't take yourself rule:
			say "[The actor] [can't] take [themselves]." (A);
		-- the can't take other people rule:
			say "[The actor] [can't] pick up [the noun][or it's the wrong time][or that's not the way]." (B);
		-- the can't take component parts rule:
			say "[text of the can't take component parts rule response (A)]" (C);
		-- the general can't take people's possessions rule:
			do nothing; [N.B.: This is handled by rewriting the rule, so we don't have compute the owner twice.]
		-- the can't take items out of play rule:
			say "[as the parser][regarding the noun][Those] [aren't] available to [the actor].[as normal]" (E);
		-- the can't take what you're inside rule:
			say "[The actor] [would have] to get [if noun is a supporter]off[otherwise]out of[end if] [the noun] first." (F);
		-- the can't take what's already taken rule:
			say "[The actor] already [have] [regarding the noun][those]." (G);
		-- the can't take scenery rule:
			say "[as the parser][regarding the noun][Those]['re] just scenery, and [can't] be taken by [the actor].[as normal]" (H);
		-- the can only take things rule:
			say "[The actor] [cannot] carry [the noun]." (I);
		-- the can't take what's fixed in place rule:
			say "[text of the can't take what's fixed in place rule response (A)]" (J);
		-- the can't exceed carrying capacity rule:
			say "[The actor] [are] carrying too many things already." (K);
		-- otherwise:
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
				say "[The actor] [can't] take [regarding the noun][those] because [those] [seem] to belong to [us]." (B);
			otherwise:
				say "[The actor] [can't] take [regarding the noun][those] because [those] [seem] to belong to [the owner]." (C);
			stop the action;
		let the owner be the not-counting-parts holder of the owner;

Section - Holdall when taking

[This one actually does require replacing the check rule in order to explain what's happening -- because it isn't an unsuccessful attempt]

The general use holdall to avoid exceeding carrying capacity rule is listed instead of the use player's holdall to avoid exceeding carrying capacity rule in the check taking rulebook.

Check an actor taking (this is the general use holdall to avoid exceeding carrying capacity rule):
	if the number of things carried by the actor is at least the carrying capacity of the actor:
		if the actor is holding a player's holdall (called the current working sack):
			let the transferred item be nothing;
			repeat with the possible item running through things carried by the actor:
				if the possible item is not lit and the possible item is not the current working sack, let the transferred item be the possible item;
			if the transferred item is not nothing:
				if the actor is the player:
					say "(putting [the transferred item] into [the current working sack] to make room)[command clarification break]" (A);
				otherwise:
					say "([The actor] putting [the transferred item] into [the current working sack] to make room)[command clarification break]" (B);
				silently try the actor trying inserting the transferred item into the current working sack;
				if the transferred item is not in the current working sack:
					stop the action.


Chapter - Removing

Section - Removing

Unsuccessful attempt by an actor removing something from (this is the actor failed to remove rule):
	if the reason the action failed is:
		-- the can't take component parts rule:
			say "[text of the can't take component parts rule response (A)]" (A);
		-- the can't remove what's not inside rule:
			say "[text of the can't remove what's not inside rule response (A)]" (B);
		-- the can't remove from people rule:
			let the owner be the holder of the noun;
			if the owner is the player:
				say "[The actor] [can't] remove [regarding the noun][those] because [those] [seem] to belong to [us]." (C);
			otherwise:
				say "[The actor] [can't] remove [regarding the noun][those] because [those] [seem] to belong to [the owner]." (D);
		-- otherwise:
			make no decision.

Chapter - Dropping

Section - Dropping

Unsuccessful attempt by an actor dropping (this is the actor failed to drop rule):
	if the reason the action failed is:
		-- the can't drop yourself rule:
			say "[The actor] [can't] drop [themselves]." (A);
		-- the can't drop body parts rule:
			say "[The actor] [can't] drop part of [themselves]." (B);
		-- the can't drop what's already dropped rule:
			say "[text of the can't drop what's already dropped rule response (A)]" (C);
		-- the can't drop what's not held rule:
			say "[The actor] [haven't] got [regarding the noun][those]." (D);
		-- the can't drop if this exceeds carrying capacity rule:
			let the receptacle be the holder of the actor;
			if the receptacle is a supporter:
				say "[text of the can't drop if this exceeds carrying capacity rule response (A)]" (E);
			otherwise if the receptacle is a container:
				say "[text of the can't drop if this exceeds carrying capacity rule response (B)]" (F);
		-- otherwise:
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
	if the reason the action failed is:
		-- the can't put something on itself rule:
			say "[The actor] [can't put] something on top of itself." (A);
		-- the can't put onto what's not a supporter rule:
			say "[text of the can't put onto what's not a supporter rule response (A)]" (B);
		-- the can't put if this exceeds carrying capacity rule:
			say "[text of the can't put if this exceeds carrying capacity rule response (A)]" (C);
		-- otherwise:
			make no decision.

Chapter - Inserting (into container)

Section - Inserting (into container)

Unsuccessful attempt by an actor inserting something into (this is the actor failed to insert into rule):
	if the reason the action failed is:
		-- the can't insert something into itself rule:
			say "[The actor] [can't put] something inside itself." (A);
		-- the can't insert into closed containers rule:
			say "[text of the can't insert into closed containers rule response (A)]" (B);
		-- the can't insert into what's not a container rule:
			say "[text of the can't insert into what's not a container rule response (A)]" (C);
		-- the can't insert if this exceeds carrying capacity rule:
			say "[text of the can't insert if this exceeds carrying capacity rule response (A)]" (D);
		-- otherwise:
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
	if the reason the action failed is:
		-- the can't wear what's not clothing rule:
			say "[The actor] [can't wear] [regarding the noun][those]." (A);
		-- the can't wear what's not held rule:
			say "[The actor] [aren't] holding [regarding the noun][those]." (B);
		-- the can't wear what's already worn rule:
			say "[The actor] [are] already wearing [regarding the noun][those]." (C);
		-- otherwise:
			make no decision.

Chapter - Taking off

Section - Taking off

Unsuccessful attempt by an actor taking off (this is the actor failed to take off rule):
	if the reason the action failed is:
		-- the can't take off what's not worn rule:
			say "[The actor] [aren't] wearing [the noun]." (A);
		-- the can't exceed carrying capacity when taking off rule:
			say "[The actor] [are] carrying too many things already." (B);
		-- otherwise:
			make no decision;

Section - Holdall when taking off

[We do something tricky here: we attempt to reuse the same rule in a different location.  Does this even work?  YES, YES IT DOES!!!  Yay!]

The general use holdall to avoid exceeding carrying capacity rule is listed before the can't exceed carrying capacity when taking off rule in the check taking off rulebook.

Chapter - Giving

Section - Giving

Unsuccessful attempt by an actor giving something to (this is the actor failed to give rule):
	if the reason the action failed is:
		-- the can't give what you haven't got rule:
			say "[The actor] [aren't] holding [the noun]." (A);
		-- the can't give to a non-person rule:
			say "[text of the can't give to a non-person rule response (A)]" (B);
		-- the can't exceed carrying capacity when giving rule:
			say "[text of the can't exceed carrying capacity when giving rule response (A)]" (C);
		-- otherwise:
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
	if the number of things carried by the second noun is at least the carrying capacity of the actor:
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

[However!  We do not allow gifts of enterables.  These cause tricky display issues because one person can end up inside another.]

The don't accept enterables rule is listed instead of the block giving rule in the check giving it to rulebook.
The block giving rule is not listed in any rulebook.

To offer is a verb.  To decline is a verb.

Check an actor giving something enterable to (this is the don't accept enterables rule):
	if the second noun is the player:
		say "[The noun] [look] too large for [us] to carry." (A);
	otherwise if the actor is the player:
		say "[We] [offer] [the noun] to [the second noun], but [the second noun] [decline], saying '[The noun] [look] too large to carry.'" (B);
	otherwise if actor is visible:
		say "[The actor] [offer] [the noun] to [the second noun], but [the second noun] [decline], saying '[The noun] [look] too large to carry.'" (C);
	stop the action.

Unsuccessful attempt by someone trying giving something enterable to:
	if the reason the action failed is the don't accept enterables rule:
		do nothing; [We have already emitted the error message.  Avoid a bogus "John is unable to do that."]
	otherwise:
		make no decision.  [continue the action may be a synonym for make no decision here, but play it safe]

Compliant Characters ends here.

---- DOCUMENTATION ----

Chapter - How to use

This extension will report parsing errors to the player when ordering other characters to do things.  

To use it, download:
	Parser Error Number Bugfix by Nathanael Nerode 
	Neutral Standard Responses by Nathanael Nerode
	and this extension

Then add to your story file:
	Include Compliant Characters by Nathanael Nerode.

Chapter - Why to use

When writing an IF story with compliant characters, it is somewhat frustrating to type
	John, get the hat
and get the response:
	There is no reply.
When the reason is that there is no hat object.

Inform 7 normally redirects parser errors from commands like this to 'answer <topic>' so that the character can respond to arbitrary statements.  But in an story -- such as Infocom's "Suspended" -- which features compliant characters who the player orders around a lot, this is simply frustrating to a player who has made a typo or conceptual error.

This extension instead reports those parser errors.  It uses variants of the messages from Neutral Standard Responses, adapted to the context of giving other characters orders.  (It depends on Neutral Standard Responses partly because the default responses in the Standard Rules don't work very well for a Suspended-style game focused on ordering other characters around, and partly to use the low-level code there.)

This extension produces the sort of the parser errors which would be given to the player by Neutral Standard Responses if she had tried to 'get the hat' herself:
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

Chapter - Holdall Enhancements

This extension makes sure a message is emitted for an actor putting something in the actor's holdall, which it isn't in the Standard Rules.

It also allows the actor to put things in the holdall to make room for clothes being removed, which was previously a missing implicit action.  (This is out of scope for this extension, perhaps, but I did it anyway.)  Likewise, someone can now put things in their holdall to make room for gifts.

Chapter - Giving

As you might expect, compliant characters accept gifts and give gifts when ordered to.  This extension eliminates the "block giving" rule and gives parser error feedback for all other gifts.   However, to avoid some real complications, people cannot give enterables to other people, as this could create a situation where one person was being carried by another.

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

This actually works and is the form you should use.  The actual code in this extension is:
	Unsuccessful attempt by an actor taking off (this is the actor failed to take off rule):
		if the reason the action failed is:
			-- the can't take off what's not worn rule:
				say "[The actor] [aren't] wearing [the noun]." (A);
			-- the can't exceed carrying capacity when taking off rule:
				say "[The actor] [are] carrying too many things already." (B);
			-- otherwise:
				make no decision;
				
If you want to override the rules in this extension, make sure your rules are listed earlier in the rulebook. [TODO: the unsuccessful attempt rulebook... I THINK... must check.]

Chapter - Interactions with other Extensions

	This extension depends on Parser Error Number Bugfix by Nathanael Nerode, which fixes a bug in the Standard Rules which left two parser errors misnamed.
	This extension depends on Neutral Standard Responses by Nathanael Nerode; it uses low-level code from that extension and reuses some of those responses (so that the story author only has to override the response in one place).
