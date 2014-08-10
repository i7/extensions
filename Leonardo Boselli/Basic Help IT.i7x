Version 3/140811 of Basic Help IT by Leonardo Boselli begins here.

"Fornisce un comando AIUTO che mostra un elenco con istruzioni standard attivabili mediante collegamenti ipertestuali."

"basato su Basic Help Menu di Emily Short."

Include Hyperlink Interface IT by Leonardo Boselli.

Chapter - Announce

When play begins (this is the announce the help availability at startup rule), announce the help availability.

To announce the help availability:
	say "[italic type]Chiedi [o]aiuto[x] se non sai come procedere.[roman type][paragraph break]".

Chapter - Help Menus

Table of Basic Help Options
title	subtable (a table name)	description	toggle (a rule)
"Introduzione a '[bold type][story title][fixed letter spacing]'"	--	"[line break][story description]"	--
"Istruzioni per giocare"	Table of Instruction Options	--	--

Table of Instruction Options
title	subtable	description	toggle
"Cos[']è l['][italic type]Interactive Fiction[fixed letter spacing]?"	--	"[line break]Questo gioco è un[']opera di [italic type]Interactive Fiction[roman type] (abbreviato IF, detta anche [italic type]Narrativa Interattiva[roman type] in italiano). Nell[']IF interpreti il personaggio principale di una storia. Scrivi comandi che determinano le azioni del personaggio e il flusso della sceneggiatura. Alcuni giochi di IF includono immagini e suoni, ma non tutti: è la tua immaginazione che li fornisce. D[']altra parte, è disponibile un[']ampia gamma di azioni: mentre in altri giochi sei limitato a sparare, muoverti o cercare oggetti con un click del mouse, IF permette molte altre possibilità."	--
"Che cosa fare di '[bold type][command prompt][fixed letter spacing]'?"	--	"[line break]Il segno '[command prompt]' rappresenta la domanda del gioco: 'Bene, che cosa vuoi fare ora?' Puoi rispondere scrivendo un[']azione - solitamente un verbo all[']imperativo, a volte seguito da preposizioni ed oggetti. Così, per esempio, GUARDA, GUARDA LA PISTOLA, PRENDI LA PISTOLA."	--
"Per iniziare"	--	"[line break]La prima cosa che devi fare per iniziare un gioco è prendere coscienza di ciò che ti circonda e capire qual è il tuo obiettivo. Per questo scopo occorre leggere attentamente l[']introduzione. A volte vengono forniti degli indizi. Devi anche esaminare la stanza in cui ti trovi. Devi individuare le uscite ed leggere le descrizioni degli oggetti presenti. Se alcuni sembrano interessanti, puoi esaminarli con il comando ESAMINA (anche abbreviato con X).[paragraph break]Potresti anche esaminare te stesso (ESAMINA ME) per verificare se l[']autore ha lasciato qualche indizio a proposito del tuo personaggio. L'inventario (INVENTARIO, anche abbreviato con I) ti fornirà l[']elenco degli oggetti che stai portando.[paragraph break]Una volta che ti sei orizzontato, devi esplorare. Spostati da una stanza all[']altra ed esamina ogni luogo accessibile."	--
"Stanze e spostamenti"	--	"[line break]In ogni istante, ti trovi in un luogo specifico, o stanza. Quando entri in una stanza, il gioco stamperà una descrizione di ciò che puoi vedere. La descrizione contiene due tipi di informazioni vitali: gli oggetti nella stanza che puoi prendere o con cui puoi interagire e una lista delle uscite. Se vuoi rileggere la descrizione, puoi semplicemente scrivere GUARDA (anche abbreviato con G).[paragraph break]Quando vuoi lasciare un luogo e spostarti in un altro, puoi comunicarlo al gioco usando le direzioni della bussola: ad esempio, VAI A NORD. Per semplicità, è possibile omettere il verbo VAI ed abbreviare il nome della direzione. Puoi usare NORD, SUD, EST, OVEST, NORDEST, SUDEST, NORDOVEST, SUDOVEST, SU e GIU['] (scritto 'giù', ma anche 'giu'), oppure in forma abbreviata N, S, E, W, NE, SE, NW, SW, U, and D (dalle diciture inglesi)."	--
"Oggetti"	--	"[line break]Durante il gioco si presenteranno molti oggetti con cui potrai interagire. In particolare, puoi prendere oggetti (comando PRENDI) e lasciarli (comando LASCIA). L'inventario (comando INVENTARIO, abbreviato con I) elencherà gli oggetti in tuo possesso.[paragraph break]Solitamente ci sono una serie di azioni che puoi eseguire su questi oggetti. APRI (e la variante SBLOCCA o APRI CON... se è necessaria una chiave), CHIUDI (e la variante BLOCCA o CHIUDI CON... per chiudere con una chiave), INDOSSA e MANGIA sono le più comuni.[paragraph break]A volte, noterai che il gioco non riconosce il nome di un oggetto anche se è stato presentato nella descrizione della stanza. Se questo avviene, l'oggetto fa solo parte della scenografia e puoi concludere che non hai bisogno di interagire con esso.[paragraph break]A volte è possibile far eseguire ad altri personaggi gli stessi comandi disponibili per il giocatore. Per ordinare ad un gnomo di prendere il presce, basta scrivere GNOMO, PRENDI LA SPADA."	--
"Per controllare il gioco"	--	"[line break]Sono disponibili alcuni semplici comandi per controllare il gioco stesso. Sono:[paragraph break]SALVA la situazione attuale del gioco.[line break]CARICA la situazione di un precedente salvataggio. Non c[']è limiti al numero di salvataggi.[line break]RESTORE ripristina il gioco nel suo stato iniziale.[line break]QUIT interrompe il gioco."	--
"Il mondo del gioco"	Table of IF Elements	--	--
"Se non riesci a procedere"	Table of Stuckness Advice	--	--

Table of Stuckness Advice
title	subtable	description	toggle
"Esplora!"	--	"[line break]Esamina ogni oggetto e guarda tutto ciò che hai nell[']inventario. Apri tutte le porte che vedi e attraversale. Guarda in tutti i contenitori chiusi. Sii certo di aver esaurito tutte le possibilità dell'ambiente in cui ti trovi.[paragraph break]Prova tutti i tuoi sensi. Se il gioco menziona superfici, odori o suoni, prova a toccare, annusare, ascoltare o gustare gli oggetti.[paragraph break]Se ancora non capisci cosa fare, prova ad aprire finestre, guardare sotto ai letti ecc. A volte gli oggetti sono ben nascosti."
"Leggi con attenzione!"	--	"[line break]Rileggi. Guarda nuovamente gli oggetti che hai già esaminato. Questo a volte fa venire idee a cui prima non avevi pensato.[paragraph break]Individua i suggerimenti nascosti nel testo. Gli oggetti che sono descritti con grande cura sono probabilmente più importanti di quelli con una breve descrizione. Gioca con questi oggetti. Se una macchina è descritta come composta da varie parti, guarda le parti e cerca di manipolarle. Allo stesso modo, nota i verbi che usa il gioco. Cerca di usarli tu stesso. Spesso il gioco prevede verbi speciali come il nome di parole magiche, o altri comandi speciali. Non fa male tentare qualcosa che il gioco suggerisce.[paragraph break]
Verifica l'intero schermo. Ci sono altre finestre oltre a quella principale? Cosa sta succedendo in quelle? Controlla la barra di stato, se ce n[']è una - può contenere il nome della stanza in cui ti trovi, il tuo punteggio, l[']ora del giorno, lo stato di salute del tuo personaggio, o altre informazioni importanti. Se c[']è riportato qualcosa, significa che è bene prestargli attenzione. Quando e dove cambia? Perché è significativo? Se la barra descrive il tuo stato di salute, ci sarà un punto in cui diventerà importante."
"Sii creativo!"	--	"[line break]Riformula i comandi. Se c[']è qualcosa che vuoi fare, ma il gioco sembra non capirti, prova formulazioni alternative.[paragraph break]Prova varianti. Talvolta un[']azione non funziona, ma produce qualche tipo di risultato insolito. Questo spesso indica che sei sulla pista giusta, anche se non hai ancora compreso l[']approccio corretto. Premere il pulsante rosso può solo generare uno strano rumore all'interno del muro, così magari premere prima il pulsante blu e poi quello rosso potrebbe aprire la porta segreta.[paragraph break]Considera il genere del gioco (fantasy, thriller, horror ecc.), ognuno ha il suo tipo di azioni e motivazioni. Che cosa stai cercando di fare e come lo ottengono i personaggi convenzionali del genere? Che tipo di comportamento è corretto per un detective, un mago o una spia?"
"Coopera!"	--	"[line break]Gioca in compagnia. Due teste sono spesso meglio di una sola. Se non funziona, prova a mandare un email all[']autore o, meglio ancora, invia una richiesta di aiuto sul newsgroup it.comp.giochi.avventure.testuali. Per migliori risultati, metti il nome del gioco nel soggetto, poi lascia una pagina vuota (così nessuno leggerà dove sei arrivato nel gioco a meno che non lo voglia) e descrivi il problema nel modo più chiaro possibile. Qualcuno probabilmente sarà in grado di aiutarti."	--

Table of IF Elements
title	subtable	description	toggle
"Spostamenti"	--	"[line break]Molti giochi di IF sono ambientati in un mondo fatto di stanze senza divisioni interne. Gli spostamenti tra stanze sono possibili, mentre quelli all[']interno della stanza non sempre hanno effetto. VAI SU SCRIVANIA è raramente un comando utile. D[']altro canto, se qualcosa viene descritto come fuori portata perché è troppo in alto, è talvolta rilevante salire su un[']oggetto per raggiugerlo. Questo tipo di attività diventa importante solo se è suggerita dal testo."	--
"Contenitori"	--	"[line break]L[']IF tende a simulare con accuratezza i contenitori. C[']è qualcosa all'interno di qualcos[']altro? Il gioco ne tiene conto e molti puzzle hanno a che fare con il luogo dove si trovano gli oggetti -- se in possesso del giocatore, sul pavimento della stanza, sul tavolo, in una scatola ecc."	--
"Tipi di azione"	--	"[line break]Molte azioni che puoi eseguire in un mondo di IF sono brevi e specifiche. VAI A OVEST o APRI LA PORTA sono spesso necessarie. FAI UN VIAGGIO or COSTRUISCI UN TAVOLO non lo sono. Azioni come VAI IN HOTEL sono sul confine: alcuni giochi le permettono, ma molti no. In generale, comportamenti astratti, composti da vari passi, devono essere separati in azioni più semplici per fare in modo che il gioco li capisca."	--
"Altri personaggi"	--	"[line break]Gli altri personaggi nei giochi di IF sono piuttosto limitati. D[']altro canto, ci sono anche giochi in cui l[']interazione tra i personaggi è l[']attrattiva principale del gioco. Dovresti essere in grado di entrare presto in sintonia con gli altri personaggi -- se rispondono a molte domande, ricorda quello che hanno detto, se si muovono di loro iniziativa, ecc., allora possono essere molto importanti. Se hanno un numero limitato di risposte e non sembra che il designer del gioco li abbia molto sviluppati, allora sono probabilmente presenti come colore locale o per fornire la soluzione ad alcuni puzzle specifici. I personaggi in giochi orientati ai puzzle spesso devono essere corrotti, intimoriti o obbligati a compiere azioni che il giocatore non può fare -- per fornire informazioni o oggetti, per raggiungere luoghi inaccessibili, per permettere al giocatore di entrare in aree ad accesso controllato e così via."	--

Understand "help" or "hint" or "hints" or "about" or "info" or "aiuto" as asking for help.
Asking for help is an action out of world.
Carry out asking for help (this is the help request rule):
	now the current menu is the Table of Basic Help Options;
	try asking for help list;

Understand "< [number] >" as asking for particular help.
Asking for particular help is an action applying to a number.
Carry out asking for particular help (this is the particular help request rule):
	let N be the number understood;
	if N < 1 or N > number of rows in the current menu:
		say "[italic type]L[']opzione [N] è ignota.[roman type][line break]";
	otherwise:
		choose row N in the current menu;
		if there is a description entry:
			say "[line break][bold type][title entry][roman type]";
			say "[description entry][line break]";
			say "[line break][o]lista opzioni[x]";
		otherwise if there is a subtable entry:
			now the current menu is subtable entry;
			try asking for help list;
		otherwise:
			say "[bold type]< [N] >[italic type] non corrisponde a nessuna azione.[roman type][line break]";

Understand "lista opzioni" as asking for help list.
Asking for help list is an action out of world.
The current menu is a table name that varies.
Carry out asking for help list (this is the help list request rule):
	repeat with N running from 1 to the number of rows in the current menu: 
		choose row N in the current menu; 
		say "[o]< [N] >[x] [title entry][line break]";
	if current menu is not Table of Basic Help Options:
		say "[o]aiuto[x]";

Basic Help IT ends here.

---- DOCUMENTATION ----

NOTA: Questa è una modifica dell'estensione originale Basic Help Menu di Emily Short per supportare i collegamenti ipertestuali ed evitare i menù a schermo.

Per la documentazione completa vedi l'estensione originale.
