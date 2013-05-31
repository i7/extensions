Constraint Solver by David Corbett begins here.

[TODO:
constraints as rules/activities
infinite domains (with initial value(s) and successor function)
look-ahead
remove repeated code
speed tests
readable code
better name than "var"
write validation rules for debugging
non-binary constraints
backtrack immediately when a domain is empty
remove debugging
deal with unsolvable problems
multiple independent CSPs i.e. no single Table of Constraints
remove repeated code
]

A var is a kind of thing.
A var has a list of numbers called the domain.
A var has a number called the index.
A var has a list of numbers called the history.

Table of Constraints
vars	constraint
(list of vars)	(phrases list of numbers -> number)

When play begins:
	repeat with x running through vars:
		change the history of x to have (number of entries in the domain of x) entries.

To solve (CSP - list of vars):
	let n be the number of entries in the CSP;
	repeat with i running from 1 to n:
		now the index of entry i in the CSP is i;
	let the value list be a list of numbers;
	extend the value list to n entries;
	let i be 1;
	while i is greater than 0 and i is at most n:
		say "[line break]i: [i].";
		say "current vars: [CSP in brace notation].";
		say "current values: [value list in brace notation].";
		let good-to-go be a truth state;
		repeat with D_i running from 1 to the number of entries in the domain of entry i in the CSP:
			say "[entry i in the CSP]([D_i]): [entry D_i in the domain of entry i in the CSP] ~ [entry D_i in the history of entry i in the CSP].";
			if entry D_i in the history of entry i in the CSP is not 0:
				next; [i.e. this value in the domain was marked inconsistent in a previous iteration]
			now entry i of the value list is entry D_i in the domain of entry i in the CSP;
			now good-to-go is whether or not the CSP is consistent with the value list through i;
			if good-to-go is true: [passed all constraints]
				say "passed all constraints.";
				now good-to-go is whether or not forward checking passes on the value list through i;
				if good-to-go is true:
					say "passed forward checking.";
[					now entry i in the value list is entry D_i in the domain of entry i in the CSP;]
					increase i by 2;
					break;
			if good-to-go is false: [failed any constraint or forward checking failed]
				say "failed any constraint or failed forward checking.";
				[unmark-as-inconsistent members of the domain with mark i-1:]
				repeat with H_i running from 1 to the number of entries in the history of entry i in the CSP:
					if entry H_i in the history of entry i in the CSP is i - 1:
						now entry H_i in the history of entry i in the CSP is 0; [TODO: duplicated in forward-checking? maybe this is unneeded here]
		decrement i;
	[debugging info:]
	say "vars: [CSP in brace notation].";
	say "values: [value list in brace notation]."

[TODO: parameterize by constraint set]
To decide whether (CSP - list of vars) is consistent with (value list - list of numbers) through (i - number):
	say "decide whether [CSP in brace notation] is consistent with [value list in brace notation] through [i].";
	let the current var be entry i in the CSP;
	let V be a list of numbers;
	repeat through the Table of Constraints:
		let relevant be true;
		now V is {};
		repeat with x running through the vars entry:
			if the index of x is greater than i:
				now relevant is false;
				break;
			add entry (index of x) in the value list to V;
		if relevant is false:
			say "	irrelevant: [constraint entry].";
			next;
		say "	relevant: [constraint entry].";
		if constraint entry applied to V is 0:
			say "	failed on [V in brace notation].";
			no;
	yes.

To decide whether forward checking passes on (value list - list of numbers) through (i - number):
	say "decide whether forward checking passes on [value list in brace notation] through [i].";
	let forward-checking-passes be true;
	let the candidate value list be a list of numbers;
	repeat through the Table of Constraints:
		say "	consider [constraint entry].";
		[the constraint must apply to exactly 1 unassigned var and any number of assigned vars]
		let the unassigned count be 0;
		let the unassigned index be 0;
		let the unassigned var be an object;
		now the candidate value list is {};
		repeat with x running through the vars entry:
			if the unassigned var is nothing:
				increment the unassigned index;
			if the index of x is greater than i:
				increment the unassigned count;
				if the unassigned count is 2:
					break;
				now the unassigned var is x;
			add entry (index of x) in the value list to the candidate value list;
		if unassigned count is not 1:
			next;
		say "	the unassigned var: [unassigned var].";
		say "	the unassigned index: [unassigned index].";
		say "	cand val list: [candidate value list in brace notation].";
		[check each value against the constraint]
		repeat with D_i running from 1 to the number of entries in the domain of the unassigned var:
			say "	unvar([D_i]): [entry D_i in the domain of the unassigned var] ~ [entry D_i in the history of the unassigned var].";
			if entry D_i in the history of the unassigned var is not 0:
				next;
			now entry (unassigned index) in the candidate value list is entry D_i in the domain of the unassigned var;
			if the constraint entry applied to the candidate value list is 0:
				now entry D_i in the history of the unassigned var is i;
		if 0 is not listed in the history of the unassigned var:
			[the domain is empty so we will roll back]
			now forward-checking-passes is false;
			break;
	if forward-checking-passes is true:
		yes;
	[roll back if necessary]
	repeat with x running through vars:
		repeat with D_i running from 1 to the number of entries in the history of x:
			if entry D_i in the history of x is i:
				now entry D_i in the history of x is 0;
	no.

Constraint Solver ends here.
