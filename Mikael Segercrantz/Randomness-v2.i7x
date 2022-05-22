Version 2.2 of Randomness by Mikael Segercrantz begins here.

"Random number generation using a simple seedable pseudorandom number generator."

Section 1 - The pseudorandom number generator kind

A pseudorandom number generator is a kind.
A pseudorandom number generator has a number called previous value.
A pseudorandom number generator has a number called multiplier.
A pseudorandom number generator has a number called adder.


Section 2 - Seeding the generator

To seed the random number generator (prng - a pseudorandom number generator) with (n - a number):
	now the previous value of prng is n.

To set the multiplier of (prng - a pseudorandom number generator) to (n - a number):
	now the multiplier of prng is n.

To set the adder of (prng - a pseudorandom number generator) to (n - a number):
	now the adder of prng is n.


Section 3 - Initialize the generators

To initialize the random number generators:
	let seed be 1234;
	repeat with prng running through pseudorandom number generators:
		now the multiplier of prng is 13;
		now the adder of prng is 4399;
		seed the random number generator prng with seed;
		now the seed is seed + 1234.

When play begins:
	initialize the random number generators.


Section 4 - Getting a random number

To decide what number is the next random number of (prng - a pseudorandom number generator):
	let current value be the previous value of prng;
	let current value be current value * multiplier of prng;
	let current value be current value + adder of prng;
	now the previous value of prng is the current value;
	decide on current value.

To decide what number is the previous random number of (prng - a pseudorandom number generator):
	decide on previous value of prng.

To decide what number is the next random number:
	decide on the next random number of the main pseudorandom number generator.

To decide what number is the previous random number:
	decide on the previous random number of the main pseudorandom number generator.


Section 5 - The main pseudorandom number generator

The main pseudorandom number generator is a pseudorandom number generator.


Randomness ends here.

---- DOCUMENTATION ----

Chapter: Information on the Pseudorandom number generator

The Randomness extension creates a pseudorandom number generator kind, which has a few properties in it:

	the previous value - the latest calculated random number
	the multiplier - the multiplier used to create random numbers
	the adder - the adder used to create random numbers

The pseudorandom number generator of the Randomness extension is of the most basic kind, utilizing the formula SEED = (SEED * MULT) + ADD to generate random numbers.

Chapter: The main pseudorandom number generator

This extension automatically creates one pseudorandom number generator called the main pseudorandom number generator. If your project requires multiple generators, you are free to create more of them, e.g. with

	The skeleton in the closet pseudorandom number generator is a pseudorandom number generator.

Chapter: Seeding the PRNG

To seed the pseudorandom number generator created by the Randomness extension, you can use the following phrases:

	seed the random number generator (name of generator) with (the seed value).
	set the multiplier of (name of generator) to (the multiplier value).
	set the adder of (name of generator) to (the adder value).

It is highly recommended that the multiplier be a prime number; the same can be said of the adder, although the extension does not require this.

Chapter: Reading values from the PRNG

You can read any pseudorandom number generator using the following syntax:

	the next random number of (name of generator)

However, accessing the main pseudorandom number generator is somewhat easier:

	the next random number

is enough to access it.

If you wish to read the last random number generated, you can use

	the previous random number of (name of generator)

and

	the previous random number

to access them.
