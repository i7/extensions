Version 1/121204 of Speech Motivations by Mike Ciul begins here.

"Player's thoughts and speech are expressed using the Thinking Privately and Speaking Out Loud activities. NPCs wait until end of turn rules to speak."

"based on Conversation Responses by Eric Eve"

Book - Includes

Include Epistemology by Eric Eve.

Include Scope Caching by Mike Ciul.

Include Disambiguation Override by Mike Ciul.

Include Plurality by Emily Short.

Book - Actor States

Part - Interlocutors

A person has an object called the interlocutor.

To decide what object is the current interlocutor: Decide on the interlocutor of the person asked.

[Not normally used for NPCs, but "Before conversing..." etc should be "Before an actor..."]

Part - Concerns

A person has an object called the concern.

Conversational state is a kind of value. Some conversational states are finished speaking, moved to speak, and waiting to speak.

A person has a conversational state.

Definition: A person is ready to respond if it is not finished speaking.

To decide what object is the current concern:
	decide on the concern of the person asked.

Part - Origins of Concerns

Chapter - Speech Motivation Values and Categories

A speech motivation is a kind of value. Some speech motivations are defined by the Table of Speech Motivations.

Table of Speech Motivations
Speech Motivation
idle
suggested
overheard
generally addressed
noticed
exclaimed
told
shown
asked
requested
offered

Relative cue publicity relates a speech motivation (called the first item) to a speech motivation (called the second item) when the first item is greater than the second item.
The verb to be more public than implies the relative cue publicity relation. The verb to be at least as private as implies the reversed relative cue publicity relation.

Relative cue privacy relates a speech motivation (called the first item) to a speech motivation (called the second item) when the first item is less than the second item.
The verb to be more private than implies the relative cue privacy relation. The verb to be at least as public as implies the reversed relative cue privacy relation.

Definition: A speech motivation is personal rather than general if it is at least exclaimed.

Definition: A speech motivation is private rather than public if it is less than generally addressed. [overheard, suggested, or idle]

Definition: A speech motivation is independent rather than prompted if it is less than overheard. [idle or suggested]

Definition: A speech motivation is imperative rather than optional if it at least asked. [asked, requested, or offered]

Definition: A speech motivation is visual rather than conceptual if it is shown or it is offered.

To decide whether (first reason - a speech motivation) has more importance than (second reason - a speech motivation):
	[if the first reason is imperative:
		decide on whether or not the first reason is more public than the second reason;
	if the second reason is imperative, no;]
	if the first reason is independent:
		decide on whether or not the first reason is more private than the second reason;
	if the second reason is independent, no;
	decide on whether or not the first reason is more public than the second reason;	
		
Relative cue importance relates a speech motivation (called the first item) to a speech motivation (called the second item) when the first item has more importance than the second item.
The verb to be more important than implies the relative cue importance relation. The verb to be no more important than implies the reversed relative cue importance relation.

Relative cue unimportance relates a speech motivation (called the first item) to a speech motivation (called the second item) when the second item has more importance than the first item.
The verb to be less important than implies the relative cue unimportance relation. The verb to be at least as important as implies the reversed relative cue unimportance relation.

Chapter - Character Motivations and Roles

A person has a speech motivation called the cue. The cue of a person is usually idle.

[use action-names instead?]

Definition: A person (called the listener) is expected to respond:
	if the cue of the listener is personal and the listener is moved to speak, yes;
	[if addressing the noun and the listener is the noun, yes;
	if addressing the second noun and the listener is the second noun, yes;]
	if seeking a response and the listener is the current interlocutor, yes;
	no.

Definition: a person (called the listener) is among the audience:
	[Make sure we have the right scope cached! - add checks to Scope Caching extension?]
	if the listener is not marked visible, no;
	if the listener is the person asked, no;
	[This is somewhat redundant, but it covers cases when a "marked visible" thing is removed from play]
	decide on whether or not the listener is enclosed by the location;

Definition: A person (called the listener) is eavesdropping:
	if the listener is the current interlocutor, no;
	if the listener is not among the audience, no;
	yes.

Chapter - Reactions to Non-Conversational Behavior

Carry out an actor examining something (this is the noun was noticed rule):
	if the current interlocutor is a person, alert the current interlocutor about the noun because noticed;

Last before an actor smelling or listening to something (this is the sensed noun was noticed rule):
	[We must catch the action before the check phase for these non-actions,
	but we must wait until after the interlocutor, etc. has been set]
	If the noun is a thing and the current interlocutor is a person, alert the current interlocutor about the noun because noticed;

[generic alerts for any time an object is a "focus of attention?"]

Part - Changing the Concern

The new subject matter is an object that varies.
The new reason is a speech motivation that varies.
The new interlocutor is an object that varies.

getting attention of something is an activity on objects.

To say alert (listener - a person) about (subject matter - an object) because (reason - a speech motivation):
	alert listener about subject matter because reason.

To alert (listener - a person) about (subject matter - an object) because (reason - a speech motivation):
	now the new subject matter is subject matter;
	now the new reason is reason;
	now the new interlocutor is the person asked;
	if the listener is the audience:
		Repeat with the member running through among the audience people:
			if the new reason is personal, now the new reason is generally addressed;
			carry out the getting attention activity with the member;
	otherwise:
		if the new interlocutor is the listener, now the new interlocutor is the interlocutor of the listener;
		carry out the getting attention activity with the listener;

[Just return a value instead, and let the phrase handle it?]

Before getting attention of the player (this is the make new subjects familiar rule):
	now the new subject matter is familiar;

[If someone is not finished speaking, we assume that their concern is not nothing]

Rule for getting attention of a person (called listener) (This is the don't repeat completed thoughts rule):
	unless the listener is done speaking about the new subject matter, continue the activity;
	If seeking a response, continue the activity;
	if the new reason is independent, continue the activity;
	deny motivation of the listener.

[Rule for getting attention of a person (called listener) (This is the make others think rule):
	if the listener is the player, continue the activity;
	unless the listener is finished speaking, continue the activity;
	if the new reason is not public, continue the activity;
	confirm motivation of the listener.]

[Rule for getting attention of a person (called listener) (This is the deny equal distractions rule):
	If the new reason is not the cue of the listener, continue the activity;
	If the listener is not moved to speak, continue the activity;
	deny motivation of the listener.]

Rule for getting attention of a person (called listener) (This is the preempt less important thoughts rule):
	if the listener is ready to speak after a speech motivation that is at least as important as the new reason, continue the activity;
	if the new reason is not personal and the new reason is not independent, continue the activity; [?]
	confirm motivation of the listener.

[We can get into weird loops pretty easily when there are multiple speakers talking about the same subject. This rule is an important way to prevent that, so it should be listed before most customized rules.]
The don't repeat completed thoughts rule is listed first in the for getting attention rulebook.

To confirm the/-- motivation of (listener - a person):
	Motivate listener to speak to the new interlocutor about the new subject matter for the new reason.

To deny the/-- motivation of (listener - a person):
	Do nothing [but useful for punctuating the end of a "for getting attention" rule].

To motivate (listener - a person) to speak to (motivated speaker - an object) about (subject matter - an object) because/for (reason - a speech motivation):
	if the subject matter is not the concern of the listener or motivated speaker is not the interlocutor of the listener:
		[What if we want to motivate the listener to speak to someone else about the same thing?]
		do nothing [or indent the next two lines];
	now the concern of the listener is the new subject matter;
	now the listener is moved to speak;
	now the interlocutor of the listener is the motivated speaker;
	now the cue of the listener is the new reason;

Chapter - Phrases for Getting Attention

To say forget the concerns of/for (listener - a person):
	forget the concerns of listener.
	
To forget the concerns of/for (listener - a person):
	if attention debugging is true, say "[bracket]Forgetting the concerns of [the listener]: [conversational state of the listener] about [the concern of the listener] because [cue of the listener].[close bracket][command clarification break]";
	Now the listener is finished speaking;
	Now the concern of listener is nothing;
	Now the cue of the listener is idle.

To say suggest (subject matter - an object) to (listener - a person):
	alert listener about subject matter because suggested;

To say suggest (subject matter - an object):
	alert the current interlocutor about subject matter because suggested;

To say bring up (subject matter - an object) with (listener - a person):
	alert the listener about subject matter because told;

To say bring up (subject matter - an object):
	alert the current interlocutor about subject matter because told;

Part - Speech Relations

Chapter - Mulit-Valent Phrases

To decide whether (the listener - a person) is concerned about (the subject matter - an object) because of/-- (the reason - a speech motivation):
	Decide on whether or not the listener is concerned about the subject matter and the listener is cued as the reason.

To decide whether (the listener - a person) is (the target state - a conversational state) about (the subject matter - an object) because of/-- (the reason - a speech motivation):
	Decide on whether or not the conversational state of the listener is the target state and the listener is concerned about the subject matter because of the reason.

To decide whether (the listener - a person) is ready to speak about (the subject matter - an object) because of/-- (the reason - a speech motivation):
	Decide on whether or not the listener is not finished speaking and the listener is concerned about the subject matter because of the reason.

Chapter - General Adjectives and Verbs

The verb to be cued as implies the cue property.

The verb to be concerned about implies the concern property.

The verb to be conversing with implies the interlocutor property.

Speech cueing relates a person (called motivated speaker) to a speech motivation (called current reason) when the motivated speaker is not finished speaking and the motivated speaker is cued as the current reason.

The verb to be ready to speak after implies the speech cueing relation.

Speech planning relates a person (called motivated speaker) to an object (called subject matter) when the motivated speaker is not finished speaking and the motivated speaker is concerned about the subject matter.

The verb to be ready to speak about implies the speech planning relation.

Definition: A person is currently speaking if it is the person asked and the speaking out loud activity is going on.

Definition: A person (called the motivated speaker) is responding:
	unless the motivated speaker is currently speaking, no;
	if the motivated speaker is expected to respond, yes;
	[Would this line work for NPCs too, without using the previous line?]
	if the motivated speaker is the player and the player is ready to speak about the subject of discussion, yes;
	no.

Response direction relates a person (called the motivated speaker) to a person (called the listener) when the motivated speaker is responding and the listener is the interlocutor of the motivated speaker.

The verb to be responding to implies the response direction relation.

Definition: A person is interjecting if it is currently speaking and it is not expected to respond.

Speech activity relates a person (called motivated speaker) to a speech motivation (called current reason) when the motivated speaker is currently speaking and the motivated speaker is ready to speak after the current reason.

The verb to be speaking after implies the speech activity relation.

Speech context relates a person (called motivated speaker) to an object (called subject matter) when the motivated speaker is finished speaking and the motivated speaker is concerned about the subject matter.

The verb to be done speaking about implies the speech context relation.

Definition: A person is speaking personally if it is speaking after a personal speech motivation.

Chapter - Offering and Requesting
	
Gift-offering relates a thing (called the gift) to a person (called the recipient) when the recipient is concerned about the gift because offered.

The verb to be offered to implies the gift-offering relation.

Definition: A thing is currently offered if it is offered to the person asked.

Gift-requesting relates a thing (called the gift) to a person (called the donor) when the donor is concerned about the gift because requested.

The verb to be requested from implies the gift-requesting relation.

Definition: A thing is currently requested if it is requested from the person asked.

Definition: A thing is pointlessly requested if it is currently requested and it is not enclosed by the person asked.

Book - Actor Behavior

Part - Refusal to Respond

Refusal to respond of something is an activity on objects. [people]

For refusal to respond of something:
	say "There is no response."

Part - Speaking Out Loud

Speaking out loud of something is an activity on objects. [subjects]

[For speaking out loud of something (called the subject matter) (this is the standard response to exclamations rule):
	if the person asked is not exclaimed, continue the activity;
	[handle hello and goodbye with knowledge of previous interlocutor?]
	say "[The person asked] acknowledge[s] your [speech abstraction of the concern of the person asked].";

To say the/-- speech abstraction of (subject matter - a thing):
	[printing the speech abstraction activity?]
	if subject matter is:
		-- yes: say "affirmation";
		-- no: say "denial";
		-- hello: say "greeting";
		-- goodbye: say "farewell";
		-- sorry: say "apology";
		-- otherwise: say "speech";]
	
For speaking out loud of something (called the subject matter) (this is the exclaiming out loud rule):
	unless an actor exclaiming something to, continue the activity;
	say "[The person asked] say[s] [if the subject matter is an exclamation][the subject matter][otherwise]'[the subject matter]'[end if] to [the current interlocutor relative to the person asked]."

For speaking out loud of something (called the subject matter) (this is the standard speaking out loud rule):
	if an actor quizzing something about:
		say "[The person asked] ask[s]";
	otherwise:
		say "[The person asked] tell[s]";
	say " [the current interlocutor] about [the subject matter relative to the current interlocutor]."

Before speaking out loud of something (called the subject matter) (this is the eavesdroppers rule):
	Repeat with listener running through every eavesdropping person:
		alert the listener about the subject matter because overheard.	

After speaking out loud of something (called the subject matter) (this is the off our chest rule):
	if the concern of the person asked is the subject matter, now the person asked is finished speaking;

Part - Responses

[borrow the Table of Locale Priorities]

Every turn (this is the handle NPC conversation rule):
	Carry out the handling conversation activity.

The handle NPC conversation rule is listed first in the every turn rulebook.

Handling conversation is an activity. [like printing the locale description, but the player, not the player's holder]

The initialise locale description rule is listed first in the before handling conversation rulebook.

Before handling conversation (this is the find motivated speakers rule):
	Carry out the choosing motivated speakers activity.

[TODO: Give everyone a chance to respond in the same turn, even if they don't have anything to say when handling conversation begins?]

For handling conversation (this is the everybody speaks rule):
	sort the Table of Locale Priorities in locale description priority order;
	repeat through the Table of Locale Priorities:
		if the notable-object entry is not finished speaking, try the notable-object entry trying voicing concerns;

After handling conversation (this is the reset concerns rule):
	repeat through the Table of Locale Priorities:
		Let the motivated speaker be the notable-object entry;
		[If the motivated speaker is finished speaking, forget the concerns of the motivated speaker;
		otherwise now the motivated speaker is waiting to speak.]
		if the motivated speaker is not finished speaking, now the motivated speaker is waiting to speak;
	[what do we do with the player here?]

Choosing motivated speakers is an activity.

Definition: a thing is other if it is not the player.

Before choosing motivated speakers (this is the forget the concerns of absent people rule):
	Repeat with the actor running through other people who are not marked visible:
		Forget the concerns of the actor;

For choosing motivated speakers (this is the expected to respond rule):
	Repeat with the potential speaker running through among the audience people:
		if the potential speaker is expected to respond:
			set the locale priority of the potential speaker to 5;
		otherwise if the potential speaker is moved to speak:
			set the locale priority of the potential speaker to 3;
		otherwise if the potential speaker is waiting to speak:
			set the locale priority of the potential speaker to 8;
		otherwise:
			set the locale priority of the potential speaker to 10;

Book - Actions for asking and telling about things

Part - Modifications for Old Actions and Grammar

Section - New Grammar

Understand the command "ask" as something new.

Understand "ask [someone] about [text]" as asking it about.

Understand the command "mention" as "answer".

Understand "tell [someone] [text]" as answering it that. Understand "tell [someone] that [text]" as answering it that.

Section - Conversational Kinds of Action

Asking something about is addressing the noun.
Asking something about is seeking a response.
Asking something about is speaking.

Asking something for is addressing the noun.
Asking something for is seeking a response.
Asking something for is speaking.

Answering something that is addressing the noun.
Answering something that is seeking a response.
Answering something that is speaking.

Telling something about is addressing the noun.
Telling something about is seeking a response.
Telling something about is speaking.

Section - Showing It To

Showing something to is addressing the second noun.
Showing something to is seeking a response.
The block showing rule is not listed in any rulebook.
Carry out showing something to someone (this is the noun was shown to the second noun rule):
	alert the second noun about the noun because shown;
Report showing something to something (this is the standard report showing it to rule):
	say "You show [the noun] to [the second noun relative to the noun].";

Section - Giving It To

Giving something to is addressing the second noun.
Giving something to is seeking a response.
The block giving rule is not listed in any rulebook.
The standard giving rule is not listed in any rulebook.
The standard report giving rule is not listed in any rulebook.
Carry out an actor giving something to someone (this is the noun was offered to the second noun rule):
	alert the second noun about the noun because offered;
Report an actor giving something to something (this is the standard report giving it to rule):
	say "[The actor] offer[s] [the noun] to [the second noun relative to the noun].";

[This relation provides a way for NPCs to give things to the player, either as a result of being asked, or spontaneously.
A modification of the can't take people's possessions rule is still necessary, though]

[TODO: tests for all conversational actions - perhaps distinguish between the actual action in progress and the successful gain of interlocutor's attention?]

[TODO: report an actor giving

Make it work so that when a person speaks out loud because requested, acceptance of request can be implemented by "try the actor trying giving the concern of the actor to the interlocutor of the actor" - or a phrase to do so.
]

Section - Blocking Topics

To say you-or-one:
	if the person asked is the player, say "you";
	otherwise say "one";

Check an actor answering something that (this is the block misparsed orders rule):
	if the player's command matches the text ",":
		say "'[The topic understood]' was not recognized as something you can ask someone to do.";
		stop the action;

The block misparsed orders rule is listed last in the check answering it that rulebook.

Check an actor telling something about (this is the block talking about topics rule):
	[what about unknown things? - watch out for Scope Caching bug with "any" token]
	Let the subject matter be the most likely match between the topic understood and "[any thing]";
	if something matched, say "[The person asked] can't think of anything to say about that right now.";
	otherwise say "'[The topic understood]' was not recognized as something [you-or-one] can talk about.";
	stop the action.

The block talking about topics rule is listed last in the check answering it that rulebook.
The block answering rule is not listed in the report answering it that rulebook.

The block talking about topics rule is listed last in the check telling it about rulebook.
The block telling rule is not listed in the report telling it about rulebook.

The block talking about topics rule is listed last in the check asking it about rulebook.
The block asking rule is not listed in the report asking it about rulebook.

Section - New Topic-based Actions

Inquiring it for is an action applying to one visible thing and one topic.
Understand "ask [someone] for [text]" as inquiring it for.
Inquiring something for is addressing the noun.
Inquiring something for is seeking a response.
Inquiring something for is speaking.

The block talking about topics rule is listed in the check inquiring it for rulebook.

The specification of the inquiring it for action is "This action provides handling for ASK SOMEONE FOR SOMETHING where SOMETHING is a topic rather than a thing, e.g. ASK BILL FOR ADVICE. This is the same as Eric Eve's 'Imploring it for,' which the author found difficult to remember."

Section - Topic-Based Commands with Nouns Left Out

Implicit-asking is an action applying to one topic.
Understand "ask about [text]" or "a [text]" as implicit-asking.
Implicit-asking is addressing the default.
Implicit-asking is seeking a response.
Implicit-asking is speaking.
Check implicit-asking: instead try asking the current interlocutor about it.

implicit-telling is an action applying to one topic.
Understand "t [text]" as implicit-telling.
Implicit-telling is addressing the default.
Implicit-telling is seeking a response.
Implicit-telling is speaking.
Check implicit-telling: instead try telling the current interlocutor about it.

implicit-inquiring is an action applying to one topic.
Understand "ask for [text]" as implicit-inquiring.
Implicit-inquiring is addressing the default.
Implicit-inquiring is seeking a response.
Implicit-inquiring is speaking.
Check implicit-inquiring: instead try inquiring the current interlocutor for it.

Part - Meaningful New Actions

Chapter - Fully-Specified Object-Based Actions

Section - Informing it About

Informing it about is an action applying to two visible things.
Understand "tell [someone] about [any known thing]" as informing it about.
Understand "tell [someone] that [any known thing]" as informing it about.
Understand "tell [someone] [any known thing]" as informing it about.
Understand "talk to/with [someone] about/regarding [any known thing]" as informing it about.
Informing something about is addressing the noun.
Informing something about is seeking a response.
Informing something about is speaking.

[For supplying a missing second noun when informing someone about (this is the bewildering swap nouns to supply a second noun for informing about a person rule):
	if the noun is a person:
		Now the second noun is the noun;
		Now the noun is the interlocutor of the player;
	otherwise:
		if the concern of the player is not nothing, now the second noun is the concern of the player;]

[Check an actor informing someone about (this is the redirect informing to talking about rule):
	instead try the actor talking about the second noun;]

Carry out an actor informing someone about something (this is the noun was told about the second noun rule):
	alert the noun about the second noun because told;

Report an actor informing something about (this is the speak the second noun out loud rule):
	Carry out the speaking out loud activity with the second noun;

The specification of the informing it about action is "This action responds to commands like TELL FRED ABOUT BOAT, where BOAT is a thing defined in the game, rather than a topic. This, perhaps the most common conversational action, is simply redirected to the talking about action after a Before rule sets the current interlocutor."

Section - Quizzing it About

Quizzing it about is an action applying to two visible things.
Understand "ask [someone] about [any known thing]" as quizzing it about.
Quizzing something about is addressing the noun.
Quizzing something about is seeking a response.
Quizzing something about is speaking.

[Check an actor quizzing someone about (this is the redirect quizzing to wondering about rule):
	instead try the actor wondering about the second noun;]

The speak the second noun out loud rule is listed in the report quizzing it about rules.

To say the (item - a thing) relative to (original item - a thing):
	If item is the original item [when speaking out loud?]:
		say itself-themselves;
	otherwise:
		if item is the player, say "you";
		otherwise say "[the item]".

For printing the name of the player when an actor addressing the noun and the player is the noun and the person asked is not the player: say "you".

[TODO: integrate with Ron Newcomb's quoted text?]

[To say the (item - a thing) relative to (original item - a thing):
	if item is original item, say itself-themselves of the second noun;
	otherwise say "[the item]"]

The specification of the quizzing it about action is "This action responds to commands like ASK FRED ABOUT BOAT, where BOAT is a thing defined in the game, rather than a topic.  This is simply redirected to the wondering about action after a Before rule sets the current interlocutor."

First check asking a female person about "herself" (this is the asking a woman about herself rule):
	instead try quizzing the noun about the noun.

First check asking a male person about "himself" (this is the asking a man about himself rule):
	instead try quizzing the noun about the noun.

First check asking a neuter person about "itself" (this is the asking a creature about itself rule):
	instead try quizzing the noun about the noun.

[Understand "herself" as a person when the item described is a female person.
Understand "himself" as a person when the item described is a male person.
Understand "itself" as a person when the item described is a person.]

Section - Requesting it For

Requesting it for is an action applying to two visible things.
Understand "ask [someone] for [any known thing]" as requesting it for.
Requesting something for is addressing the noun.
Requesting something for is seeking a response.
Requesting something for is speaking.

Carry out an actor requesting someone for something (this is the second noun was requested from the noun rule):
	alert the noun about the second noun because requested;

Report an actor requesting someone for something (this is the standard report requesting it for rule):
	say "[The actor] ask[s] [the noun] for [the second noun relative to the noun].";

The specification of the requesting it for action is "This action effectively replaces the library's asking it for action. Like asking it for it matches ASK BOB FOR SOMETHING, but unlike asking it for it makes no assumptions that this is equivalent to BOB, GIVE ME SOMETHING. Instead it can match any object known to the player, and the response can be anything we care to define."

[Section - Pointing it Out To

Understand the commands "show" and "present" and "display" as something new.

Pointing it out to is an action applying to two visible things.

Understand "show [something] to [something]" as pointing it out to.
Understand "show [someone] [something]" as pointing it out to (with nouns reversed).

Understand the commands "present" and "display" as "show".

Pointing something out to is addressing the second noun.
Pointing something out to is seeking a response.

The concern was shown rule is listed in the carry out pointing it out to rules.

The standard report showing it to rule is listed in the report pointing it out to rules.

The specification of the pointing it out to action is "This action is like showing it to, but it allows the player to show something that is not carried."]

Section - Exclaiming it To

An exclamation is a kind of subject. An exclamation is usually proper-named.

yes is an exclamation. Understand "yes/yep/yup/okay/ok/yeah/affirmative" as yes.
no is an exclamation. Understand "nah/naw/nope/negative/not" and "no way" as no.
sorry is an exclamation. Understand "apologies" and "I'm sorry" and "I apologize" and "my apologies" as sorry.
hello is an exclamation.  Understand "hi/greetings" as hello.
goodbye is an exclamation. Understand "farewell/bye/later/cheerio" and "good bye" as goodbye.

Understand the command "yes" as something new. Understand the command "no" as something new. Understand the command "sorry" as something new.

Exclaiming it to is an action applying to two visible things.

Understand "answer [any known thing] to [something]" as exclaiming it to.
Understand "answer [any known thing]" as exclaiming it to.
Understand "[any known exclamation]" as exclaiming it to.
Understand "t [any known exclamation]" as exclaiming it to.

Understand the command "exclaim" as "answer".

For supplying a missing second noun when exclaiming something to (this is the choose an interlocutor to exclaim to rule):
	[follow the addressing the default needs current interlocutor rule;]
	unless we found an interlocutor for the player:
		say "";
		rule fails;
	now the second noun is the current interlocutor.

Exclaiming something to is addressing the second noun.
Exclaiming something to is seeking a response.
Exclaiming something to is speaking.

[Check informing something about (this is the don't go all meta with exclamations rule):
	if the second noun is an exclamation, instead try exclaiming the second noun to the current interlocutor.

The don't go all meta with exclamations rule is listed in the check quizzing it about rulebook.]

Check answering someone that [when a thing (called the subject matter) is the known thing identified with the topic understood] (this is the convert answering it that to exclaiming rule):
	Let the subject matter be the most likely match between the topic understood and "[any known thing]";
	if the subject matter is not nothing, instead try exclaiming the subject matter to the noun;	
	[if something matched, do some disambiguation?]
		
Carry out an actor exclaiming something to someone (this is the noun was exclaimed to the second noun rule):
	alert the second noun about the noun because exclaimed;

Report an actor exclaiming something to (this is the speak the noun out loud rule):
	Carry out the speaking out loud activity with the noun;

[TODO: figure out why "better things to do" doesn't print anymore]

[Part - Ambiguously Directed Commands

Before asking someone to try ambiguously directed speech (this is the reverse ambiguous speech orders rule):
	Now the person asked is the player;

The reverse ambiguous speech orders rule is listed after the giving orders needs an interlocutor rule in the before rulebook.

Persuasion rule for asking people to try ambiguously directed speech (this is the allow ambiguously directed speech orders rule): persuasion succeeds.]

Chapter - Actions that Convert to Exclamations

Section - Greeting

greeting is an action applying to one visible thing.
Understand "greet [something]" as greeting.
greeting is addressing the noun.
greeting is seeking a response.
greeting is speaking.

Check greeting something:
	instead try exclaiming hello to the noun.

[Check greeting a person when the noun is the current interlocutor (this is the can't greet current interlocutor rule):
	if the noun is the player, say "Talking to yourself is unrewarding." instead;
	say "You are already talking to [the noun]." instead.

Check greeting something that is not a person (this is the can't greet inanimate objects rule):
	say "[The noun] do[if the noun is not plural-named and the noun is not the player]es[end if] not respond.";
	stop the action.

Carry out an actor greeting someone (this is the concern was a greeting rule):
	alert the noun about the person asked because greeted;

Report greeting someone (this is the default greeting rule):
  say "You say hello to [the noun]."

The specification of the greeting action is "This action responds to GREET FRED and SAY HELLO TO FRED - it's the transitive form of greeting."

[TODO: Make sure "NPC, hello" still works]

Section - Saying Hello

saying hello is an action applying to nothing.
Understand "hello" or "hi" or "say hello/hi" as saying hello.
saying hello is addressing the default.
saying hello is seeking a response.
saying hello is ambiguously directed speech.
saying hello is speaking.

Check saying hello (this is the standard saying hello rule):
	instead try greeting the current interlocutor.
  
The specification of the saying hello action is "This action, phrased as HELLO or SAY HI, causes the player to greet the current interlocutor if one can be found, or the general assembly if there are multiple choices. In contrast to 'saying hello to' in Eric Eve's extension, this is intransitive."

Section - Saying Goodbye

Saying goodbye to is an action applying to one visible thing.
Understand "say bye/goodbye/farewell/cheerio to [someone]" as saying goodbye to.
Saying goodbye to is addressing the noun. [omit?]
Saying goodbye to is seeking a response. [omit?]
Saying goodbye to is speaking.

Check saying goodbye to something when the noun is not the current interlocutor (this is the can't say goodbye to someone you're not talking to rule):
	say "You're not talking to [the noun]." instead.

Carry out an actor saying goodbye to something (this is the concern was a goodbye rule):
	alert the noun about the person asked because parted.

Last carry out an actor saying goodbye to something (this is the reset interlocutor on saying goodbye rule):   
	now the interlocutor of the actor is nothing.

Report saying goodbye to someone (this is the default saying goodbye rule):
	say "You say goodbye to [the noun]."

Understand "bye" or "goodbye" or "cheerio" or "farewell" as saying goodbye to.

For supplying a missing noun when saying goodbye to (this is the choose an interlocutor to say goodbye to rule):
	if the current interlocutor is not among the audience:
		say "You're not talking to anyone." instead;
	now the noun is the current interlocutor;]

Section - Yes, No and Sorry

[TODO: alert the listener]

Understand "nod" and "nod yes" as saying yes.

[Check answering someone that "[yes]" (this is the change answering yes to saying yes rule):
	try saying yes instead.]
The block saying yes rule is not listed in any rulebook.
saying yes is addressing the default.
Saying yes is seeking a response. [omit?]
[Saying yes is ambiguously directed speech.]
Saying yes is speaking.

Check saying yes (this is the convert saying yes to exclaiming yes rule):
	instead try exclaiming yes to the current interlocutor;

Understand "shake head" and "shake my head" and "shake head no" and "shake my head no" as saying no.

[Check answering someone that "no" (this is the change answering no to saying no rule):
	try saying no instead.]
The block saying no rule is not listed in any rulebook.
saying no is addressing the default.
Saying no is seeking a response. [omit?]
[Saying no is ambiguously directed speech.]
Saying no is speaking.

Check saying no (this is the convert saying no to exclaiming no rule):
	instead try exclaiming no to the current interlocutor;

Understand "apologize" and "apologise" as saying sorry.

[Check answering someone that "sorry" (this is the change answering sorry to saying sorry rule):
	try [asking the noun to try] saying sorry instead.]
The block saying sorry rule is not listed in any rulebook.
saying sorry is addressing the default.
Saying sorry is seeking a response. [omit?]
[Saying sorry is ambiguously directed speech.]
Saying sorry is speaking.

Check saying sorry (this is the convert saying sorry to exclaiming sorry rule):
	instead try exclaiming sorry to the current interlocutor;

Part - Commands With Nouns Left Out

Section - Talking With

Talking with is an action applying to one visible thing.
Understand "answer [someone]" as talking with.
Understand "to/with" and "[so out loud] to/with" as "[so out loud to]".
Understand "talk [so out loud to] [someone]" as talking with.
Understand "answer [so out loud to] [someone]" as talking with.
Understand "t to/with [someone]" as talking with.

Talking with is addressing the noun.
Talking with is seeking a response.
Talking with is speaking.

[We're getting into some uncomfortable rule juggling here. These should be Check rules, but they need to happen before the current interlocutor is changed by the address the noun rule.

Perhaps we don't want "talking with" to be "addressing the noun" at all - it could be a non-talking action that always redirects to a talking action?

Or maybe we always want to forget the concern when changing interlocutors?]

Before talking with (this is the let's talk about you rule):
	instead try quizzing the noun about the noun.

The let's talk about you rule is listed before the address the noun rule in the before rulebook.
	
Before talking with (this is the greet the new interlocutor when talking with rule):
	[do we want greeted/ungreeted properties?]
	if the noun is the interlocutor of the player, continue the action;
	instead try exclaiming hello to the noun;

The greet the new interlocutor when talking with rule is listed before the let's talk about you rule in the before rulebook.

Before talking with (this is the voice concerns when talking with rule):
	if the concern of the player is nothing or the interlocutor of the player is not the noun, continue the action;
	instead try informing the noun about the concern of the player;

The voice concerns when talking with rule is listed before the greet the new interlocutor when talking with rule in the before rulebook.

[why does this produce an error?
The specification of the talking with action is "This action responds to commands like TALK TO FRED. It causes the actor to switch interlocutors if necessary, and talk about the current concern."]

Section - Voicing Concerns

Voicing concerns is an action applying to nothing.
Understand "mind/out/aloud" and "out loud" and "my/your/his/her/its mind" as "[out loud]".
Understand "about it/that" and "it/that/so" as "[so]".
Understand "[so]", "[out loud]", and "[so] [out loud]" as "[so out loud]".
Understand "t", "talk",  "talk [so out loud]", "answer", "answer [so out loud]" as voicing concerns.
Voicing concerns is addressing the default.
Voicing concerns is seeking a response.
Voicing concerns is speaking.

Check an actor voicing concerns when the current concern is nothing (this is the nothing to say rule):
	if the actor is the player:
		say "You can't think of anything to talk about right now.";
	otherwise if the actor is expected to respond:
		carry out the refusal to respond activity with the actor;
	stop the action.

Check an actor voicing concerns (this is the refusing to repeat oneself rule):
	if the actor is not the player and the actor is finished speaking and the actor is expected to respond:
		carry out the refusal to respond activity with the actor;
		stop the action.

[Carry out an actor voicing concerns (this is the voiced concern was told rule):
	alert the current interlocutor about the current concern because told;

Report an actor voicing concerns (this is the standard report voicing concerns rule):
	Carry out the speaking out loud activity with the concern of the actor;]

Check an actor voicing concerns (this is the redirect voicing concerns to informing it about rule):
	instead try the actor informing the current interlocutor about the concern of the actor;

The specification of the voicing concerns action is "This action responds to the simple command TALK, and causes the actor to talk with the current interlocutor about the current concern."

Section - Talking About

Talking about is an action applying to one visible thing.
Understand "t [any known thing]" or "talk about [any known thing]" as talking about.

Understand "answer [any known thing]" as talking about.
talking about is addressing the default.
talking about is seeking a response.
talking about is speaking.

Check an actor talking about: instead try the actor informing the current interlocutor about the noun.

[Carry out an actor talking about something (this is the noun was told rule):
	alert the current interlocutor about the noun because told;

]

The specification of the talking about action is "Talking about something assumes the default interlocutor, but it allows the actor to speak out loud about something other than his or her current concern. The actor's concern remains unchanged during the action, though responses from other actors may change it later."

Section - Wondering About

wondering about is an action applying to one visible thing.
Understand "ask about [any known thing]" or "a [any known thing]" as wondering about.
wondering about is addressing the default.
wondering about is seeking a response.
wondering about is speaking.

Check an actor wondering about: instead try the actor quizzing the current interlocutor about the noun.

[Carry out an actor wondering about something (this is the noun was asked rule):
	alert the current interlocutor about the noun because asked;

The speak the noun out loud rule is listed in the report wondering about rulebook;]

The specification of the wondering about action is "Wondering about assumes the default interlocutor, but allows the actor to ask a question about something other than his or her current concern. As with talking about, the concern remains unchanged."

[Section - Pointing At

pointing at is an action applying to one visible thing.
Understand "show [something]" and "point out/at/to/towards [something]" as pointing at.

Pointing at is addressing the default.
Pointing at is seeking a response.

Carry out an actor pointing at something (this is the noun was shown rule):
	alert the current interlocutor about the noun because shown;

Report an actor pointing at something:
	say "[The actor] point[s] to [the noun].";

The specification of the pointing at action is "Pointing at assumes the default interlocutor, but it does not assume that the actor is speaking."]

Section - Begging For

begging for is an action applying to one visible thing.
Understand "ask for [any known thing]" as begging for.
begging for is addressing the default.
begging for is seeking a response.
begging for is speaking.

Check an actor begging for (this is the request the owner for the begged item rule):
	if the noun is enclosed by a not expected to respond person (called the owner) who is among the audience, instead try requesting the owner for the noun;
	
Check an actor begging for (this is the redirect begging to requesting rule): instead try the actor requesting the current interlocutor for the noun.

Part - Protocols for All Conversation Actions

Chapter - Setting the Current Interlocutor

Section - Finding an Interlocutor Before Talking

To say itself-themselves:
	say itself-themselves of prior named noun.

To say itself-themselves of (item - a thing):
	if item is the player, say "your";
	otherwise say it-them of item;
	if item acts plural, say "selves";
	otherwise say "self"

Before an actor addressing the default when the current interlocutor is the person asked (this is the address the assembly instead of talking to yourself rule):
	now the interlocutor of the actor is the audience;

Before an actor addressing the default (this is the addressing the default needs current interlocutor rule):
	unless we found an interlocutor for the actor, stop the action;

Finding an interlocutor something is an activity on objects.

To decide whether we found an interlocutor for (actor - a person):
	Carry out the finding an interlocutor activity with actor;
	Decide on whether or not the interlocutor of actor is not nothing;

For finding an interlocutor for someone (called actor) (this is the continue talking with present interlocutor rule):
	unless the interlocutor of the actor is a person who is among the audience, continue the activity;

For finding an interlocutor for someone (called actor) (this is the stop talking with absent interlocutor rule):
	if the interlocutor of the actor is nothing or the interlocutor of the actor is the audience, continue the activity;
	say "[The interlocutor of the actor] [is-are]n't here.";
	now the interlocutor of the actor is nothing;

[TODO: exclaiming doesn't require an interlocutor, or assumes the parser as an interlocutor?]

For finding an interlocutor for someone (called actor) (this is the address the whole audience rule):
	let np be the number of people who are among the audience;
	if np is 0:
		if exclaiming something to:
			now the interlocutor of the actor is the actor;
		otherwise:	
			if the actor is the player, say "There's no one here to talk to.";
			now the interlocutor of the actor is nothing;
		rule succeeds;
	if np is not 1:
		now the interlocutor of the actor is the audience;
		if the actor is the player, say "(addressing [the audience])";
		rule succeeds;
  	now the interlocutor of the actor is a random person who is among the audience;
    	if the actor is the player, say "(addressing [the interlocutor of the actor])";
	[if the candidate is not a person:
		if the actor is the player, say "You're not talking to anyone.";
		now the interlocutor of the actor is nothing;]

Before an actor addressing the noun when the current interlocutor is not the noun (this is the address the noun rule):
	now the interlocutor of the actor is the noun;
	If the current interlocutor is not the noun, stop the action.
	
Before an actor addressing the second noun when the second noun is not the current interlocutor (this is the address the second noun rule):        
	now the interlocutor of the actor is the second noun;
	if the current interlocutor is not the second noun, stop the action.

Before asking someone to try doing something when the person asked is not the current interlocutor (this is the giving orders needs an interlocutor rule):
	now the interlocutor of the player is the person asked;

[Before giving something to someone when the second noun is not the current interlocutor (this is the giving needs an interlocutor rule):
  if the current interlocutor is not a person, abide by the addressing the default needs current interlocutor rule;
  start talking to the second noun;
  if the second noun is not the current interlocutor, stop the action.]

Section - Resetting the Interlocutor

audience is a plural-named person. The printed name of audience is "anyone who can hear".

For printing the name of audience when someone is among the audience: say "[the list of people who are among the audience]"

Accessibility rule when the audience is expected to respond (this is the allow speaking to offstage audience proxy rule): Rule succeeds.

[the audience must be proper-named, so we don't have any extra 'the's in the list]

Carry out an actor going (this is the don't say goodbye when moving rule):
	[if the current interlocutor is among the audience:]
        	now the interlocutor of the actor is nothing;

The don't say goodbye when moving rule is listed first in the carry out going rules.

Section - Losing the Audience (for use with Lost Items by Mike Ciul)
	
Did we lose the audience: We didn't.

Book - Limiting what can be spoken about

To decide whether drawing attention to (item - an object):
	if the noun is item and not addressing the noun, yes;
	if the second noun is item and not addressing the second noun, yes;
	no.

To decide whether drawing attention to (O - a description of objects):
	[Calling this phrase can be faster than testing an adjective for all things]
	if the noun matches O and not addressing the noun, yes;
	if the second noun matches O and not addressing the second noun, yes;
	no.

Definition: An object is a focus of attention if drawing attention to it.

To decide which object is the subject of discussion:
	[This won't work with voicing concerns or talking with,
	 but both of those actions redirect to informing it about, which does work.]
	[this only works outside of DPMR]
	if an actor addressing the noun, decide on the second noun;
	[This only works for the player in DPMR]
	if addressing the noun, decide on the second noun;
	[This one is needed if DPMR involves a requested action]
	if asking someone to try addressing the noun, decide on the second noun;
	[Same deal with DPMR for these three]
	if an actor seeking a response, decide on the noun;
	if seeking a response, decide on the noun;
	if asking someone to try seeking a response, decide on the noun;
	decide on nothing.
	
To decide whether discussing (item - an object):
	decide on whether or not item is the subject of discussion;

To decide whether discussing (O - a description of objects):
	decide on whether or not the subject of discussion matches O.

Definition: An object is being discussed if it is the subject of discussion.
	
To decide whether discussing (item - an object) with (listener - a person):
	if listener is not expected to respond, no;
	decide on whether or not drawing attention to item.

To decide whether discussing (O - a description of objects) with (listener - a person):
	if listener is not expected to respond, no;
	decide on whether or not discussing O;

[description of objects?]

Check quizzing someone about something unknown (this is the block talking about something unknown rule):
	say "That's not a subject you're familiar with.";
	stop the action.

The block talking about something unknown rule is listed in the check informing it about rulebook.

Carry out an actor quizzing someone about something (this is the noun was asked about the second noun rule):
	alert the noun about the second noun because asked;

To say make (obj - a thing) known/familiar:
	now obj is familiar.

To say make (obj - a thing) unfamiliar:
	now obj is unfamiliar.

Book - Testing Flags

[These must be included in the release to enable certain phrases]

Attention debugging is a truth state that varies.

Book - Testing - Not For Release

Turning on attention debugging is an action out of world applying to nothing. Understand "attention" as turning on attention debugging.

Turning off attention debugging is an action out of world applying to nothing. Understand "attention off" as turning off attention debugging.

Carry out turning on attention debugging: Now attention debugging is true.
Carry out turning off attention debugging: Now attention debugging is false.

Report turning on attention debugging: say "Attention debugging is now on. Type 'attention off' to switch it off again."
Report turning off attention debugging: say "Attention debugging is now off."

Before getting attention of someone (called the listener) when attention debugging is true:
	say "[bracket]Getting attention of [the listener] ([conversational state of the listener] about [concern of the listener] because [cue of the listener]) - about [the new subject matter] because [the new reason] by [the person asked].[close bracket][command clarification break]";

After getting attention of someone (called the listener) when attention debugging is true:
	say "[bracket][The listener] is now [conversational state of the listener] about [concern of the listener] because [cue of the listener].[close bracket][command clarification break]";

Speech Motivations ends here.

---- DOCUMENTATION ----

Section: Introduction

Speech Motivations builds on some of the ideas in Eric Eve's conversation extensions - conversation revolves around in-world objects rather than arbitrary text topics - but it changes the way the PC and NPCs carry out their actions. A conversational action is treated simply as the act of speaking, and if another person chooses to respond, they do so during the Every Turn phase, with their own separate action.

This extension requires Plurality by Emily Short, which must be installed on your system.

Section: Overview of Actions

A large number of actions are created by Speech Motivations, but for most conversation, their exact nature is not important. They are grouped into kinds of action, and various tests can be performed to determine what sort of exchange is intended.

The major kinds of action are "speaking" and "seeking a response." Most conversational actions count as both, but some are only one. Saying yes, no, and sorry, for example, are speaking without seeking a response. On the other hand, showing or giving an object to someone are seeking a response without speaking. Of course the actor may be described as speaking, but the intention of these kinds of action is to say whether it is necessary to speak in order to carry them out, and whether the listener will always be expected to respond.

Three more mechanical kinds of action are "addressing the noun," "addressing the second noun," and "addressing the default." Most likely we will not need to refer to these, but in case we do, they mean pretty much what one might expect: Informing someone about something is addressing the noun, while showing something to someone is addressing the second noun. If no interlocutor is specified but the action is conversational anyway, it counts as "addressing the default."

Many actions created by Speech Motivations have nouns left out. In fact, there is one, "voicing concerns," which takes no nouns at all. All conversational actions refer to various properties of the speaker - when they are specified, they either override or set those properties, and when they are not specified, they make use of them.

Section: Overview of Properties

Every person is given four properties by Speech Motivations: The interlocutor, the concern, the speech motivation, and an anonymous condition indicating whether they are finished speaking, moved to speak, or waiting to speak. The interlocutor is the person the actor is talking to. The concern is the subject on the actor's mind. The speech motivation tells what drove the actor to speak. The condition indicates whether the person is going to attempt to speak this turn.

These properties are handled somewhat differently depending on whether the actor is the player or not. Let's start with NPCs.

The interlocutor must be a person who can see or hear the speaker. However, it is possible to set the interlocutor to "nothing" and still have a conversation: It assumed in this case that the speaker is addressing the room, and that every person who can hear is equally expected to respond.

Actions that specify who to talk to will always set the interlocutor. If the action does not specify, then the current interlocutor is assumed. If the current interlocutor is absent, or there is no one to talk to, the action will be blocked.

The concern of a person is the subject that they want to talk about. For an NPC, hearing someone else speak will provide an opportunity to change that character's concern. If a conversational action does not specify a subject, the concern of the speaker will be assumed. However, it is always possible for a person to speak about something other than their own concern by specifying that in their action. This will not change their own concern by default.

The cue of a person indicates how their concern got into their head. The speech motivations are ordered from most private and self-directed to most public and externally influenced:

	idle (the default state)
	suggested (implied by the content of what someone said)
	overheard (heard while another person was being addressed)
	generally addressed (heard while the room was being addressed)
	noticed (inspired by someone's actions)
	exclaimed (when someone said yes, no, sorry, hello, goodbye, or the literal name of any thing)
	told (when someone told/informed the actor about something)
	shown (when someone showed the actor something)
	asked (when someone asked the actor about something)
	requested (when someone asked the actor for something)
	offered (when someone "gave" the actor something)

The speech motivations are classified by several definitions, roughly ordered from idle to offered:

	Definition: A speech motivation is independent rather than prompted if it is less than overheard. [idle or suggested]

"Independent" means that the thought occurred spontaneously in the actor's mind. The complement, "prompted" indicates that the idea was expressed out loud by someone else, and everyone else is probably thinking of the same thing. Independent thoughts are never generated by the built-in action rules. Public thoughts are usually produced by "copying" the concern of the speaker to a listener. The only independent cues are "idle" and "suggested." When setting motivations yourself, used "suggested" unless you have a good reason not to.

	Definition: A speech motivation is private rather than public if it is less than generally addressed. [overheard, suggested, or idle]

"Public" means the actor has been addressed, either personally or generally. This is like "prompted," except that "overheard" does not count because the actor was not expected to be involved in the conversation. "Private" is the complement of "public."

	Definition: A speech motivation is personal rather than general if it is at least exclaimed.

"Personal" implies that the actor was addressed directly. The complement is "general." "General" includes "suggested," "overheard," "generally addressed," and "noticed." "Personal" includes all the cues generated by interacting explicitly with a specific person. This differs from "public" in the case of "generally addressed" and "noticed." The "personal" designation is used to determine whether a person is "expected to respond."

	Definition: A speech motivation is imperative rather than optional if it at least asked. [asked, requested, or offered]

"Imperative" means that a response has been solicited. The complement is "Optional." All of the independent and general cues are optional, as well as "exclaimed" and "told." A person would not be terribly rude for not answering when they were told a fact, but they might if they were asked a question or offered a gift. That is the intent of "Imperative."

In addition to absolute measures of speech motivations, there are relations for comparing them with each other:

	Relative cue publicity relates a speech motivation (called the first item) to a speech motivation (called the second item) when the first item is greater than the second item.
	The verb to be more public than implies the relative cue publicity relation. The verb to be at least as private as implies the reversed relative cue publicity relation.

"Relative cue publicity," expressed with the phrase "more public than" or the reverse, "at least as private as" tells which of two cues is more public, i.e. which is more likely to involve an explicit interaction between two or more people.

	Relative cue privacy relates a speech motivation (called the first item) to a speech motivation (called the second item) when the first item is less than the second item.
	The verb to be more private than implies the relative cue privacy relation. The verb to be at least as public as implies the reversed relative cue privacy relation.

"Relative cue privacy" expresses the same relation, but allows for equality in the opposite direction, i.e. "at least as public as" and "more private than."

Another pair of relations governs "importance:"

	To decide whether (first reason - a speech motivation) has more importance than (second reason - a speech motivation):
		if the first reason is independent:
			decide on whether or not the first reason is more private than the second reason;
		if the second reason is independent, no;
		decide on whether or not the first reason is more public than the second reason;	
		
The idea is that if a speaker thought of something independently, then the importance is actually greater if the thought is more private - e.g. an "idle" thought is more important than an "suggested" one because it is the speaker's own idea. If the cue is prompted, then importance is greater when the prompt is more pointed - a "request" for an item is more important than being "told" a fact.

	Relative cue importance relates a speech motivation (called the first item) to a speech motivation (called the second item) when the first item has more importance than the second item.
	The verb to be more important than implies the relative cue importance relation. The verb to be no more important than implies the reversed relative cue importance relation.

	Relative cue unimportance relates a speech motivation (called the first item) to a speech motivation (called the second item) when the second item has more importance than the first item.
	The verb to be less important than implies the relative cue unimportance relation. The verb to be at least as important as implies the reversed relative cue unimportance relation.

The relative cue importance/unimportance relations are used during the "getting attention" activity to determine whether a new motivation should preempt an existing one.

The finished speaking/moved to speak/waiting to speak condition tracks the course of a thought from inspiration to expression. If a person is finished speaking, then they have nothing to say. If they are moved to speak, the thought just occurred to them. If they attempt to speak and fail, then they will be waiting to speak on the next turn.

For the player, these properties have slightly different meaning. The player can obviously specify any subject to talk about, so the concern isn't all that important. However, the concern can be used to communicate the player-character's thoughts to the player. And if the player simply types "talk" or "talk to Bob," then the concern will give the PC something to talk about.

The priority of speech motivations for the player can be thought of as reversed from that of NPCs, because the player is looking at them from the inside rather than the outside. NPCs respond most often to the most public statements. But since those statements are obvious to the player, it is not often necessary to reiterate their importance. Rather, we want to inform the player about the PC's most private thoughts.

Thus, the player's condition indicates not whether they are going to speak (that is the player's choice), but whether the PC's thoughts have been made known to the player. If the PC is finished speaking, then they have "nothing on their mind." If the PC is moved to speak, then the player has not yet been told about their thoughts. If the PC is waiting to speak, then the player does not need to be told, either because the thoughts are too obvious or because they have already been expressed.

Section: The Getting Attention Acivity

Whenever a concern is presented to an actor, the "getting attention" activity is carried out with the actor. Three global variables will be set, and if they are accepted, their values will be assigned to the actor's properties:

The new subject matter may be set as the actor's concern.
The new reason may be set as the actor's speech motivation.
The new interlocutor may be set as the actor's interlocutor.

These can all be set at once using the phrase "confirm motivation of [the actor]." This will assign all three values and set the actor's condition to "moved to speak."

We can trigger the getting attention activity with this phrase:

	alert (the listener) about (the subject matter) because (reason)

Builtin rules for getting attention attempt to prioritize different stimuli so that the most important event will determine what, and whether, the actor will speak.

Section: The Speaking Out Loud Activity

Almost all conversational actions result in the speaking out loud activity - that is, if a check rule doesn't stop them. The speaking out loud activity takes the subject matter as an object - by default, it's the concern of the person asked, but it doesn't have to be.

The speaking out loud activity is where we should print out the actor's speech. The default rule "for speaking out loud of something (called the subject matter)" says "[The person asked] talk[s] briefly about [the subject matter]." We can override this with our own rules for speaking out loud.

The activity also has a few side effects. Bystanders are alerted about the current concern because "overheard," and the speaker's condition is set to "finished speaking."

Example: ** Ran Over - One character who responds to everything, one who barely talks.

	*: "Ran Over"

	Include Speech Motivations by Mike Ciul.

	Highway is a room. Jay is a man in highway. Bob is a man in highway.
	Bob wears a coat. Jay carries a joint. God is a subject.

	The description of the player is "You're completely naked, and still smarting from your fall out of heaven."

	After getting attention of someone (called the listener) who is not expected to respond:
		if the listener is Jay and the concern of Jay is a person who is not the player, continue the activity;
		if the listener is Bob or someone is expected to respond, forget the concerns of the listener;
		
	For speaking out loud when Bob is responding:
		say "Bob shrugs."

	For speaking out loud of something (called the subject matter) when Jay is responding:
		say "Jay expounds at great length, with multiple interjections of colorful profanity, on the subject of [the subject matter], but at the end you're still not sure how he feels."

	For printing the name of currently speaking Jay:
		say "himself";

	First for speaking out loud of something (called the subject matter):
		Repeat through Table of Responses:
			if the speaker entry is the person asked and the subject entry is the subject matter:
				say response entry;
				say paragraph break;
				rule succeeds;
		continue the activity.

	Table of Responses
	speaker (object)	subject (object)	response (text)
	yourself	joint	"You comment on Jay's joint."
	yourself	yourself	"'What's the matter? You never saw a naked black man before?' you say."
	yourself	coat	"You tell [the current interlocutor] that you just want to borrow the coat until you can find some other clothes."
	Bob	Jay	"Bob smiles and pats his friend on the back."
	Bob	joint	"Bob raises his eyebrows."
	Bob	God	"Bob shakes his head."
	Bob	Bob	"Bob grins and thumps his chest."
	Bob	yourself	"Bob tries not to look at your nakedness."
	Jay	joint	"'Dude, have some! First one's free!'"
	Jay	coat	"'Dude, [if jay is responding]what are you thinking? My man Bob doesn't want your dick rubbing all over the inside of his armor!'[otherwise]why you eyeing my man's coat?' Jay yells at you."
	Jay	yourself	"'I'm not staring at a naked black man. I'm staring at naked black man who just [italic type]fell out of the f***ing sky![roman type]'"

	First for speaking out loud of yourself when Jay is interjecting:
		say "Jay tries to pretend that he's not staring at your nakedness.";

	For speaking out loud of the coat when Bob is responding:
		say "Bob removes his coat and hands it to you.";
		end the story finally saying "You are no longer naked."

	test me with "x bob/ask jay about joint/x me/ask jay about me/x coat/ask jay about coat/tell jay about coat/ask jay for coat/ask bob about jay/ask bob about joint/tell bob about god/ask bob about bob/ask bob about me/ask bob about joint/ask bob for coat"

