Version 1.3 of Description Decay by Jeff Nyman begins here.

"Provides a mechanism for allowing description levels to change based on number of visits"

Part - Description Decay

Section - Do Not Allow Description Style Modes

Understand "superbrief" or "short" as a mistake ("Abbreviated room description modes are not used.").
Understand "verbose" or "long" as a mistake ("Unabbreviated room description modes are not used.").
Understand "brief" or "normal" as a mistake ("Sometimes abbreviated room description modes are not used.").

Section - Visited Count for Rooms

A room has a number called the visited-count.
The visited-count of a room is normally 0.

When play begins (this is the starting room increment visited-count rule):
	increment the visited-count of the location of the player.

Section - Summary Description

A room has some text called the summary description.

Section - Handle Looking

This is the modified room description body text rule:
	if in darkness:
		begin the printing the description of a dark room activity;
		if handling the printing the description of a dark room activity:
			say "It is entirely too dark to see anything.";
		end the printing the description of a dark room activity;
	otherwise:
		if the location is unvisited:
			if the description of the location is "":
				follow the room description paragraphs about objects rule;
				continue the action;
			otherwise:
				say "[the description of the location][paragraph break]";
		otherwise:
			if the visited-count of the location is less than 3:
				if the summary description of the location is "":
					follow the room description paragraphs about objects rule;
					continue the action;
				say "[the summary description of the location][paragraph break]";
				follow the room description paragraphs about objects rule instead;
			if the current action is looking:
				say "[the summary description of the location][paragraph break]".

The modified room description body text rule substitutes for the room description body text rule.

Section - Handle Descriptions as Part of Going

Carry out an actor going (this is the increase visited-count rule):
	if the actor is the player:
		if the visited-count of the location is less than 3:
			increment the visited-count of the location.

Description Decay ends here.

---- DOCUMENTATION ----

This extension allows for a room description to "decay" in a gradual way, based on how often the player has seen the location.

How this work is that the first time a room is gone to by the player, they will see the full description of the room. On the next time going to the room, the player will also see the description. However, you can provide a "summary description" for a room and if that is provided, this is what will always be used for the room's description the second time the player visits it.

The third time the player visits the room, they will see no description at all. (This is akin to "superbrief" mode.)

Of course, a "LOOK" command will always return the appropriate text of the location. However, the initial full description of the room is gated behind a check for whether the room is visited or unvisited. That means any subsequent looks will always rely on the summary description. You can use this extension with my Contextual Descriptions, which provides an "impressions" action that allows the player to recover the full text of the room.

Something to note is that the way this logic works, it entirely overrides the description styles that players can usually choose. There are unabbreviated room descriptions ("verbose", "long"), sometimes abbreviated room descriptions ("brief", "normal"), and abbreviated room descriptions ("superbrief", "short"). Using this extension means you want to control the display of descriptions by, in a sense, cycling through those various settings. In other words, by using this extension you are explicitly saying, as a design choice, you want the descriptions to "decay" rather than be in one mode.

Example: * Description of Diminishing Returns

	*: "Description of Diminishing Returns"

	Include Rideable Vehicles by Graham Nelson.
	Include Contextual Descriptions by Jeff Nyman.
	Include Description Decay by Jeff Nyman.

	A thing can be examined or unexamined.
	A thing is usually unexamined.

	After examining something:
		now the noun is examined.

	Palace Gate is a room. "Palace Gate is a street running north to south leading up to Kensington Gardens. It was previously part of the Gloucester Road, which is just to the south. According to the guidebook, Gloucester Road was named after Maria, Duchess of Gloucester and Edinburgh who apparently built a house there in 1805.[paragraph break]A tide of baby strollers -- or perambulators, as they call them here -- surges north along what becomes the crowded Broad Walk. Shaded glades stretch away to the northeast and a hint of color marks the western edge of what the guidebook says is the Flower Walk."

	The summary description of Palace Gate is "The Palace Gate street, leading into Kensington Gardens, with the north taking you to [summarize the Broad Walk] and east taking you to [summarize the Flower Walk]."

	The visited summary of Palace Gate is "the Palace Gate entrance to the park".

	Broad Walk is a room. "A brooding statue of Queen Victoria faces east, where the waters of the Round Pond sparkle in the afternoon sun. Your eyes follow the crowded Broad Walk north and south until its borders are lost amid the bustle of perambulators. Small paths curve northeast and southeast between the trees."

	The summary description of Broad Walk is "The statue of Queen Victoria looks out over the crowds as they bustle to various areas of the park."

	The unvisited summary of the Broad Walk is "what appears to be the crowded Broad Walk".
	The visited summary of the Broad Walk is "what you have seen is the very crowded Broad Walk".

	Flower Walk is a room. "Gaily colored flower beds line the walks bending north and west, filling the air with a gentle fragrance. A little path leads northeast, between the trees.[paragraph break]The spires of the Albert Memorial are all too visible to the south. Passing tourists hoot with laughter at the dreadful sight; nannies hide their faces and roll quickly away."

	The summary description of Flower Walk is "The walk lined with flowers. Northwest leads to [summarize the Wabe]. West takes you to [summarize Palace Gate] and north takes you to [summarize Lancaster Walk]."

	The unvisited summary of the Flower Walk is "what appears to be the slightly less crowded Flower Walk".
	The visited summary of the Flower Walk is "what you have seen is the slightly less crowded Broad Walk".

	A soccer ball is in Flower Walk.

	The initial appearance of the soccer ball is "You can see a soccer ball half-hidden among the blossoms."

	Lancaster Walk is a room. "An impressive sculpture of a horse and rider dominates this bustling intersection. The Walk continues north and south; lesser paths curve off in many directions.[paragraph break]A broad field of grass, meticulously manicured, extends to the east. Beyond it you can see the Long Water glittering between the trees."

	The summary description of Lancaster Walk is "[if the sculpture is proper-named]The[else]An[end if] impressive [sculpture] [if the sculpture is not proper-named]of a horse and rider [end if]is a focal point of the busy walk."

	The unvisited summary of Lancaster Walk is "what appears to be a long, crowded walkway".
	The visited summary of Lancaster Walk is "the crowded intersection of Lancaster Walk".

	A sculpture is in Lancaster Walk.

	The description of the sculpture is "[if unexamined][paragraph break]According to the plaque, the sculpture is called [italic type]Physical Energy[roman type]. According to the guidebook, it's the work of a British artist named George Frederic Watts. Apparently 'physical energy' is an allegory of the human need for new challenges, of our instinct to always be scanning the horizon, looking towards the future. A quote from the artist says that it's 'a symbol of that restless physical impulse to seek the still unachieved in the domain of material things'.[else]The [italic type]Physical Energy[roman type] sculpture, which is basically a bronze statue of man on horseback."

	Before examining the sculpture for the first time:
		now the printed name of the sculpture is "[italic type]Physical Energy[roman type] scultpure";
		now the sculpture is proper-named;
		say "Looking at the sculpture, you realize it has a plaque in front of it. [run paragraph on]".

	The Wabe is a room. "This grassy clearing is only twenty feet across, and, unless your eyes deceive, almost perfectly circular. Paths wander off in many directions through the surrounding thicket.[if unvisited][paragraph break]Oddly enough, this location doesn't appear in the guidebook at all.[end if]"

	The summary description of the Wabe is "The oddly circular clearing that the guidebook most definitely does not mention."

	The unvisited summary of the Wabe is "a part of the park that the guidebook doesn't seem to indicate".
	The visited summary of the Wabe is "the odd little area with the sundial".

	Broad Walk is north of Palace Gate.
	Flower Walk is east of Palace Gate.
	Lancaster Walk is north of Flower Walk.
	The Wabe is northeast of Palace Gate and northwest of Flower Walk.

	A person called Floyd is in Palace Gate.

	A perambulator is in Palace Gate.
	The perambulator is fixed in place and pushable between rooms.
	Understand "pram" as the perambulator.

	A bicycle is a rideable vehicle in Palace Gate.
	Understand "bike" as the bicycle.

	Every turn:
		if the location of Floyd is not the location of the player:
			let on the path be the best route from the location of Floyd to the location of the player;
			try Floyd going on the path.

	Test me with "north / south / east / west / look / impressions".

This example provides a lot of material and the raeson for that is try to include as many situations where the room description can change based on how it is setup, what is located in it, how the player gets to the room, and whether another character is tagging along. The best way to see this example in action is to play around with it, noting how the descriptions change.

This example is also combined with my Contextual Descriptions extension and I did that to make that both can work together.

The example test provided shows a few aspects. When the story first starts, you see the full description of the initial room (Palace Gate). The summarized aspects are showing the unvisited text.

Going north then provides the full description of the Broad Walk. There is summarized elements for this room.

Going south takes you back to Palace Gate and now you see that the summary description (rather than the full description) appears. The locale information continues to generate as expected. You can also note that the summarized text for Broad Walk shows while the summarized text for Flower Talk does not. This is because you have visited Broad Walk but you have not yet visited Flower Walk.

Going east takes you to the Flower Walk. As normal you get the full description and the locale generates correctly.

Going west now takes you back once again to Palace Gate. This time, crucially, NO description displays. The description has entirely decayed. This is because you have have seen the full description and the summary description. The locale displays as normal.

Finally, the last "look" comand shows that the description does display. Here this is the summary description. Notice too that since you have now visited BOTH the Broad Walk and Flower Walk, the summarized descriptions display.

If you wanted to recover the full description, you could use the "impressions" command. This is provided by Contextual Descriptions and makes sure that the initial impressions of the location can be recovered.
