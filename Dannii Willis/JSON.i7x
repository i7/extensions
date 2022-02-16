Version 1/220216 of JSON (for Glulx only) by Dannii Willis begins here.

"Provides support for parsing and generating JSON"

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
			{-lvalue-by-reference:loopvar} = BlkValueRead({R}-->1, {-my:1} + LIST_ITEM_BASE)-->1;
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



Chapter - Stringifying JSON values

To say (R - JSON reference):
	(- JSON_Stringify({R}); -).

Include (-
[ JSON_Stringify ref i length val type;
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
			JSON_Stringify_Real_Number(val);
		(+ JSON string type +):
			JSON_Stringify_String(val);
		(+ JSON array type +):
			! Based on LIST_OF_TY_Say
			length = BlkValueRead(val, LIST_LENGTH_F);
			print "[";
			for (i = 0: i < length: i++) {
				JSON_Stringify(BlkValueRead(val, i + LIST_ITEM_BASE));
				if (i < length - 1) print ", ";
			}
			print "]";
		(+ JSON object type +):
			length = BlkValueRead(val, LIST_LENGTH_F);
			print "{";
			for (i = 0: i < length: i = i + 2) {
				JSON_Stringify(BlkValueRead(val, i + LIST_ITEM_BASE));
				print ": ";
				JSON_Stringify(BlkValueRead(val, i + 1 + LIST_ITEM_BASE));
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

[ JSON_Stringify_String str char cp i length p;
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
			47: print "@@92/"; ! /
			92: print "@@92@@92"; ! \
			default: print (char) char;
		}
	}
	print "~";
	TEXT_TY_Untransmute(str, p, cp);
];
-).



JSON ends here.
