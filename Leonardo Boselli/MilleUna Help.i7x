Version 1/140824 of MilleUna Help by Leonardo Boselli begins here.

"The part of the MilleUna Framework that manages help, tutorials and so on."

Include Configurable Creative Commons License by Leonardo Boselli.
Include Basic Help Hyperlinks by Leonardo Boselli.
Include Tutorial Mode Hyperlinks by Leonardo Boselli.

Chapter 1 - Help

Section - Hyperlink Introduction
 
Table of Basic Help Options (continued)
title	subtable	description 
"[bold type]Hyperlinks[roman type]"	--	"[show-interf-message]"

To say show-interf-message:
	 follow the Hyperlink Interface showing the hyperlink introduction text rule.

Section - MilleUna Introduction

Table of Basic Help Options (continued)
title	subtable	description 
"[bold type]How it was written[roman type]"	--	"[show-milleuna-message]"

To say show-milleuna-message:
	 follow the MilleUna Framework showing the milleuna introduction text rule.

Showing the milleuna introduction text is an activity.

For showing the milleuna introduction text (this is the MilleUna Framework showing the milleuna introduction text rule):
	say "[line break]This interactive fiction was written with 'Inform 7' ([if FOR-WEB is true]<a href='http://inform7.com' target='_blank'>http://inform7.com</a>[otherwise]http://inform7.com[end if]) and the aid of 'MilleUna Framework', a collection of extensions put togheter by [if FOR-WEB is true]<a href='http://google.com/+LeonardoBoselli' target='_blank'>Leonardo Boselli</a>[otherwise]Leonardo Boselli[end if]. To know more about the development of interactive fiction, follow the tutorials and the examples available at [if FOR-WEB is true]<a href='http://youdev.it/milleuna' target='_blank'>http://youdev.it/milleuna</a>[otherwise]http://youdev.it/milleuna[end if].[run paragraph on]" (A);

Section - Acknowledgements

Table of Basic Help Options (continued)
title	subtable	description 
"To contact the author"	--	"[ask-for-help]"
"Acknowledgements"	--	"[acknowledgements]"

To say author's email: say "unavailable".
To say ask-for-help:
	say "[paragraph break]Do you need help?[line break]My email address is [bold type][author's email][roman type]".

To say acknowledgements:
	say "[paragraph break]Many thanks to:[line break][thank-newsgroup][thank-people]";
	
To say thank-newsgroup:
	say "The videogames portal [bold type]Old Games Italia [italic type]oldgamesitalia.net[roman type]".

To say thank-people:
	say "[line break][bold type]Graham Nelson[roman type] for the development of Inform 7[line break][bold type]Andrew Plotkin[roman type] for the development of Glulx and Quixe[line break][bold type]Massimo Stella[roman type] for the 'Italian Language' extension[line break][bold type]Mark Tilford[roman type] for many extensions[line break][bold type]Aaron Reed[roman type] for many extensions[line break][bold type]Emily Short[roman type] for many extensions[line break][bold type]Jon Ingold[roman type] for many extensions[line break][bold type]Eric Eve[roman type] for many extensions"


Chapter END

MilleUna Help ends here.

---- Documentation ----

This is part of MilleUna Framework, that contains all is needed to write interactive fiction readable online and playable clicking hyperlinks.
Visit http://youdev.it/milleuna to know more.