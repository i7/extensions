Version 1 of Approximate Quantities by Mike Ciul begins here.

"A means to print numbers as 'a few' or 'hundreds.' Also provides a system of counting numbers which never go below 0 or above a specified maximum value. Any numbers above the maximum are considered infinite."

"Evolved from Effective Infinity by Mike Ciul and borrowed from Assorted Text Generation by Emily Short."

Include Plurality by Emily Short.

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

Book - Collective Plurality

[I've borrowed heavily from Plurality, to extend the concept of "ambiguously plural." Now the ambiguously plural property combines with the plural-named property for more nuance. An ambiguously plural thing will still be treated as singular if it's referred to using the definite object. But you can make it plural-named if you want that. The choice is between:

indefinite article: "a [collective]murder of" + plural-named noun: "crows"

and:

indefinite article: "a" + singular-named noun: "murder of crows" 

I ended up needing three new variables: The current naming style, the collectively named noun, and pending naming override. The current naming style says whether we are going to treat an object as singular in the text. The collectively named noun says what that object is, and the pending naming override is a truth state that keeps track of whether we've actually said that object's name yet. It's needed so we can declare that something will be collective before we've actually said what it is, and then after we're done with it, we know to go back to treating it normally.

This handled the normal indefinite article case pretty neatly, but I still had to do some hacking for the case where the verb comes first. In that case we have to assume that all ambiguously plural nouns should be treated as singular.

In all cases, I assume that ordinarily enumerated plural-named things always have plural verbs, even if the "[collective]" phrase is invoked.
]

Section - Resolving Ambiguous Plurality

Plurality style is a kind of value. The plurality styles are normal, collective, and truly plural.

The current naming style is a plurality style that varies. The collectively named noun is an object that varies. Pending naming override is a truth state that varies.

After reading a command: reset the plurality style to normal.

To reset the plurality style to (new style - a plurality style):
	Now the collectively named noun is nothing;
	Unless the new style is normal, now pending naming override is true;
	Now the current naming style is the new style.

To say normal plurality style: reset the plurality style to normal;

To say collective: reset the plurality style to collective;

To say truly plural: reset the plurality style to truly plural;

To update plurality of (target - a thing):
	now the prior named noun is the target;
	if pending naming override is true, now the collectively named noun is the target;

After printing the name of an object (this is the naming is no longer pending rule):
	If pending naming override is false, reset the plurality style to normal;
	Now pending naming override is false.

Section - Tracking Last Item (in place of Section 1 - Tracking Last Item in Plurality by Emily Short)
 
A thing can be neuter. A thing is usually neuter.

The prior named noun is a thing that varies. The prior named noun is yourself.

After printing the name of something (called the target) (this is the notice plurality of printed object rule): 
	mark target in output.

The notice plurality of printed object rule is listed before the naming is no longer pending rule in the after printing the name rulebook.

To mark (target - a thing) in output:
	update plurality of the target;
	if the target acts plural or target is the player, mark-future-plural; 
	otherwise mark-future-singular;

To mark-future-plural:
	(- say__n = 1; -)
	
To mark-future-singular:
	(- say__n = 29; -)
    
To decide whether (item - an object) acts plural:
	if the collectively named noun is not the prior named noun, now the collectively named noun is nothing;
	if the item is the collectively named noun and the item is ambiguously plural:
		if the current naming style is collective, no;
		if the current naming style is truly plural, yes;
	if the item is plural-named, yes;
	no.

Section - Verbs (in place of Section 2 - Verbs in Plurality by Emily Short)

To say is-are: 
	say is-are of prior named noun.
    
To say is-are of (item - a thing):
	update plurality of item;
	if prior named noun acts plural or the prior named noun is the player, say "are"; otherwise say "is".

To say Is-are:
	say Is-are of prior named noun.

To say Is-are of (item - a thing):
	update plurality of the item;
	if prior named noun acts plural or the prior named noun is the player, say "Are"; otherwise say "Is".

To say has-have:
  say has-have of prior named noun.

To say has-have of (item - a thing):
  if the item acts plural or the item is the player begin;
    say "have";
  otherwise;
    say "has";
  end if.

To say Has-have of (item - a thing):
  if the item acts plural or the item is the player begin;
    say "Have";
  otherwise;
    say "Has";
  end if.

To say Has-have:
  say Has-have of prior named noun. 
    
To say 's-'re of (item - a thing):
	now the prior named noun is the item;
	if the item acts plural or the item is the player:
		say "[']re";
	otherwise:
		say "[']s".

To say 's-'re:
	say 's-'re of the prior named noun.

To say numerical 's-'re:
	(- if (say__n == 1) print "'s"; else print "'re"; -)

To say numerical is-are:
	(- if (say__n == 1) print "is"; else print "are"; -)
	
To say numerical has-have:
	(- if (say__n == 1) print "has"; else print "have"; -)
    
To say Numerical is-are:
	(- if (say__n == 1) print "Is"; else print "Are"; -)
	
To say Numerical has-have:
	(- if (say__n == 1) print "Has"; else print "Have"; -)
	
To say es:
  say es of prior named noun

To say es of (item - a thing):
  if the item acts plural or the item is the player begin;
    say "";
  otherwise;
    say "es";
  end if.

To say ies:
  say ies of prior named noun

To say ies of (item - a thing):
  if the item acts plural or the item is the player begin;
    say "y";
  otherwise;
    say "ies";
  end if.	

Chapter - Printing an Approximate Number

To say (N - a number) as an approximate quantity:
	say N as an approximate quantity using the Table of Numerical Approximation.

To say (N - a number) as an approximate quantity using (T - a table-name):
	sort T in reverse threshold order;
	repeat through T:
		if N is effectively infinite or N is at least the threshold entry:
			if there is a plurality style, reset the plurality style to the style entry;
			say "[approximation entry]";
			stop;

To say is-are (N - a number) as an approximate quantity:
	say is-are N as an approximate quantity using the Table of Numerical Approximation.

To say is-are (N - a number) as an approximate quantity using (T - a table-name):
	sort T in reverse threshold order;
	repeat through T:
		if N is effectively infinite or N is at least the threshold entry:
			if there is a plurality style, reset the plurality style to the style entry;
			if N is 1 and the plurality style is not truly plural:
				say "is";
			otherwise if the plurality style is collective:
				say "is";
			otherwise:
				say "are";
			say " [approximation entry]";
			stop;

Table of Numerical Approximation
threshold	approximation	style
0	"no"	truly plural
1	"one"	--
2	"a couple"	truly plural
3	"a few"	truly plural
5	"several"	truly plural
10	"many"	truly plural
30	"lots of"	truly plural
100	"hundreds of"	truly plural
2000	"thousands of"	truly plural
10000	"a great many" 	truly plural

Approximate Quantities ends here.

---- DOCUMENTATION ----

Approximate Quantities gives us a phrase to say a number as an approximate adjective, to use as an indefinite article, for example. The phrase is:

	To say (N - a number) as an approximate quantity:

We can invoke it like this:

	The gumballs have a number called the exact count.

	The indefinite article of the gumballs is "[exact count of the gumballs as an approximate quantity]"

Approximate Quantities will ensure verb number agreement with Plurality, so we can use the "[is-are]" phrase after a number and get the right result. We also have a phrase to use if the verb needs to come before the number:

	To say is-are (N - a number) as an approximate quantity:

Invoked like so:

	For writing a paragraph about the gumballs: say "In the machine [is-are the exact count of the gumballs as an approximate quantity] [gumballs]."

By default, the number will be expressed according to the entries in the Table of Numerical Approximation. The Table lists "no" for zero, "one" for one, "a couple" for two, etc. We can amend the Table, or we can create are own and use it with these phrases:

	To say (N - a number) as an approximate quantity using (T - a table-name):

	To say is-are (N - a number) as an approximate quantity using (T - a table-name):

The table should have three columns: Threshold, Approximation, and Style. The Threshold is the smallest number that should match N (this is different from Assorted Text Generation, which uses an upper threshold rather than a lower one). The approximation is the text that is printed. The style is a value of kind "plurality style," which can take one of three values: "normal," "collective," and "truly plural."

Plurality styles are used with the Plurality extension to ensure that the verb number matches. When we use an "as an approximate quantity" phrase, the extension keeps track of which style matches the text used. For example, "some" would use the "truly plural" style, indicating that the noun is plural, while "a pair of" would use the "collective" style, causing the noun to be treated as singular. "Normal" would preserve the default behavior.

Because of this extra complication, Plurality needs a little help determining the number of nouns in other cases. Approximate Quantities redefines the "acts plural" phrase so that it is only true when an object is plural-named or "truly plural" style is currently active. In addition, the plurality styles only apply to things that are "ambiguously plural." If a thing is "ordinarily enumerated," the styles will have no effect.

Now we have enough information to create our own table of approximations.

	Table of Numerical Sets
	threshold	approximation	style
	0	"an absence of"	truly plural
	1	"a single"	collective
	2	"a pair of"	collective
	3	"a triplet of"	collective
	4	"a whole mess of"	collective

	The indefinite article of the gumballs is "[exact count of the gumballs as an approximate quantity using the Table of Numerical Sets]"

Approximate Quantities allows us to assign a particular integer to represent an infinite number of things. The greatest number that we can then represent will be one less than "effective infinity," and there is an option to set this number:

	Use maximum counting number of at least 100.

In this case "effective infinity" will be represented by the number 101.

By default, the maximum counting number is 4. This is not because that would be desirable in most cases, but because it's possible to increase it, but not to decrease it.

When saying an approximate value, effective infinity will always produce the highest number in the table being used, regardless of whether there are multiple entries greater than the maximum counting number. Here's an example:

	Use maximum counting number of 5.

	Table of Big Numbers
	threshold	approximation	style
	0	"no"	--
	1	"one"	--
	2	"some"	--
	10	"a lot of"	--
	100	"a really big number of" --

	When play begins: say "9 is [9 as an approximate quanity using Table of Big Numbers] things."

This will produce the output "9 is a really big number of things," not "9 is a lot of things."

Note for old-schoolers: Though it may be tempting to set the maximum counting number to 69,105, that number is outside the range of numbers in the Z-machine, and it will wrap around to 3569.
