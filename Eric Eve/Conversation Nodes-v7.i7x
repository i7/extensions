Version 7 of Conversation Nodes by Eric Eve begins here.
"Builds on Conversational Defaults and adds the ability to define particular points in a conversational thread (nodes) at which particular conversational options become available."

Book 1 - Includes

Include Conversation Responses by Eric Eve. 
Include Conversational Defaults by Eric Eve.

Book 2 - Definitions

Part 1 - The Convnode Kind

A convnode is a kind of thing.
A convnode can be open or closed. A convnode is usually open. 
A convnode has a convnode called the next-node. The next-node of a convnode is usually the null-node. 
A convnode has a number called the node-time. The node-time of a convnode is usually 1.

The specification of a convnode is "A convnode is a thing that represents a particular point in a conversation at which particular conversational responses become relevant (such as when an NPC has asked a question to which you might want to respond YES or NO). A convnode can be open (in which case it normally lasts only one turn, and can be effectively bypassed altogether if the player chooses to ignore the extra options available at that point) or closed (in which case only the conversational responses available for that convnode are available, and the player will be stuck in the convnode until explicitly released; this can be used to allow an NPC to force a player to answer his/her question)."


Part 2 - The Null-Node

The null-node is a convnode.
A person has a convnode called the node.
The node of a person is usually the null-node.

Part 3 - Global Variables

The node-timer is a number that varies.
The next-scheduled-node is a convnode that varies.
The next-scheduled-node is the null-node.

conversed-this-turn is a truth state that varies.
conversed-this-turn is false.

To decide which convnode is the current node:
  if the current interlocutor is not a person, decide on the null-node;
  decide on the node of the current interlocutor.


Book 2 - Node-Switching Machinery

To say node (new-node - a convnode):
  now the next-scheduled-node is the new-node;
  the node switches in 0 turns from now.

To setnode (new-node - a convnode):
  now the next-scheduled-node is the new-node;
  the node switches in 0 turns from now.

To say leavenode: 
  now the next-scheduled-node is the next-node of the current node;
  the node switches in 0 turns from now.

At the time when the node switches:  
     if the current interlocutor is a person, advance the conversation node.

To advance the conversation node:
       now the node of the current interlocutor is the next-scheduled-node;
       now the node-timer is the node-time of the current node;    
       follow the node-introduction rules for the current node;

To initiate a/-- conversation with (new-speaker - a person) at/in/using/with (new-node - a convnode), immediately:
  now the current interlocutor is new-speaker;
  now the next-scheduled-node is new-node;
  if immediately, advance the conversation node; 
  otherwise the node switches in 0 turns from now.


Book 3 - Rules

Part 1 - Node-Specific Rules

The node-introduction rules are an object-based rulebook.
The node-continuation rules are an object-based rulebook.
The node-termination rules are an object-based rulebook. The node-termination rules have default failure.

Before going from somewhere when the current node is not null-node (this is the check going during convnode rule):
  abide by the node-termination rules for the current node.

[ The check going during convnode rule is listed before the say goodbye when moving rule in the before rules. ]

Check saying goodbye to someone when the farewell type is explicit (this is the explicit farewell during convnode rule):
  abide by the node-termination rules for the current node.

Every turn when the current node is not the null-node (this is the node continuation rule):
  if conversed-this-turn is false, follow the node-continuation rules for the current node;
  otherwise now conversed-this-turn is false.
  
Before speaking when the current node is not the null-node and the current node is open (this is the decrease node-timer rule): 
  decrease the node-timer by 1.
  
Before speaking (this is the note conversation rule):
  now conversed-this-turn is true.

Before giving something to someone (this is the node giving rule):
  now conversed-this-turn is true.

Before showing something to someone (this is the node showing rule):
  now conversed-this-turn is true.


Every turn when the current node is not the null-node and the current node is open and the node-timer < 1 (this is the node-switching rule):
 now the next-scheduled-node is the next-node of the current node;
 the node switches in 0 turns from now.


To decide if at-node (cnode - a convnode):
  decide on whether or not the current node is cnode.

Part 2 -  Responses for Closed Nodes

Check asking it about when the node of the noun is closed (this is the nodal ask response rule):
  abide by the response rules for the current node;
  abide by the default ask response rules for the current node.

Check quizzing it about when the node of the noun is closed (this is the nodal quiz response rule):
   abide by the response rules for the current node; 
   abide by the default ask response rules for the current node.

Check telling it about when the node of the noun is closed (this is the nodal tell response rule):
   abide by the response rules for the current node;
   abide by the default tell response rules for the current node.

Check informing it about when the node of the noun is closed (this is the nodal inform response rule):
  abide by the response rules for the current node;
  abide by the default tell response rules for the current node.

Check answering it that when the node of the noun is closed (this is the nodal answer response rule):
  abide by the response rules for the current node;
  abide by the default answer response rules for the current node.

Check giving it to when the node of the  second noun is closed (this is the nodal give response rule):
  abide by the response rules for the current node;
  abide by the default give response rules for the current node.

Check showing it to when the node of the second noun is closed (this is the nodal show response rule):
  abide by the response rules for the current node;
  abide by the default show response rules for the current node.

Check requesting it for when the node of the noun is closed (this is the nodal request response rule):  
  abide by the response rules for the current node;
  abide by the default ask-for response rules for the current node.

Check imploring it for when the node of the noun is closed (this is the nodal implore response rule):
  abide by the response rules for the current node;
  abide by the default ask-for response rules for the current node.

Check saying yes when the current node is closed (this is the nodal yes response rule):
  abide by the response rules for the current node;
  abide by the default yes-no response rules for the current node.

Check saying no when the current node is closed (this is the nodal no response rule):
  abide by the response rules for the current node;
  abide by the default yes-no response rules for the current node.

Check saying sorry when the current node is closed (this is the nodal sorry response rule):
  abide by the response rules for the current node;
  abide by the default response rules for the current node.

Part 3 - Responses for Open Nodes

This is the open node response rule:
  if the current node is not the null-node, abide by the response rules for the current node.

The open node response rule is listed first in the report asking it about rules.
The open node response rule is listed first in the report quizzing it about rules.
The open node response rule is listed first in the report telling it about rules.
The open node response rule is listed first in the report informing it about rules.
The open node response rule is listed first in the report answering it that rules.
The open node response rule is listed first in the report requesting it for rules.
The open node response rule is listed first in the report imploring it for rules.
The open node response rule is listed first in the report saying yes rules.
The open node response rule is listed first in the report saying no rules.
The open node response rule is listed first in the report saying sorry rules.
The open node response rule is listed first in the report giving it to rules.
The open node response rule is listed first in the report showing it to rules.

Conversation Nodes ends here.

---- DOCUMENTATION ----

Chapter: Introduction and Overview

Many ask/tell conversations in works of Interactive Fiction can end up a bit like querying a database: we ASK BOB ABOUT THIS and TELL SUE ABOUT THAT, but there may not be much sense of the conversation progressing, and the NPC we're talking with can seem a purely passive conversationalist, only ever responding to the player's conversational commands as if he or she were little more than a talking encyclopaedia.

Conversation nodes provide a way of giving more structure to a conversation. They even allow allow us to have an NPC ask a question and insist upon receiving a reply. Alternatively they might model a fleeting point in the conversation at which the player could meaningfully respond with YES or NO, say, but could equally well decide to move on to another topic, e.g.:

	>ask sarah about mary
	"Do you know Mary," you ask.

	"Yes, I know her well," she replies, "Nice girl, don't you think?"

	>yes
	"Absolutely," you agree.

	Sarah nods her approval.

Which could just as well have been:

	>ask sarah about mary
	"Do you know Mary," you ask.

	"Yes, I know her well," she replies, "Nice girl, don't you think?"

	>tell sarah about tom
	...

In the second case Sarah's question is ignored as effectively rhetorical, which it could not be if, for example, Sarah had just asked, "Are you seeing another woman?", and won't let go till she gets an answer!

The first kind of node, in which Sarah just asks "Nice girl, don't you think?", is an open node. The player could reply yes or no here, but doesn't have to, and is free to move straight on to another topic. The other kind of node, in which the NPC insists on an answer before the conversation can move on, is a closed node. We'll say more about open and closed nodes below.

Chapter: The basics of using convnodes.

Section: Defining a New Convnode

Defining a new convnode is easy. We just use a statement like:

	The bob-kitchen-node is a convnode.
	The sarah-jealousy-node is a closed convnode.

Note that a convnode is open unless we say otherwise.

A convnode has a couple of other properties we can define: next-node and node-time. We'll see how these can be used in more detail below, but briefly speaking next-node is the the convnode we'll go to when we leave this one, and node-time is the number of turns on which there are conversational commands for which we'll stick with this node. Next-node is normally the null-node, and node-timer is normally 1. Node-timer is only relevant for open nodes (we stay in a closed node until we say otherwise).

Section: NPCs and Convnodes

Each NPC in the game has a property called node, which holds the current convnode object for that NPC. Normally (and if we don't define otherwise), this will be the null-node, which effectively means we're not at any convnode at all (there's nothing to stop us altering the behaviour of the null-node, but it's probably not a very good idea, since we need something to mean 'effectively no node at all', and this extension assumes that the null-node is it).

If we want an NPC to start off in another convnode, we can do so easily enough:

	Bob is a man in the kitchen. The node is the bob-kitchen-node.

We can also change an NPC's node in the normal way, with, for example:

	now the node of Bob is the null node;

or

	now the node of Bob is the bob-lounge-node;

This is fine if the player is not currently talking to Bob and we want to set Bob up for his next conversation, but if we want to switch Bob's node in the middle of a conversation, it's better to use the node-switching machinery provided by the extension.

Section: The Current Interlocutor and the Current Node

Conversation Nodes inherits the global variable current interlocutor from Conversation Framework. The current interlocutor is the person we're currently speaking to, if there's a conversation in progress.

It follows that the current conversation node is the node of the current interlocutor. Since this is rather a long expression to type, we can refer to it simply as "the current node". Note that we can use "the current node" to get at the value of the current conversation node, but we can't change "the current node" (it's a to decide... phrase, not a global variable). It's also safe to use "the current node" when there isn't a current interlocutor (the value of the current node is then the null-node).

Section: Changing Nodes in Mid-Conversation.

Conversation Nodes defines two to say phrases which make it easy to switch to a new conversation node in the middle of a conversation (something we may frequently wish to do):

	to say node (new-node - a convnode):
	to say leavenode:

These phrases would normally be embedded in pieces of text:

	response for sarah-jealousy-node when saying yes:
	say "'Yes, I'm seeing a really nice girl I met...'

'You [italic type]bastard[roman type]!'[node sarah-furious-node] she shrieks, 'What do have to say for yourself? Do you have any excuse to offer at all?'"

	response for sarah-furious-node when saying no:
	say "'No, none,' you admit. 

	'Then I think you should just go,' [leavenode] she says flatly."

The first of these "[node sarah-furious-node]" switches the node to sarah-furious-node. The second "[leavenode]" switches the node to whatever the next-node of sarah-furious-node happens to be. We can also use the phrase:

	setnode bob-kitchen-node;

Outside a piece of text to change convnode. 

Note that these phrases don't actually change the convnode straight away; they schedule a change of convnode at the end of the turn (thus preventing any odd effects we might get from a mid-turn convnode switch). They also ensure that certain housekeeping tasks are carried out that keep the node-switching machinery working smoothly. That's why we should always use these phrases to change node in mid-conversation rather than trying to change the node of the current interlocutor directly.

Chapter: Defining Conversation Responses for Conversation Nodes

Section: Ordinary Conversation Responses:

The Conversation Responses extension included by Conversation Nodes allows you to define conversational responses for an NPC with rules like:

	Response of Bob when asked about "money":
	Response of Sarah when told about Bob:


When defining conversational responses relating to a specific node, we use same the format, but substitute the node name for the name of the NPC. The kinds of rule we can use for defining node-specific conversational response are thus:

	Response of my-node when asked about "money":
	Response of my-node when asked about the gold ring:
	Response of my-node when told about "life":
	Response of my-node when told about Napoleon:
	Response of my-node when asked-or-told about "canadian politics":
	Response of my-node when asked for "advice":
	Response of my-node when asked for the brass key:
	Response of my-node when answered that "probably":
	Response of my-node when shown the diamond ring:
	Response of my-node when given the copper coin:
	Response of my-node when given-or-shown the brass farthing:
	Response of my-node when saying yes:
	Response of my-node when saying no:
	Response of my-node when saying sorry:

Note the asked-or-told and given-or-shown forms, which allow us to combine responses for ASK and TELL, and for GIVE and SHOW.

Section: Default Responses:

For a closed node (see below) we need additionally to define one or more default responses to handle conversational commands not specifically dealt with in the node. This will normally be a response in which the NPC insists that the player character answer the question s/he's just been asked. For example:

	Default response for sarah-jealous-node:
	say "'Don't try to change the subject!' she snaps, 'I asked you if you were seeing another woman. Well, are you or aren't you: yes or no?"

We define default responses for (closed) nodes in the same way that the Conversational Defaults extension (included with this one) lets us define them for NPCs, except that we use the name of the node instead of the NPC. Although a simple "Default response for" is often enough, the complete ramge of default response types is available:

	Default ask response for my-mode:
	Defaut tell response for my-node:
	Default ask-tell response for my-node:
	Default give response for my-node:
	Default show response for my-node:
	Default give-show response for my-node:
	Default answer response for my-node:
	Default ask-for response for my-node:
	Default yes-no response for my-node:
	Default response for my-node:

The last of these is a catch-all default response that will catch any conversational command for which we haven't provided a more specific default response. For example if we defined a Default ask response rule and a Default response rule, the Default ask response rule would trap any ASK SOMEONE ABOUT SOMETHING commands, and the Default response rule would respond to all the rest (for which we had not provided more specific responses in the node).

Note the hyphen in "Default ask-for response". The name "Default ask for response" would confuse the I7 compiler.

Section: Using Instead and After Rules as alternatives to Response Rules.

It is not absolutely necessary to use "Response for..." rules. We can (more or less) achieve the same effect by using Instead rules for node-specific responses and After rules for actor-specific responses, e.g.:

	Instead of asking Bob about "money" when the current node is the bob-impecunious-node:
	say "'I could really do with some,' he tells you."

	After asking Bob about "money":
	say "'It's nice if you've got it,' Bob opines."

Using Instead and After in this way ensures that node-specific responses are always used in preference to those that are not node-specific (which is almost certainly what we want); it also ensures that closed nodes work properly (closed nodes look for default responses at the Check stage). The node-specific rule shown above may look long-winded but it could be written more concisely as:

	Instead of asking Bob about "money" when at-node bob-impecunious-node:
	say "'I could really do with some,' he tells you."

Which you may or may not prefer to:

	Response of bob-impecunious-nose when asked about "money":
	say "'I could really do with some,' he tells you."

Although even if you use Instead and After for specific responses, it's a good idea to use Default response rules for default ones.

Although this extension should work either way, there may be certain advantages to using Response rules:

1.	In a conversation-heavy game, the mass of after and instead rules would presumably have to be checked for every single action (since the After and Instead rulebooks are not action-specific), and this might have some impact on performance. Response rules are only checked for conversational commands (they're invoked from the Check and Report rulebooks).

2.	Response rules make it easier to write rules relating to more than one type of conversational command, combining responses to ASK ABOUT and TELL ABOUT and to GIVE and SHOW.

3.	We can use Response rules without having to remember the names of a variety of actions (e.g. asking it about and quizzing it about for ASK X ABOUT Y or requesting it for and imploring it for for ASK X FOR Y). This:

	Response of Bob when asked for "advice":

May be clearer (and easier to remember) than this:

	After imploring Bob for "advice":

4.	Using the Response rules helps ensures that everything happens in the right sequence:

	Normal responses for a closed convnode
	Default responses for a closed convnode
	Normal responses for an open convnode
	Normal responses for the NPC
	Default responses for the NPC


Chapter: Setting Up an Open Node

Open Nodes (which are generally intended to be fleeting) are generally the easier kind to set up. First we need to define our node object:

	mary-nice-node is a convnode.

Then we need to define the responses that apply when that node is active:

	response for mary-nice-node when saying yes:
	"'Absolutely,' you agree.

Sarah nods in silent approval."

	response for mary-nice-node when saying no:
	"'No. Actually I can't stand the woman!' you declare.

'Goodness!' Sarah exclaims, 'Well, perhaps we'd better change the subject.'"

	response for mary-nice-node when asked about Mary:
	"'Are we talking about the same Mary?' you wonder.

'I think so,' she replies, 'I thought the only one we both knew is Mary Parker.'"

An open node is usually transient. In other words it usually only lasts for one conversational turn (note, not simply one turn, since the player can carry out any number of non-conversational commands without effecting the status of an open node). This is probably the commonest case, but there may be times when we want an open node to last longer, e.g. in order to make a whole group of conversational responses available over some portion of the conversation (any of which will take precedence over responses we have defined for the NPC).

There are two ways in which we can make an open node more persistent. One is to make its next-node property point to itself. For example, if we were to define:

	my-node is a convnode. The next-node is my-node.

Then my-node will still try to change after one conversational command, but what it changes to is the node defined in its next-node property, which is now my-node, so the effect is that we stay in my-node until we take some active step to leave it.

The other way is to change the node-time property of the node to something greater than 1. For example, if we were to define:

	my-node is a convnode. The node-time is 3.

Then my-node would persist for three conversational turns before changing to whatever its next-node property defined (usually null-node). If we defined node-time to be sme very large number indeed this would effectively make my-node semi-permanent (i.e. it would stay in force until we took active steps to change it, or until we ended the conversation with the NPC).

Chapter: Setting Up a Closed Node

Section: Overview - The Basic Minimum

While an open node is generally transient, a closed node generally persists until the player gives the current interlocutor an answer he or she is prepared to accept. Also, whereas an open node does not prevent the player from addressing the topics defined for the NPC outside the node (unless it defines one for the same topic), a closed node does. It's called a closed node because we can't reach outside it until we're allowed to leave.

For a closed node the minimum we must define is:

1.	One or more response rules (or instead rules) corresponding to the responses the current interlocutor will accept. These responses must then take the player out of the node via "[node another-node]", "[leavenode]" or setnode another-node.

2.	A default response rule for the node, that defines the current interlocutor's response when the player attempts a conversational command the current interlocutor rejects. Normally this should repeat the question the current interlocutor wants answered, together with some indications of what s/he's likely to accept as an answer.

We can also define specific responses for other topics the current interlocutor won't accept, and more specific types of default response (e.g. default give-show response), if we so wish. There are also a number of other things we can do to make the closed node behave in a more sophisticated way. We'll look at those below.

So, the basic minimum for a closed node would be something like the following:

	sarah-jealous-node is a closed convnode.

	response for sarah-jealous-node when saying yes:
	say "[leavenode]'Yes, I am, but only for psychotherapy sessions, and the therapist is old enough to be my grandmother!' you reply."

	response for sarah-jealous-node when saying no:
	say "[leavenode]'No, of course not, you know you're the only woman in my life!' you protest."

	default response for sarah-jealous-node:
	say "'Don't try to change the subject!' she storms, 'I asked if you were seeing another woman. Well, are you? Yes or no!'"

Section: Node-Introduction Rules

Provided we use the built-in machinery for switching nodes ("[node another-node]", "[leavenode]" or setnode another-node), the first thing that happens when a convnode is switched is that we run the node-introduction rules for the new node (this is one reason the node-switching machinery waits till the end of the turn to switch nodes). This allows use to do anything we like at the start of the new node, but it's particularly intended for two purposes:

1.	If there are several ways into the node, or the current interlocutor wants to pose a question before the player has said anything, we can use a node-introduction rule to allow the current interlocutor to pose the question to which s/he wants the answer; e.g.:

	node-introduction for sarah-jealous-node:
	say "'Are you seeing another woman?' Sarah asks suspiciously."

2.	If it isn't obvious what might count as a valid answer to the NPC's question, we can use a node-introduction rule to prompt the player:

	node-introduction for sarah-jealous-node:
	say "(You could say yes or no)[paragraph break]".

Section: Node-Continuation Rules

If the current interlocutor is really determined to get an answer, s/he might not be content to simply stand around while the player examines everything in sight, takes inventory a couple of times, moves objects around and generally carries on as if the NPC wasn't there and hadn't just asked a question. We can use a node-continuation rule to have the NPC prompt the player for a reply:

	node-continuation for sarah-jealous-node:
 	if a random chance of 1 in 2 succeeds then
	say "'Hey! Didn't you hear me?' Sarah demands, 'I asked you if you were seeing another woman - well, are you?'"

Using a random chance is probably a good idea in a node-continuation rule to avoid the mechanical repetitiveness of having the NPC nag the player on every conversational turn. We can also avoid such repetitiveness, of course, by using the a "[one of]... [or]... [or]... [in random order]" type construction to vary what's said.

Note that a node-continuation rule is only used on non-conversational turns. Conversing sets the global variable conversed-this-turn to true, which tells the node continuation rule (an every turn rule) not to run the node-continuation rules.

Section: Node-Termination Rules

If an NPC is determined to get an answer, s/he may not appreciate it if the player attempts to evade the question by simply terminating the conversation, either by walking away or by saying goodbye. We can use node-termination rules to block such attempts, e.g.:

	node-termination for sarah-jealous-node when going:
	now conversed-this-turn is true;
	say "'Don't you walk away while I'm talking to you!' Sarah storms, 'I asked you a question: are you seeing another woman?'"

	node-termination for sarah-jealous-node when saying goodbye to Sarah:
	now conversed-this-turn is true;
	say "'Don't you 'goodbye' me!' Sarah snaps, 'Answer my question: are you seeing another woman?'"

Note the "now conversed-this-turn is true" statements. We include these to tell the node continuation rule that Sarah's already said something this turn, so we don't also want her to nag the player in a node-continuation rule.

The node-termination rules are checked in response to a movement command or a saying goodbye command. Note that the node-termination rulebook has a default failure outcome, so the very existence of a node-termination rule matching a condition suffices to block a going or saying goodbye action.

Chapter: NPC-Initiated Conversation

So far we have tacitly assumed that we reach a new convnode via an NPC's response to something said during an ongoing conversation, but it may be that we want an NPC to start a conversation, perhaps by asking a question. We can do this by using the phrase:

	Initiate a conversation with NPC at node whatever-node.

For example, we might write:

	After going to the Lounge for the first time:
	  initiate a conversation with Sarah at sarah-jealous-node;
	  continue the action.

This sets Sarah as the current interlocutor and schedules sarah-jealous-node as the node to be switched to at the end of this turn. This means that we can use "continue the action" here to have the going to action proceed to print out a room description, and then have Sarah's question (presumably provided by a node-introduction rule) displayed after the room description.

This works when the player character enters the presence of an NPC, but may not work so well when an NPC enters the presence of the player character and needs to initiate the conversation straight away. In this situation you may find that the conversation is being started on the turn after the one you want. If you come across this problem, you can add the phrase option 'immediately' to the 'Initiate a conversation' phrase to ensure that the conversation starts at the node you want right away, for example:

	At the time when Sarah enters:
	   move Sarah to the hall;
	   say "Sarah bursts into the hall.";
	   initiate a conversation with Sarah at sarah-jealous-node, immediately.

Example: * Sarah's Jealous Suspicions - Putting convnodes through their paces.

In this example we have two examples of closed convnodes and one open convnode. The first closed convnode is triggered when the player first enters the Lounge, and we need to use a node-introduction rule to pose the question Sarah wants an answer to. The second closed convnode is arrived at if and when the player admits to seeing a psychotherapist. By the time the node is reached, Sarah has just posed her question about the psychotherapist's name, so we can use the node-introduction rule just to tell the player the possible responses available at this point (note the way we use an "after reading a command rule" to change these responses into something the parser can recognize during this node). The third convnode (mary-node) is an open one, which means that the player could choose to ignore Sarah's question about Mary altogether.

	*:"Sarah's Jealous Suspicions"

	Part 1 - Setup and Map

	Include Conversation Nodes by Eric Eve.

	The Hall is a room. "Doors lead off in all directions from here, but the only important one is to the north, leading to the Lounge where Sarah is waiting for you."

	The Lounge is north of the Hall. "Although you've spent many cosy hours in here with Sarah, today the atmosphere feels decidedly chilly."

	Sarah is a woman in the lounge. "Sarah is standing in the middle of the Lounge, looking none too pleased with you."
	The description is "You wish she didn't look quite so suspicious of you."

	Part 2 - Sarah-Jealous-Node

	sarah-jealous-node is a closed convnode.

	After going to the Lounge for the first time:
	  initiate a conversation with Sarah at sarah-jealous-node;
	  continue the action.

	node-termination for sarah-jealous-node when going:
	now conversed-this-turn is true;
	say "'Don't you walk away while I'm talking to you!' Sarah storms, 'I asked you a question: are you seeing another woman?'"

	node-termination for sarah-jealous-node when saying goodbye to Sarah:
	now conversed-this-turn is true;
	say "'Don't you 'goodbye' me!' Sarah snaps, 'Answer my question: are you seeing another woman?'"

	response for sarah-jealous-node when saying yes:
	say "[node sarah-therapist-node]'Yes, I am, but only for psychotherapy sessions, and the therapist is old enough to be my grandmother!' you reply.[paragraph break]'Who is this woman?' she demands, 'What's her name?'"

	response for sarah-jealous-node when saying no:
	say "[leavenode]'No, of course not, you know you're the only woman in my life!' you protest.[paragraph break]'Very well,' she sighs, slightly mollified, 'Only Mary said - well, never mind, what Mary said.'"

	default response for sarah-jealous-node:
	say "'Don't try to change the subject!' she storms, 'I asked if you were seeing another woman. Well, are you? Yes or no!'"

	node-introduction for sarah-jealous-node:
	say "'Are you seeing another woman?' Sarah demands, wasting no time on pleasantries.[paragraph break](You could say yes or no)[paragraph break]"

	node-continuation for sarah-jealous-node:
	if a random chance of 1 in 2 succeeds,
	say "'Hey! Didn't you hear me?' Sarah demands, 'I asked you if you were seeing another woman - well, are you?'"

	Part 3 - Sarah-Therapist-Node

	sarah-therapist-node is an closed convnode.

	node-introduction for sarah-therapist-node:
 	say "(You could answer Jane, or refuse to say)[paragraph break]".

	response for sarah-therapist-node when answered that "jane":
	  say "[leavenode]Her name is Jane - Jane Smith,' you say.[paragraph break]'Jane Smith?' she queries, 'Well, I suppose I can always check that! But perhaps Mary did get it wrong...'"

	response for sarah-therapist-node when answered that "refuse":
	  say "'It's none of your business,' you reply, 'Why, don't you trust me?'[paragraph break]'I'm not sure,' she replies, 'I'd trust you more if you told me the name of this therapist; so, who is she? What's her name?'"

	Understand "refuse" or "refuse to answer" or "refuse to say" as "[refuse]"

	After reading a command when the current node is sarah-therapist-node:
	  if the player's command matches "[refuse]",  replace the player's command with "answer refuse to sarah";
	  if the player's command matches "jane", replace the player's command with "answer jane to sarah".

	Default answer response for sarah-therapist-node:
	  say "'You're lying,' Sarah says, 'Now tell me her real name.'"

	Default response for sarah-therapist-node:
	  say "'Don't keep trying to change the subject,' Sarah complains, 'I asked you the name of this ancient therapist; so, what is it?'"

	Part 4 - Mary

	Mary is a familiar woman.

	Response for Sarah when asked about Mary:
	  say "'[one of]So what's Mary been saying?' you want to know.[paragraph break]'Only that she's seen you with the same woman several times,' Sarah replies[or]Did Mary say anything about this woman she allegedly saw me with?' you want to know.[paragraph break]'Well, she didn't exactly describe her as being particularly grandmotherly, and Mary is normally pretty reliable, don't you think?' she replies[node mary-node][or]And when did Mary tell you all this?' you ask.[paragraph break]'A couple of days ago,' she shrugs[stopping]."
  
	Part 5 - Mary-Node

	mary-node is a convnode.

	Response for mary-node when saying yes:
say "'Yes, I suppose she is, but this time she must have got hold of the wrong end of the stick,' you remark.[paragraph break]'So you say,' Sarah replies."

	Response for mary-node when saying no:
say "'Evidently not, if that's what she's been telling you!' you declare.[paragraph break]'Well, I've always found her to be so,' Sarah replies."

	Part 6 - General Conversation

	Understand "weather" or "the weather" as "[weather]".

	Response for Sarah when asked-or-told about "[weather]":
	  say "'Lovely weather we're having,' you remark.[paragraph break]'They say it's going to get hotter tomorrow,' she replies darkly."

	Default response for Sarah:
	  say "She merely looks at you, as if to say, 'Shouldn't we talk about something else?'"
 
	Part 7 - Testing

	Test me with "n/t weather/x sarah/look/i/z/a sarah/bye/s/yes/refuse to say/say Virginia/say jane/a mary/a mary/no/a mary/t weather".

 




