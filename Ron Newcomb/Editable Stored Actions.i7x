Version 10 of Editable Stored Actions by Ron Newcomb begins here.

"This extension extends section 12.20 of Writing With Inform.  The individual parts of a stored action -- actor, noun, second noun, action name -- can be changed directly.  Also exposes new parts: request, text, participle, preposition, number, and each kind of value."


Volume 1 - extension Editable Stored Actions

[Chapter 0 - avoid a bug - unindexed

Unused-stored-action-to-prevent-Problem-msg is a stored action that varies. 
]

Chapter 1 - New Parts of a Stored Action

To decide whether the request part of (act - stored action):
	(- (STORED_ACTION_TY_Part({-by-reference:act}, STORA_REQUEST_F))  -).

To decide what arithmetic value of kind K is the (name of kind of arithmetic value K) part of (act - a stored action):
	(- BlkValueRead({act}, STORA_NOUN_F) -).

To decide what arithmetic value of kind K is the second (name of kind of arithmetic value K) part of (act - a stored action):
	(- BlkValueRead({act}, STORA_SECOND_F) -).

[To decide what text is text/topic part of (act - stored action):
	(- (STORED_ACTION_TY_Part({-by-reference:act}, STORA_COMMAND_TEXT_F))  -).]

To decide what text is the participle part of (sa - stored action):
	decide on the participle part of (action name part of sa).

To decide what text is the participle part of (act - an action name):
	let X be text;
	let X be "[act]";
	replace the regular expression "\s+it\b.*$" in X with "";
	decide on X.

To decide what text is the preposition part of (sa - stored action):
	decide on the preposition part of (action name part of sa).

To decide what text is the preposition part of (act - an action name):
	let X be text;
	let X be "[act]";
	unless X matches the regular expression "\bit\b", decide on "";
	replace the regular expression "^.*\bit\s*" in X with "";
	decide on X.


Chapter 2 - Change the Parts of a Stored Action

To change/now the/-- actor part of (act - a stored action) to/is (pop - a object):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_ACTOR_F, {pop})); -).

To change/now the/-- action name part of (act - a stored action) to/is (anp - an action name):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_ACTION_F, {anp})); -).

To change/now the/-- noun part of (act - a stored action) to/is (obj - an object):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_NOUN_F, {obj})); -).

To change/now the/-- second noun part of (act - a stored action) to/is (obj - an object):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_SECOND_F, {obj})); -).

Include (-
[ STORED_ACTION_TY_SetPart stora ind val at  n1 n2;
	at = FindAction(BlkValueRead(stora, STORA_ACTION_F));
	if (ind == 0) { ! remember which noun types the previous action needed
		n1 = ActionData-->(at+AD_NOUN_KOV);
		n2 = ActionData-->(at+AD_SECOND_KOV);
	}
	BlkValueWrite(stora, ind, val);  ! effect the change
	if (ind == 0) {  ! after changing the action name, blank out Noun & Second Noun if necessary
		at = FindAction(BlkValueRead(stora, STORA_ACTION_F));
		if (at == 0) return;
		if (((ActionData-->(at+AD_REQUIREMENTS) & NEED_NOUN_ABIT) == 0) || (n1 ~= ActionData-->(at+AD_NOUN_KOV)))
			if (ActionData-->(at+AD_NOUN_KOV) == UNDERSTANDING_TY)
				BlkValueWrite(stora, STORA_NOUN_F, EMPTY_TEXT_VALUE);
			else
				BlkValueWrite(stora, STORA_NOUN_F, 0);
		if (((ActionData-->(at+AD_REQUIREMENTS) & NEED_SECOND_ABIT) == 0) || (n2 ~= ActionData-->(at+AD_SECOND_KOV)))
			if (ActionData-->(at+AD_SECOND_KOV) == UNDERSTANDING_TY)
				BlkValueWrite(stora, STORA_SECOND_F, EMPTY_TEXT_VALUE);
			else
				BlkValueWrite(stora, STORA_SECOND_F, 0);
	}
];
-).

To change/now the/-- request part of (act - a stored action) to/is (b - a truth state):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_REQUEST_F, {b})); -).

To change/now the/-- (name of kind of arithmetic value K) part of (act - a stored action) to/is (obj - K):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_NOUN_F, {obj})); -).

To change/now the/-- second (name of kind of arithmetic value K) part of (act - a stored action) to/is (obj - K):
	(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_SECOND_F, {obj})); -).


[  [ broken ]
To change/now the/-- text part of (act - a stored action) to/is (itxt - text):
(- (STORED_ACTION_TY_SetPart({-by-reference:act}, STORA_COMMAND_TEXT_F, INDEXED_TEXT_TY_Create({itxt}))); -).
]


Chapter 3 - Useful Questions

To decide if (act - a stored action) involves/involve (verb - an action name):
	decide on whether or not  the action name part of the act is the verb.

To decide if the/-- noun part of (act - a stored action) is an/-- object: 
	decide on whether or not the noun part of (the action name part of the act) is an object.

To decide if the/-- noun part of (verb - an action name) is an/-- object: 
	(- ((ArgTypeNumForActionName({verb}, AD_NOUN_KOV)) == OBJECT_TY) -).

To decide if the/-- second noun part of (act - a stored action) is an/-- object: 
	decide on whether or not the second noun part of (the action name part of the act) is an object.

To decide if the/-- second noun part of (verb - an action name) is an/-- object: 
	(- ((ArgTypeNumForActionName({verb}, AD_SECOND_KOV)) == OBJECT_TY) -).

Include (-
[ ArgTypeNumForActionName ac param;
	ac = FindAction(ac);
	if (ac == 0) return EMPTY_TEXT_VALUE;
	ac = ActionData-->(ac+param); 
	if (ac ~= NULL) return ac;
	return EMPTY_TEXT_VALUE;
];
-).


[Version 10: for compatibility with new build ]
[Version 9: is the argument an object? phrases; indexed text version of participle and preposition ]
[Version 8: updated for new Inform build : action-name --> action name;  preposition of & participle of no longer can work; re-ordered headings for Index readability ]
[Version 7: added type num for args, numeric noun parts (broken)]
[Version 6: allow the preposition and participle parts to operate directly on action names]
[Version 5: removed errant semicolon from "participle part"]
[Version 4: added "involves (an action name)" ]

Editable Stored Actions ends here.

---- DOCUMENTATION ----

This extension allows us to directly change the parts of a stored action.

	The standing orders are a stored action that varies.
	The soldier on point is a person that varies.
	Guarding it from is an action applying to one room and one direction.
	
	change the action name part of the standing orders to the guarding it from action;
	change the actor part of the standing orders to the soldier on point;
	change the noun part of the standing orders to the battlefield;
	change the second noun part of the standing orders to north;

This extension also exposes a few new parts of a stored action.  The request and numerical parts can be changed in the same way as the earlier four. The rest can only be read.

	request part of S
	text part of S
	preposition part of S
	participle part of S
	number part of S
	second number part of S

The request part is an either/or property that differentiates between "Bob jumping" and "asking Bob to try jumping".  (The latter rule, if executed, would first consult the persuasion rules.  It is not referring to either of the asking actions in the Standard Rules "asking it for" nor "asking it about".)  

The text part is only of interest to actions which apply to a topic. The text part stores the player's entire command, not just the topic part.  If the action name part of a stored action is changed, this obviously invalidates the text part.  

The preposition part returns the preposition used between the two nouns, for those actions that apply to two nouns.  For example, the "telling it about" action has "about" as its preposition.  Similarly, the participle part would be "telling".  These two parts may be used on just the action name (such as "the giving it to action") in addition to a stored action.

The number and second number part are for actions that apply to a number or kind of value.  Actions can only apply to a single number or kind of value, never two, but if an action also applies to an object, the number part may be first or second.  We can test if a noun or second noun is an object by the phrases.

	*: if the noun part of (a stored action) is an object,
	if the second noun part of (a stored action) is an object,

For the phrases that return the participle, preposition, or whether or not a noun is an object, we may also use an action name instead of a stored action. This is because the returned information is constant, not depending upon a particular instance. For example:
	say "[the preposition of the asking it for action]";

	unless the second noun part of the dialing it for action is an object:
		say "[the second number part of the current action]";

A final, small feature: we may ask if a stored action involves a particular action name (i.e., if it involves a particular verb).  There are easier, more direct ways to do this, except if the action name is in a variable. 

	let the possibility be a random action name;
	if the best idea yet involves the possibility:
		say "And suddenly, a hope; a connection.  [The best idea yet] may fall within your realm of possibilities.";

The phrasebook of the index lists these phrases succinctly. 

[A caveat:  the extension currently has a limitation regarding using constant values.  The following will produce a compiler error:
	change the actor part of the standing orders to Charlie;

Instead, a workaround is offered:
	Charlie is now the actor part of the standing orders;

This limitation affects actor, noun, and second noun.  We apologize for the inconvenience.]

Example: * The Ultimate Puzzle Solution - A kind of value's not-so-kind example

	*: "The Ultimate Puzzle Solution"
	
	Include Editable Stored Actions by Ron Newcomb.
	
	The backyard is room.  A Rubik's cube is a thing carried by the player.
	
	Feet are a kind of value. 10' specifies feet.
	
	Throwing it is an action applying to one object and one feet.
	Understand "throw [something] [feet]" as throwing it.
	
	Pent-up frustration is a stored action that varies.
	
	Report throwing it:
		now pent-up frustration is the current action;
		change the second feet part of pent-up frustration to the feet understood plus 10';
		say "Although [the current action] was all you intended, you find yourself [pent-up frustration] instead."
	
	Test me with "throw rubik's cube 30['] "
	

Example: *** Editable Stored Actions - Allowing our player a CHANGE command similar to the author's

	*: "Editable Stored Actions"

	Include Editable Stored Actions by Ron Newcomb.

	Section 1 - Basic setup

	The best idea yet is a stored action that varies. 
	
	Place is a room.  Bob and Joe are men in place.  A rock is in place.  Persuasion: rule succeeds.
	
	When play begins, now the best idea yet is the action of Bob giving the rock to Bob.
	
	Instead of looking, say "You see an action here: [bold type][the best idea yet][roman type]."
	 
	Test me with "change the second noun to joe/do it/change the request to true/do it/change the second noun to me/l/change the action to jumping/jump/do it/eh/l/change the request to false/do it/l/x joe/do it/tell joe about stuff/do it/ask joe for rock/l/change the noun to rock/x noun/x second noun/do it/change second noun to rock/do it/x preposition/x participle/eh".

	Section 2 - The verbs DO IT, EXAMINE, and CHANGE

	Understand "do it" as executing. Executing is an action applying to nothing. Carry out executing: try the best idea yet.
		
	Understand "examine [text]" or "x [text]" as inspecting.  Inspecting is an action applying to one topic. 
	Carry out inspecting "prep/preposition": 
		say "The preposition is [bold type][preposition part of the best idea yet][roman type]."
	Carry out inspecting "participle/name/action-name/action": 
		say "The participle part is [bold type][participle part of the best idea yet][roman type]."
	Carry out inspecting "topic/topical/text/textual": 
		say "The topic part is [bold type][text part of the best idea yet][roman type]."
	Carry out inspecting "actor": 
		say "The actor part is [bold type][actor part of the best idea yet][roman type]."
	Carry out inspecting "noun": 
		say "The noun part is [bold type][noun part of the best idea yet][roman type]."
	Carry out inspecting "second noun": 
		say "The second noun part is [bold type][second noun part of the best idea yet][roman type]."
	Carry out inspecting "request": 
		say "The request part is [bold type][if request part of the best idea yet]true[else]false[end if][roman type]."
	
	Understand "change [text] to [any thing]" as changing it to.  Changing it to is an action applying to one topic and one visible thing.  
	Check changing "actor" to: 
		if the second noun is not a person, say "Actors must be people." instead.
	Carry out changing "actor" to: 
		change the actor part of the best idea yet to the second noun.
	Carry out changing "noun" to: 
		change the noun part of the best idea yet to the second noun.
	Carry out changing "second noun" to: 
		change the second noun part of the best idea yet to the second noun.
	Carry out changing "request" to truth: 
		change the request part of the best idea yet to true.
	Carry out changing "request" to falsehood: 
		change the request part of the best idea yet to false.
	Report changing it to: 
		say "The best idea yet has been changed to [bold type][The best idea yet][roman type]."
	
	Section 3 - CHANGE an action name

	Understand "change action/name/action-name [text]" as a mistake ("To change the stored action's action name, try to do that action.  For example, JUMP will change the action name part to the jumping action.  (Sorry, parser difficulty.)").
	
	Instead of doing something except executing, inspecting, or looking when the current action is not changing to:
		change the action name part of the best idea yet to the action name part of the current action;
		say "The action name part (only!) has been changed, yielding [bold type][the best idea yet][roman type]."

	Section 4 - Niceties, workarounds, and debugging
	
	The block giving rule is not listed in any rulebook. 
	Instead of someone jumping, say "[Actor] leaps high into the air."
	
	Truth and falsehood are things. Understand "true/yes" as truth. Understand "false/no" as falsehood.
	
	After reading a command when the player's command includes "the", cut the matched text.
	
	Understand "eh" as a mistake ("actor: [actor part of the best idea yet][line break]action name: [action name part of the best idea yet][line break]noun: [noun part of the best idea yet][line break]second noun: [second noun part of the best idea yet][line break]request? [if request part of the best idea yet]yes[else]no[end if][line break]topic: [the text part of the best idea yet][line break]participle: [the participle part of the best idea yet][line break]preposition: [preposition part of the best idea yet][line break]").


