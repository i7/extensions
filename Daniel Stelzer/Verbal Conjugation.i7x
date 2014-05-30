Verbal Conjugation by Daniel Stelzer begins here.

Include Editable Stored Actions by Ron Newcomb.

Book 1 - Values

Grammatical person is a kind of value. The grammatical persons are first person singular, first person plural, second person singular, second person plural, third person singular, and third person plural.

Table of Grammatical Exceptions
participle	stem
"tying"		"tie"
"answering"	"answer"
"entering"	"enter"
"listening"	"listen"
"opening"	"open"

Book 2 - Conjugating

To decide what text is the copula conjugated in the (selection - grammatical person):
	if the selection is third person singular:
		decide on "is";
	if the selection is first person singular:
		decide on "am";
	decide on "are". [default]

To decide what indexed text is (selected action - stored action) conjugated in the (selection - grammatical person):
	let T be indexed text;
	let T be the participle part of the selected action;
	let temp be indexed text;
	if T matches the regular expression ".+ing\b": [rule 1: select -ing words]
		let temp be "[text matching regular expression]";
		let found be false;
		repeat through the Table of Grammatical Exceptions:
			if temp matches the text "[participle entry]":
				now temp is the stem entry;
				let found be true;
				break;
		if found is false: [As in, we didn't find an exception for this one.]
			replace the regular expression "ing\b" in temp with ""; [and it will, because of tempule 1] [rule 2: remove -ing]
			if temp matches the regular expression ".*<^aeiouxy><aeiou>(<^aeiouwy>|s<^aeiou>)\b": [rule 3: add -e to -CVC]
				let temp be "[temp]e"; [The x in the first C group is a hack to fix "exiting" -> "exites".]
			replace the regular expression "(.+<aeiou>)(<tpkdbgvfr>)(\2)(\b)" in temp with "\1\2\4"; [rule 4: cut final character from -VCC]
		if the selection is third person singular:
			if temp matches the regular expression "(<aiousz>|ch|sh)\b":
				let temp be "[temp]e";
			otherwise:
				replace the regular expression "(<^aeiou>)y\b" in temp with "\1ie"; [This will never run if the above does, for performance reasons.]
			let temp be "[temp]s";
		replace the regular expression ".+ing\b" in T with temp;
	decide on T.

To decide what indexed text is the (selected action - stored action) fully conjugated in the (selection - grammatical person):
	change the actor part of the selected action to the player; [Remove the actor's name.]
	let R be indexed text;
	let R be the participle part of the selected action;
	let S be indexed text;
	let S be "[selected action]";
	let T be indexed text;
	let T be the selected action conjugated in the selection;
	replace the text R in S with T;
	decide on S.

To decide what indexed text is (selected action - stored action) conjugated in the (selection - grammatical person) progressive:
	change the actor part of the selected action to the player; [Remove the actor's name.]
	let T be indexed text;
	let T be "[copula conjugated in the selection] [selected action]";
	decide on T.

Verbal Conjugation ends here.

---- DOCUMENTATION ----

This is a deceptively simple extension to conjugate action names. By default stored actions always print the present participle ("taking the book"), which can lead to awkward prose. This extension provides three phrases to help with this.

	say "[the current action conjugated in the third person singular]"

This phrase would print "takes". You can, of course, use any stored action, grammatical person, and grammatical number you want. It doesn't have to be the current action, third person singular.

	say "[the current action fully conjugated in the third person singular]"

This phrase is similar to the above, but includes the objects and prepositions as well: "takes the book".

	say "[the copula conjugated in the first person singular]"

This phrase prints "am". Again, you can change the person and number to whatever you want.

	say "[the current action conjugated in the second person plural progressive]"

This one is a simple combination of the copula and the participle: "are taking the book". This is unlikely to be very useful, but is provided for a bit of variety.

Note that the first phrase is not always the same as first word of the second phrase: if an action name has multiple words before the noun, such as "taking inventory", the first phrase will return "takes inventory" instead of simply "takes".

This extension relies on Editable Stored Actions by Ron Newcomb, which you probably already have if you are using stored actions in prose.

One note: a few verbs do not follow the normal rules, and I haven't found a way to catch them aside from coding in specific exceptions (for example, "inter" -> "interring" but "enter" -> "entering"). In the end, I built a table for this to at least allow extensibility.
By default this Table contains all the irregular actionss in the Standard Rules: "tying", "entering", "answering", "listening", and "opening". If you define any new actions in your story which are not properly conjugated, add the stem to the Table of Grammatical Exceptions thus:

	Table of Grammatical Exceptions (continued)
	participle	stem
	"dying"		"die"

This particular verb is unlikely to be required in a story, but if it were it would require an exception. Note that only the participle is given, not the full action name ("answering" instead of "answering it that", for example).

Example: * Phase - A character who repeats the player's actions with a one turn delay.

	"Phase"
	
	Include Verbal Conjugation by Daniel Stelzer.
	
	The Library is a room. Your insubstantial shadow is a person in the Library. The shadow has a stored action called the plan.
	
	Every turn:
		say "The insubstantial shadow [one of][plan of the shadow fully conjugated in the third person singular][or]seems to [plan of the shadow fully conjugated in the third person plural][purely at random].";
		now the plan of the shadow is the current action.
	
	Persuasion: say "The shadow cannot hear you." instead.
	
	The bookshelf is an enterable supporter in the Library. On the bookshelf are a red book, a green book, and a blue book. 
	
	Test me with "wait / look / jump / l / get red book / get green book / put red book on bookshelf / x bookshelf / wait / wait". 
