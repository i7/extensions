Version 3 of Underside IT by Leonardo Boselli begins here.
   
"Allows objects to be put under other objects. An underside usually starts out closed so that its contents are hidden from view. Requires Version 7 (or later) of Bulk Limiter; the space under objects is limited by bulk. Underside is compatible with Version 10 or later of Implicit Actions, but does not require it. Version 3 of Underside has been tested with Version 5U92 of Inform. Semplicemente tradotto in italiano."

"basato su Version 3 of Underside by Eric Eve."

Part 1 - Includes

Include Italian by Leonardo Boselli.
Include Bulk Limiter IT by Leonardo Boselli. 

Part 2 - The Underside Kind

An underside is a kind of container. The carrying capacity of an underside is usually 10000. [limit by bulk rather than quantity]
An underside is usually closed. [so that it conceals its contents]

The printed name of an underside is normally "[printed name of the holder of the item described]"

The specification of underside is "An underside is a special kind of container that represents the space under an object. To use it, define an object of kind underside and make it a part of the thing you want to be able to put things under."


Part 3 - Looking Under

This is the clever looking under rule:
   if an underside (called the underpart) is part of the noun and something is in the underpart begin;
      now the underpart is open;      
      say "Sotto [the noun] [is-are a list of things in the underpart].";   
   otherwise;
      consider the standard looking under rule;
   end if.

The clever looking under rule is listed instead of the standard looking under rule in the carry out looking under rules.

Part 4 - Placing Under

Placing it under is an action applying to two things.
Understand "metti [things preferably held] sotto [something]" or "metti [art-det] [things preferably held] sotto [something]" or "metti [things preferably held] sotto [a-art] [something]" or "metti [things preferably held] sotto [art-det] [something]" or "metti [art-det] [things preferably held] sotto [art-det] [something]" as placing it under.

The placing it under action has an object called the u-side.

Setting action variables for placing something under something:
   Change the u-side to a random underside that is part of the second noun.

Chapter 2a - Before and Precondition Rules  (for use with Implicit Actions by Eric Eve)

Before placing something under something (this is the take before placing under rule):
  if the u-side is not nothing and the noun is in the u-side,
     say "[The noun] [is|are] già sotto [the second noun]." instead;
  
Precondition for placing something under something (this is the placing under precondition rule):
   if the noun is not carried, carry out the implicitly taking activity with the noun;
   if the noun is not carried, stop the action.

Chapter 2b - Before Rules  (for use without Implicit Actions by Eric Eve)

Before placing something under something (this is the take before placing under rule):
  if the u-side is not nothing and the noun is in the u-side,
     say "[The noun] [is|are] già sotto [the second noun]." instead;
  if the noun is not carried begin;
      let actdesc be "cerca di prendere";
      if the player can touch the noun and the noun is portable, let actdesc be "prendi";
      say "(prima [actdesc] [the noun])[command clarification break]";
      silently try taking the noun;
   end if;
   if the noun is not carried, stop the action.

Chapter 3 - Check, Carry Out and Report

Check an actor placing something under the noun (this is the can't put anything under itself rule):
  say "Nulla può essere nascosto sotto sè stesso." instead.

Check placing something under something (this is the can't put under any old thing rule):
  if the u-side is not an underside,  say "Non puoi mettere nulla sotto [the second noun]." instead.

Check someone placing something under something  (this is the someone can't put things under any old thing rule):
  if the u-side is not an underside,  stop the action.

Check an actor placing something under something (this is the test bulk underneath rule):
  if u-side is an underside and u-side provides the property bulk capacity begin;
     if the bulk of the noun > the bulk capacity of u-side,
        say "[The noun] [is|are] troppo grande per essere nascosto sotto [the second noun]." instead;
     if the bulk of the noun > the free capacity of u-side,
        say "Non c[']è abbastanza spazio sotto [the second noun] per [the noun]." instead;
  end if.

Carry out an actor placing something under something (this is the standard place under rule):
   move the noun to the u-side.

Report an actor placing something (called the hidden) under something (called the hider) (this is the standard report place under rule):
  say "Hai nascosto [the hidden] sotto [the hider]."

Part 5 - Phrases for Under

To move (obj - an object) under/underneath (targetobj - a thing):
   if the targetobj encloses an underside (called the underpart) which is part of the targetobj then move the obj to the underpart.

To decide whether (obj - an object) is under/underneath (targetobj - a thing):
    if the targetobj encloses an underside (called the underpart) which is part of the targetobj then decide on whether or not the obj is in the underpart;
    decide no.


Underside IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Underside by Eric Eve.