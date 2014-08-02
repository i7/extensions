Version 9/140604 of Hyperlink Interface IT (for Glulx only) by Leonardo Boselli begins here.

"Translation in italian of Version 9/140604 of Hyperlink Interface (for Glulx only) by Leonardo Boselli.

This extension emulates Blue Lacuna's emphasized hyperlink system for simplifying common IF input (by Aaron Reed) substituting emphasis with hyperlinks. Nouns, directions, and topics can be clicked directly to examine, go, or discuss.

Heavily based on Keyword Interface by Aaron Reed.

Requires Basic Hyperlinks by Emily Short and Text Capture by Eric Eve."


Include Hyperlink Interface by Leonardo Boselli.


Chapter - Setup

Understand "menù" as showing hyperlinks menu.

Chapter - Commands

Section - Exits

Understand "uscite" as listing exits

Section - Things

Understand "oggetti" as thing listing.


Chapter - Responses

    show hyperlinks menu rule response (A) is "[line break][fixed letter spacing]|[set link 2]guarda[end link]|[set link 3]inventario[end link]|".
    show hyperlinks menu rule response (B) is "[set link 4]argomenti[end link]|".
    show hyperlinks menu rule response (C) is "[set link 5]oggetti[end link]|".
    show hyperlinks menu rule response (D) is "[set link 6]uscite[end link]|".
    show hyperlinks menu rule response (E) is "[set link 7]x me[end link]|[set link 8]salva[end link]|[set link 9]carica[end link]|".
    show hyperlinks menu rule response (F) is "[roman type][line break]".
    initializing replacement commands list rule response (A) is "menù".
    initializing replacement commands list rule response (B) is "guarda".
    initializing replacement commands list rule response (C) is "inventario".
    initializing replacement commands list rule response (D) is "argomenti".
    initializing replacement commands list rule response (E) is "oggetti".
    initializing replacement commands list rule response (F) is "uscite".
    initializing replacement commands list rule response (G) is "x me".
    initializing replacement commands list rule response (H) is "salva".
    initializing replacement commands list rule response (I) is "carica".
    initializing replacement commands list rule response (J) is "zoom".
    initializing replacement commands list rule response (K) is "U".
    initializing replacement commands list rule response (L) is "N".
    initializing replacement commands list rule response (M) is "NE".
    initializing replacement commands list rule response (N) is "E".
    initializing replacement commands list rule response (O) is "SE".
    initializing replacement commands list rule response (P) is "S".
    initializing replacement commands list rule response (Q) is "SW".
    initializing replacement commands list rule response (R) is "W".
    initializing replacement commands list rule response (S) is "NW".
    initializing replacement commands list rule response (T) is "D".
    initializing replacement commands list rule response (U) is "[set link 2]guarda[end link] | [set link 3]inv[end link] | [set link 1]menù[end link]>".
    setup hyperlink emphasis rule response (A) is "[story title] fa uso di collegamenti ipertestuali evidenziati. È [if hyperlinks required is true]necessario[else]raccomandato[end if] che l'interprete li visualizzi correttamente con qualche forma di evidenziazione. Premi il numero corrispondente per cambiare le opzioni di visualizzazione finché non trovi quella che risulta più chiara sul tuo sistema.".
    setup hyperlink emphasis rule response (B) is "I collegamenti ipertestuali agli [o]oggetti[x] vengono visualizzati [o]così[x].".
    setup hyperlink emphasis rule response (C) is "I collegamenti ipertestuali alle [d]uscite[x] vengono visualizzati [d]così[x].".
    setup hyperlink emphasis rule response (D) is "I collegamenti ipertestuali agli [t]argomenti[x] vengono visualizzati [t]così[x].".
    setup hyperlink emphasis rule response (E) is "[as the parser]I messaggi del parser vengono visualizzati così[as normal].".
    setup hyperlink emphasis rule response (F) is "[line break]**Attenzione: I collegamenti ipertestuali fanno parte integrante della storia. Può essere difficile, se non impossibile, sapere come continuare se le evidenziazioni non risultassero visibili.**".
    setup hyperlink emphasis rule response (G) is "[line break]**Attenzione: potrebbe essere utile riuscire a distinguere tra un tipo di collegamento ipertestuale e l[']altro.**".
    setup hyperlink emphasis rule response (H) is "[paragraph break]Premi 0 per concludere, o 9 per [if screen reader mode is true]dis[end if]attivare la modalità screen reader.[run paragraph on]".
    setup hyperlink emphasis rule response (I) is "Premi un tasto per continuare.".
    Hyperlink Interface carry out setting screen reader mode rule response (A) is "La modalità screen reader è stata disattivata.".
    Hyperlink Interface carry out setting screen reader mode rule response (B) is "La modalità screen reader è stata attivata. [story title] usa collegamenti ipertestuali evidenziati per segnalare parole importanti per poter progredire nella storia. Il tuo interprete potrebbe leggere con un[']enfasi particolare le parole come [o]questa[x]. Se non lo facesse, puoi scrivere la parola [o]oggetti[x] per ottenere una lista degli oggetti nelle vicinanze, o scrivere [d]uscite[x] per una lista delle direzioni possibili. Scrivi [o]hyperlinks[x] per modificare lo stile dei collegamenti ipertestuali, o scrivi screen reader, senza alcuno spazio, per attivare o disattivare questa modalità.".
    Hyperlink Interface carry out listing exits rule response (A) is "Non [regarding the player][puoi] andare da nessuna parte.".
    Hyperlink Interface carry out listing exits rule response (B) is "Da [qui], [regarding the player][puoi] andare verso [a list of viable directions].".
    Hyperlink Interface carry out thing listing rule response (A) is "Nelle vicinanze [regarding the player][if the number of visible other things which are not carried by the player is 0]non [vedi] nulla d[']interessante[otherwise][vedi] [a list of visible other things which are not carried by the player][end if].".
    Hyperlink Interface setup trigger rule response (A) is "Benvenuto a [o][story title][x][if release number > 0], release [release number][end if].[paragraph break]Se nessuna parola risulta colorata o evidenziata, premi K.[paragraph break]Premi [t]N[x] per cominciare dall[']inizio o [t]R[x] per continuare una storia già iniziata.".
    Hyperlink Interface not a verb I recognise rule response (A) is "[as the parser]Non è un[']azione nè una parola chiave che può essere utilizzata adesso[as normal].".
    Hyperlink Interface showing the hyperlink introduction text rule response (A) is "Leggendo [story title], vedrai nel testo un certo numero di collegamenti ipertestuali evidenziati. Clicca sui collegamenti per progredire nella storia. [if object hyperlink highlighting is true]Puoi cliccare un collegamento a un [o]oggetto[x] per esaminarlo. [end if][if direction hyperlink highlighting is true]Una [d]direzione[x] evidenziata indica che quella parola ti sposterà nella direzione specificata . [end if][if topic hyperlink highlighting is true]Un [t]argomento[x] di discussione evidenziato sposterà la conversazione verso quell[']argomento. [end if][paragraph break]Se [if the number of active hyperlink systems > 1]i collegamenti ipertestuali nelle righe qui sopra[otherwise]il collegamento ipertestuale nella riga qui sopra[end if] non spicca tra il testo che lo circonda, scrivi HYPERLINKS per modificarne lo stile.".

Hyperlink Interface IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 9/140604 of Hyperlink Interface (for Glulx only) by Leonardo Boselli.

