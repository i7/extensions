Version 1 of Disappearing Doors by Andrew Plotkin begins here.

"The ability to remove doors from the world and put them back."

Definition: a door is absent rather than present if I6 routine "AssertDoorAbsent" makes it so (it is out of scope and untraversible).

Include (-
[ AssertDoorAbsent door flag
	addr rm1 rm2 dir1 dir2 off1 off2;
	
	if (flag == -1) {
		return (door has absent);
	}
	
	! door.found_in should be a list of two rooms, which is I7's normal arrangement
	addr = door.&found_in;
	if (addr == 0 || door.#found_in ~= 2*WORDSIZE)
		print_ret "(BUG) Cannot activate/deactivate door: malformed found_in: ", (name) door;
	rm1 = addr-->0;
	rm2 = addr-->1;
	
	@push location;
	location = rm1;
	dir1 = door.door_dir();
	location = rm2;
	dir2 = door.door_dir();
	@pull location;
	
	if (~~(dir1 ofclass (+ direction +) && dir2 ofclass (+ direction +) ))
		print_ret "(BUG) Cannot activate/deactivate door: directions not found: ", (name) door;
	
	off1 = ((rm1.IK1_Count)*No_Directions + dir1.IK3_Count);
	off2 = ((rm2.IK1_Count)*No_Directions + dir2.IK3_Count);

	if (flag) {
		if (door hasnt absent) {
			SignalMapChange();
			
			if (Map_Storage-->off1 == door)
				Map_Storage-->off1 = 0;
			else
				print "(BUG) Map_Storage from door does not match^";
			if (Map_Storage-->off2 == door)
				Map_Storage-->off2 = 0;
			else
				print "(BUG) Map_Storage from door does not match^";
			
			give door absent;
			remove door;
		}
	}
	else {
		if (door has absent) {
			SignalMapChange();
			
			if (Map_Storage-->off1 == 0)
				Map_Storage-->off1 = door;
			else
				print "(BUG) Map_Storage from door does not match^";
			if (Map_Storage-->off2 == 0)
				Map_Storage-->off2 = door;
			else
				print "(BUG) Map_Storage from door does not match^";
			
			give door ~absent;
			if (rm1 == real_location || rm2 == real_location)
				move door to real_location;
			else
				remove door;
		}
	}
];
-) after "Map Connections" in "WorldModel.i6t".

Disappearing Doors ends here.

---- DOCUMENTATION ----

The Standard Rules let you "change the (direction) exit of (room) to (room)", but doors are fixed in place on the map. This extension does not allow you to move doors around, but it does let you make a door disappear and then reappear in the same place.

This is done through a "present" (or "absent") property of doors. So you can write:

	now the magic door is absent;
	now the magic door is present;
	
	if the magic door is absent: ...
	if the magic door is present: ...

Doors always start as "present". If you want an initially hidden door to be revealed (a common case) then you must say:

	When play begins:
		now the secret door is absent.

When a door disappears, it leaves no exit where it was previously connected. You can reconnect those directions to other rooms, but you must disconnect them before you make the door present again.

Making a door disappear or reappear does not affect whether it is open, closed, locked, or unlocked.

A one-sided door cannot be made absent. This extension only works on two-sided doors.

(This extension has been tested with Inform 6G60 and 6L38.)

Example: *  The Prisoner of La-Z-enda - A simple demonstration of an appearing door.

	*: "The Prisoner of La-Z-enda"

	Include Disappearing Doors by Andrew Plotkin.

	The Prison Cell is a room. "These four stone walls are all you have seen of the world for thirty-five interminable minutes. [if the steel door is absent]There is no way in or out. Except for the[else]There's an[end if] escape tunnel to the northeast[if the Tunnel is not visited], but that looks terribly uncomfortable, so you've never tried it[end if]."

	Instead of going nowhere in the Prison Cell:
		say "The walls are obdurate."

	The steel door is a door. The steel door is north of the Prison Cell. "A door beckons in the [direction of steel door from location] wall!"

	The Tunnel is a room. "The tunnel is less uncomfortable than you'd been led to believe. Your cell is southwest, and sweet freedom is northwest."
	The Tunnel is southeast of the Hallway.
	The Tunnel is northeast of the Prison Cell.

	The Hallway is north of the steel door. "Many's the time you've imagined this corridor. It lives up to your expectations. The rest of your life is to the west."

	Instead of going west in the Hallway:
		end the story finally saying "Freedom".

	When play begins:
		now the steel door is absent.

	The doorbell is carried by the player.
	Understand "button", "bell", "device" as the doorbell.

	The doorbell can be ever-tried.

	The description of the doorbell is "It's a little bell-shaped device with a button on it. You once heard that pushing the button would make a door appear or disappear. [if the doorbell is not ever-tried]You've never bothered to try it.[else]Guess it works.[end if]"

	Instead of pushing the doorbell:
		now the doorbell is ever-tried;
		if the steel door is present:
			if the steel door is in the location:
				say "The steel door disappears.";
			else:
				say "Click. Nothing seems to happen.";
			now the steel door is absent;
		else:
			now the steel door is present;
			if the steel door is in the location:
				say "A steel door appears!";
			else:
				say "Click. Nothing seems to happen."

	Test me with "north / push button / look / north / examine door / push button / look / examine door / west".
