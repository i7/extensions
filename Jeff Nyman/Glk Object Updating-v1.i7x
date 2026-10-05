Version 1.0 of Glk Object Updating by Jeff Nyman begins here.

"The glk object updating rules, which run after the story starts, restarts, restores a saved game or undoes a turn. Inform 10.2 has them built in, so on 10.2 this extension does nothing; its 10.1 copy provides them."

[This is the Inform 10.1 copy. Inform 10.1 calls the Inform 6 routine
IdentifyGlkObject, phase 0, after startup, restart, restore and undo (it is a
stub unless something defines it); here it runs the glk object updating rules,
which is what Inform 10.2 does itself.

Inform 10.2: not needed, since Basic Inform 10.2 defines the glk object updating
rules and runs them itself. Remove this extension and the Include of it.]

Section - Glulx (for Glulx only)

The glk object updating rules is a rulebook.

Include (-
[ IdentifyGlkObject phase type ref rock;
	if (phase == 0) FollowRulebook( (+ the glk object updating rules +) );
	type = ref = rock = 0;
	rfalse;
];
-) replacing "IdentifyGlkObject".

Glk Object Updating ends here.

---- DOCUMENTATION ----

Inform 10.2 has a rulebook, the glk object updating rules, that runs after the story starts, after a restart, after a saved game is restored and after an UNDO. Inform 10.1 has no such rulebook; it has an Inform 6 hook instead.

This extension defines the rulebook and runs it from the 10.1 hook. This would not be needed on 10.2. Also worth noting that this extension defines the Inform 6 routine IdentifyGlkObject, so it can't be used together with another extension that defines it too.
