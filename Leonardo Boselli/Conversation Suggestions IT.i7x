Version 2 of Conversation Suggestions IT by Leonardo Boselli begins here.

"Provides a means of suggesting topics of conversation to the player, either in response to a TOPICS command or when NPCs are greeted. This extension requires Conversation Framework. Solo tradotto in italiano."

"basato su Conversation Suggestions by Eric Eve."

Book 1 - Includes

Include Italian by Leonardo Boselli.
[Include Plurality by Emily Short.]
Include Conversation Framework IT by Leonardo Boselli.

Book 2 - Definitions

Part 1 - Suggestion Lists for People

A person has a list of objects called ask-suggestions.
A person has a list of objects called tell-suggestions.
A person has a list of objects called other-suggestions.

Part 2 - The misc-suggestion Kind

A misc-suggestion is a kind of thing. An misc-suggestion is usually proper-named. 
A misc-suggestion is usually familiar. 
A misc-suggestion has a number called seqno. The seqno of an misc-suggestion is usually 100.

The specification of misc-suggestion is "An misc-suggestion is an object for use in an other-suggestions list. It is used to suggest topics for conversation other than those the player might ask about or tell about (e.g. SAY YES or GIVE HIM THE BOOK). The printed name of an misc-suggestion should be something that would make sense following 'You could '. An misc-suggestion can be given a seqno in order to place it in an appropriate place in the sequence of misc-suggestions."

yes-suggestion is a misc-suggestion. The printed name is "dire sì". The seqno is 10.
no-suggestion is a misc-suggestion. The printed name is "dire no." The seqno is 12.
yes-no-suggestion is a misc-suggestion. The printed name is "dire sì o no". The seqno is 10.

self-suggestion is a familiar thing. The printed name is "[the current interlocutor]"

Part 3 - Global Variables

sugg-list-ask is a list of objects that varies.
sugg-list-tell is a list of objects that varies.
sugg-list-other is a list of objects that varies.
suggest-on-greeting is a truth state that varies.
suggest-on-greeting is true.

Topic-request is a protocol type that varies. Topic-request is explicit.



Book 2 - Some Useful Phrases

To say remove  (obj - a thing) tell suggestion:
   remove obj from the tell-suggestions of the appropriate-suggestion-database, if present.

To say remove (obj - a thing) ask suggestion:
   remove obj from the ask-suggestions of the appropriate-suggestion-database, if present.

To say remove (obj - a thing) other suggestion:
  remove obj from the other-suggestions of the appropriate-suggestion-database, if present.

To say add (obj - a thing) tell suggestion:
   add obj to the tell-suggestions of the appropriate-suggestion-database, if absent.

To say add (obj - a thing) ask suggestion:
   add obj to the ask-suggestions of the appropriate-suggestion-database, if absent.
  
To say add (obj - a thing) other suggestion:
  add obj to the other-suggestions of the appropriate-suggestion-database, if absent.

To decide which object is the appropriate-suggestion-database:
  decide on the current interlocutor.

Book 3 - Rules

Part 1 - Suggestion List Construction Rules


The suggestion list construction rules are a rulebook.

The first suggestion list construction rule (this is the use the current interlocutor's suggestion lists rule):
  change sugg-list-other to the other-suggestions of the current interlocutor;
  change sugg-list-ask to the ask-suggestions of the current interlocutor;
  change sugg-list-tell to the tell-suggestions of the current interlocutor.

The last suggestion list construction rule (this is the exclude unknown items from suggestions rule):
 Let u-list be the list of unknown things;
 remove u-list from sugg-list-ask, if present;
 remove u-list from sugg-list-tell, if present;
 if the number of entries in sugg-list-other > 0 begin;
   remove u-list from sugg-list-other, if present;
  sort sugg-list-other in seqno order;
end if.

The last suggestion list construction rule (this is the refer to current interlocutor as him-herself in suggestions rule):
  if the current interlocutor is listed in sugg-list-ask begin;
    remove the current interlocutor from sugg-list-ask;
    add self-suggestion at entry 1 in sugg-list-ask;
 end if;
 if the current interlocutor is listed in sugg-list-tell begin;
    remove the current interlocutor from sugg-list-tell;
    add self-suggestion at entry 1 in sugg-list-tell;
 end if.



Part 2 - The Listing Suggested Topics Action

Listing suggested topics is an action applying to nothing.

Understand "argomenti" as listing suggested topics.

Check listing suggested topics when the current interlocutor is not a person:
  say "Non stai parlando con nessuno in questo momento." instead.

Carry out listing suggested topics:
  consider the suggestion list construction rules;
  let ask-suggs be the number of entries in sugg-list-ask;
  let tell-suggs be the number of entries in sugg-list-tell;
  let other-suggs be the number of entries in sugg-list-other;
  if ask-suggs + tell-suggs + other-suggs is 0 begin;
     say "[nothing specific]";
     rule succeeds;
  end if;
  let sugg-rep be an indexed text;
  say "[if topic-request is implicit]([end if]Potresti ";
  if other-suggs > 0 begin;
     let sugg-rep be "[sugg-list-other]";
     replace the regular expression "\band\b" in sugg-rep with "o";
     say "[sugg-rep][if tell-suggs + ask-suggs > 0]; o [end if]";
  end if;
[*** LEO *** elenca con preposizione articolata corretta]
  if ask-suggs > 0 begin;
	say "chiedere [a-prep the current interlocutor] ";
	say "[di-prep the entry 1 of sugg-list-ask]";
	if ask-suggs is greater than 1 begin;
		repeat with ct running from 2 to ask-suggs minus 1 begin;
			say ", [di-prep the entry ct of sugg-list-ask]";
		end repeat;
		say " e [di-prep the entry ask-suggs of sugg-list-ask]";
	end if;
	say "[if tell-suggs > 0]; o [end if]";
  end if;
  if tell-suggs > 0 begin;
	say "parlare [a-prep the current interlocutor] ";
	say "[di-prep the entry 1 of sugg-list-tell]";
	if tell-suggs is greater than 1 begin;
		repeat with ct running from 2 to tell-suggs minus 1 begin;
			say ", [di-prep the entry ct of sugg-list-tell]";
		end repeat;
		say " e [di-prep the entry tell-suggs of sugg-list-tell]";
	end if;
  end if;
[
  if ask-suggs > 0 begin;
      let sugg-rep be "[sugg-list-ask]";
      replace the regular expression "\band\b" in sugg-rep with "o";
      say "chiedere [a-prep the current interlocutor] [sugg-rep][if tell-suggs > 0]; o [end if]";
 end if;
 if tell-suggs > 0 begin;    
     let sugg-rep be "[sugg-list-tell]";
     replace the regular expression "\band\b" in sugg-rep with "o";
     say "parlare [a-prep the current interlocutor] [sugg-rep]";
end if;
]
say "[if topic-request is implicit].)[paragraph break][otherwise].[end if]"

To say nothing specific:
   say "Non hai nulla di specifico in mente da discutere [con-prep the current interlocutor] al momento."


Part 3 - Automatic Topic Suggestions

carry out saying hello to someone when suggest-on-greeting is true and greeting type is explicit (this is the display topic suggestions on explicit greeting rule) :
  the topic list displays in 0 turns from now.

At the time when the topic list displays:
  Show the topic suggestions implicitly.

To show the/-- topic suggestions implicitly:
    change topic-request to implicit;
    try silently listing suggested topics;
    change topic-request to explicit.


Conversation Suggestions IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di Conversation Suggestions by Eric Eve.
