Version 11/140731 of Exit Lister IT by Leonardo Boselli begins here.

"The translation in italian of Version 11 of Exit Lister by Eric Eve, A status line exit-lister and an EXITS command, with optional colouring of unvisited exits. Selected rooms and doors can be optionally be excluded from the list of exits."

Include Exit Lister by Eric Eve.

[Una parte modificata dell'estensione si trova in Italian Language]

Chapter 4 - Exit Lister Rules

To say exit list:
  let exits count be 0;
  let farplace be location;   
  say "Uscite: ";
  repeat with way running through directions
  begin;
	let farplace be the room way from the location;
	now direction-object is the room-or-door way from the location;
	if direction-object is apparent and farplace is not darkness-occluded
	begin;      
	  increase the exits count by 1;      
	  if farplace is unvisited and indicate-unvisited is show-unvisited,  say "[unvisited-mark][u-v way][end-unvisited-mark]";
	  otherwise say "[emphasis way]";          
	  say " ";
	end if;
  end repeat;
  if exits count is 0,
  say "[italic type][no-exits][roman type]".
 
To say no-exits: say "nessuna".


Chapter 6 - Exit Lister Actions

Section 1 - ExitStarting and ExitStopping

Understand "uscite off" as ExitStopping.

Understand "uscite on" as ExitStarting.


Section H (for use with Hyperlink Interface IT by Leonardo Boselli)

to say u-v (way - a direction):
   let cap-way be indexed text;
   now cap-way is "[way]";
   say "[d][cap-way in upper case][x] ".

to say emphasis (way - a direction):
	say "[d][way][x]".

Section K (for use without Hyperlink Interface IT by Leonardo Boselli)

to say emphasis (way - a direction):
	say "[way]".


Section 2- ExitListing (in place of Section 2- ExitListing in Exit Lister by Eric Eve)

ExitListing is an action out of world.

Understand "uscite" as ExitListing.

Carry out ExitListing (this is the standard carry out exit listing rule):
  list the exits.

[ This is defined as a separate phrase so that it can be called from
  user code, e.g. to replace the standard "You can't go that way" message. ]  
  
To list the exits:
  let exits count be 0;
  let farplace be location;    
  repeat with way running through directions
  begin;
	let farplace be the room way from the location;
	now direction-object is the room-or-door way from the location;
	if the direction-object is apparent and farplace is not darkness-occluded, increase exits count by 1;
  end repeat;
  if exits count is 0
  begin;
	say "[no-obvious-exits]";
	rule fails;
  end if;
  let ii be exits count;
  if exits count is 1, say "[only-obvious-exit] ";
  otherwise say "[obvious-exits] ";
  repeat with way running through directions
  begin;
	let farplace be the room way from the location;   
	now direction-object is the room-or-door way from the location;
	if direction-object is apparent and farplace is not darkness-occluded
	begin;
		say "[emphasis way]";
		if farplace is visited, say " ([to-preposition] [destname farplace])";       
		decrease ii by 1;
		if ii is 0, say ".";
		if ii is 1, say " [and-conjunction] ";
		if ii > 1, say ", ";       
	end if;   
  end repeat.

To say list the exits: list the exits. 
	
To say no-obvious-exits: say "Non [ci sono] uscite visibili."
To say only-obvious-exit: say "L[']unica uscita visibile [regarding nothing][sei] a".
To say obvious-exits: say "Le uscite visibili [sono] a".
To say and-conjunction: say "e".
To say to-preposition: say "verso".

To say destname (place - a room):
  if the destination name of place is "", say "[the place]";
  otherwise say "[destination name of place]".
 
listing explained is a truth state that varies.  

Section H (for use with Hyperlink Interface IT by Leonardo Boselli)
  
Report ExitListing when listing explained is false (this is the explain exit listing rule):
  now listing explained is true;
  say "(Usa [d]USCITE ON[x] per abilitare l[']elenco delle uscite sulla barra di stato e [d]USCITE OFF[x] per disabilitarlo)." (A).
	
Section K (for use without Hyperlink Interface IT by Leonardo Boselli)

Report ExitListing when listing explained is false (this is the explain exit listing rule):
  now listing explained is true;
  say "(Usa USCITE ON per abilitare l[']elenco delle uscite sulla barra di stato e USCITE OFF per disabilitarlo)." (A).


Chapter - Responses

report exit stopping rule response (A) is "L[']elenco delle uscite è ora disabilitato.".
report exit starting rule response (A) is "L[']elenco delle uscite è ora abilitato.".

   
Exit Lister IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 11 of Exit Lister by Eric Eve.
