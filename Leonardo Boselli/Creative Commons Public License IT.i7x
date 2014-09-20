Version 2 of Creative Commons Public License IT by Leonardo Boselli begins here.

"Un'estensione in italiano per facilitare il rilascio di 'interactive fiction' secondo la Creative Commons License v25. Basata sull'estensione GNU General Public License v3 di Otis T. Dog."

[
This Inform 7 extension is Copyright (C) 2009 by Leonardo Boselli.
   
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

The author grants permission to anyone who wishes to expand or
improve this extension in a manner consistent with the GPL v3 or later.
The author can be reached via email at tetractys@users.sf.net.
]

Chapter 1 - Text to Display

Section 1 - The recommended announcement banner for use at startup (for use without Hyperlink Interface IT by Leonardo Boselli)

To announce the CCL:
	say "[bold type]Copyright © [story creation year] [story author][roman type][line break]";
	say "[italic type]Quest[']opera è fornita SENZA ALCUNA GARANZIA e può[line break]";
	say "essere ridistribuita rispettando determinate condizioni:[line break]";
	say "per i dettagli scrivi [bold type]garanzia[roman type][italic type] o [bold type]licenza.[roman type][paragraph break]";
	[say "[bold type]'[story title]' di [story author][roman type][paragraph break]";]

Section H (for use with Hyperlink Interface IT by Leonardo Boselli)

To announce the CCL:
	say "[bold type]Copyright © [story creation year] [story author][roman type][line break]";
	say "[italic type]Quest[']opera è fornita SENZA ALCUNA GARANZIA e può[line break]";
	say "essere ridistribuita rispettando determinate condizioni:[line break]";
	say "per i dettagli scrivi [o]garanzia[x][italic type] o [o]licenza[x].[paragraph break]";
	[say "[bold type]'[story title]' di [story author][roman type][paragraph break]".]

Section 2 - The recommended warranty text

To display the warranty:
	say "[line break]Quest[']opera può essere ridistribuita nei termini della CREATIVE COMMONS PUBLIC LICENSE versione 2.5. E['] fornita nella speranza che venga utilizzata, ma SENZA ALCUNA GARANZIA, neppure quella implicita di ESSERE ADATTA AD UNO SCOPO PARTICOLARE.[paragraph break]"

Section 3 - The extremely long license text, with preamble

To display the CCL:
	say "[line break][bold type]CREATIVE COMMONS PUBLIC LICENSE[roman type] version 2.5[paragraph break]";
	say "Quest'opera è soggetta alla [italic type]Creative Commons Public License[roman type] versione 2.5 o posteriore. L'enunciato integrale della licenza in versione 2.5 è reperibile all'indirizzo internet: http://creativecommons.org/licenses/by-nc-nd/2.5/deed.it[paragraph break]";
	say "Si è liberi di riprodurre, distribuire, comunicare al pubblico, esporre, in pubblico, rappresentare, eseguire e recitare quest'opera alle seguenti condizioni:[paragraph break]";
	say "[bold type]Attribuzione[roman type][line break]";
	say "Bisogna attribuire la paternità dell'opera nei modi indicati dall'autore.[paragraph break]";
	say "[bold type]Non commerciale[roman type][line break]";
	say "Non si può usare quest'opera per fini commerciali.[paragraph break]";
	say "[bold type]Non opere derivate[roman type][line break]";
	say "Non si può alterare o trasformare quest'opera, né usarla per crearne un'altra.[paragraph break]";
	say "Ogni volta che si usa o si distribuisce quest'opera, lo si deve fare secondo i termini di questa licenza, che va comunicata con chiarezza.[paragraph break]";
	say "In ogni caso si possono concordare con il titolare dei diritti d'autore, utilizzi di quest'opera non consentiti da questa licenza.[paragraph break]".

Chapter 2 - Rules for Displaying Text

Section 1 - Creative Commons announcement

When play begins (this is the CCL's recommended announcement at startup rule), announce the CCL.

[The CCL's recommended announcement at startup rule is listed first in the when play begins rulebook.]

Section 2 - The "garanzia" command

Showing the warranty is an action out of world applying to nothing. Understand "garanzia" as showing the warranty.

Carry out showing the warranty:
	display the warranty.

Section 3 - The "license command"

Showing the CCL is an action out of world applying to nothing. Understand "licenza" as showing the CCL.

Carry out showing the CCL:
	display the CCL.
  
Creative Commons Public License IT ends here.

---- DOCUMENTATION ---- 

version 1.00

Questa estensione è molto semplice:
  1) crea un comando "garanzia" che mostra la garanzia durante il gioco
  2) crea un comando "licenza" che mostra la licenza durante il gioco
  3) mostra un breve annuncio all'inizio del gioco
