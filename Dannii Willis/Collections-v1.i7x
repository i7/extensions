Version 1.3 of Collections (for Glulx only) by Dannii Willis begins here.

"Provides support for array and map data structures"

[Supported releases: 6M62]

Use authorial modesty.



Chapter - Collection references

[A collection reference is a pointer to a malloced structure.]
A collection reference is a kind of value.
Collection reference 0 specifies a collection reference.
The specification of a collection reference is "A reference to a collection value. Collection values cannot be manipulated directly, but must be accessed only through the Collections phrases."

[Fake kinds of values for special types of collection values.]
A collection error is a kind of value.
Collection error 0 specifies a collection error.
An array is a kind of value.
Array 0 specifies an array.
A map is a kind of value.
Map 0 specifies a map.

To decide which collection reference is a/-- new/-- collection value (name of kind of sayable value K):
	(- Collections_Create({-printing-routine:K}, {-new:K}) -).
To decide which collection reference is a/-- new/-- collection value (V - sayable value of kind K):
	(- Collections_Create({-printing-routine:K}, {-by-reference:V}) -).
To decide which collection reference is a/-- new/empty array:
	(- Collections_Create(Collections_ID_Array) -).

To say kind/type of (R - collection reference):
	(- Collections_Print_Type(Collections_Get_Type({R}), 0); -).

To decide if kind/type of (R - collection reference) is (name of kind of sayable value K):
	(- (Collections_Get_Type({R}) == {-printing-routine:K}) -).

To decide if (R1 - collection reference) equals/matches/=/== (R2 - collection reference):
	(- Collections_Check_Equals({R1}, {R2}) -).

To decide what K is (R - collection reference) as a/an (name of kind of sayable value K):
	(- Collections_Read({-printing-routine:K}, {R}) -).
To let (T  - nonexisting text variable) be (R - collection reference) as a text:
	(- {-lvalue-by-reference:T} = Collections_Read(Collections_ID_Text, {R}); -).
To let (L - nonexisting list of collection references variable) be (R - collection reference) as a list:
	(- {-lvalue-by-reference:L} = Collections_Read(Collections_ID_Array, {R}, 1); -).

To set (R - collection reference) to/= (V - sayable value of kind K):
	(- Collections_Write({-printing-routine:K}, {R}, {-by-reference:V}); -).
To (R - collection reference) = (V - sayable value of kind K):
	(- Collections_Write({-printing-routine:K}, {R}, {-by-reference:V}); -).

To say (R - collection reference):
	(- Collections_Print({R}); -).

To destroy/deallocate (R - collection reference):
	(- Collections_Destroy({R}); -).



Section - unindexed

Include (-
Global Collections_ID_Array;
Global Collections_ID_ColRef;
Global Collections_ID_Error;
Global Collections_ID_Map;
Global Collections_ID_Text;
-) after "Definitions.i6t".

To set Collections_ID_Array to (name of kind of sayable value K):
	(- Collections_ID_Array = {-printing-routine:K}; -).
To set Collections_ID_ColRef to (name of kind of sayable value K):
	(- Collections_ID_ColRef = {-printing-routine:K}; -).
To set Collections_ID_Error to (name of kind of sayable value K):
	(- Collections_ID_Error = {-printing-routine:K}; -).
To set Collections_ID_Map to (name of kind of sayable value K):
	(- Collections_ID_Map = {-printing-routine:K}; -).
To set Collections_ID_Text to (name of kind of sayable value K):
	(- Collections_ID_Text = {-printing-routine:K}; -).

Before starting the virtual machine (this is the setting collections IDs rule):
	set Collections_ID_Array to array;
	set Collections_ID_ColRef to collection reference;
	set Collections_ID_Error to collection error;
	set Collections_ID_Map to map;
	set Collections_ID_Text to text;

[ We need to get a reference to KD0_list_of_collection_references (but it could be named differently), so this is a list one dimension higher than the real ones are. ]
Template array is a list of list of collection references variable.

Include (-
[ Collections_Check_Equals ref1 ref2 type1 type2;
	type1 = Collections_Get_Type(ref1);
	type2 = Collections_Get_Type(ref2);
	if (type1 ~= type2) {
		rfalse;
	}
	if (type1 == Collections_ID_Text) {
		return TEXT_TY_Replace_RE(CHR_BLOB, ref1-->1, ref2-->1, 0, 0, 1);
	}
	return ref1-->1 == ref2-->1;
];

[ Collections_Check_Type type ref reftype;
	reftype = Collections_Get_Type(ref);
	if (reftype == type) {
		rfalse;
	}
	print "Collection type mismatch: expected ";
	Collections_Print_Type(type, 0);
	print ", got ";
	Collections_Print_Type(reftype, Collections_Get_Value(ref));
	print "^";
	rtrue;
];

[ Collections_Create type value ref;
	if (type == Collections_ID_Error) {
		return 0;
	}
	@malloc 8 ref;
	ref-->0 = type;
	if (type == Collections_ID_Text) {
		ref-->1 = BlkValueCreate(TEXT_TY);
		if (value) {
			BlkValueCopy(ref-->1, value);
		}
	}
	else if (type == Collections_ID_Array or Collections_ID_Map) {
		ref-->1 = BlkValueCreate(BlkValueRead((+ template array +), LIST_ITEM_KOV_F));
	}
	else {
		ref-->1 = value;
	}
	return ref;
];

[ Collections_Destroy ref i inner length;
	if (ref == 0) {
		rfalse;
	}
	inner = ref-->1;
	if (ref-->0 == Collections_ID_Text) {
		BlkValueFree(inner);
	}
	else if (ref-->0 == Collections_ID_Array or Collections_ID_Map) {
		length = BlkValueRead(inner, LIST_LENGTH_F);
		for (i = 0: i < length: i++) {
			Collections_Destroy(BlkValueRead(inner, i + LIST_ITEM_BASE));
		}
		BlkValueFree(inner);
	}
	@mfree ref;
];

[ Collections_Get_Type ref;
	if (ref == 0) {
		return Collections_ID_Error;
	}
	return ref-->0;
];

[ Collections_Get_Value ref;
	if (ref == 0) {
		return 0;
	}
	return ref-->1;
];

[ Collections_Print ref i length type val;
	type = Collections_Get_Type(ref);
	if (type == Collections_ID_Error) {
		print "Collection error";
	}
	else if (type == Collections_ID_Array) {
		val = ref-->1;
		length = BlkValueRead(val, LIST_LENGTH_F);
		print "[";
		for (i = 0: i < length: i++) {
			Collections_Print(BlkValueRead(val, i + LIST_ITEM_BASE));
			if (i < length - 1) print ", ";
		}
		print "]";
	}
	else if (type == Collections_ID_Map) {
		val = ref-->1;
		length = BlkValueRead(val, LIST_LENGTH_F);
		print "{";
		for (i = 0: i < length: i = i + 2) {
			Collections_Print(BlkValueRead(val, i + LIST_ITEM_BASE));
			print ": ";
			Collections_Print(BlkValueRead(val, i + 1 + LIST_ITEM_BASE));
			if (i < length - 2) print ", ";
		}
		print "}";
	}
	else {
		(ref-->0)(ref-->1);
	}
];

[ Collections_Print_Type type val str;
	if (type == Collections_ID_Array) {
		print "array";
	}
	else if (type == Collections_ID_ColRef) {
		print "collection reference";
	}
	else if (type == Collections_ID_Error) {
		print "collection error";
	}
	else if (type == Collections_ID_Map) {
		print "map";
	}
	else if (type == Collections_ID_Text) {
		print "text";
	}
	else if (type == DA_TruthState) {
		print "truth state";
	}
	else if (type == DecimalNumber) {
		print "number";
	}
	else if (type == PrintExternalFileName) {
		print "external file";
	}
	else if (type == PrintFigureName) {
		print "figure name";
	}
	else if (type == PrintResponse) {
		print "response";
	}
	else if (type == PrintSceneName) {
		print "scene";
	}
	else if (type == PrintShortName) {
		print "object";
	}
	else if (type == PrintSnippet) {
		print "snippets";
	}
	else if (type == PrintSoundName) {
		print "sound name";
	}
	else if (type == PrintTableName) {
		print "table name";
	}
	else if (type == PrintTimeOfDay) {
		print "time";
	}
	else if (type == PrintUseOption) {
		print "use option";
	}
	else if (type == PrintVerbAsValue) {
		print "verb";
	}
	else if (type == REAL_NUMBER_TY_Say) {
		print "real number";
	}
	else if (type == RulebookOutcomePrintingRule) {
		print "rulebook outcome";
	}
	else if (type == RulePrintingRule) {
		print "rulebook";
	}
	else if (type == SayActionName) {
		print "action name";
	}
	else if (type == SayPhraseName) {
		print "phrase";
	}
	else if (type == STORED_ACTION_TY_Say) {
		print "stored action";
	}
	else {
		str = BlkValueCreate(TEXT_TY);
		LocalParking-->0 = type;
		LocalParking-->1 = val;
		TEXT_TY_ExpandIfPerishable(str, Collections_Print_Type_Text);
		if (TEXT_TY_Replace_RE(REGEXP_BLOB, str, Collections_Illegal_Pattern, 0, 0)) {
			print (TEXT_TY_Say) TEXT_TY_RE_GetMatchVar(1);
		}
		else {
			print (TEXT_TY_Say) str;
		}
		BlkValueFree(str);
	}
];

Array Collections_Illegal_Pattern --> CONSTANT_PACKED_TEXT_STORAGE "@@94@{5C}<illegal (.+)@{5C}>$";
Array Collections_Print_Type_Text --> CONSTANT_PERISHABLE_TEXT_STORAGE Collections_Print_Type_Inner;

[ Collections_Print_Type_Inner;
	(LocalParking-->0)(LocalParking-->1);
];

[ Collections_Read type ref safe;
	if (Collections_Check_Type(type, ref)) {
		rfalse;
	}
	if (type == Collections_ID_Array && ~~safe) {
		print "Cannot directly read an array; use ~let L be R as a list;~^";
		rfalse;
	}
	if (type == Collections_ID_Map) {
		print "Cannot directly read a map^";
		rfalse;
	}
	return ref-->1;
];

[ Collections_Write type ref value;
	if (Collections_Check_Type(type, ref)) {
		rfalse;
	}
	if (type == Collections_ID_Text) {
		BlkValueCopy(ref-->1, value);
	}
	else if (type == Collections_ID_Array) {
		print "Cannot directly write to an array^";
	}
	else if (type == Collections_ID_Map) {
		print "Cannot directly write to a map^";
	}
	else {
		ref-->1 = value;
	}
];
-).



Chapter - Maps

To decide which collection reference is a/-- new/empty map:
	(- Collections_Create(Collections_ID_Map) -).

To decide if (R - collection reference) has key (key - sayable value of kind K):
	(- Collections_Map_Has_Key({R}, {-by-reference:key}, {-printing-routine:K}) -).

To set key (key - sayable value of kind K) of (R - collection reference) to/= (val - sayable value of kind V):
	(- Collections_Map_Set_Key({R}, {-by-reference:key}, {-printing-routine:K}, {-by-reference:val}, {-printing-routine:V}); -).
To (R - collection reference) => (key - sayable value of kind K) = (val - sayable value of kind V):
	(- Collections_Map_Set_Key({R}, {-by-reference:key}, {-printing-routine:K}, {-by-reference:val}, {-printing-routine:V}); -).

To decide which collection reference is get key (key - sayable value of kind K) of (R - collection reference):
	(- Collections_Map_Get_Key({R}, {-by-reference:key}, {-printing-routine:K}) -).
To decide which collection reference is (R - collection reference) => (key - sayable value of kind K):
	(- Collections_Map_Get_Key({R}, {-by-reference:key}, {-printing-routine:K}) -).

To delete key (key - sayable value of kind K) of (R - collection reference):
	(- Collections_Map_Delete_Key({R}, {-by-reference:key}, {-printing-routine:K}); -).

To repeat with (loopvar - nonexisting collection reference variable) of/in (R - collection reference) keys begin -- end loop:
	(-
		{-my:2} = 0;
		if (Collections_Get_Type({R}) == Collections_ID_Map) {
			{-my:2} = BlkValueRead({R}-->1, LIST_LENGTH_F);
			{-lvalue-by-reference:loopvar} = BlkValueRead({R}-->1, LIST_ITEM_BASE);
		}
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1} = {-my:1} + 2, {-lvalue-by-reference:loopvar} = BlkValueRead({R}-->1, {-my:1} + LIST_ITEM_BASE))
	-).

Include (-
[ Collections_Map_Compare_Keys key keytype ref;
	if (ref-->0 ~= keytype) {
		rfalse;
	}
	if (keytype == Collections_ID_Text) {
		return TEXT_TY_Replace_RE(CHR_BLOB, ref-->1, key, 0, 0, 1);
	}
	return key == ref-->1;
];

[ Collections_Map_Delete_Key ref key keytype i inner key_ref length;
	if (Collections_Check_Type(Collections_ID_Map, ref)) {
		rfalse;
	}
	if (keytype == Collections_ID_ColRef) {
		keytype = key-->0;
		key = key-->1;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		key_ref = BlkValueRead(inner, i + LIST_ITEM_BASE);
		if (Collections_Map_Compare_Keys(key, keytype, key_ref)) {
			Collections_Destroy(key_ref);
			Collections_Destroy(BlkValueRead(inner, i + 1 + LIST_ITEM_BASE));
			LIST_OF_TY_RemoveItemRange(inner, i + 1, i + 2);
			return;
		}
	}
];

[ Collections_Map_Get_Key ref key keytype i inner length;
	if (Collections_Check_Type(Collections_ID_Map, ref)) {
		rfalse;
	}
	if (keytype == Collections_ID_ColRef) {
		keytype = key-->0;
		key = key-->1;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		if (Collections_Map_Compare_Keys(key, keytype, BlkValueRead(inner, i + LIST_ITEM_BASE))) {
			return BlkValueRead(inner, i + 1 + LIST_ITEM_BASE);
		}
	}
	return 0;
];

[ Collections_Map_Has_Key ref key keytype i inner length;
	if (Collections_Check_Type(Collections_ID_Map, ref)) {
		rfalse;
	}
	if (keytype == Collections_ID_ColRef) {
		keytype = key-->0;
		key = key-->1;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		if (Collections_Map_Compare_Keys(key, keytype, BlkValueRead(inner, i + LIST_ITEM_BASE))) {
			rtrue;
		}
	}
	rfalse;
];

[ Collections_Map_Set_Key ref key keytype val valtype i inner length origkey;
	if (Collections_Check_Type(Collections_ID_Map, ref)) {
		rfalse;
	}
	! Handle a raw value or a collection reference being passed as the key
	if (keytype == Collections_ID_ColRef) {
		origkey = key;
		keytype = key-->0;
		key = key-->1;
	}
	if (valtype ~= Collections_ID_ColRef) {
		val = Collections_Create(valtype, val);
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		if (Collections_Map_Compare_Keys(key, keytype, BlkValueRead(inner, i + LIST_ITEM_BASE))) {
			! Updating existing key
			Collections_Destroy(BlkValueRead(inner, i + 1 + LIST_ITEM_BASE));
			BlkValueWrite(inner, i + 1 + LIST_ITEM_BASE, val);
			return;
		}
	}
	! New key
	if (origkey) {
		LIST_OF_TY_InsertItem(inner, origkey);
	}
	else {
		LIST_OF_TY_InsertItem(inner, Collections_Create(keytype, key));
	}
	LIST_OF_TY_InsertItem(inner, val);
];
-).



Collections ends here.

---- Documentation ----

This extension provides support for array and map data structures. Unlike normal Inform lists, arrays can contain multiple different kinds. Maps are key-values pairs, where both keys and values can be (almost) any kind.

Chapter - Collection references

The basic data structure in this extension is the collection reference. A collection reference can be of any sayable kind. You can make a collection reference with these phrases:

	collection value (sayable value)
	collection value (name of sayable kind)

The second will make a collection reference of that kind with its default value.

You can test whether a collection reference is of a particular kind, whether it is equal to another collection reference, and say the name of kind of the collection reference with these phrase:

	if kind of (collection reference) is (name of kind)
	if (collection reference) equals (collection reference)
	say "[kind of collection reference]"

Unfortunately the names of numerical kinds cannot all be determined. If you have a weight kind, then this last phrase will display "0kg".

You can read the value of a collection reference with this phrase:

	(collection reference) as a (name of kind)

If you try to read it with the wrong kind then an error will be shown.

You can update the value of a collection reference with these phrases; again the kind must be the same.

	set (collection reference) to (value)
	(collection reference) = (value)

If you read a text collection reference into an existing text variable, then the two texts will become disconnected; changing the text variable will not result in the collection reference's internal text being changed. You can however set the collection reference to the text variable. Or if you read the collection reference into a new variable ("let T be mycolref as a text") then the internal text will be exposed as the new variable, so that changes to the variable will result in the internal text being changed.

Chapter - Arrays

You can create an array and then access its internal list with these phrases:

	new/empty array
	let (new name) be (collection reference) as a list

You can then use the normal Inform list manipulation phrases. Note that you can only add collection references to the internal list, so you will have to manually wrap your values using "collection value (value)", and if you want to remove anything from the list, you need to manually destroy it first.

Chapter - Maps

There is no Inform data structure that fits a map, but you can use these phrases to create and access them:

	new/empty map
	if (R - collection reference) has key (K - value):
	set key (K - value) of (R - collection reference) to (V - value)
	get key (K - value) of (R - collection reference)
	delete key (K - value) of (R - collection reference)

When setting a key or value, you do not need to pass in a collection reference, the extension will handle wrapping the key/value in a reference for you. On the other hand, if you do set a key or value to an existing collection reference, it will be used directly and will become owned by the map, so that you don't need to destroy it individually. Unlike for individual collection references, if you are setting a value in a map for a key that already exists, the kind of the new value does not have to be the same as the kind of the old value.

If you would like a slightly more programmy way of accessing maps, you can use these phrases:

	(R - collection reference) => (key - value) = (V - value)
	(R - collection reference) => (key - value)

You can also repeat through the keys of a map with this phrase:

	repeat with (loopvar - nonexisting collection reference variable) of/in (collection reference) keys

Chapter - Cleaning up

Collection references exist outside the normal Inform model, so you must manually destroy them in order to not leak memory. Destroying an array or map will clean up all of its contents as well.

	destroy (collection reference)

Example: * Collections demo

	*: "Collections demo"
	
	Include Collections by Dannii Willis.
	
	The Lab is a room.
	In the lab is a coin.
	
	When play begins:
		let mymap be a new map;
		set key "location" of mymap to the Lab;
		set key "time" of mymap to 12:17 PM;
		mymap => "player" = player;
		let myarray be a new array;
		let myarray internal be myarray as a list;
		add collection value true to myarray internal;
		add collection value false to myarray internal;
		mymap => "truth states" = myarray;
		mymap => coin = "coin";
		say "[mymap][paragraph break]";
		repeat with key in mymap keys:
			let V be mymap => key;
			say "Key: [key] ([kind of key]), value: [V] ([kind of V])[line break]";
		destroy mymap;
