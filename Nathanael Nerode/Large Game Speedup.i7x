Version 5/210325 of Large Game Speedup by Nathanael Nerode begins here.

"Performance improvements for games with large numbers of objects, by avoiding looping over all objects."

"based on the extension of the same name by Andrew Plotkin"

Use authorial modesty.

[This broke in 6M62, but it's still very important.  Updated by Nathanael Nerode.]

Chapter - Empty

[These adjectives are much faster than "if nothing is in..." or "if the number of things in ... is zero". (Note that the Standard Rules do not define "empty" on containers and supporters; these adjectives are Andrew Plotkin's invention.)]

Definition: a container is empty rather than non-empty if the first thing held by it is nothing.
Definition: a supporter is empty rather than non-empty if the first thing held by it is nothing.

Chapter - Mentioned

Section - Core Fast Functions

[We have to clear these flags for every thing, almost every turn. It's worth having a routine that skips I7's usual SetEitherOrProperty() mechanism and all its safety checks.]

To rapidly set all things not mentioned: (- OptimizedAllThingsUnsetMentioned(); -).
To rapidly set all things not marked for listing: (- OptimizedAllThingsUnsetWorkflag(); -).

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: OptimizedAllThingsUnsetMentioned
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ OptimizedAllThingsUnsetMentioned obj;
	for (obj=IK2_First: obj: obj=obj.IK2_Link) {
		give obj ~mentioned;
	}
];

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: OptimizedAllThingsUnsetWorkflag
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ OptimizedAllThingsUnsetWorkflag obj;
	for (obj=IK2_First: obj: obj=obj.IK2_Link) {
		give obj ~workflag;
	}
];
-) after "ListWriter.i6t".

This is the optimized declare everything unmentioned rule:
	rapidly set all things not mentioned;

Section - Replacing the Unmentioning Rules

[ Gets its own section for ease of overriding ]

The optimized declare everything unmentioned rule is listed instead of
	the declare everything initially unmentioned rule
	in the startup rulebook.

[Not clear that this one is *desirable*, even though it's in the standard rules: a bit redundant]
The optimized declare everything unmentioned rule is listed instead of
	the declare everything initially unmentioned rule
	in the turn sequence rulebook.

The optimized declare everything unmentioned rule is listed instead of
	the declare everything unmentioned rule
	in the carry out looking rulebook.

Chapter - Table of Locale Priorities

Section - Table Sort Partial

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: TableSortPartial
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Sort the first N rows of a table, rather than the whole thing. The rest
! of the table is untouched. Blank rows are sorted down to position N (not
! to the very end).
[ TableSortPartial tab rows col dir test_flag algorithm i j k f;
	for (i=1:i<=tab-->0:i++) {
		j = tab-->i; ! Address of column table
		if ((j-->1) & TB_COLUMN_DONTSORTME)
			return RunTimeProblem(RTP_TABLE_CANTSORT, tab);
	}
	if (col >= 100) col=TableFindCol(tab, col, false);
	k = rows; ! Not the entire table
	k = TableMoveBlanksToBack(tab, 1, k);
	if (test_flag) {
		print "After moving blanks to back:^"; TableColumnDebug(tab, col);
	}

	SetSortDomain(TableSwapRows, TableCompareRows);
	SortArray(tab, col, dir, k, test_flag, algorithm);

	if (test_flag) {
		print "Final state:^"; TableColumnDebug(tab, col);
	}
];
-) after "Sort" in "Tables.i6t".

To sort (T - table name) up to row (N - number) in (TC - table column) order
        (documented at ph_sortcolumn):
        (- TableSortPartial({T}, {N}, {TC}, 1); -).

Section - Set locale priority by building partial table (for use without Room Description Control by Emily Short)

[Room Description Control never hits any of this code so don't bother fixing it.]

[We never want to search (or sort) through the entire Table of Locale Priorities, so we manually keep track of the number of "live" rows. We'll also avoid use of the I7 notion of blank rows. Unused rows will be marked by "nothing" in the object column.]
The locale-table-count is a number that varies.

[This replacement phrase is heavily optimized. It behaves the same as the standard version, except that deleted rows get "nothing" in the object column instead of being marked blank.]
To set the/-- locale priority of (O - an object) to (N - a number):
	[say "[bracket][O] - [N][close bracket]";]
	if O is a thing:
		if N <= 0, now O is mentioned;
		[search the active part of the table for O; also note the first null row]
		let blanknum be 0;
		repeat with I running from 1 to locale-table-count:
			choose row I in the Table of Locale Priorities;
			let ent be the notable-object in row I of  the Table of Locale Priorities;
			if the notable-object entry is nothing:
				if blanknum is 0:
					now blanknum is I;
				next;
			if the notable-object entry is O: [ found it ]
				if N > 0: [change the existing row]
					now the locale description priority entry is N;
				else: [delete the existing row, by putting in "nothing"]
					now the notable-object entry is nothing;
					now the locale description priority entry is 32767; [Max size for Z-machine and probably large enough]
				stop; 
		if N > 0: [didn't find it, but it should be mentioned]
			if blanknum is 0: [add a new row]
				increment locale-table-count;
				choose row locale-table-count in the Table of Locale Priorities;
			else: [use the found null row]
				choose row blanknum in the Table of Locale Priorities;
			now the notable-object entry is O;
			now the locale description priority entry is N;

The optimized initialise locale description rule is listed instead of the initialise locale description rule in the before printing the locale description rulebook.
Before printing the locale description
	(this is the optimized initialise locale description rule):
	now the locale paragraph count is 0;
	now the locale-table-count is zero.   [Mark the table as empty without blanking every single row]

The optimized interesting locale paragraphs rule is listed instead of the interesting locale paragraphs rule in the for printing the locale description rulebook.
For printing the locale description
	(this is the optimized interesting locale paragraphs rule):
	sort the Table of Locale Priorities up to row locale-table-count in locale description priority order;
	repeat with I running from 1 to locale-table-count:
		choose row I in the Table of Locale Priorities;
		if the notable-object entry is not nothing:
			carry out the printing a locale paragraph about activity with the notable-object entry;
	continue the activity.

The optimized you-can-also-see rule is listed instead of the you-can-also-see rule in the for printing the locale description rulebook.
For printing the locale description
	(this is the optimized you-can-also-see rule):
	let the domain be the parameter-object; [Sadly "of something (called domain)" breaks the rule.  No idea why.]
	let the mentionable count be 0;
	let the marked count be 0;
	rapidly set all things not marked for listing;  [loops through all things]
	repeat with I running from 1 to locale-table-count:
		choose row I in the Table of Locale Priorities;
		[ say "[the notable-object entry] - [the locale description priority entry]."; ]
		if the notable-object entry is not nothing:
			increase the mentionable count by 1;
			if the locale description priority entry is greater than 0 and the notable-object entry is not mentioned:
				now the notable-object entry is marked for listing;
				increase the marked count by 1;
	if the mentionable count is greater than 0:
		[note that mentioned things have not been marked for listing]
		begin the listing nondescript items activity with the domain;
		if the marked count is 0:
			abandon the listing nondescript items activity with the domain;
		otherwise:
			if handling the listing nondescript items activity with the domain:
				let the common holder be nothing;
				let contents form of list be true;
				[ Determine whether we can use the optimized contents form first ]
				repeat with I running from 1 to locale-table-count:
					let list item be the notable-object in row I of the Table of Locale Priorities;
					if list item is nothing or list item is not marked for listing:
						next;
					if the holder of the list item is not the common holder:
						if the common holder is nothing:
							now the common holder is the holder of the list item;
						otherwise:
							now contents form of list is false;
					if the list item is mentioned:
						[Should never reach this, but doesn't hurt]
						now the list item is not marked for listing;
				if the domain is the location:
					say "[We] " (A);
				otherwise if the domain is a supporter or the domain is an animal:
					say "On [the domain] [we] " (B);
				otherwise:
					say "In [the domain] [we] " (C);
				if the locale paragraph count is greater than 0:
					say "[regarding the player][can] also see " (D);
				otherwise:
					say "[regarding the player][can] see " (E);
				filter list recursion to unmentioned things;
				if contents form of list is true and the common holder is not nothing:
					list the contents of the common holder, as a sentence, including contents,
						giving brief inventory information, tersely, not listing
						concealed items, listing marked items only;
				otherwise:
					say "[a list of marked for listing things including contents]"; [loops through all things]
				unfilter list recursion;
				if the domain is the location:
					say " here";
				say ".[paragraph break]";
			end the listing nondescript items activity with the domain;
	continue the activity.

Chapter - Improved WriteListFrom

[This replacement is more efficient in the common cases of ObjectTreeIterator and MarkedListIterator.]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: ListFilterContents
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Set/clear the list_filter_permits attribute, by using list_filter_routine.
! Do this recursively on the object and its contents (if any).
[ ListFilterContents a o;
	if ((list_filter_routine) && (list_filter_routine(a) == false))
		give a ~list_filter_permits;
	else
		give a list_filter_permits;
		
	objectloop (o in a) {
		ListFilterContents(o);
	}
];

! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: replacement for WriteListFrom in ListWriter.i6t
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ WriteListFrom first style depth noactivity iter i a ol;
	@push c_iterator; @push c_style; @push c_depth; @push c_margin;
    if (iter) c_iterator = iter; else c_iterator = ObjectTreeIterator;
    c_style = style; c_depth = depth;
	c_margin = 0; if (style & EXTRAINDENT_BIT) c_margin = 1;

	! Set or clear the list_filter_permits flag. Try to do it efficiently.
	if (c_iterator == ObjectTreeIterator) {
		! For the tree iterator, we follow the tree.
		for (a = first : a : a = sibling(a)) {
			ListFilterContents(a);
		}
	}
	else if (c_iterator == MarkedListIterator) {
		! For the list iterator, we follow the list.
		for (i=0: i<MarkedObjectLength: i++) {
			a = MarkedObjectArray-->i;
			ListFilterContents(a);
		}
	}
	else {
		! The sad inefficient old way -- loops through all objects.
		! (We don't bother with recursion because we're hitting all objects
		! anyway.)
		objectloop (a ofclass Object) {
			if ((list_filter_routine) && (list_filter_routine(a) == false))
				give a ~list_filter_permits;
			else
				give a list_filter_permits;
		}
	}

    first = c_iterator(first, depth, 0, START_ITF);
	if (first == nothing) {
		if (style & ISARE_BIT ~= 0) LIST_WRITER_INTERNAL_RM('W'); else LIST_WRITER_INTERNAL_RM('Y');
        if (style & NEWLINE_BIT ~= 0) new_line;
    } else {
		if ((noactivity) || (iter)) {
			WriteListR(first, c_depth, true);
			say__p = 1;
		} else {
			#ifndef STATIC_OBJECT_GROUPING;
			! loops through all objects
			objectloop (ol provides list_together) 
				BlkValueCopy(ol.list_together, EMPTY_TEXT_VALUE);
			#endif; ! STATIC_OBJECT_GROUPING
			CarryOutActivity(LISTING_CONTENTS_ACT, parent(first));
		}
	}

    @pull c_margin; @pull c_depth; @pull c_style; @pull c_iterator;
];
-) instead of "WriteListFrom" in "ListWriter.i6t".

Chapter - Faster Listing Phrases

[Add a set of "say the list of..." phrases that are more efficient for the common case of a container/supporter.]

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: WriteListOfMarkedContentsObjects
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
[ WriteListOfMarkedContentsObjects style common_parent
	obj first length;

	objectloop (obj in common_parent && obj has workflag2) {
		length++;
		if (first == nothing) { first = obj; }
	}

	if (length == 0) {
		if (style & ISARE_BIT ~= 0) LIST_WRITER_INTERNAL_RM('W');
		else if (style & CFIRSTART_BIT ~= 0) LIST_WRITER_INTERNAL_RM('X');
		else LIST_WRITER_INTERNAL_RM('Y');
	} else {
		@push MarkedObjectArray; @push MarkedObjectLength;
		MarkedObjectArray = RequisitionStack(length);
		MarkedObjectLength = length;
		if (MarkedObjectArray == 0) return RunTimeProblem(RTP_LISTWRITERMEMORY); 

		! common_parent is always set
		ObjectTreeCoalesce(child(common_parent));
		length = 0;
		objectloop (obj in common_parent) ! object tree order
			if (obj has workflag2) MarkedObjectArray-->length++ = obj;

		WriteListFrom(first, style, 0, false, MarkedListIterator);

		FreeStack(MarkedObjectArray);
		@pull MarkedObjectLength; @pull MarkedObjectArray;
	}
	prior_named_list = length;
	return;
];
-) after "WriteListOfMarkedObjects" in "ListWriter.i6t".

To say a list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT, {parent});
	 -).
To say A list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+CFIRSTART_BIT, {parent});
		 -).
To say list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+NOARTICLE_BIT, {parent});
		 -).
To say the list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+DEFART_BIT, {parent});
		 -).
To say The list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+DEFART_BIT+CFIRSTART_BIT, {parent});
		 -).
To say is-are a list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+ISARE_BIT, {parent});
		 -).
To say is-are list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+ISARE_BIT+NOARTICLE_BIT, {parent});
		 -).
To say is-are the list of (OS - description of objects) *in (parent - object):
	(-
		objectloop ({-my:1} in {parent}) if ({-matches-description:1:OS})
		give {-my:1} workflag2; else give {-my:1} ~workflag2;
		WriteListOfMarkedContentsObjects(ENGLISH_BIT+DEFART_BIT+ISARE_BIT, {parent});
		 -).

Chapter - Part Of

to decide which thing is the/-- first component of (obj - an object):
	(- ({obj}.component_child) -);

to decide which thing is the/-- next component after (obj - an object):
	(- ({obj}.component_sibling) -);

to decide which list of objects is the/-- list of components of (obj - an object):
	let L be a list of objects;
	let item be the first component of obj;
	while item is not nothing:
		add item to L;
		let item be the next component after item;
	decide on L;

Chapter - Static Object Grouping

[This is *untested* in 6M62.]

Use static object grouping translates as (- Constant STATIC_OBJECT_GROUPING; -). 

The initially listing contents rules are a rulebook.

When play begins (this is the initially list contents rule):
	if the static object grouping option is active:
		follow the initially listing contents rules.

To initially group (OS - description of objects) together: (- InitiallyGroupTogether({OS}, {-list-together:unarticled}); -).
To initially group (OS - description of objects) together giving articles: (- InitiallyGroupTogether({OS}, {-list-together:articled}); -).
To initially group (OS - description of objects) together as (T - text): (- InitiallyGroupTogether({OS}, {-by-reference:T}); -).

Include (-
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! Large Game Speedup: InitiallyGroupTogether
! ==== ==== ==== ==== ==== ==== ==== ==== ==== ====
! We've commented out the code in WriteListFrom that clears the list_together flag.
! It is set to the empty text for all objects at the beginning of the game, however, because of the way default values work.
! We set all the real list_together connections here at the beginning of the game.
[ InitiallyGroupTogether desc func  obj;
	obj = nothing;
	while (obj = desc(-2, obj)) {
		obj.list_together = func;
	}
];
-).

Large Game Speedup ends here.

---- DOCUMENTATION ----

Chapter - The Problem

Inform's Standard Rules take some shortcuts which are acceptable for most games, but which become inefficient in very large games. In particular, the "look" action can take several times longer than necessary.

If your game has less than a hundred things, you probably don't need this extension.  (It won't hurt, though.) The problems we're talking about arise when the game has four or five hundred things defined.

(Of course, if you have hundreds of things *in one room*, that will always be slow! And this extension does not address the problem of having big slow "every turn" rules. This is purely about the "look" action, and some related phrases that print lists.)

The problem, in brief, is code such as

	now all things are not mentioned;

or

	repeat through all things:

(Or the Inform 6 equivalents.) The Standard Rules have such code in a few places. This extension removes some (though not all) of these.

You may need this extension even with 50 things if your code is hitting the loops repeatedly.  For instance, my (Nathanael Nerode's) initial implementation of a clothing system ran a loop over all objects *inside* another loop over all objects, and did so 4 times every turn.  This extension reduces this double loop to looping over the (generally short) list of relevant objects.

Chapter - The Solutions

Section - Empty

We define an efficient "empty" adjective for containers and supporters. The Standard Rules do not define this, and it's tempting to use idioms such as "if nothing is in the box" or "if the number of things in the box is zero". These are slow. The "if the box is empty" term defined here is fast.

(If you have defined an "empty" term for your containers or supporters, this extension will conflict with it. Sorry.)

Section - Locale Description

We improve the code that handles the Table of Locale Priorities. (Which is defined as having a blank row for each thing in the game.) It no longer has to repeat through or sort the entire table; it just deals with as many rows as needed to manage the current room.

Section - ListWriter

We improve the I6 list writer. Again, this removes most of the places where the code was iterating through all objects.

We define more efficient "to say the list of..." phrases. One often writes phrases like

	say the list of things in the fridge;
	say a list of people on the sofa;

Despite their appearance, these wind up iterating through the entire universe, not just the container or supporter in question. This extension defines fast alternatives:

	say the list of things *in the fridge;
	say a list of people *in the sofa;

The star indicates that the "*in" phrase is mandatory, and understood as a parent object to iterate through. (Note that it is "*in", not "*on", even for supporters.)

Section - Parts

You'd think that a phrase like
	list of things which are part of the stove

would be quick... but again, it runs through every object in the entire game universe.

As a more efficient substitute, we provide:
	the/-- list of components of (main thing - an object)

Also, for some reason, Inform 7 doesn't provide iterators for the component "parts of" tree hierarchy.  This fills that gap.  We define:
	the/-- first component of (main thing - an object)
	the/-- next component after (other component - an object)

These are used in exactly the same way as the existing Inform 7 phrases:
	the/-- first thing held by (holder - an object)
	the/-- next thing held after (held item - an object)

Section - Static Object Grouping

Static object grouping is UNTESTED in Inform 6M62 and may not work.

Finally, we define an alternate way to group objects in lists. The Standard Rules recompute object grouping every time a list is printed. But in most games, object groups are fixed -- perhaps the Tarot cards are one group, the Scrabble tiles are another group, and so on. So it's possible to compute this once, when the game begins, and then leave it alone.

Because this alternate plan is less flexible, it doesn't happen automatically. You have to invoke it by defining an option:

	Use static object grouping.

You must then modify all your "Before listing contents..." grouping rules. If you have a rule such as

	Before listing contents:
		group Tarot cards together.

...change it to:

	Rule for initially listing contents:
		initially group Tarot cards together.

Do *not* use the standard "group X together" phrases when static option grouping is on; always use the "initially group X together" form. (The "...giving articles" and "...as (text)" variants are available.) And don't do either in a "before listing contents" rule. Move all of this logic to a "rule for initially listing contents".

Chapter - Changelog

Version 5/210325 added more section subdivision and reommitted some unnecessary code when Room Description Control is active.
Version 5/210324 reverted the changes from 5/210322 as they caused unexpected errors.
Version 5/210323 adopted the Inform 6M62-safe code for the *in phrases from the version in Counterfeit Monkey by Andrew Plotkin, solving a glaring bug which I didn't catch since I didn't test the more complicated invocations of those phrases.
Version 5/210322 was updated by Nathanael Nerode to omit unnecessary code when working with Room Description Control by Emily Short.
Version 5/171007 of Large Game Speedup was updated by Nathanael Nerode, adding the "Parts" section.
Version 5/171006 of Large Game Speedup was updated by Nathanael Nerode for Inform 6M62 and the responses system.  Code was simplifed by using the "choose row I in Table" syntax.
Version 4/140731 of Large Game Speedup was written by Andrew Plotkin for Inform 6G60 and was not tested with earlier or later releases.

Example: ** Four Hundred Things - A small game with a lot of stuff.

This game contains 400 offstage objects. (We build these 50 at a time, because the compiler refuses to create hundreds at once.) It demonstrates the "static object grouping" option, and the fast idiom for listing contents.

How much does this improve performance? I tested the example below with and without Large Game Speedup. (When removing the extension, I added a definition "a supporter is empty if nothing is on it." I also changed the "*in" and "initially listing" rules back to their standard forms.)

For each command, I list the number of Glulx VM opcodes and the time taken by the command in two interpreters (Glulxe in C, Quixe in JS). Tests on a 2.7GHz iMac.

	LOOK in Kitchen:
	without: 1013460 cycles (103.647 ms C, 1918 ms JS)
	with: 77386 cycles (20.791 ms C, 193 ms JS)

	JUMP
	without: 54474 cycles (18.451 ms C, 117 ms JS)
	with: 43752 cycles (16.606 ms C, 103 ms JS)

	EXAMINE MIRROR in Kitchen
	without: 75159 cycles (20.602 ms C, 178 ms JS)
	with: 45975 cycles (17.757 ms C, 104 ms JS)

	LOOK in Game Room
	without: 1025383 cycles (105.147 ms C, 1844 ms JS)
	with: 105354 cycles (22.663 ms C, 193 ms JS)

As you see, a lag of nearly two seconds (in the Javascript interpreter) is cut to a fraction of a second.


	*: "Four Hundred Things"

	Include Large Game Speedup by Andrew Plotkin.

	Use static object grouping.

	The player carries the bar of soap.

	The Kitchen is a room. "You're in the Kitchen. The Bathroom is east, and the Game Room is south."

	The table is a fixed in place supporter in the Kitchen.
	The description is "The table only shows up in the room description if something is on it."

	The backpack is a container in the Kitchen.
	Understand "back", "pack" as backpack.
	The book is in the backpack.

	Rule for writing a paragraph about the table:
		now the table is mentioned;
		if the table is not empty:
			say "A table stands here. On it [is-are a list of things *in the table]."

	The apple is in the Kitchen.
	The wedge of cheese is on the table.

	The mirror is in the Kitchen. "A portable mirror stands to one side."

	Check examining the mirror:
		instead say "In the mirror you see [a list of things *in the location]."
	Check searching the mirror:
		instead try examining the mirror.

	The Bathroom is east of the Kitchen. "This is the Bathroom. If you drop the soap here, you won't be able to see it. (Except in the mirror.)"

	The counter is a scenery supporter in the Bathroom.
	The description is "This is an ordinary scenery supporter."

	After choosing notable locale objects for the Bathroom:
		set the locale priority of the soap to 0.

	The Game Room is south of the Kitchen. "Games are piled around you."

	A piece is a kind of thing. The king, the pawn, the rook, and the bishop are pieces.
	All pieces are in the Game Room.
	A card is a kind of thing. The jack, the trey, and the ace are cards.
	All cards are in the Game Room.

	Rule for initially listing contents:
		initially group pieces together as "chess pieces";
		initially group cards together.

	Before grouping together cards: 
		say "[listing group size in words] playing cards (". 
	After grouping together cards: 
		say ")".

	Instead of jumping:
		say "You jump up and see all the rooms: [the list of rooms]."

	A clone is a kind of thing.
	There are 50 clones.
	There are 50 clones.
	There are 50 clones.
	There are 50 clones.
	There are 50 clones.
	There are 50 clones.
	There are 50 clones.
	There are 50 clones.

	Test me with "jump / get cheese, mirror / look / get apple / east / drop soap / put apple on counter / look / look in mirror / w / s / drop all / look".

