Version 2/150226 of Multiple Actors by Daniel Stelzer begins here.

"Allows the player to give commands to multiple actors at the same time. (This version heavily modifies the I6 parser.)"

"and Matt Wiener"

Include Editable Stored Actions by Ron Newcomb.
Include Debugging by Daniel Stelzer.
Include Serial And Fix by Andrew Plotkin.
Include Modified Timekeeping by Daniel Stelzer.

Commanding it to is an action out of world applying to one visible thing and one topic. Understand "tell [things] to [text]" or "command [things] to [text]" as commanding it to.

Include (-
	Global actorflag = false;
	Global mc_wn = 0;
-) after "Definitions.i6t".
The multicommand flag is a truth state that varies. The multicommand flag variable translates into I6 as "actorflag".
The multicommand word number is a number that varies. The multicommand word number variable translates into I6 as "mc_wn".
To decide whether the multicommand was issued this turn: (- (actorflag == 2) -);
To decide whether in multicommand mode: (- (actorflag) -);

The multicommand text is text that varies. The multicommand actor list is a list of objects that varies. [The multicommand text is the text which will be parsed for each actor. The multicommand actor list holds the actors who have not yet performed the action.]
The multicommand disambiguation flag is initially false. The multicommand stored actor is initially nothing. [The multicommand disambiguation flag allows the player to insert another command in the middle of a multicommand to answer a disambiguation question. The multicommand stored actor holds the person who initiated the multicommand (usually the player).]

Check someone commanding someone to a topic (this is the prevent recursive commands rule): say "[bracket]It's not necessary to relay your command through [the actor]; just address [the noun] [themselves].[close bracket]" (A); stop the action.
Check commanding someone to a topic when the multicommand flag is true (this is the multicommand mutex rule): stop the action.

Carry out commanding someone to a topic when the multicommand flag is false (this is the set up multicommand when commanding rule):
	set up the multicommand with "[topic understood]".

To set up the multicommand with (T - text):
	if the multiple object list is empty: [This is empty if only one noun was specified.]
		now the multicommand actor list is {};
		add the noun to the multicommand actor list;
	otherwise:
		now the multicommand actor list is the multiple object list;
	now the multicommand text is T;
	now the multicommand stored actor is the player;
	now the multicommand flag is true.

Rule for reading a command when in multicommand mode and the multicommand disambiguation flag is false (this is the replace command with multicommand rule):
	debug say "DBG: changing to [entry 1 in the multicommand actor list].";
	now the player is entry 1 in the multicommand actor list;
	debug say "DBG: changing command to [multicommand text].";
	change the text of the player's command to the multicommand text.

Before asking which do you mean when in multicommand mode (this is the multicommand begin disambiguation rule): [So as not to replace commands while disambiguation is in progress...]
	say "(for [the printed name of player])[command clarification break]" (A);
	now the multicommand disambiguation flag is true.

After reading a command when the multicommand disambiguation flag is true (this is the multicommand end disambiguation rule):
	now the multicommand disambiguation flag is false.

First for printing a parser error when in multicommand mode (this is the give actor's name in multicommand error rule):
	say "[bracket][printed name of the player][close bracket] [run paragraph on]" (A);
	follow the primary multicommand reset rule;
	follow the secondary multicommand reset rule;
	make no decision.

First before doing anything when in multicommand mode (this is the cut off multicommand actions rule):
	if the multicommand was issued this turn: [Don't parse on the first turn.]
		now the multicommand flag is true;
		stop the action;
	let the parse result be a stored action;
	now the parse result is the current action;
	debug say "DBG: parsed as [parse result].";
	now the actor part of the parse result is entry 1 in the multicommand actor list;
	now the request part of the parse result is true;
	follow the primary multicommand reset rule;
	debug say "DBG: trying [the parse result].";
	try the parse result;
	follow the secondary multicommand reset rule;
	stop the action.

This is the primary multicommand reset rule:
	debug say "DBG: removing [the printed name of entry 1 in the multicommand actor list].";
	remove entry 1 from the multicommand actor list;
	debug say "DBG: changing back to [multicommand stored actor].";
	now the player is the multicommand stored actor.

This is the secondary multicommand reset rule:
	if the multicommand actor list is empty: [Time to execute these actions!]
[		repeat with the order running through the multicommand action list:
			debug say "DBG: trying [the order].";
			try the order;	]
		now the multicommand flag is false;
		silently try waiting. [To make one turn go by.]

This is the cancel metacommand rule:
	now the multicommand flag is false;
	now the multicommand actor list is {}.

The announce items from multiple object lists rule does nothing when in multicommand mode.
The record action success rule does nothing when in multicommand mode. [In other words, actions for multiple actors shouldn't take any time.]

The multiple actor rules are a rulebook. [This is a rulebook for 2 reasons: to allow users to modify it easily, and because I don't know how to call anything else from I6.]
A first multiple actor rule (this is the sanity check multiple actor list rule):
	if the multiple object list is empty, rule fails;
	let L be the multiple object list;
	let R be a list of objects;
	repeat with the subject running through the multiple object list:
		if the subject is not a person:
		[	say "[The subject] is not animate." (A);	]
			add the subject to R; [We can't remove entries from a list while repeating through it, so we do it this way instead.]
	repeat with the subject running through R:
		remove the subject from L;
	alter the multiple object list to L;
	if the multiple object list is empty, rule fails.
A multiple actor rule (this is the set up multicommand when parsing rule):
	let T be "[the player's command]";
	let N be 1;
	while N is less than the multicommand word number: [Trim the command]
		replace punctuated word number 1 in T with "";
		increment N;
	set up the multicommand with T.	
A multiple actor rule when debug is active (this is the debug multicommand variables rule):
	say "DBG: multicommand flag is [multicommand flag].[line break]";
	say "DBG: multicommand word number is [multicommand word number].[line break]".
A last multiple actor rule (this is the clear multiple object list after use rule):
	debug say "DBG: list is [the multiple object list].";
	alter the multiple object list to {};
	rule succeeds.

[If you're another author looking at this code, here's how this I6 works:
Normally, the parser uses NounDomain to determine whether the first part of the command is an actor.
Instead, I'm making it call ParseToken with MULTI_TOKEN instead, to determine whether there's a list.
ParseToken will fail, because the list ends with a comma and the next part after the list will be a verb.
But it will put what it's found into the multiple object list, and set wn (the word counter) correctly.
At this point we call the "multiple actor rules", which copy the multiple object list and reset it to {}.
They also check the list and see if it's a valid list of actors. If it's not, the rulebook returns failure.
The I6 code interprets this to mean that there were no actors found, and reparses the command from
the beginning with that assumption. (This is necessary for commands containing commas without actors.)
If the rulebook did not return failure, the parser assumes the I7 has taken care of it and continues parsing.]

Include (-
	if (actorflag ~= 2) {
		for (j=2 : j<=num_words : j++) {
			i=NextWord();
			if (i == comma_word) jump Conversation;
		}
	}
	jump NotConversation;
	
	! NextWord nudges the word number wn on by one each time, so we've now
	! advanced past a comma.  (A comma is a word all on its own in the table.)
	
	.Conversation;
	
	j = wn - 1;
	
	wn = 1; lookahead = HELD_TOKEN; ! Jump back to the beginning of the command.
	scope_reason = TALKING_REASON;
! Here's where I'm changing things.
	l = ParseToken(ELEMENTARY_TT, MULTI_TOKEN); ! Wtf--the list of return codes for ParseToken is wrong! 2 is the code for success; 0 is the same as GPR_PREPOSITION.
	wn--;
	mc_wn = wn;
!	print "DBG: about to follow rulebook^";
	FollowRulebook((+the multiple actor rules+));
	if(RulebookFailed()){	! The multiple object list was invalid as a list of actors, so our parsing was wrong.
		wn = 1;
		jump NotConversation;
	}
!	print "WN is ", wn, "^";
!	print "Verb_wordnum is ", verb_wordnum, "^";
	verb_wordnum = wn;
	actorflag = 2; ! So this doesn't loop.
	!rtrue;
	jump ReParse;
! I cut the rest, since it's now redundant.
-) instead of "Parser Letter C" in "Parser.i6t".

[I needed to make a few changes to the rest of the parser, mostly replacing (actor == player) with (actorflag == false).]
Include (-
	.NotConversation;
	if (verb_word == 0 || ((verb_word->#dict_par1) & 1) == 0) {
		if (actorflag ~= 2) {
			verb_word = UnknownVerb(verb_word);
			if (verb_word ~= 0) jump VerbAccepted;
		}
		best_etype = VERB_PE;
		jump GiveError;
	}
	.VerbAccepted;

	meta = ((verb_word->#dict_par1) & 2)/2;
!	print "Meta: ", meta, "^";
!	print "Actorflag: ", actorflag, "^";

	if (meta == 1 && actorflag) { ! This part never seems to have an effect. Apparently "meta" is set later. But this must have some purpose, so I'm leaving it in.
		best_etype = VERB_PE;
		meta = 0;
		FollowRulebook((+cancel metacommand rule+));
		rtrue;
	!	jump GiveError;
	}

	i = DictionaryWordToVerbNum(verb_word);

	#Ifdef TARGET_ZCODE;
	syntax = (HDR_STATICMEMORY-->0)-->i;
	#Ifnot; ! TARGET_GLULX
	syntax = (#grammar_table)-->(i+1);
	#Endif; ! TARGET_

	num_lines = (syntax->0) - 1;

	pronoun_word = NULL; pronoun_obj = NULL;

	#Ifdef DEBUG;
	if (parser_trace >= 1)
		print "[Parsing for the verb '", (address) verb_word, "' (", num_lines+1, " lines)]^";
	#Endif; ! DEBUG

	best_etype = STUCK_PE; nextbest_etype = STUCK_PE;
	multiflag = false;
-) instead of "Parser Letter D" in "Parser.i6t".

Include (-
  .GiveError;

	etype = best_etype;
	if (actorflag == 2) {
		if (usual_grammar_after ~= 0) {
			verb_wordnum = usual_grammar_after;
			jump AlmostReParse;
		}
		wn = verb_wordnum;
		special_word = NextWord();
		if (special_word == comma_word) {
			special_word = NextWord();
			verb_wordnum++;
		}
		parser_results-->ACTION_PRES = ##Answer;
		parser_results-->NO_INPS_PRES = 2;
		parser_results-->INP1_PRES = actor;
		parser_results-->INP2_PRES = 1; special_number1 = special_word;
	!	actorflag = 0;
		consult_from = verb_wordnum; consult_words = num_words-consult_from+1;
		rtrue;
	}
-) instead of "Parser Letter H" in "Parser.i6t".

Include (-
[ ActionPrimitive  rv p1 p2 p3 p4 p5 frame_id;
	MStack_CreateRBVars(ACTION_PROCESSING_RB);

	if ((keep_silent == false) && (multiflag == false)) DivideParagraphPoint();
	reason_the_action_failed = 0;

	frame_id = -1;
	p1 = FindAction(action);
	if ((p1) && (ActionData-->(p1+AD_VARIABLES_CREATOR))) {
		frame_id = ActionData-->(p1+AD_VARIABLES_ID);
		Mstack_Create_Frame(ActionData-->(p1+AD_VARIABLES_CREATOR), frame_id);
	}
	if (ActionVariablesNotTypeSafe()) {
		if (frame_id ~= -1)
			Mstack_Destroy_Frame(ActionData-->(p1+AD_VARIABLES_CREATOR), frame_id);
		MStack_DestroyRBVars(ACTION_PROCESSING_RB);
		return;
	}

	FollowRulebook(SETTING_ACTION_VARIABLES_RB);

	#IFDEF DEBUG;
	if ((trace_actions) && (FindAction(-1))) {
		print "["; p1=actor; p2=act_requester; p3=action; p4=noun; p5=second;
		DB_Action(p1,p2,p3,p4,p5);
		print "]^"; ClearParagraphing();
	}
	++debug_rule_nesting;
	#ENDIF;
	TrackActions(false, meta);
	if ((meta) && (actorflag)) { ! Changed here.
		ACTION_PROCESSING_INTERNAL_RM('A',(+entry 1 of the multicommand actor list+)); new_line; FollowRulebook((+cancel metacommand rule+)); rv = RS_FAILS; }
	else if (meta) { DESCEND_TO_SPECIFIC_ACTION_R(); rv = RulebookOutcome(); }
	else { FollowRulebook(ACTION_PROCESSING_RB); rv = RulebookOutcome(); }
	#IFDEF DEBUG;
	--debug_rule_nesting;
	if ((trace_actions) && (FindAction(-1))) {
		print "["; DB_Action(p1,p2,p3,p4,p5); print " - ";
		switch (rv) {
			RS_SUCCEEDS: print "succeeded";
			RS_FAILS: print "failed";
				#IFNDEF MEMORY_ECONOMY;
				if (reason_the_action_failed)
					print " the ",
						(RulePrintingRule) reason_the_action_failed;
			    #ENDIF;
			default: print "ended without result";
		}
		print "]^"; say__p = 1;
		SetRulebookOutcome(rv); ! In case disturbed by printing activities
	}
	#ENDIF;
	if (rv == RS_SUCCEEDS) UpdateActionBitmap();
	if (frame_id ~= -1) {
		p1 = FindAction(action);
		Mstack_Destroy_Frame(ActionData-->(p1+AD_VARIABLES_CREATOR), frame_id);
	}
	MStack_DestroyRBVars(ACTION_PROCESSING_RB);
	if ((keep_silent == false) && (multiflag == false)) DivideParagraphPoint();
	if (rv == RS_SUCCEEDS) rtrue;
	rfalse;
];
-) instead of "Action Primitive" in "Actions.i6t".

Multiple Actors ends here.
