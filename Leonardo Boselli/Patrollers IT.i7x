Version 11 of Patrollers IT by Leonardo Boselli begins here.

"Based on Version 11 of Patrollers by Michael Callaghan."

"Allows a non player character to follow routes defined by rooms, directions, random journeys, the player's location or to a destination."

Chapter 1 - Define a Patroller

Section 1.1 - The Patroller Kind

A Patroller is a kind of person.

The specification of a Patroller is "Represents a non-player character whose movements we can control by setting out the character's route (specifying rooms to visit or directions to follow) or who can move randomly between rooms, to a specific destination or who can shadow the player's movements."

Section 1.2 - Define whether the Patroller is On Patrol or Off Patrol

Status is a kind of Value.  The Statuses are On Patrol and Off Patrol.

A Patroller has a Status.  A Patroller is usually Off Patrol.

Section 1.3 - Specify how a Patroller's route is defined

MovementType is a kind of Value.  The MovementTypes are RoomLed, DirectionLed, Following, Aimless and Targeted.

[RoomLed		The Patroller's route is set out in a table of rooms to visit.
DirectionLed		The Patroller's route is set out in a table of directions to follow.
Following		The Patroller follows the best route to the player.
Aimless			The Patroller's route is random.
Targeted		The Patroller follows the best route to a destination.]

A Patroller has a MovementType.  A Patroller is usually RoomLed.

Section 1.4 - Define the types of route that a Patroller can follow

Route is a kind of value.  The Routes are OneWay, TwoWay, TwoWayRepeated and Circular.

[OneWay		The Patroller goes from A to B then stops.
TwoWay			The Patroller goes from A to B then B to A and stops.
TwoWayRepeated		The Patroller goes from A to B then B to A repeatedly.
Circular			The Patroller goes from A to B to A repeatedly.]

A Patroller has a Route. A Patroller is usually OneWay.

Section 1.5 - Specify where the Patroller's route is defined (relevant unless the Route is Aimless or Targeted)

A Patroller has a table-name called RoomTable. The RoomTable of a Patroller is usually Table of NoRooms.
A Patroller has a table-name called DirectionTable. The DirectionTable of a Patroller is usually Table of NoDirections.

Section 1.6 - Specify dummy tables for the Patroller 's route

Table of NoRooms
TargetRoom
--
a Room

Table of NoDirections
TargetDirection
--
a Direction

Section 1.7 - Define a destination for Targeted Patrollers

A Patroller has a Room called Destination.

Section 1.8 - Define a value to determine if a Patroller is on the outward or inward journey for TwoWay and TwoWayRepeated Routes

RouteLeg is a kind of value.  The RouteLegs are OutwardBound and InwardBound.

A Patroller has a RouteLeg. A Patroller is usually OutwardBound.

Section 1.9 - Define values to determine the length of the Patroller's route and the position of the Patroller along that route

The Patroller has a number called PathLength. The PathLength of a Patroller is usually 1.
The Patroller has a number called PathStage. The PathStage of a Patroller is usually 1.

Section 1.10 - Define the probability that a Patroller will move on any given turn as a percentage

A Patroller has a number called Drive.  The Drive of a Patroller is usually 100.

Section 1.11 - Define the door opening capability of the Patroller

OpeningCapability is a kind of value.  The OpeningCapabilities are Universal, WithKey, UnlockedOnly and None.

[Universal		The Patroller can get through any locked door.
WithKey			The Patroller can get through locked doors if s/he holds the matching key.
UnlockedOnly		The Patroller can get through unlocked doors only
None			The Patroller cannot get through any closed door

Note:  Open doors are not treated as a barrier to the Patroller's movement.]

A Patroller has an OpeningCapability.  The OpeningCapability of a Patroller is usually None.

Section 1.12 - Define the door reclosing capability of the Patroller

ReclosingCapability is a kind of value.  The ReclosingCapabilities are Leave and Reinstate.

[Leave			The Patroller will not close a door after s/he has opened it.
Reinstate		The Patroller will return the door to its previous state after passing through it.]

A Patroller has a ReclosingCapability.  The ReclosingCapability of a Patroller is usually Leave.

Section 1.13 - Define the frequency of the patroller's movement

A Patroller has a number called Turn Frequency.  The Turn Frequency of a Patroller is usually 1.

[A Turn Frequency of 1 means move every turn (if the patroller is On Patrol), 2 means move every other turn, etc.]

Section 1.14 - Define  the start turn when the patroller becomes On Patrol

A Patroller has a number called StartTurn.

Section 1.15 - Define if rooms are ordinarily accessible to a patroller

To decide if (R - a room) is off-limits to (P - a Patroller):
	decide no.

Section 1.16 - Reporting movements of patrollers

Reporting Status is a kind of value.  The Reporting Statuses are Individual and Collective.
Reporting is a Reporting Status that varies.  Reporting is usually Individual.

Arrival List is a list of Patrollers that varies.
Departure List is a list of Patrollers that varies.

Section 1.17 - Flag to trap  best route returning nothing as a value

RouteAvailable is a truth state that varies.

Chapter 2 -  Patrolling Activity

Section 2.1 - Initialize Room Led Patrollers

When Play begins (this is the initialize room-led patrollers rule):
	repeat with Bod running through RoomLed Patrollers:
		now the PathLength of the Bod is the number of rows in the RoomTable of the Bod;
		now the PathStage of the Bod is 2.

Section 2.2 - Initialize Direction Led Patrollers

When Play begins (this is the initialize direction-led patrollers rule):
	repeat with Bod running through DirectionLed Patrollers:
		now the PathLength of the Bod is the number of rows in the DirectionTable of the Bod;
		now the PathStage of the Bod is 1.

Section 2.3 - Define the in-play movements of a Patroller

Every turn (this is the carry out patrolling rule):
	truncate the Arrival List to 0 entries;
	truncate the Departure List to 0 entries;
	repeat with Bod running through On Patrol Patrollers:
		if the Bod is ready to move:
			if a random chance of Drive of the Bod in 100 succeeds:
				carry out the Patrolling activity with the Bod;
	if Reporting is Collective:
		if the number of entries in the arrival list is not 0:
			report arrivals;
		if the number of entries in the departure list is not 0:
			report departures.

Chapter 3 - Define rules move moving patrollers

Section 3.1 - Set up the patrolling activity and associated variables

Patrolling something is an activity.
The Patrolling activity has a room called CurrentRoom.
The Patrolling activity has a room called NextRoom.
The Patrolling activity has a direction called Way.
The Patrolling activity has an object called Obstacle.
The Patrolling activity has a truth state called ObstacleLocked.
The Patrolling activity has a truth state called ObstacleClosed.

Section 3.2 - Before rules for the patrolling activity

Before Patrolling something (called the Bod) (this is the set current room for patrollers rule):
	if the Bod is a Patroller:
		now RouteAvailable is true;
		now the CurrentRoom is the location of the Bod.

Before Patrolling something (called the Bod) (this is the set room-led patrollers rule):
	if the Bod is a RoomLed Patroller:
		[Find the correct row in the Patroller's room table.]
		choose row PathStage of the Bod in the RoomTable of the Bod;
		[Set the NextRoom from the room table.]
		now the NextRoom is the TargetRoom entry;
		[Calculate the route to the next room.]
		let tempWay be the best route from the CurrentRoom to the NextRoom, using even locked doors;
		if tempWay is nothing:
			now RouteAvailable is false;
		otherwise:
			now the Way is tempWay.

Before Patrolling something (called the Bod) (this is the set direction-led patrollers rule):
	if the Bod is a DirectionLed Patroller:
		[Find the correct row in the Patroller's direction table.]
		choose row PathStage of the Bod in the DirectionTable of the Bod;
		[Set the direction if the Patroller is Outward Bound.]
		if the Bod is OutwardBound:
			now the Way is the TargetDirection entry;
		[Set the opposite direction if the Patroller in InwardBound.]
		if the Bod is InwardBound:
			now the Way is the opposite of the TargetDirection entry.

Before Patrolling something (called the Bod) (this is the set aimless patrollers rule):
	if the Bod is an Aimless Patroller:
		[Create a list to hold adjoining rooms.  We do this as a room on the other side of a door is not captured by the adjacent rooms command.]
		let RoomList be a list of objects;
		[Test each direction from the current room.]
		repeat with TestWay running through directions:
			[Look for rooms or doors]
			let NewPlace be the room-or-door the TestWay from the CurrentRoom;
			[if there is a room, add it to the room list.]
			if NewPlace is a room:
				unless NewPlace is off-limits to the Bod:
					add NewPlace to the RoomList;
			[if there is a door, add the other side of the door to the list.]
			if NewPlace is a door:
				unless the other side of NewPlace is off-limits to the Bod:
					add the other side of NewPlace to the RoomList;
		if the number of entries in RoomList is greater than 0:
			[Choose a random room from the list.]
			let Counter be a random number between 1 and the number of entries in RoomList;
			now NextRoom is entry Counter of RoomList;
		otherwise:
			[if there are no exits, setting the Next Room as the current room will ensure that Way is returned as nothing.]
			now NextRoom is the CurrentRoom;
		[Set the new direction to the way to the room.]
		let tempWay be the best route from the CurrentRoom to the NextRoom, using even locked doors;
		if tempWay is nothing:
			now RouteAvailable is false;
		otherwise:
			now the Way is tempWay.

Before Patrolling something (called the Bod) (this is the set following patrollers rule):
	if the Bod is Following Patroller:
		let tempWay be the best route from the CurrentRoom to the location of the player, using even locked doors;
		if tempWay is nothing:
			now RouteAvailable is false;
		otherwise:
			now the Way is tempWay.

Before Patrolling something (called the Bod) (this is the set targeted patrollers rule):
	if the Bod is Targeted Patroller:
		let tempWay be the best route from the CurrentRoom to the Destination of the Bod, using even locked doors;
		if tempWay is nothing:
			now RouteAvailable is false;
		otherwise:
			now the Way is tempWay.

Before Patrolling something (called the Bod) (this is the test obstacles for patrollers rule):
	if the Bod is a Patroller and RouteAvailable is true:
		let Target be the room-or-door the Way from the CurrentRoom;
		if the Target is a door:
			now Obstacle is the Target;
			if the Obstacle is locked:
				now ObstacleLocked is true;
			otherwise:
				now ObstacleLocked is false;
			if the Obstacle is closed:
				now ObstacleClosed is true;
			otherwise:
				now ObstacleClosed is false;
			now NextRoom is the other side of the Target from the CurrentRoom;
		otherwise:
			now NextRoom is the Target.

Before Patrolling something (called the Bod) (this is the try opening doors for patrollers rule):
	if the Bod is a Patroller:
		if the Obstacle is an openable closed door:
			if the Obstacle is locked and the Obstacle is lockable:
				if the OpeningCapability of the Bod is Universal:
					now the Obstacle is open;
					now the Obstacle is unlocked;
					if the CurrentRoom is the location of the player and Reporting is Individual:
						report seen unlocking and opening of the obstacle by the Bod;
					if the NextRoom is the location of the player and Reporting is Individual:
						report unseen unlocking and opening of the obstacle;
				if the OpeningCapability of the Bod is WithKey:
					if the Bod encloses the matching key of the Obstacle:
						now the Obstacle is open;
						now the Obstacle is unlocked;
						if the CurrentRoom is the location of the player and Reporting is Individual:
							report seen unlocking and opening of the obstacle by the Bod;
						if the NextRoom is the location of the player and Reporting is Individual:
							report unseen unlocking and opening of the obstacle;
			otherwise if the Obstacle is unlocked:
				if the OpeningCapability of the Bod is not None:
					now the Obstacle is open;
					if the CurrentRoom is the location of the player and Reporting is Individual:
						report seen opening of the obstacle by the Bod;
					if the NextRoom is the location of the player and Reporting is Individual:
						report unseen opening of the obstacle.

Section 3.3 - Carry out moving the Patroller

For Patrolling something (called the Bod) (this is the move patrollers rule):
	if the Bod is a Patroller and RouteAvailable is true:
		unless the NextRoom is off-limits to the Bod:
			try the Bod going the Way;
		if the location of the Bod is not the CurrentRoom:
			if the location of the Bod is the location of the Player:
				if Reporting is Collective:
					add the Bod to the Arrival List;
				if Reporting is Individual:
					if the Way is up:
						report arrival of the Bod up from the CurrentRoom;
					otherwise:
						if the Way is down:
							report arrival of the Bod down from the CurrentRoom;
						otherwise:
							report arrival of the Bod coming the opposite of the Way from the CurrentRoom;
			if the location of the Player is the CurrentRoom:
				if Reporting is Collective:
					add the Bod to the Departure List;
				if Reporting is Individual:
					report departure of the Bod going the Way to the NextRoom.

Section 3.4 - After moving the Patroller

After Patrolling something (called the Bod) (this is the update route for patrollers rule):
	[Rules for Patrollers that have route tables.]
	if the Bod is a RoomLed Patroller or the Bod is a DirectionLed Patroller:
		[Only update information if the Patroller moved.]
		if the Location of the Bod is not the CurrentRoom:
			[Rules for Patrollers that are Outward Bound.]
			if the Bod is OutwardBound:
				[Increase the PathStage of the Patroller.]
				increase the PathStage of the Bod by 1;
				[Determine what happens if the Patroller is at the end of the route.]
				if the PathStage of the Bod is greater than the PathLength of the Bod:
					[OneWay Patrollers stop at the end of their route.]
					if the Bod is OneWay, now the Bod is Off Patrol;
					[TwoWay and TwoWayRepeated Patrollers retrace their route.]
					if the Bod is TwoWay or the Bod is TwoWayRepeated:
						[Set the Patroller to retrace the route.]
						now the Bod is InwardBound;
						[Set the correct stage on the route for the Patroller.]
						if the Bod is RoomLed:
							now the PathStage of the Bod is the PathLength of the Bod minus 1;
						if the Bod is DirectionLed:
							now the PathStage of the Bod is the PathLength of the Bod;
					[Circular Patrollers return to the beginning of their route.]
					if the Bod is Circular:
						now the PathStage of the Bod is 1;
			otherwise:
				[Rules for Patrollers that are InwardBound.]
				[Decrease the PathStage of the Patroller.]
				decrease the PathStage of the Bod by 1;
				[Determine what happens if the Patroller is at the beginning of the route.]
				if the PathStage of the Bod is 0:
					[TwoWay Patrollers stop when they arrive back at the beginning of their route.]
					if the Bod is TwoWay:
						now the Bod is Off Patrol;
					[TwoWayRepeated Patrollers start the route all over again.]
					if the Bod is TwoWayRepeated:
						[Set the correct stage on the route for the Patroller.]
						if the Bod is RoomLed:
							now the PathStage of the Bod is 2;
						if the Bod is DirectionLed:
							now the PathStage of the Bod is 1;
						now the Bod is OutwardBound.

After Patrolling something (called the Bod) (this is the reclose doors for patrollers rule):
	if the Bod is a Patroller:
		if the location of the Bod is not the CurrentRoom:
			if the ReclosingCapability of the Bod is reinstate:
				if the Obstacle is an openable door:
					if ObstacleClosed is true and ObstacleLocked is true:
						now the Obstacle is closed;
						now the Obstacle is locked;
						if the CurrentRoom is the location of the player and Reporting is Individual:
							report closing and locking of the obstacle by the Bod;
						if the NextRoom is the location of the player and Reporting is Individual:
							report closing and locking of the obstacle by the Bod;
					if ObstacleClosed is true and ObstacleLocked is false:
						now the Obstacle is closed;
						if the CurrentRoom is the location of the player and Reporting is Individual:
							report closing of the obstacle by the Bod;
						if the NextRoom is the location of the player and Reporting is Individual:
							report closing of the obstacle by the Bod.

After Patrolling something (called the Bod) (this is the reached destination for targeted patrollers rule):
	if the Bod is a Targeted Patroller and the location of the Bod is the Destination of the Bod:
		now the Bod is Off Patrol.

Section 3.5 - Reporting door rules

To report seen opening of (item - a door) by (Bod - a patroller):
	say "[The Bod] apre [the item]."
To report seen unlocking and opening of (item - a door) by (Bod - a patroller):
	say "[The Bod] sblocca e apre [the item]."
To report unseen opening of (item - a door):
	say "Senti il rumore di qualcuno che apre [the item]."
To report unseen unlocking and opening of (item - a door):
	say "Senti il rumore di qualcuno che sblocca e apre [the item]."
To report closing of (item - a door) by (Bod - a patroller):
	say  "[The Bod] chiude [the item]."
To report closing and locking of (item - a door) by (Bod - a patroller):
	say "[The Bod] chiude e blocca [the item]."

Section 3.6 - Reporting movement rules

[Disable the standard reporting rule for the arrival and departure of non-player characters whilst the patrolling activity is in progress.]

Report an actor going (this is the new describe room gone into rule):
	if the patrolling activity is not going on:
		abide by the describe room gone into rule.

The new describe room gone into rule is listed instead of the describe room gone into rule in the report going rulebook.

[Arrival rules used when the player is in the room when a patroller arrives.]

To report arrival of (Bod - a patroller) up from (place - a room):
	say "[The Bod] arriva da sotto."
To report arrival of (Bod - a patroller) down from (place - a room):
	say "[The Bod] arriva da sopra."
To report arrival of (Bod - a patroller) coming (way - a direction) from (place - a room):
	say "[The Bod] arriva da [the way]."
To report departure of (Bod - a patroller) going (way - a direction) to (place - a room):
	say "[The Bod] va verso [way]."

To report arrivals:
	say "[Arrival List] arriva[if the number of entries in the arrival list is 1]no[end if]."

To report departures:
	say "[Departure List] part[if the number of entries in the departure list is 1]e[else]ono[end if]."

Section 3.7 - Activation rules

To activate (Bod - a patroller):
	now the Bod is On Patrol;
	now the startturn of the Bod is the turn count.

To deactivate (Bod - a patroller):
	now the Bod is Off Patrol.

Section 3.8 - Rule for deciding if it is the patroller's turn to move

To decide if (Bod - a patroller) is ready to move:
	[calculate how many turns have elapsed since the patroller was activated]
	let elapsed turns be the turn count minus the StartTurn of the Bod;
	[a simple error check to prevent division by 0]
	if the Turn Frequency of the Bod is less than 1:
		now the Turn Frequency of the Bod is 1;
	[calculate whether the elapsed turns is exactly divisible by the Turn Frequency]
	let decision be the remainder after dividing the elapsed turns by the Turn Frequency of the Bod;
	if decision is 0 and the location of the Bod is a room:
		decide yes;
	decide no.

Chapter 4 - Error Checking - Not for release

Section 4.1 - Code for validation

To Terminate: (- quit; -).
To say Patroller Error:
	say "[bold type]*** Patroller Extension Validation Error ***[roman type][paragraph break]".
To say Correct Code:
	say "Because of this problem, the source could not be translated into a working game. (Correct the source text to remove the difficulty and click on Go once again.)".

Section 4.2 - Validation

When play begins (this is the validate patrollers rule):
	repeat with Bod running through Patrollers:
		if the Bod is RoomLed and the RoomTable of the Bod is Table of NoRooms:
			say "[Patroller Error]";
			say "You have created a RoomLed Patroller without a RoomTable.[paragraph break]";
			say "[Correct Code]";
			Terminate;
		if the Bod is DirectionLed and the DirectionTable of the Bod is Table of NoDirections:
			say "[Patroller Error]";
			say "You have created a DirectionLed Patroller without a DirectionTable.[paragraph break]";
			say "[Correct Code]";
			Terminate;
		if the Bod is Targeted and the Destination of the Bod is not a room:
			say "[Patroller Error]";
			say "You have created a Targeted Patroller without a Destination or with a Destination that is not a room.[paragraph break]";
			say "[Correct Code]";
			Terminate;
		if the Drive of the Bod is less than 0 or the Drive of the Bod is greater than 100:
			say "[Patroller Error]";
			say "You have created a Patroller with a Drive that is outside the range 0 to 100.[paragraph break]";
			say "[Correct Code]";
			Terminate;
		if the Turn Frequency of the Bod is less than 1:
			say "[Patroller Error]";
			say "You have created a Patroller with a Turn Frequency that is less than 1.[paragraph break]";
			say "[Correct Code]";
			Terminate;

Patrollers IT ends here.

---- DOCUMENTATION ----

Leggi la documentazione originale di Version 11 of Patrollers by Michael Callaghan.
