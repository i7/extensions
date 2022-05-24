Version 14.0.220524 of Room Description Control by Emily Short begins here.

"A framework by which the author can considerably change the listing of objects in a room description. Includes facilities for concealing objects arbitrarily and changing the order in which objects are listed."

[Need this for debugging code left in]
Paragraph-debug-state is a number that varies. Paragraph-debug-state is 0.

Section 0 - Data Structure

[This is in its own section so authors can replace it with more or fewer rows.]

Table of Seen Things
output subject	current rank
an object	a number
with 60 blank rows.

Section 1 - Priority and Concealment Rules

The new object description rule is listed instead of the room description paragraphs about objects rule in the carry out looking rules.

When play begins (this is the mark everything unmentioned when play begins rule):
	now every thing is unmentioned.
	
Before reading a command (this is the mark everything unmentioned rule):
	now every thing is unmentioned.

This is the new object description rule:
	follow the description-priority rules.
	
The description-priority rules are a rulebook.

A description-priority rule (this is the marking rule):
	now every thing is not marked for listing;
	call the swift rule on everything in scope.

[ New implementation: one loop ]
A description-priority rule (this is the mentioning tedious things rule):
	repeat with item running through every thing:
		if item is undescribed:
			now item is not marked for listing; [ Usually the player ]
		if item is enclosed by the player:
			now item is not marked for listing;
		if item is scenery:
			now item is not marked for listing;

[ Old implementation: three loops over all objects ]
[
	now the player is not marked for listing;
	now every thing enclosed by the player is not marked for listing;
	now every scenery thing is not marked for listing;
]

A description-priority rule (this is the determining concealment rule): 
	follow the description-concealing rules.
	
The description-concealing rules are a rulebook. 

A description-concealing rule (this is the concealing parts rule): 
	now everything that is part of something is not marked for listing.

A description-concealing rule (this is the ordinary-concealment rule):
	repeat with special-target running through marked for listing people:
		repeat with second special-target running through things carried by special-target:
			if special-target conceals second special-target:
				now second special-target is not marked for listing.

A description-concealing rule (this is the don't mention things out of play rule):
	repeat with special-target running through marked for listing things:
		if the holder of the special-target is nothing, now the special-target is not marked for listing.

A description-priority rule (this is the loading table rule):
	blank out the whole of the Table of Seen Things;
	repeat with item running through mentionable things:
		choose a blank row in the Table of Seen Things;
		now output subject entry is item.

lowest-rank is a number that varies.

A description-priority rule (this is the description-ranking rule): 
	now lowest-rank is 1000;
	repeat through the Table of Seen Things
	begin;  
		now the description-rank of the output subject entry is 0;
		follow the ranking rules for the output subject entry;
		now the current rank entry is the description-rank of the output subject entry;
		if description-rank of the output subject entry is less than lowest-rank, now lowest-rank is description-rank of the output subject entry;
	end repeat;
	sort the Table of Seen Things in reverse current rank order; 

A description-priority rule (this is the reporting descriptions rule):
	repeat through the Table of Seen Things:
		if the output subject entry is unmentioned:
			if paragraph-debug-state is at least 2:
				say "[bracket]reporting for: [output subject entry][close bracket]"; [debugging code]
				now the output subject entry is unmentioned; [reset side effects of debugging code]
			carry out the writing a paragraph about activity with the output subject entry;
	
[A description-priority rule (this is the final description rule):
	say paragraph break.]

After printing the name of something (called special-target) while writing a paragraph about something (this is the don't write a paragraph about something twice rule):
	now the special-target is not marked for listing;
	now the special-target is mentioned.
	
A thing has a number called description-rank.

Ranking rules are an object-based rulebook.

Definition: a thing is mentionable if it is marked for listing and it is unmentioned.
Definition: a thing is unmentionable if it is not mentionable.

Definition: a thing is descriptively dull if the description-rank of it is lowest-rank.

[This portion makes sure that items that are listed together in groups get properly flagged 'mentioned':]

After printing the plural name of something (called target) (this is the write only one paragraph about a group of identical objects rule):
	repeat with item running through things held by the holder of target
	begin; 
		if the item nominally matches the target
		begin;
			now the item is mentioned;
		end if;
	end repeat;

To decide whether (X - a thing) nominally matches (Y - a thing):
	(- ({X}.list_together == {Y}.list_together) -)

[Used to be: "To call (RL - an objects based rule) on everything in scope:",  but 6M62 will only have it this way]
To call (RL - a rule) on everything in scope:
(-
   processing_rule = {RL};
   LoopOverScope(Process_single_item);
-)

The scope processing rules are an object-based rulebook.

Include (-
  Global processing_rule = 0;

  [ Process_single_item o;
     FollowRulebook(processing_rule, o, true);
  ];
-) after "Definitions.i6t".

A scope processing rule for a thing (called n) (this is the swift rule): now n is marked for listing. 

Section 2 - Entering and Leaving

The new describe contents rule is listed instead of the describe contents entered into rule in the report entering rulebook.

This is the new describe contents rule:
	if the person asked is the player, follow the description-priority rules.

A description-concealing rule while entering a container (called special-target) (this is the don't describe things outside the player's container rule):
	repeat with item running through marked for listing things:
		if item is not enclosed by special-target, now the item is not marked for listing.

Section 3 - Debugging - Not for release

para-debugging is an action out of world applying to one number.
para-debug-off is an action out of world.
para-debug-on is an action out of world.
Understand "paragraphs [number]" as para-debugging.

Understand "paragraphs off" as para-debug-off.
Carry out para-debug-off (this is the paragraph debugging off redirect rule):
	try para-debugging 0 instead;

Understand "paragraphs" or "paragraphs on" as para-debug-on.
Carry out para-debug-on (this is the paragraph debugging on redirect rule):
	try para-debugging 1 instead;

Carry out para-debugging a number (called n) (this is the default carry out paragraph debugging rule):
	if n < 0, now n is 0;
	if n > 2, now n is 2;
	now paragraph-debug-state is n.

Report para-debugging (this is the default report paragraph debugging rule):
	say "Paragraph debugging is now [if paragraph-debug-state is 2]level 2[else if paragraph-debug-state is 1]on[otherwise]off[end if]." (A)

The table-debugging rule is listed after the description-ranking rule in the description-priority rules.
The table-debugging rule is listed before the reporting descriptions rule in the description-priority rules. [After isn't good enough; it comes too late.]

This is the table-debugging rule:
	if paragraph-debug-state is at least 1:
		repeat through the Table of Seen things:
			if the output subject entry is unmentioned:
				say "[output subject entry]: rank [current rank entry][line break]";
				now output subject entry is unmentioned;
			otherwise:
				say "[output subject entry]: rank [current rank entry] (already mentioned)[line break]";
		say "[line break]";

Room Description Control ends here.

---- Documentation ----

This extension is designed to help resolve certain challenges in Inform's default room description, allowing items to be more flexibly concealed and the order in which objects are mentioned to be fully controlled by the author. To do so, it replaces "the room description paragraphs about objects rule" from the carry out looking rules, and also the "describe contents entered into rule" from the report entering rulebook. The latter means that if the player gets into an enterable container and Inform generates a description of the other things in the container, that description will follow the rules for room descriptions.

Chapter: Room Description Control's Process

There are three stages to using Room Description Control.

Section: Concealment

(1) Concealment. Room description control allows the author to mark any visible item as "not marked for listing" before it reaches the later stages of room description, using description-concealing rules. Thus we might turn off mention of items on a high shelf like this:

	A description-concealing rule when the player is not on the chair:
		now every thing enclosed by the high shelf is not marked for listing. 

or make some objects invisible in certain circumstances:

	A description-concealing rule:
		if the diamond is in the glass, now the diamond is not marked for listing.

	A description-concealing rule when the player wears the peril-sensitive sunglasses:
		now every dangerous thing is not marked for listing.

After concealment, all remaining items -- that is, every visible thing except the player, the player's possessions, scenery objects, and items explicitly concealed -- are added to a Table of Seen Things.

Section: Sorting

(2) Sorting of objects. Next we are allowed to determine the order in which we would like items in a room description to appear in the Table of Seen Things. Room Description Control calls an object-based rulebook called the ranking rules to determine how items should be ranked. The higher an item's rank, the higher it will be sorted in the Table of Seen Things and the sooner in the room description it will appear. So for instance we might encourage Inform to mention people sooner than everyone else:

	A ranking rule for a person (called special-target): 
		increase the description-rank of the special-target by 10.

or to prefer items with initial appearance properties:
	
	Definition: a thing is initially-described if it provides the property initial appearance.

	A ranking rule for an initially-described thing (called special-target): 
		increase description-rank of the special-target by 5.

All the ranking rules are considered in sequence unless a rule explicitly succeeds or fails, so if we have multiple ranking rules applying to a single item, they will all be observed; description-ranks can thus be determined cumulatively.

Section: Reporting to the player

(3) Writing a paragraph about. Finally, Room Description Control goes through the Table of Seen Things and executes the Writing a paragraph about activity for each unmentioned item it finds there. (Things whose names have been printed earlier during the room description are thereafter marked "mentioned" and will not have their writing a paragraph about activity called. This emulates the default behavior of Inform.)

An item is considered to be "mentionable" when it is unmentioned and marked for listing.

This is where the burden falls on us to provide a set of writing a paragraph about activities that will produce the kind of output we want. This is not necessarily a minor undertaking.

Several possible collections of writing-a-paragraph rules are provided as sister extensions as of this writing:

The minimalist "Single Paragraph Description" combines all description of all items into a single paragraph. This is likely to be unattractive and unruly in all but the most spartan games, but it is provided in response to a specific author request.

"Ordinary Room Description" emulates as closely as possible the Inform default behavior while still relying on Room Description Control; this means that concealment and priority rules can be applied while otherwise retaining the look and feel of a game. Ordinary Room Description also makes use of the listing nondescript items activity.

"Tailored Room Description" is the most complex solution: it does away with parenthetical lists of contents and instead produces detailed full paragraphs.

If none of these suit, we may wish to craft our own set of writing a paragraph rules instead.


Note also that under this system, the activity of listing nondescript items becomes irrelevant.

An addendum about concealment. We may also find that we want TAKE ALL to attempt to take only items that are currently not concealed according to our concealment rules. We may in that case add the following bit to our code:

	Rule for deciding whether all includes something (called special-target):
		now every thing is marked for listing;
		follow the description-concealing rules;
		if the special-target is not marked for listing, it does not.

Chapter: Debugging and Background

Section: Debugging

A debugging verb PARAGRAPHS is provided. Turning PARAGRAPHS on will cause the description process to print out its table of seen things (with ranking numbers for all objects) before formulating the description.

Section: Changelog

	Version 14.0.220524: (Updated by Nathanael Nerode.)  Switch to Inform 10.1 version numbering.  Comments and whitespace fixes.  Shorten action names for paragraph debugging to avoid conflict and compile under 10.1.  Remove triple loop over all objects in favor of single loop over all objects.  Fix treatment of undescribed objects.  Reorganize Chaneglog.
	Version 14/210401: Improved paragraph debugging; comments and some style modernization.
	Version 14/210322: (Updated by Nathanael Nerode.) Name all rules so they can be replaced/removed by story authors.  Put Table of Seen Things in its own section so it can be overridden by authors.  Additional changes taken from Counterfeit Monkey version: Rename "output" column in Table of Seen Things to "output subject" column, to avoid conflicts.  Remove dependency on Complex Listing.
	Version 13/160517: Update to work with Inform 6M62. Remove dependency on Plurality.
	Version 12 does some cleanup and brings the extension in line with adaptive responses.
	Version 10 removes deprecated phrases.
	Version 8 adds a fix for bugs involving multiple identical objects, so that they will not each earn their own individual listings.
	Version 7 adds the don't mention things out of play rule; this means that if the author places some things in scope by hand, they will not be assumed to belong to the room description. This can be overridden by replacing or suspending the rule. Version 7 also adds section headings to the documentation.
	Version 6 updates to use "object-based rulebook" rather than "object-based-rulebook", as required by Inform 5G67, and also clears up a bug whereby an NPC entering an object could trigger a description of the location entered.
	Version 5 fixes a small but very annoying bug preventing proper release of finished game files. 
