Version 1/220301 of JSON (for Glulx only) by Dannii Willis begins here.

"Provides support for parsing and generating JSON"

[Supported releases: 6M62]

Use authorial modesty.



Chapter - JSON types and references

A JSON type is a kind of value.
The JSON types are JSON error type, JSON null type, JSON boolean type, JSON number type, JSON real number type, JSON string type, JSON array type, JSON object type.
The specification of a JSON type is "A JSON type. JSON numbers are split into numbers and real numbers, just as I7 numbers are."

[A JSON reference is a pointer to a malloced structure]
A JSON reference is a kind of value.
JSON 10 specifies a JSON reference.
The specification of a JSON reference is "A reference to a JSON value. JSON values cannot be manipulated directly, but must be accessed only through the JSON phrases."

To decide what JSON type is type of (R - JSON reference):
	(- JSON_Get_Type({R}) -).

Include (-
[ JSON_Get_Type ref;
	if (ref == 0) {
		return (+ JSON error type +);
	}
	return ref-->0;
];
-).



Section - unindexed

To type-print (T - JSON type) (this is json-type-printing):
	say T;

Include (-
[ JSON_Type_Mismatch expected got;
	print "JSON type mismatch: expected ";
	((+ json-type-printing +)-->1)(expected);
	print ", got ";
	((+ json-type-printing +)-->1)(got);
	print "^";
];
-).



Chapter - Creating and destroying

[To decide which JSON reference is create JSON reference of type (T - JSON type):
	(- JSON_Create({T}) -).]

To decide which JSON reference is a/-- new/-- JSON null:
	(- JSON_Create((+ JSON null type +)) -).
To decide which JSON reference is a/-- new/-- JSON true:
	(- JSON_Create((+ JSON boolean type +), 1) -).
To decide which JSON reference is a/-- new/-- JSON false/boolean:
	(- JSON_Create((+ JSON boolean type +), 0) -).
To decide which JSON reference is a/-- new/-- JSON number (N - number):
	(- JSON_Create((+ JSON number type +), {N}) -).
To decide which JSON reference is a/-- new/-- JSON real number (N - real number):
	(- JSON_Create((+ JSON real number type +), {N}) -).
To decide which JSON reference is a/-- new/-- JSON string/text from (T - text):
	(- JSON_Create((+ JSON string type +), {-by-reference:T}) -).
To decide which JSON reference is a/-- new/empty/-- JSON array:
	(- JSON_Create((+ JSON array type +)) -).
To decide which JSON reference is a/-- new/empty/-- JSON object:
	(- JSON_Create((+ JSON object type +)) -).

To destroy (R - JSON reference):
	(- JSON_Destroy({R}); -).



Section - unindexed

[ We need to get a reference to KD0_list_of_json_references (but it could be named differently), so this is a list one dimension higher than the real ones are. ]
Template JSON array is a list of list of JSON references variable.

Include (-
[ JSON_Create type value ref;
	if (type == (+ JSON error type +)) {
		return 0;
	}
	@malloc 8 ref;
	ref-->0 = type;
	switch (type) {
		(+ JSON string type +):
			ref-->1 = BlkValueCreate(TEXT_TY);
			if (value) {
				BlkValueCopy(ref-->1, value);
			}
		(+ JSON array type +), (+ JSON object type +):
			ref-->1 = BlkValueCreate(BlkValueRead((+ template JSON array +), LIST_ITEM_KOV_F));
		default:
			ref-->1 = value;
	}
	return ref;
];

[ JSON_Destroy ref i inner length;
	if (ref == 0) {
		rfalse;
	}
	inner = ref-->1;
	switch (ref-->0) {
		(+ JSON string type +):
			BlkValueFree(inner);
		(+ JSON array type +), (+ JSON object type +):
			length = BlkValueRead(inner, LIST_LENGTH_F);
			for (i = 0: i < length: i++) {
				JSON_Destroy(BlkValueRead(inner, i + LIST_ITEM_BASE));
			}
			BlkValueFree(inner);
	}
	@mfree ref;
];
-).



Chapter - Reading and setting JSON references

To decide if (R - JSON reference) as a truth state:
	(- JSON_Read((+ JSON boolean type +), {R}) -).
To decide what number is (R - JSON reference) as a number:
	(- JSON_Read((+ JSON number type +), {R}) -).
To decide what real number is (R - JSON reference) as a real number:
	(- JSON_Read((+ JSON real number type +), {R}) -).
To let (T  - nonexisting text variable) be (R - JSON reference) as a text/string:
	(- {-lvalue-by-reference:T} = JSON_Read((+ JSON string type +), {R}); -).
To let (L - nonexisting list of JSON references variable) be (R - JSON reference) as a/an list/array:
	(- {-lvalue-by-reference:L} = JSON_Read((+ JSON array type +), {R}); -).

Include (-
[ JSON_Read type ref;
	if (ref == 0) {
		print "Trying to read from JSON error reference^";
		rfalse;
	}
	if (type ~= ref-->0) {
		JSON_Type_Mismatch(type, ref-->0);
		rfalse;
	}
	return ref-->1;
];
-).

To set (R - JSON reference) to (V - truth state):
	(- JSON_Write((+ JSON boolean type +), {R}, {V}); -).
To set (R - JSON reference) to (V - number):
	(- JSON_Write((+ JSON number type +), {R}, {V}); -).
To set (R - JSON reference) to (V - real number):
	(- JSON_Write((+ JSON real number type +), {R}, {V}); -).

Include (-
[ JSON_Write type ref value;
	if (ref == 0) {
		print "Trying to write to a JSON error reference^";
		return;
	}
	if (type ~= ref-->0) {
		JSON_Type_Mismatch(type, ref-->0);
		rfalse;
	}
	switch (type) {
		(+ JSON string type +):
			BlkValueCopy(ref-->1, value);
		(+ JSON array type +), (+ JSON object type +):
			return;
		default:
			ref-->1 = value;
	}
];
-).



Chapter - JSON objects

To decide if (R - JSON reference) has key (K - text):
	(- JSON_Object_Has_Key({R}, {-by-reference:K}) -).
To set key (K - text) of (R - JSON reference) to (V - JSON reference):
	(- JSON_Object_Set_Key({R}, {-by-reference:K}, {V}); -).
To decide which JSON reference is get key (K - text) of (R - JSON reference):
	(- JSON_Object_Get_Key({R}, {-by-reference:K}) -).
To delete key (K - text) of (R - JSON reference):
	(- JSON_Object_Delete_Key({R}, {-by-reference:K}); -).
To repeat with (loopvar - nonexisting text variable) of/in (R - JSON reference) begin -- end loop:
	(-
		{-my:2} = 0;
		if (JSON_Get_Type({R}) == (+ JSON object type +)) {
			{-my:2} = BlkValueRead({R}-->1, LIST_LENGTH_F);
			{-lvalue-by-reference:loopvar} = BlkValueRead({R}-->1, LIST_ITEM_BASE)-->1;
		}
		for ({-my:1} = 0: {-my:1} < {-my:2}: {-my:1} = {-my:1} + 2, {-lvalue-by-reference:loopvar} = BlkValueRead({R}-->1, {-my:1} + LIST_ITEM_BASE)-->1)
	-).

Include (-
[ JSON_Object_Delete_Key ref key i inner key_ref length;
	if (ref == 0) {
		print "Trying to access a JSON error reference^";
		return;
	}
	if (ref-->0 ~= (+ JSON object type +)) {
		JSON_Type_Mismatch((+ JSON object type +), ref-->0);
		rfalse;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		key_ref = BlkValueRead(inner, i + LIST_ITEM_BASE);
		if (TEXT_TY_Replace_RE(CHR_BLOB, key_ref-->1, key, 0, 0, 1)) {
			JSON_Destroy(key_ref);
			JSON_Destroy(BlkValueRead(inner, i + 1 + LIST_ITEM_BASE));
			LIST_OF_TY_RemoveItemRange(inner, i + 1, i + 2);
			return;
		}
	}
];

[ JSON_Object_Get_Key ref key i inner length;
	if (ref == 0) {
		print "Trying to access a JSON error reference^";
		return;
	}
	if (ref-->0 ~= (+ JSON object type +)) {
		JSON_Type_Mismatch((+ JSON object type +), ref-->0);
		rfalse;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		if (TEXT_TY_Replace_RE(CHR_BLOB, BlkValueRead(inner, i + LIST_ITEM_BASE)-->1, key, 0, 0, 1)) {
			return BlkValueRead(inner, i + 1 + LIST_ITEM_BASE);
		}
	}
	return 0;
];

[ JSON_Object_Has_Key ref key i inner length;
	if (ref == 0) {
		print "Trying to access a JSON error reference^";
		return;
	}
	if (ref-->0 ~= (+ JSON object type +)) {
		JSON_Type_Mismatch((+ JSON object type +), ref-->0);
		rfalse;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		if (TEXT_TY_Replace_RE(CHR_BLOB, BlkValueRead(inner, i + LIST_ITEM_BASE)-->1, key, 0, 0, 1)) {
			rtrue;
		}
	}
	rfalse;
];

[ JSON_Object_Set_Key ref key val i inner length;
	if (ref == 0) {
		print "Trying to access a JSON error reference^";
		return;
	}
	if (ref-->0 ~= (+ JSON object type +)) {
		JSON_Type_Mismatch((+ JSON object type +), ref-->0);
		rfalse;
	}
	inner = ref-->1;
	length = BlkValueRead(inner, LIST_LENGTH_F);
	for (i = 0: i < length: i = i + 2) {
		if (TEXT_TY_Replace_RE(CHR_BLOB, BlkValueRead(inner, i + LIST_ITEM_BASE)-->1, key, 0, 0, 1)) {
			! Updating existing key
			JSON_Destroy(BlkValueRead(inner, i + 1 + LIST_ITEM_BASE));
			BlkValueWrite(inner, i + 1 + LIST_ITEM_BASE, val);
			return;
		}
	}
	! New key
	LIST_OF_TY_InsertItem(inner, JSON_Create((+ JSON string type +), key));
	LIST_OF_TY_InsertItem(inner, val);
];
-).



Chapter - Parsing and stringifying JSON values

To decide which JSON reference is parse (T - a text):
	(- JSON_Parse({-by-reference:T}) -).

To say (R - JSON reference):
	(- JSON_Stringify({R}); -).
To say (R - JSON reference) escaping non-ASCII:
	(- JSON_Stringify({R}, 1); -).

Include (-
Global JSON_Parse_Progress = 0;

[ JSON_Parse str cp length p res;
	cp = str-->0;
	p = TEXT_TY_Temporarily_Transmute(str);
	length = TEXT_TY_CharacterLength(str);
	res = JSON_Parse_Inner(str, 0, length);
	TEXT_TY_Untransmute(str, p, cp);
	return res;
];

[ JSON_Parse_Skip_Whitespace str i length char;
	for (: i < length: i++) {
		char = BlkValueRead(str, i);
		if (char ~= 9 or 10 or 11 or 12 or 13 or 32) {
			break;
		}
	}
	return i;
];

[ JSON_Parse_Inner str i length char item res;
	i = JSON_Parse_Skip_Whitespace(str, i, length);
	for (: i < length: i++) {
		char = BlkValueRead(str, i);
		! numbers - must start with minus or 0-9
		if (char == '-' || (char >= '0' && char <= '9')) {
			return JSON_Parse_Number(str, i, length);
		}
		switch (char) {
			! null
			'n':
				JSON_Parse_Progress = i + 4;
				return JSON_Create((+ JSON null type +));
			! boolean
			'f':
				JSON_Parse_Progress = i + 5;
				return JSON_Create((+ JSON boolean type +), 0);
			't':
				JSON_Parse_Progress = i + 4;
				return JSON_Create((+ JSON boolean type +), 1);
			! string
			34:
				return JSON_Parse_String(str, i, length);
			! array
			'[':
				i++;
				res = JSON_Create((+ JSON array type +));
				! Check for an empty array
				i = JSON_Parse_Skip_Whitespace(str, i, length);
				char = BlkValueRead(str, i);
				if (char == ']') {
					JSON_Parse_Progress = i + 1;
					return res;
				}
				for (: i < length; i++) {
					item = JSON_Parse_Inner(str, i, length);
					i = JSON_Parse_Progress;
					if (item == 0) {
						JSON_Destroy(res);
						return 0;
					}
					LIST_OF_TY_InsertItem(res-->1, item);
					i = JSON_Parse_Skip_Whitespace(str, i, length);
					char = BlkValueRead(str, i);
					if (char == ',') {
						continue;
					}
					if (char == ']') {
						break;
					}
					JSON_Destroy(res);
					return 0;
				}
				JSON_Parse_Progress = i + 1;
				return res;
			! object
			'{':
				i++;
				res = JSON_Create((+ JSON object type +));
				! Check for an empty object
				i = JSON_Parse_Skip_Whitespace(str, i, length);
				char = BlkValueRead(str, i);
				if (char == '}') {
					JSON_Parse_Progress = i + 1;
					return res;
				}
				for (: i < length; i++) {
					! key
					item = JSON_Parse_Inner(str, i, length);
					i = JSON_Parse_Progress;
					if (item == 0) {
						JSON_Destroy(res);
						return 0;
					}
					LIST_OF_TY_InsertItem(res-->1, item);
					i = JSON_Parse_Skip_Whitespace(str, i, length);
					char = BlkValueRead(str, i++);
					if (char ~= ':') {
						JSON_Destroy(res);
						return 0;
					}
					! value
					item = JSON_Parse_Inner(str, i, length);
					i = JSON_Parse_Progress;
					if (item == 0) {
						JSON_Destroy(res);
						return 0;
					}
					LIST_OF_TY_InsertItem(res-->1, item);
					i = JSON_Parse_Skip_Whitespace(str, i, length);
					char = BlkValueRead(str, i);
					if (char == ',') {
						continue;
					}
					if (char == '}') {
						break;
					}
					JSON_Destroy(res);
					return 0;
				}
				JSON_Parse_Progress = i + 1;
				return res;
			default:
				return 0;
		}
	}
];

Array JSON_Parse_Number_Buffer -> 20;
[ JSON_Parse_Number str i length bufi char float negative res val;
	! Copy the number to the buffer
	for (: i < length: i++) {
		char = BlkValueRead(str, i);
		JSON_Parse_Number_Buffer->bufi = char;
		bufi++;
		if (char == '-') {
			negative = 1;
		}
		else if (char >= '0' && char <= '9') {
			val = val * 10 + char - '0';
		}
		else if (char == '+' or '.' or 'E' or 'e') {
			float = 1;
		}
		! End of number
		else {
			break;
		}
	}
	JSON_Parse_Progress = i;
	if (float) {
		return JSON_Create((+ JSON real number type +), FloatParse(JSON_Parse_Number_Buffer, bufi));
	}
	if (negative) {
		val = val * -1;
	}
	return JSON_Create((+ JSON number type +), val);
];

[ JSON_Parse_String str i length cap char pos ref res;
	! Handle whitespace and ensure this is actually a string
	i = JSON_Parse_Skip_Whitespace(str, i, length);
	char = BlkValueRead(str, i);
	if (char ~= 34) {
		return 0;
	}
	i++;
	res = BlkValueCreate(TEXT_TY);
	cap = BlkValueLBCapacity(res);
	for (: i < length: i++) {
		char = BlkValueRead(str, i);
		switch (char) {
			! Escaped
			92:
				if (pos + 1 >= cap) {
					if (BlkValueSetLBCapacity(res, 2 * pos) == false) {
						jump FinishedString;
					}
					cap = BlkValueLBCapacity(res);
				}
				i++;
				char = BlkValueRead(str, i);
				switch (char) {
					'b': char = 8;
					't': char = 9;
					'n': char = 10;
					'f': char = 12;
					'r': char = 13;
					'u':
						char = JSON_Hex_to_Dec(BlkValueRead(str, i + 1)) * $1000 + JSON_Hex_to_Dec(BlkValueRead(str, i + 2)) * $100 + JSON_Hex_to_Dec(BlkValueRead(str, i + 3)) * $10 + JSON_Hex_to_Dec(BlkValueRead(str, i + 4));
						i = i + 4;
				}
				BlkValueWrite(res, pos++, char);
			! end string
			34:
				i++;
				jump FinishedString;
			default:
				if (pos + 1 >= cap) {
					if (BlkValueSetLBCapacity(res, 2 * pos) == false) {
						jump FinishedString;
					}
					cap = BlkValueLBCapacity(res);
				}
				BlkValueWrite(res, pos++, char);
		}
	}
	.FinishedString;
	BlkValueWrite(res, pos, 0);
	ref = JSON_Create((+ JSON string type +), res);
	BlkValueFree(res);
	JSON_Parse_Progress = i;
	return ref;
];

[ JSON_Hex_to_Dec val;
	if (val >= '0' && val <= '9') {
		return val - '0';
	}
	if (val >= 'A' && val <= 'F') {
		return val - 'A' + 10;
	}
	if (val >= 'a' && val <= 'f') {
		return val - 'a' + 10;
	}
];

[ JSON_Stringify ref escape_non_ascii i length val type;
	type = JSON_Get_Type(ref);
	val = ref-->1;
	switch (type) {
		(+ JSON error type +):
			print "JSON Error";
		(+ JSON null type +):
			print "null";
		(+ JSON boolean type +):
			if (val) {
				print "true";
			}
			else {
				print "false";
			}
		(+ JSON number type +):
			print val;
		(+ JSON real number type +):
			JSON_Stringify_Real_Number(val, 8);
		(+ JSON string type +):
			JSON_Stringify_String(val, escape_non_ascii);
		(+ JSON array type +):
			! Based on LIST_OF_TY_Say
			length = BlkValueRead(val, LIST_LENGTH_F);
			print "[";
			for (i = 0: i < length: i++) {
				JSON_Stringify(BlkValueRead(val, i + LIST_ITEM_BASE), escape_non_ascii);
				if (i < length - 1) print ", ";
			}
			print "]";
		(+ JSON object type +):
			length = BlkValueRead(val, LIST_LENGTH_F);
			print "{";
			for (i = 0: i < length: i = i + 2) {
				JSON_Stringify(BlkValueRead(val, i + LIST_ITEM_BASE), escape_non_ascii);
				print ": ";
				JSON_Stringify(BlkValueRead(val, i + 1 + LIST_ITEM_BASE), escape_non_ascii);
				if (i < length - 2) print ", ";
			}
			print "}";
	}
];

! From RealNumber.i6t
[ JSON_Stringify_Real_Number val prec   pval;
	pval = val & $7FFFFFFF;

	@jz pval ?UseFloatDec;
	@jfge pval $49742400 ?UseFloatExp; ! 1000000.0
	@jflt pval $38D1B717 ?UseFloatExp; ! 0.0001

	.UseFloatDec;
	return FloatDec(val, prec);
	.UseFloatExp;
	return JSON_Stringify_Real_NumberExp(val, prec);
];

! The only change made is to force the use of "e" rather than "× 10^"
[ JSON_Stringify_Real_NumberExp val prec   log10val expo fexpo idig ix pow10;
	if (prec == 0)
		prec = 5;
	if (prec > 8)
		prec = 8;
	pow10 = PowersOfTen --> prec;

	! Knock off the sign bit first.
	if (val & $80000000) {
		@streamchar '-';
		val = val & $7FFFFFFF;
	}
	
	@jisnan val ?IsNan;
	@jisinf val ?IsInf;

	if (val == $0) {
		expo = 0;
		idig = 0;
		jump DoPrint;
	}

	! Take as an example val=123.5, with precision=6. The desired
	! result is "1.23000e+02".
	
	@log val sp;
	@fdiv sp $40135D8E log10val; ! $40135D8E is log(10)
	@floor log10val fexpo;
	@ftonumn fexpo expo;
	! expo is now the exponent (as an integer). For our example, expo=2.

	@fsub log10val fexpo sp;
	@numtof prec sp;
	@fadd sp sp sp;
	@fmul sp $40135D8E sp;
	@exp sp sp;
	! The stack value is now exp((log10val - fexpo + prec) * log(10)).
	! We've shifted the decimal point left by expo digits (so that
	! it's after the first nonzero digit), and then right by prec
	! digits. In our example, that would be 1235000.0.
	@ftonumn sp idig;
	! Round to an integer, and we have 1235000. Notice that this is
	! exactly the digits we want to print (if we stick a decimal point
	! after the first).

	.DoPrint;
	
	if (idig >= 10*pow10) {
		! Rounding errors have left us outside the decimal range of
		! [1.0, 10.0) where we should be. Adjust to the next higher
		! exponent.
		expo++;
		@div idig 10 idig;
	}
	
	! Trim off trailing zeroes, as long as there's at least one digit
	! after the decimal point. (Delete this stanza if you want to
	! keep the trailing zeroes.)
	while (prec > 1) {
		@mod idig 10 sp;
		@jnz sp ?DoneTrimming;
		@div pow10 10 pow10;
		@div idig 10 idig;
		prec--;
	}
	.DoneTrimming;
	
	for (ix=0 : ix<=prec : ix++) {
		@div idig pow10 sp;
		@mod sp 10 sp;
		@streamnum sp;
		if (ix == 0)
			@streamchar '.';
		@div pow10 10 pow10;
	}

	! Print the exponent.
	! Convention is to use at least two digits.
	@streamchar 'e';
	if (expo < 0) {
		@streamchar '-';
		@neg expo expo;
	}
	else {
		@streamchar '+';
	}
	if (expo < 10)
		@streamchar '0';
	@streamnum expo;
	
	rtrue;

	.IsNan;
	PrintNan();
	rtrue;

	.IsInf;
	PrintInfinity();
	rtrue;
];

[ JSON_Stringify_String str escape_non_ascii char cp i length p;
	cp = str-->0;
	p = TEXT_TY_Temporarily_Transmute(str);
	length = TEXT_TY_CharacterLength(str);
	print "~";
	for (i = 0: i < length: i++) {
		char = BlkValueRead(str, i);
		switch (char) {
			8: print "@@92b"; ! \b
			9: print "@@92t"; ! \t
			10: print "@@92n"; ! \n
			12: print "@@92f"; ! \f
			13: print "@@92r"; ! \r
			34: print "@@92~"; ! "
			92: print "@@92@@92"; ! \
			default:
				if ((escape_non_ascii && char > 127) || (char >= $D800 && char <= $DFFF)) {
					print "@@92u", (BlkPrintHexadecimal) char;
				}
				else {
					print (char) char;
				}
		}
	}
	print "~";
	TEXT_TY_Untransmute(str, p, cp);
];
-).



JSON ends here.

---- Documentation ----

This extension provides support for parsing, processing, and generating JSON.

Chapter - Creating JSON references

The basic data structure in this extension is the JSON reference. You can create JSON references with these phrases:

	JSON null
	JSON true
	JSON false/boolean
	JSON number (N - number)
	JSON real number (N - real number)
	JSON string/text from (T - text)
	JSON array
	JSON object

To determine which type a JSON reference has, use the phrase "type of (json reference)".

Chapter - Reading and setting JSON references

You can access the internal data of a JSON reference with these phrases. If you try to access a reference using the wrong type an error will be shown.

	if (R - JSON reference) as a truth state:
	(R - JSON reference) as a number
	(R - JSON reference) as a real number
	let (T  - nonexisting text variable) be (R - JSON reference) as a text/string
	let (L - nonexisting list of JSON references variable) be (R - JSON reference) as a/an list/array

To set a boolean, number, or real number, use these phrases:

	set (R - JSON reference) to (V - truth state)
	set (R - JSON reference) to (V - number)
	set (R - JSON reference) to (V - real number)

Strings and arrays can be modified in place using the standard Inform phrases. You do not need to update the JSON reference with the new text or list.

Chapter - JSON objects

There is no Inform data structure that fits a JSON object, but you can use these phrases to access them:
	
	if (R - JSON reference) has key (K - text):
	set key (K - text) of (R - JSON reference) to (V - JSON reference)
	get key (K - text) of (R - JSON reference)
	delete key (K - text) of (R - JSON reference)

You can also repeat through the keys of a JSON object with this phrase:

	repeat with (loopvar - nonexisting text variable) of/in (R - JSON reference)

Chapter - Parsing and stringifying JSON

These two phrases will parse a text into a JSON reference, and a JSON reference into a text:

	parse (T - a text)
	say (R - JSON reference)
	say (R - JSON reference) escaping non-ASCII

You can use the standard Inform phrases "text of (external file)" and "write (text) to (external file)" to read and write JSON files, but note that they will have the .glkdata extension, as well as the normal Inform file header. These file phrases only support ASCII, so use the "escaping non-ASCII" phrase if you have non-ASCII characters.

Chapter - Cleaning up

JSON references exist outside the normal Inform model, so you must manually destroy them in order to not leak memory. Destroying an array or object will clean up all of its contents as well.

	destroy (R - JSON reference)

Example: * Actions tracker

	*: "Actions tracker"
	
	Include JSON by Dannii Willis.
	
	The Lab is a room.
	In the lab is a coin.
	
	The File of Tracked Actions is called "actions".
	
	When play begins:
		if the File of Tracked Actions exists:
			let text data be "[text of File of Tracked Actions]";
			let json data be parse text data;
			if json data has key "restarted":
				say "You have restarted this demo.[line break]";
			otherwise:
				say "You have not yet restarted this demo.[line break]";
			if json data has key "jumped":
				let jump count be get key "jumped" of json data;
				say "You have jumped [jump count as a number] times.[line break]";
			if json data has key "picked up coin":
				let pick up coint count be get key "picked up coin" of json data;
				say "You have picked up the coin [pick up coint count as a number] times.[line break]";
			destroy json data;
	
	First carry out restarting the game rule:
		let json data be a JSON reference;
		if the File of Tracked Actions exists:
			let text data be "[text of File of Tracked Actions]";
			let json data be parse text data;
		otherwise:
			let json data be a new JSON object;
		set key "restarted" of json data to JSON true;
		write "[json data]" to File of Tracked Actions;
		destroy json data;
	
	To increment (T - a text) in tracked actions:
		let json data be a JSON reference;
		if the File of Tracked Actions exists:
			let text data be "[text of File of Tracked Actions]";
			let json data be parse text data;
		otherwise:
			let json data be a new JSON object;
		let count be 0;
		if json data has key T:
			now count is get key T of json data as a number;
		increment count;
		set key T of json data to JSON number count;
		write "[json data]" to File of Tracked Actions;
		destroy json data;
		
	Carry out jumping:
		increment "jumped" in tracked actions;
	
	After taking the coin:
		increment "picked up coin" in tracked actions;
		continue the action;