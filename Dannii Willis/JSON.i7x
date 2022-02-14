Version 1/220214 of JSON (for Glulx only) by Dannii Willis begins here.

"Provides support for parsing and generating JSON"

Use authorial modesty.



Chapter - JSON types and references

A JSON type is a kind of value.
The JSON types are JSON error, JSON null, JSON boolean, JSON number, JSON real number, JSON string, JSON array, JSON object.
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
		return (+ JSON error +);
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

To decide which JSON reference is a/-- new JSON null:
	(- JSON_Create((+ JSON null +)) -).
To decide which JSON reference is a/-- new JSON true:
	(- JSON_Create((+ JSON boolean +), 1) -).
To decide which JSON reference is a/-- new JSON false/boolean:
	(- JSON_Create((+ JSON boolean +), 0) -).
To decide which JSON reference is a/-- new/-- JSON number (N - number):
	(- JSON_Create((+ JSON number +), {N}) -).
To decide which JSON reference is a/-- new/-- JSON real number (N - real number):
	(- JSON_Create((+ JSON real number +), {N}) -).
To decide which JSON reference is a/-- new/-- JSON string/text from (T - text):
	(- JSON_Create((+ JSON string +), {-by-reference:T}) -).
To decide which JSON reference is a/-- new/empty JSON array:
	(- JSON_Create((+ JSON array +)) -).
To decide which JSON reference is a/-- new/empty JSON object:
	(- JSON_Create((+ JSON object +)) -).

To destroy (R - JSON reference):
	(- JSON_Destroy({R}); -).

Include (-
[ JSON_Create type value ref;
	if (type == (+ JSON error +)) {
		return 0;
	}
	@malloc 8 ref;
	ref-->0 = type;
	switch (type) {
		(+ JSON string +):
			ref-->1 = BlkValueCreate(TEXT_TY);
			if (value) {
				BlkValueCopy(ref-->1, value);
			}
		(+ JSON array +), (+ JSON object +):
			ref-->1 = BlkValueCreate(LIST_OF_TY);
		default:
			ref-->1 = value;
	}
	return ref;
];

[ JSON_Destroy ref;
	if (ref == 0) {
		rfalse;
	}
	switch (ref-->0) {
		(+ JSON string +):
			BlkValueFree(ref-->1);
		(+ JSON array +):
		(+ JSON object +):
	}
	@mfree ref;
];
-).



Chapter - Reading JSON references

To decide if (R - JSON reference) as a truth state:
	(- JSON_Read((+ JSON boolean +), {R}) -).
To decide what number is (R - JSON reference) as a number:
	(- JSON_Read((+ JSON number +), {R}) -).
To decide what real number is (R - JSON reference) as a real number:
	(- JSON_Read((+ JSON real number +), {R}) -).
[To let (T  - nonexisting variable) be (R - JSON reference) as a text/string:
	(- {-unprotect:T} {T} = JSON_Read((+ JSON string +), {R}); -).]
To decide which text is (R - JSON reference) as a text/string:
	(- JSON_Read((+ JSON string +), {R}) -).

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



Chapter - Setting JSON references

To set (R - JSON reference) to (V - truth state):
	(- JSON_Write((+ JSON boolean +), {R}, {V}); -).
To set (R - JSON reference) to (V - number):
	(- JSON_Write((+ JSON number +), {R}, {V}); -).
To set (R - JSON reference) to (V - real number):
	(- JSON_Write((+ JSON real number +), {R}, {V}); -).
To set (R - JSON reference) to (V - text):
	(- JSON_Write((+ JSON string +), {R}, {-by-reference:V}); -).

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
		(+ JSON string +):
			BlkValueCopy(ref-->1, value);
		(+ JSON array +), (+ JSON object +):
			! TODO
		default:
			ref-->1 = value;
	}
];
-).



Chapter - Stringifying JSON values

To say (R - JSON reference):
	if the type of R is:
		-- JSON error:
			say "JSON Error";
		-- JSON null:
			say "null";
		-- JSON boolean:
			if R as a truth state:
				say "true";
			otherwise:
				say "false";
		-- JSON number:
			say R as a number;
		-- JSON real number:
			let out be "[R as a real number]";
			replace the text " [unicode 215] 10^" in out with "e";
			say out;
		-- JSON string:
			say "[quotation mark]";
			let internal text be R as a text;
			repeat with i running from 1 to number of characters in internal text:
				let char be character number i in internal text;
				[ TODO: Replace with something more efficient, by getting the code point number? ]
				if char is:
					-- "[quotation mark]": say "\[quotation mark]";
					-- "\": say "\\";
					-- "/": say "\/";
					-- "[line break]": say "\n";
					-- "[unicode 8]": say "\b";
					-- "[unicode 9]": say "\t";
					-- "[unicode 12]": say "\f";
					-- "[unicode 13]": say "\r";
					-- otherwise: say char;
			say "[quotation mark]";
		-- JSON array:
			say "TODO";
		-- JSON object:
			say "TODO";



JSON ends here.
