Version 1/220311 of Custom Block Value Kinds (for Glulx only) by Dannii Willis begins here.

"Provides support for some custom block value kinds"



Volume - Template changes

[ The handling of short blocks doesn't actually do as it says it does, so we need to add support for our own short block bitmaps. ]

Include (-
Constant BLK_BVBITMAP_CUSTOM_BV = $80;
Constant BLK_BVBITMAP_OPTION = $81;
Constant BLK_BVBITMAP_COUPLE = $82;

[ BlkValueWeakKind bv o;
	if (bv) {
		o = bv-->0;
		if (o == 0) return bv-->(BLK_HEADER_KOV+1);
		if (o & BLK_BVBITMAP == o) {
			if (o & BLK_BVBITMAP_CUSTOM_BV) {
				switch (o) {
					BLK_BVBITMAP_OPTION: return OPTION_TY;
					BLK_BVBITMAP_COUPLE: return COUPLE_TY;
				}
				return 0;
			}
			if (o & BLK_BVBITMAP_TEXT) return TEXT_TY;
			o = bv-->1;
		}
		return o-->BLK_HEADER_KOV;
	}
	return NIL_TY;
];
-) instead of "Weak Kind" in "BlockValues.i6t".



Volume - Options

[ Options are three word short block values.
The first word is the short block header, $81.
The second word stores the kind, but also whether the option contains a value - if the top bit is 1 then there is a value.
The third word stores the value. ]

Include (-
Constant OPTION_IS_SOME = $80000000;
Constant OPTION_SOME_MASK = $7FFFFFFF;

[ OPTION_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return OPTION_TY_Compare(arg1, arg2);
		COPY_KOVS: OPTION_TY_Copy(arg1, arg2);
		CREATE_KOVS: return OPTION_TY_Create(arg1, arg2);
		DESTROY_KOVS: OPTION_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ OPTION_TY_Compare opt1 opt2	cf delta opt1kov;
	opt1kov = opt1-->1;
	! First check if one is some and the other is none
	delta = (((opt2-->1) & OPTION_IS_SOME) == 0) - ((opt1kov & OPTION_IS_SOME) == 0);
	if (delta) {
		return delta;
	}
	! If both are none, return 0
	if (opt1kov & OPTION_IS_SOME == 0) {
		return 0;
	}
	! Then compare the contents
	cf = KOVComparisonFunction(opt1kov & OPTION_SOME_MASK);
	if (cf == 0 or UnsignedCompare) {
		delta = opt1-->2 - opt2-->2;
	}
	else {
		delta = cf(opt1-->2, opt2-->2);
	}
	if (delta) {
		return delta;
	}
	return 0;
];

[ OPTION_TY_Copy to from	tokov;
	tokov = to-->1;
	if ((tokov & OPTION_IS_SOME) && KOVIsBlockValue(tokov & OPTION_SOME_MASK)) {
		BlkValueFree(to-->2);
	}
	tokov = tokov | ((from-->1) & OPTION_IS_SOME);
	to-->1 = tokov;
	if (tokov & OPTION_IS_SOME) {
		to-->2 = from-->2;
	}
	else {
		to-->2 = 0;
	}
];

[ OPTION_TY_Create skov short_block;
	if (short_block == 0) {
		short_block = FlexAllocate(3 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_OPTION;
	short_block-->1 = KindBaseTerm(skov, 0);
	short_block-->2 = 0;
	return short_block;
];

[ OPTION_TY_Destroy short_block	kov;
	kov = short_block-->1;
	if ((kov & OPTION_IS_SOME) && KOVIsBlockValue(kov & OPTION_SOME_MASK)) {
		BlkValueFree(short_block-->2);
	}
];

[ OPTION_TY_Distinguish opt1 opt2;
	if (OPTION_TY_Compare(opt1, opt2) == 0) rfalse;
	rtrue;
];

[ OPTION_TY_Say short_block	kov;
	kov = short_block-->1;
	if ((kov & OPTION_IS_SOME)) {
		print "Some(";
		PrintKindValuePair(kov & OPTION_SOME_MASK, short_block-->2);
		print ")";
	}
	else {
		print "None";
	}
];

[ OPTION_TY_Set short_block some value	kov;
	kov = short_block-->1;
	if ((kov & OPTION_IS_SOME) && KOVIsBlockValue(kov & OPTION_SOME_MASK)) {
		BlkValueFree(short_block-->2);
	}
	if (some) {
		short_block-->1 = kov | OPTION_IS_SOME;
		short_block-->2 = value;
	}
	else {
		short_block-->1 = kov & OPTION_SOME_MASK;
		short_block-->2 = 0;
	}
	return short_block;
];
-).

To decide what K option is (V - value of kind K) as an option:
	(- OPTION_TY_Set({-new:K option}, 1, {V}) -).

To set (O - value of kind K option) to none:
	(- OPTION_TY_Set({-by-reference:O}); -).

To set (O - value of kind K option) to (V - K):
	(- OPTION_TY_Set({-by-reference:O}, 1, {V}); -).

To decide if (O - a value option) is none:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME == 0) -).

To decide if (O - a value option) is some:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME) -).

To decide what K is value of (O - value of kind K option):
	(- ({-by-reference:O}-->2) -).



Volume - Couples

[ We can't have variable length tuples, and also TUPLE is already an I7 kind, though it isn't useable.
It doesn't seem possible to make a triple - Inform seems to trip over kinds generic over three other kinds. ]

[ Couples are five word short block values.
The first word is the short block header, $82.
The 2nd-3rd words store the types of the values.
The 4th-5th words store the values. ]

Include (-
[ COUPLE_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return COUPLE_TY_Compare(arg1, arg2);
		COPY_KOVS: COUPLE_TY_Copy(arg1, arg2);
		CREATE_KOVS: return COUPLE_TY_Create(arg1, arg2);
		DESTROY_KOVS: COUPLE_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ COUPLE_TY_Compare c1 c2	cf delta;
	! Compare the first values
	cf = KOVComparisonFunction(c1-->1);
	if (cf == 0 or UnsignedCompare) {
		delta = c1-->3 - c2-->3;
	}
	else {
		delta = cf(c1-->3, c2-->3);
	}
	if (delta) {
		return delta;
	}
	! Compare the second values
	cf = KOVComparisonFunction(c1-->2);
	if (cf == 0 or UnsignedCompare) {
		delta = c1-->4 - c2-->4;
	}
	else {
		delta = cf(c1-->4, c2-->4);
	}
	if (delta) {
		return delta;
	}
	return 0;
];

[ COUPLE_TY_Copy to from;
	to-->1 = from-->1;
	to-->2 = from-->2;
	to-->3 = from-->3;
	to-->4 = from-->4;
];

[ COUPLE_TY_Create skov short_block;
	if (short_block == 0) {
		short_block = FlexAllocate(5 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_COUPLE;
	short_block-->1 = KindBaseTerm(skov, 0);
	short_block-->2= KindBaseTerm(skov, 1);
	short_block-->3 = 0;
	short_block-->4 = 0;
	return short_block;
];

[ COUPLE_TY_Destroy short_block;
	if (KOVIsBlockValue(short_block-->1)) {
		BlkValueFree(short_block-->3);
	}
	if (KOVIsBlockValue(short_block-->2)) {
		BlkValueFree(short_block-->4);
	}
];

[ COUPLE_TY_Distinguish c1 c2;
	if (COUPLE_TY_Compare(c1, c2) == 0) rfalse;
	rtrue;
];

[ COUPLE_TY_Say short_block	kov;
	print "(";
	PrintKindValuePair(short_block-->1, short_block-->3);
	print ", ";
	PrintKindValuePair(short_block-->2, short_block-->4);
	print ")";
];

[ COUPLE_TY_Set short_block value1 value2;
	short_block-->3 = value1;
	short_block-->4 = value2;
	return short_block;
];
-).

To decide what couple of K and L is (V1 - value of kind K) and (V2 - value of kind L) as a couple:
	(- COUPLE_TY_Set({-new:couple of K and L}, {V1}, {V2}) -).

To decide what K is first value of (C - couple of value of kind K and value of kind L):
	(- {C}-->3 -).

To decide what L is second value of (C - couple of value of kind K and value of kind L):
	(- {C}-->4 -).



Custom Block Value Kinds ends here.