Version 1/220321 of Data Structures (for Glulx only) by Dannii Willis begins here.

"Provides support for some additional data structures"



Chapter - Template changes

[ Clean up the function stubs ]
Include (- -) instead of "Data Structures Stubs" in "Figures.i6t".

[ The handling of short blocks doesn't actually do as it says it does, so we need to add support for our own short block bitmaps. ]
Include (-
Constant BLK_BVBITMAP_CUSTOM_BV = $80;
Constant BLK_BVBITMAP_COUPLE = $82;
Constant BLK_BVBITMAP_RESULT = $84;
Constant BLK_BVBITMAP_MAP = $85;

[ BlkValueWeakKind bv o;
	if (bv) {
		o = bv-->0;
		if (o == 0) return bv-->(BLK_HEADER_KOV+1);
		if (o & BLK_BVBITMAP == o) {
			if (o & BLK_BVBITMAP_CUSTOM_BV) {
				switch (o) {
					BLK_BVBITMAP_COUPLE: return COUPLE_TY;
					BLK_BVBITMAP_MAP: return MAP_TY;
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

[ For unknown reasons, most of the new kinds don't get added to KOVComparisonFunction, so augment it ]
Include (-
Replace KOVComparisonFunction KOVComparisonFunction_Orig;
-) after "Definitions.i6t".

Include (-
[ KOVComparisonFunction k	ak;
	ak = KindAtomic(k);
	switch(ak) {
		ANY_TY, COUPLE_TY, MAP_TY, OPTION_TY, PROMISE_TY, RESULT_TY: return BlkValueCompare;
		default: return KOVComparisonFunction_Orig(k);
	}
];
-) after "Printing Routines" in "Output.i6t".



Chapter - Anys

[ Anys have a two word long block (ignoring the header).
Word 0: the kind of the value
Word 1: the value ]

Include (-
! Static block values have three parts: the short block (0 means the long block follows immediately), the long block header, and the long block data.
! $050C0000 means a block of length 2^5=32 bytes, that is resident (static) and uses word values.
Array ANY_TY_Default --> 0	$050C0000 ANY_TY MAX_POSITIVE_NUMBER	NULL_TY 0;

Constant ANY_TY_KOV = 0;
Constant ANY_TY_VALUE = 1;

[ ANY_TY_Support task arg1 arg2;
	switch(task) {
		COMPARE_KOVS: return ANY_TY_Compare(arg1, arg2);
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return ANY_TY_Create(arg2);
		DESTROY_KOVS: ANY_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ ANY_TY_Compare any1 any2	cf delta any1kov;
	any1kov = BlkValueRead(any1, ANY_TY_KOV);
	! Compare the kinds
	delta = any1kov - BlkValueRead(any2, ANY_TY_KOV);
	if (delta) {
		return delta;
	}
	! Then compare the contents
	cf = KOVComparisonFunction(any1kov);
	if (cf == 0 or UnsignedCompare) {
		return BlkValueRead(any1, ANY_TY_VALUE) - BlkValueRead(any2, ANY_TY_VALUE);
	}
	else {
		return cf(BlkValueRead(any1, ANY_TY_VALUE), BlkValueRead(any2, ANY_TY_VALUE));
	}
];

[ ANY_TY_Create short_block	long_block;
	long_block = FlexAllocate(2 * WORDSIZE, ANY_TY, BLK_FLAG_WORD);
	BlkValueWrite(long_block, ANY_TY_KOV, NULL_TY, 1);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ ANY_TY_Destroy any;
	if (KOVIsBlockValue(BlkValueRead(any, ANY_TY_KOV))) {
		BlkValueFree(BlkValueRead(any, ANY_TY_VALUE));
	}
];

[ ANY_TY_Distinguish any1 any2;
	if (ANY_TY_Compare(any1, any2) == 0) rfalse;
	rtrue;
];

[ ANY_TY_Get any kov checked_bv backup or	anykov txt;
	anykov = BlkValueRead(any, ANY_TY_KOV);
	if (anykov == kov) {
		if (checked_bv) {
			return RESULT_TY_Set(checked_bv, 1, BlkValueRead(any, ANY_TY_VALUE));
		}
		else {
			return BlkValueRead(any, ANY_TY_VALUE);
		}
	}
	LocalParking-->0 = kov;
	LocalParking-->1 = any;
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
		PROMISE_TY:
			ANY_TY_Print_Subkind_Name(skov, 0, 0, show_object_subkinds);
			print " promise";
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
	ANY_TY_Print_Kind_Name(BlkValueRead(LocalParking-->1, ANY_TY_KOV), BlkValueRead(LocalParking-->1, ANY_TY_VALUE), 0, 1);
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

[ ANY_TY_Say any	kov;
	kov = BlkValueRead(any, ANY_TY_KOV);
	print "Any<";
	ANY_TY_Print_Kind_Name(kov);
	print ": ";
	PrintKindValuePair(kov,  BlkValueRead(any, ANY_TY_VALUE));
	print ">";
];

[ ANY_TY_Set any kov value	long_block valcopy;
	! Check this Any hasn't been set before
	if (BlkValueRead(any, ANY_TY_KOV) ~= NULL_TY) {
		print "Error! Cannot set an Any twice!^";
		return any;
	}
	! Write to the long block directly, without copy-on-write semantics
	long_block = BlkValueGetLongBlock(any);
	BlkValueWrite(long_block, ANY_TY_KOV, kov, 1);
	! Make our own copy of the value
	if (KOVIsBlockValue(kov)) {
		valcopy = BlkValueCreate(kov);
		BlkValueCopy(valcopy, value);
		value = valcopy;
	}
	BlkValueWrite(long_block, ANY_TY_VALUE, value, 1);
	return any;
];
-).

To decide which any is (V - value of kind K) as an any:
	(- ANY_TY_Set({-new:any}, {-strong-kind:K}, {-by-reference:V}) -).

To say kind/type of (A - any):
	(- ANY_TY_Print_Kind_Name(BlkValueRead({-by-reference:A}, ANY_TY_KOV)); -).

To decide if kind/type of (A - any) is (name of kind of value K):
	(- (BlkValueRead({-by-reference:A}, ANY_TY_KOV) == {-strong-kind:K}) -).

To decide what K result is (A - any) as a/an (name of kind of value K):
	(- ANY_TY_Get({-by-reference:A}, {-strong-kind:K}, {-new:K result}) -).

To decide what K is (A - any) as a/an (name of kind of value K) or (backup - K):
	(- ANY_TY_Get({-by-reference:A}, {-strong-kind:K}, 0, {-by-reference:backup}, 1) -).



Section - Unit tests (for use with Unit Tests by Zed Lopez) (not for release) (unindexed)

Data Structures Anys is a unit test. "Data Structures: Anys functionality"

Test global any is an any that varies.
Persons have an any called test property any.

To set test global any:
	now test global any is substituted form of "[1234]" as an any;

To decide what any is test returning a text any from a phrase:
	decide on "Hello world!" as an any;

For testing data structures anys:
	[ Test untyped (null) anys ]
	let NullAny1 be an any;
	for "Untyped any is kind null" assert the kind of NullAny1 is null;
	for "Name of kind of untyped any" assert "[kind of NullAny1]" is "null";
	for "Saying untyped any" assert "[NullAny1]" is "Any<null: null>";
	for "Default value of global any" assert test global any is null as an any;
	for "Default value of property any" assert test property any of yourself is null as an any;
	set test global any;
	for "Anys correctly copy and reference count their values" assert test global any is "1234" as an any;
	[ Test basic functionality with a number any ]
	let NumAny1 be 1234 as an any;
	for "Any<number> kind" assert the kind of NumAny1 is number;
	for "Any<number> result" assert NumAny1 as a number is 1234 as a result;
	for "Any<number> equality" assert NumAny1 is 1234 as an any;
	let NumAny1Error be a text error result with message "Any type mismatch: expected text, got number";
	for "Any<number> cast to text error message" assert NumAny1 as a text is NumAny1Error;
	let NumAny1Text2 be NumAny1 as a text or "Oops, not a text";
	for "Any<number> cast with backup value" assert NumAny1Text2 is "Oops, not a text";
	for "Any<number> unchecked" assert NumAny1 as a number unchecked is 1234;
	[ Test anys with with block values with a text any ]
	let TextAny1 be "Hello world!" as an any;
	for "Any<text> kind" assert the kind of TextAny1 is text;
	for "Any<text> result" assert TextAny1 as a text is "Hello world!" as a result;
	for "Any<text> equality" assert TextAny1 is "Hello world!" as an any;
	for "Any<text> returned from phrase" assert test returning a text any from a phrase is "Hello world!" as an any;
	for "Any<text> unchecked" assert TextAny1 as a text unchecked is "Hello world!";
	[ Test comparison operators ]
	for "Any<number> > comparison" assert 1234 as an any > 1233 as an any;
	for "Any<number> < comparison" assert 1234 as an any < 1235 as an any;
	for "Any<text> > comparison" assert "Hello" as an any > "Apple" as an any;
	for "Any<text> < comparison" assert "Hello" as an any < "Zoo" as an any;
	[ Check that object subkinds are shown in error messages ]
	let ListAny1 be {yourself} as an any;
	for "Any<list of objects> subkinds shown in error messages" assert "[ListAny1 as a number]" rmatches "Error\(Any type mismatch: expected number, got list of objects \(subkind \d+\)\)";

Data Structures Anys All Kinds is a unit test. "Data Structures: Anys of all kinds"

Equation - Data Structures Test Equation
	F=ma
where F is a number, m is a number, a is an number.

The file of Data Structures Test File is called "DSTF".

To data structures test phrase (this is data structures test phrase):
	do nothing;

Sound of Data Structures Test Sound is the file "DSTS".

For testing data structures anys all kinds:
	[ Test that printing anys of all the kinds works ]
	for "Any<action name>" assert "[waiting action as an any]" is "Any<action name: waiting>";
	for "Any<activity>" assert "[printing the name as an any]" is "Any<activity: 0>";
	for "Any<any>" assert "[1234 as an any as an any]" is "Any<any: Any<number: 1234>>";
	for "Any<couple>" assert "[1234 and yourself as a couple as an any]" is "Any<couple of number and object: (1234, yourself)>";
	[ descriptions? ]
	for "Any<equation>" assert "[Data Structures Test Equation as an any]" rmatches "Any\<equation: \d+\>";
	for "Any<external file>" assert "[file of Data Structures Test File as an any]" is "Any<external file: file of Data Structures Test File>";
	for "Any<figure name>" assert "[figure of cover as an any]" is "Any<figure name: Figure of cover>";
	for "Any<list>" assert "[{yourself} as an any]" is "Any<list of objects: yourself>";
	for "Any<map>" assert "[(new map of numbers to things) as an any]" is "Any<map of numbers to objects: {}>";
	for "Any<null>" assert "[null as an any]" is "Any<null: null>";
	for "Any<number>" assert "[1234 as an any]" is "Any<number: 1234>";
	for "Any<object>" assert "[yourself as an any]" is "Any<object: yourself>";
	for "Any<option>" assert "[1234 as an option as an any]" is "Any<number option: Some(1234)>";
	for "Any<phrase>" assert "[data structures test phrase as an any]" is "Any<phrase: data structures test phrase>";
	[ properties? ]
	for "Any<real number>" assert "[3.14159 as an any]" is "Any<real number: 3.14159>";
	for "Any<relation>" assert "[containment relation as an any]" is "Any<relation: containment relation>";
	for "Any<response>" assert "[(print empty inventory rule response (A)) as an any]" is "Any<response: print empty inventory rule response (A)>";
	for "Any<result>" assert "[1234 as a result as an any]" is "Any<number result: Ok(1234)>";
	for "Any<rule>" assert "[make named things mentioned rule as an any]" is "Any<rule: make named things mentioned rule>";
	for "Any<rulebook outcome>" assert "[allow access outcome as an any]" is "Any<rulebook outcome: allow access>";
	for "Any<rulebook>" assert "[when play begins as an any]" is "Any<rulebook: When play begins rulebook>";
	for "Any<scene>" assert "[entire game as an any]" is "Any<scene: Entire Game>";
	for "Any<snippet>" assert "[the player's command as an any]" rmatches "Any\<snippet: [the player's command]\>";
	for "Any<sound name>" assert "[sound of data structures test sound as an any]" is "Any<sound name: Sound of Data Structures Test Sound>";
	for "Any<stored action>" assert "[jumping as an any]" is "Any<stored action: jumping>";
	for "Any<table>" assert "[Table of Locale Priorities as an any]" is "Any<table: Table of Locale Priorities>";
	for "Any<table column>" assert "[locale description priority as an any]" rmatches "Any\<table column: \d+\>";
	let TestText be "Hello world";
	for "Any<text>" assert "[TestText as an any]" is "Any<text: Hello world>";
	for "Any<time>" assert "[11:05 AM as an any]" is "Any<time: 11:05 am>";
	for "Any<truth state>" assert "[true as an any]" is "Any<truth state: true>";
	[ topics? ]
	for "Any<unicode character>" assert "[unicode 68 as an any]" is "Any<unicode character: 68>";
	for "Any<use option>" assert "[telemetry recordings option as an any]" is "Any<use option: telemetry recordings option>";
	for "Any<verb>" assert "[the verb discover as an any]" is "Any<verb: verb discover>";
	[ And then one enum kind of value ]
	for "Any<grammatical tense>" assert "[present tense as an any]" is "Any<grammatical tense: present tense>";



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
	(- COUPLE_TY_Set({-new:couple of K and L}, {-by-reference:V1}, {-by-reference:V2}) -).

To decide what K is first value of (C - couple of value of kind K and value of kind L):
	(- {-by-reference:C}-->3 -).

To decide what L is second value of (C - couple of value of kind K and value of kind L):
	(- {-by-reference:C}-->4 -).

To decide what K is (C - couple of value of kind K and value of kind L) => 1:
	(- {-by-reference:C}-->3 -).

To decide what L is (C - couple of value of kind K and value of kind L) => 2:
	(- {-by-reference:C}-->4 -).



Section - Unit tests (for use with Unit Tests by Zed Lopez) (not for release) (unindexed)

Data Structures Couples is a unit test. "Data Structures: Couples"

To decide what couple of text and list of numbers is test returning a couple from a phrase:
	decide on "Hello world!" and {1234} as a couple;

For testing data structures couples:
	let CoupleTest be 1234 and "Hello world" as a couple;
	for "Couple<number, text> equality" assert CoupleTest is 1234 and "Hello world" as a couple;
	for "Couple<number, text> saying" assert "[CoupleTest]" is "(1234, Hello world)";
	for "Couple<text, list of numbers> returned from phrase" assert test returning a couple from a phrase is "Hello world!" and {1234} as a couple;
	for "Couple reading first value" assert first value of CoupleTest is 1234;
	for "Couple reading second value" assert second value of CoupleTest is "Hello world";
	for "Couple reading => 1" assert CoupleTest => 1 is 1234;
	for "Couple reading => 2" assert CoupleTest => 2 is "Hello world";
	for "Couple reading < comparison" assert 1234 and "Hello" as a couple < 12345 and "Apple" as a couple;
	for "Couple reading < comparison" assert 1234 and "Hello" as a couple < 1234 and "Zoo" as a couple;
	for "Couple reading > comparison" assert 1234 and "Hello" as a couple > 123 and "Zoo" as a couple;
	for "Couple reading > comparison" assert 1234 and "Hello" as a couple > 1234 and "Apple" as a couple;



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

[ MAP_TY_Create_From short_block keys vals;
	! TODO: check keys and vals lengths are equal
	if (short_block == 0) {
		short_block = FlexAllocate(5 * WORDSIZE, 0, BLK_FLAG_WORD) + BLK_DATA_OFFSET;
	}
	short_block-->0 = BLK_BVBITMAP_MAP;
	short_block-->1 = keys;
	short_block-->2 = vals;
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
				return OPTION_TY_Set(checked_bv, 1, BlkValueRead(valslist, LIST_ITEM_KOV_F), res);
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

[To decide which map of value of kind K to value of kind L is a/-- new/-- map from (keys - list of values of kind K) and/to (vals - list of values of kind L):
	(- MAP_TY_Create_From({-new:map of K to L}, {-by-reference:K}, {-by-reference:L}) -);]



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
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {-by-reference:backup}, 1) -).

To decide what L is get key (key - value of kind K) in/from/of (M - map of any to value of kind L) or (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, 0, {-by-reference:backup}, 1) -).

To decide what L option is (M - map of value of kind K to value of kind L) => (key - K):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, {-new:L option}) -).

To decide what L option is (M - map of any to value of kind L) => (key - value of kind K):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-new:L option}) -).

To decide what L is (M - map of value of kind K to value of kind L) => (key - K) or/|| (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, 0, 0, 0, {-by-reference:backup}, 1) -).

To decide what L is (M - map of any to value of kind L) => (key - value of kind K) or/|| (backup - L):
	(- MAP_TY_Get_Key({-by-reference:M}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, 0, {-by-reference:backup}, 1) -).



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

[ Options have a two word long block (ignoring the header).
Word 0: the kind of the value, or 0 for none
Word 1: the value (or 0) ]

Include (-
! Static block values have three parts: the short block (0 means the long block follows immediately), the long block header, and the long block data.
! $050C0000 means a block of length 2^5=32 bytes, that is resident (static) and uses word values.
Array OPTION_TY_Default --> 0	$050C0000 OPTION_TY MAX_POSITIVE_NUMBER	0 0;

Constant OPTION_TY_KOV = 0;
Constant OPTION_TY_VALUE = 1;

[ OPTION_TY_Support task arg1 arg2;
	switch(task) {
		COMPARE_KOVS: return OPTION_TY_Compare(arg1, arg2);
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return OPTION_TY_Create(arg2);
		DESTROY_KOVS: OPTION_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ OPTION_TY_Compare opt1 opt2	cf delta opt1kov;
	opt1kov = BlkValueRead(opt1, OPTION_TY_KOV);
	! First check if one is some and the other is none
	delta = opt1kov - BlkValueRead(opt2, OPTION_TY_KOV);
	if (delta) {
		return delta;
	}
	! If both are none, return 0
	if (opt1kov == 0) {
		return 0;
	}
	! Then compare the contents
	cf = KOVComparisonFunction(opt1kov);
	if (cf == 0 or UnsignedCompare) {
		return BlkValueRead(opt1, OPTION_TY_VALUE) - BlkValueRead(opt2, OPTION_TY_VALUE);
	}
	else {
		return cf(BlkValueRead(opt1, OPTION_TY_VALUE), BlkValueRead(opt2, OPTION_TY_VALUE));
	}
];

[ OPTION_TY_Create short_block	long_block;
	long_block = FlexAllocate(2 * WORDSIZE, OPTION_TY, BLK_FLAG_WORD);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ OPTION_TY_Destroy option	kov;
	kov = BlkValueRead(option, OPTION_TY_KOV);
	if (kov && KOVIsBlockValue(kov)) {
		BlkValueFree(BlkValueRead(option, OPTION_TY_VALUE));
	}
];

[ OPTION_TY_Distinguish opt1 opt2;
	if (OPTION_TY_Compare(opt1, opt2) == 0) rfalse;
	rtrue;
];

[ OPTION_TY_Get option backup or	kov;
	kov = BlkValueRead(option, OPTION_TY_KOV);
	if (kov) {
		return BlkValueRead(option, OPTION_TY_VALUE);
	}
	if (~~or) {
		print "Error! Trying to extract value from a none option.^";
	}
	return backup;
];

[ OPTION_TY_Say option	kov;
	kov = BlkValueRead(option, OPTION_TY_KOV);
	if (kov) {
		print "Some(";
		PrintKindValuePair(kov, BlkValueRead(option, OPTION_TY_VALUE));
		print ")";
	}
	else {
		print "None";
	}
];

[ OPTION_TY_Set option some kov value	long_block valcopy;
	! Check this Option hasn't been set before
	if (BlkValueRead(option, OPTION_TY_KOV)) {
		print "Error! Cannot set an Option twice!^";
		return option;
	}
	if (some) {
		! Write to the long block directly, without copy-on-write semantics
		long_block = BlkValueGetLongBlock(option);
		BlkValueWrite(long_block, OPTION_TY_KOV, kov, 1);
		! Make our own copy of the value
		if (KOVIsBlockValue(kov)) {
			valcopy = BlkValueCreate(kov);
			BlkValueCopy(valcopy, value);
			value = valcopy;
		}
		BlkValueWrite(long_block, OPTION_TY_VALUE, value, 1);
	}
	return option;
];
-).

To decide what K option is (V - value of kind K) as an option:
	(- OPTION_TY_Set({-new:K option}, 1, {-strong-kind:K}, {-by-reference:V}) -).

To decide what K option is a/an (name of kind of value K) none option:
	(- OPTION_TY_Set({-new:K option}) -).

To decide if (O - a value option) is some:
	(- (BlkValueRead({-by-reference:O}, OPTION_TY_KOV)) -).

[ We declare this as a loop, even though it isn't, because nonexisting variables don't seem to be unassigned at the end of conditionals. ]
To if (O - value of kind K option) is some let (V - nonexisting K variable) be the value begin -- end loop:
	(- if (BlkValueRead({-by-reference:O}, OPTION_TY_KOV) && (
		(KOVIsBlockValue({-strong-kind:K})
			&& BlkValueCopy({-lvalue-by-reference:V}, OPTION_TY_Get({-by-reference:O}))
			|| ({-lvalue-by-reference:V} = OPTION_TY_Get({-by-reference:O}))
		)
	, 1)) -).

To decide if (O - a value option) is none:
	(- (BlkValueRead({-by-reference:O}, OPTION_TY_KOV) == 0) -).

To decide what K is value of (O - value of kind K option) or (backup - K):
	(- OPTION_TY_Get({-by-reference:O}, {-by-reference:backup}, 1) -).



Section - Unit tests (for use with Unit Tests by Zed Lopez) (not for release) (unindexed)

Data Structures Options is a unit test. "Data Structures: Options"

Test global option is a text option that varies.
Persons have a number option called test property option.

To set test global option:
	now test global option is substituted form of "[1234]" as an option;

To decide what text option is test returning a text option from a phrase:
	decide on "Hello world!" as an option;

For testing data structures options:
	[ Test default/none options ]
	let NoneOption be a number option;
	for "Default options are none" assert NoneOption is none;
	for "Default options are not some" refute NoneOption is some;
	for "Saying default option" assert "[NoneOption]" is "None";
	for "Default value of global option" assert test global option is a text none option;
	for "Default value of property any" assert test property option of yourself is a number none option;
	set test global option;
	for "Options correctly copy and reference count their values" assert test global option is "1234" as an option;
	for "Get value of none option errors" assert "[the value of NoneOption unchecked]" is "Error! Trying to extract value from a none option.[line break]0";
	for "Get value of none option with backup" assert value of NoneOption or 6789 is 6789;
	[ Test basic functionality with a number option ]
	let NumOption be 1234 as an option;
	for "Option<number> is some" assert NumOption is some;
	for "Option<number> is not none" refute NumOption is none;
	for "Option<number> equality" assert NumOption is 1234 as an option;
	for "Option<number> with backup" assert value of NumOption or 6789 is 1234;
	if NumOption is some let NumOptionValue be the value:
		for "Option<number> let V be the value" assert NumOptionValue is 1234;
	for "Option<number> value unchecked" assert the value of NumOption unchecked is 1234;
	[ Test options with with block values with a text option ]
	let TextOption be "Hello world!" as an option;
	for "Option<text> is some" assert TextOption is some;
	for "Option<text> is not none" refute TextOption is none;
	for "Option<text> equality" assert TextOption is "Hello world!" as an option;
	for "Option<text> with backup" assert value of TextOption or "Goodbye" is "Hello world!";
	if TextOption is some let TextOptionValue be the value:
		for "Option<text> let V be the value" assert TextOptionValue is "Hello world!";
	for "Option<text> value unchecked" assert the value of TextOption unchecked is "Hello world!";
	for "Option<text> returned from phrase" assert test returning a text option from a phrase is "Hello world!" as an option;
	[ Test comparison operators ]
	for "Option<number> > comparison" assert 1234 as an option > 1233 as an option;
	for "Option<number> < comparison" assert 1234 as an option < 1235 as an option;
	for "Option<text> > comparison" assert "Hello" as an option > "Apple" as an option;
	for "Option<text> < comparison" assert "Hello" as an option < "Zoo" as an option;



Chapter - Promises

[ Promises have a three word long block (ignoring the header).
Word 0: a result holding the resolved value for the promise, or 0 for a pending promise
Word 1: a list of callbacks for a success value
Word 2: a list of error callbacks ]

Include (-
Constant PROMISE_TY_RESULT = 0;
Constant PROMISE_TY_SUCCESS_HANDLERS = 1;
Constant PROMISE_TY_FAILURE_HANDLERS = 2;

[ PROMISE_TY_Support task arg1 arg2;
	switch(task) {
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return PROMISE_TY_Create(arg2);
		DESTROY_KOVS: PROMISE_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ PROMISE_TY_Add_Handler promise handlerany success_handler	result;
	result = BlkValueRead(promise, PROMISE_TY_RESULT);
	if (~~(result)) {
		if (success_handler) {
			LIST_OF_TY_InsertItem(BlkValueRead(promise, PROMISE_TY_SUCCESS_HANDLERS), handlerany);
		}
		else {
			LIST_OF_TY_InsertItem(BlkValueRead(promise, PROMISE_TY_FAILURE_HANDLERS), handlerany);
		}
	}
	else if ((result-->1) & RESULT_IS_OKAY) {
		if (success_handler) {
			PROMISE_TY_Run_Handler(handlerany, result-->2);
		}
	}
	else {
		if (~~success_handler) {
			PROMISE_TY_Run_Handler(handlerany, result-->2);
		}
	}
];

Array PROMISE_TY_Handler_List_Def --> LIST_OF_TY 1 ANY_TY;

[ PROMISE_TY_Create short_block	long_block;
	long_block = FlexAllocate(3 * WORDSIZE, PROMISE_TY, BLK_FLAG_WORD);
	BlkValueWrite(long_block, PROMISE_TY_SUCCESS_HANDLERS, BlkValueCreate(PROMISE_TY_Handler_List_Def), 1);
	BlkValueWrite(long_block, PROMISE_TY_FAILURE_HANDLERS, BlkValueCreate(PROMISE_TY_Handler_List_Def), 1);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ PROMISE_TY_Destroy promise	result;
	result = BlkValueRead(promise, PROMISE_TY_RESULT);
	if (result) {
		BlkValueFree(result);
	}
	BlkValueFree(BlkValueRead(promise, PROMISE_TY_SUCCESS_HANDLERS));
	BlkValueFree(BlkValueRead(promise, PROMISE_TY_FAILURE_HANDLERS));
];

[ PROMISE_TY_Get promise returnopt resultkov	result;
	result = BlkValueRead(promise, PROMISE_TY_RESULT);
	if (result) {
		return OPTION_TY_Set(returnopt, 1, resultkov, result);
	}
	else {
		return OPTION_TY_Set(returnopt);
	}
];

[ PROMISE_TY_Resolve promise result resultkov returnresult	handler i length list_to_run long_block promiseresult resultval;
	! Check if the promise has already been resolved
	promiseresult = BlkValueRead(promise, PROMISE_TY_RESULT);
	if (promiseresult) {
		if (returnresult) {
			return RESULT_TY_Set(returnresult, 0, PROMISE_TY_Resolve_Error_Multi);
		}
		else {
			print (TEXT_TY_Say) PROMISE_TY_Resolve_Error_Multi;
			print "^";
			return;
		}
	}
	! Store the new result, writing directly to the long block, without copy-on-write semantics
	promiseresult = BlkValueCreate(resultkov);
	BlkValueCopy(promiseresult, result);
	long_block = BlkValueGetLongBlock(promise);
	BlkValueWrite(long_block, PROMISE_TY_RESULT, promiseresult, 1);
	! Run the handlers
	if ((result-->1) & RESULT_IS_OKAY) {
		list_to_run = BlkValueRead(promise, PROMISE_TY_SUCCESS_HANDLERS);
	}
	else {
		list_to_run = BlkValueRead(promise, PROMISE_TY_FAILURE_HANDLERS);
	}
	length = BlkValueRead(list_to_run, LIST_LENGTH_F);
	resultval = result-->2;
	for (i = 0: i < length: i++) {
		handler = BlkValueRead(list_to_run, LIST_ITEM_BASE + i);
		PROMISE_TY_Run_Handler(handler, resultval);
	}
	! Clean up the handlers
	LIST_OF_TY_SetLength(BlkValueRead(promise, PROMISE_TY_SUCCESS_HANDLERS), 0, 0);
	LIST_OF_TY_SetLength(BlkValueRead(promise, PROMISE_TY_FAILURE_HANDLERS), 0, 0);
	! Return a result if requested
	if (returnresult) {
		return RESULT_TY_Set(returnresult, 1, 0);
	}
	return promise;
];

Array PROMISE_TY_Resolve_Error_Multi --> CONSTANT_PACKED_TEXT_STORAGE "A promise cannot be resolved more than once.";

[ PROMISE_TY_Run_Handler handlerany value;
	switch (handlerany-->1) {
		PHRASE_TY: ((handlerany-->2)-->1)(value);
		RULEBOOK_TY: FollowRulebook(handlerany-->2, value, 1);
		default: print "Error! Unknown promise handler kind.^";
	}
];

[ PROMISE_TY_Say promise result;
	result = BlkValueRead(promise, PROMISE_TY_RESULT);
	print "Promise(";
	if (result) {
		RESULT_TY_Say(result);
	}
	else {
		print "pending";
	}
	print ")";
];
-).



Chapter - Promises - Creating and resolving

To decide what K promise is (name of kind of value K) promise:
	(- {-new:K promise} -).

To decide what null result is resolve (P - a value of kind K promise) with (R - K result):
	(- PROMISE_TY_Resolve({-by-reference:P}, {-by-reference:R}, {-strong-kind:K result}, {-new:null result}) -).

To decide what null result is resolve (P - a value of kind K promise) with (val - K):
	(- PROMISE_TY_Resolve({-by-reference:P}, RESULT_TY_Set({-new:K result}, 1, {-by-reference:val}), {-strong-kind:K result}, {-new:null result}) -).

To decide what K promise is (val - value of kind K) as a successful/-- promise:
	(- PROMISE_TY_Resolve({-new:K promise}, RESULT_TY_Set({-new:K result}, 1, {-by-reference:val}), {-strong-kind:K result}) -).

To decide what K promise is (val - text) as a failed (name of kind of value K) promise:
	(- PROMISE_TY_Resolve({-new:K promise}, RESULT_TY_Set({-new:K result}, 0, {-by-reference:val}), {-strong-kind:K result}) -).

To decide what K result option is value of (P - a value of kind K promise):
	(- PROMISE_TY_Get({-by-reference:P}, {-new:K result option}, {-strong-kind:K result}) -).



Chapter - Promises - Attaching handlers

To attach success/-- handler/-- (H - a phrase K -> nothing) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, PHRASE_TY, {-by-reference:H}), 1); -).

[ Inform doesn't seem to allow individual rules producing nothing to be followed, only rulebooks?? ]
[To attach success/-- handler/-- (H - a K based rule producing nothing) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, RULE_TY, {-by-reference:H}), 1); -).]

To attach success/-- handler/-- (H - a K based rulebook) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, RULEBOOK_TY, {-by-reference:H}), 1); -).

To attach failure handler/-- (H - a phrase text -> nothing) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, PHRASE_TY, {-by-reference:H})); -).

[To attach failure handler/-- (H - a K based rule producing nothing) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, RULE_TY, {-by-reference:H})); -).]

To attach failure handler/-- (H - a K based rulebook) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, RULEBOOK_TY, {-by-reference:H})); -).



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
	(- RESULT_TY_Set({-new:K result}, 1, {-by-reference:V}) -).

To decide what K result is a/an (name of kind of value K) error result with message (M - text):
	(- RESULT_TY_Set({-new:K result}, 0, {-by-reference:M}) -).

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
	
To if (R - value result) is an/-- error let (V - nonexisting text variable) be the error message begin -- end loop:
	(- if ((({-by-reference:R}-->1) & RESULT_IS_OKAY == 0) && BlkValueCopy({-lvalue-by-reference:V}, RESULT_TY_Get({-by-reference:R}))) -).

To decide what K is value of (R - value of kind K result) or (backup - K):
	(- RESULT_TY_Get({-by-reference:R}, 1, {-by-reference:backup}, 1) -).



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

To resolve (P - a value of kind K promise) with (R - K result) unchecked:
	(- PROMISE_TY_Resolve({-by-reference:P}, {-by-reference:R}, {-strong-kind:K result}); -).

To resolve (P - a value of kind K promise) with (R - K) unchecked:
	(- PROMISE_TY_Resolve({-by-reference:P}, RESULT_TY_Set({-new:K result}, 1, {-by-reference:R}), {-strong-kind:K result}); -).

To decide what K is value of (R - value of kind K result) unchecked:
	(- RESULT_TY_Get({-by-reference:R}, 1, {-new:K}) -).

To decide what text is error message of (R - a value result) unchecked:
	(- RESULT_TY_Get({-by-reference:R}) -).



Data Structures ends here.