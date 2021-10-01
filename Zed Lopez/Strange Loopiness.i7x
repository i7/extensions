Version 1/210930 of Strange Loopiness by Zed Lopez begins here.

"Repeat variants for: while loop; until loop; loop counting down over a numeric
range. For any loop optionally assign a loop counter variable; for looping
through tables optionally assign a row number variable. Allows more
flexible syntax for the existing repeat loops. For 6M62."

Part while loop

Chapter while conditional

Section while conditional plain

To repeat while (c - a condition) begin -- end loop:
    (- while ({c}) -).

Section while conditional with index

To repeat while (c - a condition) with/using index (index - nonexisting number variable) begin -- end loop:
    (- {index} = 0; while ({c} && ++{index}) -).

Part repeat until

Chapter until condition

Section until condition plain

[ with an until loop, body is always executed at least once:
  the condition is tested at the end of the loop, not the
  beginning. ]
To repeat until (c - a condition) begin -- end loop:
(-
  do
    {-block}
  until ({c});
-)

Section until condition with index

To repeat until (c - a condition) with/using index (index - nonexisting number variable) begin -- end loop:
(-
  {index} = 0;
  do if (++{index}) {-block}  
  until ({c});
-)

Book Descending

Part descent plain

To repeat with/for (loopvar - nonexisting K variable) running/-- from/in (v - arithmetic value of kind K) down to (w - K) begin -- end loop:
      (- for ({loopvar}={v}: {loopvar}>={w}: {loopvar}-- ) -).

Part descent with index

To repeat with/for (loopvar - nonexisting K variable) running/-- from/in (v - arithmetic value of kind K) down to (w - K) with/using index (index - a nonexisting number variable) begin -- end loop:
      (- for ({loopvar}={v}, {index} = 1: {loopvar}>={w}: {loopvar}--, {index}++ ) -).

Book Overwriting Standard Rules 

Section Clobber Standard Repeat Rules (in place of Section SR5/3/3 - Control phrases - Repeat in Standard Rules by Graham Nelson)

Use ineffectual.

Part Alternate Repetitions

Chapter Specified numeric range

To repeat with/for (loopvar - nonexisting K variable)
  running/-- from/in (v - arithmetic value of kind K) to (w - K) begin -- end loop
  (documented at ph_repeat):
    (- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++ ) -).

Section Specified numeric range with index

To repeat with/for (loopvar - nonexisting K variable) 
  running/-- from/in (v - arithmetic value of kind K) to (w - K) with/using index (index - a nonexisting number variable) begin -- end loop
  (documented at ph_repeat):
    (- for ({loopvar}={v}, {index} = 1: {loopvar}<={w}: {loopvar}++, {index}++ )  -).

Chapter Specified enumerated value range

To repeat with/for (loopvar - nonexisting K variable)
  running/-- from/in (v - enumerated value of kind K) to (w - K) begin -- end loop
  (documented at ph_repeat):
    (- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++ )  -).

Section Specified enumerated value range with index

To repeat with/for (loopvar - nonexisting K variable)
  running/-- from/in (v - enumerated value of kind K) to (w - K) with/using index (index - nonexisting number variable) begin -- end loop
  (documented at ph_repeat):
    (- for ({loopvar}={v}, {index}=1: {loopvar}<={w}: {loopvar}++, {index}++)  -).

Chapter Description of objects

[ this works with objects *or* values because -primitive-definition gets up to some
  magic ]
To repeat with/for (loopvar - nonexisting K variable)
  running/-- through/in (OS - description of values of kind K) begin -- end loop
  (documented at ph_runthrough):
    (- {-primitive-definition:repeat-through} -).

Section Description of objects with index

[ This only works with objects 'cause I can't reproduce the magic. See the documentation below for workarounds. ]

To repeat with/for (loopvar - nonexisting K variable)
running/-- through/in (OS - description of values of kind K) with index (index - nonexisting number variable) begin -- end loop
  (documented at ph_runthrough):
(- {index} = 0; objectloop({loopvar} ofclass Object)
if ({-matches-description:loopvar:OS} && ++{index}) -).

Chapter List of values

To repeat with/for (loopvar - nonexisting K variable)
  running/-- through/in (L - list of values of kind K) begin -- end loop
  (documented at ph_repeatlist):
    (- {-primitive-definition:repeat-through-list} -).

Section list of values with index

To repeat with/for (loopvar - nonexisting K variable)
  running/-- through/in (L - list of values of kind K) with/using index (index - nonexisting number variable) begin -- end loop
  (documented at ph_repeatlist):
        (- {-my:1} = LIST_OF_TY_GetLength({L});
                for ({index} = 1 : {index} <= {-my:1} : {index}++ )
                if ({loopvar} = LIST_OF_TY_GetItem({L}, {index}))
-).

Section list of texts with index

To repeat with/for (loopvar - nonexisting text variable)
  running/-- through/in (L - list of texts) with/using index (index - nonexisting number variable) begin -- end loop:
        (- {-my:1} = LIST_OF_TY_GetLength({L}); ! texts
                for ({index} = 1 : {index} <= {-my:1} : {index}++ )
if (BlkValueCopy({-by-reference:loopvar}, LIST_OF_TY_GetItem({L}, {index})))
-).

Chapter Table

Section forward

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

Section forward with row number

To repeat running/-- through/in (T - table name) with row number (row_number - nonexisting number variable) begin -- end loop
  (documented at ph_repeattable): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=1, ct_0={-my:1}, ct_1={-my:2}, {row_number} = ct_1:
      {-my:2}<=TableRows({-my:1}):
      {-my:2}++, ct_0={-my:1}, ct_1={-my:2}, {row_number} = ct_1)
      if (TableRowIsBlank(ct_0, ct_1)==false)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section forward with row number and index

To repeat running/-- through/in (T - table name) with row number (row_number - nonexisting number variable) and index (index - nonexisting number variable) begin -- end loop
  (documented at ph_repeattable): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=1, ct_0={-my:1}, ct_1={-my:2}, {row_number} = ct_1, {index} = 1:
      {-my:2}<=TableRows({-my:1}):
      {-my:2}++, ct_0={-my:1}, ct_1={-my:2}, {row_number} = ct_1, {index}++)
      if (TableRowIsBlank(ct_0, ct_1)==false)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section reverse

To repeat running/-- through/in (T - table name) in/-- reverse/backwards order/-- begin -- end loop
  (documented at ph_repeattablereverse): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}:
      {-my:2}>=1:
      {-my:2}--, ct_0={-my:1}, ct_1={-my:2})
      if (TableRowIsBlank(ct_0, ct_1)==false)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section reverse with row number

To repeat running/-- through/in (T - table name) in/-- reverse/backwards order/-- with row number (row_number - nonexisting number variable) begin -- end loop
  (documented at ph_repeattablereverse): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1:
      {-my:2}>=1:
      {-my:2}--, ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1)
      if (TableRowIsBlank(ct_0, ct_1)==false)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section reverse with row number and index 

To repeat running/-- through/in (T - table name) in/-- reverse/backwards order/-- with row number (row_number - nonexisting number variable) and index (index - nonexisting number variable) begin -- end loop
  (documented at ph_repeattablereverse): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableRows({-my:1}), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1, {index} = 1:
      {-my:2}>=1:
      {-my:2}--, ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1, {index}++)
      if (TableRowIsBlank(ct_0, ct_1)==false)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section forward sorted by column

To repeat running/-- through/in (T - table name) sorted/-- in/by (TC - table column) order/-- begin -- end loop
  (documented at ph_repeattablecol): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}:
      {-my:2}~=0:
      {-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2})
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section forward sorted by column with row number

To repeat running/-- through/in (T - table name) sorted/-- in/by (TC - table column) order/-- with row number (row_number - nonexisting number variable) begin -- end loop
  (documented at ph_repeattablecol): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1:
      {-my:2}~=0:
      {-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2},{row_number}=ct_1)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section forward sorted by column with row number and index 

To repeat running/-- through/in (T - table name) sorted/-- in/by (TC - table column) order/-- with row number (row_number - nonexisting number variable) and index (index - nonexisting number variable) begin -- end loop
  (documented at ph_repeattablecol): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, 1), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1, {index} = 1:
      {-my:2}~=0:
      {-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, 1), ct_0={-my:1}, ct_1={-my:2},{row_number}=ct_1, {index}++)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section reverse sorted by column

To repeat running/-- through/in (T - table name) sorted/-- in/by reverse/backwards (TC - table column) order/-- begin -- end loop
  (documented at ph_repeattablecolreverse): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}:
      {-my:2}~=0:
      {-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2})
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section reverse sorted by column with row number

To repeat running/-- through/in (T - table name) sorted/-- in/by reverse/backwards (TC - table column) order/-- with row number (row_number - nonexisting number variable) begin -- end loop
  (documented at ph_repeattablecolreverse): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1:
      {-my:2}~=0:
      {-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Section reverse sorted by column with row number and index

To repeat running/-- through/in (T - table name) sorted/-- in/by reverse/backwards (TC - table column) order/-- with row number (row_number - nonexisting number variable) and index (index - nonexisting number variable) begin -- end loop
  (documented at ph_repeattablecolreverse): (-
    @push {-my:ct_0}; @push {-my:ct_1};
    for ({-my:1}={T}, {-my:2}=TableNextRow({-my:1}, {TC}, 0, -1), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1, {index} = 1:
      {-my:2}~=0:
      {-my:2}=TableNextRow({-my:1}, {TC}, {-my:2}, -1), ct_0={-my:1}, ct_1={-my:2}, {row_number}=ct_1, {index}++)
        {-block}
    @pull {-my:ct_1}; @pull {-my:ct_0};
  -).

Book Casting (For use without Central Typecasting by Zed Lopez)

To decide which K is the/a/an/-- (unknown - a value) cast as the/a/an/-- (name of kind of value K):
    (- {unknown} -).

Strange Loopiness ends here.

---- Documentation ----

This is experimental and mostly made out of the undocumented features in the Standard Rules the docs call on us not to use.

Adds while and until loops. Among other things, this makes it easy to loop indefinitely until a condition is met, which comes in handy sometimes. On the other hand, this makes it easy to loop indefinitely.

Inform 7's existing repeat statements make it hard to infinitely loop, which I'm guessing was a deliberate design decision. So be warned that these loops are powerful tools whose power is by default pointed at your foot: make sure your loop incrementally approaches its exit condition.

If you Include If True by Zed Lopez, then while and until will be able to take plain truth states instead of full conditionals.

Infinitely loop (your obligation to break out):

```
repeat while true:
```

Repeat down across a numeric range:

```
repeat with x running from 12 down to 2:
```

For all of the loops, you can also provide a loop index variable. Don't alter the loop index variable manually or it'll cease being a useful loop index variable.


Enumerated values in a specified range:

```
repeat with the-color running from red to blue with index i:
```

Descriptions of objects:

```
repeat with closed-thing running through closed things with index i:
```

Lists:

```
repeat with item running through L with index i:
```

Tables with row number:

```
repeat through Table of Regrets with row number row-id;
```

But when you're going through a table backwards or sorting by a column, the row number will typically be different from a count of iterations through the loop, so if you really want the latter, too:

```
repeat through Table of Regrets with row number row-id and index i;
```

(There isn't a provided option for just the index without the row number.)

The compiler does magic I can't reproduce to let the same phrase preamble work for descriptions of objects and descriptions of enumerated values. So the loop over a description of values with index case only works for objects. If you're working with enumerated values and you want the index, do your choice of the following:

```
[ if and only if you're working across the whole range: ]
repeat with the-color running through colors:
  let index be the-color cast as a number;
  [...]
```

or:

```
[ alternative for whole range: ]
repeat for the-color from the first value in colors to the last value in colors with index:
```

or:
```
[ other than whole range: ]
repeat for the-color from red to yellow with index i begin;

repeat for c in list of infragreen colors with index i begin;

let i be 0;
repeat for c in infragreen colors begin; [works because unfair ni magic ]
increment i;
```

Reserve this form for descriptions of objects:

```
repeat with drafty running through open containers with index i:
```

Be warned that if you do try using it with enumerated values, there *won't* be an error: the body of the loop won't be executed; it will just return immediately.


Also modifies existing syntax:

"repeat running through" and "repeat through" are interchangeable (i.e., "running" is permissible while looping through tables, and omitting it is permissible everywhere)

"for" may replace "with"

"in" may replace "from"

"in" may replace "through"

So all of the following are equivalent:

Repeat with i running from 1 to 10
Repeat with i from 1 to 10
Repeat for i in 1 to 10

And these are equivalent:

Repeat running through the Table of Regrets:
Repeat through the Table of Regrets:
Repeat in the Table of Regrets:

other examples:

repeat through the table of regrets backwards by decision-badness using row number row-id

Section Example: What's in the box? *

	*: "What's in the box?"

	The Lab is a room.
	   
	Box is a container in the Lab. There is a spam musubi in the box. An action figure is in the box.
	    
	when play begins:
	let item be the first thing held by box;
	repeat while item is not nothing begin;
	  say "[item].";
	  now item is the next thing held after item;      
	end repeat.      


Section Changelog

1/210930 Add separate case for repeat through list of text with index case, which had been failing. Any list of a block-valued kind other than text will still fail.

1/210928 Use I6-native do-until loop; prior implementation could break with multiple until loops
