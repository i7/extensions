Version 1/210918 of Repetition with Variation by Zed Lopez begins here.

"Provides an infinite loop; provides an indexed loop that counts
down; allows more flexible syntax for existing loops. For 6M62."

Include 6M62 Patches by Friends of I7. [ need TEXT_TY_BlobAccess fix ]

Book Now with Index

[ works while looping through a list or table.
  doesn't work with set descriptions.
  entirely subject to breaking on next release of I7 ]

To decide what number is the loop index: (- tmp_1 -).

Book Infinite Loop

[ it's your responsibility to break out! ]
To repeat forever begin -- end loop:
    (- while(1) -)

Book Descending

To repeat with/for (loopvar - nonexisting K variable) from/in (v - arithmetic value of kind K) downto (w - K) begin -- end loop:
      (- for ({loopvar}={v}: {loopvar}>={w}: {loopvar}-- ) -).

Book Overwriting Standard Rules 

Section Flexible Repeat Syntax (in place of Section SR5/3/3 - Control phrases - Repeat in Standard Rules by Graham Nelson)

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - arithmetic value of kind K) to (w - K) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++)  -).

To repeat with/for (loopvar - nonexisting K variable)
	running/-- from/in (v - enumerated value of kind K) to (w - K) begin -- end loop
	(documented at ph_repeat):
		(- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++)  -).

To repeat with/for (loopvar - nonexisting K variable)
	running/-- through/in (OS - description of values of kind K) begin -- end loop
	(documented at ph_runthrough):
		(- {-primitive-definition:repeat-through} -).

To repeat with/for (loopvar - nonexisting object variable)
	running/-- through/in (L - list of values) begin -- end loop
	(documented at ph_repeatlist):
		(- {-primitive-definition:repeat-through-list} -).

To repeat running/-- through/in (T - table name) begin -- end loop
	(documented at ph_repeattable): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=1, ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}<=TableRows({-my:1}):
			{-my:2}++, ct_0={-my:1}, ct_1={-my:2})
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

To repeat running/-- through/in (T - table name) in reverse order begin -- end loop
	(documented at ph_repeattablereverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}>=1:
			{-my:2}--, ct_0={-my:1}, ct_1={-my:2})
			if (TableRowIsBlank(ct_0, ct_1)==false)
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).
To repeat running/-- through/in (T - table name) in (TC - table column) order begin -- end loop
	(documented at ph_repeattablecol): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2})
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

To repeat running/-- through/in (T - table name) in reverse (TC - table column) order begin -- end loop
	(documented at ph_repeattablecolreverse): (-
		@push {-my:ct_0}; @push {-my:ct_1};
		for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}:
			{-my:2}~=0:
			{-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2})
				{-block}
		@pull {-my:ct_1}; @pull {-my:ct_0};
	-).

Repetition with Variation ends here.

---- Documentation ----

Redefines existing "repeat" statements such that:

"repeat running through" and "repeat through" are interchangeable (i.e., "running" is permissible while looping through tables, and omitting it is permissible everywhere)

"for" may replace "with"

"in" may replace "from"

"in" may replace "through"

So all of the following are equivalent:

Repeat with i running from 1 to 10
Repeat with i from 1 to 10
Repeat for i in 1 to 10

And these are equivalent:

Repeat running through the Table of Ill-considered decisions
Repeat for the Table of Ill-considered decisions

Section Changelog

1/210918: removed some looping through text phrases that weren't working
