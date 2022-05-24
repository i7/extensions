Version 5.0.220521 of Neutral Standard Responses by Nathanael Nerode begins here.

"Replaces misleading, vague, and narratively-voiced parser messages with instructive, clarifying, and neutral versions, respectively.  For Inform 10.1.0."

"based on version 3/120107 of Neutral Library Messages by Aaron Reed;
incorporates version 2/170531 of Unknown Word Error by Mike Ceil, based on Dunno by Neil Cerutti, with contributions by Andrew Plotkin for Glulx compatibility"

Volume - Underpinnings

Chapter - Helper Phrases For Author To Override

Section - Parser Message Styling

[These two are so the author can change the styling of 'parser messages' including making it completely normal.]

To say as the parser -- beginning say_as_the_parser: say "[italic type][bracket]".
To say as normal -- ending say_as_the_parser: say "[close bracket][roman type]".

Section - Noncommittal Phrases

[These allow for the possibility that the player is using "push Bob" to mean something metaphorical, for example.  They can be swapped out by the programmer, including blanking them out.]

To say or that's not the way: say ", or [regarding nothing]that [aren't] the way to do so".  [this is ", or that's not the way to do so" in the present tense]
To say or it's the wrong time: say " in these circumstances".

Chapter - Low-Level Phrases To Assist Parser Error Reporting

Section - Exposing the Verb Word to Inform 7

[This is used to give better error messages from the parser]

To decide which snippet is the quoted verb:
  (- ((verb_wordnum * 100) + 1) -) .
  
Section - Exposing the Extraneous Word to Inform 7

[This is used in "I only understood as far as" messages to give better error messages from the parser.
Using "the misunderstood word" doesn't work for this because the oops target isn't set.  Neither oops_from nor saved_oops is set.  Oy gevalt!
This was the Neutral Library Messages implementation for the misunderstood word -- however, it doesn't actually work right for "you can't see any such thing", so we handle that using the oops target, below.]

To decide which snippet is the extraneous word:
  (- (((wn - 1) * 100) + 1) -).

Section - Exposing the Misunderstood Word to Inform 7

[This is used in "you can't see any such thing" errors.
Using the extraneous word fails on "take all except asdf"
Using oops_from fails on "put treaty on asdf"
(Though consider whether we should restore the oops target and *then* use oops_from.  Probably?  FIXME)

This is the only way to do this which is correct for both:
	put treaty on asdf
	take all except asdf
]

To decide which snippet is the misunderstood word:
	(- (((saved_oops) * 100) + 1) -).

[This one seems to have no actual use, but we're keeping it around]
To decide which snippet is the other misunderstood word:
	(- (((oops_from) * 100) + 1) -).

To decide whether the misunderstood word is in the dictionary:
	(- (WordNIsInDictionary(saved_oops) ~= 0) -)

To decide whether the misunderstood word is not in the dictionary:
	(- (WordNIsInDictionary(saved_oops) == 0) -)

To decide whether the misunderstood word is out of range:
	(- (saved_oops < 1 || saved_oops > WordCount()) -)

Section - Adjusting oops target

[ This is necessary to get the right oops target in many parser errors, including CANT_SEE; the default routine in Parser.i6t does this. ]
To restore the/-- oops target:
	(-	oops_from=saved_oops; -)

[This is used in this extension for "I didn't recognise that verb" errors.]
[This is also used by Compliant Characters.i7x because the oops word is misassigned in some 'character, command' instructions.]
To set the/-- oops target to the/-- verb:
	(- oops_from = verb_wordnum; -)

[Used in this extension for "Jame, go north" when the player meant "Jane"]
To set the/-- oops target to word (N - a number):
	(- oops_from = {N}; -)

Section - Debug (not for release)

[This is too useful not to have it in place, but should never be in a published game.]

Use parser error debugging translates as (- Constant PARSER_ERROR_DEBUGGING; -);

Before printing a parser error (this is the debug parser errors rule):
	If the parser error debugging option is active:
		say "- saved_oops [the misunderstood word] - oops_from [the other misunderstood word] - wn [the extraneous word] -";
	continue the activity;

Section - Checking the pronoun referent

[This is used by Compliant Characters.i7x]
To decide if the pronoun typed refers to something:
	(- (pronoun_obj ~= NULL) -)

Section - Exposing Dictionary Lookup to Inform 7

[This is used to determine whether the misunderstood word is in the dictionary or not, for better error messages.]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: WordNIsInDictionary
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ WordNIsInDictionary n i j wc;
	wc = WordCount();
	if ((n < 1) || (n > wc)) return 0; ! Out of range
	#Ifdef TARGET_ZCODE;
		i = n*2-1; ! copied from NextWord
	#Ifnot;
		i = n*3-2; ! copied from NextWord
	#Endif;
	j = parse-->i;
	! print "debugging: [", j, "]";
	if (j == 0) return 0; ! 0 means not in dictionary
	return 1; ! Inform 7 can't handle the large negative numbers in j and sometimes thinks they're false, so we convert them to 1
];
-)

Section - Exposing the Command Understood So Far to Inform 7

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: PrintCommandUnderstoodSoFar
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! This is used to replicate the error message for "I only understood your command as far as" in Inform 7 code.
[PrintCommandUnderstoodSoFar m;
	! Grabs parser globals; very hacky
	for (m=0 : m<32 : m++) pattern-->m = pattern2-->m;
	pcount = pcount2; PrintCommand(0);
];
-)

To say the command understood so far:
	(- PrintCommandUnderstoodSoFar(); -)

Section - Exposing first non-dictionary word in command to Inform 7

[ From Unknown Word Error ]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: FindUnknownWordToken
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ FindUnknownWordToken wordnum 
 w twn numwds;
#ifdef TARGET_GLULX;
 numwds = parse-->0;
#ifnot;
 numwds = parse->1;
#endif; ! TARGET_GLULX;
 ! Throw out invalid word numbers
 if (wordnum <= 0 || wordnum > numwds) rfalse;
 twn=wn; ! save the value of wn so it can be restored
 wn=wordnum;
 while (1)
 { w=NextWordStopped();
   if (w == -1) { wn=twn; rfalse; }
   if (w == 0 && TryNumber(wn-1) == -1000) 
   { wordnum=wn-1;
     wn=twn;
     return wordnum; 
   }
 }
];
-)

To decide what number is the/-- position of the/-- first/-- non-dictionary word:
	(- FindUnknownWordToken(2) -)

Section - Printing arbitrary token from the command

[ From Unknown Word Error ]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: PrintToken
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ PrintToken wordnum 
 k l m numwds;
 numwds = WordCount();
 if (wordnum <= 0 || wordnum > numwds) return;
 k=WordAddress(wordnum); 
 l=WordLength(wordnum); 
 for (m=0: m < l: m++) 
   print (char) k->m; 
];
-)

To say the/-- word at position/-- (N - a number):
	(- PrintToken({N}); -)

Section - Detecting except

[Used to improve parser messages]
To decide whether command includes except: if the player's command includes "but" or the player's command includes "except", decide yes.

Section - Line breaks for single actions only

[The idea here is that multiple actions frequently have a terse reporting format: either one line at a time, or all in one sentence.  Single actions have a more generous format.]

[This is unused but present for completeness.]
To say single action line break:
	say "[if the I6 parser is running multiple actions][no line break][otherwise][line break][end if]";

[This is used for implicit takes, drops, and the holdall code: line break for single item take, but space and no paragraph break in multiple item takes]
To say single action command clarification break:
	say "[if the I6 parser is running multiple actions] [run paragraph on][otherwise][command clarification break][end if]";

[This is unused but present for completeness]
To say single action paragraph break:
	say "[if the I6 parser is running multiple actions][otherwise][paragraph break][end if]";

[This is used in Neutral Standard Responses, and strongly recommended]
To say single action conditional paragraph break:
	say "[if the I6 parser is running multiple actions][otherwise][conditional paragraph break][end if]";

[This is unused but present for completeness: applies when Inform *would* break the paragraph]
To say multiple action run paragraph on:
	say "[if the I6 parser is running multiple actions][run paragraph on][end if]";

Section - New Verbs

[These are used in the neutral parser messages]
  
To know is a verb.
To speak is a verb.
To tell is a verb.
To learn is a verb.
To cut is a verb.
To tie is a verb.
To drink is a verb.
To swing is a verb.
To buy is a verb.
To sleep is a verb.
[To throw is a verb.]
[To climb is a verb.]
[To order is a verb.]

[These are all also *irregular* verbs, obnoxiously!]


Volume - Standard Responses

[This has every response listed in the order produced by RESPONSES 1, plus the last one which doesn't show up (probably due to an off-by-one error in NI).  Those which are not replaced are commented out.]

Section 1 - Block Vaguely Going and Respond to Final Question in Parser Style

[
The announce items from multiple object lists rule response (A) is "[current item from the multiple object list]: [run paragraph on]".  [was "[current item from the multiple object list]: [run paragraph on]"]
]

The block vaguely going rule response (A) is "[as the parser]You'll have to say which compass direction to go in.[as normal]".  [was "You'll have to say which compass direction to go in."]

[
The print the final prompt rule response (A) is "> [run paragraph on]".  [was "> [run paragraph on]"]
The print the final question rule response (A) is "Would you like to ".  [was "Would you like to "]
The print the final question rule response (B) is " or ".  [was " or "]
]

The standard respond to final question rule response (A) is "[as the parser]Please give one of the answers above.[as normal]".  [was "Please give one of the answers above."]

[
The you-can-also-see rule response (A) is "[We] ".  [was "[We] "]
The you-can-also-see rule response (B) is "On [the domain] [we] ".  [was "On [the domain] [we] "]
The you-can-also-see rule response (C) is "In [the domain] [we] ".  [was "In [the domain] [we] "]
The you-can-also-see rule response (D) is "[regarding the player][can] also see ".  [was "[regarding the player][can] also see "]
The you-can-also-see rule response (E) is "[regarding the player][can] see ".  [was "[regarding the player][can] see "]
The you-can-also-see rule response (F) is " [here]".  [was " here"]
The use initial appearance in room descriptions rule response (A) is "On [the item] ".  [was "On [the item] "]
The describe what's on scenery supporters in room descriptions rule response (A) is "On [the item] ".  [was "On [the item] "]
The describe what's on mentioned supporters in room descriptions rule response (A) is "On [the item] ".  [was "On [the item] "]
The print empty inventory rule response (A) is "[We] [are] carrying nothing.".  [was "[We] [are] carrying nothing."]
The print standard inventory rule response (A) is "[We] [are] carrying:[line break]".  [was "[We] [are] carrying:[line break]"]
The report other people taking inventory rule response (A) is "[The actor] [look] through [their] possessions.".  [was "[The actor] [look] through [their] possessions."]
]

Section 2 - Take / Drop / Put / Insert

The can't take yourself rule response (A) is "[We] [can't] take [ourselves].".  [was "[We] [are] always self-possessed."]
The can't take other people rule response (A) is "[We] [can't] pick up [the noun][or it's the wrong time][or that's not the way].".  [was "I don't suppose [the noun] [would care] for that."]

[
The can't take component parts rule response (A) is "[regarding the noun][Those] [seem] to be a part of [the whole].".  [was "[regarding the noun][Those] [seem] to be a part of [the whole]."]
The can't take people's possessions rule response (A) is "[regarding the noun][Those] [seem] to belong to [the owner].".  [was "[regarding the noun][Those] [seem] to belong to [the owner]."]
]

[TODO: This one hits out of play items, such as perhaps abstracts.  It's separate from the access through barriers rule which applies more often.]
The can't take items out of play rule response (A) is "[as the parser][regarding the noun][Those] [aren't] available.[as normal]".  [was "[regarding the noun][Those] [aren't] available."]

[
The can't take what you're inside rule response (A) is "[We] [would have] to get [if noun is a supporter]off[otherwise]out of[end if] [the noun] first.".  [was "[We] [would have] to get [if noun is a supporter]off[otherwise]out of[end if] [the noun] first."]
The can't take what's already taken rule response (A) is "[We] already [have] [regarding the noun][those].".  [was "[We] already [have] [regarding the noun][those]."]
]

[There is a particularly nasty issue here.  We want a paragraph break after if we're examining *one* item, but only a line break if we're examining *multiple* items.  [as normal] confuses the parser so that it can't figure out that the sentence is ending.]

The can't take scenery rule response (A) is "[as the parser][regarding the noun][Those]['re] just scenery, and [can't] be taken.[as normal][single action conditional paragraph break]".  [was "[regarding the noun][They're] hardly portable."]

[
The can only take things rule response (A) is "[We] [cannot] carry [the noun].".  [was "[We] [cannot] carry [the noun]."]
]

The can't take what's fixed in place rule response (A) is "[The noun] [aren't] portable.".  [was "[regarding the noun][They're] fixed in place."]

The use player's holdall to avoid exceeding carrying capacity rule response (A) is "(putting [the transferred item] into [the current working sack] to make room)[single action command clarification break]".  [was "(putting [the transferred item] into [the current working sack] to make room)[command clarification break]"]

[
The can't exceed carrying capacity rule response (A) is "[We]['re] carrying too many things already.".  [was "[We]['re] carrying too many things already."]
The standard report taking rule response (A) is "Taken.".  [was "Taken."]
The standard report taking rule response (B) is "[The actor] [pick] up [the noun].".  [was "[The actor] [pick] up [the noun]."]
]

The can't remove what's not inside rule response (A) is "But [regarding the noun][they] [aren't] [if the second noun is a supporter]on[else]in[end if] [the second noun] [now].".  [was "But [regarding the noun][they] [aren't] there now."]

[
The can't remove from people rule response (A) is "[regarding the noun][Those] [seem] to belong to [the owner].".  [was "[regarding the noun][Those] [seem] to belong to [the owner]."]
]

The can't drop yourself rule response (A) is "[We] [can't] drop [ourselves].".  [was "[We] [lack] the dexterity."]

[
The can't drop body parts rule response (A) is "[We] [can't drop] part of [ourselves].".  [was "[We] [can't drop] part of [ourselves]."]
The can't drop what's already dropped rule response (A) is "[The noun] [are] already [here].".  [was "[The noun] [are] already here."]
The can't drop what's not held rule response (A) is "[We] [haven't] got [regarding the noun][those].".  [was "[We] [haven't] got [regarding the noun][those]."]
]

The can't drop clothes being worn rule response (A) is "(first taking [the noun] off)[single action command clarification break]".  [was "(first taking [the noun] off)[command clarification break]"]

[
The can't drop if this exceeds carrying capacity rule response (A) is "[There] [are] no more room on [the receptacle].".  [was "[There] [are] no more room on [the receptacle]."]
The can't drop if this exceeds carrying capacity rule response (B) is "[There] [are] no more room in [the receptacle].".  [was "[There] [are] no more room in [the receptacle]."]
The standard report dropping rule response (A) is "Dropped.".  [was "Dropped."]
The standard report dropping rule response (B) is "[The actor] [put] down [the noun].".  [was "[The actor] [put] down [the noun]."]
The can't put something on itself rule response (A) is "[We] [can't put] something on top of itself.".  [was "[We] [can't put] something on top of itself."]
]

The can't put onto what's not a supporter rule response (A) is "[as the parser][The second noun] [don't need] to have things put on [them] in this story.[as normal]".  [was "Putting things on [the second noun] [would achieve] nothing."]

The can't put clothes being worn rule response (A) is "(first taking [regarding the noun][them] off)[single action command clarification break]".  [was "(first taking [regarding the noun][them] off)[command clarification break]"]

[
The can't put if this exceeds carrying capacity rule response (A) is "[There] [are] no more room on [the second noun].".  [was "[There] [are] no more room on [the second noun]."]
The concise report putting rule response (A) is "Done.".  [was "Done."]
The standard report putting rule response (A) is "[The actor] [put] [the noun] on [the second noun].".  [was "[The actor] [put] [the noun] on [the second noun]."]
The can't insert something into itself rule response (A) is "[We] [can't put] something inside itself.".  [was "[We] [can't put] something inside itself."]
The can't insert into closed containers rule response (A) is "[The second noun] [are] closed.".  [was "[The second noun] [are] closed."]
The can't insert into what's not a container rule response (A) is "[regarding the second noun][Those] [can't contain] things.".  [was "[regarding the second noun][Those] [can't contain] things."]
]

The can't insert clothes being worn rule response (A) is "(first taking [regarding the noun][them] off)[single action command clarification break]".  [was "(first taking [regarding the noun][them] off)[command clarification break]"]

[
The can't insert if this exceeds carrying capacity rule response (A) is "[There] [are] no more room in [the second noun].".  [was "[There] [are] no more room in [the second noun]."]
The concise report inserting rule response (A) is "Done.".  [was "Done."]
The standard report inserting rule response (A) is "[The actor] [put] [the noun] into [the second noun].".  [was "[The actor] [put] [the noun] into [the second noun]."]
]

Section 3 - Eating

The can't eat unless edible rule response (A) is "[if noun is player][We] [can't eat] [ourselves].[otherwise if noun is a person][We] [can't] eat [the noun].[otherwise][We] [can't eat] [the noun][or that's not the way].[end if]". [was "[regarding the noun][They're] plainly inedible."]

The can't eat clothing without removing it first rule response (A) is "(first taking [the noun] off)[single action command clarification break]".  [was "(first taking [the noun] off)[command clarification break]"]

The can't eat other people's food rule response (A) is "[regarding the noun][Those] [seem] to belong to [the owner]."  [was "[The owner] [might not appreciate] that."]
The standard report eating rule response (A) is "[We] [eat] [the noun].".  [was "[We] [eat] [the noun]. Not bad."]

[
The standard report eating rule response (B) is "[The actor] [eat] [the noun].".  [was "[The actor] [eat] [the noun]."]
]

Section 4 - Travel

[
The stand up before going rule response (A) is "(first getting off [the chaise])[command clarification break]".  [was "(first getting off [the chaise])[command clarification break]"]
The can't travel in what's not a vehicle rule response (A) is "[We] [would have] to get off [the nonvehicle] first.".  [was "[We] [would have] to get off [the nonvehicle] first."]
The can't travel in what's not a vehicle rule response (B) is "[We] [would have] to get out of [the nonvehicle] first.".  [was "[We] [would have] to get out of [the nonvehicle] first."]
]

[This essentially describes programming errors in the game -- door objects with no description -- so it is a parser message.]
The can't go through undescribed doors rule response (A) is "[as the parser][We] [can't go] that way.[as normal]".  [was "[We] [can't go] that way."]

[
The can't go through closed doors rule response (A) is "(first opening [the door gone through])[command clarification break]".  [was "(first opening [the door gone through])[command clarification break]"]
]

[This is cardinal directions which are unimplemented.  By convention, not a parser message, since all cardinal directions may be tried anywhere.]
[
The can't go that way rule response (A) is "[We] [can't go] that way.".  [was "[We] [can't go] that way."]
]

[This essentially describes programming errors in the game -- entering a open door which goes nowhere -- so it is a parser message.]
The can't go that way rule response (B) is "[as the parser][We] [can't], since [the door gone through] [lead] nowhere.[as normal]".  [was "[We] [can't], since [the door gone through] [lead] nowhere."]

[
The describe room gone into rule response (A) is "[The actor] [go] up".  [was "[The actor] [go] up"]
The describe room gone into rule response (B) is "[The actor] [go] down".  [was "[The actor] [go] down"]
The describe room gone into rule response (C) is "[The actor] [go] [noun]".  [was "[The actor] [go] [noun]"]
The describe room gone into rule response (D) is "[The actor] [arrive] from above".  [was "[The actor] [arrive] from above"]
The describe room gone into rule response (E) is "[The actor] [arrive] from below".  [was "[The actor] [arrive] from below"]
The describe room gone into rule response (F) is "[The actor] [arrive] from [the back way]".  [was "[The actor] [arrive] from [the back way]"]
The describe room gone into rule response (G) is "[The actor] [arrive]".  [was "[The actor] [arrive]"]
The describe room gone into rule response (H) is "[The actor] [arrive] at [the room gone to] from above".  [was "[The actor] [arrive] at [the room gone to] from above"]
The describe room gone into rule response (I) is "[The actor] [arrive] at [the room gone to] from below".  [was "[The actor] [arrive] at [the room gone to] from below"]
The describe room gone into rule response (J) is "[The actor] [arrive] at [the room gone to] from [the back way]".  [was "[The actor] [arrive] at [the room gone to] from [the back way]"]
The describe room gone into rule response (K) is "[The actor] [go] through [the noun]".  [was "[The actor] [go] through [the noun]"]
The describe room gone into rule response (L) is "[The actor] [arrive] from [the noun]".  [was "[The actor] [arrive] from [the noun]"]
The describe room gone into rule response (M) is "on [the vehicle gone by]".  [was "on [the vehicle gone by]"]
The describe room gone into rule response (N) is "in [the vehicle gone by]".  [was "in [the vehicle gone by]"]
The describe room gone into rule response (O) is ", pushing [the thing gone with] in front, and [us] along too".  [was ", pushing [the thing gone with] in front, and [us] along too"]
The describe room gone into rule response (P) is ", pushing [the thing gone with] in front".  [was ", pushing [the thing gone with] in front"]
The describe room gone into rule response (Q) is ", pushing [the thing gone with] away".  [was ", pushing [the thing gone with] away"]
The describe room gone into rule response (R) is ", pushing [the thing gone with] in".  [was ", pushing [the thing gone with] in"]
The describe room gone into rule response (S) is ", taking [us] along".  [was ", taking [us] along"]
The can't enter what's already entered rule response (A) is "But [we]['re] already on [the noun].".  [was "But [we]['re] already on [the noun]."]
The can't enter what's already entered rule response (B) is "But [we]['re] already in [the noun].".  [was "But [we]['re] already in [the noun]."]
The can't enter what's not enterable rule response (A) is "[regarding the noun][They're] not something [we] [can] stand on.".  [was "[regarding the noun][They're] not something [we] [can] stand on."]
The can't enter what's not enterable rule response (B) is "[regarding the noun][They're] not something [we] [can] sit down on.".  [was "[regarding the noun][They're] not something [we] [can] sit down on."]
The can't enter what's not enterable rule response (C) is "[regarding the noun][They're] not something [we] [can] lie down on.".  [was "[regarding the noun][They're] not something [we] [can] lie down on."]
The can't enter what's not enterable rule response (D) is "[regarding the noun][They're] not something [we] [can] enter.".  [was "[regarding the noun][They're] not something [we] [can] enter."]
The can't enter closed containers rule response (A) is "[We] [can't get] into the closed [noun].".  [was "[We] [can't get] into the closed [noun]."]
The can't enter if this exceeds carrying capacity rule response (A) is "[There] [are] no more room on [the noun].".  [was "[There] [are] no more room on [the noun]."]
The can't enter if this exceeds carrying capacity rule response (B) is "[There] [are] no more room in [the noun].".  [was "[There] [are] no more room in [the noun]."]
The can't enter something carried rule response (A) is "[We] [can] only get into something free-standing.".  [was "[We] [can] only get into something free-standing."]
The implicitly pass through other barriers rule response (A) is "(getting off [the current home])[command clarification break]".  [was "(getting off [the current home])[command clarification break]"]
The implicitly pass through other barriers rule response (B) is "(getting out of [the current home])[command clarification break]".  [was "(getting out of [the current home])[command clarification break]"]
The implicitly pass through other barriers rule response (C) is "(getting onto [the target])[command clarification break]".  [was "(getting onto [the target])[command clarification break]"]
The implicitly pass through other barriers rule response (D) is "(getting into [the target])[command clarification break]".  [was "(getting into [the target])[command clarification break]"]
The implicitly pass through other barriers rule response (E) is "(entering [the target])[command clarification break]".  [was "(entering [the target])[command clarification break]"]
The standard report entering rule response (A) is "[We] [get] onto [the noun].".  [was "[We] [get] onto [the noun]."]
The standard report entering rule response (B) is "[We] [get] into [the noun].".  [was "[We] [get] into [the noun]."]
The standard report entering rule response (C) is "[The actor] [get] into [the noun].".  [was "[The actor] [get] into [the noun]."]
The standard report entering rule response (D) is "[The actor] [get] onto [the noun].".  [was "[The actor] [get] onto [the noun]."]
]

[This is a parser clarification for the confused who try 'exit' when not inside anything, when 'go out' isn't implemented.]

The can't exit when not inside anything rule response (A) is "[We]['re] not inside anything.  [as the parser]Sometimes a compass direction like 'north' works to leave a location.[as normal]"  [was "But [we] [aren't] in anything at the [if story tense is present tense]moment[otherwise]time[end if]."]

[
The can't exit closed containers rule response (A) is "You can't get out of the closed [cage].".  [was "You can't get out of the closed [cage]."]
The standard report exiting rule response (A) is "[We] [get] off [the container exited from].".  [was "[We] [get] off [the container exited from]."]
The standard report exiting rule response (B) is "[We] [get] out of [the container exited from].".  [was "[We] [get] out of [the container exited from]."]
The standard report exiting rule response (C) is "[The actor] [get] out of [the container exited from].".  [was "[The actor] [get] out of [the container exited from]."]
The can't get off things rule response (A) is "But [we] [aren't] on [the noun] at the [if story tense is present tense]moment[otherwise]time[end if].".  [was "But [we] [aren't] on [the noun] at the [if story tense is present tense]moment[otherwise]time[end if]."]
The standard report getting off rule response (A) is "[The actor] [get] off [the noun].".  [was "[The actor] [get] off [the noun]."]
]

Section 5 - Descriptions

[
The room description heading rule response (A) is "Darkness".  [was "Darkness"]
The room description heading rule response (B) is " (on [the intermediate level])".  [was " (on [the intermediate level])"]
The room description heading rule response (C) is " (in [the intermediate level])".  [was " (in [the intermediate level])"]
The room description body text rule response (A) is "[It] [are] pitch dark, and [we] [can't see] a thing.".  [was "[It] [are] pitch dark, and [we] [can't see] a thing."]
The other people looking rule response (A) is "[The actor] [look] around.".  [was "[The actor] [look] around."]
The examine directions rule response (A) is "[We] [see] nothing unexpected in that direction.".  [was "[We] [see] nothing unexpected in that direction."]
The examine containers rule response (A) is "In [the noun] ".  [was "In [the noun] "]
The examine containers rule response (B) is "[The noun] [are] empty.".  [was "[The noun] [are] empty."]
The examine supporters rule response (A) is "On [the noun] ".  [was "On [the noun] "]
The examine devices rule response (A) is "[The noun] [are] [if story tense is present tense]currently [end if]switched [if the noun is switched on]on[otherwise]off[end if].".  [was "[The noun] [are] [if story tense is present tense]currently [end if]switched [if the noun is switched on]on[otherwise]off[end if]."]
]

[Change "nothing special" to "nothing unexpected".]
The examine undescribed things rule response (A) is "[We] [see] nothing unexpected about [the noun].".  [was "[We] [see] nothing special about [the noun]."]

[
The report other people examining rule response (A) is "[The actor] [look] closely at [the noun].".  [was "[The actor] [look] closely at [the noun]."]
The standard looking under rule response (A) is "[We] [find] nothing of interest.".  [was "[We] [find] nothing of interest."]
The report other people looking under rule response (A) is "[The actor] [look] under [the noun].".  [was "[The actor] [look] under [the noun]."]
The can't search unless container or supporter rule response (A) is "[We] [find] nothing of interest.".  [was "[We] [find] nothing of interest."]
The can't search closed opaque containers rule response (A) is "[We] [can't see] inside, since [the noun] [are] closed.".  [was "[We] [can't see] inside, since [the noun] [are] closed."]
The standard search containers rule response (A) is "In [the noun] ".  [was "In [the noun] "]
The standard search containers rule response (B) is "[The noun] [are] empty.".  [was "[The noun] [are] empty."]
The standard search supporters rule response (A) is "On [the noun] ".  [was "On [the noun] "]
The standard search supporters rule response (B) is "[There] [are] nothing on [the noun].".  [was "[There] [are] nothing on [the noun]."]
The report other people searching rule response (A) is "[The actor] [search] [the noun].".  [was "[The actor] [search] [the noun]."]
The block consulting rule response (A) is "[We] [discover] nothing of interest in [the noun].".  [was "[We] [discover] nothing of interest in [the noun]."]
The block consulting rule response (B) is "[The actor] [look] at [the noun].".  [was "[The actor] [look] at [the noun]."]
]

Section 6 - Locks, Switches, Opening, Closing

[
The can't lock without a lock rule response (A) is "[regarding the noun][Those] [don't] seem to be something [we] [can] lock.".  [was "[regarding the noun][Those] [don't] seem to be something [we] [can] lock."]
The can't lock what's already locked rule response (A) is "[regarding the noun][They're] locked at the [if story tense is present tense]moment[otherwise]time[end if].".  [was "[regarding the noun][They're] locked at the [if story tense is present tense]moment[otherwise]time[end if]."]
The can't lock what's open rule response (A) is "First [we] [would have] to close [the noun].".  [was "First [we] [would have] to close [the noun]."]
The can't lock without the correct key rule response (A) is "[regarding the second noun][Those] [don't] seem to fit the lock.".  [was "[regarding the second noun][Those] [don't] seem to fit the lock."]
The standard report locking rule response (A) is "[We] [lock] [the noun].".  [was "[We] [lock] [the noun]."]
The standard report locking rule response (B) is "[The actor] [lock] [the noun].".  [was "[The actor] [lock] [the noun]."]
The can't unlock without a lock rule response (A) is "[regarding the noun][Those] [don't] seem to be something [we] [can] unlock.".  [was "[regarding the noun][Those] [don't] seem to be something [we] [can] unlock."]
The can't unlock what's already unlocked rule response (A) is "[regarding the noun][They're] unlocked at the [if story tense is present tense]moment[otherwise]time[end if].".  [was "[regarding the noun][They're] unlocked at the [if story tense is present tense]moment[otherwise]time[end if]."]
The can't unlock without the correct key rule response (A) is "[regarding the second noun][Those] [don't] seem to fit the lock.".  [was "[regarding the second noun][Those] [don't] seem to fit the lock."]
The standard report unlocking rule response (A) is "[We] [unlock] [the noun].".  [was "[We] [unlock] [the noun]."]
The standard report unlocking rule response (B) is "[The actor] [unlock] [the noun].".  [was "[The actor] [unlock] [the noun]."]
The can't switch on unless switchable rule response (A) is "[regarding the noun][They] [aren't] something [we] [can] switch.".  [was "[regarding the noun][They] [aren't] something [we] [can] switch."]
The can't switch on what's already on rule response (A) is "[regarding the noun][They're] already on.".  [was "[regarding the noun][They're] already on."]
The standard report switching on rule response (A) is "[The actor] [switch] [the noun] on.".  [was "[The actor] [switch] [the noun] on."]
The can't switch off unless switchable rule response (A) is "[regarding the noun][They] [aren't] something [we] [can] switch.".  [was "[regarding the noun][They] [aren't] something [we] [can] switch."]
The can't switch off what's already off rule response (A) is "[regarding the noun][They're] already off.".  [was "[regarding the noun][They're] already off."]
The standard report switching off rule response (A) is "[The actor] [switch] [the noun] off.".  [was "[The actor] [switch] [the noun] off."]
The can't open unless openable rule response (A) is "[regarding the noun][They] [aren't] something [we] [can] open.".  [was "[regarding the noun][They] [aren't] something [we] [can] open."]
The can't open what's locked rule response (A) is "[regarding the noun][They] [seem] to be locked.".  [was "[regarding the noun][They] [seem] to be locked."]
The can't open what's already open rule response (A) is "[regarding the noun][They're] already open.".  [was "[regarding the noun][They're] already open."]
The reveal any newly visible interior rule response (A) is "[We] [open] [the noun], revealing ".  [was "[We] [open] [the noun], revealing "]
The standard report opening rule response (A) is "[We] [open] [the noun].".  [was "[We] [open] [the noun]."]
The standard report opening rule response (B) is "[The actor] [open] [the noun].".  [was "[The actor] [open] [the noun]."]
The standard report opening rule response (C) is "[The noun] [open].".  [was "[The noun] [open]."]
The can't close unless openable rule response (A) is "[regarding the noun][They] [aren't] something [we] [can] close.".  [was "[regarding the noun][They] [aren't] something [we] [can] close."]
The can't close what's already closed rule response (A) is "[regarding the noun][They're] already closed.".  [was "[regarding the noun][They're] already closed."]
The standard report closing rule response (A) is "[We] [close] [the noun].".  [was "[We] [close] [the noun]."]
The standard report closing rule response (B) is "[The actor] [close] [the noun].".  [was "[The actor] [close] [the noun]."]
The standard report closing rule response (C) is "[The noun] [close].".  [was "[The noun] [close]."]
]

Section 7 - Wearing

The can't wear what's not clothing rule response (A) is "[if noun is a person][We] [can't] wear [the noun].[otherwise][We] [can't wear] [regarding the noun][those].[end if]".  [was "[We] [can't wear] [regarding the noun][those]!"]
The can't wear what's not held rule response (A) is "[We] [aren't] holding [regarding the noun][those].".  [was "[We] [aren't] holding [regarding the noun][those]!"]
The can't wear what's already worn rule response (A) is "[We]['re] already wearing [regarding the noun][those].".  [was "[We]['re] already wearing [regarding the noun][those]!"]

[
The standard report wearing rule response (A) is "[We] [put] on [the noun].".  [was "[We] [put] on [the noun]."]
The standard report wearing rule response (B) is "[The actor] [put] on [the noun].".  [was "[The actor] [put] on [the noun]."]
The can't take off what's not worn rule response (A) is "[We] [aren't] wearing [the noun].".  [was "[We] [aren't] wearing [the noun]."]
The can't exceed carrying capacity when taking off rule response (A) is "[We]['re] carrying too many things already.".  [was "[We]['re] carrying too many things already."]
The standard report taking off rule response (A) is "[We] [take] off [the noun].".  [was "[We] [take] off [the noun]."]
The standard report taking off rule response (B) is "[The actor] [take] off [the noun].".  [was "[The actor] [take] off [the noun]."]
]

Section 8 - Give, Show, Wake

[
The can't give what you haven't got rule response (A) is "[We] [aren't] holding [the noun].".  [was "[We] [aren't] holding [the noun]."]
The can't give to yourself rule response (A) is "[We] [can't give] [the noun] to [ourselves].".  [was "[We] [can't give] [the noun] to [ourselves]."]
The can't give to a non-person rule response (A) is "[The second noun] [aren't] able to receive things.".  [was "[The second noun] [aren't] able to receive things."]
The can't give clothes being worn rule response (A) is "(first taking [the noun] off)[command clarification break]".  [was "(first taking [the noun] off)[command clarification break]"]
]

The block giving rule response (A) is "[as the parser][We] [don't need] to give [the noun] to [the second noun][or that's not the way].[as normal]".  [was "[The second noun] [don't] seem interested."]

[
The can't exceed carrying capacity when giving rule response (A) is "[The second noun] [are] carrying too many things already.".  [was "[The second noun] [are] carrying too many things already."]
The standard report giving rule response (A) is "[We] [give] [the noun] to [the second noun].".  [was "[We] [give] [the noun] to [the second noun]."]
The standard report giving rule response (B) is "[The actor] [give] [the noun] to [us].".  [was "[The actor] [give] [the noun] to [us]."]
The standard report giving rule response (C) is "[The actor] [give] [the noun] to [the second noun].".  [was "[The actor] [give] [the noun] to [the second noun]."]
The can't show what you haven't got rule response (A) is "[We] [aren't] holding [the noun].".  [was "[We] [aren't] holding [the noun]."]
]

The block showing rule response (A) is "[as the parser][We] [don't need] to show [the noun] to [the second noun][or that's not the way].[as normal]".  [was "[The second noun] [are] unimpressed."]

The block waking rule response (A) is "[if noun is player]As far as [we] [know], [we]['re] already awake.[otherwise][as the parser]You can't wake [the noun][or that's not the way].[as normal][end if]".  [was "That [seem] unnecessary."]

Section 9 - Throw, Attack, Kiss

[
The implicitly remove thrown clothing rule response (A) is "(first taking [the noun] off)[command clarification break]".  [was "(first taking [the noun] off)[command clarification break]"]
]

The futile to throw things at inanimate objects rule response (A) is "[We] [can't] throw [regarding the noun][those][or that's not the way].".  [was "Futile."]
The block throwing at rule response (A) is "Throwing [the noun] at [the second noun] would have no effect[or it's the wrong time].".  [was "[We] [lack] the nerve when it [if story tense is the past tense]came[otherwise]comes[end if] to the crucial moment."]
The block attacking rule response (A) is "Attacking [the noun] would have no effect[or that's not the way].".  [was "Violence [aren't] the answer to this one."]
The kissing yourself rule response (A) is "[We] [can't] [the quoted verb] [ourselves][or that's not the way].".  [was "[We] [don't] get much from that."]
The block kissing rule response (A) is "[We] [can't] [the quoted verb] [the noun][or that's not the way].".  [was "[The noun] [might not] like that."]

Section 10 - Speech

The block answering rule response (A) is "[We] [speak].".  [was "[There] [are] no reply."]
The telling yourself rule response (A) is "[as the parser][We] [can't tell] [ourselves] about something.[as normal]".  [was "[We] [talk] to [ourselves] a while."]
The block telling rule response (A) is "[We] [learn] nothing new.".  [was "This [provoke] no reaction."]
The block asking rule response (A) is "[We] [aren't] successful.".  [was "[There] [are] no reply."]

Section 11 - Waiting

[
The standard report waiting rule response (A) is "Time [pass].".  [was "Time [pass]."]
The standard report waiting rule response (B) is "[The actor] [wait].".  [was "[The actor] [wait]."]
]

Section 12 - Touch, Wave

The report touching yourself rule response (A) is "[We] [feel] nothing unexpected.".  [was "[We] [achieve] nothing by this."]

[
The report touching yourself rule response (B) is "[The actor] [touch] [themselves].".  
]

The report touching other people rule response (A) is "[as the parser][We] [don't need] to touch [the noun].[as normal]".  [was "[The noun] [might not like] that."]

[
The report touching other people rule response (B) is "[The actor] [touch] [us].".  [was "[The actor] [touch] [us]."]
The report touching other people rule response (C) is "[The actor] [touch] [the noun].".  [was "[The actor] [touch] [the noun]."]
The report touching things rule response (A) is "[We] [feel] nothing unexpected.".  [was "[We] [feel] nothing unexpected."]
The report touching things rule response (B) is "[The actor] [touch] [the noun].".  [was "[The actor] [touch] [the noun]."]
The can't wave what's not held rule response (A) is "But [we] [aren't] holding [regarding the noun][those].".  [was "But [we] [aren't] holding [regarding the noun][those]."]
The report waving things rule response (A) is "[We] [wave] [the noun].".  [was "[We] [wave] [the noun]."]
The report waving things rule response (B) is "[The actor] [wave] [the noun].".  [was "[The actor] [wave] [the noun]."]
]

Section 13 - Pull, Push, Turn, Squeeze

[
The can't pull what's fixed in place rule response (A) is "[regarding the noun][They] [are] fixed in place.".  [was "[regarding the noun][They] [are] fixed in place."]
The can't pull scenery rule response (A) is "[We] [are] unable to.".  [was "[We] [are] unable to."]
]

The can't pull people rule response (A) is "[as the parser][We] [don't need] to pull [if the noun is the player]yourself[else][the noun][end if].[as normal]".  [was "[The noun] [might not like] that."]
The report pulling rule response (A) is "[We] [pull] [the noun].".  [was "Nothing obvious [happen]."]

[
The report pulling rule response (B) is "[The actor] [pull] [the noun].".  [was "[The actor] [pull] [the noun]."]
The can't push what's fixed in place rule response (A) is "[regarding the noun][They] [are] fixed in place.".  [was "[regarding the noun][They] [are] fixed in place."]
The can't push scenery rule response (A) is "[We] [are] unable to.".  [was "[We] [are] unable to."]
]

The can't push people rule response (A) is "[as the parser][We] [don't need] to push [if the noun is the player]yourself[else][the noun][end if].[as normal]".  [was "[The noun] [might not like] that."]
The report pushing rule response (A) is "[We] [push] [the noun].".  [was "Nothing obvious [happen]."]

[
The report pushing rule response (B) is "[The actor] [push] [the noun].".  [was "[The actor] [push] [the noun]."]
The can't turn what's fixed in place rule response (A) is "[regarding the noun][They] [are] fixed in place.".  [was "[regarding the noun][They] [are] fixed in place."]
The can't turn scenery rule response (A) is "[We] [are] unable to.".  [was "[We] [are] unable to."]
]

The can't turn people rule response (A) is "[as the parser][We] [don't need] to turn [if the noun is the player]yourself[else][the noun][end if].[as normal]".  [was "[The noun] [might not like] that."]
The report turning rule response (A) is "[We] [turn] [the noun].".  [was "Nothing obvious [happen]."]

[
The report turning rule response (B) is "[The actor] [turn] [the noun].".  [was "[The actor] [turn] [the noun]."]
The can't push unpushable things rule response (A) is "[The noun] [cannot] be pushed from place to place.".  [was "[The noun] [cannot] be pushed from place to place."]
The can't push to non-directions rule response (A) is "[regarding the noun][They] [aren't] a direction.".  [was "[regarding the noun][They] [aren't] a direction."]
The can't push vertically rule response (A) is "[The noun] [cannot] be pushed up or down.".  [was "[The noun] [cannot] be pushed up or down."]
The can't push from within rule response (A) is "[The noun] [cannot] be pushed from [here].".  [was "[The noun] [cannot] be pushed from here."]
The block pushing in directions rule response (A) is "[The noun] [cannot] be pushed from place to place.".  [was "[The noun] [cannot] be pushed from place to place."]
]

The innuendo about squeezing people rule response (A) is "[as the parser][We] [don't need] to squeeze [if the noun is the player][ourselves][else][the noun][end if].[as normal]".  [was "[The noun] [might not like] that."]
The report squeezing rule response (A) is "[We] [squeeze] [the noun]".  [was "[We] [achieve] nothing by this."]

[
The report squeezing rule response (B) is "[The actor] [squeeze] [the noun].".  [was "[The actor] [squeeze] [the noun]."]
]

Section 14 - Yes, No, Burn, Wake, Think

The block saying yes rule response (A) is "Saying yes here has no effect.".  [was "That was a rhetorical question."]
The block saying no rule response (A) is "Saying no here has no effect.".  [was "That was a rhetorical question."]
The block burning rule response (A) is "You can't burn [the noun][or that's not the way].".  [was "This dangerous act [would achieve] little."]
The block waking up rule response (A) is "As far as [we] [know], [we]['re] already awake.".  [was "The dreadful truth [are], this [are not] a dream."]
The block thinking rule response (A) is "Time passes.".  [was "What a good idea."]

Section 15 - Smell, Listen, Taste

[These are OK.]
[
The report smelling rule response (A) is "[We] [smell] nothing unexpected.".  [was "[We] [smell] nothing unexpected."]
The report smelling rule response (B) is "[The actor] [sniff].".  [was "[The actor] [sniff]."]
The report listening rule response (A) is "[We] [hear] nothing unexpected.".  [was "[We] [hear] nothing unexpected."]
The report listening rule response (B) is "[The actor] [listen].".  [was "[The actor] [listen]."]
The report tasting rule response (A) is "[We] [taste] nothing unexpected.".  [was "[We] [taste] nothing unexpected."]
The report tasting rule response (B) is "[The actor] [taste] [the noun].".  [was "[The actor] [taste] [the noun]."]
]

Section 16 - Cut, Jump, Tie, Drink, Sorry, Swing, Rub, Set, Wave, Buy, Climb, Sleep

The block cutting rule response (A) is "[We] [can't cut] [the noun][or that's not the way].".  [was "Cutting [regarding the noun][them] up [would achieve] little."]
The report jumping rule response (A) is "Jumping would have no effect[or that's not the way].".  [was "[We] [jump] on the spot."]

[
The report jumping rule response (B) is "[The actor] [jump] on the spot.".  [was "[The actor] [jump] on the spot."]
]

The block tying rule response (A) is "[We] [can't tie] [the noun] to [the second noun][or that's not the way].".  [was "[We] [would achieve] nothing by this."]
The block drinking rule response (A) is "[if noun is player][We] [can't] [the quoted verb] [ourselves].[otherwise if noun is a person][as the parser][We] [can't] [the quoted verb] [the noun].[as normal][otherwise][We] [can't] [the quoted verb] [the noun][or that's not the way].".  [was "[There's] nothing suitable to drink here."]
The block saying sorry rule response (A) is "Saying sorry here has no effect.".  [was "Oh, don't [if American dialect option is active]apologize[otherwise]apologise[end if]."]
The block swinging rule response (A) is "[We] [can't swing] [the noun][or that's not the way].".  [was "[There's] nothing sensible to swing here."]
The can't rub another person rule response (A) is "[as the parser][We] [don't need] to rub [if the noun is the player]yourself[else][the noun][end if].[as normal]".  [was "[The noun] [might not like] that."]

[
The report rubbing rule response (A) is "[We] [rub] [the noun].".  [was "[We] [rub] [the noun]."]
The report rubbing rule response (B) is "[The actor] [rub] [the noun].".  [was "[The actor] [rub] [the noun]."]
]

The block setting it to rule response (A) is "[We] [can't set] [the noun] to that[or that's not the way].".  [was "No, [we] [can't set] [regarding the noun][those] to anything."]

[
The report waving hands rule response (A) is "[We] [wave].".  [was "[We] [wave]."]
The report waving hands rule response (B) is "[The actor] [wave].".  [was "[The actor] [wave]."]
]

The block buying rule response (A) is "[We] [can't buy] [the noun][or that's not the way].".  [was "Nothing [are] on sale."]
The block climbing rule response (A) is "[regarding the noun][Those] [can't be] climbed in that way.  [as the parser]Sometimes a direction like 'up' or 'down' works instead.[as normal]".  [was "Little [are] to be achieved by that."]
The block sleeping rule response (A) is "[We] [can't sleep] right [now].".  [was "[We] [aren't] feeling especially drowsy."]

Section 17 - Visibility, Accessibility, Reachability

The adjust light rule response (A) is "[We] [can't see] anything.".  [was "[It] [are] [if story tense is present tense]now [end if]pitch dark in [if story tense is present tense]here[else]there[end if]!"]

[
The generate action rule response (A) is "(considering the first sixteen objects only)[command clarification break]".  [was "(considering the first sixteen objects only)[command clarification break]"]
The generate action rule response (B) is "Nothing to do!".  [was "Nothing to do!"]
]
[The generate action rule response (B) happens when we are generating objects from a multiple object list which has no objects in it.  It shouldn't fire.]

The basic accessibility rule response (A) is "[as the parser]Part of your command is not a physical part of the story world, so you can't act on it in that way.[as normal]".  [was "You must name something more substantial."]

[
The basic visibility rule response (A) is "[It] [are] pitch dark, and [we] [can't see] a thing.".  [was "[It] [are] pitch dark, and [we] [can't see] a thing."]
]

The requested actions require persuasion rule response (A) is "[We] [can't] order [the person asked] to do that[or that's not the way].".  [was "[The noun] [have] better things to do."]

[
The carry out requested actions rule response (A) is "[The person asked] [are] unable to do that.".  [was "[The noun] [are] unable to do that."]
The access through barriers rule response (A) is "[regarding the noun][Those] [aren't] available.".  [was "[regarding the noun][Those] [aren't] available."]
The can't reach inside closed containers rule response (A) is "[The noun] [aren't] open.".  [was "[The noun] [aren't] open."]
The can't reach inside rooms rule response (A) is "[We] [can't] reach into [the noun].".  [was "[We] [can't] reach into [the noun]."]
The can't reach outside closed containers rule response (A) is "[The noun] [aren't] open.".  [was "[The noun] [aren't] open."]
]

Section 18 - List writer internal rule

[This is all OK, no changes]

[
The list writer internal rule response (A) is " (".  [was " ("]
The list writer internal rule response (B) is ")".  [was ")"]
The list writer internal rule response (C) is " and ".  [was " and "]
The list writer internal rule response (D) is "providing light".  [was "providing light"]
The list writer internal rule response (E) is "closed".  [was "closed"]
The list writer internal rule response (F) is "empty".  [was "empty"]
The list writer internal rule response (G) is "closed and empty".  [was "closed and empty"]
The list writer internal rule response (H) is "closed and providing light".  [was "closed and providing light"]
The list writer internal rule response (I) is "empty and providing light".  [was "empty and providing light"]
The list writer internal rule response (J) is "closed, empty[if serial comma option is active],[end if] and providing light".  [was "closed, empty[if serial comma option is active],[end if] and providing light"]
The list writer internal rule response (K) is "providing light and being worn".  [was "providing light and being worn"]
The list writer internal rule response (L) is "being worn".  [was "being worn"]
The list writer internal rule response (M) is "open".  [was "open"]
The list writer internal rule response (N) is "open but empty".  [was "open but empty"]
The list writer internal rule response (O) is "closed".  [was "closed"]
The list writer internal rule response (P) is "closed and locked".  [was "closed and locked"]
The list writer internal rule response (Q) is "containing".  [was "containing"]
The list writer internal rule response (R) is "on [if the noun is a person]whom[otherwise]which[end if] ".  [was "on [if the noun is a person]whom[otherwise]which[end if] "]
The list writer internal rule response (S) is ", on top of [if the noun is a person]whom[otherwise]which[end if] ".  [was ", on top of [if the noun is a person]whom[otherwise]which[end if] "]
The list writer internal rule response (T) is "in [if the noun is a person]whom[otherwise]which[end if] ".  [was "in [if the noun is a person]whom[otherwise]which[end if] "]
The list writer internal rule response (U) is ", inside [if the noun is a person]whom[otherwise]which[end if] ".  [was ", inside [if the noun is a person]whom[otherwise]which[end if] "]
The list writer internal rule response (V) is "[regarding list writer internals][are]".  [was "[regarding list writer internals][are]"]
The list writer internal rule response (W) is "[regarding list writer internals][are] nothing".  [was "[regarding list writer internals][are] nothing"]
The list writer internal rule response (X) is "Nothing".  [was "Nothing"]
The list writer internal rule response (Y) is "nothing".  [was "nothing"]
]

Section 19 - Action processing internal rule

[Parser styling]

The action processing internal rule response (A) is "[as the parser]That command asks to do something outside of play, so it can only make sense from you to me. [The person asked] cannot be asked to do this.[as normal]".  [was "[bracket]That command asks to do something outside of play, so it can only make sense from you to me. [The noun] cannot be asked to do this.[close bracket]"]
The action processing internal rule response (B) is "[as the parser]You must name an object.[as normal]".  [was "You must name an object."]
The action processing internal rule response (C) is "[as the parser]You may not name an object.[as normal]".  [was "You may not name an object."]
The action processing internal rule response (D) is "[as the parser]You must supply a noun.[as normal]".  [was "You must supply a noun."]
The action processing internal rule response (E) is "[as the parser]You may not supply a noun.[as normal]".  [was "You may not supply a noun."]
The action processing internal rule response (F) is "[as the parser]You must name a second object.[as normal]".  [was "You must name a second object."]
The action processing internal rule response (G) is "[as the parser]You may not name a second object.[as normal]".  [was "You may not name a second object."]
The action processing internal rule response (H) is "[as the parser]You must supply a second noun.[as normal]".  [was "You must supply a second noun."]
The action processing internal rule response (I) is "[as the parser]You may not supply a second noun.[as normal]".  [was "You may not supply a second noun."]
The action processing internal rule response (J) is "[as the parser]Since something dramatic has happened, your list of commands has been cut short.[as normal]".  [was "(Since something dramatic has happened, your list of commands has been cut short.)"]
The action processing internal rule response (K) is "[as the parser]I didn't understand that instruction.[as normal]".
[N.B. - The above is the equivalent of "I didn't understand that sentence" if you ordered someone else to do it]

Section 20 - Parser error internal rule

[Parser styling.  Note that the parser will spit out a line break for these.]

The parser error internal rule response (A) is "[as the parser]I didn't understand that sentence.[as normal]".  [was "I didn't understand that sentence."]

[These two are partial sentences, so they are fixed in the next volume.]
[
The parser error internal rule response (B) is "I only understood you as far as wanting to ".  [was "I only understood you as far as wanting to "]
The parser error internal rule response (C) is "I only understood you as far as wanting to (go) ".  [was "I only understood you as far as wanting to (go) "]
]

The parser error internal rule response (D) is "[as the parser]I can't understand your entire command, though the first part matched an action I expected to include a number.[as normal]".  [was "I didn't understand that number."]

["You can't see any such thing" gets its own volume, because it really deserves a lot of disambiguation.]
[
The parser error internal rule response (E) is "[We] [can't] see any such thing.".  [was "[We] [can't] see any such thing."]
]

[This error message is unused, probably -- TOOLIT_PE is not called by the library -- unless NI generates it.]
The parser error internal rule response (F) is "[as the parser]You seem to have said too little.[as normal]".  [was "You seem to have said too little!"]
The parser error internal rule response (G) is "[We] [aren't] holding that."  [was "[We] [aren't] holding that!"]
The parser error internal rule response (H) is "[as the parser]You can't use multiple objects with that verb.[as normal]".  [was "You can't use multiple objects with that verb."]
The parser error internal rule response (I) is "[as the parser]You can only use multiple objects once on a line.[as normal]".  [was "You can only use multiple objects once on a line."]
The parser error internal rule response (J) is "[as the parser]I'm not sure what ['][pronoun i6 dictionary word]['] refers to.[as normal]".  [was "I'm not sure what ['][pronoun i6 dictionary word]['] refers to."]
The parser error internal rule response (K) is "[as the parser][We] [can't] see ['][pronoun i6 dictionary word]['] ([the noun]) at the moment.[as normal]".  [was "[We] [can't] see ['][pronoun i6 dictionary word]['] ([the noun]) at the moment."]
The parser error internal rule response (L) is "[as the parser]You excepted something not included anyway.[as normal]".  [was "You excepted something not included anyway!"]
The parser error internal rule response (M) is "[as the parser]You can only do that to something animate.[as normal]".  [was "You can only do that to something animate."]
The parser error internal rule response (N) is "[as the parser]The word '[the quoted verb]' is not a verb I [if American dialect option is active]recognize[otherwise]recognise[end if].[as normal]".  [was "That's not a verb I [if American dialect option is active]recognize[otherwise]recognise[end if]."]
[This error message is unused, probably -- SCENERY_PE is not called by the library -- unless NI generates it.]
The parser error internal rule response (O) is "[as the parser]That's not something you need to refer to in the course of this story.[as normal]".  [was "That's not something you need to refer to in the course of this game."]
[This error message is unused, probably -- JUNKAFTER_PE is not called by the library -- unless NI generates it.]
The parser error internal rule response (P) is "[as the parser]I didn't understand the way that finished.[as normal]".  [was "I didn't understand the way that finished."]
The parser error internal rule response (Q) is "[as the parser][if number understood is 0]None[otherwise]Only [number understood in words][end if] of those [regarding the number understood][are] available.[as normal]".  [was "[if number understood is 0]None[otherwise]Only [number understood in words][end if] of those [regarding the number understood][are] available."]
The parser error internal rule response (R) is "[as the parser]That noun did not make sense in this context.[as normal]".  [was "That noun did not make sense in this context."]
The parser error internal rule response (S) is "[as the parser]To repeat a command like 'frog, jump', just say 'again', not 'frog, again'.[as normal]".  [was "To repeat a command like 'frog, jump', just say 'again', not 'frog, again'."]
The parser error internal rule response (T) is "[as the parser]You can't begin a command with a comma.[as normal]".  [was "You can't begin with a comma."]
The parser error internal rule response (U) is "[as the parser]In some stories you can type 'character, command' to give someone else an order; but I couldn't understand what you said in that context.[as normal]".  [was "You seem to want to talk to someone, but I can't see whom."]
The parser error internal rule response (V) is "[as the parser]You can't talk to [the noun].[as normal]".  [was "You can't talk to [the noun]."]
The parser error internal rule response (W) is "[as the parser]In some stories, you can type 'character, command' to give someone else an order; but I couldn't understand some of what you said before the comma in that context.[as normal]".  [was "To talk to someone, try 'someone, hello' or some such."]
The parser error internal rule response (X) is "[as the parser]No command given.[as normal]".  [was "I beg your pardon?"]

Section 21 - Parser nothing error internal rule

[Error A is only triggered on "get 100 items" commands, and is clearly a programming bug in the I6 template code.  Redirect it to the other one.]
The parser nothing error internal rule response (A) is "[text of the parser nothing error internal rule response (B)]".  [was "Nothing to do!"]
The parser nothing error internal rule response (B) is "[as the parser][if command includes except]That excludes everything.[otherwise]There is nothing available to [the quoted verb].[end if][as normal]".  [was "[There] [adapt the verb are from the third person plural] none at all available!"]

[This short class of errors handles "Remove" actions, and mimics the responses for "take" actions.  No changes needed.]
[
The parser nothing error internal rule response (C) is "[regarding the noun][Those] [seem] to belong to [the noun].".  [was "[regarding the noun][Those] [seem] to belong to [the noun]."]
The parser nothing error internal rule response (D) is "[regarding the noun][Those] [can't] contain things.".  [was "[regarding the noun][Those] [can't] contain things."]
The parser nothing error internal rule response (E) is "[The noun] [aren't] open.".  [was "[The noun] [aren't] open."]
The parser nothing error internal rule response (F) is "[The noun] [are] empty.".  [was "[The noun] [are] empty."]
]

Section 21 - Darkness name

[
The darkness name internal rule response (A) is "Darkness".  [was "Darkness"]
]

Section 22 - Oops, Again

The parser command internal rule response (A) is "[as the parser]Nothing to correct.  To correct a single misunderstood word in the last command, type 'oops' or 'o' followed by a word.[as normal]".  [was "Sorry, that can't be corrected."]
The parser command internal rule response (B) is "[as the parser]Nothing to correct.  To correct a single misunderstood word in the last command, type 'oops' or 'o' followed by a word.[as normal]".  [was "Think nothing of it."]
The parser command internal rule response (C) is "[as the parser]Too many words. To correct a single misunderstood word in the last command, type 'oops' or 'o' followed by a word.[as normal]".  [was "'Oops' can only correct a single word."]
The parser command internal rule response (D) is "[as the parser]There is not a command to repeat.[as normal]".  [was "You can hardly repeat that."]

Section 23 - Parser Clarification

[These two can't be parser styled due to failure to expose the trailing question mark.  TODO.]
[
The parser clarification internal rule response (A) is "Who do you mean, ".  [was "Who do you mean, "]
The parser clarification internal rule response (B) is "Which do you mean, ".  [was "Which do you mean, "]
]

The parser clarification internal rule response (C) is "[as the parser]Sorry, you can only have one item here. Which exactly?[as normal]".  [was "Sorry, you can only have one item here. Which exactly?"]
The parser clarification internal rule response (D) is "[as the parser]Whom do you want [if the noun is not the player][the noun] [end if]to [parser command so far]?[as normal]".  [was "Whom do you want [if the noun is not the player][the noun] [end if]to [parser command so far]?"]
The parser clarification internal rule response (E) is "[as the parser]What do you want [if the noun is not the player][the noun] [end if]to [parser command so far]?[as normal]".  [was "What do you want [if the noun is not the player][the noun] [end if]to [parser command so far]?"]
The parser clarification internal rule response (F) is "those things".  [was "those things"]
The parser clarification internal rule response (G) is "that".  [was "that"]
The parser clarification internal rule response (H) is " or ".  [was " or "]

Section 24 - Yes or No

The yes or no question internal rule response (A) is "[as the parser]Please answer yes or no.[as normal]".  [was "Please answer yes or no."]

Section 25 - Protagonist, Implicit Taking, Obituary

[
The print protagonist internal rule response (A) is "[We]".  [was "[We]"]
The print protagonist internal rule response (B) is "[ourselves]".  [was "[ourselves]"]
The print protagonist internal rule response (C) is "[our] former self".  [was "[our] former self"]
]

The standard implicit taking rule response (A) is "(first taking [the noun])[single action command clarification break]".  [was "(first taking [the noun])[command clarification break]"]
The standard implicit taking rule response (B) is "([the second noun] first taking [the noun])[single action command clarification break]".  [was "([the second noun] first taking [the noun])[command clarification break]"]

[
The print obituary headline rule response (A) is " You have died ".  [was " You have died "]
The print obituary headline rule response (B) is " You have won ".  [was " You have won "]
The print obituary headline rule response (C) is " The End ".  [was " The End "]
]

Section 26 - Undo, Quit, Save, Restore, Verify, Transcript

The immediately undo rule response (A) is "[as the parser]You can't 'undo' in this story.[as normal]".  [was "The use of 'undo' is forbidden in this story."]
The immediately undo rule response (B) is "[as the parser]You can't 'undo' on the first turn.[as normal]".  [was "You can't 'undo' what hasn't been done!"]
The immediately undo rule response (C) is "[as the parser]Your interpreter does not provide 'undo'.[as normal]".  [was "Your interpreter does not provide 'undo'. Sorry!"]
The immediately undo rule response (D) is "[as the parser]'Undo' failed.[as normal]".  [was "'Undo' failed. Sorry!"]
The immediately undo rule response (E) is "[as the parser]Previous turn undone.[as normal]".  [was "[bracket]Previous turn undone.[close bracket]"]
The immediately undo rule response (F) is "[as the parser]Can't 'undo' any more times.[as normal]".  [was "'Undo' capacity exhausted. Sorry!"]

[Prompt -- can't be put in brackets]
[
The quit the game rule response (A) is "Are you sure you want to quit? ".  [was "Are you sure you want to quit? "]
]

The save the game rule response (A) is "[as the parser]Save failed.[as normal]".  [was "Save failed."]
The save the game rule response (B) is "[as the parser]Ok.[as normal]".  [was "Ok."]
The restore the game rule response (A) is "[as the parser]Restore failed.[as normal]".  [was "Restore failed."]
The restore the game rule response (B) is "[as the parser]Ok.[as normal]".  [was "Ok."]

[Prompt -- can't be parser-styled]
[
The restart the game rule response (A) is "Are you sure you want to restart? ".  [was "Are you sure you want to restart? "]
]

The restart the game rule response (B) is "[as the parser]Failed.[as normal]".  [was "Failed."]
The verify the story file rule response (A) is "[as the parser]The story file has verified as intact.[as normal]".  [was "The game file has verified as intact."]
The verify the story file rule response (B) is "[as the parser]The story file did not verify as intact, and may be corrupt.[as normal]".  [was "The game file did not verify as intact, and may be corrupt."]
The switch the story transcript on rule response (A) is "[as the parser]Transcripting is already on.[as normal]".  [was "Transcripting is already on."]
The switch the story transcript on rule response (B) is "Start of a transcript of".  [was "Start of a transcript of"]
The switch the story transcript on rule response (C) is "[as the parser]Attempt to begin transcript failed.[as normal]".  [was "Attempt to begin transcript failed."]
The switch the story transcript off rule response (A) is "[as the parser]Transcripting is already off.[as normal]".  [was "Transcripting is already off."]
The switch the story transcript off rule response (B) is "[line break]End of transcript.".  [was "[line break]End of transcript."]
The switch the story transcript off rule response (C) is "[as the parser]Attempt to end transcript failed.[as normal]".  [was "Attempt to end transcript failed."]

Section 27 - The Score

[The final score is broken into parts and requires a complex fix to be parser-styled, fixed in the next volume]

The announce the score rule response (A) is "[if the story has ended]In that story you scored[otherwise]You have so far scored[end if] [score] out of a possible [maximum score], in [turn count] turn[s]".  [was "[if the story has ended]In that game you scored[otherwise]You have so far scored[end if] [score] out of a possible [maximum score], in [turn count] turn[s]"]

[
The announce the score rule response (B) is ", earning you the rank of ".  [was ", earning you the rank of "]
]

The announce the score rule response (C) is "[as the parser][There] [are] no score in this story.[as normal]".  [was "[There] [are] no score in this story."]
The announce the score rule response (D) is "[as the parser]Your score has just gone up by [number understood in words] point[s].[as normal]".  [was "[bracket]Your score has just gone up by [number understood in words] point[s].[close bracket]"]
The announce the score rule response (E) is "[as the parser]Your score has just gone down by [number understood in words] point[s].[as normal]".  [was "[bracket]Your score has just gone down by [number understood in words] point[s].[close bracket]"]

Section 28 - Verbose, Brief, Superbrief

[This is another case of partial sentences, fixed in the next volume]
[
The standard report preferring abbreviated room descriptions rule response (A) is " is now in its 'superbrief' mode, which always gives short descriptions of locations (even if you haven't been there before).".  [was " is now in its 'superbrief' mode, which always gives short descriptions of locations (even if you haven't been there before)."]
The standard report preferring unabbreviated room descriptions rule response (A) is " is now in its 'verbose' mode, which always gives long descriptions of locations (even if you've been there before).".  [was " is now in its 'verbose' mode, which always gives long descriptions of locations (even if you've been there before)."]
The standard report preferring sometimes abbreviated room descriptions rule response (A) is " is now in its 'brief' printing mode, which gives long descriptions of places never before visited and short descriptions otherwise.".  [was " is now in its 'brief' printing mode, which gives long descriptions of places never before visited and short descriptions otherwise."]
]

Section 29 - Score notification

The standard report switching score notification on rule response (A) is "[as the parser]Score notification on.[as normal]".  [was "Score notification on."]
The standard report switching score notification off rule response (A) is "[as the parser]Score notification off.[as normal]".  [was "Score notification off."]

Section 30 - Pronoun meanings

[This is another case of partial sentences, fixed in the next volume]
[
The announce the pronoun meanings rule response (A) is "At the moment, ".  [was "At the moment, "]
The announce the pronoun meanings rule response (B) is "means ".  [was "means "]
The announce the pronoun meanings rule response (C) is "is unset".  [was "is unset"]
]

The announce the pronoun meanings rule response (D) is "no pronouns are known to the story.".  [was "no pronouns are known to the game."] [Used for languages without pronouns]


Volume - Replace partial-sentence messages with full-sentence messages

Chapter - As far as parser error

[To repeat: These two are, annoyingly, PARTIAL sentences.]
[
The parser error internal rule response (B) is "I only understood you as far as wanting to ".  [was "I only understood you as far as wanting to "]
The parser error internal rule response (C) is "I only understood you as far as wanting to (go) ".  [was "I only understood you as far as wanting to (go) "]
]

For printing a parser error while the latest parser error is the only understood as far as error (this is the only understood as far as rule):
	say "[as the parser]I can't understand your entire command.  The first part looked like the command '[the command understood so far]', but I didn't expect the word '[the extraneous word]' next.[as normal][line break]" (A);

Chapter - Announcing the Score

[As an exercise in masochism, we roll up our sleeves for the unpleasant plumbing involved in making the score command be styled correctly. Since the standard rules hard-code printing a period and line break into the obscure PrintRank routine, of all places, we have to do some ugly trickery to make this work.]

[First:
- replace PrintRank with PrintRankName which only prints the name of the rank
- expose whether there is a rank table
]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: Print Rank replacement work
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

[ PrintRankName i j v;
  if (KIT_CONFIGURATION_BITMAP & RANKING_TABLE_TCBIT) {
    j = TableRows(RANKING_TABLE);
    for ( i=j:i>=1:i-- )
			if (score >= TableLookUpEntry(RANKING_TABLE, 1, i)) {
        v = TableLookUpEntry(RANKING_TABLE, 2, i);
        TEXT_TY_Say(v);
        return;
	    }
  }
];
-)

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: Print Rank replacement work
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

[ DoesRankingTableExist; 
  if (KIT_CONFIGURATION_BITMAP & RANKING_TABLE_TCBIT) {
		return true;
	} else {
		return false;
	}
];

-)

[Second: wrap these I6 routines in I7 phrases]

To decide whether the table of rankings exists:
	(- DoesRankingTableExist() -)

To say current rank name:
	(- PrintRankName(); -)

[Finally: replace the score announcement rule.]

The full-sentence announce the score rule is listed instead of the announce the score rule in the carry out requesting the score rulebook.

This is the full-sentence announce the score rule:
	if the actor is the player:
		if the scoring option is active:
			if the table of rankings exists:
				say "[as the parser][text of the announce the score rule response (A)][text of the announce the score rule response (B)][current rank name].[run paragraph on][as normal][line break]" (B);
			otherwise:
				say "[as the parser][text of the announce the score rule response (A)].[as normal][line break]" (C);
		otherwise:
			[For bizarre reasons, this one needs a line break, though the one which responds to "nofity on" does not.  Context, I guess.]
			say "[text of the announce the score rule response (C)][line break]" (A);

Chapter - Brief, Verbose, Superbrief

[Much easier than announcing the score.]

The full-sentence report preferring sometimes abbreviated room descriptions rule is listed
	instead of the standard report preferring sometimes abbreviated room descriptions rule
	in the report preferring sometimes abbreviated room descriptions rulebook.

This is the full-sentence report preferring sometimes abbreviated room descriptions rule:
	if the actor is the player:
		say "[as the parser][The story title][text of the standard report preferring sometimes abbreviated room descriptions rule response (A)][as normal][line break]" (A);

The full-sentence report preferring unabbreviated room descriptions rule is listed
	instead of the standard report preferring unabbreviated room descriptions rule
	in the report preferring unabbreviated room descriptions rulebook.
	
This is the full-sentence report preferring unabbreviated room descriptions rule:
	if the actor is the player:
		say "[as the parser][The story title][text of the standard report preferring unabbreviated room descriptions rule response (A)][as normal][line break]" (A);

The full-sentence report preferring abbreviated room descriptions rule is listed
	instead of the standard report preferring abbreviated room descriptions rule
	in the report preferring abbreviated room descriptions rulebook.

This is the full-sentence report preferring abbreviated room descriptions rule:
	if the actor is the player:
		say "[as the parser][The story title][text of the standard report preferring abbreviated room descriptions rule response (A)][as normal][line break]" (A);

Chapter - Requesting the Pronoun Meanings

[This is a complicated construction.  To do this, access the I6 code as a phrase instead of a rule.  In order to avoid a spurious line break we must duplicate all the I6 code. This is the code of
ANNOUNCE_PRONOUN_MEANINGS_R except for the one change.]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Neutral Standard Responses.i7x: Announce Pronoun Meanings
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====

[ AnnouncePronounMeanings x y c d;
  if (actor ~= player) rfalse;
  ANNOUNCE_PRONOUN_MEANINGS_RM('A');

  c = (LanguagePronouns-->0)/3;
  if (player ~= selfobj) c++;

  if (c==0) { ANNOUNCE_PRONOUN_MEANINGS_RM('D'); rtrue; }

  for (x = 1, d = 0 : x <= LanguagePronouns-->0: x = x+3) {
    print "~", (address) LanguagePronouns-->x, "~ ";
    y = LanguagePronouns-->(x+2);
    if (y == NULL) ANNOUNCE_PRONOUN_MEANINGS_RM('C');
    else { ANNOUNCE_PRONOUN_MEANINGS_RM('B'); print (the) y; }
    d++;
    if (d < c-1) print ", ";
    if (d == c-1) {
      if (KIT_CONFIGURATION_BITMAP & SERIAL_COMMA_TCBIT) print ",";
      LIST_WRITER_INTERNAL_RM('C');
    }
  }
  if (player ~= selfobj) {
    print "~", (address) ME1__WD, "~ "; ANNOUNCE_PRONOUN_MEANINGS_RM('B');
    c = player; player = selfobj;
    print (the) c; player = c;
  }
  print "."; ! This is the only change made by Neutral Standard Responses
];
-)

To say statement of pronoun meanings:
	(- AnnouncePronounMeanings(); -)
	
The full-sentence announce the pronoun meanings rule is listed
	instead of the announce the pronoun meanings rule
	in the carry out requesting the pronoun meanings rulebook.

This is the full-sentence announce the pronoun meanings rule:
		say "[as the parser][statement of pronoun meanings][as normal][line break]".

Volume - Player Description

[Authors can easily override the description of the player, but extension authors can't without tromping on the final author's ability to (since you can't have two "usually" or two "is" lines). Bother. The only line changed in this block is the description of yourself property. ]

Chapter 1 - Without Gender Options (for use without Gender Options by Nathanael Nerode)
[Gender Options rewrites this section heavily; we need to not touch its version.
Gender Options will accomodate us.]

Section 11 - People (in place of Section 11 - People in Standard Rules by Graham Nelson) 

The specification of person is "Despite the name, not necessarily
a human being, but anything animate enough to envisage having a
conversation with, or bartering with."

A person can be female or male. A person is usually male.
A person can be neuter. A person is usually not neuter.

A person has a number called carrying capacity.
The carrying capacity of a person is usually 100.

A person can be transparent. A person is always transparent.

The yourself is an undescribed person. The yourself is proper-named.

The yourself is privately-named.
Understand "your former self" or "my former self" or "former self" or
  "former" as yourself when the player is not yourself.

The yourself object translates into Inter as "selfobj".

Chapter 2 - Always Active

Section SR2.2.11A - Player Description

The description of yourself is usually "[We] [see] nothing unexpected about [ourselves]." ["As good-looking as ever."]

Volume - You Can't See Any Such Thing

Chapter - Order of parser error rulebook

The traditional can't see any such thing rule is listed last in the for printing a parser error rulebook.  [3rd to last]
The command includes word not in scope rule is listed last in the for printing a parser error rulebook. [2nd to last]
The command includes word not in dictionary rule is listed last in the for printing a parser error rulebook.  [Last]

Chapter - Traditional can't see any such thing rule

[For those story authors who do not want to explain what words are not in the dictionary.]

Use traditional can't see any such thing translates as (- Constant TRADITIONAL_CANT_SEE; -).

Rule for printing a parser error when the latest parser error is the can't see any such thing error and the traditional can't see any such thing option is active (this is the traditional can't see any such thing rule):
	say "[ text of the parser error internal rule response (E) ]";
	restore the oops target;

Chapter - Commmand includes word not in scope rule

[It's a bit silly to check whether the misunderstood word is in the dictionary twice, in two rules, but it's cheap code so we do this the "clean" way.]

Rule for printing a parser error when the latest parser error is the can't see any such thing error and the misunderstood word is in the dictionary (this is the command includes word not in scope rule):
	say "[We] [can't] see anything called '[the misunderstood word]' right [now].  [as the parser]Or I misunderstood you.[no line break][as normal][line break]" (A);
	restore the oops target;

Chapter - Command includes word not in dictionary rule

[It's a bit silly to check whether the misunderstood word is in the dictionary twice, in two rules, but it's cheap code so we do this the "clean" way.]

Rule for printing a parser error when the latest parser error is the can't see any such thing error and the misunderstood word is not in the dictionary (this is the command includes word not in dictionary rule):
	if the misunderstood word is out of range: [Could happen]
		continue the activity;
	say "[as the parser]You don't need to use the word '[the misunderstood word]' in this story.[as normal][line break]" (A);
	restore the oops target;

[Theoretically you could fall through if the misunderstood word is out of range -- but you shouldn't get a CANT_SEE error in that case.  If this happens it'll fall back to the traditional "You can't see any such thing."]

Volume - Fix Remove Action

[We have to patch a nasty bug in the Standard Rules.  Because the grammar lines don't recognize "remove [thing not inside] from [container]", the check rules for Remove never trigger, and it defaults to "you can't see any such thing"!  We displace the bad "things inside" token with "things", and then introduce a rule for "all" to prevent it from including things not on the table.]

Understand "take [things] from [something]" as removing it from.
Understand "take [things] off [something]" as removing it from.
Understand "get [things] from [something]" as removing it from.
Understand "remove [things] from [something]" as removing it from.

Rule for deciding whether all includes a thing (called item) while removing (this is the don't remove things not there rule):
	if the holder of the item is not the second noun:
		it does not;
	otherwise:
		make no decision;

Volume - Enhanced oops

Section - Set oops target on verb I don't understand error

[The standard rules fail to set the oops word here.]

Rule for printing a parser error when the latest parser error is the not a verb I recognise error (this is the enhanced not a verb I recognise rule):
	say "[text of the parser error internal rule response (N)][line break]" (A);
	set the oops target to the verb;

Section - Set oops target on can't see who to talk to error

Rule for printing a parser error when the latest parser error is the can't see whom to talk to error (this is the enhanced can't see who to talk to rule):
	say "[text of the parser error internal rule response (U)][line break]" (A);
	set the oops target to word one;

Neutral Standard Responses ends here.

---- DOCUMENTATION ----

Every Inform project contains dozens of sentences of text not written by the project's author, which explain the results of actions or refuse to carry out commands that aren't understood or that contradict the world model. The default set of these library messages, which have accumulated like barnacles on the interactive fiction community since its maiden voyages in the 1970s, contains many misleading, distracting, or unhelpful texts that experienced players see past but newcomers stumble over. This extension replaces the worst offenders with more neutral or helpful variations.

Simply including the extension is all that is necessary. Read on only if you're interested in the gory details.

Section - Rationale

The main complaints levied against the standard reponses are:

They sometimes imply a certain tone of wry amusement which descends from the Infocom/text adventure era, and which is not always appropriate to modern works of IF.
	
There is not a clear distinction between messages narrating story world events and those giving parser refusals, leading to a muddying of the difference between the author's voice and the default system messages.
	
Error messages often do not contain information instructing players how to better restate their command.
	
They can sometimes contradict the story world, as in the assumption "That's plainly inedible," or mislead the player about a course of action, as in "This dangerous act would achieve little."
	
Inconsistencies in style, such as whether command examples are given in CAPS or 'quotes', or which messages are wrapped in square brackets and what that signifies.

The extension attempts to address all of these concerns as much as possible. Jokes or insults have been replaced by more neutral responses.  Many error messages have been rephrased to more clearly state what confused the parser or instruct the player towards a better command to try. Messages that make assumptions about the player's intentions or the world model have been softened so as not to appear incongruous with the story. All command examples are now given in 'quote' format.  And by default, all parser / out-of-world messages are wrapped in brackets and put in italics.

Section - Noncommittal responses

Many of the replacement responses in this extension are deliberately noncommittal, in order to be appropriate no matter what the story author is doing.  This is in order to deal with commands like "pick up Fred", where the player may be using it in a metaphorical way and the story author may want the player to go through the steps of seducing Fred.  Or "attack box", where the story author may want the player to be more specific about how to attack the box.  These responses in this extension often use the following two phrases:
	To say or that's not the way: say ", or [regarding nothing]that [aren't] the way to do so".  [this is ", or that's not the way to do so" in the present tense]
	To say or it's the wrong time: say " in these circumstances".
	
If you want to be more definite about telling the player that she is unable to do things, you can blank these out:
	To say or that's not the way: do nothing.
	To say or it's the wrong time: do nothing.

Section - Parser Style versus Story Style

Whether a message comes from the parser or the story narrator is something of an existential or aesthetic question in some cases: is "But you aren't on the sofa at the moment" a parser objection or a narrator observation?

The rule in this extension is that only out-of-world, metatextual responses are "parser messages".  This consists of responses which break the fourth wall by talking about the command line, saving, restoring, undoing, or talking about what is permitted in the story.  So "You hear nothing unexpected" and "You aren't holding the apple" are both story messages, while "You don't need to use the word 'xxx' in this story" is a parser message.

Parser messages are styled using a pair of phrases, which must always be used as a pair:
	"[as the parser]I didn't understand that command.[as normal]"

These are the default definitions:
	To say as the parser -- beginning say_as_the_parser: say "[italic type][bracket]".
	To say as normal -- ending say_as_the_parser: say "[close bracket][roman type]".
	
To override this, use code like the following:

	To say as the parser -- beginning say_as_the_parser: say "[bold type]The parser says: '".
	To say as normal -- ending say_as_the_parser: say "'[roman type]".
	
These say statements may be used in your own text to style parser messages.  With a bracket following a period at the end of a sentence, Inform's line breaking algorithm gets confused, so it's often necessary to write:
	say "[as the parser]Hi, I'm the parser.[no line break][as normal][line break]".

Or if you're running the paragraph on:
	say "[as the parser]Hi, I'm the parser.[no line break][as normal]".
	
One final subtlety:  if you're responding to an action like "take" which has a paragraph break after "take one thing" but not after each line in "take all", you'll want to use an additional phrase "single action conditional paragraph break" (see the section on line breaking):
	say "[as the parser]You shouldn't try to take that in this story.[as normal][single action conditional paragraph break]";

Section - Overriding Responses

If you don't want parser messages to be styled differently from other library messages:
	To say as the parser -- beginning say_as_the_parser: do nothing.
	To say as normal -- ending say_as_the_parser: do nothing.

Of course, all responses can be individually overridden using the usual responses system.

Section - Use Different Line Breaking in Multiple Object Lists

This extension provides several utility phrases to allow you to make the same text line-break correctly both for multiple action reports like:
	the box: (putting the toy in the holdall to make room) Taken.
	the cat: You can't take the cat.
	
	>

And on single action reports like:
	(putting the toy in the holdall to make room)
	Taken.
	
	>

The say phrases available are:

	single action line break

This is a line break if doing a single action, and no line break if doing multiple actions.  I haven't actually found a use for this:

	single action conditional paragraph break

This is a conditional paragraph break only if there is a single action.  This corrects the report for:
	the box: You can't boil the box.
	the cat: Boiled.

	single action paragraph break

This is a paragraph break only if there is a single action.  I haven't actually found a use for this, as the single action conditional paragraph break is more useful.

	multiple action run paragraph on

This could be used where Inform really wants to break the paragraph.  For multiple actions, it runs the paragraph on; for single actions, it doesn't.  I haven't found a use for this either.

	single action command clarification break

This is one space if doing multiple actions, and otherwise a command clarification break.  The purpose of this is specifically to avoid a line break in the following:
	the box: (Putting the toy in the holdall to take room) Taken.

It should generally be used only for such situations.
 
Section - You can't see any such thing

The message "You can't see any such thing." is traditionally printed in many circumstances.  Part of the difficulty is the wide variety of circumstances it can appear under. From the player's perspective, this message appears when she tries to use a verb with
	a) something neither mentioned nor implemented (like the sky)
	b) something mentioned in descriptive text but not implemented
	c) something implemented but not given the specific word used as a synonym
	d) a misspelled word
	e) a word mistakenly understood as part of the direct object, rather than part of the grammar line, as in >TAKE INVENTORY NOW which is matched as {take | inventory now}.
	f) something that exists but has never been seen and is not in scope
	g) something previously seen but no longer in scope, perhaps without the player realizing it's no longer available

In nearly all of these cases, the player believes the object they're referring to should exist, meaning the message is often frustrating. 

Distinguishing between these subtle cases can be difficult. For instance, short of capturing all text output and analyzing it, there is no way to distinguish A from B. Perhaps the easiest distinction to make is between commands containing dictionary words and those that don't, which separates A-D from E-G.

This extension, by default, explicitly tells the player if a word they typed is not in the story's dictionary. The classic argument against this, that sneaky players can use it to figure out the existence of yet-unseen objects, seems less relevant today than it did when puzzles comprised most IF content (not to mention having something of a nanny-state quality, like a novelist hovering around ensuring readers don't flip ahead and see IMPORTANT NOUNS they aren't supposed to know about yet). Perhaps a more relevant objection is that messages of this sort can make the parser seem primitive ("I don't know the word 'love.'")  I believe the benefit to players of knowing that a command didn't work because a certain word isn't important (rather than wondering if it's just not in scope, or they misspelled it, or they typed it in the wrong spot in the grammar line) outweighs these concerns, and I've attempted to make the message prescriptive rather than expository: "You don't need to use the word 'love' in this story." However, if you'd like to restore the traditional behavior, you can do so with 'Use traditional can't see any such thing'.

If the parser fails because it doesn't recognize a word, this extension will give an informative error message like:
	"[You don't need to use the word 'kludge' in this story.]"

You can change this to, for instance, the traditional Infocom-style message as follows:
	The command includes word not in dictionary rule response (A) is "I don't know the word '[word at position N]'".

In the response's context, "word at position N" is the first non-dictionary word.
This helps out players who know not to try the word again.

If the word is recognized but out of scope, the parser will instead say:
	"You can't see anything called 'kludge' right now.  [Or I misunderstood you.]"

You can change this as follows:
	The command includes word not in scope rule response (A) is "Naughty player, referring to things you can't see such as [the misunderstood word]."

In the response's context, "the misunderstood word" is the first word not understood by the parser; it's the word which will be replaced by "oops".
In certain responses, this isn't valid; use "the extraneous word" instead in those responses.

If you want to conceal from the player which words are understood, you can restore the default Inform 7 message:
	You can't see any such thing.

by using the option
	Use traditional can't see any such thing.
	
In addition, the Standard Rules have a bug in the 'remove thing from container' implementation which results in "You can't see any such thing" being printed for items which are visible but not inside the container.  This extension fixes this bug and gives the proper responses for that case.  This is fixed whether or not you "Use traditional can't see any such thing".

Section - Further ideas for 'You can't see any such thing'

Several additional extensions can help break things down further. "Remembering" carves off G from E-F, while "Poor Man's Mistype" can sometimes address D. "Smarter Parser" can sometimes offer helpful messages for certain types of A command related to body parts and common environmental features like the sky. Eric Eve's Text Capture could be a tool in distinguishing A from B.

"The word 'sky' doesn't refer to anything right now" is used by TADS3.

Another option is "Here are some things you can see: [the list of visible things which are not the player]."

Section - Compatibility with Other Extensions

This incorporates, and updates, the entirety of Neutral Library Messages by Aaron Reed, Unknown Word Error by Mike Ciel, Unknown Word Error by Neil Cerutti, and Dunno by Neil Cerutti.  It is incompatible with all of these extensions; do not include them.

Some of the response replacements, particularly those where multiple responses were used to build a single sentence, were significantly more difficult to implement than others and involved hacking into I6 code.  These are in separate volumes and chapters; these can be individually replaced if they are causing trouble.  The "Standard Responses" volume should be safe in any case.

I strongly recommend the "Tab Removal" extension.  This replaces tabs with spaces in commands typed by the player.  Without it, error messages for commands containing tabs are quite cryptic.

The "Compliant Characters" extension depends on Neutral Standard Messages.  It enhances error messages for commands given to other characters.  With Compliant Characters, if the persuasion rules succeed a command like
	Jane, take blox

will give a response like
	[You don't need to use the word "blox" in this story.]

or
	Jane already has that.

or
	Jane can't take that because that seems to belong to you.

instead of the unhelpful default:
	Jane is unable to do that.

Compliant Characters is a separate extension because it is intended for stories where you want the *story* to give responses to mistyped or illogical commands, while some games may prefer that the *character* give responses in character (which is the Inform 7 default assumption).

Section - Extension History

This extension is based on Neutral Library Messages by Aaron Reed.  Aaron wrote many of the changed responses.  Aaron also wrote most of the documentation (athough I have made some substantial edits).  However, Neutral Library Messages stopped working when Inform 7 created the "responses" system.  Adapting to the responses system required a nearly complete rewrite.

I (Nathanael Nerode) took the opportunity of the rewrite to do a complete reorganization.  The response replacements are now in the source code in the order produced by the "responses 1" command, for ease of updating with future versions of Inform.  Additional messages were fixed and some of Aaron's neutral messages were made even more neutral.

I also made one philosophical design change.  Messages are styled "as the parser" if they are metatextual.  Discussing save, restore, undo, or command errors is metatextual: these are things which explicitly talk to the player and not to the player character.  Telling the player that the player does not need to do something in this story is also metatextual -- giving the player meta-information.  Messages are not styled as the parser if they reflect logical errors which the player character might make which are within the world model (such as trying to put a box inside itself), which they were in Aaron's version.

Section - Changelogs

Neutral Standard Responses:
	Version 5.0.220521: adapt to Inform v10.1.0.
	Version 4/210908: in several rule responses, changed "here" to "[here]" (which will only ever matter outside of present tense) -- ZL
	Version 4/171007:
		Add line break helper phrases and documentation.  Fix several tricky line break errors correctly (including some from the Standard Rules).
		New and much better I6 method for determining the misunderstood word and for determining whether it is a dictionary word.
		Major fixes to "You can't see that" responses.  Fix error on "take all but (item not in play)".
		Repair bug in the Standard Rules implementation of Remove (which gave misleading error messages).
		Set oops target on additional errors which didn't set it.
	Version 3/171002: Line break fix.
	Version 3/171001: Remove parser voicing from attack, throw, and kiss.  Name the unrecognized verb in the error message.  Redirect bogus message triggered only on 'get 100 items'.
	Version 3/170927: Fixes to two bugs reported by Daniel Stelzer.
	Version 3/170926: Incorporated remaining "difficult" features of Neutral Library Messages.
	Version 2: Unreleased: complete code rewrite to improve maintainability, included all straightforward message replacements.
	Version 1: Unreleased: adapted Neutral Library Messages to responses system.

Neutral Library Messages:
	Version 3: Modified NPC action rejections to use the same verb the player typed in cases where this could be confusing (hug mapping to kiss).
	Version 2: Fixed bug in misc message 72 to use "the person asked" instead of "the noun"; clarified documentation.

Unknown Word Error:
	Version 2 by Mike Ciul corrected a problem with the "undo from" referent.
	Version 1 by Neil Cerutti was a wrapper of Dunno.

Dunno - A Library Extension by Neil Cerutti (cerutti@together.net) for Inform 6
	Version 1.1 - 2 Apr 2001: Modified by Andrew Plotkin for Glulx compatibility.
	Version 1.0 - 25 Jun 1999: Initial release.

Example: * The Ringer - An array of different types of messages, both from the parser and the narrator. (From Neutral Library Messages)

	*: "The Ringer"

	Include Neutral Standard Responses by Nathanael Nerode.

	To say as the parser -- beginning say_as_the_parser: say "<<".
	To say as normal -- ending say_as_the_parser: say ">>".

	Stage is a room. A big cat and a small cat and a bat are in Stage. A platform is an enterable supporter in Stage. A box is a closed openable container on platform. In the box is an apple. The player wears an ascot.
	
	To sing is a verb.
	Singing is an action applying to nothing.
	Understand "sing" as singing.

	Check singing when player does not hold platform: instead say "[as the parser]You can't sing in this extension demo![no line break][as normal][line break]".
	Before jumping when player is on platform: say "Before jumping, you stop and think about something.".
	Instead of sleeping when player is on platform: say "You can't.  [as the parser]You might try MOVE or TILT.[no line break][as normal][line break]".
	Before listening when player is on platform: say "[as the parser]That's totally impossible.[no line break][as normal]  But you do it anyway."

	test me with "get bat / jump / get cat / big / wait / oops / listen to platform now / get on platform / look / remove all from cat / eat platform / open box / eat apple / g / take / bat / drop all but rat / drop all but bat / drop all but / sing / jump / sleep / listen / examine cat and rat / drop ascot / score". 

	[NB - The one which gives the wrong error with version 4 of Neutral Library Messages is 'get all but rat'... a project for version 5.  The rest work.  This is a bug in drop, since take all but xxxx works right.]

Example: * Ignorance is Bliss - Test for don't know that word rule (from Unknown Word Error)
	
	*: "Ignorance is Bliss"

	Include Neutral Standard Responses by Nathanael Nerode.

	The Conference Chamber is a room. In the Conference Chamber is a table. On the table is a treaty.

	Test me with "examine non-proliferation treaty".

Example: ** Oops - Regression test for interaction between don't know that word rule and parser oops (from Unknown Word Error)

	*: "Oops"

	Include Neutral Standard Responses by Nathanael Nerode.

	The Conference Chamber is a room. In the Conference Chamber is a table. On the table is a treaty.

	Understand "put [something preferably held] on top of [something]" as putting it on.

	[ Without "restore the oops target" above, this oops would result in "put table on tabl" and get the same error message a second time because of some parsing weirdness. ]
	Test me with "put treaty on tabl / oops table".

Example: *** Scenery - Regression test for line break issues with scenery responses

	*: "Scenery"

	Include Neutral Standard Responses by Nathanael Nerode.

	The House is a room.  "It's the house."

	The banana is a thing.  [Kept offstage for testing.]

	The furniture is a plural-named scenery thing in the house.  The description of the furniture is "The furniture is not meant to be used."

	The decorations is a plural-named scenery thing in the house.  The description of the decorations is "Decorative."

	test scenery with "take furniture/take furniture and decorations".
	test cantsee with "take banana/take sdfh/take banana and furniture".
