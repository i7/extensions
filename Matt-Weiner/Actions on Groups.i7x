Actions on Groups by Matt Weiner begins here.

Section 1 - The Multiple Actions Flag

Multiple actions already taken is a truth state that varies. [Will be used to block the action on groups from running for every object in the multiple object list after the first, and also for blocking the ordinary processing of the action.]

An action-processing rule when multiple actions already taken is true (this is the multiple actions preempt ordinary actions rule):
	stop the action.		

Every turn (this is the reset multiple actions flag rule): 
	now multiple actions already taken is false.

The multiple actions preempt ordinary actions rule is listed after the check for group action rule in the action-processing rulebook. [This stops the ordinary action from running when a group action has been performed.]

Section 2 - The Action On Groups Rulebook

Action on groups is a rulebook. Action on groups has default success. 

An action-processing rule when the current action is groupable action and the multiple object list is not empty and multiple actions already taken is false (this is the check for group action rule):
	follow the action on groups rules for the action name part of the current action;
	if rule succeeded or rule failed: [but not if there is no outcome, which will happen if no action on groups rule runs or the rules that run make no decision]
		now multiple actions already taken is true.

The check for group action rule is listed before the announce items from multiple object lists rule in the action-processing rulebook. [Could list it "first" but I want to leave open the possibility of another extension putting another rule first--all we need is to guarantee that it winds up before the announce items rule.]

The announce items from multiple object lists rule does nothing when multiple actions already taken is true. [So the ordinary processing of the actions doesn't print the names of everything in the multiple object list.] 

Section 3 - Group-Only Action

[If an action is group-only, then an attempt to carry it out with a multiple object list that is not one of the designated groups will fail, rather than serially executing the action for each object in the list.]

Last action on groups rule when the current action is group-only action (this is the can't use undesignated groups rule):
	say "Sorry, you can't do that with all those things at once." (A);
	rule fails. 
	
[Note that if you define other action on groups rules for group-only actions in the main source code, they will wind up after this one. So be careful!]

Section 4 - New Phrases

[so we can use the standard syntax: An action on groups for [action] when dealing with [list]:]

To decide whether dealing with (list one - a list of objects):
	let list two be the multiple object list;
	repeat with tester running through list one:
		if tester is not listed in list two:
			no;
	repeat with tester running through list two:
		if tester is not listed in list one:
			no;
	yes.
	
[In case we want to redirect an action to a single action, so we have to clear the multiple object list.]

To clear the multiple object list:
	alter the multiple object list to {}.	

Section 5 - A Null Action

[we need to define an action that is groupable action and group-only action, so the Inform compiler will recognize those as kinds of action.]

Null acting is an action applying to one thing.
Null acting is groupable action.
Null acting is group-only action.

Actions on Groups ends here.

---- DOCUMENTATION ----

PURPOSE OF EXTENSION

Ordinarily in Inform 7, once we have specified that "marry [things]" is to be understood as marrying, the command "MARRY DOMINIQUE AND DEVIN" would produce an output somewhat like this:
	
	Dominique: Married.
	Devin. Married.

If the player is officiating at a wedding ceremony rather than practicing plural marriage, we might want an output more like:
	
	You marry Dominique and Devin to each other.

And we would like the effects of this action to operate on Dominique and Devin as a pair rather than first on Dominique and then on Devin; they should wind up related by marriage, rather than each of them acquiring a separate "married" property.

Actions on Groups allows us to make certain actions apply to an entire player-specified group all at once, rather than applying serially to each member of the group. To do this we use a kind of action, groupable action, and a special rulebook, the Action on Groups rules. When groupable action is run on more than one object at once, the Action on Groups rules are checked. If any of the Action on Groups rules are run, then any further processing of the action is halted; the game will not print announcements such as "Dominique:" and will not run the normal Before-Instead-Check-Carry Out-After-Report rules for the action.

USE OF EXTENSION

To set up action on groups for an action, we must declare it as groupable action:
	
	Examining is groupable action.

We must create an Understand token to allow it to apply to multiple things, if it is not already so defined in the Standard Rules:

	Understand "examine [things]" as examining.

And we must create one or more Action on Groups rules for the action:
	
	Action on groups rule for examining:

The Action on Groups rulebook has default outcome success, so if one Action on Groups rule runs, no other such rules will run; unless we tell the rule to allow the rulebook to continue by invoking a "make no decision" phrase at the appropriate point. If the Action on Groups rulebook ends in success or failure, then the "multiple actions already taken" truth state will be set to true; this will suppress all further processing of actions that turn and will prevent the announcements of the individual items from the multiple object list from printing. 

The list of items specified by the player is the multiple object list (see §21.6 of Writing with Inform). If we want to write rules that apply only when a given list has been specified, we can use the phrase "when dealing with"; "dealing with L" is true when L is a list that contains all and only the objects in the multiple object list. So a rule beginning:

	Action on groups rule for marrying when dealing with {Dominique, Devin}:

would fire in response to "MARRY DOMINIQUE AND DEVIN" but not in response to "MARRY DOMINIQUE, DEVIN AND ALEX." See Example C below for examples of "dealing with" rules.

We can specify a groupable action as group-only action:

	Quizzing it about is group-only action.

The Action on Groups rulebook for group-only actions is backstopped by the can't use undesignated groups rule, which prints a refusal to act on multiple objects. The idea is that a group-only action does not work on arbitrary groups, but only when the group the player's command picks out is a group ithatf the author has written a rule for dealing with. If the player's command picks out a different group, so that none of the author's Action on Groups rules fires, then the extension will print a refusal to act on multiple objects and stop all further processing of the actions. See "Sword Talk" for an example of group-only action.

REDIRECTING ACTIONS

The multiple object list governs whether or not we are acting on groups, and what groups we are acting on. If we wish to invoke a group action from within another rule, we must first alter the multiple object list to the list we wish to act on, and then try the action we wish on some entry of that list. Example C below demonstrates this; when searching a supporter that supports multiple items, we redirect the action to examining the contents of the supporter.

If we wish to invoke a non-group action from within a group action, we must first empty out the multiple object list. Example A below demonstrates this; when quizzing the swordsmith about the list of swords, we redirect the action to quizzing the swordsmith about the ideal sword. We must first empty the multiple object list, or Inform will treat "try quizzing the swordsmith about the ideal sword" as if it were an action on the list of swords, and we will enter an infinite loop.

A custom phrase is provided for emptying the multiple object list:

	clear the multiple object list.

CAUTIONS

Do not use "stop the action" or "...instead" in an Action on Groups rule unless you want to proceed with the standard way of processing the action serially for each object in the multiple object list; use "rule fails" instead. In order for the multiple actions already taken flag to be set, the Action on Groups rulebook must end in success or failure. "Stop the action" and "...instead" cause the specific rule that is running to end in failure, but terminate the rulebook with no decision. "Rule fails" ends both the specific rule and the rulebook in failure, which will cause the flag to be set properly and will terminate any further action processing that turn.

If you wish more than one Action on Groups rule to run in a turn, for instance to check the group action in one rule and carry it out in another rule, then the first rules must end in "make no decision" in order to allow the next rule to run. But some rule must end in a decision, or the multiple actions already taken flag will not be set and normal action processing will not be preempted. Since Action on Groups rules have default success, it should be enough to ensure that some rule that does not contain the "make no decision" phrase runs if the rulebook is not cut off earlier with "rule fails."

Some of the more complicated things that one might wish to try with Actions on Groups can require very delicate handling of the success and failure of the rulebooks. See the implementation of "The Facts Were These, Refactored" (at http://www.intfiction.org/forum/viewtopic.php?f=7&t=19285) for an example. Use with care.

ACKNOWLEDGMENTS

Thanks to Björn Paulsen for inspiring and encouraging the extension, and to (your name here) for additional suggestions! Comments and suggestions can be sent to (first name of extension author) at (full name of extension author, with no spaces) dot net.

EXAMPLES

Example A, "Sword Talk," demonstrates a simple case of group only action. We would like the swordsmith to respond to "ask smith about swords" with chat about the ideal sword, but 
	
	Understand "swords" as the ideal sword.

will not work; the parser will understand "swords" as the plural of sword anyway. We define quizzing as a groupable action, so that "ask smith about swords" will result in quizzing the smith about the list of swords, and write a rule for dealing with quizzing when dealing with the list of swords. (Note that we must clear the multiple object list so this action is not itself treated as multiple.) We also define quizzing as group-only action, so any other attempt to ask about multiple things will fail. (Since there is no "[any things]" token as of Inform 6L38, we have to engage in a bit of trickery to add the off-stage things to scope when quizzing; the "[any things]" token is planned for future releases.) Most of the code for "Sword Talk" is by Björn Paulsen.

Example B, "Matrimony," allows us to marry two people at a time to each other. We write a series of Action on Groups rules to check that we are only marrying people, that we are marrying exactly two people, and so on. As discussed above, the initial rules must invoke "rule fails" when they fail, and must end with "make no decision" in order to allow the rulebook to proceed to the next rule; but the final rule must not end in "make no decision." Every rule is marked "Last" to ensure that they run in source code order (which is the order we want).

Example C, "The Facts Were These (Refactored)," is a reimplementation of the example "The Facts Were These" from the Inform documentation. For the most part, we can simply remove the mechanics from the original example that deal with multiple-examining, declare examining as groupable action (with an appropriate Understand token), and write rules for dealing with the lists of objects that have special effects. We also reimplement the searching code by altering the multiple object list and then trying an examining action, so the examining action gets redirected to the Actions on Groups rules.

Example: * Sword Talk - Allowing a response to "ask smith about swords" while blocking any other attempt to ask about multiple things.

	*: "Sword Talk" by Björn Paulsen with modifications by Matt Weiner
	
	Include Actions on Groups by Matt Weiner.
	
	Section 1 - Swords and the Ideal Sword
	
	A sword is a kind of thing.
	
	Understand "blade/edge/sword" as "[blade]".
	Understand "[blade]" as sword.
	
	Definition: a thing is perfect if it is nowhere.
	
	The ideal sword is a sword.
	Understand "blades/edges" as the ideal sword.
	
	Section 2 - Quizzing
	
	Understand the command "ask" as something new. 
	
	Quizzing it about is an action applying to one thing and one visible thing.
	Understand "ask [someone] about [things]" as quizzing it about.
	
	Does the player mean quizzing about a perfect thing: it is very likely.
	
	To decide what action name is the action-to-be: (- action_to_be -).
	After deciding the scope of the player when the action-to-be is the quizzing it about action:
		repeat with item running through things:
			place item in scope.
	
	Section 3 - Setting Action on Groups for Quizzing
	
	Quizzing is groupable action.
	Quizzing is group-only action. 
	
	Action on groups for quizzing when dealing with the list of swords:
		clear the multiple object list;
		try quizzing the noun about the ideal sword.
		
	The can't use undesignated groups rule response (A) is "'Sorry, one question at a time!'"
	
	Section 4 - Scenario
	
	The swordsmith is a man. "The swordsmith wears a button that reads 'ASK me ABOUT swords, or about a particular sword!'" Understand "smith" as the swordsmith. The swordsmith wears a button. The description of the button is "'ASK me ABOUT swords, or about a particular sword!'"
	
	The rakish fop is a man. The fop holds a sword called the wicked needle.
	The dolorous monk is a man. The monk carries a sword called the keen instrument of DEATH.
	
	After quizzing the swordsmith about the ideal sword, say "'Yes, swords are the best!'"
	After quizzing the swordsmith about a sword (called blade), say "'Hmm, [the blade]... not my best work, to be honest.'"
	
	The forge is a room. All men are here. The player is the monk.
	
	Test me with "ask smith about sword/ask smith about my sword/ask smith about swords/ask smith about needle and instrument".
	
Example: * Matrimony - Allowing the player to perform marriages between any two people, setting a relation between those two people.
	
	*: "Matrimony" by Matt Weiner
	
	Include Actions on Groups by Matt Weiner.
	
	Registry is a room. "Here people wait for you to marry them. To each other." Alex, Devin, Dominique, Casey, and Jordan are people in Registry. A lectern is in Registry.
	
	Marrying is an action applying to one thing. Understand "marry [things]" as marrying. [Unfortunately there's no "people" token.]
	Marrying is groupable action.
	
	Marriage relates one person to another (called the spouse). The verb to be married to means the marriage relation.
	
	Definition: A person is married if it is married to someone.
	
	Last action on groups rule for marrying (this is the can only marry people rule):
		repeat with item running through the multiple object list:
			if item is not a person:
				say "Only people can be married.";
				rule fails;
		make no decision.
		
	Last action on groups rule for marrying (this is the two at a time rule):
		if the number of entries in the multiple object list is not 2:
			say "You only have the power to marry two people to each other at once.";
			rule fails;
		otherwise:
			make no decision.
			
	Last action on groups rule for marrying (this is the can't marry yourself to anyone rule):
		if the player is listed in the multiple object list:
			say "You are not here to marry anyone yourself, only to officiate at marriages.";
			rule fails;
		make no decision.
			
	Last action on groups rule for marrying (this is the can't marry what's already married rule):
		repeat with celebrant running through the multiple object list:
			if celebrant is married:
				say "[Celebrant] is already married.";
				rule fails;
		make no decision.
	
	Last action on groups rule for marrying (this is the perform marriage rule):
		let first party be entry 1 of the multiple object list;
		let second party be entry 2 of the multiple object list;
		now first party is married to second party;
		say "You join [the first party] to [the second party] in matrimony."
		
	Check marrying (this is the block marrying rule):
		say "You are not here to marry anyone yourself, only to officiate at marriages."
		
	Every turn:
		if someone is married:
			repeat with celebrant running through married people:
				say "[Celebrant] is married to [Spouse of celebrant].";
		otherwise:
			say "No one is married yet."
			
	test me with "marry all/marry all people/marry dominique and devin/marry alex/marry me and alex/marry alex, casey and jordan/marry alex and alex/marry alex and lectern/marry alex and devin/marry alex and casey".

Example: ** The Left Hand of Autumn, Refactored - The example "The Left Hand of Autumn" from the Inform documentation, refactored so as to use the Actions on Groups extension.

	*: "The Left Hand of Autumn, Refactored" by Emily Short with modifications from Matt Weiner

	Include Actions on Groups by Matt Weiner.
	
	Section 1 - General Code from "The Left Hand of Autumn"
	
	[Most of this section of the original example was the code for multiple examining, which we have refactored using this extension. But some bits remain.]
	
	[This allows the player to use the collective names for things in their commands.]
	After reading a command:
		repeat through the Table of Collective Names:
			let N be "[the player's command]";
			let Y be relevant list entry;
			while N matches the regular expression "[name-text entry]":
				replace the regular expression "(.*)[name-text entry](.*)" in N with "\1[Y]\2";
			change the text of the player's command to N.
	
	Report taking something:
		say "You pick up [the noun]." instead.
	
	Section 2 - Scenario
	
	Eight-Walled Chamber is a room. "A perfectly octagonal room whose walls are tinted in various hues."
	
	The display table is a supporter in the Chamber. A twig of rowan wood is on the table.
	
	The player carries an apple and a pear.
	
	A glove is a kind of thing. A glove is always wearable. Understand "glove" as a glove. The player carries a left glove and a right glove. The left glove and the right glove are gloves.
	
	[Now we define a few actual lists of items:]
	
	Fruit list is a list of things which varies. Fruit list is { apple, pear }.
	Glove list is a list of things which varies. Glove list is { right glove, left glove }.
	Arcane list is a list of things which varies. Arcane list is { left glove, twig, pear }.
	
	Table of Collective Names
	name-text	relevant list
	"left hand of autumn"	"[arcane list]"
	"gloves"	"[glove list]"
	"pair of gloves"	"[glove list]"
	
	Test me with "x apple and pear / x left and right / put pear on table / put left glove on table / x all on table / put all on table / examine all on table / get apple, twig, pear / x all on table / search table".
	
	Section 3 - Handling the Scenario with Action on Groups
	
	Understand "examine [things]" as examining. 
	
	Examining it from is an action applying to two things.
	
	Understand "examine [things inside] in/on [something]" or "look at [things inside] in/on [something]" as examining it from. [As in the original example, we can use this to capture "look at everything on the table"; but now we can redirect it to simple examining, and use the action on groups rules to take care of the case where the things on the table form a special group.]
	
	Examining is groupable action. Examining something from something is groupable action.
	
	An action on groups rule for examining something from something:
		try examining the noun. [This will trigger the action on groups rules for examining; and since the rule for examining it from fires before the announce items rule, examining it from will not trigger announcments from the multiple object lists]
	
	Carry out examining it from: try examining the noun instead. [This will be invoked when there is only a single item involved.]
	
	An action on groups rule for examining when dealing with the fruit list:
		say "Just a couple of fruits."
		
	An action on groups rule for examining when dealing with the glove list:
		say "It's a matched pair of fuzzy blue gloves."
		
	An action on groups rule for examining when dealing with the arcane list:
		say "To anyone else it might look like a random collection of objects, but these three things -- [multiple object list with definite articles] -- constitute a mystic key known as the Left Hand of Autumn. They practically hum with power."
		
	Last action on groups rule for examining:
		say "You see [multiple object list with indefinite articles]." 
		
	Understand "look on [something]" as searching.
	
	[The original example had a phrase for describing a list, which was invoked both by multiple examining and by searching a container/supporter that contained/supported multiple things. We can accomplish the same thing by hand-changing the multiple object list to the list of things in/on the container/supporter, and then examining the first one--which will behave just as if the player had typed "EXAMINE ALL ON TABLE."]
	
	Instead of searching something which supports at least two things:
		let L be the list of things supported by the noun;
		alter the multiple object list to L;
		try examining entry 1 of L.
		
	Instead of searching something which contains at least two things:
		let L be the list of things contained by the noun;
		alter the multiple object list to L;
		try examining entry 1 of L.
