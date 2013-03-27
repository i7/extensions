Version 3 of Written Inventory IT by Leonardo Boselli begins here.

"Provides a framework for listing inventories in natural sentences. Separates carried and worn objects, followed by objects that contains other objects. What's listed in the third section is customisable via a rulebook. Unica modifica: traduzione in italiano."

"basato su Written Inventory by Jon Ingold."

Encasement relates a thing (called X) to a thing (called Y) when X is part of Y or X is held by Y. The verb to be encased by implies the encasement relation.

Definition: a container is empty if the number of things in it is zero. 
Definition: a supporter is empty if the number of things on it is zero. 
Definition: a thing is empty if the number of things encased by it is zero.

Definition: a thing is non-empty if it is not empty. 

Inventory listing the contents of something is an activity. 

The print empty inventory rule   is not listed in the carry out taking inventory rules.
The print standard inventory rule  is not listed in the carry out taking inventory rules.

[
The first carry out taking inventory rule (this is the intro list rule):
	say "[run paragraph on]";
]

Carry out taking inventory when the number of things had by the player is zero (this is the new empty inventory rule): 
	 say "Non hai niente in mano." instead;

Carry out taking inventory when the number of things carried by the player is greater than zero (this is the basic carrying inventory rule): 
	say "Hai [a list of things carried by the player] in mano[if the player wears something]; inoltre [end if][run paragraph on]";

Carry out taking inventory when the number of things worn by the player is greater than zero (this is the basic wearing inventory rule): 
	if the number of things worn by the player is greater than zero, say  "[if the player carries something]i[otherwise]I[end if]ndossi [a list of things worn by the player][run paragraph on]";

Carry out taking inventory (this is the set up second-level inventory list rule):
	now everything is unmentioned; 
	now the player is mentioned; 

Carry out taking inventory (this is the deliver second-level inventory list rule):
	let item be a random unmentioned non-empty thing encased by something mentioned;
	while item is a thing begin;
		carry out the inventory listing the contents activity with the item;
		now the item is mentioned;
		let item be a random unmentioned non-empty thing encased by something mentioned;
	end while;
	say "."

Rule for inventory listing the contents of an open container (called the item):
	say ". Dentro [the item] [is-are a list of things in the item][run paragraph on]" instead;

Rule for inventory listing the contents of a supporter (called the item):
	say ". Sopra [the item] [is-are a list of things on the item][run paragraph on]" instead;

Rule for inventory listing the contents of a thing (called the item):
	do nothing instead;

Written Inventory IT ends here.

---- DOCUMENTATION ----

Vedi documentazione originale di Written Inventory by Jon Ingold.