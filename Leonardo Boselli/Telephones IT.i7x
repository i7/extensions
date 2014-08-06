Telephones IT by Leonardo Boselli begins here.

"Telephones, standard and portable. Solo tradotto in italiano."

"based on Telephones by George Tryfonas."

A telephone is a kind of thing. A telephone has a number called the calling number. A telephone has a person
called the owner. A telephone can be inuse. A telephone is usually not inuse. Understand "telefono" as a telephone.

Understand "componi [a number]" as dialling it on. 
Understand "componi [a number] su/sul/sullo/sulla/sui/sugli/sulle/sull [something]" as dialling it on.
Understand the command "chiama" or "telefona" as "componi".

Connection relates one person to another (called the other party). 

The verb to reach (he reaches, they reach, it is reached) implies the connection relation.

Dialling it on is an action applying to one number and one visible thing.

The dialling it on action has an object called the line dialled.

Setting action variables for dialling (this is the set up dialling rule):
	repeat with item running through the list of telephones:
		if the calling number of the item is the number understood, now the line dialled is the item.

Check dialling it on (this is the can't dial on something that is not a telephone rule):
	if the second noun is not a telephone, say "Non essere stupido." instead;

Check dialling it on (this is the can't dial the calling number rule):
	if the number understood is the calling number of the second noun, say "È occupato." instead;

Check dialling it on (this is the can't dial an emergency number rule):
	if the number understood is a number listed in the Table of Misdialled Numbers, say "[the retort corresponding to a number of the number understood in the Table of Misdialled Numbers]" instead.

Check dialling it on (this is the can't dial an invalid numer rule):
	if the line dialled is nothing, say "Il telefono squilla ma nessuno risponde." instead.

Carry out dialling it on (this is the standard dialling rule):
	now the second noun is inuse;
	now the player reaches the owner of the line dialled.

Report dialling it on (this is the standard report dialling rule):
	say "'Pronto?' dice [the other party of the player] dall[']altro capo della linea.".

After deciding the scope of the player while the player reaches someone (this is the establish connection rule): 
	place the other party of the player in scope.

Instead of listening to a inuse telephone when the player reaches someone (this is the listening to a connected telephone rule): 
	say "Puoi sentire il respiro [dip the other party of the player]." 


Before listening to someone when the player cannot touch the noun (this is the listening to a connected party rule): 
	say "[The noun] sta aspettando che tu continui la conversazione." instead.

Rule for supplying a missing second noun while dialling: 
	assign a phone. 


To assign a phone: 
	if the player can touch a telephone (called the current phone): 
		say "([sup the current phone])[line break]"; 
		now the second noun is the current phone; 
	otherwise: 
		say "Non hai un telefono a portata di mano."

Before dialling when the player reaches someone (this is the dialling a telephone while on the line rule): 
	say "(prima interrompi la comunicazione [conp the other party of the player])[command clarification break]";
	end current conversation. 


Understand "aggancia" or "riaggancia" as hanging up. 


Hanging up is an action applying to nothing.

The hanging up action has an object called the phone hanged up. 

Setting action variables for hanging up (this is the set up hanging up rule):
	let the target be a random inuse telephone which can be touched by the player;
	now the phone hanged up is the target.

Check hanging up (this is the can't hang up while not on the line rule): 
	if the player does not reach someone, say "Non sei in linea con nessuno." instead;

Carry out hanging up (this is the standard hanging up rule):
	now the phone hanged up is not inuse;
	now the player does not reach anyone. 

Report hanging up (this is the standard report hanging up rule): 
	say "Riagganci [the phone hanged up], interrompendo la comunicazione." 

Before going somewhere when the player reaches someone (this is the go somewhere while on the line rule):
	if the number of inuse telephones held by the player is 0: 
		say "(prima interrompi la comunicazione  [conp the other party of the player])[command clarification break]"; 
		end current conversation.

After looking when the player reaches someone (this is the look while on the line rule):
	try listening to the other party of the player;
	continue the action.

To end current conversation: 
	silently try hanging up.

Table of Misdialled Numbers
number	retort
113	"In questa nazione, la legge punisce gli scherzi telefonici fatti alla polizia."

Telephones IT end here.

---- DOCUMENTATION ----

Vedi documentazione originale di Telephones by George Tryfonas.
