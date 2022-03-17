Version 1/220316 of Data Structures (for Glulx only) by Dannii Willis begins here.

"Provides support for some additional data structures"



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

Include (- -) instead of "Data Structures Stubs" in "Figures.i6t".



Chapter - Anys

[ Anys are three word short block values.
The 1st word is the short block header, $83.
The 2nd word store the type of the value.
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
	cf = KOVComparisonFunction(c1kov);
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
	short_block-->1 = NULL_TY;
	short_block-->2 = 0;
	return short_block;
];

[ ANY_TY_Destroy short_block;
	if (KOVIsBlockValue(short_block-->1)) {
		BlkValueFree(short_block-->2);
	}
];

[ ANY_TY_Distinguish c1 c2;
	if (ANY_TY_Compare(c1, c2) == 0) rfalse;
	rtrue;
];

[ ANY_TY_Get short_block type checked_bv backup or	kov txt;
	kov = short_block-->1;
	if (kov == type) {
		if (checked_bv) {
			return RESULT_TY_Set(checked_bv, 1, short_block-->2);
		}
		else {
			return short_block-->2;
		}
	}
	LocalParking-->0 = type;
	LocalParking-->1 = short_block;
	if (checked_bv) {
		txt = BlkValueCreate(TEXT_TY);
		BlkValueCopy(txt, ANY_TY_Print_Kind_Mismatch);
		return RESULT_TY_Set(checked_bv, 0, txt);
	}
	else {
		if (~~or) {
			ANY_TY_Print_Kind_Mismatch_Inner();
			print "^";
		}
		return backup;
	}
];

Array ANY_TY_Print_Illegal_Pattern --> CONSTANT_PACKED_TEXT_STORAGE "@@94@{5C}<illegal (.+)@{5C}>$";

[ ANY_TY_Print_Kind_Name skov val plural show_object_subkinds	basekov subkind str;
	basekov = KindAtomic(skov);
	switch (basekov) {
		ACTION_NAME_TY: print "action name";
		ACTIVITY_TY: print "activity";
		ANY_TY: print "any";
		COUPLE_TY:
			if (plural) {
				print "couples of ";
			}
			else {
				print "couple of ";
			}
			ANY_TY_Print_Subkind_Name(skov, 0, 0, show_object_subkinds);
			print " and ";
			ANY_TY_Print_Subkind_Name(skov, 1, 0, show_object_subkinds);
		DESCRIPTION_OF_TY: print "description";
		EQUATION_TY: print "equation";
		EXTERNAL_FILE_TY: print "external file";
		FIGURE_NAME_TY: print "figure name";
		LIST_OF_TY:
			if (plural) {
				print "lists of ";
			}
			else {
				print "list of ";
			}
			ANY_TY_Print_Subkind_Name(skov, 0, 1, show_object_subkinds);
		MAP_TY:
			if (plural) {
				print "maps of ";
			}
			else {
				print "map of ";
			}
			ANY_TY_Print_Subkind_Name(skov, 0, 1, show_object_subkinds);
			print " to ";
			ANY_TY_Print_Subkind_Name(skov, 1, 1, show_object_subkinds);
		NULL_TY: print "null";
		NUMBER_TY: print "number";
		OBJECT_TY: print "object";
		OPTION_TY:
			ANY_TY_Print_Subkind_Name(skov, 0, 0, show_object_subkinds);
			print " option";
		PHRASE_TY: print "phrase";
		PROPERTY_TY: print "property";
		REAL_NUMBER_TY: print "real number";
		RELATION_TY: print "relation";
		RESPONSE_TY: print "response";
		RESULT_TY:
			ANY_TY_Print_Subkind_Name(skov, 0, 0, show_object_subkinds);
			print " result";
		RULE_TY: print "rule";
		RULEBOOK_OUTCOME_TY: print "rulebook outcome";
		RULEBOOK_TY: print "rulebook";
		SCENE_TY: print "scene";
		SNIPPET_TY: print "snippet";
		SOUND_NAME_TY: print "sound name";
		STORED_ACTION_TY: print "stored action";
		TABLE_TY: print "table";
		TABLE_COLUMN_TY: print "table column";
		TEXT_TY: print "text";
		TIME_TY: print "time";
		TRUTH_STATE_TY: print "truth state";
		UNDERSTANDING_TY: print "topic";
		UNICODE_CHARACTER_TY: print "unicode character";
		USE_OPTION_TY: print "use option";
		VERB_TY: print "verb";
		default:
			str = BlkValueCreate(TEXT_TY);
			LocalParking-->0 = basekov;
			LocalParking-->1 = val;
			TEXT_TY_ExpandIfPerishable(str, ANY_TY_Print_Kind_Text);
			if (TEXT_TY_Replace_RE(REGEXP_BLOB, str, ANY_TY_Print_Illegal_Pattern, 0, 0)) {
				print (TEXT_TY_Say) TEXT_TY_RE_GetMatchVar(1);
			}
			else {
				print (TEXT_TY_Say) str;
			}
			BlkValueFree(str);
	}
	if (plural) {
		if (basekov == COUPLE_TY or LIST_OF_TY or MAP_TY) {
			return;
		}
		print "s";
	}
];

Array ANY_TY_Print_Kind_Mismatch --> CONSTANT_PERISHABLE_TEXT_STORAGE ANY_TY_Print_Kind_Mismatch_Inner;
[ ANY_TY_Print_Kind_Mismatch_Inner;
	print "Any type mismatch: expected ";
	ANY_TY_Print_Kind_Name(LocalParking-->0, 0, 0, 1);
	print ", got ";
	ANY_TY_Print_Kind_Name((LocalParking-->1)-->1, (LocalParking-->1)-->2, 0, 1);
];

Array ANY_TY_Print_Kind_Text --> CONSTANT_PERISHABLE_TEXT_STORAGE ANY_TY_Print_Kind_Text_Inner;
[ ANY_TY_Print_Kind_Text_Inner;
	PrintKindValuePair(LocalParking-->0, LocalParking-->1);
];

[ ANY_TY_Print_Subkind_Name skov subkind_num plural show_object_subkinds	subkind;
	subkind = KindBaseTerm(skov, subkind_num);
	ANY_TY_Print_Kind_Name(subkind, 0, plural, show_object_subkinds);
	if (show_object_subkinds && subkind == OBJECT_TY) {
		print " (subkind ", skov, ")";
	}
];

[ ANY_TY_Say short_block	kov;
	print "Any<";
	ANY_TY_Print_Kind_Name(short_block-->1);
	print ": ";
	PrintKindValuePair(short_block-->1, short_block-->2);
	print ">";
];

[ ANY_TY_Set short_block type value;
	short_block-->1 = type;
	short_block-->2 = value;
	return short_block;
];
-).

To decide which any is (V - value of kind K) as an any:
	(- ANY_TY_Set({-new:any}, {-strong-kind:K}, {V}) -).

To say kind/type of (A - any):
	(- ANY_TY_Print_Kind_Name({-by-reference:A}-->1); -).

To decide if kind/type of (A - any) is (name of kind of value K):
	(- ({-by-reference:A}-->1 == {-strong-kind:K}) -).

To decide what K result is (A - any) as a/an (name of kind of value K):
	(- ANY_TY_Get({-by-reference:A}, {-strong-kind:K}, {-new:K result}) -).

To decide what K is (A - any) as a/an (name of kind of value K) or (backup - K):
	(- ANY_TY_Get({-by-reference:A}, {-strong-kind:K}, 0, {backup}, 1) -).



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
	!BlkValueCopy(to-->1, from-->1);
	!BlkValueCopy(to-->2, from-->2);
];

Array MAP_TY_Temp_List_Definition --> LIST_OF_TY 1 ANY_TY;

[ MAP_TY_Create skov short_block;
	if (short_block == 0) {
		short_block = FlexAllocate(5 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_MAP;
	MAP_TY_Temp_List_Definition-->2 = KindBaseTerm(skov, 0);
	short_block-->1 = BlkValueCreate(MAP_TY_Temp_List_Definition);
	MAP_TY_Temp_List_Definition-->2 = KindBaseTerm(skov, 1);
	short_block-->2 = BlkValueCreate(MAP_TY_Temp_List_Definition);
	return short_block;
];

[ MAP_TY_Delete_Key map key keyany keytype	cf i keyslist length;
	if (keyany && keytype ~= ANY_TY) {
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

[ MAP_TY_Get_Key map key keyany keytype checked_bv backup or	cf i keyskov keyslist length res valslist;
	if (keyany && keytype ~= ANY_TY) {
		key = ANY_TY_Set(keyany, keytype, key);
	}
	keyslist = map-->1;
	valslist = map-->2;
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
				return OPTION_TY_Set(checked_bv, 1, res);
			}
			else {
				return res;
			}
		}
	}
	if (checked_bv) {
		return OPTION_TY_Set(checked_bv);
	}
	else {
		if (~~or) {
			print "Map has no key: ";
			PrintKindValuePair(keyskov, key);
			print "^";
		}
		return backup;
	}
];

[ MAP_TY_Has_Key map key keyany keytype	cf i keyslist length;
	if (keyany && keytype ~= ANY_TY) {
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
	if (keyany && keytype ~= ANY_TY) {
		key = ANY_TY_Set(keyany, keytype, key);
	}
	if (valany && valtype ~= ANY_TY) {
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



Chapter - Maps - Creating

To decide which map of value of kind K to value of kind L is a/-- new map of (name of kind of value K) to (name of kind of value L):
	(- {-new:map of K to L} -);



Chapter - Maps - Writing

To set key (key - K) in/of (M - map of value of kind K to value of kind L) to/= (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

To set key (key - K) in/of (M - map of value of kind K to any) to/= (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).

To set key (key - value of kind K) in/of (M - map of any to value of kind L) to/= (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}); -).

To set key (key - value of kind K) in/of (M - map of any to any) to/= (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).

To (M - map of value of kind K to value of kind L) => (key - K) = (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

To (M - map of value of kind K to any) => (key - K) = (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).

To (M - map of any to value of kind L) => (key - value of kind K) = (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}); -).

To (M - map of any to any) => (key - value of kind K) = (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).



Chapter - Maps - Checking keys

To decide if (M - map of value of kind K to value of kind L) has key (key - K):
	(- MAP_TY_Has_Key({-by-reference:M}, {-by-reference:key}) -).

To decide if (M - map of any to value of kind L) has key (key - value of kind K):
	(- MAP_TY_Has_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}) -).



Chapter - Maps - Reading

To decide what L option is get key (key - K) in/from/of (M - map of value of kind K to value of kind L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-new:L option}) -).

To decide what L option is get key (key - value of kind K) in/from/of (M - map of any to value of kind L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-new:L option}) -).

To decide what L is get key (key - K) in/from/of (M - map of value of kind K to value of kind L) or (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {backup}, 1) -).

To decide what L is get key (key - value of kind K) in/from/of (M - map of any to value of kind L) or (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, 0, {backup}, 1) -).

To decide what L option is (M - map of value of kind K to value of kind L) => (key - K):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-new:L option}) -).

To decide what L option is (M - map of any to value of kind L) => (key - value of kind K):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-new:L option}) -).

To decide what L is (M - map of value of kind K to value of kind L) => (key - K) or/|| (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {backup}, 1) -).

To decide what L is (M - map of any to value of kind L) => (key - value of kind K) or/|| (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, 0, {backup}, 1) -).



Chapter - Maps - Deleting keys

To delete key (key - K) in/from/of (M - map of value of kind K to value of kind L):
	(- MAP_TY_Delete_Key({-by-reference:M}, {-by-reference:key}); -).

To delete key (key - value of kind K) in/from/of (M - map of any to value of kind L):
	(- MAP_TY_Delete_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}); -).



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



Chapter - Nulls

[ Nulls are not block values, they're just an empty word of memory. ]

Include (-
[ NULL_TY_Say;
	print "null";
];
-).

To decide which null is null:
	(- 0 -);



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

[ OPTION_TY_Copy to from	kov tokov;
	tokov = to-->1;
	kov = tokov & OPTION_SOME_MASK;
	if ((tokov & OPTION_IS_SOME) && KOVIsBlockValue(kov)) {
		BlkValueFree(to-->2);
	}
	tokov = kov | ((from-->1) & OPTION_IS_SOME);
	to-->1 = tokov;
	if (tokov & OPTION_IS_SOME) {
		if (KOVIsBlockValue(kov)) {
			to-->2 = BlkValueCreate(kov);
			BlkValueCopy(to-->2, from-->2);
		}
		else {
			to-->2 = from-->2;
		}
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

[ OPTION_TY_Get short_block backup or	kov;
	kov = short_block-->1;
	if (kov & OPTION_IS_SOME) {
		return short_block-->2;
	}
	if (~~or) {
		print "Error! Trying to extract value from a none option.^";
	}
	return backup;
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

To decide if (O - a value option) is some:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME) -).

[ We declare this as a loop, even though it isn't, because nonexisting variables don't seem to be unassigned at the end of conditionals. ]
To if (O - value of kind K option) is some let (V - nonexisting K variable) be the value begin -- end loop:
	(- if (({-by-reference:O}-->1) & OPTION_IS_SOME && (
		(KOVIsBlockValue({-strong-kind:K})
			&& BlkValueCopy({-lvalue-by-reference:V}, OPTION_TY_Get({-by-reference:O}, 1))
			|| ({-lvalue-by-reference:V} = OPTION_TY_Get({-by-reference:O}, 1))
		)
	, 1)) -).

To decide if (O - a value option) is none:
	(- (({-by-reference:O}-->1) & OPTION_IS_SOME == 0) -).

To decide what K is value of (O - value of kind K option) or (backup - K):
	(- OPTION_TY_Get({-by-reference:O}, {backup}, 1) -).



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

[ RESULT_TY_Copy to from	kov tokov;
	tokov = to-->1;
	kov = tokov & RESULT_MASK;
	if (RESULT_TY_Val_Needs_Freeing(to)) {
		BlkValueFree(to-->2);
	}
	tokov = kov | ((from-->1) & RESULT_IS_OKAY);
	to-->1 = tokov;
	if ((tokov & RESULT_IS_OKAY) && KOVIsBlockValue(kov)) {
		to-->2 = BlkValueCreate(kov);
		BlkValueCopy(to-->2, from-->2);
	}
	else if (tokov & RESULT_IS_OKAY == 0) {
		to-->2 = BlkValueCreate(TEXT_TY);
		BlkValueCopy(to-->2, from-->2);
	}
	else {
		to-->2 = from-->2;
	}
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

[ RESULT_TY_Destroy short_block;
	if (RESULT_TY_Val_Needs_Freeing(short_block)) {
		BlkValueFree(short_block-->2);
	}
];

[ RESULT_TY_Distinguish opt1 opt2;
	if (RESULT_TY_Compare(opt1, opt2) == 0) rfalse;
	rtrue;
];

[ RESULT_TY_Get short_block get_okay backup or	kov;
	kov = short_block-->1;
	if (kov & RESULT_IS_OKAY) {
		if (get_okay) {
			return short_block-->2;
		}
		print "Error! Trying to extract error message from an okay result.^";
		return 0;
	}
	if (get_okay) {
		if (~~or) {
			print "Error! Trying to extract value from an error result.^";
		}
		return backup;
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
	if (RESULT_TY_Val_Needs_Freeing(short_block)) {
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

[ RESULT_TY_Val_Needs_Freeing short_block kov;
	kov = short_block-->1;
	if (kov & RESULT_IS_OKAY) {
		if (KOVIsBlockValue(kov & RESULT_MASK)) {
			rtrue;
		}
		rfalse;
	}
	rtrue;
];
-).

To decide what K result is (V - value of kind K) as a/an ok/okay/-- result:
	(- RESULT_TY_Set({-new:K result}, 1, {V}) -).

To decide what K result is a/an (name of kind of value K) error result with message (M - text):
	(- RESULT_TY_Set({-new:K result}, 0, {M}) -).

To decide if (R - a value result) is ok/okay:
	(- (({-by-reference:R}-->1) & RESULT_IS_OKAY) -).

[ We declare this as a loop, even though it isn't, because nonexisting variables don't seem to be unassigned at the end of conditionals. ]
To if (R - value of kind K result) is ok/okay let (V - nonexisting K variable) be the value begin -- end loop:
	(- if (({-by-reference:R}-->1) & RESULT_IS_OKAY && (
		(KOVIsBlockValue({-strong-kind:K})
			&& BlkValueCopy({-lvalue-by-reference:V}, RESULT_TY_Get({-by-reference:R}, 1))
			|| ({-lvalue-by-reference:V} = RESULT_TY_Get({-by-reference:R}, 1))
		)
	, 1)) -).

To decide if (R - a value result) is an/-- error:
	(- (({-by-reference:R}-->1) & RESULT_IS_OKAY == 0) -).
	
To if (R - value of kind K result) is an/-- error let (V - nonexisting text variable) be the error message begin -- end loop:
	(- if ((({-by-reference:R}-->1) & RESULT_IS_OKAY == 0) && BlkValueCopy({-lvalue-by-reference:V}, RESULT_TY_Get({-by-reference:R}))) -).

To decide what K is value of (R - value of kind K result) or (backup - K):
	(- RESULT_TY_Get({-by-reference:R}, 1, {backup}, 1) -).



Chapter - Unchecked phrases

[ Unchecked phrases should be used only with caution. ]

To decide what K is (A - any) as a/an (name of kind of value K) unchecked:
	(- ANY_TY_Get({-by-reference:A}, {-strong-kind:K}, 0, {-new:K}) -).

To decide what L is get key (key - K) in/from/of (M - map of value of kind K to value of kind L) unchecked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {-new:L}) -).

To decide what L is get key (key - value of kind K) in/from/of (M - map of any to value of kind L) unchecked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, 0, {-new:L}) -).

To decide what L is (M - map of value of kind K to value of kind L) => (key - K) unchecked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {-new:L}) -).

To decide what L is (M - map of any to value of kind L) => (key - value of kind K) unchecked:
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, 0, {-new:L}) -).

To decide what K is value of (O - value of kind K option) unchecked:
	(- OPTION_TY_Get({-by-reference:O}, {-new:K}) -).

To decide what K is value of (R - value of kind K result) unchecked:
	(- RESULT_TY_Get({-by-reference:R}, 1, {-new:K}) -).

To decide what text is error message of (R - a value result) unchecked:
	(- RESULT_TY_Get({-by-reference:R}) -).



Data Structures ends here.
