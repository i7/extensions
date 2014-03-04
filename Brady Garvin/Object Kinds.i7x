Version 2 of Object Kinds by Brady Garvin begins here.

"The ability to treat object kinds as values."

[Based on RTP.i6t and The Inform Technical Manual.]

Chapter "Object Kinds as Values"

An object kind is a kind of value.
Object Kind #9999 specifies an object kind.  [I opt for an arithmetic kind of value to prevent authors from giving kinds properties; at the moment, that isn't supported.]

To decide what object kind is the generic object kind: (- 0 -).

Chapter "Yourself as the Spare Object"

Include (-
	[ ok_imbue_selfobj kind_index;
		(selfobj.&2)-->0 = KindHierarchy-->(2 * kind_index);
		(selfobj.&2)-->1 = KindHierarchy-->(2 * kind_index);
		(selfobj.&2)-->2 = KindHierarchy-->(2 * kind_index);
	];
	[ ok_unimbue_selfobj;
		(selfobj.&2)-->0 = K8_person;
		(selfobj.&2)-->1 = K2_thing;
		(selfobj.&2)-->2 = K0_kind;
	];
-)

To make yourself temporarily behave as if it has the kind (K - an object kind): (- ok_imbue_selfobj({K}); -).
To make yourself behave as if it has its proper kinds again: (- ok_unimbue_selfobj(); -).

Chapter "Counting Object Kinds on the Z-Machine" (for Z-Machine only)

To decide what object kind is the last object kind: (- (#highest_class_number - 5) -).

Chapter "Counting Object Kinds in Glulx" (for Glulx only)

Include (-
	Global get_last_object_kind = compute_and_get_last_object_kind;
-) after "Definitions.i6t".

Include (-
	Global last_object_kind;
	[ compute_and_get_last_object_kind i result;
		result = 0;
		for (i = K0_kind: i: i = i-->6) ++result;
		get_last_object_kind = just_get_last_object_kind;
		return last_object_kind = result;
	];
	[ just_get_last_object_kind;
		return last_object_kind;
	];
-).

To decide what object kind is the last object kind: (- get_last_object_kind() -).

Chapter "Operations on Object Kinds"

Include (-
	[ object_kind_is_valid kind;
		return kind >= 0 && kind <= (+ the last object kind +);
	];
-).

Definition: an object kind is valid rather than invalid if I6 routine "object_kind_is_valid" says so (it is at least zero, the minimum object kind, and at most the maximum object kind).

To repeat with (I - a nonexisting object kind variable) running through object kinds begin -- end: (- for({I} = 0: {I} < (+ the last object kind +): ++{I}) -).

To decide what object kind is the parent of (K - an object kind): (- KindHierarchy-->({K} * 2 + 1) -).

To decide what list of object kinds is the children of (K - an object kind):
	let the result be a list of object kinds;
	repeat with the candidate running through object kinds:
		if the candidate is not the generic object kind and the parent of the candidate is K:
			add the candidate to the result;
	decide on the result.

To say the singular of (K - an object kind): (-
	switch ({K}) {
		0: print "object";
		default: print (I7_Kind_Name)(KindHierarchy-->(2 * {K}));
	}
-).
To say the plural of (K - an object kind): (-
	switch ({K}) {
		0: print "objects";
		1: print "rooms";
		2: print "things";
		default:
			ok_imbue_selfobj({K});
			print (string)(+ yourself +).(KindHierarchy-->(2 * {K}))::plural;
			ok_unimbue_selfobj();
	}
-).

Chapter "Identifying Object Kinds from Descriptions"

Cached object kind identification relates various descriptions of objects to one object kind.

To decide what object kind is the object kind for (D - a description of values of kind K):
	if D relates to an object kind by the cached object kind identification relation:
		decide on the object kind that D relates to by the cached object kind identification relation;
	repeat with the candidate running through object kinds:
		make yourself temporarily behave as if it has the kind the candidate;
		if yourself matches D:
			make yourself behave as if it has its proper kinds again;
			now the cached object kind identification relation relates D to the candidate;
			decide on the candidate;
	make yourself behave as if it has its proper kinds again;
	now the cached object kind identification relation relates D to the generic object kind;
	decide on the generic object kind.

Chapter "Relating Objects and Object Kinds"

Section "Private I6 Hook" - unindexed

To decide whether (O - an object) is of kind (K - an object kind) according to I6: (- ({O} ofclass (KindHierarchy-->(2 * {K}))) -).

Section "Decider, Relation, and Verb"

To decide what object kind is the object kind of (O - an object): (- ({O}.KD_Count) -).

Being of the kind relates an object (called O) to an object kind (called K) when O is of kind K according to I6.
The verb to be of kind implies the being of the kind relation.
The verb to be of the kind implies the being of the kind relation.

Object Kinds ends here.

---- DOCUMENTATION ----

When Object Kinds is included, we can treat the kinds of objects as values in
their own right.  Ordinarily we write these values using the syntax

	the object kind for (K - a kind name in the plural)

For instance,

	showme the object kind for things;

will print

	Object Kind #2

because "thing" is the third kind defined by Inform ("object" is Object Kind #0,
and room is Object Kind #1).  We can also write kinds by number, though this is
less usually useful:

	showme Object Kind #2;

will give the same output.

In the latter case, it may be useful to test

	if (K - an object kind) is valid:
		....

or

	if (K - an object kind) is invalid:
		....

because the extension's other phrases are liable to produce error messages if we
give them an object kind that doesn't actually exist.

Other ways to obtain object kinds are via the loop

	repeat with (I - a nonexisting object kind variable) running through object kinds:
		....

or by asking an object for its kind:

	the object kind of (O - an object)

Once we have a kind, we can get its parent, which is its direct superkind, or
"object" if none exists:

	the parent of (K - an object kind)

as well as a list of its children (its direct subkinds):

	the children of (K - an object kind)

It is also possible to test whether an object has a certain kind via the being
of the kind relation.  For instance:

	if (O - an object) is of kind (K - an object kind):
		....

And we can say the preferred singular and plural forms:

	say "[the singular of (K - an object kind)]"

	say "[the plural of (K - an object kind)]"

Example: * Object Kinds Demonstration - Printing a summary of the story's kind hierarchy.

	*: "Object Kinds Demonstration"

	Include Object Kinds by Brady Garvin.

	There is a room.
	A pteranodon is a kind of animal; a military-grade flying hamster ball is a kind of device.
	Fido is a pteranodon.
	When play begins:
		say "Object kind of the player: [the singular of the object kind of the player].";
		say "Object kind of pteranodons: [the singular of the object kind for pteranodons].";
		repeat with I running through object kinds:
			say "[the singular of I] / [the plural of I]: kind of [the singular of the parent of I].[line break]    Children kinds: ";
			let child printed be false;
			repeat with J running through the children of I:
				say "[if child printed is true], [end if][the singular of J]";
				now child printed is true;
			if child printed is false:
				say "(none)";
			say ".[line break]    Whether the player is of this kind: [whether or not the player is of kind I].[line break]";
			say "    Instance things: [the list of things that are of the kind I]."
