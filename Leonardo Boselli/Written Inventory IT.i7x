Version 3/140824 of Written Inventory IT by Leonardo Boselli begins here.

"Just italian responses for Version 3 of Written Inventory by Jon Ingold. Provides a framework for listing inventories in natural sentences. Separates carried and worn objects, followed by objects that contains other objects. What's listed in the third section is customisable via a rulebook."

Include Written Inventory by Leonardo Boselli.


Chapter - Responses

the intro list rule response (A) is "[run paragraph on]".
the new empty inventory rule response (A) is "Non [regarding the player][hai] niente in mano.".
the basic carrying inventory rule response (A) is "In mano [regarding the player][hai] [a list of things carried by the player].[if the player wears something] Inoltre [end if][run paragraph on]".
the basic wearing inventory rule response (A) is "[regarding the player][if the player carries something][indossi][otherwise][maiuscolo][Indossi][maiuscolo][end if] [a list of things worn by the player][run paragraph on]".
the listing open container rule response (A) is ". Dentro [the item] [is-are a list of things in the item][run paragraph on]".
the listing supporter rule response (A) is ". Sopra [the item] [is-are a list of things on the item][run paragraph on]".

[Alternative Written Inventory]
[
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
]	


Written Inventory IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 3 of Written Inventory by Jon Ingold.