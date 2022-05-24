Version 10.1 of Reactable Quips by Michael Martin begins here.

"A table-based approach to NPC conversation chains, as well as allowing rules to fire on lines of conversation."

[Version 10.1 - Version number update for Inform 10.1 by Nathanael Nerode.  The version number is a coincidence, I swear!]
[Version 10/220523 - Restore the ability to type "3" as well as "say 3".  It works under Inform 10.1 if specified separately.]
[Version 10/220522 - Update for Inform 10.1 by Nathanael Nerode.  Probably will still work with 6M62.]
[Version 10/171116 - Update for 6M62 by climbingstars.]
[Version 10 - Quick patch and update for 6E59, correcting the compilation problems and removing any reliance on deprecated features or syntax.]
[Version 9 - Updated for 5T18, correcting run-time problems and ducking some library bugs.]
[Version 8 - Made it cleaner for clients to check whether or not RQ is active.  Cleaned up the parser errors a little.]
[Version 7 - Remove the ugly hack from version 6 that copes with the 4X60 bug.]
[Version 6 - Add > SAY X syntax to match QBC. Allow delivery of nested quips. Make example clickable.  Basic quipping rule changed to be compatible with 4X60.]
[Version 5 - Made a procedural rule static.]
[Version 4 - Cleanups for indexing.  Rule ordering bugfix.  Removed redundant rules.  Permit current quip to change in a "before quipping" rule.  Reset the number understood when necessary to duck a parser issue.  Add a specification for quips.  Removed ugly hacks to make parser asides work right in versions of Inform predating version 4S08.]
[Version 3 - Replaced parentheses with brackets where appropriate, as is traditional for parser asides.  Removed the "wait silently" action by using conditional "understand" statements instead -- this produces sensible error messages in all circumstances as of version 3T38 of Inform 7.  Expanded documentation to show how default ask and tell quips can be individually universally redefined.  ]
[Version 2 - Modified "if index is the noun" to "if index is the number understood" to compensate for Inform 7's improved type checking in 3R85.  Improved the output of REPEAT, and added RECAP as a synonym.]
[Version 1 - Initial release.]

Section 1 - Quips

A quip is a kind of value.  The quips are defined by the Table of Quip Texts.  The specification of quip is "Represents a line or exchange of dialogue, which may be linked to other quips via followups or linked to ask or tell responses."

The current quip is a quip that varies. The current quip is quip_null.
The pertinent quip is a quip that varies.  The pertinent quip is quip_null.

A person has a quip called default ask quip. The default ask quip of a person is usually quip_null.
A person has a quip called default tell quip. The default tell quip of a person is usually quip_dtell.

Quipping is an activity.  The last for quipping rule (this is the basic quipping rule): say "[quiptext of the current quip][paragraph break]";

To deliver the (q - quip) quip:
	now the current quip is q;
	carry out the quipping activity;
	let rq_index be 0;
	repeat through Table of Quip Followups:
		if the current quip is the quip entry:
			increase rq_index by 1;
			say "[bracket][rq_index][close bracket] [option entry][line break]";
	if rq_index is not 0:
		now the pertinent quip is the current quip;
		now the number understood is 0;
	otherwise:
		now the pertinent quip is quip_null.

To nest the (q - quip) quip:
	let x be the current quip;
	now the current quip is q;
	carry out the quipping activity;
	now the current quip is x.

To decide whether RQ is active:
	If the pertinent quip is quip_null, no;
	yes.

Requesting a recap is an action out of world applying to nothing.  Understand "repeat" or "recap" as requesting a recap when RQ is active.

Carry out requesting a recap (this is the perform recap rule):
	let rq_index be 0;
	repeat through Table of Quip Followups:
		if the quip entry is the pertinent quip:
			increase rq_index by 1;
			if rq_index is 1, say "[RQ options prologue][paragraph break]";
			say "[bracket][rq_index][close bracket] [option entry][line break]";
	if rq_index is 0, say "[RQ no options][paragraph break]".

Responding with is an action applying to one number.
Understand "say [number]" as responding with when RQ is active.

Understand "[number]" as responding with when RQ is active.

[This rule Can't Run, as the Understand commands stand..]
[Carry out responding with when the pertinent quip is quip_null (this is the can't talk out of conversations rule): 
  say "[bracket]BUG: Responded despite there being no conversation options available![close bracket]".]

[Likewise, this test is redundant.]
Carry out responding with [when the pertinent quip is not quip_null] (this is the perform responding rule):
	let rq_index be 0;
	repeat through Table of Quip Followups:
		if the quip entry is the pertinent quip:
			increase rq_index by 1;
			if rq_index is the number understood:
				deliver the result entry quip;
				rule succeeds;
	follow the RQ out of range rules for rq_index.

Before doing something [other than requesting a recap or responding with] when the pertinent quip is not quip_null (this is the force conversation rule):
	unless the current action is requesting a recap or the current action is responding with:
		say "[RQ reaction demand][paragraph break]";
		stop the action.

The force conversation rule is listed first in the before rules.

This is the instant quip reaction rule:
	if RQ is active, rule succeeds.

The instant quip reaction rule is listed before the every turn stage rule in the turn sequence rules.

Section 2 - Hitword-based conversation

The block asking rule is not listed in any rulebook.
The block telling rule is not listed in any rulebook.
The block answering rule is not listed in any rulebook.

Carry out an actor asking someone about something (This is the RQ asking about rule): 
	repeat through Table of Ask Results:
		if the noun is the NPC entry:
			if the topic understood includes topic entry:
				deliver the result entry quip;
				rule succeeds; 
	if the noun is a person:
		say "[quiptext of the default ask quip of the noun][paragraph break]"; 
		rule succeeds; 
	say "[bracket]BUG: Managed to talk to [a noun], who is not a person![close bracket]";
	rule succeeds.

Carry out an actor telling someone about something (this is the RQ telling about rule): 
	repeat through Table of Tell Results:
		if the noun is the NPC entry:
			if the topic understood includes topic entry:
				deliver the result entry quip;
				rule succeeds; 
	if the noun is a person:
		say "[quiptext of the default tell quip of the noun][paragraph break]"; 
		rule succeeds; 
	say "[bracket]BUG: Managed to talk to [a noun], who is not a person![close bracket][paragraph break]";
	rule succeeds.

Carry out an actor answering someone that something (this is the RQ answering that rule): 
	repeat through Table of Tell Results:
		if the noun is the NPC entry:
			if the topic understood includes topic entry:
				deliver the result entry quip;
				rule succeeds; 
	if the noun is a person:
		say "[quiptext of the default tell quip of the noun][paragraph break]"; 
		rule succeeds; 
	say "[bracket]BUG: Managed to talk to [a noun], who is not a person![close bracket][paragraph break]";
	rule succeeds.

Section 3 - Quip Tables

Table of Quip Texts
quip		quiptext
quip_null	"[generic ask quip]"
quip_dtell	"[generic tell quip]"

Table of Quip Followups
quip (a quip)		option (text)		result (a quip)
with 1 blank row

Table of Ask Results
NPC (a person)		topic		result (a quip)
with 1 blank row

Table of Tell Results
NPC (a person)		topic		result (a quip)
with 1 blank row

Section 4 - Straightening out the parser

Before printing a parser error when RQ is active and the latest parser error is the didn't understand that number error:
	now the latest parser error is the didn't understand error.
  
Section 5 - Text overrides

The generic ask quip is some text that varies. The generic ask quip is usually "You can't think of anything to say on that topic.".
The generic tell quip is some text that varies. The generic tell quip is usually "You can't think of anything to say on that topic.".
The RQ options prologue is some text that varies. The RQ options prologue is usually "The available options are:".
The RQ reaction demand is some text that varies. The RQ reaction demand is usually "[bracket]I need some kind of reaction from you to continue the scene.  Enter a number, or say REPEAT to reacquaint yourself with your options.[close bracket]".
The RQ no options is some text that varies. The RQ no options is usually "[bracket]No responses are currently available.[close bracket]".
The RQ out of range rules are a number based rulebook.
An RQ out of range rule for a number (called max) (this is the basic RQ out of range rule): say "[bracket]Valid responses range from 1-[max].  Type REPEAT to relist the options.[close bracket][paragraph break]".

Reactable Quips ends here.

---- DOCUMENTATION ----

Reactable Quips provides a table-driven conversation system for NPCs that allows a mixture of traditional ask/tell and menu-based systems.  The intended model is that under normal circumstances, the player character may initiate conversation by asking or telling an NPC about a topic.  That NPC will then respond.  However, NPCs may occasionally say or do things that demand or imply some kind of reaction from the PC -- the player must then choose some option off a menu to characterize the reaction.

Regardless of the intended model, it is quite possible to use the extension to implement a pure ask/tell system.

Section: Defining and firing off quips

The most fundamental concept in the extension is the "quip".  Quips are values, not things; they are used to index into the quip tables.

Thus, the one task we must always perform is filling in the Table of Quip Texts.  A default table is provided by the extension, so you will need to continue the table in your own code:

	Table of Quip Texts (continued)
	quip	quiptext
	greeting	"'Why, hello there!'"
	discuss weather	"'Looks like rain, or my name isn't George Washington.'"
	standoff	"'What's it to you, Mac?'"

We then (if we are using the ask/tell model) use the Table of Ask Results and Table of Tell Results to attach quips to NPCs and topics.  The topics may be patterns, much like understanding commands as actions are.  However, the library will match against any text that contains the topic (much like the "Complimentary Peanuts" example in the Recipe Book).  The results are quips.

	Table of Ask Results (continued)
	NPC	topic	result
	Bob	"weather" or "nice day"	discuss weather

	Table of Tell Results (continued)
	NPC	topic	result
	Bob	"hi/hello"	greeting

People have a "default ask quip" and "default tell quip" that can be used to give a generic response to unknown topics.  This defaults to the first two quips in the table, which are predefined to "You can't think of anything to say on that topic."  If you wish to universally redefine either of these, redefine the globals "generic ask quip" or "generic tell quip".   See also "Customizing parser messages", below.

We can also script quip delivery:

	Instead of examining Bob, deliver the greeting quip.

Section: Attaching rules to quips

Quips can be attached to rules; however, quips aren't things, and so can't be treated as "something" or "anything."  Instead, we use rulebooks associated with the quipping activity:

	Before quipping when the current quip is greeting: say "You walk up and say hello."

Quips may require a reaction.  Possible responses (and the quips those responses lead to) are stored in the Table of Quip Followups:

	Table of Quip Followups (continued)
	quip	option	result
	greeting	"Make small talk"	discuss weather
	greeting	"Get down to business"	standoff

If a quip is in the table of quip followups, the game will not progress until a choice has been made.  If a quip does not appear in the table of quip followups, then after delivering the quip, normal gameplay resumes.

If you want to check on your own whether or not a response is being awaited, the condition to check is:

	if RQ is active

Section: Customizing parser messages

Most of the text produced by Reactable Quips can be modified.  The two most probable things to change are the "generic ask quip" and the "generic tell quip", which are the default message when you ask or tell/answer about a topic a person has no defined response to.  Both default to "You can't think of anything to say on that topic."

If the player attempts something that is not selecting a reaction when a reaction is required, the parser will usually reply with "[I need some kind of reaction from you to continue the scene.  Enter a number, or say REPEAT to reacquaint yourself with your options.]" To change this message, reassign "the RQ reaction demand."

If the player requests a recap of his options, it will preface the options with "The available options are:". To change that text, reassign "the RQ options prologue".  Ordinarily this can only happen when a reaction is pending, but in case it doesn't, the "RQ no options" text will be printed. This defaults to "[No responses are currently available.]".

If you wish to rewrite the error message for an invalid number, you will need to replace "the basic RQ out of range rule".  The RQ out of range rules operate on numbers; the number received is the maximum valid value at the time of the error.  Here is the entirety of the basic rule, for use as a template:

	An RQ out of range rule for a number (called max) (this is the basic RQ out of range rule): say "[bracket]Valid responses range from 1-[max].  Type REPEAT to relist the options.[close bracket][paragraph break]".

Example: * Security Consultant - Extracting useful information from an NPC.

	*: "Security Consultant"

	Include Reactable Quips by Michael Martin.

	The Vault is a room. A guard is a man in the Vault. Some treasure is in the vault. The default tell quip of the guard is t_badpassword.

	Instead of taking the treasure, say "The guard holds up a hand. 'I can't let you touch that unless you tell me the password.'"

	Table of Ask Results (continued)
	NPC	topic	result
	guard	"name"	a_name
	guard	"treasure"	a_treasure
	guard	"password"	a_password
	guard	"job/guard"	a_job
	guard	"anglerfish"	a_fish

	Table of Tell Results (continued)
	NPC	topic	result
	guard	"password"	t_password
	guard	"anglerfish"	t_fish
	guard	"treasure"	a_treasure

	Table of Quip Texts (continued)
	quip	quiptext
	a_name	"'My name's Gordon.'"
	a_treasure	"'Pretty fantastic, isn't it?'"
	a_password	"'The password is [']anglerfish['].'"
	a_job	"'I'm a guard. I guard things.'"
	a_fish	"'That's kind of above my pay grade. I guess it's some kind of fish?'"
	t_fish	"'That's the password! Sure, you can have the treasure.'"
	t_password	"'No, no, you have to tell me the password, not tell me [']the password['].'"
	t_badpassword	"'Sorry, that's not the password.'"

	After quipping when the current quip is t_fish: end the story finally saying "You have discovered a fatal security flaw".

	Test me with "ask guard about name / take treasure / ask guard about guard / guard, sesame / guard, password / tell guard about treasure / ask guard about treasure / ask guard about password / say anglerfish to guard".

Note that most traditional syntaxes for talking to NPCs will translate to TELL actions. Also note that a single line of dialogue may be recycled across ASK and TELL or even across NPCs by referring to the same quip multiple times.

Example: ** Think Fast - Reacting to sudden events with a choice from a menu.

The "deliver the X quip" command lets us move into reaction mode whenever we want; the trick is to make the choice mean something (by attaching rules to the followup quips) and to trigger the initial quip at the appropriate time.

	*: "Think Fast"

	Include Reactable Quips by Michael Martin.
	Use no scoring.

	The Playground is a room. "This grassy field is perfect for all kinds of sports. Something's happening off to the east."
	East of the playground is the Pitcher's Mound.

	Table of Quip Texts (continued)
	quip	quiptext
	Sudden Event	"As you walk over to the pitcher's mound, you hear a shout and something flies right at your face!"
	Victory	"You quickly raise your hand and pluck the missile out of the air. Looking at it closely, you see that it is a fabulous gem!"
	Evasion	"You expertly duck and the missile flies over your head, landing somewhere in the playground from whence you came."

	Table of Quip Followups (continued)
	quip	option	result
	Sudden Event	"Catch it"	Victory
	Sudden Event	"Duck it"	Evasion

	The fabulous gem is a thing. The description is "Shiny!"
	After quipping when the current quip is Victory: now the player holds the fabulous gem.
	After quipping when the current quip is Evasion: now the fabulous gem is in the Playground.

	Every turn: If the player carries the fabulous gem, end the story finally saying "You're fantastically wealthy!"

	Assault is a scene. Assault begins when the location is the Pitcher's Mound. When Assault begins: deliver the Sudden Event quip. Assault ends when the fabulous gem is not off-stage.

	Test catch with "e / 3 / 1".
	Test evade with "e / e / repeat / 2 / w / get gem".

We use a scene to trigger our starting quip for two reasons: first, to ensure it only happens once, and second, to ensure that the quip happens after the room description is printed.

Example: ** When Injokes Collide - Mixing conversation with reactions, and matching on complete phrases or complex topics.

	*: "When Injokes Collide"

	Include Reactable Quips by Michael Martin.

	Use American dialect, the serial comma, no deprecated features, and no scoring.

	Horace's House is a room.  A man called Horace is here.  "Your eccentric neighbor Horace is here, with a T-shirt that says 'TELL ME ABOUT YOURSELF.'"

	Table of Quip Texts (continued)
	quip			quiptext
	suggest monkeys		"'That's nice, I suppose.  But have I told you how awesome monkeys are?  You should ask me about monkeys!'"
	yay monkeys		"'Monkeys are awesome!  Anyone with [italic type]any[roman type] sense loves monkeys.  Did you know?  It was humans who unleashed Zero Wing on an unsuspecting universe.'"
	hate aybabtu		"Horace unleashes an unearthly howl.  'AIIIEEEEE!  NO!  Speak of it not!  Never again!  Hate you forever!  Die die die!!!!'[paragraph break]He leaps for your throat, wrestles you to the ground, and pummels the consciousness out of you. Death will follow soon enough..."
	apes ok			"'They're OK, I guess, but they're not nearly as great as monkeys.'"
	humans lousy		"'Humans in general are vastly inferior to monkeys.'"
	kindred spirit		"'Finally!  A kindred spirit!  My quest is finally over.  Take this briefcase as a token of my appreciation.'[paragraph break]He hands you a briefcase full of solid gold Krugerrands."
	speciesist		"'Oh, you're just speciesist like the rest of them.'"

	Table of Quip Followups (continued)
	quip			option			result
	humans lousy		"Fervently agree"		kindred spirit
	humans lousy		"Shrug indifferently"	speciesist

	Table of Ask Results (continued)
	NPC		topic						result
	Horace		"monkeys"					yay monkeys
	Horace		"lemurs/apes/gibbons/orangutans/bonobos/gorillas"	apes ok
	Horace		"humans/people/me/you/myself/yourself/himself/self"	humans lousy
	Horace		"All his/her/your base" or "All his/her/your base are belong to us/you/me" or "AYBABTU"	hate aybabtu

	Table of Tell Results (continued)
	NPC		topic		result
	Horace		"self/me/myself"	suggest monkeys

	After quipping when the current quip is hate aybabtu: end the story saying "You have no chance to survive make your time".
	After quipping when the current quip is kindred spirit: end the story finally saying "You have won".

	test winning with "ask horace about people / 3 / 1".

	test me with "tell horace about myself / ask horace about how awesome monkeys are / ask horace about humans / go east / repeat / 2 / ask horace about gibbons / ask horace about all his base".
