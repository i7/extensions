Version 3 of Written Inventory IT by Leonardo Boselli begins here.

"Provides a framework for listing inventories in natural sentences. Separates carried and worn objects, followed by objects that contains other objects. What's listed in the third section is customisable via a rulebook. Unica modifica: traduzione in italiano."

"basato su Written Inventory by Jon Ingold."

Encasement relates a thing (called X) to a thing (called Y) when X is part of Y or X is held by Y[] or X is worn by Y[]. The verb to be encased by implies the encasement relation.

Definition: a container is empty if the number of things in it is zero. 
Definition: a supporter is empty if the number of things on it is zero. 
Definition: a thing is empty if the number of things encased by it is zero.

[Definition: a thing is non-empty if it is not empty.]
Definition: a thing is non-empty if it is not closed and it is not empty.

Inventory listing the contents of something is an activity. 

The print empty inventory rule is not listed in the carry out taking inventory rules.
The print standard inventory rule is not listed in the carry out taking inventory rules.

[
The first carry out taking inventory rule (this is the intro list rule):
	say "[run paragraph on]";
]

Carry out taking inventory when the number of things had by the player is zero (this is the new empty inventory rule): 
	 say "Non hai niente in mano." instead;

Carry out taking inventory when the number of things carried by the player is greater than zero (this is the basic carrying inventory rule):
	say "In mano hai";
	let IDX be 0;
	let MAX be the number of things carried by the player;
	repeat with TENUTO running through the things carried by the player:
		increase IDX by 1;
		say " [a TENUTO]";
		let IDX2 be 0;
		let MAX2 be the number of non-empty things incorporated by the TENUTO;
		if the TENUTO is not closed and the TENUTO is not empty:
			increase IDX2 by 1;
			say " (in cui [is-are a list of things in the TENUTO]";
		otherwise if the TENUTO is a supporter:
			increase IDX2 by 1;
			say " (in cui [is-are a list of things on the TENUTO]";
		repeat with PARTE running through the non-empty things incorporated by the TENUTO:
			increase IDX2 by 1;
			if IDX2 is 1:
				say " (";
			otherwise if IDX2 is less than MAX2 minus 1:
				say ", ";
			otherwise:
				say " e ";
			if PARTE is a container:
				say "[inp cui PARTE] [is-are a list of things in the PARTE]";
			otherwise if parte is a supporter:
				say "[sup cui PARTE] [is-are a list of things on the PARTE]";
		if IDX2 is greater than 0:
			say ")";
		if IDX is less than MAX minus 1:
			say ",";
		otherwise if IDX is MAX minus 1:
			say " e";
	say ".[run paragraph on][if the player wears something] Inoltre [otherwise][line break][line break][end if]";

Carry out taking inventory when the number of things worn by the player is greater than zero (this is the basic wearing inventory rule): 
	say  "[if the player carries something]i[otherwise]I[end if]ndossi";
	let IDX be 0;
	let MAX be the number of things worn by the player;
	repeat with INDOSSATO running through the things worn by the player:
		increase IDX by 1;
		say " [a INDOSSATO]";
		let IDX2 be 0;
		let MAX2 be the number of non-empty things incorporated by the INDOSSATO;
		if the INDOSSATO is not closed and the INDOSSATO is not empty:
			increase IDX2 by 1;
			say " (in cui [is-are a list of things in the INDOSSATO]";
		otherwise if the INDOSSATO is a supporter:
			increase IDX2 by 1;
			say " (in cui [is-are a list of things on the INDOSSATO]";
		repeat with PARTE running through the non-empty things incorporated by the INDOSSATO:
			increase IDX2 by 1;
			if IDX2 is 1:
				say " (";
			otherwise if IDX2 is less than MAX2 minus 1:
				say ", ";
			otherwise:
				say " e ";
			if PARTE is an container:
				say "[inp cui PARTE] [is-are a list of things in the PARTE]";
			otherwise if parte is a supporter:
				say "[sup cui PARTE] [is-are a list of things on the PARTE]";
		if IDX2 is greater than 0:
			say ")";
		if IDX is less than MAX minus 1:
			say ",";
		otherwise if IDX is MAX minus 1:
			say " e";
	say ".";
	
[
Carry out taking inventory when the number of things carried by the player is greater than zero (this is the basic carrying inventory rule): 
	say "In mano hai [a list of things carried by the player].[if the player wears something] Inoltre [end if][run paragraph on]";

Carry out taking inventory when the number of things worn by the player is greater than zero (this is the basic wearing inventory rule): 
	if the number of things worn by the player is greater than zero, say  "[if the player carries something]i[otherwise]I[end if]ndossi [a list of things worn by the player][run paragraph on]";

Carry out taking inventory (this is the set up second-level inventory list rule):
	now everything is unmentioned;
	now the player is mentioned; 

Carry out taking inventory (this is the deliver second-level inventory list rule):
	let item be a random unmentioned [non-empty] thing encased by something mentioned;
	while item is a thing:
		if the item is non-empty:
			carry out the inventory listing the contents activity with the item;
		now the item is mentioned;
		let item be a random unmentioned [non-empty] thing encased by something mentioned;
	say "."

Rule for inventory listing the contents of an open container (called the item):
	let superitem be a random thing that incorporates the item;
	say ". Dentro [the item] [if the superitem is not nothing][dip the superitem] [end if][is-are a list of things in the item][run paragraph on]" instead;

Rule for inventory listing the contents of a supporter (called the item):
	let superitem be a random thing that incorporates the item;
	say ". Sopra [the item] [if the superitem is not nothing][dip the superitem] [end if][is-are a list of things on the item][run paragraph on]" instead;

Rule for inventory listing the contents of a thing (called the item):
	do nothing instead;
]

[
the printing lit thing in inventory rule is not listed in any rulebook.
the printing open container in inventory rule is not listed in any rulebook.
the printing closed container in inventory rule is not listed in any rulebook.
the printing open empty container in inventory rule is not listed in any rulebook.
the printing worn thing in inventory rule is not listed in any rulebook.
]

Written Inventory IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di Written Inventory by Jon Ingold.
