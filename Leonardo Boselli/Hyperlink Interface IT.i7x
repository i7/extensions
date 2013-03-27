Version 1 of Hyperlink Interface IT (for Glulx only) by Leonardo Boselli begins here.

"This extension modifies the emulation of Blue Lacuna's emphasized keyword system for simplifying common IF input (by Aaron Reed) substituting emphasis with hyperlinks. Objects, directions, and topics can be clicked directly to examine, go, or discuss. Works with Glulx. Requires Basic Hyperlinks by Emily Short and Text Capture by Eric Eve. Modifiche: tradotto in italiano."

"basato su Hyperlink Interface by Leonardo Boselli"

Include Basic Screen Effects by Emily Short.

Hyperlinks required is a truth state that varies. Hyperlinks required is false.

Chapter - Menus

Menu hyperlink shown is a truth state that varies. Menu hyperlink shown is false.

Showing hyperlinks menu is an action applying to nothing.
Understand "menù" or "menu" as  showing hyperlinks menu.
Carry out showing hyperlinks menu:
	say "[line break][fixed letter spacing] [set link 2]guarda[end link] [set link 3]inventario[end link]";
	if topic hyperlink highlighting is true:
		say " [set link 4]argomenti[end link]";
	if object hyperlink highlighting is true:
		say " [set link 5]oggetti[end link]";
	if direction hyperlink highlighting is true:
		say " [set link 6]uscite[end link]";
	say "[roman type][line break]".

Chapter - Things

Section - Definitions

Object hyperlink highlighting is a truth state that varies. Object hyperlink highlighting is true. [Global activation of object hyperlinks.]

Understand "[a thing]" as examining.

Every thing has a text called the keyword. The keyword of a thing is usually "". [which word of a multi-word noun should be highlighted. In practice, the player can type any word with the same effect, but for presentation purposes it's best to have a single word highlighted.]

A thing is either hyperlinked or hyperlinkless. A thing is usually hyperlinked. [Hyperlinkless things are not automatically highlighed in room descriptions.]

Object hyperlinking something is an activity.

Rule for printing the name of a thing (called item) while looking (this is the Hyperlink Interface highlight objects when looking rule):
	carry out the object hyperlinking activity with item.

Rule for printing the name of a thing (called item) while taking inventory (this is the Hyperlink Interface highlight objects when taking inventory rule):
	carry out the object hyperlinking activity with item.

Section - Hyperlinks management

The HI max hyperlinks is a number that varies.
The HI max hyperlinks is 50.
The HI min hyperlinks is a number that varies.
The HI min hyperlinks is 7.

The HI hyperlinks counter is a number that varies.
The HI hyperlinks counter is 6.

Include Basic Hyperlinks by Emily Short.

List of Hyperlink Glulx Replacement Commands is a list of indexed texts that varies.
List of Hyperlink Glulx Replacement Commands is {}.

First when play begins:
	let T be an indexed text;
	let T be "menù";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "guarda";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "inventario";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "argomenti";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "oggetti";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "uscite";
	add T to List of Hyperlink Glulx Replacement Commands;
	change the command prompt to "[set link 2] g [end link]|[set link 3] i [end link]| [set link 1]menù[end link]>";
	repeat with CT running from (HI min hyperlinks) to (HI max hyperlinks):
		let T be "";
		add T to List of Hyperlink Glulx Replacement Commands.

A clicking hyperlink rule (this is the HI default command replacement by hyperlinks rule):
	let N be the number of entries in the List of Hyperlink Glulx Replacement Commands;
	if the current link number is less than N plus 1:
		change the glulx replacement command to the entry current link number of the List of Hyperlink Glulx Replacement Commands.

The HI default command replacement by hyperlinks rule is listed instead of the default command replacement by hyperlinks rule in the clicking hyperlink rules.

Include Text Capture by Eric Eve.

To start HI hyperlink capture:
	if the active style is not hyperlink-no-style:
		increment HI hyperlinks counter by 1;
		if HI hyperlinks counter greater than HI max hyperlinks,
		change HI hyperlinks counter to HI min hyperlinks;
		say "[set link HI hyperlinks counter]";
		start capturing text.

To end HI hyperlink capture:
	if the active style is not hyperlink-no-style:
		stop capturing text;
		say "[captured text][end link]";
		change entry HI hyperlinks counter of List of Hyperlink Glulx Replacement Commands to "[captured text]".

The HI hyperlink text is an indexed text that varies.
To print HI hyperlink:
	increment HI hyperlinks counter by 1;
	if HI hyperlinks counter greater than HI max hyperlinks,
		change HI hyperlinks counter to HI min hyperlinks;
	say " [set link HI hyperlinks counter][HI hyperlink text][end link][line break]";
	change entry HI hyperlinks counter of List of Hyperlink Glulx Replacement Commands to "[HI hyperlink text]".

Section - Rule for object hyperlinking something

Rule for object hyperlinking something (called item) (this is the Hyperlink Interface object hyperlinking rule):
	if object hyperlink highlighting is false or item is hyperlinkless:
		say the printed name of item;
		continue the action;
	let output be indexed text;
	now output is the printed name of item;
	let hl be indexed text;
	now hl is the keyword of item;
	if hl is "", change hl to word number ( the number of words in output ) in output;
	repeat with wordcounter running from 1 to the number of words in output:
		say "[if wordcounter > 1] [end if]";
		if word number wordcounter in output matches the regular expression "\b(?i)[hl]":
			if the item is scenery:
				say "[s][word number wordcounter in output][x]";
			otherwise:
				say "[o][word number wordcounter in output][x]";
		else:
			say "[word number wordcounter in output]".


Chapter - Exits

Section - Definitions

Direction hyperlink highlighting is a truth state that varies. Direction hyperlink highlighting is true.

Understand "[a direction]" as going. Understand "[an open door]" as entering.

Direction hyperlinking something is an activity.

Every direction has a text called printed name. The printed name of a direction is usually "quella via". The printed name of north is "nord". The printed name of northeast is "nordest". The printed name of east is "est". The printed name of southeast is "sudest". The printed name of south is "sud". The printed name of southwest is "sudovest". The printed name of west is "ovest". The printed name of northwest is "nordovest". The printed name of up is "su". The printed name of down is "giù". The printed name of inside is "dentro". The printed name of outside is "fuori".

The saved direction is a direction that varies.

Rule for printing the name of a direction (called dir) while looking (this is the Hyperlink Interface highlight directions while looking rule):
	now the saved direction is dir;
	carry out the direction hyperlinking activity.

Rule for printing the name of a direction (called dir) while exits listing (this is the Hyperlink Interface highlight directions while exits listing rule):
	now the saved direction is dir;
	carry out the direction hyperlinking activity.

Section - Rule for direction hyperlinking something

Rule for direction hyperlinking (this is the Hyperlink Interface direction hyperlinking rule):
	if direction hyperlink highlighting is false:
		say the printed name of the saved direction;
		continue the action;
	say "[d][the printed name of the saved direction][x]".


Chapter - Topics

Topic hyperlink highlighting is a truth state that varies. Topic hyperlink highlighting is false.

Topic hyperlink something is an activity.


Chapter - Hyperlink Types

A hyperlink type is a kind of thing. object-word is a hyperlink type. direction-word is a hyperlink type. topic-word is a hyperlink type.
scenery-word is a hyperlink type.

A hyperlink emphasis is a kind of value. The plural of hyperlink emphasis is hyperlink emphases. 

A hyperlink type has a hyperlink emphasis called style. 

The active style is a hyperlink emphasis that varies. 

To say o:
	if object hyperlink highlighting is true:
		set the text style for the style of object-word; 
		now the active style is the style of object-word;
		start HI hyperlink capture.
	
To say s:
	if object hyperlink highlighting is true:
		set the text style for the style of scenery-word; 
		now the active style is the style of scenery-word;
		start HI hyperlink capture.
	
To say t:
	if topic hyperlink highlighting is true:
		set the text style for the style of topic-word; 
		now the active style is the style of topic-word;
		start HI hyperlink capture.
 
To say d: 
	if direction hyperlink highlighting is true:
		set the text style for the style of direction-word;
		now the active style is the style of direction-word;
		start HI hyperlink capture.
	 
To say x:
	end HI hyperlink capture;
	reset styles with active style.
	         
Section - Glulx Style Definitions

Include Glulx Text Effects by Emily Short. 

The hyperlink emphases are hyperlink-bold-style, hyperlink-italics-style, hyperlink-fixedwidth-style, hyperlink-normal-style and hyperlink-no-style.

The style of object-word is hyperlink-fixedwidth-style. The style of direction-word is hyperlink-italics-style. The style of topic-word is hyperlink-bold-style.
The style of scenery-word is hyperlink-normal-style.

To set the text style for (val - a hyperlink emphasis):
	if val is hyperlink-bold-style:
		say bold type;
	else if val is hyperlink-italics-style:
		say italic type;
	else if val is hyperlink-fixedwidth-style:
		say fixed letter spacing;
	else if val is hyperlink-normal-style:
		do nothing;
	else if val is hyperlink-no-style:
		do nothing.

To reset styles with (val - a hyperlink emphasis):
	if val is hyperlink-fixedwidth-style:
		say variable letter spacing;
	else:
		say roman type;


Chapter - Changing Style

Setting the hyperlink emphasis is an action out of world applying to nothing. Understand "collegamenti" or "links" as setting the hyperlink emphasis. 
 
tempstyles is a list of hyperlink emphases that varies.

Carry out setting the hyperlink emphasis (this is the Hyperlink Interface carry out setting hyperlink emphasis rule): 
	run the hyperlinks routine.

To run the hyperlinks routine:
	let mychar be 1;   
	while mychar is not 0:
		clear the screen;  
		let num be 0; 
		show HI message for hyperlink-setting-instructions;
		say line break;
		if object hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let object-number be num;
			show HI message for hyperlink-instructions-object;
		if object hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let scenery-number be num;
			show HI message for hyperlink-instructions-scenery;
		if direction hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let direction-number be num;
			show HI message for hyperlink-instructions-direction;
		if topic hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let topic-number be num;
			show HI message for hyperlink-instructions-topic;
		[Print a warning if emphasis is disabled in a game where hyperlinks are required; note that the player is still allowed to do so, however.]
		if hyperlinks required is true:
			if ( object hyperlink highlighting is true and style of object-word is hyperlink-no-style ) or ( object hyperlink highlighting is true and style of scenery-word is hyperlink-no-style ) or ( direction hyperlink highlighting is true and  style of direction-word is hyperlink-no-style ) or ( topic hyperlink highlighting is true and style of topic-word is hyperlink-no-style ) :
				say line break;
				show HI message for hyperlink-instructions-disabled;
		[Print a warning if any two active hyperlink styles are the same.]
		truncate tempstyles to 0 entries;
		let dupe be false;
		if object hyperlink highlighting is true:
			add style of object-word to tempstyles;
			add style of scenery-word to tempstyles;
		if direction hyperlink highlighting is true:
			if style of direction-word is listed in tempstyles:
				now dupe is true;
			else:
				add style of direction-word to tempstyles;
		if topic hyperlink highlighting is true:
			if style of topic-word is listed in tempstyles:
				now dupe is true;
		if dupe is true:
			say line break;
			show HI message for hyperlink-instructions-distinct;
		say line break;
		show HI message for hyperlink-instructions-end;
		now mychar is single-character - 48; [Converts ASCII to actual number typed.]
		if mychar is object-number:
			advance style with object-word;
		otherwise if mychar is scenery-number:
			advance style with scenery-word;
		otherwise if mychar is direction-number:
			advance style with direction-word;
		otherwise if mychar is topic-number:
			advance style with topic-word;
	clear the screen;
	if pre-game hyperlink setting is true:
		now pre-game hyperlink setting is false;
		do nothing;
	otherwise:
		try looking. 
	  
To advance style with (hltype - a hyperlink type):
	now the style of hltype is the hyperlink emphasis after the style of hltype.

To decide which number is single-character: (- (VM_KeyChar()) -).

Section - Exits

[This routine is lifted straight from the example in the Inform 7 docs.]

Understand "uscite" or "exits" as exits listing. Exits listing is an action out of world applying to nothing.

Definition: a direction (called thataway) is viable if the room thataway from the location is a room.

[*** LEO *** Per eliminare THE nella lista di 'viable directions']
Carry out exits listing (this is the Hyperlink Interface carry out exits listing rule):
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

Carry out thing listing (this is the Hyperlink Interface carry out thing listing rule):
	say "Intorno [is-are the list of visible other things].".

[*** LEO *** per evitare che siano elencate le parti]
Definition: a thing is other if it is not the player and it is not part of something.

Rule for printing the name of a thing (called item) while thing listing:
	carry out the object hyperlinking activity with item.


Chapter - Beginning Play
	 
Section - Hyperlink Interface setup rule

pre-game hyperlink setting is a truth state that varies. pre-game hyperlink setting is true.

When play begins (this is the Hyperlink Interface setup trigger rule):
	if hyperlinks required is false:
		continue the action;
	clear the screen;
	let mychar be 1; 
	show HI message for welcome-message;
	while mychar is not 0:
		now mychar is single-character; 
		if mychar is 82 or mychar is 114: [ r or R: restore ]
			restore the game;  
		if mychar is 72 or mychar is 104: [ h or H: hyperlink ]
			run the hyperlinks routine;
			now mychar is 0;
		if mychar is 78 or mychar is 110: [ n or N: new game ]
			now mychar is 0;
	clear the screen;
	say "[line break][line break][line break]";
	now pre-game hyperlink setting is false.    
 
To restore the game: (- RESTORE_THE_GAME_R(); -).


Chapter - Error Reporting

Section - Not a verb I recognise

Rule for printing a parser error when parser error is not a verb I recognise (this is the Hyperlink Interface not a verb I recognise rule) : show HI message for not-a-verb-I-recognise. [Acknowledge that the player may be trying to type a hyperlink, not just a verb.]


Chapter - Messages

A HI message is a kind of value. Some HI messages are defined by the Table of Hyperlink Interface messages.

To show HI message for (whichmsg - a HI message):
	choose row with a HI message of whichmsg in Table of Hyperlink Interface messages;
	say HI output entry;
	say line break.

Table of Hyperlink Interface messages
HI message	HI output
not-a-verb-I-recognise	"Non è un verbo che riconosco e neppure una parola chiave che tu possa usare in questo momento."
hyperlink-introduction	"[line break]Leggendo '[bold type][story title][roman type]', vedrai nel testo certe parole chiave enfatizzate come collegamenti ipertestuali. Scrivi una qualsiasi parola chiave o clicca su di essa per procedere nella narrazione.[if object hyperlink highlighting is true][line break]Se una parola, ad esempio [s]scenario[x], appare enfatizzata in questo modo, significa che scrivendola sarà possibile leggere una descrizione dettagliata dello scenario stesso.[line break]Invece se una parola, ad esempio [o]oggetto[x], appare enfatizzata in questo modo, significa che scrivendola sarà possibile esaminare l[']oggetto stesso più da vicino, ma che è anche possibile interagire con l[']oggetto mediante opportuni verbi.[end if][if direction hyperlink highlighting is true][line break]Se una parola, ad esempio [d]direzione[x], appare enfatizzata in questo modo, significa che scrivendola ti muoverai nella direzione indicata o verso il luogo corrispondente.[end if][if topic hyperlink highlighting is true][line break]Se una parola, ad esempio [t]conversazione[x], appare enfatizzata in questo modo, significa che scrivendola la discussione proseguirà su quell'argomento.[end if][line break]Se [if the number of active hyperlink systems > 1]le parole chiave non spiccano[else]la parola chiave non spicca[end if] dal resto del testo, scrivi il comando 'collegamenti' per impostare diversamente l[']enfatizzazione sul tuo sistema. Altri comandi: 'oggetti' per elencare tutti gli oggetti con cui si può interagire e 'uscite' per elencare le vie d[']uscita."
welcome-message	"Buona lettura di [o][story title][x], versione [release number].[paragraph break]Se nessuna delle parole sopra riportate sono enfatizzate e sottolineate, premi K.[paragraph break]Premi [t]N[x] per cominciare dall[']inizio or [t]R[x] per ricaricare una storia iniziata in precedenza."
hyperlink-setting-instructions	"[story title] fa uso di parole chiave enfatizzate come collegamenti ipertestuali. [if hyperlinks required is true]E['] necessario[else]Si raccomanda[end if] che il programma interprete enfatizzi in qualche modo le parole chiave. Premi uno dei numeri sotto elencati per vedere in sequenza una serie di opzioni di visualizzazione fino a quando non ne trovi una che risulti chiara per il tuo sistema."
hyperlink-instructions-object	"Le parole chiave degli [o]oggetti[x] sono enfatizzate [o]così[x]."
hyperlink-instructions-scenery	"Le parole chiave degli [s]scenari[x] sono enfatizzate [s]così[x]."
hyperlink-instructions-direction	"Le parole chiave delle [d]uscite[x] sono enfatizzate [d]così[x]."
hyperlink-instructions-topic	"Le parole chiave degli [t]argomenti[x] sono enfatizzate [t]così[x]."
hyperlink-instructions-disabled	"**Attenzione: le parole chiave enfatizzate come collegamenti ipertestuali sono parte integrante del design di [story title]. Può essere difficile o impossibile intuire come continuare se l[']enfasi non è visibile.**"
hyperlink-instructions-distinct	"**Attenzione: talvolta può essere utile riuscire a distinguere tra i vari tipi di parole chiave.**"
hyperlink-instructions-end	"Premi 0 quando hai finito.[run paragraph on]"

To decide what number is the number of active hyperlink systems:
	let ctr be 0;
	if object hyperlink highlighting is true, increase ctr by 1;
	if direction hyperlink highlighting is true, increase ctr by 1;
	if topic hyperlink highlighting is true, increase ctr by 1;
	decide on ctr.

Hyperlink Interface IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Hyperlink Interface by Leonardo Boselli.
