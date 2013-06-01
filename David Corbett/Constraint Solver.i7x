Constraint Solver by David Corbett begins here.

[TODO:
constraints as rules/activities?
infinite domains (with initial value(s) and successor function)
non-numeric domains
speed tests
readable code
better name than "var"
write validation rules for debugging
remove debugging
multiple independent CSPs i.e. no single Table of Constraints
forward checking with multiple unassigned vars
]

A var is a kind of thing.
A var has a list of numbers called the domain.
A var has a list of numbers called the history.
A var has a number called the index.
A var has a number called the previous value index.

Table of Constraints
vars	constraint
(list of vars)	(phrases list of numbers -> number)

When play begins:
	repeat with x running through vars:
		change the history of x to have (number of entries in the domain of x) entries;
		change the previous value index of x to 0.

To decide what list of lists of numbers is all solutions of (CSP - list of vars):
	decide on -1 solutions of CSP.

To decide what list of lists of numbers is (solution limit - number) solutions/solution of (CSP - list of vars):
	let the solutions be a list of lists of numbers;
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
		let forward-checking-passed be a truth state;
		repeat with D_i running from the previous value index of entry i in the CSP + 1 to the number of entries in the domain of entry i in the CSP:
			say "[entry i in the CSP]([D_i]): [entry D_i in the domain of entry i in the CSP] ~ [entry D_i in the history of entry i in the CSP].";
			now the previous value index of entry i in the CSP is D_i;
			if entry D_i in the history of entry i in the CSP is not 0:
				next; [This value was marked inconsistent in a previous iteration.]
			now entry i of the value list is entry D_i in the domain of entry i in the CSP;
			now forward-checking-passed is whether or not forward checking passes on the value list through i;
			if forward-checking-passed is true:
				break;
		if forward-checking-passed is false or i is n and the number of entries in the solutions is not the solution limit:
			if forward-checking-passed is true, add the value list to the solutions;
			now the previous value index of entry i in the CSP is 0;
			decrement i;
		otherwise:
			increment i;
	say "final i: [i].";
	say "vars: [CSP in brace notation].";
	say "values: [value list in brace notation].";
	say "solutions: [solutions in brace notation].";
	decide on the solutions.

[TODO: parameterize by constraint set]
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
		[Check each value against the constraint:]
		repeat with D_i running from 1 to the number of entries in the domain of the unassigned var:
			say "	unvar([D_i]): [entry D_i in the domain of the unassigned var] ~ [entry D_i in the history of the unassigned var].";
			if entry D_i in the history of the unassigned var is not 0:
				next;
			now entry (unassigned index) in the candidate value list is entry D_i in the domain of the unassigned var;
			if the constraint entry applied to the candidate value list is 0:
				now entry D_i in the history of the unassigned var is i;
		if 0 is not listed in the history of the unassigned var:
			[The domain is empty so we will roll back.]
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
