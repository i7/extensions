Version 3 of Conversation Package by Eric Eve begins here.
"This extension includes both Conversation Nodes and Conversation Suggestions, and makes the suggestions aware of conversation nodes. It therefore includes the complete conversational system in one package. It also requires Conversation Responses, Conversational Defaults, Conversation Framework and Epistemology. The documentation for this extension give some guidance on how these other extensions can be mixed and matched."

Part 1 - Include Conv Nodes &  Suggestions

Include Conversation Nodes by Eric Eve.
Include Conversation Suggestions by Eric Eve.

Part 2 - Modifications to Conv Nodes

A convnode has a list of objects called ask-suggestions.
A convnode has a list of objects called tell-suggestions.
A convnode has a list of objects called other-suggestions.
A convnode can be auto-suggesting. 
A convnode is usually not auto-suggesting.
A closed convnode is usually auto-suggesting.

Part 3 - New Rules for Conv Nodes

To decide which object is the appropriate-suggestion-database:
  if the current node is closed, decide on the current node;
  decide on the current interlocutor.

A suggestion list construction rule when the current node is not the null-node and the current node is open (this is the add the current node's suggestion lists rule):
  add the other-suggestions of the current node to sugg-list-other, if absent;
  add the ask-suggestions of the current node to sugg-list-ask, if absent;
  add the tell-suggestions of the current node to sugg-list-tell, if absent.

This is the use a closed node's suggestion lists rule:
  now sugg-list-other is the other-suggestions of the current node;
  now sugg-list-ask is the ask-suggestions of the current node;
  now sugg-list-tell is the tell-suggestions of the current node.

The use the current interlocutor's suggestion lists rule is not listed in the suggestion list construction rules.

The first suggestion list construction rule (this is the use the appropriate suggestion lists rule):
   if the current node is not the null-node and the current node is closed, follow use a closed node's suggestion lists rule;
   otherwise follow the use the current interlocutor's suggestion lists rule;

A node-introduction rule for a closed convnode when the current node is auto-suggesting (this is the show node suggestions rule):
   Show the topic suggestions implicitly.

The show node suggestions rule is listed last in the node-introduction rules.

Conversation Package ends here.

---- DOCUMENTATION ----

Chapter: Introduction and Overview

Conversation Package is the most inclusive of the series of conversational extensions based on the Conversation Framework extension. It provides support for asking and telling about things as well as topics, for coding a variety of default responses to conversational commands, for suggesting worthwhile topics of conversation to the player, and for organizing particular points in conversational exchanges as conversation "nodes". If you don't need all this functionality, you might want to consider using one (or more) of the other conversation extensions.

Conversation Package includes both Conversation Nodes and Conversation Suggestions, combining their functionality. It also extends the functionality of Conversation Suggestions into nodes. In particular, lists of ask-suggestions, tell-suggestions and other-suggestions can be attached to nodes as well as people.

See the documentation of Conversation Nodes and Conversation Suggestions for a full explanation of what they do and how they work, and the chapter on The Constituent Extensions below for details of the other extensions included in this one, what they do, and how they can be used together.

Chapter: Using Suggestions with Conversation Nodes

Section: Suggestion Lists on Convnodes

The Conversation Suggestions extension allows us to associate topic suggestions with particular NPCs. These topic suggestions are lists of things the player can ask or tell the current interlocutor about. Conversation Package extends this functionality so that we can also associate lists of topic suggestions with convnodes. In particular it adds the follwing properties to convnode (which Conversation Suggestions adds to people):

	ask-suggestions
	tell-suggestions
	other-suggestions

Each of these (if used) should contain a list of objects. The first two should contain a list of things the player can ask or tell the NPC about when the convnode in question is active. The other-suggestions should include a list of misc-suggestion objects. The printed names of these misc-suggestion objects should display the text of any conversational commands (other than ask or tell) you want to suggest the player might usefully use while this convnode is active (e.g. "say yes or no" or "answer Fred"). This can be particularly useful when the NPC has just posed a question and you want the player to know the range of possible answers.

The following common misc-suggestions are already defined:

	yes-suggestion
	no-suggestion
	yes-no-suggestion

When a TOPICS command is issued (or is triggered implicitly), what happens will depend on whether the current convnode is open or closed (for the meaning of these terms, see the Conversation Nodes documentation). If the current convnode is open, its suggestion lists will be added to those of the current interlocutor and the joint list displayed (since an open node doesn't prevent access to the NPC's non-nodal conversation topics). If the convnode is closed, however, then only the suggestions belonging to that convnode will be displayed (since any topics outside the closed convnode won't be accessible until we leave the node). For example, if an NPC has just asked a question to which she's demanded a yes or no answer, then there's no point in displaying any other conversation suggestions beyond "You could say yes or no."

Section: Adding and Removing Suggestions

The conversational topics we want to suggest to a player will generally change during the course of play. The Conversation Suggestions extension defines a number of to say phrases (designed to be used in the text of conversational responses) which can add or remove suggestions, for example:

	"[add gold ring ask auggestion]"
	"[remove john doe tell suggestion]"

These continue to work as in Conversation Suggestions, except when they are used when the current convnode is closed. If used within a closed convnode, they will add or remove the suggestions from that convnode's suggestion lists instead of the actor's suggestion lists.

Section: Auto-Suggesting Convnodes

This extension adds one further property to convnode, auto-suggesting. Closed convnodes are usually auto-suggesting, while open convnodes are not.

When a convnode is first activated (i.e., when we first switch to it in the course of conversation), its node-introduction rules are run. This extension adds a new node-introduction rule that displays that convnode's suggestions when an auto-suggesting convnode is activated.



Chapter: The Constituent Extensions

Section: List of Conversation Extension Family Members

Conversation Package (directly or indirectly) includes every other extension in this family of conversation extensions:

	Conversation Nodes
	Conversation Suggestions
	Conversational Defaults
	Conversation Responses
	Conversation Framework
	Epistemology

The older extension, Conversation Rules, does not belong to this family (although it is also based on Conversation Framework, which requires Epistemology).

Section: How the Conversation Family is Related

The relation between these extensions (which directly includes, and hence requires, which) are as follows:

	Conversation Framework includes Epistemology
	Conversation Responses includes Conversation Framework	
	Conversation Suggestions includes Conversation Framework
	Conversational Defaults includes Conversation Framework
	Conversation Nodes includes Conversational Defaults and Conversation Responses
	Conversation Package includes Conversation Nodes and Conversation Suggestions

Section: Which Can be Used with Which

The main reason for dividing these Conversation extensions up like this is so that game authors can mix and match those pieces of this conversation system they want, while not being saddled with the parts they don't need. Any of these extensions can usefully be included in a game by itself, but the following combinations may also be useful:

	Conversation Responses + Conversation Suggestions
	Conversation Responses + Conversational Defaults
	Conversational Defaults + Conversation Suggestions
	Conversational Defaults + Conversation Suggestions + Conversation Responses

(It might just be useful to combine Conversation Nodes + Conversation Suggestions, but it's probably better to use Conversation Package, which includes a few extra pieces of code to help the two work together).

Conversation Framework is also the basis of Conversation Rules, which provides similar functionality to this set of extensions but in a different way. This newer set of extensions is designed to be easier to use than Conversation Rules.

Section: Which Does Which

Conversation Framework extends the grammar for ASK X ABOUT Y, ASK X FOR Y and TELL X ABOUT Y so that for all three commands Y can be either a thing or a topic. It also provides greeting protocols (saying hello and goodbye), and allows abbreviated forms of conversational commands (A Y, ASK FOR Y, T Y) once conversation is under way. It also converts the various ways of saying yes, no and sorry (e.g. BOB, YES or ANSWER YES TO BOB) to saying yes, saying no, or saying sorry. Finally, the global variable current interlocutor is defined to be the actor the player is currently conversing with.

Conversation Responses provides a set of rulebooks for facilitating the writing of conversational responses; for example "Response of Bob when asked about Sally". It's particularly useful for defining responses for more than one command, e.g. "Response of Bob when asked-or-told about Sally" defines a common response to ASK BOB ABOUT SALLY and TELL BOB ABOUT SALLY.

Conversational Defaults provides a set of ruleboooks for handling default responses, i.e. the responses NPCs make to topics we have not explicitly allowed for.

Conversation Suggestions provides a mechanism for suggesting which topics of conversation it may be worth the player's while to pursue, e.g. "You could ask her about Bob, the gold ring or the wet cabbage; or you could tell her about Napoleon, the stale bread, or yourself." It also provides a TOPICS command for listing these suggestions.

Conversation Nodes provides a means of structuring conversations via points in the conversation ('nodes') when a particular set of responses become relevant (e.g. answering yes or no to a question an NPC has just asked).

Conversation Package includes all the others, and adds code to make Conversation Nodes work well with Conversation Suggestions.

Example: * Consultation - A nodal conversation complete with suggestions, not that they help too much with this doctor! 

	*: "Consultation"

	Part 1 - Setup

	Include Conversation Package by Eric Eve.

	To say /p: say paragraph break.
	To say /l: say line break.

	your symptoms are a familiar thing.
	the weather is a familiar thing.
	advice-suggestion is a misc-suggestion. 
	The printed name is "ask him for advice".

	Part 2 - Scenario

	The Doctor's Surgery is a room.

	Doctor Kilpatient is a man in the Surgery. "Doctor Kilpatient is sitting behind his desk, looking at you with the air of a man whose lifetime practice of misanthropy is nearing the reward of ultimate perfection."
	Understand "dr" as Doctor Kilpatient.
	The node of Doctor Kilpatient is doctor-node.
	The ask-suggestions are{ self-suggestion, the weather }.
	The tell-suggestions are { your symptoms }.
	The other-suggestions are { advice-suggestion }.

	Part 3 - Conversation

	Chapter 1 - Node-Specific Responses

	doctor-node is a closed convnode.
	  the tell-suggestions are { yourself }.

	Response for doctor-node when told about yourself:	
	  say "[node ill-node]'I'm not feeling too good, doctor,' you say. [/p]'So what's the matter?' he asks, 'are you ill?' [/l]"

	Default response for doctor-node:
	  say "[node ill-node]'I'm a busy man, so let's get to the point. Are you ill?' the doctor demands."

	ill-node is a closed convnode.
	The other-suggestions of ill-node are { yes-no-suggestion }.
	The tell-suggestions of ill-node are { your symptoms }.

	Response for ill-node when saying yes:
	  say "[node symptom-node]'Yes, that's why I'm here, doctor,' you tell him. [/p]'So what exactly is the matter?' the doctor wants to know."

	Response for ill-node when saying no:
	  say "'No, I just...' you begin. [/p]'Then kindly don't waste my time.' the doctor snaps, 'Goodbye!'";
	  end the story finally saying "You have been shown the door".

	Response for ill-node when told about your symptoms:
	  say "[remove your symptoms tell suggestion]'Let's take this one step at a time,' he interrupts you, 'Now tell me, are you ill or not, yes or no?'"

	Default response for ill-node:
	 say "'Come now, I asked you a simple enough question,' he replies, 'Are you ill, yes or no?'"

	Node-continuation rule for ill-node:
	  if a random chance of 1 in 2 succeeds, say "'I haven't got all day,' Dr Kilpatient complains, 'So I'd appreciate it if you would answer my question: are you ill?'"

	symptom-node is a closed convnode.
	The tell-suggestions are { your symptoms }.

	Response for symptom-node when told about your symptoms:
	  say "'Well, doctor, I've got this terrible headache, my back's killing me, I'm having trouble walking, and I've got this strange lump on my arm,' you say. [/p][node help-node]'Don't worry,' he replies, 'You'll be dead within the week, and then it won't hurt any more. Now, is there anything else I can help you with?' [/l]"

	Default response for symptom-node:
	 say "'No, no, no, don't try to change the subject, just tell me your symptoms!' he interrupts you."

	help-node is a convnode.
	the other-suggestions of help-node are { yes-no-suggestion }.

	response for help-node when saying no:
	 say "'No, I think you've been quite helpful enough, doctor,' you reply. [/p]'I do my best,' he replies dryly."

	response for help-node when saying yes:
	 say "'Well, yes, I was hoping for something a bit more positive,' you reply. [/p]'I'm not in the business of hope,' he snorts. [/l]"

	Chapter 2 - General Responses

	response for kilpatient when asked for "advice":
	 say "[remove advice-suggestion other suggestion]'Can't you give me any advice about how to dull the pain - or stay alive - or anything useful like that?' you ask. [/p]'Pain is good for the soul. So is death. Count yourself fortunate,' he replies. [/l]"

	response for kilpatient when asked about kilpatient:
 	 say "[remove self-suggestion ask suggestion]'Are you always this sympathetic with your patients?' you ask. [/p]'I try not to be,' he assures you. [/l]"

	response for kilpatient when asked-or-told about the weather:
	 say "[remove weather ask suggestion]'It's quite cold for the time of year; could the weather be affecting my health?' you ask. [/p]'Possibly,' he replies. [/l]"

	response for kilpatient when told about your symptoms:
	 say "[remove your symptoms tell suggestion]'Let me tell you about my other symptoms,' you begin. [/p]'Please don't,' he interrupts, 'I'm sure they're very boring; you just aren't a medically interesting case.' [/l]".

	Part 4 - Testing

	Test me with "talk to doctor/t yourself/t symptoms/topics/yes/t yourself/t symptoms/topics/yes/topics/ask for advice/a weather/t symptoms/a himself/topics"
