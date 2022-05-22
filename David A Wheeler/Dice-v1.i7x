Version 1.3 of Dice by David A Wheeler begins here.
"Support conventional X d Y dice notation, e.g., 3 d 6 totals 3 six-sided dice."

[ Released under the terms of the Creative Commons Attribution 4.0 International (CC-BY-4.0) license.  See https://creativecommons.org/licenses/by/4.0/ for license details. You may also use this under the Creative Commons Attribution 3.0 United States (CC-BY-3.0-US) license. See https://creativecommons.org/licenses/by/3.0/us/ for license details. You may also use this under the terms of the MIT license. See https://opensource.org/licenses/MIT for license details.

SPDX-License-Identifier: CC-BY-4.0 OR CC-BY-3.0-US OR MIT

Copyright (C) David A. Wheeler and Dice project contributors.]

To decide which number is (num - number) d (sides - number):
	let result be 0;
	repeat with iteration running from 1 to num:
		increase result by a random number between 1 and sides;
	decide on result.

Dice ends here.

---- DOCUMENTATION ----

This is a simple extension to simplify rolling dice and adding them up. Simply use 'd' with the number of dice on the left and the number of sides on the right, as is common convention. You must have whitespace around the 'd'.

E.g., 3 d 6 totals 3 six-sided dice, while 4 d 8 + 7 totals 4 eight-sided dice (and then adds 7 to that result). The value of 10 d 1 + 2 will be 12 every time, since a 1-sided die always produces 1.

You may use this extension under the terms of the Creative Commons Attribution 3.0 United States (CC-BY-3.0-US) license, Creative Commons Attribution 4.0 International (CC-BY-4.0), OR the MIT license. See the source code for details.

Example: * Pest Control - Dice in Action

	"Pest Control" by David A Wheeler

	Include Dice by David A Wheeler.

	[Significants parts below are derived from the "Randomness" section example "Lanista 1"]

	A person has a number called current hit points.

	The Dragon's Lair is a room. "This is a beautiful airy room."
	An animal called Malevilness the Red Dragon is here.
	The description of Malevilness is "Malevilness the Red Dragon is taller than 3 men, and there's always room in his stomach for one more."

	When play begins:
		now the current hit points of the player is 5 d 8;
		now the current hit points of Malevilness is 5 d 8;
		now the left hand status line is "You: [current hit points of player]";
		now the right hand status line is "Dragon: [current hit points of Malevilness]".

	Instead of attacking someone:
		let the damage be 3 d 6;
		say "You attack [the noun], causing [damage] points of damage!";
		decrease the current hit points of the noun by the damage;
		if the current hit points of the noun is less than 0: 
			say "[line break][The noun] expires!";
			now the noun is nowhere;
			end the story finally;
			stop the action;
		let the enemy damage be 2 d 4;
		say "[line break][The noun] attacks you, causing [enemy damage] points of damage!";
		decrease the current hit points of the player by the enemy damage;
		if the current hit points of the player is less than 0:
			say "[line break]You expire!";
			end the story.

	Test me with "hit dragon / g / g / g".
