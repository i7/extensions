Version 7 of Conversation Responses by Eric Eve begins here.
"Provides a meaning for defining responses to conversational commands (such as ASK FRED ABOUT GARDEN) as a series of rules."

Include Conversation Framework by Eric Eve.

Part 1 - Define Five New Rulebooks

The response rules are an object-based rulebook.
The response rules have default success.

The greeting response rules are an object-based rulebook.
The greeting response rules have default success.

The farewell response rules are an object-based rulebook.
The farewell response rules have default success.

The implicit greeting response rules are an object-based rulebook.
The implicit greeting response rules have default success.

The implicit farewell response rules are an object-based rulebook.
The implicit farewell response rules have default success.


Part 2 - Unlist some rules

The block saying yes rule is not listed in any rulebook.
The block saying no rule is not listed in any rulebook.
The block saying sorry rule is not listed in any rulebook.
The block showing rule is not listed in any rulebook.
The block giving rule is not listed in any rulebook.
The standard giving rule is not listed in any rulebook.
The standard report giving rule is not listed in any rulebook.

Part 3 - Some Useful Phrases

To decide whether asked about (obj - an object):
  if quizzing someone about something, decide on whether or not the obj is the second noun;
  decide no.

To decide whether asked about (objs - a description of objects):
    if quizzing someone about something, decide on whether or not the second noun is a member of objs;
   decide no.

To decide whether asked about (atopic - a topic):
  if asking someone about something,  decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether asked-or-told about (obj - an object):
  if quizzing someone about something or informing someone about something, decide on whether or not the obj is the second noun;
  decide no.

To decide whether asked or told about (objs - a description of objects):
    if quizzing someone about something or informing someone about something,
    decide on whether or not the second noun is a member of objs;
   decide no.

To decide whether asked-or-told about (atopic - a topic):
 if asking someone about something or telling someone about something, decide on whether or not the topic understood matches atopic;
 decide no.

To decide whether told about (obj - an object):
  if informing someone about something, decide on whether or not obj is the second noun;
  decide no.

To decide whether told about (objs - a description of objects):
    if informing someone about something, decide on whether or not the second noun is a member of objs;
   decide no.


To decide whether told about (atopic -  a topic):
  if telling someone about something, decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether answered that (atopic -  a topic):
  if answering someone that something, decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether asked for (obj - an object):
  if requesting someone for something, decide on whether or not the obj is the second noun;
  decide no.

To decide whether asked for (atopic - a topic):
  if imploring someone for something, decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether asked for (objs - a description of objects):
    if requesting someone for something, decide on whether or not the second noun is a member of objs;
   decide no.


To decide whether shown (obj - an object):
  if showing something to someone, decide on whether or not obj is the noun;
  decide no.

To decide whether shown (objs - a description of objects):
    if showing something to someone,  decide on whether or not the noun is a member of objs;
   decide no.


To decide whether given (obj - an object):
    if giving something to someone, decide on whether or not obj is the noun;
   decide no.

To decide whether given(objs - a description of objects):
    if giving something to someone,  decide on whether or not the noun is a member of objs;
   decide no.


To decide whether given-or-shown (obj - an object):
     if giving something to someone or showing something to someone, decide on whether or not obj is the noun;
   decide no.

To decide whether given-or-shown (objs - a description of objects):
    if giving something to someone or showing something to someone,
    decide on whether or not the noun is a member of objs;
   decide no.


To decide whether (X - an object) is a member of (D - description of objects): (-
({D})({X}) -).



Part 4 - Conversation Report Rules

This is the standard response rule:
   abide by the response rules for the current interlocutor.

The standard response rule is listed first in the report asking it about rules. 
The standard response rule is listed first in the report quizzing it about rules. 
The standard response rule is listed first in the report telling it about rules. 
The standard response rule is listed first in the report informing it about rules. 
The standard response rule is listed first in the report requesting it for rules. 
The standard response rule is listed first in the report imploring it for rules. 
The standard response rule is listed first in the report giving it to rules. 
The standard response rule is listed first in the report showing it to rules. 
The standard response rule is listed first in the report saying yes rules. 
The standard response rule is listed first in the report saying no rules. 
The standard response rule is listed first in the report saying sorry rules.
The standard response rule is listed first in the report answering it that rules.

The first report rule for saying goodbye to someone (this is the standard report farewell rule):
  if farewell type is implicit, abide by the implicit farewell response rules for the noun;
  abide by the farewell response rules for the noun.

The first report rule for saying hello to someone (this is the standard report greeting rule):
  if greeting type is implicit,  abide by the implicit greeting response rules for the noun;  
  abide by the greeting response rules for the noun.

Conversation Responses ends here.

---- DOCUMENTATION ----

Chapter: Various Responses

Conversation Responses allows response rules for various conversational commands to be written in the following forms:

	Response of Bob when asked about Bob:  
	Response of Bob when asked about "life":            
	Response of Bob when told about "[money]":
	Response of Bob when asked about a container:
	Response of Bob when asked about something fixed in place:
	Response of Bob when told about Jim:
	Response of Bob when shown the wallet:
	Response of Bob when given the wallet:
	Response of Bob when asked for the wallet:
	Response of Bob when asked for "sympathy":
	Response of Bob when anwered that "probably":
	Response of Bob when saying yes:
	Response of Bob when saying no:
	Response of Bob when saying sorry:

This may seem to have little advantage over writing rules like "After asking Bob about life", but it also allows the following forms for ask/tell or give/show:

	Response of Bob when asked-or-told about "life":
	Response of Bob when asked-or-told about the wallet:
	Response of Bob when given-or-shown the gold coin:

It also avoids using the After rulebook, since all these Response rules are triggered from the action-specific Report rules (which may be more efficient when there would otherwise need to be a lot of action-generic after rules to cater for a large number of conversational responses). 

But this extension only really comes into its own when combined into others (such as Conversational Defaults and Conversation Nodes), where using these Response rules helps ensures that the various rulebooks are consulted in the right order.

Chapter: Hello and Goodbye

This extension also provides special report rules for saying hello and goodbye to NPCs:

	Greeting response for Bob:
	Implicit greeting response for Bob:
	Farewell response for Bob:
	Implicit farewell response for Bob:

An implicit greeting is triggered if we address an NPC without explicitly saying hello. An implicit farewell is triggered is we walk away from an NPC in mid-conversation without first saying goodbye. In the former case the extension will use an Implicit Greeting Response if present, or a Greeting Response if no Implicit Greeting Response has been defined. Likewise if we walk away from the current interlocutor in mid-conversation, the extension will trigger an Implicit Farewell Response if one has been provided, but will otherwise fall back on the appropriate Farewell Response. If neither an Implicit Farewell Response nor a Farewell Response has been defined, then no kind of implicit farewell will be displayed (and likewise with an implicit greeting).


Example: * Bob's Lost Wallet - A brief conversation illustrating the use of response rules.

	*: "Bob's Lost Wallet"

	Include Conversation Responses by Eric Eve.

	The Hall is a Room. "As befits a grand old manor house, the hall is imposingly large, with acres of polished wooden floorboards and scores of ancient family portraits hung about the walls."

	Some ancient family portraits are scenery in the Hall.
	Understand "ancestors" as the ancient family portraits.

	Bob is a man in the Hall. "Bob is standing in the middle of the hall, looking rather worried."

	After saying hello to Bob:
	say "'Hello there, Bob!'[paragraph break]'Good morning,' he replies."

	Response of Bob when asked about Bob:
	say "'[one of]How are you today? You look worried!' you remark.[paragraph break]'I've lost my wallet,' he tells you[make lost wallet known][or]Are you okay - apart from your wallet?' you ask.[paragraph break]'Fine, but I'm so worried about my wallet!' he replies[stopping]."

	Response of Bob when asked about the lost wallet:
	say "'Where did you last see your wallet?' you ask.[paragraph break]'I can't remember,' he replies."

	Response of Bob when asked-or-told about "[theft]" and the lost wallet is known:
	say "'[one of]Could your wallet have been stolen, do you think?' you ask.[paragraph break]'I don't know,' he answers miserably[or]Have you tried telling the police?' you suggest.[paragraph break]'No, I'd feel such a fool if it just turned up,' he replies[stopping]."

	Response of Bob when saying sorry and the lost wallet is known:
	say "'Well, I'm sorry you can't find your wallet,' you say.[paragraph break]'So am I,' he tells you."

	Response of Bob when asked-or-told about the ancient family portraits:
	say "'[one of]Who are all those people in the portraits?' you ask.[paragraph break]'Oh, just my ancestors. I expect half of them were hung for sheep-stealing,' he replies[or]I don't think your ancestors look that disreputable,' you remark.[paragraph break][make lost wallet known]'Never mind my ancestors - it's my wallet I'm worried about!' he replies[stopping]."	

	Response of Bob when shown the silver dollar:
	say "'Is this any good to you?' you ask.[paragraph break]'One dollar?' he asks, 'Thanks, but no thanks. It's not the cash I'm so worried about, it's the credit cards!'"

	The silver dollar is carried by the player.

	The lost wallet is a thing. 

	Understand "bob's" or "his" as the lost wallet.
	
	Understand "theft" or "thief" or "stolen" or "police" as "[theft]".
	
	Test me with "Ask bob about himself/a bob/a wallet/a portraits/a ancestors/a theft/t police/show dollar"

