Version 1 of Effective Infinity by Mike Ciul begins here.

"Provides a system of counting numbers which never go below 0 or above a specified maximum value. Any numbers above the maximum are considered infinite."

Book - Quantities

Chapter - Effective Infinity

Use maximum counting number of at least 4 translates as (- Constant MAX_FINITE_INT = {N}; -).

[todo: allow quantities to be represented as numerals or spelled out, using use options]

To decide which number is maximum counting number: (- (MAX_FINITE_INT) -).

To decide which number is effective infinity: decide on maximum counting number plus one.

Definition: a number is effectively infinite rather than effectively finite if it is greater than maximum counting number.

Chapter - Keeping Numbers Within Bounds

To decide what number is the counting number after (N - a number):
	decide on N increased by 1 within counting range;

To decide what number is the counting number before (N - a number):
	decide on N decreased by 1 within counting range;

To decide what number is (N - a number) decreased by (M - a number) within counting range:
	decide on N increased by (M * -1) within counting range;

To decide what number is (N - a number) increased by (M - a number) within counting range:
	if N is effectively infinite, decide on effective infinity;
	Let the result be N + M;
	if the result is effectively infinite, decide on maximum counting number;
	if the result is less than zero, decide on zero;
	decide on the result;

Chapter - Printing an Approximate Number

Printing an approximate number of something is an activity on numbers.

To say (N - a number) as an approximate number:
	if N is zero, say "no";
	otherwise carry out the printing an approximate number activity with N.

For printing an approximate number for a number (called N):
	[watch out for the 0 bug: if this activity is called with 0, N could have any value at all!]
	if N is effectively infinite:
		say "a great many";
	otherwise if N is zero:
		say "no";
	otherwise if N is one:
		say "a";
	otherwise if N is two:
		say "a couple";
	otherwise if N is three:
		say "a few";
	otherwise:
		say "several";

Effective Infinity ends here.

---- DOCUMENTATION ----

Effective Infinity allows us to assign a particular integer to represent an infinite number of things. The greatest number that we can then represent will be one less than "effective infinity," and there is an option to set this number:

	Use maximum multiplicity of at least 100.

In this case "effective infinity" will be represented by the number 101.

	Use maximum multiplicity of at least 100.

	Change the number of gravel in the Quarry to maximum multiplicity.

	Add some gravel to the Quarry.

The Quarry will still have 100 pieces of gravel. But we can always do this:

	Fill the Quarry with gravel.

And now we'll have an unlimited supply.

Note for old-schoolers: Though it may be tempting to set maximum multiplicity to 69,105, that number is outside the range of numbers in the Z-machine, and it will wrap around to 3569.

Section: Printing an Approximate Number for a Number

The printing an approximate number activity is an activity on numbers. This is the one we might want to override if we'd prefer our numbers written a different way:

	rule for printing an approximate number for (N - a number):
		say "[N in words]";

	rule for printing an approximate number for (N - a number) when the writing style is totally wild:
		if N is 0:
			say "zilch";
		if N is 1:
			say "an all-a-lonely";
		if N is 2:
			say "a coupla";
		if N is at least 3 and N is less than 10:
			say "not a whole lotta";
		otherwise:
			say "a really freakin whole big bunch of"

The "N as an approximate number" phrase uses the "printing an approximate number" activity:

	say "[3 as an approximate number]"

would output:
	
	a few

