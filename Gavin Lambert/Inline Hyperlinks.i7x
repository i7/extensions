Version 2/200930 of Inline Hyperlinks (for Glulx only) by Gavin Lambert begins here.

"Provides a simple HTML-inspired syntax for adding hyperlinks within any say phrases."

Include Hyperlink Extension Registry by Gavin Lambert.
Include Text Capture by Eric Eve.

Section - Link Management

The hyperlink list is a list of text variables.

To decide which number is the hyperlink index of (command - text), adding if needed:
	if command is empty, decide on 0;
	let count be 1;
	repeat with entry running through the hyperlink list:
		if entry is command, decide on count;
		increment count;
	unless adding if needed, decide on 0;
	add command to the hyperlink list;
	if count is greater than the maximum possible hyperlink data, say "[bold type](ERROR: too many hyperlinks)[roman type]";
	decide on count.

To decide which text is the hyperlink command at (N - number):
	if N is less than 1, decide on "";
	if N is greater than the number of entries in the hyperlink list, decide on "";
	decide on entry N of the hyperlink list.

To clear the hyperlink list:
	now the hyperlink list is {}.

Section - Link Declaration

The hyperlinked text is a text variable.
The hyperlinked command is a text variable.

To say link -- beginning say_link -- running on:
	now the hyperlinked text is "";
	now the hyperlinked command is "";
	start capturing text.
	
To say as -- continuing say_link -- running on:
	stop capturing text;
	if the hyperlinked text is empty, now the hyperlinked text is the substituted form of "[captured text]";
	start capturing text.
	
To say end link -- ending say_link -- running on:
	stop capturing text;
	if the hyperlinked text is empty, now the hyperlinked text is the substituted form of "[captured text]";
	now the hyperlinked command is the substituted form of "[captured text]";
	let index be the hyperlink index of the hyperlinked command, adding if needed;
	let id be the hyperlink id for tag gih_tag with data index;
	if index is 0, say hyperlinked text;
	otherwise say "[set link id][hyperlinked text][clear link]".

Section - Link Processing

The hyperlink command processing rules are a text based rulebook producing text.

Last hyperlink command processing rule for text (called command) (this is the default hyperlink command processing rule):
	rule succeeds with result command.

Section - Framework Registration - unindexed

gih_tag is a number that varies.

After starting the virtual machine (this is the inline hyperlinks registration rule):
	now gih_tag is a new hyperlink tag.

Hyperlink tag processing rule for gih_tag (this is the inline hyperlinks processing rule):
	let index be the current hyperlink data as a number;
	let command be the hyperlink command at index;
	if command is not empty:
		let command be the text produced by the hyperlink command processing rules for command;
		if command is not empty, rule succeeds with result command.

Section - Debugging (not for release)

Previewing the hyperlink list is an action out of world applying to nothing. Understand "preview hyperlinks" or "preview hyperlink list" or "preview the hyperlink list" or "hyperlinks" or "preview hyperlink commands" as previewing the hyperlink list.

Carry out previewing the hyperlink list:
	say "The hyperlink command list is as follows:[paragraph break]";
	let count be 1;
	repeat with entry running through the hyperlink list:
		say "[count]: [entry][line break]";
		increment count.

Section - Debugging (for use with Extended Debugging by Erik Temple)

[this section is identical to the prior one; it merely introduces a way to keep this command in a release build if you wish, indicated by including other debugging features]

Previewing the hyperlink list is an action out of world applying to nothing. Understand "preview hyperlinks" or "preview hyperlink list" or "preview the hyperlink list" or "hyperlinks" or "preview hyperlink commands" as previewing the hyperlink list.

Carry out previewing the hyperlink list:
	say "The hyperlink command list is as follows:[paragraph break]";
	let count be 1;
	repeat with entry running through the hyperlink list:
		say "[count]: [entry][line break]";
		increment count.

Inline Hyperlinks ends here.

---- DOCUMENTATION ----

Inline Hyperlinks allows us to specify text hyperlinks that provide a replacement command (and optionally some other special action). Hyperlinks are specified directly in descriptions and other "say" text, and are automatically tracked and numbered as required by the underlying glk system.

This version of Inline Hyperlinks was completely rewritten, but borrows heavily from both Inline Hyperlinks by Daniel Stelzer (with modifications by Eric Temple) and Hyperlinks by Dannii Willis.  It was written for Inform 7 6M62.

Version 2 was updated to remove the old id reservation system in favour of using the Hyperlink Extension Registry instead.

Inline Hyperlinks requires Text Capture by Eric Eve, and Hyperlinks and Hyperlink Extension Registry by Gavin Lambert.

Section: Basic Usage

Hyperlinks can be specified in two ways. We can specify the text of the hyperlink, followed by the text of the replacement command that clicking on that hyperlink will generate. For example, the following command will hyperlink the word "north"; when the link is clicked, the command "GO NORTH" will be generated.

	say "There is only one exit, to the [link]north[as]GO NORTH[end link]."

If we want the command generated to be the same as the hyperlinked text, we simply surround the text with the link tags:

	say "It appears that the only thing to do here is to [link]jump[end link]."

Inline Hyperlinks will also register hyperlinks in the status line. We define these like we do any other hyperlink, e.g.:

	When play begins:
		now the right hand status line is "Exits: [link]N[end link]"
		
While this does not require Flexible Windows by Jon Ingold, if you have included that before you included Inline Hyperlinks then it will automatically allow hyperlinks to appear in any other window as well.

Note that, because Inline Hyperlinks uses text capture (via Eric Eve's Text Capture extension) to store commands, we gain a significant advantage over methods of storing hyperlinks that rely on text. Whereas the latter types are limited to utilizing types that can be stored (leaving out temporary values such as might be generated by a loop, for example), Inline Hyperlinks is limited only to what can be printed, which makes assigning hyperlinks much easier. If we use text substitutions in our linked text, for example, the value of the substitution will be the value *at the time the link was created*. See the "Maze" example below for an example.

Section: Keypresses (or: Line vs Character Input)

Most of the time, stories are expected to be paused waiting for "line input" from the player (typing a full command).  It is only when in this state that clicking a hyperlink can actually inject a command.

In some cases, a story might be prompting for a single keypress (without pressing Enter afterwards), for such things as menus or yes/no prompts, among other things.  When in this state, clicking a hyperlink that produces a command will use the first character of that command as the player's keypress -- the rest of the command will be discarded.  However, this does allow you to provide usable hyperlinks for these sorts of inputs.  As is standard for character input, the actual key "pressed" is not printed.

If the story is not waiting for either of these things, then input replacement cannot occur.  Clicking on a hyperlink will still run any custom rules associated with it (see Advanced Usage) but will not actually inject any input.  This could still be useful in a wholly choice-based story (or a choice-based section of a larger story), where perhaps the normal line parser is not actually running.

Section: Advanced Usage

By default, the command portion of the hyperlink is interpreted as a command to be entered as if the player had typed it rather than clicking the link.  (Due to various quirks the injected command is usually printed on a separate line, unlike normally-entered commands.)

But this is not the only thing that can be done.  Either in addition to or instead of the standard behaviour, you can define alternative actions for specific commands or in general using the "hyperlink command processing rules" rulebook.

Creating a new rule in this rulebook can look something like this:
	
	A hyperlink command processing rule for "xyzzy" when the gazebo is in the location:
		rule succeeds with result "cast magic missile at the gazebo".

These rules take the hyperlink command as a parameter (so you can define different rules for different commands), have an optional 'when' clause like any other rules, and along with whatever other processing you like can end with one of the following:
	
	rule succeeds with result "text".	(this rulebook immediately ends and "text" will be entered as the player's input instead of the hyperlink command itself)
	continue the action.					(this rule ends but other rules continue; by default it will then enter the original hyperlink command text as the player's input)
	stop the action.							(this rulebook immediately ends; nothing else happens)

Among other manipulation of the model world, thanks to the Glk Input Suspending extension, you can "say" things either instead of or in addition to providing an input command (although that should be used sparingly, to avoid weird display), and if you do "stop the action" instead of providing a command then any partially-typed input by the player should be restored afterwards.  Note however that if the story is waiting for a keypress at the time that the hyperlink is clicked then only the first character of the replacement command will be read as that keypress; the remaining text will be lost.  However this does allow you to provide hyperlinks in contexts where single-key answers are expected as well.

If you want to write a more generic rule that can perform more complex tests on the hyperlink command itself, then this is the pattern to use:
	
	A hyperlink command processing rule for text (called command):
		if command matches the text "frob":
			...

See the example "Magic Words" for a demonstration of this. Note that the hyperlink command need not be anything actually parsable as a player command if you always "stop the action" or substitute an alternative command instead.

Section: Internals

Internally, Glk refers to each link only by a numeric identifier. Inline Hyperlinks keys that identifier to a list of texts (the "hyperlink list"); for example, if the ID for a given link is 10, Inline Hyperlinks will look up the 10th entry in the list for the linked command. Commands are not repeated, so if we repeatedly print a link with the replacement command "go north" then the same number will be assigned to the link each time. This helps keep the hyperlink list as short as it can be.

In actual fact, thanks to the Hyperlink Extension Registry, this extension doesn't really start at link id 1, but rather uses some high bits as a "tag" to indicate that it's a link from this extension, with the remaining bits encoding the link id 1 (or whatever it is).  These tag values are automatically chosen based on the extensions that have been included, so as long as all hyperlink extensions are using the same registry then there can't be any collisions or mixing-up of the links.

This also means that you're free to use manually numbered links as well if you wish, since Hyperlink Extension Registry keeps the "low numbers" (those with high bits all zero) free for the author's use.  You can see an example of this in the "Systematic Derangement of the Inner Compass" example below.

Performance will gradually decrease (though usually quite slowly) as unique commands are added to the list.  If you are concerned about the size of the hyperlink list, you may want to clean it out periodically. Inline Hyperlinks doesn't do this automatically, since different stories may have different needs. But keep in mind that (because most interpreters offer scrollback functionality) the entire story text is theoretically accessible to the player at any time: if you make changes to the hyperlink list, a player who scrolls back to click on a link may find that the link does not work as expected.  (While most links will probably be context-sensitive anyway and not be *useful* outside of the room where they were first printed, that is at least unsurprising behaviour, whereas if clicking a link produced a completely different command then it would be another matter.) The safest way to flush the list is probably to clear the screen periodically, resetting the scrollback buffer on most interpreters. At the same time that the screen is cleared, empty the hyperlink list, e.g:

	To clear the screen and hyperlink list:
		clear the screen;
		clear the hyperlink list.

If you are going to flush the list like this, be careful not to clear the screen without good reason. Choose natural break-points (such as chapters, or changes in setting) to avoid confusing (and frustrating) the player. While it may be tempting to do this more frequently to get rid of "outdated" commands that won't even work properly in another room or another context, this also removes the player's record of their journey thus far, which can leave them without important clues.

Section: Debugging

If we are testing the game in the Inform IDE, or if we have included the Extended Debugging extension, we can type HYPERLINKS at the command line at any time to see the current list of hyperlinked commands and their numeric identifiers (used by Glulx to identify the link).


Example: * Survival Mode

A simple example that shows the most basic usage. The "before reading a command" rule is really the only relevant thing in the example.

	*: "Survival Mode"

	Include Inline Hyperlinks by Gavin Lambert.

	The Jungle is a room. "You are [swing state] from a thick, rope-like vine. Another dangles from the canopy twenty-five or so feet away. A thick jungle mist obscures the view beyond, as well as the forest floor."

	Before reading a command:
		say "You can [link]swing[end link] or [link]release[as]jump[end link]."
	
	Yourself can be hanging or swaying. Yourself is hanging.
		
	Instead of swinging yourself:
		if the player is swaying:
			say "You swing faster.";
		otherwise:
			say "You sway a bit to get the vine moving, and soon are swinging in a wide arc.";
			now the player is swaying.

	To say swing state:
		if the player is hanging:
			say "hanging";
		if the player is swaying:
			say "swinging".
	
	Instead of jumping:
		if the player is swaying:
			say "You release the vine, impeccably timing your leap. You grab onto the other vine and hold. Through the mist you see yet another vine hanging thirty feet or so ahead.";
			now the player is hanging;
		otherwise:
			say "You release the vine and drop toward the jungle floor. Tumbling through the mist, you land hard on [one of]a thorn-tree; the baroque profusion of spines the size of railroad spikes ends your life[or]a massive hill of flesh-eating ants. They swarm over you before you can regain your feet[or]a path used exclusively by stampeding boars; a pack of the loathsome creatures happens to be passing[purely at random].";
			end the story saying "You have died".
					
	Understand "swing" as swinging.

	Rule for supplying a missing noun while swinging:
		now the noun is yourself.
	
	Instead of doing anything other than looking or swinging or jumping:
		say "There is no time for anything but survival."


Example: * Maze

It can be difficult to work with text substitutions in Inform, because it often refuses to allow temporary values to be restored for later usage. Inline Hyperlinks uses text capture, however, letting us avoid such problems. This example shows how we can build links as needed to automate exit-listing. All hyperlink handling occurs in the "to say exits" phrase.

	*: "Maze"

	Include Inline Hyperlinks by Gavin Lambert.

	The printed name of a room is "Maze". The description of a room is usually "A maze of twisty little passages, all alike. Exits: [exits]".

	To say exits:
		let count be 0;
		repeat with way running through all directions:
			let destination be the room way from the location;
			if destination is nothing, next;
			if count is greater than zero, say ", ";
			[this part is deliberately silly to increase the number of replacements used]
			let dir be text;
			let dir be "[way]";
			let dir be "[dir]";
			say "[link][way][as]go [dir][end link]";
			increment count;
		if count is greater than zero, say ". ".

	R01 is a room. R02 is north of R01. R03 is east of R01. R04 is north of R02 and northwest of R03. R05 is northeast of R02. R06 is north of R05. R07 is west of R06. R08 is southwest of R04 and northwest of R02. R09 is east of R06. R10 is northeast of R06. R11 is east of R10. R12 is southeast of R09. R13 is south of R12. R14 is northeast of R12. R14 is southeast of R11. R15 is up from R03. R16 is east of R15. R17 is north of R16. R18 is down from R17. The description of R18 is "A maze of twisty little passages, all alike. A breeze blows from the northeast. Exits: [exits]"

	Exit is northeast of R18. Exit is outside from R18. The printed name of Exit is "Outside". "You emerge into sunlight." Southwest from Exit is nowhere. Inside from Exit is nowhere. After looking in Exit, end the story saying "You have won."


Example: ** I'll have a Side of Inline Inventory, Please

This example borrows from the similarly-named example from the Hyperlinks extension; presenting the inventory as a sidebar, and providing a link to examine the object when clicked.  Where it differs from that one is that the links are managed more automatically.

	*: "I'll have a Side of Inline Inventory, Please"
	
	Include Flexible Windows by Jon Ingold.
	Include Inline Hyperlinks by Gavin Lambert.

	Rule for printing the name of something (called item) when the current focus window is the side window:
		say "[link][printed name of item][as]x [printed name of item][end link]".
		
	The side window is a text buffer g-window spawned by the main window.
	The position of the side window is g-placeright.
	The measurement of the side window is 30.

	Rule for refreshing the side window:
		try taking inventory.
	
	When play begins:
		open the side window.
	
	Every turn:
		refresh the side window;
		focus the main window.
	
	The Study is a room. In the study is an old oak desk. On the desk is a Parker pen, a letter, an envelope and twenty dollars.
	The description of pen is "Metallic, with a stainless tip and other trimmings, but otherwise the body is all matte black.  [if carried]You feel fancier just holding it."
	The description of letter is "You've read this letter so many times that you can't stand to read it again.  And yet, you know you will, eventually."
	The description of envelope is "This is the envelope that the letter came in, on that fateful night just a few days ago."
	The description of twenty dollars is "A creased twenty dollar bill.  It was in the envelope along with the letter."
	
	Test me with "take pen/take letter/i/take all".

You do need to be a little careful when printing the name of an item from the "printing the name of something" rule itself -- trying to say just "[item]" would re-invoke the same rule and cause a stack overflow.  There are some other ways to solve this, and there might be some other caveats if you want to customise the printed name of certain objects in other ways, so this is not a fully robust solution -- that's left as an exercise for another extension to solve.


Example: ** Magic Words

There may be times when we want a hyperlink to do something other than paste a straightforward command. In this example, a single hyperlink in the status bar issues different commands depending on what room the player is in. This could have been done by issuing the same command and giving it different contextual rules, but this is a little more mysterious since the player can't type the command themselves.

This also demonstrates that interrupted input is automatically resumed after clicking a hyperlink, provided that the hyperlink does not actually produce a replacement command.  You can see this by clicking the link at least twice in the Laboratory -- subsequent clicks do nothing, and if you have a half-typed command when clicking the link a third or subsequent time then your input is restored.  And finally it also demonstrates that printing text during hyperlink processing works as expected.

	*: "Magic Words"
	
	Include Inline Hyperlinks by Gavin Lambert.
	
	When play begins:
		now the right hand status line is "[link]xyzzy[end link]".
	[This may be hard to actually see in some terps, due to default colours.  Changing that is out of scope of this example.]

	Laboratory is a room. "Various odds and ends are scattered about.  The main door to the lab has become jammed shut due to.... reasons -- but you can still get outside via the fire exit."
	
	A beaker is in laboratory. The description is "An uninteresting glass beaker."
	Instead of attacking the beaker for the first time, say "You flail at the beaker, knocking it dangerously close to the edge of the table -- but fortunately it survives."
	Instead of attacking the beaker:
		now the beaker is nowhere;
		say "The beaker was less fortunate the second time -- it smashes to the ground and shatters into a million tiny fragments.  A swarm of small cleaning bots scurry out of the walls and quickly dispose of the mess, then just as suddenly vanish back from whence they came."
	
	Fire Escape is outside of Laboratory. "Just outside the emergency exit door of your laboratory (safety alarm conveniently disabled) lies the fire escape landing.  A chill breeze runs through your hair -- the air is quite cold this high up."
	Instead of examining down in Fire Escape, say "You're pretty sure that's a cloud below you."
	Instead of jumping in Fire Escape for the first time, say "You're not quite that silly -- are you?"
	Instead of jumping in Fire Escape:
		say "Apparently you are.[paragraph break]It takes several minutes of plummeting, but you eventually do discover the ground beneath.";
		end the story saying "It does not want to be friends"

	After answering the player that:
		say "[We] [say], '[topic understood].'".
	
	A hyperlink command processing rule for "xyzzy" when the location is Laboratory:
		if the beaker is in the location:
			rule succeeds with result "break beaker";
		say "The magic word fizzles aimlessly." instead.
			
	A hyperlink command processing rule for "xyzzy" when the location is Fire Escape:
		rule succeeds with result "jump".

Note that "xyzzy" itself is not actually a verb that the parser recognises -- typing it in will not run these rules, only clicking links will.  However, other than special cases like this, you should not have links that can't be typed in instead, unless you want to limit your players to only use interpreters that support hyperlinks.


Example: ** Derangement of the Inner Compass

In this example, which builds on the Maze example above, we demonstrate a bit of perverseness using a custom hyperlink rule.

The player can eat a pill, which temporarily thwarts her attempts to move in a given direction; instead of moving the direction indicated, an entirely random direction is substituted. This could have been done by simply changing the going action, but instead the hyperlink has been changed for illustrative purposes (along with the typed action, for consistency).

The player eventually recovers from the disorienting effects of the drug, and we track this using a variable called derangement.

	*: "Derangement of the Inner Compass"

	Include Basic Screen Effects by Emily Short.
	Include Inline Hyperlinks by Gavin Lambert.

	The derangement is initially zero.  Definition: yourself is deranged if the derangement is greater than zero.

	Every turn when the player is deranged:
		decrement derangement;
		if the player is not deranged, handle player recovery.
		
	Instead of going nowhere when the player is deranged:
		say "You collide with a wall."

	To say exits:
		let count be 0;
		repeat with way running through all directions:
			let destination be the room way from the location;
			if destination is nothing, next;
			if count is greater than zero, say ", ";
			say "[link][way][as]go [way][end link]";
			increment count;
		if count is greater than zero, say ". ".

	Hyperlink command processing rule for text (called command) when the player is deranged:
		if command matches the text "go ":
			show the glk input event replacement "go ???";
			replace the current glk input event with text input "go north", silently;
			[we could have just used 'command' directly, but this demonstrates how to use a different command from the link]
			rule succeeds with result "".
	
	Before going a direction when the player is deranged:
		now the noun is a random direction;
		follow setting action variables.

	The printed name of a room is "Maze". The description of a room is usually "A maze of twisty little passages, all alike. Exits: [exits]".

	There is a red pill in R01. The red pill is edible. The printed name is "[link]red pill[as]eat red pill[end link]". "[A red pill] lies on the floor here. Perhaps this will give you the mental acuity necessary to see through the maze!"

	Understand "take [something edible]" as eating when the player holds the noun.

	Instead of eating the red pill:
		now the red pill is nowhere;
		say "You pop the red pill with great anticipation...[paragraph break][bracket]Press any key[close bracket]";
		wait for any key;
		clear screen;
		say "You begin to feel odd indeed. Like the synapses aren't properly connected. Your body has been divorced from your inner compass![paragraph break]";
		now the derangement is a random number between 4 and 9;
		silently try looking.
		
	To handle player recovery:
		say "[line break]The odd feeling fades a bit.[paragraph break][bracket]Press any key[close bracket]";
		wait for any key;
		clear screen;
		say "You shake your head, feeling it clear. All is right again![paragraph break]";
		silently try looking;
		now the red pill is in R01;
		now the red pill is not handled;
		if the player is in R01, say "A tiny concealed chute opens and another [red pill] rolls out."

	R01 is a room. R02 is north of R01. R03 is east of R01. R04 is north of R02 and northwest of R03. R05 is northeast of R02. R06 is north of R05. R07 is west of R06. R08 is southwest of R04 and northwest of R02. R09 is east of R06. R10 is northeast of R06. R11 is east of R10. R12 is southeast of R09. R13 is south of R12. R14 is northeast of R12. R14 is southeast of R11. R15 is up from R03. R16 is east of R15. R17 is north of R16. R18 is down from R17. The description of R18 is "A maze of twisty little passages, all alike. A breeze blows from the northeast. Exits: [exits]"

	Exit is northeast of R18. Exit is outside from R18. The printed name of Exit is "Outside". "You emerge into sunlight." Southwest from Exit is nowhere. Inside from Exit is nowhere. After looking in Exit, end the story saying "You have won".

We could have instead simply jumbled up the visible link text and the actual command when printing the links while the player is deranged. But this demonstrates how you can have a special rule that only sometimes applies and that alters which command is actually run. We also demonstrate how to display a different command from the one that actually executes as well.  (Although that should be used sparingly, as it will likely confuse the player -- but in this case, that was the goal.)

In this example, we know that the only links available while the player is deranged are movement commands (the only other link was "eat pill", but that's been cleared away), so we didn't need to check what link was actually clicked in the hyperlink command processing rule, but we did anyway for illustrative purposes.


Example: **** Systematic Derangement of the Inner Compass

This example further changes the "Derangement of the Inner Compass" example by using another method of custom link actions; we use some manually numbered link ids, and write a new hyperlink processing rule that will respond when hyperlinks with these IDs are activated. Other hyperlinks will react normally.

Most of the mechanics of derangement are the same, but instead of picking a direction entirely at random, the hyperlinks behave a bit more systematic, and will instead pick a single direction at the time they are printed and will stick with that if clicked again. (This does mean that at times none of the printed links will ever successfully lead anywhere.) This could have been done simply by setting the link command accordingly, but we needed something to demonstrate reserved ids.

Also, rather than changing the going action directly, we instead use a different means to intercept typed commands (typed commands still pick a direction entirely at random). Note that this is less robust -- it relies on the links using "go [direction]" while the player types "[direction]", which gives the verbose player a method of cheating the system; there are ways to fix that (the easiest being to set a flag when a hyperlink command is recognised) but that is left as an exercise for the reader.  In most cases you should just use unique and easily recognised link commands rather than doing things this way anyway.

	*: "Systematic Derangement of the Inner Compass"

	Include Basic Screen Effects by Emily Short.
	Include Inline Hyperlinks by Gavin Lambert.

	The derangement is initially zero.  Definition: yourself is deranged if the derangement is greater than zero.

	Every turn when the player is deranged:
		decrement derangement;
		if the player is not deranged, handle player recovery.
		
	Instead of going nowhere when the player is deranged:
		say "You collide with a wall."
	
	To say exits:
		let count be 0;
		repeat with way running through all directions:
			let destination be the room way from the location;
			if destination is nothing, next;
			if count is greater than zero, say ", ";
			say "[link][way][as]go [way][end link]";
			increment count;
		if count is greater than zero, say ". ".

	To say skewed exits:
		let count be 0;
		repeat with way running through all directions:
			let destination be the room way from the location;
			if destination is nothing, next;
			if count is greater than zero, say ", ";
			say "[set link (a random number between 1 and 12)][way][clear link]";
			increment count;
		if count is greater than zero, say ". ".
			
	Hyperlink id processing rule for a number (called id):
		if there is an ID of id in the Table of Ways:
			if the player is not deranged, rule succeeds with result " ";
			choose row with ID of id in the Table of Ways;
			show the glk input event replacement "go ???";
			replace the current glk input event with text input "go [direction entry]", silently;
			rule succeeds with result "".
	
	After reading a command when the player is deranged:
		if the player's command matches "[direction]":
			say "Confusion... ";
			choose a random row in the Table of Ways;
			replace the player's command with "go [direction entry]".

	Table of Ways
	ID	direction
	1	"north"
	2	"east"
	3	"south"
	4	"west"
	5	"northeast"
	6	"southeast"
	7	"southwest"
	8	"northwest"
	9	"up"
	10	"down"
	11	"inside"
	12	"outside"

	The printed name of a room is "Maze". The description of a room is usually "A maze of twisty little passages, all alike. Exits: [if the player is deranged][skewed exits][otherwise][exits][end if]".

	There is a red pill in R01. The red pill is edible. The printed name is "[link]red pill[as]eat red pill[end link]". "[A red pill] lies on the floor here. Perhaps this will give you the mental acuity necessary to see through the maze!"

	Understand "take [something edible]" as eating when the player holds the noun.

	Instead of eating the red pill:
		now the red pill is nowhere;
		say "You pop the red pill with great anticipation...[paragraph break][bracket]Press any key[close bracket]";
		wait for any key;
		clear screen;
		say "You begin to feel odd indeed. Like the synapses aren't properly connected. Your body has been divorced from your inner compass![paragraph break]";
		now the derangement is a random number between 4 and 9;
		silently try looking.
		
	To handle player recovery:
		say "[line break]The odd feeling fades a bit.[paragraph break][bracket]Press any key[close bracket]";
		wait for any key;
		clear screen;
		say "You shake your head, feeling it clear. All is right again![paragraph break]";
		silently try looking;
		now the red pill is in R01;
		now the red pill is not handled;
		if the player is in R01, say "A tiny concealed chute opens and another [red pill] rolls out."

	R01 is a room. R02 is north of R01. R03 is east of R01. R04 is north of R02 and northwest of R03. R05 is northeast of R02. R06 is north of R05. R07 is west of R06. R08 is southwest of R04 and northwest of R02. R09 is east of R06. R10 is northeast of R06. R11 is east of R10. R12 is southeast of R09. R13 is south of R12. R14 is northeast of R12. R14 is southeast of R11. R15 is up from R03. R16 is east of R15. R17 is north of R16. R18 is down from R17. The description of R18 is "A maze of twisty little passages, all alike. A breeze blows from the northeast. Exits: [exits]"

	Exit is northeast of R18. Exit is outside from R18. The printed name of Exit is "Outside". "You emerge into sunlight." Southwest from Exit is nowhere. Inside from Exit is nowhere. After looking in Exit, end the story saying "You have won".

First, we reserve the hyperlink ID numbers 1 through 12 for manual use. This simply assigns an empty text to the first 12 hyperlink commands, i.e. "". If these are clicked outside of their intended use, they will thus have no effect.

We then revisit the exit lister from the Maze example above, and implement it in two different ways. The first represents the player while "straight", and is the same as in the Maze example. The second example, used when the player is "deranged," assigns random link IDs to the listed directions.

We then write a new hyperlink processing rule that will supersede the default command-pasting rule. This rule takes effect only when the hyperlink that was clicked has an ID in the set of 12 that we reserved above. The rule pastes text to the command line that indicates the PC's confusion ("go ???"). It is important to note, however, that this command is not entered; if it were, Inform would not understand it, since ??? is not a valid direction. Instead, we look the hyperlink ID number up in a table of stored directions and we enter that as a command instead, without printing the real command.  (Note that a table is not actually required for this purpose -- we could have used Inform's built in "list of directions" instead.  But it's likely that if you wanted to reserve ids you'd have a table of text commands you'd want to use, so we went that route.)

(Ordinarily, you could just "rule succeeds with result 'x'" to alter the command -- so clicking "north" could end up running "go west" simply by returning that, with no need to bypass the normal action processing.  This is much simpler, but also does end up printing the 'real' command.  In this example we took the weirder path mostly to demonstrate the advanced features.)

Note that, in this example, we clear the screen to ensure that the player will never be able to click on our special links during her normal state, nor on the normal links during her deranged state. However, if she were to click on one of the 12 special links while not deranged, there would ordinarily be no result, because the accompanying commands are all empty texts, i.e. "".  But there's one time when the links are still clickable and the player is no longer deranged -- when waiting for a keypress to acknowledge recovery. In this case, clicking on any of the leftover deranged links will acknowledge the keypress prompt, thanks to explicitly returning a non-empty command.

A companion rule for input redirects the player's typed direction command in the same way. (A better way to do this would be to do something more like the prior example, but we choose to lie in the hole we've dug ourselves...)
