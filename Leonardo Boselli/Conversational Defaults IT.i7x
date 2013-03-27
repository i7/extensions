Version 2 of Conversational Defaults IT by Leonardo Boselli begins here.
"Provides a set of rules to facilitate defining default conversational responses for different conversational commands targeted at various NPCs. This extension requires Conversation Framework. Solo tradotto in italiano."

"basato su Conversational Defaults by Eric Eve."

Book 1 - Includes

Include Conversation Framework IT by Leonardo Boselli.

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
 say "[The current interlocutor] non risponde."

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

The last report asking it about rule (this is the default asking rule):
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

Conversational Defaults IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Conversational Defaults by Eric Eve.