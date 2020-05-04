Version 2/140825 of Tutorial Mode Hyperlinks IT by Leonardo Boselli begins here.

"Adds a tutorial mode, which is on by default, to any game, to introduce key actions for the novice player. Can be revised or expanded by the author. Changes to the original version: added the hyperlinks of the Hyperlink Interface. Based on Tutorial Mode by Emily Short. Translated in Italian."

Include Tutorial Mode Hyperlinks by Leonardo Boselli.

Section 1 - Creating tutorial mode and controls

Include Conversation Package IT by Leonardo Boselli.
Include Hyperlink Interface IT by Leonardo Boselli.

the tutor first time looking rule response (A) is "[no line break]([italic type]Scrivi [t]TUTORIAL ON[x][italic type] per seguire un tutorial interattivo su come giocare[roman type])[paragraph break]".

the turn off tutorial rule response (A) is "Il tutorial è già disattivo.".
the report turn off tutorial rule response (A) is "Ora il [t]tutorial[x] è disattivo. Ti conviene riprenderlo se non hai ben compreso il significato dei collegamenti ipertestuali con i seguenti stili: [o]oggetti[x], [d]direzioni[x], [t]argomenti[x].".
the check turning on tutorial rule response (A) is "Il tutorial è già attivo o è stato già eseguito completamente.".
the report turning on tutorial rule response (A) is "Ora il tutorial è attivo.".

Section 2 - Forcing player response

Understand "carica" or "smetti" or "salva" or "ricomincia" or "versione" as "[meta]".

the require correct response rule response (A) is "[italic type][one of]Bene[or]Molto bene[or]Eccellente[or]Ottimo lavoro[or]Superbo[or]Perfetto[at random][one of]![or].[at random][roman type]".
the require correct response rule response (B) is "[italic type][one of]No[or]Mi dispiace[at random], [one of]non è questo[or]riprova[at random].[roman type]".

Section 3 - The Instructional Rules

the teach looking rule response (A) is "[italic type]In ogni momento, puoi osservare ciò che ti circonda scrivendo [t]GUARDA[x][italic type]. Ora prova a scrivere GUARDA sulla linea di comando. (Se hai già dimestichezza con le avventure testuali e con l[']interfaccia a collegamenti ipertestuali, puoi interrompere il tutorial scrivendo [t]TUTORIAL OFF[x][italic type].)[roman type]".
the teach looking rule response (B) is "guarda".

the teach examining rule response (A) is "[italic type]Anche i singoli oggetti hanno delle descrizioni. Puoi scoprire qualcosa di più su di essi esaminandoli, come per esempio con [t]ESAMINA [N in upper case][x][italic type].[roman type]".
the teach examining rule response (B) is "esamina [N]".

the teach taking rule response (A) is "[italic type]Puoi raccogliere oggetti, quando li vedi, scrivendo [t]PRENDI [N in upper case][x][italic type].[roman type]".
the teach taking rule response (B) is "prendi [N]".

the teach inventory rule response (A) is "[italic type]Ora risulta che hai qualcosa in mano. Per scoprire cosa trasporti o cosa indossi, scrivi [t]INVENTARIO[x][italic type].[roman type]".
the teach inventory rule response (B) is "inventario".

the teach dropping rule response (A) is "[italic type]Se vuoi liberarti di qualcosa che hai in mano, puoi sempre abbandonarla, scrivendo [t]LASCIA [N in upper case][x][italic type].[roman type]".
the teach dropping rule response (B) is "lascia [N]".

the teach taking off rule response (A) is "[italic type]Puoi toglierti gli oggetti indossati, scrivendo [t]TOGLI [N in upper case][x][italic type].[roman type]".
the teach taking off rule response (B) is "togli [N]".

the teach wearing rule response (A) is "[italic type]Puoi anche indossare gli oggetti, scrivendo [t]INDOSSA [N in upper case][x][italic type].[roman type]".
the teach wearing rule response (B) is "indossa [N]".

the teach extracting rule response (A) is "[italic type]Alcuni oggetti possono essere collocati all[']interno di contenitori, come per esempio [the example-contained] [inp the example-container][italic type]. Se vuoi prenderli, scrivi normalmente [t]PRENDI [N in upper case][x][italic type].[roman type]".
the teach extracting rule response (B) is "prendi [N]".

the teach inserting into rule response (A) is "[inp the example-container]".
the teach inserting into rule response (B) is "[italic type]Se vuoi riporre un oggetto in un contenitore, puoi scrivere [t]METTI [N in upper case] [N1 in upper case][x][italic type].[roman type]".
the teach inserting into rule response (C) is "metti [N] [N1]".

the teach hailing rule response (A) is "[italic type]Se vuoi iniziare a conversare con qualcuno, puoi scrivere [t][N in upper case], SALVE[x][italic type].[roman type]".
the teach hailing rule response (B) is "[N], salve".

the teach asking about rule response (A) is "[dip the example-argument]".
the teach asking about rule response (B) is "[italic type]Se vuoi chiedere particolari informazioni, puoi scrivere [t]CHIEDI [N in upper case][x][italic type].[roman type]".
the teach asking about rule response (C) is "chiedi [N]".

the teach goodbye rule response (A) is "[italic type]Se vuoi interrompere una conversazione noiosa, ti puoi congedare scrivendo [t]ADDIO[x][italic type].[roman type]".
the teach goodbye rule response (B) is "addio".

the teach compass directions rule response (A) is "[italic type]Per spostarti da un luogo all[']altro, puoi usare le direzioni della bussola (NORD, SUD, EST, OVEST, così come NORDEST, NORDOVEST, ecc.).[line break]Prova a scrivere [d][N in upper case][x][italic type].[roman type]".
the teach compass directions rule response (B) is "[N]".

the teach meta-features rule response (A) is "[italic type]Questo tutorial copre i comandi principali, ma ci sono tanti altri verbi che puoi scrivere mentre procedi e dovresti essere in grado di intuire quali sono dal contesto. Non temere di sperimentare nuove azioni.[paragraph break]Inoltre, puoi anche utilizzare i collegamenti ipertestuali che compaiono sotto la linea di comando e consentono un accesso rapido alle azioni di uso più comune.[paragraph break]Per interrompere il gioco, scrivi [t]SMETTI[x][italic type]; per salvare la tua attuale posizione, scrivi [t]SALVA[x][italic type]. [t]CARICA[x][italic type] permette di ripristinare un gioco salvato in precedenza e [t]RICOMINCIA[x][italic type] fa ripartire il gioco dall[']inizio.[roman type]".

Table of Instruction Followups (replaced)
selector	followup
teach looking rule	"Eccellente! GUARDA (anche abbreviato in L, dall[']inglese 'Look') stamperà una descrizione dell[']ambiente, come questa:"
teach examining rule	"Molto bene. Siccome esaminerai oggetti frequentemente, puoi abbreviare il comando con X (dall[']inglese 'eXamine').[line break]Come puoi notare, determinate parole sono evidenziate con stili particolari e trasformate in collegamenti ipertestuali, come per esempio [the example-thing][italic type]. Questo significa che l[']oggetto può essere esaminato semplicemente scrivendone il nome, cioè addirittura omettendo la X.[line break]Infine, per facilitare il giocatore, possono comparire subito dopo la descrizione, sotto forma di collegamenti ipertestuali, alcuni suggerimenti sulle azioni che è possibile eseguire sull[']oggetto esaminato.[line break]Ecco la descrizione dell[']oggetto:"
teach inventory rule	"Giusto! In seguito, puoi anche abbreviare il comando con INV, o semplicemente I. Come vedi, verrà stampata una descrizione di ciò che possiedi:"
teach dropping rule	"L[']azione di lasciare un oggetto avrà l[']effetto di spostarlo nell[']ambiente, come in questo caso:"
teach taking rule	"Ben fatto. Ora otterrai un messaggio che ti informerà sul fatto che hai raccolto [the example-thing][italic type] con successo:"
teach compass directions rule	"Bene! Come altri comandi molto usati, le direzioni della bussola possono essere abbreviate con N, S, E, O, NE, NO, e così via (oppure, dall[']inglese 'West', con W al posto di O). SU e GIU['] (ma anche U e D, dall[']inglese 'Up' e 'Down') sono pure possibili.[line break]Leggi attentamente le descrizioni delle stanze per capire quali direzioni sono accessibili. Inoltre, certe parole evidenziate in [d]questo modo[x][italic type] rappresentano porte o luoghi verso cui ci si può muovere: per farlo è sufficiente scrivere la parola corrispondente.[paragraph break]Appena entri in una stanza, otterrai una descrizione di ciò che contiene, come questa:"
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