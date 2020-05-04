Version 9/140531 of Keyword Interface IT by Leonardo Boselli begins here.

"Translation in italian of Version 9/140501 of Keyword Interface by Aaron Reed.

This extension emulates Blue Lacuna's emphasized keyword system for simplifying common IF input. Nouns, directions, and topics can be typed without a verb to examine, go, or discuss. Works with Glulx or z-code."

Include Keyword Interface by Aaron Reed.

Chapter - Commands

Understand "parole chiave" as setting the keyword emphasis.
Understand "uscite" as listing exits. 
Understand "oggetti" as thing listing.

Chapter - Responses

    setup keyword emphasis rule response (A) is "'[story title]' usa l[']enfatizzazione delle parole chiave. [if keywords required is true]È necessario[else]Si raccomanda[end if] che l[']interprete le mostri con qualche forma d[']enfatizzazione. Premi uno dei numeri per variare le opzioni di visualizzazione finché non trovi una combinaione che risulti chiara.".
    setup keyword emphasis rule response (B) is "L[']enfatizzazione degli [o]oggetti[x] appare così.".
    setup keyword emphasis rule response (C) is "L[']enfatizzazione delle [d]uscite[x] appare così.".
    setup keyword emphasis rule response (D) is "L[']enfatizzazione degli [t]argomenti[x] appare così.".
    setup keyword emphasis rule response (E) is "[as the parser]I messaggi del sistema appaiono così[as normal].".
    setup keyword emphasis rule response (F) is "[line break]**Attenzione: Le parole chiave fanno parte integrante del design di '[story title]'. Progredire nella storia può diventare difficile o addirittura impossibile se l[']enfatizzazione non è visibile.**".
    setup keyword emphasis rule response (G) is "[line break]**Attezione: Può essere utile distinguere un tipo di parola chiave dall[']altra.**".
    setup keyword emphasis rule response (H) is "[paragraph break]Premi 0 per terminare, oppure 9 per [if screen reader mode is true]dis[end if]attivare la modalità di lettura schermo.[run paragraph on]".
    setup keyword emphasis rule response (I) is "Premi un tasto per continuare.".
    Keyword Interface carry out setting screen reader mode rule response (A) is "La modalità di lettura schermo è stata attivata.".
    Keyword Interface carry out setting screen reader mode rule response (B) is "La modalità di lettura schermo è stata disattivata. '[story title]' usa l[']enfatizzazione delle parole chiave per indicare parole importanti che possono essere digitate per progredire nella storia. Il tuo lettore potrebbe porre un[']enfasi riconoscibile nel pronunciare parole enfatizzate come [o]questa[x]. Se non lo facesse, puoi scrivere il comando [o]oggetti[x] per ottenere la lista degli oggetti vicini, o scrivere [d]uscite[x] per la lista delle direzioni. Scrivi [o]parole chiave[x] per modificare lo stile delle parole chiave, o scrivi screen reader senza spazi per attivare o disattivare questa modalità.".
    Keyword Interface carry out listing exits rule response (A) is "Non [regarding nothing][ci sei] nessuna uscita.".
    Keyword Interface carry out listing exits rule response (B) is "Da [qui] [if the number of viable directions is 1]l'unica uscita [regarding nothing][sei][otherwise][puoi] andare[end if] verso [list of viable directions].".

To decide which number is list-plurality of the (list - a list of objects):
	let list-number be 0; [0: singular, 1: plural]
	if the number of entries in the list is greater than 1:
		decide on 1;
	if entry 1 in the list is plural-named:
		decide on 1;
	decide on 0;

    Keyword Interface carry out thing listing rule response (A) is "Nelle vicinanze [regarding nothing][if the number of visible other things which are not carried by the player is 0]non [ci sei] nulla d[']interessante[otherwise if list-plurality of the list of visible other things which are not carried by the player is 1][ci sono] [list of visible other things which are not carried by the player with indefinite articles][otherwise][ci sei] [a entry 1 of list of visible other things which are not carried by the player][end if].".
    Keyword Interface setup trigger rule response (A) is "'[o][story title][x]' di [story author][if release number > 0], release [release number][end if].[paragraph break]Se nessuna parola qui sopra risulta colorata o enfatizzata, premi K.[paragraph break]Premi [t]N[x] per cominciare dall[']inizio o [t]R[x] per continuare una storia già iniziata.".
    Keyword Interface not a verb I recognise rule response (A) is "[as the parser]Non è un[']azione nota e neppure una parola chiave che, al momento, possa essere utilizzata.[as normal]".
    Keyword Interface showing the keyword introduction text rule response (A) is "Mentre leggi '[story title]', nel testo noterai determinate parole chiave enfatizzate. Scrivi una qualsiasi parola chiave per progredire nella storia. [if object keyword highlighting is true]Puoi scrivere la parola chiave di un [o]object[x] enfatizzato per esaminarlo. [end if][if direction keyword highlighting is true]Una [d]direzione[x] enfatizzata indica che scrivendo quella parola ti muoverai in quella direzione or verso quel distante scenario. [end if][if topic keyword highlighting is true]Una parola enfatizzata in una [t]conversazione[x] significa che, scrivendo quella parola, la discussione verrà condotta verso quell'argomento. [end if][paragraph break]Se, nel paragrafo precedente, [if the number of active keyword systems > 1]le parole chiave non si distinguono[else]la parola chiave non si distingue[end if], scrivi PAROLE CHIAVE per modificare lo stile di visualizzazione.".

Keyword Interface IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 9/140501 of Keyword Interface by Aaron Reed.
