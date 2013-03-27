Version 8 of Exit Lister IT by Leonardo Boselli begins here.

"A status line exit-lister and an EXITS command, with optional colouring of unvisited exits. Selected rooms and doors can be optionally be excluded from the list of exits. Modifiche: solo tradotto in italiano."

"basato su Version 8 of Exit Lister by Eric Eve."

Chapter 1 - Exit Lister Includes

Include Basic Screen Effects by Emily Short.

Chapter 2 - Exit Lister Setup

A room has a text called destination name. The destination name of a room is usually "".

A door can be apparent. A door is usually apparent.
A room can be apparent. A room is usually apparent.

Chapter 3 - Exit Lister Tables

The status exit table is a table-name that varies. 
The status exit table is the Table of Exit Status.

The standard status table is a table-name that varies. 
The standard status table is the Table of Standard Status.

Table of Exit Status
left	central	right
" [left hand status line]"	""	"[right hand status line]"
" [exit list]"	""	""

Table of Standard Status
left	central	right
" [left hand status line]"	""	"[right hand status line]"

Chapter 4 - Exit Lister Rules

Rule for constructing the status line (this is the exit lister status line rule):
   if exit listing is enabled then
     fill status bar with the status exit table;
   otherwise
     fill status bar with the standard status table;
   rule succeeds.

To say exit list:
  let exits count be 0;
  let farplace be location;   
  say "Uscite: ";
  repeat with way running through directions
  begin;
    let farplace be the room way from the location;
    change direction-object to the room-or-door way from the location;
    if direction-object is apparent
    begin;      
      increase the exits count by 1;      
      if farplace is unvisited and indicate-unvisited is show-unvisited then say "[unvisited-mark][u-v way][end-unvisited-mark]";
      otherwise say "[way]";          
      say " ";
    end if;
  end repeat;
  if exits count is 0,
  say "[italic type][no-exits][roman type]".
 
To say no-exits: say "nessuna".

Chapter 5 - Exit Lister Values

A listing_state is a kind of value. The listing_states are enabled and disabled.

Exit listing is a listing_state that varies. Exit Listing is enabled.

A visiting-mark is a kind of value. The visiting-marks are show-unvisited and dont-show-unvisited.

indicate-unvisited is a visiting-mark that varies.

indicate-unvisited is show-unvisited.

The direction-object is an object that varies.

Chapter 6 - Exit Lister Actions

ExitStarting is an action out of world.

ExitStopping is an action out of world.

Carry out ExitStopping (this is the standard Exit Stopping rule):
  Change exit listing to disabled.
  

Report ExitStopping:
  clear only the status line;
  say "L[']elenco delle uscite è disabilitato."


Understand "uscite off" as ExitStopping.

Understand "uscite on" as ExitStarting.

Carry out ExitStarting (this is the standard Exit Starting rule):
  Change exit listing to enabled.

Report ExitStarting:
  say "L[']elenco delle uscite è abilitato.";
  
  
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
    change direction-object to the room-or-door way from the location;
    if the direction-object is apparent, increase exits count by 1;
  end repeat;
  if exits count is 0
  begin;
    say "[no-obvious-exits]";
    rule fails;
  end if;
  let i be exits count;
  if exits count is 1, say "L[']unica uscita è ";
  otherwise say "Le uscite sono ";
  repeat with way running through directions
  begin;
    let farplace be the room way from the location;   
    change direction-object to the room-or-door way from the location;
    if direction-object is apparent
    begin;
        say "[way]";
        if farplace is visited, say " (verso [destname farplace])";       
        decrease i by 1;
        if i is 0, say ".";
        if i is 1, say " e ";
        if i > 1, say ", ";       
    end if;   
  end repeat.

To say list the exits: list the exits. 
    
To say no-obvious-exits: say "Non ci sono uscite."

Report ExitListing when listing explained is 0 (this is the explain exit listing rule):
  change listing explained to 1;
  say "(Usa USCITE ON per abilitare l[']elenco delle uscite nella barra di stato e USCITE OFF per disabilitarlo.)"
  
To say destname (place - a room):
  if the destination name of place is "", say "[the place]" in lower case;
  otherwise say "[destination name of place]".
 
listing explained is a number that varies.  
  
Chapter 7 - Exit Lister Indicating Unvisited

exit colouring is an action out of world.
understand "uscite colore" as exit colouring.

exit-colour-num is a number that varies.
exit-colour-num is 1.
exit-symbol-num is a number that varies.


exit symboling is an action out of world.

Understand "uscite simbolo" as exit symboling.

exit-marker is a text that varies.


Carry out exit symboling (this is the standard exit symboling rule):
  increase exit-symbol-num by 1;
  if exit-symbol-num > the number of rows in the Table of Exit Symbols then change exit-symbol-num to 1;
  choose row exit-symbol-num in the Table of Exit Symbols;
  change exit-marker to the exit-symbol entry.

Report exit symboling:
  say "Fatto."


Table of Exit Symbols
exit-symbol
""
"="
"-"
"*"
"+"


Section 7G (for Glulx Only)

exit-symbol-num is 1.
exit-marker is "".

Carry out exit colouring (this is the standard exit colouring rule):
   change indicate-unvisited to the visiting-mark after indicate-unvisited.

to say unvisited-mark:
  say "[exit-marker]".

to say end-unvisited-mark:  
  say "[exit-marker]".

to say u-v (way - a direction):
   let cap-way be indexed text;
   change cap-way to "[way]";
   say "[cap-way in upper case]".


Section 7Z (for Z-machine only)


Carry out exit colouring (this is the standard exit colouring rule):
  increase exit-colour-num by 1;
  if exit-colour-num > 4  begin;
    change exit-colour-num to 0;
    change indicate-unvisited to dont-show-unvisited;
 otherwise;
   change indicate-unvisited to show-unvisited;
 end if.

Report exit colouring:
 say "Fatto."



to say unvisited-mark:
if exit-colour-num is 1 begin;
  turn the background red;
otherwise if exit-colour-num is 2;
  turn the background yellow;
otherwise if exit-colour-num is 3;
  turn the background blue;
otherwise;
  turn the background green;
end if;
say "[exit-marker]".

to say end-unvisited-mark:
  say "[exit-marker][default letters]".


exit-symbol-num is 1.
exit-marker is "".

to say u-v (way - a direction):
  say "[way]".


   
Exit Lister IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Exit Lister by Eric Eve.