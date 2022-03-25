Version 1 of List Utilities by Zed Lopez begins here.

"List utility functions"

Chapter empty imperative

To empty a/an/-- (L - a list of values of kind K):
  (- LIST_OF_TY_SetLength({-by-reference:L}, 0); -)

Part sorts

chapter random

[ with empty list, will result in:
*** Couldn't read from entry 1 of a list which is empty ***

*** Run-time problem P50: Attempt to use list item which does not exist.
]

To decide what K is a/-- random entry in/of/from the/a/an/-- (L - a list of values of kind K):
  decide on entry (a random number from 1 to the size of L) in L;

To decide what K is a/-- random entry in/of/from the/a/an/-- (L - a list of values of kind K) or (v - K):
    if L is empty, decide on v;
    decide on entry (a random number from 1 to the size of L) in L;

To decide what list of Ks is a/-- shuffled/randomized (L - a list of values of kind K):
  let M be L;
  sort M in random order;
  decide on M;

chapter sorts
[ modify LIST_OF_TY_Sort to return a value ]

Include (-
Global LIST_OF_TY_Sort_cf;

[ LIST_OF_TY_Sort list dir prop cf  i j no_items v;
	BlkMakeMutable(list);
	no_items = BlkValueRead(list, LIST_LENGTH_F);
	if (dir == 2) {
		if (no_items < 2) return list;
		for (i=1:i<no_items:i++) {
			j = random(i+1) - 1;
			v = BlkValueRead(list, LIST_ITEM_BASE+i);
			BlkValueWrite(list, LIST_ITEM_BASE+i, BlkValueRead(list, LIST_ITEM_BASE+j));
			BlkValueWrite(list, LIST_ITEM_BASE+j, v);
		}
		return;
	}
	SetSortDomain(ListSwapEntries, ListCompareEntries);
	if (cf) LIST_OF_TY_Sort_cf = BlkValueCompare;
	else LIST_OF_TY_Sort_cf = 0;
	SortArray(list, prop, dir, no_items, false, 0);
    return list;
];

[ ListSwapEntries list i j v;
	if (i==j) return;
	v = BlkValueRead(list, LIST_ITEM_BASE+i-1);
	BlkValueWrite(list, LIST_ITEM_BASE+i-1, BlkValueRead(list, LIST_ITEM_BASE+j-1));
	BlkValueWrite(list, LIST_ITEM_BASE+j-1, v);
];

[ ListCompareEntries list col i j d cf;
	if (i==j) return 0;
	i = BlkValueRead(list, LIST_ITEM_BASE+i-1);
	j = BlkValueRead(list, LIST_ITEM_BASE+j-1);
	if (I7S_Col) {
		if (i provides I7S_Col) i=i.I7S_Col; else i=0;
		if (j provides I7S_Col) j=j.I7S_Col; else j=0;
		cf = LIST_OF_TY_Sort_cf;
	} else {
		cf = LIST_OF_TY_ComparisonFn(list);
	}
	if (cf == 0) {
		if (i > j) return 1;
		if (i < j) return -1;
		return 0;
	} else
		return cf(i, j);
];

-) instead of "Sorting" in "Lists.i6t".



To decide what list of Ks is a/-- sorted (L - a list of values of kind K):
    (- LIST_OF_TY_Sort({L}, 1) -).

To decide what list of Ks is a/-- sorted (L - a list of values of kind K) in/-- descending/backwards/reverse order/--:
    (- LIST_OF_TY_Sort({L}, -1) -).

chapter reverse

To decide what list of Ks is a/-- reverse of/-- (L - a list of values of kind K):
    (- LIST_OF_TY_Reverse({L},1) -). [ {L} instead of {-lvalue-by-reference:L} ]

Part more flexible prepositions in standard phrases

To remove entry (N - number) in/of/from (L - list of values), if present:
(- LIST_OF_TY_RemoveItemRange({-lvalue-by-reference:L}, {N}, {N}, {phrase options}); -).

To add (LX - list of Ks) at entry (E - number) in/of/to (L - list of values of kind K):
  (- LIST_OF_TY_AppendList({-lvalue-by-reference:L}, {-by-reference:LX}, 1, {E}, 0); -).

To add (new entry - K) at entry (E - number) in/of/to (L - list of values of kind K), if absent:
  (- LIST_OF_TY_InsertItem({-lvalue-by-reference:L}, {new entry}, 1, {E}, {phrase options}); -).

Part stack

Chapter pop

Section pop returning value

Include (-
[ ListPop L kind x last;
last = BlkValueRead(L, LIST_LENGTH_F);
x = LIST_OF_TY_GetItem(L, last);
LIST_OF_TY_RemoveItemRange(L, last, last);
return x;
];
-).

To decide what K is pop of/-- (L - a list of values of kind K):
    (- ListPop({-by-reference:L},{-strong-kind:K}) -).

To decide what K is pop of/-- (L - a list of values of kind K) or (backup - a K):
  if L is empty, decide on backup;
  decide on pop L;

Section pop ignoring value

To pop (L - a list of values of kind K): (- ListPop({-lvalue-by-reference:L}); -).

Chapter push

To push (n - a K) on (L - a list of values of kind K): (- LIST_OF_TY_InsertItem({-lvalue-by-reference:L}, {n}, 0, 0, 0); -).

Part queue

Chapter shift

Section shift returning value

Include (-
[ ListShift L kind x last;
last = BlkValueRead(L, LIST_LENGTH_F);
x = LIST_OF_TY_GetItem(L, 1);
LIST_OF_TY_RemoveItemRange(L, 1, 1);
return x;
];
-).

[if empty, results in:
To decide what K is pop of/-- (L - a list of values of kind K)

*** Couldn't read from entry 1 of a list which is empty ***

*** Run-time problem P50: Attempt to use list item which does not exist.

*** Couldn't remove entries 1 to 1 from the list {}, which has entries in the range 1 to 0 ***
]

To decide what K is shift of/-- (L - a list of values of kind K): (- ListShift({-by-reference:L},{-new:K}) -).

To decide what K is shift of/-- (L - a list of values of kind K) or (backup - a K):
  if L is empty, decide on backup;
  decide on shift L;


Section shift ignoring value

To shift (L - a list of values of kind K): (- ListShift({-by-reference:L}); -).

Chapter Unshift

To unshift (n - a K) on/from (L - a list of values of kind K): (- LIST_OF_TY_InsertItem({-by-reference:L}, {n}, 1 ,1, 0); -).

Book slice

Part slice forward

Chapter slice specified range

To decide what list of K is entries (M - a number) to (N - a number) in/of (L - a list of values of kind K):
    let result be a list of K;
    repeat for i in M to N begin;
      add (entry i in L) to result;
    end repeat;
    if L is empty, decide on L;
    decide on result.

Chapter slice through end

To decide what list of K is entries (M - a number) to end/finish/last of (L - a list of values of kind K):
  decide on entries M to (last index of L) of L.

Part last index/entry

Chapter last index

To decide what number is a/-- last index in/of a/an/-- (L - a list of values of kind K):
    decide on the size of L.

Chapter last entry

To decide what K is a/-- last entry in/of the/a/an/-- (l - a list of values of kind K):
  let x be the number of entries in l;
  if x is zero, decide on null K;
  decide on entry x in l.

Chapter combo

To decide if (L - a list of values of kind K) is a/-- combination of/-- (M - a list of Ks):
  if the size of L is not the size of M, no;
  if sorted L is sorted M, yes;
  no.

Part set functions

To decide which list of values of kind K is a/-- unique (l - a list of values of kind K):
    let r be a list of K;
    repeat with x running through l begin;
      add x to r, if absent;
    end repeat;
    decide on r. 

To decide which list of values of kind K is a/-- intersection of (l - a list of values of kind K) and (m - a list of Ks):
    let r be unique l;
    repeat with i running through l begin;
      if i is not listed in m and i is listed in r, remove i from r;
      end repeat;
      decide on r.

To decide which list of values of kind K is a/-- sum of (l - a list of values of kind K) and (m - a list of values of kind M):
    let r be l;
    add m to r;
    decide on r.

To decide which list of values of kind K is a/-- union of (l - a list of values of kind K) and (m - a list of values of kind M):
    decide on the unique sum of l and m.

To decide if (l - a list of values) intersects (m - a list of values):
    if the intersection of l and m is empty, decide no;
    decide yes.

To decide if (l - a list of values) is disjoint from (m - a list of values):
    if the intersection of l and m is empty, decide yes;
    decide no.

To decide what number is a/-- size of (l - a list of values):
    decide on the number of entries in l.

To decide what number is a/-- left/-- index of a/an/-- (x - a value) in a/an/-- (l - a list of values of kind K):
  repeat with i running from 1 to the size of l begin;
    if x is entry i in l, decide on i;
  end repeat;
  decide on 0.

To decide what number is a/-- right index of (x - a value) in (l - a list of values):
  repeat with i running from 1 to size of l begin;
    let idx be 1 + size of l - i;
    if x is entry idx in l, decide on idx;
  end repeat;
  decide on 0.

To decide what number is zentry (n - a number) of/in (L - a list of values of kind K):
  let len be the last index of L;
  if n >= 0 and n < len, decide on entry (n + 1) of L;
  if n < 0 and (0 - n) <= len, decide on entry (len + 1 + n) of L;
  decide on null K;

Include (-
[ listExtreme L k cmp_target cmp i last val result cmp_result;
  if (k) { cmp = KOVComparisonFunction(k);  }
  if (k == NUMBER_TY) cmp = utSignedCompare;
last = BlkValueRead(L, LIST_LENGTH_F);
result = LIST_OF_TY_GetItem(L, 1);
for ( i = 2; i <= last; i++ ) {
  val = LIST_OF_TY_GetItem(L, i);
  cmp_result = cmp(val, result);
  if ((cmp_target == 1) && (cmp_result > 0)) result = val;
  else if ((cmp_target == -1) && (cmp_result < 0)) result = val;
}
return result;
];
-)

To decide what K is max/maximum of/-- (L - a list of values of kind K):
  (- listExtreme({L},{-strong-kind:K},1) -)

To decide what K is min/minimum of/-- (L - a list of values of kind K):
  (- listExtreme({L},{-strong-kind:K},-1) -)

Book Central Typecasting-dependent (for use with Central Typecasting by Zed Lopez)

Part ordinalth entry

To decide what K is a/-- (O - an ordinal) entry in/of the/a/an/-- (l - a list of values of kind K):
    decide on entry (O cast as a number) in l.

Volume Descent (for use without Strange Loopiness by Zed Lopez)

To repeat with/for the/a/an/-- (loopvar - nonexisting K variable) running/-- from/in (v - value of kind K) down to (w - K) begin -- end loop:
      (- for ({loopvar}={v}: {loopvar}>={w}: {loopvar}-- ) -).

To repeat with/for the/a/an/-- (loopvar - nonexisting K variable)
  running/-- from/in (v - value of kind K) to (w - K) begin -- end loop
  (documented at ph_repeat):
    (- for ({loopvar}={v}: {loopvar}<={w}: {loopvar}++ ) -).

Volume Central (for use without Central Typecasting by Zed Lopez)

To decide what K is a/-- null (name of kind of value K): (- nothing -)

Volume compare (for use without Unit Tests by Zed Lopez)

Include (-
[ utSignedCompare x y;
if (x > y) return 1;
if (x < y) return -1;
return 0;
];
-);

List Utilities ends here.

---- Documentation ----

Chapter Examples

Example: ** List tests

	*: "List tests"
	
	Include List Utilities by Zed Lopez.
	Include Unit Tests by Zed Lopez.
	Include Text Capture by Eric Eve.
	
	Use test automatically.
	
	Lab is a room.
	
	emptying is a unit test. "Emptying".
	
	empty-l is a list of numbers that varies.
	empty-l is usually {}.
	ref is always { 0, 1, 2 }.
	rev-ref is always { 2, 1, 0 }.
	lol is always { { 0, 1, 2 }, { 0, 2, 1 }, { 1, 0, 2 }, { 1, 2, 0 }, { 2, 0, 1 }, { 2, 1, 0 } }.
	list9 is always { 1, 2, 3, 4, 5, 6, 7, 8, 9 }.
	loneliest is always { 1 }.
	teens is always { 13, 14, 15, 16, 17, 18, 19 }.
	
	For testing emptying:
	    let L be a list of numbers;
	    empty L;
	    for "emptying an empty list" assert L is empty; 
	    let L2 be { 1, 2, 3 };
	    empty L2;
	    for "emptying a non-empty list" assert the number of entries in L2 is 0;
	
	Random entry is a unit test. "Random entry"
	
	For testing random entry:
	  let z be a random entry from empty-l;
	  for "random entry from empty list" assert z is 0;
	  let err be ut-test-output;
	  for "random entry from empty list error" assert previous reported error; [err rmatches "^\*\*";]
	  let z2 be a random entry from empty-l or improbable number;
	  for "random entry from empty list or backup" assert z2 is improbable number;
	  let count be { 0, 0, 0 };
	  repeat with i running from 1 to 300 begin;
	    let x be a random entry in ref;
	    increment entry (x + 1) in count;
	  end repeat;
	  let label be "monte carlo [count]";
	  repeat with i running through ref begin;
	    let j be i + 1;
	    if entry j in count < 50 or entry j in count > 200 begin;
	      for label fail;
	      rule fails;
	    end if;
	  end repeat;
	  for label pass;
	
	Shuffle is a unit test. "Returning shuffled list".
	
	For testing shuffle:
	  let empty-shuffling be shuffled empty-l;
	  for "empty list shuffled" assert empty-shuffling is empty;
	  let count be a list of numbers;
	  let indices be { 6, 8, 12, 16, 20, 22 }; [ the trinary values of combinations of 0, 1, 2 ]
	  extend count to 22 entries;
	  let result be a list of numbers;
	  let orig be { 0, 1, 2};
	  repeat with i running from 1 to 300 begin;
	    let M be shuffled ref;
	    let val be 1 + (entry 1 of M) + ((entry 2 of M) * 3) + ((entry 3 of M) * 9); [ convert to a trinary val ]
	    now entry val of count is (entry val of count) + 1;
	  end repeat;
	  repeat with i running through indices begin;
	    add entry i of count to result;
	  end repeat;
	  for "Original unchanged" assert orig is {0, 1, 2};
	  let label be "Shuffle [result]";
	  [ the mean is 42.66 ] 
	  repeat with i running through result begin;
	    if i < 22 or i > 86 begin;
	      for label fail;
	      rule fails;
	    end if;
	  end repeat;
	  for label pass;  
	
	Sort is a unit test.
	
	For testing sort:
	  let empty-sorted be sorted empty-l;
	  for "empty list sorted" assert empty-sorted is empty;
	  for "empty list sorted backwards" assert sorted empty-l backwards is empty;
	  repeat with l running through lol begin;
	    let orig be l;
	    for "sort [l]" assert sorted l is ref;
	    unless l is orig, for "sort [l] original changed" fail;
	    for "sort [l] backwards" assert sorted l backwards is rev-ref;
	  end repeat;
	
	Reverse is a unit test. "Returning reversed list".
	
	For testing reverse:
	  let empty-reverse be reverse empty-l;
	  for "empty list reverse" assert empty-reverse is empty;
	  repeat with l running through lol begin;
	    let orig be l;
	    let r be reverse l;
	    let len be number of entries in l;
	    repeat with i running from 1 to len begin;
	      unless entry i of r is entry (len + 1 - i) of l begin;
	        for "sort [r] backwards" fail;
	        rule fails;
	      end unless;
	    end repeat;
	  end repeat;
	  for "sort backwards" pass;  
	
	Pop value is a unit test. "Pop value".
	
	to decide if previous reported error:
	  decide on whether or not ut-test-output rmatches "^\*\*";
	
	For testing pop value:
	  let l1 be ref;
	  let p be pop l1;
	  for "popped value { 0, 1, 2 }, got 2" assert p is 2;
	  for "popped value { 0, 1, 2 }, length of list" assert number of entries in l1 is 2;
	  for "popped value { 0, 1, 2 }, first entry 0" assert entry 1 of l1 is 0;
	  for "popped value { 0, 1, 2 }, second entry 1" assert entry 2 of l1 is 1;
	  for "popped non-empty with backup" assert pop l1 or improbable number is 1;
	  let l2 be a list of numbers;
	  for "popped value empty list" assert pop l2 is 0;
	  for "popped value empty list error" assert previous reported error;
	  let l3 be teens;
	  for "popped value non-empty with backup" assert pop l3 or improbable number is 19;
	  let l4 be a list of numbers;
	  for "popped value empty with backup" assert pop l4 or improbable number is improbable number;
	  
	Pop discarding is a unit test. "Pop, discarding value".
	
	For testing pop discarding:
	  let l1 be ref;
	  pop l1;
	  for "popped { 0, 1, 2 }, length of list" assert number of entries in l1 is 2;
	  for "popped { 0, 1, 2 }, first entry" assert entry 1 of l1 is 0;
	  for "popped { 0, 1, 2 }, second entry" assert entry 2 of l1 is 1;
	  let l2 be a list of numbers;
	  pop l2;
	  for "check pop empty list error" pass;
	  for "popped empty list error" assert previous reported error;
	  for "popped empty list" assert l2 is empty;
	
	Push is a unit test. "Push".
	  
	For testing push:
	  let l1 be ref;
	  push 5 on l1;
	  for "pushed 5 on { 0, 1, 2 }, length of list" assert number of entries in l1 is 4;
	  for "pushed 5 on { 0, 1, 2 }, first entry" assert entry 1 of l1 is 0;
	  for "pushed 5 on { 0, 1, 2 }, third entry" assert entry 3 of l1 is 2;
	  for "pushed 5 on { 0, 1, 2 }, fourth entry" assert entry 4 of l1 is 5;
	  let l2 be a list of numbers;
	  push 7 on l2;
	  for "push 7 on {}, length of list" assert number of entries in l2 is 1;
	  for "push 7 on {}, sole entry" assert entry 1 of l2 is 7;
	
	Shift value is a unit test. "Shift value".
	
	For testing shift value:
	  let l1 be ref;
	  let l2 be l1;
	  let p be shift l2;
	  for "shift value { 0, 1, 2 }, got 0" assert p is 0;
	  for "shift value { 0, 1, 2 }, length of list" assert number of entries in l2 is 2;
	  for "shift value { 0, 1, 2 }, first entry" assert entry 1 of l2 is 1;
	  for "shift value { 0, 1, 2 }, second entry" assert entry 2 of l2 is 2;
	  for "shift value, original unchanged" assert l1 is ref;
	  let l2 be teens;
	  for "shifted non-empty with backup" assert (shift l2 or improbable number) is 13;
	  let L be a list of numbers;
	  for "shift value, empty list" assert shift L is 0;
	  for "shift value, empty error message" assert previous reported error;
	
	  
	Shift discarding is a unit test. "Shift, discarding value".
	
	For testing shift discarding:
	  let l1 be ref;
	  shift l1;
	  for "shifted { 0, 1, 2 }, length of list" assert number of entries in l1 is 2;
	  for "shifted { 0, 1, 2 }, first entry" assert entry 1 of l1 is 1;
	  for "shifted { 0, 1, 2 }, second entry" assert entry 2 of l1 is 2;
	  let l2 be a list of numbers;
	  shift l2;
	  for "shifted empty list" assert l2 is empty; [TODO fails]
	
	Unshift is a unit test. "Unshift".
	  
	For testing unshift:
	  let l1 be ref;
	  unshift 5 on l1;
	  for "unshifted 5 on { 0, 1, 2 }, length of list" assert number of entries in l1 is 4;
	  for "unshifted 5 on { 0, 1, 2 }, first entry" assert entry 1 of l1 is 5;
	  for "unshifted 5 on { 0, 1, 2 }, third entry" assert entry 3 of l1 is 1;
	  for "unshifted 5 on { 0, 1, 2 }, fourth entry" assert entry 4 of l1 is 2;
	  let l2 be a list of numbers;
	  unshift 7 on l2;
	  for "unshift 7 on {}, length of list" assert number of entries in l2 is 1;
	  for "unshift 7 on {}, sole entry" assert entry 1 of l2 is 7;
	
	Last index is a unit test. "Last index."
	
	For testing last index:
	  for "empty" assert last index of empty-L is 0;
	  for "last of 9" assert last index of list9 is 9;
	  for "singleton" assert last index of loneliest is 1;
	
	Last entry is a unit test. "Last entry."
	
	For testing last entry:
	  for "empty" assert last entry of empty-l is 0;
	  for "last of 9" assert last entry of list9 is 9;
	  for "singleton" assert last entry of loneliest is 1;
	  for "rev-ref" assert last entry of rev-ref is 0;
	
	Combo is a unit test. "Combination".
	
	For testing combo:
	  for "empty and list9" refute empty-l is a combination of list9;
	  for "list9 and empty" refute list9 is a combination of empty-l;
	  for "ref and rev-ref" assert rev-ref is a combination of ref;
	  for "shuffled list9s" assert shuffled list9 is a combination of shuffled list9; 
	
	
	[Backwards slice is a unit test. "Backwards slice".
	
	For testing backwards slice:
	  for "empty" assert entries 99 to -3 of empty-l is empty;
	  for "end out of range" assert entries 15 down to 8 of list9 is { 9, 8 };
	  for "ref" assert entries 3 down to 1 of ref is rev-ref;
	  for "start out of range" assert entries 4 down to 0 of list9 is { 4, 3, 2, 1 };
	  for "both out of range" assert entries 15 down to -3 of loneliest is {1};]
	  
	Uniquity is a unit test. "Uniquity".
	
	For testing uniquity:
	  for "empty" assert unique empty-l is empty;
	  for "ref" assert sorted unique rev-ref is ref;
	  let duplicative be a list of numbers;
	  repeat for i in 1 to 3 begin;
	    let L be shuffled list9;
	    repeat with j running through L begin;
	      add j to duplicative;
	    end repeat;
	  end repeat;
	  for "duplicative" assert sorted unique duplicative is list9;
	  
	Intersection is a unit test. "Intersection".
	
	For testing intersection:
	  for "empty 0" assert intersection of empty-l and empty-l is empty;
	  for "empty 1" assert intersection of empty-l and list9 is empty;
	  for "empty 2" assert intersection of empty-l and loneliest is empty;
	  for "empty 3" assert intersection of loneliest and empty-l is empty;
	  for "ref and loneliest" assert intersection of ref and loneliest is { 1 };
	  for "loneliest and ref" assert intersection of loneliest and ref is { 1 };
	  for "rev-ref and loneliest" assert intersection of rev-ref and loneliest is { 1 };
	  for "list9 and loneliest" assert intersection of list9 and loneliest is { 1 };
	  for "list9 and ref" assert intersection of list9 and ref is { 1, 2 };
	  let lista be shuffled list9;
	  let listb be shuffled list9;
	  let listc be sorted intersection of lista and listb;
	  for "shuffled" assert listc is list9;
	  for "identical" assert intersection of list9 and list9 is list9;
	
	Sums is a unit test. "Sums".
	
	For testing sums:
	  for "empty and ref" assert sum of empty-l and ref is ref;
	  for "rev-ref and empty" assert sum of rev-ref and empty-l is rev-ref;
	  for "empty and empty" assert sum of empty-l and empty-l is empty;
	  for "rev-ref and ref" assert sum of rev-ref and ref is { 2, 1, 0, 0, 1, 2 };
	  for "list9 and list9 length" assert size of sum of list9 and list9 is 18;
	
	Union is a unit test. "Union".
	
	For testing union:
	  for "ref and rev-ref" assert sorted union of ref and rev-ref is ref;
	  for "list9 and ref" assert sorted union of list9 and ref is { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
	  for "empty and empty" assert union of empty-l and empty-l is empty;
	  for "empty and ref" assert union of empty-l and ref is ref;
	  for "loneliest and teens" assert union of loneliest and teens is { 1, 13, 14, 15, 16, 17, 18, 19 };  
	  
	Intersects is a unit test. "if intersects".
	
	For testing intersects:
	  for "2 empty lists" refute empty-l intersects empty-l;
	  for "empty lists and ref" refute empty-l intersects ref;
	  for "teens and list9" refute teens intersects list9;
	
	Disjoint from is a unit test. "if is disjoint from".
	
	For testing disjoint from:
	  for "2 empty lists" assert empty-l is disjoint from empty-l;
	  for "empty lists and ref" assert empty-l is disjoint from ref;
	  for "teens and list9" assert teens is disjoint from list9;
	
	
	Slice nice is a unit test. "Slice".
	
	For testing slice:
	  for "empty" assert entries 3 to 4 of empty-l is empty;
	  for "empty error" assert previous reported error;
	  for "plain" assert entries 2 to 3 of list9 is { 2, 3 };
	  for "singleton bottom" assert entries 1 to 1 of list9 is { 1 };
	  for "singleton top" assert entries 9 to 9 of list9 is { 9 };
	  let test-l be list9;
	  for "middle slice" assert entries 3 to 7 of test-l is { 3, 4, 5, 6, 7 };
	  for "original unchanged" assert test-l is list9;
	  for "start slice" assert entries 1 to 3 of test-l is { 1, 2, 3 };
	  for "end slice" assert entries 6 to 9 of test-l is { 6, 7, 8, 9 };
	  for "single slice" assert entries 9 to 9 of test-l is { 9 };
	  for "singleton" assert entries 1 to 1 of loneliest is { 1 };
	
	End slice is a unit test. "Slice through end"
	
	For testing end slice:
	  for "7 of 9" assert entries 7 to last of list9 is { 7, 8, 9 };
	  for "singleton" assert entries 1 to last of loneliest is { 1 };
	  for "empty" assert entries 1 to 15 of empty-l is empty;
	
	Left index is a unit test. "Left index".
	
	For testing left index:
	  for "empty-l" assert left index of 5 in empty-l is 0;  
	  for "empty-l" assert left index of 0 in empty-l is 0;
	  for "ref" assert left index of 1 in ref is 2;
	  for "teens" assert left index of 15 in teens is 3;
	  let l1 be the sum of ref and list9;
	  for "sum of ref and list9" assert left index of 1 in l1 is 2;
	
	Rindex is a unit test. "Scooby-doo saying 'windex'".
	
	For testing rindex:
	  for "empty-l" assert right index of 5 in empty-l is 0;  
	  for "empty-l" assert right index of 0 in empty-l is 0;
	  for "rindex 1 in ref" assert right index of 1 in ref is 2;
	  for "rindex 15 in teens" assert right index of 15 in teens is 3;
	  let l1 be the sum of ref and list9;
	  for "rindex 8 in sum of ref and list9" assert right index of 8 in l1 is 11;
	  for "rindex 1 in sum of ref and list9" assert right index of 1 in l1 is 4;
	
	Zentry is a unit test. "Zentry".
	
	For testing zentry:
	  for "empty-l" assert zentry 0 in empty-l is 0;
	  for "ref 0" assert zentry 0 in ref is 0; 
	  for "rev-ref -1" assert zentry -1 in rev-ref is 0;
	  for "rev-ref 0th" assert zentry 0 in rev-ref is 2;
	  for "teens 2" assert zentry 2 in teens is 15;
	  for "teens -2" assert zentry -2 in teens is 18;
	
	Minmax is a unit test. "Min/max".
	
	For testing minmax:
	  for "min ref" assert min of ref is 0;
	  for "max ref" assert max of ref is 2;
	  for "min teens" assert min of teens is 13;
	  for "max teens" assert max of teens is 19;
	  let L be the shuffled sum of ref and teens;
	  for "min L" assert min of ref is 0;
	  for "max L" assert max of teens is 19;
