Version 2 of Notepad IT by Leonardo Boselli begins here.

"A system for creating an in-game notepad that the player can write on. Unico cambiamento: traduzione in italiano."

"based on Version 1 of Notepad by Jim Aikin."

Section 1 - Definitions & Buffer Size

A notepad is a kind of thing. A notepad has an indexed text called memo. The memo of a notepad is usually "". A notepad has a list of objects called allowed-pens. The allowed-pens of a notepad is usually {}. A notepad has a truth state called pen-needed. The pen-needed of a notepad is usually true. A notepad can be edit-allowing or non-edit-allowing. A notepad is usually edit-allowing.

Termination type is a kind of value. The termination types are terminated and unterminated.

To decide which termination type is the terminor of (T - indexed text):
	let N be the number of characters in T;
	let C be indexed text;
	let C be character number N in T;
	if C is ".":
		decide on terminated;
	otherwise if C is "?":
		decide on terminated;
	otherwise if C is "!":
		decide on terminated;
	decide on unterminated.

Section 2 - Reading

Understand the command "leggi" as something new.

Reading is an action applying to one visible thing and requiring light. Understand "leggi [something]" as reading.

Check an actor reading (this is the ordinary check reading rule):
	if the actor is the player:
		if the noun is not a notepad:
			try examining the noun instead;
		otherwise if the memo of the noun is "":
			say "Non c[']è scritto nulla [sup the noun]." instead;
	otherwise:
		if the noun is not a notepad:
			say "[The actor] non può farlo.";
			rule succeeds;
		otherwise if the memo of the noun is "":
			say "'Non c[']è scritto nulla [sup the noun]', dice [the actor].";
			rule succeeds.

Carry out an actor reading (this is the ordinary carry out reading rule):
	if the actor is the player:
		if the memo of the noun is not "":
			let term be the terminor of the memo of the noun;
			say "Il testo [sup the noun] è: [run paragraph on]";
			if term is terminated:
				say "'[memo of the noun]'[paragraph break]";
			otherwise:
				say "'[memo of the noun].'";
		otherwise:
			say "Non c[']è scritto nulla [sup the noun].";
	otherwise:
		if the memo of the noun is not "":
			say "'Il testo [sup the noun] è: ['][memo of the noun]['],', dice [the actor].";
		otherwise:
			say "'Non c[']è scritto nulla [sup the noun]', dice [the actor]."

After examining a notepad (called N) (this is the notepad output rule):
	if the memo of N is not "":
		let term be the terminor of the memo of N;
		say "Il testo [sup the N] è: [run paragraph on]";
		if term is terminated:
			say "'[memo of N]'[paragraph break]";
		otherwise:
			say "'[memo of N].'"

Section 3 - Writing It On

Writing it on is an action applying to one topic and one thing and requiring light. Understand "scrivi [text] su/sul/sullo/sulla/sui/sugli/sulle/sull [something]" as writing it on.

Check an actor writing on something (this is the ordinary check writing it on rule):
	let carrying-pen be a truth state;
	let carrying-pen be false;
	if the actor is the player:
		if the second noun is not a notepad:
			say "Non puoi scrivere [sup the second noun]." instead;
		otherwise if the second noun is non-edit-allowing:
			say "[The second noun] [if the second noun is plural-named]sono[otherwise]è[end if] protetto da scrittura e non ci si può scrivere sopra." instead;
		if the pen-needed of the second noun is true:
			repeat with P running through the allowed-pens of the second noun:
				if the player carries P:
					now carrying-pen is true;
		otherwise:
			now carrying-pen is true;
		if carrying-pen is false:
			say "Non hai nulla con cui poter scrivere." instead;
	otherwise:
		if the second noun is not a notepad:
			say "[The actor] non può scrivere nulla [sup the second noun].";
			rule succeeds;
		otherwise if the second noun is non-edit-allowing:
			say "[The second noun] [if the second noun is plural-named]sono[otherwise]è[end if] protetto da scrittura e non ci si può scrivere sopra.";
			rule succeeds;
		if the pen-needed of the second noun is true:
			repeat with P running through the allowed-pens of the second noun:
				if the actor carries P:
					now carrying-pen is true;
		otherwise:
			now carrying-pen is true;
		if carrying-pen is false:
			say "[The actor] non ha nulla con cui poter scrivere.";
			rule succeeds.

Carry out an actor writing on something (this is the ordinary carry out writing it on rule):
	let T be indexed text;
	let T be the topic understood;
	now the memo of the second noun is T;
	if the actor is the player:
		say "Hai scritto '[T]' [sup the second noun].";
	otherwise:
		say "[The actor] ha scritto '[T]' [sup the second noun]."

Section 4 - Adding It To

Adding it to is an action applying to one topic and one thing and requiring light. Understand "aggiungi [text] su/sul/sullo/sulla/sui/sugli/sulle/sull [something]" as adding it to.
Check an actor adding to something (this is the ordinary check adding it to rule):
	let carrying-pen be a truth state;
	let carrying-pen be false;
	if the second noun is not a notepad:
		if the actor is the player:
			say "Non puoi scrivere nulla [sup the second noun]." instead;
		otherwise:
			say "[The actor] non può scrivere nulla [sup the second noun].";
			rule succeeds;
	otherwise if the second noun is non-edit-allowing:
		say "[The second noun] [if the second noun is plural-named]sono[otherwise]è[end if] protetto da scrittura e non ci si può scrivere nulla.";
		rule succeeds;
	if the pen-needed of the second noun is true:
		now carrying-pen is false;
		repeat with P running through the allowed-pens of the second noun:
			if the actor carries P:
				now carrying-pen is true;
	otherwise:
		now carrying-pen is true;
	if carrying-pen is false:
		if the actor is the player:
			say "Non hai nulla con cui poter scrivere." instead;
		otherwise:
			say "[The actor] non ha nulla con cui poter scrivere.";
			rule succeeds.

Carry out an actor adding to something (this is the ordinary carry out adding it to rule):
	let T be indexed text;
	let T be the topic understood;
	let C be indexed text;
	let C be the memo of the second noun;
	now the memo of the second noun is "[C] [T]";
	if the actor is the player:
		say "Hai aggiunto [run paragraph on]";
	otherwise:
		say "[The actor] aggiunge [run paragraph on]";
	say "al testo [sup the second noun]. Il testo ora è: [run paragraph on]";
	let term be the terminor of the memo of the second noun;
	if term is terminated:
		say "'[memo of the second noun]'[paragraph break]";
	otherwise:
		say "'[memo of the second noun].'"

Section 5 - Copying It To

Copying it to is an action applying to two things and requiring light. Understand "copia [something] su [something]", "copia il/lo/la/i/gli/le/l [something] su/sul/sullo/sulla/sui/sugli/sulle/sull [something]", "ricopia [something] su [something]", "ricopia il/lo/la/i/gli/le/l [something] su/sul/sullo/sulla/sui/sugli/sulle/sull [something]" as copying it to.

Check an actor copying something to something (this is the ordinary check copying it to rule):
	let carrying-pen be a truth state;
	let carrying-pen be false;
	if the noun is not a notepad:
		say "Non si può copiare alcun testo [dap the noun]." instead;
	otherwise if the second noun is not a notepad:
		if the actor is the player:
			say "Non puoi [run paragraph on]";
		otherwise:
			say "[The actor] non può [run paragraph on]";
		say "copiare del testo [sup the second noun]!";
		rule succeeds;
	otherwise if the noun is the second noun:
		if the actor is the player:
			say "Non puoi [run paragraph on]";
		otherwise:
			say "[The actor] non può [run paragraph on]";
		say "copiare del testo su se stesso.";
		rule succeeds;
	otherwise if the second noun is non-edit-allowing:
		say "[The second noun] [if the second noun is plural-named]sono[otherwise]è[end if] protetto da scrittura e non ci si può scrivere sopra.";
		rule succeeds;
	otherwise if the memo of the noun is "":
		say "Al momento non c[']è scritto nulla [sup the noun]." instead;
	if the pen-needed of the second noun is true:
		now carrying-pen is false;
		repeat with P running through the allowed-pens of the second noun:
			if the player carries P:
				now carrying-pen is true;
	otherwise:
		now carrying-pen is true;
	if carrying-pen is false:
		if the actor is the player:
			say "Non hai [run paragraph on]";
		otherwise:
			say "[The actor] non ha [run paragraph on]";
		say "nulla con cui poter scrivere [sup the second noun].";
		rule succeeds.

Carry out an actor copying something to something (this is the ordinary carry out copying it to rule):
	now the memo of the second noun is the memo of the noun;
	if the actor is the player:
		say "Hai [run paragraph on]";
	otherwise:
		say "[The actor] ha [run paragraph on]";
	say "copiato il contenuto [dip the noun] [sup the second noun] e quindi il testo [sup the second noun] ora  è: [run paragraph on]";
	let term be the terminor of the memo of the second noun;
	if term is terminated:
		say "'[memo of the second noun]'[paragraph break]";
	otherwise:
		say "'[memo of the second noun].'"

Section 6 - Erasing

Erasing is an action applying to one thing and requiring light. Understand "cancella [something]" and "cancella il/lo/la/i/gli/le/l [something]" as erasing.

Check an actor erasing (this is the ordinary check erasing rule):
	if the noun is not a notepad:
		say "Non c[']è nulla da cancellare [sup the noun].";
		rule succeeds;
	otherwise if the memo of the noun is "":
		say "Al momento non c[']è scritto nulla [sup the noun].";
		rule succeeds;
	otherwise if the noun is non-edit-allowing:
		say "[The noun] [if the noun is plural-named]sono[otherwise]è[end if] protetto da scrittura e non ci si può scrivere sopra.";
		rule succeeds.

Carry out an actor erasing (this is the ordinary carry out erasing rule):
	now the memo of the noun is "";
	if the actor is the player:
		say "Hai [run paragraph on]";
	otherwise:
		say "[The actor] ha [run paragraph on]";
	say "cancellato ciò che era scritto [sup the noun] lasciandolo vuoto."

Section 7 - Erasing It From

Erasing it from is an action applying to one topic and one thing and requiring light. Understand "cancella [text] da/dal/dallo/dalla/dai/dagli/dalle/dall [something]" as erasing it from.

Check an actor erasing from something (this is the ordinary check erasing it from rule):
	if the second noun is not a notepad:
		if the actor is the player:
			say "Non puoi [run paragraph on]";
		otherwise:
			say "[The actor] non può [run paragraph on]";
		say "cancellare nulla [dap the second noun].";
		rule succeeds;
	otherwise if the memo of the second noun is "":
		say "Non c[']è scritto nulla [sup the second noun], così nulla può essere cancellato.";
		rule succeeds;
	otherwise if the second noun is non-edit-allowing:
		say "[The second noun] [if the second noun is plural-named]sono[otherwise]è[end if] protetto da scrittura e non ci si può scrivere nulla sopra.";
		rule succeeds.

Carry out an actor erasing from something (this is the ordinary carry out erasing it from rule):
	let T be indexed text;
	let T be the topic understood;
	let C be indexed text;
	let C be the memo of the second noun;
	if C matches the text T, case insensitively:
		replace the text T in C with "", case insensitively;
		[this next line gets rid of extra spaces when words are deleted:]
		replace the text "\s{2,}" in C with " ";
		[we'll also get rid of a first or trailing space:]
		let char be indexed text;
		let char be character number 1 in C;
		if char is " ":
			replace character number 1 in C with "";
		let N be the number of characters in C;
		let char be character number N in C;
		if char is " ":
			replace character number N in C with "";
		now the memo of the second noun is C;
		say "La cancellatura lascia [sup the second noun] il testo: [run paragraph on]";
		let term be the terminor of the memo of the second noun;
		if term is terminated:
			say "'[memo of the second noun]'[paragraph break]";
		otherwise:
			say "'[memo of the second noun].'";
	otherwise:
		if the actor is the player:
			say "Il testo '[T]' non sembra scritto da nessuna parte [sup the second noun].";
		otherwise:
			say "'Il testo ['][T]['] non sembra scritto da nessuna parte [sup the second noun]', dice [the actor]."

Section 8 - Protecting and Unprotecting

Protecting is an action out of world applying to one thing. Understand "proteggi [something]" and "proteggi il/lo/la/i/gli/le/l [something]" as protecting.

Check protecting:
	if the noun is not a notepad:
		say "L[']azione non può essere usata con [the noun]." instead;
	otherwise if the noun is non-edit-allowing:
		say "[The noun] è già protetto da scrittura." instead.

Carry out protecting:
	now the noun is non-edit-allowing.

Report protecting:
	say "Hai protetto da scrittura il testo [sup the noun]."

Unprotecting is an action out of world applying to one thing. Understand "sproteggi [something]" and "sproteggi il/lo/la/i/gli/le/l [something]" as unprotecting.

Check unprotecting:
	if the noun is not a notepad:
		say "L[']azione non può essere usata con [the noun]." instead;
	otherwise if the noun is edit-allowing:
		say "[The noun] non è protetto da scrittura." instead.

Carry out unprotecting:
	now the noun is edit-allowing.

Report unprotecting:
	say "[The noun] non è più protetto da scrittura."

Notepad IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Notepad by Jim Aikin.
