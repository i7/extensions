Version 6/140613 of Measured Liquid IT by Leonardo Boselli begins here.

"Translation in italian of Version 6 of Measured Liquid by Emily Short.

Measured Liquid provides a concept of volume, together with the ability to fill containers, pour measured amounts of liquid, and drink from containers. It handles mixtures as well, if desired. It is compatible with, but does not require, the Metric Units extension by Graham Nelson."


Include Measured Liquid by Emily Short.


Chapter - Understands

Understand "di" as a fluid container.

Understand "vuoto" as a fluid container when the item described is patently empty.
Understand "chiuso" as a container when the item described is closed.


Understand "nuota in/nel/nello/nella/nei/negli/nelle/nell [something]" or "tuffati in/nel/nello/nella/nei/negli/nelle/nell [something]" as swimming in. Understand "nuota" or "tuffati" as swimming in.

Understand "devi da/dal/dallo/dalla/dai/dagli/dalle/dall [fluid container]" as drinking.

[Here we want Inform to prefer full liquid sources to other containers when it chooses an end to a player's unfinished or ambiguous command. And so:]

Understand "riempi [fluid container] con [full liquid source]" as filling it with. 
Understand "riempi il/lo/la/i/gli/le/l [fluid container] con il/lo/la/i/gli/le/l [full liquid source]" as filling it with. 
Understand "riempi [fluid container] con [non-empty fluid container]" as filling it with.
Understand "riempi il/lo/la/i/gli/le/l [fluid container] con il/lo/la/i/gli/le/l [non-empty fluid container]" as filling it with.
Understand "riempi [fluid container] con [fluid container]" as filling it with.
Understand "riempi il/lo/la/i/gli/le/l [fluid container] con il/lo/la/i/gli/le/l [fluid container]" as filling it with.

[Both grammar lines point to the same ultimate outcome; the purpose of specifying both is to tell Inform to check thoroughly for full liquid sources before falling back on other fluid containers when making its decisions.]

Understand "riempi [something] con [something]" as filling it with.
Understand "riempi il/lo/la/i/gli/le/l [something] con il/lo/la/i/gli/le/l [something]" as filling it with.

Understand "riempi [something]" as filling it with.
Understand "riempi il/lo/la/i/gli/le/l [something]" as filling it with.


Understand "versa [non-empty fluid container] in [fluid container]" as pouring it into. 
Understand "versa il/lo/la/i/gli/le/l [non-empty fluid container] in/nel/nello/nella/nei/negli/nelle/nell [fluid container]" as pouring it into. 
Understand "vuota [non-empty fluid container] in [fluid container]" as pouring it into.
Understand "vuota il/lo/la/i/gli/le/l [non-empty fluid container] in/nel/nello/nella/nei/negli/nelle/nell [fluid container]" as pouring it into.

Understand "versa [fluid container] in [fluid container]" as pouring it into. 
Understand "versa il/lo/la/i/gli/le/l [fluid container] in/nel/nello/nella/nei/negli/nelle/nell [fluid container]" as pouring it into. 
Understand "vuota [fluid container] in [fluid container]" as pouring it into.
Understand "vuota il/lo/la/i/gli/le/l [fluid container] in/nel/nello/nella/nei/negli/nelle/nell [fluid container]" as pouring it into.

Understand "versa [something] in [something]" as pouring it into. 
Understand "versa il/lo/la/i/gli/le/l [something] in/nel/nello/nella/nei/negli/nelle/nell [something]" as pouring it into. 
Understand "vuota [something] in [something]" as pouring it into.
Understand "vuota il/lo/la/i/gli/le/l [something] in/nel/nello/nella/nei/negli/nelle/nell [something]" as pouring it into.

Chapter - Additional Verbs

In italian restare is a verb.
In italian offrire is a verb.
In italian riempire is a verb.
In italian vuotare is a verb.
[da sistemare]
In italian contienere is a verb.
[da sistemare]
In italian puliscere is a verb.
[da sistemare]
In italian vuoere is a verb.
[da sistemare]
In italian bevere is a verb.

To say pulito:
	say "pulit[o-agg]".
To say lavato:
	say "lavat[o-agg]".
To say pieno:
	say "pien[o-agg]".
To say mezzo:
	say "mezz[o-agg]".
To say versato:
	say "versat[o-agg]".

Chapter - Responses

    can't put solids into a fluid container rule response (A) is "[The second noun] [puoi] contenere solo liquidi.".
    can't stash full cups rule response (A) is "[regarding nothing][maiuscolo][Puoi][maiuscolo] causare versamenti.".
    prefix empties rule response (A) is "[regarding the noun][vuoto] ".
    plural prefix empties rule response (A) is "[regarding the noun][vuoto] ".
    prefix closedness rule response (A) is "[regarding the noun][chiuso] ".
[
    suffix with contents rule response (A) is " di [liquid of the target]".
    plural suffix with contents rule response (A) is " di [liquid of the target]".
]
    clean away traces rule response (A) is "[regarding nothing][maiuscolo][Sei][maiuscolo] difficile pulire [the noun] poiché [contieni] ancora molto.".
    clean away traces rule response (B) is "[The actor] [pulisci] tutte le tracce di [liquid of the noun].".
    clean away traces rule response (C) is "[The noun] [sei] già [pulito].".
    report filling from a liquid source rule response (A) is "[regarding the player][maiuscolo][Riempi][maiuscolo] [the second noun] con [the liquid of the noun] [dip the noun].".
    report someone filling from a liquid source rule response (A) is "[The actor] [riempi] [the second noun] con [the liquid of the noun] [dip the noun].".
    dumping fluids rule response (A) is "[The noun] [sei] già [vuoto].".
    dumping fluids rule response (B) is "[regarding the player][maiuscolo][Vuoti][maiuscolo] [the noun] [inp the second noun].".
    dumping fluids rule response (C) is "[The actor] [vuoti] [the noun] [inp the second noun].".
    can't throw objects in a liquid source rule response (A) is "[The noun] andrebbe disperso.". [LEO consider story tenses]
    try to swim in visible lakes rule response (A) is "Non [regarding nothing][ci sei] nulla in cui nuotare.".
    block swimming in liquid lakes rule response (A) is "[Ora] non [regarding the player][vuoi] nuotare.".
    block swimming in small vessels rule response (A) is "Non [regarding the player][puoi] entrare [inp the noun].".
    block swimming in random objects rule response (A) is "Non si [regarding nothing][puoi] nuotare [inp the noun].".
    no dumping in streams rule response (A) is "[The noun] [sei] già [vuoto].".
    no dumping in streams rule response (B) is "[regarding the player][maiuscolo][Vuoti][maiuscolo] [the noun] [inp the second noun], dove [regarding the noun][sei] [lavato] via velocemente.".
    no dumping in streams rule response (C) is "[The actor] [vuoti] [the noun] [inp the second noun], dove [regarding the player][sei] [lavato] via velocemente.".
    no inserting things into flowing water rule response (A) is "[The second noun] non [puoi] contenere oggetti.".
    report filling from a liquid stream rule response (A) is "[regarding the player][maiuscolo][Riempi][maiuscolo] [the second noun] [dap the noun].".
    examining fluid containers rule response (A) is "[The noun] [fill description of the noun]".
    examining fluid containers rule response (B) is " [description of the liquid of the noun]".
    examining fluid containers rule response (C) is "[paragraph break]".
    just examine fluid containers rule response (A) is "[The noun] [fill description of the noun][paragraph break]".
    describe sources rule response (A) is "[regarding the sample lake][offri] una sorgente di [liquid of the sample lake].[no line break]".
    describe empty containers rule response (A) is "[regarding the sample cup]non [contieni] nulla.[no line break]".
    describe empty containers rule response (B) is "[regarding the sample cup]non [contieni] tracce di liquido.[no line break]".
    describe empty containers rule response (C) is "[regarding the sample cup][contieni] solo tracce di [liquid of the sample cup] al fondo.[no line break]".
    describe graduated containers rule response (A) is "[regarding the sample cup][contieni] [the fluid content of the sample cup] di [liquid of the sample cup].[no line break]".
    describe ungraduated containers rule response (A) is "[sei]".
    describe ungraduated containers rule response (B) is " [pieno]".
    describe ungraduated containers rule response (C) is " quasi [vuoto]".
    describe ungraduated containers rule response (D) is " quasi [pieno]".
    describe ungraduated containers rule response (E) is " [mezzo] [pieno]".
    describe ungraduated containers rule response (F) is " di [liquid of the sample cup].[no line break]".
    can't drink from closed sources rule response (A) is "(prima [regarding the player][apri] [the noun])[command clarification break]".
    prefer to carry drink sources rule response (A) is "(prima [regarding the player][prendi] [the noun])[command clarification break]".
    can't drink things that aren't fluids rule response (A) is "Non [regarding the player][puoi] bere [the noun].".
    can't drink from empty containers rule response (A) is "[The noun] [sei] completamente [vuoto].".
    can't drink from empty containers rule response (B) is "[The noun] non [contieni] più [liquid drunk].".
    can't drink noxious containers rule response (A) is "Non [regarding the player][puoi] bere [liquid drunk].".
    standard report drinking rule response (A) is "[regarding the player][maiuscolo][Bevi][maiuscolo] un sorso di [liquid drunk][if the noun is empty], lasciando [the noun] [vuoto][end if]".
    standard report drinking rule response (B) is ". [flavor of the liquid drunk][paragraph break]".
    standard report drinking rule response (C) is ".".
    standard report someone drinking rule response (A) is "[The actor] [bevi] un sorso di [liquid drunk][if the noun is empty], lasciando [the noun] [vuoto][end if].".
    can't taste noxious containers rule response (A) is "Non [regarding the player][puoi] bere [liquid drunk].".
    can't drink from shut containers rule response (A) is "(prima [regarding the player][apri] [the noun])[command clarification break]".
    report flavors of drinks rule response (A) is "[flavor of the liquid of the noun][paragraph break]".
    assume matching source rule response (A) is "[regarding the player][maiuscolo][Devi][maiuscolo] riempire [the noun] con qualcosa di specifico.".
    assume matching source rule response (B) is "Occorre specificare con cosa riempire [the noun].".
    can't pour from a closed noun rule response (A) is "(prima [regarding the player][apri] [the noun])[command clarification break]".
    can't pour into a closed noun rule response (A) is "(prima [regarding the player][apri] [the second noun])[command clarification break]".
    can't pour two untouched things rule response (A) is "(prima [regarding the player][prendi] [the noun])[command clarification break]".
    can't pour two untouched things rule response (B) is "(prima [regarding the player][prendi] [the second noun])[command clarification break]".
    can't pour two untouched things rule response (C) is "[regarding the player][maiuscolo][Devi][maiuscolo] reggere almeno uno tra [the noun] o [the second noun].".
    can't pour without fluid containers rule response (A) is "Non [regarding the player][puoi] versare [the noun].".
    can't pour without fluid containers rule response (B) is "Non [regarding the player][puoi] versare liquidi [inp the second noun].".
    no pouring something into itself rule response (A) is "Non [regarding the player][puoi] versare [the noun] dentro se [stesso].".
    can't pour empties rule response (A) is "Non resta [liquid poured] [inp the noun].".
    can't pour empties rule response (B) is "[The noun] [sei] completamente [vuoto].".
    can't overfill rule response (A) is "[The second noun] non [puoi] contenere più di quanto già [contieni].".
    standard report pouring rule response (A) is "[regarding the player][maiuscolo][Riempi][maiuscolo] [the second noun] con [the liquid poured]".
    standard report pouring rule response (B) is "[regarding the player][maiuscolo][Vuoti][maiuscolo] [the liquid poured] [inp the second noun]".
    standard report pouring rule response (C) is "[if the noun is empty], lasciandolo [the noun] [vuoto][end if]".
    standard report pouring rule response (D) is ". [run paragraph on]".
    standard report pouring rule response (E) is "[regarding the second noun][Essi] [fill description of the second noun][paragraph break]".
    standard report pouring rule response (F) is ".".
    standard report someone pouring rule response (A) is "[The actor] [riempi] [the second noun] con [the liquid poured]".
    standard report someone pouring rule response (B) is "[The actor] [vuoti] [the liquid poured] [inp the second noun]".
    standard report someone pouring rule response (C) is "[if the noun is empty], lasciandolo [the noun] [vuoto][end if]".
    standard report someone pouring rule response (D) is ". [run paragraph on]".
    standard report someone pouring rule response (E) is ".".
    explain unsuccessful pouring rule response (A) is "[The actor] non [puoi] versare [dap the noun] when [sei] [chiuso].".
    explain unsuccessful pouring rule response (B) is "[The actor] non [puoi] mettere [the noun] e [the second noun] nella giusta posizione per versare.".
    explain unsuccessful pouring rule response (C) is "[The noun] non [sei] qualcosa che [puoi] essere [versato].".
    explain unsuccessful pouring rule response (E) is "[The second noun] non [sei] qualcosa che [puoi] essere [versato].".
    explain unsuccessful pouring rule response (F) is "[The actor] non [puoi] versare [the noun] dentro se [stesso].".
    explain unsuccessful pouring rule response (G) is "Non [regarding nothing][resti] [liquid of the noun] [inp the noun].".
    explain unsuccessful pouring rule response (H) is "[The second noun] non [puoi] contenere più di quanto già [contieni].".
    explain unsuccessful pouring rule response (I) is "[The liquid-mixture refusal][paragraph break]".
    explain unsuccessful drinking rule response (A) is "[The noun] non si [puoi] bere.".
    explain unsuccessful drinking rule response (B) is "[The noun] non [contieni] nulla.".
    explain unsuccessful drinking rule response (C) is "[The actor] non [puoi] bere [liquid of the noun].".


Measured Liquid IT ends here.

---- Documentation ----

Read the original documentaion of Version 6 of Measured Liquid by Emily Short.
