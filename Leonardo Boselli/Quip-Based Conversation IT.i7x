Version 4 of Quip-Based Conversation IT by Leonardo Boselli begins here.

"Un[']estensione a Reactable Quips per permettere un più tradizionale consersazione basata su menù. L[']unica modifica è la traduzione in italiano."

"basato su Version 4 of Quip-Based Conversation by Michale Martin."

Include Version 9 of Reactable Quips IT by Leonardo Boselli.
Include Italian by Leonardo Boselli.

Section 1 - Cancelling ASK, TELL, and ORDERS

[
Before asking someone about: clue talking instead.
Before telling someone about: clue talking instead.
Before answering someone that: clue talking instead.
Before asking someone to try doing something: clue talking instead.

To clue talking:
	say "[bracket]Use TALK TO to interact with characters.[close bracket][paragraph break]".
]

Section 2 - Member fields and default values

A person has a quip called a greeting.  The greeting of a person is usually quip_null.
A person has a table-name called the litany.  The litany of a person is usually the Table of No Conversation.  

[This is the currently active litany.]
The qbc_litany is a table-name that varies.  The qbc_litany is the Table of No Conversation.

Table of No Conversation
prompt	response	enabled
a text	a quip		a number

[ QBC is never active if RQ is. ]
To decide whether QBC is active:
	if the number of filled rows in the qbc_litany is not zero and not RQ is active, yes;
	no.

Section 3 - Initiating conversations

Talking to is an action applying to one visible thing.  Understand "parla [something]" or "parla [a-art] [something]" as talking to.

Check talking to: 
	if the noun provides the property litany and the noun provides the property greeting, do nothing; 
	otherwise say "In genere, è meglio parlare ad esseri viventi." instead.

Check talking to:
	if the greeting of the noun is quip_null and the number of filled rows in the litany of the noun is zero, say "Non ti viene in mente nulla da dire in particolare." instead.

Carry out talking to:
	if the greeting of the noun is not quip_null, deliver the greeting of the noun quip;
	if the number of filled rows in the litany of the noun is not zero:
		change the qbc_litany to the litany of the noun;
		display the QBC options.

[This is for when we have a Reactable Quips-style followup in the middle of a conversation.]
After responding with (this is the revert to normal conversation rule):
	display the QBC options.

To display the QBC options:
	if the game is over, stop;
	if RQ is active, stop;
	let qbc_index be 0;
	repeat through qbc_litany:
		if the enabled entry is 1:
			increase qbc_index by 1;
			say "[bracket][qbc_index][close bracket] [prompt entry][line break]";
	if qbc_index is not 0, change the number understood to 0;
	otherwise terminate the conversation.

Does the player mean talking to a person: it is likely.

Section 4 - Delivering lines

QBC responding with is an action applying to one number.  Understand "[number]" or "dì [number]" as QBC responding with when QBC is active.

Carry out QBC responding with (this is the perform talking rule):
	let qbc_index be 0;
	repeat through the qbc_litany:
		if the enabled entry is 1:
			increase qbc_index by 1;
			if qbc_index is the number understood:
				change the enabled entry to 0;
				deliver the response entry quip;
				display the QBC options;
				rule succeeds;
	say "[bracket]Le risposte valide sono comprese tra 1 e [qbc_index].  Scrivi RIPETI per elencare le opzioni.[close bracket][paragraph break]".

Section 5 - Recaps

QBC recap is an action out of world applying to nothing.  Understand "ripeti" or "ricapitola" as QBC recap when QBC is active.

Carry out QBC recap (this is the perform QBC recap rule):
	let qbc_index be 0;
	repeat through qbc_litany:
		if the enabled entry is 1:
			increase qbc_index by 1;
			if qbc_index is 1, say "Le opzioni disponibili sono:[paragraph break]";
			say "[bracket][qbc_index][close bracket] [prompt entry][line break]";
	[This "can't happen" but there's no reason to not check.]
	if qbc_index is 0, say "[bracket]Al momento non stai conversando.[close bracket][paragraph break]";

Section 6 - Utility functions

To enable the (q - a quip) quip for (o - a thing):
	repeat through the litany of o:
		if the response entry is q, change the enabled entry to 1.

To disable the (q - a quip) quip for (o - a thing):
	repeat through the litany of o:
		if the response entry is q, change the enabled entry to 0.

To enable the (q - a quip) quip:
	repeat through the qbc_litany:
		if the response entry is q, change the enabled entry to 1.

To disable the (q - a quip) quip:
	repeat through the qbc_litany:
		if the response entry is q, change the enabled entry to 0.

To shift the conversation to (t - a table-name):
	change the qbc_litany to t.

To run a conversation on (t - a table-name):
	shift the conversation to t;
	display the QBC options.

To terminate the conversation:
	change the qbc_litany to the Table of No Conversation.

Section 7 - Straightening out the parser

Before printing a parser error when QBC is active and the parser error is didn't understand that number:
	rq_fixerror.

Quip-Based Conversation IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Version 4 of Quip-Based Conversation by Michael Martin.
