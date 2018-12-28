Version 2 of Graphical Map (for Glulx only) by Xavid begins here.

"Provides support for an image-based map with a static background and icons for the player and optionally other things or doors."

Part 1 - Inclusions

Include Flexible Windows by Jon Ingold.
[Include Drawing Commands by Xavid.]
Include Glimmr Drawing Commands by Erik Temple.

Part 2 - Map Window

Chapter 1 - Setup

The map window is a graphics g-window spawned by the main window.
The position of the map window is usually g-placeabove.
The scale method of the map window is g-fixed-size.
The measurement of the map window is usually 0.
When play begins (this is the size map window by map height rule):
	if the measurement of the map window is 0:
		now the measurement of the map window is the image-height of the Figure of Map.

Chapter 2 - Drawing the Map

The map origin is a list of numbers that varies. The map origin is {0, 0}.
Rule for refreshing the map window (this is the draw map rule):
	let fig be the map figure of the location;				
	if fig is the Figure of Cover:
		now fig is the Figure of Map;
	let the horizontal scroll be ((the width of the map window) minus the image-width of fig) divided by 2;
	if (the width of the map window is less than the image-width of fig or the hide unvisited rooms in map option is active) and the fixed map option is not active:
		let the horizontal scroll be ((((the width of the map window) minus the map grid size) divided by 2) minus ((entry 1 of the map padding) plus (the map grid size times (entry 1 of the real grid pos of the location)))) to the nearest whole number;
		if the zero-based map grid option is not active:
			let the horizontal scroll be the horizontal scroll plus the map grid size;
		[ We don't bound the scrolling when hiding unvisited rooms to avoid spoiling the edges of the map ]
		if the hide unvisited rooms in map option is not active:
			if the horizontal scroll is greater than 0:
				let the horizontal scroll be 0;
			if the horizontal scroll is less than (the width of the map window) minus the image-width of fig:
				let the horizontal scroll be (the width of the map window) minus the image-width of fig;
	let the vertical scroll be 0;
	if (the height of the map window is less than the image-height of fig or the hide unvisited rooms in map option is active) and the fixed map option is not active:
		let the vertical scroll be ((((the height of the map window) minus the map grid size) divided by 2) minus ((entry 2 of the map padding) plus (the map grid size times (entry 2 of the real grid pos of the location)))) to the nearest whole number;
		if the zero-based map grid option is not active:
			let the vertical scroll be the vertical scroll plus the map grid size;
		[ We don't bound the scrolling when hiding unvisited rooms to avoid spoiling the edges of the map ]
		if the hide unvisited rooms in map option is not active:
			if the vertical scroll is greater than 0:
				let the vertical scroll be 0;
			if the vertical scroll is less than (the height of the map window) minus the image-height of fig:
				let the vertical scroll be (the height of the map window) minus the image-height of fig;
	display fig in the map window at the horizontal scroll x the vertical scroll;
	now entry 1 of the map origin is the horizontal scroll plus entry 1 of the map padding;
	now entry 2 of the map origin is the vertical scroll plus entry 2 of the map padding;
	repeat with R running through plotted rooms:
		let xpos be ((entry 1 of the map offset of R) plus (the map grid size times ((entry 1 of the real grid pos of R) plus 0.5)) minus ((the image-width of the map icon of R) divided by 2)) to the nearest whole number;
		let ypos be ((entry 2 of the map offset of R) plus (the map grid size times ((entry 2 of the real grid pos of R) plus 0.5)) minus ((the image-height of the map icon of R) divided by 2)) to the nearest whole number;
		if the zero-based map grid option is not active:
			let xpos be xpos minus the map grid size;
			let ypos be ypos minus the map grid size;
		display the map icon of R in the map window at ((entry 1 of the map origin) plus xpos) x ((entry 2 of the map origin) plus ypos);
	repeat with T running through mappable things:
		follow the map drawing rulebook for T;
	if the right map overlay is not no map icon:	
		let ox be the width of the map window minus the image-width of the right map overlay;
		let oy be (the height of the map window minus the image-height of the right map overlay) divided by 2;
		display the right map overlay in the map window at ox x oy;
	if the hide unvisited rooms in map option is active:
		repeat with R running through unvisited rooms that do not contain the player:
			if the map figure of R is the map figure of the location:
				let xpos be (the horizontal scroll plus (entry 1 of the map padding) plus (the map grid size times (entry 1 of the real grid pos of R))) to the nearest whole number;
				let ypos be (the vertical scroll plus (entry 2 of the map padding) plus (the map grid size times (entry 2 of the real grid pos of R))) to the nearest whole number;
				if the zero-based map grid option is not active:
					let xpos be xpos minus the map grid size;
					let ypos be ypos minus the map grid size;
				erase rect in the map window at xpos x ypos with size the map grid size x the map grid size.

Every turn (this is the redraw map each turn rule):
	refresh the map window.

To map draw (T - thing) at (X - a number) x (Y - a number):
	display the map icon of T in the map window at ((entry 1 of the map origin) plus X) x ((entry 2 of the map origin) plus Y).

Map drawing is a thing based rulebook. Map drawing rules have default success.

Section 1 - Drawing Things

Map drawing a thing (called T) (this is the default map drawing rule):
	if the only draw visited things option is not active or the location of T is visited:
		let xpos be ((entry 1 of the computed room offset of T) plus (the map grid size times (entry 1 of the real grid pos of the location of T))) to the nearest whole number;
		let ypos be ((entry 2 of the computed room offset of T) plus (the map grid size times (entry 2 of the real grid pos of the location of T))) to the nearest whole number;
		if the zero-based map grid option is not active:
			let xpos be xpos minus the map grid size;
			let ypos be ypos minus the map grid size;
		map draw T at xpos x ypos.

Section 2 - Drawing Doors

A door has a list of numbers called the map position.
Map drawing a door (called D) (this is the map drawing doors rule):
	if D is closed and (the only draw visited things option is not active or the location of D is visited):
		map draw D at entry 1 of the map position of D x entry 2 of the map position of D.

Part 3 - Map Options

Use zero-based map grid translates as (- -).

Use hide unvisited rooms in map translates as (- -).
Use fixed map translates as (- -).

Use only draw visited things translates as (- -).

The map grid size is a number that varies.
The map padding is a list of numbers that varies.

Part 4 - Map Properties

A room has a list of numbers called the grid position.
A room has a list of real numbers called the real grid position.
[ Unfortunately, if we try to set a list of real numbers property to {1,2}, Inform ends up getting confused, so we need this hack to allow either. ]
To decide which list of real numbers is the real grid pos of (R - a room):
	if the real grid position of R is not empty:
		decide on the real grid position of R;
	else:
		let P be a list of real numbers;
		add entry 1 of the grid position of R to P;
		add entry 2 of the grid position of R to P;
		decide on P.

A room has a figure name called the map figure.
[ We want to do something like:
The map figure is usually Figure of Map.
but we can't because we want to let the individual game define what file Figure of Map is, so we fake it.
]

A room has a figure name called the map icon.
A room has a list of numbers called the map offset.

A thing has a figure name called the map icon.
A thing has a list of numbers called the room offset.
To decide which list of numbers is the computed room offset of (T - a thing):
	decide on the room offset of T.

No map icon is always the figure of cover.
Definition: a thing is mappable if the map icon of it is not the figure of cover and it is not nowhere and the map figure of the location of it is the map figure of the location.
Definition: a room is plotted if the map icon of it is not the figure of cover and it is visited and the map figure of it is the map figure of the location.

The right map overlay is a figure name that varies.

Part 5 - Command

Toggling the map is an action out of world. Understand "map" or "hide map" or "show map" as toggling the map.
Carry out toggling the map (this is the toggling the map rule):
	if the map window is g-required:
		close the map window;
		say "Map hidden." (A);
	else:
		open the map window;
		say "Map shown." (B).

Part 6 - Misc Implementation

Chapter 1 - Erasing Commands

To dimrecterase in (rn - a number) at (x1 - a number) by/x (y1 - a number) with size/dimensions (width - a number) by/x (height - a number):
	(- EraseDimRect({rn}, {x1}, {y1}, {width}, {height}); -)

To erase a/-- rectangle/rect in (win - a g-window) at (x1 - a number) by/x (y1 - a number) with size/dimensions (width - a number) by/x (height - a number):
	dimrecterase in (ref number of win) at (x1) by (y1) with size (width) by (height);

Include (-

[ EraseDimRect rn x1 y1 width height ;
	if (rn) {
		glk_window_erase_rect(rn, x1, y1, width, height);
	}
];

-).

Graphical Map ends here.

---- DOCUMENTATION ----

This extension allows you to have a window with a map image in it, and to draw icons on the map based on the location of the player or whatever other things you want.

It requires Flexible Windows by Jon Ingold.

Chapter 1 - Usage

Section 1 - A Map

To use this extension, you must first create a map image. You can make it in the graphics program of your choice, such as Inkscape, or with Inform's built-in map functionality. Either way, the map can be as elaborate as you want, but rooms should be based around a regular grid. Save your map image to the Figures directory of your materials directory. Import this as a figure called Map with something like:

	Figure of Map is the file "Map.png".

You also need to tell Graphical Map some information about the map that it can use for layout: the width and height of the image, the distance between the upper left corners of the rooms in your grid, and the padding, the horizontal and vertical distance from the upper left of your image to the top left of the room grid. All distances are in pixels.

	The map grid size is 50.
	The map padding is {20, 10}.

About the room grid: this extension assumes that the rooms in your map are assigned to adjacent squares that are all the same size. The image doesn't have to draw them as squares, of course, but the extension will treat them as squares for purposes of placing map icons (for the PC and so on). If, like Inform's Index map, your map has lines connecting rooms instead of placing them adjacent to each other, you should include the space for those connectors in the map grid size.

The map window isn't shown by default, in case you want to have some introductory sequence before it appears. To make it visible, you can do something like:

	When play begins:
		Open the map window.

Section 2 - Rooms

The above is enough to display a static map. But to draw things on it, first we need to know what space in the map grid each Inform room corresponds to. We do this by setting the grid position of a room to its horizontal and vertical position in the map grid, for example:

	The grid position of the Crossroads is {3, 1}.

This puts the room in the third column and first row on the map.

(If you want the upper left space in the map grid be {0, 0} instead of {1, 1}, you can add the "Use zero-based map grid." option.)

Section 3 - Mapping Things

To have the player show up on the map, you also need to make an icon to represent them. This also needs to be declared as a figure. It should generally be a PNG with a transparent background so it looks good overlaid on the map. You assign this figure as the map icon of the player. You also need to define the map offset of the player, the horizontal and vertical distance from the top left of a room to where the icon should appear.

	The map icon of yourself is the Figure of PC.
	The map offset of yourself is {25, 12}.

You can assign map icons and map offsets to anything, not just the PC. Giving different things different map offsets will allow them to appear in the same room without the icons being on top of each other.

Section 4 - Mapping Doors

Doors are another thing you might want to be indicated on your map. Doors work a little differently than other things. Because they're not really in a single room, the map offset of a door is relative to the overall map grid, not a particular room. Also, a door is only drawn when the door is closed, not when it's open.

Section 5 - Exploration

By default, the whole map is visible from the start of game. If your game is exploration-based, you may want to hide rooms that have not been visited. Basic support for this functionality can be obtained with:
	
	Use hide unvisited rooms in map.

This just erases the map grid corresponding to any unvisited room.

To make this work nicely when you have connector lines between rooms in your map, you should calculate the map padding so that the rooms on your map image are centered in the boxes of the map grid, and thus half of each connector is in the box for each of the connected rooms. (It's ok if the map padding needs to be negative to accomplish this.)

Section 6 - Scrolling

Many games may have a map too big to display all at once. If the map is taller than conveniently fits on the screen all at once, you should give the map window an explicit height with something like:

	The measurement of the map window is 100.

The map will automatically scroll around to keep the room the player is currently in centered. The same applies if the map image is wider than fits in the window.

The map always scrolls when the hide unvisited rooms in map option is active, to avoid spoiling the fact that the player's at the edge of the map.

If you want to disable scrolling, for example because you use a wide map image to avoid white bars on the edge for wider screens but it's fine for the edges to get cut off on smaller screens, say "use fixed map".

Section 7 - Multiple Maps

You can have multiple maps, for example for different floors in a building or if your game has different discontinuous areas. To use a figure other than the Figure of Map for a room, say something like:

	The map figure of the Attic is Figure of Attic.

Section 8 - Legend

You can have a fixed image like a legend/key that doesn't move with the rest of the map. To do this, say something like:
	
	The right map overlay is the Figure of Compass.

Chapter 2 - Bugs and Comments

This extension is hosted in Github at https://github.com/i7/extensions/tree/master/Xavid. Feel free to email me at extensions@xavid.us with questions, comments, bug reports, suggestions, or improvements.

Example: * Simple Map - Mapping a two-room world.

	*: "Simple Map"

	Include Graphical Map by Xavid.

	The map grid size is 50.
	The map padding is {10, 10}.
	
	Use hide unvisited rooms in map.

	[ You can download the images used in this example from https://github.com/i7/extensions/tree/master/Xavid/Figures ]
	Figure of Map is the file "Map.png".
	Figure of PC is the file "PC.png".
	Figure of Door is the file "Door.png".

	[ This positions a 25 x 25 icon (just shy of) centered in the room. ]
	The map icon of yourself is the Figure of PC.
	To decide which list of numbers is the computed room offset of (T - yourself):
		decide on {12, 12}.

	Balcony is a room.
	The grid position is {1, 1}.

	An open door called the glass door is south of Balcony.
	The map position is {0, 49}.
	The map icon is the figure of Door.

	Bedroom is south of the glass door.
	The grid position is {1, 2}.
	
	When play begins:
		Open the map window.
	
	Test me with "s / close door / open door".

Example: * Scrolling Map - A map that is too tall to fit on screen all at once.

	*: "Scrolling Map"

	Include Graphical Map by Xavid.

	The measurement of the map window is 100.
	The map grid size is 50.
	The map padding is {10, 10}.

	[ You can download the images used in this example from https://github.com/i7/extensions/tree/master/Xavid/Figures ]
	Figure of Map is the file "Tall Map.png".
	Figure of PC is the file "PC.png".

	The map icon of yourself is the Figure of PC.
	The room offset of yourself is {12, 12}.

	Arlington Heights is a room.
	The grid position is {1, 1}.

	Park Ave is south of Arlington Heights.
	The grid position is {1, 2}.

	Daniels St is south of Park Ave.
	The grid position is {1, 3}.

	Appleton St is south of Daniels St.
	The grid position is {1, 4}.

	Quincy St is south of Appleton St.
	The grid position is {1, 5}.

	Menotomy Rd is south of Quincy St.
	The grid position is {1, 6}.

	Mt Vernon St is south of Menotomy Rd.
	The grid position is {1, 7}.

	Lockeland Ave is south of Mt Vernon St.
	The grid position is {1, 8}.

	Newman Way is south of Lockeland Ave.
	The grid position is {1, 9}.

	Academy St is south of Newman Way.
	The grid position is {1, 10}.

	When play begins:
		Open the map window.
	
	Test me with "s / s / s / s / s / s / s".
