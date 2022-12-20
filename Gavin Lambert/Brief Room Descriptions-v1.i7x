Version 1.3.1 of Brief Room Descriptions by Gavin Lambert begins here.

"Alters BRIEF mode to display a room's brief description instead of nothing."

Use authorial modesty.

Section - Default Setting

Use brief room descriptions.

Section - Everything Else

A room has some text called brief description.

Carry out looking (this is the brief room description body text rule):
	if the visibility level count is 0
		or the visibility ceiling is not the location
		or not set to sometimes abbreviated room descriptions
		or abbreviated form allowed is false
		or the location is not visited, continue the action;
	let desc be the brief description of the location;
	if desc is not empty:
		say desc;
		say paragraph break.
		
The brief room description body text rule is listed before the room description body text rule in the carry out looking rules.

Brief Room Descriptions ends here.

---- DOCUMENTATION ----

This is a very straightforward extension that allows you to tweak the way that "brief" room descriptions work in Inform stories.

Without this extension, all players are in "verbose" mode by default and will see the full room description every time they visit a room.  At the player's option, they may request "brief" mode, which will print a description the first time and nothing on subsequent times, or "superbrief" mode, which will print nothing on the first time either.  In all cases, using "look" explicitly will show the full description regardless of the mode.

Including this extension tweaks things slightly so that players default to the "brief" mode, but also gives every room a "brief description" property, which will be printed on the second and subsequent visits to a room rather than printing nothing.

It still respects player preferences, however, so if they explicitly request "verbose" mode then they will get it.

The "superbrief" mode remains unaffected by this and will not display either kind of description.  We presume the player knows what they're doing if they request this.

Example: * Brevity is Beautiful - Demonstration of brief descriptions.

	*: "Brevity is Beautiful"
	
	Include Brief Room Descriptions by Gavin Lambert.

	The Wilkie Memorial Research Wing is a room.
	"The research wing was built onto the science building in 1967, when the college's finances were good but its aesthetic standards at a local minimum. A dull brown corridor recedes both north and south; drab olive doors open onto the laboratories of individual faculty members. The twitchy fluorescent lighting makes the whole thing flicker, as though it might wink out of existence at any moment. 
	
	The Men's Restroom is immediately west of this point."
	The brief description is "The restroom is to the west."

	The Men's Restroom is west of the Research Wing.
	"Well, yes, you really shouldn't be in here. But the nearest women's room is on the other side of the building, and at this hour you have the labs mostly to yourself. All the same, you try not to read any of the things scrawled over the urinals which might have been intended in confidence." 
	The brief description is "The research wing is back to the east."

	Test me with "w / e / w / e / verbose / w".
