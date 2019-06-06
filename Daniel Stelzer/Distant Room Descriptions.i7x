Distant Room Descriptions by Daniel Stelzer begins here.

Describing something is an activity on objects.
The describing something activity has an object called the distant visibility ceiling.
The describing something activity has a number called the distant visibility level count.
The viewpoint is an object that varies. [There has to be a better way than using a global variable!]

To describe (place - an object) from the viewpoint of (item - a thing):
	now the viewpoint is the item;
	carry out the describing activity with the place.
To describle (place - an object):
	now the viewpoint is the place;
	carry out the describing activity with the place.

Before describing an object (called the place) (this is the distant determine visibility ceiling
	rule):
	calculate visibility ceiling at low level;
	now the distant visibility level count is the visibility ceiling count calculated;
	now the distant visibility ceiling is the visibility ceiling calculated;

Rule for describing an object (called the place) (this is the distant room description heading rule):
	say bold type;
	if the visibility level count is 0:
		begin the printing the name of a dark room activity;
		if handling the printing the name of a dark room activity,
			issue miscellaneous library message number 71;
		end the printing the name of a dark room activity;
	otherwise if the visibility ceiling is the place:
		say "[visibility ceiling]";
	otherwise:
		say "[The visibility ceiling]";
	say roman type;
	let intermediate level be the visibility-holder of the viewpoint;
	repeat with intermediate level count running from 2 to the visibility level count:
		issue library message looking action number 8 for the intermediate level;
		let the intermediate level be the visibility-holder of the intermediate level;
	say line break;
	say run paragraph on with special look spacing;
	continue the activity.

Rule for describing an object (called the place) (this is the distant room description body text rule):
	if the visibility level count is 0:
		if set to abbreviated room descriptions, continue the action;
		if set to sometimes abbreviated	room descriptions and
			abbreviated form allowed is true and
			darkness witnessed is true,
			continue the action;
		begin the printing the description of a dark room activity;
		if handling the printing the description of a dark room activity,
			issue miscellaneous library message number 17;
		end the printing the description of a dark room activity;
	otherwise if the visibility ceiling is the location:
		if set to abbreviated room descriptions, continue the action;
		if set to sometimes abbreviated	room descriptions and abbreviated form
			allowed is true and the location is visited, continue the action;
		print the place's description;
	continue the activity.

Rule for describing an object (called the place) (this is the distant room description paragraphs about objects rule):
	if the visibility level count is greater than 0:
		let the intermediate position be the viewpoint;
		let the IP count be the visibility level count;
		while the IP count is greater than 0:
			now the intermediate position is marked for listing;
			let the intermediate position be the visibility-holder of the
				intermediate position;
			decrease the IP count by 1;
		let the top-down IP count be the visibility level count;
		while the top-down IP count is greater than 0:
			let the intermediate position be the viewpoint;
			let the IP count be 0;
			while the IP count is less than the top-down IP count:
				let the intermediate position be the visibility-holder of the
					intermediate position;
				increase the IP count by 1;
			[if we ever support I6-style inside descriptions, here's where]
			describe locale for the intermediate position;
			decrease the top-down IP count by 1;
	continue the activity.

Distant Room Descriptions ends here.

---- DOCUMENTATION ---- 

This is a relatively simple extension which adds a new phrase: "describe (place - an object) from the viewpoint of (item - a thing)". This should print the room description just as if the player had typed "look" while in the place. You can also leave off the viewpoint clause if it isn't necessary.
