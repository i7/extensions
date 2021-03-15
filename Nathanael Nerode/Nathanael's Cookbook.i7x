Version 2/171001 of Nathanael's Cookbook by Nathanael Nerode begins here.

"This is just a collection of worked examples illustrating various features of Inform.  There isn't actually anything in the extension per se, but the examples in the documentation can be click-pasted in the Inform IDE for convenience."

Nathanael's Cookbook ends here.

---- DOCUMENTATION ----

This is just a collection of examples.

Example: * Careful Startup -- displaying messages at the right time during startup

	*: "Careful Startup"

	Bedroom is a room.

	The description of Bedroom is "There's a double bed here."

	A bed is a kind of supporter.
	The latticework double bed is a bed in the bedroom.
	The description of the latticework double bed is "It's a double bed with a latticework headboard."
	
	The player is on the latticework double bed.  [This is the correct way to set a starting location.]

	This is the teaser rule:
		say "Nightmares.  Fear.  Running."

	The teaser rule is listed before the display banner rule in the startup rulebook.

	This is the introduce the game rule:
		say "You blearily open your eyes, shaking away dreams.  You're in your bed."

	The introduce the game rule is listed before the initial room description rule in the startup rulebook.
	[Note: "After the display banner rule" won't work, it'll end up after the initial room description.]

	This is the just before the prompt rule:
		say "Maybe you should get up.";
	The just before the prompt rule is listed after the initial room description rule in the startup rulebook.

	[ This is the default order of the startup rulebook:
	First come the very basic rules:
		initalize memory rule
		seed random number generator rule
		update chronological records rule
		declare everything initially unmentioned rule
		position player in model world rule
		start in the correct scenes rule
	Then come the so-called "mid-placed rules":
		when play begins stage rule
		fix baseline scoring rule
		display banner rule
		initial room description rule
	]

Example: * Mention Unmention -- controlling whether something is mentioned

	*: "Mention Unmention"

	To say mention (item - a thing):
		now item is mentioned;

	To say unmention (item - a thing):
		now item is not mentioned;

	A fruit is a kind of thing.
	A banana is a fruit.  The description of the banana is "It's a banana."
	An orange is a fruit.  The description of the orange is "It's an orange."
	A kiwi is a fruit.  The description of the kiwi is "You didn't notice it at first, but that's definitely a kiwi.";

	Fruit Room is a room.
	"This is a room for displaying fruit, such as [a list of fruit].[unmention banana][unmention orange]";

	The banana and the orange are in the fruit room.

Example: * Examine Room -- putting the room in scope

If you're in a room called "Main Street", you probably want "look at main street" to work.  By default, it doesn't.

	*: "Examine Room"

	Main Street is a room.
	"This is the center of the city, where it all happens!"

	After deciding the scope of an object (called character) (this is the put room in scope rule):
		Place the location of the character in scope, but not its contents.

	Rule for deciding whether all includes rooms:
		it does not.

	test me with "examine street/examine main street/take all".

Example: * Meeting Place -- using arbitrary binary relations

Use the full power of arbitrary binary relations, which are poorly documented in the Inform 7 manual.  Show how to specify an action applying to a thing in the room and a thing not in the room.

	*: "Meeting Place"

	Meeting Place is a room.

	A government is a kind of thing.

	US, UK, France, Germany, Russia, China, India, Pakistan are governments.

	Alpha, Beta, Gamma, Delta, Epsilon are people in Meeting Place.

	Trusting relates various people to various governments.
	The verb to trust means the trusting relation.

	Alpha trusts US.  Alpha trusts UK.
	Beta trusts US.  Beta trusts France.
	Gamma trusts China.  Gamma trusts France.

	Understand "ask [someone] about [any government]" as asking it opinion about.
	Asking it opinion about is an action applying to one thing and one visible thing.
	[Note the completely misleading and perverse use of "visible thing" to mean "thing not necessary touchable".]

	Report asking a person (called who) opinion about a government (called what):
		if who trusts what:
			say "[Who] [say] 'Great country, I'd love to live there.'";
		else:
			say "[Who] [say] 'Nice people there, but I wouldn't want to live under their government.'";

Example: *** Confusion -- polite responses for failed commands to actors

The default "There is no reply" is completely surreal for certain types of games.  This gives a reply which a *compliant* person might give.

	*: "Confusion"

	The Lounge is a room.  "It's a lounge."

	Alan is a man in the lounge.  Ella is a woman in the lounge.

	Persuasion rule for asking Alan to try doing something: persuasion succeeds.
	Persuasion rule for asking Ella to try doing something: persuasion succeeds.

	The confused by command rule is listed before the block answering rule in the report answering it that rulebook.

	Report an actor answering someone that (this is the confused by command rule):
		["noun, gibberish" is converted into "answer noun with the topic understood"]
		if the actor is the player:
			[The alternative is ordering someone else to say something]
			now the prior named object is nothing;
			say "[Noun] [seem] confused by your request." (A);
		stop the action.

	Table of Alan's Confusion Responses
	Response
	"[Noun] [look] at [us], perplexed, and [regarding noun][say] 'I don't know what you mean by ['][the topic understood]['].'"
	"[Noun] [say] 'I didn't understand that, dear.'"
	"[Noun] [say] 'Did you say ['][the topic understood][']?'  [They] [look] confused."

	Report an actor answering Alan that (this is the Alan is confused by command rule):
		["noun, gibberish" is converted into "answer noun with the topic understood"]
		if the actor is the player:
			[The alternative is ordering someone else to say something]
			now the prior named object is nothing;
			choose a random row from the Table of Alan's Confusion Responses;
			say response entry;
		stop the action.

	Table of Ella's Confusion Responses
	Response
	"[Noun] [look] at [us], perplexed, and [regarding noun][say] 'I don't get what you mean by ['][the topic understood]['].'"
	"[Noun] [say] 'I didn't understand that, darling.'"
	"[Noun] [say] 'Did you say ['][the topic understood][']?'  [They] [look] puzzled."

	Report an actor answering Ella that (this is the Ella is confused by command rule):
		["noun, gibberish" is converted into "answer noun with the topic understood"]
		if the actor is the player:
			[The alternative is ordering someone else to say something]
			now the prior named object is nothing;
			choose a random row from the Table of Ella's Confusion Responses;
			say response entry;
		stop the action.
