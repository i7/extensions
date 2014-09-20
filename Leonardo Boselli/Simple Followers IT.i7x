Version 5 of Simple Followers IT by Leonardo Boselli begins here.

"Allows non-player characters to follow the player (or one another); adds a FOLLOW command and a corresponding STOP FOLLOWING command so that the player can issue these orders to non-player characters. Semplicemente tradotto in italiano."

"basato su Simple Followers by Emily Short."

[Include Plurality by Emily Short.]

Section 1 - The shadowing relation

Shadowing relates various people to one person (called the goal). The verb to shadow (he shadows, they shadow, he shadowed, he is shadowed, he is shadowing) implies the shadowing relation. 

Every turn: 
        repeat with pursuer running through people who are shadowing someone 
        begin; 
                let starting-space be the location of the pursuer; 
                let ending-space be the location of the goal of the pursuer; 
	if the starting-space is not the ending-space 
	begin;
	                let next-way be the best route from the starting-space to the ending-space, using doors; 
          	     	if next-way is a direction, try the pursuer trying going next-way; 
	end if;
        end repeat. 


Section 2 - The FOLLOW action

Understand "segui [something]" or "segui il/lo/la/i/gli/le/l [something]" as following. Following is an action applying to one thing. Understand the commands "insegui" as "segui". [Understand "start following/pursuing/chasing [something]" as following. Understand the commands "begin" and "commence" as "start".]

Check following something (this is the block following rule): 
	say "Preferisci tenere questa opzione aperta." instead.

Check someone trying following (this is the following only people rule): 
	if the noun is not a person, stop the action.

Check someone trying following (this is the following people already followed rule):
	if the person asked is shadowing the noun, stop the action.

Carry out someone trying following (this is the standard shadowing rule): 
	now the person asked shadows the noun. 

Report someone trying following (this is the standard report someone trying following rule): 
	say "[The person asked] inizia a seguir[if the noun is the player]ti[otherwise]e [the noun][end if]." 

Unsuccessful attempt by someone trying following (this is the excuses for not following rule):
	if the reason the action failed is the following only people rule, say "[The person asked] capisce che non può seguire nulla di inanimato.";
	if the reason the action failed is the following people already followed rule, say "[The person asked] rinnova lo sforzo di seguir[if the noun is the player]ti[otherwise]e [the noun][end if]."


Section 3 - The STOP FOLLOWING action

Understand "smetti di seguire/inseguire [something]" or "smetti di seguire/inseguire il/lo/la/i/gli/le/l [something]" as ceasing to follow. Ceasing to follow is an action applying to one thing. [Understand the commands "cease" and "desist" as "stop". Understand "quit following/chasing/pursuing [something]" as ceasing to follow.]

Check ceasing to follow something (this is the block ceasing to follow rule):
	say "Non stai seguendo più nessuno." instead.

Check someone trying ceasing to follow (this is the can't stop following what isn't followed rule):
	if the person asked is not shadowing the noun, stop the action.
	
Carry out someone trying ceasing to follow (this is the standard stop-shadowing rule):
	now the person asked is not shadowing the noun.
	
Report someone trying ceasing to follow (this is the standard report someone trying ceasing to follow rule):
	say "[The person asked] ha smesso di seguir[if the noun is the player]ti[otherwise]e [the noun][end if]."  

Unsuccessful attempt by someone trying ceasing to follow (this is the excuses for not ceasing to follow rule):
	say "[The person asked] non capisce, perché non sta più seguendo nessuno."


Section 4 - Another meaning for WAIT

Understand "aspetta qui" as waiting. Understand the command "fermati" or "rimani" as "aspetta".

Instead of asking someone who is shadowing someone to try waiting (this is the waiting cancels following rule):
	try asking the person asked to try ceasing to follow the goal of the person asked.

Simple Followers IT ends here.

---- Documentation ----

Vedi la documentazione originale di Simple Followers by Emily Short.