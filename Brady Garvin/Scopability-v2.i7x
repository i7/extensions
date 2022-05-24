Version 2.0.220524 of Scopability by Brady Garvin begins here.

"The ability to toggle objects' scopability; the parser does not acknowledge the existence of unscopable objects, even if they are explicitly added to scope."

Section - Scopable property high level

An object can be scopable or unscopable.
An object is usually scopable.

Section - Scopable property low level

Include (- Attribute scopable; -)

The scopable property translates into Inter as "scopable".

Section - Unscopable things usually scenery

An unscopable thing is usually scenery.

Section - Parser changes to honor scopable property

[ DoScopeAction is located in Parser.i6t in the CommandParserKit. ]
[ This is the bottom level thing which acts when something is being put in scope, so cancelling out here
  makes sure that the item is never treated as in scope, for any purpose ]
[ As of this writing, DoScopeAction contains the truly ancient piece of code "indirect(parser_one, item)",
	but although this is accepted by Inform 7 in a Kit, this isn't accepted in an Inform 6 inclusion by Inform 7.
	This code is equivalent to parser_one(item) -- Thanks to Andrew Plotkin for figuring this out. ]

Include (-
[ DoScopeAction item;

	if (item hasnt scopable) return; ! This line added by Scopability

	#Ifdef DEBUG;
	if (parser_trace >= 6)
		print "[DSA on ", (the) item, " with reason = ", scope_reason,
			" p1 = ", parser_one, " p2 = ", parser_two, "]^";
	#Endif; ! DEBUG

	@push parser_one; @push scope_reason;

	switch(scope_reason) {
		TESTSCOPE_REASON: if (item == parser_one) parser_two = 1;
		LOOPOVERSCOPE_REASON: if (parser_one ofclass Routine) parser_one(item);
		PARSING_REASON, TALKING_REASON: MatchTextAgainstObject(item);
		}

	@pull scope_reason; @pull parser_one;
];
-) replacing "DoScopeAction"

Scopability ends here.

---- DOCUMENTATION ----

When Scopability is included, every object can be either scopable or unscopable.
Most are scopable, which means that they are subject to Inform's usual scope
rules.  But unscopable objects are never acknowledged by the parser, even if we
try to explicitly add them to scope, which is useful for modeling objects that
are present, but that the player character cannot see.

Objects declared as initially unscopable are scenery unless we state otherwise;
non-scenery usually appears in room descriptions, which would contradict the
supposed invisibility.  However, scopable and scenery status are toggled
independently thereafter, so revealing an object usually means changing both
properties.

Changelog:
	Version 2: Updated for Inform 10.1 by Nathanael Nerode.  Thanks to Andrew Plotkin and Zed Lopez for deciphering black magic in the parser code.
	Version 1/210620: per https://intfiction.org/t/friends-of-i7-extension-testing/51284/14, fixed a compilation error by changing a ';' -> '.' (modified by Zed Lopez)
	Version 1: Brady Garvin committed to Friends of I7 repo on Dec 28, 2013 with the note "Added my scopability code, per a forum request."

Example: * The Visitor - An object that is present but unrevealed.

	*: "The Visitor"

	Include Scopability by Brady Garvin.

	Cavern is a room.
	The rocky debris is scenery.
	The alien artifact is an unscopable thing in the cavern.
	"It's embedded in the rock!"
	The description of the alien artifact is "It looks alien."

	Every turn when the alien artifact is in the location:
		say "There's a faint humming coming from above."

	Instead of listening when the alien artifact is in the location:
		say "Hmmmm hmmmm hmmmm.  Hm hm hm hm.  Hmmmm hm hm.  Hm.  Hm hmmmm.  Hm hmmmm hm."

	Instead of jumping when the alien artifact is in the location and the alien artifact is not scopable:
		say "The jolt shakes [rocky debris] loose from the ceiling, revealing [an alien artifact]!";
		now the rocky debris is in the location;
		now the alien artifact is scopable;
		now the alien artifact is not scenery.

	Test me with "z / listen / x artifact / jump / x artifact".
