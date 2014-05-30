Version 1/140513 of Adventure Book by Edward Griffiths begins here.

"A system for creating Choose Your Own Adventure style programs, with advanced features."

"based on an original programming system by Jon Ingold"

[This is an attempt to recreate the functionality of Jon Ingold's amazingly fun and addictive Adventure Book programming system.]

Chapter One -- Parts of an Adventure Book

[The basic unit of fiction in an Adventure Book is the page.  Gameplay consists mostly of printing the current page and allowing the player to select one of its choices.  Some pages are called dead ends.  When the game reaches a dead end, it returns to the previous page and allows the player to select a different choice.  This allows us to create options like "Examine the cake", which would take us to a page that prints the cake's description, then returns us to our previous menu to try something else.  A "special" page is ignored by debugging reports, and should really only be used by "meta-pages", such as The Last Page.]

A page is a kind of thing.  The initial appearance is usually "".  A page can be a dead end.  A page is usually not a dead end.  A page can be special.  A page is usually not special.

[Jon Ingold's original work supported a player inventory, represented by a series of flags.  By using so-called "invisible items", the game could also keep track of various information relating to the game state.  In this system, we'll use flags and inventory items in mostly the same way, but we'll distinguish them by name to make it easier for the author (or anyone reading the code) to differentiate.]

[As a curious side effect of the way Jon Ingold handled inventory items, it was valid to use the "use inventory item" option to create a sort of "magic word" that the player could type in a specific situation if the inventory item required was never otherwise referred to.  The effect was demonstrated in the game Aliens!.  I've decided to allow this behavior as well.]

A flag is a kind of thing.  A flag can be on or off.  A flag is usually off.  An inventory item is a kind of flag.  A magic word is a kind of inventory item.

[Choices are very simple.  When the player selects one, he is taken to the destination page.  A choice may not be available to the player depending on its relationship to the flags in the game, as explored in the next chapter.  A choice that's only available when you type the name of an inventory item is called a use.]

A choice is a kind of thing.  A use is a kind of choice.

Chapter Two -- How the Parts of an Adventure Book Relate to Each Other

[A page offers a number of choices.  Not all choices offered on a page will be relevant; that's decided by a choice's relationships with the flags.]

Offering relates one page (called the parent) to various choices.  The verb to offer (it offers, they offer, it offered, it is offered, it is offering) implies the offering relation.  The verb to be for implies the reversed offering relation.

[A choice leads to one page of the text.]

Triggering relates various choices to one page (called the destination).  The verb to trigger (it triggers, they trigger, it triggered, it is triggered, it is triggering) implies the triggering relation.

[Diverting leads from one page directly into another.]

Following relates one page (called the destination) to various pages.  The verb to follow (it follows, they follow, it followed, it is followed, it is following) implies the following relation.

[A page may give or remove certain items or flags whenever it is visited.]

Adding relates various pages to various flags.  The verb to give (it gives, they give, it gave, it is given, it is giving) implies the adding relation.

Clearing relates various pages to various flags.  The verb to remove (it removes, they remove, it removed, it is removed, it is removing) implies the clearing relation.

[A choice will be unavailable if any flag the choice requires is off or if any of the flags that stop it are on.  A use also has an inventory item that the player must type in to activate the use.]

Requiring relates various choices to various flags.  The verb to require (it requires, they require, it required, it is required, it is requiring) implies the requiring relation.

Cancelling relates various flags to various choices.  The verb to cancel (it cancels, they cancel, it cancelled, it is cancelled, it is cancelling) implies the cancelling relation.

Using relates various uses to one inventory item (called the tool).  The verb to use (it uses, they use, it used, it is used, it is using) implies the using relation.

Chapter Three -- How an Adventure Book Works

Section 1 -- Game Commands

[Adventure Book allowed for a number of commands for game management.  We can use the Inform 7 version of most of these, but we want to allow the syntax that Adventure Book used.]

Table of Commands
topic
"restart/x"
"save/s"
"restore/r"
"quit/q"
"look/l"
"inventory/i"
"help/h"

Understand the command "x" as something new.
Understand "x" as restarting the game.
Understand the command "s" as something new.
Understand "s" as saving the game.
Understand "r" as restoring the game.

Section 2 -- Wielding

[When the name of an inventory item is entered at the command prompt, we try to find the best fit with available use options that the current page offers.  In the case of magic words, a failure needs to be described as "You don't have that." to prevent the user from accidentally tripping upon the right word in the wrong context.]

Wielding is an action applying to one visible thing.

Understand "[an inventory item]" as wielding.

Understand "[any magic word]" as wielding.

Carry out wielding:
	repeat with the possibility running through uses offered by the current page:
		if the possibility is valid and the possibility uses the noun:
			turn to the destination of the possibility;
			the rule succeeds;
	if the noun is a magic word:
		say "You don't have that.";
	otherwise:
		say "You can't use that here."

Section 3 -- Choosing

[The main form of interface.  It simply consults the Table of Options built by the last turn to command and turns the system to the appropriate page.]

Table of Options
option
introductionscreenbegin
with 30 blank rows

Choosing is an action applying to a number.

Understand "[a number]" as choosing.

The command is a choice that varies.

Carry out choosing a number (called N):	
	if there is an option in row N of the Table of Options:
		now the command is the option in row N of the Table of Options;
		turn to the destination of the command;
	otherwise:
		try looking;		

Section 4 -- Asking for Help

[Displays system commands.]

Asking for help is an action applying to nothing.

Understand "help" and "h"  as asking for help.

Carry out asking for help:
	say "[fixed letter spacing]Command Summary:[line break]
		 LOOK / L	         Repeat the last page[line break]
		 INVENTORY / I     Show player inventory[line break]
		 SAVE / S          Save the game[line break]
		 RESTORE / R       Restore the game[line break]
		 QUIT / Q          Quit the game[line break]
		 RESTART / X       Restart the game[line break]
		 HELP / H          This text[line break]
		 [line break]
		 Select options by their number.  To use an object, type its name as it appears in the inventory list.[variable letter spacing]".

Section 5 -- The New Parser

[We only want the system to recognize, in order: one of the special commands, one of the listed options on the page, a declared inventory item, or a declared magic word.  Any other misunderstandings should be treated as inventory items the player doesn't have, which may or may not exist.]
	
After reading a command:
	repeat through the Table of Commands:
		if the player's command matches the topic entry, make no decision;
	if the player's command matches "[a number]", make no decision;
	if the player's command matches "[any inventory item]", make no decision;
	say "You don't have that.";
	reject the player's command.
	
Rule for printing a parser error:
	say "You don't have that." instead.

Section 6 -- Reading the Book

[Special pages provided by the system.  Current page and Previous page are for navigating, The Introduction Screen starts us off, and The Last Page gives players an elegant way to end their story, if they so choose.]

The current page is a page that varies.  The current page is The Introduction Screen.

The previous page is a page that varies.  The previous page is The Introduction Screen.

The Introduction Screen is a special page.  "[fixed letter spacing]-- Created using Adventure Book for Inform 7 by Edward Griffiths[line break]
   Based on Adventure Book by Jon Ingold

		 Command Summary:[line break]
		 LOOK / L	         Repeat the last page[line break]
		 INVENTORY / I     Show player inventory[line break]
		 SAVE / S          Save the game[line break]
		 RESTORE / R       Restore the game[line break]
		 QUIT / Q          Quit the game[line break]
		 RESTART / X       Restart the game[line break]
		 HELP / H          This text[line break]
		 [line break]
		 Select options by their number.  To use an object, type its name as it appears in the inventory list.[variable letter spacing]".
A choice called introductionscreenbegin is for The Introduction Screen.  "Continue."  It triggers The First Page.

The Last Page is a special page. "X) Restart[line break]R) Restore[line break]Q) Quit".

["Looking" displays the text of the current page and the most recently built list of choices.]

The finish condition is a flag.  Pagenames is a thing.  Pagenames can be on or off.  Pagenames is off.

Instead of looking:
	read the current page;
	repeat with N running from 1 to the number of filled rows in the Table of Options:
		now the command is the option in row N of the Table of Options;
		let x be the destination of the command;
		if x is unwritten and x is not special and the initial appearance of x is "", say "*** ";
		say "[N]) [The initial appearance of the command][line break]";
			
To decide if (possibility - a page) is unwritten:
	if possibility is a dead end, decide no;
	if possibility offers something, decide no;
	if possibility is followed by something, decide no;
	decide yes;

[Here's where all the magic happens.  When the system turns to a page, it first sets the values of previous page and current page, reads through the chain of diversions and dead ends, and rebuilds the list of choices based on the page where it finally ended up.  Finally, we make the player look so he can see what's going on after all that chaos.]

To turn to (destination - a page):
	now the previous page is the current page;
	now the current page is the destination;
	read through to the next decision;
	rebuild the list of choices;
	try looking;

[Simply clear out the list, go through the choices on the current page, and stick in any choices that are allowed by the current game context.]
	
To rebuild the list of choices:
	repeat through the Table of Options:
		blank out the whole row;
	repeat with possibility running through choices offered by the current page:
		if the possibility is valid and the possibility is not a use:
			choose a blank row in the Table of Options;
			now option entry is the possibility;

To decide if (possibility - a choice) is valid:
	repeat with x running through flags required by possibility:
		if x is off, decide no;
	repeat with x running through flags which cancel possibility:
		if x is on, decide no;
	decide yes;

[First, we need to set up a loop that won't end until we've reached the end of the chain of diversions.  For every page we encounter, we have to set and clear all applicable flags.  If the page ends in a diversion, we print the text for that page and move on to the next one.  Note that previous page isn't updated when we change the current page; this is so we can bounce back to it if our chain of diversions takes us to a dead end.

When we're done diverting, we check to see if we've reached a dead end.  If yes, we display the text for our dead end and bounce back to the previous page.  Note that we never print the text for the page of the player's final destination; since the list of choices hasn't been rebuilt for the player's new destination, there's nothing meaningful to display yet.]

To read through to the next decision:
	now the finish condition is off;
	while the finish condition is off:
		run inform code for the current page;
		repeat with gizmo running through flags given by the current page:
			set gizmo;
		repeat with gizmo running through flags removed by the current page:
			clear gizmo;
		if the current page is followed by something:
			read the current page;
			now the current page is the destination of the current page;
		otherwise:
			now the finish condition is on;
	if the current page is a dead end:
		read the current page;
		now the current page is the previous page;

To read (x - a page):
	if the initial appearance of x is not "", say "[if pagenames is on][the current page][line break][end if][The initial appearance of x][paragraph break]";

To set (x - a flag):
	if x is not a magic word:
		now x is on;
		if x is an inventory item, now the player is holding x;

To clear (x - a flag):
	if x is not a magic word:
		now x is off;
		if x is an inventory item, remove x from play;

To run inform code for (x - a page):
	do nothing;

To change pages to (x - a page):
	now the current page is x;
	run inform code for x;
	
[And a few final setup details.  The game room exists as a concession to the Inform 7 system so that there's a "place" where the player exists while he's reading this book.   Magic words are explicitly placed into scope for the wielding action.  Finally, we abolish the status line for stylistic reasons.]
	
There is a room called the game room.  The printed name is " ".

After deciding the scope of the player while wielding:
	repeat with x running through magic words:
		place x in scope;

Rule for constructing the status line: do nothing.

Use memory economy.

Section 7 -- Debugging - Not for release

[For authors only.  We allow commands to print the names of unwritten pages, to give or remove individual flags or inventory items, to give or remove ALL flags and inventory items, and to turn directly to the page of our choice.]

[First we define commands for all debugging commands.]

Table of Commands (continued)
topic
"report"
"skip to [any page]"
"list pages/flags/items"
"list magic words"
"give [any flag]"
"give all"
"remove [any flag]"
"remove all"
"page names on/off"

[Printing a report is the most involved activity.]

Printing a report is an action applying to nothing.

Understand "report" as printing a report.

Carry out printing a report:
	say "Searching for pages that don't have any option to continue...";
	repeat with x running through pages:
		if x is unwritten and x is not special:
			say "[line break][x] has no options to continue.[line break]";
			repeat with y running through choices that trigger x:
				if y is not a use:
					say "* The choice '[the initial appearance of y]' for [the parent of y] triggers [x].[line break]";
				otherwise:
					say "* A use for [the tool of y] for [the parent of y] triggers [x].[line break]";
			repeat with y running through pages that are followed by x:
				say "* [y] is followed by [x]. [line break]";
	say "[line break]Searching for pages that can't be reached:[line break]";
	repeat with x running through pages:
		if x is unreachable and x is not special, say "[x][line break]";
	say "[line break]Finished."

To decide if (possibility - a page) is unreachable:
	if something triggers possibility, decide no;
	if something is followed by possibility, decide no;
	decide yes;

[Skiping to a given page is no sweat.]

Skipping to is an action applying to one visible thing.  Understand "skip to [any page]" as skipping to.

Carry out skipping to something:
	turn to the noun;

[We can make up a big list of all pages, flags, inventory items, and magic words.]

Listing pages is an action applying to nothing.  Understand "list pages" as listing pages.

Carry out listing pages:
	say "Pages in the story:[line break]";
	repeat with x running through pages:
		say "[x][line break]";

Listing flags is an action applying to nothing.  Understand "list flags" as listing flags.

Carry out listing flags:
	say "Flags:[line break]";
	repeat with x running through flags:
		if x is not an inventory item, say "[x]: [if x is on]ON[otherwise]OFF[end if][line break]";

Listing items is an action applying to nothing.  Understand "list items" as listing items.

Carry out listing items:
	say "[line break]Inventory Items:[line break]";
	repeat with x running through inventory items:
		if x is not a magic word, say "[x][line break]";

Listing magic words is an action applying to nothing.  Understand "list magic words" as listing magic words.

Carry out listing magic words:
	say "[line break]Magic Words:[line break]";
	repeat with x running through magic words:
		say "[x][line break]";

[Giving and removing.  Very simple; just flip the switch the player indicates and rebuild the list of choices.]

Understand the command "give" as something new.  Understand the command "remove" as something new.

Flagsetting is an action applying to one visible thing.  Understand "give [any flag]" as flagsetting.

Carry out flagsetting something:
	set the noun;
	rebuild the list of choices;
	say "Done.[line break]";
	try looking;

Setting all is an action applying to nothing.  Understand "give all" as setting all.

Carry out setting all:
	repeat with x running through flags:
		set x;
	rebuild the list of choices;
	say "Done.[line break]";
	try looking;

Flagclearing is an action applying to one visible thing.  Understand "remove [any flag]" as flagclearing.

Carry out flagclearing something:
	clear the noun;
	rebuild the list of choices;
	say "Done.[line break]";
	try looking;

Clearing all is an action applying to nothing.  Understand "remove all" as clearing all.

Carry out clearing all:
	repeat with x running through flags:
		clear x;
	rebuild the list of choices;
	say "Done.[line break]";
	try looking;

[We can list page names while we're debugging.]

Turning on page names is an action applying to nothing.  Understand "page names on" as turning on page names.

Carry out turning on page names:
	now pagenames is on;
	say "Page names on."

Turning off page names is an action applying to nothing.  Understand "page names off" as turning off page names.

Carry out turning off page names:
	now pagenames is off;
	say "Page names off."

Adventure Book ends here.

---- DOCUMENTATION ----

Chapter: How to Write an Adventure Book

Section: Introduction

Adventure Book for Inform 7 is a recreation of the behavior of Jon Ingold's Adventure Book programming system.  It offers a reasonably simple syntax for people who would like to create Choose Your Own Adventure style programs without a lot of hassle, but it also allows for some advanced features to make your program feel more like a real game -- changing conditions, inventory items, and magic words.

This documentation assumes some familiarity with Inform 7, but it's written with beginners and non-programmers in mind.

Special thanks to Jon Ingold for his feedback in the development of this extension.  Comments are welcome at cpface@execpc.com.

Section: Version History

Version 1/140513

This extension differs from the author's original version: it has been modified for compatibility with version 6L02 of Inform. The latest version of this extension can be found at <https://github.com/i7/extensions>. 

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

Version 1/091203

Original release.

Version 1/110101

Giving and Removing relations renamed to Adding and Clearing, respectively, to avoid a conflict with newer versions of Inform 7.  Code structure described in earlier documentation ("It gives [flagname]." and "It removes [flagname].") should be unaffected, but any user-written code that refers directly to the relations will need to be modified.

"Use memory economy." has been added to the extension to give authors a slightly larger buffer to work with.

Section: Setting Up a Page

A good start to any programming language is creating a program to write "Hello World!".  So let's start with that and see how a page is set up.

	*: "The Hello World Story" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The First Page is a page.
	"Hello World!"

This is sufficient to create a running program.  If you click Inform 7's Go! button, you'll be presented with the Adventure Book opening screen and prompted to continue.  When you do, you'll be shown the text "Hello World!" and given a prompt.  Of course, since we haven't created any options for the player to try, the program can't continue in any useful way.

Notice how the page is written.  The first line, "The First Page is a page.", tells Inform that we're creating a new page and we're calling it The First Page.  On the next line, we write what it says on that page, surrounded by quotes.  And that's really all there is to it.

Pages can have just about any name you can think of.  If it makes sense to you to call them "Page 1", "Page 2", and so on, that's fine.  You can also name them after what happens on that page, such as "Exploring the Cave" or "Arguing with Robert".  The only really important rule is that the first page of your story must be called The First Page.

Notes for beginners:  Whenever quoted text is used to describe a page or a choice, either the text must end with a sentence-ending punctuation mark (. ! ?) or there must be a period after the second quotation mark.  All other sentences must end with a period.  Within quoted text, replace all quotation marks with ' marks; the game will automatically replace them with the appropriate marks when the game is run.  For example:

	"Margaret storms up to you.  'Do you really need the radio that loud?' she huffs."

will be printed as:

	Margaret storms up to you.  "Do you really need the radio that loud?" she huffs.

Section: Choices

The most important function of an Adventure Book is to offer the player choices.  Choices are listed after the quoted text that describes a page.  Here is a page with three choices:

	The First Page is a page.
	"You are at the beach.  What would you like to do?"
	A choice called TheFirstPageA is for The First Page.  "Go for a walk."  It triggers Go Walking.
	A choice called TheFirstPageB is for The First Page.  "Build a sand castle."  It triggers Building a Sandcastle.
	A choice called TheFirstPageC is for The First Page.  "Go for a swim."  It triggers Go Swimming.

Creating a choice has at least three parts.  First, "A choice called [something] is for [a page]." tells Inform that we are creating a new choice for the page we've named.  What we decide to call the choice isn't important because we'll never have to refer to it, but we can't have two choices with the same name.  It's a good idea, then, to give a choice a name that refers in some way to the page that it's on to avoid making duplicates.

The second part is quoted text that's displayed when the page is read.  You don't need to include the number that the player types to select the option; the system does that automatically.  When the program is run, the page above will be printed like this:

	You are at the beach.  What would you like to do?
	
	1) Go for a walk.
	2) Build a sand castle.
	3) Go for a swim.

The third part tells where the story will go if the player selects this choice.  "It triggers Go Walking." means that, if the player selects "Go for a walk.", the program will "turn to" the page with the name Go Walking, and play will continue from there.

Section: Pages Without Choices

Sometimes we'll want to direct the story to a particular place without requiring (or allowing) the player to make a decision.  If this is the case, we'll follow the description of a page with the sentence "It is followed by [the name of a page]." instead of a list of choices.  For example:

	The First Page is a page.
	"The directions have taken you through miles of back roads to an angry-looking house with chipped blue paint and foggy windows.  Is this really Melissa's house?"
	It is followed by The Driveway.

	The Driveway is a page.
	"You are standing in the driveway of what may or may not be Melissa's house.  What is your next move?"
	A choice called ...

After the game prints the text for The First Page to the player, it will automatically continue on to The Driveway without any input from the player and continue reading from there.  The chain can be as long as you'd like, with any number of "It is followed by..." statements.

One practical use for dividing up the action like this is that it allows us to return to the page called The Driveway and take further action there without reprinting the description of the player's initial arrival; if the player has been exploring the grounds for a while, the directions that brought him there aren't likely to be on his mind anymore.  In more traditional Adventure Books, it may simply be a convenient way to join convergent plot lines together -- forcing paths through the plot to meet at a particular place.

Another useful behavior is for a page to return to the page that called it after it is read to allow the player to make a different choice.  This is done by replacing the list of choices with the sentence "It is a dead end."  For example:

	*: "Stranger at a Party" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The First Page is a page.
	"You find yourself lost in a throng of revelling strangers."
	A choice called TheFirstPageA is for The First Page. "Talk to the gentleman by the drinks." It triggers NoReply.
	A choice called TheFirstPageB is for The First Page. "Talk to the guy by the stereo." It triggers NoReply.
	A choice called TheFirstPageC is for The First Page. "Talk to the man sitting on the couch." It triggers NoReply.
	A choice called TheFirstPageD is for The First Page. "Talk to one of the guys sharing stories in the corner." It triggers Your Friend Jake.
	
	NoReply is a page.
	"He casts you a withering stare."
	It is a dead end.
	
	Your Friend Jake is a page.
	"When you approach the guys in the corner, you're surprised to find your good friend Jake.  Did he say he was coming to this party?"

When the player selects an option that triggers the page NoReply, he'll be given a discouraging message and prompted to pick a different option from The First Page.

There are a number of uses for this sort of behavior.  In a traditional Choose Your Own Adventure book, it was sometimes necessary to tell the player that there was something wrong with a choice he made and to force him to go back and try it again; this would allow us to send the player back without needing to know which page he came from.  This is also useful for creating choices for smaller actions that don't drastically change the plot;  "Take a closer look at the old oak tree", for example, may trigger a page that describes the tree in detail, but, since it doesn't open up any new choices for the player, it sends him back to try something else.

It's worth mentioning that the author is allowed to string together a long chain of pages with "It is followed by..." statements and then to declare the last one to be a dead end.  In this case, the program will flip back to the last page it read that offered the player a choice.

Finally, sooner or later, every story reaches its conclusion.  To end a story, simply replace the list of choices with the sentence "It is followed by The Last Page."  The Last Page is a special page defined by the Adventure Book extension which does nothing except to offer the player choices to restart the game, restore a saved game, or quit.  For example, here is a page that ends a story:

	Drinking the Poison is a page.
	"You bring the bubbling brew to your lips and take a long drink.  It burns your throat and suffocates you.  You feel faint...

	*** You have died ***"
	It is followed by The Last Page.

When Drinking the Poison is read, the following text is displayed:

	You bring the bubbling brew to your lips and take a long drink.  It burns your throat and suffocates you.  You feel faint...

	*** You have died ***

	X) Restart
	R) Restore
	Q) Quit

	>

Using The Last Page to end a story is recommended, but optional.  There is no reason why you can't create your own game-ending pages.

This is all you need to know to create a functioning Adventure Book game.  The next chapter will demonstrate some advanced features.

Chapter: Advanced Features

Section: Setting Conditions

The advantage of a computer program over a traditional Choose Your Own Adventure story is that the computer can remember what has already happened and adapt what happens next based on that history.  Adventure Book lets you use on or off markers called flags to keep track of what has happened and what the player can do.

Flags don't need to be declared in any special way.  If you create a page that turns a flag on or off, Inform will automatically create that flag for you.  However, a flag can be created with a sentence like "[The flag's name] is a flag."  For example:

	TheReadingLampIsOn is a flag.

Most flags begin the game in the off position.  To set a flag to the "on" position, add the line "It gives [the flag's name]." just after the page's description and before the list of choices:

	Turning on the Reading Lamp is a page.
	"You turn the reading lamp on."
	It gives TheReadingLampIsOn.

Now, whenever Turning on the Reading Lamp is read, the flag called TheReadingLampIsOn will be turned on.

To return a flag to the off position, add the line "It removes [the flag's name]." just after the page's description:

	Turning off the Reading Lamp is a page:
	"You turn the reading lamp off."
	It removes TheReadingLampIsOn.

Any number of "It gives ..." and "It removes..." lines can be added to a page, just as long as they're all listed before defining the choices (or "It is a dead end." or "It is followed by..." statements) for that page.  For example:

	Confusing Mess is a page:
	"Goodness!  A lot has happened on this page!"
	It gives TheDuckHasBeenSeen.  It removes TheShirtIsWhite.  It gives LoudMusicIsPlaying.  It is a dead end.

Flags affect the game by changing which options are allowed on a given page.  Here is a choice to look at a bookshelf, but only if the reading lamp is turned on.

	In the Library is a page.
	"You are in your cozy library, surrounded by your favorite books."
	A choice called IntheLibraryA is for In the Library.  "Look at the bookshelf."  It triggers Examine Bookshelf.  It requires TheReadingLampIsOn.

Adding "It requires [flag name]." to the description of a choice prevents it from being printed if the flag is turned off.  In this case, the player will never be able to select an option to look at the bookshelf unless the flag TheReadingLampIsOn has been turned on.

Adding "It is cancelled by [flag name]." to the description of a choice prevents it from being printed if the flag is turned on.  This can be used to create choices like this:

	In the Library is a page.
	"You are in your cozy library, surrounded by your favorite books."
	A choice called IntheLibraryA is for In the Library.  "Look at the bookshelf."  It triggers Examine Bookshelf.  It requires TheReadingLampIsOn.
	A choice called IntheLibraryB is for In the Library.  "Look at the bookshelf."  It triggers Too Dark.  It is cancelled by TheReadingLampIsOn.

This would give the player a choice called "Look at the bookshelf." no matter whether the lamp is on or not, but where the player goes when he selects it depends on the state of the lamp.

Any number of "It requires..." or "It is cancelled by..." statements can be added to the end of a choice's description.  If any one of them would prevent a choice from being displayed, the choice is not printed.

	A choice called ByThePondA is for By The Pond.  "Look at the ducks."  It triggers Examine Ducks.  It requires TheDucksAreByThePond.  It is cancelled by TheStreetLightIsBroken.

In this case, "Look at the ducks." would only be printed if TheDucksAreByThePond is on and TheStreetLightIsBroken is off.

Note for advanced Inform users:  You can alter the text printed in a page using the techniques described in Chapter 5.5 of Writing with Inform.  The syntax for the conditions is simply "[if (the name of the flag) is (on or off)]".

Section: Inventory Items

One thing we might like to do in a game is give the player an inventory of items that he can use in different situations.  Inventory items offer a bit more flexibility than flags alone, but they need to be declared first.

For example, suppose I want to make a game, and the items I want to add are a sword, a shield, and a flask.  This is how I'd declare them:

	The sword is an inventory item.  The shield is an inventory item.   The flask is an inventory item.

"[Name] is an inventory item." tells Inform that you're creating a new inventory item and gives it a name.  It's a good idea to have one-word item names to keep things from getting confusing.  When you have a lot of items in a game, listing them out individually can be cumbersome.  The line above can be shortened to:

	The sword, the shield, and the flask are inventory items.

Inventory items can be declared anywhere in your code, but it's easier to keep track of them if you group them near the top.

Once your item is declared, it can be used exactly the same way as a flag.  Pages can give or remove an inventory item, and choices can require or be cancelled by items:

	A choice called InTheArenaA is for In the Arena.  "Attack the monster."  It triggers Attack Monster.  It requires the sword.

But inventory items have a more subtle use.  At any time, the player can type the name of an item he's holding to try and use that item instead of selecting one of the choices offered to him.  Most of the time, this will simply tell the player "You can't use that here.", but we can change that by adding a special kind of choice to our page called a use.  The choice above could be written as a use like this:

	A use called InTheArenaA is for In the Arena.  It triggers Attack Monster.  It uses the sword.

There's no descriptive text because this option is never explicitly printed for the player; he will have to take the initiative to try and use his sword without prompting from the system.  Notice "It uses the sword." instead of "It requires the sword."  That means that the player will actually have to type in the sword's name in order to use this option.

One problem with Choose Your Own Adventure style stories is how explicitly the player's options are spelled out for him.  Having "hidden" choices available for the player makes the game seem a little less confined.

Section: Magic Words

Magic words are another way to allow the player to make a choice that hasn't been explicitly offered to him.  For example, you could set up a computer terminal that requires a password or create a magic word that can be used to defeat an ogre or set up a puzzle that requires the player to deduce the correct sequence of keys to press.  For a situation like this, we can create a special command called a magic word.

To create a magic word, you simply declare it like so:

	Xyzzy is a magic word.

Now we can make uses for xyzzy.

	A use called IntheHouseA is for In the House.  It triggers Teleport to Caves.  It uses xyzzy.

A magic word never needs to be given or removed.  (In fact, trying to give or remove a magic word will have no effect.)

Suppose we want to make a number for the player to enter, like "413".  Inform won't allow us to use a purely numeric name for a magic word; "413 is a magic word." will cause an error.  In this case, it's probably better to use a sequence that has other characters in it, like "4-1-3" or "4/13".  But if it's absolutely necessary, then there is a work-around if you define your magic word like this:

	413 x is a magic word.

The name "413 x" is a tricky way to declare a magic word that can be referred to as "413".  (Technically, "x" will also refer to it, but the system will override it in favor of the restart command.)

Now we can make a use like this:

	A use called IntheVault is for In the Vault.  It triggers Open the Vault.  It uses 413 x.

A word of caution: when using purely numeric sequences for magic words, they will always override the choices that the player types in, even on pages that don't use that magic word.  For example, if we decide that the number 1 is going to be a magic word, like so:

	1 x is a magic word.

then the player will never be allowed to select option number 1 on any page.  (And, as a consequence, will never be able to leave the Introduction Screen.)  In general, it's best to look for alternatives to purely numeric sequences.

Section: Debugging

As your story grows in size and complexity, it can get difficult to keep track of everything.  The Adventure Book extension provides a number of debugging commands that are only available when you're testing your game in Inform 7.  There are reports about the game state as well as cheats that allow you to skip to any page, modify any flag, and acquire any inventory item.

On the most basic level, the game attempts to detect when a page has been left unwritten as you are playing it.  How does the system decide if a page is unwritten?  Well, whenever you refer to a new page -- when declaring a choice or a use or using "It is followed by..." to describe a page -- Inform 7 creates a blank page with that name.  Unless a formal definition is provided for that page, the page will have no description, no choices, and no way to continue; if the game leads the player to that page, it will end abruptly and mysteriously.  Since it's perfectly valid to create a page that doesn't have a text description (see the example "Conversation Trees" for a useful application), the system defines an unwritten page to be a page that has no way to continue -- no choices, no "It is followed by..." statement, no "It is a dead end." statement.

As you're playing the game, any choice that would lead to an unwritten page is preceded by three asterisks (***).  Here is an example of an unfinished story to show you how it works:

	*: "Unfinished" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The sword is an inventory item.  Xyzzy is a magic word.
	
	The First Page is a page.
	"An excellent start to your adventure!  What are you going to do first?"
	A choice called tfpa is for The First Page.  "Set off for adventure!"  It triggers The Next Page.
	A choice called tfpb is for The First Page.  "Set BOLDLY off for adventure!"  It triggers The Third Page.
	A use called tfpc is for The First Page.  It uses the sword.  It triggers The Swordplay Page.
	A use called tfpd is for The First Page.  It uses xyzzy.  It triggers The Xyzzy Page.
	
	The Third Page is a page.
	"You take an appropriately BOLD stance as you set off for adventure!"
	It is followed by The Next Page.
	
	The Fourth Page is a page.
	"You find yourself high up in the mountains!  What next?"

Since we never defined The Next Page in this story, the choice "Set off for adventure!" is listed as:

	*** 1) Set off for adventure!

This is a visual cue to the author, as he's testing, that that part of the game isn't working yet.  It's a useful hint, but it has a limitation -- it doesn't check to the end of a chain of "It is followed by..." statements to make sure that it ultimately leads to a written page.  And so the second choice isn't marked in any way, and if the player selects that choice, he is taken to The Third Page, which is followed by The Next Page, where the game comes to an abrupt halt.  Moreover, there are no indications at all for the use commands, since they're never printed in the page descriptions.

The "report" command is provided to help the author catch all of the missed connections in his story.  At any time, you can type "report" instead of a normal game command to bring up a list of all unwritten pages and a summary of the paths that lead to that page as well as a list of pages that don't have any connection to them whatsoever.  Print a report for the story above, and you'll see all sorts of problems with it:

	Searching for pages that don't have any option to continue...
	
	The Next Page has no options to continue.
	* The choice "Set off for adventure!" for The First Page triggers The Next Page.
	* The Third Page is followed by The Next Page. 
	
	The Swordplay Page has no options to continue.
	* A use for the sword for The First Page triggers The Swordplay Page.
	
	The Xyzzy Page has no options to continue.
	* A use for Xyzzy for The First Page triggers The Xyzzy Page.
	
	Fourth Page has no options to continue.
	
	Searching for pages that can't be reached:
	Fourth Page

It's a good idea to print a report for any game before you release it; short of exhaustively attempting every single choice of your game, it can be easy to miss one little connection along the way.

Suppose, however, that you have intentionally written a page without any means to continue.  For example, you're writing a page to replace The Last Page.  In that case, it can be annoying or misleading to see choices that lead to those pages marked with asterisks or to see them show up in reports.  If this is the case, you can indicate that a page is "a special page" when you declare it:

	The Really Last Page is a special page.
	"GAME OVER."

Now The Really Last Page will never show up in any reports, and any choices that lead to this page will be unmarked.  It's important that you only use this option if you really mean it.  The whole point of the report command is to remind you of parts of the story that you still need to continue; declaring a page to be "special" to keep it from being included in reports as you work on other parts of the story defeats the purpose.

As you're testing a large game, it can be a chore to have to exhaustively test every option, especially the parts of your game that depend on the states of flags and inventory items, and especially when you have to start from the beginning every time.  To facilitate testing, a number of commands are provided to help you jump around to different parts of the story.

First, there's the "skip to" command.  Type "skip to [the name of a page]", and the game will behave exactly as if you'd selected a choice that led to that page; flags and inventory items will be given or removed, the chain of "It is followed by..." commands will be followed, and, if the final page is a dead end, it will return to the page you were just reading.

To make navigation between pages a little easier, you can type "page names on" to display the name of each page as it's read.  (And, of course, typing "page names off" turns them off again.)  As a last resort, you can type "list pages" to get the complete list of all pages in the story, but this can get very, very long.

Finally, there are commands for manipulating the flags.  At any time, you can type "list flags" to get a list of all flags in the game, and whether they're on or off.  (Similarly, you can get lists of all inventory items or magic words by typing "list items" or "list magic words", respectively.)  You can set any flag or obtain any inventory item by typing "give [name of flag or item]", and you can turn any flag off or dispose of any inventory item by typing "remove [name of flag or item]".  If you're in a hurry, "give all" will set all flags and give you all of the inventory items, and "remove all" will clear all flags and trash all items.

Chapter: Integrating Inform 7 Code

Section: Relationships

The purpose of the Adventure Book extension is to provide beginners and non-programmers a relatively simple and flexible way to write interactive fiction.  However, experienced Inform 7 users may want to take full advantage of the language to produce more advanced effects.  This chapter will detail how the Adventure Book system works behind the scenes and give authors some basic guidelines for using Inform 7 code to change or extend Adventure Book's behavior.

The Adventure Book system is built on three core kinds of things: pages, choices, and flags.  A use is a kind of choice, an inventory item is a kind of flag, and a magic word is a kind of inventory item.  The meat of an adventure book program is describing the properties of these objects and their relationships with each other.

Here is a comprehensive list of all of the relationships defined by Adventure Book:

	Offering relates one page (called the parent) to various choices.  The verb to offer (it offers, they offer, it offered, it is offered, it is offering) implies the offering relation.  The verb to be for implies the reversed offering relation.
	
	Triggering relates various choices to one page (called the destination).  The verb to trigger (it triggers, they trigger, it triggered, it is triggered, it is triggering) implies the triggering relation.
	
	Following relates one page (called the destination) to various pages.  The verb to follow (it follows, they follow, it followed, it is followed, it is following) implies the following relation.
	
	Adding relates various pages to various flags.  The verb to give (it gives, they give, it gave, it is given, it is giving) implies the adding relation.
	
	Clearing relates various pages to various flags.  The verb to remove (it removes, they remove, it removed, it is removed, it is removing) implies the clearing relation.
	
	Requiring relates various choices to various flags.  The verb to require (it requires, they require, it required, it is required, it is requiring) implies the requiring relation.
	
	Cancelling relates various flags to various choices.  The verb to cancel (it cancels, they cancel, it cancelled, it is cancelled, it is cancelling) implies the cancelling relation.
	
	Using relates various uses to one inventory item (called the tool).  The verb to use (it uses, they use, it used, it is used, it is using) implies the using relation.

You could, if you wished, rewrite the syntax for the game system by defining new verbs for the relationships.  For example, if you don't like the expression "It triggers..." and you'd prefer to write "It turnsto..." instead, simply include this line in your program:

	The verb to turnto (it turnsto, they turnto, it turnedto, it is turnedto, it is turningto) implies the triggering relation.

Now you can write a (grammatically incorrect) sentence like:

	A choice called thefirstpagea is for The First Page.  "Go on a hike."  It turnsto GoHiking.

Section: The Adventure Book Phrasebook

The following is a list of all phrases defined by Adventure Book and what they do.

	turn to (destination - a page)

The Adventure Book system uses variables called "current page" and "previous page" to mark the player's place.  The phrase "turn to [page name]" is used when we must conclude an author-written command by turning to a new page.  It is responsible for updating the current and previous pages, flipping through the book until it reaches a page with a choice, rebuilding the list of choices based on where we ended up and how the game flags look, and giving the player the result.  This should NOT be used in a "to run inform code for..." block; use "change pages to..." instead.  (See the section on Running Inform Code.)

	set (x - a flag)

Sets x to the on position.  If x is an inventory item, it moves x into the player's possession.

	clear (x - a flag)

Sets x to the off position.  If x is an inventory item, it removes x from the player's possession.

	rebuild the list of choices

Throws out the old list of choices and creates a new one based on the current state of flag variables and the current page.  This should always be done in a command that alters the game's flags without turning to a new page; otherwise, the player may be allowed to select choices that are no longer valid.  Also, it's a good idea to end such commands with "try looking" to show the player his new list of choices.

	read (x - a flag)

Prints the description of the given page and does nothing else.

	read through to the next decision

This phrase is primarily used by the "turn to..." phrase, and it's responsible for a lot of the messy work of moving from page to page correctly.  First, it runs any special inform code that may be defined for the current page.  Then, it sets and clears any flags associated with that page.  If the current page is followed by another page, it prints the description of the page and moves to the next page, running inform code and manipulating flags until it reaches the end of the chain of "It is followed by..." statements.  If the current page is a dead end, it skips back to the page where the player made his last decision WITHOUT running inform code or manipulating flags.

It won't be necessary to invoke this phrase in most cases; it's usually much more useful to just use "turn to..." instead.  However, it is available if necessary -- if, for example, you'd like to write a new "turn to..." phrase.

	decide if (possibility - a choice) is valid

This is true if the choice is not cancelled by any "on" flags and it does not require any "off" flags, and false otherwise.

	decide if (possibility - a page) is unwritten

This is false if the page has no means to continue (no choices, no "It is a dead end." statement, no "It is followed by..." statement) and true otherwise.

	change pages to (x - a page)

This phrase changes the current page to the given page and then runs inform code for it.  (See the section on Running Inform Code.)

	run inform code for (x - a page)

This phrase does nothing unless it has been redefined by the author.  (See the section on Running Inform Code.)

Section: New Commands

One way to modify the behavior of the Adventure Book system is to create a new game command.  The extension normally overrides most of the player commands that are built into Inform 7, but it doesn't have to.  A table called the Table of Commands holds all of the extra commands that Adventure Book recognizes beyond the numbers for selecting choices and the names of inventory items and magic words.  You can add new commands to this list by continuing the table like so:

	Table of Commands (continued)
	topic
	"jump"
	"examine [an inventory item]"

This will allow the player to use the commands "jump" and "examine [something]" in exactly the same way that they're used in Inform 7.

For example, let's say that we want to allow the "examine" command so that the player can look at his inventory items without having to provide him an explicit choice to do so.  We would add "examine" to our Table of Items, and provide descriptions for all of the things the player might carry:

	*: "A Closer Look" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	Table of Commands (continued)
	topic
	"examine [an inventory item]"
	
	The ball is an inventory item.  The description is "Round and colorful."
	The pail is an inventory item.  The description is "A small sand toy."
	The ruby is an inventory item.  The description is "Red and beautiful."
	
	The First Page is a page.
	"You've got a handful of knickknacks.  Type 'examine (item)' to take a closer look."
	It gives the ball, the pail, and the ruby.

Note that only the word "examine" will be accepted; synonyms like "look at" will have to be rejected unless we specifically list them.

Most Inform 7 commands aren't designed to function with Adventure Book's world model, so this is more useful for authors who want to add their own custom commands to a game.  When a command is carried out, it can print information, adjust flags, and even move the player to a different page, if necessary.  See The Adventure Book Phrasebook for the list of phrases that you can use in your commands to change the game state.

Section: Running Inform Code

Whenever a page is triggered (except when it's returned to as a result of a dead end statement), the system invokes a phrase called "run inform code for [page name]".  This is the default behavior:

	To run inform code for (x - a page):
		do nothing;

This doesn't do anything interesting on its own.  Rather, it's an entry point that allows the author to sneak in a snippet of Inform code that's performed in special circumstances.

For example, let's say that we want to have a choice that could lead to one of two pages, chosen at random.  We could define a special case for "run inform code for..." that randomizes the player's destination when that choice is invoked:

	*: "Opening Kickoff" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The First Page is a page.
	"You toss the coin up in the air...".
	A choice called tfpa is for The First Page. "Which way did it land?" It triggers Landing.
	
	Landing is a special page.
	
	To run inform code for (x - Landing):
		if a random chance of 1 in 2 succeeds:
			change pages to Heads;
		otherwise:
			change pages to Tails;
	
	Heads is a page.
	"Heads!"
	It is followed by Reflip.
	
	Tails is a page.
	"Tails!"
	It is followed by Reflip.
	
	Reflip is a page.
	"Care to try it again?"
	A choice called reflipa is for Reflip.  "Sure!"  It triggers Landing.

The phrase "change pages to [page name]" is used in "run inform code for..." definitions when we want to trigger a different page as a result of what happened in our program.  It ensures that any inform code for the new page will be run as the game continues forward.  It is bad practice to use "turn to..." statements in your "run inform code for..." definitions because it can lead to recursion and unexpected effects.

Inform code extensions can give an Adventure Book a whole new flavor.  See the example "Combat System" for a demonstration.

Chapter: Changes From the Original Adventure Book

Section: Feature Changes

Authors who are already familiar with Jon Ingold's Adventure Book should hardly notice any changes in the look and feel of programs created with Adventure Book for Inform 7.  However, there are a few subtle differences.

First, there are no longer "win" or "lose" commands.  The program doesn't end unless the player explicitly quits.  This is to allow the player a chance to restart or restore when a game is over without having to restart the entire program.  The command "It is followed by The Last Page." is provided to give authors a sort of standardized "end game" menu, but it doesn't differentiate between winning, losing, or other game-ending conditions.  The author is welcome to create his own game-ending pages, and a few suggestions are offered in the Examples chapter.

Second, there are fewer practical limits on how many choices each page can support.  A practically unlimited number of choices and uses can be attached to each page.  However, only 30 choices can be printed at once.  This means that, if there are more than 30 choices on a page, you will have to make sure that some of them are blocked by "It requires ..." or "It is cancelled by ..." commands to keep them under the limit.  (Ideally, any page which needs so many choices should probably be broken down into sub-pages just to make things less confusing for the player.)

Third, you can now set conditions on an option to use an inventory item.  You can use this to ensure that certain conditions are met before the player can use an item in his inventory; a key can't be used if the door is already unlocked, a gun can't be fired unless the player has loaded it with bullets, and so on.

Section: Porting Original Adventure Book Programs

It's relatively simple to import code from the original Adventure Book into Adventure Book for Inform 7.  ADV files are human-readable, plain text files that can be opened with any text editor.  This section details how to convert existing Adventure Book games into new projects that can be compiled in Inform 7.

First, let's look at an example of how a page is described in an ADV file:

	* YourHouse
	   Your house is a rather modest little shack near the edge of town.  It keeps
	the wind and the rain out on sunny days.  
	+Venture forth+Road
	+Consider the loaf of bread on the table+Considerbread~@-BREADGONE

An ADV file declares the name of a page with a line that begins with an asterisk (*).  The line "* YourHouse" translates to:

	YourHouse is a page.

Text that doesn't begin with a special symbol is the description of the page.  This can stay more or less as it is, but it should be enclosed in quotation marks, and any internal quotation marks should be replaced with ' marks.

A + sign indicates a choice.  The text after the first + sign is the description of the choice.  The text after the second + sign is the name of the page that it opens to.  "+Venture forth+Road" translates to:

	A choice called yourhousea is for YourHouse.  "Venture Forth".  It triggers Road.

A tilde (~) indicates a condition.  The text immediately after the tilde is the name of the flag or inventory item that the condition is checking for.  If the name begins with an @ sign, it is an "It is cancelled by ..." condition.  Otherwise, the condition would be an "It requires ..." condition.  If there is a - sign before the name, it is checking for a flag.  Otherwise, it is checking for an inventory item.  So "~@-BREADGONE" is an "It is cancelled by ..." condition that is checking for a flag.  The last line of the example translates into this:

	A choice called yourhouseb is for YourHouse.  "Consider the loaf of bread on the table".  It triggers Considerbread.  It is cancelled by BREADGONE.

There may be multiple conditions on the same line, all separated by tildes.  A line like "~-DUCKGONE~@-MUSICON~RADIO~@SANDWICH" can be broken down into four sentences:

	It requires DUCKGONE.  It is cancelled by MUSICON.  It requires the radio.  It is cancelled by the sandwich.

where the radio and the sandwich are inventory items that are declared at the beginning of the text.

Put it all together, and the example page looks like this:

	YourHouse is a page.
	"Your house is a rather modest little shack near the edge of town.  It keeps
	the wind and the rain out on sunny days."
	A choice called yourhousea is for YourHouse.  "Venture Forth".  It triggers Road.
	A choice called yourhouseb is for YourHouse.  "Consider the loaf of bread on the table".  It triggers Considerbread.  It is cancelled by BREADGONE.

A line that starts with a # indicates a special command for the ADV file reader.  "#div" is a diversion to the page named immediately following "#div".  For example, "#divForest5" would translate to:

	It is followed by Forest5.

"#ret" is a "return", called a dead end in the Inform 7 version.  "#ret" translates directly into:

	It is a dead end.

"#win" and "#die" are commands for ending the game.  The closest thing to this in Inform 7 is diverting to The Last Page:

	It is followed by The Last Page.

Lines that begin with ">" and "<" signs are "It gives ..." and "It removes ..." commands, respectively.  So ">SWORD" becomes:

	It gives the sword.

where the sword is an inventory item, and "<-BRIDGEBARRED" becomes:

	It removes BRIDGEBARRED.

where BRIDGEBARRED is a flag.

A line that begins with a colon (:) is a use.  The text after the first colon is the item that's being used, and the text after the second colon is the page to turn to if that item is used.  So a line like ":LICENSE:TakeBridge" becomes:

	A use called crossbridgea is for CrossBridge.  It triggers TakeBridge.  It uses the license.

Chapter: Examples

Section: Special Effects

Adventure Book boils interactive fiction down to its most basic elements -- accepting choices from the player, and changing the game state to match those choices.  There are a lot of limitations to writing a game in this format, but with a little cleverness, it's fairly simple to create some very interesting effects.  We'll conclude with some examples of some simple effects that may help fire up your imagination as well as a complete game written with the original Adventure Book and translated into Inform 7.

Example: * Simple Choices - The basics of setting up a story with choices.

This is a simple example of how to set up branching text - no flags or inventory items required.  If you can understand how this works, then you're ready to start writing your own stories.

Notice that there is a lot of repetition between pages in this story when the events of the previous pages don't have much influence on the current state of the story, but it does influence later events.  If we used flags - say, a flag to tell whether or not the grandmother has been eaten - we could save a lot of typing by leading both outcomes of the grandmother scene to a single page, then checking later to see if the grandmother was eaten when it makes a difference to the narrative.

	*: "Little Red Riding Hood Interactive" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The First Page is a page.
	"Once upon a time, there was a little girl who lived in a cottage on the edge of the woods.  Everywhere she went, she wore a bright red riding hood, and everyone who knew her called her Little Red Riding Hood."
	It is followed by Page 2.
	
	Page 2 is a page.
	"One day, Little Red Riding Hood's grandmother fell ill, and so her mother gave her a basket of goodies to take to her grandmother's house.
	
	'But be careful on the road through the forest,' her mother said.  'Stay on the path, and don't talk to any strangers.'"
	It is followed by Page 3.
	
	Page 3 is a page.
	"But as Little Red Riding Hood made her way to her grandmother's, she came upon a wicked wolf.  But he was so kind and so sweet that she quite forgot her mother's instructions.
	
	'Where are you going, Little Red Riding Hood?' he asked.
	
	'I'm going to visit my grandmother,' Little Red Riding Hood explained.  'She lives in the cottage on the other edge of the forest.  She's very sick, and I'm bringing this basket of goodies to cheer her up.'
	
	The wolf heard this, and he licked his chops, scheming to himself.  'Perhaps you should stop a moment to pick some flowers for her,' the wolf suggested.  'That would be sure to cheer her up.'"
	It is followed by Page 4.
	
	Page 4 is a page.
	"As Little Red Riding Hood stopped to pick a bouquet of flowers for her grandmother, the wolf ran on ahead.  What did he do when he reached the grandmother's cottage?"
	A choice called p4a is for Page 4.  "He tied her up and threw her in the closet."  It triggers Page 5.
	A choice called p4b is for Page 4.  "He ate her up in one bite."  It triggers Page 6.
	
	Page 5 is a page. [The wolf ties up Grandmother.]
	"When the wolf reached the grandmother's cottage, he knocked on the door.  'Who is it?' asked the grandmother.  'It's your granddaughter, Little Red Riding Hood,' the wolf replied, disguising his voice.
	
	But when the grandmother opened the door and found a ferocious wolf, she screamed and fainted dead away.  And so the wolf tied her up with her own bedsheets and locked her up tight in the closet.
	
	With the grandmother safely locked up, the wolf dressed himself in her bedclothes, climbed into her bed, and pulled the sheets up over his head."
	It is followed by Page 7.
	
	Page 6 is a page.  [The wolf eats Grandmother.]
	"The wolf broke open the door to the grandmother's cottage, snarling ferociously.  The grandmother screamed in fright as the wolf attacked and ate her up in one bite.
	
	He licked his chops, chuckling wickedly to himself as he dressed himself in the grandmother's bedclothes and hid himself under the covers of her bed."
	It is followed by Page 8.
	
	Page 7 is a page. [Grandmother is tied up, Red appears.]
	"When Little Red Riding Hood arrived at her grandmother's house, she found her grandmother looking very peculiar.
	
	'Grandmother!' she cried.  'What big eyes you have!'
	
	'All the better to see you with, my dear,' the wolf said.
	
	'And what big ears you have!'  Red Riding Hood said.
	
	'All the better to hear you with, my dear,' the wolf grinned.
	
	Red Riding Hood gasped.  'Grandmother!  What big teeth you have!'
	
	At last, the wolf threw off his bedclothes.  'All the better to eat you with, my dear!'
	
	What happens next?"
	A choice called p7a is for Page 7.  "The wolf ate Little Red Riding Hood."  It triggers Page 9.
	A choice called p7b is for Page 7.  "The hunter burst into the room."  It triggers Page 10.
	
	Page 8 is a page.  [Grandmother was eaten, Red appears.]
	"When Little Red Riding Hood arrived at her grandmother's house, she found her grandmother looking very peculiar.
	
	'Grandmother!' she cried.  'What big eyes you have!'
	
	'All the better to see you with, my dear,' the wolf said.
	
	'And what big ears you have!'  Red Riding Hood said.
	
	'All the better to hear you with, my dear,' the wolf grinned.
	
	Red Riding Hood gasped.  'Grandmother!  What big teeth you have!'
	
	At last, the wolf threw off his bedclothes.  'All the better to eat you with, my dear!'
	
	What happens next?"
	A choice called p8a is for Page 8.  "The wolf ate Little Red Riding Hood."  It triggers Page 11.
	A choice called p8b is for Page 8.  "Red Riding Hood escaped."  It triggers Page 12.
	
	Page 9 is a page.  [Grandmother is tied up, Red is eaten.]
	"The wolf pounced upon Little Red Riding Hood, and before she could even call for help, he ate her up in a single bite.  Chuckling happily to himself, he crawled back into the grandmother's bed and soon fell soundly asleep.
	
	Just then, a hunter arrived at the grandmother's cottage and found a wicked wolf in the grandmother's bed, no doubt up to mischief.  What did he do?"
	A choice called p9a is for Page 9.  "The hunter shot the wolf dead."  It triggers Page 13.
	A choice called p9b is for Page 9.  "The hunter cut the wolf open and filled him with rocks."  It triggers Page 14.
	
	Page 10 is a page.  [Grandmother is tied up, Red escapes.]
	"The wolf sprang from the bed and chased Little Red Riding Hood around and around the room.  It looked like he was about to catch up with her, when suddenly a hunter burst into the room.  He'd heard the screaming and came to investigate, only to find a wicked wolf chasing a poor little girl around the grandmother's bedroom.  What did he do?"
	A choice called p10a is for Page 10.  "The hunter shot the wolf dead."  It triggers Page 15.
	A choice called p10b is for Page 10.  "The hunter scared the wolf off."  It triggers Page 16.
	
	Page 11 is a page.  [Grandmother and Red are eaten.]
	"The wolf sprang from the bed, pounced Little Red Riding Hood, and gobbled her up in one big bite.  After such a large meal, he began to feel very sleepy, and so he crawled back into the grandmother's bed and fell fast asleep.
	
	Just then, a hunter happened past the grandmother's cottage.  Thinking it odd that the door should be ajar with no sounds coming from inside, he stepped in and found the wolf sound asleep.  What did he do?"
	A choice called p11a is for Page 11.  "The hunter shot the wolf dead."  It triggers Page 17.
	A choice called p11b is for Page 11.  "The hunter cut the wolf open and filled him with rocks."  It triggers Page 18.
	
	Page 12 is a page.  [Grandmother is eaten, Red escapes.]
	"The wolf sprange from the bed and chased Little Red Riding Hood around and around the room, but she was too quick, and she hopped out the window to safety.
	
	She ran and ran as fast as she could until she found a hunter in the forest.  She told him everything that happened, and together they returned to the grandmother's cottage.  The hunter shot the wolf dead and cut open his stomach to free the grandmother."
	It is followed by Page 19.
	
	Page 13 is a page.  [Grandmother is tied up, Red is eaten, the hunter shoots the wolf dead.]
	"The hunter heard a sound from the closet and opened it to find the poor grandmother, tied up.  When he cut her bindings and she told him what happened, he loaded his rifle and shot the wicked wolf dead.  Then he took his hunting knife from his pocket and cut open the wolf's stomach to rescue Little Red Riding Hood."
	It is followed by Page 19.
	
	Page 14 is a page.  [Grandmother is tied up, Red is eaten, the hunter fills the wolf with rocks.]
	"The hunter heard a sound from the closet and opened it to find the poor grandmother, tied up.  When he cut her bindings and she told him what happened, he took his hunting knife from his pocket and cut the wolf's belly open to rescue Little Red Riding Hood.  While the wolf slept, they all filled his empty stomach with stones and sewed his stomach shut again.
	
	When the wolf woke up, he was very thirsty, and so he drug himself out the door and to the well to get a drink.  But when he bent over to get some water, the weight in his stomach pulled him to the bottom of the well, where he was drowned."
	It is followed by Page 19.
	
	Page 15 is a page.  [Grandmother is tied up, Red escapes, the hunter shoots the wolf.]
	"Taking careful aim, the hunter shot the wolf dead.  Just then, they heard a sound coming from the closet.  They opened the door to find the grandmother, all tied up.  The hunter quickly cut the bedsheets and freed her."
	It is followed by Page 19.
	
	Page 16 is a page.  [Grandmother is tied up, Red escapes, the wolf escapes.]
	"The wolf took one look at the hunter's gun and he leapt out the window and back into the forest, never to be seen again.  Just then, they heard a noise coming from the closet.  Opening the door, the found the grandmother all tied up.  The hunter quickly cut the bedsheets and freed her."
	It is followed by Page 19.
	
	Page 17 is a page.  [Grandmother and Red are eaten, the hunter shoots the wolf.]
	"The hunter loaded his rifle and shot the wolf dead where he slept.  Then he took the hunting knife from his belt and cut open the wolf's stomach, freeing Little Red Riding Hood and her grandmother."
	It is followed by Page 19.
	
	Page 18 is a page.  [Grandmother and Red are eaten, the hunter fills the wolf with rocks.]
	"The hunter took the hunting knife from his belt and cut open the wolf's stomach, freeing Little Red Riding Hood and her grandmother.  Then they gathered up a large pile of heavy stones to fill the wolf's stomach and sewed it shut again.
	
	When the wolf awoke, he was very thirsty, and so he drug himself out the door and to the well to get a drink.  But when he bent over to get some water, the weight in his stomach pulled him to the bottom of the well, where he was drowned."
	It is followed by Page 19.
	
	Page 19 is a page.
	"From that day forward, Little Red Riding Hood never strayed from the path through the forest, and she never ever talked to strangers.  And they all lived happily ever after.
	
	The End."
	It is followed by The Last Page.

Example: ** Conversation Trees - How to create dialogue menus with story characters.

The menu-based interface makes it very easy to set up a multi-tiered conversation tree where the player can select a subject to talk about, which leads to more available topics, resulting in a more or less natural conversational exchange.  This sample game shows how to set up a very simple conversation tree where some choices will simply print a response and return to the same general subject, while others may lead to new subjects altogether.

Notice, in particular, the use of pages with no description to hold the choices for the player's end of the conversation.  This is so we can return to the same set of choices without interrupting the flow of the conversation by reprinting the statement that initiated them.  In this case, we don't want to reprint the introductory text about sitting next to Keith every time we want to change the subject.

Notice also how flags can be used to expand the options available on a subject based on what's already been discussed - the question about kissing a sting ray only appears when Keith has mentioned it in the conversation.

Finally, we use the flag CARTELDISMISSED to keep track of whether or not Keith has admitted to the player that the story about his drug cartel is a lie.  If he's already admitted to deception, it's not likely that he's going to try the same line again or that the player will fall for it, so we provide a different option in the list of subject that takes us right to the part of the conversation about sting rays.

	*: "A Chat With Keith" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The First Page is a page.
	"The dinner seating on the cruise ship has placed you next to a rather charming young man in his late 20s who introduces himself as Keith Owens.  As you wait for dinner to be served, you find yourself curious about him."
	It is followed by KeithTopics.
	
	KeithSubjects is a page.
	"What would you like to ask about?"
	It is followed by KeithTopics.
	
	KeithTopics is a page.
	A choice called keithtopa is for KeithTopics.  "'What do you do for a living?'".  It triggers SubjectChocolate.
	A choice called keithtopb is for KeithTopics.  "'Do you have any hobbies?'".  It triggers SubjectHobbies.
	A choice called keithtopc is for KeithTopics.  "'What brings you to the Caribbean?'".  It triggers SubjectCaribbean.  It is cancelled by CARTELDISMISSED.
	A choice called keithtopd is for KeithTopics.  "'When are you going to be swimming with the sting rays?'".  It triggers SubjectStingRay.  It requires CARTELDISMISSED.
	A choice called keithtope is for KeithTopics.  "That's enough conversation for now."  It triggers EndConversation.
	
	SubjectChocolate is a page.
	"'I run a chocolate shop, actually,' he notes.  'We specialize in hand-made confections.  Just about everything is made on-site.'"
	It is followed by ChocolateTopics.
	
	ChocolateTopics is a page.
	A choice called choctopa is for ChocolateTopics.  "'Is that difficult?'".  It triggers SubjectDifficulty.
	A choice called choctopb is for ChocolateTopics.  "'How did you get into the chocolate business?'".  It triggers SubjectBusiness.
	A choice called choctopc is for ChocolateTopics.  "Ask about something else."  It triggers KeithSubjects.
	
	SubjectDifficulty is a page.
	"'Not when you've been doing it for as long as I have,' he notes."
	It is a dead end.
	
	SubjectBusiness is a page.
	"'Chocolate has been the family business going back almost a hundred and thirty years,' he notes.  'My father taught me everything I know about it.  He still works there, keeping the books and everything.'"
	It is a dead end.
	
	SubjectHobbies is a page.
	"'Well, I like to go hiking whenever I can,' he says.  'I try to find some time every summer to go up to Wisconsin and explore the Kettle Moraine.'"
	It is followed by HobbyTopics.
	
	HobbyTopics is a page.
	A choice called hobtopa is for HobbyTopics.  "'Are you an outdoorsman?'".  It triggers SubjectOutdoors.
	A choice called hobtopb is for HobbyTopics.  "'What's the Kettle Moraine?'".  It triggers SubjectKettle.
	A choice called hobtopc is for HobbyTopics.  "Ask about something else."  It triggers KeithSubjects.
	
	SubjectOutdoors is a page.
	"'As much as possible,' he grins.  'Ever since I was a kid.  They couldn't keep me indoors for anything.'"
	It is a dead end.
	
	SubjectKettle is a page.
	"'It's a region in Wisconsin that marks the furthest progress of the glaciers into North America during the last Ice Age,' he explains.  'There's a long trail that stretches for miles and miles through woods and fields.  I like to put aside a few days and hike from one end of it to the other.'"
	It is a dead end.
	
	SubjectCaribbean is a page.
	"'I'm running heroin for my cartel,' he remarks casually, taking a sip of his wine."
	It is followed by CaribbeanTopics.
	
	CaribbeanTopics is a page.
	A choice called caribtopa is for CaribbeanTopics.  "'... Really?'".  It triggers SubjectReally.
	A choice called caribtopb is for CaribbeanTopics.  "Politely change the subject."  It triggers KeithSubjects.
	
	SubjectReally is a page.
	"Keith laughs.  'No, I've just always wanted to see the sting rays.  I'm signed up for the shore excursion to Sting Ray City.  They take you out to a sand bar in the middle of the ocean and let you swim with the sting rays.'"
	It gives CARTELDISMISSED.  It is followed by StingRayTopics.
	
	SubjectStingRay is a page.
	"'That's scheduled for the third day, I believe,' he says."
	It is followed by StingRayTopics.
	
	StingRayTopics is a page.
	A choice called stingrtopa is for StingRayTopics.  "'That sounds awfully dangerous.'".  It triggers SubjectDangerous.
	A choice called stingrtopb is for StingRayTopics.  "'Why sting rays?'".  It triggers SubjectWhy.
	A choice called stingrtopc is for StingRayTopics.  "'A kiss?'".  It triggers SubjectKiss.  It requires STINGRAYKISS.
	A choice called stingrtopd is for StingRayTopics.  "Ask about something else."  It triggers KeithSubjects.
	
	SubjectDangerous is a page.
	"He grins.  'Well, you only live once.  Actually, sting rays tend to be very gentle animals; they hardly attack unless provoked.'"
	It is a dead end.
	
	SubjectWhy is a page.
	"He grins.  'I'm hoping to get a kiss.'"
	It gives STINGRAYKISS.  It is a dead end.
	
	SubjectKiss is a page.
	"Keith nods.  'It's supposed to bring good luck.'"
	It is a dead end.
	
	EndConversation is a page.
	"Just as well, it looks like the waiter is coming."
	It is followed by The Last Page.

Example: ** Lockable Door - How to create a door that can be locked or unlocked from the inside or outside by using an inventory item.

If we think of an Adventure Book like a traditional piece of interactive fiction, we can imagine certain pages representing the player's current location and his choices taking him from one location to another.  We might want an effect where a door is locked and requires a key to open.  We may even want to allow him to lock it again with the same key.

Here's an example implementation of a door that can be locked and unlocked from both the inside and the outside by using the key.  Notice how the uses for the key have conditions to sort between when the player is locking or unlocking the door.  Notice also how LockedDoor, LockDoor, and UnlockDoor are reused by the pages on either side of the door.

	*: "Locked Out" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The key is an inventory item.
	
	The First Page is a page.
	"It's seven o'clock in the evening.  The dim yellow street lights cast a dismal glow on the slush-covered sidewalk.  You stand on your front stoop."
	A choice called tfpa is for The First Page.  "Go inside".  It triggers GoInside.  It requires DoorUnlocked.
	A choice called tfpb is for The First Page.  "Go inside".  It triggers LockedDoor.  It is cancelled by DoorUnlocked.
	A choice called tfpc is for The First Page.  "Look under the mat."  It triggers FindKey.  It is cancelled by the key.
	A use called tfpd is for The First Page.  It triggers LockDoor.  It uses the key.  It requires DoorUnlocked.
	A use called tfpe is for The First Page.  It triggers UnlockDoor.  It uses the key.  It is cancelled by DoorUnlocked.
	
	LockedDoor is a page.
	"You take the doorknob and give it a jiggle.  It barely budges, locked tight."
	It is a dead end.
	
	FindKey is a page.
	"You lift the mat and find a small key.  Good job no burglars ever think to check."
	It gives the key.  It is a dead end.
	
	LockDoor is a page.
	"You turn the key in the lock, locking it tight."
	It removes DoorUnlocked.  It is a dead end.
	
	UnlockDoor is a page.
	"You turn the key in the lock, freeing the knob."
	It gives DoorUnlocked.  It is a dead end.
	
	GoInside is a page.
	"At last..."
	It is followed by YourHome.
	
	YourHome is a page.
	"Snug and comfortable, the perfect retreat at the end of the day."
	A choice called yha is for YourHome.  "Go outside."  It triggers GoOutside.  It requires DoorUnlocked.
	A choice called yhb is for YourHome.  "Go outside."  It triggers LockedDoor.  It is cancelled by DoorUnlocked.
	A use called yhc is for YourHome.  It triggers LockDoor.  It uses the key.  It requires DoorUnlocked.
	A use called yhd is for YourHome.  It triggers UnlockDoor.  It uses the key.  It is cancelled by DoorUnlocked.
	
	GoOutside is a page.
	"If you must..."
	It is followed by The First Page.

Example: ** Adaptive Text - How to change what's written on a page based on the game state.

In the original Adventure Book system, every page had a single, static description.  One major advantage of using Inform 7 is that you can vary the way a page is written based on how flags are set and whether inventory items are carried.  This can be very useful if you have a story where the player visits the same page many times, but it looks slightly different or slightly different things happen based on what has happened previously.

In this very simple example, the description of the cat varies depending on whether the player is holding the cat treats.

	*: "Cat Feeder" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The treats is an inventory item.
	
	The First Page is a page.
	"You're standing in your kitchen.  [if the treats is off]Your cat paces the room, bored and inattentive.[otherwise]Your cat has crossed the room to meet you, stroking itself against your ankles lovingly.[end if]".
	A choice called tfpa is for The First Page.  "Get out a box of cat treats."  It triggers GetTheTreats.  It is cancelled by the treats.
	A use called tfpb is for The First Page.  It triggers FeedYourCat.  It uses the treats.
	
	GetTheTreats is a page.
	"You open the drawer and pull out one of the boxes of cat treats."
	It gives the treats.  It is a dead end.
	
	FeedYourCat is a page.
	"Your cat happily devours every last treat from your hands, one by one.  Your usefulness spent, it returns its attention to personal matters."
	It removes the treats.  It is a dead end.

Example: *** Winning and Dying - How to add traditional "win" and "die" messages to your games.

The Adventure Book extension provides The Last Page as a tidy little "end game" menu that you can use in your stories, but the burden of printing out a message to the player to indicate success or failure falls on the author.

Suppose you'd like ending pages that look more like traditional Inform games.  This game shows you an example of how you can do just that.  Failure and Success are pages that tell the player that he has died or won, respectively.  Both choices divert to GameEnd, which displays the usual restart/restore/quit option that Inform provides automatically.  We even define an AMUSING choice as a magic word that only works at GameEnd and only if the player has gone through Success.

	*: "The Lady or the Tiger?" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	Amusing is a magic word.
	
	The First Page is a page.
	"You stand in the arena, a door to your left and a door to your right.  Which one will you choose?"
	A choice called tfpa is for The First Page.  "Left".  It triggers LeftDoor.
	A choice called tfpb is for The First Page.  "Right".  It triggers RightDoor.
	
	LeftDoor is a page.
	"You open the left door just a crack, and suddenly a monstrous tiger leaps out at you!  It gobbles you up in no time at all."
	It is followed by Failure.
	
	RightDoor is a page.
	"You open the right door to discover a beautiful woman waiting inside!  You are wed immediately."
	It is followed by Success.
	
	Failure is a page.
	"*** You have died ***".
	It is followed by GameEnd.
	
	Success is a page.
	"*** You have won ***".
	It gives AmusingChoice.  It is followed by GameEnd.
	
	GameEnd is a page.
	"Would you like to RESTART, RESTORE a saved game[if AmusingChoice is on], see some suggestions for AMUSING things to do[end if] or QUIT?"
	A use called genda is for GameEnd.  It triggers Amusement.  It uses amusing.  It requires AmusingChoice.
	
	Amusement is a page.
	"Read the original story by Frank Stockton."
	It is a dead end.

Example: **** Combat System - Using the "run inform code for..." phrase to add functionality.

Experienced Inform 7 programmers can add a lot of extra behavior to the Adventure Book system by creating custom game commands and overriding the "run inform code for..." phrase.

Some traditional adventure books, such as the Fighting Fantasy series, added a combat system and encounters with monsters to make the story feel more like an RPG.  This is a very simple example of how we can make special pages that know how to begin a monster encounter and a combat menu that can do more than just turn the player to a different page.

	*: "Dungeon Deep" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	Chapter 1 - A Simple Combat System
	
Because this is just an example, we keep the system simple.  Attack increased your chances of hitting, hit points represent your life force.

	*: Section 1 - Character Stats
	
	People have a number called hit points. People have a number called attack.
	
	The hit points of the player is 10. The attack of the player is 5.
	
	A monster is a kind of person.
	
	Section 2 - Combat

Here, we create a special kind of page called a combat setting.  It keeps track of a lot of information that will be useful when we run combat.  The monsterless page is where we turn if there are no monsters currently occupying this page.  The victory page is where we turn at the end of a successful combat, where we may grant the player treasures or other boons.  The defeat page is where we turn if the player fails in this combat.  It is usually The Last Page, but it doesn't have to be; we can create special encounters where combat isn't fatal if the player fails by making it turn to a different page.  Finally, the escape page allows us to give a page where the player can turn if he tries to escape.  Notice that, if no such page is defined, the player simply bounces back into combat.
	
	*: A combat setting is a kind of page. A combat setting has a page called the monsterless page. A combat setting has a page called the victory page. A combat setting has a page called the defeat page. A combat setting usually has defeat page The Last Page. A combat setting has a page called the escape page. A combat setting usually has escape page NoEscape. A combat setting is usually special.
	
	NoEscape is a page.
	"You can't escape!"
	It is a dead end.
	
	Current Battle is a combat setting that varies. Current Opponent is a monster that varies.

We define monsters separately from the combat setting where they are found.  This would allow us to dynamically change where monsters appear throughout the game.

	*: Inhabiting relates various monsters to one combat setting (called the home). The verb to inhabit (it inhabits, they inhabit, it inhabited, it is inhabited, it is inhabiting) implies the inhabiting relation. The verb to house (it houses, they house, it housed, it is housed, it is housing) implies the reversed inhabiting relation.

Whenever we turn to a combat setting, we first check to see if monsters are about.  If not, we go to the monsterless page.  If so, we set up our combat variables and go to the combat menu.
	
	*: To run inform code for (x - a combat setting):
		if x is not inhabited by something:
			change pages to the monsterless page of x;
		otherwise:
			now Current Battle is x;
			now Current Opponent is a random monster that inhabits x;
			read x;
			change pages to CombatMenu;

CombatMenu is a pretty normal page.  CombatAttack is where the real fun happens.  Whenever we turn to that page, we roll dice for the player and the monster, add attack bonuses, and compare the results.  The winner does 2 points of damage to the loser, and nothing happens in the event of a tie.  If either side was defeated, we tell the game to branch to the appropriate page.  Otherwise, we jump back to the CombatMenu to try again.
	
	*: CombatMenu is a page.
	"Your hit points: [hit points of the player][line break]	[Current Opponent]'s hit points: [hit points of the Current Opponent][paragraph break]	What will you do?"
	A choice called combatmenua is for CombatMenu. "Attack". It triggers CombatAttack.
	A choice called combatmenub is for CombatMenu. "Retreat". It triggers CombatRetreat.
	
	CombatAttack and CombatRetreat are special pages.
	
	To run inform code for (x - CombatAttack):
		let playerroll be a random number from 1 to 6;
		let playerroll be playerroll plus a random number from 1 to 6;
		let playerroll be playerroll plus the attack of the player;
		let monsterroll be a random number from 1 to 6;
		let monsterroll be monsterroll plus a random number from 1 to 6;
		let monsterroll be monsterroll plus the attack of the Current Opponent;
		if playerroll is greater than monsterroll:
			say "You hit for 2 points.";
			now the hit points of the Current Opponent is the hit points of the current opponent minus 2;
		if playerroll is less than monsterroll:
			say "You were hit for 2 points.";
			now the hit points of the player is the hit points of the player minus 2;
		if playerroll is monsterroll:
			say "You parry each other's attacks.";
		if the hit points of the player is less than 1:
			say "You were defeated.";
			change pages to the defeat page of the Current Battle;
			rule succeeds;
		if the hit points of the Current Opponent is less than 1:
			say "You have defeated [the Current Opponent].";
			now the Current Opponent inhabits nothing;
			if the Current Battle is inhabited by something:
				change pages to the Current Battle;
			otherwise:
				change pages to the victory page of the Current Battle;
			rule succeeds;
		change pages to CombatMenu;
	
	To run inform code for (x - CombatRetreat):
		change pages to the escape page of the Current Battle.
	
We may want to make the player gain or lose stamina as a result of events in the story beyond combat.  So we create properties to keep track of what the page can do to the player's stamina and "run inform code for..." definitions that can carry them out.

	*: Section 3 - Traps
	
	Pages have a number called hit points. A page usually has hit points 0.  A page can be trapped.  A page is usually not trapped.  A page can be healing.  A page is usually not healing.
	
	To run inform code for (x - a trapped page):
		now the hit points of the player is the hit points of the player minus the hit points of the current page;
		if the hit points of the player is less than 1:
			now the hit points of the player is 0;
			read the current page;
			change pages to The Last Page;
	
	To run inform code for (x - a healing page):
		now the hit points of the player is the hit points of the player plus the hit points of the current page;
		if the hit points of the player is greater than 10:
			now the hit points of the player is 10;
	
Finally, we define a new command, "status", that allows the player to view his hit points at any time.

	*: Section 4 - Status
	
	Table of Commands (continued)
	topic
	"status"
	
	Checking status is an action applying to nothing. Understand "status" as checking status.
	
	Carry out checking status:
		say "[status][paragraph break]";
		
	To say status:
		say "Current hit points: [the hit points of the player]";
	
And now, an example of how it all comes together.  We have one combat setting with two monsters, one room that does damage, and one room that heals.

	*: Chapter 2 - A sample game
	
	The key is an inventory item.
	
	The First Page is a page.
	"You're deep in a gloomy dungeon.  A nasty smell comes from the passage to your left.  The passage to the right smells like fresh air.  There's a sound of running water behind you.  Where will you go?"
	A choice called tfpa is for The First Page. "Go left." It triggers OrcBattle.
	A choice called tfpb is for The First Page. "Go right." It triggers TrapRoom.
	A choice called tfpc is for The First Page. "Explore the darkness in the back of the room." It triggers FountainRoom.
	
	OrcBattle is a combat setting.
	"Suddenly, you're attacked by an ugly monster!"
	It has victory page FindKey. It has monsterless page MonsterKilled. It has escape page The First Page.
	
	The Orc is a monster. It has hit points 5. It has attack 5. It inhabits OrcBattle.
	
	The Kobold is a monster. It has hit points 3. It has attack 3. It inhabits OrcBattle.
	
	FindKey is a page.
	"Exploring the room, you find a small brass key."
	It gives the key.  It is followed by MonsterKilled.
	
	MonsterKilled is a page.
	"You're in an empty room.  It looks like the scene of a recent melee."
	A choice called monsterkilleda is for MonsterKilled. "Go back." It triggers The First Page.
	
	TrapRoom is a page.
	"FWIP!  A poison dart shoots from a hidden spot in the wall.  You take one point of damage.[paragraph break][status]".
	It is trapped. It has hit points 1. It is followed by NearExit.
	
	NearExit is a page.
	"The way out is just up ahead!"
	A choice called nearexita is for NearExit. "Escape". It triggers Victory.  It requires the key.
	A choice called nearexitb is for NearExit.  "Escape".  It triggers NoKey.  It is cancelled by the key.
	A choice called nearexitc is for NearExit. "Go Back". It triggers The First Page.
	A use called nearexitd is for NearExit.  It uses the key.  It triggers Victory.
	
	NoKey is a page.
	"You try the door, but it won't open!"
	It is a dead end.
	
	Victory is a page.
	"You use the brass key to open the door.  At last, you've escaped from the dungeon!"
	It is followed by The Last Page.
	
	FountainRoom is a page.
	"You find a fountain of healing and drink your fill.[paragraph break][status]".
	It is healing. It has hit points 10.  It is a dead end.
		
Example: **** Placebo! - A complete adventure game in Adventure Book format.

Placebo! is an example of how to make a game that behaves more or less like a traditional piece of interactive fiction using the Adventure Book interface.  There are commands that allow the player to move between different locations, interact with his surroundings, and acquire and use inventory items.  Play through it to see the sorts of effects that are possible with Adventure Book, and read through the code at your own pace to see how it's done.  Feel free to adopt or adapt any of the techniques in this story to your own projects.

	*: "Placebo!" by Edward Griffiths
	
	Include Adventure Book by Edward Griffiths
	
	The bread, the sack, the amusing, the sword, the stone, the goldenpear, the wand, and the license are inventory items.
	
	The First Page is a page.
	"   An evil magician known only as The Mad Hermit is causing terror throughout
	the land of Placebo, and you're as good a person as any to put a stop to him. 
	So, laying aside your afternoon plans, you decide to head off on an adventure."
	A choice called tfpa is for The First Page.  "Journey forth!"  It triggers YourHouse.
	
	YourHouse is a page.
	"Your house is a rather modest little shack near the edge of town.  It keeps
	the wind and the rain out on sunny days."
	A choice called yha is for YourHouse.  "Venture forth".  It triggers Road.
	A choice called yhb is for YourHouse.  "Consider the loaf of bread on the table".  It triggers Considerbread.  It is cancelled by BREADGONE.
	
	Road is a page.
	"A dusty road winds its way through the countryside.  Which way would you like
	to follow it?"
	A choice called roada is for Road.  "Back to your house".  It triggers YourHouse.
	A choice called roadb is for Road.  "Into town".  It triggers Town.
	A choice called roadc is for Road.  "Into the forbidden forest".  It triggers Forest1.
	
	Forest1 is a page.
	"You are in a maze of twisty little trees, all alike."
	A choice called Forest1a is for Forest1.  "Go North".  It triggers Road.
	A choice called Forest1b is for Forest1.  "Go South".  It triggers Forest2.
	A choice called Forest1c is for Forest1.  "Search through the grass for no reason".  It triggers FindNothing.
	
	Forest2 is a page.
	"You are in a maze of twisty little trees, all alike."
	A choice called Forest2a is for Forest2.  "Go North".  It triggers Forest1.
	A choice called Forest2b is for Forest2.  "Go East".  It triggers Forest3.
	A choice called Forest2c is for Forest2.  "Search through the grass for no reason".  It triggers FindNothing.
	
	Forest3 is a page.
	"You are in a maze of twisty little trees, all alike."
	A choice called Forest3a is for Forest3.  "Go North".  It triggers Forest1.
	A choice called Forest3b is for Forest3.  "Go West".  It triggers Forest2.
	A choice called Forest3c is for Forest3.  "Go East".  It triggers Forest4.
	A choice called Forest3d is for Forest3.  "Search through the grass for no reason".  It triggers FindNothing.
	
	Forest4 is a page.
	"You are in a maze of twisty little trees, all alike."
	A choice called Forest4a is for Forest4.  "Go North".  It triggers Forest5.
	A choice called Forest4b is for Forest4.  "Go West".  It triggers Forest3.
	A choice called Forest4c is for Forest4.  "Search through the grass for no reason".  It triggers FindNothing.
	
	LeaveSack is a page.
	"Yeah, no way is that going to turn out to be useful."
	It is followed by Forest5.
	
	KnightSpeak is a page.
	"The knight seems a bit anxious, as though he wishes you were somebody else's
	problem right now.  What would you like to try and talk to him about?"
	It is followed by KnightTopics.
	
	KnightGoing is a page.
	"The knight takes no pains to be courteous.  'I'm guarding a bridge.  How do
	you think I'm doing?'"
	It is a dead end.
	
	KnightHermit is a page.
	 "'We've got the situation well in hand, thank you very much,' the knight
	explains in that cool sort of tone that completely fails to mask the speaker's
	annoyance."
	It is a dead end.
	
	KnightLicense is a page.
	"'Yes, new law that's just been passed,' the knight says brightly, eager to
	pass on any bit of bad news he can.  'Can't have just anyone galavanting off to
	the Mystic Mountains after all.  Only licensed adventurers are allowed across
	the bridge.  Take it up with the king, if you like.'".
	It gives LICENSEFROMKING.  It is a dead end.
	
	King is a page.
	"The king of Placebo likes to have an open-door policy with his subjects, so
	it's no trouble whatsoever to have an audience with him.  You're guided through
	the halls of the castle and taken directly to the throne room, well ahead of the
	hundreds of others who had been waiting all day to speak with the king.  You
	make no friends this day. 
	    
	What would you like to speak with the king about?"
	It is followed by KingTopics.
	
	KingGoing is a page.
	"The king chortles.  'Nabad.'".
	It is a dead end.
	
	KingHermit is a page.
	"The king laughs.  'I dunno.'".
	It is a dead end.
	
	NoMoney is a page.
	"The king chuckles.  'Sucks to be you!'".
	It is followed by KingTopics.
	
	CrossBridge is a page.
	"As you approach the bridge, the knight holds out his sword, barring your
	progress.  'License, please,' he demands in a bored tone."
	It gives BRIDGEBARRED.
	A choice called cba is for CrossBridge.  "Talk to the knight".  It triggers KnightSpeak.
	A choice called cbb is for CrossBridge.  "Find a different way across".  It triggers ClimbDown.
	A choice called cbc is for CrossBridge.  "Return to town".  It triggers Town.
	A use called cbd is for CrossBridge.  It triggers TakeBridge.  It uses the license.
	
	TakeBridge is a page.
	"The knight scowls, takes the license from you, scowls harder, examines it,
	grits his teeth, and returns it to you.  'Fine, cross,' he says.
	    
	The bridge swings a bit, but it's sound.  You make it safely to the other
	side."
	It is followed by Valley.
	
	FindNothing is a page.
	"Not sure what you expected to find, just searching through the grass at
	random, but it's not here."
	It is a dead end.
	
	FindStone is a page.
	"Not sure what -- oh wait, there's a small, smooth blue stone sitting here. 
	Want to take it with you?"
	A choice called fsa is for FindStone.  "Take the stone".  It triggers TakeStone.
	A choice called fsb is for FindStone.  "Leave it where it is".  It triggers LeaveStone.
	
	LeaveStone is a page.
	"Yeah, what are the odds of finding something essential to your quest just by
	digging around in the grass twice in one day?"
	It is followed by Valley.
	
	EatPudding is a page.
	"It's some good pudding all right.  You eat your fill, but the puddle never
	grows smaller."
	It is followed by Valley.
	
	Wizard is a page.
	"You find the local wizard in the study of his tower, sitting behind a table
	that's covered in dusty tomes.  He looks up from his reading and blinks at you
	with bleary eyes.  'Oh hi.'  And with that, he returns to his reading.  
	     
	Did you have anything you wanted to talk to him about?"
	It is followed by WizardTopics.
	
	WizardHello is a page.
	"The wizard doesn't even look up.  'Hey,' he mumbles, distracted."
	It is a dead end.
	
	WizardGoing is a page.
	"The wizard shrugs noncommittally."
	It is a dead end.
	
	WizardHermit is a page.
	"'Yeah, that guy really pisses me off,' the wizard mumbles flatly.  'Gives
	wizards a bad name, y'know?'".
	It is a dead end.
	
	WizardRobbery is a page.
	"You browse the shelves of the wizard's study.  He doesn't care.  Your eyes
	fall on a rather beautiful gold ring.  Wanna take it?"
	A choice called wra is for WizardRobbery.  "Take the ring".  It triggers TakeRing.
	A choice called wrb is for WizardRobbery. "Leave the ring".  It triggers WizardTopics.
	
	TakeRing is a page.
	"As you touch the ring, you suddenly feel your fingertips go numb.  The
	feeling spreads down your arm and envelops your body.  As you turn to stone, the
	wizard glances up from his reading, blinks once, and looks down again.  'Yeah,
	don't touch anything,' he warns you.
	
	*** You are STONED ***".
	It is followed by The Last Page.
	
	WizardPear is a page.
	"The wizard frowns slightly.  'The dragon guards those,' he mutters.  'Give
	him some bread or something and he'll give you one.'"
	It gives DRAGONDISCUSSED.  It is a dead end.
	
	WizardDragon is a page.
	"The wizard bobs his head distractedly.  'Up in the Mystic Mountains.'"
	It is a dead end.
	
	WrongChoice is a page.
	"NO."
	It is a dead end.
	
	DestroyBoulder is a page.
	"You wave the magic wand at the boulder, and presto!  No more boulder.  You
	continue up the mountain path until you reach a deep, dark cave."
	It gives BOULDERREMOVED.  It is followed by DragonLair.
	
	DragonResponse is a page.
	"The dragon considers you for a thoughtful moment and comes to the conclusion
	that you're probably pretty nutritious.  He pops you in his mouth and swallows
	you whole.  His stomach isn't much of a conversationalist either.
	
	*** You are DIED ***".
	It is followed by The Last Page.
	
	DragonAttack is a page.
	"With what, your bare hands?"
	A choice called daa is for DragonAttack.  "Yes".  It triggers DragonFight.
	A choice called dab is for DragonAttack.  "No".  It triggers DragonLair.
	A use called dac is for DragonAttack.  It triggers DragonTransform.  It uses the wand.
	
	DragonTransform is a page.
	"With a wave of your magic wand, the dragon is transformed into cheese."
	It gives DRAGONCHEESE.  It is followed by CheeseLair.
	
	DragonLair is a page.
	"You're in an especially dark and spooky cave, most of which is taken up by a
	very large red dragon, who's lounging about as dragons tend to do."
	A choice called dla is for DragonLair.  "Speak with the dragon".  It triggers DragonSpeak.
	A choice called dlb is for DragonLair.  "Attack the dragon".  It triggers DragonAttack.
	A choice called dlc is for DragonLair.  "Retreat back down the mountain path".  It triggers Valley.
	A use called dld is for DragonLair.  It triggers DragonFeed.  It uses the bread.
	
	EatCheese is a page.
	"You break off a chunk to munch on.  It's some good cheese.  A deep
	orange-yellow, creamy and mild."
	It is a dead end.
	
	Town is a page.
	"The streets of Placebo bustle chaotically as people go about their daily
	business.  Someone around here must know something about the whereabouts of the
	Mad Hermit.  Where would you like to go?"
	A choice called towna is for Town.  "See if anyone at the local bar knows anything".  It triggers Bar.
	A choice called townb is for Town.  "Consult with the king".  It triggers King.
	A choice called townc is for Town.  "Pay a visit on the wizard".  It triggers Wizard.
	A choice called townd is for Town.  "Press on to the mystic mountains".  It triggers Bridge.
	A choice called towne is for Town.  "Take the road into the forest".  It triggers Road.
	
	PatronTalk is a page.
	"You sit yourself down next to a particularly inebriated fellow at the bar. 
	He looks up at you blankly."
	It is followed by PatronTopics.
	
	PatronResponse is a page.
	"The patron stares at you blankly."
	It is a dead end.
	
	PatronPhilosophy is a page.
	"What follows is a lengthy and enlightening discussion of philosophical
	theories and musings, including a comparison and contrast of Eastern and Western
	religious movements, the strengths and weaknesses of socialism and capitalism,
	and a lively argument about the impact that Aristotle had on modern
	philosophical thought.  The hours pass, and round after round of beer is brought
	forth.  You find a soulmate in this bar patron, but alas, he has to be moving
	on.  As he takes his leave, you muse over the whims of fate that connect two
	people for an afternoon, and the way one life can touch so many others."
	It gives PATRONGONE.  It is followed by Bar.
	
	KnightPear is a page.
	"The knight gives you a steady look.  'I'm sorry, I seem to have left my fruit
	cart at home today.'"
	It is a dead end.
	
	KingPear is a page.
	"The king guffaws.  'Pfff, I don't do any of that magic crap.'"
	It is a dead end.
	
	KingTopics is a page.
	A choice called KingTopA is for KingTopics.  "'So, how's it going?'".  It triggers KingGoing.
	A choice called KingTopB is for KingTopics.  "'Where is the Mad Hermit?'".  It triggers KingHermit.
	A choice called KingTopC is for KingTopics.  "'I understand I need a license to go to the Mystic Mountains.'".  It triggers KingLicense.  It requires LICENSEFROMKING.  It is cancelled by the license.
	A choice called KingTopD is for KingTopics.  "'Do you know where I could find a golden pear?'"  It triggers KingPear.  It requires PEARNEEDED.  It is cancelled by the goldenpear.
	A choice called KingTopE is for KingTopics.  "Leave the castle".  It triggers Town.
	
	PatronTopics is a page.
	A choice called PatronTopA is for PatronTopics.  "'So, how's it going?'".  It triggers PatronResponse.
	A choice called PatronTopB is for PatronTopics.  "'Know where I could find the Mad Hermit?'".  It triggers PatronResponse.
	A choice called PatronTopC is for PatronTopics.  "'Have you ever heard of the golden pear?'".  It triggers PatronResponse.  It requires PEARNEEDED.  It is cancelled by the goldenpear.
	A choice called PatronTopD is for PatronTopics.  "'Care to discuss your philosophical views?'".  It triggers PatronPhilosophy.
	A choice called PatronTopE is for PatronTopics.  "'I'll just be on my way then.'"  It triggers Bar.
	
	WizardTopics is a page.
	A choice called WizardTopA is for WizardTopics. "'Umm... hello?'".  It triggers WizardHello.
	A choice called WizardTopB is for WizardTopics.  "'How's it going?'".  It triggers WizardGoing.
	A choice called WizardTopC is for WizardTopics. "'How about that Mad Hermit then?'".  It triggers WizardHermit.
	A choice called WizardTopD is for WizardTopics.  "'Do you know where I could find a golden pear?'".  It triggers WizardPear.  It requires PEARNEEDED.  It is cancelled by the goldenpear.
	A choice called WizardTopE is for WizardTopics.  "'... A dragon, eh?'".  It triggers WizardDragon.  It requires DRAGONDISCUSSED.  It is cancelled by the goldenpear.
	A choice called WizardTopF is for WizardTopics.  "Go through his stuff while he's not looking".  It triggers WizardRobbery.
	A choice called WizardTopG is for WizardTopics.  "Just turn around and walk away".  It triggers Town.
	A use called WizardTopH is for WizardTopics.  It triggers WizardStone.  It uses the stone.
	
	DragonSpeak is a page.
	"What would you like to talk with the dragon about?"
	A choice called dragspa is for DragonSpeak.  "'How's it going?'".  It triggers DragonResponse.
	A choice called dragspb is for DragonSpeak.  "'Do you know where the Mad Hermit is?'".  It triggers DragonResponse.
	A choice called dragspc is for DragonSpeak.  "'So tell me a little bit about your political views.'".  It triggers DragonResponse.
	A choice called dragspd is for DragonSpeak.  "'I don't suppose you know where I could get a golden pear?'"  It triggers DragonResponse.  It requires PEARNEEDED.
	A choice called dragspe is for DragonSpeak.  "'Well, see ya.'".  It triggers DragonLair.
	
	SolveMaze is a page.
	"Surprised at how simple the maze was, you continue to the next room of the
	Mad Hermit's dungeon."
	It is followed by Dungeon2.
	
	Dungeon1 is a page.
	"You find yourself in a dungeon corridor that stretches off in all directions,
	with passages winding around like a cow's intestines, with no path leading back
	the way it came from in a perverted orgy of nonlinearity."
	A choice called dun1a is for Dungeon1.  "Easily stumble upon the correct way through the maze".  It triggers SolveMaze.
	A choice called dun1b is for Dungeon1.  "Mess about with the thing for hours and never really get anywhere".  It triggers Dungeon1.
	
	Dungeon2 is a page.
	"You find yourself in a room that looks like it was drawn on graph paper, its
	stone walls made in a perfectly straight square.  Nine square tiles, each
	exactly five feet long on each side, line the floor.  Either end of the room has
	a door, each exactly five feet wide."
	A choice called dun2a is for Dungeon2.  "Press on to the next room".  It triggers Dungeon3.
	A choice called dun2b is for Dungeon2.  "Return to the maze".  It triggers Dungeon1.
	A choice called dun2c is for Dungeon2.  "Take a closer look at that sword sticking out of the stone in the middle of the room".  It triggers ExamineSword.  It is cancelled by the sword.
	
	SwordOptions is a page.
	A choice called swoopa is for SwordOptions.  "Take the sword".  It triggers TakeSword.
	A choice called swoopb is for SwordOptions.  "Leave it alone".  It triggers Dungeon2.
	A use called swoopc is for SwordOptions.  It triggers WandSword.  It uses the wand.
	
	ExamineSword is a page.
	"Sure enough, you discover a sword stuck in a rock sitting in the exact center
	of the room.  An inscription is carved into the rock:
	   
	   'Let he who has shown his courage and valour come forward and take this sword
	from the rock, for it will vanquish evil.'".
	It is followed by SwordOptions.
	
	KnightTopics is a page.
	A choice called knigtopa is for KnightTopics.  "'So, how's it going?'"  It triggers KnightGoing.
	A choice called knigtopb is for KnightTopics.  "'So, how about that Mad Hermit guy?'"  It triggers KnightHermit.
	A choice called knigtopc is for KnightTopics.  "'Wait, what's this about a license?'"  It triggers KnightLicense.  It requires BRIDGEBARRED.  It is cancelled by the license.
	A choice called knigtopd is for KnightTopics.  "'I don't suppose you know where I could find a golden pear.'"  It triggers KnightPear.  It requires PEARNEEDED.  It is cancelled by the goldenpear.
	A choice called knigtope is for KnightTopics. "'See you around.'"  It triggers Bridge.
	
	Bar is a page.
	"This is a shady little establishment near the edge of town.  If anyone knows
	the whereabouts of a rogue wizard, it'd be the people who frequent this place."
	A choice called bara is for Bar.  "Speak to the bartender".  It triggers BartenderTalk.
	A choice called barb is for Bar.  "Speak to a random patron".  It triggers PatronTalk.  It is cancelled by PATRONGONE.
	A choice called barc is for Bar.  "Make good your escape".  It triggers Town.
	
	BartenderBeer is a page.
	"The bartender shakes his head.  'No you won't.  We don't take kindly to your
	type here.'"
	It is a dead end.
	
	BartenderGoing is a page.
	"The bartender nods solemnly.  'It's been better.'"
	It is a dead end.
	
	BartenderHermit is a page.
	"The bartender grins as well as anyone who's missing half of his teeth can. 
	'Well now.  That sort of information will cost you.'  He lowers his voice.  'You
	want to deal with dark wizards?  You bring me some magic power.  I want the
	legendary golden pear.'"
	It gives PEARNEEDED.  It is followed by BartenderBribe.
	
	BartenderInfo is a page.
	"The bartender grins an especially wicked and nasty grin, pocketing the golden
	pear.  'So, you'd like to meet the Mad Hermit, would you?'  You notice for the
	first time that you're standing between two burly-looking humanoids with green,
	warty skin and yellow, crooked teeth.  'Well, allow me to provide an escort for
	you.'    
	       
	Something strikes you in the back of the head.  Everything goes black. 
	There's no way to tell how long it's been before you regain consciousness..."
	It removes the goldenpear.  It is followed by Dungeon1.
	
	BartenderPear is a page.
	"The bartender smirks.  'Not my problem, is it?'"
	It is a dead end.
	
	BartenderStone is a page.
	"The bartender palms the small blue stone, showing genuine interest.  At
	length, he drops it back in your hand.  'Might make a nice magic wand, but it's
	not what I'm looking for.  I want something bigger.'"
	It is a dead end.
	
	BartenderTalk is a page.
	"The bartender is a crooked and misshapen man.  He looks like he was put
	together from mismatched body parts and they did a rush job on all the joints. 
	He eyes you with the sort of look that occurs in the natural world when one
	animal wants another animal to piss the hell off.  'What can I get for you?' he
	asks, the words slithering from his throat."
	It is followed by BartenderTopics.
	
	BartenderTopics is a page.
	A choice called barttopa is for BartenderTopics.  "'How's it going?'".  It triggers BartenderGoing.
	A choice called barttopb is for BartenderTopics.  "'I'll have a beer.'".  It triggers BartenderBeer.
	A choice called barttopc is for BartenderTopics.  "'Know where I could find the Mad Hermit?'".  It triggers BartenderHermit.
	A choice called barttopd is for BartenderTopics.  "'Know where I could find a golden pear?'"  It triggers BartenderPear.  It requires PEARNEEDED.  It is cancelled by the goldenpear.
	A choice called barttope is for BartenderTopics.  "'I'll be on my way then.'".  It triggers Bar.
	
	BartenderWand is a page.
	"The bartender picks up the magic wand you offer him, his face somehow
	managing to contort even further than it already was.  He tosses it back at you
	in disgust.  'Don't bribe me with toys,' he spits."
	It is a dead end.
	
	BlockedPath is a page.
	"The trail winds its way up the side of a mountain.  About halfway up, the
	path is suddenly blocked by an enormous boulder."
	It is followed by BoulderOptions.
	
	BoulderOptions is a page.
	A choice called boulopa is for BoulderOptions.  "Move the boulder".  It triggers WrongChoice.
	A choice called boulopb is for BoulderOptions.  "Go around the boulder".  It triggers WrongChoice.
	A choice called boulopc is for BoulderOptions.  "Eat the boulder".  It triggers WrongChoice.
	A choice called boulopd is for BoulderOptions.  "Take the boulder".  It triggers WrongChoice.
	A choice called boulope is for BoulderOptions.  "Jump over the boulder".  It triggers WrongChoice.
	A choice called boulopf is for BoulderOptions.  "Talk to the boulder".  It triggers WrongChoice.
	A choice called boulopg is for BoulderOptions.  "Burn the boulder".  It triggers WrongChoice.
	A choice called bouloph is for BoulderOptions.  "Meekly retreat to the valley".  It triggers Valley.
	A use called boulopi is for BoulderOptions.  It triggers DestroyBoulder.  It uses the wand.
	
	Bridge is a page.
	"The town of Placebo ends abruptly at the edge of a cliff.  A long suspension
	bridge made of rope and planks leads across a deep, wide chasm.  On the other
	side are the mystic mountains.  A knight is standing guard by the bridge."
	A choice called bridgea is for Bridge.  "Speak with the guard".  It triggers KnightSpeak.
	A choice called bridgeb is for Bridge.  "Cross the bridge".  It triggers CrossBridge.
	A choice called bridgec is for Bridge.  "Climb down into the chasm".  It triggers ClimbDown.
	A choice called bridged is for Bridge.  "Return to town".  It triggers Town.
	
	CheeseLair is a page.
	"You're in an especially dark and spooky cave, most of which is taken up by a
	very large yellow cheese, which is lounging around the way a dragon might."
	A choice called chelaa is for CheeseLair.  "Eat some of the cheese".  It triggers EatCheese.
	A choice called chelab is for CheeseLair.  "Go back down to the valley".  It triggers Valley.
	
	CheesePath is a page.
	"You climb the mountain path to the dragon's lair."
	It is followed by CheeseLair.
	
	ClearPath is a page.
	"You climb the mountain path to the dragon's lair."
	It is followed by DragonLair.
	
	ClimbDown is a page.
	"You start to lower yourself over the edge of the cliff, feeling with your
	feet for a place to rest your weight.  Your arms start to get sore from
	supporting your weight, and you're suddenly terrifyingly aware of the deadly
	drop below you.   
	      
	'That's not very safe,' the knight calls over helpfully.   
	      
	But finally, you feel a foothold.  You give it a strong kick.  It doesn't
	budge.  You rest your weight on it.  Solid.  You take a deep breath.   
	      
	And then you're suddenly swarmed by thousands of carnivorous centipedes,
	which eat you alive.
	
	*** YOU ARE DIED***".
	It is followed by The Last Page.
	
	Considerbread is a page.
	"It's really a lovely loaf of bread, baked to a golden brown on the outside,
	with the texture of the grain still visible.  You could eat it if you like, or
	take it with you."  
	A choice called conbreada is for ConsiderBread.  "Eat the bread".  It triggers EatBread.
	A choice called conbreadb is for ConsiderBread.  "Take it with you".  It triggers TakeBread.
	A choice called conbreadc is for ConsiderBread.  "Leave it here for now".  It triggers YourHouse.
	
	EatBread is a page.
	"You devour the bread, every single crumb.  It takes you no closer to
	defeating the Mad Hermit, and naturally the game is unwinnable now, but it's
	worth it.  It's just that good."
	It gives BREADGONE.  It is followed by YourHouse.
	
	TakeBread is a page.
	"Smart thinking.  Sooner or later you're bound to run into some sort of
	monster that needs to be fed.  You tuck it away until you need it.
	   
	(Type BREAD instead of an option when you want to use it.)".
	It gives the bread.  It gives BREADGONE.  It is followed by YourHouse.
	
	TakeSword is a page.
	"You grab the handle of the sword and gently lift...  
	     
	... Then you lift a little harder...  
	     
	... Then you pull as hard as you can with both hands...  
	     
	... Then you stop trying before you give yourself a hernia."
	It is a dead end.
	
	TakeStone is a page.
	"Hey, they wouldn't give you the option to pick it up if it wasn't important,
	eh?  As you touch the stone, you feel a gentle vibration in your fingertips. 
	When you stand again, a bolt of electricity suddenly leaps from the stone,
	turning a nearby patch of grass into tapioca pudding.  Oh, so it's a magic
	stone.  Well that's neat. 
	   
	(Type STONE instead of an option when you want to use it.)"
	It gives STONEMOVED.  It gives the stone.  It is followed by Valley.
	
	WizardStone is a page.
	"You pull the blue stone out of your pocket and hold it out for the wizard to
	see.  It's the first thing to get his attention since you walked in.  He looks
	up, dazed, and takes it from your hand, studying it like a cat would study a
	mouse.   
	      
	'Huh.  Not bad.'  He opens a drawer in his desk and pulls out a stick.  He
	fastens the stone to the end with a bit of twine and sets the creation in your
	hand.  'There you go.'  He's returned to his book before he even finishes
	addressing you.  'Magic wand.  That should clear out some obstacles for you.' 
	He sniffs loudly to celebrate the end of the conversation.
	   
	(Type WAND instead of an option when you want to use it.)".
	It gives the wand.  It removes the stone.  It is a dead end.
	
	DragonFeed is a page.
	"The dragon perks.  Nothing gets a dragon's appetite going like the sweet,
	sweet taste of fresh homemade bread.  He snatches it away from you, nearly
	taking your hands with it, gulps it down, and licks his snout clean.  So
	grateful is he that he produces from nowhere a single golden pear, which he
	offers to you in a gesture of thanks.  And since it's a good idea to accept
	anything a dragon might offer you, you slip it into your pocket.
	   
	(Type GOLDENPEAR instead of an option when you want to use it.)".
	It gives the goldenpear.  It removes the bread.  It is followed by DragonLair.
	
	WandSword is a page.
	"With a wave of your magic wand, the stone turns into a very surprised beaver.
	 It screams out in pain and expires one and a half seconds later, unable to
	survive with a sword wedged in its back.  The blade comes out easily -- you wipe
	it off on a clean patch of beaver fur and carry it along with you.  
	     
	(Type SWORD instead of an option when you want to use it.)".
	It gives the sword.  It is followed by Dungeon2.
	
	Valley is a page.
	"You're standing in a particularly pleasant valley in the Mystic Mountains. 
	It's the sort of place where talking rabbits might sit on giant toadstools and
	have tea parties with little magic fairies.  A path leads up into the mountains,
	and the suspension bridge leads back across the chasm to Placebo town."
	A choice called valleya is for Valley.  "Follow the path into the mountains".  It triggers BlockedPath.  It is cancelled by BOULDERREMOVED.
	A choice called valleyb is for Valley.  "Follow the path into the mountains".  It triggers ClearPath.  It requires BOULDERREMOVED.  It is cancelled by DRAGONCHEESE.
	A choice called valleyc is for Valley.  "Follow the path into the mountains".  It triggers CheesePath.  It requires BOULDERREMOVED.  It requires DRAGONCHEESE.
	A choice called valleyd is for Valley.  "Go back across the bridge".  It triggers Town.
	A choice called valleye is for Valley.  "Search through the grass for no reason".  It triggers FindStone.  It is cancelled by STONEMOVED.
	A choice called valleyf is for Valley.  "Search through the grass for no reason".  It triggers FindNothing.  It requires STONEMOVED.
	A choice called valleyg is for Valley.  "Try some of the tapioca pudding".  It triggers EatPudding.  It requires STONEMOVED.
	
	HermitZap is a page.
	"You get too close to the Hermit's staff and an arc of electricity leaps into
	your body, frying you to death.  The Mad Hermit eats your ears off and fashions
	your arms into hockey sticks.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitWand is a page.
	"You wave the magic wand at the Mad Hermit, but as the wave of magical energy
	hits him, the wand starts to vibrate like it's electrified.  The wand kicks back
	and transforms you into a mouse.   
	      
	'BLINKY!!!  Y'AVE COME HOME!!!' the Mad Hermit shrieks.  He picks you up by
	the tail and swallows you whole.  Then he dances around the room like a chicken
	and makes farting noises.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitKill is a page.
	"Seeing your opportunity, you lunge forward and slice the Mad Hermit's head
	off.  His body does a stupid little dance and falls over."
	It is followed by Endgame.
	
	Dungeon3 is a page.
	"You enter a wide, ominous chamber.  There are no walls and no ceiling to be
	seen, nothing but the door you entered from.  Smoke spills across the floor in
	deep whisps.  The darkness is complete, except for a single ray of moonlight
	that shines on a figure in the center of the room.  His body is hidden by purple
	robes.  Spidery fingers clutch the end of a long wooden staff.  His face is thin
	and hairy, and his eyes are wild.    
	       
	You've found him at last.  The Mad Hermit.  
	     
	'PANCAKES!!!' the wizard screams, waving his staff around wildly.  'IT'S TOO
	LATE!!!  YOU'RE THANKSGIVING!!!'"
	A choice called dun3a is for Dungeon3.  "Talk to him".  It triggers HermitTalk.
	A choice called dun3b is for Dungeon3.  "Attack him".  It triggers HermitAttack.
	
	HermitTalk is a page.
	"What would you like to say to him?"
	A choice called hermtalka is for HermitTalk.  "'So, how's it going?'".  It triggers HermitGoing.
	A choice called hermtalkb is for HermitTalk.  "'Hey, think you could end your reign of terror?'".  It triggers HermitEndreign.
	A choice called hermtalkc is for HermitTalk.  "'Get ready to die!'".  It triggers HermitGetready.
	A choice called hermtalkd is for HermitTalk.  "Never mind."  It triggers HermitDontattack.
	
	HermitGoing is a page.
	"'I'M GOING FOR A WHOLE NEW STYLE!!!'  He swings his staff like a baseball bat
	and knocks your head clean off your body.
	
	*** YOU ARE DIED***".
	It is followed by The Last Page.
	
	HermitGetready is a page.
	"'AUNTIE WANTS A KISS!!!'  The Mad Hermit bends over and points his rear end
	at you, which shoots out a huge burst of flame.  As your body smoulders, the Mad
	Hermit beats it with his staff, screaming, 'CHRISTMAS BELLS, CHRISTMAS BELLS,
	CHRISTMAS ALL THE WAY!!!'".
	It is followed by The Last Page.
	
	HermitEndreign is a page.
	"'MAKE ROOM FOR GRANDMA!!!' the Mad Hermit shrieks, exploding with the force
	of a nuclear warhead.  You're vaporized instantly, along with the entire city of
	Placebo.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitAttack is a page.
	"With what, your bare hands?"
	A choice called hermattacka is for HermitAttack.  "Yes".  It triggers HermitBarehands.
	A choice called hermattackb is for HermitAttack.  "No".  It triggers HermitDontattack.
	A use called hermattackc is for HermitAttack.  It triggers HermitWand.  It uses the wand.
	A use called hermattackd is for HermitAttack.  It triggers HermitSword.  It uses the sword.
	
	HermitFallingRocks is a page.
	"As you head for cover, the Mad Hermit raises his staff over his head and
	screams, 'I CAN ALREADY SMELL YOUR JUICY MEATS!!!'  And then he launches into
	the air, through the hole in the ceiling high above, into the sky, and far, far
	out of sight until he hurls screaming into the very center of the sun, which
	causes it to explode and take the rest of the solar system with it.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitSword is a page.
	"You draw your sword and attack.  The wizard parries your first blow with his
	staff, then the second.  With a wild hyena laugh, he grabs his staff in his
	teeth and continues to parry your blows by swinging his head about.  When he
	sees a break in your offense, he spins himself in a circle, cracking you over
	the head with either end of his staff.      
	         
	You slump to the ground, and he starts beating you with his staff, shrieking,
	'WHERE'S MY CANDY!!!'"
	A choice called hermswoa is for HermitSword.  "Try to trip him up".  It triggers HermitTrip.
	A choice called hermswob is for HermitSword.  "Try to block his attacks".  It triggers HermitDefend.
	
	HermitDefend is a page.
	"You curl up on the floor, trying to protect your vital organs from attack.  
	
	'GET OFF OF HER!!!' the Mad Hermit screams.  'LET HER BREATHE!!!'  He grabs
	your head in both hands and twists counterclockwise until it comes off.  He
	beats himself over the head with your skull, chanting, 'PORK!!!  PORK!!! 
	PORK!!!  PORK!!!  PORK!!!  PORK!!!'
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitTrip is a page.
	"You grab the Mad Hermit's feet and yank as hard as you can.  Much to your
	surprise, they yank right back.  Before you realize what's going on, you're
	pulled off the ground and into the darkness that surrounds you.  Your center of
	balance rocks about like dice in a tumbler as you fly a chaotic, zigzagging
	course through the air.  The Mad Hermit smacks his staff down into your skull
	repeatedly, cackling, 'PETER PETER PUMPKIN HEATER!!!  HAD A WIFE THAT LET HIM
	EAT HER!!!'"
	A choice called hermtripa is for HermitTrip.  "Hang on for dear life".  It triggers HermitHangon.
	A choice called hermtripb is for HermitTrip.  "Let go".  It triggers HermitLetgo.
	A use called hermtripc is for HermitTrip.  It triggers HermitMidairSword.  It uses the sword.
	
	HermitFly is a page.
	"You aren't a quick learner."
	It is followed by HermitSplat.
	
	HermitSplat is a page.
	"The fall isn't so bad, but the sudden stop at the end is a killer.  The Mad
	Hermit throws himself into your entrails and rolls around, sobbing, 'I'M NOT
	BUYING ANY MORE APPLES!!!'
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitHangon is a page.
	"'IT TAKES TWO TO TANGO!!!' the Mad Hermit declares, driving his staff
	straight through your eye and into your brain.  You forget how to do algebra,
	and then how to breathe.  Deprived of the two things that make life worthwhile,
	you expire.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitDontattack is a page.
	"Before you can decide on another course of action, the Mad Hermit screams,
	'MARY!!! YER COVERED WITH LEECHES!!!'  He descends upon you like a bird of prey,
	smacking you about with his staff, shrieking at the top of his voice, 'KEEP 'EM
	BACK!!!  KEEP 'EM BACK!!!  KEEP 'EM BACK!!!'"
	A choice called hermdonatta is for HermitDontattack.  "Fight back".  It triggers HermitStruggle.
	A choice called hermdonattb is for HermitDontattack.  "Go on the defensive".  It triggers HermitDefend.
	A use called hermdonattc is for HermitDontattack.  It triggers HermitWand.  It uses the wand.
	A use called hermdonattd is for HermitDontattack.  It triggers HermitSword.  It uses the sword.
	
	HermitStruggle is a page.
	"You reach out and grab the Mad Hermit's staff.  His eyes go so wide that they
	start to squeeze out of their sockets as a struggle ensues.  He gives one good,
	hard twist and sends you rolling to the ground.  'I'M NOT WEARING YOUR BOOTS!!!'
	he cackles victoriously.  He waves the staff at you and sends you hurtling up in
	the air.  You're several hundred feet high before you start to descend once
	again."
	A choice called hermstruga is for HermitStruggle.  "Fall to your death".  It triggers HermitSplat.
	A choice called hermstrugb is for HermitStruggle.  "Learn how to fly".  It triggers HermitFly.
	A use called hermstrugc is for HermitStruggle.  It triggers HermitJello.  It uses the wand.
	
	HermitLetgo is a page.
	"You let go and tumble through space."
	A choice called hermletgoa is for HermitLetgo.  "Plummet to your death".  It triggers HermitSplat.
	A choice called hermletgob is for HermitLetgo.  "Learn how to fly".  It triggers HermitFly.
	A use called hermletgoc is for HermitLetgo.  It triggers HermitJello.  It uses the wand.
	
	Endgame is a page.
	"The Mad Hermit lies dead at your feet.  The reign of terror is finally over,
	and the land of Placebo can once again be free.   
	      
	You consider the magic staff lying next to the wizard's lifeless body.  And
	suddenly, you realize what you must do next."
	It gives amusing.  It is followed by EndingChoices.
	
	EndingChoices is a page.
	A choice called endchoicea is for EndingChoices.  "Begin your next quest".  It triggers EndingHero.
	A choice called endchoiceb is for EndingChoices.  "Return to your humble home".  It triggers EndingHome.
	A choice called endchoicec is for EndingChoices.  "Take up the wizard's staff and continue his work".  It triggers EndingEvil.
	A use called endchoiced is for EndingChoices.  It triggers AmusingPage.  It uses amusing.
	
	HermitMidairSword is a page.
	"You hold onto the Mad Hermit's ankle with one hand and draw your sword with
	the other hand.  With one swing of your sword, you manage to hack off the Mad
	Hermit's leg at the shin.  Unfortunately, it was the one you were holding onto. 
	You fall through space, clutching half of a leg in one hand and a sword in the
	other.  And, somehow or other, you manage to impale yourself on your sword upon
	landing, which is great because that way you're dead slightly before every bone
	in your body is broken on impact.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	BartenderBribe is a page.
	A choice called barbribea is for BartenderBribe.  "Excuse yourself".  It triggers Bar.
	A use called barbribeb is for BartenderBribe.  It triggers BartenderWand.  It uses the wand.
	A use called barbribec is for BartenderBribe.  It triggers BartenderSack.  It uses the sack.
	A use called barbribed is for BartenderBribe.  It triggers BartenderInfo.  It uses the goldenpear.
	A use called barbribee is for BartenderBribe.  It triggers BartenderStone.  It uses the stone.
	
	BartenderSack is a page.
	"The bartender takes the sack from you and examines the contents with an even
	nastier grin.  'Thank you kindly.  Quite a generous donation.'  He slips the
	sack away, and you never see it again."
	It removes the sack.  It is followed by BartenderBribe.
	
	KingLicense is a page.
	"The king snickers.  'Yeah, it's a bureaucratic thing.  It's basically just a
	way to gouge adventurers so the railroads get more business.  But whaddaya gonna
	do?  I can get you one for a hundred gold pazoozas if you want.'"
	A choice called kinglica is for KingLicense.  "'I don't have any money.'"  It triggers NoMoney.
	A use called kinglicb is for KingLicense.  It triggers BuyLicense.  It uses the sack.
	
	BuyLicense is a page.
	"The king cackles.  'Awesome!  Here you go.'  You trade your gold pazoozas for
	a pretty sheet of paper.  Make sure to keep copies for your personal records.  
	     
	(Type LICENSE instead of an option when you want to use it.)".
	It gives the license.  It removes the sack.  It is followed by KingTopics.
	
	Forest5 is a page.
	"You are in a maze of twisty little trees, all alike."
	A choice called for5a is for Forest5.  "Go South".  It triggers Forest4.
	A choice called for5b is for Forest5.  "Go West".  It triggers Forest1.
	A choice called for5c is for Forest5.  "Search through the grass for no reason".  It triggers FindSack.  It is cancelled by SACKTAKEN.
	A choice called for5d is for Forest5.  "Search through the grass for no reason".  It triggers FindNothing.  It requires SACKTAKEN.
	
	FindSack is a page.
	"Not sure what you expected to find, searching through -- hello!  It looks
	like someone's dropped a small sack here.  Upon closer inspection, it seems to
	contain about 100 golden pazoozas.  How fortunate!"
	A choice called findsacka is for FindSack.  "Take the sack with you".  It triggers TakeSack.
	A choice called findsackb is for FindSack.  "Leave the sack where you found it".  It triggers LeaveSack.
	
	TakeSack is a page.
	"Finders keepers!  You tie the sack to your belt.   
	      
	(Type SACK instead of an option when you want to use it.)".
	It gives the sack.  It gives SACKTAKEN.  It is followed by Forest5.
	
	HermitBarehands is a page.
	"You land a solid punch in the Mad Hermit's face.  He spins around in place
	three times from the force of the punch, staggers backwards, and starts dancing
	around the room singing a showtune at the top of his voice.  'OH IT'S HAPPY!!!
	YELLOW SNAPPY!!! IT'S TRIPPY AND WITTY AND TWIRLY AND PURPLE AND GAAAAAAAAAY!!!'
	
	Rocks start to crumble from somewhere up above as he sings, and light starts
	to pour into the room."
	A choice called hermbarhana is for HermitBarehands.  "Watch out for falling rocks".  It triggers HermitFallingRocks.
	A choice called hermbarhanb is for HermitBarehands.  "Rush the wizard before he brings down the roof".  It triggers HermitRush.
	A use called hermbarhanc is for HermitBarehands.  It triggers HermitWand.  It uses the wand.
	A use called hermbarhand is for HermitBarehands.  It triggers HermitSword.  It uses the sword.
	
	HermitRush is a page.
	"You tackle the Mad Hermit to the ground, and the rocks stop tumbling from
	above.  'CANS BLANGERS AND CORKAMEL!' he curses, writhing beneath you. 
	Suddenly, you feel yourself rising into the air.  The Mad Hermit is transforming
	beneath you, expanding several times his normal size, into the form of a
	monstrous, nightmare horse.  He towers larger than Placebo Castle, and still he
	grows, cackling madly and galloping around the room." 
	A choice called hermrusha is for HermitRush.  "Hang on for dear life".  It triggers HermitHorseride.
	A choice called hermrushb is for HermitRush.  "Bail out".  It triggers HermitHorsejump.
	A use called hermrushc is for HermitRush.  It triggers HermitHorseSword.  It uses the sword.
	A use called hermrushd is for HermitRush.  It triggers HermitHorseWand.  It uses the wand.
	
	HermitHorsejump is a page.
	"You roll over the side of the horse's back and fall safely to the floor. 
	You're trampled unsafely into the floor exactly two seconds later.  The horse
	takes seventy three victory laps around the room, smearing you into a sick red
	stain on the floor every time he trots across you.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	DragonFight is a page.
	"You land a crushing blow on the dragon's nose.  He counters by eating you in
	a single bite.  You strangle his stomach.  He counters by thoroughly digesting
	you, bones and all.  You give him a crippling attack of constipation.  VICTORY.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitHorseride is a page.
	"You cling to the horse's back as tightly as you can, a decision that you
	regret when it spontaneously bursts into flame five seconds later.  You burn to
	a cinder as the horse starts quacking like a duck.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitHorseSword is a page.
	"Sword in hand, you start to climb the horse's neck, which has grown as tall
	as a hill.  As you try to go for a lethal blow at the base of the skull, the
	horse suddenly flips his head back and shakes you loose.  As you tumble through
	space, you can see the horse below you.  He's staring straight back up at you as
	you seem to be heading straight for him. 
	    
	His mouth opens wide, and you head right for it. 
	    
	GULP.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitTackle is a page.
	"When the Mad Hermit sees you approach, he ducks his head down and charges
	full force into your gut.  He packs a surprising punch for such a wirey old man.
	 'WHO WANTS SOME CAKE!!!' As you double over and fall to the ground, he starts
	stomping repeatedly on your skull until it splits open.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	HermitPeeled is a page.
	"Suddenly, the electricity crawls up the Mad Hermit's arm.  He screams and
	drops it to the ground.  Now's your chance!"
	A choice called hermpa is for HermitPeeled.  "Grab the Mad Hermit's magic staff".  It triggers HermitZap.
	A choice called hermpb is for HermitPeeled.  "Tackle the Mad Hermit".  It triggers HermitTackle.
	A use called hermpc is for HermitPeeled.  It triggers HermitKill.  It uses the sword.
	A use called hermpd is for HermitPeeled.  It triggers HermitWand.  It uses the wand.
	
	HermitJello is a page.
	"You wave the wand at the ground, hoping beyond hope that something good will
	come of it.  And as you reach the floor, you find that it's turned into
	lime-flavored gelatine.  You bounce harmlessly on the surface until you come to
	a complete stop.          
	             
	When you look up, you see that you're laying at the Mad Hermit's feet.  He
	raises his staff high above his head.  'I'M GOING TO PEEL YOU!!!'  he declares. 
	'I'M GOING TO PEEL YOU!!!'  Electricity begins to crackle up and down the length
	of his staff."
	A choice called hermjella is for HermitJello.  "Wait to be peeled".  It triggers HermitPeeled.
	A choice called hermjellb is for HermitJello.  "Tackle him".  It triggers HermitZap.
	A use called hermjellc is for HermitJello.  It triggers HermitZap.  It uses the sword.
	A use called hermjelld is for HermitJello.  It triggers HermitWand.  It uses the wand.
	
	HermitHorseWand is a page.
	"You wave your magic wand at the horse's head.  He screams in shock, and you
	get a sinking feeling as he starts to return to normal size.  Suddenly he trips,
	and you both go tumbling.   
	      
	As you rise to your feet again, you see the Mad Hermit, back in his natural
	form, holding his staff above his head.  'NO MORE WAITING FOR MARY!!!' he
	declares.  'THIS TIME IT'S AUGUST!!!'  Electricity begins to crackle up and down
	the length of his staff."
	A choice called hermhorwaa is for HermitHorseWand.  "Wait for Mary".  It triggers HermitPeeled.
	A choice called hermhorwab is for HermitHorseWand.  "Attack him".  It triggers HermitZap.
	A use called hermhorwac is for HermitHorseWand.  It triggers HermitZap.  It uses the sword.
	A use called hermhorwad is for HermitHorseWand.  It triggers HermitWand.  It uses the wand.
	
	EndingHero is a page.
	"Yes, clearly you were cut out for this sort of thing.  A life of righteous
	adventuring!  Vanquishing evil, rescuing damsels, all that good stuff!  Before
	the Mad Hermit's body even cools, you've already decided that you're going to
	seek someone else who needs killing.  With a sword at your side and an
	adventuring license, you set out into the world. 
	    
	YOU WILL RETURN IN PLACEBO II -- THE MAD HERMIT'S REVENGE!
	
	*** YOU ARE WIN ***".
	It is followed by The Last Page.
	
	EndingEvil is a page.
	"You take up the Mad Hermit's staff as your own, feeling the power flow
	through you.  Yes, clearly this was your destiny -- to rule the land of Placebo
	with an iron fist. 
	    
	You amass an army of hideous green humanoids and wage a war that leads to the
	fall of humanity, enslaving the world and twisting it into your own monstrous
	image.  But your comeuppance finally arrives when, one day, you die of old age,
	which just goes to show that all evildoers get it in the end.
	
	*** YOU ARE DIED ***".
	It is followed by The Last Page.
	
	EndingHome is a page.
	"Yes, the evil wizard's reign of terror is over.  It's been an exciting
	afternoon, but now it's time to return to your cozy little home and see if
	there's anything interesting on television tonight.  Or whatever it is you do in
	the evenings, it was never exactly clear what time period this game took place
	in.
	
	*** YOU ARE WIN ***".
	It is followed by The Last Page.
	
	AmusingPage is a page.
	"It's been at least ten years since I first drew out the map for what would
	turn out to be Placebo, my very first adventure game.  I wrote the first version
	on a TI-82 graphics calculator when I should have been paying attention to my
	high school classes.  The text was terse, and the interface was simple, but I
	was damned proud of it.  I had managed to put a text adventure on a system that
	didn't even allow for string variables. 
	    
	I've reworked and expanded the game for Jon Ingold's Adventure Book as an
	exercise with the system, and it's been a delightful experience.  It is, in many
	ways, much more satisfying than working with a full-blown programming language,
	or even with a game-specific language such as Inform.  My only regret is that
	this project barely scratches the surface of what's possible with the system --
	Kingdom Without End is a tough act to follow."
	It is followed by Amusing2.
	
	Amusing2 is a page.
	"There's only so much that you can keep hidden in a game where most of your
	choices are explicitly listed for you.  However, there are a couple optional
	amusements you may have missed.  Did you try attacking the dragon and using the
	magic wand?  Did you try offering a sack of gold or a lesser magic to the
	bartender in exchange for his information?  Did you know there are three basic
	decision branches (which converge toward the end) that let you beat the Mad
	Hermit?  
	     
	I hope the game gave you a giggle.  Now choose your ending."  
	It is followed by EndingChoices.