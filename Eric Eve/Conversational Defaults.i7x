Version 3 of Conversational Defaults by Eric Eve begins here.
"Provides a set of rules to facilitate defining default conversational responses for different conversational commands targeted at various NPCs. This extension requires Conversation Framework."

Book 1 - Includes

Include Conversation Framework by Eric Eve.

Book 2 - Rules

Part 1 - The Response Rule Books

The default ask response rules are an object-based rulebook.
The default ask response rules have default success. 

The default ask-tell response rules are an object-based rulebook.
The default ask-tell response rules have default success.

The default tell response rules are an object-based rulebook.
The default tell response rules have default success.

The default answer response rules are an object-based rulebook.
The default answer response rules have default success.

The default ask-for response rules are an object-based rulebook.
The default ask-for response rules have default success.

The default give response rules are an object-based rulebook.
The default give response rules have default success.

The default show response rules are an object-based rulebook.
The default show response rules have default success.

The default give-show response rules are an object-based rulebook.
The default give-show response rules have default success.

The default yes-no response rules are an object-based rulebook.
The default yes-no response rules have default success.

The default response rules are an object-based rulebook.
The default response rules have default success.


Part 2 - Rules to Relate the Rulebooks


The last default response rule (this is the unresponsive rule): 
 say "[The current interlocutor] [do not] respond." (A).

Last default answer response rule for a thing (called the responder)  (this is the try default tell response rule):
  abide by the default tell response rules for the responder.

Last default ask response rule for a thing (called the responder) (this is the try default ask-tell response rule):
  abide by the default ask-tell response rules for the responder.


The try default ask-tell response rule is listed last in the default tell response rules.

The last default give response rule for a thing (called the responder) (this is the try default give-show response rule):
  abide by the default give-show response rules for the responder.

The try default give-show response rule is listed last in the default show response rules.
 

The last default ask-tell response rule for a thing (called the responder) (this is the try default response rule):
  abide by the default response rules for the responder.  

The try default response rule is listed last in the default give-show response rules.
The try default response rule is listed last in the default ask-for response rules.
The try default response rule is listed last in the default yes-no response rules.


Part 3 - Report Rules to Use the Rulebooks

Report asking someone about something  (this is the default asking rule):
  abide by the default ask response rules for the noun.

Report quizzing someone about something (this is the default quizzing rule):
  abide by the default ask response rules for the noun.

Report telling someone about something (this is the default telling rule):
  abide by the default tell response rules for the noun.

Report informing someone about something (this is the default informing rule):
  abide by the default tell response rules for the noun.

Report answering someone that something (this is the default answering rule):
  abide by the default answer response rules for the noun.

Report giving something to someone (this is the default giving rule):
  abide by the default give response rules for the second noun.

Report showing something to someone (this is the default showing rule):
  abide by the default show response rules for the second noun.

Report requesting someone for something (this is the default requesting rule):
  abide by the default ask-for response rules for the noun.

Report imploring someone for something (this is the default imploring rule):
 abide by the default ask-for response rules for the noun.

Report saying yes (this is the default yes rule):
  abide by the default yes-no response rules for the current interlocutor.

Report saying no (this is the default no rule):
  abide by the default yes-no response rules for the current interlocutor.

Report saying sorry (this is the default sorry rule):
  abide by the default response rules for the current interlocutor.

Part 4 - Removing Some Existing Rules

The block asking rule is not listed in any rulebook.
The block telling rule is not listed in any rulebook.
The block quizzing rule is not listed in any rulebook.
The block informing rule is not listed in any rulebook.
The block answering rule is not listed in any rulebook.
The block showing rule is not listed in any rulebook.
The block giving rule is not listed in any rulebook.
The block saying yes rule is not listed in any rulebook.
The block saying no rule is not listed in any rulebook.
The block saying sorry rule is not listed in any rulebook.

Conversational Defaults ends here.

---- DOCUMENTATION ----

However assiduous we are in providing conversational responses for things the player may try to tell or ask our NPCs about, we cannot possibly cover them all. Even if one of our NPCs is a banker, it's unlikely that we'll have provided responses to ASK BANKER ABOUT NORTHEN ROCK and ASK BANKER ABOUT LATEST INTEREST RATE CUT and ASK BANKER ABOUT DETAILS OF INTERNET SAVINGS ACCOUNTS. In such cases we need to provide default responses, responses which in practice mean "I have not be programmed to respond to that input" without making our NPCs look too robotic. This extension defines a number of rules and rulebooks to ease the process of defining such default responses. These enable us to write rules of the form:

	default ask response for the banker: 	
	default answer response for the banker:	
	default tell response for the banker:	
	default ask-tell response for the banker:	
	
	defaullt give response for the banker:	
	default show response for the banker:	
	default give-show response for the banker: 

	default ask-for response for the banker:	
	default yes-no response for the banker:	

	default response for the banker:		

Note that there's a hierarchy here. If we define a default ask response and a default tell response for the banker, we don't need a default ask-tell response since it would then never be reached. Either we define separate a default ask response and default tell response (if we want to handle them differently) or we define a default ask-tell response if we want to use the same default response whether the player typed ASK or TELL. Similarly, we can define separate default give and default show responses for an NPC if we want to handle them differently, or a single default give-show response to handle both GIVE and SHOW.

A slightly subtler point: if we don't define a default answer response for an NPC, a command like ANSWER BANKER THAT FOO  or SAY FOO TO BANKER, will first be handled by our default tell response rule (if we've defined one), or failing that by our default ask-tell response rule (if we've defined one), or failing that by a default response rule.

The default response rule is a catch-all for all the other cases we haven't explicitly defined. If we liked, we could just define a single "default response for banker" rule that handled all conversational commands addressed to the banker for which we haven't defined particular responses.

Note also that these rules effectively kick in at the report stage. This allows us to define our particular responses at the after stage, e.g.:

	after asking banker about "savings accounts":
	  "'We offer a very attractive range of savings accounts,' he assures you, 'indeed, we boast the highest interest rates of any bank in the country. Of course, you understand that [italic type]we[roman type] charge [italic type]you[roman type] the interest for looking after your money.'"

	after quizzing banker about Pluto Crat:
	"'You know very well I can't discuss my other clients with you,' he replies sternly, 'bankers have a rigorous code of ethics, you know.'"

	default ask response for the banker:
	"'[one of]This really isn't the best time to discuss that[or]I'd rather not talk about that right now[or]You'll need to make another appointment to discuss that[or]I hardly think that's an appropriate question to ask your bank manager[in random order],' he replies."

An alternative would be to use Conversational Defaults alongside Conversation Responses. Then instead of the above we could write:

	response of banker when asked about "savings accounts":
	  "'We offer a very attractive range of savings accounts,' he assures you, 'indeed, we boast the highest interest rates of any bank in the country. Of course, you understand that [italic type]we[roman type] charge [italic type]you[roman type] the interest for looking after your money.'"

	response of banker when asked about Pluto Crat:
	"'You know very well I can't discuss my other clients with you,' he replies sternly, 'bankers have a rigorous code of ethics, you know.'"

	default ask response for the banker:
	"'[one of]This really isn't the best time to discuss that[or]I'd rather not talk about that right now[or]You'll need to make another appointment to discuss that[or]I hardly think that's an appropriate question to ask your bank manager[in random order],' he replies."

The two examples illustrate these two methods further.

One other thing to note: our default answer response for the banker would be reached whenever the player enters the command ASK BANKER ABOUT FOO, when we haven't implemented a response for foo, whether the parser matches "ASK BANKER ABOUT FOO" to the asking it about action or the quizzing it about action. Similarly a default tell response is triggered whether we TELL BANKER ABOUT THING or TELL BANKER ABOUT "TOPIC", and a default ask-for response whether we ASK BANKER FOR THING or ASK BANKER FOR "TOPIC".

Example: * Sisko's Briefing - A brief conversation with defaults.

	*: "Sisko's Briefing"

	Include Conversational Defaults by Eric Eve.

	Captain Sisko's Office is a Room.
	"Behind the desk a pair of large windows overlook the stars that seem to surround the wormhole."

	The large desk is a scenery supporter in Captain Sisko's Office.
		
	Benjamin Sisko is a man in Captain Sisko's Office. "Captain Sisko is seated behind his desk."
	Understand "ben" or "captain" as Benjamin Sisko.

	After quizzing Sisko about the dominion war:
	say "'It's not going as well as I'd like; we're taking far too many casualties,' he tells you."

	After quizzing Sisko about Gul Dukat:
	say "'He's a very evil man,' Sisko opines."

	After quizzing Sisko about Sisko:
	say "'I am quite well, thank you,' he assures you."

	After informing Sisko about Quark:
	say "'Up to his usual tricks, no doubt,' he nods."

	default ask-tell response for Sisko:
	say "'Let's talk about that some other time,' he suggests."

	default ask-for response for Sisko:
	say "'I'm afraid I can't help you with that just now,' he tells you."

	default yes-no response for Sisko:
	say "'I wasn't aware I had just asked you something,' Sisko remarks."
	
	The dominion war is a familiar thing.
	Gul Dukat is a familiar man.
	Quark is a familiar man.
	
	Test me with "a sisko/a war/a quark/t quark/ask for promotion/a dukat/a bashir/t dax"


Example: * Sisko's Extended Briefing - A longer version of the first example, using the Conversation Responses extension as well.

	*: "Sisko's Extended Briefing"

	Include Conversation Responses by Eric Eve.
	Include Conversational Defaults by Eric Eve.

	Captain Sisko's Office is a Room.
	"Behind the desk a pair of large windows overlook the stars that seem to surround the wormhole."

	The large desk is a scenery supporter in Captain Sisko's Office.
	A ball is on the large desk.
		
	Benjamin Sisko is a man in Captain Sisko's Office. "Captain Sisko is seated behind his desk."
	Understand "ben" or "captain" as Benjamin Sisko.

	response of Sisko when asked about the dominion war:
	say "'It's not going as well as I'd like; we're taking far too many casualties,' he tells you."

	response of Sisko when asked about Gul Dukat:
	say "'He's a very evil man,' Sisko opines."

	response of Sisko when asked about Sisko:
	say "'I am quite well, thank you,' he assures you."

	response of Sisko when asked-or-told about Quark:
	say "'Up to his usual tricks, no doubt,' he nods."

	response of Sisko when asked for "advice":
	say "'I think you should make up your own mind,' he tells you."

	response of Sisko when asked about "bajor":
	say "'I think it's a fascinating planet,' he beams."

	default ask response for Sisko:
	say "'[one of]Let's talk about that some other time,' he suggests[or]I don't think I want to tell you about that right now,' he replies[or]'It would take too long to explain,' he tells you[in random order]."

	default tell response for Sisko:
	say "'[one of]That's very interesting, I'm sure,' he remarks[or]Perhaps you should tell me more about that on another occasion,' he suggests[or]I don't think I want to hear about that right now,' he complains[in random order]."

	default ask-for response for Sisko:
	say "'I'm afraid I can't help you with that just now,' he tells you."

	default yes-no response for Sisko:
	say "'I wasn't aware I had just asked you something,' Sisko remarks."

	default give-show response for Sisko:
	 now the noun is on the large desk;
	  say "'I'll take that, thank you very much,' he says, putting [the noun] [if the noun is the ball]back [end if]on the desk."

	The player is carrying a status report.
	
	The dominion war is a familiar thing.
	Gul Dukat is a familiar man.
	Quark is a familiar man.
	
	Test me with "a sisko/a war/a quark/t quark/ask for advice/ask for money/a dukat/a bashir/t dax/a bajor/t emissary/no/show Sisko the ball/show report"


