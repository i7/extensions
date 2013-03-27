Automap IT by Leonardo Boselli begins here.

"An extension to automatically draw a map. Unico cambiamento: traduzione in italiano."

"based on Automap by Mark Tilford."

Section 1 - Global constants, Memory management, Kinds, and verbs

Use automap manual exploration translates as (- Constant AUTOMAP_MANUAL_EXPLORATION 1; -).
Use automap manual display translates as (- Constant AUTOMAP_MANUAL_DISPLAY 1; -).
Use automap visible background translates as (- Constant AUTOMAP_VISIBLE_BACKGROUND 1; -).
Use automap hide paths through closed doors translates as (- Constant AUTOMAP_HIDE_CLOSED_DOORS 1; -).

Use automap reserved area of at least 400 translates as (- Constant USEOP_MAP_ALLOC_AREA {N};  -).
Use automap static allocation translates as (- Constant AUTOMAP_ALLOCATE_STATIC 1; -).
Use automap hyperlinks translates as (- Constant AUTOMAP_HYPERLINKS 1; -).
[Include Text Capture by Eric Eve.
Use maximum capture buffer length of at least 512.]

Include (- 

Constant AUTOMAP_CHAR_IN 3;
Constant AUTOMAP_CHAR_OUT 4;
Constant AUTOMAP_CHAR_INOUT 5;

Constant AUTOMAP_CHAR_PRESENT_IN 6;
Constant AUTOMAP_CHAR_PRESENT_OUT 7;
Constant AUTOMAP_CHAR_PRESENT_INOUT 8;

Constant AUTOMAP_CHAR_DARK 9;
Constant AUTOMAP_CHAR_PRESENT_DARK 10;

#ifdef TARGET_ZCODE;
#ifndef AUTOMAP_ALLOCATE_STATIC;
Constant AUTOMAP_ALLOCATE_STATIC 1;
#endif;
#endif;
!#Ifdef TARGET_ZCODE;
#ifdef AUTOMAP_ALLOCATE_STATIC;
Constant MAP_ALLOC_AREA USEOP_MAP_ALLOC_AREA;
Array Automap_Chars -> MAP_ALLOC_AREA;
#ifnot;
Global MAP_ALLOC_AREA = 0;
Global Automap_Chars = 0;
Global printed_nomalloc_message = 0;
#endif;

Global MAP_WIDTH = 0;
Global MAP_HEIGHT = 0;

[ Reserve_Map_Memory rows cols;
	if (rows == 0) {
		rows = 0;
		cols = 0;
		return;
	}
	if (rows * cols > MAP_ALLOC_AREA) {
		!#ifdef TARGET_ZCODE;
		#ifdef AUTOMAP_ALLOCATE_STATIC;
		if (rows > MAP_ALLOC_AREA) {
			MAP_WIDTH = 0;
			MAP_HEIGHT = 0;
			return;
		}
		MAP_HEIGHT = rows;
		MAP_WIDTH = MAP_ALLOC_AREA / rows;
		return;
		#ifnot;
		if (~~check_for_malloc()) {
			if ( (+ current zoom +) == (+ map absent +) )
				return;
			if (~~Printed_nomalloc_message) {
				print "[Your interpreter does not support dynamic memory allocation.  Automap features will not function.]^";
				Printed_nomalloc_message = true;
			}
			(+ current zoom +) = (+ map absent +);
			return;
		}
		printed_nomalloc_message = false;
		if (Automap_Chars ~= 0) {
			@mfree Automap_Chars;
			Automap_Chars = 0;
		}
		MAP_ALLOC_AREA = rows * cols;
		@malloc MAP_ALLOC_AREA Automap_Chars;
		if (Automap_Chars == 0) {
			MAP_ALLOC_AREA = 0;
			MAP_WIDTH = 0;
			MAP_HEIGHT = 0;
			rfalse;
		}
		#endif;
	}
	MAP_WIDTH = cols;
	MAP_HEIGHT = rows;
	];
	
[ Check_for_malloc rv;
	#ifndef AUTOMAP_ALLOCATE_STATIC;
	@gestalt 7 0 rv;
	return rv;
	#ifnot;
	return 1;
	#endif;
];
!#Endif;
-) after "Definitions.i6t".

To decide whether there is no dynamic allocation conflict:
	(- Check_for_malloc() -).

To reserve automap memory of (rows - a number) rows by (cols - a number) cols/columns :  (- Reserve_Map_Memory ({rows}, {cols}) ;-).
To reserve automap memory of (cols - a number) cols/columns by (rows - a number) rows:  (- Reserve_Map_Memory ({rows}, {cols}) ;-).
To reserve automap memory of (rows - a number) by (cols - a number):  (- Reserve_Map_Memory ({rows}, {cols}) ;-).
To reserve automap memory of (rows - a number) rows: (- Reserve_Map_Memory ({rows}, VM_ScreenWidth()-2); -).

Include Basic Screen Effects by Emily Short.

A Mappable Room is a kind of room.
A mappable room has a number called map_x.
A mappable room has a number called map_y.

A mappable room can be currently_mapped.  A mappable room is usually not currently_mapped.

To decide what number is the distance (d - a direction) from (r - a room): decide on 1.

Coregionality relates mappable rooms to each other in groups.  The verb to be coregional with implies the coregionality relation.

Map zoomedness is a kind of value.  The Map zoomednesses are map absent, map zoomed in, and map zoomed out.

Current zoom is a map zoomedness that varies.  [The current zoom is map zoomed in.] The current zoom is map absent.

To report dynamic allocation conflict:
	say "[bracket]Il tuo interprete non supporta l[']allocazione dinamica, così la mappa automatica non funzionerà.[close bracket][line break]";
	now current zoom is map absent;
		
Zooming in is an action out of world applying to nothing.  Understand "zoom in" as zooming in.
Carry out zooming in: if there is no dynamic allocation conflict begin; say "Zoom in!"; now current zoom is map zoomed in; otherwise; report dynamic allocation conflict; end if.

Zooming out is an action out of world applying to nothing.  Understand "zoom out" as zooming out.
Carry out zooming out:
	if there is no dynamic allocation conflict begin; say "Zoom out!"; now current zoom is map zoomed out; otherwise; report dynamic allocation conflict; end if.

Zooming away is an action out of world applying to nothing.  Understand "mappa nascosta" as zooming away.  Carry out zooming away: say "La mappa è stata nascosta."; now current zoom is map absent.

ZoomingMisc is an action out of world applying to nothing.  Understand "zoom" as zoomingmisc.
Carry out zoomingmisc: 
	if there is no dynamic allocation conflict begin;
		if current zoom is map zoomed in begin;
			try zooming out;
		otherwise if current zoom is map zoomed out;
			try zooming away;
		otherwise;
			try zooming in;
		end if;
	otherwise;
		report dynamic allocation conflict;
	end if.


Map displayness is a kind of value.  The map displaynesses are map display automatic, map display fancy, map display ascii, map display unicode.
Current displayness is a map displayness that varies.

Map displaying fancy is an action out of world applying to nothing.  Understand "mappa fancy" as map displaying fancy.  Understand "mappa font 3" as map displaying fancy.  Understand "mappa beyond zork" as map displaying fancy.  Carry out map displaying fancy: now current displayness is map display fancy; say "La mappa è visualizzata con i caratteri fancy.".

Map displaying ascii is an action out of world applying to nothing.  Understand "mappa simple/ascii/plain" as map displaying ascii.  Carry out map displaying ascii: now current displayness is map display ascii; say "La mappa è visualizzata con i caratteri ascii.".
Gargoyle workaround is an action out of world applying to nothing.  Understand "gargoyle bug workaround" as gargoyle workaround.  Carry out gargoyle workaround: now current displayness is map display ascii; say "Activating workaround for buggy interpreter.".

Map displaying automatic is an action out of world applying to nothing.  Understand "mappa auto" as map displaying automatic.  Carry out map displaying automatic: now current displayness is map display automatic; say "La mappa è visualizzata con i caratteri automatici."

Automap work is an activity.  ["Catchall activity in case the author wants to do something different while doing automap related activity."]

Automap exploring is an activity.  ["Check a room, and join all adjacent rooms which are currently_mapped to its automap region."]

Automap drawing is an activity. ["writing the array that shows the automap."]

To decide whether (dir - a direction) is region preserving:
   if dir is north or dir is east or dir is west or dir is south or dir is northeast or dir is southeast or dir is northwest or dir is southwest, decide yes;
   if dir is up or dir is down or dir is inside or dir is outside, decide no;
   say "Errore: [dir] è una direzione sbagliata!"; decide no.

To decide what number is the delta x of (dir - a direction):
   if dir is west or dir is northwest or dir is southwest, decide on -1;
   if dir is east or dir is northeast or dir is southeast, decide on 1;
   decide on 0.

To decide what number is the delta y of (dir - a direction):
   if dir is north or dir is northwest or dir is northeast, decide on -1;
   if dir is south or dir is southwest or dir is southeast, decide on 1;
   decide on 0.


[Understand north south path as 40.]
To decide what number is automap in: decide on 3.
To decide what number is automap out: decide on 4.
To decide what number is automap inout: decide on 5.
To decide what number is automap present in: decide on 6.
To decide what number is automap present out: decide on 7.
To decide what number is automap present inout: decide on 8.
To decide what number is automap dark: decide on 9.
To decide what number is automap present dark: decide on 10.

To decide what number is north south path: decide on 40.
To decide what number is east west path: decide on 38.
To decide what number is ne sw path: decide on 35.
To decide what number is nw se path: decide on 36.
To decide what number is diagonal cross: decide on 90.
To decide what number is orthogonal cross: decide on 91. 
To decide what number is south wall: decide on 38.
To decide what number is north wall: decide on 39.
To decide what number is east wall: decide on 40.
To decide what number is west wall: decide on 41.
To decide what number is north exit: decide on 42.
To decide what number is south exit: decide on 43.
To decide what number is east exit: decide on 44.
To decide what number is west exit: decide on 45.
To decide what number is sw corner: decide on 46.
To decide what number is nw corner: decide on 47.
To decide what number is ne corner: decide on 48.
To decide what number is se corner: decide on 49.
To decide what number is sw exit: decide on 50.
To decide what number is nw exit: decide on 51.
To decide what number is ne exit: decide on 52.
To decide what number is se exit: decide on 53.
To decide what number is up arrow: decide on 92.
To decide what number is down arrow: decide on 93.
To decide what number is up down arrow: decide on 94.
To decide what number is question arrow: decide on 96.

To decide what number is empty cell: decide on 32.
To decide what number is full room: decide on 54.
To decide what number is empty room: decide on 95.

To decide what number is full south wall: decide on 55.
To decide what number is full north wall: decide on 56.
To decide what number is full east wall: decide on 57.
To decide what number is full west wall: decide on 58.
To decide what number is full north exit: decide on 59.
To decide what number is full south exit: decide on 60.
To decide what number is full east exit: decide on 61.
To decide what number is full west exit: decide on 62.
To decide what number is full sw corner: decide on 63.
To decide what number is full nw corner: decide on 64.
To decide what number is full ne corner: decide on 65.
To decide what number is full se corner: decide on 66.
To decide what number is full sw exit: decide on 67.
To decide what number is full nw exit: decide on 68.
To decide what number is full ne exit: decide on 69.
To decide what number is full se exit: decide on 70.
To decide what number is full up arrow: decide on 123.
To decide what number is full down arrow: decide on 124.
To decide what number is full up down arrow: decide on 125.
To decide what number is full question arrow: decide on 126.



To decide what number is map width:
	(- MAP_WIDTH -);
To decide what number is map height: 
	(- MAP_HEIGHT -);


Section 2 - Exploration - determining how rooms should be placed relative to each other

[ Unmap Room ]
To unmap (r - a room):
	now r is not coregional with r;
	now r is not currently_mapped.

To remap/explore (r - a room):
	unless r is explored, say "Errore nell[']esplorare [r] - BUG.";

[ Explore Room ]
To decide whether (r - a room) is explored:
	[say "Exploring [r].";]
	begin the automap work activity;
	begin the automap exploring activity;
	if r is a mappable room
	begin;
		if r is not currently_mapped begin;
			[say "Setting [r] to currently_mapped.";]
			now map_x of r is 0;
			now map_y of r is 0;
			now r is currently_mapped;
		end if;
		[say "mapped_room is [mapped_room].";]
		repeat with dir running through directions
		begin;
			if dir is region preserving and r has an exit to the dir
			begin;
				let next_room be the room dir from the r;
				[say "[mapped_room] : [dir] : [next_room].";]
				if next_room is a mappable room
				begin;
					[if next_room is placed 1 and 1 from r, say "Huh.";]
					let d be the distance dir from r;
					let ddx be d times (the delta x of dir);
					let ddy be d times (the delta y of dir);
					unless next_room is placed ddx and ddy from r, say "Errore nell[']esplorare [dir] da [r].";
				end if;
			end if;
		end repeat;
	end if;
	end the automap exploring activity;
	end the automap work activity;
	decide yes.

[ Recenter Region : Recoordinate the rooms in a region so that the minimum x and the minimum y of the region are 0. ]
To recenter the region of (r - a mappable room):
	let min_x be the map_x of r;
	let min_y be the map_y of r;
	repeat with loop_room running through all mappable rooms coregional with r begin;
		if the map_x of loop_room is less than min_x, now min_x is the map_x of loop_room;
		if the map_y of loop_room is less than min_y, now min_y is the map_y of loop_room;
	end repeat;
	repeat with loop_room running through all mappable rooms coregional with r begin;
		now the map_x of loop_room is the map_x of loop_room - min_x;
		now the map_y of loop_room is the map_y of loop_room - min_y;
	end repeat.
		

[ Join Regions : decide whether (nr - mappable room) is placed (dx - a number) and (dy - a number) from (or - mappable room):]
To decide whether (new room - mappable room) is placed (dx - a number) and (dy - a number) from (old room - mappable room):
	[ If the either room isn't currently_mapped, do nothing. ]
	if new room is not currently_mapped or old room is not currently_mapped, decide yes;
	[say "Trying to place [new room] at ([dx], [dy]) relative to [old room].";]
	[say "Normal decision.";]
	[now old room is currently_mapped;]
	[ if they're in the same region, check whether the placements are consistent. ]
	if new room is coregional with old room begin;
		[say "The coregional test.";]
		if map_x of new room is map_x of old room plus dx and map_y of new room is map_y of old room plus dy, decide yes;
		decide no;
	end if;
	[ otherwise, join the two regions ]
	let delta_x be (map_x of old room) + dx - (map_x of new room);
	let delta_y be (map_y of old room) + dy - (map_y of new room);
	repeat with loop_room running through all mappable rooms coregional with new room
	begin;
		change map_x of loop_room to (map_x of loop_room) + (delta_x);
		change map_y of loop_room to map_y of loop_room + delta_y;
	end repeat;
	now old room is coregional with new room;
	recenter the region of old room;
	decide yes.
	
To decide whether (r - a room) is not explored:
	if r is explored, decide no; decide yes.	
	
To decide whether (r - a room) has an exit to the/-- (d - a direction):
	if using the automap hide paths through closed doors option and the room-or-door d from r is a closed door, decide no;
	If the room d from r is a room, decide yes; decide no.

Section 3 - Drawing the map - Writing to the character array

To place (ch - number) at (x - a number) and (y - a number):
	(- if ( {x} >= 0 && {x} < MAP_WIDTH && {y} >=0 && {y} < MAP_HEIGHT)
		Automap_Chars -> ( {y} * MAP_WIDTH + {x} ) = {ch}; -)

[To place (ch - number) at (x - a number) and (y - a number):
	[say "Placing [ch] at [x] and [y].";]
	[if ch is 76 begin; say "Placing 76 for [map drawn room] to [map drawn direction]."; end if;]
	if x >= 0 and x < map width and y >= 0 and y < map height begin;
		hard-place ch at x and y;
	end if.]

To decide what number is the character at (sq - a number):
	(- Automap_Chars -> {sq} -);

[To decide what number is the character at (x - a number) and (y - a number):
	(- if ( {x} >= 0 && {x} < MAP_WIDTH && {y} >=0 && {y} < MAP_HEIGHT)
		return Automap_Chars -> ( {y} * MAP_WIDTH + {x} )
	else return 0; -).
]	
	
To decide what number is room size: if current zoom is map zoomed in, decide on 4; decide on 2.

Map drawn room is a mappable room that varies.  Map drawn direction is a direction that varies.

[ Draw Path ]
To draw a path from (room x - a number) and (room y - a number) to (dir - a direction) for (dist - a number) with (ch - a number):
	[if ch is 76 begin; say "Drawing path with 76 from [map drawn room] to [map drawn direction]."; end if;]
	[say "drawing path from ([room x], [room y]) to the [dir] with [ch]:[line break]";]
	now dist is (dist - 1) times room size + 1;
	let dx be the delta x of dir;
	let dy be the delta y of dir;
	let room x be room x + dx;
	let room y be room y + dy;
	while (room x >= 0 and room x < map width and room y >= 0 and room y < map height and dist > 0) begin;
		let sq be (room y * map width) + room x;
		let ch2 be the character at sq;
		if ch2 is 32 or ch2 is ch begin; do nothing; [ Drawing over a space or a matching character is normal. ]
		otherwise if ch2 is 90 or ch2 is 91; now ch is ch2; [ Drawing anything over an X or + is a nop. ]
		otherwise if ch is 35 or ch is 36; now ch is 90; [ Drawing a ne/sw over nw/se or v.v makes an X. ]
		[otherwise if ch is 35 or ch is 36; say "writing [ch] over [ch2] for X at ([room x], [room y])::[sq]."; now ch is 90;]
		otherwise if ch is 1 or ch is 2; now ch is 91; [ Drawing a n/s over e/w or v.v makes a +.]
		otherwise; say "Draw Path ha ottenuto un valore con [ch] su [ch2] in ([room x], [room y]): BUG.";
		end if;
		if ch is not ch2, place ch at room x and room y;
		now dist is dist - 1;
		now room x is room x + dx;
		now room y is room y + dy;
	end while.
	
To decide what number is the maximum of (x - a number) and (y - a number): if (x < y), decide on y; decide on x.
To decide what number is the minimum of (x - a number) and (y - a number): if (x < y), decide on x; decide on y.
	
Include (-
[ ClearMap i;
	!for (i = 0: i < MAP_WIDTH * MAP_HEIGHT: ++ i)
	for (i = MAP_WIDTH * MAP_HEIGHT - 1; i >= 0; -- i)
		Automap_Chars->i = 32; ! Empty cell
]; -);

To clear the map: (- ClearMap(); -);

[ Draw Map ]
To decide whether the map is drawn:
	if current zoom is map absent, decide no;
	if location is a mappable room begin;
		[start capturing text;]
		[say "location is a mappable room.";]
		begin the automap work activity;
		begin the automap drawing activity;
		let max_x be the map_x of location;
		let max_y be the map_y of location;
		repeat with loop_room running through the mappable rooms coregional with location begin;
			if the map_x of loop_room is greater than max_x, now max_x is the map_x of loop_room;
			if the map_y of loop_room is greater than max_y, now max_y is the map_y of loop_room;
		end repeat;
		let map_min_x be 0;
		[ If the width of the drawn map is no more than the width allocated, center the map horizontally.]
		[ Otherwise, place the map so as to center the location, unless that would go over the edge ]
		[  max (wmost, min (center - WIDTH/2, emost - WIDTH)) ]
		[let n1 be 2 + (room size) * (1 + max_x);]
		[say "[2 + (room size) * (1 + max_x)] ?>= [map width] :: [2 + (1 + the map_x of location) * (room size) - map width / 2] [(1 + max_x) * room size - map width].";]
		[say "Would center x at [((room size * (1 + max_x)) - map width) / 2] == ([room size] * [1 + max_x] - [map width]) / 2.";
		if 2 + (room size) * (1 + max_x) >= map width begin;
			[now map_min_x is the maximum of -2 and (the minimum of (2 + (1 + the map_x of location) * (room size) - map width / 2) and ((1 + max_x) * room size - map width));] [ I have no idea why the parens cause this line to fail.]
			now map_min_x is the maximum of -2 and (the minimum of (2 + (1 + the map_x of location) * (room size) - map width / 2) and (1 + max_x) * room size - map width); 
		otherwise;
			now map_min_x is (room size * (1 + max_x) - map width) / 2;
		end if;]
		if 1 is 1 begin;
			[say "room size = [room size], map width = [map width], max_x = [max_x], map_x = [ map_x of location ], ";]
			let shown_map_width be (room size) * (1 + max_x); increase shown_map_width by 1;
			[say "shown_map_width is [shown_map_width], ";]
			[let shown_map_start be shown_map_width - map width;]
			let center_location_start be (1 + the map_x of location) * room size; decrease center_location_start by 1; [ x coordinate of location ]
			[say "center location start is [center_location_start] ";]
			decrease center_location_start by room size / 2;
			[say " to [center_location_start], ";]
			[decrease center_location_start by map height / 2;]
			[decrease center_location_start by map width;
			now center_location_start is center_location_start / 2; [ x coordinate of start position that would center location ]]
			decrease center_location_start by (map width / 2);
			[say " to [center_location_start], ";]
			let eastmost_start be (1 + max_x) * room size; increase eastmost_start by 0; [ x coordinate of eastmost point ]
			now eastmost_start is eastmost_start - map width; [ x coordinate of start position that would be eastmost point at the edge ]
			[say "eastmost_start is [ eastmost_start ], ";]
			if shown_map_width > map width begin;
				[increase center_location_start by 2;]
				now map_min_x is the minimum of  center_location_start and eastmost_start;
				now map_min_x is the maximum of -1 and map_min_x;
			otherwise;
				[[now map_min_x is center_location_start;]
				[now map_min_x is shown_map_width;
				decrease map_min_x by ( map width / 2);]]
				now map_min_x is shown_map_width - map width;
				decrease map_min_x by 2;
				now map_min_x is map_min_x / 2;
				[decrease map_min_x by 1;] [compensate that (0,0) is a corner of a cell, not the center]
			end if;
			[say "map_min_x is [map_min_x].";]
			[say "room size = [room size], map width = [map width], max_x = [max_x], map_x = [ map_x of location ], shown_map_width is [shown_map_width], center location start is [center_location_start], eastmost_start is [ eastmost_start ], map_min_x is [map_min_x].";]
		end if;
		let map_min_y be 0;
		[ If the width of the drawn map is no more than the width allocated, center the map horizontally.]
		[ Otherwise, place the map so as to center the location, unless that would go over the edge ]
		[  max (nmost, min (center - WIDTH/2, smost - WIDTH)) ]
		[if 2 + (room size) * (1 + max_y) >= map height begin;
			now map_min_y is the maximum of -2 and (the minimum of (2 + (1 + the map_y of location) * (room size) - map height / 2) and (1 + max_y) * room size - map height); 
		otherwise;
			now map_min_y is (room size * (1 + max_y) - map height) / 2;
		end if;]
		if 1 is 1 begin; [ limiting the scope of the local variables ]
			[say "room size = [room size], map_height = [map height], max_y = [max_y], map_y = [ map_y of location ], ";]
			let shown_map_height be (room size) * (1 + max_y); increase shown_map_height by 1;
			[say "shown_map_height is [shown_map_height], ";]
			let center_location_start be (1 + map_y of location) * room size; decrease center_location_start by 1; [ y coordinate of location ]
			decrease center_location_start by room size / 2;
			[say "center location start is [center_location_start] ";]
			decrease center_location_start by map height / 2; [say "to [center_location_start], ";]
			let southmost_start be (1 + max_y) * room size; increase southmost_start by 0; [ y coordinate of southmost point ]
			decrease southmost_start by map height; [ y coordinate of start position that would be southmost point at the edge ]
			[say "southmost_start is [ southmost_start ], ";]
			if shown_map_height > map height begin;
				[decrease center_location_start by 2;]
				now map_min_y is the minimum of center_location_start and southmost_start;
				[decrease map_min_y by (map height minus 1) / 2;]
				now map_min_y is the maximum of -1 and map_min_y;
			otherwise;
				now map_min_y is shown_map_height - map height;
				decrease map_min_y by 2;
				now map_min_y is map_min_y / 2;
				[decrease map_min_y by 1;] [compensate that (0,0) is a corner of a cell, not the center]
			end if;
			[say "map_min_y is [map_min_y].";]
		end if;
		Clear the map;
		[reset 76;]
		repeat with loop_room running through the mappable rooms coregional with location begin;
			now map drawn room is loop_room;
			let temp_x be (the map_x of loop_room * room size) - map_min_x;
			let temp_y be (the map_y of loop_room * room size) - map_min_y;
			[say "Gridding [loop_room] at [temp_x], [temp_y]";]
			[if (temp_x + room size >= 0) and (temp_x < map width) and (temp_y + room size >= 0) and (temp_y < map height), begin;]
			[say "[temp_x + room size] >= 0 && [temp_x] < [map width] && [temp_y + room size] >= 0 && [temp_y] < [map height].";]
			if (temp_x + room size >= 0) and (temp_x < map width) and (temp_y + room size >= 0) and (temp_y < map height) begin;
				if the current zoom is map zoomed in begin;
					let offset be 0;
					if loop_room is location, now offset is 17; [ Difference between empty image chars and full image chars ]
					[check 76;]
					now map drawn direction is southwest;
					if loop_room has an exit to southwest begin;
						place sw exit + offset at temp_x and temp_y + 2;
						[draw a path from temp_x and temp_y + 2 to -1 and 1 for (the distance from loop_room to the southwest) with ne sw path;]
						draw a path from temp_x and temp_y + 2 to southwest for the distance southwest from loop_room with ne sw path;				
					otherwise;
						place sw corner + offset at temp_x and temp_y + 2;
					end if;
					[check 76;]
					now map drawn direction is northwest;
					if loop_room has an exit to northwest begin;
						place nw exit + offset at temp_x and temp_y;
						draw a path from temp_x and temp_y to northwest for the distance northwest from loop_room with nw se path;				
					otherwise;
						place nw corner + offset at temp_x and temp_y;
					end if;
					[check 76;]
					now map drawn direction is northeast;
					if loop_room has an exit to northeast begin;
						place ne exit + offset at temp_x + 2 and temp_y;
						draw a path from temp_x + 2 and temp_y to northeast for the distance northeast from loop_room with ne sw path;				
					otherwise;
						place ne corner + offset at temp_x + 2 and temp_y;
					end if;
					[check 76;]
					now map drawn direction is southeast;
					if loop_room has an exit to southeast begin;
						place se exit + offset at temp_x + 2 and temp_y + 2;
						draw a path from temp_x + 2 and temp_y + 2 to southeast for the distance southeast from loop_room with nw se path;
					otherwise;
						place se corner + offset at temp_x + 2 and temp_y + 2;
					end if;
					[check 76;]
					now map drawn direction is south;					
					if loop_room has an exit to south begin;
						place south exit + offset at temp_x + 1 and temp_y + 2;
						draw a path from temp_x + 1 and temp_y + 2 to south for the distance south from loop_room with north south path;				
					otherwise;
						place south wall + offset at temp_x + 1 and temp_y + 2;
					end if;
					[check 76;]
					now map drawn direction is north;
					if loop_room has an exit to north begin;
						place north exit + offset at temp_x + 1 and temp_y;
						draw a path from temp_x + 1 and temp_y to north for the distance north from loop_room with north south path;				
					otherwise;
						place north wall + offset at temp_x + 1 and temp_y;
					end if;
					[check 76;]
					now map drawn direction is west;
					if loop_room has an exit to west begin;
						place west exit + offset at temp_x and temp_y + 1;
						draw a path from temp_x and temp_y + 1 to west for the distance west from loop_room with east west path;				
					otherwise;
						place west wall + offset at temp_x and temp_y + 1;
					end if;
					[check 76;]
					now map drawn direction is east;
					if loop_room has an exit to east begin;
						place east exit + offset at temp_x + 2 and temp_y + 1;
						draw a path from temp_x + 2 and temp_y + 1 to east for the distance east from loop_room with east west path;				
					otherwise;
						place east wall + offset at temp_x + 2 and temp_y + 1;
					end if;
					[check 76;]
					now map drawn direction is nothing;
					[ Now, draw the central square of the room and, if needed, and up / down / questionmark arrow within ]
					place 37 + offset at temp_x + 1 and temp_y + 1; 
					now offset is 0;
					if loop_room is location, now offset is 31; [ changes up arrow to full up arrow and the like ]
					if loop_room has an exit to up and loop_room has an exit to down begin;
						place up down arrow + offset at temp_x + 1 and temp_y + 1;
					otherwise if loop_room has an exit to up;
						place up arrow + offset at temp_x + 1 and temp_y + 1;
					otherwise if loop_room has an exit to down;
						place down arrow + offset at temp_x + 1 and temp_y + 1;
					[otherwise if loop_room has an exit to inside or loop_room has an exit to outside;
						if loop_room is location begin;
							place full question arrow at temp_x + 1 and temp_y + 1;
						otherwise;
							place question arrow at temp_x + 1 and temp_y + 1;
						end if;]
					otherwise if loop_room has an exit to inside or loop_room has an exit to outside;
						let ch be automap in;
						if loop_room is location begin;
							if loop_room has an exit to inside and loop_room has an exit to outside begin;
								now ch is automap present inout;
							otherwise if loop_room has an exit to inside;
								now ch is automap present in;
							otherwise;
								now ch is automap present out;
							end if;
						otherwise;
							if loop_room has an exit to inside and loop_room has an exit to outside begin;
								now ch is automap inout;
							otherwise if loop_room has an exit to inside;
								now ch is automap in;
							otherwise;
								now ch is automap out;
							end if;
						end if;
						place ch at temp_x + 1 and temp_y + 1;
					end if;
					[check 76;]
				otherwise; [ in zoomed out mode ]
					if loop_room has an exit to southwest, draw a path from temp_x and temp_y to southwest for the distance southwest from loop_room with ne sw path;
					if loop_room has an exit to northwest, draw a path from temp_x and temp_y to northwest for the distance northwest from loop_room with nw se path;
					if loop_room has an exit to southeast, draw a path from temp_x and temp_y to southeast for the distance southeast from loop_room with nw se path;
					if loop_room has an exit to northeast, draw a path from temp_x and temp_y to northeast for the distance northeast from loop_room with ne sw path;
					if loop_room has an exit to south, draw a path from temp_x and temp_y to south for the distance south from loop_room with north south path;
					if loop_room has an exit to north, draw a path from temp_x and temp_y to north for the distance north from loop_room with north south path;
					if loop_room has an exit to east, draw a path from temp_x and temp_y to east for the distance east from loop_room with east west path;
					if loop_room has an exit to west, draw a path from temp_x and temp_y to west for the distance west from loop_room with east west path;
					let offset be 0;
					if loop_room is location, now offset is 31;
					if loop_room has an exit to up and loop_room has an exit to down begin;
						place up down arrow + offset at temp_x and temp_y;
					otherwise if loop_room has an exit to up;
						place up arrow + offset at temp_x and temp_y;
					otherwise if loop_room has an exit to down;
						place down arrow + offset at temp_x and temp_y;
					otherwise if loop_room has an exit to inside or loop_room has an exit to outside;
						[if loop_room is location begin;
							place full question arrow at temp_x and temp_y;
						otherwise;
							place question arrow at temp_x and temp_y;
						end if;]
						let ch be automap in;
						if loop_room is location begin;
							if loop_room has an exit to inside and loop_room has an exit to outside begin;
								now ch is automap present inout;
							otherwise if loop_room has an exit to inside;
								now ch is automap present in;
							otherwise;
								now ch is automap present out;
							end if;
						otherwise;
							if loop_room has an exit to inside and loop_room has an exit to outside begin;
								now ch is automap inout;
							otherwise if loop_room has an exit to inside;
								now ch is automap in;
							otherwise;
								now ch is automap out;
							end if;
						end if;
						place ch at temp_x and temp_y;
					otherwise if loop_room is location;
						place full room at temp_x and temp_y;
					otherwise;
						place empty room at temp_x and temp_y;
					end if;
				end if;
				now map drawn room is nothing;
			end if;
		end repeat;
		end the automap drawing activity;
		end the automap work activity;
		[stop capturing text;]
		decide yes;
	end if;
	[stop capturing text;]
	decide no.					
	
Section 4 - Displaying the map
	
[ Adapted from Emily Short's Basic Screen Effects ]
To fill status bar with (selected table - a table-name) and map:
        let __n be the number of rows in the selected table;
	if the current zoom is map absent begin;
	        deepen status line to __n rows;
	otherwise;
	        deepen status line to __n + map height rows;
	end if;
	let __index be 1;
        repeat through selected table
        begin;
                move cursor to __index; 
                say "[left entry]";
                center central entry at row __index;
                right align cursor to __index;
                say "[right entry]";
                change __index to __index + 1;
        end repeat;
	if the map is drawn and the current zoom is not map absent, display the map at line __n;
	[if __b and the current zoom is not map absent, display the map at line __n + 1;]
		
Before constructing the status line (this is the automap add adjacent rooms to map rule) : if not using the automap manual exploration option and the location is a mappable room and the location is not explored, say "Errore nell[']esplorare [location]."

Rule for constructing the status line (this is the automap standard status line rule):
	fill status bar with table of ordinary status and map.

To display the map at line (n - a number):
	(- I6_Draw_Map_At ({n}); -).



Include (-

#ifdef DONTUSE_THIS;
[ I6_Draw_Map_At line_n width posa posb ctr ch graphic_mode;
	!#ifdef TARGET_ZCODE;
	++ line_n;
	!#endif;
	!return;
	!!VM_MainWindow();
	!!@set_font 1 -> posa;
	!!@set_cursor 1 1; style roman; @set_window 0; font on; !@split_window 1;
	!!return;
	!!print "I6_Draw_Map_At : rows = ", MAP_HEIGHT, ", columns = ", MAP_WIDTH, ".^";

	posa = line_n + 1;	
	!posa = MAP_HEIGHT + 1;
	!!DeepStatus (line_n + MAP_HEIGHT);
	!#ifdef TARGET_GLULX;
	!!!VM_StatusLineHeight (MAP_HEIGHT + line_n); ! How do I deepen the status line and have it be remembered? TODO
	!#endif;
	!!VM_StatusWindow();
	!!if (VM_StatusLineHeight() < MAP_HEIGHT + line_n) VM_StatusLineHeight (MAP_HEIGHT + line_n);
	
	!#ifdef TARGET_ZCODE; @set_window 0; #endif;
	!!print "line 1"; ! uncomment
	
	width = VM_ScreenWidth();
	!!print "width = ", width, "^";
	graphic_mode = 0;
	!!print "line 2"; ! uncomment
	if ( (+ current displayness +) == (+ map display fancy +) or (+ map display automatic +) ) {
		!!print "line 3"; ! uncomment
		#Ifdef TARGET_ZCODE;
		@set_font 3 graphic_mode; ! TODO: Make this glulx friendly
		#endif;
		!!print "line 4"; ! uncomment region
		!!if ( (+ current displayness +) == (+ map display fancy +) ) ! XYZZY1
		!!	graphic_mode = 3; ! XYZZY 1
		!!print "line 5";
	}
	!!print "About to preproc map^"; ! uncomment
	!!Automap_Chars->20 = 35; ! XYZZY2
	if (graphic_mode == 0) {
		for (ctr = 0: ctr < MAP_HEIGHT * MAP_WIDTH: ++ ctr) {
			ch = Automap_Chars -> ctr;
			if (ch ~= 32) {
				if (ch == 35 or 50 or 52) ch = '/';
				else if (ch == 36 or 51 or 53) ch = '\';
				else if (ch == 40 or 41) ch = '|';
				else if (ch == 38 or 39) ch = '-';
				else if (ch == 91 or 42 or 43 or 44 or 45) ch = '+';
				else if (ch >= 54 && ch <= 70) ch = '*';
				else if (ch == 37) ch = ' ';
				else if (ch >= 37 && ch <= 53 || ch == 95) ch = 'o';
				else if (ch == 90) ch = 'X';
				else if (ch == 92) ch = 'U'; else if (ch == 123) ch = 'u';
				!else if (ch == 92 or 123) ch = 'U';
				else if (ch == 93) ch = 'D'; else if (ch == 124) ch = 'd';
				!else if (ch == 93 or 124) ch = 'D';
				else if (ch == 94 or 125) ch = ';';
				else if (ch == AUTOMAP_CHAR_IN || ch == AUTOMAP_CHAR_INOUT) ch = 'I';
				else if (ch == AUTOMAP_CHAR_OUT) ch = 'O';
				else if (ch == AUTOMAP_CHAR_PRESENT_IN || ch == AUTOMAP_CHAR_PRESENT_INOUT) ch = 'i';
				else if (ch == AUTOMAP_CHAR_PRESENT_OUT) ch = 'o';
				else if (ch == AUTOMAP_CHAR_DARK || ch == AUTOMAP_CHAR_PRESENT_DARK) ch = '?';
				!else if (ch == 96 or 126) ch = '?';
				else if (ch == 2) ch = '|';
				else if (ch == 1) ch = '-';
				else {
					print "Bad number ", ch, " in map.^";
					ch = '?';
				}
																Automap_Chars -> ctr = ch;
			} else {
				#ifdef AUTOMAP_VISIBLE_BACKGROUND;
				Automap_Chars->ctr = '.';
				#endif;
			}
		}
	} else { ! graphic_mode ~= 0
		for (ctr = 0: ctr < MAP_HEIGHT * MAP_WIDTH: ++ ctr) {
			ch = Automap_Chars -> ctr;
			if (ch == 1) Automap_Chars->ctr = 38;
			else if (ch == 2) Automap_Chars->ctr = 40;
			else if (ch == AUTOMAP_CHAR_IN or AUTOMAP_CHAR_OUT or AUTOMAP_CHAR_INOUT or AUTOMAP_CHAR_DARK) Automap_Chars->ctr = 96;
			else if (ch == AUTOMAP_CHAR_PRESENT_IN or AUTOMAP_CHAR_PRESENT_OUT or AUTOMAP_CHAR_PRESENT_INOUT or AUTOMAP_CHAR_PRESENT_DARK) Automap_Chars->ctr = 126;
			else {
				#ifdef AUTOMAP_VISIBLE_BACKGROUND;
				if (ch == 32) Automap_Chars->ctr = 71;
				#endif;
			}
		}
	}
	!!Automap_Chars->1 = 35;
	!!print "Preproc'ed map^";
	#ifdef TARGET_ZCODE;
	@set_window 1;
	#ifnot;
	! TODO
	#endif;
	ctr = 0;
	for (posa = line_n: posa < MAP_HEIGHT + line_n: ++ posa) {
		!!VM_MainWindow(); print "posa = ", posa, "^";
		posb = width - MAP_WIDTH - 1;
		!!#ifdef TARGET_ZCODE;
		!!@set_cursor posa posb;
		!!#ifnot;
		!!print "^";
		!!! TODO
		!!#endif;
		VM_MoveCursorInStatusLine (posa, posb);;
		!VM_MoveCursorInStatusLine (posa, 0); spaces posb;
		!! TODO: For some reason, if I use the first method, the map is placed differently on the first turn,
		!!   (Also, if the window is resized, the old map can stick around; that's why I changed it.)
		!! With the second, the map isn't drawn at all on the first turn, for some reason.
		
		for (posb = 0: posb < MAP_WIDTH: ++ posb) {
			!!VM_MoveCursorInStatusLine (posa, posb);
			print (char) Automap_Chars->( ctr ++ );
			!!VM_MainWindow(); print Automap_Chars->(ctr  - 1), " ";
		}
		print " ";
	}
	!VM_MoveCursorInStatusLine (posa, 1);
	#ifdef TARGET_ZCODE;
	if (graphic_mode ~= 0)
		@set_font 1 posa;
	!@set_cursor 1 1;
	style roman;
	!@set_window 0;
	font on;
	!!@split_window 1;
	!print "graphic mode was ", graphic_mode, "^";
	!!VM_StatusLineHeight(1);
	#ifnot;
	!VM_MainWindow();
	! TODO
	#endif;
];
#endif;

Array Automap_Font_0_Conv -> 0 45 124 73 79 73 105 111 105 63 63 11 12 13 14 15 ! 0 - 15
     16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 ! 16 - 31
     32 33 34 47 92 32 45 45 124 124 43 43 43 43 111 111 ! 32 - 47
     111 111 47 92 47 92 42 42 42 42 42 42 42 42 42 42 ! 48 - 63
     42 42 42 42 42 42 42 71 72 73 74 75 76 77 78 79 ! 64 - 79
     80 81 82 83 84 85 86 87 88 89 88 43 85 68 59 111 ! 80 - 95
     96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 ! 96 - 111
     112 113 114 115 116 117 118 119 120 121 122 117 100 59 126 127 ! 112 - 127
     ;
Array Automap_Font_3_Conv -> 0 38 40 96 96 96 126 126 126 96 126 11 12 13 14 15 ! 0 -  15
     16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 ! 16 -  31
     71 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 ! 32 -  47
     48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 ! 48 -  63
     64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 ! 64 -  79
     80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 ! 80 -  95
     96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 ! 96 -  111
     112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 ! 112 -  127
     ;

[ I6_Draw_Map_At line_n width posa posb ctr ch graphic_mode transform_table;
	++ line_n;
	posa = line_n + 1;	
	width = VM_ScreenWidth();
	graphic_mode = 0;

	if ( (+ current displayness +) == (+ map display fancy +) or (+ map display automatic +) ) {
		#Ifdef TARGET_ZCODE;
		@set_font 3 graphic_mode; ! TODO: Make this glulx friendly
		#endif;
	}
	transform_table = Automap_Font_0_Conv;
	if (graphic_mode == 0) {
		#ifdef AUTOMAP_VISIBLE_BACKGROUND;
		transform_table->32 = '.';
		#endif;
	} else {
		transform_table = Automap_Font_3_Conv;
		#ifdef AUTOMAP_VISIBLE_BACKGROUND;
		transform_table->32 = 71;
		#endif;
	}
	
	#ifdef TARGET_ZCODE;
	@set_window 1;
	#ifnot;
	! TODO
	#endif;

	ctr = 0;
	for (posa = line_n: posa < MAP_HEIGHT + line_n: ++ posa) {
		posb = width - MAP_WIDTH - 1;
		VM_MoveCursorInStatusLine (posa, posb);;

		for (posb = 0: posb < MAP_WIDTH: ++ posb) {
			print (char) transform_table->(Automap_Chars->( ctr ++ ));
		}
	}
	#ifdef TARGET_ZCODE;
	if (graphic_mode ~= 0)
		@set_font 1 posa;
	style roman;
	font on;
	#ifnot;
	! TODO
	#endif;
];
	
#ifdef DONTUSE_THIS;
[ ConvertAutomap ch ach;
	print "Automap_Font_0_Conv -> ";
	for (ach = 0: ach < 128: ++ ach) {
		ch = ach;
		if (ch ~= 32) {
			if (ach == 35 or 50 or 52) ch = '/';
			else if (ach == 36 or 51 or 53) ch = '\';
			else if (ach == 40 or 41) ch = '|';
			else if (ach == 38 or 39) ch = '-';
			else if (ach == 91 or 42 or 43 or 44 or 45) ch = '+';
			else if (ach >= 54 && ch <= 70) ch = '*';
			else if (ach == 37) ch = ' ';
			else if (ach >= 37 && ch <= 53 || ch == 95) ch = 'o';
			else if (ach == 90) ch = 'X';
			else if (ach == 92) ch = 'U'; else if (ch == 123) ch = 'u';
			!else if (ach == 92 or 123) ch = 'U';
			else if (ach == 93) ch = 'D'; else if (ch == 124) ch = 'd';
			!else if (ach == 93 or 124) ch = 'D';
			else if (ach == 94 or 125) ch = ';';
			else if (ach == AUTOMAP_CHAR_IN || ch == AUTOMAP_CHAR_INOUT) ch = 'I';
			else if (ach == AUTOMAP_CHAR_OUT) ch = 'O';
			else if (ach == AUTOMAP_CHAR_PRESENT_IN || ch == AUTOMAP_CHAR_PRESENT_INOUT) ch = 'i';
			else if (ach == AUTOMAP_CHAR_PRESENT_OUT) ch = 'o';
			else if (ach == AUTOMAP_CHAR_DARK || ch == AUTOMAP_CHAR_PRESENT_DARK) ch = '?';
			!else if (ach == 96 or 126) ch = '?';
			else if (ach == 2) ch = '|';
			else if (ach == 1) ch = '-';
			else {
				!print "Bad number ", ch, " in map.^";
				!ach = '?';
			}
		}
		print ch, " ";
		if ( (ach + 1) % 16 == 0) print "! ", ach-15, " - ", ach, "^     ";
	}
	print ";^Automap_Font_3_Conv -> ";
	for (ach = 0: ach < 128: ++ ach) {
		ch = 0;
		if (ach == 1) ch = 38;
		else if (ach == 2) ch = 40;
		else if (ach == AUTOMAP_CHAR_IN or AUTOMAP_CHAR_OUT or AUTOMAP_CHAR_INOUT or AUTOMAP_CHAR_DARK) ch = 96;
		else if (ach == AUTOMAP_CHAR_PRESENT_IN or AUTOMAP_CHAR_PRESENT_OUT or AUTOMAP_CHAR_PRESENT_INOUT or AUTOMAP_CHAR_PRESENT_DARK) ch = 126;
		else {
			#ifdef AUTOMAP_VISIBLE_BACKGROUND;
			if (ach == 32) ch = 71;
			#endif;
		}
		print ch, " ";
		if ( (ach + 1) % 16 == 0) print "! ", ach-15, " -  ", ach, "^     ";		
	}	
	print ";^";
];
#endif;
-);


To say (n - a number) blank lines:
	while n > 0:
		say "[line break]";
		decrease n by 1.

Section 99 - Debug verbs - Not for release

Map viewing is an action out of world applying to nothing.  Understand "map view" as map viewing.

Carry out map viewing:
	say "Viewing rooms coregional with [location].";
	repeat with viewed room running through all rooms coregional with location begin;
		say "[viewed room] [if viewed room is not currently_mapped](currently unmapped ???) [end if]is at [map_x of viewed room], [map_y of viewed room].";
	end repeat;
	say "[line break]Viewing rooms not coregional with [location].";
	repeat with viewed room running through all rooms not coregional with location begin;
		say "[viewed room] [if viewed room is not currently_mapped](currently unmapped) [end if]is at [map_x of viewed room], [map_y of viewed room].";
	end repeat;

Map dumping is an action out of world applying to nothing.  Understand "map dump" as map dumping.

Include (-
[ Automap_dump i;
	for (i = 0: i < MAP_WIDTH * MAP_HEIGHT; ++ i)
		print Automap_chars->i, " ";
];
-);

To say automap dump:
	(- Automap_dump(); -).

Carry out map dumping:
	say "MAP DUMP:[line break][automap dump].".
	
Automap IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di Automap by Mark Tilford.