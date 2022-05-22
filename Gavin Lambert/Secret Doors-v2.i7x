Version 2 of Secret Doors by Gavin Lambert begins here.

"Doors and switches that cannot be acted upon until they are discovered."

"updated from Andrew Owen's original work"

A secret door is a kind of door.
A secret door can be revealed or unrevealed.
A secret door is unrevealed.
A secret door is scenery.
A secret door is closed.

A secret switch is a kind of thing.
A secret switch can be revealed or unrevealed.
A secret switch is unrevealed.
A secret switch is scenery.

To print the you can't go message:
	say "[text of can't go that way rule response (A)][line break]".

To print the you can't see message:
	say "[text of parser error internal rule response (E)][line break]".

Before going through a secret door which is unrevealed:
	print the you can't go message instead.
	
Rule for setting action variables for going (this is the going through secret doors rule):
	if the door gone through is an unrevealed secret door:
		now the door gone through is nothing;
		now the room gone to is nothing.
		
The going through secret doors rule is listed after the standard set going variables rule in the setting action variables rulebook.
The determine map connection rule is not listed in any rulebook.

Before doing something to a secret door which is unrevealed:
	print the you can't see message instead.

Before doing something when a secret door is the second noun and the second noun is unrevealed:
	print the you can't see message instead.

Before doing something to a secret switch which is unrevealed:
	print the you can't see message instead.

Before doing something when a secret switch is the second noun and the second noun is unrevealed:
	print the you can't see message instead.

Secret Doors ends here.

---- DOCUMENTATION ----

Secret Doors is an extension which provides robust support for hidden
doors and hidden switches.  It was originally written by Andrew Owen,
but has had minor changes in order to make it compatible with Inform 7 build 6L02.

Version 2 adds a fix that allows "going nowhere" rules to apply to unrevealed secret doors as well.

It creates two new kinds: "secret door" (a
kind of door) and "secret switch" (a kind of thing) with the properties
"revealed" or "unrevealed".

	The passage door is a secret door.
	The passage door is west of the Big Cave and east of the Secret
Passage.

	The hidden lever is a secret switch in the Big Cave.

If the player attempts to walk through a secret door, the same response
to attempting to travel in a non-existent direction is given:

	>west
	You can't go that way.

If the player attempts to interact with a secret switch, the same
response to attempting to interact with a non-existent object is given:

	>pull lever
	You can't see any such thing!

	>throw rock at lever
	You can't see any such thing!

It might be that we want the switch to be in plain sight. In that case
it should be defined as a normal object rather than a secret switch:

	The lever is fixed in place in the Big Cave.

	Instead of pulling the lever for the first time:
		now the passage door is revealed;
		now the passage door is open;
		say "As you pull the lever, a secret door opens, revealing a secret
passage!"

If on the other hand we want the switch to be hidden as well, then we
need a way of revealing it so that it can be used. For example:

	The lever is a secret switch in the Big Cave.

	The cave wall is scenery in the Big Cave.

	Instead of searching or examining the cave wall:
		now the lever is revealed;
		say "In a gap between two rocks you discover a lever."

	Instead of pulling the revealed lever for the first time:
		now the passage door is revealed;
		now the passage door is open;
		say "As you pull the lever, a secret door opens, revealing a secret
passage!"

WARNING: it's important to say "the revealed lever", not simply "the lever".
Otherwise attempts to pull the lever when it is not yet revealed will be counted,
and "the first time" will no longer be true, resulting in a broken story.

Note that secret doors and switches are defined as scenery by default (which is
why it's not necessary to define a secret switch as fixed in place).  You can override
this on a case-by-case basis if you wish.

Also note that by default secret doors behave like regular doors once revealed,
which means that the player can open and close them as normal.
If you want to have the door open exclusively through some story-provided
mechanism, then remember to define them as "unopenable" -- this doesn't
stop the story from opening the door, but it stops the player from doing so.

Example: * Simple Cave with Secret Door and Lever - This defines a simple two-room example similar to the above.  

	*: "Secret Cave Passage" by Gavin Lambert

	Include Secret Doors by Gavin Lambert.

	Big Cave is a room. "You're not sure how you ended up here, but you're surrounded on all sides by slightly damp rock.  Fortunately the walls seem to contain faintly glowing moss, so there's enough light to see by."
	The faintly glowing moss is scenery in the Big Cave.  "It glows just barely enough to make out your surroundings."

	Secret Passage is a room. "For being so close to a cave, this passage is surprisingly well built and is lit by standard electrical bulbs.  Unfortunately it also appears to be blocked by rubble not too far from the entrance; you can't seem to proceed any further."
	The rubble is scenery in the Secret Passage.  "It looks completely impassable."

	The passage door is an unopenable secret door.  "It's fairly unassuming.  You'd never have known it was there until it opened."
	It is west of the Big Cave and east of the Secret Passage.

	The hidden lever is a secret switch in the Big Cave.  "Nestled almost invisibly between two rocks in the cave wall.  [if the passage door is revealed]It has been pulled downwards.[otherwise]It points invitingly upwards.[end if]"

	The cave wall is scenery in the Big Cave.  "Nothing else more interesting presents itself.  Just more glowing moss."
	Understand "damp rock" or "rock" as the cave wall.

	Instead of going nowhere from the Big Cave:
		say "The cave walls seem completely intact in that direction."

	Instead of searching or examining the cave wall for the first time:
		now the lever is revealed;
		say "As you examine the cave wall, in a gap between two rocks you discover a lever."
		
	Instead of pulling or pushing the revealed lever:
		if the passage door is revealed:
			say "You don't have any desire to close the passage again.";
		otherwise:
			now the passage door is revealed;
			now the passage door is open;
			say "A secret door opens with a rumble, revealing a secret passage in the west wall!"

	Test me with "w / open door / pull lever / x wall / x lever / pull lever / x lever / w"
