Version 5 of Clues and Conversation by Brian Rushton begins here.

"A simple system for building conversations."

"developed with 6m62"

[Thanks to Michael Lauenstein, Gavin Lambert and Matt Weiner]

Chapter 1 - Quips

Section 1 - Basic definitions

[Quips are the topics or clues you can discuss]

A quip is a kind of thing. 

Section 2 - Properties of quips

[We use physicality to determine what things we can do to quips]

A thing can be physical or unphysical. A thing is usually physical.

A quip is never physical. A quip has some text called the preview. The preview of a quip is usually "Insert preview here.". A quip has some text called history. 

[You can only discuss a quip with it's target, if it has one. If the target is the nobody, you can discuss it with everyone. Thanks to Gavin Lambert for this idea.]

A quip has an object called the target. The target of a quip is usually nothing.

['Meih' means 'not yet'. You don't have to use it; you can just say 'not TargetGiven'. This is just a way to check if you've already discussed something with someone.]

A quip can be TargetGiven or MeihTarget. A quip is usually MeihTarget.

[TargetResponse is the text that you get after saying something]

A quip has some text called TargetResponse. The TargetResponse of a quip is usually "You get no response." 

[TargetSummary is only used when recalling, remembering, or examining a topic you've already discussed. ]

A quip has some text called TargetSummary. The TargetSummary of a quip is usually "You already tried talking about this."

[This is purely for aesthetics. You can call quips 'clues' and it will change all the text to be 'clues']

A clue is a kind of quip.

[When a quip can be spoken to multiple people, we need a more complicated relationship]

[Heeding takes the place of the Target. By default, when you deliver a generic quip, we make everyone heed it]

Heeding relates various people to various quips. The verb to heed means the heeding relation.

[Forsaking takes the place of MeihTarget]

Forsaking relates various people to various quips. The verb to forsake means the forsaking relation.

Section 3 - Preventing dumb actions

[This makes it so you can't 'drop all' or 'take all' and have it involve your topics]

Rule for deciding whether all includes quips (this is the exclude quips from all rule): 
	it does not.

[Thanks to Matt W for this cleaner way than my previous version]

inserting is material behavior.

putting is material behavior.

taking is material behavior.

dropping is material behavior.

switching on is material behavior.

switching off is material behavior.

opening is material behavior.

closing is material behavior.

wearing is material behavior.

pushing is material behavior.

pulling is material behavior.

touching is material behavior.

cutting is material behavior.
	
attacking is material behavior.

waving is material behavior.

burning is material behavior.

rubbing is material behavior.

squeezing is material behavior.
	
tasting is material behavior.

eating is material behavior.
	
drinking is material behavior.

giving is material behavior.

Before material behavior when the noun is unphysical (this is the can't touch immaterial things rule):
	say "That's not a physical object." (A) instead;

Chapter 2 - Quip dynamics

Section 1 - Remembering

[When you examine or remember a topic, it prints its history]

Understand "recall [something]" or "remember [something]" as examining.

Check examining a quip (this is the quip description rule):
	say "[The history of the noun]" (A) instead;

Section 2 - Delivering quips

[Talkative describes all possible targets of a quip. We include 'yourself' as someone guaranteed to exist. We make the player talkative when play begins.]

A person can be talkative or not talkative. A person is usually talkative. Yourself is not talkative.

[Delivery is the way that people get new topics. The 'deliveryflagged' thing is a gimmick to make sure that new topics show up at the end of each turn.]

A quip can be deliveryflagged or not deliveryflagged. A quip is usually not deliveryflagged.

To deliver (CurrentQuip - a quip):
	if CurrentQuip is carried by the player:
		do nothing;
	otherwise:
		now CurrentQuip is deliveryflagged;
	
[Now some replacement phrases]

A quip has some text called ClueOrTopic. The ClueOrTopic of a quip is usually "topic".

The ClueOrTopic of a clue is usually "clue".

To say HasCluesOrTopics:
	say "[if the number of clues carried by the player > 0]clue[otherwise]topic[end if]";

To say CapCluesOrTopics:
	say "[if the number of clues carried by the player > 0]CLUES[otherwise]TOPICS[end if]";

[First clear changes the first time we clear flags]

FirstClear is a number that varies. FirstClear is 0.

To clear the flags:
	let somethingDelivered be 0;
	repeat with currentquip running through deliveryflagged quips:
		say "[bracket]New [ClueOrTopic of currentquip] - [currentquip][close bracket][roman type]";
		say "[line break]";
		now history of currentquip is "[currentquip] - [preview of currentquip][line break]";
		now currentquip is carried by the player;
		now currentquip is not deliveryflagged;
		now somethingDelivered is 1;
		if the target of currentquip is nothing:
			repeat with currentperson running through talkative people:
				now currentperson heeds currentquip;
	if somethingDelivered is 1:
		If FirstClear is 0:
			say "[line break][bracket]You can see your list of [HasCluesOrTopics]s by typing [CapCluesOrTopics], or just [if the number of clues carried by the player > 0]C[otherwise]T[end if].[close bracket]";
			say "[line break]";
			now FirstClear is 1;

Every turn:
	clear the flags
	
[This line handles things delivered at the beginning of the game]

Report looking for the first time:
	clear the flags;
	
Section 3 - Renewing and removing topics

[This for topics you want to repeat]

A quip can be renewalflagged or not renewalflagged. A quip is usually not renewalflagged.

A quip can be removalflagged or not removalflagged. A quip is usually not removalflagged.

To renew (CurrentQuip - a quip):
	if CurrentQuip is not carried by the player:
		deliver CurrentQuip;
	otherwise if CurrentQuip is MeihTarget:
		do nothing;
	otherwise:
		now CurrentQuip is renewalflagged;

Every turn:
	repeat with CurrentQuip running through renewalflagged quips:
		say "[bracket]Renewed [ClueOrTopic of currentquip] - [CurrentQuip][close bracket][line break]";
		now CurrentQuip is MeihTarget;
		now CurrentQuip is not renewalflagged;

To remove (CurrentQuip - a quip):
	if CurrentQuip is carried by the player:
		now CurrentQuip is removalflagged;

Every turn:
	repeat with CurrentQuip running through removalflagged quips:
		say "[bracket]Removed [ClueOrTopic of currentquip] - [CurrentQuip][close bracket][line break]";
		now CurrentQuip is MeihTarget;
		now CurrentQuip is nowhere;
		now CurrentQuip is not removalflagged;

Section 4 - Defining the uttering verbs

Understand the command "say" as something new.

[Uttering it to is our main action.]

Uttering it to is an action applying to two things. Understand "say [something] to [someone]" or "tell [something] to [someone]" or "t [something] to [someone]" or "a [something] to [someone]" or "talk about [something] to [someone]" or "say [something] [someone]" or "tell [something] [someone]" or "t [something] [someone]" or "a [something] [someone]" or "talk about [something] [someone]" as uttering it to.

Understand "tell [someone] about [something]" as uttering it to (with nouns reversed).

[Singleuttering automatically tries saying a quip to the target of the noun]

Singleuttering is an action applying to one thing. Understand "say [something]" or "tell [something]" or "t [something]" or "a [something]" as singleuttering.

[This next line and the code it's used in are just a way to to say 'talk to someone who isn't the player' if there is no target]
A person can be playerly or unplayerly. A person is usually unplayerly. The player is playerly.

Check singleuttering (this is the only quips can be singleuttered rule):
	if the noun is not a quip:
		say "That's not something you can say." (A) instead;

Carry out singleuttering (this is the standard singleuttering rule):
	if the target of the noun is nothing:
		if the number of people enclosed by the location of the player > 1:
			repeat with current running through people in the location of the player:
				if current is not the player:
					try uttering the noun to current;
					break;
		otherwise:
			say "There's no one else here." (A);
	otherwise:
		if the target of the noun is in the location of the player:
			try uttering the noun to the target of the noun;
		otherwise:
			say "[The target of the noun] isn't here." (B);	

[We favor singleuttering when possible]

Does the player mean singleuttering something:
	it is very likely;

[HelpfulText is used to remind players how to find information on past topics]

HelpfulText is some text that varies. HelpfulText is "[paragraph break][bracket][We] [can] REMEMBER or RECALL a topic to remind [ourselves] about previous conversations.[close bracket][line break]"
	
A quip has a list of things called historylist. 

Check uttering it to (this is the can't utter in darkness rule):
	if in darkness:
		say "It's too dark to find the person [we] [are] talking to!" (A) instead;

Check uttering it to (this is the uttering requires quips rule):
	if the noun is not a quip:
		say "[We] [can] only discuss your current thoughts as listed in your [HasCluesOrTopics]s." (A) instead;
	
Check uttering it to (this is the quips must be carried rule):
	if the noun is not carried by the player:
		say "That's not a [ClueOrTopic of the noun] [we] currently possess." (A) instead;

Check uttering it to (this is the uttering requires people rule):
	if the second noun is not a person:
		say "[We] [can] only do that to something animate." (A) instead;

Carry out Uttering it to (this is the standard uttering rule):
	if the second noun is the target of the noun:
		if the noun is MeihTarget:
			say TargetResponse of noun;
			say "[line break]"; 
			now the noun is TargetGiven;
			now history of the noun is "[the noun] - [preview of the noun][paragraph break][TargetSummary of noun][line break]";
		otherwise:
			say "[We] [have] already discussed this with [Target of the noun].[HelpfulText]" (A);
	otherwise if second noun heeds the noun:
		if the second noun does not forsake the noun:
			say TargetResponse of noun;
			say "[line break]"; 
			now the second noun forsakes the noun;
			add the second noun to historylist of the noun, if absent;
			now history of the noun is "[the noun] - [preview of the noun][paragraph break][We] [have] already discussed this with [historylist].[line break]";
		otherwise:
			say "[We] [have] already discussed this with [the second noun].[HelpfulText]" (B);
	otherwise:
		say "That's not something [we] plan on discussing with [the second noun]." (C);

Section 5 - When the order is reversed

Querying it to is an action applying to two things. Understand "ask [someone] about [something]" as querying it to.

Carry out querying (this is the standard querying rule):
	try uttering the second noun to the noun;

Section 6 - Guiding the player when using the wrong conversational format

Talking to is an action applying to one thing. Understand "talk to [someone]" as talking to.

CurrentPerson is some text that varies. CurrentPerson is "the player".

To say CapPerson:
	say "[CurrentPerson in upper case]";

[HasCluesorTopics is defined in Section 2 above]

[If the player is using general topics that apply to everyone, we have to add in some weird code]

Check talking to (this is the can't talk to yourself rule):
	if the noun is the player:
		say "It may be better to talk with others." (A) instead;
	
Check talking to (this is the can't talk to objects rule):
	if the noun is not a person:
		say "[We] [can] only do that with something animate." (A) instead;

[CounterThing checks if the player is carrying any quips specific to the person you are talking to or general quips]

Carry out talking to (this is the standard talking to rule):
	now CurrentPerson is "[the noun]";
	say "To speak with [the noun], choose a [HasCluesOrTopics] from below and SAY [bracket]the [HasCluesOrTopics][close bracket] TO [CapPerson].[paragraph break]" (A);
	let counterThing be 0;
	repeat with currenttwo running through quips carried by the player:
		if the target of currenttwo is the noun:
			increment counterThing;
		if the target of currenttwo is nothing:
			increment counterThing;
	if CounterThing > 0:		
		repeat with current running through quips carried by the player:
			if current is TargetGiven:
				if Target of current is the noun or the noun heeds current:
					say "[bracket]The [HasCluesOrTopics]s with an asterisk (*) can no longer be discussed with [the noun].[close bracket][paragraph break]" (B);
					break;
		say "[bold type]Things to say to [the noun]:[roman type]" (C);
		repeat with currentquip running through all quips carried by the player:
			if Target of currentquip is the noun:
				say "[line break]   [if currentquip is targetgiven]*[end if]";
				say "[currentquip] - [preview of currentquip]";
			otherwise if the noun heeds currentquip:
				say "[line break]   [if the noun forsakes currentquip]*[end if]";
				say "[currentquip] - [preview of currentquip]";
		say "[line break]";
	otherwise:
		say "[bold type]Things to say to [the noun][roman type][line break]    You can't think of anything at this time.[line break]" (D);

Chapter 3 - Inventory

Section 1 - Taking inventory
	
The print empty inventory rule is not listed in the carry out taking inventory rulebook.
The print standard inventory rule is not listed in the carry out taking inventory rulebook.

[EmptyText is some text that varies. EmptyText is "[line break]   nothing[line break]".]

[We don't want quips showing up in regular inventory]

Carry out taking inventory (this is the quip-based inventory rule):
	if the number of physical things carried by the player is 0:
		say "[We] [are] carrying nothing." (A);
	otherwise:
		now all things enclosed by the player are marked for listing;
		now all quips carried by the player are unmarked for listing;
		say "[We] [are] carrying:[line break]" (B);
		list the contents of the player, with newlines, indented, including contents,
			giving inventory information, with extra indentation, listing marked items only;
	say "[first time][line break][bracket]You can see topics for speaking to others by typing T or TOPICS[close bracket].[line break][only]" (C);

[Carry out taking inventory (this is the quip-based inventory rule):
	say "[We] [are] carrying:";
	repeat with currentitem running through physical things carried by the player:
		now EmptyText is "";
		say "[line break]   [a currentitem]";
	say "[EmptyText][first time][line break][bracket]You can see topics for speaking to others by typing T or TOPICS[close bracket].[only]";
	now EmptyText is "[line break]   nothing";]

Section 2 - Taking topic inventory

[I put this in its own section to make it easier to take out]

Topicing is an action out of world. Understand "t" or "topics" or "thoughts" or "c" or "clues" as topicing.

Section 3 - Actual rules for taking inventory

After printing the name of a quip (called currentquip) when topicing (this is the preview printing rule):
	Say " - [the preview of currentquip]" (A).

Carry out topicing (this is the standard topicing rule):
	repeat with current running through quips carried by the player:
		if current is TargetGiven:
			say "[bracket]The [HasCluesOrTopics]s with an asterisk (*) can no longer be discussed.[close bracket][paragraph break]" (A);
			break;
	let generalcounter be 0;
	repeat with currenttwo running through quips carried by the player:
		if the target of currenttwo is nothing:
			increment generalCounter;
	if generalcounter > 0:
		say "[bold type]General [HasCluesOrTopics]s:[roman type]" (B);
		repeat with currentquip running through all quips carried by the player:
			if Target of currentquip is nothing:
				if every talkative person forsakes currentquip:
					say "[line break]  *";
				otherwise:
					say "[line break]   ";
				say currentquip;
		say "[line break]";
	repeat with current running through talkative people:
		let counterThing be 0;
		repeat with currenttwo running through quips carried by the player:
			if the target of currenttwo is current:
				increment counterThing;
		if CounterThing > 0:
			say "[bold type]Things to say to [the current][roman type]" (C);
			repeat with currentquip running through all quips carried by the player:
				if Target of currentquip is current:
					if currentquip is targetgiven:
						say "[line break]  *";
					otherwise:
						say "[line break]   ";
					say currentquip;
			say "[line break]";
		otherwise:
			if current is the player:
				do nothing;
			otherwise if generalCounter > 0:
				do nothing;
			otherwise:
				say "[bold type]Things to say to [the current][roman type][line break]    You can't think of anything at this time.[line break]" (D);
				
Report topicing (this is the advice on talking to just one person rule):
	say "[We] [can] see just the topics for one person at a time by TALKing TO that person." (A);

Chapter 3 - Topics that apply to everyone

CurrentTarget is a person that varies. CurrentTarget is yourself.

Check uttering something to someone (this is the uttering target assigning rule):
	now CurrentTarget is the second noun;

[You must create your own attributes here, one for each person you can talk to. See example Group Chat for an idea of how to do this.]

Clues and Conversation ends here.

---- DOCUMENTATION ---- 

Section: Philosophy

Inform 7 is most successful in its modeling of things (like TAKE, DROP, EXAMINE, etc.) Therefore, this extension creates conversational topics or clues as inventory items, called 'quips', and treats them as much like 'things' as possible.

To avoid confusion, this extension mods the standard inventory to list topics and physical items separately.

Section: How to make topics

Every topic is called a 'quip' (modelled after similar code from Emily Short). The terms 'topic' and 'quip' are used interchangeably in this documentation. 

Every quip needs a target. This is the person you can tell it to. 

For example:
	
	Accusation is a quip. The target of Accusation is Simba.

Every quip has text called the 'preview'. This is what's shown in your 'Topic Inventory' (which players access by typing TOPICS, CLUES, C, or T).

	Accusation is a quip. The target of Accusation is Simba. The preview of Accusation is "'Murderer!'"

The text displayed when you talk to someone is called the TargetResponse of the quip. 

	Accusation is a quip. The target of Accusation is Simba. The preview of Accusation is "'Murderer!'"

	The TargetResponse of Accusation is "'Murderer!' you say.

	'No, no, no no no!' says Simba."

Section: Generic topics

If you want to be able to say the quip to multiple people , you can make the target nothing. This is the default, so you can just leave the target unsaid. These quips are 'generic'.

	Hello is a quip.
	
This lets you say 'Hello' to everyone. There is a variable called CurrentTarget that lets you know who you're talking to, and this can be used for customizing the response.

	Hello is a quip. TargetResponse of Hello is "[if CurrentTarget is Dreary Dan]'Hello!' you say cheerfully. 

	'Whatever,' says Dreary Dan.[otherwise]'Hello!' you say cheerfully.

	'Hello,' says [CurrentTarget].[end if]"

If legibility becomes an issue, you can use tables instead.

Section: Remembering conversation

If you want people to remember what happened in a conversation, you can add TargetSummary to a quip. Only quips with a specific target need TargetSummary.

	The TargetSummary of Accusation is "You accused Simba of murder."

If a quip can be discussed with multiple people, the target summary is an automatically generated list of who you've discussed it with.

If you want to be able to discuss a quip with many (but not all) people, you can use the 'heeds' relation to exclude people. For instance:
	
	Cheerful is a quip. Ebenezer Scrooge does not heed Cheerful.

Section: Giving a player a topic to discuss

Use the phrase 'deliver -quip name-' to give a quip to the player. If a player already has the quip, nothing will happen. If they don't have it yet, the game will announce the new quip.

	Hello is a quip.
		
	When play begins:
		deliver Hello;

Section: Talking verbs

The verb for talking is Uttering It To. So if you say the quip Dog to Dan, the game calls it 'Uttering Dog to Dan'.

Section: Repeating a topic

If you want a quip to come back, you can 'renew' it:
	
	Report eating the popsicle:
		renew Hungry;
		
If a quip has a specific target, it can only be said once unless you renew it.

Quips without a target can be said to anyone over and over.

Section: Removing a topic

If you want to take away a topic completely and announce then remove it:
	
	Report taking the dog:
		remove Lost;

Section: Clues

If you use the word 'clue' instead of quips, then the game will refer to quips as 'clues' instead of 'topics'.

	Barking is a clue. 
	
Section: Parts of code it messes with

This extension changes the behavior of taking inventory and the command SAY. It uses the abbreviation T and C.

The quips are carried by you, so 'repeat with current running through things carried by the player' will include them. To ignore them, use the adjective 'physical', like:
	
	Repeat with current running through physical things carried by the player:

Section: Having things happen when you talk

You can do this by using 'report uttering something to someone'.	

	Report uttering Payment to the shopkeeper:
		now PlayerGold is 10; 
		
Quips that have a specific target have a flag called TargetGiven you can check.

	Compliment is a quip. The target of Compliment is Doorman. The preview of Compliment is "'Looking sharp!'".

	The description of the doorman is "The doorman looks [if Compliment is TargetGiven]happy[otherwise]sad[end if]."

Section: Excluding people from talking altogether.

If a person is 'talkative', you can say generic quips to them (one whose currenttarget is nothing). To exclude someone from conversation, you can make them 'not talkative'.

As discussed earlier, to keep a person from talking about a specific generic topic, use the following format:
	
	Cheerful is a quip. Ebenezer Scrooge does not heed cheerful.

Example: * The Raven - Having a single topic with a single target.

	*: "The Raven"
	
	Include Clues and Conversation by Brian Rushton.

	The Study is a room.

	Poe is a man in the Study. The description of Poe is "A man who seems to awaiting a pronouncement of eternal doom."

	When play begins:
		deliver Doom;
		
	Doom is a quip. The preview of Doom is "Nevermore".

	The target of Doom is Poe. The TargetResponse of Doom is "'Nevermore', quoth you.

	'No!' screams Poe."

	Report uttering Doom to Poe:
		end the story finally;

	Test me with "I / talk to poe / T / say Doom"

Example: * The Detective - Having a single clue with no specific target.

	*: "The Detective"
	
	Include Clues and Conversation by Brian Rushton.

	The Study is a room. Parlor is north of the Study.

	Watson is a man in the Parlor. The description of Watson is "Watson is interested in everything you have to say."

	When play begins:
		deliver Ash;
		
	Ash is a clue. The preview of Ash is "The ash was from a cigar manufactured in Greenland.".

	The TargetResponse of Ash is "'This is a Greenland cigar', you shout.

	'Hurrah!' says Watson."

	Test me with "T / say Ash / N / say ash / T"
	
Example: * Eat Your Words - Trying out responses.

	*: "Eat Your Words"
	
	Include Clues and Conversation by Brian Rushton.

	Restaurant is a room.

	Noether is a woman in Restaurant.

	The table is scenery in Restaurant.

	When play begins:
		deliver Dinner;
		
	Dinner is a quip. The preview of Dinner is "Your meal was excellent.".

	The Target of Dinner is Noether. The TargetResponse of Dinner is "You say, 'Ahh, such an excellent meal.'

	'It was lovely, wasn't it?' says Noether. 'Let's get dessert'."

	Test me with "T / I / x dinner / x table / talk to me / talk to table / say dinner to table / say table to noether / eat dinner / burn dinner / give dinner to noether / say dinner / say dinner"
	
Example: ** Group Chat - Talking to everyone.

	*: "Group Chat"
	
	Include Clues and Conversation by Brian Rushton.

	Classroom is a room.

	Noether is a woman in Classroom. Hypatia is a woman in Classroom. Gauss is a man in Classroom. Euler is a man in Classroom.
	
	When play begins:
		deliver Roll Call;
		
	Roll Call is a quip. The preview of Roll Call is "You need to take roll.".

	TargetResponse of a Roll Call is "[if CurrentTarget is Noether]You say, 'Noether?'

	'Present!' she says.[otherwise if CurrentTarget is Hypatia]You say, 'Hypatia?'

	'I'm here!' she says.[otherwise if CurrentTarget is Gauss]You say, 'Gauss?'

	'Yup,' he says.[otherwise if CurrentTarget is Euler]You say, 'Euler?'

	'That's what they call me,' he says.[end if]"

	Test me with "recall roll call / say roll call to noether / recall roll call / say roll call to hypatia / recall roll call / say roll call to gauss / say roll call to euler / recall roll call / say roll call to noether / recall roll call"
	
Example: ** Lost Wallet - Getting quips from things and other quips.

	*: "Lost Wallet"
	
	Include Clues and Conversation by Brian Rushton.

	Street is a room.

	The stranger is a man in Street. The description of a stranger is "He looks exactly like the opposite of Timothy Chalamet."
	
	When play begins:
		say "A stranger in front of you drops his wallet!";
		
	The wallet is in Street. The description of the wallet is "A receptacle for money, which can be exchanged for goods and services."

	Report taking the wallet:
		deliver Hold On;
	
	Instead of dropping the wallet:
		say "You need to get it to its owner!";

	Instead of giving the wallet to stranger:
		say "He's going to fast, and can't see you!"

	Hold On is a quip. The target of Hold On is Stranger. The preview of Hold On is "Offer the wallet to the stranger."
	
	TargetResponse of Hold On is "'Hold on!' you shout.

	You run up to the stranger, puffing. 'Is this yours?' you ask.

	'Yeah, it is. Thanks so much!' he says. 'Here, take this twenty,' he adds, offering you a bill."

	TargetSummary of Hold On is "You gave the man his wallet, and he offered you twenty bucks."

	Report uttering Hold On to Stranger:
		now the wallet is nowhere;
		deliver Sure;
		deliver Nah;
		
	Sure is a quip. The target of Sure is Stranger. The preview of Sure is "Accept the money."
		
	TargetResponse of Sure is "'Sure, thanks!' you say. You grab the bill and walk away."

	Report uttering Sure to Stranger:
		end the story finally saying "You've won, slightly richer than before"

	Nah is a quip. The target of Nah is Stranger. The preview of Nah is "Reject the money."

	TargetResponse of Nah is "'No thanks!' you say, and walk away."

	Report uttering Nah to Stranger:
		end the story finally saying "You've won, no richer than before"

	Test me with "talk to stranger / t / take wallet / t / talk to stranger / say hold on / t / say sure"
	
Example: *** Halloween Dance - A complete game using this extension.

	*: "Halloween Dance"

	Include Clues and Conversation by Brian Rushton.

	Dance Hall is a room. The description of Dance Hall is "A school gymnasium with four or five pumpkins on the side and orange and black streamers hanging from the ceiling."

	The pumpkins are scenery. The description of pumpkins is "The pumpkins have ghosts carved into them.". Understand "pumpkin" as pumpkins.

	Ghosts is a quip. The preview of Ghosts is "'Do you believe in ghosts?'". 

	After examining the pumpkins for the first time:
		deliver Ghosts;
	
	TargetResponse of Ghosts is "'Do you believe in ghosts?'[paragraph break]'Not really, why?'[paragraph break]'They say that a kid died in this gym 40 years ago at a Halloween party.'[paragraph break]'How did he die?'[paragraph break]'His costume caught on fire on a tiki torch against the wall. He tried to take it off, but his zipper was stuck. He ran out into the night to try and reach a pond but he didn't make it.'"
	
	The description of the player is "You're wearing a spooky ghost costume!";

	The streamers are scenery. The description of the streamers is "The streamers are orange and black. A spider scurries across it and out of sight."

	The pumpkins and streamers are in Dance Hall.

	Fred is a man. Jane is a woman. Fred is in Dance Hall. Jane is in Dance Hall.  

	Dancing is an action applying to nothing.

	Understand "dance" as dancing.

	Instead of dancing:
		say "You [one of]do the robot[or]break dance[or]do the macarena[or]bob your head[at random]."

	The description of Fred is "A young man wearing a white suit with red splatters all over. He is standing next to a cooler with mist coming out of it."

	The description of Jane is "A young woman wearing a simple frock covered with dozens of old... are those beepers? Like from the 90[']s?"

	Boy is a quip. The preview of Boy is "'So, what do you know about Fred?'".
	The target of Boy is Jane.

	Girl is a quip. The preview of Girl is "'So, what do you know about Jane?'".
	The target of Girl is Fred.

	The cooler is in the  Dance Hall. The description of the cooler is "A small blue cooler with mist coming out of it."

	Instead of taking the cooler:
		say "That belongs to someone else."

	Instead of opening the cooler:
		say "That's already open."

	Instead of looking in the cooler:
		say "The boy says 'Hey, that's mine!'"

	The brainpop is a thing. The description of brainpop is "A homemade popsicle with some kind of mush in it."

	The costume is a thing. The description of costume is "A Phantom of the Schoolhouse costume, complete with gloves and mask." Understand "my costume" as costume. Understand "your costume" as costume. Understand "glove" as costume. Understand "mask" as costume. Understand "gloves" as costume.
	The indefinite article of the costume is "your".
	The player wears the costume.

	After examining the costume for the first time:
		deliver Phantom;

	Instead of taking off costume:
		say "You don't want to take that off now."

	Instead of dropping costume:
		say "You actually aren't wearing anything underneath. Better hold on to it."

	Greeting is a quip. The preview of Greeting is "'Hi! My name is Gerald.'" 

	Compliment is a quip. The preview of Compliment is "'Wow, nice costume!'". 

	Uhh is a quip. The preview of Uhh is "'Actually, I'm not interested.'". The target of Uhh is Fred.
	Okay is a quip. The preview of Okay is "'Why not?'". The target of Okay is Fred.

	[These are temporary quips]

	Report uttering something to someone:
		remove Uhh;
		remove Okay;

	TargetResponse of Greeting is "'Hi, my name is Gerald.'

	[if CurrentTarget is Fred]Fred says, 'Hi, my name is Fred!'[otherwise]Jane says, 'Hi, my name is Jane!'[end if]"

	Report uttering Greeting to Fred:
		deliver Boy;
		
	Report uttering Greeting to Jane:
		deliver Girl;

	TargetResponse of Compliment is "You say, 'Wow, nice costume!'

	[if CurrentTarget is Fred]'Thanks! I'm a zombie ice cream man selling brainpops. You want one?'[otherwise]'Awww, you're sweet! I'm the Grim Beeper, reminding all technology that it will one day be obsolete.'[end if]"
	
	Report uttering Compliment to Fred:
		deliver Uhh;
		deliver Okay;

	TargetResponse of Okay is "'Why not?'[paragraph break] He hands you a brainpop."
	TargetResponse of Uhh is "'Actually, I'm not interested.'[paragraph break]He shrugs."

	Report uttering Okay to Fred:
		now the player is carrying the brainpop;

	Instead of eating the brainpop:
		say "Wow! That really hits the spot! The mush was strawberries.";
		now the brainpop is nowhere.
		
	Strawberries is a quip. The printed name of Strawberries is "'Did you know Jane doesn't like strawberries?'". The target of Strawberries is Fred.

	Instead of giving the brainpop to Jane:
		say "She grimaces and says, 'No thanks, I don't like strawberry.'";
		deliver Strawberries;

	TargetResponse of Strawberries is "'Did you know Jane doesn't like strawberries?'

	Fred's face blanches. He says, 'Aw, crap,' and hangs his head.";

	TargetResponse of Girl is "'So, what do you know about Jane?'[paragraph break]He looks at Jane, then leans forward and whispers, 'Can you keep a secret? Jane has been my crush for two years now. I heard she likes walking dead, so I made this whole getup and these brainpops to impress her[if Strawberries is TargetGiven]. But apparently she hates strawberries...'[otherwise].'[end if]";
	
	Report uttering Girl to Fred:
		deliver Crush;
		deliver Lie;

	TargetResponse of Boy is "'So, what do you know about Fred?'[paragraph break]She brightens up, peeking over at Fred. 'Can you keep a secret? I think Fred is the sweetest man at school. He's really into repairing old technology, so I made this costume for him.' She twirls to display her outfit. 'I love fixing old stuff too, That's how we met, in our Tech class.'";
	
	Report uttering Boy to Jane:
		deliver Romance;

	Phantom is a quip. The preview of Phantom is "'What do you think about my costume?'".

	TargetResponse of Phantom is "'What do you think about my costume?'[paragraph break]'It's nice! What are you?'[paragraph break]'I'm the Phantom of the Schoolhouse.'[paragraph break]'Cool! I didn't think they let people wear masks anymore.' [CurrentTarget] hesitates for a moment. 'To be honest, I've been wondering if you even go to this school.'";
		
	Crush is a quip. The preview of Crush is "'So, I found out who Fred is interested in...'". The Target of Crush is Jane.

	JaneKnows is a number that varies. JaneKnows is usually 0.

	FredKnows is a number that varies. FredKnows is usually 0.

	TargetResponse of Crush is "'So, I found out who Fred is interested in...'[paragraph break]'Really?'[paragraph break]'He told me he's had a crush on you for two years'.";
	
	Report uttering Crush to Jane:
		now JaneKnows is 1;
		if FredKnows is 1:
			say "Jane turns to Fred and smiles. She walks over and draws him to the side. You see the two of them laughing together, and then Jane kisses Fred on the cheek and he blushes. Fred turns to you as they walk out together, and gives you a thumbs up.";
			end the story finally saying "You had some fun, and got the rest of the brainpops.";
		otherwise:
			say "Jane beams from ear to ear, and keeps glancing at Fred.";
		remove Lie;
			
	Romance is a quip. The preview of Romance is "'So, I found out who Jane is interested in...'" The target of Romance is Fred.

	TargetResponse of Romance is "'So, I found out who Jane is interested in...'[paragraph break]He looks upset for a second. 'Who?'[paragraph break]'She said she's been into you ever since Tech class. She wore the beeper dress just for you.'";

	Report uttering Romance to Fred:
		now FredKnows is 1;
		if JaneKnows is 1:
			say "[paragraph break]Fred looks over at Jane, leaving the brainpops behind. He turns behind, and says, 'Hey, take the rest of them. I don't need them anymore.'[paragraph break]He walks up to Jane and starts pointing at her costume. You hear them laughing together. As they talk, his hand brushes hers, and she smiles. You turn away and enjoy your reward.";
			end the story finally saying "You had some fun, and got the rest of the brainpops.";
		otherwise:
			say "Fred seems noticeably more cheerful.";

	Lie is a quip. The preview of Lie is "Lie-'Fred told me he hates your guts.'". The target of Lie is Jane.
		
	TargetResponse of Lie is "'Fred told me hates your guts. He even put strawberry in those popsicles because he knows you hate it.'[paragraph break]Jane storms away, glaring at Fred. Fred looks at her, perplexed, then back at you. You ignore Fred, and look at the pumpkins instead. Oooh, nice ghost carving.";
	
	Report uttering Lie to Jane:
		end the story finally saying "No one is happy now.";

	When play begins:
		deliver Greeting;
		deliver Phantom;
	
	Report examining Fred:
		deliver Compliment;
		
	Report examining Jane:
		deliver Compliment;

	Test me with "talk to Fred / x pumpkins / say ghosts to jane / x jane / x fred / t / say greeting to fred / say greeting to jane / say boy to jane / say girl to fred / t / say compliment to fred / talk to jane / say okay to fred / eat brainpop /  say uhh to fred / say ghosts to fred / say romance to fred  / say crush to jane"
