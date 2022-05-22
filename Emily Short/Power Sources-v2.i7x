Version 2 of Power Sources by Emily Short begins here.

"Power Sources provides an implementation of plugs and batteries, and is designed to be used alongside Computers or as a base for other device implementations. It requires Plugs and Sockets by Sean Turner."

Part 1 - Wall Power

[Mostly we're relying on Sean's extension; the additions here are just to make for more convenient default behavior. ]

Include Plugs and Sockets by Sean Turner. 

A wall socket is a kind of thing. It is scenery. Every wall socket incorporates a PS-socket.

Understand "plug in [something]" or "plug [something] in" as plugging it into.

Rule for supplying a missing second noun while plugging something into (this is the assume a wall socket rule):
	if a wall socket (called target) is visible:
		now the second noun is the target;
	otherwise:
		say "You'll have to say what you want to plug [the noun] into." (A)

Part 2 - Battery Power

Section 1 - Batteries

A battery is a kind of thing. A battery has a number called charge. The charge of a battery is usually 60. 

A rechargeable battery is a kind of battery. A rechargeable battery has a number called maximum charge. The maximum charge of a rechargeable battery is usually 60.

Definition: a battery is discharged if its charge < 1.
Definition: a rechargeable battery is fully charged if its charge is its maximum charge.

[We make this rule occur at the beginning of the every turn rules so that if the devices are themselves doing something every turn while switched on, we don't get a sequence where the player removes a battery, the robot dog barks one last time anyway, and only then do we get the robot dog shutdown message.]
A first every turn rule (this is the check power sources rule):
	follow the energy management rules.

The energy management rules are a rulebook.

An energy management rule (this is the deplete or recharge batteries rule):
	repeat with hollow running through battery compartments:
		if the hollow is part of a device (called the machine):
			if a battery (called cell) is in the hollow:
				if the machine is wall-powered:
					if the cell is a rechargeable battery and charge of the cell is less than the maximum charge of the cell:
						increase the charge of the cell by the battery recharge of the machine;
						if the charge of the cell is greater than the maximum charge of the cell:
							now the charge of the cell is the maximum charge of the cell;
						if the cell is fully charged and the player can see the machine:
							carry out the notifying of full charge activity with the machine;
				otherwise if the machine is switched on:
					decrease the charge of the cell by the battery drain of the machine;
					if the player can see the machine:
						carry out the warning about the failure activity with the machine.


Section 2 - Battery Compartments

A battery compartment is a kind of container. A battery compartment is usually closed and openable and privately-named. Understand "battery compartment" or "compartment" or "compartment of [something related by reversed incorporation]" as a battery compartment.

Setting action variables for an actor opening a device  (this is the divert opening actions to the battery compartment rule):
	now the noun is a random battery compartment which is part of the noun. 

Setting action variables for an actor closing a device  (this is the divert closing actions to the battery compartment rule):
	now the noun is a random battery compartment which is part of the noun.

Setting action variables for an actor inserting a battery into a device  (this is the divert inserting actions to the battery compartment rule):
	now the second noun is a random battery compartment which is part of the second noun.

Setting action variables for an actor switching on a battery compartment which is part of a device (called the power user) (this is the divert switching on actions to the device rule): 
	now the noun is the power user.

Setting action variables for an actor searching a device which incorporates a battery compartment (called the target) (this is the divert searching actions to the compartment rule):
	now the noun is the target.

Check an actor inserting something which is not a battery into a battery compartment (this is the can't put non-batteries in a battery compartment rule):
	if the actor is the player:
		say "Only batteries should go in a battery compartment.";
	stop the action.

Definition: a device is empty:
	if a random battery compartment which is part of it contains a battery (called the power source):
		if the power source is discharged, yes;
		no;
	yes.

Section 3 - Battery-related Understand tricks

[And to get rid of annoying messages like "Which would you like to close, the flashlight or the flashlight's battery compartment?" when only the compartment is closable, we might add some understanding instructions:]

Understand "turn on [device]" as switching on.

Understand "turn off [device]" as switching off.

Understand "open [openable closed thing]" as opening.

Understand "close [openable open thing]" as closing.

Understand "put [an unencumbered thing] in [container]" as inserting it into.

Definition: a thing is unencumbered if it is not part of something and it is not fixed in place and it is not scenery.

[These options are isolated into their own section so that if we ever want to get rid of them or we're working with another extension that already includes this information, we can replace the section and be rid of them.]

Section 4 - Does the Player Mean rules about batteries and compartments
 

Does the player mean doing something other than searching to a battery compartment (this is the prefer only to search compartments rule): 
	it is unlikely. [We discourage Inform from choosing a compartment when the player uses just the name of a device or the word 'battery'.]

Does the player mean inserting into a battery compartment (this is the prefer not to insert non-batteries into a battery compartment rule): 
	if the noun is nothing: 
		it is very likely; 
	otherwise: 
		make no decision.

Does the player mean inserting a battery compartment into (this is the prefer not to insert compartments rule):
	 it is very unlikely.
Does the player mean taking a battery which is in a battery compartment (this is the prefer to take batteries rule):
	it is very likely.
Does the player mean taking a battery compartment (this is the prefer not to take compartments rule):
	it is very unlikely.
Does the player mean inserting something into a device (this is the prefer not to insert into devices rule): 
	it is unlikely.
Does the player mean searching a battery compartment (this is the prefer searching compartments rule): 
	it is very likely.

Section 5 - Device effects on batteries

[These numbers control how rapidly a device drains batteries, starting from a default of 1 charge point per turn, and how fast they recharge. Out of kindness to the player, we default to recharging four times as fast as we discharge, but that can be changed.]

A device has a number called the battery drain. The battery drain of a device is usually 1.
A device has a number called the battery recharge. The battery recharge of a device is usually 4.

Part 3 - Power and Powerlessness

Chapter 1 - Powered, Wall-Powered and Unpowered

Definition: a device (called the test device) is powered:
	follow the power-determination rules for the test device;
	if rule succeeded:
		yes;
	no.

The power-determination rules are an object based rulebook.

A power-determination rule for something (called test device) (this is the no interference with completely powerless devices rule):
	if the test device does not incorporate a PS-plug and the test device does not incorporate a battery compartment:
		rule succeeds. [we assume the device is magically self-powered somehow; this means we don't lose the functionality of every device in the game just by including this extension.]

A power-determination rule for something (called test device) (this is the wall-powered devices work rule):
	if the test device is wall-powered:
		rule succeeds.

A power-determination rule for something (called test device) (this is the devices containing undepleted batteries work rule):
	if the test device incorporates a battery compartment:
		if the test device is not empty:
			rule succeeds.

Last power-determination rule for something (called test device) (this is the no power if we can't find a power source rule):
	rule fails.

Definition: a device (called the test device) is battery-powered:
	if the test device incorporates a battery compartment and the test device is not wall-powered:
		yes;
	no.

Definition: a device (called the test device) is wall-powered:
	repeat with item running through PS-plugs which are part of the test device:
		repeat with second item running through PS-sockets which are part of a wall socket:
			if the item is the attachment of the second item:	
				yes;
	no.
	
Definition: a device is unpowered if it is not powered.

Chapter 2 - Refusing to turn on

Check an actor switching on an unpowered device (this is the can't switch on powerless devices rule):
	if the player is the actor:
		say "[The noun] [are] without power." (A) instead;
	stop the action.

Chapter 3 - Warning about failure

Warning about the failure of something is an activity.

Rule for warning about the failure of a device (called the machine) (this is the default warn about extinguishing rule):
	if a random battery compartment which is part of the machine  contains a battery (called the power source):
		let turns remaining be the charge of the power source divided by the battery drain of the machine;
		if the turns remaining is 1:
			say "[The machine] [are] nearing the end of [their] battery life." (A)

Chapter 4 - Putting out devices

Putting out something is an activity.

Rule for putting out a device (called the item) (this is the extinguishing cut-off machines rule):
	let the old noun be the noun;
	now the noun is the item;
	follow the carry out switching off rules; 
	now the noun is the old noun.

After putting out a visible device (called the machine) (this is the default describe putting out a device rule):
	say "[The machine] [are] now off.[line break]" (A)

A last energy management rule:
	repeat with item running through unpowered switched on devices:
		carry out the putting out activity with the item. 

Chapter 5 - Notifying of full charge

Notifying of full charge of something is an activity.

Rule for notifying of full charge of a device (called the machine) (this is the default notify about recharging rule):
	if a random battery compartment which is part of the machine contains a fully charged rechargeable battery (called the power source):
		say "[The power source] in [the machine] [regarding power source][are] [if story tense is present tense]now [end if]fully charged." (A)

Power Sources ends here.

---- Documentation ----

Power Sources provides an implementation of plugs and batteries, and is designed to be used alongside Computers or as a base for other device implementations. It requires Plugs and Sockets by Sean Turner.

Chapter: Power

Section: Power from the wall

Power Sources creates a kind called wall socket, which is the source of home electricity. Beyond this, it largely depends on Plugs and Sockets by Sean Turner. To create a lamp that can be plugged in, we would write

	A lamp is a device in foo. The lamp incorporates a PS-plug.

and to indicate that a given room is capable of offering it power:

	The Salon contains a wall socket. 

By default a wall socket has one PS-socket, which is to say that it can have one thing plugged into it. If we wish to extend that, we need only iterate the socket-assigning assertion until our sockets are as buff as we desire:

	Every wall socket incorporates a PS-socket.

(These function cumulatively.)

One inherited behavior from Plugs and Sockets is that by default it is not possible for the player to walk away from a socket while carrying a plugged-in object. I quote from the documentation there:

	"One final point: a value called PS-leaving can be either PS-denied or PS-allowed. It is PS-denied by default. When it is PS-denied and the player attempts to leave a location whilst carrying something attached to something not carried, a message will be displayed and the action prevented. If this variable is set to PS-allowed, the action will be okay but all the relevant connections for those things carried will be broken."

Section: Power from batteries

Power sources also defines kinds for batteries (and a subset, rechargeable batteries) and battery compartments. A battery compartment is part of the device it powers, and can contain only batteries. 

The default behavior is that a battery has a charge (or battery life) of 60. If we leave all settings at their default, this number represents 60 turns of play, or an hour at minute-to-minute equivalence. 

It is possible to change these effects. We can change the charge of a battery to a different number (and the maximum charge of a rechargeable battery, to make sure it can't be repowered for a longer time than we want). 

Furthermore, each device has numbers called battery drain (how many points of charge it takes to operate per minute) and battery recharge (how many points of charge it restores if it is being used to restore a drained rechargeable battery). By default, these numbers are 1 and 4, respectively, so a 60-charge battery takes 60 turns to drain and 15 to recharge.

However, if we want different game devices to drain batteries at different speeds, we may alter these numbers. For instance, if we wanted to model a digital camera and a trusty little emergency flashlight, we might do something like this:

	The AA-cell is a battery. The charge of the AA-cell is 180. 
	The battery drain of the digital camera is 18.

The battery drain of the flashlight is still 1, so it depletes the charge of the AA-cell at 1 point per turn, lasting three hours, but the digital camera takes only 10 minutes to consume the same battery.

This system does not account for having different battery types associated with different sorts of device. If we do want to implement this, the most expedient way is probably to create sub-kinds, as in

	A D-cell battery is a kind of battery.
	A laptop battery compartment is a kind of battery compartment.

...and add our own rules forbidding any kind of battery except the correct one from being put in a specific type of compartment.

Finally, it's true that many common devices operate on pairs of batteries simultaneously, but modeling this in great detail, including the effect of running differently-charged batteries together, is probably not worth the effort. If this is found to be disappointingly unrealistic, we might try creating a single battery object that just pretends to be a pair of batteries, as in

	A pair of AA batteries is a battery.

Section: Is this device powered?

A device is considered to be powered if:

1) it incorporates neither a PS-plug nor a battery compartment. This is meant as a fail-safe: if the author includes this extension but has some devices defined that he doesn't designate as having either a battery compartment or a power plug, those devices will go on functioning the same way they did before the extension was included.

2) it incorporates a PS-plug that is plugged into a wall socket.

3) it incorporates a battery compartment that contains an undepleted battery.

These criteria can be changed or augmented using the power-determination rulebook, of which the rules look like this, for instance:

	A power-determination rule (this is the no interference with completely powerless devices rule):
		if the test device does not incorporate a PS-plug and the test device does not incorporate a battery compartment:
			rule succeeds; 

Revising these rules might be appropriate if, for instance, we wanted to take advantage of more of the sophistication of the Plugs and Sockets extension, and model not just wall sockets but also extension cords and multiple power plug types.

Chapter: Behavior of powered devices

Section: Devices cannot be turned on when they have no power

Thanks to the can't switch on powerless devices rule, we cannot switch on an unpowered device.

Section: Battery-powered devices issue a warning when they are nearly out of power

The warning about the failure activity currently handles this, and has a single rule:
	
	Rule for warning about the failure of a device (called the machine) (this is the default warn about extinguishing rule):
		let turns remaining be the charge of the power source divided by the battery drain of the machine;
		if the turns remaining is 1:
			if the charge of the power source is 2:
				say "[The machine] [is-are] obviously going to go out quite soon."

If we want to issue other warnings, or warnings at other times, we can do so by adding other rules to the activity. We can also remove this one, as in

	*: The default warn about extinguishing rule is not listed in any rulebook.

Section: Devices shut off when they have no power

The putting out a device activity handles the case where a device loses power (either thanks to battery failure or through being unplugged). The For... rules of the activity actually turn the device off, while the After... rules provide a description of the shutdown. 

By default we start with the extremely bland after rule

	After putting out a visible device (called the machine) (this is the default describe putting out a device rule):
		say "[The machine] [is-are] now off.[line break]"

It's possible to turn off a device by unplugging it even if the check rules would normally forbid this. That is because we might, for instance, encounter the evil master computer whose off-switch is cunning protected by laser turrets, but pulling out its power cord will still do the trick.

If we don't want that to be the case, we will need to replace the "extinguishing cut-off machines rule" rule. 

Section: Device gives notice when its internal rechargeable battery reaches full power

The notifying of full charge activity lets us give a message when something becomes fully charged, as in this default rule:

	Rule for notifying of full charge of a device (called the machine) (this is the default notify about recharging rule):
		if a random battery compartment which is part of the machine contains a fully charged rechargeable battery (called the power source):
			say "[The power source] in [the machine] [is-are of power source] now fully charged."

The intent is that the player need not constantly recheck the battery during charging to determine whether it has finished yet.

Example: * Lamplighter - A very simple scenario with a wall-plugged lamp that lights when turned on.

	*: "Lamplighter"

	Include Power Sources by Emily Short.

	Salon is a room. A lamp is a device in the Salon. "A lamp [if lit]shines brightly[otherwise]sits[end if] here." The lamp incorporates a PS-plug.

	The Salon contains a wall socket. 

	When play begins:
		let spot be a random wall socket in the Salon;
		if spot is a wall socket:
			silently try plugging the lamp into spot.
			
	Carry out switching on the lamp:
		now the lamp is lit.
	
	Carry out switching off the lamp:
		now the lamp is unlit.

	Test me with "look / turn on lamp / look / unplug lamp / look / turn on lamp / plug in lamp / turn on lamp / unplug lamp / plug lamp into wall socket".

Example: * Lamplighter Two - The same scenario, but with the addition of a portable flashlight and a battery-operated robot dog.

	*: "Lamplighter Two"

	Include Power Sources by Emily Short.
		
	An electric light is a kind of device. Carry out switching on an electric light: now the noun is lit. Carry out switching off an electric light: now the noun is unlit. 
	
	Salon is a room. A lamp is a fixed in place electric light in the Salon. "A lamp [if lit]shines brightly[otherwise]sits[end if] here." The lamp incorporates a PS-plug.
	
	The flashlight is an electric light carried by the player. It incorporates a battery compartment.
	
	The Salon contains a wall socket. 
	
	When play begins:
		let spot be a random wall socket in the Salon;
		if spot is a wall socket:
			silently try plugging the lamp into spot.
	
	The robot dog is a device in the Salon. The battery drain of the robot dog is 10. 
	
	Every turn when the robot dog is switched on: say "The robot dog barks."
	
	The robot dog incorporates a battery compartment. The player carries one battery.
	
	Test me with "look / turn on lamp / look / unplug lamp / look / turn on lamp / plug in lamp / turn on lamp / unplug lamp / plug lamp into wall socket / turn on robot dog / open dog / put battery in dog / turn on dog / drop dog / i / z / open flashlight / put battery in flashlight / close battery compartment / turn on flashlight / i  / z / z / z / z / z / z / z / z ".
	

Example: * Lamplighter Three - The flashlight again, but this time with a rechargeable battery and a battery charger that can restore it to full strength. We also use the "warning about the failure" activity to add a more interesting description when the flashlight is about to go out.

Our battery charger is going to be a simple device that includes both a plug and a battery compartment. 

	*: "Lamplighter Three"

	Include Power Sources by Emily Short.

	A light source is a kind of device. Carry out switching on a light source: now the noun is lit. Carry out switching off a light source: now the noun is unlit.

	Salon is a room. A lamp is a fixed in place light source in the Salon. "A lamp [if lit]shines brightly[otherwise]sits[end if] here." The lamp incorporates a PS-plug.

	The flashlight is a light source carried by the player. It incorporates a battery compartment. The player carries a rechargeable battery. The battery drain of the flashlight is 6.

	The Salon contains a wall socket.

	When play begins:
		let spot be a random wall socket in the Salon;
		if spot is a wall socket:
			silently try plugging the lamp into spot.

	The player carries a charger. The charger is a device. The charger incorporates a battery compartment. The charger incorporates a PS-plug. Understand "battery charger" as the charger.

	Instead of examining the charger:
		let cell be a random battery which is in a battery compartment which is part of the charger;
		if cell is not a battery or charger is not wall-powered:
			say "The light on the battery charger is off." instead;
		otherwise if cell is not a rechargeable battery:
			say "The light on the battery charger flashes a warning red." instead;
		otherwise if the cell is fully charged:
			say "The light on the battery charger glows green to indicate a full charge." instead;
		otherwise:
			say "The light on the battery charger glows red to indicate charging."

	Carry out plugging the charger into a wall socket:
		now the charger is in the location.

	Carry out unplugging the charger:
		now the player carries the charger.

	Report inserting a battery into a battery compartment which is part of the charger:
		say "You put [the noun] into [the second noun]. [run paragraph on]";
		try examining the charger instead.

	When play begins:
		let target be a random battery compartment that is part of the charger;
		now the target is open;
		now the target is not openable.

	Rule for warning about the failure of the flashlight:
		if a random battery compartment which is part of the flashlight contains a	battery (called the power source):
			let turns remaining be the charge of the power source divided by the battery drain of the flashlight;
			if the turns remaining is 1:
				say "The flashlight is getting appreciably dimmer."

	Test me with "look / turn on lamp / look / unplug lamp / look / turn on lamp / plug in lamp / turn on lamp / unplug lamp / plug lamp into wall socket / i / open flashlight / put battery in flashlight / close battery compartment / turn on flashlight / i  / z / z / z / z / z / z / z / z / open flashlight / get battery / put battery in charger / x charger / unplug lamp / plug in charger / x charger / z / z / z / z / z /z / z / x charger / z / z / z / z / z / x charger / put battery in flashlight / turn on flashlight".