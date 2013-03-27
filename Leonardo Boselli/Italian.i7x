Version 1 of Italian by Leonardo Boselli begins here.

"Parser e messaggi di base tradotti in italiano."

"basato su Version 1 of Italian by Massimo Stella." 

Part 0 - Apostrophes

Include Punctuation Removal by Emily Short.

After reading a command:
	remove apostrophes.

Part 1 - Definitions

Section 1.1 - Library Message values

Library message id is a kind of value.
The library message ids are defined by the table of library messages.

The main object is an object that varies.
The secondary object is an object that varies.
The main room is a room that varies.
The numeric amount is a number that varies.
The library-message-id is a library message id that varies.
The before library messages rule is a rule that varies.
The after library messages rule is a rule that varies.

Tense is a kind of value. The tenses are past tense and present tense.
Grammatical number is a kind of value. The grammatical numbers are singular and plural.
Grammatical person is a kind of value. The grammatical persons are first person, second person and third person.
Gender is a kind of value. The genders are gender masculine, gender feminine and gender neuter.

The library message tense is a tense that varies.
The library message grammatical number is a grammatical number that varies.
The library message person is a grammatical person that varies.
The library message gender is a gender that varies.
Library_message_debug is a thing. Library_message_debug can be on or off.

Section 1.2 - Defaults

The library message tense is present tense.
The library message grammatical number is singular.
The library message person is second person.
The library message gender is gender masculine.
Library_message_debug is off.

Table of custom library messages
Message Id		Message Text
library message id		text

Section 1.3 - Before and After rules

[ called just before and just after a library message is printed ]

The before library messages rule is the empty rule.
The after library messages rule is the empty rule.

This is the empty rule:
	do nothing.

Section 1.4 - Altering messages

When play begins:
	init library messages;
	add the custom library messages.

To add the custom library messages:
 	repeat through the table of custom library messages begin;
		set the message id entry to the message text entry;
	end repeat.

To set (id_ - library message id) to (msg_ - text):
	update the row with id of id_ to msg_.

[ perform a binary search to quickly find the message id (table is guaranteed to be sorted) ]

To update the row with id of (id_ - library message id) to (msg_ - text):
	let n1 be 1;
	let n2 be the number of rows in the table of library messages;
	while n1 <= n2 begin;
		let mid be n1 plus n2;
		change mid to mid divided by 2;
		choose row mid in the table of library messages;
		if the message id entry is id_ begin;
			change the message text entry to msg_;
			change n1 to n2 + 1;	[ to force the loop to stop ]
		end if;
		if the message id entry < id_, change n1 to mid plus 1;
		if the message id entry > id_, change n2 to mid minus 1;
	end while.

libmsg_3ps_changed is a number that varies. libmsg_3ps_changed is 0.

To set the library message third person text to (name_ - text):
	set the library message third person text to name_ / name_ / name_.

To set the library message third person text to (upper_ - text) / (lower_ - text):
	set the library message third person text to upper_ / lower_ / lower_.

To restore the library message third person text:
	set the library message third person text to "Egli" / "egli" / "lui";
	change libmsg_3ps_changed to 0.

To set the library message third person text to (upper_ - text) / (lower_ - text) / (dobj_ - text):
	change libmsg_3ps_changed to 1;
	repeat through the table of 'you' forms begin;
		if Gramm Person entry is third person and
			Gramm Number entry is singular begin;
			if Case entry is upper-case, change Word entry to upper_;
 			otherwise change Word entry to lower_;
		end if;
	end repeat;
	repeat through the table of 'you' dobj forms begin;
		if Gramm Person entry is third person and Gramm Number entry is singular then
			change Word entry to dobj_;
	end repeat.

Part 2 - Messages

Section 2.1 - End of game messages

Table of library messages
Message Id				Message Text
LibMsg <you have died>			" E['] finita. "
LibMsg <you have won>			" Hai vinto! "

Section 2.2 - Descriptions

[ The following rule supercedes LibMsg <player self description> (left in for backwards compatibility, but has no effect) ]

Rule for printing the name of the player:
	say "[yourself]".

Table of library messages (continued)
Message Id				Message Text
LibMsg <player self description>		"[yourself]"
LibMsg <unimportant object>		"Non è importante."

[
   Removed "LibMsg <player description>"
   - use "The description of the player is ..." instead.
]

Section 2.2 - Descriptions b

Rule for printing a number of things (called objects):
	say "[listing group size in italian words] ";
	carry out the printing the plural name activity with objects.

To say genderity:
	if the curr_obj is plural-named then say plural-genderity;
	else say singular-genderity.
To say singular-genderity:
	say "[if the curr_obj is female]a[otherwise]o[end if]".
To say plural-genderity:
	say "[if the curr_obj is female]e[otherwise]i[end if]".

To decide if the (letter - an indexed text) is a vowel:
	if letter is "a" or letter is "e" or letter is "i" or letter is "o" or letter is "u" or
		letter is "A" or letter is "E" or letter is "I" or letter is "O" or letter is "U", decide yes;
	decide no.

To decide which number is the article-kind of (x - a thing):
	let printed-name be the printed name of x;
	let first-letter be the character number 1 in printed-name;
	if first-letter is a vowel, decide on 0;
	if first-letter is "z" or first-letter is "Z", decide on 1;
	if first-letter is "x" or first-letter is "X", decide on 1;
	let second-letter be the character number 2 in printed-name;
	if first-letter is "s" or first-letter is "S":
		if second-letter is a vowel, decide on 2;
		decide on 1;
	if first-letter is "p" or first-letter is "P":
		if second-letter is "s", decide on 1;
	if first-letter is "g" or first-letter is "G":
		if second-letter is "n", decide on 1;
	decide on 2.

To decide which number is the article-kind of (x - a room):
	let printed-name be the printed name of x;
	let first-letter be the character number 1 in printed-name;
	if first-letter is a vowel, decide on 0;
	if first-letter is "z" or first-letter is "Z", decide on 1;
	if first-letter is "x" or first-letter is "X", decide on 1;
	let second-letter be the character number 2 in printed-name;
	if first-letter is "s" or first-letter is "S":
		if second-letter is a vowel, decide on 2;
		decide on 1;
	if first-letter is "p" or first-letter is "P":
		if second-letter is "s", decide on 1;
	if first-letter is "g" or first-letter is "G":
		if second-letter is "n", decide on 1;
	decide on 2.

Italian preposition is a kind of value. The italian prepositions are defined by the Table of Italian Prepositions. 

Table of Italian Prepositions
Name	Text
di-prep	"de"
a-prep	"a"
da-prep	"da"
in-prep	"ne"
su-prep	"su"

To say (prep - an italian preposition) the (object - a thing):
	say "[text of prep]";
	if object is female:
		if object is plural-named:
			 say "lle ";
		otherwise:
			if article-kind of object is 0:
				 say "ll[']";
			otherwise:
				say "lla ";
	otherwise if article-kind of object is 0:
		say "[if object is plural-named]gli [otherwise]ll['][end if]";
	otherwise if article-kind of object is 1:
		say "[if object is plural-named]gli [otherwise]llo [end if]";
	otherwise:
		say "[if object is plural-named]i [otherwise]l [end if]";
	say "[object]".

To say con-prep the (object - a thing):
	say "co";
	if object is female:
		if object is plural-named:
			 say "n le ";
		otherwise:
			if article-kind of object is 0:
				 say "n l[']";
			otherwise:
				say "n la ";
	otherwise if article-kind of object is 0:
		say "[if object is plural-named]gli [otherwise]n l['][end if]";
	otherwise if article-kind of object is 1:
		say "[if object is plural-named]gli [otherwise]n lo [end if]";
	otherwise:
		say "[if object is plural-named]i [otherwise]l [end if]";
	say "[object]".

To say (prep - an italian preposition) the (place - a room):
	say "[text of prep]";
	if place is female:
		if place is plural-named:
			 say "lle ";
		otherwise:
			if article-kind of place is 0:
				 say "ll[']";
			otherwise:
				say "lla ";
	otherwise if article-kind of place is 0:
		say "[if place is plural-named]gli [otherwise]ll['][end if]";
	otherwise if article-kind of place is 1:
		say "[if place is plural-named]gli [otherwise]llo [end if]";
	otherwise:
		say "[if place is plural-named]i [otherwise]l [end if]";
	say "[place]".

To say off|out of (object - a thing):
	if object is a supporter, say "[da-prep the  object]";
	otherwise say "fuori [da-prep the object]".

[The description of the player is "Sei sempre l[genderity] stess[genderity]."]

Section 2.3 - Prompts and Input

Table of library messages (continued)
Message Id				Message Text
LibMsg <empty line>			"Cosa vorresti dire?"
LibMsg <confirm Quit>			"Sei sicuro di voler uscire? (s/n) "
LibMsg <yes or no prompt>		"Per piacere, rispondi 'sì' o 'no'."
LibMsg <restrict answer>			"Per piacere, rispondi con una delle opzioni suggerite."
LibMsg <page prompt>			"[line break][bracket]Premi SPAZIO, per piacere.[close bracket]"
LibMsg <menu prompt>			"[line break]Scrivi un numero da 1 fino a [numeric amount], 0 per ristampare o premi INVIO."
LibMsg <comment recorded>		"[bracket]Commento registrato.[close bracket]"
LibMsg <comment not recorded>		"[bracket]Commento non registrato.[close bracket]"

Section 2.4 - Undo

Table of library messages (continued)
Message Id				Message Text
LibMsg <undo succeeded>		"[bracket]Il turno precedente è stato annullato.[close bracket]"
LibMsg <undo failed>			"Annullamento fallito. [bracket]Non tutti gli interpreti lo supportano.[close bracket]"
LibMsg <undo not provided>		"[bracket]Il tuo interprete non supporta il comando ANNULLA.[close bracket]"
LibMsg <cannot undo nothing>		"[bracket]Non puoi disfare ciò che non è ancora stato fatto.[close bracket]"
LibMsg <cannot undo twice in a row>	"[bracket]Non puoi disfare per due volte consecutive.[close bracket]"
LibMsg <undo forbidden>			"Il comando ANNULLA non è abilitato in questa storia."

Section 2.5 - Oops

Table of library messages (continued)
Message Id				Message Text
LibMsg <oops failed>			"Scusami, non può essere corretto."
LibMsg <oops too many arguments>	"Può correggere solo una singola parola."
LibMsg <oops no arguments>		"Niente da fare, vero?"

Section 2.6 - Again

Table of library messages (continued)
Message Id				Message Text
LibMsg <cannot do again>		"Non si può ripetere."
LibMsg <again usage>			"Per ripetere un comando basta pronunciare ANCORA."

Section 2.7 - Syntax Errors

Table of library messages (continued)
Message Id				Message Text
LibMsg <command not understood>	"Non ho compreso la frase."
LibMsg <command partly understood>	"Ho capito solamente sino a "
LibMsg <command badly ended>		"Non ho compreso la fine del comando."
LibMsg <command incomplete>		"Sembra che tu abbia detto troppo poco!"
LibMsg <command cut short>		"(Poichè è accaduto qualcosa di drammatico, la tua lista di comandi è stata tagliata pesantemente.)"
LibMsg <number not understood>		"Non ho compreso il numero."
LibMsg <cannot begin at comma>		"Non puoi iniziare un comando con una virgola."
LibMsg <extra words before comma>	"Per parlare a qualcuno, prova con [']qualcuno, ciao['] o frasi simili."

Section 2.8 - Illegal Commands

Table of library messages (continued)
Message Id					Message Text
LibMsg <unknown object>			"Non si vede niente del genere."
LibMsg <object not held>				"Non l[genderity] stai portando con te!"
LibMsg <unknown verb>				"Scusami, non riesco a capire cosa intendi."
LibMsg <verb cannot have inanimate object>	"Si possono fare cose del genere solo ad oggetti animati."
LibMsg <noun needed>				"Devi fornire un nome."
LibMsg <noun not needed>			"Puoi evitare di fornire un nome."
LibMsg <object needed>				"Devi specificare un oggetto."
LibMsg <object not needed>			"Puoi evitare di specificare un oggetto."
LibMsg <second object needed>			"Devi specificare un secondo oggetto."
LibMsg <second object not needed>		"Puoi evitare di specificare un secondo oggetto."
LibMsg <second noun needed>			"Devi fornire un secondo nome."
LibMsg <second noun not needed>			"Puoi evitare di fornire un secondo nome."
LibMsg <something more substantial needed>	"Devi nominare qualcosa di più specifico."

Section 2.9 - Multiple Objects

Table of library messages (continued)
Message Id					Message Text
LibMsg <verb cannot have multiple objects>		"Non puoi usare oggetti multipli con questo verbo."
LibMsg <too many multiple objects>		"Puoi usare oggetti multipli una sola volta per riga."
LibMsg <not that many available>			"[if the numeric amount is 0]Nessun[singular-genderity] di quest[plural-genderity][otherwise]Solo [numeric amount in words] di quest[genderity] [is|are for numeric amount][end if] disponibil[if the numeric amount is 0]e[otherwise]i[end if]."
LibMsg <no objects available>			"Di disponibili non ce ne sono!"
LibMsg <zero multiple objects>			"Niente da fare!"
LibMsg <first N objects>				"(considerando solamente i primi sedici oggetti)"
LibMsg <excepted object not included anyway>	"Ti aspettavi una cosa che comunque non era scontata!"

Section 2.10 - Implicit Actions

To say entering|getting onto-into:
	if main object is not a supporter and main object is not a container,
		say "entri";
	otherwise say "[if main object is supporter]sali[otherwise]entri[end if] [onto|into]".

To say getting off-out of (x - a thing):
	if main object is not a supporter and main object is not a container,
		say "esci";
	otherwise say "[if main object is supporter]scendi[otherwise]esci[end if] [off|out of x]".

Table of library messages (continued)
Message Id						Message Text
LibMsg <report implicit take>				"(prima prendi [the % dobj])"
LibMsg <report npc implicit take>				"([the actor] prima prende [the % dobj])"
LibMsg <implicitly pass outwards through other barriers>	"([getting off-out of main object])"
LibMsg <implicitly pass inwards through other barriers>	"([entering|getting onto-into] [the % dobj])"
LibMsg <cannot drop clothes being worn>			"(prima togli [the % dobj])"
LibMsg <cannot insert clothes being worn>			"(prima togli [the % dobj])"
LibMsg <cannot put clothes being worn>			"(prima togli [the % dobj])"

Section 2.11 - Carrying Capacity

Table of library messages (continued)
Message Id						Message Text
LibMsg <cannot exceed carrying capacity>			"Stai portando già troppe cose."
LibMsg <use holdall to avoid exceeding carrying capacity>	"(metti [the % dobj] in [the player's holdall] per fare posto)"
LibMsg <cannot insert if this exceeds carrying capacity>	"Non c[']è più spazio dentro [the % dobj]."
LibMsg <cannot put if this exceeds carrying capacity>		"Non c[']è più spazio sopra [the % dobj]."

Section 2.12 - Disambiguation

Table of library messages (continued)
Message Id				Message Text
LibMsg <who disambiguation>		"Chi intendi, "
LibMsg <which disambiguation>		"Quale intendi, "
LibMsg <whom disambiguation>		"A chi vorresti fare tutto questo?"
LibMsg <what disambiguation>		"Cosa vuoi fare precisamente?"
LibMsg <single object disambiguation>	"Scusami, ne puoi avere solo un[genderity] qui. Esattamente quale?"

Section 2.13 - Pronouns

To say <space> at the moment:
   if lm_present, say " al momento"

Table of library messages (continued)
Message Id				Message Text
LibMsg <pronoun not set>			"Non so a cosa ['][pronoun word]['] si riferisca."
LibMsg <pronoun absent>			"[Can't] vedere ['][pronoun word]['] ([the %])[<space> at the moment]."
LibMsg <Pronouns initial text>		"Attualmente, "
LibMsg <Pronouns -means- text>		"significa"
LibMsg <Pronouns -unset- text>		"non è predisposto"
LibMsg <no pronouns known>		"nessun pronome verrà riconosciuto nel corso del gioco."

Section 2.14 - Commanding People

Table of library messages (continued)
Message Id				Message Text
LibMsg <person ignores command>	"[The %] [has|have] cose migliori da fare."
LibMsg <cannot talk to absent person>	"Sembra che tu voglia parlare con qualcuno, ma non capisco con chi."
LibMsg <cannot talk to inanimate object>	"Non puoi parlare ad un oggetto inanimato."
LibMsg <npc unable to do that>		"[The actor] non può farlo."

Section 2.15 - File Operations

Table of library messages (continued)
Message Id				Message Text
LibMsg <confirm Restart>			"Sei sicuro di voler ricominciare? (s/n) "
LibMsg <Restart failed>			"Fallito."
LibMsg <Restore failed>			"Caricamento Fallito."
LibMsg <Restore succeeded>		"Ok."
LibMsg <Save failed>			"Salvataggio Fallito."
LibMsg <Save succeeded>			"Ok."
LibMsg <Verify succeeded>		"Il file di gioco è risultato intatto."
LibMsg <Verify failed>			"Il file di gioco potrebbe essere corrotto."

Section 2.16 - Transcripts

Table of library messages (continued)
Message Id				Message Text
LibMsg <transcript already on>		"La riscrittura è già attivata."
LibMsg <transcript already off>		"La riscrittura è già disattivata."
LibMsg <start of transcript>		"Inizia la riscrittura di"
LibMsg <end of transcript>		"[/n]Fine della riscrittura."
LibMsg <transcript failed>			"Fallito il tentativo di iniziare la riscrittura."
LibMsg <end transcript failed>		"Fallito il tentativo di terminare la riscrittura."

Section 2.17 - Scoring

Table of library messages (continued)
Message Id				Message Text
LibMsg <Score command>		"[if game over]Nel gioco[otherwise]Sinora[end if] hai totalizzato [the score] su [maximum score], in [turn count] mosse"
LibMsg <score changed>			"Il tuo punteggio è [if the numeric amount is positive]aumentato di [the numeric amount in italian words][otherwise]diminuito di [0 minus the numeric amount in italian words][end if] [if the numeric amount is 1]punto[otherwise]punti[end if]"
LibMsg <score notification turned on>	"Notifica del punteggio attivata."
LibMsg <score notification turned off>	"Notifica del punteggio disattivata."
LibMsg <no scoring>			"Non vi è alcun punteggio in questa storia."
LibMsg <score rank>			", conquistandoti il titolo di "

Section 2.18 - Inventory

Table of library messages (continued)
Message Id				Message Text
LibMsg <report npc taking inventory>	"[The actor] guarda tra le sue cose."
LibMsg <Inventory initial text>		"Stai portando"
LibMsg <Inventory no possessions>		"Non stai portando nulla."

Section 2.19 - Darkness

Table of library messages (continued)
Message Id				Message Text
LibMsg <entering darkness>		"[if lm_past]Improvvisamente si è fatto buio.[otherwise]Adesso è tutto avvolto dall[']oscurità![end if]"
LibMsg <dark description>			"C[']è un buio pesto e non riesci a vedere nulla."
LibMsg <examine while dark>		"Oscurità. L[']assenza di luce impedisce ogni osservazione."
LibMsg <search while dark>		"Ma è buio!"
LibMsg <look under while dark>		"Ma è tutto buio!"
LibMsg <dark room name>		"Buio"

Section 2.20 - Take

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player taking>			"Hai preso [the % dobj]."
LibMsg <report npc taking>			"[The actor] prende [the % dobj]."
LibMsg <cannot take yourself>			"Non puoi prenderti."
LibMsg <cannot take other people>			"Non si può prendere."
LibMsg <cannot take something you are within>	"Non puoi farlo finchè ci sei."
LibMsg <cannot take something already taken>	"[The noun] [is|are] già in tuo possesso."
LibMsg <cannot take possessions of others>		"[=> noun]Non puoi perché appart[if the noun is plural-named]engono[otherwise]iene[end if] [=> %][a-prep the main object]."
LibMsg <cannot take component parts>		"[=> noun]Non puoi perché [is|are] parte [di-prep the main object]."
LibMsg <cannot take hidden parts>			"[The %] [isn't|aren't] a disposizione."
LibMsg <cannot reach within closed containers>	"[The %] [isn't|aren't] apert[genderity]."
LibMsg <cannot take scenery>			"Non è possibile."
LibMsg <cannot take something fixed>		"Niente da fare, non si muov[if the curr_obj is plural-named]ono[otherwise]e[end if]."
LibMsg <cannot reach within other places>		"Non puoi arrivarci."

[ See also:
  	LibMsg <cannot exceed carrying capacity>
	LibMsg <use holdall to avoid exceeding carrying capacity> ]

Section 2.21 - Remove

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player removing>			"Rimozione completata."
LibMsg <report npc removing>			"[The actor] rimuove [the % dobj] [da-prep the second noun]."
LibMsg <cannot remove from closed containers>	"[Is|Are] chius[genderity]."
LibMsg <cannot remove something not within>	"Ma non ce ne sono più, ora."

Section 2.22 - Drop

Table of library messages (continued)
Message Id						Message Text
LibMsg <report player dropping>				"Lasci [the % dobj] per terra."
LibMsg <report npc dropping>				"[The actor] lascia [the % dobj] per terra."
LibMsg <cannot drop something already dropped>		"Non hai [the %]."
LibMsg <cannot drop not holding>				"Non hai [the %] in mano."
LibMsg <cannot drop if this exceeds carrying capacity>	"Non c[']è lo spazio necessario!"

[ See also:
  	LibMsg <cannot drop clothes being worn> ]

Section 2.23 - Insert

Table of library messages (continued)
Message Id						Message Text
LibMsg <report player inserting>				"Hai messo [the % dobj] dentro [the second noun]."
LibMsg <report npc inserting>				"[The actor] mette [the % dobj] dentro [the second noun]."
LibMsg <cannot insert something not held>			"Non puoi perché non ce l[']hai in mano."
LibMsg <cannot insert into something not a container>	"[The % dobj] non può contenere oggetti."
LibMsg <cannot insert into closed containers>		"Non puoi mettere [the noun] dentro [the second noun] perché [is|are] chius[genderity]."
LibMsg <need to take off before inserting>			"Devi toglierti di dosso [the % dobj], prima di inserirl[genderity]."
LibMsg <cannot insert something into itself>			"Non puoi mettere nulla dentro se stesso."

[ See also:
  	LibMsg <cannot insert if this exceeds carrying capacity>
	LibMsg <cannot insert clothes being worn> ]

Section 2.24 - Put On

Table of library messages (continued)
Message Id						Message Text
LibMsg <report player putting on>				"Hai messo [the % dobj] sopra [the second noun]."
LibMsg <report npc putting on>				"[The actor] mette [the % dobj] sopra [the second noun]."
LibMsg <cannot put something not held>			"Non puoi posizionare ciò che non possiedi[<space> at the moment]."
LibMsg <cannot put something on it-self>			"Non puoi posizionare nulla su se stesso."
LibMsg <cannot put onto something not a supporter>	"Non è possibile posizionare oggetti sopra [the second noun]."
LibMsg <cannot put onto something being carried>		"Ci vuole troppa destrezza: non puoi riuscirci."

[ See also:
  	LibMsg <cannot put if this exceeds carrying capacity>
	LibMsg <cannot put clothes being worn> ]

Section 2.25 - Give

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player giving>			"Consegni [the % dobj] [a-prep the second noun]."
LibMsg <report npc giving to player>		"[The actor] ti consegna [the % dobj]."
LibMsg <report npc giving to npc>			"[The actor] consegna [the % dobj] [a-prep the second noun]."
LibMsg <cannot give what you have not got>	"Non puoi cedere ciò che non possiedi[<space> at the moment]."
LibMsg <cannot give to yourself>			"E['] un[']azione inutile."
LibMsg <block giving>				"La tua offerta non suscita alcun interesse."
LibMsg <unable to receive things>			"[The %] [can't] ricevere oggetti."

Section 2.26 - Show

Table of library messages (continued)
Message Id					Message Text
LibMsg <cannot show what you have not got>	"Non puoi mostrare ciò che non possiedi[<space> at the moment]."
LibMsg <block showing>				"Le tue azioni non suscitano alcun interesse."

Section 2.27 - Enter

To say appropriate action for Enter verb:
   (-
       if (verb_word == 'sali') print "Sali";
       else if (verb_word == 'siedi') print "Siedi";
       else if (verb_word == 'giaci' or 'sdraiati') print "Ti sdrai";
       else print "Entri";
   -).

To say appropriate action for enter verb:
   (-
       if (verb_word == 'sali') print "sali";
       else if (verb_word == 'siedi') print "siedi";
       else if (verb_word == 'giaci' or 'sdraiati') print "ti sdrai";
       else print "entri";
   -).

To say appropriate action for enters verb:
   (-
       if (verb_word == 'sali') print "sale";
       else if (verb_word == 'siedi') print "si siede";
       else if (verb_word == 'sdraiati') print "si sdraia";
       else print "entra";
   -).

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player entering>			"[=> %][appropriate action for enter verb] [onto|into] [the % dobj]."
LibMsg <report npc entering container>		"[The actor] [appropriate action for enters verb] dentro [the % dobj]."
LibMsg <report npc entering supporter>		"[The actor] [appropriate action for enters verb] sopra [the % dobj]."
LibMsg <cannot enter something already entered>	"Sei già al suo interno!"
LibMsg <cannot enter something not enterable>	"Non permette di entrare al suo interno."
LibMsg <cannot enter closed containers>		"Devi aprire ciò che è chiuso prima di potervi entrare."
LibMsg <cannot enter something carried>		"Non puoi entrare in ciò che è trasportato."

[ See also:
	LibMsg <implicitly pass outwards through other barriers>
	LibMsg <implicitly pass inwards through other barriers> ]

Section 2.28 - Exit, Get Off

To say Appropriate action for exit verb:
   (-
       if (verb_word == 'scendi') print "Scendi";
       else if (verb_word == 'alzati') print "Ti alzi";
       else print "Esci";
   -).

To say appropriate action for exits verb:
   (-
       if (verb_word == 'scendi') print "scende";
       else if (verb_word == 'alzati') print "si alza";
       else print "esce";
   -).

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player exiting>			"[=> %][Appropriate action for exit verb] [da-prep the main object]."
LibMsg <report npc exiting container>		"[The actor] [appropriate action for exits verb] [=> %][da-prep the main object]."
LibMsg <report npc exiting supporter>		"[The actor] [appropriate action for exits verb] [=> %][da-prep the main object]."
LibMsg <cannot exit when not within anything>	"Non puoi uscire da qualcosa in cui non ti trovi."
LibMsg <cannot exit closed containers>		"L[']uscita è chiusa [<space> at the moment]."
LibMsg <cannot get off things>			"Non puoi scendere [=> %][off|out of main object][<space> at the moment]."
LibMsg <cannot exit thing not within>		"Non puoi far uscire [=> %][off|out of main object] [the % dobj]."

Section 2.29 - Go

To say direction (dir - a direction):
	if dir is west, say "ovest";
	if dir is south, say "sud";
	if dir is east, say "est";
	if dir is north, say "nord";
	if dir is northwest, say "nordovest";
	if dir is southwest, say "sudovest";
	if dir is southeast, say "sudest";
	if dir is northeast, say "nordest";
	if dir is up, say "sopra";
	if dir is down, say "sotto";
	if dir is inside, say "dentro";
	if dir is outside, say "fuori".

To say opposite direction (dir - a direction):
	if dir is west, say "est";
	if dir is south, say "nord";
	if dir is east, say "ovest";
	if dir is north, say "sud";
	if dir is northwest, say "sudest";
	if dir is southwest, say "nordest";
	if dir is southeast, say "nordovest";
	if dir is northeast, say "sudovest";
	if dir is up, say "sotto";
	if dir is down, say "sopra";
	if dir is inside, say "fuori";
	if dir is outside, say "dentro".

Table of library messages (continued)
Message Id					Message Text
LibMsg <cannot go that way>			"Non puoi andare da quella parte."
LibMsg <cannot travel in something not a vehicle>	"Dovresti prima uscire [=> %][off|out of] [the % dobj]."
LibMsg <cannot go through concealed doors>	"Il passaggio è sbarrato."
LibMsg <cannot go up through closed doors>	"Non puoi scalare un passaggio chiuso."
LibMsg <cannot go down through closed doors>	"Non puoi strisciare sotto un passaggio chiuso."
LibMsg <cannot go through closed doors>		"Il passaggio è chiuso."
LibMsg <nothing through door>			"[The %] non porta da nessuna parte."
LibMsg <block vaguely going>			"Devi seguire alcune direzioni precise.[/r]"
LibMsg <say npc goes>				"[The actor] va a [direction noun]"
LibMsg <say npc arrives>				"[The actor] arriva da [opposite direction noun]"
LibMsg <say npc arrives from unknown direction>	"[The actor] arriva."
LibMsg <say npc arrives at>			"[The actor] arriva a [the %] [from the secondary object]"
LibMsg <say npc goes through>			"[The actor] va attraverso [the %]"
LibMsg <say npc arrives from>			"[The actor] arriva da [direction noun]"
LibMsg <say npc vehicle>				"[on|in] [the %]"
LibMsg <say npc pushing in front with player>	", spingendo [the %] in avanti, e anche te"
LibMsg <say npc pushing in front>			", spingendo [the %] in avanti"
LibMsg <say npc pushing away>			", spingendo [the %] via"
LibMsg <say npc pushing in>			", spingendo [the %] dentro"
LibMsg <say npc taking player along>		", portandoti appresso"

To say from (dir - a direction):
    say "da ";
    if dir is down, say "sotto";
    if dir is up, say "sopra";
    if dir is not down and dir is not up, say "[dir]".

Section 2.30 - Brief, Super Brief, Verbose

Table of library messages (continued)
Message Id				Message Text
LibMsg <brief look mode>			"[<space> at the moment] è nella modalità 'brief' di stampa, che fornisce lunghe descrizioni dei luoghi mai visitati e altre più sintetiche negli altri casi."
LibMsg <superbrief look mode>		" è[<space> at the moment] nella modalità 'superbrief', che fornisce sempre descrizioni brevi dei luoghi (anche di quelli mai visitati)."
LibMsg <verbose look mode>		" è[<space> at the moment] nella modalità 'verbose', che fornisce sempre descrizioni lunghe dei luoghi (anche di quelli già visitati)."

Section 2.31 - Look

Table of library messages (continued)
Message Id				Message Text
LibMsg <report npc looking>		"[The actor] si guarda intorno."
LibMsg <top line what on>		" ([on|in] [the % dobj])"
LibMsg <top line what in>			" ([on|in] [the % dobj])"
LibMsg <top line what as>			" (come [inform 6 short name of %])"
LibMsg <say things within>		"[On|In] [the main object] puoi vedere [what's inside %]."
LibMsg <say things also within>		"[On|In] [the main object] puoi vedere anche [what's inside %]."
LibMsg <say things on>			"Sopra [the main object] [what's on %]."

To say what's on %:
	list the contents of the main object, prefacing with is/are, as a sentence, including contents, giving brief inventory information, tersely, not listing concealed items.

To say what's inside %:
	list the contents of the main object, as a sentence, including contents, giving brief inventory information, tersely, not listing concealed items.

Section 2.32 - Examine

Table of library messages (continued)
Message Id				Message Text
LibMsg <report npc examining>		"[The actor] osserva attentamente [the % dobj]."
LibMsg <examine undescribed things>	"Non ci trovi niente di particolare."
LibMsg <examine direction>		"Non osservi nulla di interessante in quella direzione."
LibMsg <examine devices>		"[The %] [if the curr_obj is switched off]non[end if] [is|are] acces[genderity]."

[ See also:
	LibMsg <examine in darkness> ]

Section 2.33 - Search

Table of library messages (continued)
Message Id						Message Text
LibMsg <report npc searching>				"[The actor] esamina [the % dobj]."
LibMsg <cannot search unless container or supporter>	"Non ci trovi nulla di interessante."
LibMsg <cannot search closed opaque containers>		"Non puoi vedere all[']interno dei contenitori chiusi."
LibMsg <nothing found within container>			"Non trovi nulla dentro [the % dobj]."
LibMsg <nothing found on top of>				"Non trovi niente sopra [the % dobj]."

[ See also:
	LibMsg <search in darkness> ]

Section 2.34 - Look Under

Table of library messages (continued)
Message Id				Message Text
LibMsg <report npc looking under>		"[The actor] guarda sotto [the % dobj]."
LibMsg <look under>			"Non trovi nulla di interessante."

[ See also:
	LibMsg <look under in darkness> ]

Section 2.35 - Open

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player opening>			"Apri [the % dobj]."
LibMsg <report npc opening>			"[The actor] apre [the % dobj]."
LibMsg <report unseen npc opening>		"[The %] si apre."
LibMsg <cannot open unless openable>		"Non si può aprire."
LibMsg <cannot open something locked>		"Devi prima trovare una chiave per sbloccare [the % dobj]."
LibMsg <cannot open something already open>	"[Is|Are] già apert[genderity]."
LibMsg <reveal any newly visible exterior initial text>	"Apri [the % dobj], scoprendo "
LibMsg <no newly visible exterior>			"il nulla."

Section 2.36 - Close

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player closing>			"Chiudi [the % dobj]."
LibMsg <report npc closing>			"[The actor] chiude [the % dobj]."
LibMsg <report unseen npc closing>		"[The %] si chiude."
LibMsg <cannot close unless openable>		"Non si può chiudere."
LibMsg <cannot close something already closed>	"[Is|Are] già chius[genderity]."

Section 2.37 - Lock

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player locking>			"Blocchi [the % dobj]."
LibMsg <report npc locking>			"[The actor] blocca [the % dobj]."
LibMsg <cannot lock without a lock>		"Non si può bloccare."
LibMsg <cannot lock something already locked>	"[Is|Are] già bloccat[genderity]."
LibMsg <cannot lock something open>		"Non si può bloccare, perché è ancora apert[genderity]."
LibMsg <cannot lock without the correct key>	"Non è la chiave giusta per la serratura."

Section 2.38 - Unlock

Table of library messages (continued)
Message Id						Message Text
LibMsg <report player unlocking>				"La serratura si apre con un piccolo scatto. Riesci a sbloccare [the % dobj]."
LibMsg <report npc unlocking>				"[The actor] sblocca [the % dobj]."
LibMsg <cannot unlock without a lock>			"Non si può bloccare."
LibMsg <cannot unlock something already unlocked>		"[Is|Are] già sbloccat[genderity]."
LibMsg <cannot unlock without the correct key>		"Non è la chiave giusta per la serratura."

Section 2.39 - Switch On

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player switching on>		"Accendi [the % dobj]."
LibMsg <report npc switching on>			"[The actor] accende [the % dobj]."
LibMsg <cannot switch on unless switchable>	"Non si può accendere."
LibMsg <cannot switch on something already on>	"[Is|Are] già acces[genderity]."

Section 2.40 - Switch Off

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player switching off>		"Spegni [the % dobj]."
LibMsg <report npc switching off>			"[The actor] spegne [the % dobj]."
LibMsg <cannot switch off unless switchable>	"Non si può spegnere."
LibMsg <cannot switch off something already off>	"[Is|Are]  già spent[genderity]."

Section 2.41 - Wear

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player wearing>			"Indossi [the % dobj]."
LibMsg <report npc wearing>			"[The actor] indossa [the % dobj]."
LibMsg <cannot wear something not clothing>	"Non si può indossare."
LibMsg <cannot wear not holding>			"Non puoi indossare ciò che non è in tuo possesso."
LibMsg <cannot wear something already worn>	"[Is|Are] già indossat[genderity]."

Section 2.42 - Take Off

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player taking off>			"Ti togli [the % dobj]."
LibMsg <report npc taking off>			"[The actor] si toglie [the % dobj]."
LibMsg <cannot take off something not worn>	"Non [is|are] indossat[genderity]."

Section 2.43 - Eating And Drinking, Senses

Table of library messages (continued)
Message Id				Message Text
LibMsg <report player eating>		"Hai mangiato [the % dobj]."
LibMsg <report npc eating>		"[The actor] mangia [the % dobj]."
LibMsg <cannot eat unless edible>		"Non è commestibile."
LibMsg <block drinking>			"Non si può bere."
LibMsg <block tasting>			"Non si può assaggiare."
LibMsg <block smelling>			"Non senti alcun odore particolare."
LibMsg <block listening>			"Non senti nulla di particolare."

Section 2.44 - Touching

To say keep your hands to yourself:
	say "Tieni le mani a posto. Non è il momento di andare a toccare di qua e di là![run paragraph on]"

To say Keep:
 	say "[=> player]";
	if lm_p2 and lm_sing, say "Tieni";
	otherwise say "Dovresti tenere a posto"

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player touching things>		"Al tatto non senti nulla di particolare."
LibMsg <report npc touching things>		"[The actor] tocca [the % dobj]."
LibMsg <report player touching self>		"E adesso?"
LibMsg <report npc touching self>			"[The actor] si tocca."
LibMsg <report player touching other people>	"[Keep your hands to yourself]"
LibMsg <report npc touching other people>		"[The actor] tocca [the % dobj]."

Section 2.45 - Rhetorical Commands

Table of library messages (continued)
Message Id				Message Text
LibMsg <block saying yes>		"Era una domanda retorica."
LibMsg <block saying no>			"Era una domanda retorica."
LibMsg <block saying sorry>		"Oh, non ti scusare."
LibMsg <block swearing obscenely>	"Non utilizzare questo linguaggio osceno."
LibMsg <block swearing mildly>		"Non utilizzare questo linguaggio."

Section 2.46 - Body Movement

Table of library messages (continued)
Message Id				Message Text
LibMsg <block climbing>			"Non puoi scalare."
LibMsg <block jumping>			"Hai fatto un salto."
LibMsg <block swinging>			"Ti arrabbi, ma senza effetto"
LibMsg <block waving hands>		"Agiti le mani in aria senza effetto"

Section 2.47 - Physical Interaction

Table of library messages (continued)
Message Id				Message Text
LibMsg <block attacking>			"La violenza non è la risposta giusta."
LibMsg <block burning>			"Non si dovrebbe scherzare con il fuoco."
LibMsg <block cutting>			"Un taglio non risolve nulla"
LibMsg <block rubbing>			"Si tratta di uno sforzo inutile."
LibMsg <block setting to>			"Niente da fare purtroppo."
LibMsg <block tying>			"Quante energie sprecate."
LibMsg <report player waving things>	"Hai agitato [the % dobj] senza effetto."
LibMsg <report npc waving things>		"[The actor] agita [the % dobj]."
LibMsg <cannot wave something not held>	"Non puoi agitare per aria ciò che non possiedi."
LibMsg <squeezing people>		"[Keep your hands to yourself]."
LibMsg <report player squeezing>		"Un gesto inutile."
LibMsg <report npc squeezing>		"[The actor] spreme [the % dobj]."
LibMsg <block throwing at>		"Non serve lanciare [the % dobj]."
LibMsg <throw at inanimate object>	"Inutile."

Section 2.48 - Push, Pull, Turn

Table of library messages (continued)
Message Id					Message Text
LibMsg <report player pushing>			"Non avviene nulla di utile."
LibMsg <report npc pushing>			"[The actor] spinge [the % dobj]."
LibMsg <report player pulling>			"Non avviene nulla di utile."
LibMsg <report npc pulling>			"[The actor] tira [the % dobj]."
LibMsg <report player turning>			"Non avviene nulla di utile."
LibMsg <report npc turning>			"[The actor] gira [the % dobj]."
LibMsg <block pushing in directions>		"Non si tratta di qualcosa che si possa spingere di qua e di là."
LibMsg <not pushed in a direction>			"Quella non è una direzione."
LibMsg <pushed in illegal direction>		"Quella direzione sarebbe un vicolo cieco."
LibMsg <cannot push something fixed in place>	"Non si muove."
LibMsg <cannot pull something fixed in place>	"Non si muove."
LibMsg <cannot turn something fixed in place>	"Non si muove."
LibMsg <cannot push scenery>			"Non sei in grado."
LibMsg <cannot pull scenery>			"Non sei in grado."
LibMsg <cannot turn scenery>			"Non sei in grado."
LibMsg <cannot push people>			"Non sarebbe un gesto cortese."
LibMsg <cannot pull people>			"Non sarebbe un gesto cortese."
LibMsg <cannot turn people>			"Non sarebbe un gesto cortese."

Section 2.49 - Speech / Interpersonal Actions

Table of library messages (continued)
Message Id				Message Text
LibMsg <block answering>		"Niente. Nessuna risposta."
LibMsg <block asking>			"Silenzio. Nessuna risposta."
LibMsg <block buying>			"Non puoi comprare."
LibMsg <block kissing>			"Non puoi baciare."
LibMsg <block singing>			"Non puoi cantare."
LibMsg <block telling>			"Nulla. Nessuna risposta."
LibMsg <telling yourself>			"Parli tra te e te, ma senza concludere nulla."

Section 2.50 - Mental Actions

Table of library messages (continued)
Message Id				Message Text
LibMsg <block thinking>			"Che fantastica idea..."
LibMsg <block player consulting>		"Non trovi nulla di interessante nel [the % dobj]."
LibMsg <block npc consulting>		"[The actor] guarda verso il [the % dobj]."

Section 2.51 - Sleep And Waiting

Table of library messages (continued)
Message Id				Message Text
LibMsg <block sleeping>			"Non hai sonno."
LibMsg <block waking up>		"Non stai dormendo."
LibMsg <block waking other>		"Potrebbe essere inutile."
LibMsg <report player waiting>		"Il tempo passa."
LibMsg <report npc waiting>		"[The actor] aspetta pazientemente."

Section 2.52 - List Miscellany

Table of library messages (continued)
Message Id						Message Text
LibMsg <misc brackets providing light>			" (che illumina)"
LibMsg <misc brackets closed>				" (chius[genderity])"
LibMsg <misc brackets empty>				" (vuot[genderity])"
LibMsg <misc brackets closed and empty>			" (chius[genderity] e vuot[genderity])"
LibMsg <misc brackets closed and providing light>		" (chius[genderity] e che illumina)"
LibMsg <misc brackets empty and providing light>		" (vuot[genderity] e che illumina)"
LibMsg <misc brackets closed empty and providing light>	" (chius[genderity], vuot[genderity] e che illumina)"
LibMsg <misc brackets providing light and being worn>	" (che illumina e indossat[genderity]"
LibMsg <misc bracket providing light>			" (che illumina"
LibMsg <misc bracket being worn>				" (indossat[genderity]"
LibMsg <misc bracket>					" ("
LibMsg <misc open>					"apert[genderity]"
LibMsg <misc open but empty>				"apert[genderity] ma vuot[genderity]"
LibMsg <misc closed>					"chius[genderity]"
LibMsg <misc closed and locked>				"chius[genderity] e bloccat[genderity]"
LibMsg <misc and empty>					" e vuot[genderity]"
LibMsg <misc containing>					" contenente "
LibMsg <misc bracket on>					" (su "
LibMsg <misc comma on top of>				", sopra "
LibMsg <misc bracket in>					" (in "
LibMsg <misc comma inside>				", dentro "

Part 2.53b - Accessi Diretti a Inform 6

Include (-
[ LanguageTimeOfDay hours mins i;
    i = hours%24;
    if (i == 0) i = 24;
    if (i < 10) print " ";
    print i, ":", mins/10, mins%10;
];
-) instead of "Time" in "Language.i6t".

Include (-
[ LanguageVerb i;
    switch (i) {
      'i//','inv','inventory':
               print "take inventory";
      'g//':   print "look";
      'x//':   print "examine";
      'z//':   print "wait";
      default: rfalse;
    }
    rtrue;
];

[ LanguageVerbLikesAdverb w;
    if (w == 'look' or 'go' or 'push' or 'walk')
        rtrue;
    rfalse;
];

[ LanguageVerbMayBeName w;
    if (w == 'long' or 'short' or 'normal'
                    or 'brief' or 'full' or 'verbose')
        rtrue;
    rfalse;
];
-) instead of "Commands" in "Language.i6t".


Part 2.53b - Numeri

To say (count - a number) in italian words:
	if count >= 1000 and count <= 10000:
		let n be count / 1000;
		repeat through the Table of Numeri:
			if n is the threshold entry:
				say "[if n > 1][italian entry]mila[otherwise if n is 1]mille[otherwise][end if]";
		let m be the remainder after dividing count by 1000;
		change count to m;
	if count >= 100 and count <= 999:
		let n be count / 100;
		repeat through the Table of Numeri:
			if n is the threshold entry:
				say "[if n > 1][italian entry]cento[otherwise if n is 1]cento[otherwise][end if]";
		let m be the remainder after dividing count by 100;
		change count to m;
	if count >= 0 and count <= 21:
		repeat through the Table of Numeri:
			if count is the threshold entry:
				say "[italian entry]";
				rule succeeds;	
	otherwise if count > 21 and count <= 29:
		decrease count by 20;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count  is 8]vent[italian entry][otherwise]venti[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 30 and count < 40:
		decrease count by 30;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]trenta[otherwise if count is 1 or count is 8]trent[italian entry][otherwise]trenta[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 40 and count < 50:
		decrease count by 40;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]quaranta[otherwise if count is 1 or count is 8]quarant[italian entry][otherwise]quaranta[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 50 and count < 60:
		decrease count by 50;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]cinquanta[otherwise if count is 1 or count is 8]cinquant[italian entry][otherwise]cinquanta[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 60 and count < 70:
		decrease count by 60;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]sessanta[otherwise if count is 1 or count is 8]sessant[italian entry][otherwise]sessanta[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 70 and count < 80:
		decrease count by 70;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]settanta[otherwise if count is 1 or count is 8]settant[italian entry][otherwise]settanta[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 80 and count < 90:
		decrease count by 80;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]ottanta[otherwise if count is 1 or count is 8]ottant[italian entry][otherwise]ottanta[italian entry][end if]";
				rule succeeds;
	otherwise if count >= 90 and count < 100:
		decrease count by 90;
		repeat through the Table of Numeri:
	 		if count is the threshold entry:
				say "[if count is 0]novanta[otherwise if count is 1 or count is 8]novant[italian entry][otherwise]novanta[italian entry][end if]";
				rule succeeds.
	
Table of Numeri
threshold	italian
0		"zero"
1		"uno"
2		"due"
3		"tre"
4		"quattro"
5		"cinque"
6		"sei"
7		"sette"
8		"otto"
9		"nove"
10		"dieci"
11		"undici"
12		"dodici"
13		"tredici"
14		"quattordici"
15		"quindici"
16		"sedici"
17		"diciassette"
18		"diciotto"
19		"diciannove"
20		"venti"
21		"ventuno"

Part 2.53b - Data

To say (orario - a time) in italian words:
	let h be the hours part of orario;
	let m be the minutes part of orario;
	say "[h in italian words][if m is 0] in punto[otherwise] e [m in italian words][end if]".

To say (orario - a time) in italian complete words:
	let h be the hours part of orario;
	let m be the minutes part of orario;
	if m is 0, say "[h in italian words] in punto";
	if m > 0 and m <= 30, say "[h in italian words] e [if m is 15]un quarto[otherwise if m is 30]e mezzo[otherwise][m in italian words][end if]";
	if m > 30 and m < 60 , say "[h in italian words] meno [if m is 45]un quarto[otherwise][60 - m in italian words][end if]".

Part 3 - Implementation

Section 3.1 - Kinds - unindexed

[ upper and lower case ]

Letter case is a kind of value.
The letter cases are lower-case and upper-case.

Section 3.2 - The current object - unindexed

curr_obj is an object that varies.
curr_obj_inform6_value is an object that varies.

[ The current tense, number, person and gender for curr_obj;
  if curr_obj == the player, these are equal to the library message values,
  otherwise curr_obj_number is third person and the number and gender are
  determined by the object. ]

temporary_tense is a tense that varies.
use_temporary_tense is a truth state that varies.
use_temporary_tense is false.
curr_obj_number is a grammatical number that varies.
curr_obj_person is a grammatical person that varies.
curr_obj_gender is a gender that varies.

[ the subject of the sentence, initially assumed to be the actor ]

curr_subject is an object that varies.

[ change the current object ]

To set the current object to (x_ - an object) / (dbg_msg - text):
   if the main object is nothing, change the main object to the noun;
   if x_ is_nothing, change curr_obj to main object;	[ make sure it is always valid ]
   otherwise change curr_obj to x_;
   if curr_obj is_nothing, change curr_obj to the player; [last resort]
   if library_message_debug is on begin;
      say "{[dbg_msg]:obj=";
      if curr_obj is the player, say "player"; [infinite recursion if prints player!]
      otherwise say "[curr_obj]";
      say "}";
   end if;
   if curr_obj is the player or curr_obj is_nothing, use the player's GNP;
   otherwise use the object's GNP.

To use the player's GNP:
   change curr_obj_person to the library message person;
   change curr_obj_number to the library message grammatical number;
   change curr_obj_gender to the library message gender.

To use the object's GNP:
   change curr_obj_person to third person;
   if curr_obj acts plural, change curr_obj_number to plural;
   otherwise change curr_obj_number to singular;
   change curr_obj_gender to the gender of curr_obj.

To decide which gender is the gender of (x_ - an object):
   if x_ acts feminine, decide on gender feminine;
   if x_ acts neuter, decide on gender neuter;
   decide on gender masculine.

To decide whether (x_ - an object) is_nothing:
   (- {x_} == nothing -).

This is the get the curr_obj from Inform 6 rule:
   set the current object to curr_obj_inform6_value / "I6".

To say current object is (x_ - an object):
   set the current object to x_ / "say curr obj".

To make sure main object is set / (dbg_msg - text):
   if main object is nothing, change main object to the noun;
   set the current object to the main object / dbg_msg.

[ called from Inform 6 ]

This is the internal make main object the current object rule:
  set the current object to the main object / "internal".

Include (-
[ set_curr_obj x;
  (+curr_obj_inform6_value+) = x;
  (+get the curr_obj from Inform 6 rule+)();   ! notify Inform 7 about the change
];
-)

Section 3.3 - "Say object" rules

To say => present tense:
   change temporary_tense to present tense;
   change use_temporary_tense to true.

To say => past tense:
   change temporary_tense to past tense;
   change use_temporary_tense to true.

To say => default tense:
   change temporary_tense to the library message tense;
   change use_temporary_tense to false.

To say => %:
   set the current object to the main object / "=>%".

To say => actor:
   set the current object to the person asked / "=>actor".

[ same as saying "[current object is ...]" ]

To say => (obj_ - an object):
   set the current object to obj_ / "=>".

To say % => (obj_ - an object):
   change the main object to obj_;
   set the current object to the main object / "%=>".

To say %:
   make sure main object is set / "%";
   if the main object is the player, say "[you]";
   otherwise say "[main object]".

To say the %:
   make sure main object is set / "the %";
   if the main object is the player, say "[you]";
   otherwise say "[the main object]".

To say The %:
   make sure main object is set / "The %";
   if the main object is the player, say "[You]";
   otherwise say "[The main object]";
   change curr_subject to the main object.

To say the % dobj:
   make sure main object is set / "the % dobj";
   if the main object is the player, say "[you|yourself]";
   otherwise say "[the main object]".

To say % dobj:
   make sure main object is set / "% dobj";
   if the main object is the player, say "[you|yourself]";
   otherwise say "[main object]".

To say inform 6 short name of %:
   make sure main object is set / "I6 %";
   if the main object is the player, say "[you]";
   otherwise say "[main object]".   [ probably wrong; Inform 6 uses print_obj to print this ]

To say The $:
   if curr_obj is the player, say "[You]";
   otherwise say "[The curr_obj]";
   change curr_subject to curr_obj.

To say the $:
   if curr_obj is the player, say "[you]";
   otherwise say "[the curr_obj]".

To say $:
   if curr_obj is the player, say "[you]";
   otherwise say "[curr_obj]".

To say $ dobj:
   if curr_obj is the player, say "[you|yourself]";
   otherwise say "[curr_obj]".

To say the $ dobj:
   if curr_obj is the player, say "[you|yourself]";
   otherwise say "[the curr_obj]".

To say The actor:
   say "[=> actor][The $]".
To say the actor:
   say "[=> actor][the $]".

Section 3.5 - Genere

A thing can be male or female. A thing is usually male.
A thing can be singular-named or plural-named. A thing is usually singular-named.
A room can be male or female. A room is usually male.
A room can be singular-named or plural-named. A room is usually singular-named.

Section 3.4 - Decision rules - unindexed

[ The following rule was taken from Emily Short's "Plurality" extension ]

To decide whether (x_ - an object) acts plural:
   if x_ is plural-named, decide yes;
   otherwise decide no.

To decide whether (x_ - an object) does not act plural:
   if x_ acts plural, decide no;
   otherwise decide yes.

To decide whether (x_ - an object) acts feminine: 
   if x_ is female, decide yes;
   otherwise decide no.

To decide whether (x_ - an object) acts neuter: 
   (- {x_} has neuter || ({x_} hasnt animate && {x_} hasnt female) -).

To decide whether lm_present:
	if use_temporary_tense is true:
   		if temporary_tense is present tense, decide yes;
		decide no;
	otherwise:
   		if library message tense is present tense, decide yes;
		decide no;

To decide whether lm_past:
	if use_temporary_tense is true:
		if temporary_tense is past tense, decide yes;
		decide no;
	otherwise:
		if library message tense is past tense, decide yes;
		decide no.

To decide whether lm_plu:
   if curr_obj_number is plural, decide yes;
   otherwise decide no.
To decide whether lm_sing:
   if curr_obj_number is singular, decide yes;
   otherwise decide no.

To decide whether lm_p1:
   if curr_obj_person is first person, decide yes;
   otherwise decide no.
To decide whether lm_p2:
   if curr_obj_person is second person, decide yes;
   otherwise decide no.
To decide whether lm_p3:
   if curr_obj_person is third person, decide yes;
   otherwise decide no.

To decide whether lm_masc:
   if curr_obj_gender is gender masculine, decide yes;
   otherwise decide no.
To decide whether lm_not_masc:
   if curr_obj_gender is gender masculine, decide no;
   otherwise decide yes.
To decide whether lm_fem:
   if curr_obj_gender is gender feminine, decide yes;
   otherwise decide no.
To decide whether lm_neut:
   if curr_obj_gender is gender neuter, decide yes;
   otherwise decide no.

Section 3.5 - Grammatical tables

Table of 'you' forms 
Gramm Person	Gramm Number	Case	Word
first person	singular		upper-case 	"Io"
second person	singular		upper-case	"Tu"
third person	singular		upper-case	"Egli"
first person	plural		upper-case	"Noi"
second person	plural		upper-case	"Voi"
third person	plural		upper-case	"Essi"
first person	singular		lower-case 	"io"
second person	singular		lower-case	"tu"
third person	singular		lower-case	"egli"
first person	plural		lower-case	"noi"
second person	plural		lower-case	"voi"
third person	plural		lower-case	"essi"

Table of 'you' dobj forms
Gramm Person	Gramm Number	Word
first person	singular		"me"
second person	singular		"te"
third person	singular		"lui"
first person	plural		"essi"
second person	plural		"essi"
third person	plural		"essi"

Table of 'your' forms
Gramm Person	Gramm Number	Case	Word
first person	singular		upper-case 	"Mio"
second person	singular		upper-case	"Tuo"
third person	singular		upper-case	"Suo"
first person	plural		upper-case	"Nostro"
second person	plural		upper-case	"Vostro"
third person	plural		upper-case	"Loro"
first person	singular		lower-case 	"mio"
second person	singular		lower-case	"tuo"
third person	singular		lower-case	"suo"
first person	plural		lower-case	"nostro"
second person	plural		lower-case	"vostro"
third person	plural		lower-case	"loro"

Table of 'yourself' forms
Gramm Person	Gramm Number	Case	Word
first person	singular		upper-case 	"Me stesso"
second person	singular		upper-case	"Te stesso"
third person	singular		upper-case	"Egli stesso"
first person	plural		upper-case	"Noi stessi"
second person	plural		upper-case	"Voi stessi"
third person	plural		upper-case	"Loro stessi"
first person	singular		lower-case 	"me stesso"
second person	singular		lower-case	"te stesso"
third person	singular		lower-case	"egli stesso"
first person	plural		lower-case	"voi stessi"
second person	plural		lower-case	"noi stessi"
third person	plural		lower-case	"loro stessi"

Table of 'he' forms
Gender			Gramm Number	Case	Word
gender masculine	singular		upper-case	"Egli"
gender feminine		singular		upper-case	"Ella"
gender neuter		singular		upper-case	"Esso"
gender masculine	plural		upper-case	"Essi"
gender feminine		plural		upper-case	"Essi"
gender neuter		plural		upper-case	"Essi"
gender masculine	singular		lower-case	"egli"
gender feminine		singular		lower-case	"ella"
gender neuter		singular		lower-case	"esso"
gender masculine	plural		lower-case	"essi"
gender feminine		plural		lower-case	"essi"
gender neuter		plural		lower-case	"essi"

Table of 'his' forms
Gender			Gramm Number	Case	Word
gender masculine	singular		upper-case	"Suo"
gender feminine		singular		upper-case	"Suo"
gender neuter		singular		upper-case	"Suo"
gender masculine	plural		upper-case	"Loro"
gender feminine		plural		upper-case	"Loro"
gender neuter		plural		upper-case	"Loro"
gender masculine	singular		lower-case	"suo"
gender feminine		singular		lower-case	"suo"
gender neuter		singular		lower-case	"suo"
gender masculine	plural		lower-case	"loro"
gender feminine		plural		lower-case	"loro"
gender neuter		plural		lower-case	"loro"

Table of 'him' forms
Gender				Gramm Number	Case	Word
gender masculine	singular		upper-case	"Lui"
gender feminine		singular		upper-case	"Lei"
gender neuter		singular		upper-case	"Esso"
gender masculine	plural		upper-case	"Essi"
gender feminine		plural		upper-case	"Essi"
gender neuter		plural		upper-case	"Essi"
gender masculine	singular		lower-case	"lui"
gender feminine		singular		lower-case	"lei"
gender neuter		singular		lower-case	"esso"
gender masculine	plural		lower-case	"essi"
gender feminine		plural		lower-case	"essi"
gender neuter		plural		lower-case	"essi"

Table of 'himself' forms
Gender				Gramm Number	Case	Word
gender masculine	singular		upper-case	"Lui stesso"
gender feminine		singular		upper-case	"Lei stessa"
gender neuter		singular		upper-case	"Esso stesso"
gender masculine	plural		upper-case	"Essi stessi"
gender feminine		plural		upper-case	"Essi stessi"
gender neuter		plural		upper-case	"Essi stessi"
gender masculine	singular		lower-case	"lui stesso"
gender feminine		singular		lower-case	"lei stessa"
gender neuter		singular		lower-case	"essa stessa"
gender masculine	plural		lower-case	"essi stessi"
gender feminine		plural		lower-case	"essi stessi"
gender neuter		plural		lower-case	"essi stessi"

Table of 'are' forms
Gramm Person	Gramm Number	Case	Word	Negative
first person	singular		upper-case 	"Sono"	"Non sono"
second person	singular		upper-case	"Sei"	"Non sei"
third person	singular		upper-case	"E[']"	"Non è"
first person	plural		upper-case	"Siamo"	"Non siamo"
second person	plural		upper-case	"Siete"	"Non siete"
third person	plural		upper-case	"Sono"	"Non sono"
first person	singular		lower-case 	"sono"	"non sono"
second person	singular		lower-case	"sei"	"non sei"
third person	singular		lower-case	"è"	"non è"
first person	plural		lower-case	"siamo"	"non siamo"
second person	plural		lower-case	"siete"	"non siete"
third person	plural		lower-case	"sono"	"non sono"

Table of 'were' forms
Gramm Person	Gramm Number	Case	Word	Negative
first person	singular		upper-case 	"Ero"	"Non ero"
second person	singular		upper-case	"Eri"	"Non eri"
third person	singular		upper-case	"Era"	"Non era"
first person	plural		upper-case	"Eravamo"	"Non eravamo"
second person	plural		upper-case	"Eravate"	"Non eravate"
third person	plural		upper-case	"Erano"	"Non erano"
first person	singular		lower-case 	"ero"	"non ero"
second person	singular		lower-case	"eri"	"non eri"
third person	singular		lower-case	"era"	"non era"
first person	plural		lower-case	"eravamo"	"non eravamo"
second person	plural		lower-case	"eravate"	"non eravate"
third person	plural		lower-case	"erano"	"non erano"

Table of 'have' forms
Gramm Person	Gramm Number	Case	Word	Negative
first person	singular		upper-case 	"Ho"	"Non ho"
second person	singular		upper-case	"Hai"	"Non hai"
third person	singular		upper-case	"Ha"	"Non ha"
first person	plural		upper-case	"Abbiamo"	"Non abbiamo"
second person	plural		upper-case	"Avete"	"Non avete"
third person	plural		upper-case	"Hanno"	"Non hanno"
first person	singular		lower-case 	"ho"	"non ho"
second person	singular		lower-case	"hai"	"non hai"
third person	singular		lower-case	"ha"	"non ha"
first person	plural		lower-case	"abbiamo"	"non abbiamo"
second person	plural		lower-case	"avete"	"non avete"
third person	plural		lower-case	"hanno"	"non hanno"

Table of 'had' forms
Gramm Person	Gramm Number	Case	Word	Negative
first person	singular		upper-case 	"Avevo"	"Non avevo"
second person	singular		upper-case	"Avevi"	"Non avevi"
third person	singular		upper-case	"Aveva"	"Non aveva"
first person	plural		upper-case	"Avevamo"	"Non avevamo"
second person	plural		upper-case	"Avevate"	"Non avevate"
third person	plural		upper-case	"Avevano"	"Non avevano"
first person	singular		lower-case 	"avevo"	"non avevo"
second person	singular		lower-case	"avevi"	"non avevi"
third person	singular		lower-case	"aveva"	"non aveva"
first person	plural		lower-case	"avevamo"	"non avevamo"
second person	plural		lower-case	"avevate"	"non avevate"
third person	plural		lower-case	"avevano"	"non avevano"

Table of 'can' forms
Gramm Person	Gramm Number	Case	Word	Negative
first person	singular		upper-case 	"Posso"	"Non posso"
second person	singular		upper-case	"Puoi"	"Non puoi"
third person	singular		upper-case	"Può"	"Non può"
first person	plural		upper-case	"Possiamo"	"Non possiamo"
second person	plural		upper-case	"Potete"	"Non potete"
third person	plural		upper-case	"Possono"	"Non possono"
first person	singular		lower-case 	"posso"	"non posso"
second person	singular		lower-case	"puoi"	"non puoi"
third person	singular		lower-case	"può"	"non può"
first person	plural		lower-case	"possiamo"	"non possiamo"
second person	plural		lower-case	"potete"	"non potete"
third person	plural		lower-case	"possono"	"non possono"

Table of 'could' forms
Gramm Person	Gramm Number	Case	Word	Negative
first person	singular		upper-case 	"Potevo"	"Non potevo"
second person	singular		upper-case	"Potevi"	"Non potevi"
third person	singular		upper-case	"Poteva"	"Non poteva"
first person	plural		upper-case	"Potevamo"	"Non potevamo"
second person	plural		upper-case	"Potevate"	"Non potevate"
third person	plural		upper-case	"Potevano"	"Non potevano"
first person	singular		lower-case 	"potevo"	"non potevo"
second person	singular		lower-case	"potevi"	"non potevi"
third person	singular		lower-case	"poteva"	"non poteva"
first person	plural		lower-case	"potevano"	"non potevano"
second person	plural		lower-case	"potevate"	"non potevate"
third person	plural		lower-case	"potevano"	"non potevano"

Section 3.6 - Table operations - unindexed

[ get the "Word" entry from a grammatical table ]

To find (c_ - letter case) & (p_ - grammatical person) & (n_ - grammatical number)
  in (t_ - table-name):
  let r_ be 1;
  let num_ be the number of rows in t_;
  while r_ <= num_ begin;
     choose row r_ in t_;
     if Case entry is c_ and
	    Gramm Person entry is p_ and
	    Gramm Number entry is n_
	 begin;
	    say Word entry;
	    change r_ to num_ + 1;	[ to force the loop to end ]
	 otherwise;
	    change r_ to r_ + 1;
     end if;
  end while.

[ get the "Negative" entry from a grammatical table ]

To find negative (c_ - letter case) & (p_ - grammatical person) & (n_ - grammatical number)
  in (t_ - table-name):
  let r_ be 1;
  let num_ be the number of rows in t_;
  while r_ <= num_ begin;
     choose row r_ in t_;
     if Case entry is c_ and
	    Gramm Person entry is p_ and
	    Gramm Number entry is n_
	 begin;
	    say Negative entry;
	    change r_ to num_ + 1;	[ to force the loop to end ]
	 otherwise;
	    change r_ to r_ + 1;
     end if;
  end while.

[ for tables with gender instead of person, eg. 'he' ]

To find (c_ - letter case) & (g_ - gender) & (n_ - grammatical number)
  in (t_ - table-name):
  let r_ be 1;
  let num_ be the number of rows in t_;
  while r_ <= num_ begin;
     choose row r_ in t_;
     if Case entry is c_ and
	    Gender entry is g_ and
	    Gramm Number entry is n_
	 begin;
	    say Word entry;
	    change r_ to num_ + 1;	[ to force the loop to end ]
	 otherwise;
	    change r_ to r_ + 1;
     end if;
  end while.

[ for tables without "Case" columns ]

To find (p_ - grammatical person) & (n_ - grammatical number)
  in (t_ - table-name):
  let r_ be 1;
  let num_ be the number of rows in t_;
  while r_ <= num_ begin;
     choose row r_ in t_;
     if Gramm Person entry is p_ and
	    Gramm Number entry is n_
	 begin;
	    say Word entry;
	    change r_ to num_ + 1;	[ to force the loop to end ]
	 otherwise;
	    change r_ to r_ + 1;
     end if;
  end while.

Section 3.7 - "Say word" rules

To say (the_case - letter case) 'you':
   set the current object to the player / "'you'";
   if lm_p3 and lm_sing and libmsg_3ps_changed is 0, say the_case 'he';
   otherwise find the_case & curr_obj_person & curr_obj_number
     in the table of 'you' forms.

To say (the_case - letter case) 'your':
   set the current object to the player / "'your'";
   if lm_p3 and lm_sing, say the_case 'his';
   otherwise find the_case & curr_obj_person & curr_obj_number
     in the table of 'your' forms.

To say (the_case - letter case) 'yourself':
   set the current object to the player / "'yourself'";
   if lm_p3 and lm_sing, find the_case & curr_obj_gender & curr_obj_number
     in the table of 'himself' forms;
   otherwise find the_case & curr_obj_person & curr_obj_number
     in the table of 'yourself' forms.

To say (the_case - letter case) 'himself':
   set the current object to main object / "'himself'";
   find the_case & curr_obj_gender & curr_obj_number
     in the table of 'himself' forms.

[ "you" as the direct object (always lower case), eg. "He saw you" ]

To say you dobj:
   set the current object to the player / "you dobj";
   if lm_p3 and lm_sing and libmsg_3ps_changed is 0, say "[him]";
   otherwise find curr_obj_person & curr_obj_number
     in the table of 'you' dobj forms.

To say you|yourself:
   if curr_subject is the player,    [ if the player is doing the action ]
      say "[yourself]";
   otherwise say you dobj.

To say (the_case - letter case) 'he':
   find the_case & curr_obj_gender & curr_obj_number
     in the table of 'he' forms.

To say (the_case - letter case) 'his':
   find the_case & curr_obj_gender & curr_obj_number
     in the table of 'his' forms.

To say (the_case - letter case) 'him':
   find the_case & curr_obj_gender & curr_obj_number
     in the table of 'him' forms.

To find (the_case - letter case) verb in (t_present - table-name) / (t_past - table-name):
   if lm_present, find the_case & curr_obj_person & curr_obj_number
     in t_present;
   otherwise find the_case & curr_obj_person & curr_obj_number
     in t_past.

To find (the_case - letter case) negative in (t_present - table-name) / (t_past - table-name):
   if lm_present, find negative the_case & curr_obj_person & curr_obj_number
     in t_present;
   otherwise find negative the_case & curr_obj_person & curr_obj_number
     in t_past.

To say (the_case - letter case) 'are' for (obj_ - object):
   set the current object to obj_ / "'are'";
   find the_case verb in the table of 'are' forms /
     the table of 'were' forms.

To say (the_case - letter case) 'were' for (obj_ - object):
   set the current object to obj_ / "'were'";
   find the_case verb in the table of 'were' forms /
     the table of 'were' forms.

To say (the_case - letter case) 'aren't' for (obj_ - object):
   set the current object to obj_ / "'aren't'";
   find the_case negative in the table of 'are' forms /
     the table of 'were' forms.

To say (the_case - letter case) 'have' for (obj_ - object):
   set the current object to obj_ / "'have'";
   find the_case verb in the table of 'have' forms /
     the table of 'had' forms.

To say (the_case - letter case) 'haven't' for (obj_ - object):
   set the current object to obj_ / "'haven't'";
   find the_case negative in the table of 'have' forms /
     the table of 'had' forms.

To say (the_case - letter case) 'can':
   find the_case verb in the table of 'can' forms /
       the table of 'could' forms.

To say (the_case - letter case) 'can't':
   find the_case negative in the table of 'can' forms /
       the table of 'could' forms.

To say (the_case - letter case) 'have' auxiliary for (obj_ - object):
   set the current object to obj_ / "'have' aux";
   find the_case & curr_obj_person & curr_obj_number
     in the table of 'have' forms.

To say (the_case - letter case) 'haven't' auxiliary for (obj_ - object):
   set the current object to obj_ / "'haven't' aux";
   find negative the_case & curr_obj_person & curr_obj_number
     in the table of 'have' forms.

To say You: say upper-case 'you'; change curr_subject to the player.
To say Your: say upper-case 'your'.
To say Yourself: say upper-case 'yourself'.
To say He: say upper-case 'he'; change curr_subject to curr_obj.
To say His: say upper-case 'his'.
To say Him: say upper-case 'him'.
To say Himself: say upper-case 'himself'.

To say you: say lower-case 'you'; change curr_subject to the player.
To say your: say lower-case 'your'.
To say yourself: say lower-case 'yourself'.
[ To say you dobj: defined above ]
[ To say you|yourself: defined above ]
To say he: say lower-case 'he'; change curr_subject to curr_obj.
To say his: say lower-case 'his'.
To say him: say lower-case 'him'.
To say himself: say lower-case 'himself'.

[ 'are' and 'have' assume the player is the subject; if some other
  thing is the subject, use 'is|are' / 'has|have' instead ]

To say Are: say upper-case 'are' for the player; change curr_subject to the player.
To say Aren't: say upper-case 'aren't' for the player; change curr_subject to the player.
To say Have: say upper-case 'have' for the player; change curr_subject to the player.
To say Haven't: say upper-case 'haven't' for the player; change curr_subject to the player.
To say Have+: say upper-case 'have' auxiliary for the player; change curr_subject to the player.
To say Haven't+: say upper-case 'haven't' auxiliary for the player; change curr_subject to the player.

To say are: say lower-case 'are' for the player.
To say aren't: say lower-case 'aren't' for the player.
To say have: say lower-case 'have' for the player.
To say haven't: say lower-case 'haven't' for the player.
To say have+: say lower-case 'have' auxiliary for the player.
To say haven't+: say lower-case 'haven't' auxiliary for the player.

To say Can: say upper-case 'can'.
To say Can't: say upper-case 'can't'.
To say can: say lower-case 'can'.
To say can't: say lower-case 'can't'.

To say It's: say "[/r]"; follow the upper-case 'it's' rule.
To say it's: say "[/r]";  follow the lower-case 'it's' rule.
To say There's: say "[/r]";  follow the upper-case 'there's' rule.
To say there's: say "[/r]";  follow the lower-case 'there's' rule.
To say comes|came: say "[/r]";  follow the lower-case 'comes' rule.

[ here/there, for contexts like "A dog is here" or "A dog was there" ]
To say here: say "[if lm_past]t[end if]qui".

This is the upper-case 'it's' rule:
   say "[if lm_present]E['][otherwise]Era".
This is the lower-case 'it's' rule:
   say "[if lm_present]è[otherwise]era".
This is the upper-case 'there's' rule:
   say "[if lm_present]C[']è[otherwise]C[']era".
This is the lower-case 'there's' rule:
   say "[if lm_present]c[']è[otherwise]c[']era".
This is the lower-case 'comes' rule:
   say "[if lm_present]viene[otherwise]veniva".

To say Is|Are: say upper-case 'are' for curr_obj; change curr_subject to curr_obj.
To say Was|Were: say upper-case 'were' for curr_obj; change curr_subject to curr_obj.
To say Has|Have: say upper-case 'have' for curr_obj; change curr_subject to curr_obj.
To say Isn't|Aren't: say upper-case 'aren't' for curr_obj; change curr_subject to curr_obj.
To say Hasn't|Haven't: say upper-case 'haven't' for curr_obj; change curr_subject to curr_obj.

To say is|are: say lower-case 'are' for curr_obj.
To say was|were: say lower-case 'were' for curr_obj.
To say has|have: say lower-case 'have' for curr_obj.
To say isn't|aren't: say lower-case 'aren't' for curr_obj.
To say hasn't|haven't: say lower-case 'haven't' for curr_obj.

To say Is|Was:
   if lm_present, find upper-case & third person & singular in the table of 'are' forms;
   otherwise find upper-case & third person & singular in the table of 'were' forms.
To say Isn't|Wasn't:
   if lm_present, find negative upper-case & third person & singular in the table of 'are' forms;
   otherwise find negative upper-case & third person & singular in the table of 'were' forms.
To say is|was:
   if lm_present, find lower-case & third person & singular in the table of 'are' forms;
   otherwise find lower-case & third person & singular in the table of 'were' forms.
To say isn't|wasn't:
   if lm_present, find negative lower-case & third person & singular in the table of 'are' forms;
   otherwise find negative lower-case & third person & singular in the table of 'were' forms.

To print (word1_ - text) for singular or (word2_ - text) for plural:
   if curr_obj is the player, say "[if lm_p3 and lm_sing][word1_][otherwise][word2_]";
   otherwise say "[if curr_obj acts plural][word2_][otherwise][word1_]".

To say It|They:
   print "Esso" for singular or "Essi" for plural; change curr_subject to curr_obj.
To say It|Those:
   print "Esso" for singular or "Quelli" for plural; change curr_subject to curr_obj.
To say That|Those:
   print "Quello" for singular or "Quelli" for plural; change curr_subject to curr_obj.
To say That|They:
   print "Quello" for singular or "Essi" for plural; change curr_subject to curr_obj.
To say That's|They're:
   print "Quello è" for singular or "Essi sono" for plural; change curr_subject to curr_obj.

[ for the following group of "say" rules, assume main object is being referred to ]

To say it|they:
   set the current object to main object / "it|they";
   print "esso" for singular or "essi" for plural. 
To say it|them:
   set the current object to main object / "it|them";
   print "lo" for singular or "li" for plural.
To say it|those:
   set the current object to main object / "it|those";
   print "quello" for singular or "quelli" for plural. 
To say that|those:
   set the current object to main object / "that|those";
   print "quello" for singular or "quelli" for plural.

To say is|are for (n_ - a number):
    if n_ is 1, say "è";
    otherwise say "sono".

To say off|out of:
  if curr_obj is a container, say "fuori da";
  otherwise say "da".
To say onto|into:
  if curr_obj is a container, say "dentro";
  otherwise say "sopra".
To say on|in:
  if curr_obj is a container, say "dentro";
  otherwise say "sopra".
To say On|In:
  if curr_obj is a container, say "Dentro";
  otherwise say "Sopra".

Section 3.8 - "Say suffix" rules

Section 3.9 - Irregular verbs

Section 3.10 - "Say symbol" rules

[ Some conventient abbreviations to prevent spurious line breaks
  from occurring in some messages ]

To say dot:
   say "[unicode 46]".
To say ExMark:
   say "[unicode 33]".
To say QMark:
   say "[unicode 63]".

Section 3.11 - Miscellaneous "say" rules

To say /n: say "[line break][run paragraph on]".
To say /p: say paragraph break.
To say /r: say run paragraph on.

To say the player's holdall:
   (- print (the) SACK_OBJECT; set_curr_obj(SACK_OBJECT); -)

To say story name:
   (- print (string) Story; -).

To say pronoun word:
   (- print (address) pronoun_word; -).

To say the last command:
    (- PrintCommand(); -).

Section 3.12 - Miscellaneous decision rules

To decide if game over:
   (- deadflag -).

To decide whether noun is living:
   (- noun has animate -).

To decide whether noun is doing the action:
   (- noun == actor -).

To decide whether noun is not doing the action:
   (- noun ~= actor -).

To decide whether player is doing the action:
   (- actor == player -).

To decide whether player is not doing the action:
   (- actor ~= player -).

[
To decide whether player can see the actor:
   (- I7_CanSee(player, actor) -).
]

To decide whether there are multiple objects:
   (- multiflag == 1 -).

To decide whether there are not multiple objects:
   (- multiflag ~= 1 -).

[ perform a binary search to quickly find the message id in the
  table of library messages (assumes the table has been sorted) ]

This is the print library message rule:
   change libmsg-was-empty to 1;
   let n1 be 1;
   let n2 be the number of rows in the table of library messages;
   while n1 <= n2 begin;
      let mid be n1 plus n2;
	  change mid to mid divided by 2;
	  choose row mid in the table of library messages;
	  if the message id entry is library-message-id begin;
	     if the message text entry is not "" begin;
		    say the message text entry;
			change libmsg-was-empty to 0;
	     end if;
		 change n1 to n2 + 1;	[ to force the loop to stop ]
	  end if;
	  if the message id entry < library-message-id, change n1 to mid plus 1;
      if the message id entry > library-message-id, change n2 to mid minus 1;
   end while.

libmsg-was-empty is a number that varies.

Part 4 - Inform 6 interface - unindexed

To init library messages:
(- InitLibraryMessages(); -)

[
  The following I6 code (in InitLibraryMessages) does not compile under
  Glulx (it says "Illegal backpatch marker in forward-declared symbol").

  It was originally added in version 6 to prevent infinite
  recursion when pushing an object between rooms; the Standard Rules
  file says:

     Include (- with before [; PushDir: AllowPushDir(); rtrue; ]
     ... -) when defining a thing

  - which caused problems when defining the I7_LibraryMessages
  object, and so the code below removed all "befores" other than
  LibraryMessagesBefore.

  To make a long story short ... the original PushDir problem seems
  to have gone away, but I am still suspicious, so I'll leave it in
  when compiling to Z code.
]

Include (-
  Constant LibraryMessages = (+I7_LibraryMessages+);

[ InitLibraryMessages n;

#Ifndef TARGET_GLULX;
  if ((+I7_LibraryMessages+).&before)
  {
      ! get rid of any other "before" routines
      for (n = 0 : n < (+I7_LibraryMessages+).#before / WORDSIZE : n++)
      {
          if ((+I7_LibraryMessages+).&before --> n ~= LibraryMessagesBefore)
              (+I7_LibraryMessages+).&before --> n = nothing;
      }
  }
#Endif; ! TARGET_GLULX
];
-) after "Definitions.i6t".

I7_LibraryMessages is a thing.
Include (-
  with before LibraryMessagesBefore,
-) when defining I7_LibraryMessages.

Include (-
[ LibraryMessagesBefore id temp isImplicitAction after_text;
    (+the numeric amount+) = lm_o;
    (+main object+) = lm_o;
    (+secondary object+) = lm_o2;
    (+curr_subject+) = actor;

    if (actor ~= player) { set_curr_obj(actor); }
    else if (lm_o > 0) { set_curr_obj(lm_o); }
    else { set_curr_obj(player); }

    id = -1;
    isImplicitAction = 0;
    after_text = "^";
-)

[ Note that there is no "Prompt:" section, since Inform 7 handles
  the prompt specially; see "Changing the command prompt" in the I7 manual ]

[*** Miscellany ***]

Include (-
Miscellany:
    switch (lm_n) {
       1: id = (+LibMsg <first N objects>+); after_text = "";
       2: id = (+LibMsg <zero multiple objects>+);
       3: id = (+LibMsg <you have died>+); after_text = "";
       4: id = (+LibMsg <you have won>+); after_text = "";
     ! 5 is "Would you like to restart ...", handled specially by Inform 7
       6: id = (+LibMsg <undo not provided>+);
       7: id = (+LibMsg <undo failed>+);
       8: id = (+LibMsg <restrict answer>+); after_text = "";
       9: id = (+LibMsg <entering darkness>+);
       10: id = (+LibMsg <empty line>+);
       11: id = (+LibMsg <cannot undo nothing>+);
       12: id = (+LibMsg <cannot undo twice in a row>+);
       13: id = (+LibMsg <undo succeeded>+);
       14: id = (+LibMsg <oops failed>+);
       15: id = (+LibMsg <oops no arguments>+);
       16: id = (+LibMsg <oops too many arguments>+);
       17: id = (+LibMsg <dark description>+);
       18: id = (+LibMsg <player self description>+); after_text = "";
     ! 19 was LibMsg <player description>, "As good-looking as ever"
	 ! - use "The description of the player is ..." instead.
       20: id = (+LibMsg <again usage>+);
       21: id = (+LibMsg <cannot do again>+);
       22: id = (+LibMsg <cannot begin at comma>+);
       23: id = (+LibMsg <cannot talk to absent person>+);
       24: id = (+LibMsg <cannot talk to inanimate object>+);
       25: id = (+LibMsg <extra words before comma>+);
       26: id = (+LibMsg <report implicit take>+);
       27: id = (+LibMsg <command not understood>+);
       28: id = (+LibMsg <command partly understood>+); after_text = "";
       29: id = (+LibMsg <number not understood>+);
       30: id = (+LibMsg <unknown object>+);
-)

Include (-
       31: id = (+LibMsg <command incomplete>+);
       32: id = (+LibMsg <object not held>+);
       33: id = (+LibMsg <verb cannot have multiple objects>+);
       34: id = (+LibMsg <too many multiple objects>+);
       35: id = (+LibMsg <pronoun not set>+);
       36: id = (+LibMsg <excepted object not included anyway>+);
       37: id = (+LibMsg <verb cannot have inanimate object>+);
       38: id = (+LibMsg <unknown verb>+);
       39: id = (+LibMsg <unimportant object>+);
       40: (+main object+) = pronoun_obj;
	 (+internal make main object the current object rule+)();
	 id = (+LibMsg <pronoun absent>+);
       41: id = (+LibMsg <command badly ended>+);
       42: id = (+LibMsg <not that many available>+);
       43: id = (+LibMsg <zero multiple objects>+); ! same as Miscellany #2 (?)
       44: id = (+LibMsg <no objects available>+);
       45: id = (+LibMsg <who disambiguation>+); after_text = "";
       46: id = (+LibMsg <which disambiguation>+); after_text = "";
       47: id = (+LibMsg <single object disambiguation>+);
       48: (+main object+) = actor;
	 (+internal make main object the current object rule+)();
	 id = (+LibMsg <whom disambiguation>+);
       49: (+main object+) = actor;
	 (+internal make main object the current object rule+)();
	 id = (+LibMsg <what disambiguation>+);
       50: id = (+LibMsg <score changed>+); after_text = "";
       51: id = (+LibMsg <command cut short>+);
       52: id = (+LibMsg <menu prompt>+); after_text = "";
       53: id = (+LibMsg <page prompt>+); after_text = "";
       54: id = (+LibMsg <comment recorded>+);
       55: id = (+LibMsg <comment not recorded>+);
     ! 56 = ".^"
     ! 57 = "?^"
       58: id = (+LibMsg <npc unable to do that>+);
       59: id = (+LibMsg <noun needed>+);
       60: id = (+LibMsg <noun not needed>+);
       61: id = (+LibMsg <object needed>+);
       62: id = (+LibMsg <object not needed>+);
       63: id = (+LibMsg <second object needed>+);
       64: id = (+LibMsg <second object not needed>+);
       65: id = (+LibMsg <second noun needed>+);
       66: id = (+LibMsg <second noun not needed>+);
       67: id = (+LibMsg <something more substantial needed>+);
       68: id = (+LibMsg <report npc implicit take>+);
       69: id = (+LibMsg <report implicit take>+);
       70: id = (+LibMsg <undo forbidden>+);
       71: id = (+LibMsg <dark room name>+);
       72: id = (+LibMsg <person ignores command>+);
            default: jump not_handled; }
    jump handled;
-)

[*** Quit, Restart ***]

Include (-
Quit:
    switch (lm_n) {
       1: id = (+LibMsg <yes or no prompt>+); after_text = "";
       2: id = (+LibMsg <confirm Quit>+); after_text = "";
       default: jump not_handled; }
    jump handled;

Restart:
    switch (lm_n) {
       1: id = (+LibMsg <confirm Restart>+); after_text = "";
       2: id = (+LibMsg <Restart failed>+);
       default: jump not_handled; }
    jump handled;
-)

[*** File Operations ***]

Include (-

Restore:
    switch (lm_n) {
       1: id = (+LibMsg <Restore failed>+);
       2: id = (+LibMsg <Restore succeeded>+);
       default: jump not_handled; }
    jump handled;

Save:
    switch (lm_n) {
       1: id = (+LibMsg <Save failed>+);
       2: id = (+LibMsg <Save succeeded>+);
       default: jump not_handled; }
    jump handled;

Verify:
    switch (lm_n) {
       1: id = (+LibMsg <Verify succeeded>+);
       2: id = (+LibMsg <Verify failed>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Transcripts ***]

Include (-
ScriptOn:
    switch (lm_n) {
       1: id = (+LibMsg <transcript already on>+);
       2: id = (+LibMsg <start of transcript>+); after_text = "";
       3: id = (+LibMsg <transcript failed>+);
       default: jump not_handled; }
    jump handled;

ScriptOff:
    switch (lm_n) {
       1: id = (+LibMsg <transcript already off>+);
       2: id = (+LibMsg <end of transcript>+);
       3: id = (+LibMsg <end transcript failed>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Scoring ***]

Include (-
NotifyOn:
     id = (+LibMsg <score notification turned on>+);
     jump handled;

NotifyOff:
     id = (+LibMsg <score notification turned off>+);
     jump handled;

Score:
    switch (lm_n) {
       1: id = (+LibMsg <Score command>+); after_text = "";
       2: id = (+LibMsg <no scoring>+);
       3: id = (+LibMsg <score rank>+); after_text = "";
       default: jump not_handled; }
     jump handled;
-)

[*** Listing ***]

Include (-
Pronouns:
    switch (lm_n) {
       1: id = (+LibMsg <Pronouns initial text>+); after_text = "";
       2: id = (+LibMsg <Pronouns -means- text>+); after_text = " ";
       3: id = (+LibMsg <Pronouns -unset- text>+); after_text = "";
       4: id = (+LibMsg <no pronouns known>+);
       default: jump not_handled; }
    jump handled;

Inv:
    switch (lm_n) {
       1: id = (+LibMsg <Inventory no possessions>+);
       2: id = (+LibMsg <Inventory initial text>+); after_text = "";
     ! 3 is ":^" (used for list style NEWLINE_BIT)
     ! 4 is ".^" (used for list style ENGLISH_BIT)
       5: id = (+LibMsg <report npc taking inventory>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Take, Remove ***]

Include (-
Take:
    switch (lm_n) {
       1: id = (+LibMsg <report player taking>+);
       2: id = (+LibMsg <cannot take yourself>+);
       3: id = (+LibMsg <cannot take other people>+);
       4: id = (+LibMsg <cannot take something you are within>+);
       5: id = (+LibMsg <cannot take something already taken>+);
       6: id = (+LibMsg <cannot take possessions of others>+);
       7: id = (+LibMsg <cannot take component parts>+);
       8: id = (+LibMsg <cannot take hidden parts>+);
       9: id = (+LibMsg <cannot reach within closed containers>+);
       10: id = (+LibMsg <cannot take scenery>+);
       11: id = (+LibMsg <cannot take something fixed>+);
       12: id = (+LibMsg <cannot exceed carrying capacity>+);
       13: id = (+LibMsg <use holdall to avoid exceeding carrying capacity>+);
             isImplicitAction = 1;
       14: id = (+LibMsg <cannot reach within other places>+);
     ! 15 doesn't seem to be produced anywhere ("You cannot carry ...")
       16: id = (+LibMsg <report npc taking>+);
       default: jump not_handled; }
    jump handled;

Remove:
    switch (lm_n)
    {  1: id = (+LibMsg <cannot remove from closed containers>+);
       2: id = (+LibMsg <cannot remove something not within>+);
       3: id = (+LibMsg <report player removing>+); ! TODO - not printed any more? ("Taken" instead)
      ! TODO (maybe): need 4 = LibMsg <report npc removing>
       default: jump not_handled; }
    jump handled;
-)

[*** Drop, Insert, Put ***]

Include (-
Drop:
    switch (lm_n) {
       1: id = (+LibMsg <cannot drop something already dropped>+);
       2: id = (+LibMsg <cannot drop not holding>+);
       3: id = (+LibMsg <cannot drop clothes being worn>+);
           isImplicitAction = 1;
       4: id = (+LibMsg <report player dropping>+);
       5,6: id = (+LibMsg <cannot drop if this exceeds carrying capacity>+);   ! 5 = supporter, 6 = container
       7: id = (+LibMsg <report npc dropping>+);
       default: jump not_handled; }
    jump handled;

Insert:
    switch (lm_n) {
       1: id = (+LibMsg <cannot insert something not held>+);
       2: id = (+LibMsg <cannot insert into something not a container>+);
       3: id = (+LibMsg <cannot insert into closed containers>+);
       4: id = (+LibMsg <need to take off before inserting>+);   ! (unused ?)
       5: id = (+LibMsg <cannot insert something into itself>+);
       6: id = (+LibMsg <cannot insert clothes being worn>+);
           isImplicitAction = 1;
       7: id = (+LibMsg <cannot insert if this exceeds carrying capacity>+);
       8,9: id = (+LibMsg <report player inserting>+);  ! 8 is for multiple objects
       10: id = (+LibMsg <report npc inserting>+);
       default: jump not_handled; }
    jump handled;

PutOn:
    switch (lm_n) {
       1: id = (+LibMsg <cannot put something not held>+);
       2: id = (+LibMsg <cannot put something on it-self>+);
       3: id = (+LibMsg <cannot put onto something not a supporter>+);
       4: id = (+LibMsg <cannot put onto something being carried>+);
       5: id = (+LibMsg <cannot put clothes being worn>+);
           isImplicitAction = 1;
       6: id = (+LibMsg <cannot put if this exceeds carrying capacity>+);
       7,8: id = (+LibMsg <report player putting on>+);  ! 7 is for multiple objects
       9: id = (+LibMsg <report npc putting on>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Give, Show ***]

Include (-
Give:
    switch (lm_n) {
       1: id = (+LibMsg <cannot give what you have not got>+);
       2: id = (+LibMsg <cannot give to yourself>+);
       3: id = (+LibMsg <block giving>+);
       4: id = (+LibMsg <unable to receive things>+);
       5: id = (+LibMsg <report player giving>+);
       6: id = (+LibMsg <report npc giving to player>+);  
       7: id = (+LibMsg <report npc giving to npc>+);
      default: jump not_handled; }
    jump handled;

Show:
    switch (lm_n) {
       1: id = (+LibMsg <cannot show what you have not got>+);
       2: id = (+LibMsg <block showing>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Enter, Exit, GetOff ***]

Include (-
Enter:
    switch (lm_n) {
       1: id = (+LibMsg <cannot enter something already entered>+);
       2: id = (+LibMsg <cannot enter something not enterable>+);
       3: id = (+LibMsg <cannot enter closed containers>+);
       4: id = (+LibMsg <cannot enter something carried>+);
       5: id = (+LibMsg <report player entering>+);
       6: id = (+LibMsg <implicitly pass outwards through other barriers>+);
          isImplicitAction = 1;
       7: id = (+LibMsg <implicitly pass inwards through other barriers>+);
           isImplicitAction = 1;
       8: id = (+LibMsg <report npc entering container>+);  ! 8 = container
       9: id = (+LibMsg <report npc entering supporter>+);  ! 9 = supporter
       default: jump not_handled; }
    jump handled;

Exit:
    switch (lm_n) {
       1: id = (+LibMsg <cannot exit when not within anything>+);
       2: id = (+LibMsg <cannot exit closed containers>+);
       3: id = (+LibMsg <report player exiting>+);
       4: id = (+LibMsg <cannot exit thing not within>+);
       5: id = (+LibMsg <report npc exiting container>+);
       6: id = (+LibMsg <report npc exiting supporter>+);
       default: jump not_handled; }
    jump handled;

GetOff:
    id = (+LibMsg <cannot get off things>+);
    jump handled;
-)

[*** Go ***]

Include (-
Go:
    switch (lm_n) {
       1: id = (+LibMsg <cannot travel in something not a vehicle>+);
       2: id = (+LibMsg <cannot go that way>+);
          (+main object+) = noun;   ! the direction
       3: id = (+LibMsg <cannot go up through closed doors>+);
       4: id = (+LibMsg <cannot go down through closed doors>+);
       5: id = (+LibMsg <cannot go through closed doors>+);
       6: id = (+LibMsg <nothing through door>+);
       7: id = (+LibMsg <block vaguely going>+);
       8: id = (+LibMsg <say npc goes>+);
          (+main object+) = (+ up +);
       9: id = (+LibMsg <say npc goes>+);
          (+main object+) = (+ down +);
       10: id = (+LibMsg <say npc goes>+);
       11: id = (+LibMsg <say npc arrives>+);
          (+main object+) = (+ up +);
       12:  id = (+LibMsg <say npc arrives>+);
          (+main object+) = (+ down +);
       13:  id = (+LibMsg <say npc arrives>+);
       14: id = (+LibMsg <say npc arrives from unknown direction>+);
       15: id = (+LibMsg <say npc arrives at>+);
          (+secondary object+) = (+ up +);
       16: id = (+LibMsg <say npc arrives at>+);
          (+secondary object+) = (+ down +);
       17: id = (+LibMsg <say npc arrives at>+);
          ! secondary object already defined
       18: id = (+LibMsg <say npc goes through>+);
       19: id = (+LibMsg <say npc arrives from>+);
       20,21: id = (+LibMsg <say npc vehicle>+);
       22: id = (+LibMsg <say npc pushing in front with player>+);
       23: id = (+LibMsg <say npc pushing in front>+);
       24: id = (+LibMsg <say npc pushing away>+);
       25: id = (+LibMsg <say npc pushing in>+);
       26: id = (+LibMsg <say npc taking player along>+);
       default: jump not_handled; }
    if (lm_n >= 8) { after_text = ""; }   ! sentence fragment
    jump handled;
-)

[*** Verbosity Level ***]

Include (-
LMode1:
    id = (+LibMsg <brief look mode>+);
    jump handled;

LMode2:
    id = (+LibMsg <verbose look mode>+);
    jump handled;

LMode3:
    id = (+LibMsg <superbrief look mode>+);
    jump handled;
-)

[*** Look ***]

Include (-
Look:
    after_text = "";
    switch (lm_n) {
       1: id = (+LibMsg <top line what on>+);
       2: id = (+LibMsg <top line what in>+);
       3: id = (+LibMsg <top line what as>+);
       4: id = (+LibMsg <say things on>+);
       5: id = (+LibMsg <say things also within>+);
       6: id = (+LibMsg <say things within>+);
       7: id = (+LibMsg <examine direction>+);
       8: if (lm_o has supporter) id = (+LibMsg <top line what on>+);
          else id = (+LibMsg <top line what in>+);
       9: id = (+LibMsg <report npc looking>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Examine, Search, LookUnder ***]

Include (-
Examine:
    switch (lm_n) {
       1: id = (+LibMsg <examine while dark>+);
       2: id = (+LibMsg <examine undescribed things>+);
       3: id = (+LibMsg <examine devices>+);
       4: id = (+LibMsg <report npc examining>+);
       5: id = (+LibMsg <examine direction>+);
       default: jump not_handled; }
    jump handled;

Search:
    switch (lm_n) {
       1: id = (+LibMsg <search while dark>+);
       2: id = (+LibMsg <nothing found on top of>+);
       3: id = (+LibMsg <say things on>+); ! 3 prints what is on a supporter
       4: id = (+LibMsg <cannot search unless container or supporter>+);
       5: id = (+LibMsg <cannot search closed opaque containers>+);
       6: id = (+LibMsg <nothing found within container>+);
       7: id = (+LibMsg <say things within>+); ! 7 prints the contents of a container
       8: id = (+LibMsg <report npc searching>+);
       default: jump not_handled; }
    jump handled;

LookUnder:
   switch (lm_n) {
       1: id = (+LibMsg <look under while dark>+);
       2: id = (+LibMsg <look under>+);
       3: id = (+LibMsg <report npc looking under>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Open, Close, Lock, Unlock ***]

Include (-
Open:
    switch (lm_n) {
       1: id = (+LibMsg <cannot open unless openable>+);
       2: id = (+LibMsg <cannot open something locked>+);
       3: id = (+LibMsg <cannot open something already open>+);
       4: id = -2; ! reveal any newly visible exterior
       5: id = (+LibMsg <report player opening>+);
       6: id = (+LibMsg <report npc opening>+);
       7: id = (+LibMsg <report unseen npc opening>+);
       default: jump not_handled; }
    jump handled;

Close:
    switch (lm_n) {
       1: id = (+LibMsg <cannot close unless openable>+);
       2: id = (+LibMsg <cannot close something already closed>+);
       3: id = (+LibMsg <report player closing>+);
       4: id = (+LibMsg <report npc closing>+);
       5: id = (+LibMsg <report unseen npc closing>+);
       default: jump not_handled; }
    jump handled;

Lock:
    switch (lm_n) {
       1: id = (+LibMsg <cannot lock without a lock>+);
       2: id = (+LibMsg <cannot lock something already locked>+);
       3: id = (+LibMsg <cannot lock something open>+);
       4: id = (+LibMsg <cannot lock without the correct key>+);
       5: id = (+LibMsg <report player locking>+);
       6: id = (+LibMsg <report npc locking>+);
       default: jump not_handled; }
    jump handled;

Unlock:
    switch (lm_n) {
       1: id = (+LibMsg <cannot unlock without a lock>+);
       2: id = (+LibMsg <cannot unlock something already unlocked>+);
       3: id = (+LibMsg <cannot unlock without the correct key>+);
       4: id = (+LibMsg <report player unlocking>+);
       5: id = (+LibMsg <report npc unlocking>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Switch On / Off ***]

Include (-
SwitchOn:
    switch (lm_n) {
       1: id = (+LibMsg <cannot switch on unless switchable>+);
       2: id = (+LibMsg <cannot switch on something already on>+);
       3: id = (+LibMsg <report player switching on>+);
       4: id = (+LibMsg <report npc switching on>+);
       default: jump not_handled; }
    jump handled;

SwitchOff:
    switch (lm_n) {
       1: id = (+LibMsg <cannot switch off unless switchable>+);
       2: id = (+LibMsg <cannot switch off something already off>+);
       3: id = (+LibMsg <report player switching off>+);
       4: id = (+LibMsg <report npc switching off>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Wear, Disrobe ***]

Include (-
Wear:
    switch (lm_n) {
       1: id = (+LibMsg <cannot wear something not clothing>+);
       2: id = (+LibMsg <cannot wear not holding>+);
       3: id = (+LibMsg <cannot wear something already worn>+);
       4: id = (+LibMsg <report player wearing>+);
       5: id = (+LibMsg <report npc wearing>+);
       default: jump not_handled; }
    jump handled;

Disrobe:
    switch (lm_n) {
       1: id = (+LibMsg <cannot take off something not worn>+);
       2: id = (+LibMsg <report player taking off>+);
       3: id = (+LibMsg <report npc taking off>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Eating, Drinking, Senses ***]

Include (-
Eat:
    switch (lm_n) {
       1: id = (+LibMsg <cannot eat unless edible>+);
       2: id = (+LibMsg <report player eating>+);
       3: id = (+LibMsg <report npc eating>+);
       default: jump not_handled; }
    jump handled;
Drink:
    id = (+LibMsg <block drinking>+);
    jump handled;
Taste:
    id = (+LibMsg <block tasting>+);
    jump handled;
Smell:
    id = (+LibMsg <block smelling>+);
    jump handled;
Listen:
    id = (+LibMsg <block listening>+);
    jump handled;
ListMiscellany:
	after_text = "";
	switch (lm_n) {
	1: id = (+LibMsg <misc brackets providing light>+);
	2: id = (+LibMsg <misc brackets closed>+);
	4: id = (+LibMsg <misc brackets empty>+);
	6: id = (+LibMsg <misc brackets closed and empty>+);
	3: id = (+LibMsg <misc brackets closed and providing light>+);
	5: id = (+LibMsg <misc brackets empty and providing light>+);
	7: id = (+LibMsg <misc brackets closed empty and providing light>+);
	8: id = (+LibMsg <misc brackets providing light and being worn>+);
	9: id = (+LibMsg <misc bracket providing light>+);
	10: id = (+LibMsg <misc bracket being worn>+);
	11: id = (+LibMsg <misc bracket>+);
	12: id = (+LibMsg <misc open>+); after_text = "";
	13: id = (+LibMsg <misc open but empty>+);
	14: id = (+LibMsg <misc closed>+);
	15: id = (+LibMsg <misc closed and locked>+);
	16: id = (+LibMsg <misc and empty>+);
	17: id = (+LibMsg <misc brackets empty>+);
	18: id = (+LibMsg <misc containing>+);
	19: id = (+LibMsg <misc bracket on>+);
	20: id = (+LibMsg <misc comma on top of>+);
	21: id = (+LibMsg <misc bracket in>+);
	22: id = (+LibMsg <misc comma inside>+);
	default: jump not_handled; }
    jump handled;
Touch:
    switch (lm_n) {
       1: id = (+LibMsg <report player touching other people>+);
       2: id = (+LibMsg <report player touching things>+);
       3: id = (+LibMsg <report player touching self>+);
       4: id = (+LibMsg <report npc touching self>+);
	   ! 5 is for touching the player, 6 is for another NPC
       5,6: id = (+LibMsg <report npc touching other people>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Rhetorical Commands ***]

Include (-
Yes:
    id = (+LibMsg <block saying yes>+);
    jump handled;
No:
    id = (+LibMsg <block saying no>+);
    jump handled;
Sorry:
    id = (+LibMsg <block saying sorry>+);
    jump handled;
Strong:
    id = (+LibMsg <block swearing obscenely>+);
    jump handled;
Mild:
    id = (+LibMsg <block swearing mildly>+);
    jump handled;
-)

[*** Body Movement  ***]

Include (-
Climb:
    id = (+LibMsg <block climbing>+);
    jump handled;
Jump:
    id = (+LibMsg <block jumping>+);
    jump handled;
Swing:
    id = (+LibMsg <block swinging>+);
    jump handled;
WaveHands:
    id = (+LibMsg <block waving hands>+);
    jump handled;
-)

[*** Physical Interaction ***]

Include (-
Attack:
    id = (+LibMsg <block attacking>+);
    jump handled;
Burn:
    id = (+LibMsg <block burning>+);
    jump handled;
Cut:
    id = (+LibMsg <block cutting>+);
    jump handled;
Rub:
    id = (+LibMsg <block rubbing>+);
    jump handled;
SetTo:
    id = (+LibMsg <block setting to>+);
    jump handled;
Tie:
    id = (+LibMsg <block tying>+);
    jump handled;

Wave:
    switch (lm_n) {
       1: id = (+LibMsg <cannot wave something not held>+);
       2: id = (+LibMsg <report player waving things>+);
       3: id = (+LibMsg <report npc waving things>+);
       default: jump not_handled; }
    jump handled;

Squeeze:
    switch (lm_n) {
       1: id = (+LibMsg <squeezing people>+);
       2: id = (+LibMsg <report player squeezing>+);
       3: id = (+LibMsg <report npc squeezing>+);
       default: jump not_handled; }
    jump handled;

ThrowAt:
    switch (lm_n) {
       1: id = (+LibMsg <throw at inanimate object>+);
       2: id = (+LibMsg <block throwing at>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Push, Pull, Turn ***]

Include (-
Push:
    switch (lm_n) {
       1: id = (+LibMsg <cannot push something fixed in place>+);
       2: id = (+LibMsg <cannot push scenery>+);
       3: id = (+LibMsg <report player pushing>+);
       4: id = (+LibMsg <cannot push people>+);
     ! 5 does not apply to Push
       6:  id = (+LibMsg <report npc pushing>+);
       default: jump not_handled; }
    jump handled;

PushDir:
    switch (lm_n) {
       1: id = (+LibMsg <block pushing in directions>+);
       2: id = (+LibMsg <not pushed in a direction>+);
       3: id = (+LibMsg <pushed in illegal direction>+);
       default: jump not_handled; }
    jump handled;

Pull:
    switch (lm_n) {
       1: id = (+LibMsg <cannot pull something fixed in place>+);
       2: id = (+LibMsg <cannot pull scenery>+);
       3: id = (+LibMsg <report player pulling>+);
       4: id = (+LibMsg <cannot pull people>+);
       5: id = (+LibMsg <report npc pulling>+);
       default: jump not_handled; }
    jump handled;

Turn:
    switch (lm_n) {
       1: id = (+LibMsg <cannot turn something fixed in place>+);
       2: id = (+LibMsg <cannot turn scenery>+);
       3: id = (+LibMsg <report player turning>+);
       4: id = (+LibMsg <cannot turn people>+);
     ! 5,6 do not apply to Turn
       7: id = (+LibMsg <report npc turning>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Speech / Interpersonal Actions ***]

Include (-
Answer:
    id = (+LibMsg <block answering>+);
    jump handled;
Ask:
    id = (+LibMsg <block asking>+);
    jump handled;
Buy:
    id = (+LibMsg <block buying>+);
    jump handled;
Kiss:
    id = (+LibMsg <block kissing>+);
    jump handled;
Sing:
    id = (+LibMsg <block singing>+);
    jump handled;
Tell:
    switch (lm_n) {
       1: id = (+LibMsg <telling yourself>+);
       2: id = (+LibMsg <block telling>+);
       default: jump not_handled; }
    jump handled;
-)

[*** Mental Actions ***]

Include (-
Think:
    id = (+LibMsg <block thinking>+);
    jump handled;
Consult:
    switch (lm_n) {
       1: id = (+LibMsg <block player consulting>+);
       2: id = (+LibMsg <block npc consulting>+);
    default: jump not_handled; }
    jump handled;
-)

[*** Sleep And Waiting ***]

Include (-
Sleep:
    id = (+LibMsg <block sleeping>+);
    jump handled;
Wait:
    switch (lm_n) {
       1: id = (+LibMsg <report player waiting>+);
       2: id = (+LibMsg <report npc waiting>+);
    default: jump not_handled; }
    jump handled;
Wake:
    id = (+LibMsg <block waking up>+);
    jump handled;
WakeOther:
    id = (+LibMsg <block waking other>+);
    jump handled;
-)

Include (-
default:
.not_handled;
    (+main object+) = nothing;
    rfalse;
.handled;
	if (id == -2)  {
        (+custom_internal_i6 reveal any newly visible exterior rule+)();
    }
    else {
		(+library-message-id+) = id;

        if ( (+before library messages rule+)() == 0)
        {
            (+print library message rule+)();

            if (isImplicitAction)
			{ say__p = 0; }

            if (after_text ~= nothing && (+libmsg-was-empty+) == 0)
			{ print (string) after_text; }

            (+after library messages rule+)();
        }
    }

    (+main object+) = nothing;
    rtrue;
];
-)


Part 5 - Rule handling - unindexed

Section 5.1 - Reporting rules - unindexed

To display (id_ - a library message id):
   display_part_1 for id_;
   follow the after library messages rule;
   display_part_2.

To display (id_ - a library message id) without 'after library messages':
   display_part_1 for id_;
   display_part_2.

To display_part_1 for (id_ - a library message id):
   change curr_subject to the person asked;	[ "actor" in Inform 6 ]
   change main object to the noun;
   set the current object to the main object / "set up";
   change library-message-id to id_;
   abide by the before library messages rule;
   follow the print library message rule.

To display_part_2:
   set_to_nothing main object;
   if libmsg-was-empty is 0 begin;
      if library-message-id is not LibMsg <reveal any newly visible exterior initial text>,
         say "[if there are not multiple objects][/n]";
   end if.

To set_to_nothing (x_ - an object):
   (- {x_} = nothing; -).

Section 5.2 - Internal rules - unindexed


[ the following rule is called from the i6 code ]

This is the custom_internal_i6 reveal any newly visible exterior rule:
   display LibMsg <reveal any newly visible exterior initial text> without 'after library messages';
   if there is no newly visible exterior begin;
       follow the after library messages rule;
       display LibMsg <no newly visible exterior>;
   otherwise;
       say ".[/r]";
       follow the after library messages rule;
       say "[/n]";
   end if.

[ need to test the return value of WriteListFrom(); not sure how to do this in Inform 7 ]

To decide whether there is no newly visible exterior:
   (- WriteListFrom(child(lm_o), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT) == 0 -).

[ Special handling for "go" without a direction ]

The block vaguely going rule is not listed in the for supplying a missing noun rules.

Rule for supplying a missing noun while going:
   display LibMsg <block vaguely going>;
   say " ".		[ if this isn't here, it says "You must supply a noun" ! ]

[
Instead of examining a closed container: 
     	say "Non riesci a capire il contenuto di qualcosa chiusa."
]

Section 5.3 - Locale description - unindexed

[ The following code was supplied by Emily Short ]

The you-can-see-more rule is listed instead of the you-can-also-see rule in the for printing the locale description rules. 

For printing the locale description (this is the you-can-see-more rule): 
	let the domain be the parameter-object; 
	let the mentionable count be 0; 
	repeat with item running through things: 
		now the item is not marked for listing; 
	repeat through the Table of Locale Priorities: 
		[say "[notable-object entry] - [locale description priority entry].";]
		if the locale description priority entry is greater than 0, 
			now the notable-object entry is marked for listing; 
		increase the mentionable count by 1; 
	if the mentionable count is greater than 0: 
		repeat with item running through things: 
			if the item is mentioned: 
				now the item is not marked for listing; 
		begin the listing nondescript items activity; 
		if the number of marked for listing things is 0: 
			abandon the listing nondescript items activity; 
		otherwise: 
			if handling the listing nondescript items activity: 
				if the domain is a room: 
					if the domain is the location, say "Qui "; 
					otherwise say "Qui "; 
				otherwise if the domain is a container: 
					say "Dentro [the domain] "; 
				otherwise: 
					say "Sopra [the domain] "; 
				say "puoi [if the locale paragraph count is greater than 0]anche [end if]vedere "; 
				let the common holder be nothing; 
				let contents form of list be true; 
				repeat with list item running through marked for listing things: 
					if the holder of the list item is not the common holder: 
						if the common holder is nothing, 
							now the common holder is the holder of the list item; 
						otherwise now contents form of list is false; 
					if the list item is mentioned, now the list item is not marked for listing; 
				filter list recursion to unmentioned things; 
				if contents form of list is true and the common holder is not nothing, 
					list the contents of the common holder, as a sentence, including contents, giving brief inventory information, tersely, not listing concealed items, listing marked items only; 
				otherwise say "[a list of marked for listing things including contents]";
				if the domain is the location, say ""; 
				say ".[paragraph break]"; 
				unfilter list recursion; 
			end the listing nondescript items activity; 
	continue the activity.

The use-initial-appearance rule is listed instead of the use initial appearance in room descriptions rule in the for printing a locale paragraph about rules.

For printing a locale paragraph about a thing (called the item) (this is the use-initial-appearance rule):
	if the item is not mentioned:
		if the item provides the property initial appearance and the
			item is not handled:
			increase the locale paragraph count by 1;
			say "[initial appearance of the item]";
			say "[paragraph break]";
			if a locale-supportable thing is on the item:
				repeat with possibility running through things on the item:
					now the possibility is marked for listing;
					if the possibility is mentioned:
						now the possibility is not marked for listing;
				say "Sopra [the item] ";
				list the contents of the item, as a sentence, including contents, giving brief inventory information, tersely, not listing concealed items, prefacing with is/are, listing marked items only;
				say ".[paragraph break]";
			now the item is mentioned;
	continue the activity.

The describe-on-scenery-supporters rule is listed instead of the describe what’s on scenery supporters in room descriptions rule in the for printing a locale paragraph about rules.

For printing a locale paragraph about a thing (called the item) (this is the describe-on-scenery-supporters rule):
	if the item is not undescribed and the item is scenery and the item does not enclose the player:
		set pronouns from the item;
		if a locale-supportable thing is on the item:
			repeat with possibility running through things on the item:
				now the possibility is marked for listing;
				if the possibility is mentioned:
					now the possibility is not marked for listing;
			increase the locale paragraph count by 1;
			say "Sopra [the item] ";
			list the contents of the item, as a sentence, including contents, giving brief inventory information, tersely, not listing concealed items, prefacing with is/are, listing marked items only;
			say ".[paragraph break]";
	continue the activity.

Section 5.5 - Frasi Finali
[Il codice di questa sezione è basato sulle versioni di Sebastian Arg e di Eric Forgeot]

The print the final question rule is not listed in any rulebook.
The Italian print the final question rule is listed in before handling the final question.
This is the Italian print the final question rule:
	let named options count be 0;
	repeat through the Table of Italian Final Question Options:
		if the only if victorious entry is false or the game ended in victory:
			if there is a final response rule entry
				or the final response activity entry [activity] is not empty:
				if there is a final question wording entry, increase named options count by 1;
	if the named options count is less than 1, abide by the immediately quit rule;
	say "Cosa desideri fare: ";
	repeat through the Table of Italian Final Question Options:
		if the only if victorious entry is false or the game ended in victory:
			if there is a final response rule entry
				or the final response activity entry [activity] is not empty:
				if there is a final question wording entry:
					say final question wording entry;
					decrease named options count by 1;
					if the named options count is 0:
						say "?[line break]";
					otherwise if the named options count is 1:
						if using the serial comma option, say ",";
						say " o ";
					otherwise:
						say ", ".

The standard respond to final question rule is not listed in any rulebook.
The Italian standard respond to final question rule is listed last in for handling the final question.
This is the Italian standard respond to final question rule:
	repeat through the Table of Italian Final Question Options:
		if the only if victorious entry is false or the game ended in victory:
			if there is a final response rule entry
				or the final response activity entry [activity] is not empty:
				if the player's command matches the topic entry:
					if there is a final response rule entry, abide by final response rule entry;
					otherwise carry out the final response activity entry activity;
					rule succeeds;
	issue miscellaneous library message number 8.

Table of Italian Final Question Options
final question wording	only if victorious	topic		final response rule		final response activity
"RICOMINCIARE"				false				"ricominciare"	immediately restart the VM rule	--
"CARICARE una partita salvata"	false				"caricare"	immediately restore saved game rule	--
"scoprire le sorprese del gioco (SORPRESE)"	true	"sorprese"	--	amusing a victorious player
"USCIRE"					false				"uscire"		immediately quit rule	--
--						false				"annulla"		immediately undo rule	--


The describe what's on scenery supporters in room descriptions rule is not listed in any rulebook.

For printing a locale paragraph about a thing (called the item)(this is the describe-what's-on-scenery-supporters-in-room-descriptions rule):
	if the item is not undescribed and the item is scenery and the item does not enclose the player:
		set pronouns from the item;
		if a locale-supportable thing is on the item:
			repeat with possibility running through things on the item:
				now the possibility is marked for listing;
				if the possibility is mentioned:
					now the possibility is not marked for listing;
			increase the locale paragraph count by 1;
			say "Sopra [the item] " ;
			list the contents of the item, as a sentence, including contents,
				giving brief inventory information, tersely, not listing
				concealed items, prefacing with is/are, listing marked items only;
			say ".[paragraph break]";
	continue the activity.


Section 5.6 - Dettagli della list-miscellany

[ Definition : something is empty if it carries nothing or it contains nothing. ]


Section 5.6a - Gli articoli e i generi

Include (-
Constant LanguageAnimateGender   = male;
Constant LanguageInanimateGender = male;

Constant LanguageContractionForms = 3;   

! ---------------------------------------------------------------------
! Qualche regola per gli articoli e una precisazione.
! ---------------------------------------------------------------------
! Ci sono tre casi che dipendono dalla lettera iniziale di una parola:
! 1. Parola che comincia con vocale
! 2. Parola che comincia con z oppure s + consonante (oppure ps, pn,
!    gn, x)
! 3. Parola che comincia con altra consonante.
!
! N.B. Le parole che cominciano con ps, pn, gn e x (molto poche)
!      dovrebbero seguire la regola 2 (secondo la grammatica
!      italiana). Nell'uso reale della lingua si tende a seguire
!      la regola 3. Questa libreria segue la regola grammaticale. Se
!      vuoi cambiarla, per accordarla all'uso reale basta
!      semplicemente specificare l'articolo nella
!      definizione dell'oggetto (has article ""). Per esempio:
!      	    da:  "lo pneumatico, uno pneumatico" (default)
!            a:  "il pneumatico, un pneumatico"  (has article "il")
! *** In questa versione ho tolto 'pn' ***
! --------------------------------------------------------------------- 

[ LanguageContraction text;

	if (text->0 == 'a' or 'e' or 'i' or 'o' or 'u'
		or 'A' or 'E' or 'I' or 'O' or 'U') return 0;
	if (text->0 == 'z' or 'Z' or 'x' or 'X') return 1;
	if (text->0 == 's' or 'S')
		if (text->1 == 'a' or 'e' or 'i' or 'o' or 'u' 
			or 'A' or 'E' or 'I' or 'O' or 'U') return 2;
		else return 1;
	if (text->0 == 'p' or 'P')
		if (text->1 == 's') return 1;
	if (text->0 == 'g' or 'G')
    		if (text->1 == 'n') return 1;
	return 2;
];

Array LanguageArticles -->
!  Contraction form 0:    Contraction form 1:     Contraction form 2:
!  Cdef   Def    Indef    Cdef   Def    Indef     Cdef   Def    Indef
   "L'"   "l'"  "un "     "Lo "  "lo "   "uno "    "Il "  "il "  "un "  
   "L'"   "l'"  "un'"     "La "  "la "   "una "    "La "  "la "  "una "
   "Gli " "gli " "degli " "Gli " "gli "  "degli "  "I "   "i "   "dei "  
   "Le "  "le " "delle "  "Le "  "le "   "delle "  "Le "  "le "  "delle ";
                   !             a           i
                   !             s     p     s     p
                   !             m f n m f n m f n m f n               

Array LanguageGNAsToArticles --> 0 1 0 2 3 0 0 1 0 2 3 0;

-) instead of "Articles" in "Language.i6t".


Section 5.7 - Evitiamo sovrapposizioni con il comando oops

Include (-
Constant AGAIN1__WD     = 'ancora';
Constant AGAIN2__WD     = 'an//';
Constant AGAIN3__WD     = 'ancora';
Constant OOPS1__WD      = 'oops';
Constant OOPS2__WD      = 'oo//';
Constant OOPS3__WD      = 'oops';
Constant UNDO1__WD      = 'annulla';
Constant UNDO2__WD      = 'annulla';
Constant UNDO3__WD      = 'annulla';

Constant ALL1__WD       = 'ogni';
Constant ALL2__WD       = 'ognuno';
Constant ALL3__WD       = 'ognuna';
Constant ALL4__WD       = 'qualsiasi';
Constant ALL5__WD       = 'entrambi';
Constant AND1__WD       = 'e';
Constant AND2__WD       = 'e';
Constant AND3__WD      = 'e';
Constant BUT1__WD       = 'ma';
Constant BUT2__WD       = 'eccetto';
Constant BUT3__WD       = 'ma';
Constant ME1__WD        = 'me';
Constant ME2__WD        = 'me stesso';
Constant ME3__WD        = 'stesso';
Constant OF1__WD        = 'di';
Constant OF2__WD        = 'di';
Constant OF3__WD        = 'di';
Constant OF4__WD        = 'di';
Constant OTHER1__WD     = 'altri';
Constant OTHER2__WD     = 'altro';
Constant OTHER3__WD     = 'altra';
Constant THEN1__WD      = 'allora';
Constant THEN2__WD      = 'allora';
Constant THEN3__WD      = 'allora';

Constant NO1__WD        = 'n//';
Constant NO2__WD        = 'no';
Constant NO3__WD        = 'no';
Constant YES1__WD       = 's//';
Constant YES2__WD       = 'sì';
Constant YES3__WD       = 'sì';

Constant AMUSING__WD    = 'amusing';
Constant FULLSCORE1__WD = 'fullscore';
Constant FULLSCORE2__WD = 'full';
Constant QUIT1__WD      = 'q//';
Constant QUIT2__WD      = 'quit';
Constant RESTART__WD    = 'restart';
Constant RESTORE__WD    = 'restore';
-) instead of "Vocabulary" in "Language.i6t".

Section 5.8 - Altre sostituzioni utili

Include (-
Constant NKEY__TX       = "N = prossimo_argomento";
Constant PKEY__TX       = "P = precedente";
Constant QKEY1__TX      = "Q = ritorna al gioco";
Constant QKEY2__TX      = "Q = menu precedente";
Constant RKEY__TX       = "RETURN = leggi argomento";

Constant NKEY1__KY      = 'N';
Constant NKEY2__KY      = 'n';
Constant PKEY1__KY      = 'P';
Constant PKEY2__KY      = 'p';
Constant QKEY1__KY      = 'Q';
Constant QKEY2__KY      = 'q';

Constant SCORE__TX      = "Punteggio: ";
Constant MOVES__TX      = "Mosse: ";
Constant TIME__TX       = "Ora: ";
Global CANTGO__TX     = "Non puoi andare da quella parte.";
Global FORMER__TX     = "te stesso";
Global YOURSELF__TX   = "te stesso";
Constant YOU__TX        = "Tu";
Constant DARKNESS__TX   = "Buio";

Constant THOSET__TX     = "quelle cose";
Constant THAT__TX       = "quello";
Constant OR__TX         = " o ";
Constant NOTHING__TX    = "niente";
Global IS__TX         = " è";
Global ARE__TX        = " sono";
Global IS2__TX        = "c'è ";
Global ARE2__TX       = "ci sono ";
Global IS3__TX        = "c'è";
Global ARE3__TX       = "ci sono";
Constant AND__TX        = " e ";
#ifdef I7_SERIAL_COMMA;
Constant LISTAND__TX   = ", e ";
Constant LISTAND2__TX  = " e ";
#ifnot;
Constant LISTAND__TX   = " e ";
Constant LISTAND2__TX  = " e ";
#endif; ! I7_SERIAL_COMMA
Constant WHOM__TX       = "quale ";
Constant WHICH__TX      = "cui ";
Constant COMMA__TX      = ", ";
-) instead of "Short Texts" in "Language.i6t".


Section Finale - Traduzione dei Verbi

Rule for printing a parser error when parser error is noun did not make sense in that context: 
    say "La parola non ha senso in questo contesto." 

[articoli e preposizioni articolate]
Understand "il/lo/la/i/gli/le/l" as "[art-det]".
Understand "da/dal/dallo/dalla/dai/dagli/dalle/dall" as "[da-art]".
Understand "su/sul/sullo/sulla/sui/sugli/sulle/sull" as "[su-art]".
Understand "in/nel/nello/nella/nei/negli/nelle/nell" as "[in-art]".
Understand "a/al/allo/alla/ai/agli/alle/all" as "[a-art]".
Understand "di/del/dello/della/dei/degli/delle/dell" as "[di-art]".
Understand "con/col/coi/cogli/coll" as "[con-art]".

[Actions concerning the actor's possessions]
Understand "inventario" as taking inventory.
Understand "prendi [things]" or "prendi [art-det] [something]" as taking.
Understand "rimuovi [things] [da-art] [something]" or "rimuovi [art-det] [something] [da-art] [something]" as removing it from.
Understand "prendi [things] [da-art] [something]" or "prendi [art-det] [something] [da-art] [something]" as removing it from.
Understand "togli [things] [da-art] [something]" or "togli [art-det] [something] [da-art] [something]" as removing it from.
Understand "scarica [things] [da-art] [something]" or "scarica [art-det] [something] [da-art] [something]" as removing it from.
Understand "lascia [things]" or "lascia [art-det] [something]" as dropping.
Understand "lascia [things preferably held] [su-art] [something]" or "lascia [art-det] [something preferably held] [su-art] [something]" as putting it on.
Understand "poggia [things preferably held] [su-art] [something]" or "poggia [art-det] [something preferably held] [su-art] [something]" as putting it on.
Understand "appoggia [things preferably held] [su-art] [something]" or "appoggia [art-det] [something preferably held] [su-art] [something]" as putting it on.
Understand "metti [things preferably held] [su-art] [something]" or "metti [art-det] [things preferably held] [su-art] [something]" as putting it on.
Understand "carica [things preferably held] [su-art] [something]" or "carica [art-det] [something preferably held] [su-art] [something]" as putting it on.
Understand "inserisci [things preferably held] [in-art] [something]" or "inserisci [art-det] [something preferably held] [in-art] [something]" as inserting it into.
Understand "metti [things preferably held] [in-art] [something]" or "metti [art-det] [something preferably held] [in-art] [something]" as inserting it into.
Understand "mangia [things preferably held]" or "mangia [art-det] [something]" as eating.
[Actions which move the actor]
Understand "vai [direction]" or "vai [a-art] [direction]" as going.
Understand "entra [something]" or "entra [in-art] [something]" as entering.
Understand "sali [something]" or "sali [su-art] [something]" as entering.
Understand "salta [something]" or "salta [su-art] [something]" as entering.
Understand "siedi [something]" or "siedi [su-art] [something]" as entering.
Understand "giaci [something]" or "giaci [su-art] [something]" as entering.
Understand "sdraiati [something]" or "sdraiati [su-art] [something]" as entering.
Understand "esci" or "scendi" as exiting.
Understand "esci [something]" or "esci [da-art] [something]" as getting off.
Understand "scendi [something]" or "scendi [da-art] [something]" as getting off.
Understand "alzati [something]" or "alzati [da-art] [something]" as getting off.
[Actions concerning the actor's vision]
Understand "guarda" or "g" as looking.
Understand "guarda [things]" or "guarda [art-det] [something]" as examining.
Understand "esamina [things]" or "esamina [art-det] [something]" as examining.
Understand "leggi [things]" or "leggi [art-det] [something]" as examining.
Understand "guarda sotto [things]" or "guarda sotto [art-det] [something]" or "guarda sotto [a-art] [something]" as looking under.
Understand "guarda [in-art] [things]" or "guarda dentro [a-art] [something]" as searching.
Understand "guarda [su-art] [things]" or "guarda sopra [a-art] [something]" as searching.
Understand "cerca [in-art] [things]" or "cerca dentro [a-art] [something]" as searching.
Understand "cerca [su-art] [things]" or "cerca sopra [art-det] [something]" as searching.
Understand "consulta [things] [su-art] [text]" or "consulta [art-det] [something] [su-art] [text]" as consulting it about.
Understand "cerca [in-art] [things] [di-art] [text]" as consulting it about.
Understand "leggi [in-art] [things] [di-art] [text]" as consulting it about.
[Actions which change the state of things]
Understand "chiudi [things] [con-art] [something]" or "chiudi [art-det] [something] [con-art] [something]" or "chiudi [art-det] [something] con [art-det] [something]" as locking it with.
Understand "blocca [things] [con-art] [something]" or "blocca [art-det] [something] [con-art] [something]" or "blocca [art-det] [something] con [art-det] [something]" as locking it with.
Understand "apri [things] [con-art] [something]" or "apri [art-det] [something] [con-art] [something]" or "apri [art-det] [something] con [art-det] [something]" as unlocking it with.
Understand "sblocca [things] [con-art] [something]" or "sblocca [art-det] [something] [con-art] [something]" or "sblocca [art-det] [something] con [art-det] [something]" as unlocking it with.
Understand "accendi [things]" or "accendi [art-det] [something]" as switching on.
Understand "spegni [things]" or "spegni [art-det] [something]" as switching off.
Understand "apri [things]" or "apri [art-det] [something]" as opening.
Understand "chiudi [things]" or "chiudi [art-det] [something]" as closing.
Understand "indossa [things]" or "indossa [art-det] [something]" as wearing.
Understand "metti [things]" or "metti [art-det] [something]" as wearing.
Understand "togli [things]" or "togli [art-det] [something]" as taking off.
[Actions concerning other people]
Understand "dai [things preferably held] [a-art] [someone]" or  "dai [art-det] [something preferably held] [a-art] [someone]" as giving it to.
Understand "mostra [things preferably held] a [someone]" or "mostra [art-det] [something preferably held] [a-art] [someone]" as showing it to.
Understand "sveglia [someone]" or "sveglia [art-det] [someone]" as waking.
Understand "getta [things preferably held] [a-art] [something]" or "getta [art-det] [something preferably held] [a-art] [something]" as throwing it at.
Understand "lancia [things preferably held] [a-art] [something]" or "lancia [art-det] [something preferably held] [a-art] [something]" as throwing it at.
Understand "attacca [something]" or "attacca [art-det] [something]" as attacking.
Understand "bacia [something]" or "bacia [art-det] [something]" as kissing.
[Talking to is an action applying to one visible thing.  Understand "parla [something]" or "parla [a-art] [something]" as talking to.]
Understand "rispondi [someone] [text]" or "rispondi [a-art] [someone] [text]" as answering it that.
Understand "parla [someone] [di-art] [text]" or "parla [a-art] [someone] [di-art] [text]" or "parla [con-art] [someone] [di-art] [text]" as telling it about.
Understand "chiedi [someone] [di-art] [text]" as asking it about.
Understand "chiedi [a-art] [someone] [di-art] [text]" as asking it about.
Understand "chiedi [a-art] [someone] [something]" or "chiedi [a-art] [someone] [art-det] [something]" as asking it for.
[Actions which are checked but then do nothing unless rules intervene]
Understand "aspetta" as waiting.
Understand "tocca [things]" or "tocca [art-det] [something]" as touching.
Understand "agita [things]" or "agita [art-det] [something]" as waving.
Understand "tira [things]" or "tira [art-det] [something]" as pulling.
Understand "spingi [things]" or "spingi [art-det] [something]" as pushing.
Understand "gira [things]" or "gira [art-det] [something]" as turning.
Understand "spingi [things] [a-art] [direction]" or "spingi [art-det] [something] [a-art] [direction]" as pushing it to.
Understand "spremi [things]" or "spremi [art-det] [something]" as squeezing.
Understand "stringi [things]" or "stringi [art-det] [something]" as squeezing.
[Actions which always do nothing unless rules intervene]
Understand "si" or "sì" as saying yes.
Understand "brucia [things]" or "brucia [art-det] [something]" as burning.
Understand "sveglia" or "svegliati" as waking up.
Understand "pensa" or "medita" as thinking.
Understand "odora" or "odora [things]" or "odora [art-det] [something]" as smelling.
Understand "annusa" or "annusa [things]" or "annusa [art-det] [something]" as smelling.
Understand "ascolta" or "ascolta [things]" or "ascolta [art-det] [something]" as listening to.
Understand "gusta [things]" or "gusta [art-det] [something]" as tasting.
Understand "assaggia [things]" or "assaggia [art-det] [something]" as tasting.
Understand "taglia [things]" or "taglia [art-det] [something]" as cutting.
Understand "salta" as jumping.
Understand "lega [things] [a-art] [something]" or "lega [art-det] [something] [a-art] [something]" as tying it to.
Understand "bevi [things]" or "bevi [art-det] [something]" as drinking.
Understand "scusa" or "scusati" as saying sorry.
Understand "colpisci [things]" or "colpisci [art-det] [something]" as swinging.
Understand "oscilla [things]" or "oscilla [su-art] [something]" as swinging.
Understand "calcia [things]" or "calcia [art-det] [something]" as swinging.
Understand "strofina [things]" or "strofina [art-det] [something]" as rubbing.
Understand "imposta [things] [a-art] [text]" or "imposta [art-det] [something] [a-art] [text]" as setting it to.
Understand "regola [things] [a-art] [text]" or "regola [art-det] [something] [a-art] [text]" as setting it to.
Understand "agita le mani" as waving hands.
Understand "compra [things]" or "compra [art-det] [something]" as buying.
Understand "canta" as singing.
Understand "scala [things]" or "scala [art-det] [something]" as climbing.
Understand "dormi" as sleeping.
[Actions which happen out of world]
Understand "punti" or "punteggio" as requesting the score.
Understand "interrompi" or "smetti" as quitting the game.
Understand "ricomincia" as restarting the game.
Understand "carica" as restoring the game.
Understand "salva" as saving the game.

[directions]
Understand "o" as west.
Understand "ovest" as west.
Understand "sud" as south.
Understand "est" as east.
Understand "nord" as north.
Understand "nordovest" as northwest.
Understand "sudovest" as southwest.
Understand "sudest" as southeast.
Understand "nordest" as northeast.
Understand "su" as up.
Understand "giù" as down.
Understand "giu" as down.

Italian ends here.

---- DOCUMENTATION ----

Italian è una estensione adibita alla traduzione del parser inglese in lingua italiana.
La versione attuale è la 1.

Vedi Italian di Massimo Stella per la documentazione originale.
