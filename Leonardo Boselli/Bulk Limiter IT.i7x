Version 7 of Bulk Limiter IT by Leonardo Boselli begins here.

"Contenitori ed attori che limitano le dimensioni dei loro contenuti. L[']unica modifica è la traduzione in italiano."

"basato su Version 7 of Bulk Limiter by Eric Eve."

Include Italian by Leonardo Boselli.
[Include Plurality by Emily Short.]

A thing has a number called bulk. 
The bulk of a thing is normally 1.

A container has a number called bulk capacity. 
The bulk capacity of a container is normally 10.

A person has a number called bulk capacity.
The bulk capacity of a person is normally 100.


Check an actor inserting into when the second noun provides the property bulk capacity (this is the bulk test rule):   
   if the bulk of the noun is greater than the bulk capacity of the second noun then 
      say "[The noun] [is|are] troppo grande per essere contenuto [in-prep the second noun]." instead;
   if the bulk of the noun is greater than the free capacity of the second noun then 
      say "Non c[']è abbastanza spazio [in-prep the second noun] per [the noun]." instead;
  
Check an actor taking when the actor provides the property bulk capacity 
   (this is the person bulk test rule):
   if the bulk of the noun is greater than the bulk capacity of the actor then 
      say "[The noun] [is|are] troppo pesante per [if the actor is the player]te[otherwise][the actor][end if]." instead;
   if the bulk of the noun is greater than the free capacity of the actor then 
      say "[if the actor is the player]Non puoi[otherwise][the actor] non può[end if] sollevare [the noun]." instead;
 
To decide what number is the free capacity of (targetbox - a container):
  let sum be the total bulk of the things in the targetbox;
  change sum to the bulk capacity of the targetbox minus sum;
  decide on the sum.

To decide what number is the free capacity of (targetperson - a person):  
   let sum be the total bulk of the things carried by targetperson;  
   change sum to the bulk capacity of the targetperson minus sum;  
   decide on the sum.


Bulk Limiter IT ends here.

---- DOCUMENTATION ----

Vedi la documentazione originale di Bulk Limiter by Eric Eve.
