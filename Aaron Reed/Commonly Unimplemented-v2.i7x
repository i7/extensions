Version 2 of Commonly Unimplemented by Aaron Reed begins here.

"Responds to attempts to interact with unimplemented clothing, body parts, or generic surroundings. Requires Smarter Parser by Aaron Reed."

Chapter - Compatibility

Section - Inclusions

Include Version 16 of Smarter Parser by Aaron Reed.

Chapter - Sequence

The flexible stripping body parts rule is listed before the unnecessary possessives rule in the Smarter Parser rules. The usually no clothing rule is listed before the unnecessary possessives rule in the Smarter Parser rules. The generic surroundings rule is listed before the unnecessary possessives rule in the Smarter Parser rules.

Chapter - Altering Lists

Section - Utility Functions - unindexed

To decide what indexed text is remove_list_word (wd - indexed text) from (thelist - an indexed text):
	unless wd is empty:
		replace the regular expression "\|[wd]" in thelist with "";
		decide on thelist;
	
To decide what indexed text is remove_list_words (wds - list of indexed texts) from (thelist - an indexed text):
	repeat with wd running through wds:
		now thelist is remove_list_word "[wd]" from thelist;
	decide on thelist;
		
To show_list_words for (thelist - an indexed text):
	let output be indexed text;
	now output is thelist;
	replace the regular expression "\(~!\|" in output with "";
	replace the regular expression "\)~?" in output with "";
	replace the regular expression "\|" in output with ", ";
	say output;
	say line break.
	
Section - Forward-facing phrases

To release body part word (wd - indexed text) from Smarter Parser:
	now body_part_words is remove_list_word wd from body_part_words.

To release body part words (wds - list of indexed texts) from Smarter Parser:
	now body_part_words is remove_list_words wds from body_part_words.
	
To say body part words:
	show_list_words for body_part_words.

To release clothing word (wd - indexed text) from Smarter Parser:
	now clothing_words is remove_list_word wd from clothing_words.

To release clothing words (wds - list of indexed texts) from Smarter Parser:
	now clothing_words is remove_list_words wds from clothing_words.
	
To say clothing words:
	show_list_words for clothing_words.
	
To release surroundings word (wd - indexed text) from Smarter Parser:
	now surroundings_words is remove_list_word wd from surroundings_words.

To release surroundings words (wds - list of indexed texts) from Smarter Parser:
	now surroundings_words is remove_list_words wds from surroundings_words.
	
To say surroundings words:
	show_list_words for clothing_words.	


Chapter - Rules

Section - New Stripping Body Parts

body_part_words is an indexed text variable. body_part_words is "(~!|eye|head|skull|hair|nose|mouth|ear|cheek|forehead|face|neck|chest|gut|breast|belly|stomach|body|nipple|shoulder|collar|arm|wrist|hand|finger|knuckle|fingernail|waist|thigh|leg|knee|shin|ankle|foot|feet|toe|elbow|fist|thumb|tongue|lip|heart)~".

A smarter parser rule when sp_normal (this is the flexible stripping body parts rule):
	let last_word_pos be the number of words in reborn command;
	let last_word be indexed text;
	now last_word is word number last_word_pos in reborn command;
	if sp_regex last_word starts with body_part_words:
		identify error as flexible stripping body parts rule;
		replace word number last_word_pos in reborn command with "_body";
		if stripping "(on|in) ?(the|his|her|a|their|my)? _body" is fruitful or stripping "[apostrophe]?s _body" is fruitful, even within words: 
			identify error as flexible stripping body parts rule;
			reparse the command;
		else:
			reject the command.

Table of Smarter Parser Messages (continued)
rule name	message
flexible stripping body parts rule	"[as the parser]You do not normally need to refer to parts of the body.[as normal]"


Section - Clothing

clothing_words is an indexed text variable. clothing_words is "(~!|clothes|shirt|pant|jacket|sock|shoe|belt|hat|underwear|jean|trouser|pocket)~".

A smarter parser rule when sp_normal (this is the usually no clothing rule):
	let last_word_pos be the number of words in reborn command;
	let last_word be indexed text;
	now last_word is word number last_word_pos in reborn command;
	if sp_regex last_word starts with clothing_words:
		identify error as usually no clothing rule;
		reject the command.

Table of Smarter Parser Messages (continued)
rule name	message
usually no clothing rule	"[as the parser]You do not normally need to refer to articles of clothing.[as normal]"

Section - Surroundings

surroundings_words is an indexed text variable. surroundings_words is "(~!|ground|floor|wall|corner|ceiling|sky)~".

A smarter parser rule when sp_normal (this is the generic surroundings rule):
	let last_word_pos be the number of words in reborn command;
	let last_word be indexed text;
	now last_word is word number last_word_pos in reborn command;
	if sp_regex last_word starts with surroundings_words:
		identify error as generic surroundings rule;
		reject the command.

Table of Smarter Parser Messages (continued)
rule name		message
generic surroundings rule		"[as the parser]Unless specifically mentioned by the text, avoid general concepts like the floor and ceiling. Try typing LOOK and then using verbs like TAKE or EXAMINE on the things you see mentioned.[as normal]"

Commonly Unimplemented ends here.

---- DOCUMENTATION ----

An extension for Smarter Parser, this provides three new rules that offer tutorial-style messages if the player tries interacting with unimplemented body parts, clothing, or generic surroundings like the floor or ceiling.

Chapter: Customizing

Frequently you actually *will* implement some of these things, and want to avoid misleading your players if they're using the right word but an incorrect syntax. You can alter the messages to help teach players the correct format (see below) but you can also keep the extension from triggering at all by excluding specific words from the match list.

To do this, probably in a "when play begins" rule, you can use either of the phrase variants:

	release body part word "skull" from Smarter Parser
	release body part words {"skull", "head", "hair"} from Smarter Parser
	
...as well as four other phrases to "release clothing word(s)" and "release surroundings word(s)." This will also stop plurals from matching as well. You can see a list of the current words with:

	say body part words
	
And likewise for the other two categories.

Chapter: Rules

Section: the flexible stripping body parts rule

Looks for commands that reference parts of the body. If the reference is in the form of an addendum like ON HIS SHOULDER or IN THE FACE, strip the addendum and reparse. Also tries to reparse something like LOOK AT LISA'S FACE as LOOK AT LISA. If a body part word is found outside either of these patterns, reject the command.

The default list is:

	eye, head, skull, hair, nose, mouth, ear, cheek, forehead, face, neck, chest, gut, breast, belly, stomach, body, nipple, shoulder, collar, arm, wrist, hand, finger, knuckle, fingernail, waist, thigh, leg, knee, shin, ankle, foot, feet, toe, elbow, fist, thumb, tongue, lip, heart
	
To change the message:

	*: Table of Smarter Parser Messages (continued)
	rule name	message
	flexible stripping body parts rule	"[as the parser]You do not normally need to refer to parts of the body.[as normal]"
	
To remove:

	*: The flexible stripping body parts rule is not listed in the Smarter Parser rulebook.
	
Section: the usually no clothing rule

Rejects commands which include mentions of common articles of clothing. The default list is:

	clothes, shirt, pant, jacket, sock, shoe, belt, hat, underwear, jean, trouser, pocket
	
To change the message:

	*: Table of Smarter Parser Messages (continued)
	rule name	message
	usually no clothing rule	"[as the parser]You do not normally need to refer to articles of clothing.[as normal]"
	
To remove:

	*: The usually no clothing rule is not listed in the Smarter Parser rulebook.	
	
Section: the generic surroundings rule

Rejects commands which include mentions of generic and probably unimplemented surroundings. The default list is:

	ground, floor, wall, corner, ceiling, sky
	
To change the message:

	*: Table of Smarter Parser Messages (continued)
	rule name		message
	generic surroundings rule		"[as the parser]Unless specifically mentioned by the text, avoid general concepts like the floor and ceiling. Try typing LOOK and then using verbs like TAKE or EXAMINE on the things you see mentioned.[as normal]"
	
To remove:

	*: The generic surroundings rule is not listed in the Smarter Parser rulebook.	
	
Example: ** Noses - Subtitle of this example.

Show how to easily prevent the extension from stepping on your toes.

	*: "Noses"

	Include Smarter Parser by Aaron Reed.
	Include Commonly Unimplemented by Aaron Reed.
	
	Stage is a room. Bob and Phil are people in Stage.
	A nose is a kind of thing. A nose is part of every person.
	
	Nose poking is an action applying to one thing. Understand "poke [something]" as nose poking. Check nose poking: if noun is not a nose, instead say "Only for noses!". Carry out nose poking: say "Strangely satisfying."
	
	When play begins: release body part word "nose" from Smarter Parser.
	
	Table of Smarter Parser Messages (continued)
	rule name	message
	flexible stripping body parts rule	"[as the parser]You do not normally need to refer to parts of the body; except in the case of noses, which you can try to POKE.[as normal]"
	
	test me with "x phil's nose / pick phil's nose / punch phil in the nose / poke phil's cheek / poke my nose" 
	 
