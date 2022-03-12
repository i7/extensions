Version 1/220312 of Custom Block Value Kinds (for Glulx only) by Dannii Willis begins here.

"Provides support for some custom block value kinds"



Chapter - Template changes

[ The handling of short blocks doesn't actually do as it says it does, so we need to add support for our own short block bitmaps. ]

Include (-
Constant BLK_BVBITMAP_CUSTOM_BV = $80;
Constant BLK_BVBITMAP_OPTION = $81;
Constant BLK_BVBITMAP_COUPLE = $82;
Constant BLK_BVBITMAP_ANY = $83;
Constant BLK_BVBITMAP_RESULT = $84;
Constant BLK_BVBITMAP_MAP = $85;

[ BlkValueWeakKind bv o;
	if (bv) {
		o = bv-->0;
		if (o == 0) return bv-->(BLK_HEADER_KOV+1);
		if (o & BLK_BVBITMAP == o) {
			if (o & BLK_BVBITMAP_CUSTOM_BV) {
				switch (o) {
					BLK_BVBITMAP_ANY: return ANY_TY;
					BLK_BVBITMAP_COUPLE: return COUPLE_TY;
					BLK_BVBITMAP_MAP: return MAP_TY;
					BLK_BVBITMAP_OPTION: return OPTION_TY;
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



Chapter - Anys

[ Anys are three word short block values.
The 1st word is the short block header, $83.
The 2nd word store the type of the value - but as a printing function address.
The 3rd word store the value. ]

Include (-
[ ANY_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return ANY_TY_Compare(arg1, arg2);
		COPY_KOVS: ANY_TY_Copy(arg1, arg2);
		CREATE_KOVS: return ANY_TY_Create(arg1, arg2);
		DESTROY_KOVS: ANY_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ ANY_TY_Compare c1 c2	cf delta c1kov;
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

[ ANY_TY_Copy to from;
	to-->1 = from-->1;
	to-->2 = from-->2;
];

[ ANY_TY_Create skov short_block;
	if (short_block == 0) {
		short_block = FlexAllocate(3 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_ANY;
	short_block-->1 = 0;
	short_block-->2 = 0;
	return short_block;
];

[ ANY_TY_Destroy short_block;
	if (CBVK_Is_PrintingFunc_BlockValue(short_block-->1)) {
		BlkValueFree(short_block-->2);
	}
];

[ ANY_TY_Distinguish c1 c2;
	if (ANY_TY_Compare(c1, c2) == 0) rfalse;
	rtrue;
];

[ ANY_TY_Get short_block type checked_bv	kov;
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
		BlkValueCopy(checked_bv-->2, CBVK_Print_Any_Type_Mismatch);
		return checked_bv;
	}
	else {
		CBVK_Print_Any_Type_Mismatch_I();
		print "^";
		return 0;
	}
];

Array CBVK_Print_Any_Type_Mismatch --> CONSTANT_PERISHABLE_TEXT_STORAGE CBVK_Print_Any_Type_Mismatch_I;
[ CBVK_Print_Any_Type_Mismatch_I;
	print "Any type mismatch: expected ";
	CBVK_Print_Name_Of_PrintingFunc(LocalParking-->0, 0);
	print ", got ";
	CBVK_Print_Name_Of_PrintingFunc((LocalParking-->1)-->1, (LocalParking-->1)-->2);
];

[ ANY_TY_Say short_block	kov;
	print "Any<";
	CBVK_Print_Name_Of_PrintingFunc(short_block-->1);
	print ": ";
	(short_block-->1)(short_block-->2);
	print ">";
];

[ ANY_TY_Set short_block type value;
	short_block-->1 = type;
	short_block-->2 = value;
	return short_block;
];

[ CBVK_Is_PrintingFunc_BlockValue type;
	switch (type) {
		ANY_TY_Say: rtrue;
		COUPLE_TY_Say: rtrue;
		LIST_OF_TY_Say: rtrue;
		MAP_TY_Say: rtrue;
		OPTION_TY_Say: rtrue;
		RELATION_TY_Say: rtrue;
		STORED_ACTION_TY_Say: rtrue;
		TEXT_TY_Say: rtrue;
	}
	rfalse;
];

[ CBVK_Print_Name_Of_PrintingFunc type val	str;
	switch (type) {
		ANY_TY_Say: print "any";
		COUPLE_TY_Say: print "couple";
		DA_TruthState: print "truth state";
		DecimalNumber: print "number";
		LIST_OF_TY_Say: print "list";
		MAP_TY_Say: print "map";
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
		ANY_TY_Say: return BlkValueCompare;
		COUPLE_TY_Say: return BlkValueCompare;
		DA_Number: return UnsignedCompare;
		DA_TruthState: return UnsignedCompare;
		DecimalNumber: return UnsignedCompare;
		LIST_OF_TY_Say: return BlkValueCompare;
		MAP_TY_Say: return BlkValueCompare;
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

To decide which any is (V - sayable value of kind K) as an any:
	(- ANY_TY_Set({-new:any}, {-printing-routine:K}, {V}) -).

To say kind/type of (A - any):
	(- CBVK_Print_Name_Of_PrintingFunc({-by-reference:A}-->1); -).

To decide if kind/type of (A - any) is (name of kind of sayable value K):
	(- ({-by-reference:A}-->1 == {-printing-routine:K}) -).

To decide what K is (A - any) as a/an (name of kind of sayable value K):
	(- ANY_TY_Get({-by-reference:A}, {-printing-routine:K}) -).

To decide what K result is (A - any) as a/an (name of kind of sayable value K) checked:
	(- ANY_TY_Get({-by-reference:A}, {-printing-routine:K}, {-new:K result}) -).



Chapter - Couples

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
	short_block-->2 = KindBaseTerm(skov, 1);
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

To decide what K is (C - couple of value of kind K and value of kind L) => 1:
	(- {-by-reference:C}-->3 -).

To decide what L is (C - couple of value of kind K and value of kind L) => 2:
	(- {-by-reference:C}-->4 -).



Chapter - Maps

[ Maps are three word short block values.
The 1st word is the short block header, $85.
The 2nd word is a list of keys.
The 3rd word is a list of values. ]

Include (-
[ MAP_TY_Support task arg1 arg2 arg3;
	switch(task) {
		!COMPARE_KOVS: return MAP_TY_Compare(arg1, arg2);
		COPY_KOVS: MAP_TY_Copy(arg1, arg2);
		CREATE_KOVS: return MAP_TY_Create(arg1, arg2);
		DESTROY_KOVS: MAP_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ MAP_TY_Compare c1 c2	cf delta c1kov;

];

[ MAP_TY_Copy to from;
	to-->1 = from-->1;
	to-->2 = from-->2;
];

Array MAP_TY_Temp_List_Definition --> LIST_OF_TY 1 ANY_TY;

[ MAP_TY_Create skov short_block	keykov valkov;
	keykov = KindBaseTerm(skov, 0);
	valkov = KindBaseTerm(skov, 1);
	if (short_block == 0) {
		short_block = FlexAllocate(5 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_MAP;
	MAP_TY_Temp_List_Definition-->2 = keykov;
	short_block-->1 = BlkValueCreate(MAP_TY_Temp_List_Definition);
	MAP_TY_Temp_List_Definition-->2 = valkov;
	short_block-->2 = BlkValueCreate(MAP_TY_Temp_List_Definition);
	return short_block;
];

[ MAP_TY_Delete_Key map key keyany keytype	cf i keyslist length;
	if (keyany && keytype ~= ANY_TY_Say) {
		key = ANY_TY_Set(keyany, keytype, key);
	}
	keyslist = map-->1;
	cf = KOVComparisonFunction(BlkValueRead(keyslist, LIST_ITEM_KOV_F));
	if (cf == 0) {
		cf = UnsignedCompare;
	}
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	for (i = 0: i < length; i++) {
		if (cf(key, BlkValueRead(keyslist, LIST_ITEM_BASE + i)) == 0) {
			LIST_OF_TY_RemoveItemRange(keyslist, i + 1, i + 1);
			LIST_OF_TY_RemoveItemRange(map-->2, i + 1, i + 1);
			return;
		}
	}
];

[ MAP_TY_Destroy short_block;
	BlkValueFree(short_block-->1);
	BlkValueFree(short_block-->2);
];

[ MAP_TY_Distinguish m1 m2;
	if (MAP_TY_Compare(m1, m2) == 0) rfalse;
	rtrue;
];

[ MAP_TY_Get_Key map key keyany keytype checked_bv	cf i keyskov keyslist length res valslist;
	if (keyany && keytype ~= ANY_TY_Say) {
		key = ANY_TY_Set(keyany, keytype, key);
	}
	keyslist = map-->1;
	valslist = map-->1;
	keyskov = BlkValueRead(keyslist, LIST_ITEM_KOV_F);
	cf = KOVComparisonFunction(keyskov);
	if (cf == 0) {
		cf = UnsignedCompare;
	}
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	for (i = 0: i < length; i++) {
		res = BlkValueRead(keyslist, LIST_ITEM_BASE + i);
		if (cf(key, res) == 0) {
			res = BlkValueRead(valslist, LIST_ITEM_BASE + i);
			if (checked_bv) {
				checked_bv-->1 = checked_bv-->1 | RESULT_IS_OKAY;
				checked_bv-->2 = res;
				return checked_bv;
			}
			else {
				return res;
			}
		}
	}
	LocalParking-->0 = keyskov;
	LocalParking-->1 = key;
	if (checked_bv) {
		checked_bv-->2 = BlkValueCreate(TEXT_TY);
		BlkValueCopy(checked_bv-->2, CBVK_Print_Missing_Key);
		return checked_bv;
	}
	else {
		CBVK_Print_Missing_Key_Inner();
		print "^";
		return 0;
	}
];

Array CBVK_Print_Missing_Key --> CONSTANT_PERISHABLE_TEXT_STORAGE CBVK_Print_Missing_Key_Inner;
[ CBVK_Print_Missing_Key_Inner;
	print "Map has no key: ";
	PrintKindValuePair(LocalParking-->0, LocalParking-->1);
];

[ MAP_TY_Has_Key map key keyany keytype	cf i keyslist length;
	if (keyany && keytype ~= ANY_TY_Say) {
		key = ANY_TY_Set(keyany, keytype, key);
	}
	keyslist = map-->1;
	cf = KOVComparisonFunction(BlkValueRead(keyslist, LIST_ITEM_KOV_F));
	if (cf == 0) {
		cf = UnsignedCompare;
	}
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	for (i = 0: i < length; i++) {
		if (cf(key, BlkValueRead(keyslist, LIST_ITEM_BASE + i)) == 0) {
			rtrue;
		}
	}
	rfalse;
];

[ MAP_TY_Set_Key map key keyany keytype val valany valtype	cf i keyslist length valslist;
	if (keyany && keytype ~= ANY_TY_Say) {
		key = ANY_TY_Set(keyany, keytype, key);
	}
	if (valany && valtype ~= ANY_TY_Say) {
		val = ANY_TY_Set(valany, valtype, val);
	}
	keyslist = map-->1;
	valslist = map-->2;
	cf = KOVComparisonFunction(BlkValueRead(keyslist, LIST_ITEM_KOV_F));
	if (cf == 0) {
		cf = UnsignedCompare;
	}
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	for (i = 0: i < length; i++) {
		if (cf(key, BlkValueRead(keyslist, LIST_ITEM_BASE + i)) == 0) {
			! Updating existing key
			LIST_OF_TY_RemoveItemRange(valslist, i + 1, i + 1);
			LIST_OF_TY_InsertItem(valslist, val, 1, i + 1);
			return;
		}
	}
	! New key
	LIST_OF_TY_InsertItem(keyslist, key);
	LIST_OF_TY_InsertItem(valslist, val);
];

[ MAP_TY_Say map	i keyskov keyslist length valskov valslist;
	keyslist = map-->1;
	valslist = map-->2;
	keyskov = BlkValueRead(keyslist, LIST_ITEM_KOV_F);
	valskov = BlkValueRead(valslist, LIST_ITEM_KOV_F);
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	print "{";
	for (i = 0: i < length: i++) {
		PrintKindValuePair(keyskov, BlkValueRead(keyslist, LIST_ITEM_BASE + i));
		print ": ";
		PrintKindValuePair(valskov, BlkValueRead(valslist, LIST_ITEM_BASE + i));
		if (i < length - 1) print ", ";
	}
	print "}";
];
-).



Chapter - Maps - Writing

To set key (key - K) in/of (M - map of value of kind K to value of kind L) to/= (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

To set key (key - K) in/of (M - map of value of kind K to any) to/= (val - sayable value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}, {-new:any}, {-printing-routine:V}); -).

To set key (key - sayable value of kind K) in/of (M - map of any to value of kind L) to/= (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}, {-by-reference:val}); -).

To set key (key - sayable value of kind K) in/of (M - map of any to any) to/= (val - sayable value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}, {-by-reference:val}, {-new:any}, {-printing-routine:V}); -).

To (M - map of value of kind K to value of kind L) => (key - K) = (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

To (M - map of value of kind K to any) => (key - K) = (val - sayable value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}, {-new:any}, {-printing-routine:V}); -).

To (M - map of any to value of kind L) => (key - sayable value of kind K) = (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}, {-by-reference:val}); -).

To (M - map of any to any) => (key - sayable value of kind K) = (val - sayable value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}, {-by-reference:val}, {-new:any}, {-printing-routine:V}); -).



Chapter - Maps - Checking keys

To decide if (M - map of value of kind K to value of kind L) has key (key - K):
	(- MAP_TY_Has_Key({-by-reference:M}, {-by-reference:key}) -).

To decide if (M - map of any to value of kind L) has key (key - sayable value of kind K):
	(- MAP_TY_Has_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}) -).



Chapter - Maps - Reading

To decide what L is get key (key - K) in/from/of (M - map of value of kind K to value of kind L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}) -).

To decide what L is get key (key - sayable value of kind K) in/from/of (M - map of any to value of kind L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}) -).

To decide what L result is get key (key - K) in/from/of (M - map of value of kind K to value of kind L) checked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-new:L result}) -).

To decide what L result is get key (key - sayable value of kind K) in/from/of (M - map of any to value of kind L) checked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}, {-new:L result}) -).

To decide what L is (M - map of value of kind K to value of kind L) => (key - K):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}) -).

To decide what L is (M - map of any to value of kind L) => (key - sayable value of kind K):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}) -).

To decide what L result is (M - map of value of kind K to value of kind L) => (key - K) checked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-new:L result}) -).

To decide what L result is (M - map of any to value of kind L) => (key - sayable value of kind K) checked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}, {-new:L result}) -).



Chapter - Maps - Deleting keys

To delete key (key - K) in/from/of (M - map of value of kind K to value of kind L):
	(- MAP_TY_Delete_Key({-by-reference:M}, {-by-reference:key}); -).

To delete key (key - sayable value of kind K) in/from/of (M - map of any to value of kind L):
	(- MAP_TY_Delete_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-printing-routine:K}); -).



Chapter - Maps - Iterating

To repeat with (key - nonexisting K variable) in/from/of (M - map of value of kind K to value of kind L) keys begin -- end loop:
	(-
		{-my:2} = BlkValueRead({-by-reference:M}-->1, LIST_LENGTH_F);
		{-lvalue-by-reference:key} = BlkValueRead({-by-reference:M}-->1, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:key} = BlkValueRead({-by-reference:M}-->1, LIST_ITEM_BASE + {-my:1}))
	-).

To repeat with (val - nonexisting L variable) in/from/of (M - map of value of kind K to value of kind L) values begin -- end loop:
	(-
		{-my:2} = BlkValueRead({-by-reference:M}-->1, LIST_LENGTH_F);
		{-lvalue-by-reference:val} = BlkValueRead({-by-reference:M}-->2, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:val} = BlkValueRead({-by-reference:M}-->2, LIST_ITEM_BASE + {-my:1}))
	-).

To repeat with (key - nonexisting K variable) and/to/=> (val - nonexisting L variable) in/from/of (M - map of value of kind K to value of kind L) begin -- end loop:
	(-
		{-my:2} = BlkValueRead({-by-reference:M}-->1, LIST_LENGTH_F);
		{-lvalue-by-reference:key} = BlkValueRead({-by-reference:M}-->1, LIST_ITEM_BASE);
		{-lvalue-by-reference:val} = BlkValueRead({-by-reference:M}-->2, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:key} = BlkValueRead({-by-reference:M}-->1, LIST_ITEM_BASE + {-my:1}), {-lvalue-by-reference:val} = BlkValueRead({-by-reference:M}-->2, LIST_ITEM_BASE + {-my:1}))
	-).



Chapter - Options

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



Chapter - Results

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