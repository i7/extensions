Version 2/191009 of Expanded Understanding by Xavid begins here.

"Various tweaks to understand additional variations of commands and have cleverer, more specific error messages in common failure cases."

Include Snippetage by Dave Robinson.
Include Small Kindnesses by Aaron Reed.
Include version 2 of Object Matching by Xavid.

Part 1 - Commands

Chapter 1 - Take

Section 1 - Aliases

Understand "remove [something in a container]" as taking.

Section 2 - Improved Errors for Taking

[ Is it "take off hat" or "take hat off"? ]
A can't see any such thing rule when the clever action-to-be is the taking off action (this is the not wearing something to take off rule):
	say "You're not wearing any [mistaken noun snippet]."

[ Maybe it's "take something from something" ; mistaken noun position will be 1 when it's nothing and 0 when it's something, but in the wrong location ]
A can't see any such thing rule when the clever action-to-be is the removing it from action and the mistaken noun position is not 2 (this is the can't see something to take from rule):
	if the clever second noun snippet object-matches "[thing]":
		let loc be the substituted form of "in [the matched object]";
		if the matched object is a person:
			now loc is the substituted form of "held by [the matched object]";
		else if the matched object is a supporter:
			now loc is the substituted form of "on [the matched object]";
		say the clever don't "see" any clever noun snippet message for loc;
	else:				
		say the clever don't "see" any mistaken noun snippet message.

Chapter 2 - Drop

Section 1 - Improved Errors for Dropping

[ Maybe it's "drop something on something" ]
A can't see any such thing rule when (the clever action-to-be is the putting it on action or the clever action-to-be is the inserting it into action) and the mistaken noun position is 1 (this is the can't see something to drop on something rule):
	say the clever don't "have" any mistaken noun snippet message for "in your possession".

[ Probably "drop something" ]
A can't see any such thing rule when the clever action-to-be is the dropping action (this is the can't see something to drop rule):
	say the clever don't "have" any mistaken noun snippet message for "in your possession".

Section 2 - Throwing At

Understand "throw [something] on [something]" as throwing it at.

Chapter 3 - Examine/Look/Search

Section 1 - Preferably Examining Things

[ Make this more specific so that you'll examine the thing, not the room, if both are visible. Examining rooms is enabled by the required Small Kindnesses by Aaron Reed. ]
Understand "examine [a visible thing]" as examining.

Section 3 - Searching

Understand the command "search" as something new.

[ Examining should list contents and is more likely to have a good message. We're specific here so the thing version takes priority over the room version. ]
Understand "search [a visible thing]" as examining.
Understand "search [room]" as overly elaborate looking.

[ Saying "a visible thing" makes this take priority over the Standard Rules version. ]
Understand "look inside/in/into/through [a visible thing]" as examining.

Section 4 - Improved Errors for Examining

Definition: a thing is remembered if the remembered holder of it is not nothing.

Section 5 - Examining Rooms

Understand "room/here" as a room.

Chapter 4 - Burn

Understand "set fire to [something]" as burning.

Chapter 5 - Go

Section 1 - Going To Scenery (for use with Approaches by Emily Short)

Landmark-approaching is an action applying to one visible thing.
A thing can be approachable.
A scenery thing is usually approachable.
A fixed in place thing is usually approachable.
Definition: a thing is a landmark if it is approachable and it is in a visited room.
Understand "go to [any landmark thing]" or "go back to [any landmark thing]" or "return to [any landmark thing]" or "revisit [any landmark thing]" as landmark-approaching.  

Instead of an actor landmark-approaching (this is the convert landmark-approaching to approaching rule):
	convert to the approaching action on location of the noun.

Rule for printing a parser error when the latest parser error is the noun did not make sense in that context error and (the action-to-be is the landmark-approaching action or the action-to-be is the approaching action) (this is the clever error for approaching a room not matched rule):
	say "I don't know a location called '[mistake snippet]'.".

Unsuccessful attempt by someone landmark-approaching when the noun is in the location of the actor (this is the unsuccessful NPC attempt to landmark-approach the current location rule):
	say "[The actor] is already [at the location of the noun]."

Section 2 - Going Short Distances (for use with Approaches by Emily Short)

Report approaching when the location is the noun and the number of entries in the path so far of the player is 1 (this is the describe even short paths when approaching rule):
	carry out the describing path activity with the player;
	say paragraph break;
	try looking instead.

Section 3 - Improved Errors for Approaching (for use with Approaches by Emily Short)

The can't approach our current location rule response (A) is "[We] [are] already [at the location].".

Unsuccessful attempt by someone approaching when the noun is the location of the actor (this is the unsuccessful NPC attempt to approach the current location rule):
	say "[The actor] is already [at the noun]."

Section 4 - Go without "to" (for use with Approaches by Emily Short)

Understand "go [any visited room]" as approaching.
Understand "go [any landmark thing]" as landmark-approaching.

Section 5 - Enter

[The standard rules have "understand "enter" as entering", which keeps Inform from supplying a noun automatically in the parenthetical manner.]

Understand the command "enter" as something new.
Understand "enter [a door]" as entering.
Understand "enter [a vehicle]" as entering.
Understand "enter [something]" as entering.

[ This can also be the going-inside action. ]
Entering simply is an action applying to nothing.
Understand "enter" as entering simply when the room-or-door inside from the location is not nothing.
Check an actor entering simply:
	convert to the going action on inside.

Section 6 - Leave

[We want leaving the room to be more specific than leaving something we're not on, because often the room name can also match scenery in the room.]

Definition: a room is here-y if it is the location.

Understand "leave [a here-y room]" as getting off.

[We want to convert exit room to outside even if you can't go outside, because you get a better error message.]
Check an actor exiting (this is the Expanded Understanding exit leaves rule):
	let the local room be the location of the actor;
	if the container exited from is the local room:
		convert to the going action on outside.
The Expanded Understanding exit leaves rule is listed before the can't exit when not inside anything rule in the check exiting rules.

Section 7 - Going Up/Down Something

Understand "go up/down [something]" as climbing.

Understand "stairs" as up when the room up from the location is not nowhere and the room down from the location is nowhere.
Understand "stairs" as down when the room down from the location is not nowhere and the room up from the location is nowhere.

Chapter 6 - Following (for use with Simple Followers by Emily Short)

Section 1 - Long Distances (for use with Approaches by Emily Short)

[Ideally we'd replace the default rule, but it's unnamed, so eh.]
Every turn (this is the followers pursue even through multiple rooms rule):
	repeat with pursuer running through people who are shadowing someone:
		while the location of the pursuer is not the location of the goal of the pursuer:
			let starting-space be the location of the pursuer; 
			let ending-space be the location of the goal of the pursuer; 
			let next-way be the best route from the starting-space to the ending-space, using doors; 
			if next-way is a direction:
				try the pursuer trying going next-way;
				if the pursuer is in starting-space:
					now the pursuer is not shadowing the goal of the pursuer;
					break;

Chapter 7 - Use

[ Small Kindnesses defines a one-noun form of use, and a two-form but only in some cases. ]
Understand "use [something] on [something]" as using it on. Using it on is an action applying to two things.

Carry out using it on (this is the Expanded Understanding carry out using it on rule): say "You'll have to try a more specific verb than use."

Chapter 8 - Tie

Tying a knot in is an action applying to one thing.
Understand "tie knot in [something preferably held]" as tying a knot in.

Check an actor tying a knot in (this is the block tying a knot in rule):
	if the actor is the player:
		say "That's not something you can tie a knot in.";
	stop the action.

Part 2 - Other

Chapter 1 - All

To decide what action-name is the action-to-be: (- action_to_be -).

Rule for deciding whether all includes things in containers when an actor taking (this is the can't take all from containers rule): it does not.
Rule for deciding whether all includes things held by someone when an actor taking (this is the can't take all from people rule): it does not.

Rule for printing a parser error when the latest parser error is the nothing to do error (this is the clever error for all matching nothing rule):
	if the the action-to-be is the taking action or the action-to-be is the removing it from action:
		say "You don't see anything obvious to [the verb word].";
	else if the action-to-be is the dropping action or the action-to-be is the putting it on action or the action-to-be is the inserting it into action or the action-to-be is the throwing it at action:
		say "You're not carrying anything to [the verb word].";
	else:
		say "I'm not sure what you want to [the verb word]."

Section 1 - Whether All Includes Rules for Other Actors

[ The rules for deciding whether all includes in the standard rules only apply to the player, so you get weird behavior when doing things like "Kayla, take all". Here we repeat the rules with the necessary addition of "an actor". ]

Rule for deciding whether all includes scenery while an actor taking or an actor taking off or an actor removing (this is the expanded exclude scenery from take all rule):
	it does not.
Rule for deciding whether all includes people while an actor taking or an actor taking off or an actor removing (this is the expanded exclude people from take all rule):
	it does not.
Rule for deciding whether all includes fixed in place things while an actor taking or an actor taking off or an actor removing (this is the expanded exclude fixed in place things from take all rule):
	it does not.
Rule for deciding whether all includes things enclosed by the person reaching while an actor taking or an actor taking off or an actor removing (this is the expanded exclude indirect possessions from take all rule):
	it does not.
Rule for deciding whether all includes a person while an actor dropping or an actor throwing or an actor inserting or an actor putting (this is the expanded exclude people from drop all rule):
	it does not.

Section 2 - Improved Errors for Drop All

[ Because the standard rules include things like "drop [things preferably held] onto [something]" as putting it on, "drop all" by default will often ask a clarification question on what that final something should be instead of an error about not having anything to drop. Disabling clarification in this case avoids that. ]

Rule for deciding whether all includes when an actor dropping when the person reaching holds nothing (this is the no clarification when drop all matches nothing rule):
	now disable clarification is true;
	make no decision.

[ An alternate approach would be below, which replace the definition in the Standard Rules. We get rid of the [other things] versions of the complicated drops, because having those definitions can lead to error messages like "What do you want to drop those things in?" when doing "drop all". The downside compared to the above is that it keeps "drop all on table" from working. ]

[Understand the commands "drop" and "throw" and "discard" as something new.
Understand "drop [things preferably held]" as dropping.
Understand "drop [something preferably held] in/into/down [something]" as inserting it into.
Understand "drop [something preferably held] on/onto [something]" as putting it on.
Understand the commands "throw" and "discard" as "drop".]

Section 3 - Give All

Understand "give [things preferably held] to [someone]" as giving it to.
Understand "give [someone] [things preferably held]" as giving it to (with nouns reversed).

[ Bad grammar, but might get tried anyways. ]
[ This is the intent, but doing literally this messes up the error messages for other things. Doing it as a parser error handler means it won't break otherwise successful commands. ]
[Understand "give [a held thing] [someone]" as giving it to.]
Rule for printing a parser error when the latest parser error is the can only do that to something animate error and the action-to-be is the giving it to action (this is the clever bad grammar giving rule):
	if the length of the player's command >= 3 and the word at (the length of the player's command - 1) does not match "to" and the word at (the length of the player's command) object-matches "[someone]":
		let person be the matched object;
		if the snippet at 2 of length (the length of the player's command - 2) object-matches "[a held thing]":
			try giving the matched object to the person;
			rule succeeds;
	continue the activity.

Chapter 2 - Conversation

Section 1 - Rewriting the Command

After reading a command (this is the Expanded Understanding conversational substitutions rule):
	if the word at 1 matches "[someone]" and the length of the player's command >= 2:
		[missing commas: understand "Kayla go south" as "Kayla, go south"]
		change the text of the player's command to the substituted form of "[word at 1], [the command from 2 onwards]";
	else if the player's command includes "tell/ask/order/command [someone] to" and the start of the matched text is 1:
		[understand "tell Kayla to go south" as "Kayla, go south"]
		let name be the snippet at (start of the matched text plus 1) of length (length of the matched text minus 2);
		replace the matched text with the substituted form of "[name],";
	else if the player's command includes "remind [someone] about/that" and the start of the matched text is 1:
		[understand "remind Kayla about danger" as "Kayla, remember danger"]
		let name be the snippet at (start of the matched text plus 1) of length (length of the matched text minus 2);
		replace the matched text with the substituted form of "[name], remember";
	else if the length of the player's command >= 3 and the word at 1 does not match "answer/say/shout/speak" and the word at (the length of the player's command - 1) exactly matches the text "," and the word at (the length of the player's command) matches "[someone]":
		[Understand "hello, Kayla" as "Kayla, hello"]
		change the text of the player's command to the substituted form of "[word at the length of the player's command], [snippet at 1 of length (length of the player's command - 2)]";
	else if the length of the player's command >= 3 and the word at 1 matches "answer/say/shout/speak" and the word at (the length of the player's command - 1) does not match "to" and the word at (the length of the player's command) matches "[someone]":
		[Understand "say hello mother" as "say hello to mother"]
		if the word at (the length of the player's command - 1) exactly matches the text ",":
			change the text of the player's command to the substituted form of "[snippet at 1 of length (length of the player's command - 2)] to [word at (length of the player's command)]";
		else:
			change the text of the player's command to the substituted form of "[snippet at 1 of length (length of the player's command - 1)] to [word at (length of the player's command)]";
	else if the length of the player's command is 1 and the word at 1 matches "hello":
		change the text of the player's command to the substituted form of "answer [the player's command]";
	else if the length of the player's command is 2 and the word at 1 matches "hello" and the word at 2 matches "[someone]":
		change the text of the player's command to the substituted form of "[the word at 2], [the word at 1]";

Section 2 - Telling That

Understand "tell [someone] [text]" as answering it that.
Understand "tell [someone] that [text]" as answering it that.

Chapter 3 - NPCs Implicitly Taking (for use with Implicit Actions by Eric Eve)

[ NPC Implicit Actions by Eric Eve doesn't seem fully compatible with recent Inform and also doesn't display the useful (Kayla trying to take the tomes) messages you might hope for. This addresses the same problem, with messages, for taking only. ]

Section 1 - Actions to Implicitly Take Before

Precondition for someone putting something on something when the noun is not carried by the actor (this is the NPC take object before putting it on rule):
  if the noun is on the second noun,
    say "[The noun] [are] already on [the second noun]." (A) instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried by the actor and implicit action attempted is true, rule succeeds.
   
Precondition for someone inserting something into something when the noun is not carried by the actor (this is the NPC take object before inserting it into rule):
  if the noun is in the second noun,
    say "[The noun] [are] already in [the second noun]." (A) instead;
 carry out the implicitly taking activity with the noun;
 if the noun is not carried by the actor and implicit action attempted is true, rule succeeds.

Section 2 - Implicitly Taking Implementation

Rule for implicitly taking something (called the object desired) when the person asked is not the player (this is the NPC implicit taking rule):
	initialize the implicit action;
	silently try the person asked taking the object desired;  
	finish the implicit action for the person asked with participle "taking" infinitive "take" object "[the object desired]" and condition (whether or not the object desired is carried by the person asked).

Section 3 - Phrases for NPCs

To finish the implicit action for (actor - a person) with participle (partc - some text) infinitive (inf - some text) object (obj - an indexed text) and condition (cond - a truth state):
  decrease the implicit action stack depth by 1;
  if the implicit action stack depth is 0, stop capturing text;
  if implicit action failure is false begin;
  if parenthesize implicit actions is true,
     now the implicit action report is "[implicit action report][if number of characters in implicit action report > 0], then [end if][if cond is true][partc][otherwise]trying to [inf][end if] [obj]";
  otherwise now the implicit action report is "[implicit action report][if number of characters in implicit action report > 0], then [end if][if cond is false]tries to [end if][inf] [obj]";
  end if;
  if cond is false, now implicit action failure is true;  
  if the implicit action stack depth is 0 begin;
    say "[implicit action summary for the actor]";
    if cond is false begin;
      let CT be "[captured text]";
	if the number of characters in CT is not 0,
        say "[captured text][run paragraph on]";
      else say "[The actor] is unable to [inf] [the obj].";
    end if;
  end if.

To say implicit action summary for (actor - a person):
  if parenthesize implicit actions is true, 
       say "(first [the actor] [implicit action report])[command clarification  break]";
  otherwise  say "[The actor] [implicit action report].";  
  now implicit action failure is false;
  now implicit action report is "".

Section 4 - Corrected Line Spacing

[ We specifically label partc as non-empty text so this phrase takes priority over the one in the base extentsion. ]

To finish the implicit action with participle (partc - some non-empty text) infinitive (inf - some text) object (obj - an indexed text) and condition (cond - a truth state):
  decrease the implicit action stack depth by 1;
  if the implicit action stack depth is 0, stop capturing text;
  if implicit action failure is false begin;
  if parenthesize implicit actions is true,
     now the implicit action report is "[implicit action report][if number of characters in implicit action report > 0], then [end if][if cond is true][partc][otherwise]trying to [inf][end if] [obj]";
  otherwise now the implicit action report is "[implicit action report][if number of characters in implicit action report > 0], then [end if][if cond is false]try to [end if][inf] [obj]";
  end if;
  if cond is false, now implicit action failure is true;  
  if the implicit action stack depth is 0 begin;
    say "[implicit action summary]";
    if cond is false,  say "[captured text][run paragraph on]";   
  end if.

Chapter 4 - Can't See Any Such Thing

Section 1 - Rules

Last rule for printing a parser error when the latest parser error is the can't see any such thing error (this is the clever can't see any such thing rule):
	determine the mistaken noun;
	abide by the can't see any such thing rules.

Can't see any such thing is a rulebook.
The can't see any such thing rules have default success.

Last can't see any such thing rule (this is the can't see any such thing here rule):
	debug "XAVID: [clever action-to-be] [mistaken noun position].";
	say the clever don't "see" any mistaken noun snippet message.

Section 2 - Message

To say the clever don't (seehave - text) any (MS - a snippet) message:
	say the clever don't seehave any MS message for "here".

To say the clever don't (seehave - text) any (MS - a snippet) message for (loc - text):
	if MS is invalid:
		[ This might be "drop onto table". ]
		say "I'm not sure what you want to [clever verb].";		
	else if MS object-matches "[any remembered thing]":
		if the location of the matched object is the location of the player:
			say "[regarding the matched object][The matched object] [aren't] [loc]. [They]['re] [at the remembered holder of the matched object].";
		else if the matched object is fixed in place:
			say "[regarding the matched object]You don't [seehave] [the matched object] [loc]. [They] [adapt the verb are in the past tense] [at the remembered holder of the matched object].";
		else:
			say "[regarding the matched object]You don't [seehave] [the matched object] [loc][if (the location of the remembered holder of the matched object is not the location of the player) and (the number of characters in the remembered action of the matched object is not 0)]. You [regarding the matched object][remembered action of the matched object] [at the remembered holder of the matched object][end if].";
	else:		
		say "You don't [seehave] any [cleanly MS] [loc]."

To say cleanly (MS - a snippet):
	if MS matches the regular expression "^(.*)\.$":
		say the text matching subexpression 1;
	else:
		say MS.

Section 3 - Implementation

The clever noun snippet is a snippet that varies.
The clever second noun snippet is a snippet that varies.
The mistaken noun snippet is a snippet that varies.
The mistaken noun position is a number that varies.
The clever action-to-be is an action name that varies.
The clever verb is text that varies.

To determine the mistaken noun:
	let best score be -1;
	[ set some defaults if no lines match, due to implied prepositions say ]
	[ 0 means "unknown" ]
	now the mistaken noun position is 0;
	now the mistaken noun snippet is the snippet at 2 of length the length of the player's command - 1;
	now the clever action-to-be is the waiting action;
	get syntax;
	repeat with I running from 1 to the syntax len:		
		let WL be a list of text;
		let n1start be a number;
		let n2start be a number;
		let n1len be a number;
		let n2len be a number;
		let found mid be false;
		unpack next grammar line;
		[add grammar token 1 to P;]
		let J be 0;
		analyze token J;
		let rejected line be false;		
		let cmd point be 2;
		let score be 0;
		debug "[line break]EU line [I - 1]";
		while 1 is 1:
			debug "EU token [J]: [tokenly J] [token type] [token data] [if token cont J]/[end if].";
			if not token cont J and WL is not empty:
				debug "XY: [WL].";
				increase score by 1;
				let matched word be false;
				repeat with W running through WL:
					repeat with K running from cmd point to the length of the player's command:
						debug "Comparing [word at K] vs [W]";
						if the word at K exactly matches the text W:
							if K > cmd point and n1start is 0:
								break;
							now matched word is true;
							if n2start > 0:
								now n2len is K - n2start;
							else if n1start > 0:
								now n1len is K - n1start;
								now found mid is true;
							now cmd point is K + 1;
							debug "XAVID: matched word: [W].";
							break;
					if matched word is true:
						break;
				if matched word is false:
					if n1start > 0 and ((the length of the player's command) is n1start):
						debug "XAVID guessing partial command";
						decrease score by 1;
					else:
						debug "XAVID no match";
						now rejected line is true;
					break;
				now WL is {};
			if token type is 1 and token data is 15:
				break;
			else if token type is 2:
				let T be the substituted form of "[token text]";
				add T to WL;
			else:
				if cmd point > the length of the player's command:
					debug "XAVID off end";
					now rejected line is true;
					break;
				debug "XAVID nounish? '[snippet at cmd point of length 1]' [found mid] [cmd point]";
				if found mid is true:
					now n2start is cmd point;
				else:
					now n1start is cmd point;
			increase J by 1;
			analyze token J;
		if n2start > 0 and n2start <= the length of the player's command and n2len is 0:
			debug "XAVID guessing n2 to end from [n2start].";
			now n2len is (the length of the player's command - n2start) + 1;
		else if n1start > 0 and n1len is 0:
			debug "XAVID guessing n1 to end from [n1start].";
			now n1len is (the length of the player's command - n1start) + 1;
		debug "XAVID: [cmd point] [n1start] [n2start] [rejected line].";
		if (cmd point <= the length of the player's command) and (cmd point is not n2start) and (cmd point is not n1start):
			debug "XAVID mismatch";
			now rejected line is true;
		if rejected line is false:
			let N1 be the snippet at n1start of length n1len;
			let N2 be the snippet at n2start of length n2len;
			[if n2start > 0:
				say "XAVID line matched [score] with N1=[N1] and N2=[N2].";
			else if n1start > 0:
				say "XAVID line matched [score] with N1=[N1].";
			else:
				say "XAVID line matched [score].";]
			if score > best score:
				[say "XAVID [n1start] [n1len].";]
				now the clever noun snippet is N1;
				now the clever second noun snippet is N2;
				now the clever action-to-be is the action-to-be;
				[ saved mistake start might be from a later grammar line, so can't use it ]
				[ let's see if the first noun doesn't object-match something ]
				if the clever noun snippet object-matches "[thing]":
					if the clever second noun snippet object-matches "[thing]":
						[ both nouns match, so I'm out of ideas ]
						now the mistaken noun position is 0;
					else:
						debug "N2 seems mistaken based on [clever second noun snippet]";
						now the mistaken noun position is 2;
						now the mistaken noun snippet is the clever second noun snippet;
				else:
					debug "N1 seems mistaken based on [clever noun snippet]";
					now the mistaken noun position is 1;
					now the mistaken noun snippet is the clever noun snippet;
				[ handle lists of nouns somewhat properly ]
				let mnstart be the start of the mistaken noun snippet;
				let wordskip be 0;
				repeat with possible len running from 1 to the length of the mistaken noun snippet:
					let snip be the snippet at mnstart plus possible len of length 1;
					if (not (snip is valid)) or snip matches the regular expression "(?i)^and|,$":
						[ maybe end snippet early if we hit an and or , ]
						let currsnip be the snippet at (mnstart plus wordskip) of length (possible len minus wordskip);
						if currsnip matches a noun:
							debug "[currsnip] matches a thing";
							[ keep going ]
							now wordskip is possible len plus 1;
						else:
							debug "'[currsnip]' at [mnstart plus wordskip] len [possible len minus wordskip] does not match a thing";
							now the mistaken noun snippet is currsnip;
							break;
				if n1start > 2:
					now the clever verb is the snippet at 1 of length n1start;
				else:
					now the clever verb is the verb word;
				if N1 is the mistaken noun snippet:
					debug "Better match: [the mistaken noun snippet] N1!";
				else if N2 is the mistaken noun snippet:
					debug "Better match: [the mistaken noun snippet] N2!";
				else:
					debug "Better match: [n1start] ? [n2start] ? [mistaken noun snippet] ?";
				now best score is score;
				if action reversed is true:
					let tmp be the clever noun snippet;
					now the clever noun snippet is the clever second noun snippet;
					now the clever second noun snippet is tmp;
					if mistaken noun position is 2:
						now mistaken noun position is 1;
					else if mistaken noun position is 1:
						now mistaken noun position is 2;
	debug "XAVID best match: [clever action-to-be] [mistaken noun snippet].";

Syntax len is a number that varies.
The syntax len variable translates into I6 as "syntax_len".

Token type is a number that varies.
The token type variable translates into I6 as "found_ttype".

Token data is a number that varies.
The token data variable translates into I6 as "found_tdata".

Action reversed is a truth state that varies.
The action reversed variable translates into I6 as "action_reversed".

Match from is a number that varies.
The match from variable translates into I6 as "found_tdata".

Include (-

Global next_grammar_line;
Global syntax_len;

-) after "Definitions.i6t".

To get syntax:
	(- GetSyntax(); -).

To unpack next grammar line:
	(- next_grammar_line  = UnpackGrammarLine(next_grammar_line); -).

To analyze token (N - a number):
	(- AnalyseToken(line_token-->{N}); -).

To say token text:
	(- print (address) found_tdata; -).

To decide whether token cont (N - a number):
	(- ((line_token-->{N})->0 & $10) -).

Include (-

[ GetSyntax i syntax;
	i = DictionaryWordToVerbNum(verb_word);
	syntax = (#grammar_table)-->(i+1);
	syntax_len = (syntax->0);
	next_grammar_line = syntax + 1;
];

-).

Section 4 - Debugging - Not for release

Expanded debug mode is a truth state that varies. Expanded debug mode is usually false.

Toggling expanded debug mode is an action out of world.
Understand "eudebug" as toggling expanded debug mode.
Carry out toggling expanded debug mode:
	if expanded debug mode is true:
		now expanded debug mode is false;
	else:
		now expanded debug mode is true;
	say "(set expanded understanding debug mode to [expanded debug mode].)"

To debug (T - text):
	if expanded debug mode is true:
		say "[T][line break]".

To say tokenly (N - a number):
	(- DebugToken(line_token-->{N}); -).

Section 5 - Lack of Debugging - For release only

To debug (T - text):
	do nothing.

To say tokenly (N - a number):
	do nothing.

Chapter 5 - Scenery

[Normally, we don't want scenery to come up as the default nouns Inform will guess when we type words without all necessary nouns specified. This avoids that.]
A scenery thing is usually undescribed.

Chapter 6 - Clarification

Section 1 - Whom do you want to give?

The parser clarification internal rule response (D) is "[whom do you want to verb message]".

To say whom do you want to verb message:
	if the substituted form of "[parser command so far]" is "give":
		say "What would you like [if the noun is not the player][the noun] [end if]to give?[command clarification break]";
	else:
		say "Whom do you want [if the noun is not the player][the noun] [end if]to
		[parser command so far]?[command clarification break]".

Section 2 - Responding N to a clarification question

[ These almost certainly is the player getting a clarification question and then trying to go a direction ]
After reading a command (this is the Expanded Understanding answering directions rule):
	if the player's command matches "give/take/drop n/s/e/w/u/d/nw/ne/se/sw":
		change the text of the player's command to the substituted form of "[word at 2]".

Part 3 - Implementation Details

Section 2 - Re-enabling Clarifications

[ If a rule above disables clarifications in some case, we want to re-enable them before the next command. ]

Every turn (this is the enable clarification after parsing rule):
	now disable clarification is false.

Section 3 - Remembering Locations of Things (for use without Remembering by Aaron Reed)

A thing can be memorable or unmemorable. Things are usually memorable.

Remembered holding relates various things to one thing (called the remembered holder). The verb to be remembered to be holding means the reversed remembered holding relation. The verb to be remembered to be held by means the remembered holding relation.

Every thing has a text called the remembered action.

Last when play begins (this is the Remembering update remembered positions for first turn rule):
	follow the Remembering update remembered positions of things rule.

Every turn (this is the Remembering update remembered positions of things rule):
	unless in darkness:
		repeat with item running through visible things:
			if remembered holder of item is not holder of item:				
				if (item is described or item is scenery) and item is memorable:
					now the remembered action of the item is "last saw [them]";
					now the remembered holder of item is the holder of item;
		let visible holders be the list of visible things;
		add the location to visible holders;
		repeat with item running through visible holders:
			let L be the list of things remembered to be held by item;
			repeat with subitem running through L:
				if the holder of subitem is not item:
					now the remembered action of subitem is "".

[ We shouldn't remember undescribed items just by walking past them, but examining them, sure. ]
Carry out examining something memorable:
	now the remembered action of the noun is "last saw [them]";
	now the remembered holder of the noun is the holder of the noun.

Last carry out dropping something memorable:
	now the remembered action of the noun is "dropped [them]";
	now the remembered holder of the noun is the holder of the noun.

Section 4 - Printing the Name of a Room

[Inspired by Appoaches by Emily Short]

To say the natural name of (R - a room):
	if R is proper-named:
		say "[R]";
	else:
		say "the [printed name of R in lower case]".

An object has a text called the at preposition.
The at preposition of a room is usually "at".
The at preposition of a thing is usually "in".
The at preposition of a supporter is usually "on".

To say at (T - an object):
	carry out the saying at activity with T.

Saying at something is an activity on objects.

Rule for saying at a room (called T):
	if T is the location:
		say "right here";
	else:
		say "[at preposition of T] [the natural name of T]".

Rule for saying at a thing (called T):
	say "[at preposition of T] [the T] [at the holder of T]".

Rule for saying at a person (called T):
	if T is the player:
		say "among your possessions";
	else:
		say "in [the T]'s possession".

Section 5 - Mistake Location
	
To decide which number is the mistake start:
	(- oops_from -).

To decide which snippet is the mistake snippet:
	decide on the snippet at mistake start of length (the command length - mistake start + 1).

To decide which number is the saved mistake start:
	(- saved_oops -).

To decide which snippet is the saved mistake snippet:
	decide on the snippet at saved mistake start of length (the command length - saved mistake start + 1).

Section 6 - Convert To with Two Nouns

To convert to (AN - an action name) on (O - an object) and (P - an object):
	(- return GVS_Convert({AN},{O},{P}); -) - in to only.

Expanded Understanding ends here.

---- DOCUMENTATION ----

This extension makes various tweaks to understand additional variations of commands and have cleverer, more specific error messages in common failure cases.

It requires and includes the related Small Kindnesses by Aaron Reed. It depends on Snippetage by Dave Robinson and Object Matching by Xavid for implementation details.

Some enhancements are specific to use with Approaches by Emily Short (including one to improve interaction with Simple Followers by Emily Short).

Part 1 - Command Tweaks

Chapter 1 - Aliases

This extension provides aliases to make commands the player might type work.

The command "remove" can mean taking something in a container (in addition to taking off something you're wearing).

"Set fire to" means to burn.

"Leave [room]" means to go outside, whether or not you actually can; you'll get the same error message as if you typed "outside".

Chapter 2 - Remapped Commands

We interpret "search" as examining a thing or room, on the assumption that this will show something's contents and is more likely to be correctly modified for things with special description rules.

Chapter 3 - Modified Commands

Section 1 - Examining Tweaks

This raises the priority of things when examining so that, in the common case where there's a scenery thing in a room with a similar name, the thing wins. (Examining rooms is enabled by the required Small Kindnesses by Aaron Reed.)

You can set this for individual things by saying:
	
	The river is visible from a distance.

To change the default for, say, scenery:

	A scenery thing is usually visible from a distance.

Section 2 - Entering

The Standard Rules defines an enter variation with no object. We get rid of this so that you get the parenthetical message about what you're entering when entering something without specifying it specifically.

Part 2 - Cleverer Error Messages

This extension attempts to improve some error messages in a few common cases when players refer to nouns that aren't available.

Chapter 1 - Examining

If the player tries to examine something that's not here but they've seen before, this extension reminds them where they last saw it. (This functionality is inspired by Remembering by Aaron Reed but is implemented differently to avoid modifying the understanding of commands that aren't errors.)

To make natural messages about things being in rooms, we give rooms a property called the "at preposition". This is "at" by default for messages like "You last saw it at the river." but can be set to, say, "in" for indoor rooms. In addition, you can have rooms be improper-named for these messages to use lower case and the article "the".

In addition, the error messages are reworked to use the specific words typed by the player in some cases.

Chapter 2 - Taking and Dropping

We similarly use remembering and specific words for error messages from taking and dropping action.

Chapter 3 - All

Section 1 - General

We have more specific error messages for commands with all where nothing matches (e.g., take all when there's nothing here or drop all when you're not holding anything) to replace the default "There are none at all available!" The new messages are specifically based on the action the player was trying to take.

Section 2 - Drop All

By default, the standard rules provide several variations of drop that allow multiple things; in addition to the basic "drop all", you can also do "drop all into box" or "drop all onto table". The problem is that if you do "drop all" when you aren't holding anything, you get a clarification message appropriate to one of those unusual variations like "What do you want to drop those things in?", which is confusing. To avoid this, we disable clarification for dropping all when the actor isn't holding anything.

Section 3 - Limiting All

Inform uses "whether all includes" rules to, e.g., include scenery from "take all". Unfortunately, as defined in the Standard Rules these rules apply just to the player, not other actors. We provide versions of the same rules for any actor.

Part 3 - Conversation

We add several variations of "tell someone to do something" as an alternative to "someone, do something". We also understand a command that starts with someone's name as an order even if the comma is left off (if the name is one word long).

We add "tell someone that something" as an alternative to "answer".

We also understand "remind someone that something" as "someone, remember something". Remember isn't actually understood by default, but you can either make it a command or handle this with "answer someone that"-based rules.

Part 4 - Improvements with Approaches by Emily Short

We allow the player to go to a visited room by going to the name of a fixed in place or scenery thing in that room, using it as a landmark, instead of just the room name.

We display the direction traveled even when going to an adjacent room to be more explicit.

We improve error messages to use the "at preposition" property described above.

We also improve its compatibility with Simple Followers (also by Emily Short), so you don't leave people behind when to travel long distances with "go to".

Part 5 - Improvements with Implicit Actions by Eric Eve

We allow NPCs to implicitly take things, which is normally allowed by the Standard Rules but is disabled with the Implicit Actions extension (which is otherwise great because it improves error messages when you try to implicitly take something but can't).

In addition, we fix an extra line break that normally shows up after the failure-to-take message when you try and fail to implicitly take something.

Part 6 - Bugs and Comments

This extension is hosted in Github at https://github.com/i7/extensions/tree/master/Xavid. Feel free to email me at extensions@xavid.us with questions, comments, bug reports, suggestions, or improvements.

Example: * Shed - Improved errors.

	*: "Shed"

	[ Compare the messages you get from "test me" with and without including Expanded Understanding. ]

	Include Expanded Understanding by Xavid.
	
	Shed is a room.

	A supporter called a table is here.

	A thing called a hammer is here.

	South of Shed is Yard.

	A scenery thing called the sunset is here.

	A fixed in place thing called the stump is here.

	Test me with "drop all / take hammer / s / take all / x table".

Example: ** Unit Tests

	*: "Unit Tests"

	Include Expanded Understanding by Xavid.
	Include Command Unit Testing by Xavid.
	Include Approaches by Emily Short.
	Include Implicit Actions by Eric Eve.
	
	Shed is an improper-named room. The at preposition is "in".
	
	A scenery thing called a glowing orb is here. [It is visible from a distance.]
	
	A supporter called a table is here. On the table is a saw.
	
	A thing called a hammer is here.
	
	A vehicle called a hovercraft is here.
	
	A room called In Yard is south of Shed.
	Inside from In Yard is Shed.
	
	A scenery thing called the yard is here. "This is a thing, not a room."
	
	A fixed in place thing called the stump is here.
	
	A woman called the girl is here.
	Persuasion rule for asking someone to try doing something:
		persuasion succeeds.
	The block giving rule does nothing.
	
	An animal called the penguin is here.
	
	Filling it from is an action applying to two things.
	Understand "fill [something] from [something]" as filling it from.

	Understand "put out [something] with [something preferably held]" as putting it on (with nouns reversed).

	Understand "put [something preferably held] in front of [something]" as putting it on.

	Zapping is an action applying to one thing.
	Understand "zap [something]" as zapping.
	Instead of zapping something:
		say "Zot!";
		now the noun is nowhere.

	A room called Roof is up from Shed.
	
	Unit test:
		start test "x here";
		assert that "x room" produces "Shed[line break]You can see a table (on which is a saw), a hammer and a hovercraft (empty) here.";
		[]
		start test "implied preposition grammar";
		assert that "fill stump girl" produces "You don't see any stump girl here.";
		[]
		start test "all";
		assert that "drop all" produces "You're not carrying anything to drop.";
		do "take hammer";
		do "s";
		assert that "take all" produces "You don't see anything obvious to take.";
		[]
		start test "remembered examining";
		assert that "x table" produces "You don't see the table here. It was in the shed.";
		[]
		start test "scenery matches room";
		assert that "x yard" produces "This is a thing, not a room.";
		[]
		start test "examining errors";
		assert that "x wombat" produces "You don't see any wombat here.";
		assert that "Examine wombat." produces "You don't see any wombat here.";
		assert that "x orb table" produces "You don't see any orb table here.";
		[]
		start test "alternate ways of ordering";
		assert that "girl jump" produces "The girl jumps on the spot.";
		assert that "order girl to jump" produces "The girl jumps on the spot.";
		assert that "girl" produces "That's not a verb I recognise.";
		assert that "girl," produces "There is no reply.";
		[]
		start test "failing to implicitly take";
		assert that "put stump on yard" produces "(first trying to take the stump)[line break]That's fixed in place.";
		[]
		start test "going to";
		assert that "go to orb" produces "You go inside to the shed. [paragraph break]Shed[line break]You can see a table (on which is a saw) and a hovercraft (empty) here.";
		[]
		start test "complex taking";
		assert that "take hammer from table" produces "The hammer isn't on the table. It's among your possessions.";
		assert that "take hammer from stump" produces "You don't see the stump here. It was at In Yard.";
		assert that "take stump yard from table" produces "You don't see any stump yard on the table.";
		[]
		start test "take off";
		assert that "take off stump" produces "You're not wearing any stump.";
		assert that "take stump off" produces "You're not wearing any stump.";
		[]
		start test "drop";
		assert that "drop stump" produces "You don't have the stump in your possession. It was at In Yard.";
		assert that "drop stump on table" produces "You don't have the stump in your possession. It was at In Yard.";
		assert that "drop stump on counter" produces "You don't have the stump in your possession. It was at In Yard.";
		assert that "drop rock and hammer" produces "You don't have any rock in your possession.";
		assert that "drop hammer and rock" produces "You don't have any rock in your possession.";
		assert that "drop rock, hammer" produces "You don't have any rock in your possession.";
		assert that "drop hammer, rock" produces "You don't have any rock in your possession.";
		assert that "drop hammer on counter" produces "You don't see any counter here.";
		assert that "drop onto table" produces "I'm not sure what you want to drop.";
		[]
		start test "put";
		assert that "put stump on table" produces "You don't have the stump in your possession. It was at In Yard.";
		[]
		start test "give";
		do "take saw";
		do "s";
		assert that "give all to girl" produces "saw: You give the saw to the girl.[line break]hammer: You give the hammer to the girl.";
		assert that "girl, give all to me" produces "hammer: The girl gives the hammer to you.[paragraph break]saw: The girl gives the saw to you.";
		assert that "give girl all" produces "saw: You give the saw to the girl.[line break]hammer: You give the hammer to the girl.";
		assert that "girl, give me all" produces "hammer: The girl gives the hammer to you.[paragraph break]saw: The girl gives the saw to you.";
		assert that "take all from girl" produces "You don't see anything obvious to take.";
		assert that "give hammer girl" produces "You give the hammer to the girl.";
		do "n";
		assert that "give saw to girl" produces "You don't see the girl here. You last saw her at In Yard.";
		assert that "give saw to table" produces "You can only do that to something animate.";
		assert that "use saw on table" produces "You'll have to try a more specific verb than use.";
		[]
		start test "complex verb lines";
		do "drop saw";
		assert that "put out stump with saw" produces "You don't see the stump here. It was at In Yard.";
		do "s";
		assert that "put out stump with saw" produces "You don't have the saw in your possession. You dropped it in the shed.";
		[]
		start test "multiword verb messages";
		assert that "put out fish with saw" produces "You don't see any fish here.";
		[ regression test for implied prepositional phrases for the second noun ]
		assert that "put out fish" produces "You don't see any fish here.";
		[]
		start test "items that aren't where you remember them";
		assert that "take saw" produces "You don't see the saw here. You dropped it in the shed.";
		do "n";
		do "zap saw";
		assert that "take saw" produces "You don't see the saw here.";
		do "s";
		assert that "take saw" produces "You don't see the saw here.";
		[]
		start test "held by";
		assert that "take stump from girl" produces "The stump isn't held by the girl. It's right here.";
		[]
		start test "enter";
		do "enter";
		assert that "[location]" substitutes to "Shed";
		assert that "enter" produces "(the hovercraft)[line break]You get into the hovercraft.";
		
	
	Test me with "unit".

Example: *** Unit Tests with Unknown Word Error by Mike Ciul

	*: "Unit Tests with Unknown Word Error by Mike Ciul"
	
	Include Expanded Understanding by Xavid.
	Include Command Unit Testing by Xavid.
	Include Unknown Word Error by Mike Ciul.
	
	Shed is an improper-named room. The at preposition is "in".
	
	A scenery thing called a glowing orb is here. It is visible from a distance.
	
	A supporter called a table is here. On the table is a saw.

	Unit test:
		start test "examining errors";
		assert that "x wombat" produces "I don't know the word 'wombat'.";
		assert that "x orb table" produces "You don't see any orb table here.";
	
	Test me with "unit".