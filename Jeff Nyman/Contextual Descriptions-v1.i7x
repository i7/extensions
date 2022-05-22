Version 1.3 of Contextual Descriptions by Jeff Nyman begins here.

"Provides a mechanism for contextually shifting descriptions."

Part - Impressions

Impressions is an action applying to nothing.
Understand "impressions" as impressions.

Carry out impressions:
	let the current location be the location of the player;
	now the current location is unvisited;
	try looking.

Part - Location Summary

To say a/an lowercase (item - an object):
	let T be "[an item]";
	say "[T in lower case]".

To say the lowercase (item - an object):
	let T be "[the item]";
	say "[T in lower case]".

A room has some text called the unvisited summary.
The unvisited summary of a room is usually "[a lowercase item described]".

A room has some text called the visited summary.
The visited summary of a room is usually "[the lowercase item described]".

To say summarize (the place - a room):
	if the place is visited, say the visited summary of the place;
	otherwise say the unvisited summary of the place.

Contextual Descriptions ends here.

---- DOCUMENTATION ----

This extension allows for contextually shifting descriptions for rooms. What that means is simply that how a room is described in some particulars may differ based on what the protagonist has seen. The underlying idea here is that how we "describe" a location to others or even to ourselves would differ if this is the first time we're seeing the location versus seeing it again at a different time.

To this end, the extension provides a "visited summary" and "unvisited summary" to be applied to rooms. These are what can be displayed after the initial impressions (description) has been shown.

It's quite possible, of course, for someone to re-think about their first impressions or, in the context of a story, the player may want to recover that full description. The "impressions" action allows the player to recover that initial description. It's necessary to provide an action like this because a generic "look" might not do it if the room description uses constructs like "[if unvisisted]".

Example: * A Walk Through the Park

	*: "A Walk Through the Park"

	Include Contextual Descriptions by Jeff Nyman.

	Palace Gate is a room. "[if unvisited]Palace Gate is a street running north to south leading up to Kensington Gardens. It was previously part of the Gloucester Road, which is just to the south. According to the guidebook, Gloucester Road was named after Maria, Duchess of Gloucester and Edinburgh who apparently built a house there in 1805.[else]This is the Palace Gate street, leading into Kensington Gardens, with the north taking you to [summarize the Broad Walk] and east taking you to [summarize the Flower Walk]."

	Broad Walk is a room. "A brooding statue of Queen Victoria faces east, where the waters of the Round Pond sparkle in the afternoon sun. Your eyes follow the crowded Broad Walk north and south until its borders are lost amid the bustle of perambulators. Small paths curve northeast and southeast between the trees."

	The unvisited summary of the Broad Walk is "what appears to be the crowded Broad Walk".

	The visited summary of the Broad Walk is "what you have seen is the very crowded Broad Walk".

	Flower Walk is a room. "Gaily colored flower beds line the walks bending north and west, filling the air with a gentle fragrance. A little path leads northeast, between the trees.[paragraph break]The spires of the Albert Memorial are all too visible to the south. Passing tourists hoot with laughter at the dreadful sight; nannies hide their faces and roll quickly away."

	The unvisited summary of the Flower Walk is "what appears to be the slightly less crowded Flower Walk".

	The visited summary of the Flower Walk is "what you have seen is the slightly less crowded Broad Walk".

	Broad Walk is north of Palace Gate.
	Flower Walk is east of Palace Gate.

	Test me with "look / north / south / impressions / east / west".

The test in the example will let you see how the description changes based on what locations you have visited. Specifically the summary of the Broad Walk and the Flower Walk, as described from the Palace Gate, will change depending on whether or not you have visited the locations. The use of "impressions" allows you to recover the full description of a location that has text gated by a visited/unvisited condition.
