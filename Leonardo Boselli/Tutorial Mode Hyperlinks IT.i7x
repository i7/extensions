Tutorial Mode Hyperlinks IT by Leonardo Boselli begins here.

"Adds a tutorial mode, which is on by default, to any game, to introduce key actions for the novice player. Can be revised or expanded by the author. Modifiche: tradotto in italiano e ampiamente rimaneggiato anche per illustrare la Hyperlink Interface."

"based on Tutorial Mode by Emily Short."

Section 1 - Creating tutorial mode and controls

Include Conversation Package IT by Leonardo Boselli.
Include Hyperlink Interface IT by Leonardo Boselli.

Tutorial mode is a truth state that varies. Tutorial mode is false.

After looking for the first time:
	say "[no line break]([italic type]Scrivi [t]TUTOR[x] per seguire un tutorial interattivo su come giocare[roman type])[paragraph break]".

Understand "tutor off" or "tutorial off" as turning off tutorial mode.
Understand "tutor" or "tutor on" or "tutorial on" as turning on tutorial mode.

Turning off tutorial mode is an action out of world.

Check turning off tutorial mode:
	if tutorial mode is false, say "Il tutor è già disattivo." instead.

Carry out turning off tutorial mode:
	now tutorial mode is false.
	
Report turning off tutorial mode:
	say "Ora il tutor è disattivo. Ti conviene riprenderlo se non hai ben compreso il significato dei collegamenti ipertestuali con i seguenti stili: [o]oggetti[x], [d]direzioni[x], [t]argomenti[x]."

Turning on tutorial mode is an action out of world.

Check turning on tutorial mode:
	if tutorial mode is true, say "Il tutor è già attivo o è stato già eseguito completamente." instead.

Carry out turning on tutorial mode:
	now tutorial mode is true.
	
Report turning on tutorial mode:
	say "Ora il tutor è attivo."

Section 2 - Forcing player response

The example-thing is a thing that varies.
The example-worn is a thing that varies.
The example-talker is an person that varies.
The example-argument is an object that varies.
The example-contained is a thing that varies.
The example-container is a thing that varies.

The expected command is indexed text that varies. 
The alternate command is indexed text that varies. 
The held rule is a rule that varies. 
The completed instruction list is a list of rules that varies.

Understand "carica" or "smetti" or "salva" or "ricomincia" or "versione" as "[meta]".

After reading a command when tutorial mode is true (this is the require correct response rule):
	if the player's command includes "tutor", make no decision;
	if the player's command includes "[meta]", make no decision;
	if the expected command is "", make no decision;
	let the translated command be indexed text;
	let the translated command be "[the player's command]";
	if (the translated command is the expected command) or (the translated command is the alternate command):
		now the expected command is "";
		now the alternate command is "";
		if the held rule is a selector listed in the Table of Instruction Followups:
			choose row with a selector of the held rule in the Table of Instruction Followups;
			say "[italic type][followup entry][roman type][paragraph break]";
		otherwise:
			say "[italic type][one of]Bene[or]Molto bene[or]Eccellente[or]Ottimo lavoro[or]Superbo[or]Perfetto[at random][one of]![or].[at random][roman type]";
		add the held rule to the completed instruction list;
		now the held rule is the little-used do nothing rule;
	otherwise:
		say "[italic type][one of]No[or]Mi dispiace[at random], [one of]non è questo[or]riprova[at random].[roman type]";
		reject the player's command;

Section 3 - The Instructional Rules

Before reading a command when tutorial mode is true (this is the offer new prompt rule):
	follow the instructional rules.

The instructional rules are a rulebook.

An instructional rule (this is the teach looking rule): 
	if the teach looking rule is listed in the completed instruction list, make no decision;
	say "[italic type]In ogni momento, puoi osservare ciò che ti circonda scrivendo [t]GUARDA[x] (LOOK in inglese). Ora prova a scrivere GUARDA sulla linea di comando. (Se hai già dimestichezza con le avventure testuali e con l[']interfaccia a collegamenti ipertestuali, puoi interrompere il tutorial scrivendo [t]TUTOR OFF[x].)[roman type]";
	now the expected command is "look";
	now the alternate command is "guarda";
	now the held rule is the teach looking rule;
	rule succeeds.

An instructional rule (this is the teach examining rule): 
	if the teach examining rule is listed in the completed instruction list, make no decision;
	if the player can see the example-thing:
		let N be indexed text;
		let N be "[the example-thing]";
		say "[italic type]Anche i singoli oggetti hanno delle descrizioni. Puoi scoprire qualcosa di più su di essi esaminandoli, come ad esempio con [t]ESAMINA [N in upper case][x] (o EXAMINE in inglese).[roman type]";
		now the expected command is "examine [N]";
		now the alternate command is "esamina [N]";
		now the held rule is the teach examining rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach taking rule):
	if the teach taking rule is listed in the completed instruction list, make no decision;
	if (the player does not carry the example-thing) and (the player does not wear the example-thing):
		let N be indexed text;
		let N be "[the example-thing]";
		say "[italic type]Puoi raccogliere oggetti, quando li vedi, scrivendo [t]PRENDI [N in upper case][x] (o TAKE in inglese).[roman type]";
		now the expected command is "take [N]";
		now the alternate command is "prendi [N]";
		now the held rule is the teach taking rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach inventory rule): 
	if the teach inventory rule is listed in the completed instruction list, make no decision;
	if the player carries the example-thing:
		say "[italic type]Ora risulta che hai qualcosa in mano. Per scoprire cosa trasporti o cosa indossi, scrivi [t]INVENTARIO[x] (o INVENTORY in inglese).[roman type]";
		now the expected command is "inventory";
		now the alternate command is "inventario";
		now the held rule is the teach inventory rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach dropping rule):
	if the teach dropping rule is listed in the completed instruction list, make no decision;
	if the player carries the example-thing:
		let N be indexed text;
		let N be "[the example-thing]";
		say "[italic type]Se vuoi liberarti di qualcosa che hai in mano, puoi sempre abbandonarla, scrivendo [t]LASCIA [N in upper case][x] (o DROP in inglese).[roman type]";
		now the expected command is "drop [N]";
		now the alternate command is "lascia [N]";
		now the held rule is the teach dropping rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach taking off rule):
	if the teach taking off rule is listed in the completed instruction list, make no decision;
	if the player wears the example-worn:
		let N be indexed text;
		let N be "[the example-worn]";
		say "[italic type]Puoi toglierti gli oggetti indossati, scrivendo [t]TOGLI [N in upper case][x] (o TAKE OFF in inglese).[roman type]";
		now the expected command is "take off [N]";
		now the alternate command is "togli [N]";
		now the held rule is the teach taking off rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach wearing rule):
	if the teach wearing rule is listed in the completed instruction list, make no decision;
	if the teach dropping rule is not listed in the completed instruction list, make no decision;
	if the player carries the example-worn:
		let N be indexed text;
		let N be "[the example-worn]";
		say "[italic type]Puoi anche indossare gli oggetti, scrivendo [t]INDOSSA [N in upper case][x] (o WEAR in inglese).[roman type]";
		now the expected command is "wear [N]";
		now the alternate command is "indossa [N]";
		now the held rule is the teach wearing rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach extracting rule):
	if the teach extracting rule is listed in the completed instruction list, make no decision;
	if the example-contained is contained in the example-container:
		let N be indexed text;
		let N be "[the example-contained]";
		say "[italic type]Alcuni oggetti possono essere collocati all[']interno di contenitori, come ad esempio [the example-contained] [inp the example-container]. Se vuoi prenderli, scrivi normalmente [t]PRENDI [N in upper case][x] (o TAKE in inglese).[roman type]";
		now the expected command is "take [N]";
		now the alternate command is "prendi [N]";
		now the held rule is the teach extracting rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach inserting into rule):
	if the teach inserting into rule is listed in the completed instruction list, make no decision;
	if the player carries the example-contained:
		let N be indexed text;
		let N be "[the example-contained]";
		let N1 be indexed text;
		let N1 be "[inp the example-container]";
		say "[italic type]Se vuoi riporre un oggetto in un contenitore, puoi scrivere [t]METTI [N in upper case] [N1 in upper case][x] (o INSERT INTO in inglese).[roman type]";
		now the expected command is "insert [N] [N1]";
		now the alternate command is "metti [N] [N1]";
		now the held rule is the teach inserting into rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach hailing rule):
	if the teach hailing rule is listed in the completed instruction list, make no decision;
	if the player can see the example-talker:
		let N be indexed text;
		let N be "[example-talker]";
		say "[italic type]Se vuoi iniziare a conversare con qualcuno, puoi scrivere [t][N in upper case], SALVE[x] (o HI in inglese).[roman type]";
		now the expected command is "[N], hi";
		now the alternate command is "[N], salve";
		now the held rule is the teach hailing rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach asking about rule):
	if the teach asking about rule is listed in the completed instruction list, make no decision;
	if the teach hailing rule is not listed in the completed instruction list, make no decision;
	if the current interlocutor is the example-talker:
		let N be indexed text;
		let N be "[dip the example-argument]";
		say "[italic type]Se vuoi chiedere particolari informazioni, puoi scrivere [t]CHIEDI [N in upper case][x] (o ASK ABOUT in inglese).[roman type]";
		now the expected command is "ask about [N]";
		now the alternate command is "chiedi [N]";
		now the held rule is the teach asking about rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach goodbye rule):
	if the teach goodbye rule is listed in the completed instruction list, make no decision;
	if the teach hailing rule is not listed in the completed instruction list, make no decision;
	if the teach asking about rule is not listed in the completed instruction list, make no decision;
	if the current interlocutor is the example-talker:
		say "[italic type]Se vuoi interrompere una conversazione noiosa, ti puoi congedare scrivendo [t]ADDIO[x] (o BYE in inglese).[roman type]";
		now the expected command is "bye";
		now the alternate command is "addio";
		now the held rule is the teach goodbye rule;
		rule succeeds;
	otherwise:
		make no decision.

An instructional rule (this is the teach compass directions rule):
	if the teach compass directions rule is listed in the completed instruction list, make no decision;
	let place be a random room which is adjacent to the location; 
	let way be the best route from the location to the place; 
	let N be indexed text;
	let N be "[way]";
	say "[italic type]Per spostarti da un luogo all[']altro, puoi usare le direzioni della bussola (NORD, SUD, EST, OVEST, così come NORDEST, NORDOVEST, ecc. o i corrispondenti in inglese).[line break]Prova a scrivere [d][N in upper case][x].[roman type]";
	now the expected command is "[N]";
	now the held rule is the teach compass directions rule;
	rule succeeds.

A last instructional rule (this is the teach meta-features rule):
	if the teach meta-features rule is listed in the completed instruction list, make no decision;
	say "[italic type]Questo tutorial copre la maggior parte di ciò che devi sapere! Ci sono tanti altri verbi che puoi scrivere mentre procedi, ma dovresti essere in grado di intuire quali sono dal contesto. Non temere di sperimentare nuove azioni.[paragraph break]Inoltre, puoi anche utilizzare i collegamenti ipertestuali che compaiono sotto la linea di comando e consentono un accesso rapido alle azioni di uso più comune.[paragraph break]Per interrompere il gioco, scrivi SMETTI; per salvare la tua attuale posizione, scrivi SALVA. CARICA permette di ripristinare un gioco salvato in precedenza e RICOMINCIA fa partire il gioco dall[']inizio.[roman type]";
	add the teach meta-features rule to the completed instruction list;
	rule succeeds. 

Table of Instruction Followups
selector	followup
teach looking rule	"Eccellente! GUARDA (o LOOK, anche abbreviato in L) stamperà una descrizione dell[']ambiente, come questa:"
teach examining rule	"Molto bene. Siccome esaminerai oggetti frequentemente, puoi abbreviare il comando con X.[line break]Come puoi notare, determinate parole sono evidenziate con stili particolari e trasformate in collegamenti ipertestuali, come ad esempio [the example-thing][italic type]. Questo significa che l[']oggetto può essere esaminato semplicemente scrivendone il nome, cioè addirittura omettendo la X, e con tali tipi di oggetti si può anche interagire mediante opportune azioni.[line break]Infine, per facilitare il giocatore, possono comparire subito dopo la descrizione, sotto forma di collegamenti ipertestuali, alcuni suggerimenti sulle azioni che è possibile eseguire sull[']oggetto esaminato.[line break]Ecco la descrizione dell[']oggetto:"
teach inventory rule	"Giusto! In seguito, puoi anche abbreviare il comando con INV o semplicemente I. Come vedi, verrà stampata una descrizione di ciò che possiedi:"
teach dropping rule	"L[']azione di lasciare un oggetto avrà l[']effetto di spostarlo nell[']ambiente, come in questo caso:"
teach taking rule	"Ben fatto. Ora otterrai un messaggio che ti informerà che hai raccolto [the example-thing] con successo:"
teach compass directions rule	"Bene! Come altri comandi molto usati, le direzioni della bussola possono essere abbreviate con N, S, E, O, NE, NO, e così via (oppure, in inglese, W al posto di O). SU e GIU['] (UP e DOWN in inglese) sono anche possibili.[line break]Leggi attentamente le descrizioni delle stanze per capire quali direzioni sono accessibili. Inoltre, certe parole evidenziate in [d]questo modo[x][italic type] rappresentano porte o luoghi verso cui ci si può muovere: per farlo è sufficiente scrivere la parola corrispondente.[paragraph break]Appena entri in una stanza, otterrai una descrizione di ciò che contiene, come questa:"
teach wearing rule	"Bene! L[']azione di indossare un oggetto lo sposterà sul personaggio, come in questo caso:"
teach taking off rule	"Corretto. L[']azione di togliere un oggetto avrà l[']effetto di spostarlo dal corpo del personaggio alle sue mani, come in questo caso:"
teach hailing rule	"Ottimo! L[']azione di salutare un personaggio inizierà una conversazione, come in questo caso:"
teach asking about rule	"Molto bene. Come avrai intuito, sarebbe bastato scrivere [example-argument][italic type] perché è una parola evidenziata con lo stile degli argomenti di conversazione. L[']azione di chiedere o parlare di determinati argomenti permette di guidare la conversazione a piacimento, come in questo caso:"
teach goodbye rule	"Perfetto! L[']azione di salutare un personaggio interromperà la conversazione, come in questo caso:"
teach extracting rule	"Giusto! L[']azione di prendere un oggetto che si trova dentro a un contenitore avrà l[']effetto di spostarlo dal contenitore alle mani del personaggio, come in questo caso:"
teach inserting into rule	"Ottimo lavoro. L[']azione di inserire un oggetto dentro un contenitore avrà l[']effetto di spostarlo dalle mani del personaggio nel contenitore, come in questo caso:"

Tutorial Mode Hyperlinks IT ends here.

---- Documentation ----

Vedi la documentazione originale di Tutorial Mode by Emily Short.
