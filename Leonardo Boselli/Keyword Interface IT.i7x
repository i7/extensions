Keyword Interface IT by Leonardo Boselli begins here.

"This extension emulates Blue Lacuna's emphasized keyword system for simplifying common IF input. Nouns, directions, and topics can be typed without a verb to examine, go, or discuss. Works with Glulx or z-code. Modifiche: tradotto in italiano; aggiunti scenari, modificata lista uscite."

"basato su Keyword Interface by Aaron Reed"

Include Basic Screen Effects by Emily Short.

Keywords required is a truth state that varies. Keywords required is false.

Chapter - Things

Section - Definitions

Object keyword highlighting is a truth state that varies. Object keyword highlighting is true. [Global activation of object keywords.]

Understand "[a thing]" as examining.

Every thing has a text called the keyword. The keyword of a thing is usually "". [which word of a multi-word noun should be highlighted. In practice, the player can type any word with the same effect, but for presentation purposes it's best to have a single word highlighted.]

A thing is either keyworded or keywordless. A thing is usually keyworded. [Keywordless things are not automatically highlighed in room descriptions.]

Object keywording something is an activity.

Rule for printing the name of a thing (called item) while looking (this is the Keyword Interface highlight objects when looking rule):
	carry out the object keywording activity with item.

Rule for printing the name of a thing (called item) while taking inventory (this is the Keyword Interface highlight objects when taking inventory rule):
	carry out the object keywording activity with item.

Section - Rule for object keywording something

Rule for object keywording something (called item) (this is the Keyword Interface object keywording rule):
	if object keyword highlighting is false or item is keywordless:
		say the printed name of item;
		continue the action;
	let output be indexed text;
	now output is the printed name of item;
	let kw be indexed text;
	now kw is the keyword of item;
	if kw is "", change kw to word number ( the number of words in output ) in output;
	repeat with wordcounter running from 1 to the number of words in output:
		say "[if wordcounter > 1] [end if]";
		if word number wordcounter in output matches the regular expression "\b(?i)[kw]":
			if the item is scenery:
				say "[s][word number wordcounter in output][x]";
			otherwise:
				say "[o][word number wordcounter in output][x]";
		else:
			say "[word number wordcounter in output]".


Chapter - Exits

Section - Definitions

Direction keyword highlighting is a truth state that varies. Direction keyword highlighting is true.

Understand "[a direction]" as going. Understand "[an open door]" as entering.

Direction keywording something is an activity.

Every direction has a text called printed name. The printed name of a direction is usually "quella via". The printed name of north is "nord". The printed name of northeast is "nordest". The printed name of east is "est". The printed name of southeast is "sudest". The printed name of south is "sud". The printed name of southwest is "sudovest". The printed name of west is "ovest". The printed name of northwest is "nordovest". The printed name of up is "su". The printed name of down is "giù". The printed name of inside is "dentro". The printed name of outside is "fuori".

The saved direction is a direction that varies.

Rule for printing the name of a direction (called dir) while looking (this is the Keyword Interface highlight directions while looking rule):
	now the saved direction is dir;
	carry out the direction keywording activity.

Rule for printing the name of a direction (called dir) while exits listing (this is the Keyword Interface highlight directions while exits listing rule):
	now the saved direction is dir;
	carry out the direction keywording activity.

Section - Rule for direction keywording something

Rule for direction keywording (this is the Keyword Interface direction keywording rule):
	if direction keyword highlighting is false:
		say the printed name of the saved direction;
		continue the action;
	say "[d][the printed name of the saved direction][x]".



Chapter - Topics

Topic keyword highlighting is a truth state that varies. Topic keyword highlighting is false.

Topic keywording something is an activity.



Chapter - Parser

Parser highlighting is a truth state that varies. Parser highlighting is false.

To say as the parser:
	now we-are-parser-speaking is true;
	set the text style for the style of parser-word.
	 
To say as normal:
	now we-are-parser-speaking is false; 
	reset styles with the style of parser-word.

Before printing a parser error when parser highlighting is true (this is the Keyword Interface before printing a parser error rule):
	say "[as the parser]".

After printing a parser error when parser highlighting is true (this is the Keyword Interface after printing a parser error rule):
	say "[as normal]". 


Chapter - Keyword Types

A keyword type is a kind of thing. object-word is a keyword type. direction-word is a keyword type. topic-word is a keyword type. parser-word is a keyword type.
scenery-word is a keyword type.

A keyword emphasis is a kind of value. The plural of keyword emphasis is keyword emphases. 

A keyword type has a keyword emphasis called style. 

The active style is a keyword emphasis that varies. 

we-are-parser-speaking is a truth state that varies. we-are-parser-speaking is false.  [It's possible to have, say, an emphasized object keyword within a parser error message; this variable keeps track of whether we need to return to the parser style after switching off another keyword style.]
	
To say o:
	if object keyword highlighting is true:
		set the text style for the style of object-word; 
		now the active style is the style of object-word.

To say s:
	if object keyword highlighting is true:
		set the text style for the style of scenery-word; 
		now the active style is the style of scenery-word.
	
To say t:
	if topic keyword highlighting is true:
		set the text style for the style of topic-word; 
		now the active style is the style of topic-word.  	      
 
To say d: 
	if direction keyword highlighting is true:
		set the text style for the style of direction-word;
		now the active style is the style of direction-word.  	  
	 
To say x:
	reset styles with active style;
	         
Section - Glulx Style Definitions (for Glulx only)

Include Glulx Text Effects by Emily Short. 

The keyword emphases are keyword-color1-style, keyword-color2-style, keyword-bold-style, keyword-italics-style, keyword-fixedwidth-style, and keyword-no-style.

The style of object-word is keyword-color1-style. The style of direction-word is keyword-color2-style. The style of topic-word is keyword-bold-style. The style of parser-word is keyword-italics-style.
The style of scenery-word is keyword-italics-style.

Table of User Styles (continued)
style name	fixed width	boldness	relative size	glulx color
special-style-1	proportional-font	bold-weight	0	g-color1
special-style-2	proportional-font	bold-weight	0	g-color2
 
Table of Common Color Values (continued)
glulx color value	assigned number   
g-color1	255	[blue]
g-color2	3381555	[green]

To set the text style for (val - a keyword emphasis):
	if val is keyword-color1-style:
		say first custom style;
	else if val is keyword-color2-style:
		say second custom style;
	else if val is keyword-bold-style:
		say bold type;
	else if val is keyword-italics-style:
		say italic type;
	else if val is keyword-fixedwidth-style:
		say fixed letter spacing;
	else if val is keyword-no-style:
		do nothing.

To reset styles with (val - a keyword emphasis):
	if val is keyword-fixedwidth-style:
		say variable letter spacing;
	else:
		say roman type;
	if we-are-parser-speaking is true, say as the parser. 

Section - Z-Machine Style Definitions (for Z-machine only)

The keyword emphases are keyword-red, keyword-green, keyword-yellow, keyword-blue, keyword-magenta, keyword-cyan, keyword-white, keyword-bold-style, keyword-italics-style, keyword-fixedwidth-style, and keyword-no-style.

The style of object-word is keyword-blue. The style of direction-word is keyword-magenta. The style of topic-word is keyword-red. [These are really the only three z-code colors that are readable on a white background.] The style of parser-word is keyword-italics-style.
The style of scenery-word is keyword-italics-style.

To set the text style for (val - a keyword emphasis):
	if val is keyword-red:
		say red letters;
		say bold type;
	else if val is keyword-green:
		say green letters;
		say bold type;
	else if val is keyword-yellow:
		say yellow letters;
		say bold type;
	else if val is keyword-blue:
		say blue letters;
		say bold type;
	else if val is keyword-magenta:
		say magenta letters;
		say bold type;
	else if val is keyword-cyan:
		say cyan letters;
		say bold type;
	else if val is keyword-white:
		say white letters;
		say bold type;
	else if val is keyword-bold-style:
		say black letters;
		say bold type;
	else if val is keyword-italics-style:
		say italic type;
	else if val is keyword-fixedwidth-style:
		say fixed letter spacing;
	else if val is keyword-no-style:
		do nothing.

To reset styles with (val - a keyword emphasis):
	if val is keyword-fixedwidth-style:
		say variable letter spacing;
	else:
		say roman type;
		say default letters;
	if we-are-parser-speaking is true, say as the parser. 




Chapter - Changing Style


Setting the keyword emphasis is an action out of world applying to nothing. Understand "parole" or "parole chiave" or "keyword" or "keywords" as setting the keyword emphasis. 
 
tempstyles is a list of keyword emphases that varies.

Carry out setting the keyword emphasis (this is the Keyword Interface carry out setting keyword emphasis rule): 
	run the keywords routine.

To run the keywords routine:
	let mychar be 1;   
	while mychar is not 0:
		clear the screen;  
		let num be 0; 
		show KI message for keyword-setting-instructions;
		say line break;
		if object keyword highlighting is true:
			increase num by 1;
			say "[num]) ";
			let object-number be num;
			show KI message for keyword-instructions-object;
		if object keyword highlighting is true:
			increase num by 1;
			say "[num]) ";
			let scenery-number be num;
			show KI message for keyword-instructions-scenery;
		if direction keyword highlighting is true:
			increase num by 1;
			say "[num]) ";
			let direction-number be num;
			show KI message for keyword-instructions-direction;
		if topic keyword highlighting is true:
			increase num by 1;
			say "[num]) ";
			let topic-number be num;
			show KI message for keyword-instructions-topic;
		if parser highlighting is true:
			[say line break;]
			increase num by 1;
			say "[num]) ";
			let parser-number be num;
			show KI message for keyword-instructions-parser;
		[Print a warning if emphasis is disabled in a game where keywords are required; note that the player is still allowed to do so, however.]
		if keywords required is true:
			if ( object keyword highlighting is true and style of object-word is keyword-no-style ) or ( object keyword highlighting is true and style of scenery-word is keyword-no-style ) or ( direction keyword highlighting is true and  style of direction-word is keyword-no-style ) or ( topic keyword highlighting is true and style of topic-word is keyword-no-style ) :
				say line break;
				show KI message for keyword-instructions-disabled;
		[Print a warning if any two active keyword styles are the same.]
		truncate tempstyles to 0 entries;
		let dupe be false;
		if object keyword highlighting is true:
			add style of object-word to tempstyles;
			add style of scenery-word to tempstyles;
		if direction keyword highlighting is true:
			if style of direction-word is listed in tempstyles:
				now dupe is true;
			else:
				add style of direction-word to tempstyles;
		if topic keyword highlighting is true:
			if style of topic-word is listed in tempstyles:
				now dupe is true;
		if dupe is true:
			say line break;
			show KI message for keyword-instructions-distinct;
		say line break;
		show KI message for keyword-instructions-end;
		now mychar is single-character - 48; [Converts ASCII to actual number typed.]
		if mychar is object-number:
			advance style with object-word;
		otherwise if mychar is scenery-number:
			advance style with scenery-word;
		otherwise if mychar is direction-number:
			advance style with direction-word;
		otherwise if mychar is topic-number:
			advance style with topic-word;
		otherwise if mychar is parser-number:
			advance style with parser-word;
		otherwise if mychar is 9:
			clear the screen;
			try setting screen reader mode; 
			say "Premi un tasto per continuare.";
			wait for any key;
			now mychar is 0;
	clear the screen;
	if pre-game keyword setting is true:
		now pre-game keyword setting is false;
		do nothing;
	otherwise:
		try looking. 
	  
To advance style with (kwtype - a keyword type):
	now the style of kwtype is the keyword emphasis after the style of kwtype.

To decide which number is single-character: (- (VM_KeyChar()) -).

Chapter - Screen Reader Mode

Screen reader mode is a truth state that varies. 

Setting screen reader mode is an action out of world. Understand "lettura schermo" or "screenreader" or "screen reader" as setting screen reader mode.
	
Carry out setting screen reader mode (this is the Keyword Interface carry out setting screen reader mode rule):
	if screen reader mode is true:
		now screen reader mode is false;
		show KI message for screen-reader-deactivated;
	else:
		now screen reader mode is true; 
		show KI message for screen-reader-activated.

Section - Exits

[This routine is lifted straight from the example in the Inform 7 docs.]

Understand "uscite" or "exits" as exits listing. Exits listing is an action out of world applying to nothing.

Definition: a direction (called thataway) is viable if the room thataway from the location is a room.

[*** LEO *** Per eliminare THE nella lista di 'viable directions']
Carry out exits listing (this is the Keyword Interface carry out exits listing rule):
	let count of exits be the number of viable directions; 
	if the count of exits is 0:
		say "Sembra che tu sia intrappolato qui." instead;
	if the count of exits is 1:
		say "Da qui, l[']unica via d[']uscita è [entry 1 of the list of viable directions].";
	otherwise:
		say "Da qui, le uniche vie d[']uscita sono [entry 1 of the list of viable directions]";
		repeat with ct running from 2 to count of exits minus 1:
			say ", [entry ct of the list of viable directions]";
		say " e [entry count of exits of the list of viable directions]."

Section - Things

Understand "oggetti" or "things" as thing listing. Thing listing is an action out of world applying to nothing.

Carry out thing listing (this is the Keyword Interface carry out thing listing rule):
	say "Intorno [is-are the list of visible other things].".

[*** LEO *** per evitare che siano elencate le parti]
Definition: a thing is other if it is not the player and it is not part of something.

Rule for printing the name of a thing (called item) while thing listing:
	carry out the object keywording activity with item.


Chapter - Beginning Play
	 
Section - Keyword Interface setup rule

pre-game keyword setting is a truth state that varies. pre-game keyword setting is true.

When play begins (this is the Keyword Interface setup trigger rule):
	if keywords required is false:
		continue the action;
	clear the screen;
	let mychar be 1; 
	show KI message for welcome-message;
	while mychar is not 0:
		now mychar is single-character; 
		if mychar is 82 or mychar is 114: [ r or R: restore ]
			restore the game;  
		if mychar is 75 or mychar is 107: [ k or K: keyword ]
			run the keywords routine;
			now mychar is 0;
		if mychar is 78 or mychar is 110: [ n or N: new game ]
			now mychar is 0;
	clear the screen;
	say "[line break][line break][line break]";
	now pre-game keyword setting is false.    
 
To restore the game: (- RESTORE_THE_GAME_R(); -).


Chapter - Error Reporting

Section - Not a verb I recognise

Rule for printing a parser error when parser error is not a verb I recognise (this is the Keyword Interface not a verb I recognise rule) : show KI message for not-a-verb-I-recognise. [Acknowledge that the player may be trying to type a keyword, not just a verb.]


Chapter - Messages

A KI message is a kind of value. Some KI messages are defined by the Table of Keyword Interface messages.

To show KI message for (whichmsg - a KI message):
	choose row with a KI message of whichmsg in Table of Keyword Interface messages;
	say KI output entry;
	say line break.

Table of Keyword Interface messages
KI message	KI output
not-a-verb-I-recognise	"Non è un verbo che riconosco e neppure una parola chiave che tu possa usare in questo momento."
keyword-introduction	"[line break]Leggendo '[bold type][story title][roman type]', vedrai nel testo certe parole chiave enfatizzate. Scrivi una qualsiasi parola chiave per procedere nella narrazione.[if object keyword highlighting is true][line break]Se una parola, ad esempio [s]scenario[x], appare enfatizzata in questo modo, significa che scrivendola sarà possibile leggere una descrizione dettagliata dello scenario stesso.[line break]Invece se una parola, ad esempio [o]oggetto[x], appare enfatizzata in questo modo, significa che scrivendola sarà possibile esaminare l[']oggetto stesso più da vicino, ma che è anche possibile interagire con l[']oggetto mediante opportuni verbi.[end if][if direction keyword highlighting is true][line break]Se una parola, ad esempio [d]direzione[x], appare enfatizzata in questo modo, significa che scrivendola ti muoverai nella direzione indicata o verso il luogo corrispondente.[end if][if topic keyword highlighting is true][line break]Se una parola, ad esempio [t]conversazione[x], appare enfatizzata in questo modo, significa che scrivendola la discussione proseguirà su quell'argomento.[end if][line break]Se [if the number of active keyword systems > 1]le parole chiave non spiccano[else]la parola chiave non spicca[end if] dal resto del testo, scrivi il comando 'parole chiave' per impostare diversamente l[']enfatizzazione sul tuo sistema. Altri comandi: 'oggetti' per elencare tutti gli oggetti con cui si può interagire e 'uscite' per elencare le vie d[']uscita."
welcome-message	"Buona lettura di [o][story title][x], versione [release number].[paragraph break]Se nessuna delle parole sopra riportate sono colorate o enfatizzate, premi K.[paragraph break]Premi [t]N[x] per cominciare dall[']inizio or [t]R[x] per ricaricare una storia iniziata in precedenza."
keyword-setting-instructions	"[story title] fa uso di parole chiave enfatizzate. [if keywords required is true]E['] necessario[else]Si raccomanda[end if] che il programma interprete enfatizzi in qualche modo le parole chiave. Premi uno dei numeri sotto elencati per vedere in sequenza una serie di opzioni di visualizzazione fino a quando non ne trovi una che risulti chiara per il tuo sistema."
keyword-instructions-object	"Le parole chiave degli [o]oggetti[x] sono enfatizzate [o]così[x]."
keyword-instructions-scenery	"Le parole chiave degli [s]scenari[x] sono enfatizzate [s]così[x]."
keyword-instructions-direction	"Le parole chiave delle [d]uscite[x] sono enfatizzate [d]così[x]."
keyword-instructions-topic	"Le parole chiave degli [t]argomenti[x] sono enfatizzate [t]così[x]."
keyword-instructions-parser	"[as the parser]I messaggi del parser sono visualizzati in questo modo[as normal]."
keyword-instructions-disabled	"**Attenzione: le parole chiave enfatizzate sono parte integrante del design di [story title]. Può essere difficile o impossibile intuire come continuare se l[']enfasi non è visibile.**"
keyword-instructions-distinct	"**Attenzione: talvolta può essere utile riuscire a distinguere tra i vari tipi di parole chiave.**"
keyword-instructions-end	"Premi 0 quando hai finito, o 9 per [if screen reader mode is true]dis[end if]attivare la modalità di lettura dello schermo.[run paragraph on]"
screen-reader-activated	"La modalità di lettura dello schermo è stata attivata. [story title] usa parole chiave enfatizzate per evidenziare parole importanti che puoi scrivere per procedere nella narrazione. Il tuo software di lettura potrebbe pronunciare con un tono riconoscibile parole enfatizzate come [o]questa[x]. Se non lo facesse, con il comando 'oggetti' ottieni una lista degli oggetti nelle vicinanze, con il comando 'uscite' ottieni una lista delle direzioni accessibili. Scrivi 'parole chiave' per cambiare lo stile delle parole chiave, o scrivi 'lettura schermo' per attivare o disattivare questa modalità."
screen-reader-deactivated	"La modalità di lettura schermo è stata disattivata."


To decide what number is the number of active keyword systems:
	let ctr be 0;
	if object keyword highlighting is true, increase ctr by 1;
	if direction keyword highlighting is true, increase ctr by 1;
	if topic keyword highlighting is true, increase ctr by 1;
	decide on ctr.

Keyword Interface IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Keyword Interface by Aaron Reed.