Version 1/220310 of Custom Block Value Kinds (for Glulx only) by Dannii Willis begins here.

"Provides support for some custom block value kinds"



Volume - Template changes

[ The handling of short blocks doesn't actually do as it says it does, so we need to add support for our own short block bitmaps. ]

Include (-
Constant BLK_BVBITMAP_CUSTOM_BV = $80;
Constant BLK_BVBITMAP_OPTION = $81;

[ BlkValueWeakKind bv o;
	if (bv) {
		o = bv-->0;
		if (o == 0) return bv-->(BLK_HEADER_KOV+1);
		if (o & BLK_BVBITMAP == o) {
			if (o & BLK_BVBITMAP_TEXT) return TEXT_TY;
			if (o & BLK_BVBITMAP_CUSTOM_BV) {
				if (o == BLK_BVBITMAP_OPTION) return OPTION_TY;
				return 0;
			}
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
		CREATE_KOVS: return OPTION_TY_Create(arg1, arg2);
		DESTROY_KOVS: OPTION_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
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

[ OPTION_TY_Destroy short_block kov;
	kov = short_block-->1;
	if ((kov & OPTION_IS_SOME) && KOVIsBlockValue(kov & OPTION_SOME_MASK)) {
		BlkValueFree(short_block-->2);
	}
];
-).

To decide if (O - a value option) is none:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME == 0) -).

To decide if (O - a value option) is some:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME) -).



Custom Block Value Kinds ends here.