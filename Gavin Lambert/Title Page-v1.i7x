Version 1.0.1 of Title Page by Gavin Lambert begins here.

"Provides an intro screen to the story, offering an image and menu."

Part - Dependencies

Include Basic Screen Effects by Emily Short. 

Part - Definitions

Use hidden title page translates as (- Constant Hide_title; -).
Use left aligned title page translates as (- Constant Left_align_title; -).
Use art in title page translates as (- Constant Title_art; -).

To say (n - number) spaces -- running on:
	(- spaces ({n}); -)
	
Title page display rules is a rulebook.

Section - Standard Rules

A title page display rule (this is the title page name rule):
	let line1 be "[bold type][story title][roman type]" (A);
	if the left aligned title page option is active:
		say line break;
		say line1;
	otherwise:
		center line1;
	
A title page display rule (this is the title page author rule):
	let line be "  by [if story author is empty]Anonymous[otherwise][story author][end if]" (A);
	if the left aligned title page option is active:
		say line break;
		say line;
	otherwise:
		center line;
	
A title page display rule (this is the title page quotation rule):
	let line be "[italic type][story headline][roman type]" (A);
	if the left aligned title page option is active:
		say line break;
		say line;
	otherwise:
		center line;

Part - Menu

Section - Standard Menus

Table of title page menu options
left	right
"Quit"	"Q"
"                - from a saved position"	"R"
"Start the story - from the beginning"	"(SPACE)"

Table of title page menu actions
number	rule
32	title page start rule
13	title page start rule
-6	title page start rule
82	restore the game rule
114	restore the game rule
77	title page quit rule
109	title page quit rule

Section - Menu Rules

This is the title page start rule:
	rule succeeds.
	
This is the title page quit rule:
	stop game abruptly.

Section - Menu Internals - unindexed

To decide which number is the maximum of (a - number) and (b - number):
	if a is greater than b, decide on a;
	decide on b.

To print the title page menu:
	say paragraph break;
	let width be the screen width;
	let leftmax be 0;
	let rightmax be 0;
	repeat through table of title page menu options:
		let leftmax be the maximum of leftmax and the number of characters in left entry;
		let rightmax be the maximum of rightmax and the number of characters in right entry;
	if leftmax plus rightmax plus 8 is greater than width:
		[the screen is too narrow, fall back on basic formatting]
		repeat through table of title page menu options in reverse order:
			say "[left entry] : [right entry][line break]";
	otherwise:
		let gutter be 2;
		if the left aligned title page option is not active:
			[these parentheses are required, at least as of 6M62, since I7 fails basic arithmetic]
			let gutter be (((width minus leftmax) minus rightmax) minus 4) divided by 2;
		repeat through table of title page menu options in reverse order:
			say "[fixed letter spacing][gutter spaces][left entry][fixed letter spacing][leftmax minus number of characters in left entry spaces] : [(rightmax minus number of characters in right entry) divided by 2 spaces][right entry][line break]";
		say variable letter spacing.
					
Part - Splash Art (for Glulx only)

Include Glulx Image Centering by Emily Short. 

Title page figure is a figure-name variable.

This is the title page splash art rule:
	say paragraph break;
	if the left aligned title page option is active:
		display title page figure;
	otherwise:
		display title page figure centered;

The title page splash art rule is listed before the title page quotation rule in the title page display rules.
The title page splash art rule does nothing if the art in title page option is not active.

Part - To do the thing

Section - internals - unindexed

To redraw status line:
	(- DrawStatusLine(); -).
	
Section - Main

First when play begins rule (this is the title page begin display rule):
	while 1 is 1:
		redraw status line;
		clear the screen;
		follow the title page display rules;
		say line break;
		print the title page menu;
		let k be 0;
		while k is 0:
			let k be the chosen letter;
			if there is a number of k in the table of title page menu actions:
				follow the rule corresponding to a number of k in the table of title page menu actions;
				if rule succeeded:
					clear the screen;
					say line break;
					make no decision;
				if rule failed:
					let k be 0.

Part - Or not to do the thing (not for release)

The title page begin display rule does nothing if the hidden title page option is active.

Part - Keep the Status Tidy (for use with Flexible Windows by Jon Ingold)

The when play begins rulebook has a truth state called the prior title page status.

First when play begins (this is the open the status window after title page rule):
	if the prior title page status is true:
		open the status window.
		
First when play begins rule (this is the close the status window before title page rule):
	now the prior title page status is whether or not the status window is g-present;
	if the prior title page status is true:
		close the status window.
		
The title page begin display rule is listed before the open the status window after title page rule in the when play begins rulebook.
		
Part - Keep Graphics in its Place (for use with Simple Graphical Window by Emily Short)

[Opening the status window after the graphics window is a bad idea, as then it ends up in the middle of the screen.]
The graphics window construction rule is listed after the open the status window after title page rule in the when play begins rulebook.

Title Page ends here.

---- DOCUMENTATION ----

This adds a title page to the start of your story -- heavily inspired by Jon Ingold's extension of the same name, but using a very different method of control.  (So you are very likely to need source text changes to switch from one to the other.)

Simply including the extension, without doing anything else, nets you a startup display of your story's name, author, and headline, then asking the player to press a key to decide if they want a clean start or to restore a saved game.

Of course, that can be annoying while you're developing your story, so it's possible to hide the title page in testing builds simply by including the following in your story (note that you can always define this, it is automatically ignored for release builds and you don't have to restrict it to "not for release" yourself -- you only need to remove it when you want to test something specifically about the title page):

	Use hidden title page.
	
By default, everything in the title page is shown centred (or at least as centred as interpreters will allow).  If you instead prefer for things to be left-aligned, then you can say that:
	
	Use left aligned title page.
	
Example: * Simple Defaults - Basic title page

	*: "Simple Defaults"
	
	Include Title Page by Gavin Lambert.
	
	Limbo is a room.
	
Example: * Splash - Title page with splash image

If you're compiling to Glulx, then you can also include an image in the title page, by including the "Use art in title page" statement.  By default, it will appear between the story name/author and the headline, and it will use the cover art for your story (as defined by "Release along with cover art").  However note that cover art doesn't actually exist until the story is released, so you'll see a blank space instead while testing.  Otherwise, you can specify any other figure that you like (and these will appear while testing) by setting the "title page figure".

Note that due to technical limitations, some interpreters (at time of writing, notably Quixe - the default web interpreter - was one of these) may still show this image left-aligned even when that option isn't set.  If this happens with your primary intended interpreter, then you may want to set the left alignment option so that everything appears consistent at least.

Also at time of writing some additional steps are required after releasing before Quixe can load any image files, as it doesn't have access to the full blorb file.

	*: "Splash" by Gavin Lambert

	The story headline is "A Graphic Adventure".  Limbo is a room.
	
	Include Title Page by Gavin Lambert.  Use art in title page.
	Figure splash is the file "splash.png" ("A colossal cave.").  The title page figure is figure splash.

Example: * Additional accreditation - Customising the title page display

The "title page display rules" are a rulebook that control the display of the top part of the title page.  As such, this means that you can do many different things to customise it.

One of the simplest changes is to alter the response text for one of the standard rules to print something different instead.  It's also possible to reorder rules, omit them entirely, or introduce your own custom rules.

Note that for best results, you should define rules with simple headers, and if you have conditions on applicability you should put them in the body of the rule.  Otherwise Inform may order the rules in a way that surprises you.

	*: "Additional accreditation"
	
	Include Title Page by Gavin Lambert.  Limbo is a room.
	
	Use left aligned title page.  Use art in title page.
	
	The title page name rule is not listed in any rulebook.
	The title page author rule is listed before the credit where credit is due rule in the title page display rules.
	The title page author rule response (A) is "Created by an infinite array of monkeys with typewriters."
	
	A title page display rule (this is the credit where credit is due rule):
		say "Some additional credits go to the lab members who were able to not only assemble, but also feed, all those monkeys.".

Note that due to the way rulebooks work, you'll usually have better luck listing which rule it should appear before rather than after.  (And in this case we could have just disabled the author rule as well and written a new one rather than changing its text, but it serves as a demonstration of different customisations this way.)
	
Example: *** Extra Info - Customising the title page menu

The menu at the bottom of the title page, on the other hand, is customised via tables.  (I did think of a way to control it via rulebooks instead, so I'm open to suggestions to change this if people have a strong preference for that.  Let me know.)  It's fairly straightforward to add new items to the top of the menu simply by continuing the table -- note that in order to make continuation easy, the table is printed in reverse order.  There's two tables involved; one has the display text and the other has the actions to be performed.

Another possibility, instead of continuing the standard tables, is to amend them, or even to replace them entirely (by specifying a replacement Section).

When writing the action rules, it's possible to manipulate the title page menu itself in a few ways:

Firstly, if you write "rule succeeds", then this will end the title page and it will clear the screen and continue on with the rest of the normal "when play begins" rules.  (Use caution if you're calling a standard rule instead of writing one specifically for the title page.)  This may be suitable if you want to have the player choose between different starting conditions (such as different playable characters or genders) and you don't want to have a separate menu for that later on.

If you write "rule fails", then it will go straight back to waiting for a menu keypress without updating the display.  (You should only do this if your rule doesn't say anything.  Again, use caution if you're re-using an existing rule.)

If you write "make no decision" (or don't write any of these), then it will clear the screen and redisplay the title page menu.  (And it's possible for you to amend the tables to change the options before it does so, if you wish.)

	*: "Extra Info"
	
	Include Glulx Text Effects by Emily Short.  [Include Flexible Windows by Jon Ingold.]
	Include Title Page by Gavin Lambert.  Include Menus by Dannii Willis.  Limbo is a room.

	Table of title page menu options (continued)
	left	right
	"Introduction for new players"	"N"

	Table of title page menu actions (continued)
	number	rule
	78	new player intro rule
	110	new player intro rule
	
	Table of New Player Info
	title	submenu	text
	"Special Commands"	--	"This game has a VERBS command. At any time, VERBS will list verbs that you could use in play."
	"Warnings"	--	"This game contains Strong Language and Graphic Violence. It may not be suitable for younger audiences. Please use your own discretion in deciding whether this is right for you."

	This is the new player intro rule:
		display the Table of New Player Info menu with title "New Player Introduction".

Note that the rule makes no decision (by default), in order to trigger redrawing the title page.  You will typically want to do that in all such rules.  Also note that both the upper and lower-case character codes are listed in the actions table.

This example uses Menus by Dannii Willis purely for illustrative purposes; you can use any other menu framework or non-menu-related action rule that you wish.

This example used to demonstrate integration with Flexible Windows by Jon Ingold, however this has not yet been ported to Inform 10.  But in theory when present, it will entirely hide the status window while the title page is shown and then show it again (or not, as appropriate) afterwards.  Menus by Dannii Willis is ok with this, but it's possible some other custom rules may want to do things involving the status window that aren't expecting it to be closed.  If this is a problem, then you can disable these rules with:
	
	*: The close the status window before title page rule is not listed in any rulebook.
		The open the status window after title page rule is not listed in any rulebook.

Another possibility is that after exiting the title page, some rules that open other windows may get confused by the status window opening and closing.  Again, the above can disable that entirely, but another possible solution is to ensure that the rules are processed in the correct order.  For example, the following line is automatically used to ensure compatibility with Simple Graphical Window by Emily Short; you may need something similar for other extensions.  (You shouldn't need it for anything done in your own story file, as that will naturally occur after the extensions by default anyway.)

	*: The graphics window construction rule is listed after the open the status window after title page rule in the when play begins rulebook.

You may need to similarly move rules around, or change the order in which you Include extensions, if some other extensions define "first when play begins" rules.  In general, "Title Page" works best as the last extension that you include; you should not need to do anything special in that case.
