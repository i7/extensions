Version 2 of Volumetric Limiter by Daniel Gaskell begins here.

"Containers and actor that limit their contents by volume. Modeled after Bulk Limiter by Eric Eve, but understands length, width, and height as well as total size."

A volumetric size is a kind of value. 1000x1000x1000 specifies a volumetric size with parts length and width and height.

A thing has a volumetric size called bulk.
The bulk of a thing is normally 6x6x3.

A container has a volumetric size called bulk capacity.
The bulk capacity of a container is usually 24x16x12.

A person has a volumetric size called bulk capacity.
The bulk capacity of a person is usually 120x72x72.

To decide which number is the longest dimension of (active bulk - a volumetric size):
	if the length part of active bulk >= the width part of active bulk and the length part of active bulk >= the height part of active bulk, decide on the length part of active bulk;
	if the width part of active bulk >= the length part of active bulk and the width part of active bulk >= the height part of active bulk, decide on the width part of active bulk;
	if the height part of active bulk >= the length part of active bulk and the height part of active bulk >= the width part of active bulk, decide on the height part of active bulk.
	
To decide which number is the second longest dimension of (active bulk - a volumetric size):
	let tmp-longest be the longest dimension of active bulk;
	let tmp-shortest be the shortest dimension of active bulk;
	[first, try to decide outright]
	if the length part of active bulk > tmp-shortest and the length part of active bulk < tmp-longest, decide on the length part of active bulk;
	if the width part of active bulk > tmp-shortest and the width part of active bulk < tmp-longest, decide on the width part of active bulk;
	if the height part of active bulk > tmp-shortest and the height part of active bulk < tmp-longest, decide on the height part of active bulk;
	[otherwise, two or more numbers are the same - see which number there's the most of]
	let tmp-longest-counter be 0;
	if the length part of active bulk is tmp-longest, increment tmp-longest-counter;
	if the width part of active bulk is tmp-longest, increment tmp-longest-counter;
	if the height part of active bulk is tmp-longest, increment tmp-longest-counter;
	if tmp-longest-counter > 1:
		decide on tmp-longest;
	otherwise:
		decide on tmp-shortest.

To decide which number is the shortest dimension of (active bulk - a volumetric size):
	if the length part of active bulk <= the width part of active bulk and the length part of active bulk <= the height part of active bulk, decide on the length part of active bulk;
	if the width part of active bulk <= the length part of active bulk and the width part of active bulk <= the height part of active bulk, decide on the width part of active bulk;
	if the height part of active bulk <= the length part of active bulk and the height part of active bulk <= the width part of active bulk, decide on the height part of active bulk.

To decide what number is the cubic volume of (active size - a volumetric size):
	decide on (the length part of active size times the width part of active size) times the height part of active size.
	
To decide what number is the free capacity of (active item - a container):
	let tmp-sum be 0;
	repeat with tmp-item running through things in the active item:
		now tmp-sum is tmp-sum plus the cubic volume of the bulk of tmp-item;
	decide on the cubic volume of the bulk capacity of active item minus tmp-sum.
	
To decide what number is the free capacity of (active item - a person):
	let tmp-sum be 0;
	repeat with tmp-item running through things carried by the active item:
		now tmp-sum is tmp-sum plus the cubic volume of the bulk of tmp-item;
	decide on the cubic volume of the bulk capacity of active item minus tmp-sum.

Failed bulk dimensions is initially 0.
Tightest fit factor is initially 0.0.

To decide if (source - an object) fits into (target - an object):
	now failed bulk dimensions is 0;
	now tightest fit factor is 0.0;
	[cache dimension calculations]
	let source-longest be the longest dimension of the bulk of source;
	let source-second-longest be the second longest dimension of the bulk of source;
	let source-shortest be the shortest dimension of the bulk of source;
	let target-longest be the longest dimension of the bulk capacity of target;
	let target-second-longest be the second longest dimension of the bulk capacity of target;
	let target-shortest be the shortest dimension of the bulk capacity of target;
	[calculate tightest fit factor]
	if (source-longest / target-longest) > tightest fit factor, now tightest fit factor is source-longest / target-longest;
	if (source-second-longest / target-second-longest) > tightest fit factor, now tightest fit factor is source-second-longest / target-second-longest;
	if (source-shortest / target-shortest) > tightest fit factor, now tightest fit factor is source-shortest / target-shortest;
	[calculate failed dimensions]
	if source-longest > target-longest, increment failed bulk dimensions;
	if source-second-longest > target-second-longest, increment failed bulk dimensions;
	if source-shortest > target-shortest, increment failed bulk dimensions;
	[decide]
	if failed bulk dimensions > 0, no;
	yes.

To decide if (target - an object) has enough space for (source - an object):
	if the free capacity of target >= the cubic volume of the bulk of source, yes;
	no.

Check an actor inserting into when the second noun provides the property bulk capacity (this is the can't insert bulky objects rule):
	unless the noun fits into the second noun:
		if failed bulk dimensions is 1:
			say "[The noun] [are] [if tightest fit factor >= 2]much [end if]too long to fit in [the second noun]." (A) instead;
		otherwise:
			say "[The noun] [are] [if tightest fit factor >= 2]much [end if]too large to fit in [the second noun]." (B) instead;
	unless the second noun has enough space for the noun:
		say "[There] [are not] enough room left in [the second noun] for [the noun]." (C) instead.

Check an actor taking when the actor provides the property bulk capacity (this is the can't pick up bulky objects rule):
	unless the noun fits into the actor:
		if failed bulk dimensions is 1:
			say "[The noun] [are] [if tightest fit factor >= 2]much [end if]too long for [if the actor is the player][us][otherwise][the actor][end if] to carry." (A) instead;
		otherwise:
			say "[The noun] [are] [if tightest fit factor >= 2]much [end if]too large for [if the actor is the player][us][otherwise][the actor][end if] to carry." (B) instead;
	unless the actor has enough space for the noun:
		say "[If the player is the actor][We] [don't][otherwise][The actor] [don't][end if] have enough room left to carry [the noun]." (C) instead.

Volumetric Limiter ends here.



---- DOCUMENTATION ----

Chapter: Overview

This extension adds a bulk property to all things, and a bulk capacity property to all containers and people. Objects cannot be put into containers that are full or too small for them.

Bulk is a value of the kind "volumetric size", with parts length, width, and height. For example:

	The pot of gold is at Rainbow's End. The bulk is 20x20x12.
	
The dimensions are unitless, so "20" could represent 20 inches, 20 cm, or any other unit, so long as we are consistent about it. The default values assume dimensions will be given in inches (i.e. the pot of gold is 20 inches across and 12 inches tall).

The default bulk of a thing is 6x6x3 (the size of a small bowl). The default bulk capacity of a container is 24x16x12 (the size of a small chest). The default bulk capacity of a person is 120x72x72 (quite voluminous).

The implementation is simplified, but fairly intelligent: Volumetric Limiter will understand that we cannot put a four-foot broomstick in a box two feet wide, for example, but won't try to work out whether the broom could be wedged in diagonally. Fullness is likewise simplified: Volumetric Limiter only considers total volume, not how objects might coexist based on their shape. Still, it's enough to produce convincing parser responses like:

	The umbrella is too long to fit in the jewelry box.
	Laurie doesn't have enough room left to carry the sack of coal.
	The piano is much too large to fit in the cassette player.

Note that this extension complements (rather than replaces) Inform's built-in capacity check for containers. The default carrying capacity of a container is 100, so capacity checks rarely come into play, but the rules still exist if needed.

Chapter: Special Tools

A number of internal phrases and definitions can be used separately, if needed. We can find the longest, second-longest, and shortest dimensions of a volumetric size using:

	the longest dimension of (a volumetric size)
	the second longest dimension of (a volumetric size)
	the shortest dimension of (a volumetric size)
	
We can find the total volume of a volumetric size (length x width x height) using:

	the cubic volume of (a volumetric size)
	
We can find out how much space is left in a container or person (by volume) using:

	the free capacity of (something)
	
We can manually check dimensions and available volume using:
	
	if (something) fits into (something)...
	if (something) has enough space for (something)...
	
Finally, after running the "(something) fits into (something)" test, two variables will be set: "failed bulk dimensions" and "tightest fit factor". These are used to generate more intelligent failure messages.

"Failed bulk dimensions" holds the number of dimensions that don't fit, from 0 to 3. For example, a flagpole might have a small enough length and width to fit in a drawer, but not a small enough height, so "failed bulk dimensions" would be set to 1.

"Tightest fit factor" is a real number holding the percentage of the container that the largest dimension takes up. For example, a 12-inch cube in a 24-inch box would have a "tightest fit factor" of 0.5 (50%), while a 24-inch pole in a 12-inch box would have a "tightest fit factor" of 2.0 (200%).

Example: * Drawing Room - Some objects to play with, demonstrating relative volumes.

	*: "Drawing Room"

	Include Volumetric Limiter by Daniel Gaskell.
	
	The Drawing Room is a room.
	
	The gigantic novelty pencil is in the Drawing Room. The bulk is 36x5x5.
	The scale model of the Parthenon is in the Drawing Room. The bulk is 12x10x6.
	The marble is in the Drawing Room. The bulk is 1x1x1.
	The inexplicable titanium cube is in the Drawing Room. The bulk is 12x12x12.
	
	The matchbox is a container in the Drawing Room. The bulk is 3x2x1. The bulk capacity is 3x2x1.
	The fishbowl is a container in the Drawing Room. The bulk is 12x12x12. The bulk capacity is 8x8x8.
	The cabinet is a container in the Drawing Room. It is fixed in place. The bulk capacity is 24x12x12.
	
	Test me with "put fishbowl in matchbox / put marble in matchbox / put pencil in fishbowl / put cube in fishbowl / put matchbox in fishbowl / put pencil in cabinet / put fishbowl in cabinet / put cube in cabinet / put model in cabinet".
