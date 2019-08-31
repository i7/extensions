Version 1 of Visible from a Distance by Xavid begins here.

"Allow certain things in adjacent rooms to be examined."

Include Expanded Understanding by Xavid.

Chapter 1 - Examining Things in Adjacent Rooms

A thing can be visible from a distance.

After deciding the scope of the player when examining (this is the things in adjacent rooms are in scope for examining rule):
	[repeat with S running through visible from a distance things in adjacent rooms:
		place S in scope, but not its contents;]
	repeat with D running through directions:
		let R be the room D from the location;
		if R is not nowhere:
			repeat with S running through visible from a distance things in R:
				place S in scope, but not its contents;
	repeat with D running through open doors in the location:
		repeat with S running through visible from a distance things in the other side of D:
			place S in scope, but not its contents.

Before examining something when the noun is not in the location (this is the indicate direction when examining things in adjacent rooms rule):
	[ We check these first to prefer NSEW to like inside ]
	let D be nothing;
	repeat with MD running through {north, south, east, west, northeast, southeast, southwest, northwest, up, down}:
		if the room MD of the location is the location of the noun:
			now D is MD;
			break;
	if D is nothing:
		now D is the best route from the location to the location of the noun, using doors;
	if D is not nothing:
		say "(looking [D] to [the natural name of the location of the noun])[line break]".

Visible from a Distance ends here.

---- DOCUMENTATION ----

A thing can be visible from a distance, meaning you can examine it from adjacent rooms. This can be useful if you have something like a river where in adjacent room descriptions you say "To the west is a river.", but you don't want to make it a backdrop because you don't want the player to be able to interact with it in other ways from these adjacent rooms.

This is its own extension, rather than being part of Expanded Understanding, because it can slow down the examine command in larger games and won't always be used.