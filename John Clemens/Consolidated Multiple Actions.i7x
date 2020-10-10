Version 3 of Consolidated Multiple Actions (for Glulx only) by John Clemens begins here.

"An extension to consolidate action reports when performing an action on multiple objects, such as with 'take all'. Requires Hypothetical Questions by Jesse McGrew. Version 3 updated by Emily Short for 6L38 compatibility."

[email: jdc20@psu.edu
version 1: 080703

To do:
	- fix "The grouped list" PPC issue after next update
]

Include Hypothetical Questions by Jesse McGrew.

Use strict action consolidation checking translates as (- Constant STRICT_ACTION_CONSOLIDATION; -).

Section 1 - New generate action rule

Include (-

[ GENERATE_ACTION_R i j k l;
	if (EarlyInTurnSequence == false) rfalse; ! Prevent use outside top level
	EarlyInTurnSequence = false;

	action = parser_results-->ACTION_PRES;
	act_requester = nothing; if (actor ~= player) act_requester = player;

	inp1 = 0; inp2 = 0; multiflag = false;
	if (parser_results-->NO_INPS_PRES >= 1) {
		inp1 = parser_results-->INP1_PRES; if (inp1 == 0) multiflag = true;
	}
	if (parser_results-->NO_INPS_PRES >= 2) {
		inp2 = parser_results-->INP2_PRES; if (inp2 == 0) multiflag = true;
	}

	if (inp1 == 1) {
		noun = nothing; ! noun = special_number1;
	} else noun = inp1;
	if (inp2 == 1) {
		second = nothing;
		! if (inp1 == 1) second = special_number2; else second = special_number1;
	} else second = inp2;

	if (multiflag) {
		if (multiple_object-->0 == 0) {
			if (actor == player) { GENERATE_ACTION_RM('B'); new_line; }
			return;
		}
		if (toomany_flag) {
			toomany_flag = false;
			if (actor == player) { GENERATE_ACTION_RM('A'); }
		}
		FollowRulebook( (+ multiple action processing rulebook +) ); ! new in CMA
		if (multiple_object-->0 > 0) GenerateMultipleActions(); ! modified in CMA
		multiflag = false;
	} else BeginAction(action, noun, second);

	if ((actor ~= player) || (act_requester)) action = ##Wait;
	actor = player; act_requester = 0;

	if (meta) { RulebookSucceeds(); rtrue; }
	rfalse;
];
 -) instead of "Generate Action Rule" in "OrderOfPlay.i6t".

Section 2 - Consolidate multiple actions rule

Multiple action processing rules is a rulebook.

A multiple action processing rule (this is the consolidate multiple actions rule):
	truncate the consolidated objects list to 0 entries;
	truncate the noteworthy objects list to 0 entries;
	let L be the multiple object list;
	let F be a list of objects;
	repeat with x running through L:
		now the noun is x;
		hypothetically test the proposed action and consider the action consolidation results rulebook;
		if the outcome of the rulebook is:
			-- standard outcome: add x to the consolidated objects list;
				issue CMA debugging message "standard";
				silently try the current action;
			-- noteworthy outcome: add x to the noteworthy objects list;
				issue CMA debugging message "noteworthy";
			-- failed outcome: add x to F;
				issue CMA debugging message "failed";
	add the noteworthy objects list to F;
	alter the multiple object list to F;
	if the number of entries of the consolidated objects list is greater than 0:
		carry out the reporting consolidated actions activity;
		if a paragraph break is pending, say conditional paragraph break;
	now the number of multiple actions so far this turn is 0.

The consolidated objects list is a list of objects that varies.
The noteworthy objects list is a list of objects that varies.

The action_success_flag is a truth state variable.
The hypothetical_test_flag is a truth state variable.
The noteworthy_consolidation_flag is a truth state variable.

To indicate noteworthy consolidation: now the noteworthy_consolidation_flag is true.

[We need the following because even though an NPC's action may fail, the asking action can succeed]
First unsuccessful attempt by someone doing something when the hypothetical_test_flag is true (this is the catch failure of actions by others rule): now the action_success_flag is false.

Action consolidation results rules is a rulebook. The action consolidation results rulebook has outcomes standard, failed, and noteworthy.

Last action consolidation results rule (this is the standard action consolidation results rule):
	if the noteworthy_consolidation_flag is true, noteworthy;
	if the action_success_flag is true:
		let H be indexed text;
		let H be "[the hypothetical output]";
		unless the strict action consolidation checking option is active:
			replace the regular expression "\[bracket](<^\[bracket]\[close bracket]>)*\[close bracket]" in H with "";
			replace the regular expression "\((<^\(\)>)*\)" in H with "";
		if H exactly matches the regular expression "\s*", standard;
		noteworthy;
	failed.

Section 2a - cma rule utility functions - unindexed

To test the proposed action:
	now the noteworthy_consolidation_flag is false;
	now the action_success_flag is true;
	now the hypothetical_test_flag is true;
	silently try the current action;
	unless the rule succeeded, now the action_success_flag is false;
	now the hypothetical_test_flag is false.

To issue CMA debugging message (T - text): (- CMADebug({T}); -).

Include (-
[ CMADebug ro;
	#IFDEF DEBUG;
	if ((trace_actions) && (FindAction(-1))) {
		print "[testing consolidation for "; 
		DB_Action(actor,act_requester,action,noun,second);
		print " - ", (string) ro,  " outcome]^"; ClearParagraphing();
	}
	#ENDIF;
	rtrue;
];
-).

Section 3 -Reporting consolidated actions

Reporting consolidated actions is an activity.

Last for reporting consolidated actions rule when taking (this is the standard consolidated report taking rule): 
	say "[We] [pick] up [consolidated objects]." (A)
	
Last for reporting consolidated actions rule when asking someone to try taking (this is the standard consolidated report taking by others rule): 
	say "[The person asked] [pick] up [consolidated objects]." (A)

Last for reporting consolidated actions rule when dropping (this is the standard consolidated report dropping rule): 
	say "[We] [put] down [consolidated objects]." (A)

Last for reporting consolidated actions rule when asking someone to try dropping (this is the standard consolidated report dropping by others rule): 
	say "[The person asked] [put] down [consolidated objects]." (A)

Last for reporting consolidated actions rule when removing from (this is the standard consolidated report removing from rule): 
	say "[We] [pick] up [consolidated objects]." (A)
	
Last for reporting consolidated actions rule when asking someone to try removing from (this is the standard consolidated report removing from by others rule): 
	say "[The person asked] [pick] up [consolidated objects]." (A)

Last for reporting consolidated actions rule when putting on (this is the standard consolidated report putting on rule): 
	say "[We] [put] [consolidated objects] on [the second noun]." (A)
	
Last for reporting consolidated actions rule when asking someone to try putting on (this is the standard consolidated report putting on by others rule): 
	say "[The person asked] [put] [consolidated objects] on [the second noun]." (A)

Last for reporting consolidated actions rule when inserting into (this is the standard consolidated report inserting into rule): 
	say "[We] [put] [consolidated objects] into [the second noun]." (A)
	
Last for reporting consolidated actions rule when asking someone to try inserting into (this is the standard consolidated report inserting into by others rule): 
	say "[The person asked] [put] [consolidated objects] into [the second noun]." (A)

Section 4 - Printing consolidated objects

[We make this into an activity so that we can write use it in other conditions, such as name printing.]

To say consolidated objects: carry out the printing consolidated objects activity.

Printing consolidated objects is an activity.

[We use the list-writer to print the consolidated objects list so that multiple objects of a kind are grouped together, and to allow the grouping together activity to be used. The complication is that we want to try to keep the order of the printed list the same as the order in which the actions occurred (as much as possible) and be somewhat efficient, so we add a new list-writing function.]

Last for printing consolidated objects rule (this is the grouped listing of consolidated objects rule): say the grouped consolidated objects list.

To say the grouped (L - a list of objects):
	list the elements of L, as a sentence, using the definite article.
[To say The grouped (L - a list of objects):
	list the elements of L, as a sentence, using the definite article, with capitalized first article.]
["The" doesn't work properly on PPC, presumably due to the endianness bug. Can FIX this after the next update.]
To say The capitalized grouped (L - a list of objects):
	list the elements of L, as a sentence, using the definite article, with capitalized first article.
	 

To list the elements of (L - a list of objects), with newlines, indented, giving inventory information, as a sentence, including contents, including all contents, tersely, giving brief inventory information, using the definite article, listing marked items only, prefacing with is/are, not listing concealed items, suppressing all articles, with extra indentation and/or with capitalized first article:(- WriteGroupedList({L}, {phrase options}); -). 

Include (-
[ WriteGroupedList list style 
	i obj first length g gc; 

	gc = -2;
	
	if ((list==0) || (BlkValueWeakKind(list) ~= LIST_OF_TY)) return; 
	length = BlkValueRead(list, LIST_LENGTH_F); 

	if (length == 0) {
	    	if (style & ISARE_BIT ~= 0) LIST_WRITER_INTERNAL_RM('W');
	    	else if (style & CFIRSTART_BIT ~= 0) LIST_WRITER_INTERNAL_RM('X');
			else LIST_WRITER_INTERNAL_RM('Y');
	} else { 
		@push MarkedObjectArray; @push MarkedObjectLength; 
		MarkedObjectArray = RequisitionStack(length); 
		MarkedObjectLength = length; 
		if (MarkedObjectArray == 0) return RunTimeProblem(RTP_LISTWRITERMEMORY); 
		
		for (i=0:i<length :i++) { 
			obj = BlkValueRead(list, i+LIST_ITEM_BASE); 
			if (first == nothing) first = obj;
			MarkedObjectArray-->i = obj; 

			g = GetGNAOfObject(obj); g = g%3;
			if (gc == -2) gc = g;
			else if (gc ~= g) gc = -1;			

		}

		if (length > 1)
		{
			say__n = 1;
		} else { 
			say__n = 0;
		}

		WriteListFrom(first, style, 0, false, MarkedListIterator); 
		FreeStack(MarkedObjectArray); 
		@pull MarkedObjectLength; @pull MarkedObjectArray; 
	} 
	prior_named_list = length; 
	prior_named_list_gender = gc;
	return;
];
-).

Section 5 - Announcing multiple occurrences

[We spin this off into an activity to make it easier to vary.]

The number of multiple actions so far this turn is a number variable. [This can be tested in an announcing rule to vary the announcement for successive actions.]

The new announce items from multiple object lists rule is listed instead of the announce items from multiple object lists rule in the action-processing rules.

This is the new announce items from multiple object lists rule:
	if the current item from the multiple object list is not nothing, carry out the announcing a multiple occurrence activity with the current item from the multiple object list.

Announcing a multiple occurrence of something is an activity.

The last for announcing a multiple occurrence rule for something (called the object in question) (this is the standard multiple object announcement rule): 
	if the object in question is not listed in the noteworthy objects list:
		say "[object in question]: [run paragraph on]" (A).

First before announcing a multiple occurrence rule (this is the keep track of number of actions so far rule): increase the number of multiple actions so far this turn by 1.


Section 6 - Recognizing "them" as a list in input

[We don't want to interfere with the normal use of "them" to refer to a plural-named thing, so we go through the usual pronouns mechanism with a placeholder object.]

The stored consolidated objects is a list of objects that varies.
	
After printing consolidated objects (this is the update the pronoun them to consolidated objects rule): set pronouns from the consolidated objects list.
	
After reading a command when them refers to a list (this is the replace them by stored consolidated objects rule):
	let N be indexed text;
	let N be the player's command;
	let Y be indexed text;
	let Y be "[stored consolidated objects]";
	replace the regular expression "\bthem\b" in N with "[Y]";
	change the text of the player's command to N.

To set pronouns from (L - a list of objects):
	[We should be careful not to run this on a list which contains only a single object which is repeated multiple times, but the lists produced from the multiple objects list are okay.]
	if the number of entries of L is 1, set pronouns from entry 1 of L;
	if the number of entries of L is at least 2:
		now stored consolidated objects is L;
		set pronouns from the pronoun_them_placeholder.

To decide if them refers to a list: (- TestThemPlaceholder() -).

Section 6a - them utility functions - unindexed

The pronoun_them_placeholder is a privately-named plural-named proper-named thing.
Rule for printing the name of the pronoun_them_placeholder: say the grouped stored consolidated objects.

Include (- [ TestThemPlaceholder ; return (LanguagePronouns-->12 == (+pronoun_them_placeholder+)); ]; -).
[This needs to be reworked to localize more easily.]


Consolidated Multiple Actions ends here.


---- DOCUMENTATION ----

Section: Basic behavior

Normally, when the player issues a command such as "take knife and fork" or "drop all", Inform prints a series of messages, one for each object, preceded by the object name. This often results of a series of default messages, which we might rather see grouped into a single message. Consolidated Multiple Actions combines the reports of such multiple actions into a single message when the actions have standard results. The default behavior requires no additional work beyond including the extension.

Before printing any reports, the actions are tested and divided into three categories. "Standard" action results are those which succeed and print nothing when run silently, i.e., they print text only in report rules (parenthetical and bracketed output, such as "(first taking the...)" and debugging messages are ignored here). "Failed" action results are those which fail. "Noteworthy" action results are ones which either succeed but print text other than in a report rule (e.g., they use an "after" rule), or are explicitly marked as noteworthy. This can override standard and failed results. An action result can be marked as noteworthy by using the phrase:

		indicate noteworthy consolidation

This can be used anywhere in the rulebooks for the action except the "report" rules (which are not consulted during testing).

After the action results are determined, a single report message is printed for all of the objects which had standard results. Then the failed actions are run sequentially, with the usual reporting, followed by the noteworthy actions. By default, the object name is printed before failed action results (as in the ordinary behavior), but is omitted before noteworthy action results.

There is one use option: "Use strict action consolidation checking" will require that nothing at all be printed (not even parenthetical messages) in order for an action result to be considered standard. Finally, when using the "actions" debugging commands, messages will be printed showing the results of the consolidation tests.

Section: New rules and rulebooks

The extension adds a new rulebook, the multiple action processing rules, which is run after Inform has determined that there are multiple objects but before the action is run on them. Actions can take multiple objects if they have grammar lines including the "[things]" token; the standard library allows this for the actions of taking, dropping, removing from, putting on, and inserting into. This rulebook contains one rule, "the consolidate multiple actions rule", which consolidates and reports the standard action results as described above. Other rules may be added to this rulebook for additional processing of multiple objects (such as reordering the multiple object list). After this rulebook finishes, the action is applied to the objects remaining in the multiple objects list in the normal fashion.

The consolidate multiple objects rule creates two lists of objects: "the consolidated objects list" which contains those objects whose reports have been consolidated, and "the noteworthy objects list" which contains those objects whose action results are noteworthy. These may be consulted for use in further customization.

The results of an action are categorized by a second rulebook, the action consolidation results rules. This rulebook has three possible outcomes: standard, failed, and noteworthy. New rules may be added here to change the default determination of which actions are standard.

Section: New activities

The extension introduces three new activities:

* Reporting consolidated actions: This activity prints the action report message for the consolidated objects. Any action which can take multiple objects needs to have a reporting consolidated actions rule or nothing will be printed for standard results. Rules are provided for the built-in actions which allow multiple nouns. Actions by NPCs are also consolidated and need reporting rules; these should have the preamble:

	Rule for reporting consolidated actions when asking someone to try (the action)

since multiple actions by an NPC will only be generated in response to the player issuing a command to the NPC.

The text substitution "[consolidated objects]" may be used in such report rules to list the objects whose reports are being consolidated; this will invoke the "printing consolidated objects" activity.

We should be careful not to write a rule like "Rule for reporting consolidated actions when taking the plate", since only the last object in the consolidated objects list will match here. Instead, we should phrase the rule as "Rule for reporting consolidated actions when taking and the plate is listed in the consolidated objects list".

* Printing consolidated objects: This activity prints the actual list of the objects whose reports are consolidated. The default behavior of this activity makes use of Inform's list writing functions so that the "grouping together" activity may be applied to it. The following phrase may be used to print out a list using these abilities:

	list the elements of (L - a list of objects)...(options);

This phrase can take all of the same phrase options as "list the contents of" (as well as the option "with capitalized first article"). For convenience, the most common two uses of this phrase can be invoked with:

	say the grouped (L - a list of objects)
	say The capitalized grouped (L - a list of objects)

* Announcing a multiple occurrence of something: This activity prints the message which precedes an action for an object which has not been consolidated. By default, this prints the objects name followed by a colon for failed actions, and nothing for noteworthy actions. The variable

	the number of multiple actions so far this turn

can be used to tell how many such actions have occurred in order to vary such messages.

Section: Handling the pronoun "them"

After printing the consolidated objects, these objects are stored in a list called "the stored consolidated objects" so that they may be referred to in input using the pronoun "them". This pronoun is also used by Inform to refer to plural-named objects, and so will be updated in the normal fashion (in which case it will no longer refer to the last list of consolidated objects). The usual testing command "pronouns" can be used to determine what the current interpretation is. It may be desirable to try to update this list when printing a list of objects in other places, but since there is no uniformly desirable behavior this task is left to authors. This may be done using the phrase:

	set pronouns from (L - a list of objects)

and we can test whether "them" currently refers to a list of objects with:

	if them refers to a list...

This feature is somewhat experimental, and authors who wish to disable it can do so by adding the lines:
	The update the pronoun them to consolidated objects rule is not listed in any rulebook.	
	The replace them by stored consolidated objects rule is not listed in any rulebook.
	
Section: Change Log

Version 3 was updated for compatibility with 6L38 by Emily Short, and the examples somewhat revised to demonstrate adaptive text behavior.


Example: * Clutter - Illustrating the basic functionality, grouping of objects, and some nicer output for non-standard results.

We can use the grouping together activity when printing consolidated objects just as we can when listing contents, as illustrated with the Scrabble pieces below. We can also add a new rule for announcing a multiple occurrence to vary the reporting of failed and noteworthy results.

Notice also the difference between a Report rule and an After rule for taking. The Report rule for the glass ("You carefully pick up the glass.") fires only when it's taken by itself, whereas thanks to its After rule, the cat will always be reported as struggling no matter how many objects we're picking up.

	*: "Clutter"

	Include Consolidated Multiple Actions by John Clemens.
	
	The Cluttered Office is a room.
	
	The trash can is an open fixed in place container in the cluttered office.
	A desk is here. It is fixed in place. A glass and a plate are on the desk.
	Report taking the glass: say "[We] carefully [pick] up the glass."; rule succeeds.
	A cat is here. After taking the cat, say "The cat [struggle], but [we] [manage] to pick it up."
	The hot potato is here. Instead of taking the hot potato: indicate noteworthy consolidation; say "[We] [burn] [our] hand on the potato, and [let] go immediately."
	
	Some flowers are here.
	
	Bob is a man in the cluttered office. Persuasion rule: persuasion succeeds.
	
	A book is a kind of thing. 5 books are in the cluttered office.
	
	 A Scrabble piece is a kind of thing. The X, the Y and the Z are Scrabble pieces in the cluttered office. Understand "tile" as a Scrabble piece. Understand "tiles" as the plural of Scrabble piece.
	Before printing consolidated objects: group Scrabble pieces together.
	Before listing contents: group Scrabble pieces together.
	Before printing the name of a Scrabble piece while not grouping together, say "tile ". After printing the name of a Scrabble piece while not grouping together, say " from a Scrabble set".
	Before grouping together Scrabble pieces, say "the tiles ". After grouping together Scrabble pieces while not printing consolidated objects, say " from a Scrabble set".
	
	To fail is a verb. To struggle is a verb. To manage is a verb. To burn is a verb. To let is a verb.
	
	Rule for announcing a multiple occurrence of something (called object in question) when taking or removing: 
		if the number of multiple actions so far this turn is greater than 1, say conditional paragraph break;
		if the object in question is not listed in the noteworthy objects list:
			if number of multiple actions so far this turn is:
				-- 1: say "[We] [are] unable to take";
				-- 2: say "[We] further [cannot] take";
				-- 3: say "[We] also [fail] to obtain";
				-- otherwise: say "And";
			say " [the object in question]: [run paragraph on]".
	
	Test me with "take all / drop all / Bob, take glass and plate / Bob, put them on the desk / remove all from desk/ put them in trash can / take glass / drop glass / take glass and plate / drop them / take flowers / drop them".


Example: ** Orderly Announcement - Another way of naming collections of objects when reporting actions, to allow naming them in input as well.

We can use the "grouping together" activity to rename a collection when reporting consolidated actions, but we may also want to recognize the collection names in input. For this we can use a somewhat more complicated approach; the technique used here is not very sophisticated and will only recognize the exact name of the collection.

	*: "Orderly Announcement"
	
	Include Consolidated Multiple Actions by John Clemens.
	
	The Kitchen is a room.
	
	A utensil is a kind of thing. The knife, the fork, and the spoon are utensils in the kitchen.
	
	A glove is a kind of thing. A glove is always wearable. Understand "glove" as a glove. The left glove and the right glove are gloves in the kitchen.
	
	Before listing contents: 
		group gloves together; 
		group utensils together.
		
	Before grouping together gloves: 
		say "a pair of gloves (";
	After grouping together gloves:
		say ")".
		
	Before grouping together utensils: 
		if the listing group size is 3:
			say "a place setting (";
		else:
			say "some utensils (".
	After grouping together utensils:
		say ")".
	
	A collection is a kind of thing. A collection has a list of objects called components.
	
	The pair of gloves is a collection. The components of the pair of gloves is {left glove, right glove}.
	
	The place setting is a collection. The components of the place setting is { knife, fork, spoon }.
	
	To decide if (L1 - list of objects) is a subset of (L2 - list of objects):
		repeat with x running through L1:
			if x is not listed in L2, no;
		yes.
	
	Before printing consolidated objects:
		repeat with group running through collections:
			let L be the components of group;
			if L is a subset of the consolidated objects list:
				repeat with x running through L:
					remove x from the consolidated objects list, if present;
				add group to the consolidated objects list.
	
	After reading a command: 
		repeat with group running through collections: 
			let N be text;
			let Y be text;
			let N be the player's command;  
			let Y be "[components of group]";
			while N matches the regular expression "[group]":
				replace the regular expression "(.*)[group](.*)" in N with "\1[Y]\2"; 
			change the text of the player's command to N.
	
	Test me with "take all / drop place setting / take knife and fork / drop all".

Example: *** Burn, Baby, Burn - Adding a new action which allows multiple nouns.

We can add a new action which allows multiple nouns (or extend an already existing action) using the "[things]" token. In addition to the usual check, carry out, and report rules, we also need to add a rule for reporting consolidated actions for the new action (and a rule for reporting actions by others, if NPCs can be commanded to perform the action). Here we add a "burning it with" action. 

Note that we would not want to use the strict action consolidation checking option here because of a possible "(first taking the lighter)" message.

Since the action typically fails in one way, we can also add a new multiple action processing rule to consolidate the failed action reports as well.

And just for fun, we vary the printing of the consolidated objects list a bit.

	*: "Burn, Baby, Burn"
	
	Include Consolidated Multiple Actions by John Clemens.

	The Abandoned Warehouse is a room.
	
	The player carries a lighter.
	
	Flammability is a kind of value. The flammabilities are flammable and non-flammable. A thing has a flammability. The flammability of a thing is usually non-flammable. Understand the flammability property as describing a thing.
	 
	A book, a newspaper, some dried flowers, and a bra are flammable things in the warehouse.
	A safe, a bottle of water, and a fire-resistant flag are here.
	
	Understand the command "burn" as something new.
	
	To refuse is a verb. To burst is a verb.
	
	Understand "burn [things] with [something]" or "burn [things]" as burning it with. Burning it with is an action applying to one thing and one carried thing.
	Rule for supplying a missing second noun while burning with: now the second noun is the lighter.
	Check burning the player with: instead say "[We] [are not] eager to hurt [ourselves]."
	Check burning lighter with: instead say "The lighter [are] designed to burn fluid without the rest of the casing being consumed."
	Check burning it with: if the second noun is not the lighter, instead say "[The second noun] [are] not a suitable fire-starter."
	Check burning it with: if the noun is not flammable, instead say "[The noun] [refuse] to catch fire."
	Carry out burning it with: remove the noun from play.
	Report burning it with: say "[The noun] [burst] into flames and [are] soon gone."
	
	Rule for reporting consolidated actions when burning with: say "[The capitalized grouped consolidated objects list] burst[s] into flames and [are] soon gone." 
		
	A multiple action processing rule for burning with (this is the consolidate inflammables rule):
		let L be the multiple object list;
		if the number of entries of L is at least 1:
			say "[The capitalized grouped L] [refuse] to catch fire.";
			truncate L to 0 entries;
			alter the multiple object list to L. 
	
	The consolidate inflammables rule is listed after the consolidate multiple actions rule in the multiple action processing rulebook.
	
	Rule for printing consolidated objects when not burning with:
		if the number of entries of the consolidated objects list is at least 3, say "a bunch of things[if the lighter is listed in the consolidated objects list], including [the lighter]";
		otherwise say the grouped consolidated objects list.
	
	Test me with "take all / i / drop all / burn me with lighter / burn lighter with lighter / burn newspaper / burn flowers with lighter / burn everything!".
