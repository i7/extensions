Constraint Solver by David Corbett begins here.

[TODO:
constraints as rules/activities
infinite domains (with initial value(s) and successor function)
look-ahead
speed tests
readable code
better name than "var"
write validation rules for debugging
non-binary constraints
backtrack immediately when a domain is empty
remove debugging
]

A var is a kind of thing.
A var has a list of lists of numbers called the domain.
A var has a number called the index.

Table of Constraints
vars	constraint
(list of vars)	(list of lists of numbers)

The stack is a list of vars which varies.

To solve the constraints on (vars-list - list of vars):
	let n be the number of entries in vars-list;
[	sort L in random order;]
	let the value stack be a list of numbers;
	let i be 1;
	let the last index stack be a list of numbers;
	change the value stack to have n entries;
	change the last index stack to have n entries;
	repeat with x running from 1 to n:
		now the index of (entry x in vars-list) is x; [initialize indexes of vars for later lookup]
	while i is positive and i is at most n:
		say "vars([i]) = [entry i in vars-list].";
		say "values = [value stack in brace notation].";
		say "last indexes = [last index stack in brace notation].";
		let V be a number;
		let passed-all-constraints be a truth state;
		[ loop: find the first value that breaks no constraint ]
		repeat with v_i running from (entry i in the last index stack) + 1 to (the number of entries in entry 1 in the domain of entry i in vars-list):
			now V is entry v_i in entry 1 in the domain of entry i in vars-list;
			now entry i in the last index stack is v_i;
			if entry i in vars-list of V is okay with the value stack up to i:
				now passed-all-constraints is true;
				break;
		[now value is a good value, if there is any]
		if passed-all-constraints is false:
			now entry i of the last index stack is 0;
			roll back entry i in vars-list;
			decrement i;
		otherwise:
			now entry i in the value stack is v;
			prune vars-list up to i;
			increment i;
	say line break;
	say "[vars-list in brace notation].";
	say "[value stack in brace notation]."

[for testing]
To decide whether player consents to (V - var) of (N - number):
	say "[V] == [N]? ";
	if the player consents, yes;
	no.

To decide whether (X - var) of (V - number) is okay with (L - list of numbers) up to (max - number):
	let P be a list of numbers;
	repeat through the Table of Constraints:
		now P is {};
		if X is entry 1 in the vars entry:
			add V to P;
			add entry (index of entry 2 in the vars entry) in L to P;
			if index of entry 2 in the vars entry is greater than max:
				next;
		otherwise if X is entry 2 in the vars entry:
			add entry (index of entry 1 in the vars entry) in L to P;
			if index of entry 1 in the vars entry is greater than max:
				next;
			add V to P;
		otherwise:
			next;
		decide on whether or not P is listed in the constraint entry;
	yes.

[The domain of X must have at least 2 entries.]
To roll back (X - var):
	say "roll back [X].";
	let D be entry 1 in the domain of X;
	remove entry 1 from the domain of X;
	add D to entry 1 in the domain of X.

To prune (L - list of vars) up to (max - number):
	repeat through the Table of Constraints:
		say "constraint: [vars entry in brace notation].";
		let rejects be a list of numbers;
		let unassigned be a number;
		let assigned be a number;
		if the index of entry 1 of the vars entry is greater than max and the index of entry 2 of the vars entry is at most max:
			now unassigned is 1;
			now assigned is 2;
		otherwise if the index of entry 1 of the vars entry is at most max and the index of entry 2 of the vars entry is greater than max:
			now assigned is 1;
			now unassigned is 2;
		otherwise:
			say "    ignore.";
			next;
		say "    unassigned: [unassigned].";
		repeat with N running through entry 1 of the domain of entry unassigned of the vars entry:
			say "        N: [N].";
			let okay be false;
			repeat with P running through the constraint entry:
				say "            P: [P in brace notation].";
				if entry unassigned of P is N and entry assigned of P is listed in entry 1 of the domain of entry assigned of the vars entry:
					now okay is true;
					break;
			if okay is false:
				say "        reject [N].";
				add N to rejects;
		say "rejects from [entry unassigned of the vars entry]: [rejects in brace notation].";
		remove rejects from entry 1 of the domain of entry unassigned of the vars entry;
		add rejects at entry 2 in the domain of entry unassigned of the vars entry;

Constraint Solver ends here.
