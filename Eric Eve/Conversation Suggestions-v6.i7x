Version 6.2 of Conversation Suggestions by Eric Eve begins here.
"Provides a means of suggesting topics of conversation to the player, either in response to a TOPICS command or when NPCs are greeted. This extension requires Conversation Framework. Version 3 makes use of Complex Listing by Emily Short if it's included in the same game rather than indexed text to generate a list of suggestions."

Book 1 - Includes

Include Conversation Framework by Eric Eve.

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

yes-suggestion is a misc-suggestion. The printed name is "say yes". The seqno is 10.
no-suggestion is a misc-suggestion. The printed name is "say no." The seqno is 12.
yes-no-suggestion is a misc-suggestion. The printed name is "say yes or no". The seqno is 10.

self-suggestion is a familiar thing. The printed name is "[regarding the current interlocutor][themselves]"

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
  now sugg-list-other is the other-suggestions of the current interlocutor;
  now sugg-list-ask is the ask-suggestions of the current interlocutor;
  now sugg-list-tell is the tell-suggestions of the current interlocutor.

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

Understand "topics" as listing suggested topics.

Check listing suggested topics when the current interlocutor is not a person (this is the can't suggest topics when not talking to anyone rule):
  say "[We] [aren't] talking to anyone right [now]." (A) instead.

[ Following the suggestion in Matt Wigdahl's article at http://www.wigdahl.net/quern/2009/12/23/inform-7-development-implementing-single-keyword we use the printed name of  the interlocutor in the following to say phrase, rather than just the current interlocutor, to avoid any custom formatting that may have been applied to topic names in a rule for printing the name of ... when suggestion topics]

To say nothing specific:
   say "[We] [have] nothing specific in mind to discuss with [the printed name of the current interlocutor] just [now]."

Chapter 1a -  Listing Suggested Topics (for use with Complex Listing by Emily Short)

[ This version uses Complex Listing to end the list with "or" rather than "and" ]

Section 1 - Carry Out Listing

Carry out listing suggested topics (this is the list suggested topics rule):
	follow the suggestion list construction rules;
	let ask-suggs be the number of entries in sugg-list-ask;
	let tell-suggs be the number of entries in sugg-list-tell;
	let other-suggs be the number of entries in sugg-list-other;
	if ask-suggs + tell-suggs + other-suggs is 0:
		say "[nothing specific]";
		rule succeeds;
	say "[if topic-request is implicit]([end if][We] [could] " (A);
	if other-suggs > 0:
		say "[sugg-list-other in topic format][if tell-suggs + ask-suggs > 0]; or [end if]" (B);
	if ask-suggs > 0:
		say "ask [regarding the current interlocutor][them] about [sugg-list-ask in topic format][if tell-suggs > 0]; or [end if]" (C);
	if tell-suggs > 0:
		say "tell [regarding the current interlocutor][them] about [sugg-list-tell in topic format]" (D);
	say "[if topic-request is implicit].)[otherwise].[end if][paragraph break]" (E).
	
 
Section 2 - Carry Out Listing Support Routines

To say (l - a list of objects) in topic format:
	set up l for topic printing;
	say "[the prepared list delimited in disjunctive style]";
 
To set up (l - a list of objects) for topic printing:
	repeat with item running through l:
		now the item is marked for special listing;
	register things marked for listing.

Chapter 1b -  Listing Suggested Topics (for use without Complex Listing by Emily Short)

[ This version uses regular expression substitution in indexed text to end the list with "or" rather than "and" ]

Carry out listing suggested topics (this is the complex list suggested topics rule):
  follow the suggestion list construction rules;
  let ask-suggs be the number of entries in sugg-list-ask;
  let tell-suggs be the number of entries in sugg-list-tell;
  let other-suggs be the number of entries in sugg-list-other;
  if ask-suggs + tell-suggs + other-suggs is 0 begin;
     say "[nothing specific]" (A);
     rule succeeds;
  end if;
  let sugg-rep be a text;
  say "[if topic-request is implicit]([end if][We] [could] " (B);
  if other-suggs > 0 begin;
     let sugg-rep be "[sugg-list-other]";
     replace the regular expression "\band\b" in sugg-rep with "or";
     say "[sugg-rep][if tell-suggs + ask-suggs > 0]; or [end if]" (C);
  end if;
  if ask-suggs > 0 begin;
      let sugg-rep be "[sugg-list-ask with definite articles]";
      replace the regular expression "\band\b" in sugg-rep with "or";
      say "ask [regarding the current interlocutor][them] about [sugg-rep][if tell-suggs > 0]; or [end if]" (D);
 end if;
 if tell-suggs > 0 begin;    
     let sugg-rep be "[sugg-list-tell with definite articles]";
     replace the regular expression "\band\b" in sugg-rep with "or";
     say "tell [regarding the current interlocutor][them] about [sugg-rep]" (E);
end if;
say "[if topic-request is implicit].)[otherwise].[end if][paragraph break]" (F).



Part 3 - Automatic Topic Suggestions

carry out saying hello to someone when suggest-on-greeting is true and greeting type is explicit (this is the display topic suggestions on explicit greeting rule) :
  the topic list displays in 0 turns from now.

At the time when the topic list displays:
  Show the topic suggestions implicitly.

To show the/-- topic suggestions implicitly:
    now topic-request is implicit;
    try listing suggested topics;
    now topic-request is explicit.



Conversation Suggestions ends here.

---- DOCUMENTATION ----

Chapter: Introduction

Section: Overview

In some games that involve a considerable amount of conversation, it can be helpful to tell the player what conversation options may be worth trying. This extension provides a TOPICS command that lists whatever topic suggestions we define. For example:

	>talk to bob
	"Hi there!" you say.

	"Hello," he replies
	(You could ask him about himself, Amanda, the gold ring or the lighthouse; or tell him about yourself or the strangers.)

	>topics
	You could ask him about himself, Amanda, the gold ring or the lighthouse; or tell him about yourself or the strangers.

It is not possible to have the game work out itself which topics are available for discussion; we have to manage topic suggestion lists in our own code, but this does give us control over precisely what suggestions we display to the player. There is no need to list every topic that may give a non-default response; it may often be better just to list the more relevant ones, or we may want to avoid spoilers.

This extension uses Conversation Framework. It can also be used alongside Conversation Responses and Conversational Defaults. If you want to use Conversation Suggestions with Conversation Nodes you'll probably be better off using Conversation Package.

Section: Acknowledgements and Notes

Version 3 incorporates some code contributed by Matt Wigdahl, which takes effect if Complex Listing by Emily Short is present. The provides an alternative method of formatting lists of suggestions to use "or" rather than "and". Without Complex Listing, Conversation Suggestions uses indexed text to do this, which obliterates any special formatting applied to suggestions in the list. For example, if you wanted individual topic suggestions to be shown in blue, you might add a rule like:

	Rule for printing the name of something (called item) when listing suggested topics:
		say "[blue letters][printed name of the item][default letters]";

By default, however, this formatting will be lost, since Conversation Suggestions converts the output to indexed text before displaying it. To preserve such formatting we need to add the following to our code:

	*: Include Complex Listing by Emily Short

Conversation Suggestions will then use Complex Listing rather than indexed text to process the list of suggested topics, and our formatting will be preserved.


Chapter: Setting Up Suggestion Lists

Section: Ask and Tell Suggestions

Each actor in our game has three suggestion lists, defined in the following three properties:

	ask-suggestions
	tell-suggestions
	other-suggestions

This assumes that most of the time we'll want to suggest things the player can ask or tell people about, but it also allows us to make other kinds suggestions of suggestion as well.

We can set up initial lists of things we can ask or tell an actor about simply by defining these lists on the NPC in question, for example:

	Bob is a man.
	The ask-suggestions are  { bob, amanda, gold ring, lighthouse }.
	The tell-suggestions are  { yourself, the strangers }.

Note that the objects we put in these lists are the simply the objects that the player can ask or tell Bob about. This means that if we want to suggest discussing an abstract topic (such as the weather) we need to define an object to represent that topic:

	The weather is a familiar thing.

We have to make such a topic familiar, otherwise the player won't be able to refer to it in a conversational command (and it won't be listed as a suggestion).

If we want the suggested name of an object in a suggestion list to differ from its ordinary printed name, we can just write a rule for printing the name of the whatever when listing suggested topics, for example:

	Rule for printing the name of the gold ring when listing suggested topics:
	say "the mysterious ring".

Conversation Suggestions contains a special object for making suggestions about the current interlocutor. If we write the following:

	Bob is a man.
	The ask-suggestions are  { self-suggestion, amanda, gold ring, lighthouse }.

The suggestions will be shown as:

	You could ask Bob about himself, Amanda, the gold ring or the lighthouse.

Which reads more naturally than:

	You could ask Bob about Bob, Amanda, the gold ring or the lighthouse.

self-suggestion will automatically display as "himself" or "herself" depending on the gender of the current interlocutor.

Conversation Framework already ensures that ASK BOB ABOUT HIMSELF is translated into ASK BOB ABOUT BOB.

Section: Other Suggestions

Although it's likely that most of the time we'll want to suggest things the player can ask or tell about, we may occasionally want to suggest other kinds of conversational response, for example "You could say or no" or "You could give him the gold ring" or "You could say Jane". For this purpose we use the other-suggestions list, which should contain objects of kind misc-suggestion. The printed name of an misc-suggestion should have a printed name that displays a suggestion phrase that could follow "You could", for example:

	ring-suggestion is an misc-suggestion. The printed name is "give him the gold ring"
	jane-suggestion is an misc-suggestion. The printed name is "say Jane"

This extension predefines three misc-suggestions that are likely to be commonly used:

	yes-suggestion
	no-suggestion
	yes-no-suggestion

The last of these displays "say yes or no", which might be slightly neater than the "say yes or say no" that would result from listing yes-suggestion and no-suggestion separately.

Then to make these three suggestions available when addressing Bob we'd define:

	Bob is a man.
	The other-suggestions are { yes-no-suggestion, ring-suggestion, jane-suggestion }.

If we had a number of other-suggestions, we might want some control over the order in which they're displayed. To be sure, they'll start out being displayed in the order in which we list them in the other-suggestions property, but once we start adding and subtracting misc-suggestions as the situation changes this will no longer be the case. The misc-suggestion kind therefore has a seqno property to allow us to control the order in which they're displayed: other-suggestions are sorted in seqno order before being displayed. This would allow us, for example, to group all suggestions of the form "show him the whatever" together by giving them the same seqno.

By default misc-suggestions have a seqno of 100, but yes-suggestion, yes-no-suggestion and no-suggestion have seqnos of 10, 10 and 12 respectively, so that they'll normally be displayed at the start of the list.

Chapter: Managing Suggestions

Section: Adding and Removing Suggestions

We've just seen how to set up an initial list of conversation suggestions. That's all very well, but the chances are that the suggestions we want to offer will change over the course of the game. We'll want to remove some suggestions as they cease to be relevant (perhaps because the player has already asked the NPC about that topic) and add others as new things come to light.

We'll often want to add or remove things as a result of things that are said, so this extension defines the following phrases to add or remove suggestions:

	To say remove  (obj - a thing) tell suggestion:
	To say remove (obj - a thing) ask suggestion:
	To say remove (obj - a thing) other suggestion:
	To say add (obj - a thing) tell suggestion:
	To say add (obj - a thing) ask suggestion:  
	To say add (obj - a thing) other suggestion:

These can then be used like this:

	"[remove gold key tell suggestion]"
	"[remove bob ask suggestion]"
	"[remove yes-no other suggestion]"
	"[add matilda tell suggestion]"
	"[add treasure ask suggestion]"
	"[add ring-suggestion other suggestion]"

Usually, though these would be embedded in longer pieces of text giving the NPC's response to some conversational command, e.g.:

	After quizzing Bob about Bob:
	say "'How are you today, Bob?' you ask.

	'Oh fine, just fine,' he replies, [remove bob ask suggestion]'Absolutely broke, but fine.'"

Section: Suggestions and Player Knowledge

In one particular case the Conversation Suggestions extension can automatically take care of when suggestions occur. The Epistemology extension (included via Conversation Framework) keeps track of what the player knows about. Something is known either if the player has seen it, or if it is defined as familiar. Anything else is unknown. Conversation Suggestions automatically removes anything unknown from the list of suggestions it displays.

This means that you can include unknown things in the initial ask-suggestions and tell-suggestions lists, and they won't actually be displayed until they become known. Making them known (e.g. through using "now the magic ring is familiar" or "[make the magic ring known]") will then simultaneously make them available to be asked and told about (or rather quizzed and informed about) and make them appear in the list of suggested topics.

Section: Suggestions and Greetings

By default a list of conversation suggestions is displayed either when the player enters a TOPICS command, or when the player issues an explicit greeting command (such as TALK TO BOB or BOB, HELLO). The latter behaviour can be disabled by changing suggest-on-greeting to false.

Example: * The Lion in Winter - Suggestions for a conversation fit for a king.

	*: "The Lion in Winter"

	Part 1 - Setup and Topics

	Include Conversation Suggestions by Eric Eve.

	Richard is a familiar man.

	Eleanor of Aquitaine is a familiar woman.
	Understand "queen" as Eleanor.

	Bertrand de Born is a man.

	Thomas Becket is a familiar man.

	Alice of Berangaria is a woman.

	England is a familiar thing.
	France is a familiar thing.
	Prince John is a familiar man.
	doggerel is a familiar thing.

	The player carries a sword. 
	Understand "weapon" or "your" as the sword.

	sword-suggestion is a misc-suggestion. The printed name is "show him your sword".

	Part 2 - The King

	The Solar is a Room. "Dimly lit by the pale winter sun, the Solar overlooks the snow-covered bailey."

	King Henry is a man in the Solar. "King Henry is pacing up and down the Solar like a caged lion."
	The description is "He looks full of energy, as if anxious to get on with building the Angevin Empire instead of being cooped up in a wintry castle."

	The ask-suggestions are { France, Alice, Richard,  Eleanor,  Bertrand,  Thomas  }.
	The tell-suggestions are { England, Prince John }.
	The other-suggestions are { sword-suggestion }.

	Understand "plantagenet" or "II" or "the second" as King Henry.

	Part 3 - Conversation

	After quizzing King Henry about France:
	 say "'[remove france ask suggestion]'I rule more of it than the King of France does!' he boasts."

	After quizzing King Henry about Thomas:
	  say "[remove thomas ask suggestion]'Don't talk to me about that meddlesome priest!' the king growls."

	After quizzing King Henry about Eleanor:
	  say "[make bertrand known][remove eleanor ask suggestion]'She'll be joining me here shortly, and I'm looking forward to it. But I do wish that scoundrel Bertrand de Born would stop singing songs about her!' the king exclaims."

	After quizzing King Henry about Bertrand:
	  say "[remove bertrand ask suggestion][add doggerel ask suggestion]'That wretched minstrel stirs up more trouble with his doggerel than a score of knights with their swords!' the king complains."

	After quizzing King Henry about doggerel:
	say "[remove doggerel ask suggestion]''Bertrand's latest ditty goes something like this,' scowls the king: 'Alas poor prisoner, poor prisoner return, to thy people, Eleanor, who weep and mourn;  my tears are my bread both night and day, alas how long is my exile!'"

	After quizzing King Henry about Richard:
	 say "[remove richard ask suggestion][make alice known]'I just don't know: he's a good enough warrior, but I do wish he'd marry, I sometimes worry about him. Alice is comely enough, after all!' the king remarks."

	After quizzing King Henry about Alice:
	 say "[remove alice ask suggestion]'Well, Richard should have shown more interest in her. If he wouldn't take her himself he's only himself to blame if I decorate his head with antlers!' Henry yells."

	After informing King Henry about England:
	 say "[remove England tell suggestion]'I'm sure England can manage without me until the spring,' Henry replies."

	After informing King Henry about Prince John:
	 say "[remove Prince John tell suggestion]'I'm glad to hear John will be here soon. He's the only one who's really loyal to me, you know!' King Henry declares."

	Instead of showing the sword to King Henry:
	 say "[remove sword-suggestion other suggestion]'That's a fine weapon you have there,' the king approves."

	Part 4 - Testing

	test me with "talk to the king/a thomas/t england/topics/a france/t john/topics/a richard/a eleanor/topics/a alice/a bertrand/topics/a doggerel/show sword/topics"


