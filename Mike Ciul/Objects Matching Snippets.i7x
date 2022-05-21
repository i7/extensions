Version 1 of Objects Matching Snippets by Mike Ciul begins here.

Section - The Item to Match

The item to match is a object that varies.
Definition: A thing is matchable if it is the item to match.
Definition: An room is matchable if it is the item to match.
Definition: A direction is matchable if it is the item to match.
Definition: A region is matchable if it is the item to match.

Section - Snippet-matching

Does the object match is a snippet based rulebook. The does the object match rulebook has outcomes it does (success) and it does not (failure).

Does the object match a snippet (called S):
	if the item to match is a thing and S matches "[any matchable thing]", it does;
	if the item to match is a room and S matches "[any matchable room]", it does;
	if the item to match is a direction and S matches "[any matchable direction]", it does;
	if the item to match is a region and S matches "[any matchable region]", it does;
	it does not.

To decide whether (candidate - an object) matches (S - a snippet):
	Now the item to match is candidate;
	follow the does the object match rules for S;
	decide on whether or not the outcome of the rulebook is the it does outcome;
	
Snippet-matching relates an object (called candidate) to a snippet (called S) when candidate matches S. The verb to be identified with implies the snippet-matching relation.

Section - Snippet-inclusion

Does the object's name appear in is a snippet based rulebook. The does the object's name appear in rulebook has outcomes it does (success) and it does not (failure).

Does the object's name appear in a snippet (called S):
	if the item to match is a thing and S includes "[any matchable thing]", it does;
	if the item to match is a room and S includes "[any matchable room]", it does;
	if the item to match is a direction and S includes "[any matchable direction]", it does;
	if the item to match is a region and S includes "[any matchable region]", it does;
	it does not.

To decide whether the name of (candidate - an object) appears in (S - a snippet):
	Now the item to match is candidate;
	follow the does the object's name appear in rules for S;
	decide on whether or not the outcome of the rulebook is the it does outcome;
	
Snippet-inclusion relates an object (called candidate) to a snippet (called S) when the name of candidate appears in S. The verb to be named in implies the snippet-inclusion relation.

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

Definition: A thing is likeliest if the match score for it is the best match score;
Definition: A room is likeliest if the match score for it is the best match score;
Definition: A direction is likeliest if the match score for it is the best match score;
Definition: A region is likeliest if the match score for it is the best match score;

Section - Choosing the Most Likely Object

To decide whether nothing matched:
	decide on whether or not the best match score is -1;

To decide whether something matched:
	decide on whether or not the best match score is at least 0;

To decide which object is the/-- most likely (O - description of objects):
	Let the already matched item be nothing;
	Now the best match score is -1;
	Repeat with the candidate running through the list of O:
		Let the current match score be the match score for the candidate;
		If the current match score is less than the best match score, next;
		If the current match score is the best match score:
			now the already matched item is nothing;
			next;
		Now the already matched item is the candidate;
		Now the best match score is the current match score;
	Decide on the already matched item.

Section - Testing Commands - Not for Release

match-checking is an action applying to one topic. Understand "objmatch [text]" as match-checking.

Report match-checking:
	showme the list of things identified with the topic understood;
	showme the list of rooms identified with the topic understood;
	showme the list of directions identified with the topic understood;
	showme the list of regions identified with the topic understood;

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
