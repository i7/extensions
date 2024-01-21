Version 9 of Bulk Limiter by Eric Eve begins here.

"Containers and actors that limit their contents by bulk"

A container has a number called bulk capacity. 
The bulk capacity of a container is normally 10.

A person has a number called bulk capacity.
The bulk capacity of a person is normally 100.

A thing has a number called bulk. 
The bulk of a thing is normally 1.

Check an actor inserting into when the second noun provides the property bulk capacity (this is the bulk test rule):   
   if the bulk of the noun is greater than the bulk capacity of the second noun,  
      say "[The noun] [are] too big to fit in [the second noun]." (A) instead;
   if the bulk of the noun is greater than the free capacity of the second noun,  
      say "[There] [are not] enough room left in [the second noun] for [the noun]."  (B) instead;
  
Check an actor taking when the actor provides the property bulk capacity 
   (this is the person bulk test rule):
   if the bulk of the noun is greater than the bulk capacity of the actor, 
      say "[The noun] [are] too big for [if the actor is the player][us][otherwise][the actor][end if] to pick up." (A) instead;
   if the bulk of the noun is greater than the free capacity of the actor,
      say "[If the player is the actor][We] [don't][otherwise][The actor] [don't][end if] have enough room left to carry [the noun]." (B) instead;
 
To decide what number is the free capacity of (targetbox - a container):
  let sum be the total bulk of the things in the targetbox;
  now sum is the bulk capacity of the targetbox minus sum;
  decide on the sum.

To decide what number is the free capacity of (targetperson - a person):  
   let sum be the total bulk of the things carried by targetperson;  
   now sum is the bulk capacity of the targetperson minus sum;  
   decide on the sum.


Bulk Limiter ends here.

---- DOCUMENTATION ----


This extension adds a bulk property to all things, and a bulk capacity property to all containers and people. The implementation is deliberately quite basic, in order to provide an
extension with a relatively small footprint to deal with simple cases such as preventing boulders being put in purses or carried. In order to keep things simple this extension deliberately doesn't deal with bulk capacities of supporters, or weights, or take into account the maximum dimension of long, thin objects or the like. It is intended to provide a simple solution to a common problem, not a full simulation.

The default bulk of a thing is 1. The default bulk capacity of a container is 10.  The default bulk capacity of a person is 100.

The extension performs a check on attempting to insert something into a container that the total bulk of the objects inside the container does not exceed its capacity. If an actor (not necessarily the player) attempts to insert an object whose bulk is larger than the bulk capacity of the container or to take an object whose bulk is larger than their own bulk capacity, the attempt will fail with a message saying that the object is too large for the container. Otherwise, if we attempt to insert an object into a container when there's not enough room left for it or take an object we can no longer carry, we'll get a message saying that there's not enough room left.

Note that this extension complements rather than replaces Inform's built in capacity check for containers. 

With thanks to Kevin Riggle whose suggestions have been incorporated into this extension.


Example: * The Basket, the Bricks and the Spoon - Putting things in a container with not quite enough room for them all, and carrying things without quite enough arms for them all.	

	*: "Basket"

	Include Bulk Limiter by Eric Eve

	The bulk capacity of a person is normally 10.

	The Kitchen is a room. "The only furniture of interest is the table." 
	A table is a scenery supporter in the kitchen. 
	A small spoon is on the table.

	A large hamper is in the kitchen. The bulk is 100.
  
	On the table is a container called the wicker basket.

	A brick is a kind of thing. The bulk of a brick is normally 5. Two bricks are here.

	Understand "put [things] in [something]" as inserting it into.	

	Test me with "Put bricks in basket/put spoon in basket/take brick/put spoon in basket/put brick in basket/put spoon in basket/take brick/take spoon/take hamper".
