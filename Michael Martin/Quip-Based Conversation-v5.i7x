Version 5.1 of Quip-Based Conversation by Michael Martin begins here.

"An extension to Reactable Quips to allow for more traditional menu-based conversation."

Include Version 10.1 of Reactable Quips by Michael Martin.

[Version 5.1: Update for Inform 10.1 by Nathanael Nerode; just version number changes here and Reactable Quips.]
[Version 5/171116: Update for 6M62 by climbingstars.]
[Version 5: Update for 6E59. Removes references to deprecated features in Inform.]
[Version 4: Update for 5T18. Syntax and documentation updates; Version 3 should still work as long as RQ is the right version.]
[Version 3: Update for 5G67. Fixes an understanding precedence problem between RQ and QBC.  Gives better parser errors if garbage is typed while a conversation is live.]
[Version 2: Update for 4X60. Requires at least version 6 of RQ because previous versions don't work on 4X60.]
[Version 1: Initial release. We require at least version 3 of RQ because we rely on the conditional Understand commands to handle overrides.]

Section 1 - Cancelling ASK, TELL, and ORDERS

Before asking someone about (this is the reject asking for talking rule): clue talking instead.
Before telling someone about (this is the reject telling for talking rule): clue talking instead.
Before answering someone that (this is the reject answering for talking rule): clue talking instead.
Before asking someone to try doing something (this is the reject commanding for talking rule): clue talking instead.

The QBC talking cue is some text that varies. The QBC talking cue is usually "[bracket]Use TALK TO to interact with characters.[close bracket]".

To clue talking:
	say "[QBC talking cue][paragraph break]".

Section 2 - Member fields and default values

A person has a quip called a greeting.  The greeting of a person is usually quip_null.
A person has a table-name called the litany.  The litany of a person is usually the Table of No Conversation.  

[This is the currently active litany.]
The qbc_litany is a table-name that varies.  The qbc_litany is the Table of No Conversation.

Table of No Conversation
prompt	response	enabled
a text	a quip		a number

[QBC is never active if RQ is.]
To decide whether QBC is active:
	if the number of filled rows in the qbc_litany is not zero and not RQ is active, yes;
	no.

Section 3 - Initiating conversations

Talking to is an action applying to one visible thing.  Understand "talk to [something]" as talking to.

Check talking to (this is the can only talk to talkables rule): 
	if the noun provides the property litany and the noun provides the property greeting, do nothing; 
	otherwise say "Generally, it's best to talk to living things." instead.

Check talking to (this is the can only talk to people with things to say rule):
	if the greeting of the noun is quip_null and the number of filled rows in the litany of the noun is zero:
		say "[generic ask quip][paragraph break]" instead.

Carry out talking to (this is the basic talking to rule):
	if the greeting of the noun is not quip_null, deliver the greeting of the noun quip;
	if the number of filled rows in the litany of the noun is not zero:
		now the qbc_litany is the litany of the noun;
		display the QBC options.

[This is for when we have a Reactable Quips-style followup in the middle of a conversation.]
After responding with (this is the revert to normal conversation rule):
	display the QBC options.

To display the QBC options:
	if the story has ended, stop;
	if RQ is active, stop;
	let qbc_index be 0;
	repeat through qbc_litany:
		if the enabled entry is 1:
			increase qbc_index by 1;
			say "[bracket][qbc_index][close bracket] [prompt entry][line break]";
	if qbc_index is not 0, now the number understood is 0;
	otherwise terminate the conversation.

Does the player mean talking to a person: it is likely.

Section 4 - Delivering lines

QBC responding with is an action applying to one number.  Understand "[number]" or "say [number]" as QBC responding with when QBC is active.

Carry out QBC responding with (this is the perform talking rule):
	let qbc_index be 0;
	repeat through the qbc_litany:
		if the enabled entry is 1:
			increase qbc_index by 1;
			if qbc_index is the number understood:
				now the enabled entry is 0;
				deliver the response entry quip;
				display the QBC options;
				rule succeeds;
	follow the RQ out of range rules for qbc_index.

Section 5 - Recaps

QBC recapping is an action out of world applying to nothing.  Understand "repeat" or "recap" as QBC recapping when QBC is active.

Carry out QBC recapping (this is the perform QBC recapping rule):
	let qbc_index be 0;
	repeat through qbc_litany:
		if the enabled entry is 1:
			increase qbc_index by 1;
			if qbc_index is 1, say "[RQ options prologue][paragraph break]";
			say "[bracket][qbc_index][close bracket] [prompt entry][line break]";
	[This "can't happen" but there's no reason to not check.]
	if qbc_index is 0, say "[QBC no conversation error][paragraph break]";

The QBC no conversation error is some text that varies. The QBC no conversation error is usually "[bracket]You are not currently in a conversation.[close bracket]".

Section 6 - Utility functions

To enable the (q - a quip) quip for (o - a thing):
	repeat through the litany of o:
		if the response entry is q, now the enabled entry is 1.

To disable the (q - a quip) quip for (o - a thing):
	repeat through the litany of o:
		if the response entry is q, now the enabled entry is 0.

To enable the (q - a quip) quip:
	repeat through the qbc_litany:
		if the response entry is q, now the enabled entry is 1.

To disable the (q - a quip) quip:
	repeat through the qbc_litany:
		if the response entry is q, now the enabled entry is 0.

To shift the conversation to (t - a table-name):
	now the qbc_litany is t.

To run a conversation on (t - a table-name):
	shift the conversation to t;
	display the QBC options.

To terminate the conversation:
	now the qbc_litany is the Table of No Conversation.

Section 7 - Straightening out the parser

Before printing a parser error when QBC is active and the latest parser error is the didn't understand that number error:
	now the latest parser error is the didn't understand error.

Quip-Based Conversation ends here.

---- DOCUMENTATION ----

Quip-Based Conversation builds upon the Reactable Quips extension to provide a table-driven conversation system for NPCs smoothly handles Photopia or LucasArts-style conversation menus.  The player character may initiate conversation with a >TALK TO NPC command.  After an optional greeting exchange, the player selects dialogue from a menu.  Options may become available or unavailable as a result of these statements.  The basic functionality of Reactable Quips is retained; NPCs may occasionally say or do things that demand or imply some kind of reaction from the PC -- the player must then choose some option off a new menu to characterize the reaction.  After the reaction is selected, the traditional menus return.

Section: Defining quips

The most fundamental concept in the extension is the "quip".  Quips are values, not things; they are used to index into the quip tables.

Thus, the one task we must always perform is filling in the Table of Quip Texts.  A default table is provided by the extension, so you will need to continue the table in your own code:

	Table of Quip Texts (continued)
	quip	quiptext
	greeting	"'Why, hello there!'"
	discuss weather	"'Looks like rain, or my name isn't George Washington.'"
	standoff	"'What's it to you, Mac?'"
	silence	"You decide to remain silent for the moment."

Section: Making people talk

People have a "greeting" which is a quip that is delivered when you TALK TO them.  This defaults to the internal value "quip_null" which will result in no greeting and all, moving straight to options.

People also have a "litany" which is a table that holds their actual conversational options.  This defaults to the Table of No Conversation, in which no options are presented at all.  Other litanies have three columns: "prompt" - a string indicating the player's prospective line of dialogue; "response" - a quip that is the NPC's reply; and "enabled", a number that should be 1 if the line is available the first time the character is spoken to, and 0 otherwise.

	George is a man in the Cherry Orchard.  The greeting of George is greeting.  The litany of George is the Table of George Conversation.

	Table of George Conversation
	prompt	response	enabled
	"How's the weather look?"	discuss weather	1
	"How're your teeth doing?"	standoff	1
	"Say nothing"	silence	1

Rules may be attached to quips as usual; see the Reactable Quips documentation for how this works in detail.  Briefly, we use rulebooks associated with the quipping activity, and refer to the variable "the current quip" to determine which ones are in use.

A wide variety of phrases are available for use in these rules; most relevant are "enable the X quip" and "disable the X quip", where X is the name of the response quip you wish to make available in the current litany.  If you wish to enable or disable quips in other litanies, you may "enable/disable the X quip for Y" where Y is the name of the person in whose litany you wish to modify the option.  To modify or eliminate the default conversation characteristics of a character, the greeting or litany may be changed normally with commands like "change the litany of X to Y" -- however, changing the litany of a character will not modify the current conversation.  To modify that, you instead "shift the conversation to X".  To run a conversation without an attached person, you may "run a conversation on X".  This will not deliver a greeting quip.  Finally, when talking is done, one may "terminate the conversation".  This is an appropriate reaction to good-bye or say-nothing quips, depending on how they are handled.

Quips disable themselves by default when used.  For permanent quips (such as "say nothing", above), we must re-enable them by hand:

	After quipping when the current quip is silence: enable the silence quip.

If "silence" is shared across NPCs, this one rule will work for all of them.  For custom farewell quips, individual rules will be used.

Section: Intermingling conversation with other activities

Quips in a litany may have followups defined as per Reactable Quips; see the Reactable Quips documentation for details on how this works.  Note that while Reactions require a response from the player, ordinary conversation does not.  This is a departure from the Phototalk model, but tracks more modern works such as City of Secrets or Beyond.  If you wish to require conversation to continue until stopped, include the following code in your project.

	Before doing something when QBC is active (this is the QBC force conversation rule):
		unless the current action is QBC responding with or the current action is QBC recap, say "[bracket]I need some kind of reaction from you to continue the scene.  Enter a number, or say REPEAT to reacquaint yourself with your options.[close bracket][paragraph break]" instead.

	The QBC force conversation rule is listed first in the before rules.

This code may change across versions of Quip-Based Conversations, so if you upgrade mid-project, check this section again.  Also, make sure that all conversations have some option that that both re-enables itself and terminates the conversation, or players will get stuck!

If you keep the default, interruptible conversations, you will need to ensure that conversations terminate when the PC and the NPC being spoken to are no longer in the same location.  If NPCs do not move, a simple

	Before going: terminate the conversation.

will suffice; terminating a conversation that is not in progress is harmless.  If you wish to check to see if you are in a conversation, as we did above in the force conversation rule, the condition to check is

	if QBC is active

Section: Customizing messages

QBC builds upon Reactable Quips, and so most of the text customizations available there also apply to QBC. The most relevant are the "generic ask quip", which is printed if the player attempts to speak to an NPC whose litany is entirely exhausted and who has no greeting defined, and the RQ out of range rules, which are followed on invalid input.

QBC also defines two new text variables: The two new ones are the "QBC talking cue" - the hint to the player that TALK TO is the preferred verb for conversation - and the "QBC no conversation error", which is printed if a recap is forced when no conversation is active. The latter is unlikely to see use in normal circumstances.



Example: *** Joe Schmoe Revisited - A reimplementation of David Glasser's PHTALKOO.H example, with additions showing interaction with Reactable Quips and independent conversations.

	*:"Joe Schmoe Revisited"

	The story headline is "An Interactive Revisiting of the phtalkoo.h Test".
	Include Quip-Based Conversation by Michael Martin.
	Use no scoring and no deprecated features.

	Chapter 1 - The Setup

	When play begins, say "Joe Schmoe is yor frend!"

	Joe Schmoe's Place is a room.  "You are in Joe Schmoe's place."

	Joe Schmoe is a man in Joe Schmoe's Place.  The description is "This is Joe. It's yor frend!"  The litany of Joe Schmoe is the Table of Joe Comments.

	The greeting of yourself is selftalk.

	Casting Xyzzy is an action applying to nothing.  Understand "xyzzy" as casting xyzzy.  Carry out casting xyzzy: deliver the xyzzy quip; run a conversation on the Table of Magic Followups.

	Chapter 2 - The Script

	Section 1 - The Text

	Table of Quip Texts (continued)
	quip		quiptext
	selftalk		"Talking to yourself is not particularly fun."
	who-am-i	"'My name is Joe Schmoe and Inform hates me.'"
	why-hate	"'I tried to compile a game and it gave me 40 Problem messages.'"
	yay-inform	"'Thanks so much! You're the greatest!'"
	hate-you	"'I hate you!'[paragraph break] Joe kills you."
	hate-you-2	"'I hate you!'[paragraph break] Joe kills you."
	hate-you-3	"'I hate you!'[paragraph break] Joe kills you."
	hate-pedants	"'I hate pedants!'[paragraph break] Joe kills you."
	yay-monkeys	"'Of course I like monkeys.'"
	yay-you		"'Now we can be friends!'"
	say-nothing	"You decide not to say anything after all."
	ehn-apes	"'Apes are OK, I guess.'"
	ehn-lemurs	"'I don't really have an opinion on lemurs.'"
	xyzzy		"What's the other magic word?"

	Table of Joe Comments
	prompt					response	enabled
	"Who are you?"				who-am-i	1
	"Why does Inform hate you?"		why-hate	0
	"You probably just left out a semi-colon."	yay-inform	0
	"I don't care."				hate-you	0
	"Ha, ha. Inform hates you."		hate-you-2	0
	"Do you like a monkey?"			yay-monkeys	1
	"Only crazy people like monkeys."		hate-you-3	0
	"No, I said 'a monkey', not 'monkeys'."	hate-pedants	0
	"I like monkeys too."			yay-you		0
	"Say nothing"				say-nothing	1

	Table of Quip Followups (continued)
	quip		option			result
	yay-monkeys	"What about apes?"	ehn-apes
	yay-monkeys	"What about lemurs?"	ehn-lemurs

	Table of Magic Followups
	prompt					response	enabled
	"PLUGH"					yay-you		1
	"There are at least two; which one?"	hate-pedants	1

	Section 2 - Dialogue affects itself

	After quipping when the current quip is who-am-i:
		enable the why-hate quip;
		enable the hate-you quip.

	After quipping when the current quip is why-hate:
		disable the hate-you quip;
		enable the hate-you-2 quip;
		enable the yay-inform quip.

	After quipping when the current quip is yay-monkeys:
		enable the hate-you-3 quip;
		enable the hate-pedants quip;
		enable the yay-you quip.

	After quipping when the current quip is say-nothing:
		enable the say-nothing quip;
		terminate the conversation.

	Section 3 - Dialogue affects the game

	After quipping when the current quip is hate-you: end the story saying "You have died".
	After quipping when the current quip is hate-you-2: end the story saying "You have died".
	After quipping when the current quip is hate-you-3: end the story saying "You have died".
	After quipping when the current quip is hate-pedants: end the story saying "You have died".
	After quipping when the current quip is yay-inform: end the story finally saying "You have won".
	After quipping when the current quip is yay-you: end the story finally saying "You have won".

	Section 4 - Tests

	test me with "talk to me / x joe / talk to joe / 1 / x me / 1 / repeat / 3 / x me / 1 / 1".
	test xyzzy with "xyzzy / 1".
