Version 4/080508 of Achievements by Mikael Segercrantz begins here.

"A table-based way to assign scores for actions, rooms and objects."


Chapter 1 - The objects

Section 1(a) - Table of Achievements

Table of Achievements
message		points		used
text		a number	a number


Section 1(b) - Table of Scored Objects

Table of Scored Objects
object		points		used
a thing		a number	a number


Section 1(c) - Table of Scored Places

Table of Scored Places
loci		points		used
a room		a number	a number


Section 1(d) - Globals

Achievement-Init is a number which varies. Achievement-Init is 0.

The achievement maximum score is a number which varies. The achievement maximum score is 0.


Section 1(e) - Text variables

Achievement in-that-game-you-scored-unranked is text that varies. Achievement in-that-game-you-scored-unranked is "In that game you scored [score] out of a possible [achievement maximum score], in [turn count] turn[s].[line break]".
Achievement in-that-game-you-scored-ranked is text that varies. Achievement in-that-game-you-scored-ranked is "In that game you scored [score] out of a possible [achievement maximum score], in [turn count] turn[s][achievement short-ranking]".
Achievement in-that-game-you-scored is text that varies. Achievement in-that-game-you-scored is "[if using ranking][achievement in-that-game-you-scored-ranked][otherwise][achievement in-that-game-you-scored-unranked][end if]".

Achievement you-have-scored-unranked is text that varies. Achievement you-have-scored-unranked is "You have so far scored [score] out of a possible [achievement maximum score], in [turn count] turn[s].[line break]".
Achievement you-have-scored-ranked is text that varies. Achievement you-have-scored-ranked is "You have so far scored [score] out of a possible [achievement maximum score], in [turn count] turn[s][achievement short-ranking]".
Achievement you-have-scored is text that varies. Achievement you-have-scored is "[if using ranking][achievement you-have-scored-ranked][otherwise][achievement you-have-scored-unranked][end if]".

Achievement you-have-not-received-unranked is text that varies. Achievement you-have-not-received-unranked is "You have not received any points yet.[line break]".
Achievement you-have-not-received-ranked is text that varies. Achievement you-have-not-received-ranked is "You have not received any points yet[achievement short-ranking]".
Achievement you-have-not-received is text that varies. Achievement you-have-not-received is "[if using ranking][achievement you-have-not-received-ranked][otherwise][achievement you-have-not-received-unranked][end if]".

Achievement for-only is text that varies. Achievement for-only is "for";

Achievement out-of-unranked is text that varies. Achievement out-of-unranked is "(out of [achievement maximum score])[line break]".
Achievement out-of-ranked is text that varies. Achievement out-of-ranked is "(out of [achievement maximum score])[line break][achievement long-ranking]".
Achievement out-of is text that varies. Achievement out-of is "[if using ranking][achievement out-of-ranked][otherwise][achievement out-of-unranked][end if]".

Achievement short-ranking is text that varies. Achievement short-ranking is ", giving you a rank of [announce the ranking].[line break]".
Achievement long-ranking is text that varies. Achievement long-ranking is "[line break]This gives you a rank of [announce the ranking].[line break]".

Achievement locating-various-objects is text that varies. Achievement locating-various-objects is "locating sundry items".
Achievement finding-various-places is text that varies. Achievement finding-various-places is "finding various places".

Chapter 2 - Rules


Section 2(a) - Overriding the standard rules

Procedural rule: 
	substitute the announce the short score rule for the announce the score rule;
	substitute the announce the final score rule for the print final score rule.


Section 2(b) - Final question

Table of Final Question Options (continued)
final question wording	only if victorious		topic		final response rule		final response activity
"view the FULL score"	false			"full"		announce the achievements rule	--


Section 2(c) - Miscellaneous rules

To pad (n - a number):
	let m be n;
	if n is less than 0:
       		let n be n multiplied by -1;
		let n be n multiplied by 10;
	say "  ";
	if n is less than 10:
		say "   ";
	otherwise if n is less than 100:
		say "  ";
	otherwise if n is less than 1000:
		say " ";
	say m;
	say " ".


Section 2(d) - Full score replacement rules

This is the announce the died achievement score rule:
	say "[achievement in-that-game-you-scored]".

To announce the beginning of full score:
	say "[achievement you-have-scored]".

To announce the tabled part of full score:
	repeat through the Table of Achievements in used order:
		if the used entry is greater than 0:
			let n be the points entry;
			pad n;
			say "[achievement for-only] [message entry][line break]".

To announce the tabled objects of full score:
	let total be 0;
	repeat through the Table of Scored Objects:
		if the used entry is not 0, increase the total by the points entry;
	if total is not 0:
		pad total;
		say "[achievement for-only] [achievement locating-various-objects][line break]".

To announce the tabled rooms of full score:
	let total be 0;
	repeat through the Table of Scored Places:
		if the used entry is not 0, increase the total by the points entry;
	if total is not 0:
		pad total;
		say "[achievement for-only] [achievement finding-various-places][line break]".

To announce the end of full score:
	pad score;
	say "[achievement out-of]";

To announce the no score:
	say "[achievement you-have-not-received]".


Section 2(e) - Announce the achievements rule

This is the announce the achievements rule:
	if the score is greater than 0:
		announce the beginning of full score;
		announce the tabled part of full score;
		announce the tabled objects of full score;
		announce the tabled rooms of full score;
		announce the end of full score;
	otherwise:
		announce the no score.


Section 2(f) - Ranking

Table of Achievement Rankings
minimum	rank
a number	text


To decide whether using ranking:
	if the number of filled rows in the Table of Achievement Rankings is at least 1, decide yes;
	decide no.

To say announce the ranking:
	let mentioned be 0;
	let closest be -32767;
	let difference be 32767;
	repeat through the Table of Achievement Rankings:
		if score is at least the minimum entry and score - the minimum entry is less than difference:
			now difference is score - the minimum entry;
			now closest is the minimum entry;
	repeat through the Table of Achievement Rankings:
		if mentioned is 0 and closest is the minimum entry:
			now mentioned is 1;
			say "[rank entry]";
	if mentioned is 0, say "*** ERROR: Unknown rank ***".


Section 2(g) - Replacing "score"

This is the announce the short score rule:
	say "[achievement you-have-scored]".

This is the announce the final score rule:
	say "[achievement in-that-game-you-scored]".


Section 2(h) - Score achievement

To score the achievement with message (msg - text):
	choose row with message of msg in the Table of Achievements;
	if the used entry is 0:
		change the used entry to the turn count;
		increase the score by the points entry.


Section 2(i) - Score objects

To score found objects:
	repeat through the Table of Scored Objects:
		if the used entry is 0:
			if the player encloses the object entry:
				change the used entry to the turn count;
				increase the score by the points entry.


Section 2(j) - Score rooms

To score visited rooms:
	repeat through the Table of Scored Places:
		if the used entry is 0:
			if the location is the loci entry:
				change the used entry to the turn count;
				increase the score by the points entry.


Section 2(k) - Initialization

To perform initialization:
	let the total be 0;
	repeat through the Table of Scored Places:
		change the used entry to 0;
		increase the total by the points entry;
		if the loci entry is the location:
			change the used entry to -1;
			increase the score by the points entry;
	repeat through the Table of Scored Objects:
		change the used entry to 0;
		increase the total by the points entry;
		if the object entry is enclosed by the player:
			change the used entry to -1;
			increase the score by the points entry;
	repeat through the Table of Achievements:
		increase the total by the points entry;
		change the used entry to 0;
	change the achievement maximum score to the total.

Before printing the name of a room:
	if Achievement-Init is 0:
		perform initialization;
		change Achievement-Init to 1.


Section 2(l) - Every turn

Every turn (this is the scoring of rooms and objects rule):
	score found objects;
	score visited rooms.


Section 2(m) - Decisions

To decide whether the achievement (txt - text) is scored:
	repeat through the Table of Achievements:
		if the message entry is txt:
			if the used entry is not 0, decide yes;
	decide no.

To decide whether the object (obj - a thing) is scored:
	repeat through the Table of Scored Objects:
		if the object entry is obj:
			if the used entry is not 0, decide yes;
	decide no.

To decide whether the room (rm - a room) is scored:
	repeat through the Table of Scored Places:
		if the loci entry is rm:
			if the used entry is not 0, decide yes;
	decide no.


Chapter 3 - Vocabulary

Section 3(a) - Full score

Understand "full score" or "full" or "fullscore" as requesting the full score.
Requesting the full score is an action out of world.
Carry out requesting the full score: follow the announce the achievements rule.


Achievements ends here.

---- Documentation ----

Chapter: Introduction

The Achievements extension allows for ease of scoring in a game. It allows for different achievements to be scored, as well as finding certain items and rooms. All the achievements, items, and rooms for scoring are managed through tables; the Table of Achievements, the Table of Scored Objects, and the Table of Scored Places respectively.

The extension replaces the score and the full score handling of Inform 7, including the final score displaying, to manage the listing of scores from the tables, and, as of version 4, does not contain any Inform 6 code anymore, thanks to the new end of game handling in Inform 7 5T18.

Chapter: Definitions

Section: Global Variables

The extension defines some global variables:
	1. a number which varies called Achievement-Init. This is used for the extension to know if it has been initialized or not, since it needs to initialize itself when beginning the description of the first location in the game (when play begins does not work, unfortunately, since the location of the player during it is the dark room, not the real location). Initialization grants the points from the start room, if it has any, as well as of any objects enclosed by the player at the beginning of the game, if any have scores defined on them. The name has been chosen to minimize the risk of clashing with a variable in user code.
	2. a number which varies called the achievement maximum score, which is automatically calculated at initialization time.
	3. a ton of text variables to allow for the modification of the messages by this extension. For more information, see the chapter on Modification.

Chapter: Using Achievements

To use the extension, you need to continue the tables you want to use.

Section: Table of Scored Objects

The Table of Scored Objects is defined as follows:

	Table of Scored Objects
	object		points		used
	a thing		a number	a number

The Table of Scored Objects contain the objects for which a score will be given. The object column is the name of the object, the points column the value of the object, and the used column (which will be initialized to 0 at the start of the game) marks the fact of having received the points from the object.

Section: Table of Scored Places

The Table of Scored Places is defined as follows:

	Table of Scored Places
	loci		points		used
	a room		a number	a number

As with the Table of Scored Objects, the Table of Scored Places has the same function. The loci column defining the room to be scored replaces the object column. The used column will be initialized to 0 automatically.

Section: Table of Achievements

The Table of Achievements is defined as follows:

	Table of Achievements
	message		points		used
	text		a number	a number

Again, the table looks like the previous tables, and again, the used column will be initialized to 0 automatically. The message contains the text which will be shown while listing the full score.

Section: Table of Achievement Ranking

The Table of Achievement Ranking is defined as follows:

	Table of Achievement Rankings
	minimum	rank
	a number	text

The Table of Achievement Rankings is used to replace the Table of Rankings (see the chapter on Time, subchapter Introducing tables: Rankings in the Inform 7 documentation).

Section: Scoring an Achievement

To score an achievement, you need to use the following syntax:

	score the achievement with message "the message entry";

and the points will be added to the score.

Section: Testing for Achievements

It is possible to test if an achievement, an object or a room has been scored, using the phrases

	the achievement "<message>" is scored
	the item <object> is scored
	the room <room> is scored

where <message> is the message entry used to score the achievement, <object> is the item tested for and <room> is the room tested for.

Section: Scoring of rooms and objects

If needed, you may override the every turn rule, "scoring of rooms and objects".

Chapter: Modification

As mentioned earlier, this extension comes with a few text variables to ease the customization of the text it can display. The following variables are defined:

	Achievement in-that-game-you-scored-unranked - "In that game you scored [score] out of a possible [achievement maximum score], in [turn count] turn[s].[line break]".
	Achievement in-that-game-you-scored-ranked - "In that game you scored [score] out of a possible [achievement maximum score], in [turn count] turn[s][achievement short-ranking]".
	Achievement in-that-game-you-scored - "[if using ranking][achievement in-that-game-you-scored-ranked][otherwise][achievement in-that-game-you-scored-unranked][end if]".
	
	Achievement you-have-scored-unranked - "You have so far scored [score] out of a possible [achievement maximum score], in [turn count] turn[s].[line break]".
	Achievement you-have-scored-ranked - "You have so far scored [score] out of a possible [achievement maximum score], in [turn count] turn[s][achievement short-ranking]".
	Achievement you-have-scored - "[if using ranking][achievement you-have-scored-ranked][otherwise][achievement you-have-scored-unranked][end if]".
	
	Achievement you-have-not-received-unranked - "You have not received any points yet.[line break]".
	Achievement you-have-not-received-ranked - "You have not received any points yet[achievement short-ranking]".
	Achievement you-have-not-received - "[if using ranking][achievement you-have-not-received-ranked][otherwise][achievement you-have-not-received-unranked][end if]".
	
	Achievement for-only - "for";
	
	Achievement out-of-unranked - "(out of [achievement maximum score])[line break]".
	Achievement out-of-ranked - "(out of [achievement maximum score])[line break][achievement long-ranking]".
	Achievement out-of - "[if using ranking][achievement out-of-ranked][otherwise][achievement out-of-unranked][end if]".
	
	Achievement short-ranking - ", giving you a rank of [announce the ranking].[line break]".
	Achievement long-ranking - "[line break]This gives you a rank of [announce the ranking].[line break]".

	Achievement locating-various-objects - "locating sundry items"
	Achievement finding-various-places - "finding various places"

Above, you also see the default message for the text. This extension itself uses the following ones:

	Achievement in-that-game-you-scored
	Achievement you-have-scored
	Achievement you-have-not-received
	Achievement for-only
	Achievement out-of

when necessary, and these, as can be seen above, call the correct version depending on whether ranks are in use or not.

Example: ** Where ever thou art - Demonstrating the use of achievements, locations scored and items scored.

	*: "Where ever thou art"

	Include Version 4 of Achievements by Mikael Segercrantz.

Let's create the three rooms first.

	The entrance hall is a room. The basement is a room. The dining hall is a room.

Add a door and the connections:

	A wooden door is a door. It is west of the entrance hall and east of the dining hall. It is closed and openable.

	The basement is below the entrance hall.

Add some treasure:

	A baseball cap is a thing. Some crates are in the basement. They are fixed in place.

	Instead of searching the crates for the first time:
		now the baseball cap is in the basement;
		say "Tucked behind crates of various things, you find a baseball cap!"
	
	After opening the wooden door, score the achievement with message "finding the way to the dining hall".

And the tables:

	Table of Achievements (continued)
	used		points		message
	0		10		"finding the way to the dining hall"

	Table of Scored Places (continued)
	used		points		loci
	0		5		basement
	0		5		dining hall

	Table of Scored Objects (continued)
	used		points		object
	0		5		baseball cap

	Table of Achievement Rankings (continued)
	minimum	rank
	0		"beginner"
	10		"explorer"
	20		"leader"
	25		"master"

Initialize status line:

	When play begins:
		change the right hand status line to "[score] out of [achievement maximum score]".

Ending the game:

	Every turn:
		if the score is the achievement maximum score, end the game in victory.

And finally the testing command:

	Test me with " open door / score / w / score / e / d / score / search crates / take cap ".