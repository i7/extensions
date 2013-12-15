Version 2 of Objects Matching Snippets by Mike Ciul begins here.

"Provides phrases and relations for checking whether objects are named in snippets. Also provides a rulebook for disambinguating objects outside of an action context."

"based on ideas in Original Parser by Ron Newcomb and I6 advice from Andrew Plotkin"

Section - Turn Sequence Hacking

A meta-command state is a kind of value. Out-of-world is a meta-command state.
To decide which meta-command state is in-world: (- 0 -)

The current meta-command state is a meta-command state that varies.
The current meta-command state variable translates into I6 as "meta".

[
Setting "meta" allows us to skip Before, Instead, After and Every Turn rules... hopefully it skips scene changes too.

But that's not enough. In order for the turn to resume again properly, we have to read the command at the right time. When the disambiguation prompt appears, and the player types a new command, we must abort the turn that was still proceeding and start a new one. That means skipping the next "reading a command" activity.
]

[We need to know whether "meta" is set because we're aborting a turn, or whether there was a real meta-action.]
Aborting the turn sequence is a truth state that varies.
To abort the turn sequence:
	now aborting the turn sequence is true;
	now the current meta-command state is out-of-world.

Interrupting the turn sequence for disambiguation is a truth state that varies.

Disambiguation behavior is a kind of value. Some disambiguation behaviors are reject the ambiguous command, choose only the most likely object, and choose the first match.

Disambiguation state is a kind of value. Some disambiguation states are expect command disambiguation only, anticipate snippet disambiguation, and handle snippet disambiguation.

The disambiguation mode is a disambiguation behavior that varies.
The current disambiguation state is a disambiguation state that varies.
 
To prepare for disambiguation:
	Prepare to reject the ambiguous command if disambiguation is triggered;

To prepare to (M - a disambiguation behavior) if disambiguation is triggered:
	Now the disambiguation mode is M;
	Now the current disambiguation state is anticipate snippet disambiguation.

To decide whether a disambiguation prompt interrupted the turn sequence:
	Decide on whether or not the current disambiguation state is handle snippet disambiguation;

Before asking which do you mean when the current disambiguation state is anticipate snippet disambiguation:
	Now the current disambiguation state is handle snippet disambiguation.

After reading a command:
	unless a disambiguation prompt interrupted the turn sequence:
		Now aborting the turn sequence is false;
	Now the current disambiguation state is expect command disambiguation only;

To decide whether the player's input has not been parsed as a command yet:
	Decide on whether or not aborting the turn sequence is true;

For reading a command when the player's input has not been parsed as a command yet:
	do nothing;
	
Section - Low-Level Phrases

To loop over the match list with (func - phrase thing -> nothing): (- LoopOverMatchList({func}); -);

Include (-
[ LoopOverMatchList func i;
	for (i = 0; i < number_matched; i++) {
		indirect(func-->1, match_list-->i);
	}
];

-)

To decide which object is the first match: (- FirstMatch() -)

Include (-
[ FirstMatch;
	if (number_matched < 1) {
		print "PROGRAMMING ERROR: No matches^";
		return 0;
	}
	return match_list-->0;
];
-)

Section - High-Level Phrases

The match handler is a phrase thing -> nothing that varies;

To handle the single best match between (T - a topic) and (snip - a snippet) with (func - phrase thing -> nothing):
	prepare for disambiguation;
	now the disambiguation mode is choose only the most likely object;
	now the match handler is func;
	if snip matches T, apply func to the first match;
	[at this point we may be returning from a disambiguation prompt, and we need to abort the rest of the turn]

For asking which do	you mean when a disambiguation prompt interrupted the turn sequence:
	Let the item be nothing;
	if the disambiguation mode is:
		-- choose the first match:
			Now item is the first match;
		-- choose only the most likely object:
			Now item is the most likely match;
	If the item is nothing:
		carry out the printing a disambiguation refusal activity;
	otherwise:
		apply the match handler to the item;	
	[somehow stop disambiguation from inserting words into the existing command]
	abort the turn sequence; [only takes effect after the disambiguation prompt] 

Section - Did the Player Choose

did the player choose is an object based rulebook.
The did the player choose rules have outcomes it is very likely, it is likely, it is possible, it is unlikely, it is very unlikely.

To decide which number is the/-- match score for (item - an object):
	follow the did the player choose rules for item;
	if the outcome of the rulebook is:
		-- the it is very likely outcome: decide on 4;
		-- the it is likely outcome: decide on 3;
		-- the it is possible outcome: decide on 2;
		-- the it is unlikely outcome: decide on 1;
		-- the it is very unlikely outcome: decide on 0;
	decide on 2;

The best match score is a number that varies.
The already matched item is an object that varies.

Section - Choosing the Most Likely Object

To decide whether nothing matched:
	decide on whether or not the best match score is -1;

To decide whether something matched:
	decide on whether or not the best match score is at least 0;

To decide which object is the/-- most likely match:
	Let the already matched item be nothing;
	Now the best match score is -1;
	Loop over the match list with match-likeliness checking;
	Decide on the already matched item;

To check whether (the candidate - an object) is the most likely match so far (this is match-likeliness checking):
	Let the current match score be the match score for the candidate;
	If the current match score is less than the best match score, stop;
	If the current match score is the best match score:
		now the already matched item is nothing;
		stop;
	Now the already matched item is the candidate;
	Now the best match score is the current match score;

Section - Refusing to Disambiguate

Printing a disambiguation refusal is an activity.

For printing a disambiguation refusal:
	say "You must be more specific.";

Section - Testing Commands - Not for Release

[match-checking is an action out of world applying to one topic. Understand "objmatch [text]" as match-checking.

Report match-checking:
	showme the list of things identified with the topic understood;
	showme the list of rooms identified with the topic understood;
	showme the list of directions identified with the topic understood;
	showme the list of regions identified with the topic understood;]

Objects Matching Snippets ends here.

---- DOCUMENTATION ----

Objects Matching Snippets is a very simple extension that provides a convenient way to search for names of objects within a snippet such as the player's command or the topic understood.

There are two relations that can be used for this: snippet-matching ("O is identified with S") and snippet-inclusion ("O is named in S"). These correspond to the built-in phrases "S matches O" and "S includes O."

Snippet-matching tests whether the name of object O matches the snippet S:
	
	say "[The list of things identified with the topic understood] all match the phrase '[the topic understood]' in your command.";

Snippet-inclusion tests whether the name of object O appears in the snippet S:

	say "The rooms [list of rooms named in the player's command] are all mentioned in your command."

Note that these are both object-to-snippet relations, so you can test them on rooms, directions, and regions as well as things.

If you just want to pick an object, you can use the phrase "the most likely O":

	say "You probably meant [the most likely thing identified with the topic understood]."

This phrase will return an object if there is exactly one match, otherwise it will return nothing, even if there were multiple matches.

To control what objects match, you can use a scoring system similar to the Does the Player Mean rules. This is managed using the "Did the Player Choose" rulebook. The difference is that the Did the Player Choose rules are object based, so you need to pass a description of the object you're testing:

	Did the player choose an exclamation when answering someone that: It is very likely.

The "most likely" phrase will reject any objects that score lower than the best choice. But if there are two or more objects that score equally high, it will still return nothing. To find out whether the phrase failed because nothing match or because of multiple matches, you can test "if nothing matched," "if something matched," and which objects were "likeliest" immediately after calling the phrase:
	
	Let the choice be the most likely thing named in the player's command;
	if the choice is nothing:
		if nothing matched, say "You didn't mention any things I recognize.";
		if something matched, say "You mentioned [the list of likeliest things named in the player's command] in your command.";

Remember that the "likeliest" adjective merely runs the "did the player choose" rulebook on the item described - it doesn't test whether that object was part of the "most likely" test just performed, so you must reiterate any other conditions used to invoke the phrase.

To test what objects match any snippet, you can use the "objmatch" testing command:

	>objmatch me
	"list of things identified with the topic understood" = list of things: {yourself}
	"list of rooms identified with the topic understood" = list of rooms: {}
	"list of directions identified with the topic understood" = list of directions: {}
	"list of regions identified with the topic understood" = list of regions: {}

Example: * Exclamations - Creates a new action that can be parsed from the command "[someone], [something]"

	*: "Exclamations"

	Include Objects Matching Snippets by Mike Ciul.

	Exclaiming it to is an action applying to two visible things.
	Report exclaiming it to: say "You say '[noun]' to [the second noun]."

	An exclamation is a kind of thing. Hello is an exclamation.

	Check answering someone that:
		Let item be the most likely thing identified with the topic understood;
		If item is a thing:
			instead try exclaiming item to the noun;
		Let item be the most likely thing named in the topic understood;
		if something matched:
			say "Your command did not exactly match anything you can say, but [the list of likeliest things named in the topic understood] matched part[if item is nothing]s[end if] of it.";
			stop the action.

	Test is a room. Bob is a man in Test.

	Test me with "say hello to bob/bob, hello how are you Bob"