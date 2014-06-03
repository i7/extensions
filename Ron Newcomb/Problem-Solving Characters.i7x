Version 2 of Problem-Solving Characters (for Glulx only) by Ron Newcomb begins here.

"This extension enables the characters to sensibly circumvent obstacles to their desired actions.  Intended for works in which the non-player characters perform game actions just like the player-character, but cannot be strictly scripted because of a changing gameworld."

"with patches by Daniel M. Stelzer"

Chapter - Action Attempts and Reasons Why They Fail

An attempt is a kind of object with printed name "[subjectless stored action]". 
An attempt has a stored action. 
An attempt can be untried, failed, partly successful, or successful.
An attempt has a rule called the meddling check rule.
An attempt is always proper-named.
An attempt can be available or unavailable. An attempt is usually available.
The specification of an attempt is "An action which has failed.  Attempts record which Check rule prevented the action and whether the action could or should be re-attempted later.  For a re-attempt to be successful, certain pre-requisites need to be 'fulfilled' (a relation) by other actions, so the same Check rule doesn't simply stop the action again."

nothing as an attempt is an attempt.
There are 50 attempts. [This should normally be enough for any game.]

Fulfillment relates one attempt (called the cause) to various attempts.  
The verb to fulfill (it fulfills, they fulfill, it fulfilled, it is fulfilled, it is fulfilling) implies the reversed fulfillment relation. 

Planning relates one attempt (called the goals) to one person. 
The verb to plan (he plans, they plan, she planned, it is planned, he is planning) implies the reversed planning relation.

To recycle (A - an attempt):
[	say "Recycling [A in agenda form].";	]
	repeat with B running through attempts which fulfill A:
		recycle B;
	now A is available;
	now A is untried;
	repeat with C running through attempts fulfilled by A:
		now A does not fulfill C.

Every person plans an attempt. [This one node has the "waiting" action and is just a dummy node that "top-level" plans all connect to, which simplifies code.]

Definition: an attempt is hindered if (it is failed or it is untried) and there are untried attempts which fulfill it and there are no successful attempts which fulfill it.
Definition: an attempt is moot if it is untried and (it fulfills an [already] successful attempt or it fulfills a partly successful attempt).
Definition: an attempt is in the future if it is untried and it does not fulfill an [already] successful attempt.
Definition: an attempt is in the present if it is hindered.
Definition: an attempt is in the past if it is successful or it is partly successful or (it is failed and there are no untried attempts which fulfill it).
Definition: an attempt is a could've been if it is moot.
Definition: an attempt is top-level if someone plans the cause of it.
Definition: a person (called the actor) is quiescent rather than busy if all attempts which [could possibly] fulfill the goals of the actor are in the past.

The when hindered by rules are a rule based rulebook.
The when hindered by rules have outcomes pretend it worked (success).  
The when hindered by rulebook has an object called the actor.
First when hindered by (this is the set actor variable rule): now the actor is the person asked. [convenience for the game author]
First when hindered by (this is the don't plan for the player rule): if the person asked is the player, do nothing instead.

First after an actor doing something (this is the update plans on success rule):
	let this attempt be what the actor will do next;
	if the current action is the stored action of this attempt, now this attempt is successful;
	make no decision.

Every turn (this is the clean up finished actions rule):
	repeat with the subject running through quiescent people:
	[	say "(Recycling [the subject]'s attempts).";	]
		repeat with A running through attempts which fulfill the goals of the subject:
			recycle A.

First after not an actor doing something (this is the update plans on failure rule):
	let this attempt be what the actor will do next;
	if the current action is not the stored action of this attempt:
		now this attempt is nothing as an attempt;
	if a successful attempt (called the solution) fulfills this attempt:
		if the reason the action failed is not the meddling check rule of this attempt,
			now this attempt is partly successful;
	follow the when hindered by rules for the reason the action failed;
	if the outcome of the rulebook is the pretend it worked outcome:
		now this attempt is successful;
	otherwise if no attempts fulfill this attempt:
		now this attempt is [definitely] failed;
	make no decision.

Chapter - For use in the When Hindered By rules

[ These four phrases are synonymous with each other.  "We" is shorthand for "the person asked". ]

To decide which rule is the (R - rule) requirement:
	decide on R.

To we can/could try (suggestion - an action):
	(- Can{suggestion}{-backspace}{-backspace}, actor); -).

To we can/could try (suggestion - a stored action): 
	The person asked could try the suggestion.

To (performer - an object) can/could try (suggestion - an action):
	(- Can{suggestion}{-backspace}{-backspace}, {performer}); -).

To (actor - a person) can/could try (suggestion - a stored action) (this is circumventing):
[	say "We could try [suggestion].";	]
	let this attempt be what the actor is trying to accomplish now;
	let the circumvention be a random available attempt;
	if the circumvention is nothing:
		say "*** ERROR: Out of attempts! ***";
		stop;
	now the stored action of the circumvention is the suggestion;
	now the actor part of the stored action of the circumvention is the actor;
	now the circumvention is untried;
	now the circumvention is unavailable;
[	let the circumvention be a new attempt for the actor who'll try the suggestion;	]
	if this attempt is the goals of the actor:
	[	say "Creating 'this attempt'.";	]
	[	now this attempt is a new attempt for the actor who'll try the current action;	]
		now this attempt is a random available attempt;
		now the stored action of this attempt is the current action;
		now the actor part of the stored action of this attempt is the actor;
		now this attempt is untried;
		now this attempt is unavailable;
		now this attempt fulfills the goals of the actor;
		now the meddling check rule of this attempt is the reason the action failed;
		now the goals of the actor are untried;
	now the circumvention fulfills this attempt.

Include (-
[ CanTryAction  request  unused  action  n  n2  actor;
	((+ circumventing +)-->1)(actor, STORED_ACTION_TY_New(action, n, n2, actor, request, 0));
]; -).


Chapter - To Answer Why or How 

Confused about timing is a truth state that varies.

[Section 1 - why did, why will, why is ]

To decide which attempt is why (actor - a person) did/accomplished (act - an attempt):
	now confused about timing is whether or not the act is not in the past;
	decide on the cause of the act.

To decide which attempt is why (actor - a person) will do/accomplish/-- (act - an attempt):
	now confused about timing is whether or not the act is not in the future;
	decide on the cause of the act.

To decide which attempt is why (actor - a person) is/are doing/accomplishing (act - an attempt):
	now confused about timing is whether or not the act is not in the present;
	decide on the cause of the act.

[Section 2 - how did, how will, how can, how could, how could have ]

To decide which attempt is how (actor - a person) did/accomplished do/-- (act  - an attempt):
	now confused about timing is whether or not the act is not in the past;
	if confused about timing is true, decide on how the actor will accomplish the act;
	if there is a successful attempt (called the method) which fulfills the act,
		decide on the method;
	if there is a partly successful attempt (called the method) which fulfills the act,
		decide on the method;
	decide on the act. [ the action was so simple and straightforward there is no "how" ]

To decide which attempt is how (actor - a person) will do/accomplish/-- (act - an attempt):
	now confused about timing is whether or not the act is in the past;
	let the choices be how the actor can accomplish the act;
	repeat with detail running through the choices:
		if the detail is hindered, decide on how the actor will accomplish the detail;
	repeat with detail running through the choices:
		if the detail is untried, decide on the detail;
	decide on the goals of the actor.

To decide which list of attempts is how (actor - a person) can do/accomplish (act  - an attempt):
[	decide on the list of not in the past attempts which fulfill the act.]
	let the choices be a list of attempts;
	repeat with item running through the not in the past attempts which fulfill the act:
		add the item to the choices;
	decide on the choices.

To decide which list of attempts is how (actor - a person) could do/accomplish (act  - an attempt):
[	decide on the list of attempts which fulfill the act.]
	let the choices be a list of attempts;
	repeat with item running through the attempts which fulfill the act:
		add the item to the choices;
	decide on the choices.

To decide which list of attempts is how (actor - a person) could have done/accomplished (act  - an attempt):
	[decide on the fixed list of could've been attempts which fulfill the act.]
	let the choices be a list of attempts;
	repeat with item running through the could've been attempts which fulfill the act:
		add the item to the choices;
	decide on the choices.

[Section 3 - what will, what is doing ]

To decide which attempt is what (actor - a person) is/are trying to do/accomplish now/--:
	let this act be the goals of the actor;
	while a hindered attempt (called the details) fulfills this act:
		now this act is the details;
	decide on this [the most finely detailed, and hindered,] act.

To decide which attempt is what (actor - a person) will do next:
	let the choices be (how the actor can accomplish (what the actor is trying to do now));
	repeat with item running through the choices:
		if the item is untried, decide on the item;
	now the stored action of the goals of the actor is the action of the actor waiting;
	decide on the goals of the actor. ["I don't know"]

[Section 4 - bringing up something in someone's agenda ]

To decide which attempt is (act - a stored action) from the agenda of (performer - a person):
	now the actor part of the act is the performer;
	let the most recent answer be nothing as an attempt;
	repeat with the item running through attempts:
		if the act is the stored action of the item, now the most recent answer is the item;
	decide on the most recent answer.

[To decide which attempt is (act - a stored action) that (performer - a person) did brought up with (listener - a person):
	now the actor part of the act is the performer;
	repeat with the item running through attempts:
		if the act is the stored action of the item, decide on the item;
	decide on nothing as an attempt.

	let this act be the goals of the listener;
	repeat with the details running through the attempts which fulfill this act:
		if the act is the stored action of the details, decide on the details;
		now this act is the details;]

Section - To say an attempt within a sentence naturally

To decide what stored action is the subjectless (act - a stored action): 
	now the actor part of the act is the player;
	decide on the act.

Chapter - Persuasion Uses Both Characters' Turns

[Persuasion commands like BOB, PEEL POTATO use Bob's turn as well as the player's.]

The persuadee is a person that varies.  Before asking someone to try doing something, now the persuadee is the person asked. 

Every turn (this is the every on-stage NPC gets a turn rule):
	repeat with the performer running through on-stage people who are not the player:
		if the performer is not the persuadee,
			try what the performer will do next;
	now the persuadee is the player.

Chapter - Necessary Technical Additions - unindexed

Section - on any action's failure - unindexed

Include After Not Doing Something by Ron Newcomb.  

[ This phrase is safe to use by your game. It's only unindexed to avoid cluttering the index, and, it's easy to forget the "stored action of the" part. ]
To try (act - an attempt): try the stored action of the act.

Section - Temp - unindexed

Include Editable Stored Actions by Ron Newcomb.

[ This phrase is safe to use by your game.  It's only unindexed to avoid cluttering the index. ]
[To change/now the actor part of (act - a stored action) is (actor - a person):
	(- BlkValueWrite({-pointer-to:act}, 3, {actor}); -)]

[	Section - create new attempts - unindexed

Include Dynamic Objects by Jesse McGrew. After cloning a new object from an attempt (this is the new circumvention found rule), fix the cloned stored action property.

To decide what attempt is a new attempt for (actor - a person) who'll try (act - a stored action):
	let the circumvention be a new object cloned from nothing as an attempt; [from the extension Dynamic Objects by Jesse McGrew]
	now the stored action of the circumvention is the act;
	now the actor part of the stored action of the circumvention is the actor;
	now the circumvention is untried; 
	decide on the circumvention.	]

Chapter - Testing Commands - not for release

[For implicitly taking: do nothing instead.]

To say agenda for (actor - a person) indenting (indentation level - a number) times:
	now the actor's next attempt is what the actor will do next;
	say "[sub-agenda for the goals of the actor indenting (the indentation level) times]".

Checking agendas is an action out of world applying to nothing. Understand "agenda" or "agendas" as checking agendas.
Carry out checking agendas:
	repeat with actor running through everyone:
		say "[The actor]:[line break][agenda for the actor indenting one times]".

Checking agendas for is an action out of world applying to one thing. Understand "agendas for/-- [someone]" or "agenda for/-- [someone]" as checking agendas for.
Carry out checking agendas for:
	say agenda for the noun indenting zero times.

Section - not for release - unindexed

The actor's next attempt is an attempt that varies.

To say (act - an attempt) in agenda form:
	say "[act] ([if the act is hindered]hindered by the [meddling check rule of the act][else if the act is partly successful]solved despite the [meddling check rule of the act][else if the act is moot]moot[else][attempt condition of the act][end if])".

To say sub-agenda for (act - an attempt) indenting (indentation level - a number) times:
	repeat with item running through all attempts which fulfill the act:
		repeat with n running from 1 to the indentation level:
			say "    ";
		if the item is the actor's next attempt, say bold type;
		say "[item in agenda form][roman type][line break][sub-agenda for the item indenting (the indentation level + 1) times]"

Chapter - Some standard When Hindered By rules

[ The body of an When Hindered By rule will have statements like "we could try mowing the lawn" ]

Section 1 - the Already Done rules

[ The “already” rules. Thirteen rules prevent doing what’s done. Generally, doing almost any action twice in a row will trip one of these, and I like to believe they’re tripped by accident more than anything else. Trying to wear what you’re wearing, exiting when you’re already outside, these are fairly trivial for an AI to deal with: pretend the action succeeded, even if the player isn’t. ]
When hindered by the can't take what's already taken rule requirement, pretend it worked.
When hindered by the can't drop what's already dropped rule requirement, pretend it worked.
When hindered by the can't enter what's already entered rule requirement, pretend it worked.
When hindered by the can't lock what's already locked rule requirement, pretend it worked.
When hindered by the can't unlock what's already unlocked rule requirement, pretend it worked.
When hindered by the can't switch on what's already on rule requirement, pretend it worked.
When hindered by the can't switch off what's already off rule requirement, pretend it worked.
When hindered by the can't open what's already open rule requirement, pretend it worked.
When hindered by the can't close what's already closed rule requirement, pretend it worked.
When hindered by the can't wear what's already worn rule requirement, pretend it worked.
When hindered by the can't give to yourself rule requirement, pretend it worked.
[When hindered by the can't exit when not inside anything rule requirement, pretend it worked.] [ a syntax bug prevents this. ]
When hindered by (this is the for the can't exit when not inside anything rule): if the reason the action failed is the can't exit when not inside anything rule requirement, pretend it worked. [ workaround ]
When hindered by the can't remove what's not inside rule requirement, pretend it worked.
When hindered by the can't drop what's not held rule requirement, pretend it worked.
When hindered by the can't take off what's not worn rule requirement, pretend it worked.

Section 2 - the Convert rules

[ The “convert” rules. These check rules don’t actually fail at all. Rather, they change the action-in-progess to another action, or massage a noun, such as converting between doors and directions. They’re a little like implicit actions, except that the original action isn’t needed. The new action covers all bases. These too are easy for AI: ignore them. ] 
When hindered by the convert remove to take rule requirement, pretend it worked.
When hindered by the convert put to drop where possible rule requirement, pretend it worked.
When hindered by the convert insert to drop where possible rule requirement, pretend it worked.
When hindered by the convert enter door into go rule requirement, pretend it worked.
When hindered by the convert enter compass direction into go rule requirement, pretend it worked.
When hindered by the convert exit into go out rule requirement, pretend it worked.
When hindered by the convert exit into get off rule requirement, pretend it worked.
When hindered by the convert show to yourself to examine rule requirement, pretend it worked.
When hindered by the translate asking for to giving rule requirement, pretend it worked.
When hindered by the standard pushing in directions rule requirement, pretend it worked.
When hindered by the determine map connection rule requirement, pretend it worked.

Section 3 - the Block rules

[ The “block” rules. It’s the job of these 31 rules to make witty remarks. Oh, they also ignore the player’s attempted action, preferably without annoying the piss out of him. It’s something of a cutting irony that Inform has two swearing actions, and they are also both in here. AI can ignore them, but particular games will almost certainly write exceptions to them. Maybe the author doesn’t want to simulate fire, but lighting a lantern as an exception is pretty common. ]  [ 
When hindered by the block giving rule: 
When hindered by the block showing rule: 
When hindered by the block waking rule: 
When hindered by the block throwing at rule: 
When hindered by the futile to throw things at inanimate objects rule:
When hindered by the block attacking rule: 
When hindered by the block kissing rule: 
When hindered by the block pushing in directions rule: 
When hindered by the block saying yes rule: 
When hindered by the block saying no rule: 
When hindered by the block burning rule: 
When hindered by the block waking up rule: 
When hindered by the block thinking rule: 
When hindered by the block smelling rule: 
When hindered by the block listening rule: 
When hindered by the block tasting rule: 
When hindered by the block cutting rule: 
When hindered by the block jumping rule: 
When hindered by the block tying rule: 
When hindered by the block drinking rule: 
When hindered by the block saying sorry rule: 
When hindered by the block swearing obscenely rule: 
When hindered by the block swearing mildly rule: 
When hindered by the block swinging rule: 
When hindered by the block rubbing rule: 
When hindered by the block setting it to rule: 
When hindered by the block waving hands rule: 
When hindered by the block buying rule: 
When hindered by the block singing rule: 
When hindered by the block climbing rule: 
When hindered by the block sleeping rule: 
]

Section 4 - the -Self rules

[ The ouroborous-like “-self” rules resemble the futility of the “already” rules, but are much sillier. AI ignores these only because if they’re entered, it’s either because some other code is broke, or the author has something unique in mind. Or the player needs a therapist, but Eliza is an application of AI, not an implementation. ]  
When hindered by the can't take yourself rule requirement, pretend it worked.
When hindered by the can't drop yourself rule requirement, pretend it worked.
When hindered by the can't give to yourself rule requirement, pretend it worked.
When hindered by the kissing yourself rule requirement, pretend it worked.
When hindered by the telling yourself rule requirement, pretend it worked.
When hindered by the asking yourself for something rule requirement, pretend it worked.
When hindered by the can't put something on itself rule requirement, pretend it worked.
When hindered by the can't insert something into itself rule requirement, pretend it worked.


Section 5 - the What's Not Held rules

[ Many if not all of the “what’s not held” and “what you haven’t got” rules will automatically try to implicitly take, so AI doesn’t actually need to handle them, unless marketing asks how many unique situations the AI covers. Some of these rules, despite the wording of their names, fall into the “already” and/or “but first” categories. Nevertheless, the language in many of their names, much like the marketing department, emphasizes how poor you are. ]
When hindered by the can't wear what's not held rule requirement: we could try taking the noun. 
When hindered by the can't wave what's not held rule requirement: we could try taking the noun.
When hindered by the can't show what you haven't got rule requirement: we could try taking the noun.
When hindered by the can't give what you haven't got rule requirement: we could try taking the noun.
[When hindered by the can't insert what's not held rule: [implicit take]
When hindered by the can't put what's not held rule: [implicit take]
When hindered by the implicitly remove thrown clothing rule: [implicit]
When hindered by the implicitly pass through other barriers rule: [implicit]
When hindered by the stand up before going rule: [implicit]
]

Section 6 - the But First rules

[ “But first” rules. Some check rules merely call for a rather obvious intermediate action. These are a no-brainer for AI, and perhaps candidates as implicit actions in their own right. These rules aren’t necessarily for the silly player, as they do enforce physical reality. But their inclusion does tend to focus the player more heavily on common-sense actions than on higher goals. Arguably, 90% of all check rules fall into this category. The physical world is like that. ]
When hindered by the can't take what you're inside rule requirement: we could try exiting [the noun].
When hindered by the can't enter closed containers rule requirement: we could try opening the noun.
When hindered by the can't exit closed containers rule requirement: we could try opening the holder of the person asked.
When hindered by the can't insert into closed containers rule requirement: we could try opening the second noun.
When hindered by the can't search closed opaque containers rule requirement: if the noun is a closed opaque container, we could try opening the noun.
When hindered by the can't lock what's open rule requirement: we could try closing the noun.
[When hindered by the can't eat clothing without removing it first rule: [implicitly done]]
When hindered by the can't enter something carried rule requirement: we could try dropping the noun.
[When hindered by the can't put onto something being carried rule requirement: we could try dropping the second noun; we could try putting the noun on the second noun.]
When hindered by the can't drop clothes being worn rule requirement: we could try taking off the noun.
When hindered by the can't put clothes being worn rule requirement:  we could try taking off the noun.
When hindered by the can't insert clothes being worn rule requirement:  we could try taking off the noun.
When hindered by the can't give clothes being worn rule requirement:  we could try taking off the noun.


Section 7 - the Sensory rules

[ Sensory rules. Not actually check rules, but serving the same purpose, these are the hardest for the AI to deal with. Partly because they crop up often, and partly because they are all-encompassing and sometimes vague about why they fail, so a lot of processing needs happen to figure out how to respond. And just to add insult to injury, many of the thorniest problems around AI tend to be caused by the basic accessibility rule alone. ]  [
When hindered by the basic visibility rule:
When hindered by the basic accessibility rule:
When hindered by the access through barriers rule:
When hindered by the can't reach inside rooms rule:
When hindered by the can't reach inside closed containers rule:
When hindered by the can't reach inside rooms rule:
When hindered by the can't reach outside closed containers rule:
When hindered by the can't act in the dark rule:
When hindered by the procedural rulebook (this is the assume success for unknown reason the action failed rule), pretend it worked.
]
When hindered by the carrying requirements rule requirement: we could try taking the noun.


Section 8 - the Carrying Capacity rules

[ The few “carrying capacity” rules actually are dealt with by the AI, partly as blowback from the accessibility rules. But considering that juggling puzzles aren’t a common trope anymore, the responses are simple and straightforward. It’s unlikely they’ll solve any need-a-third-hand puzzles on their own. The author will be welcome to add rules to taste. ]
When hindered by the can't exceed carrying capacity rule requirement: we could try dropping a random carried thing.
When hindered by the can't put if this exceeds carrying capacity rule requirement: we could try taking a random thing which is on the second noun.
When hindered by the can't insert if this exceeds carrying capacity rule requirement: we could try taking a random thing which is in the second noun.
When hindered by the can't drop if this exceeds carrying capacity rule requirement: 
	let H be the holder of the person asked;
	if H is a supporter:
		we could try taking a random thing which is on H;
		we could try exiting;
	otherwise:
		we could try taking a random thing which is in H;
		we could try exiting.

Section 9 - the Matching Key rules

[ The “matching key” rules. These three check rules brought up quite a dilemma. While the AI could easily fetch and use a lock’s matching key, in-world, it makes no sense. While auto-taking any keys happened upon by the I-F player is natural, the kleptomaniac tendencies are less understandable in an NPC who lives in that world. The fundamental problem is one of differing kinds of prescient knowledge. Although a player easily knows keys are more valuable than anything in an I-F world, and will grab them immediately no matter who the in-world owner is, it’s stealing. And although the AI can easily peek behind the scenes to learn whether a given lock has a matching key, and where the key is, it’s cheating. Unfortunately, Inform doesn’t automatically track NPC knowledge, so any rules the AI needs will depend on what and how much the author implements. At the end of the day, I chose to leave these completely unimplemented.  ][
When hindered by the can't open what's locked rule: we could try unlocking the noun with the matching key of the noun.
When hindered by the can't lock without the correct key rule: 
When hindered by the can't unlock without the correct key rule: 
]

[ Our final set of categories fall under the broad rubric of physics. While many earlier rules deal with ridiculous situations, silly commands, and ensuring necessary prerequisites, these last categories lend rigor to I-F’s physical world. Space and furniture sit alongside sentience and gravity in less than fifty rules. Generally, the AI won’t attempt a thing for any violations. If an author decides to make angry dragons edible, it’s on them to inform the AI that to eat is to defeat. ]

Section 10 - the Kind rules

[ The “kind” rules. Clothing is for wearing, vehicles for riding, and mailboxes for spam. But sometimes these fundamental facts will be forgotten, and these rules step in to ensure cats and dogs don’t live together. ][
When hindered by the can't put onto what's not a supporter rule: 
When hindered by the can't insert into what's not a container rule: 
When hindered by the can't travel in what's not a vehicle rule: 
When hindered by the can't wear what's not clothing rule: 
When hindered by the can't search unless container or supporter rule: 
When hindered by the can't give to a non-person rule: 
When hindered by the can't get off things rule: 
When hindered by the can't push to non-directions rule:  we could try listing exits.
When hindered by the can't take component parts rule:      [listed twice in Check Taking]
When hindered by the can only take things rule: 
]

Section 11 - The -Able and -Ible rules

[ The “-able / -ible” rules. Related to the above, these check particular properties. Some, but not all, vehicles can be locked. Some, but not all, mailboxes can be climbed into. And some, but unfortunately few, T-shirts can be switched on. When a player assumes underwear is edible, these rules save him from uncomfortable conversations with doctors. ] [
When hindered by the can't switch on unless switchable rule: 
When hindered by the can't switch off unless switchable rule: 
When hindered by the can't open unless openable rule: 
When hindered by the can't close unless openable rule: 
When hindered by the can't push unpushable things rule: 
When hindered by the can't enter what's not enterable rule: 
When hindered by the can't eat unless edible rule: 
When hindered by the can't lock without a lock rule: 
When hindered by the can't unlock without a lock rule: 
]

Section 12 - the People rules

[ “People” rules. People tend to have opinions on being manhandled. People also tend to get much more unruly than inanimate objects when manhandled. Please manhandle people with care. ] [
When hindered by the can't take other people rule: ]
When hindered by the can't take people's possessions rule requirement: we could try asking the holder of the noun for the noun.[
When hindered by the can't remove from people rule: 
When hindered by the can't pull people rule: 
When hindered by the can't push people rule: 
When hindered by the can't turn people rule: 
When hindered by the innuendo about squeezing people rule: 
]

Section 13 - the Property rules

[ If the above corrects for assuming something has properties it doesn’t, these correct for assuming a lack of properties that actually are in attendance. “Scenery”, “fixed in place”, “concealed/undescribed”, “on-stage”, “adjacent”… or just solid oak. ] [
When hindered by the can't take scenery rule: 
When hindered by the can't pull scenery rule: 
When hindered by the can't push scenery rule: 
When hindered by the can't turn scenery rule: 
When hindered by the can't take what's fixed in place rule: 
When hindered by the can't pull what's fixed in place rule: 
When hindered by the can't push what's fixed in place rule: 
When hindered by the can't turn what's fixed in place rule: 
When hindered by the can't go through undescribed doors rule: 
When hindered by the can't take items out of play rule: 
When hindered by the can't go that way rule: 
When hindered by the can't go through closed doors rule:
]

[ And finally, that definition of gravity I promised. ] [
When hindered by the can't push vertically rule: 
]


Problem-Solving Characters ends here.

---- DOCUMENTATION ----

Section: How to Circumvent an Obstacle

When a character tries to unlock a door but is told, "You lack the key," the door becomes an obstacle.  Or in terms of Inform-ese, a check rule on the Unlocking action called "the can't unlock without the correct key rule" is the obstacle. We can show characters how to circumvent the obstacle with:
 
	When hindered by the can't unlock without the correct key rule requirement, we could try finding the matching key of the noun.
 
That rule has an advantage over this:
 
	Before someone opening a locked door, try the actor finding the matching key of the noun.
 
The Before rule would try the circumvention immediately, in the same turn.  If the finding action involves travelling around the map, which incidentally requires circumventing other locked doors and many other things, well, that's a lot of action for a single turn.  By contrast, the Hindered By rule saves the circumventing action for next turn, and can re-try the original action on the turn after that.  If the finding action requires a lot of sub-actions to complete, the whole string of actions is remembered and re-tried, in correct order, over as many turns as necessary.  

This extension handles all the bookkeeping. The AGENDA testing command (abbreviated A) shows the outline for each character, with each action's status.  One action in a character's outline may be in bold print.  If so, that is the action that character will perform the next time he or she gets a turn.  It can be fetched with the phrase "what (someone) will do next", and even printed to the screen as part of a THINK or HINT command.  It is also the phrase used by the "every on-stage NPC gets a turn rule", found in the Every Turn rules.

	> AGENDA
	Bob:
		taking the potato (solved the basic accessibility rule)
			speaking with the microwave (failed)
			attacking the microwave (failed)
			opening the microwave (successful)
			dropping the microwave (moot)
		taking the potato (hindered by the hot potato rule)
			examining the potato (untried)

If multiple actions were suggested by the When Hindered By rules, they are tried in that order, one per turn, until one of them succeeds.  When one does succeed, the parent action is re-tried, and should succeed this time. If it does, the untried alternatives are rendered moot.  If it fails again but because of a different check rule requirement, it is marked partly successful, the agenda says it "solved" the old check rule requirement, and the action is re-created in the outline as hindered by the new check rule. 

In lieu of the "we could try" phrase in response to a hinderance, we can "pretend it worked".  The "already" check rules use this, like so.

	When hindered by the can't lock what's already locked rule requirement, pretend it worked.

Commands like BOB, PEEL POTATO use Bob's turn as well as the player's.  A character is "busy" if he's working through his agenda, but if persuasion succeeds he'll pause what he's doing to serve the player. This is also part of the "every on-stage NPC gets a turn" rule.


Section: Expressed in Language

The bookkeeping can serve a secondary purpose to make our NPCs seem a little more alive. A chain of actions have a why/how relationship.  Why are you trying to find that key? To unlock that door.  How are you going to unlock that door? By finding the key, or, bashing it down.  If we can parse a player's questions, there's many phrases that can answer them using the bookkeeping.  The example Motive and Method shows the basics with a minimum of parser work.  

All of these phrases are optional to learn.  They exist only for convenience. 

First, since it is easier to work OPENING THE MICROWAVE into prose than BOB OPENING THE MICROWAVE, this phrase does just that.

	subjectless (stored action)

Second, these phrases answer questions about when the attempt happens.

	if (attempt) is in the past
	if (attempt) is in the present
	if (attempt) is in the future
	if (attempt) is a could've been
	if confused about timing is (true/false)

These phrases explore the agenda and decide on an attempt, except the can/could phrases which decide on a list of attempts.

	why (person) did/accomplished (attempt)
	why (person) will do/accomplish/-- (attempt)
	why (person) is/are doing/accomplishing (attempt)
	how (person) did/accomplished (attempt)
	how (person) will do/accomplish/-- (attempt)
	how (person) can do/accomplish (attempt) 
	how (person) could do/accomplish (attempt) 
	how (person) could have done/accomplished (attempt) 
	what (person) is/are trying to do/accomplish now/--
	what (person) will do next
	(stored action) from the agenda of (person)

If the player asks why on a "top-level" attempt, the author must provide the answer.  Similar if a How phrase returns nothing.

Finally, the truth state "confused about timing" is true if you use a did/will phrase, but the attempt isn't in the past/future that the question assumed. The extension doesn't use this information, but it provides it in case it's wanted.

 
Section: Similarities to Narrative Scenes

In an effort to inspire more narratively driven works that incorporate reactive characters, I'd like to share some interesting parallels between how narrative scenes are constructed and this extension in order to fire the imagination.

* Kurt Vonnegut said every character should want something, even if just a glass of water. In this extension what a character wants is represented by the top-level action in that character's agenda, as a parser command: GET WATER.  Or, TAKE WORLD.  Or,  FATHER, NO.

* Attaining that desire isn't going to be easy, else why read about it?  There will be obstacles and there will be struggle, and by the end of it the character will be irrevocably changed by the experience.  This extension represents obstacles as check rules, especially ones custom-made by the author for the particular characters in the particular story.  (Most of the standard rules in Inform's library merely enforce the basics of physical reality.) 

* When Hindered By rules are, effectively, character reactions.

* A scene highlights a character and an attempt to get what is wanted at that moment, such as an item or a solution to a problem they're thinking about, or some kind of acknowledgement from someone.  (The main character of a scene isn't necessarily the main character of the story.)  The scene ends in one of three ways: the character gets what they want, or they don't, or it's postponed.  These map directly onto the three major statuses of an attempt object:  successful, failed, and hindered.  

* A scene has three parts, beginning, middle and end.  The beginning introduces who the scene's main character is, where they're at, what they're trying to do, etc.  Generally this part of a scene wouldn't be interactive, because it would be asking the player to make decisions before the author has oriented them. Instead, it's a fine place to mention things the player has done, to both "prove" to the player they can affect the story world, and hold their interest through a long non-interactive description by briefly focusing on them. "What the character is trying to do" and "what a character will do next" are phrases in this extension.

* The mid-scene usually has the conflict, whether physical or verbal or internal or some combination. It has a to-and-fro sense to it, almost like a dance. To observe a conflict is to see multiple small obstacles and circumventions in rapid sequence.  The mid-scene is where the parser gets to do a lot.  The mid-scene can be choppy and full of dead-ends plot-wise, which can cause a player to focus attention on the game elements over the writing.

* The end of a scene shows whether the character got what they wanted, and sometimes how they deal with it. In a CYOA this is a fine place for the three or four options on what happens next. In a parser work the commands might be at a slightly higher level of abstraction, like VISIT somewhere or someone, or INVESTIGATE some case or place, and so on, for which a new scene would delve into the details.  The end can also be a good place for foreshadowing, since the player is no longer concentrated on in-the-moment game elements. To this extension, the end of a scene means an untried action in that character's agenda is about to change status to failed, succeeded, or hindered.

* If the player-character is the main character of the story, and the walkthrough for the game were formatted to fit the AGENDA testing command, then the agenda would be the story's plot outline. If the player-character is NOT the main character of the story, they can be positioned as a third-party to the story's central conflict. This allows very interesting choices for the player on how to relate to the main conflict:  choose one side over the other?  Mediate between them?  Escalate the conflict?  Or perhaps a three-way dispute would be more interesting. If you ignore it to pursue your own sandbox goals, will the other characters allow you to do so?

* If puzzles seem out of place but something 'crunchy' is still desired, one alternative could be the type of turn-based, multi-player gameplay found in ordinary board games, card games, and sports. These games differ in how well players can determine who's the current winner, and in how much players can interfere with each other's plans.  Golf and bowling play out like several side-by-side games of solitaire, while Settlers of Catan is a board game of Screw Your Neighbor married to a card game of Screw The Winner, where every road ends in a fork.  This extension allows the "how to play" knowledge that drives the NPCs to be broken into bite-sized pieces spread across When Hindered By rules. (More sophisticated what-if analysis would require the extension Hypothetical Questions, by Jesse McGrew.)

Inform's standard actions allow characters to navigate and manipulate a mostly physical world.  But by writing actions to convince, coerce, support, offer, blackmail, protect, teach, conceal, investigate, chase, negotiate, lie, entrap, broadcast, steal, inform, pressure, manipulate, fool, bring to justice, love, and all the other things that people don't do to medium-sized dry goods, the above framework becomes a little more interesting.

[some conversational actions in a verbal conflict:
"you cannot say that to me because" (hypocrit?)
"that is incorrect because" (reason?)
"your view of the same facts is distorted because" (ad hominem?)
"I believe(d) this because" (confirming or excusing)
"I had to / was forced to, because" (defending)
"What (or why) was..." (learning)]

Example: * Baked Potato - Careful, it's hot.

	*: "Baked Potato"

	Include Problem-Solving Characters by Ron Newcomb.

	Bob's Kitchen is room.

	Bob is a man in Bob's kitchen. A microwave is a closed openable transparent container here.

	A potato is in the microwave. A thing can be hot. The potato is hot.

	Persuasion: persuasion succeeds.

	Unsuccessful attempt by when the reason the action failed is the basic accessibility rule: say "'Just a sec.'" instead.

	Unsuccessful attempt by Bob attacking something: say "Bob stabs the open button ineffectively." instead.

	Check an actor taking something hot (this is the hot potato rule): say "Too hot!" instead.

	Report an actor examining something hot: now the potato is not hot; say "It eventually cools down." instead.

	When hindered by the hot potato rule requirement, we could try examining the noun.

	When hindered by the basic accessibility rule:
		we could try attacking the holder of the noun;
		if the holder of the noun is not the holder of the person asked, we could try opening the holder of the noun;
		we could try dropping the holder of the noun.

	Test me with "a / Bob, take the potato / a / wait / a / wait / a / wait / a / wait / a / wait / a / wait".



Example: *** Motive and Method - Answering WHY and HOW, and some simple parsing to understand the question.

We'll start with the hot potato example, then add the necessary code.

	*: "Motive and Method"
	
	Include Problem-Solving Characters by Ron Newcomb.

	There is room.

	When hindered by the basic accessibility rule:
		we could try attacking the holder of the noun;
		if the holder of the noun is not the holder of the person asked, we could try opening the holder of the noun;
		we could try dropping the holder of the noun.

	Bob is a man.
	A microwave is a closed openable transparent container. Bob and the microwave are here.
	A potato is in the microwave.
	Persuasion: rule succeeds.

	A thing can be hot. The potato is hot.

	Check an actor taking something hot (this is the hot potato rule): say "Too hot!" instead.

	Report an actor examining something hot: now the potato is not hot; say "It eventually cools down." instead.

	When hindered by the hot potato rule requirement, we could try examining the noun.

	Test me with "Bob, take the potato / a / wait / why did you attack the microwave / what are you doing / how will you take the potato / wait / why did you take the potato".

	Persuasion: persuasion succeeds.

	Unsuccessful attempt by when the reason the action failed is the basic accessibility rule: say "'Just a sec.'" instead.

	Unsuccessful attempt by Bob attacking something: say "Bob stabs the open button ineffectively." instead.

Now we'll add the code to handle the questions.  The first hurdle is the parser.  WHY and HOW questions take an entire command after them, but if we require a wording like WHY DID YOU TAKE THE POTATO, then we can capture the WHY/HOW in truth states that vary, cut the rest, and leave only TAKE THE POTATO for the parser.

	*: Asking why, asking how are truth states that vary.
	
	After reading a command:
		now asking why is (whether or not the player's command includes "why");
		now asking how is (whether or not the player's command includes "how");
		while the player's command includes "why/how/will/did/do/could/you":
			cut the matched text.
	
But to whom is the player speaking?  And if the player enters DAPHNE, WHY DID YOU TAKE THE POTATO, then they're clearly asking Daphne regardless who they were talking with previously. Let's remember conversation partners, and handle the directly-addressed case.
	
	*: The current interlocutor is a person that varies, Bob. 
	
	Persuasion when asking why is true or asking how is true: now the current interlocutor is the person asked; persuasion succeeds.
	
Finally, the money shot. The leftover command is parsed as taking the potato, but this Instead rule uses the truth states to determine that a question needs answering rather than a potato needing taking. We feed the current action to a phrase which searches the person's entire agenda for a match. If it finds taking the potato in Bob's past, present, or future, it then gives it to one of the phrases that gets the motive (why) or the method (how) for it. Note that we don't spend much time here dealing with differences in tense, endless WHYs or HOWs, creating attempt based rulebooks for a character, etc. which we would do in a real work. 
	
	*: Instead of an actor doing anything when asking why is true or asking how is true:
		let the act in question be the current action from the agenda of the current interlocutor;
		if the act in question is nothing, say "'I don't know what you're talking about.'" instead;
		if asking why is true, now the act in question is why the current interlocutor is doing the act in question; 
		if asking how is true, now the act in question is how the current interlocutor will accomplish the act in question;
		if the act in question is nothing, say "'Like this,' Bob quips." instead;
		if Bob plans the act in question, say "'Er, because you told me to.'" instead; 
		if asking why is true, say "'Because I'm [act in question],' answers Bob.";
		if asking how is true, say "'By [act in question],' answers Bob."
	
Similarly, we can make a current response.
	
	*: After reading a command when the player's command matches "what are you doing", replace the player's command with "ask [the current interlocutor] about themself".
	
	Instead of asking someone about "themself/himself/herself", say "'I'm [what the noun will do next],' replies [the noun]." 
			


Example: * To list all check rules - Insert this at the very end of your work's text to list all the check rules in your game, with an When Hindered By preamble wrapped around.

	*: "List the Check Rules"

	To repeat with (Nth - nonexisting rule based rulebook variable) running through rulebooks begin -- end: 
	(- for ({Nth} = 0; {Nth} <= NUMBER_RULEBOOKS_CREATED; ++{Nth})  -). 


	There is room. 


	To repeat with (Rth - nonexisting rule variable) running through (rb - a rule based rulebook) begin -- end:
	(- for (parameter_object = 0 : (rulebooks_array-->{rb})-->parameter_object ~= NULL : ++parameter_object) 
		{ {Rth} = (rulebooks_array-->{rb})-->parameter_object;  !-).



	When play begins:
		repeat with book running through rulebooks:
			if "[book]" matches the text "check":
				say "[line break][bracket][book][close bracket][line break]";
				repeat with obstacle running through the book:
					say "When hindered by the [obstacle] requirement: [line break]";
		[say "WHEN HINDERED BY.";
		repeat with reaction running through The when hindered by rules:
			say "[reaction] [line break]";]
