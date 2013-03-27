Version 9 of Reactable Quips IT by Leonardo Boselli begins here.

"Un approccio basato su tabolo per le conversazioni con gli NPC. L'unica modifica è la traduzione in italiano."

"basato su Version 9 of Reactable Quips by Michael Martin."

Section 1 - Quips

A quip is a kind of value.  The quips are defined by the Table of Quip Texts.  The specification of quip is "Represents a line or exchange of dialogue, which may be linked to other quips via followups or linked to ask or tell responses."

The current quip is a quip that varies. The current quip is quip_null.
The pertinent quip is a quip that varies.  The pertinent quip is quip_null.

A person has a quip called default ask quip. The default ask quip of a person is usually quip_null.
A person has a quip called default tell quip. The default tell quip of a person is usually quip_dtell.

Quipping is an activity.  The last for quipping rule (this is the basic quipping rule): say "[quiptext of the current quip][paragraph break]";

To deliver the (q - quip) quip:
	change the current quip to q;
	carry out the quipping activity;
	let rq_index be 0;
	repeat through Table of Quip Followups:
		if the current quip is the quip entry:
			increase rq_index by 1;
			say "[bracket][rq_index][close bracket] [option entry][line break]";
	if rq_index is not 0:
		change the pertinent quip to the current quip;
		change the number understood to 0;
	otherwise:
		change the pertinent quip to quip_null.

To nest the (q - quip) quip:
	let x be the current quip;
	change the current quip to q;
	carry out the quipping activity;
	change the current quip to x.

To decide whether RQ is active:
	If the pertinent quip is quip_null, no;
	yes.

Requesting a recap is an action out of world applying to nothing.  Understand "ripeti" or "ricapitola" as requesting a recap when RQ is active.

Carry out requesting a recap (this is the perform recap rule):
	let rq_index be 0;
	repeat through Table of Quip Followups:
		if the quip entry is the pertinent quip:
			increase rq_index by 1;
			if rq_index is 1, say "Le opzioni disponibili sono:[paragraph break]";
			say "[bracket][rq_index][close bracket] [option entry][line break]";
	if rq_index is 0, say "[bracket]Non ci sono risposte disponibili.[close bracket][paragraph break]".

Responding with is an action applying to one number.
Understand "[number]" or "dì [number]" as responding with when RQ is active.

[This rule Can't Run, as the Understand commands stand..]
[Carry out responding with when the pertinent quip is quip_null (this is the can't talk out of conversations rule): 
  say "[bracket]BUG: Responded despite there being no conversation options available![close bracket]".]

[Likewise, this test is redundant.]
Carry out responding with [when the pertinent quip is not quip_null] (this is the perform responding rule):
	let rq_index be 0;
	repeat through Table of Quip Followups:
		if the quip entry is the pertinent quip:
			increase rq_index by 1;
			if rq_index is the number understood:
				deliver the result entry quip;
				rule succeeds;
	say "[bracket]La risposte valide sono comprese tra 1 e [rq_index].  Scrivi RIPETI per elencare le opzioni.[close bracket][paragraph break]".

Before doing something [other than requesting a recap or responding with] when the pertinent quip is not quip_null (this is the force conversation rule):
	unless the current action is requesting a recap or the current action is responding with:
		say "[bracket]Ho bisogno di qualche tipo di rezione da parte tua per continuare la scena.  Inserisci un numero, o scrivi RIPETI per elencare le opzioni disponibili.[close bracket][paragraph break]";
		stop the action.

The force conversation rule is listed first in the before rules.

A procedural rule when RQ is active:
	ignore the every turn stage rule;
	ignore the timed events rule;
	ignore the advance time rule;
	ignore the update chronological records rule.

Section 2 - Hitword-based conversation

Instead of asking someone about something: 
	repeat through Table of Ask Results:
		if the noun is the NPC entry:
			if the topic understood includes topic entry:
				deliver the result entry quip;
				rule succeeds; 
	if the noun is a person:
		say "[quiptext of the default ask quip of the noun][paragraph break]"; 
		rule succeeds; 
	say "[bracket]BUG: Managed to talk to [a noun], who is not a person![close bracket]".

Telling someone about something is reactable quips speech.
Answering someone that something is reactable quips speech.

Instead of reactable quips speech: 
	repeat through Table of Tell Results:
		if the noun is the NPC entry:
			if the topic understood includes topic entry:
				deliver the result entry quip;
				rule succeeds; 
	if the noun is a person:
		say "[quiptext of the default tell quip of the noun][paragraph break]"; 
		rule succeeds; 
	say "[bracket]BUG: Managed to talk to [a noun], who is not a person![close bracket][paragraph break]"

Section 3 - Quip Tables

Table of Quip Texts
quip		quiptext
quip_null	"Non ti viene in mente nulla da dire sull[']argomento."
quip_dtell	"Non ti viene in mente nulla da dire sull[']argomento."

Table of Quip Followups
quip		option		result
a quip		text		a quip

Table of Ask Results
NPC		topic		result
a person		a topic		a quip

Table of Tell Results
NPC		topic		result
a person		a topic		a quip

Section 4 - Straightening out the parser

To rq_fixerror: (- etype = STUCK_PE; -)

Before printing a parser error when RQ is active and the parser error is didn't understand that number:
  rq_fixerror.

Reactable Quips IT ends here.

---- DOCUMENTATION ----

Consulta la documentazione originale di Version 9 of Reactable Quips by Michael Martin.
