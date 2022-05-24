Version 1.0.220523 of Room Description Supporter Bugfixes by Nathanael Nerode begins here.

"Fixes some issues in Standard Rules related to printing room descriptions with enterable supporters."

Include Large Game Speedup by Nathanael Nerode. [For rapid unmentioning.]

Section - List the player's supporter

[ List the supporter even if you're in it. ]
The don't mention player's supporter in room descriptions rule is not listed in any rulebook.

[ No, *really* list the supporter and containers you're in.
  The problem here is that mentioning the bed in the room title makes the game think that it's already been mentioned;
  which causes its paragraph to not trigger.
]
Carry out looking (this is the unmention things mentioned in room heading rule):
  rapidly set all things not mentioned;
  continue the action.

The unmention things mentioned in room heading rule is listed before the room description body text rule in the carry out looking rulebook.

Section - Describing Things On Supporters

[ Note on speed.  Most "repeat" clauses -- those with an "in" or "on" -- use the fast objectloop,
  which only iterates over the objects in one object.  Thankfully. ]

[ We wish to invoke the "write a paragraph for" code. 
  So, this rather clever hack pulls out the rule which calls "write a paragraph for" so it can be reused, and gives it its own rulebook.  You can "follow" a rulebook, though not a bare rule.]

Items on supporters paragraph production is an object-based rulebook.
The offer items to writing a paragraph about rule is listed in items on supporters paragraph production.

[ This is the section which says "On the tabletop are..."
  This extracts common text which is repeated multiple times in Standard Rules -- and then *fixes it*.  It now properly avoids saying "On the dresser is nothing."
	This is a good example of how to write a subroutine in the form of a rule, which is necessary in order to allow message substitutions in the subroutine. ]

Printing the on-list is an object-based rulebook.

Printing the on-list of a thing (called item) (this is the on-the-supporter-are rule):
	let residuals be false;
	repeat with subitem running through things on the item:
		if the subitem is locale-supportable and the item does not conceal the subitem:
			now the subitem is marked for listing;
			now residuals is true;
		otherwise:
			now the subitem is not marked for listing;
	if residuals is true:
		[There is at least one subitem to report.]
		set pronouns from the item;
		increase the locale paragraph count by 1;
		say "On [the item] " (A);
		list the contents of the item, as a sentence, including contents,
			giving brief inventory information, tersely, not listing
			concealed items, prefacing with is/are, listing marked items only;
		say ".[paragraph break]";

[ OK, we have extracted all the places this loop is used. ]

[ These two are more specific ("about a supporter") than most of the rules ("about a thing")
  So they come first.  First offer to write-a-paragraph, then initial descriptions. ]

[ Fix initial appearance on supporters. TODO: This is not, in fact, done. ]

[ This bypasses the locale-supportable/concealed checks; your paragraph-writing routine
  must handle those. Same applies if the item wasn't on a supporter but was in the room.]
For printing a locale paragraph about a supporter (called the tabletop)
		(this is the describe what's on supporters in room descriptions with paragraphs rule):
	repeat with subitem running through things on the tabletop:
[		if the subitem is locale-supportable and the tabletop does not conceal the subitem, ]
		follow the items on supporters paragraph production rulebook for the subitem;
	continue the activity.

[This next one isn't changed at all, it's just code tidying.]
For printing a locale paragraph about a supporter (called the tabletop)
		(this is the fixed initial appearance on supporters rule):
	repeat with item running through things on the tabletop:
		if the item is not handled
				and the item provides the property initial appearance
				and the initial appearance of the item is not ""
				and the item is not undescribed
				and the item is not a person:
			now the item is mentioned;
			say initial appearance of the item;
			say paragraph break;
	continue the activity.

The fixed initial appearance on supporters rule
	is listed instead of
	the initial appearance on supporters rule
	in the
	for printing a locale paragraph about rulebook.

The describe what's on supporters in room descriptions with paragraphs rule
	is listed before
	the fixed initial appearance on supporters rule
	in the
	for printing a locale paragraph about rulebook.

[ Fix initial appearance rule.]
[ This rule should be broken into two pieces, but it's not worth the work. ]

For printing a locale paragraph about a thing (called the item)
	(this is the fixed use initial appearance in room descriptions rule):
	if the item is not mentioned
			and the item is not handled
			and the item provides the property initial appearance
			and the initial appearance of the item is not "":
		increase the locale paragraph count by 1;
		say "[initial appearance of the item]";
		say "[paragraph break]";
		now the item is mentioned;
		follow the printing the on-list rulebook for item;
	continue the activity.

The fixed use initial appearance in room descriptions rule
	is listed instead of
	the use initial appearance in room descriptions rule
	in the
	for printing a locale paragraph about rulebook.

[ Fix scenery supporters. ]
For printing a locale paragraph about a thing (called the item)
		(this is the fixed describe what's on scenery supporters in room descriptions rule):
	if the item is scenery and the item does not enclose the player:
		follow the printing the on-list rulebook for item;
	continue the activity.

The fixed describe what's on scenery supporters in room descriptions rule
	is listed instead of
	the describe what's on scenery supporters in room descriptions rule
	in the
	for printing a locale paragraph about rulebook.

[ Fix mentioned supporters. ]
For printing a locale paragraph about a thing (called the item)
		(this is the fixed describe what's on mentioned supporters in room descriptions rule):
	if the item is mentioned 
			and the item is not undescribed
			and the item is not scenery
			and the item is a supporter
			and the item does not enclose the player:
		follow the printing the on-list rulebook for item;
	continue the activity.

The fixed describe what's on mentioned supporters in room descriptions rule
	is listed instead of
	the describe what's on mentioned supporters in room descriptions rule
	in the
	for printing a locale paragraph about rulebook.

Room Description Supporter Bugfixes ends here.

---- DOCUMENTATION ----

I do not currently recommend using this, but I am uploading it as documentation of both the problems in the Standard Rules and the minimally invasive solutions.  It is probably better to use a more comprehensive replacement of the room description rules; but this will do the minimum fix.

Suppose you have an enterable supporter in a room: say, a bed or tabletop.
Suppose it has a "rule for writing a paragraph about", giving it a special description.
Suppose you also have an item intended to sit on the bed -- like sheets.
Suppose they also have a "rule for writing a paragraph about".

In the Standard Rules, the following problems arise:

1. If you're in the bed, the description of the bed won't be printed, whether or not you have a special paragraph for it.  Even if you eliminate the rule which appears to prevent it, which this extension does, it will still be suppressed.  This is because the bed is marked as "mentioned" when it's printed in the header, as follows:

  Bedroom (in the bed)

This suppression may or may not be desirable.  (In the case of a bed with a special paragraph, probably not desirable!) This extension unmentions everything after printing the heading and before printing the room description, thus fixing this problem.

This behavior can be reverted to the Standard Rules behavior as follows:

	The unmention things mentioned in room heading rule is not listed in any rulebook.
	The don't mention player's supporter in room descriptions rule is listed before the don't mention scenery in room descriptions rule in the printing a locale paragraph about rulebook.
	
The second line is probably unnecessary, as that rule in Standard Rules is probably redundant.

2. Items on the bed will frequently be printed with an "On the bed are sheets." even if you have a special paragraph for them.  This is because the rule for printing the "On the bed are..." line may execute before the rule for printing special paragraphs.  This printing marks the items mentioned, suppressing the special paragraph.

This extension offers the items a chance to print their special paragraphs first, using the usual "write a paragraph about" activity.  Please note that it won't check concealment, mentionedness, etc.; if you want to, you should check

	if the item is locale-supportable and the tabletop does not conceal the item

Note that the Standard Rules define locale-supportable as follows:
	Definition: a thing (called the item) is locale-supportable if the item is not scenery and the item is not mentioned and the item is not undescribed.

This is hooked through the "items on supporters paragraph production" rulebook, so it can be disabled with:

	The offer items to writing a paragraph about rule is not listed in the items on supporters paragraph production rulebook

Unfortunately, things on the tabletop with special paragraphs will be listed before the tabletop itself.  This is a limitation of this architecture, which is why you may want to use Room Description Control by Emily Short instead.

3. The Standard Rules will sometimes print "On the bed is nothing."  Before printing the "On the bed are..." phrase, the standard rules check that something which is not scenery, not undescribed, and not already mentioned is on the bed.  But if that something is concealed, or gets mentioned mid-description, it won't be printed, ending up with the "nothing" result!  This extension fixes this by correctly counting the items to be listed before deciding whether to print a sentence.

Changelog:

	1.0.220523 - Update to Inform v10 version numbering.  No other changes.  Large Game Speedup had to be fixed, though.
	1/210315 - First version
