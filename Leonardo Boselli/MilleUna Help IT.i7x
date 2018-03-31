Version 1/140824 of MilleUna Help IT by Leonardo Boselli begins here.

"The part of the MilleUna Framework that manages help, tutorials and so on. Translated in Italian."

Include Configurable Creative Commons License IT by Leonardo Boselli.
Include Basic Help Hyperlinks IT by Leonardo Boselli.
Include Tutorial Mode Hyperlinks IT by Leonardo Boselli.

Chapter 1 - Help

Section - Hyperlink Introduction
 
Table of Basic Help Options (continued)
title	subtable	description 
"[bold type]Collegamenti ipertestuali[roman type]"	--	"[show-interf-message]"

To say show-interf-message:
	 follow the Hyperlink Interface showing the hyperlink introduction text rule.

Section - MilleUna Introduction

Table of Basic Help Options (continued)
title	subtable	description 
"[bold type]Come è stato scritto[roman type]"	--	"[show-milleuna-message]"

To say show-milleuna-message:
	 follow the MilleUna Framework showing the milleuna introduction text rule.

Showing the milleuna introduction text is an activity.

For showing the milleuna introduction text (this is the MilleUna Framework showing the milleuna introduction text rule):
	say "[line break]Questa avventura testuale è stata scritta con 'Inform 7' ([if FOR-WEB is true]<a href='http://inform7.com' target='_blank'>http://inform7.com</a>[otherwise]http://inform7.com[end if]) e l[']aiuto del 'MilleUna Framework', un insieme di estensioni collezionate da [if FOR-WEB is true]<a href='http://google.com/+LeonardoBoselli' target='_blank'>Leonardo Boselli</a>[otherwise]Leonardo Boselli[end if]. Per saperne di più sullo sviluppo delle avventure testuali, segui i tutorial e gli esempi disponibili alla pagina [if FOR-WEB is true]<a href='http://youdev.it/milleuna' target='_blank'>http://youdev.it/milleuna</a>[otherwise]http://youdev.it/milleuna[end if].[run paragraph on]" (A)

Section - Acknowledgements

Table of Basic Help Options (continued)
title	subtable	description 
"Per contattare l[']autore"	--	"[ask-for-help]"
"Ringraziamenti"	--	"[acknowledgements]"

To say author's email: say "indisponibile".
To say ask-for-help:
	say "[paragraph break]Hai bisogno di aiuto?[line break]Il mio indirizzo è [bold type][author's email][roman type]".

To say acknowledgements:
	say "[paragraph break]Si ringraziano:[line break][thank-newsgroup][thank-people]";
	
To say thank-newsgroup:
	say "Il portale di videogiochi [bold type]Old Games Italia [italic type]oldgamesitalia.net[roman type]".

To say thank-people:
	say "[line break][bold type]Graham Nelson[roman type] per lo sviluppo di Inform 7[line break][bold type]Andrew Plotkin[roman type] per lo sviluppo di Glulx and Quixe[line break][bold type]Massimo Stella[roman type] per l[']estensione 'Italian Language'[line break][bold type]Mark Tilford[roman type] per varie estensioni[line break][bold type]Aaron Reed[roman type] per varie estensioni[line break][bold type]Emily Short[roman type] per varie estensioni[line break][bold type]Jon Ingold[roman type] per varie estensioni[line break][bold type]Eric Eve[roman type] per varie estensioni"


Chapter END

MilleUna Help IT ends here.

---- Documentation ----

This is part of MilleUna Framework, that contains all is needed to write interactive fiction readable online and playable clicking hyperlinks.
Visit http://youdev.it/milleuna to know more.