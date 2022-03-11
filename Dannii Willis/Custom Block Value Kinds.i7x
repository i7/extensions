Version 1/220311 of Custom Block Value Kinds (for Glulx only) by Dannii Willis begins here.

"Provides support for some custom block value kinds"



Volume - Template changes

[ The handling of short blocks doesn't actually do as it says it does, so we need to add support for our own short block bitmaps. ]

Include (-
Constant BLK_BVBITMAP_CUSTOM_BV = $80;
Constant BLK_BVBITMAP_OPTION = $81;
Constant BLK_BVBITMAP_COUPLE = $82;
Constant BLK_BVBITMAP_CRATE = $83;
Constant BLK_BVBITMAP_RESULT = $84;

[ BlkValueWeakKind bv o;
	if (bv) {
		o = bv-->0;
		if (o == 0) return bv-->(BLK_HEADER_KOV+1);
		if (o & BLK_BVBITMAP == o) {
			if (o & BLK_BVBITMAP_CUSTOM_BV) {
				switch (o) {
					BLK_BVBITMAP_OPTION: return OPTION_TY;
					BLK_BVBITMAP_COUPLE: return COUPLE_TY;
					BLK_BVBITMAP_CRATE: return CRATE_TY;
					BLK_BVBITMAP_RESULT: return RESULT_TY;
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

Include (- -) instead of "Stubs For Custom Block Value Kinds" in "Figures.i6t".



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
	return delta;
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
	(- {-by-reference:C}-->3 -).

To decide what L is second value of (C - couple of value of kind K and value of kind L):
	(- {-by-reference:C}-->4 -).



Volume - Crates

[ Crates are three word short block values.
The 1st word is the short block header, $83.
The 2nd word store the type of the value - but as a printing function address.
The 3rd word store the value. ]

Include (-
[ CRATE_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return CRATE_TY_Compare(arg1, arg2);
		COPY_KOVS: CRATE_TY_Copy(arg1, arg2);
		CREATE_KOVS: return CRATE_TY_Create(arg1, arg2);
		DESTROY_KOVS: CRATE_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ CRATE_TY_Compare c1 c2	cf delta c1kov;
	c1kov = c1-->1;
	! Compare the kinds
	delta = c1kov - c2-->1;
	if (delta) {
		return delta;
	}
	! Then compare the contents
	cf = CBVK_PrintingFunc_To_Comp_Func(c1kov);
	if (cf == 0 or UnsignedCompare) {
		delta = c1-->2 - c2-->2;
	}
	else {
		delta = cf(c1-->2, c2-->2);
	}
	return delta;
];

[ CRATE_TY_Copy to from;
	to-->1 = from-->1;
	to-->2 = from-->2;
];

[ CRATE_TY_Create skov short_block;
	if (short_block == 0) {
		short_block = FlexAllocate(3 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_CRATE;
	short_block-->1 = 0;
	short_block-->2 = 0;
	return short_block;
];

[ CRATE_TY_Destroy short_block;
	if (CBVK_Is_PrintingFunc_BlockValue(short_block-->1)) {
		BlkValueFree(short_block-->2);
	}
];

[ CRATE_TY_Distinguish c1 c2;
	if (CRATE_TY_Compare(c1, c2) == 0) rfalse;
	rtrue;
];

[ CRATE_TY_Get short_block type checked_bv	kov;
	kov = short_block-->1;
	if (kov == type) {
		if (checked_bv) {
			checked_bv-->1 = checked_bv-->1 | RESULT_IS_OKAY;
			checked_bv-->2 = short_block-->2;
			return checked_bv;
		}
		else {
			return short_block-->2;
		}
	}
	LocalParking-->0 = type;
	LocalParking-->1 = short_block;
	if (checked_bv) {
		checked_bv-->2 = BlkValueCreate(TEXT_TY);
		BlkValueCopy(checked_bv-->2, CBVK_Print_Crate_Type_Mismatch);
		return checked_bv;
	}
	else {
		CBVK_Print_Crate_Type_Mismatch_I();
		print "^";
		return 0;
	}
];

Array CBVK_Print_Crate_Type_Mismatch --> CONSTANT_PERISHABLE_TEXT_STORAGE CBVK_Print_Crate_Type_Mismatch_I;
[ CBVK_Print_Crate_Type_Mismatch_I;
	print "Collection type mismatch: expected ";
	CBVK_Print_Name_Of_PrintingFunc(LocalParking-->0, 0);
	print ", got ";
	CBVK_Print_Name_Of_PrintingFunc((LocalParking-->1)-->1, (LocalParking-->1)-->2);
];

[ CRATE_TY_Say short_block	kov;
	print "Crate<";
	CBVK_Print_Name_Of_PrintingFunc(short_block-->1);
	print ": ";
	(short_block-->1)(short_block-->2);
	print ">";
];

[ CRATE_TY_Set short_block type value;
	short_block-->1 = type;
	short_block-->2 = value;
	return short_block;
];

[ CBVK_Is_PrintingFunc_BlockValue type;
	switch (type) {
		COUPLE_TY_Say: rtrue;
		CRATE_TY_Say: rtrue;
		LIST_OF_TY_Say: rtrue;
		OPTION_TY_Say: rtrue;
		RELATION_TY_Say: rtrue;
		STORED_ACTION_TY_Say: rtrue;
		TEXT_TY_Say: rtrue;
	}
	rfalse;
];

[ CBVK_Print_Name_Of_PrintingFunc type val	str;
	switch (type) {
		COUPLE_TY_Say: print "couple";
		CRATE_TY_Say: print "crate";
		DA_TruthState: print "truth state";
		DecimalNumber: print "number";
		LIST_OF_TY_Say: print "list";
		OPTION_TY_Say: print "option";
		PrintExternalFileName: print "external file";
		PrintFigureName: print "figure name";
		PrintResponse: print "response";
		PrintSceneName: print "scene";
		PrintShortName: print "object";
		PrintSnippet: print "snippet";
		PrintSoundName: print "sound name";
		PrintTableName: print "table name";
		PrintTimeOfDay: print "time";
		PrintUseOption: print "use option";
		PrintVerbAsValue: print "verb";
		REAL_NUMBER_TY_Say: print "real number";
		RELATION_TY_Say: print "relation";
		RulebookOutcomePrintingRule: print "rulebook outcome";
		RulePrintingRule: print "rulebook";
		SayActionName: print "action name";
		SayPhraseName: print "phrase";
		STORED_ACTION_TY_Say: print "stored action";
		TEXT_TY_Say: print "text";
		default:
			str = BlkValueCreate(TEXT_TY);
			LocalParking-->0 = type;
			LocalParking-->1 = val;
			TEXT_TY_ExpandIfPerishable(str, CBVK_Print_Type_Text);
			if (TEXT_TY_Replace_RE(REGEXP_BLOB, str, CBVK_Illegal_Pattern, 0, 0)) {
				print (TEXT_TY_Say) TEXT_TY_RE_GetMatchVar(1);
			}
			else {
				print (TEXT_TY_Say) str;
			}
			BlkValueFree(str);
	}
];

Array CBVK_Illegal_Pattern --> CONSTANT_PACKED_TEXT_STORAGE "@@94@{5C}<illegal (.+)@{5C}>$";
Array CBVK_Print_Type_Text --> CONSTANT_PERISHABLE_TEXT_STORAGE CBVK_Print_Type_Inner;
[ CBVK_Print_Type_Inner;
	(LocalParking-->0)(LocalParking-->1);
];

[ CBVK_PrintingFunc_To_Comp_Func type val	str;
	switch (type) {
		COUPLE_TY_Say: return BlkValueCompare;
		CRATE_TY_Say: return BlkValueCompare;
		DA_Number: return UnsignedCompare;
		DA_TruthState: return UnsignedCompare;
		DecimalNumber: return UnsignedCompare;
		LIST_OF_TY_Say: return BlkValueCompare;
		OPTION_TY_Say: return BlkValueCompare;
		PrintExternalFileName: return UnsignedCompare;
		PrintFigureName: return UnsignedCompare;
		PrintResponse: return UnsignedCompare;
		PrintSceneName: return UnsignedCompare;
		PrintShortName: return UnsignedCompare;
		PrintSnippet: return UnsignedCompare;
		PrintSoundName: return UnsignedCompare;
		PrintTableName: return UnsignedCompare;
		PrintUseOption: return UnsignedCompare;
		PrintVerbAsValue: return UnsignedCompare;
		REAL_NUMBER_TY_Say: return REAL_NUMBER_TY_Compare;
		RulebookOutcomePrintingRule: return UnsignedCompare;
		SayActionName: return UnsignedCompare;
		STORED_ACTION_TY_Say: return BlkValueCompare;
		TEXT_TY_Say: return BlkValueCompare;
	}
	return 0;
];
-).

To decide which crate is (V - sayable value of kind K) as a crate:
	(- CRATE_TY_Set({-new:crate}, {-printing-routine:K}, {V}) -).

To say kind/type of (C - crate):
	(- CBVK_Print_Name_Of_PrintingFunc({-by-reference:C}-->1); -).

To decide if kind/type of (C - crate) is (name of kind of sayable value K):
	(- ({-by-reference:C}-->1 == {-printing-routine:K}) -).

To decide what K is (C - crate) as a/an (name of kind of sayable value K):
	(- CRATE_TY_Get({-by-reference:C}, {-printing-routine:K}) -).

To decide what K result is (C - crate) as a/an (name of kind of sayable value K) checked:
	(- CRATE_TY_Get({-by-reference:C}, {-printing-routine:K}, {-new:K result}) -).



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

[ OPTION_TY_Compare opt1 opt2	cf delta opt1kov opt2kov;
	opt1kov = opt1-->1;
	opt2kov = opt2-->1;
	! First check if one is some and the other is none
	delta = ((opt2kov & OPTION_IS_SOME) == 0) - ((opt1kov & OPTION_IS_SOME) == 0);
	if (delta) {
		return delta;
	}
	! If both are none, return 0
	if (opt1kov & OPTION_IS_SOME == 0) {
		return 0;
	}
	! Compare the kinds
	delta = ((opt2kov & OPTION_SOME_MASK) == 0) - ((opt1kov & OPTION_SOME_MASK) == 0);
	if (delta) {
		return delta;
	}
	! Then compare the contents
	cf = KOVComparisonFunction(opt1kov & OPTION_SOME_MASK);
	if (cf == 0 or UnsignedCompare) {
		delta = opt1-->2 - opt2-->2;
	}
	else {
		delta = cf(opt1-->2, opt2-->2);
	}
	return delta;
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

[ OPTION_TY_Get short_block	kov;
	kov = short_block-->1;
	if (kov & OPTION_IS_SOME) {
		return short_block-->2;
	}
	print "Error! Trying to extract value from a none option.^";
	return 0;
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

To decide what K option is a/an (name of kind of value K) none option:
	(- OPTION_TY_Set({-new:K option}) -).

[To set (O - value of kind K option) to (V - K):
	(- OPTION_TY_Set({-by-reference:O}, 1, {V}); -).

To set (O - value of kind K option) to none:
	(- OPTION_TY_Set({-by-reference:O}); -).]

To decide if (O - a value option) is some:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME) -).

To decide if (O - a value option) is none:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME == 0) -).

To decide what K is value of (O - value of kind K option):
	(- OPTION_TY_Get({-by-reference:O}) -).



Volume - Results

[ Results are three word short block values.
The first word is the short block header, $84.
The second word stores the kind, but also whether the result contains a value - if the top bit is 1 then there is a value, if not then an error message text.
The third word stores the value or error message text. ]

Include (-
Constant RESULT_IS_OKAY = $80000000;
Constant RESULT_MASK = $7FFFFFFF;

[ RESULT_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return RESULT_TY_Compare(arg1, arg2);
		COPY_KOVS: RESULT_TY_Copy(arg1, arg2);
		CREATE_KOVS: return RESULT_TY_Create(arg1, arg2);
		DESTROY_KOVS: RESULT_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ RESULT_TY_Compare opt1 opt2	cf delta opt1kov opt2kov;
	opt1kov = opt1-->1;
	opt2kov = opt2-->1;
	! First check if one is okay and the other is error
	delta = ((opt2kov & RESULT_IS_OKAY) == 0) - ((opt1kov & RESULT_IS_OKAY) == 0);
	if (delta) {
		return delta;
	}
	! Compare the kinds
	delta = ((opt2kov & RESULT_MASK) == 0) - ((opt1kov & RESULT_MASK) == 0);
	if (delta) {
		return delta;
	}
	! Then compare the contents
	if (opt1kov & RESULT_IS_OKAY) {
		cf = KOVComparisonFunction(opt1kov & RESULT_MASK);
	}
	else {
		cf = BlkValueCompare;
	}
	if (cf == 0 or UnsignedCompare) {
		delta = opt1-->2 - opt2-->2;
	}
	else {
		delta = cf(opt1-->2, opt2-->2);
	}
	return delta;
];

[ RESULT_TY_Copy to from	tokov;
	tokov = to-->1;
	if (((tokov & RESULT_IS_OKAY) && KOVIsBlockValue(tokov & RESULT_MASK)) || to-->2) {
		BlkValueFree(to-->2);
	}
	tokov = tokov | ((from-->1) & RESULT_IS_OKAY);
	to-->1 = tokov;
	to-->2 = from-->2;
];

[ RESULT_TY_Create skov short_block;
	if (short_block == 0) {
		short_block = FlexAllocate(3 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_RESULT;
	short_block-->1 = KindBaseTerm(skov, 0);
	short_block-->2 = 0;
	return short_block;
];

[ RESULT_TY_Destroy short_block	kov;
	kov = short_block-->1;
	if (((kov & RESULT_IS_OKAY) && KOVIsBlockValue(kov & RESULT_MASK)) || short_block-->2) {
		BlkValueFree(short_block-->2);
	}
];

[ RESULT_TY_Distinguish opt1 opt2;
	if (RESULT_TY_Compare(opt1, opt2) == 0) rfalse;
	rtrue;
];

[ RESULT_TY_Get short_block get_okay	kov;
	kov = short_block-->1;
	if (kov & RESULT_IS_OKAY) {
		if (get_okay) {
			return short_block-->2;
		}
		print "Error! Trying to extract error message from an okay result.^";
		return 0;
	}
	if (get_okay) {
		print "Error! Trying to extract value from an error result.^";
		return 0;
	}
	return short_block-->2;
];

[ RESULT_TY_Say short_block	kov;
	kov = short_block-->1;
	if ((kov & RESULT_IS_OKAY)) {
		print "Ok(";
		PrintKindValuePair(kov & RESULT_MASK, short_block-->2);
		print ")";
	}
	else {
		print "Error(";
		print (TEXT_TY_Say) short_block-->2;
		print ")";
	}
];

[ RESULT_TY_Set short_block ok value	kov;
	kov = short_block-->1;
	if ((kov & RESULT_IS_OKAY) && KOVIsBlockValue(kov & RESULT_MASK)) {
		BlkValueFree(short_block-->2);
	}
	if (ok) {
		short_block-->1 = kov | RESULT_IS_OKAY;
	}
	else {
		short_block-->1 = kov & RESULT_MASK;
	}
	short_block-->2 = value;
	return short_block;
];
-).

To decide what K result is (V - value of kind K) as a/an ok/okay/-- result:
	(- RESULT_TY_Set({-new:K result}, 1, {V}) -).

To decide what K result is a/an (name of kind of value K) error result with message (M - text):
	(- RESULT_TY_Set({-new:K result}, 0, {M}) -).

To decide if (R - a value result) is ok/okay:
	(- (({-by-reference:R}-->1) & RESULT_IS_OKAY) -).

To decide if (R - a value result) is an/-- error:
	(- (({-by-reference:R}-->1) & RESULT_IS_OKAY == 0) -).

To decide what K is value of (R - value of kind K result):
	(- RESULT_TY_Get({-by-reference:R}, 1) -).

To decide what text is error message of (R - a value result):
	(- RESULT_TY_Get({-by-reference:R}) -).



Custom Block Value Kinds ends here.