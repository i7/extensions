Version 2 of Snippetage by Dave Robinson begins here.

"Some functions for setting and use of snippets (parts of the player's command)."

To decide which snippet is the word at (N - a number): decide on the snippet at N of 1.

[ This is alternative phrasing. ]
To decide which snippet is the snippet of length (L - a number) at (N - a number): decide on the snippet at N of L.
[ This is alternative phrasing. ]
To decide which snippet is the snippet at word (N - a number) of length (L - a number): decide on the snippet at N of L.
[ This is alternative phrasing. ]
To decide which snippet is the snippet at (N - a number) of length (L - a number): decide on the snippet at N of L.

To decide which snippet is the snippet at (N - a number) of (L - a number):
	(- (100*{N} + {L}) -).

To decide what number is the command length:
	decide on the length of the player's command.

To decide what number is the length of (S - a snippet): (- {S}%100 -).
To decide what number is the start of (S - a snippet): (- {S}/100 -).
To decide what number is the end of (S - a snippet):
	let N be the start of S plus the length of S minus 1;
	decide on N.

To decide whether (S - a snippet) is valid:
	if the start of S is less than 1, decide no;
	if the length of S is less than 1, decide no;
	if the end of S is greater than the command length, decide no;
	decide yes.

To decide whether (S - a snippet) is invalid:
	if S is valid, decide no; otherwise decide yes.

To decide what number is the verb position: (- verb_wordnum -).

To decide what snippet is the command from (N - a number) onwards:
	let L be the command length plus 1 minus N;
	decide on the snippet at N of L.

To decide what snippet is the verb word:
	decide on the word at the verb position.

Snippetage ends here.

---- DOCUMENTATION ----

Snippetage has several rules to allow us to make and manipulate snippets more easily. Snippets in Inform 7 are fragments of the player's command that start at a certain word and go on for a certain number of words. This extension gives rules for working out what numbers are the start, end and length for snippets; it tells us if a snippet is valid or invalid, and it defines a couple of other handy things like the "verb word" snippet. Any valid snippet can be used in a say rule, or matched against a topic. So you can put:
	say "You used the verb [verb word]."

or
	if the word at the end of the player's command matches "bananas" ....

or
	if the snippet at the verb position of length 2 matches "look in" ...

A snippet is decided to be valid if its start is in the player's command and ends later in the player's command. So
	if the snippet at word 1 of length 0 is invalid, say "That snippet is invalid."

would indeed say it was invalid (because it has zero length), and
	if the snippet at the end of the player's command of length 2 is invalid, say "That snippet is invalid."

would also say the snippet is invalid, because it extends beyond the end of the player's command.

Example: * Pedantic Bob - Some simple printing and matching of snippets, and an input-quoting error message

	"Pedantic Bob"

	Include Snippetage by Dave Robinson.

	The Pit is a room. "The pit looks the same as ever, and quite inescapable. Apart, possibly, from [the red door] to the south."

	A door called a red door is south of the pit and north of Freedom. The description is "You have heard that the red door leads to freedom, but you don't know if you believe it.".
	The red door is lockable and locked.

	After going south from the pit, end the game in victory.
	Before entering the red door, try going south instead.

	Rule for writing a paragraph about the red door: now the red door is mentioned; rule succeeds.

	The brass key unlocks the red door.

	Bob is a man in the Pit. "Bob stands nearby.". The description is "Bob responds to commands. He doesn't usually obey them, but he often responds to them.".

	Asking Bob about something is attempting conversation.
	Telling Bob about something is attempting conversation.
	Answering Bob that something is attempting conversation.

	Before attempting conversation:
		say "Bob is not much interested in conversation, but he might respond to commands." instead.

	Instead of asking Bob to try doing something:
		if the verb word matches "x" begin;
			say "'X!' Bob cackles. 'X marks the spot!'";
		otherwise;
			let n be the verb position;
			if n is the end of the player's command, say "'I can [verb word] as much as you want,' Bob says. 'It won't help.'";
			otherwise say "'You want me to [verb word]?' Bob says. 'Are you sure you mean [command from verb position onwards]?'";
		end if.

	Instead of asking Bob to try examining the parrot when the verb word matches "describe":
		say "'Looks like a cockatoo to me,' Bob observes.";
		now the parrot is renamed.
	Instead of asking Bob to try examining the parrot, say "Bob looks over at [the parrot] and grunts boredly.".

	A parrot is an animal in the Pit. The parrot is neuter.
	"[A parrot] sits nearby giving the occasional squawk."
	The parrot can be renamed. The description is "[if renamed]A fine example of a cockatoo[otherwise]It looks like a parrot, but you're not sure[end if][if the parrot is holding the brass key]. It's holding a brass key[end if].".
	The parrot is holding a brass key.
	Before taking the brass key, if the parrot is holding the key, say "[The parrot] flutters away as you reach for the key." instead.
	Before taking the parrot, say "[The parrot] dodges away from you." instead.

	After reading a command: if the player's command is valid and a random chance of 1 in 3 succeeds begin;
		let n be the end of the player's command;
		say "'Awwwk [word at n] [word at n] [word at n]!' [the parrot] shrieks.";
	end if.

	Understand "bird" as the parrot.
	Understand "cockatoo" as the parrot when the parrot is renamed. The printed name of the parrot is "[if renamed]cockatoo[otherwise]parrot[end if]".

	Before asking a parrot to try doing something:
		if the word at 1 matches "parrot", say "'Parrot?' [the parrot] squawks. 'Who's a parrot?'" instead;
		if the word at 1 matches "it", say "'It?' [the parrot] squawks. 'Oh, I'm [italic type]it[roman type] now, am I?'" instead;
		if the word at 1 matches "bird", say "'Bird?' [the parrot] repeats incredulously. 'Is that the best you can do?'" instead.

	Before asking the parrot to try giving the brass key to someone, try asking the parrot to try dropping the brass key instead.

	Persuasion rule for asking the parrot to try doing something other than dropping:
		say "[The parrot] just squawks.";
		persuasion fails.
	Persuasion rule for asking the parrot to try dropping: if the parrot is holding the noun, persuasion succeeds; otherwise persuasion fails.

	After the parrot trying dropping the key, say "[The parrot] drops the key to the ground.".

In addition to annoying word-repeating characters, we can have a word-repeating parser, which repeats back words it didn't understand, something like this: 

	Rule for printing a parser error when parser error is not a verb I recognise:
		say "The verb '[verb word]' is not needed in this game.".

	Test me with "Examine parrot / It, drop key / Parrot, drop key / Bird, drop key / Bob, wait / Bob, x me / Bob, examine me / Bob, examine parrot / Bob, describe the parrot / Cockatoo, drop key / Scrape the cockatoo / Take the key / Unlock the door / Open it / South".
