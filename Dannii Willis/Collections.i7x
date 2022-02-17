Version 1/220217 of Collections (for Glulx only) by Dannii Willis begins here.

"Provides support for array and map data structures"

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
	(- Collections_Create({-printing-routine:K}) -).
To decide which collection reference is a/-- new/-- collection value (V - sayable value of kind K):
	(- Collections_Create({-printing-routine:K}, {-by-reference:V}) -).
To decide which collection reference is a/-- new/empty array:
	(- Collections_Create(Collections_ID_Array) -).
To decide which collection reference is a/-- new/empty map:
	(- Collections_Create(Collections_ID_Map) -).

To decide if type of (R - collection reference) is (name of kind of sayable value K):
	(- (Collections_Get_Type({R}) == {-printing-routine:K}) -).

To decide if (R1 - collection reference) equals/matches/=/== (R2 - collection reference):
	(- Collections_Check_Equals({R1}, {R2}) -).

To decide what K is (R - collection reference) as a/an (name of kind of sayable value K):
	(- Collections_Read({-printing-routine:K}, {R}) -).
To let (T  - nonexisting text variable) be (R - collection reference) as a text:
	(- {-lvalue-by-reference:T} = Collections_Read(Collections_ID_Text, {R}, 1); -).
To let (L - nonexisting list of collection references variable) be (R - collection reference) as a list:
	(- {-lvalue-by-reference:L} = Collections_Read(Collections_ID_Array, {R}, 1); -).

To set (R - collection reference) to/= (V - sayable value of kind K):
	(- Collections_Write({-printing-routine:K}, {R}, {-by-reference:V}); -).
To (R - collection reference) = (V - sayable value of kind K):
	(- Collections_Write({-printing-routine:K}, {R}, {-by-reference:V}); -).

To destroy (R - collection reference):
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

[ Collections_Check_Type type ref;
	if (ref == 0) {
		print "Trying to access a collection error reference^";
		rtrue;
	}
	if (ref-->0 ~= type) {
		print "Collection type mismatch^";
		rtrue;
	}
	rfalse;
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
		return;
	}
	else if (type == Collections_ID_Map) {
		print "Cannot directly write to a map^";
		return;
	}
	else {
		ref-->1 = value;
	}
];
-).



Chapter - Maps

To decide if (R - collection reference) has key (key - sayable value of kind K):
	(- Collections_Map_Has_Key({R}, {-by-reference:key}, {-printing-routine:K}) -).

To set key (key - sayable value of kind K) of (R - collection reference) to/= (val - sayable value of kind V):
	(- Collections_Map_Set_Key({R}, {-by-reference:key}, {-printing-routine:K}, {val}, {-printing-routine:V}); -).
To (R - collection reference) => (key - sayable value of kind K) = (val - sayable value of kind V):
	(- Collections_Map_Set_Key({R}, {-by-reference:key}, {-printing-routine:K}, {val}, {-printing-routine:V}); -).

To decide which collection reference is get key (key - sayable value of kind K) of (R - collection reference):
	(- Collections_Map_Get_Key({R}, {-by-reference:key}, {-printing-routine:K}) -).
To decide which collection reference is (R - collection reference) => (key - sayable value of kind K):
	(- Collections_Map_Get_Key({R}, {-by-reference:key}, {-printing-routine:K}) -).

To delete key (key - sayable value of kind K) of (R - collection reference):
	(- Collections_Map_Delete_Key({R}, {-by-reference:key}, {-printing-routine:K}); -).

To repeat with (loopvar - nonexisting collection reference variable) of/in (R - collection reference) begin -- end loop:
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

[ Collections_Map_Set_Key ref key keytype val valtype i inner length;
	if (Collections_Check_Type(Collections_ID_Map, ref)) {
		rfalse;
	}
	if (keytype == Collections_ID_ColRef) {
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
	LIST_OF_TY_InsertItem(inner, Collections_Create(keytype, key));
	LIST_OF_TY_InsertItem(inner, val);
];
-).



Collections ends here.
