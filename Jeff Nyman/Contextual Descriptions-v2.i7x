Version 2.0 of Contextual Descriptions by Jeff Nyman begins here.

"Describes places differently depending on whether the player character has been there, and lets the player recall a place's first impression."

Part - Arrivals

[An arrival is the first time a room is described after the player character
has been somewhere else. Counting arrivals in the looking action, rather than in
going, means every way of arriving counts (walking, being moved by the story,
riding a vehicle), and looking around where you already are doesn't. Being in a
room without seeing it (in the dark, or shut inside something) isn't an
arrival; the arrival is when the room is first seen afterwards. This count
is the one notion of "been here" that the summaries below and my related
extension Description Decay both use.]

A room has a number called the arrival count. The arrival count of a room is usually 0.

The room last described is an object that varies. The room last described is nothing.

First carry out looking (this is the count arrivals rule):
	if the visibility level count is 0 or the visibility ceiling is not the location:
		now the room last described is nothing;
	otherwise if the location is not the room last described:
		increment the arrival count of the location;
		now the room last described is the location.

Definition: a room is newly arrived at if its arrival count is 1.
Definition: a room is revisited if its arrival count is greater than 1.

Part - Summaries

[How a room is referred to from elsewhere: a summary before the player character
has been there, and another once they have.]

A room has some text called the unvisited summary. The unvisited summary of a room is usually "[a item described]".
A room has some text called the visited summary. The visited summary of a room is usually "[the item described]".

To say summarize (the place - a room):
	if the arrival count of the place is 0, say the unvisited summary of the place;
	otherwise say the visited summary of the place.

[Lower-casing a whole name, available for summaries that want it. The default
summaries don't use it, because it would turn "Kensington Gardens" into
"kensington gardens".]
To say a/an lowercase (item - an object):
	let T be "[an item]";
	say "[T in lower case]".

To say the lowercase (item - an object):
	let T be "[the item]";
	say "[T in lower case]".

Part - Impressions

[Recalling the first impression of the place where the player character is. It is
a matter of memory, not of doing anything, so no time passes. The room is briefly
treated as unvisited, so that descriptions written with "[if unvisited]" show
their first-visit text; looking marks it visited again. It is not an arrival.]

Recalling first impressions is an action out of world. Understand "impressions" or "first impressions" as recalling first impressions.

Carry out recalling first impressions:
	now the location is unvisited;
	try looking.

Contextual Descriptions ends here.

---- DOCUMENTATION ----

This extension describes places differently depending on whether the player character has been there before. The idea is that we describe a place differently, to ourselves or to others, the first time we see it than when we come back to it.

Section: Arrivals

Every room has an "arrival count": how many times the player character has arrived there. An arrival is the first time a room is described after they've been somewhere else, however they got there: on foot, carried by a vehicle, or moved by the story. Looking around where they already are doesn't count, and neither does IMPRESSIONS (below). The room the story starts in has an arrival count of 1 as soon as the opening description is shown.

Two adjectives come with it:

	a room is "newly arrived at" when its arrival count is 1;
	a room is "revisited" when its arrival count is more than 1.

Description Decay uses the same count, so the two extensions agree about what "been here before" means.

Being in a room without seeing it, in the dark or shut inside something opaque, isn't an arrival either: the room isn't described. The arrival happens when the room is next seen, so a cellar first entered in the dark still gets its first-visit treatment when the light goes on.

A room moved into without a description being printed (for instance with "move the player to the Garden, without printing a room description") isn't counted until it is next described.

Section: Summaries

Each room has two summaries, for referring to it from somewhere else:

	the unvisited summary: before the player character has been there;
	the visited summary: once they have.

"[summarize (room)]" says whichever applies. For example:

	The description of the Hall is "A plain hall. The study, [summarize the Study], is east."

By default the unvisited summary is "[a item described]" and the visited one "[the item described]", so a room with a proper name is just named ("Broad Walk"). Give rooms summaries of their own when you want more:

	The unvisited summary of the Broad Walk is "what appears to be the crowded Broad Walk".
	The visited summary of the Broad Walk is "the very crowded Broad Walk".

The phrases "[a lowercase (object)]" and "[the lowercase (object)]" lower-case a whole name, for summaries that want it. They aren't the default, because they lower-case proper names too.

Section: Impressions

IMPRESSIONS (or FIRST IMPRESSIONS) recalls the first impression of the room the player character is in. It's needed because once a room has been seen, a plain LOOK may no longer show its first-visit text: descriptions written with "[if unvisited]" change, and Description Decay shortens them.

IMPRESSIONS takes no time, since it's an act of memory, and it doesn't count as an arrival.

Section: Changes from version 1

(1) Whether a room has been visited, for summaries, is now its arrival count rather than Inform's visited property. The two agree in ordinary play; the difference is that IMPRESSIONS no longer briefly changes it.

(2) The default summaries no longer lower-case the room's name.

(3) IMPRESSIONS takes no time (it is out of world), and FIRST IMPRESSIONS also works.

Example: * A Walk Through the Park - Summaries that change once a place has been visited, and recalling a first impression.

	*: "A Walk Through the Park"

	Include Contextual Descriptions by Jeff Nyman.

	Palace Gate is a room. "[if unvisited]Palace Gate is a street running north to south leading up to Kensington Gardens. It was previously part of the Gloucester Road, which is just to the south. According to the guidebook, Gloucester Road was named after Maria, Duchess of Gloucester and Edinburgh who apparently built a house there in 1805.[otherwise]This is the Palace Gate street, leading into Kensington Gardens, with the north taking you to [summarize the Broad Walk] and east taking you to [summarize the Flower Walk].[end if]"

	Broad Walk is a room. "A brooding statue of Queen Victoria faces east, where the waters of the Round Pond sparkle in the afternoon sun. Your eyes follow the crowded Broad Walk north and south until its borders are lost amid the bustle of perambulators. Small paths curve northeast and southeast between the trees."

	The unvisited summary of the Broad Walk is "what appears to be the crowded Broad Walk".
	The visited summary of the Broad Walk is "the very crowded Broad Walk".

	Flower Walk is a room. "Gaily colored flower beds line the walks bending north and west, filling the air with a gentle fragrance. A little path leads northeast, between the trees.[paragraph break]The spires of the Albert Memorial are all too visible to the south. Passing tourists hoot with laughter at the dreadful sight; nannies hide their faces and roll quickly away."

	The unvisited summary of the Flower Walk is "what appears to be the slightly less crowded Flower Walk".
	The visited summary of the Flower Walk is "the slightly less crowded Flower Walk".

	Broad Walk is north of Palace Gate.
	Flower Walk is east of Palace Gate.

	Test me with "look / north / south / impressions / east / west".

The first LOOK at Palace Gate shows its first-visit text. After a trip north and back, the description refers to the Broad Walk by its visited summary and to the Flower Walk, not yet visited, by its unvisited one. IMPRESSIONS brings back the first-visit text without any time passing, and the trip east and back changes the Flower Walk's summary too.
