Version 2/140823 of Exit Lister IT by Leonardo Boselli begins here.

"Appends a list of exit directions and names any previously visited rooms at the end of a room description. Just italian responses here."

Include Exit Lister by Leonardo Boselli.


Section 4 - Status Bar

Table of No Exits Status (replaced)
left		central				right 
" [if map region of the location is not nothing][map region of the location] - [end if][if in darkness]nell[']oscurità[otherwise][location][end if]"	"| Punti: [score]/[maximum score]"	"| Passi: [turn count] | Stanze: [number of visited rooms]/[number of rooms]" 

Table of Exits Status (replaced)
left	central				right 
" Punti: [score]/[maximum score]"	"| Passi: [turn count]"	"| Stanze: [number of visited rooms]/[number of rooms]" 
" [if map region of the location is not nothing][map region of the location] - [end if][if in darkness]nell[']oscurità[otherwise][location][end if]"	""	"| [exit list]" 

Section - Commands

Understand "uscite off" as ExitStopping.
Understand "uscite on" as ExitStarting.
Understand "uscite" as ExitListing.

Chapter - Responses

looking exits rule response (A) is "Da [qui] [regarding the player][puoi] andare".
looking exits rule response (B) is "[if dir is not down and dir is not up] a[end if] [dir]".
looking exits rule response (C) is " attraverso [the direction-object]".
looking exits rule response (D) is " verso [the farplace]".
looking exits rule response (E) is " e".
the going nowhere replacement rule response (A) is "Non [regarding the player][puoi] andare in quella direzione.".
the exits listing rule response (A) is "Uscite: ".
the exits listing rule response (B) is "Nessuna".
the report exit stopping rule response (A) is "L[']elenco delle uscite è ora disabilitato.".
the report exit starting rule response (A) is "L[']elenco delle uscite è ora abilitato.".

Section H (for use with Hyperlink Interface by Leonardo Boselli)
  
the explain exit listing rule response (A) is "(Usa [t]USCITE OFF[x] per disabilitare l[']elenco delle uscite sulla barra di stato e [t]USCITE ON[x] per abilitarlo.)".
	
Section K (for use without Hyperlink Interface by Leonardo Boselli)

the explain exit listing rule response (A) is "(Usa USCITE OFF per disabilitare l[']elenco delle uscite sulla barra di stato e USCITE ON per abilitarlo.)".


Exit Lister IT ends here.

---- DOCUMENTATION ----

No documentation yet.
