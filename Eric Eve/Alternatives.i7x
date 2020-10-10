Version 3 of Alternatives by Eric Eve begins here.
"Allows checking the presence of an object or value in a set of objects or values with new either/or and neither/nor phrases. e.g., 'If the noun is either the carrot or the potato:', or 'Instead of eating something when the noun is neither the cake nor the pudding:'"


Part 1 - Value Phrases

To decide whether ( num - value of kind K) is either (num1 - K) or (num2 - K):
  (-  ({num} == {num1} or {num2})   -).

To decide whether ( num - value of kind K) is either (num1 - K) or (num2 - K) or (num3 - K):
  (-  ({num} == {num1} or {num2} or {num3})   -).

To decide whether ( num - value of kind K) is either (num1 - K) or (num2 - K) or (num3 - K) or (num4 - K):
  (-  ({num} == {num1} or {num2} or {num3} or {num4})   -).

To decide whether ( num - value of kind K) is either (num1 - K) or (num2 - K) or (num3 - K) or (num4 - K) or (num5 - K):
  (-  ({num} == {num1} or {num2} or {num3} or {num4} or {num5})   -).

To decide whether ( num - value of kind K) is either (num1 - K) or (num2 - K) or (num3 - K) or (num4 - K) or (num5 - K)  or (num6 - K):
  (-  ({num} == {num1} or {num2} or {num3} or {num4} or {num5} or {num6})   -).


To decide whether ( num - value of kind K) is neither (num1 - K) nor (num2 - K):
  (-  ({num} ~= {num1} or {num2})   -).

To decide whether ( num - value of kind K) is neither (num1 - K) nor (num2 - K) nor (num3 - K):
  (-  ({num} ~= {num1} or {num2} or {num3})   -).

To decide whether ( num - value of kind K) is neither (num1 - K) nor (num2 - K) nor (num3 - K) nor (num4 - K):
  (-  ({num} ~= {num1} or {num2} or {num3} or {num4})   -).

To decide whether ( num - value of kind K) is neither (num1 - K) nor (num2 - K) nor (num3 - K) nor (num4 - K) nor (num5 - K):
  (-  ({num} ~= {num1} or {num2} or {num3} or {num4} or {num5})   -).
  
  To decide whether ( num - value of kind K) is neither (num1 - K) nor (num2 - K) nor (num3 - K) nor (num4 - K) nor (num5 - K) nor (num6 - K):
  (-  ({num} ~= {num1} or {num2} or {num3} or {num4} or {num5} or {num6})   -).


Alternatives ends here.

---- DOCUMENTATION ----

Chapter: Alternatives

Section: The Basics

This extension adds a number of conditions that can be used with IF, WHEN and the like:

	X is either A or B
	X is either A or B or C
	X is either A or B or C or D
	X is either A or B or C or D or E
	X is either A or B or C or D or E or F

	X is neither A nor B
	X is neither A nor B nor C
	X is neither A nor B nor C nor D
	X is neither A nor B nor C nor D nor E
	X is neither A nor B nor C nor D nor E nor F
	
For this to work, either A, B, C, D, E  and F must all be the same kind of value as X. Thus, for example, if X is an object, A, B, C etc. must all be objects or if X is a number then A, B, C etc. must all be numbers. Apart from this restriction, these phrases can be used with any kind of value, including new kinds defined by a game author. This allows us to use tests like:

	if the colour of the noun is either red or blue...

	Instead of eating the noun when the colour of the noun is neither blue nor orange nor green...

(Assuming, of course, that we have defined colour as a kind of value which includes red, blue, green and orange among its possible values). Note in this case that we must test "the colour of the noun" not just the "noun"; the following condition will not compile:

	If the noun is either red or blue,

Instead we must write:

	if the colour of the noun is either red or blue...

The reason is that the phrase is testing for literal equality, and a thing can never be equal to a colour.

Section: Other Restrictions and Workarounds

Note that Alternatives only works for comparisons, that is for testing whether one value is equal to one of up to six other values, or unequal to all of six other values. Although it might be useful to be able to do so, Alternatives does not allow us to write, for example:

	After taking either the bucket or the spade:
		say "You pick up [the noun] with gusto."

It is, however, often possible to achieve the desired effect with a slight rephrasing. We can, for example, write:

	After taking when the noun is either the bucket or the spade:
		say "You pick up [the noun] with gusto."

And this will have the desired effect.

A similar technique can be used to handle numerical values input by the player, for example:

	*: Guessing is an action applying to one number.
   
	Understand "guess [number]" as guessing.
   
	After guessing when the number understood is either 2 or 3 or 5 or 7 or 11 or 13:
		say "Ah, a prime number less than 17!"
      
	Report guessing: Say "[the number understood] doesn't interest me much."
	
Section: Changes in Version 2

The number of items that can appear on the right hand side of the comparison has been increased from five to six. This is probably more than enough for most purposes, but should several users wish this to be extended further that is something I could consider for a future version.

Version 1 allowed objects and numbers to be compared with these phrases, and tentatively allowed other types of value. Version 2 is no longer tentative about comparing other types of value with these phrases. On the other hand Version 2 enforces stricter type checking at compilation time. Version 1 would allow:

	if the noun is either the ball or 2 or red or "fred",...
	
Which was hardly useful, and which will no longer compile in Version 2.

These changes employ features of Inform 7 that are new to Release 6E59.
	

Example: * Paintshop Blues - Experimenting with the actions the player is prepared to perfom on differently coloured objects.

This is something of a toy example, and there's nothing it does that couldn't be done some other (and often better) way in Inform; nonetheless it serves to illustrate how this extension can be used. 

	*: "Paintshop Blues" by Eric Eve

	Book 1 - World Model

	Include Alternatives by Eric Eve.

	colour is a kind of value. The colours are red, orange, yellow, green, turquoise, blue, purple, black and white.

	A chromatinon is a kind of thing. A chromatinon has a colour. 

	before printing the name of a chromatinon:
	  say "[colour of the item described] ";

	Understand the colour property as describing a chromatinon.

	Painting is an action applying to one thing and one colour.

	Understand "paint [something] [colour]" as painting.

	Check painting something when the noun is not a chromatinon:
	   say "I'm afraid that can't be recoloured." instead.

	Check painting a chromatinon when the colour of the noun is the colour understood:
	  say "But [the noun] is already [the colour understood]!"

	Carry out painting a chromatinon:
	  Now the colour of the noun is the colour understood.

	Report painting a chromatinon:
	  say "Okay -- it's now [a noun]."

	Book 2 - Scenario

	Part 1 - Objects

	The Experimental Paintshop is a room.
	"This is where you can test the effect of colour on your highly colour-sensitive mind."

	The ball is a blue chromatinon in the Experimental Paintshop.

	The pencil is a black chromatinon in the Experimental Paintshop.

	The pen is a red chromatinon in the Experimental Paintshop.

	The table is a supporter in the Experimental Paintshop.

	The china cup is an orange chromatinon on the table.

	The china plate is a white chromatinon on the table.

	Part 2 - Rules

	After taking something when the noun is either the pencil or the pen:
	  say "You pick up a writing implement ([a noun], to be precise)."

	After taking the ball when the colour of the ball is either blue or green:
	  say "You pick up [the ball]."

	Instead of dropping something when the noun is either the china cup or the china plate:
	  say "But it might break if you drop it!"

	After taking inventory when the number of things carried by the player is either 1 or 3 or 5:
	  say "You seem to be holding an odd number of things."

	After taking inventory when the number of things carried by the player is neither 0 nor 1 nor 3 nor 5:
	  say "You are carrying an even number of objects."

	Instead of dropping something when the colour of the noun is either turquoise or blue or purple:
	  say "But it's so pretty -- [the colour of the noun] is one of your favourite colours!"

	Instead of taking something when the colour of the noun is either black or white:
	  say "But it's so plain!"

	Before eating something when the colour of the noun is neither red nor orange nor green nor white:
	  say "Whoever heard of [colour of the noun] food? [A noun] can't possibly be edible!" instead.

	Test me with "eat ball/take plate/paint plate red/eat plate/drop plate/take pencil/paint pencil orange/take pencil/i/take ball/drop ball/i/take pen/paint pen purple/eat pen/drop pen/i"


Note once again what we must test "the colour of whatever" and not just "whatever" with these phrases. It would be pointless to have a clause like "when the noun is either red or blue" since this condition would not compile (and could not be met even if it did compile).

Although this is a toy example it does illustrate one or two situations where this extension might be useful. For example we could have achieved the same effect as the "Instead of dropping rule" for the cup and plate above with:

	Definition: a thing is breakable if it is the china cup or if it is the china plate.

	Instead of dropping something breakable:
 	say "But it might break if you drop it!"

But this extension would save us the extra step of defining the breakable adjective, which might be useful if this were the only such case we wanted to catch.

