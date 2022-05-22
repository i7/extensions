Version 1.2 of Optimized Epistemology by Andrew Plotkin begins here.

"Keeping track of what the player character knows and sees."

Book 1 - Sight

A thing can be either seen or unseen. A thing is usually unseen.

[It might seem more straightforward simply to write "Now everything visible in
the location is seen." but this turns out to be unacceptably slow in practice.

The original Epistemology extension uses "repeat with item running through things that are enclosed by the location: if the item is not enclosed by an opaque closed container: ..." This is better, but it still iterates over every thing in the game world, which is bad for very large games.

Instead, we use an I6 scope search. This only runs through items in the room, which is typically a much more manageable list.]

Carry out looking (this is the mark items as seen when looking rule):
	observe-all-in-scope.

Carry out opening a container (this is the mark items as seen on opening a container rule):
	observe-all-in-scope.

The mark items as seen on opening a container rule is listed after the
standard opening rule in the carry out opening rules.

Book 2 - Familiarity

Chapter 1 - Basic Familiarity

A thing can be familiar or unfamiliar. A thing is usually unfamiliar.

[Mark an item as both familiar and seen.]
To familiarize (T - thing) (this is familiarization):
	now T is familiar;
	now T is seen.

Carry out examining something visible (this is the mark items as seen on examining rule):
	familiarize the noun.

Definition: a thing is known rather than unknown if it is familiar or it is seen.

Chapter 2 - Subject (for use without Threaded Conversation by Emily Short)

A subject is a kind of thing. The specification of a subject is "Something
that conversations can refer to, but which has no real-world presence or
functionality."

Chapter 3 - Familiarity of Subjects

A subject is usually familiar.

Book 3 - The Nasty Bits

To observe-all-in-scope: (- ObserveScopeWithin(player); -).

Include (-

! Perform a scope search for the given actor, applying seen/familiar to every item reached.
! In this routine, ((+ familiarization +)-->1) is the I6 idiom for calling the I7 "familiarization" phrase.
[ ObserveScopeWithin obj;
	LoopOverScope(((+ familiarization +)-->1), obj);
];

-);

Book 4 - Testing commands - not for release

Requesting epistemic status of is an action out of world applying to one visible thing.

Understand "epistat [any thing]" as requesting epistemic status of.

Report requesting epistemic status of (this is the report epistemic status rule):
	say "[noun] - [if the noun is seen]seen[otherwise]unseen[end if] /
		[if the noun is familiar]familiar[otherwise]unfamiliar[end if] /
		[if the noun is known]known[otherwise]unknown[end if]." (A).

Optimized Epistemology ends here.

---- DOCUMENTATION ----

Foreword: This is an optimized version of Epistemology by Eric Eve (version 9). I created it for use in very large games (hundreds of objects), where the original code might detectably bog down. This version is meant as a drop-in replacement.

Like the original Epistemology, this version only marks objects "seen" when you look around, open a container, or examine something. (Or move to a different room, which invokes LOOK.) This means that objects which are moved into a room might not be "seen" until the player does LOOK or EXAMINE.

This version differs from the original in a couple of minor ways:

- When you open a container, all objects in the room (not just the container) are marked "seen". (This should be fine, since objects in the room should already have been seen when you walked in.)

- When you LOOK or OPEN, objects added to scope (with the "deciding the scope of" activity) are marked "seen". The original Epistemology did not do this.

- The phrase "familiarize (thing)" is provided to mark a thing as both "seen" and "familiar". You can also do "observe-all-in-scope" to re-scan the entire room.

If you want to be certain about marking every object that appears, you can add this rule, at the expense of some game speed:

Every turn: observe-all-in-scope.

--- ORIGINAL DOCUMENTATION ---

The purpose of this extension is to keep track of what objects the player character knows about, either because s/he has seen them, or because they are already familiar for some other reason. It is not intended as a way to track NPC knowledge, which might be better implemented using a system of relations.

When the Epistemology extension is used all game objects are either seen or unseen, either familiar or unfamiliar, and either known or unknown. By default, all objects start unseen and unfamiliar, and hence unknown (although we can of course change this for indivdual objects, groups of objects or kinds). The seen/unseen and familiar/unfamiliar pairs can be tested or set as requires. The known/unknown status may be tested but not directly changed in code, since it derives from the other two: a thing is considered to be known if it is either seen or familiar; otherwise it is unknown.

These distinctions are maintained since the player character may well know about things he or she is yet to see (such as the Magical Golden Golf Ball of Destiny that she has been sent to recover) or are which are in any case unseeable (such as love, freedom, democracy and inflation) which may nevertheless be the subject of conversation or thoughts. Things that are known about but as yet unseen or entities that are abstract can be marked as familiar, either from the outset, or when the player learns about them during the course of the game. Also, there may be cases where it's important to distinguish whether the player character has actually seen the Golden Golf Ball (say) or merely knows about it.

The new kind called subject is provided for more abstract objects such as love and atomic physics. Unlike other things, subjects are considered familiar by default.

As far as possible, the extension tries to keep track of what the player character has seen, first by marking as seen (and familiar) everything that's in plain view in the location when a LOOK command is executed, and second eveything in plain view within a container when that container is opened. The algorithm for doing this may be less than perfect (in the interests of acceptable speed), and there will be cases that it does not cover (for example when an object is moved into the location to simulate its being found under the rug); in such cases it will be necessary explicitly to change the newly-arrived object to seen in our code (if we need to keep track of it).

This extension also marks an object as both seen and familiar when it is examined (which should catch most, if not all, the cases not already covered).

Finally, the testing command EPISTAT X (not for release) is provided to aid testing and debugging games using this extension. For example the command EPISTAT GOLD BALL will show whether the gold ball is seen, familiar or known. This may be useful to help track whether the epistemic status of various objects in our game is actually what we think it should be. EPISTAT (derived from EPIstemic STAtus) is indeed a nasty non-word, but it has the merits of being (a) reasonably brief, (b) acceptably memorable and (c) unlikely to clash with any verbs defined in-game.

(With thanks to Aaron Reed for suggesting some optimization, which also led me to spot a bug.)

Example: * Contemplation - Thinking about things that are known

	*: "Contemplation"

	Include Optimized Epistemology by Andrew Plotkin.

	Part  1 - Thought Mechanics

	Thinking about is an action applying to one visible thing.

	Understand "think about [any thing]" as thinking about.
	Understand "think about [any known thing]" as thinking about.

	Report thinking about something unknown:
	  say "[no thoughts]"

	Report thinking about something known:
	  say "[the thought of the noun][paragraph break]"

	A thing has a text called thought.
	
	Pondering is an action applying to one topic.

	Understand "think about [text]" as pondering. [otherwise we get an ugly response to THINK ABOUT FOO etc.]

	Report pondering:
	  say "[no thoughts]"

	To say no thoughts:
	   say "You have no thoughts on that subject right now."

	Part  2 - Scenario

	The player wears a watch.

	The Study is a Room. "You deliberately keep this room as bare as possible, to prevent material objects distracting you from your thoughts. The two essential objects that remain are a comfortable armchair and the door out into the hall to the west."

	The comfortable armchair is an enterable scenery supporter in the Study. The description is "It's nothing special, but it looks comfortable enough." The thought is "You think it's a good place to sit and think."
	Understand "arm" or "chair" as the comfortable armchair.

	Report entering the armchair:
		instead say "You sit down and dream about golf."

	The hall door is an open openable scenery door. The hall door is west of the Study and east of the Main Hall. The thought is "Useful things, doors, you muse: without them it would be so much harder to get from room to room."

	The Golf Dream is scenery. The description is "You have long had a distant dream of playing golf in some paradisaical country club." The thought is "[description of the Golf Dream]".

	After deciding the scope of the player when the player is on the armchair:
		place the Golf Dream in scope.

	The Main Hall is a Room. "This place is almost as sparsely furnished as the Study which lies to the east."

	The large oak table is a supporter in the Main Hall. "A large oak table abuts one wall." The thought is "You've never given this table much thought, to be honest -- it's just a table, after all."

	A note is on the large oak table. The description of the note is "The note reads: 'To find fame, love, and everlasting happiness, you need to go on the quest of the Great Golden Golf Ball of Destiny.'"
	The thought of the note is "You [if we have examined the note]think it contains an interesting proposition[otherwise]wonder what it says[end if]. "

	Carry out examining the note: now the Great Golden Golf Ball of Destiny is familiar.

	Life is a subject. The thought is "You think [if the golden golf ball is familiar]it has just become a whole lot more interesting[otherwise]it's preferable to the alternative[end if]. "

	Liberty is a subject. The thought is "It's a fine word -- but a slippery concept."
	Understand "freedom" as liberty.

	Love is a subject. The thought is "You [if we have examined the note]think it might be worth questing to find it[otherwise]wonder where it is to be found[end if]. "

	Understand "fame" or "everlasting" or "happiness" as love.

	The Great Golden Golf Ball of Destiny is a thing. The thought is "You wonder what kind of object it can be to offer so much."

	The red box is an open container on the large oak table.
	The red ball is in the red box.

	The green box is a closed openable container on the large oak table.
	The green ball is in the green box.

	The glass box is a closed openable transparent container on the large oak table.
	The crystal ball is in the glass box.

	The widget is in the Main Hall.
	The button is part of the widget.
	
	The wallpaper is a backdrop. The wallpaper is in the Main Hall.

	Test me with "think about love/think about door/think about golden ball/think about note/think about table/think about life/epistat red ball/epistat green ball/w/think about table/think about note/read note/think about note/think about love/think about golden ball/think about life/epistat golden ball/epistat red ball/epistat green ball/open green box/epistat green ball".
