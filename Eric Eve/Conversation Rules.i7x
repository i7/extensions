Version 7 of Conversation Rules by Eric Eve begins here.

"A way of controlling conversations using rules and tables. Also implements topic suggestions and Conversation nodes. Requires Plurality by Emily Short and Conversation Framework, Epistemology and List Control by Eric Eve."

Book 1 - Includes

Include Version 4 of Conversation Framework by Eric Eve.
Include List Control by Eric Eve.

Book 2 - Conversation Model

Part 0 - Verbs

To point is a verb.

Part  1 - People and Tables

A person has a table-name called quizzing table.
A person has a table-name called informing table.

The quizzing table of a person is normally the Table of Null Response.
The informing table of a person is normally the Table of Null Response.

Table of Null Response
subject		response rule		response table (table-name)	suggest
yourself		default no response rule		--	0

A person has a rule called the unknown quizzing rule.
A person has a rule called the unknown informing rule.

The unknown quizzing rule of a person is normally the default no response rule.

The unknown informing rule of a person is normally the default no response rule.

This is the default no response rule:
  say "[There] [are] no response." (A).

Part 2 - Action Handling

Report quizzing someone about something known when the second noun is a subject listed in the quizzing table of the noun (this is the standard quizzing report rule):  
  if there is a suggest entry and the suggest entry is -1, continue the action;
  if there is a response rule entry, follow the response rule entry;
  if there is a response table entry, show the next response from the response table entry;
  if there is a suggest entry and the suggest entry > 0 begin;
    let sug be the suggest entry;
    decrease sug by 1;
    now the suggest entry is sug;
 end if;
 stop the action.
  

Report quizzing someone about something when the noun provides the property unknown quizzing rule (this is the default quizzing report rule):
  follow the unknown quizzing rule of the noun instead

[
A procedural rule when quizzing somebody about something:
  if the second noun is unknown or the second noun is not a subject listed in the quizzing table of the noun then ignore the greet a new interlocutor rule.
]

Report informing someone about something known when the second noun is a subject listed in the informing table of the noun (this is the standard informing report rule):  
  if there is a suggest entry and the suggest entry is -1, continue the action;
  if there is a response rule entry, follow the response rule entry;
  if there is a response table entry, show the next response from the response table entry;
  if there is a suggest entry and the suggest entry > 0 begin;
    let sug be the suggest entry;
    decrease sug by 1;
    now the suggest entry is sug;
 end if;
 stop the action.
  

Report informing someone about something when the noun provides the property unknown informing rule (this is the default informing report rule):
  follow the unknown informing rule of the noun instead.

Part  3 - Some useful shortcuts

To say reveal (item - a thing): now the item is familiar.

This is the quiz-inform rule:
  try informing the noun about the second noun instead.

This is the inform-quiz rule:
  try quizzing the noun about the second noun instead.

Part 4 - Suggesting Topics

Requesting suggested topics is an action out of world applying to nothing.

Understand "topics" as requesting suggested topics.

Check requesting suggested topics when the current interlocutor is not a person (this is the can't suggest if no interlocutor rule):
  say "[We] [aren't] conversing with anyone." (A) instead.

Report requesting suggested topics (this is the standard list suggested topics rule):
  let ask topics be the number of current suggestions in the quizzing table of the current interlocutor;
  let tell topics be the number of current suggestions in the informing table of the current interlocutor;
  if ask topics + tell topics is 0 and the suggestions of the current convnode is "blank", 
         say "[We] [have] nothing in mind to discuss with [the current interlocutor] just [now]." (A) instead;
  say "([We] [could] " (B);
  if the suggestions of the current convnode is not "blank" begin;
     say "[suggestions of the current convnode]" (C);
    if the current convnode is limited, say ".)" (D) instead;
    if ask topics + tell topics > 0, say ", or " (E);
  end if;
  if ask topics > 0  begin;
    say "ask [regarding the current interlocutor][them] about " (F);
    list the current suggestions in the quizzing table of the current interlocutor;   
    if tell topics > 0, say ", or " (G);
  end if;
  if tell topics > 0 begin;
    say "tell [regarding the current interlocutor][them] about " (H);
    list the current suggestions in the informing table of the current interlocutor;   
  end if;
  say ".)" (I).

To decide which number is the number of current suggestions in (tab - a table-name):
  let count be 0;
  repeat through tab begin;
    if the subject entry is known and there is a suggest entry and the suggest entry > 0,
        increase count by 1;
  end repeat;
  decide on count.

To list the current suggestions in (tab - a table-name):
  let count be the number of current suggestions in tab; 
  let suggested topics be 0;
  repeat through tab begin;
  if the subject entry is known and there is a suggest entry and the suggest entry > 0 begin;
       say "[the topic name of the subject entry]";
       increase suggested topics by 1; 
       if suggested topics is count - 1 begin;
            say " or "; 
       otherwise;
            if suggested topics < count, say ", ";
      end if;
    end if;
  end repeat.

To say the topic name of (item  - a thing):
  if the item is the current interlocutor,
      say "[regarding the current interlocutor][themselves]";   
  otherwise say "[the item]".
  

To set the quiz suggestions of (item - a thing) to (n - a number):
  if the current interlocutor is a person begin;
    if the item is a subject listed in the quizzing table of the current interlocutor,
        now the suggest entry is n;
  end if.

To set the inform suggestions of (item - a thing) to (n - a number):
  if the current interlocutor is a person begin;
    if the item is a subject listed in the informing table of the current interlocutor,
      now the suggest entry is n;
  end if.

To say quiz (item - a thing) to (n - a number):
  set the quiz suggestions of the item to n.

To say inform (item - a thing) to (n - a number):
  set the inform suggestions of the item to n.


Part  5 - Yes and No

[Dealing with YES and NO]

The block saying yes rule is not listed in any rulebook.
The block saying no rule is not listed in any rulebook.

Report saying yes when the current interlocutor is a person (this is the saying yes or no to someone rule):
  say "'[if saying yes]Yes[otherwise]No[end if],' [we] [say].

'But I didn't ask you anything,' [regarding the current interlocutor][they] [point] out." (A) instead.

The saying yes or no to someone rule is listed in the report saying no rules.


Part 6 - Conversation Nodes

A Conversation Node is a kind of thing. A Conversation Node has a rule called the node rule. The node rule of a Conversation Node is normally the do nothing rule.
A Conversation Node has a text called suggestions. The suggestions of a Conversation Node is usually "blank".
A Conversation Node can be either limited or unlimited. A Conversation Node is normally limited.

This is the do nothing rule: do nothing.

The current convnode is a Conversation Node that varies. The current convnode is the null-node.

The null-node is a Conversation Node.

Check asking it about when the current convnode is not the null-node (this is the try convnode when conversing rule):
   abide by the node rule of the current convnode.

The try convnode when conversing rule is listed in the check telling it about rules.
The try convnode when conversing rule is listed in the check quizzing it about rules.
The try convnode when conversing rule is listed in the check informing it about rules.
The try convnode when conversing rule is listed in the check asking it for rules.
The try convnode when conversing rule is listed in the check answering it that rules.


Check saying yes when the current interlocutor is a person (this is the try convnode when saying yes or no rule):
  if the current convnode is not the null-node,
  abide by the node rule of the current convnode;
     
The try convnode when saying yes or no rule is listed in the check saying no rules.

To say convnode (newnode - a Conversation Node):
  now the current convnode is newnode;
  if the suggestions of the current convnode is not "blank",
  follow the standard list suggested topics rule;


Xspcing is an action applying to nothing.

Check Xspcing when the current convnode is not the null-node (this is the Special Topic rule):
  abide by the node rule of the current convnode.


Book 3 - Additional Grammar


[We use primary and secondary as a further way to disambiguate similar objects in conversational contexts]

[This is an attempt to provide unnecessary disambiguation prompts when the same vocab may apply to a number of things.]

A thing can be primary or secondary. A thing is normally secondary.


Understand "ask [someone] about [any primary known thing]" as quizzing it about.
Understand "a [any primary known thing]" as implicit-quizzing.
Understand "ask about [any primary known thing]" as implicit-quizzing.
Understand "tell [someone] about [any primary known thing]" as informing it about.
Understand "t [any primary known thing]" as implicit-informing.



Conversation Rules ends here.

---- DOCUMENTATION ----

Chapter: THE BASICS

Conversation Rules builds on Conversation Framework, List Control and Epistemology (which it uses, and which therefore must be present for it to use) to provide a sophisticated (and fairly complex) means of handling conversations of the ASK/TELL type. It can also suggest to the player which topics are available to be asked about and told about. Finally, it allows the use of Conversation Nodes --  points in a conversation when the player can types responses outside the normal ask/tell paradigm in reply to a question or comment by the NPC. (If this all sounds a bit like the TADS 3 conversation system, there is a reason for that; I originally developed this extension in the course of porting part of a TADS 3 game to Inform 7).

The first point to bear in mind about Conversation Rules is that it supports asking and telling NPCs about things rather than topics; that is it uses the quizzing it about and informing it about actions defined in Conversation Framework (the documentation of which should also be consulted at this point if it is not already familiar), rather than the standard asking it about and telling it about actions that come with Inform 7. That doesn't mean that we can't use asking it about (a topic) and telling it about (a topic) with Conversation Rules; it's just that Conversation Rules provides no additional support for these actions. Instead, it provides support for quizzing and informing NPCs about things (which may include things or subjects -- for which see the Epistemology documentation -- used to represent abstract ideas like love, liberty or the rate of inflation). 

Within Conversation Rules each NPC's responses to being quizzed about or informed about something is controlled through a pair of tables we need to define for the purpose: the NPC's quizzing table and informing table. Thus we might define:

	Bob is a man. The quizzing table is The Table of Bob's Quizzes. The informing table is The Table of Bob's Informs.

We then need to supply these tables, which take the form:

	Table of Bob's Quizzes
	subject		response rule			response table	suggest
	bob		bob himself rule			--		1

This will cause the bob himself rule to be invoked in response to the command ASK BOB ABOUT BOB or ASK BOB ABOUT HIMSELF. It will also cause 'you could ask Bob about himself' to be suggested as a possible topic of conversation with Bob, until we had actually asked him about himself for the first time. If we didn't want this to appear as a suggested topic we could put a 0 in the suggest column (or leave it blank). If we wanted it to be suggested more than once, we would put the number of times Bob could be asked about himself before this ceased to be suggested in the suggest column.

Obviously, we also need to provide an appropriate bob himself rule, for example:

	This is the bob himself rule:
	  say "'How are you today, Bob?' you enquire.

	'Fine, just fine,' he replies."

If Bob's responses varied according to circumstances, we could write a more complex rule, or else use a rulebook to decide Bob's response:

	Table of Bob's Quizzes
	subject		response rule			response table	suggest
	Fred		bob fred rules			--		3


	The bob fred rules is a rulebook.

	A bob fred rule when fred is unseen:
              say "Who is Fred anyway?' you ask.

	 'He's my cousin,' Bob tells you."

	A bob fred rule when fred is seen:
	  say "'Fred looks quite ill, don't you think?' you remark.

	'Yes - he contracted Dutch Elm Disease last week,' Bob tells you."

A common situation is where we want an NPC to run through a list of responses, supplying a new one each time he is asked until the last is reached, or maybe supplying a random one drawn from a list of possible responses on each occasion. The extension List Control, which Conversation Rules uses, provides a mechanism for running through such a list, while Conversation Rule provides a means of getting the next response from such a list automatically, instead of of explicitly having to write a rule to do it. Just put the name of the table containing the list of responses in the appropriate response table column, e.g.:

	Table of Bob's Quizzes
	subject		response rule			response table		suggest
	bob		--				Table of Bob Himself	3


	Table of Bob Himself
	response
	"'How are you today?' you ask.

	'Fine, just fine,' he assures you."
	"'Are you sure you're all right, Bob?' you enquire, 'you look a bit off colour.'

	'I'm absolutely fine,' he insists."
	"Are you absolutely sure you're all right?' you ask.

	'How many times do I have to tell you?' he snaps, 'I'm completely all right!'"

	Table of Table Types (continued)
	tabname		index	tabtype
	Table of Bob Himself	0	stop-list

See the List Control documentation for an explanation of how the above two tables work. It is, by the way, perfectly legal to include both a rule and table name in the same row, in which case the rule will be executed before the next response from the table is shown. This may be useful if, say, we want quizzing someone about something to have a side effect in addition to the display of a conversational exchange.


Chapter:  DEFAULT RESPONSES

We next need a means of having our NPC respond to things we haven't explicitly provided for. Two rules are provided for this, the NPC's unknown quizzing rule and the NPC's unknown informing rule, which by default are set to the no response rule (which in turn simply says that there's no response). To customize this, we need to change these rules to something different; e.g.

	The unknown quizzing rule of Bob is the Bob no quiz rule. The unknown informing rule of Bob is the Bob no inform rule.

	This is the Bob no quiz rule: say "Bob scratches his head and looks puzzled by your question."

	This is the Bob no inform rule: say "Bob listens to what you have to say, but merely grunts in reply."

Of course, these rules could be more elaborate; we might, for example, want Bob's response to be a random response from a selection of defaults:

	This is the Bob no quiz rule: show the next response from the Table of Bob's Default Quiz Responses.

Obviously, we'd then need to define this table (again see the List Control documentation).


Chapter:  CONTROLLING RESPONSE ACCESSIBILITY 

A further sophistication is that Conversation Rules makes use of the Epistemology extension, which keeps track of which objects the player knows about. If the player asks an NPC about a thing the player character does not (yet) know about, the default response will be used even if a custom response has been supplied (in the relevant table) for that object. This prevents the player stumbling on something prematurely, or getting a response that presupposes something the player character does not know about (i.e. a thing which is still unfamiliar and unseen, as defined by the Epistemology extension). For example, suppose the PC doesn't know that Bob has a cousin called Fred until Bob mentions the fact in conversation; we could write:

	Table of Bob's Quizzes
	subject		response rule			response table		suggest
	bob		--				Table of Bob Himself	2
 	fred		bob-fred rule			--			1


	Table of Bob Himself
	response
	"'How are you today, Bob?' you ask.

	'Better than my cousin Fred, at any rate.' he mutters[reveal Fred]."
 	"'How are you doing?' you wonder.
	'Oh I'm doing fine, just fine,' he assures you."

	This is the bob-fred rule:
	  say "'What's the matter with your cousin Fred?' you ask.

	'He's suffering an acute attack of Dutch Elm Disease,' he tells you."

Now if we type ASK BOB ABOUT FRED before asking Bob about himself for the first time, we'll only get Bob's default response. The special tag "[reveal Fred]" changes Fred from unfamiliar to familiar (it's a to say rule that doesn't actually say anything), so that we can ask Bob (or anyone else) about Fred thereafter. Note that the 'To reveal X' rule is built into the Conversation Rules extension; it's not something we need to supply in our game code.

This mechanism is fine for stopping the player character talking about things that aren't yet known to him or her, but there may be other reasons why we want to make a response temoparily unreachable, e.g because the NPC doesn't know about it yet, or it doesn't make sense to talk about it with this particular NPC until something else has been said. One way to deal with this situation would be to test for the appropriate condition(s) in the relevant response rule, but this may not always be convenient, particularly if we are using a response table to provide the response. Another method we can use is to set the value in the suggest to -1, which makes the topic unavailable (and, of course, not suggested) until the suggest value is changed to something else. Just as we can use "[reveal Fred]" to change Fred to familiar, so we can use "[quiz x to n]" or "[inform x to n]" to change the suggest column corresponding to x to n in the quizzing table or informing table of the current interlocutor (the NPC we're current talking to). So, for example, if it's possible that the player character already knows of the existence of Fred, but we don't want him asking Bob about Fred until Bob has mentioned Fred, we could change the above example to:

	Table of Bob's Quizzes
	subject		response rule			response table		suggest
	bob		--				Table of Bob Himself	2
 	fred		bob-fred rule			--			-1


	Table of Bob Himself
	response
	"'How are you today, Bob?' you ask.

	'Better than my cousin Fred, at any rate.' he mutters[quiz Fred to 1]."
 	"'How are you doing?' you wonder.
	'Oh I'm doing fine, just fine,' he assures you."


Chapter: COMBINING ASK AND TELL

Sometimes we want ASK FOO ABOUT BAR to give the same response as TELL FOO ABOUT BAR. If this is always the case for every NPC we can simply write:

	Instead of informing someone about something, try quizzing the noun about the second noun.

We can do something similar if we want this to apply only to a particular NPC:

	Instead of informing Bob about something, try quizzing Bob about the second noun.

Sometimes, however, we may want ASK and TELL to be equivalent only for certain topics. We could cope for this by writing a series of Instead rules:

	Instead of informing Bob about Fred, try asking Bob about Fred.
	Instead of informing Bob about the lighthouse, try asking Bob about the lighthouse.

But this could become a bit tedious and long-winded if we have quite a few topics to redirect like this. An alternative is to use the supplied quiz-inform and inform-quiz rules within the apprropriate table to redirect quizzing to informing or informing to quizzing, e.g.:

	Table of Bob's Informs
	subject		response rule			response table		suggest
	fred		inform-quiz rule			a table-name		0
	lighthouse	inform-quiz rule

It may seem that we could simply have written "bob-fred rule" in the response column to get the same effect, since the same rule would be triggered whether we ASK BOB ABOUT FRED or TELL BOB ABOUT FRED. The problem is that we'd then have to worry about keeping the values in the suggest columns of both tables in sync, and this is a complication best avoided.


Chapter: CONVERSATION NODES

There may come a point in a conversation when an NPC asks a question or makes a statement to which ASK BOB ABOUT X or TELL BOB ABOUT X would be a clumsy response at best. It may be that a simple yes or no would be better, or it may be that a more elaborate reply is called for. For this type of situation we can use a Conversation Node. Suppose, for example, that Bob asks a question to which the possible answers are YES, NO and I DON'T KNOW. Perhaps the question was "Have you met my cousin Fred?", so we might call our conversation node the bob-fred node:

	The bob-fred node is a Conversation Node.

Next we need to have some means of letting the player know what responses are possible while we're in this node. For this purpose we can set the Conversation Node's suggestions property:

	The bob-fred node is a Conversation Node. The suggestions is "say yes or no, or say that you don't know"

The rule here is that the text in the suggestions property is something that can reasonably follow "You could". In the above example the player would see a prompt like "(You could say yes or no, or say that you don't know."). A further refinement is that a Conversation Node can be limited (the default) or unlimited. If the Conversation Node is limited then the suggestions in its suggestions property are the only suggested conversation topics that will be shown. If it is unlimited then all the other topics currently available for suggestion (i.e. all the quizzing and informing topics with a suggest entry greater than 0 in the appropriate table) will be listed too.

We still need a means for the Conversation Node to respond to the player's special response (in this case yes, no, or don't know). To do this we need to give the Conversation Node a node rule (which in practice will usually be a rulebook):

	The bob-fred-node rules is a rulebook.
	The node rule of the bob-fred node is the bob-fred-node rules.

Then we need to define the appropriate rules for handling the player's possible responses. We'll start by handling the straightforward YES and NO responses:

	A bob-fred-node rule when saying yes:
 	   say "'Yes, I ran into him the other day,' you say.

	   'In that case you know he's not very well.' Bob replies[convnode null-node].";
               rule suceeds.

	A bob-fred-node-rule when saying no:
	  say "'No, I didn't even know you had a cousin called Fred,' you reply.

	  'Unless he recovers soon, I probably won't for much longer,' he replies darkly[convnode null-node].";
	 rule suceeds.

These rules will handle YES or NO or BOB, YES or BOB, NO or SAY YES TO BOB or SAY NO TO BOB (since Conversation Framework, included by Conversation Rules) takes care of converting the other forms to YES and NO respectively). Note that we need to end each rule with "rule succeeds" to prevent fall through to the normal conversation processing (unless, of course, we want to allow this). Not also the "[convnode null-node]", which is used to reset the current conversation node to nothing once we are done with it (this will be explained further below).

Next, we may want a special rule to make Bob insist on an answer if we don't give him one:

	The last bob-fred-node rule:
	  say "'I asked you if you'd met my cousin Fred,' Bob reminds you.";
              rule succeeds.

Here we don't include "[convnode null-node]", since we want the current node to remain active when Bob doesn't get a satisfactory reply. If we were instead happy for Bob's question to be ignored (say by the player asking about something else) we'd instead write:

	The last bob-fred-node rule:
	  Change the current convnode to the null-node;

This resets the current convnode so that the bob-fred-node rule doesn't stay current once the player has ignored the question that triggered it; we also make sure that this rule doesn't succeed so that we can go on to the ordinary handling of the topic asked about.

This still leaves the question of how we respond to I DON'T KNOW. This is a bit trickier; the first part of the trick is to think of all the ways the player might signal I DON'T KNOW and then wrap them up in an Understand statement:

	Understand "you don't/dont know" or "i don't/dont know" or "don't know" or "dont know" as "[dont know]".

Next we have to make these responses understood as a special action, but only when this conversation node is active. A special wierdly-named Xspcing action (most unlikely to clash with anything else) is provided for the purpose. In this case we'd use it thus:

	Understand "[dont know]" as Xspcing when the current convnode is the bob-fred node.

Then we provide a bob-fred-node rule to respond to this input:

	A bob-fred-node rule when Xspcing:
	if the player's response matches "[dont know]" begin;
		say "[dont know fred].";
              	rule succeeds;
  	end if.

	A bob-fred-node rule when answering and the topic understood matches "[dont know]":
           	 	say "[dont know fred].";
             	 rule succeeds;

	To say dont know fred:
   	  say "'I have met someone called Fred, but I don't know whether he's your cousin,' you reply.
	  'He's a tall, thin, bald man with a limp,' Bob tells you, 'anyway -- he's also very sick[convnode null-node].'"

Note that in this case we need the 'when answering' rule to cover the possibility that the player types SAY I DON'T KNOW or the like.

Finally, we need some way to trigger the conversation node. At root, the way to activate a Conversation Node is to make it the current convnode, e.g.:

	Change the current convnode to the bob-fred node.

More normally, though, we'd use a "[convnode whatevernode]" tag inside a text string, e.g.:

	Table of Bob Himself
	response
	"'How are you today, Bob?' you ask.

	'Better than my cousin Fred, at any rate.' he mutters, 'Have you met him?'[quiz Fred to 1][convnode bob-fred node]"
 	"'How are you doing?' you wonder.
	'Oh I'm doing fine, just fine,' he assures you."

Not only does "[convnode whatevernode]" change the current convnode from within a text string, it also causes the topics associated with the node to be suggested so that the player can see what responses are available.


Chapter: SAYING YES AND NO

As mentioned above, Conversation Framework (included by Conversation Rules) takes care of directing the commands WHOEVER, YES and SAY YES TO WHOEVER to a simple YES command (and likewise with NO). In addition commands like FRED, YES or SAY YES TO FRED will trigger an implicit greeting of Fred (for which see the Conversation Framework documentation) if Fred is not already the current interlocutor (actually, most of the work for this is now carried oun by Conversation Framework).


Chapter: SUGGESTED TOPICS

As noted under section 1 above, Conversation Rules provides a mechanism for showing the player a list of things s/he can ask or tell the current interlocutor about. As already explained, this is managed by entering a number (greater than zero) in the suggest column against the appropriate item in the appropriate table. This number is reduced by one each time the subject is asked about (or told about, as the case may be) until it reaches zero. The number should therefore start at the number of times you want the suggestion to remain active.

Whether the suggestion appears as a suggested tell topic ("You could tell Bob about Fred") or a suggested ask topic ("You could ask Bob about Fred") depends on whether it appears in the NPC's informing table or its quizzing table (again, as described above).

By default, a list of suggested topics is displayed:

1) In response to an explicit TOPICS command typed by the player; and

2) When a Conversation Node is entered via a "[convnode whatevernode]" tag in a text string, and the Conversation Node in question has a suggestions property that is not "blank".

It may be that we would also like to see a list of suggested topics displayed in response to an explict greeting (such as TALK TO BOB, or BOB, HELLO). To do this we need to dd something like (assuming we have elsewhere defined a Table of Bob's Greetings):

	After saying hello to Bob:
	  show the next response from the Table of Bob's Greetings;
	  if the greeting type is explicit then consider the standard list suggested topics rule.

Note that in this case it is preferable to use 'consider the standard list suggested topics rule' rather than 'try requesting suggested topics', since if the latter is used the turn count will not be advance (requesting suggested topics is an action out of world, since it seems reasonable that it shouldn't consume any game time).


Chapter: DISAMBIGUATION AND PRIMARY SUBJECTS

Since quizzing about and informing about are actions that potentially apply to all objects defined in our game, there is a danger that trying to converse with someone about something may result in an ungainly disambiguation prompt:

>ASK JIM ABOUT BALL

Which do you mean, the red rubber ball, the ball gown, the masked ball or the ball bearing?

Conversation Rules takes care of this to some extent by preferring subjects that are known about to those that aren't in such contexts, which may help cut down the list (and avoid revealing the existence of something the player isn't meant to know about yet), but this may not be enough to avoid all instances of ungainly disambiguation, especially in the later stages of a game when most things are known about. Conversation Rules offers partial relief in the form of the primary/secondary condition applied to all objects. Other things being equal, Conversation Rules will pick a primary thing in preference to a secondary thing in a context such as this (provided the primary thing is known). So, for example, if we want all conversational references to BALL, not otherwise qualified, to refer to the masked ball, then we could define:

	The masked ball is a primary subject.

The problem is, the masked ball is then the primary meaning of 'ball' for all interlocutors in the game. If little Billy is more likely to be more interested in his red rubber ball, we should have to supply special grammar lines for this particular exception:

	Understand "ask [billy] about [red subber ball]" as quizzing it about.
	Understand "a [red rubber ball]" as quizzing it about when the default interlocutor is Billy.

But it could become quite cumbersome to do this for a lot of subject/interlocutor combinations.


Chapter:. OTHER FEATURES

Note that Conversation Rules is fully compatible with the greeting protocols defined in Conversation Framework (for which consult the Conversation Framework documentation). To take full advantage of this it may be necessary to write rules for saying hello and goodbye to particular NPCs in addition to the various types of conversation rule described above.

Conversation Rules is also compatible with the abbreviated conversation commands A THIS or T THAT implemented in Conversation Framework.


Example: ** The Tribune's Report - A Sample Conversation

Conversation Rules doesn't handle asking it about and telling it about, so we include rules in Part 1 to provide graceful handling for ASK ABOUT FOO and TELL ABOUT BAR where foo and bar don't correspond to any objects in the game. Other games may want to handle these commands differently, though this is quite a good default.


	*: "The Tribune's Report"

	Part  1 - Conversation Model

	Include Conversation Rules by Eric Eve.

	Instead of asking someone about something:
	  follow the unknown quizzing rule of the noun.

	Instead of telling someone about something:
	  follow the unknown informing rule of the noun.

	Part 2 - Scenario

	Chapter 1 - The Location

	The Great Hall is a Room. "The strong morning sunlight filters in through the unglazed windows overlooking the Upper City and the Temple compound."

	Some unglazed windows are scenery in the Great Hall.

	Chapter 2 - Pilate

	Section  1 - The Man

	Pontius Pilate is a man in the Great Hall. "The governor is standing at the centre of the hall, frowning in thought." The description is "He's a stout, balding man, dressed in the tunic of the equestrian order." The quizzing table is the Table of Pilate's Answers. The informing table is the Table of Pilate's Remarks. The unknown quizzing rule is the Pilate's default-quiz-response rule. The unknown informing rule is the Pilate's default-inform-response rule.

	Understand "man" or "governor" or "prefect" or "procurator" or "roman" or "stout" or "balding" as Pontius Pilate.

	Section 2 - Greeting

	After saying hello to Pontius Pilate:
	  say "'Good morning, your excellency,' you greet him.

	'I don't know what's good about it, tribune,' Pilate grunts in reply.";
	if the greeting type is explicit, follow the standard list suggested topics rule.

	Section 3 - Conversation Topics
	
	Table of Pilate's Answers
	subject		response rule			response table		suggest
	Pilate		--					Table of Pilate Self	3	
	Caiaphas	caiaphas rule				--			1
	jerusalem	jerusalem rule			--			1
	emperor		--					Table of Caesar		-1

	Table of Pilate's Remarks
	subject		response rule			response table		suggest
	jesus		--					Table of Jesus		2

	Table of Pilate Self
	response
	"'How are you today, sir?' you enquire politely.

	'Terrible,' he grunts. 'I slept badly, dreamed nastily, and woke up with a mouth tasting like a whore's armpit.'"
	"'Do you like it in Judaea?' you ask.

	'Caesarea's okay,' he replies, 'but Jerusalem is too hot, too crowded, and too dangerous[reveal jerusalem].'"
	"'But things aren't going too badly for you here, are they sir?' you ask.

	'No, not too badly,' he agrees. 'At least I still seem to be in favour with the Emperor[quiz emperor to 2].'"

	This is the caiaphas rule:
	  say "'How is the High Priest these days?' you ask.

	'As devious as ever,' Pilate tells you."

	This is the jerusalem rule:
	  say "'What did you mean by Jerusalem being too dangerous?' you wonder. 'Surely there's nothing our two cohorts of auxiliaries can't deal with?'

	Pilate lets out a heavy sigh. 'Nothing except a crowd of volatile Jews celebrating their Passover -- with all the undercurrents for revolutionary sentiment that implies.'"

	Table of Jesus
	response
	"'I've just come from the Temple, sir,' you report, 'there was some scruffy Galilean called Jesus causing a disturbance there. The priests seemed quite upset by it all!'

	'Did you arrest this Jesus fellow then?' Pilate demands.[convnode arrest-node][run paragraph on]"
	"'This Jesus fellow seems to be some sort of prophet,' you tell him.

	'Prophet!' Pilate almost spits the word. 'They're almost as bad as brigands round here, tribune, you mark my words! Charlatans the lot of them -- whipping up the people with false hopes of liberation. If this Jesus fellow is a prophet we should have him executed -- a crucifixion or two at the height of the festival should show these Jews who's in charge round here!'"

	Table of Caesar
	response
	"'How is the Emperor?' you enquire, 'Is he still on Capri?'

	'Last I heard,' Pilate nods."
	"'And the Emperor's health?' you ask.

	Pilate gives a little shudder, 'It is not always healthy to discuss Caesar's health, tribune,' he warns you."

	This is the Pilate's default-quiz-response rule:
	  show the next response from the Table of Pilate's Default Quiz Responses.

	This is the Pilate's default-inform-response rule: 
	  show the next response from the Table of Pilate's Default Inform Responses.
	
	Table of Pilate's Default Quiz Responses
	response
	"The governor seems momentarily lost in thought, and apparently fails to hear your question."
	"'We'll discuss that some other time, tribune,' Pilate tells you."
	"The prefect mutters something under his breath, which you fail to catch."
	"Pilate looks annoyed by your question, for some reason, and declines to answer."

	Table of Pilate's Default Inform Responses
	responses
	"Pilate listens to what you have to say with feigned interest."
	"'Indeed,' the governor remarks."
	"Pilate frowns in evident impatience at your irrelevant remarks."

	Table of Table Types (continued)
	tabname				index	tabtype
	Table of Pilate Self			0	stop-list
	Table of Jesus				0	stop-list
	Table of Pilate's Default Quiz Responses	0	shuffled-list
	Table of Pilate's Default Inform Responses	0	shuffled-list
	Table of Caesar				0	stop-list
	
	Section 4 - Objects referred to

	Caiaphas is a familiar man.
	Understand "high" or "priest" as Caiaphas.

	Jesus is a familiar man. Understand "of nazareth" or "galilean" or "joshua" or "yeshua" as Jesus.

	Jerusalem is a subject.

	The Emperor is a familiar man. Understand "caesar" or "tiberius" or "princeps" as the Emperor.
	
	Section 5 - Conversation Node

	The arrest rules is a rulebook.

	The arrest-node is a Conversation Node. The suggestions are "say yes or no". The node rule is the arrest rules.

	An arrest rule when saying no:
	  say "'No, sir, I'm afraid he managed to slip away,' you confess.

	'Damn!' Pilate swears, 'We'll have to see if Caiaphas can track him down for us.'[convnode null-node]";
	rule succeeds.

	An arrest rule when saying yes:
	  say "'Yes, sir -- or at least we tried to, but the temple police got in our way and the wretched fellow managed to escape.'

	'Damn!' Pilate swears. 'We'll have to see if Caiaphas can track him down for us.'[convnode null-node]";
	rule succeeds.

	The last arrest rule:
	  say "'Never mind that,' snaps Pilate. 'I asked you whether you arrested this Jesus fellow. Well -- did you?'";
	  rule succeeds.

	Part  3 - Testing

	test me with "talk to pilate/a emperor/a himself/g/a jerusalem/topics/t jesus/no/a caiaphas/a pilate/a emperor/g/topics/t jesus"





