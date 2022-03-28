Version 1/220328 of Data Structures (for Glulx only) by Dannii Willis begins here.

"Provides support for some additional data structures"



Chapter - Template changes

[ Clean up the function stubs ]
Include (- -) instead of "Data Structures Stubs" in "Figures.i6t".

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



Chapter - General utilities

To decide what V is a/-- new (name of kind of value V):
	(- {-new:V} -).

To ignore the result of (V - value):
	(- {V}; -).

[ The immutable kinds are compared based on their values. The mutable kinds are compared based on their long blocks, and so can share a comparison function. ]
Include (-
[ Data_Structures_Compare_Common v1 v2;
	! Equal long blocks means these are the same
	if (BlkValueGetLongBlock(v1) == BlkValueGetLongBlock(v2)) {
		return 0;
	}
	return v1 - v2;
];

[ Data_Structures_Distinguish v1 v2;
	if (Data_Structures_Compare_Common(v1, v2) == 0) rfalse;
	rtrue;
];
-).



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
	! Equal long blocks means these are the same
	if (BlkValueGetLongBlock(any1) == BlkValueGetLongBlock(any2)) {
		return 0;
	}
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
			return RESULT_TY_Set(checked_bv, kov, BlkValueRead(any, ANY_TY_VALUE));
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
	print "Any kind mismatch: expected ";
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

Data Structures Anys is heap tracking.

Test global any is an any that varies.
Persons have an any called test property any.

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
	[ Test basic functionality with a number any ]
	let NumAny1 be 1234 as an any;
	for "Any<number> kind" assert the kind of NumAny1 is number;
	for "Any<number> result" assert NumAny1 as a number is 1234 as a result;
	for "Any<number> equality" assert NumAny1 is 1234 as an any;
	let NumAny1Error be a text error result with message "Any kind mismatch: expected text, got number";
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
	for "Any<list of objects> subkinds shown in error messages" assert "[ListAny1 as a number]" rmatches "Error\(Any kind mismatch: expected number, got list of objects \(subkind \d+\)\)";

Data Structures Anys All Kinds is a unit test. "Data Structures: Anys of all kinds"

Data Structures Anys All Kinds is heap tracking.

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



Chapter - Closures

[ Closures have a ? word long block (ignoring the header).
Word 0: address to resume
Word 1: a list of numbers for preserving the locals
Word 2: local variable number for first incoming parameter
Word 3: a list of numbers for preserving the stack ]

Use closure saving memory of at least 100000 translates as (- Constant CLOSURE_TY_SAVING_MEMORY = {N}; -).

Include (-
! Static long blocks have two parts: the long block header, and the long block data.
! $050C0000 means a block of length 2^5=32 bytes, that is resident (static) and uses word values.
Array CLOSURE_TY_Default_LB --> $050C0000 CLOSURE_TY MAX_POSITIVE_NUMBER	0 0;

Constant CLOSURE_TY_ADDR = 0;
Constant CLOSURE_TY_LOCALS_DATA = 1;
Constant CLOSURE_TY_FIRST_PARAMETER = 2;
Constant CLOSURE_TY_STACK_DATA = 3;

Constant CLOSURE_TY_MAX_LOCALS = 20;

[ DS_Read32 str	res;
	res = glk_get_char_stream(str);
	@shiftl res 8 res;
	res = res + glk_get_char_stream(str);
	@shiftl res 8 res;
	res = res + glk_get_char_stream(str);
	@shiftl res 8 res;
	return res + glk_get_char_stream(str);
];

Array CLOSURE_TY_Temp_List_Definition --> LIST_OF_TY 1 NUMBER_TY;

[ CLOSURE_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return Data_Structures_Compare_Common(arg1, arg2);
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return CLOSURE_TY_Create(arg2);
		DESTROY_KOVS: CLOSURE_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ CLOSURE_TY_Create short_block	long_block;
	long_block = FlexAllocate(4 * WORDSIZE, CLOSURE_TY, BLK_FLAG_WORD);
	BlkValueWrite(long_block, CLOSURE_TY_LOCALS_DATA, BlkValueCreate(CLOSURE_TY_Temp_List_Definition), 1);
	BlkValueWrite(long_block, CLOSURE_TY_STACK_DATA, BlkValueCreate(CLOSURE_TY_Temp_List_Definition), 1);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ CLOSURE_TY_Destroy closure	i length localslist long_block temp;
	long_block = BlkValueGetLongBlock(closure);
	localslist = BlkValueRead(closure, CLOSURE_TY_LOCALS_DATA);
	length = BlkValueRead(localslist, LIST_LENGTH_F);
	! Free our copy of the closure
	for (i = 0: i < length: i++) {
		temp = BlkValueRead(localslist, LIST_ITEM_BASE + i);
		if (temp-->0 == long_block) {
			! Because this copy isn't reference counted properly, free it with the flex system, not the block value system
			FlexFree(temp - BLK_DATA_OFFSET);
		}
	}
	BlkValueFree(localslist);
	BlkValueFree(BlkValueRead(closure, CLOSURE_TY_STACK_DATA));
];

[ CLOSURE_TY_Initialise closure has_parameters updating	addr chunk chunk_length count file_length frame_length frameptr i localslist localspos long_block oldlocalscount prev_func save_alloc save_str stacklist stackpos stks_base temp;
	long_block = BlkValueGetLongBlock(closure);
	localslist = BlkValueRead(closure, CLOSURE_TY_LOCALS_DATA);
	stacklist = BlkValueRead(closure, CLOSURE_TY_STACK_DATA);
	! Reset the stack if we are updating a closure
	if (updating) {
		LIST_OF_TY_SetLength(stacklist, 0, 0);
		oldlocalscount = BlkValueRead(localslist, LIST_LENGTH_F);
	}
	! Get address of first parameter
	if (has_parameters) {
		! Check that the instruction we use has been encoded correctly;
		addr = BlkValueRead(closure, CLOSURE_TY_ADDR);
		if (addr->0 ~= $10 || addr->1 ~= $09 || addr->2 ~= $09) {
			print "Error! Closure code has been compiled incorrectly.^";
			rfalse;
		}
		BlkValueWrite(long_block, CLOSURE_TY_FIRST_PARAMETER, (addr->3) / 4, 1);
	}
	! Get a snapshot of the stack
	@malloc CLOSURE_TY_SAVING_MEMORY save_alloc;
	save_str = glk_stream_open_memory(save_alloc, CLOSURE_TY_SAVING_MEMORY, filemode_ReadWrite, 0);
	@save save_str temp;
	! Parse the Quetzal save
	glk_stream_set_position(save_str, 4, seekmode_Start);
	file_length = DS_Read32(save_str);
	glk_stream_set_position(save_str, 12, seekmode_Start);
	while (glk_stream_get_position(save_str) < file_length) {
		chunk = DS_Read32(save_str);
		chunk_length = DS_Read32(save_str);
		if (chunk == $53746B73) { ! Stks
			stks_base = glk_stream_get_position(save_str);
			glk_stream_set_position(save_str, chunk_length - 4, seekmode_Current);
			! The stream cursor is now at the final call stub frameptr
			frameptr = DS_Read32(save_str);
			temp = frameptr;
			glk_stream_set_position(save_str, stks_base + frameptr - 4, seekmode_Start);
			! We're now at the call stub frameptr for the closure function
			frameptr = DS_Read32(save_str);
			! Account for the call stub in the frame length
			frame_length = temp - frameptr - 16;
			glk_stream_set_position(save_str, stks_base + frameptr, seekmode_Start);
			! Now at the base of the frame
			stackpos = DS_Read32(save_str);
			localspos = DS_Read32(save_str);
			glk_stream_set_position(save_str, stks_base + frameptr + localspos, seekmode_Start);
			! Now at the locals
			count = (stackpos - localspos) / 4;
			if (count > CLOSURE_TY_MAX_LOCALS) {
				print "Error! Closures only support a maximum of ", CLOSURE_TY_MAX_LOCALS, " locals.^";
				rfalse;
			}
			for (i = 0: i < count: i++) {
				temp = DS_Read32(save_str);
				! Is this the closure?
				if (temp-->0 == long_block && ~~updating) {
					! Make a copy of the closure, but don't add to its reference count
					temp = BlkValueCreateSB1(0, long_block);
				}
				if (updating && i < oldlocalscount) {
					WriteLIST_OF_TY_GetItem(localslist, i + 1, temp);
				}
				else {
					LIST_OF_TY_InsertItem(localslist, temp);
				}
			}
			! And finally at the routine stack
			count = ((frame_length - stackpos) / 4);
			for (i = 0: i < count: i++) {
				LIST_OF_TY_InsertItem(stacklist, DS_Read32(save_str));
			}
			! TODO: block values on stack
			break;
		}
		else {
			if (chunk_length % 2) {
				chunk_length++;
			}
			glk_stream_set_position(save_str, chunk_length, seekmode_Current);
		}
	}
	! Clean up
	glk_stream_close(save_str, 0);
	@mfree save_alloc;
];

Global CLOSURE_TY_Reenter_Addr;
Global CLOSURE_TY_Reenter_Index;
Global CLOSURE_TY_Reenter_Locals_Count;
Global CLOSURE_TY_Reenter_Locals_Data;
Global CLOSURE_TY_Reenter_Stack_Count;
Global CLOSURE_TY_Reenter_Stack_Data;
Global CLOSURE_TY_Reenter_Temp;
[ CLOSURE_TY_Reenter closure result resultkov parameter_count P1 P1kov P2 P2kov P3 P3kov	first_param P1copy P2copy P3copy resultval;
	! Check that this closure is initialised
	if (BlkValueRead(closure, CLOSURE_TY_ADDR) == 0) {
		return RESULT_TY_Set(result, 0, CLOSURE_TY_Reenter_Error);
	}
	CLOSURE_TY_Reenter_Addr = BlkValueRead(closure, CLOSURE_TY_ADDR);
	! Copy the locals list
	CLOSURE_TY_Reenter_Locals_Data = BlkValueCreate(CLOSURE_TY_Temp_List_Definition);
	BlkValueCopy(CLOSURE_TY_Reenter_Locals_Data, BlkValueRead(closure, CLOSURE_TY_LOCALS_DATA));
	BlkMakeMutable(CLOSURE_TY_Reenter_Locals_Data);
	CLOSURE_TY_Reenter_Locals_Count = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_LENGTH_F);
	CLOSURE_TY_Reenter_Stack_Data = BlkValueRead(closure, CLOSURE_TY_STACK_DATA);
	CLOSURE_TY_Reenter_Stack_Count = BlkValueRead(CLOSURE_TY_Reenter_Stack_Data, LIST_LENGTH_F);
	if (parameter_count) {
		first_param = BlkValueRead(closure, CLOSURE_TY_FIRST_PARAMETER);
		! Make our own copy of the parameter
		if (KOVIsBlockValue(P1kov)) {
			P1copy = BlkValueCreate(P1kov);
			BlkValueCopy(P1copy, P1);
			P1 = P1copy;
		}
		WriteLIST_OF_TY_GetItem(CLOSURE_TY_Reenter_Locals_Data, first_param + 1, P1);
		if (parameter_count > 1) {
			if (KOVIsBlockValue(P2kov)) {
				P2copy = BlkValueCreate(P2kov);
				BlkValueCopy(P2copy, P2);
				P2 = P2copy;
			}
			WriteLIST_OF_TY_GetItem(CLOSURE_TY_Reenter_Locals_Data, first_param + 2, P2);
			if (parameter_count > 2) {
				if (KOVIsBlockValue(P3kov)) {
					P3copy = BlkValueCreate(P3kov);
					BlkValueCopy(P3copy, P3);
					P3 = P3copy;
				}
				WriteLIST_OF_TY_GetItem(CLOSURE_TY_Reenter_Locals_Data, first_param + 3, P3);
			}
		}
	}
	resultval = CLOSURE_TY_Reenter_Inner();
	if (parameter_count) {
		if (KOVIsBlockValue(P1kov)) {
			BlkValueFree(P1copy);
		}
		if (parameter_count > 1) {
			if (KOVIsBlockValue(P2kov)) {
				BlkValueFree(P2copy);
			}
			if (parameter_count > 2) {
				if (KOVIsBlockValue(P3kov)) {
					BlkValueFree(P3copy);
				}
			}
		}
	}
	BlkValueFree(CLOSURE_TY_Reenter_Locals_Data);
	return RESULT_TY_Set(result, resultkov, resultval);
];
Array CLOSURE_TY_Reenter_Error --> CONSTANT_PACKED_TEXT_STORAGE "Cannot run an uninitialised Closure.";

[ CLOSURE_TY_Reenter_Inner l0 l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 l13 l14 l15 l16 l17 l18 l19;
	! Restore all the locals
	if (CLOSURE_TY_Reenter_Locals_Count > 0) {
		l0 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE);
		if (CLOSURE_TY_Reenter_Locals_Count > 1) {
			l1 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 1);
			if (CLOSURE_TY_Reenter_Locals_Count > 2) {
				l2 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 2);
				if (CLOSURE_TY_Reenter_Locals_Count > 3) {
					l3 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 3);
					if (CLOSURE_TY_Reenter_Locals_Count > 4) {
						l4 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 4);
						if (CLOSURE_TY_Reenter_Locals_Count > 5) {
							l5 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 5);
							if (CLOSURE_TY_Reenter_Locals_Count > 6) {
								l6 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 6);
								if (CLOSURE_TY_Reenter_Locals_Count > 7) {
									l7 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 7);
									if (CLOSURE_TY_Reenter_Locals_Count > 8) {
										l8 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 8);
										if (CLOSURE_TY_Reenter_Locals_Count > 9) {
											l9 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 9);
											if (CLOSURE_TY_Reenter_Locals_Count > 10) {
												l10 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 10);
												if (CLOSURE_TY_Reenter_Locals_Count > 11) {
													l11 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 11);
													if (CLOSURE_TY_Reenter_Locals_Count > 12) {
														l12 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 12);
														if (CLOSURE_TY_Reenter_Locals_Count > 13) {
															l13 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 13);
															if (CLOSURE_TY_Reenter_Locals_Count > 14) {
																l14 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 14);
																if (CLOSURE_TY_Reenter_Locals_Count > 15) {
																	l15 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 15);
																	if (CLOSURE_TY_Reenter_Locals_Count > 16) {
																		l16 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 16);
																		if (CLOSURE_TY_Reenter_Locals_Count > 17) {
																			l17 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 17);
																			if (CLOSURE_TY_Reenter_Locals_Count > 18) {
																				l18 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 18);
																				if (CLOSURE_TY_Reenter_Locals_Count > 19) {
																					l19 = BlkValueRead(CLOSURE_TY_Reenter_Locals_Data, LIST_ITEM_BASE + 19);
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	! Restore the stack
	for (CLOSURE_TY_Reenter_Index = 0: CLOSURE_TY_Reenter_Index < CLOSURE_TY_Reenter_Stack_Count: CLOSURE_TY_Reenter_Index++) {
		CLOSURE_TY_Reenter_Temp = BlkValueRead(CLOSURE_TY_Reenter_Stack_Data, LIST_ITEM_BASE + CLOSURE_TY_Reenter_Index);
		@push CLOSURE_TY_Reenter_Temp;
	}
	@jumpabs CLOSURE_TY_Reenter_Addr;
];

[ CLOSURE_TY_Preinitialise closure;
	! Check if we are writing to the default map, and if so make a new map
	if (BlkValueGetLongBlock(closure) == CLOSURE_TY_Default_LB) {
		print "Error! Cannot initialise a global Closure.^";
		rtrue;
	}
	! Check if closure has been initialised already
	if (BlkValueRead(closure, CLOSURE_TY_ADDR)) {
		print "Error! Cannot initialise a Closure twice.^";
		rtrue;
	}
	rfalse;
];

[ CLOSURE_TY_Say closure	addr;
	addr = BlkValueRead(closure, CLOSURE_TY_ADDR);
	if (addr) {
		print "Closure<", addr, ">";
	}
	else {
		print "Closure<Uninitialised>";
	}
];
-).



Chapter - Closures - Initialising and updating

To initialise (C - closure value of kind K -> value of kind L) with parameter (P1 - nonexisting K variable):
	(-
	if (CLOSURE_TY_Preinitialise({-by-reference:C})) {
		rfalse;
	}
	jump DS_Closure{-counter:DS_Closures}_Catch;
	.DS_Closure{-counter:DS_Closures}_Catch_Continue;
	@pull temporary_value;
	@pull temporary_value;
	! Write the address
	BlkValueWrite(BlkValueGetLongBlock({-by-reference:C}), CLOSURE_TY_ADDR, temporary_value, 1);
	! Clean up the rest of the call stub
	@pull temporary_value;
	@pull temporary_value;
	CLOSURE_TY_Initialise({-by-reference:C}, 1);
	rfalse;
	.DS_Closure{-counter:DS_Closures}_Catch;
	@catch temporary_value ?DS_Closure{-counter:DS_Closures}_Catch_Continue;
	! This lets us work out which local variable number the incoming parameter is
	@add {-by-reference:P1} 0 {-by-reference:P1};
	{-counter-up:DS_Closures}
	-).

To decide if (C - closure value of kind K -> value of kind L) is initialised:
	(- BlkValueRead({-by-reference:C}, CLOSURE_TY_ADDR) -).

[ Note that updating closures which save stack variables might not be safe if they've already been popped! ]
To update all local variables of (C - closure value of kind K -> value of kind L):
	(- if (BlkValueRead({-by-reference:C}, CLOSURE_TY_ADDR) == 0) {
		print "Error! Can only update closures which have already been initialised.^";
		rfalse;
	}
	CLOSURE_TY_Initialise({-by-reference:C}, 0, 1); -).



Chapter - Closures - Running

To decide what L result is (C - closure value of kind K -> value of kind L) applied to (P1 - K):
	(- CLOSURE_TY_Reenter({-by-reference:C}, {-new:L result}, {-strong-kind:L}, 1, {-by-reference:P1}, {-strong-kind:K}) -).



Chapter - Couples

[ We can't have variable length tuples, and also TUPLE is already an I7 kind, though it isn't useable.
It doesn't seem possible to make a triple - Inform seems to trip over kinds generic over three other kinds. ]

[ Couples have a ? word long block (ignoring the header).
Words 0-1: the kinds of the values
Words 2-3: the values ]

Include (-
! Static block values have three parts: the short block (0 means the long block follows immediately), the long block header, and the long block data.
! $050C0000 means a block of length 2^5=32 bytes, that is resident (static) and uses word values.
Array COUPLE_TY_Default --> 0	$050C0000 COUPLE_TY MAX_POSITIVE_NUMBER	0 0;

Constant COUPLE_TY_KOV_A = 0;
Constant COUPLE_TY_KOV_B = 1;
Constant COUPLE_TY_VALUE_A = 2;
Constant COUPLE_TY_VALUE_B = 3;

[ COUPLE_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return COUPLE_TY_Compare(arg1, arg2);
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return COUPLE_TY_Create(arg2);
		DESTROY_KOVS: COUPLE_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ COUPLE_TY_Compare c1 c2	cf delta;
	! Equal long blocks means these are the same
	if (BlkValueGetLongBlock(c1) == BlkValueGetLongBlock(c2)) {
		return 0;
	}
	! Default values
	if (c1 == COUPLE_TY_Default || c2 == COUPLE_TY_Default) {
		return BlkValueRead(c1, COUPLE_TY_KOV_A) - BlkValueRead(c2, COUPLE_TY_KOV_A);
	}
	! Compare the first values
	cf = KOVComparisonFunction(BlkValueRead(c1, COUPLE_TY_KOV_A));
	if (cf == 0 or UnsignedCompare) {
		delta = BlkValueRead(c1, COUPLE_TY_VALUE_A) - BlkValueRead(c2, COUPLE_TY_VALUE_A);
	}
	else {
		delta = cf(BlkValueRead(c1, COUPLE_TY_VALUE_A), BlkValueRead(c2, COUPLE_TY_VALUE_A));
	}
	if (delta) {
		return delta;
	}
	! Compare the second values
	cf = KOVComparisonFunction(BlkValueRead(c1, COUPLE_TY_KOV_B));
	if (cf == 0 or UnsignedCompare) {
		delta = BlkValueRead(c1, COUPLE_TY_VALUE_B) - BlkValueRead(c2, COUPLE_TY_VALUE_B);
	}
	else {
		delta = cf(BlkValueRead(c1, COUPLE_TY_VALUE_B), BlkValueRead(c2, COUPLE_TY_VALUE_B));
	}
	return delta;
];

[ COUPLE_TY_Create short_block	long_block;
	long_block = FlexAllocate(4 * WORDSIZE, COUPLE_TY, BLK_FLAG_WORD);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ COUPLE_TY_Destroy couple;
	if (KOVIsBlockValue(BlkValueRead(couple, COUPLE_TY_KOV_A))) {
		BlkValueFree(BlkValueRead(couple, COUPLE_TY_VALUE_A));
	}
	if (KOVIsBlockValue(BlkValueRead(couple, COUPLE_TY_KOV_B))) {
		BlkValueFree(BlkValueRead(couple, COUPLE_TY_VALUE_B));
	}
];

[ COUPLE_TY_Distinguish c1 c2;
	if (COUPLE_TY_Compare(c1, c2) == 0) rfalse;
	rtrue;
];

[ COUPLE_TY_Get couple index backup;
	! Check if this any is a default
	if (couple == COUPLE_TY_Default) {
		return backup;
	}
	return BlkValueRead(couple, index);
];

[ COUPLE_TY_Say couple	kov;
	if (couple == COUPLE_TY_Default) {
		print "(Uninitialised Couple)";
		return;
	}
	print "(";
	PrintKindValuePair(BlkValueRead(couple, COUPLE_TY_KOV_A), BlkValueRead(couple, COUPLE_TY_VALUE_A));
	print ", ";
	PrintKindValuePair(BlkValueRead(couple, COUPLE_TY_KOV_B), BlkValueRead(couple, COUPLE_TY_VALUE_B));
	print ")";
];

[ COUPLE_TY_Set couple kov1 value1 kov2 value2	long_block valcopy;
	! Check this Couple hasn't been set before
	if (BlkValueRead(couple, COUPLE_TY_KOV_A) ~= 0) {
		print "Error! Cannot set a Couple twice!^";
		return couple;
	}
	! Write to the long block directly, without copy-on-write semantics
	long_block = BlkValueGetLongBlock(couple);
	BlkValueWrite(long_block, COUPLE_TY_KOV_A, kov1, 1);
	BlkValueWrite(long_block, COUPLE_TY_KOV_B, kov2, 1);
	! Make our own copy of the value
	if (KOVIsBlockValue(kov1)) {
		valcopy = BlkValueCreate(kov1);
		BlkValueCopy(valcopy, value1);
		value1 = valcopy;
	}
	BlkValueWrite(long_block, COUPLE_TY_VALUE_A, value1, 1);
	! Make our own copy of the value
	if (KOVIsBlockValue(kov2)) {
		valcopy = BlkValueCreate(kov2);
		BlkValueCopy(valcopy, value2);
		value2 = valcopy;
	}
	BlkValueWrite(long_block, COUPLE_TY_VALUE_B, value2, 1);
	return couple;
];
-).

To decide what couple of K and L is (V1 - value of kind K) and (V2 - value of kind L) as a couple:
	(- COUPLE_TY_Set({-new:couple of K and L}, {-strong-kind:K}, {-by-reference:V1}, {-strong-kind:L}, {-by-reference:V2}) -).

To decide what K is first value of (C - couple of value of kind K and value of kind L):
	(- COUPLE_TY_Get({-by-reference:C}, COUPLE_TY_VALUE_A, {-new:K}) -).

To decide what L is second value of (C - couple of value of kind K and value of kind L):
	(- COUPLE_TY_Get({-by-reference:C}, COUPLE_TY_VALUE_B, {-new:L}) -).

To decide what K is (C - couple of value of kind K and value of kind L) => 1:
	(- COUPLE_TY_Get({-by-reference:C}, COUPLE_TY_VALUE_A, {-new:K}) -).

To decide what L is (C - couple of value of kind K and value of kind L) => 2:
	(- COUPLE_TY_Get({-by-reference:C}, COUPLE_TY_VALUE_B, {-new:L}) -).



Section - Unit tests (for use with Unit Tests by Zed Lopez) (not for release) (unindexed)

Data Structures Couples is a unit test. "Data Structures: Couples"

Data Structures Couples is heap tracking.

Test global couple is a (couple of text and number) that varies.

To decide what couple of text and list of numbers is test returning a couple from a phrase:
	decide on "Hello world!" and {1234} as a couple;

For testing data structures couples:
	for "Default couple saying" assert "[test global couple]" is "(Uninitialised Couple)";
	for "Default couple first value" assert first value of test global couple is "";
	for "Default couple second value" assert second value of test global couple is 0;
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

[ Maps have a two word long block (ignoring the header).
Word 0: list of keys
Word 1: list of values ]

Include (-
! Static long blocks have two parts: the long block header, and the long block data.
! $050C0000 means a block of length 2^5=32 bytes, that is resident (static) and uses word values.
Array MAP_TY_Default_LB --> $050C0000 MAP_TY MAX_POSITIVE_NUMBER	MAP_TY_Default_List MAP_TY_Default_List;
! And a static list, to be used for both the keys and values - it doesn't matter as we'll prevent it ever being written to.
! $051C0000 means a block of length 2^5=32 byes, that is resident (static), uses word values, and sets BLK_FLAG_TRUNCMULT... I'm not sure what that does, but it's how I7 compiles global lists.
Array MAP_TY_Default_List --> 0	$051C0000 LIST_OF_TY MAX_POSITIVE_NUMBER	NUMBER_TY 0 0;

[ MAP_TY_Support task arg1 arg2 arg3;
	switch(task) {
		COMPARE_KOVS: return Data_Structures_Compare_Common(arg1, arg2);
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return MAP_TY_Create(arg1, arg2);
		DESTROY_KOVS: MAP_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

Constant MAP_TY_KEYS = 0;
Constant MAP_TY_VALUES = 1;

Array MAP_TY_Temp_List_Definition --> LIST_OF_TY 1 ANY_TY;

[ MAP_TY_Clone skov oldmap newmap;
	newmap = MAP_TY_Create(skov, 0);
	! Copy the lists. The lists code will handle cloning themselves the first time one is written to.
	BlkValueCopy(BlkValueRead(newmap, MAP_TY_KEYS), BlkValueRead(oldmap, MAP_TY_KEYS));
	BlkValueCopy(BlkValueRead(newmap, MAP_TY_VALUES), BlkValueRead(oldmap, MAP_TY_VALUES));
	return newmap;
];

[ MAP_TY_Create skov short_block	long_block;
	long_block = FlexAllocate(2 * WORDSIZE, MAP_TY, BLK_FLAG_WORD);
	MAP_TY_Temp_List_Definition-->2 = KindBaseTerm(skov, 0);
	BlkValueWrite(long_block, MAP_TY_KEYS, BlkValueCreate(MAP_TY_Temp_List_Definition), 1);
	MAP_TY_Temp_List_Definition-->2 = KindBaseTerm(skov, 1);
	BlkValueWrite(long_block, MAP_TY_VALUES, BlkValueCreate(MAP_TY_Temp_List_Definition), 1);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ MAP_TY_Create_From short_block keys vals	long_block;
	! TODO: check keys and vals lengths are equal
	long_block = FlexAllocate(2 * WORDSIZE, MAP_TY, BLK_FLAG_WORD);
	BlkValueWrite(long_block, MAP_TY_KEYS, keys, 1);
	BlkValueWrite(long_block, MAP_TY_VALUES, vals, 1);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ MAP_TY_Delete_Key map key keyany keykind	cf i keyslist length;
	if (keyany && keykind ~= ANY_TY) {
		key = ANY_TY_Set(keyany, keykind, key);
	}
	keyslist = BlkValueRead(map, MAP_TY_KEYS);
	cf = KOVComparisonFunction(BlkValueRead(keyslist, LIST_ITEM_KOV_F));
	if (cf == 0) {
		cf = UnsignedCompare;
	}
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	for (i = 0: i < length; i++) {
		if (cf(key, BlkValueRead(keyslist, LIST_ITEM_BASE + i)) == 0) {
			LIST_OF_TY_RemoveItemRange(keyslist, i + 1, i + 1);
			LIST_OF_TY_RemoveItemRange(BlkValueRead(map, MAP_TY_VALUES), i + 1, i + 1);
			return;
		}
	}
];

[ MAP_TY_Destroy map;
	BlkValueFree(BlkValueRead(map, MAP_TY_KEYS));
	BlkValueFree(BlkValueRead(map, MAP_TY_VALUES));
];

[ MAP_TY_Get_Key map key keyany keykind checked_bv backup or	cf i keyskov keyslist length res valslist;
	if (keyany && keykind ~= ANY_TY) {
		key = ANY_TY_Set(keyany, keykind, key);
	}
	keyslist = BlkValueRead(map, MAP_TY_KEYS);
	valslist = BlkValueRead(map, MAP_TY_VALUES);
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

[ MAP_TY_Has_Key map key keyany keykind	cf i keyslist length;
	if (keyany && keykind ~= ANY_TY) {
		key = ANY_TY_Set(keyany, keykind, key);
	}
	keyslist = BlkValueRead(map, MAP_TY_KEYS);
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

[ MAP_TY_Set_Key map mapkov key keyany keykind val valany valkind	cf i keyslist kov length temp valslist;
	! Check if we are writing to the default map, and if so make a new map
	if (BlkValueGetLongBlock(map) == MAP_TY_Default_LB) {
		temp = MAP_TY_Create(mapkov);
		BlkValueCopy(map, temp);
		BlkValueFree(temp);
	}
	if (keyany && keykind ~= ANY_TY) {
		key = ANY_TY_Set(keyany, keykind, key);
	}
	if (valany && valkind ~= ANY_TY) {
		val = ANY_TY_Set(valany, valkind, val);
	}
	keyslist = BlkValueRead(map, MAP_TY_KEYS);
	valslist = BlkValueRead(map, MAP_TY_VALUES);
	cf = KOVComparisonFunction(BlkValueRead(keyslist, LIST_ITEM_KOV_F));
	if (cf == 0) {
		cf = UnsignedCompare;
	}
	length = BlkValueRead(keyslist, LIST_LENGTH_F);
	for (i = 0: i < length; i++) {
		if (cf(key, BlkValueRead(keyslist, LIST_ITEM_BASE + i)) == 0) {
			! Updating existing key
			LIST_OF_TY_RemoveItemRange(valslist, i + 1, i + 1);
			! Make our own copy of the value
			kov = BlkValueRead(valslist, LIST_ITEM_KOV_F);
			if (KOVIsBlockValue(kov)) {
				temp = BlkValueCreate(kov);
				BlkValueCopy(temp, val);
				val = temp;
			}
			LIST_OF_TY_InsertItem(valslist, val, 1, i + 1);
			return;
		}
	}
	! New key
	! Make our own copy of the key
	kov = BlkValueRead(keyslist, LIST_ITEM_KOV_F);
	if (KOVIsBlockValue(kov)) {
		temp = BlkValueCreate(kov);
		BlkValueCopy(temp, key);
		key = temp;
	}
	LIST_OF_TY_InsertItem(keyslist, key);
	! Make our own copy of the value
	kov = BlkValueRead(valslist, LIST_ITEM_KOV_F);
	if (KOVIsBlockValue(kov)) {
		temp = BlkValueCreate(kov);
		BlkValueCopy(temp, val);
		val = temp;
	}
	LIST_OF_TY_InsertItem(valslist, val);
];

[ MAP_TY_Say map	i keyskov keyslist length valskov valslist;
	keyslist = BlkValueRead(map, MAP_TY_KEYS);
	valslist = BlkValueRead(map, MAP_TY_VALUES);
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

[To decide which map of value of kind K to value of kind L is new/-- map from (keys - list of values of kind K) and/to (vals - list of values of kind L):
	(- MAP_TY_Create_From({-new:map of K to L}, {-by-reference:K}, {-by-reference:L}) -);]

To decide which map of value of kind K to value of kind L is clone of (M - map of value of kind K to value of kind L):
	(- MAP_TY_Clone({-strong-kind:map of K to L}, {-by-reference:M}, {-new:map of K to L}) -).



Chapter - Maps - Writing

To set key (key - K) in/of (M - map of value of kind K to value of kind L) to/= (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of K to L}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

To set key (key - K) in/of (M - map of value of kind K to any) to/= (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of K to any}, {-by-reference:key}, 0, 0, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).

To set key (key - value of kind K) in/of (M - map of any to value of kind L) to/= (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of any to L}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}); -).

To set key (key - value of kind K) in/of (M - map of any to any) to/= (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of any to any}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).

To (M - map of value of kind K to value of kind L) => (key - K) = (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of K to L}, {-by-reference:key}, 0, 0, {-by-reference:val}); -).

To (M - map of value of kind K to any) => (key - K) = (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of K to any}, {-by-reference:key}, 0, 0, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).

To (M - map of any to value of kind L) => (key - value of kind K) = (val - L):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of any to L}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}); -).

To (M - map of any to any) => (key - value of kind K) = (val - value of kind V):
	(- MAP_TY_Set_Key({-by-reference:M}, {-strong-kind:map of any to any}, {-by-reference:key}, {-new:any}, {-strong-kind:K}, {-by-reference:val}, {-new:any}, {-strong-kind:V}); -).



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
		{-my:3} = BlkValueRead({-by-reference:M}, MAP_TY_KEYS);
		{-my:2} = BlkValueRead({-my:3}, LIST_LENGTH_F);
		{-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE + {-my:1}))
	-).

To repeat with (val - nonexisting L variable) in/from/of (M - map of value of kind K to value of kind L) values begin -- end loop:
	(-
		{-my:3} = BlkValueRead({-by-reference:M}, MAP_TY_VALUES);
		{-my:2} = BlkValueRead({-my:3}, LIST_LENGTH_F);
		{-lvalue-by-reference:val} = BlkValueRead({-my:3}, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:val} = BlkValueRead({-my:3}, LIST_ITEM_BASE + {-my:1}))
	-).

To repeat with (key - nonexisting K variable) and/to/=> (val - nonexisting L variable) in/from/of (M - map of value of kind K to value of kind L) begin -- end loop:
	(-
		{-my:4} = BlkValueRead({-by-reference:M}, MAP_TY_VALUES);
		{-my:3} = BlkValueRead({-by-reference:M}, MAP_TY_KEYS);
		{-my:2} = BlkValueRead({-my:3}, LIST_LENGTH_F);
		{-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE);
		{-lvalue-by-reference:val} = BlkValueRead({-my:4}, LIST_ITEM_BASE);
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1}++, {-lvalue-by-reference:key} = BlkValueRead({-my:3}, LIST_ITEM_BASE + {-my:1}), {-lvalue-by-reference:val} = BlkValueRead({-my:4}, LIST_ITEM_BASE + {-my:1}))
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
	! Equal long blocks means these are the same
	if (BlkValueGetLongBlock(opt1) == BlkValueGetLongBlock(opt2)) {
		return 0;
	}
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

To decide what K option is (name of kind of value K) none option:
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

Data Structures Options is heap tracking.

Test global option is a text option that varies.
Persons have a number option called test property option.

To decide what text option is test returning a text option from a phrase:
	decide on "Hello world!" as an option;

For testing data structures options:
	[ Test default/none options ]
	let NoneOption be a number option;
	for "Default options are none" assert NoneOption is none;
	for "Default options are not some" refute NoneOption is some;
	for "Saying default option" assert "[NoneOption]" is "None";
	for "Default value of global option" assert test global option is a text none option;
	for "Default value of property option" assert test property option of yourself is a number none option;
	[increase pre-test heap usage by 84;]
	for "Get value of none option unchecked shows error" assert "[the value of NoneOption unchecked]" is "Error! Trying to extract value from a none option.[line break]0";
	for "Get value of none option with backup" assert value of NoneOption or 6789 is 6789;
	if NoneOption is some let NoneOptionValue be the value:
		for "Option<none> let V be the value" fail;
	otherwise:
		for "Option<none> let V be the value" pass;
	[ Test basic functionality with a number option ]
	let NumOption be 1234 as an option;
	for "Option<number> is some" assert NumOption is some;
	for "Option<number> is not none" refute NumOption is none;
	for "Option<number> equality" assert NumOption is 1234 as an option;
	for "Option<number> with backup" assert value of NumOption or 6789 is 1234;
	if NumOption is some let NumOptionValue be the value:
		for "Option<number> let V be the value" assert NumOptionValue is 1234;
	otherwise:
		for "Option<number> let V be the value" fail;
	for "Option<number> value unchecked" assert the value of NumOption unchecked is 1234;
	[ Test options with with block values with a text option ]
	let TextOption be "Hello world!" as an option;
	for "Option<text> is some" assert TextOption is some;
	for "Option<text> is not none" refute TextOption is none;
	for "Option<text> equality" assert TextOption is "Hello world!" as an option;
	for "Option<text> with backup" assert value of TextOption or "Goodbye" is "Hello world!";
	if TextOption is some let TextOptionValue be the value:
		for "Option<text> let V be the value" assert TextOptionValue is "Hello world!";
	otherwise:
		for "Option<text> let V be the value" fail;
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
		COMPARE_KOVS: return Data_Structures_Compare_Common(arg1, arg2);
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
	else if (BlkValueRead(result, RESULT_TY_VALUE)) {
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
	if (BlkValueRead(result, RESULT_TY_VALUE)) {
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
		return RESULT_TY_Set(returnresult, NULL_TY, 0);
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
	(- PROMISE_TY_Resolve({-by-reference:P}, RESULT_TY_Set({-new:K result}, {-strong-kind:K}, {-by-reference:val}), {-strong-kind:K result}, {-new:null result}) -).

To decide what K promise is (val - value of kind K) as a successful/-- promise:
	(- PROMISE_TY_Resolve({-new:K promise}, RESULT_TY_Set({-new:K result}, {-strong-kind:K}, {-by-reference:val}), {-strong-kind:K result}) -).

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

To attach failure handler/-- (H - a text based rulebook) to (P - a value of kind K promise):
	(- PROMISE_TY_Add_Handler({-by-reference:P}, ANY_TY_Set({-new:any}, RULEBOOK_TY, {-by-reference:H})); -).



Chapter - Results

[ Results have a two word long block (ignoring the header).
Word 0: the kind of the value, or 0 for none
Word 1: the value or error message ]

Include (-
! Static block values have three parts: the short block (0 means the long block follows immediately), the long block header, and the long block data.
! $050C0000 means a block of length 2^5=32 bytes, that is resident (static) and uses word values.
Array RESULT_TY_Default --> 0	$050C0000 RESULT_TY MAX_POSITIVE_NUMBER	0 RESULT_TY_Default_Message;
! Make this a function text so that it will be compared properly - two packed texts will be compared by address not contents.
Array RESULT_TY_Default_Message --> CONSTANT_PERISHABLE_TEXT_STORAGE RESULT_TY_Default_Message_fn;
[ RESULT_TY_Default_Message_fn;
	print "Uninitialised result";
];

Constant RESULT_TY_KOV = 0;
Constant RESULT_TY_VALUE = 1;

[ RESULT_TY_Support task arg1 arg2;
	switch(task) {
		COMPARE_KOVS: return RESULT_TY_Compare(arg1, arg2);
		COPYQUICK_KOVS: rtrue;
		COPYSB_KOVS: BlkValueCopySB1(arg1, arg2);
		CREATE_KOVS: return RESULT_TY_Create(arg2);
		DESTROY_KOVS: RESULT_TY_Destroy(arg1);
	}
	! We don't respond to the other tasks
	rfalse;
];

[ RESULT_TY_Compare res1 res2	cf delta res1kov;
	! Equal long blocks means these are the same
	if (BlkValueGetLongBlock(res1) == BlkValueGetLongBlock(res2)) {
		return 0;
	}
	res1kov = BlkValueRead(res1, RESULT_TY_KOV);
	! First check if one is okay and the other is error
	delta = (BlkValueRead(res2, RESULT_TY_KOV) == 0) - (res1kov == 0);
	if (delta) {
		return delta;
	}
	! Then compare the contents
	if (res1kov) {
		cf = KOVComparisonFunction(res1kov);
	}
	else {
		cf = BlkValueCompare;
	}
	if (cf == 0 or UnsignedCompare) {
		return BlkValueRead(res1, RESULT_TY_VALUE) - BlkValueRead(res2, RESULT_TY_VALUE);
	}
	else {
		return cf(BlkValueRead(res1, RESULT_TY_VALUE), BlkValueRead(res2, RESULT_TY_VALUE));
	}
];

[ RESULT_TY_Create short_block	long_block;
	long_block = FlexAllocate(2 * WORDSIZE, RESULT_TY, BLK_FLAG_WORD);
	short_block = BlkValueCreateSB1(short_block, long_block);
	return short_block;
];

[ RESULT_TY_Destroy result	kov;
	kov = BlkValueRead(result, RESULT_TY_KOV);
	if (kov == 0 || KOVIsBlockValue(kov)) {
		BlkValueFree(BlkValueRead(result, RESULT_TY_VALUE));
	}
];

[ RESULT_TY_Distinguish opt1 opt2;
	if (RESULT_TY_Compare(opt1, opt2) == 0) rfalse;
	rtrue;
];

[ RESULT_TY_Get result get_okay backup or	kov;
	kov = BlkValueRead(result, RESULT_TY_KOV);
	if (kov) {
		if (get_okay) {
			return BlkValueRead(result, RESULT_TY_VALUE);
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
	return BlkValueRead(result, RESULT_TY_VALUE);
];

[ RESULT_TY_Say result	kov;
	kov = BlkValueRead(result, RESULT_TY_KOV);
	if (kov) {
		print "Ok(";
		PrintKindValuePair(kov, BlkValueRead(result, RESULT_TY_VALUE));
		print ")";
	}
	else {
		print "Error(";
		print (TEXT_TY_Say) BlkValueRead(result, RESULT_TY_VALUE);
		print ")";
	}
];

[ RESULT_TY_Set result kov value	long_block valcopy;
	! Check this Result hasn't been set before
	if (BlkValueRead(result, RESULT_TY_KOV) || ~~(BlkValueRead(result, RESULT_TY_VALUE) == 0 or RESULT_TY_Default_Message)) {
		print "Error! Cannot set a Result twice!^";
		return result;
	}
	! Write to the long block directly, without copy-on-write semantics
	long_block = BlkValueGetLongBlock(result);
	BlkValueWrite(long_block, RESULT_TY_KOV, kov, 1);
	! Make our own copy of the value
	if (KOVIsBlockValue(kov)) {
		valcopy = BlkValueCreate(kov);
		BlkValueCopy(valcopy, value);
		value = valcopy;
	}
	BlkValueWrite(long_block, RESULT_TY_VALUE, value, 1);
	return result;
];
-).

To decide what K result is (V - value of kind K) as a/an ok/okay/-- result:
	(- RESULT_TY_Set({-new:K result}, {-strong-kind:K}, {-by-reference:V}) -).

To decide what K result is (name of kind of value K) error result with message (M - text):
	(- RESULT_TY_Set({-new:K result}, 0, {-by-reference:M}) -).

To decide if (R - a value result) is ok/okay:
	(- (BlkValueRead({-by-reference:R}, RESULT_TY_KOV)) -).

[ We declare this as a loop, even though it isn't, because nonexisting variables don't seem to be unassigned at the end of conditionals. ]
To if (R - value of kind K result) is ok/okay let (V - nonexisting K variable) be the value begin -- end loop:
	(- if (BlkValueRead({-by-reference:R}, RESULT_TY_KOV) && (
		(KOVIsBlockValue({-strong-kind:K})
			&& BlkValueCopy({-lvalue-by-reference:V}, RESULT_TY_Get({-by-reference:R}, 1))
			|| ({-lvalue-by-reference:V} = RESULT_TY_Get({-by-reference:R}, 1))
		)
	, 1)) -).

To decide if (R - a value result) is an/-- error:
	(- (BlkValueRead({-by-reference:R}, RESULT_TY_KOV) == 0) -).

To if (R - value result) is an/-- error let (V - nonexisting text variable) be the error message begin -- end loop:
	(- if ((BlkValueRead({-by-reference:R}, RESULT_TY_KOV) == 0) && BlkValueCopy({-lvalue-by-reference:V}, RESULT_TY_Get({-by-reference:R}))) -).

To decide what K is value of (R - value of kind K result) or (backup - K):
	(- RESULT_TY_Get({-by-reference:R}, 1, {-by-reference:backup}, 1) -).



Section - Unit tests (for use with Unit Tests by Zed Lopez) (not for release) (unindexed)

Data Structures Results is a unit test. "Data Structures: Results"

Data Structures Results is heap tracking.

Test global result is a text result that varies.
Persons have a number result called test property result.

To decide what text result is test returning a text result from a phrase:
	decide on "Hello world!" as a result;

For testing data structures results:
	[ Test default/none results ]
	let DefaultResult be a number result;
	for "Default results are error" assert DefaultResult is an error;
	for "Default results are not okay" refute DefaultResult is okay;
	for "Saying default result" assert "[DefaultResult]" is "Error()";
	for "Default value of global result" assert test global result is a text error result with message "Uninitialised result";
	for "Default value of property result" assert test property result of yourself is a number error result with message "Uninitialised result";
	let ErrorResult be a number error result with message "Test error result";
	for "Result<number> (error) saying" assert "[ErrorResult]" is "Error(Test error result)";
	if ErrorResult is an error let ErrorResultValue be the error message:
		for "Result<number> (error) let V be the error message" assert ErrorResultValue is "Test error result";
	otherwise:
		for "Result<number> (error) let V be the error message" fail;
	for "Get value of none result unchecked shows errors" assert "[the value of DefaultResult unchecked]" is "Error! Trying to extract value from an error result.[line break]0";
	for "Get value of none result with backup" assert value of DefaultResult or 6789 is 6789;
	[ Test basic functionality with a number result ]
	let NumResult be 1234 as an result;
	for "Result<number> is okay" assert NumResult is okay;
	for "Result<number> is not an error" refute NumResult is an error;
	for "Result<number> equality" assert NumResult is 1234 as an result;
	for "Result<number> with backup" assert value of NumResult or 6789 is 1234;
	if NumResult is okay let NumResultValue be the value:
		for "Result<number> let V be the value" assert NumResultValue is 1234;
	otherwise:
		for "Result<number> let V be the value" fail;
	for "Result<number> value unchecked" assert the value of NumResult unchecked is 1234;
	[ Test results with with block values with a text result ]
	let TextResult be "Hello world!" as an result;
	for "Result<text> is okay" assert TextResult is okay;
	for "Result<text> is not an error" refute TextResult is an error;
	for "Result<text> equality" assert TextResult is "Hello world!" as an result;
	for "Result<text> with backup" assert value of TextResult or "Goodbye" is "Hello world!";
	if TextResult is okay let TextResultValue be the value:
		for "Result<text> let V be the value" assert TextResultValue is "Hello world!";
	otherwise:
		for "Result<text> let V be the value" fail;
	for "Result<text> value unchecked" assert the value of TextResult unchecked is "Hello world!";
	for "Result<text> returned from phrase" assert test returning a text result from a phrase is "Hello world!" as an result;
	[ Test comparison operators ]
	for "Result<number> > comparison" assert 1234 as an result > 1233 as an result;
	for "Result<number> < comparison" assert 1234 as an result < 1235 as an result;
	for "Result<text> > comparison" assert "Hello" as an result > "Apple" as an result;
	for "Result<text> < comparison" assert "Hello" as an result < "Zoo" as an result;
	for "Result<Error> > comparison" assert a number error result with message "Hello" > a number error result with message "Apple";
	for "Result<Error> < comparison" assert a number error result with message "Hello" < a number error result with message "Zoo";



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
	(- PROMISE_TY_Resolve({-by-reference:P}, RESULT_TY_Set({-new:K result}, {-strong-kind:K}, {-by-reference:R}), {-strong-kind:K result}); -).

To decide what K is value of (R - value of kind K result) unchecked:
	(- RESULT_TY_Get({-by-reference:R}, 1, {-new:K}) -).

To decide what text is error message of (R - a value result) unchecked:
	(- RESULT_TY_Get({-by-reference:R}) -).



Chapter - Extra unit tests (for use with Unit Tests by Zed Lopez) (not for release) (unindexed)

Data Structures Globals is a unit test. "Data Structures: Globals"

To set test global any to text:
	now test global any is substituted form of "[1234]" as an any;

To set test global couple:
	now test global couple is substituted form of "[1234]" and 7890 as a couple;

To set test global option:
	now test global option is substituted form of "[1234]" as an option;

To set test global result:
	now test global result is substituted form of "[1234]" as a result;

To decide what text result is test returning a text result from a phrase:
	decide on "Hello world!" as a result;

For testing data structures globals:
	set test global any to text;
	for "Anys correctly copy and reference count their values" assert test global any is "1234" as an any;
	set test global couple;
	for "Couples correctly copy and reference count their values" assert test global couple is "1234" and 7890 as a couple;
	set test global option;
	for "Options correctly copy and reference count their values" assert test global option is "1234" as an option;
	set test global result;
	for "Results correctly copy and reference count their values" assert test global result is "1234" as an result;



Data Structures ends here.