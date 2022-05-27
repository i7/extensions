Version 7.0.220525 of Single Paragraph Description by Emily Short begins here.

"A room description extension based on Room Description Control (which is required). All contents of a room are summarized in a single paragraph, starting with the regular room description."

Include Room Description Control by Emily Short.
 
The room description body text rule is not listed in any rulebook.

Definition: a thing is initially-described if the initial appearance of it is not "" and it is not handled.

The new reporting descriptions rule is listed instead of the reporting descriptions rule in the description-priority rulebook.

The reporting items rule is listed after the new reporting descriptions rule in the description-priority rulebook.

A ranking rule for an initially-described thing (called special-target): 
	increase description-rank of the special-target by 5.

A ranking rule for a container (called special-target): 
	increase description-rank of the special-target by the number of mentionable things in the special-target.

A ranking rule for a supporter (called special-target): 
	increase description-rank of the special-target by the number of mentionable things on the special-target.

A ranking rule for something (called special-target) which is not in the location:
	increase description-rank of the special-target by 1. 


Printed a room description is a truth state that varies. Printed a room description is false.

This is the new reporting descriptions rule:
	if the description of the location is not "":
		if set to abbreviated room descriptions:
			make no decision;
		otherwise if set to sometimes abbreviated room descriptions and abbreviated form allowed is true and the location is visited:
			make no decision;
		otherwise:
			say "[description of the location] [run paragraph on]" (A); [Need rpo because end of rule]
			now printed a room description is true;

This is the reporting items rule: 
	if the Table of Seen Things is empty: 
		if printed a room description is true:
			now printed a room description is false;
			say "[line break]" (A);
		otherwise:
			say "[conditional paragraph break]" (B);
		make no decision; 
	now printed a room description is false; 
	repeat through the Table of Seen things:
		if the output subject entry is mentionable:
			if the output subject entry is initially-described:
				say "[initial appearance of output subject entry] " (C);
				now output subject entry is mentioned;
			otherwise if output subject entry is in something (called special-vase):
				say "In [the special-vase] [regarding mentionable things in the special-vase][are] [list of mentionable things in the special-vase]. " (D);
			otherwise if output subject entry is on something (called special-vase):
				say "On [the special-vase] [regarding mentionable things on the special-vase][are] [list of mentionable things on the special-vase]. " (F);
			otherwise if output subject entry supports something mentionable:
				say "On [a output subject entry] [regarding mentionable things on the output subject entry][are] [list of mentionable things on the output subject entry]. " (G);
			otherwise if output subject entry contains something mentionable:
				say "In [a output subject entry] [regarding mentionable things in the output subject entry][are] [list of mentionable things in the output subject entry]. " (H);
			otherwise:
				say "[We] also [see] here [a list of mentionable things]. " (I); 
	say "[paragraph break]" (J).

After printing the name of something (called special-target):
	now the special-target is not marked for listing;
	now the special-target is mentioned.  

The new describe contents rule is not listed in the report entering rulebook.

Single Paragraph Description ends here.

---- Documentation ----

Single Paragraph Description is an extension built on Room Description Control. It produces single paragraphs of output, like this:

	The amphitheater is currently empty of spectators, though you can see a magnificent view of the valley beyond the orchestra. On the ground is a mask. You can also see a play script and a ball of wax here.

and when the mask is taken

	The amphitheater is currently empty of spectators, though you can see a magnificent view of the valley beyond the orchestra. You can also see a mask, a play script and a ball of wax here.

Unlike previous versions, starting in version 7, you should not end room descriptions and initial appearances with a space.  This extension will add the spaces between sentences.

The exact text patterns can be changed with the responses system, specifically responses for
	the reporting items rule
	the new reporting descriptions rules
The responses *do* need the space at the end; this is how the extension adds the spaces.

As long as you deal strictly with texts, this should work.  If you do something more complicated -- like making a new say-phrase definition for "to say the initial description of", or intervening in the "issuing the response text of something activity" -- be careful.  This is not advised.  If you invoke 'say', make sure you do so with '[no line break]'.  If you add another action rule, be sure to terminate it with '[run paragraph on]'; normally every action rule triggers a paragraph break (though activity rules do not).

Because these single-paragraph descriptions can grow quite long and hard to read, it is likely that this technique will work best in small games or those with few portable objects.

If the game in question is set to BRIEF or SUPERBRIEF mode, Single Paragraph Description will omit the initial room description either when visiting the room for the second time (for brief) or always (for superbrief). Items in the room will still be mentioned.

Changelog:

	Version 7.0.220525 adds scenery to the example to verify that recent changes to Room Description Control work correctly. (Modified by Nathanael Nerode.)  Changelog is reordered.
	Version 7.0.220524 updates for Inform v10.1. (Modified by Nathanael Nerode.)
	Version 7/210331 auto-inserts the spaces after room descriptions and initial descriptions.  This actually works.  The example now replaces a response in order to match the sample text.  (Modified by Nathanael Nerode.)
	Version 6/210322 is updated to work with version 14 of Room Description Control, which renamed the "output" column of the Table of Seen Things to "output subject" to reduce namespace conflicts with games.  (Modified by Nathanael Nerode.)
	Version 3 removes a bug in which rooms with no description could crash the game.

Example: * Scene Setting - The Amphitheater in full

	*: "Scene Setting"

	Include Single Paragraph Description by Emily Short.

	Amphitheater is a room. "The amphitheater [regarding nothing][are] currently empty of spectators, though [we] [can] see a magnificent view of the valley beyond the orchestra."

	A play script and a ball of wax are here.

	A mask is here. "On the floor [regarding the mask][are] a mask."

	The valley is scenery in Amphitheater.  Understand "view" as the valley. 
	The description of the valley is "The valley spreads out, green and lush, into the far distance."

	The reporting items rule response (I) is "[We] can also [see] [a list of mentionable things] here. ";

	Test me with "look / get all / look / drop all / look".
