Version 4.2 of Plugs and Sockets by Sean Turner begins here.

"System for handling plugs and sockets."

Section 1 - Definitions

To decide if the (first-item - a thing) is inserted into the (second-item - a thing):
	repeat with outer loop running through the PS-plugs which are part of the first-item:
		if the attachment of the outer loop is not nothing:
			repeat with inner loop running through the PS-sockets which are part of the second-item:
				if the attachment of the inner loop is the outer loop:
					if the attachment of the outer loop is the inner loop:
						decide yes;
					else:
						say "** Problem! Attachments don't match! **";
	decide no.

To decide what number is the count of occupied plugs of the (item - a thing):
	let count be 0;
	repeat with loop-item running through the PS-plugs which are part of the item:
		if the attachment of the loop-item is not nothing:
			increase count by 1;
	decide on the count.

To decide what number is the count of occupied sockets of the (item - a thing):
	let count be 0;
	repeat with loop-item running through the PS-sockets which are part of the item:
		if the attachment of the loop-item is not nothing:
			increase count by 1;
	decide on the count.
	 
Definition: a PS-socket (called chosen socket) is socket-occupied:
	if the attachment of the chosen socket is nothing:
		no;
	yes.

To decide what number is the count of occupied connectors of the (item - a thing):
	let total be the count of occupied plugs of the item plus the count of occupied sockets of the item;
	decide on the total.

Definition: A thing is a PS-receiver if it incorporates a PS-socket, and it is not a PS-socket.
Definition: A thing is a PS-inserter if it incorporates a PS-plug, and it is not a PS-plug.
Definition: A thing (called the test-item) is attached:
	if the count of occupied connectors of the test-item is 0, decide no;
	decide yes.

Connect listing is a truth state that varies.

After examining a thing (this is the list attached things when examining receiver or inserter rule):
	let receive flag be false;
	if the noun is a PS-receiver:
		say "[The noun] [have] [exam receiver status of the noun]" (A);
		let receive flag be true;
	if the noun is a PS-inserter:
		if receive flag is true, say "[line break]";
		say "[exam inserter status of the noun]." (B).

To say exam inserter status of the (item - a thing):
	say "[regarding the item][They] [are] ";
	if the count of occupied plugs of the item is 0:
		say "not plugged into anything" ;
	else:
		say "[inserter status of the item]"; 

To say inserter status of the (item - a thing):
	now connect listing is true;
	let total be the count of occupied plugs of the item;
	let count be 0;
	repeat with loop-item running through the PS-plugs which are part of the item:
		if the attachment of the loop-item is not nothing:
			increase the count by 1;
			if the count is 1:
				say "plugged into ";
			else if the count is total:
				say " and ";
			else:
				say ", ";
			say "[a holder of the attachment of the loop-item]";
	now connect listing is false;

To say exam receiver status of the (item - a thing):
	if the count of occupied sockets of the item is 0, say "nothing";
	else say "[receiver status of the item]";
	say " plugged into [regarding the item][them].";

To say receiver status of the (item - a thing):
	now connect listing is true;
	let count be 0;
	let total be the count of occupied sockets of the item;
	repeat with loop-item running through the PS-sockets which are part of the item:
		if the attachment of the loop-item is not nothing:
			increase the count by 1;
			if the count is greater than 1:
				if the count is the total:
					say " and ";
				else:
					say ", ";
			say "[a holder of the attachment of the loop-item]";
	now connect listing is false.
	
After printing the name of a something (called the item) while listing contents (this is the list attached things when listing receiver or inserter rule):
	let counter be the count of occupied sockets of the item;
	if the item is a PS-receiver, and connect listing is false, and the counter is greater than 0:
		say " (into which [regarding socket-occupied PS-sockets which are part of the item][are] plugged [receiver status of the item])" (A);
	if the item is a PS-inserter, and connect listing is false, and the count of occupied plugs of the item is greater than 0:
		say " ([inserter status of the item])" (B).


A PS-connector is a kind of thing. It has an object called the attachment. It has some text called the PS-type. The PS-type is usually "standard". A PS-connector can be PS-unknown, PS-male or PS-female (this is its gender property).

Instead of examining a PS-connector (called the item) (this is the PS-connector examination rule):
	if the item is PS-male:
		say "[regarding the item][They] [are] a male [PS-type of the item] connector of [the holder of the noun]. [They] [are] [if the attachment of the noun is nothing]unplugged[else]plugged into [the holder of the attachment of the noun][end if]." (A);
	else:
		say "[regarding the item][They] [are] a female [PS-type of the item] connector of [the holder of the noun]. [They] [have] [if the attachment of the noun is nothing]nothing[else][the holder of the attachment of the noun][end if] plugged into it." (B).

A PS-plug is a kind of PS-connector. It is always PS-male.

A PS-socket is a kind of PS-connector. It is always PS-female.

To disconnect is a verb.

Before an actor going to somewhere (this is the leaving room whilst attached to fixed things rule):
	repeat with item running through the attached carried things:
		repeat with loop-item running through the PS-connectors which are part of the item:
			let the connectee be the attachment of the loop-item;
			if the connectee is not nothing:
				if the holder of the connectee is not carried by the player:
					if PS-leaving is PS-denied:
						if the actor is the player:
							say "It [would] be unwise to leave since [we] [are] carrying [the item] which [are] attached to [the holder of the connectee]." (A);
						stop the action;
					now the attachment of the loop-item is nothing;
					now the attachment of the connectee is nothing;
					if the actor is the player:
						say "[The item] [disconnect] from [the holder of connectee]." (B).
						

Section 2 - Grammar

Understand "plug [something] into [something]" as plugging it into.

Plugging it into is an action applying to two things.

The plugging it into action has an object called the candidate plug.
The plugging it into action has an object called the candidate socket.
The plugging it into action has an object called the candidate inserter.
The plugging it into action has an object called the candidate receiver.
The plugging it into action has an object called the actual plug.
The plugging it into action has an object called the actual socket.

[Next two checks ensure a player other than the actor isn't holding the plug or socket to be used. (Borrowed from the standard can't take people's possessions rule)]
Check an actor plugging something into something (this is the can't-plug-people's-plugs rule):
	let the local ceiling be the common ancestor of the actor with the noun;
	let H be the not-counting-parts holder of the noun;
	while H is not nothing and H is not the local ceiling:
		if H is a person:
			say "[text of can't take other people rule response (A)][line break]" (A);
			stop the action;
		let H be the not-counting-parts holder of H;

The can't-plug-people's-plugs rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something (this is the can't-plug-into-people's-sockets rule):
	let the local ceiling be the common ancestor of the actor with the second noun;
	let H be the not-counting-parts holder of the second noun;
	while H is not nothing and H is not the local ceiling:
		if H is a person:
			say "[text of can't take other people rule response (A)][line break]" (A);
			stop the action;
		let H be the not-counting-parts holder of H;

The can't-plug-into-people's-sockets rule is listed last in the check plugging it into rulebook.

Check an actor plugging a PS-plug into something (this is the plugging-a-plug rule):
	if the attachment of the noun is not nothing:
		if the actor is the player:
			say "[The noun] [are] already plugged into [the holder of the attachment of the noun]." (A);
		stop the action;
	else:
		now the candidate plug is the noun;
		now the candidate inserter is the holder of the noun.

The plugging-a-plug rule is listed last in the check plugging it into rulebook.
		
Check an actor plugging something that is not a PS-plug into something (this is the plugging-something-other-than-a-plug rule):
	if the noun is not a PS-inserter:
		if the actor is the player:
			say "[The noun] [have] no plug." (A);
		stop the action;
	else:
		now the candidate plug is nothing;
		now the candidate inserter is the noun.
	
The plugging-something-other-than-a-plug rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into a PS-socket (this is the plugging-into-a-socket rule):
	if the attachment of the second noun is not nothing:
		if the actor is the player:
			say "[The second noun] already [have] [the holder of the attachment of the second noun] plugged into it." (A);
		stop the action;
	else:
		now the candidate socket is the second noun;
		now the candidate receiver is the holder of the second noun.
		
The plugging-into-a-socket rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something that is not a PS-socket (this is the plugging-into-something-other-than-a-socket rule):
	if the second noun is not a PS-receiver:
		if the actor is the player:
			say "[The second noun] [have] no socket." (A);
		stop the action;
	else:
		now the candidate socket is nothing;
		now the candidate receiver is the second noun.
	
The plugging-into-something-other-than-a-socket rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something (this is the already-plugged-together rule):
	if the candidate inserter is inserted into the candidate receiver:
		if the actor is the player:
			say "[The candidate inserter] [are] already plugged into [the candidate receiver]." (A);
		stop the action.

The already-plugged-together rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something (this is the plug-unknown-socket-known rule):
	if the candidate plug is nothing, and the candidate socket is not nothing:
		repeat with test-plug running through the PS-plugs which are part of the candidate inserter:
			if the attachment of the test-plug is nothing, and the PS-type of the test-plug is the PS-type of the candidate socket:
				now the actual plug is the test-plug;
				break;
		if the actual plug is nothing:
			if the actor is the player:
				say "[The candidate inserter] [have] no free plugs that match [the candidate socket]." (A);
			stop the action;
		now the actual socket is the candidate socket.

The plug-unknown-socket-known rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something (this is the plug-known-socket-unknown rule):
	if the candidate plug is not nothing, and the candidate socket is nothing:
		repeat with test-socket running through the PS-sockets which are part of the candidate receiver:
			if the attachment of the test-socket is nothing, and the PS-type of the test-socket is the PS-type of the candidate plug:
				now the actual socket is the test-socket;
				break;
		if the actual socket is nothing:
			if the actor is the player:
				say "[The candidate receiver] [have] no free sockets that match [the candidate plug]." (A);
			stop the action;
		now the actual plug is the candidate plug.

The plug-known-socket-unknown rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something (this is the plug-unknown-socket-unknown rule):
	if the candidate plug is nothing, and the candidate socket is nothing:
		let matching connection type be "";
		repeat with test-plug running through the PS-plugs which are part of the candidate inserter:
			if the actual plug is not nothing and the actual socket is not nothing, break;
			if the attachment of the test-plug is nothing:
				now the actual plug is the test-plug;
				repeat with test-socket running through the PS-sockets which are part of the candidate receiver:
					if the attachment of the test-socket is nothing, and the PS-type of the test-plug is the PS-type of the test-socket:
						if matching connection type is not "":
							if matching connection type is not the PS-type of the test-plug:
								if the actor is the player:
									say "[regarding PS-plugs]There [are] multiple types of matching plugs and sockets available for [the candidate inserter] and [the candidate receiver]. Try specifying which plug or socket you wish to use." (A);
								stop the action;
						else:
							now the matching connection type is the PS-type of the test-plug;
							now the actual socket is the test-socket;
		if the actual plug is nothing:
			if the actor is the player:
				say "[The candidate inserter] [have] no free plugs available." (B);
			stop the action;
		if the actual socket is nothing:
			if the actor is the player:
				say "[The candidate receiver] [have] no free sockets that [would] allow [the candidate inserter] to be plugged in." (C);
			stop the action.
	
The plug-unknown-socket-unknown rule is listed last in the check plugging it into rulebook.

Check an actor plugging something into something (this is the plug-known-socket-known rule):
	if the candidate plug is not nothing, and the candidate socket is not nothing:
		if the PS-type of the candidate plug is not the PS-type of the candidate socket:
			if the actor is the player:
				say "[The candidate plug] and [the candidate socket][regarding things] [are not] of the same type." (A);
			stop the action;
		now the actual plug is the candidate plug;
		now the actual socket is the candidate socket.

The plug-known-socket-known rule is listed last in the check plugging it into rulebook.

Carry out an actor plugging something into something (this is the plug-something-into-something rule):
	now the attachment of the actual plug is the actual socket;
	now the attachment of the actual socket is the actual plug.

To plug is a verb.

Report an actor plugging something into something (this is the report-plugging it into rule):
	say "[The actor] [plug] [the noun] into [the second noun]." (A).

Understand "unplug [other things] from [something]" as unplugging it from.

Unplugging it from is an action applying to two things.

[Next two checks ensure a player other than the actor isn't holding the plug or socket to be used. (Borrowed from the standard can't take people's possessions rule)]
Check an actor unplugging something from something (this is the can't-unplug-people's-plugs-from rule):
	let the local ceiling be the common ancestor of the actor with the noun;
	let H be the not-counting-parts holder of the noun;
	while H is not nothing and H is not the local ceiling:
		if H is a person:
			say "[text of can't take other people rule response (A)][line break]" (A);
			stop the action;
		let H be the not-counting-parts holder of H;

The can't-unplug-people's-plugs-from rule is listed last in the check unplugging it from rulebook.

Check an actor unplugging something from something (this is the can't-unplug-from-people's-sockets rule):
	let the local ceiling be the common ancestor of the actor with the second noun;
	let H be the not-counting-parts holder of the second noun;
	while H is not nothing and H is not the local ceiling:
		if H is a person:
			say "[text of can't take other people rule response (A)][line break]" (A);
			stop the action;
		let H be the not-counting-parts holder of H;

The can't-unplug-from-people's-sockets rule is listed last in the check unplugging it from rulebook.

Check an actor unplugging PS-inserter from a PS-receiver(this is the item-must-be-plugged-into-second-item rule):
	unless the noun is inserted into the second noun:
		if the actor is the player:
			say "[The noun] [are not] plugged into [the second noun]." (A);
		stop the action.

The item-must-be-plugged-into-second-item rule is listed last in the check unplugging it from rulebook.

Check an actor unplugging a PS-plug from something (this is the cannot-unplug-plugs-from rule):
	if the actor is the player:
		say "You cannot specify a particular plug when unplugging something." (A);
	stop the action.

The cannot-unplug-plugs-from rule is listed last in the check unplugging it from rulebook.

Check an actor unplugging something from a PS-socket (this is the cannot-unplug-from-sockets rule):
	if the actor is the player:
		say "You cannot specify a particular socket when unplugging something." (A);
	stop the action.

The cannot-unplug-from-sockets rule is listed last in the check unplugging it from rulebook.

Check an actor unplugging something from something (this is the catch-invalid-unplugging-it-from rule):
	if the noun is not a PS-inserter, or the second noun is not a PS-receiver:
		try the actor removing the noun from the second noun instead.
[		if the actor is the player:
			say "[The noun] [is-are] not plugged into [the second noun].";
		stop the action.]

The catch-invalid-unplugging-it-from rule is listed last in the check unplugging it from rulebook.

Carry out an actor unplugging something from something (this is the unplug-two-items rule):
	repeat with test-plug running through the PS-plugs which are part of the noun:
		let the test-socket be the attachment of the test-plug;
		if the test-socket is not nothing:
			if the test-socket is a part of the second noun:
				now the attachment of the test-plug is nothing;
				now the attachment of the test-socket is nothing;

To unplug is a verb.

Report an actor unplugging something from something (this is the report-actor-unplugging-it-from rule):
	say "[The actor] [unplug] [the noun] from [the second noun]." (A).

Understand "unplug [something]" as unplugging.

Unplugging is an action applying to one thing.

Check an actor unplugging something (this is the can't-unplug-people's-plugs rule):
	let the local ceiling be the common ancestor of the actor with the noun;
	let H be the not-counting-parts holder of the noun;
	while H is not nothing and H is not the local ceiling:
		if H is a person:
			say "[text of can't take other people rule response (A)][line break]" (A);
			stop the action;
		let H be the not-counting-parts holder of H;

The can't-unplug-people's-plugs rule is listed last in the check unplugging rulebook.

Check an actor unplugging PS-inserter (this is the ensure-item-only-plugged-into-1-thing rule):
	let plugged count be the count of occupied plugs of the noun;
	if the plugged count is 0:
		if the actor is the player:
			say "[The noun] [are not] plugged into anything." (A);
		stop the action;
	if the plugged count is greater than 1:
		if the actor is the player:
			let item be "[noun]" in upper case;
			say "[The noun] [are] plugged into more than one thing. [bracket]try UNPLUG [item] FROM something[close bracket][line break]" (B);
		stop the action.

The ensure-item-only-plugged-into-1-thing rule is listed last in the check unplugging rulebook.

Check an actor unplugging a PS-plug (this is the cannot-unplug-plugs rule):
	say "You cannot specify a particular plug when unplugging something." (A) instead.

The cannot-unplug-plugs rule is listed last in the check unplugging rulebook.

Check an actor unplugging something that is not a PS-inserter (this is the catch-invalid-unplugging-it rule):
	if the actor is the player:
		say "[The noun] [are not] plugged into anything." (A);
	stop the action.

The catch-invalid-unplugging-it rule is listed last in the check unplugging rulebook.

Carry out an actor unplugging (this is the unplug-item-from-inferred-item rule):
	repeat with test-plug running through the PS-plugs which are part of the noun:
		let the test-socket be the attachment of the test-plug;
		if the test-socket is not nothing:
			now the second noun is the holder of the test-socket;
			if the actor is the player:
				say "(from [the second noun])[command clarification break]" (A); 
			try the actor unplugging the noun from the second noun instead;
			stop the action;
	say "*** Problem : Couldn't find match for [the noun] when unplugging ***" (B).

[This allows "INSERT" to work as "PLUG" when the noun is an inserter or plug AND the second noun is a receiver or socket. Otherwise the action will continue.]
Before an actor inserting something into something (this is the allow-inserting-for-plugging rule):
	if the noun is a PS-inserter, or the noun is a PS-plug:
		if the second noun is a PS-receiver, or the second noun is a PS-socket:
			try actor plugging the noun into the second noun instead;
	continue the action.

[This allows "ATTACH" to work as "PLUG" when the noun is an inserter or plug AND the second noun is a receiver or socket. Otherwise tying it to is attempted.]
Understand the command "attach" as something new.
PS-attaching it to is an action applying to two things.
Understand "attach [something] to [something]" as PS-attaching it to.
Instead of an actor PS-attaching something to something (this is the allow-plug-or-tie-depending-on-type rule):
	if the noun is a PS-inserter, or the noun is a PS-plug:
		if the second noun is a PS-receiver, or the second noun is a PS-socket:
			try actor plugging the noun into the second noun instead;
	try actor tying the noun to the second noun instead.

[Allows "DETACH" as a synonym for "UNPLUG"]
Understand the command "detach" as "unplug".

[Make "REMOVE something from something" act as a synonym for "UNPLUGGING something from something" - unless the first thing is inside the second, then removing it from is attempted.]
Understand "remove [something] from [something]" as unplugging it from.

[Allows "REMOVE plug" or "REMOVE inserter" - also allows "TAKE OFF plug"]
Before of an actor taking off something (this is the allow-removing-for-unplugging rule):
	if the noun is a PS-inserter, or the noun is a PS-plug:
		try actor unplugging the noun instead;
	continue the action.

Section 3 - Variables

A permission is a kind of value. The permissions are PS-allowed and PS-denied. 

PS-leaving is a permission that varies. PS-leaving is PS-denied.

Plugs and Sockets ends here.

---- DOCUMENTATION ---- 

This extension provides a mechanism to add plugs and sockets of various kinds to things to allow objects to attach to one another. For example, one could create a TV with a (male) plug attached. Additionally a wall point with a (female) socket could be created thereby allowing the TV to be plugged into it. This could be coded like so:

	Test Lab is a room.

	A wall point is here. It is fixed in place. Incorporated by it is a PS-socket.

	A TV is here. It is fixed in place. Incorporated by it is a PS-plug.

This allows the TV to be plugged into the wall point. Naturally, the TV can be unplugged from the wall point. The additional grammar "PLUG something into something" and "UNPLUG something FROM something" have been provided for this.

Things can have both plugs and sockets. For example:

	A power board is here. Incorporated by it is a PS-plug and four PS-sockets.

This allows up to four things that have plugs to be plugged into the power board, whilst it itself can be plugged into something with a socket, such as the wall point. Note that when plugging, a specific plug and/or socket can be nominated. This is not permitted when unplugging, but more on this later.

One point about multiple plugging: a thing cannot be plugged into something more than once. So, for example, if we have a cable defined thusly:

	A cable is here. Incorporated by it are two PS-plugs.

we cannot "PLUG CABLE INTO THE POWER BOARD" twice. The first time is okay but the second will be rejected, even though we could, in the real world, plug a both ends of male-male power cable into a power board.

Plugs and sockets have a text property called "PS-type". By default, the PS-type of sockets and plugs provided - PS-socket and PS-plug - is "standard". If you use these kinds only, then everything will work nicely as expected. However we may want to create plugs and sockets of different kinds. For example:

	An S-Video plug is a kind of PS-plug. The PS-type of an S-Video Plug is "S-Video".
	An S-Video socket is a kind of PS-socket. The PS-type of an S-Video Socket is "S-Video".

	An S-Video cable is here. Incorporated by it are two S-Video plugs.

	An amplifier is here. Incorporated by it is an S-Video socket.
	A DVD player is here. Incorporated by it is an S-Video socket.

creates an S-Video cable that can connect between an amplifier and a DVD player. Plugs and sockets of differing types cannot be plugged into each other.

It becomes more complex when considering some things may contain several different types of sockets. For example:

	An HDMI socket is a kind of PS-socket. The PS-type of an HDMI socket is "HDMI".
	An HDMI plug is a kind of PS-plug. The PS-type of an HDMI plug is "HDMI".
	An HMDI cable is here. Incorporated by it are two HDMI plugs.
	The amplifier incorporates an HDMI socket.

The amplifier now has two different types of socket. This isn't so bad because if we try "PLUG HDMI CABLE INTO AMPLIFIER" the game will know, without ambiguity, which socket to use.

Similarly, we could define an adapter cable that has a 3.5mm audio plug at one end and a pair of RC audio connectors at the other. If we attempted to plug this into something with only one type of socket (say an iPhone), it would automatically plug in the correct matching plug.

Things can have any number of plugs and sockets of any type attached.

It can become too complicated to figure out which cable end to plug into which socket. For example, if we had an adapter cable with an HDMI plug at one end and an S-Video plug at the other, we would have trouble with "PLUG CABLE INTO THE AMPLIFIER" (assuming the sockets of the amplifier were all free). This is because the code doesn't know which end to plug in - either would be valid. In this case, the solution is to name the plugs and/or the sockets. Then the player can specify which end is to be plugged into the amplifier.

	A complex cable is here. The description is "An HDMI to S-Video adapter cable (which is probably not possible!)".
	The HDMI end of the cable is an HDMI plug. It is part of the complex cable.
	The S-Video end of the cable is an S-Video plug. It is part of the complex cable.

Now the player can type "PLUG THE HDMI END OF THE CABLE INTO THE AMPLIFIER" which will work as expected. Or even "PLUG THE HDMI END OF THE CABLE INTO THE HDMI-IN SOCKET" (if the sockets were appropriately named) would work if you wanted to be more specific still.

Similarly, "UNPLUG CABLE FROM THE AMPLIFIER" performs as expected. If the cable is only plugged into the amplifier, just "UNPLUG CABLE" would be sufficient.

The synonyms "INSERT" and "ATTACH" work for "PLUG", likewise "DETACH" and "REMOVE" work for "UNPLUG". Note these synonyms work when the attempt is made for plugs or sockets or things containing plugs or sockets. Otherwise the existing behaviour for the synonym (if it exists) will take place. For example, if "ATTACH" is attempted for a non-plug or something not containing a plug, the command will revert to being understood as "TIE". All of this behaviour can be changed with appropriate manipulation of the listed rules.

The extension does support plural items with appropriate messages. So "PLUG TV INTO SOME BANANAS" will give the message "The bananas have no socket" rather than "The bananas has no socket".

The extension also supports actors other than the player. For example, "GEORGE, PLUG THE CORD INTO THE POWER POINT" will work correctly (as long as George is willing).

There are currently three major limitations to the extension:
1) You cannot plug an item into another item multiple times. There is a rule which explicitly forbids it (although it could be delisted). It creates problems with listing attachments and ambiguity and wasn't really necessary.
2) You cannot name a plug or socket when unplugging. Once again, it would have added complexity and I didn't believe it is needed.
3) Plugs and sockets has not been tested for multi-layered situations. That is, a plug or socket must be a part of a parent object, not a part of a part. For example, lets say we have an "entertainment system" which has a "DVD player" as a part. The "DVD player" could then have a plug as a part of it. However this may cause problems when trying to "PLUG" it into things. 

One final point: a value called PS-leaving can be either PS-denied or PS-allowed. It is PS-denied by default. When it is PS-denied and the player attempts to leave a location whilst carrying something attached to something not carried, a message will be displayed and the action prevented. If this variable is set to PS-allowed, the action will be okay but all the relevant connections for those things carried will be broken.

Example: ** Home Theatre - Plugging a variety of components with different connections together to watch a DVD.

	*: "Home Theatre" by Sean Turner

	Include Plugs and Sockets by Sean Turner

	Section 1 - New plug and socket kinds

	An HDMI-plug is a kind of PS-plug. The PS-type of an HDMI-plug is "HDMI".
	An HDMI-socket is a kind of PS-socket. The PS-type of an HDMI-socket is "HDMI".

	A DVI-plug is a kind of PS-plug. The PS-type of a DVI-plug is "DVI".
	A DVI-socket is a kind of PS-socket. The PS-type of a DVI-socket is "DVI".

	A power-plug is a kind of PS-plug. The PS-type of a power-plug is "power". A power-plug has a truth state called searched state. The searched state of a power-plug is usually false.

	A power-socket is a kind of PS-socket. The PS-type of a power-socket is "power".

	A double-adapter is a kind of thing. Every double-adapter incorporates a power-plug and two power-sockets.

	A hifi-gadget is a kind of thing. Every hifi-gadget incorporates a power-plug.

	Section 2 - A few decisions 

	To decide if the (test-item - a thing) is powered:
		repeat with item running through the power-plugs:
			now the searched state of the item is false;
		let forever be true;
		while forever is true:
			if the test-item is the power point:
				decide yes;
			let test-plug be a random power-plug which is part of the test-item;
			if the test-plug is nothing, or the attachment of the test-plug is nothing:
				decide no;
			else:
				if the searched state of the test-plug is true:
					decide no;
				now the searched state of the test-plug is true;
				now the test-item is the holder of the attachment of the test-plug.

	To decide if the audio is connected:
		if the HDMI cable is inserted into the receiver, and the HDMI cable is inserted into the DVD player, and the holder of the attachment of the HDMI-IN socket is HDMI cable:
			decide on true;
		decide on false.

	To decide if the video is connected:
		if the video converter is inserted into the TV, and the video converter is inserted into the receiver, and the attachment of the HDMI-OUT socket is the green plug:
			decide on true;
		decide on false.

	Section 3 - Scenario

	The Home Theatre is a room. "This softly lit and richly carpeted homage to 1970's decor is the perfect place to relax and watch a movie. A store room is to the south."

	A big screen TV is a hifi-gadget. It is here. "A huge 150cm Plasma TV dominates the north wall.". It is fixed in place.
	The description is "Tastelessly huge. The TV is [if the TV is powered]on although nothing is showing.[else]off.".
	Incorporated by it is a DVI-socket.

	A power point is here. It is fixed in place. "Unfortunately the room has only one single power point tucked away in the corner farthest from the TV."
	Incorporated by it is a power-socket.

	Check plugging a PS-inserter into the power point (this is the power-point-too-far rule):
		if the noun is fixed in place, say "The plug of [the noun] will not reach to [the power point]." instead;
		if the noun is not the extension cord, say "It would be useless to plug [the noun] into [the power point] when it is so far from the TV." instead. 

	The power-point-too-far rule is listed last in the check plugging it into rulebook.

	A Blu-ray DVD player is a hifi-gadget. It is here. The description is "A state of the art DVD player. In the player is a movie waiting to be watched. The DVD player is [if the DVD is powered]on and the movie is playing.[else]off."
	Incorporated by it is an HDMI-socket.

	A digital receiver is a hifi-gadget. It is here. It is fixed in place.
	The description is "A complex switching mechanism routing various audio visual inputs to the TV and speakers. The speakers are hard-wired into the back of the receiver. On the back of the receiver are two HDMI sockets labeled HDMI-IN and HDMI-OUT.

	The receiver is [if the receiver is powered]on and hums slightly.[else]off.".
	Incorporated by the receiver is an HDMI-socket called the HDMI-OUT socket.
	Incorporated by the receiver is an HDMI-socket called the HDMI-IN socket.

	Some speakers are scenery. They are here.

	The Store room is south of the Home Theatre.

	An extension cord is here. The description is "5 metres of sturdy electrical cord.". The indefinite article is "an".
	Incorporated by it is a power-plug and a power-socket.

	A video converter cable is here. The description is "It converts from an HDMI source to a DVI destination - useful when only the video component of the signal is required. The male DVI plug is red and the male HDMI plug is green.".
	Incorporated by the cable is a DVI-plug called the red plug.
	Incorporated by the cable is an HDMI-plug called the green plug.

	An HDMI cable is here. Incorporated by it are two HDMI-plugs. The indefinite article is "an". The description is "Connects two HDMI devices for video and sound. The two male connectors are indistinguishable.".

	A cream double adapter is a double-adapter. It is here.
	A white double adapter is a double-adapter. It is here.

	Section 4 - Victory condition

	Every turn:
		let power flowing be true;
		repeat with item running through hifi-gadgets:
			unless the item is powered:
				now power flowing is false;
		if power flowing is true, and the audio is connected, and the video is connected:
			say "Ahh. Now you can relax and watch the movie.";
			end the story saying "You have won.";
		else:
			if the receiver is powered, and the DVD is powered, and the audio is connected:
				say "You can hear the movie but you can't see any picture!".


	Section 5 - Testing

	test me with "s/get all/n/plug tv into white/plug dvd into white/plug white into cream/plug receiver into cream/plug cream into cord/plug cord into point/plug hdmi into receiver/plug hdmi into dvd/plug video into receiver/x green/x red/plug video into tv/unplug video from receiver/unplug hdmi from receiver/plug hdmi into hdmi-in/plug video into hdmi-out".

	test errors with "plug tv into point/plug tv into receiver/s/get all/n/plug cord into point/s/plug hdmi into cream/unplug cord from point/plug cord into cord/unplug cord/plug tv into white/plug receiver into white/ plug cream into white/unplug tv/plug red plug into receiver/plug green plug into receiver/plug video cable into tv".
