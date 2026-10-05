Version 2.0 of Description Decay by Jeff Nyman begins here.

"Room descriptions that shorten as a place grows familiar: in full on the first arrival, then a summary, then nothing on arrival, while LOOK always describes the room."

Include Contextual Descriptions by Jeff Nyman.

Part - Description Decay

Section - One way to describe rooms

[This extension decides how much of a room's description to show, so Inform's
own description modes don't apply.]
Understand "superbrief" or "short" or "verbose" or "long" or "brief" or "normal" as a mistake ("Room descriptions here change as places become familiar, so the brief, verbose and superbrief modes aren't used.").

Section - Summary description

A room has some text called the summary description.

[Arrivals before this many show the summary; from this arrival on, arriving
shows no description at all. LOOK always shows one.]
The decay threshold is a number that varies. The decay threshold is usually 3.

Section - Describing the room

[How much to say, from the arrival count kept by Contextual Descriptions:
	the first arrival, or IMPRESSIONS: the full description;
	later arrivals, until the decay threshold: the summary;
	arrivals from the threshold on: nothing;
	LOOK, at any time: the summary.
A room without a summary uses its full description wherever a summary would go.
Darkness, and being inside something that blocks the view, are left to Inform's
own rule. The room's contents are always listed, and every later rule for
looking runs as usual.]

Carry out looking (this is the decaying room description body text rule):
	if the visibility level count is 0:
		follow the room description body text rule;
	otherwise if the visibility ceiling is the location:
		if the location is unvisited:
			print the location's description;
		otherwise if the current action is looking or the arrival count of the location < the decay threshold:
			if the summary description of the location is empty:
				print the location's description;
			otherwise:
				say "[summary description of the location][paragraph break]".

The decaying room description body text rule is listed instead of the room description body text rule in the carry out looking rules.

Description Decay ends here.

---- DOCUMENTATION ----

This extension lets a room's description "decay": it shortens as the player character comes to know a place. The first time they arrive, they get the full description. The next few times, they get a shorter summary. After that, arriving shows no description at all, just what's there. But LOOK always describes the room, because a player who asks to look should get an answer.

It uses Contextual Descriptions (which it includes) for its notion of having been somewhere: a room's arrival count. An arrival is the first time a room is described after the player character has been somewhere else, however they got there, so "been here before" means the same thing in both extensions.

Section: The stages

	First arrival: the full description.
	Later arrivals, up to the decay threshold: the summary description.
	Arrivals from the decay threshold on: no description; the room's contents are still listed.
	LOOK, at any time: the summary description.
	IMPRESSIONS (from Contextual Descriptions): the full description again.

The decay threshold is 3 by default, so the second arrival shows the summary and the third shows nothing. Change it for a slower or quicker decay:

	The decay threshold is 5.

Give a room a summary like this:

	The summary description of the Broad Walk is "The crowded Broad Walk."

A room without a summary uses its full description wherever the summary would appear, so it is described in full on every arrival before the threshold and at every LOOK.

Section: What is left alone

Only the room's own description decays. Its contents are listed as usual at every stage, and every other rule that runs when the player looks still runs. For example, World Knowledge marks what's in view as seen whatever stage the description is at.

Darkness is left to Inform's own rule, with its usual "It is pitch dark" message, and so is a view blocked by being inside something.

Section: Description modes

Because this extension decides how much of a room to describe, Inform's description modes (BRIEF, VERBOSE, SUPERBRIEF and their synonyms) are turned off, with a message saying why. Using this extension is a design choice: descriptions decay rather than staying in one mode.

Section: Changes from version 1

(1) Arrivals are counted the way Contextual Descriptions counts them, so arriving by any means counts, not only the player's own going action.

(2) A room without a summary is described in full at the summary stages. In version 1 it was described only once and then never again, even by LOOK.

(3) LOOK always describes the room. In version 1, LOOK in a room without a summary showed nothing after the first visit.

(4) Every other rule that runs on looking still runs. In version 1, describing a summary stopped them, so other extensions (World Knowledge, for one) missed those looks.

(5) Darkness uses Inform's own message.

(6) The point at which descriptions stop is now a setting, the decay threshold.

(7) Description Decay now includes Contextual Descriptions, which it needs for IMPRESSIONS and the arrival count.

Example: * Description of Diminishing Returns - A walk where descriptions shorten, a companion who follows, and a pram you push.

	*: "Description of Diminishing Returns"

	Include Description Decay by Jeff Nyman.

	A thing can be examined or unexamined. A thing is usually unexamined.

	After examining something:
		now the noun is examined.

	Palace Gate is a room. "Palace Gate is a street running north to south leading up to Kensington Gardens. It was previously part of the Gloucester Road, which is just to the south. According to the guidebook, Gloucester Road was named after Maria, Duchess of Gloucester and Edinburgh who apparently built a house there in 1805.[paragraph break]A tide of baby strollers -- or perambulators, as they call them here -- surges north along what becomes the crowded Broad Walk. Shaded glades stretch away to the northeast and a hint of color marks the western edge of what the guidebook says is the Flower Walk."

	The summary description of Palace Gate is "The Palace Gate street, leading into Kensington Gardens, with the north taking you to [summarize the Broad Walk] and east taking you to [summarize the Flower Walk]."

	The visited summary of Palace Gate is "the Palace Gate entrance to the park".

	Broad Walk is a room. "A brooding statue of Queen Victoria faces east, where the waters of the Round Pond sparkle in the afternoon sun. Your eyes follow the crowded Broad Walk north and south until its borders are lost amid the bustle of perambulators. Small paths curve northeast and southeast between the trees."

	The unvisited summary of the Broad Walk is "what appears to be the crowded Broad Walk".
	The visited summary of the Broad Walk is "the very crowded Broad Walk".

	Flower Walk is a room. "Gaily colored flower beds line the walks bending north and west, filling the air with a gentle fragrance. A little path leads northeast, between the trees.[paragraph break]The spires of the Albert Memorial are all too visible to the south. Passing tourists hoot with laughter at the dreadful sight; nannies hide their faces and roll quickly away."

	The summary description of Flower Walk is "The walk lined with flowers. Northwest leads to [summarize the Wabe]. West takes you to [summarize Palace Gate] and north takes you to [summarize Lancaster Walk]."

	The unvisited summary of the Flower Walk is "what appears to be the slightly less crowded Flower Walk".
	The visited summary of the Flower Walk is "the slightly less crowded Flower Walk".

	A soccer ball is in Flower Walk. The initial appearance of the soccer ball is "You can see a soccer ball half-hidden among the blossoms."

	Lancaster Walk is a room. "An impressive sculpture of a horse and rider dominates this bustling intersection. The Walk continues north and south; lesser paths curve off in many directions.[paragraph break]A broad field of grass, meticulously manicured, extends to the east. Beyond it you can see the Long Water glittering between the trees."

	The summary description of Lancaster Walk is "[if the sculpture is proper-named]The[otherwise]An[end if] impressive [sculpture] [if the sculpture is not proper-named]of a horse and rider [end if]is a focal point of the busy walk."

	The unvisited summary of Lancaster Walk is "what appears to be a long, crowded walkway".
	The visited summary of Lancaster Walk is "the crowded intersection of Lancaster Walk".

	A sculpture is in Lancaster Walk.

	The description of the sculpture is "[if unexamined]According to the plaque, the sculpture is called [italic type]Physical Energy[roman type]. According to the guidebook, it's the work of a British artist named George Frederic Watts. Apparently 'physical energy' is an allegory of the human need for new challenges, of our instinct to always be scanning the horizon, looking towards the future. A quote from the artist says that it's 'a symbol of that restless physical impulse to seek the still unachieved in the domain of material things'.[otherwise]The [italic type]Physical Energy[roman type] sculpture, which is basically a bronze statue of man on horseback.[end if]"

	Before examining the sculpture for the first time:
		now the printed name of the sculpture is "[italic type]Physical Energy[roman type] sculpture";
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

	Every turn:
		if the location of Floyd is not the location of the player:
			let the way be the best route from the location of Floyd to the location of the player;
			try Floyd going the way.

	Test me with "north / south / east / west / look / east / west / impressions / north / south / north".

The walk shows each stage. Palace Gate is described in full when the story starts. Going north, the Broad Walk is described in full too; it has no summary, so it will be described in full whenever a summary would appear. Back at Palace Gate, the second arrival shows its summary, which now calls the Broad Walk by its visited summary while the Flower Walk, not yet visited, keeps its unvisited one. After a trip east to the Flower Walk and back, the third arrival at Palace Gate shows no description at all, only what's there; LOOK then shows the summary. The second trip east does the same for the Flower Walk, and IMPRESSIONS back at Palace Gate brings back its full description without any time passing. Finally, the Broad Walk, which has no summary, is still described in full on its second arrival, and shows nothing on its third.

Floyd follows you around, and you can push the perambulator from room to room.
