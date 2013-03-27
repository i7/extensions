Version 2 of Conversation Responses IT by Leonardo Boselli begins here.

"basato su Conversation Responses by Eric Eve."

Include Conversation Framework IT by Leonardo Boselli.

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
  if quizzing someone about something then decide on whether or not the obj is the second noun;
  decide no.

To decide whether asked about (objs - a description):
    if quizzing someone about something then decide on whether or not the second noun is a member of objs;
   decide no.

To decide whether asked about (atopic - a topic):
  if asking someone about something then decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether asked-or-told about (obj - an object):
  if quizzing someone about something or informing someone about something then decide on whether or not the obj is the second noun;
  decide no.

To decide whether asked or told about (objs - a description):
    if quizzing someone about something or informing someone about something,
    decide on whether or not the second noun is a member of objs;
   decide no.

To decide whether asked-or-told about (atopic - a topic):
 if asking someone about something or telling someone about something then decide on whether or not the topic understood matches atopic;
 decide no.

To decide whether told about (obj - an object):
  if informing someone about something then decide on whether or not obj is the second noun;
  decide no.

To decide whether told about (objs - a description):
    if informing someone about something then decide on whether or not the second noun is a member of objs;
   decide no.


To decide whether told about (atopic -  a topic):
  if telling someone about something then decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether answered that (atopic -  a topic):
  if answering someone that something then decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether asked for (obj - an object):
  if requesting someone for something then decide on whether or not the obj is the second noun;
  decide no.

To decide whether asked for (atopic - a topic):
  if imploring someone for something then decide on whether or not the topic understood matches atopic;
  decide no.

To decide whether asked for (objs - a description):
    if requesting someone for something then decide on whether or not the second noun is a member of objs;
   decide no.


To decide whether shown (obj - an object):
  if showing something to someone, decide on whether or not obj is the noun;
  decide no.

To decide whether shown (objs - a description):
    if showing something to someone,  decide on whether or not the noun is a member of objs;
   decide no.


To decide whether given (obj - an object):
    if giving something to someone, decide on whether or not obj is the noun;
   decide no.

To decide whether given(objs - a description):
    if giving something to someone,  decide on whether or not the noun is a member of objs;
   decide no.


To decide whether given-or-shown (obj - an object):
     if giving something to someone or showing something to someone, decide on whether or not obj is the noun;
   decide no.

To decide whether given-or-shown (objs - a description):
    if giving something to someone or showing something to someone,
    decide on whether or not the noun is a member of objs;
   decide no.


To decide whether (X - an object) is a member of (D - description): (-
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

The first report rule for saying goodbye to someone (this is the standard report farewell rule):
  if farewell type is implicit then abide by the implicit farewell response rules for the noun;
  abide by the farewell response rules for the noun.

The first report rule for saying hello to someone (this is the standard report greeting rule):
  if greeting type is implicit then abide by the implicit greeting response rules for the noun;  
  abide by the greeting response rules for the noun.

Conversation Responses IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Conversation Responses by Eric Eve.