Version 2/140430 of Vorple (for Z-Machine only) by Juhana Leinonen begins here.

"Core functionality of Vorple, including JavaScript evaluation, HTML elements and turn type marking."

Use authorial modesty.

Chapter 1 - JavaScript evaluation

Section 1 - Eval stream (I6)

Include (-

! eval() stream
! Currently only for Z-Machine
! by Dannii

Array streambuf buffer 200;

Constant HDR_SPECREVISION  $32;

[ Gestalt zid gid arg val;
	! Check a gestalt value
	#Ifdef TARGET_ZCODE;
		@"EXT:30S" zid arg -> val;
	#Ifnot; ! TARGET_GLULX
		@gestalt gid arg val;
	#Endif; ! TARGET_
	
	return val;
];

[ Vp_IsZ12 val ;
	#Ifdef TARGET_ZCODE;
		! Check we're in a 1.2 version interpreter
		val = HDR_SPECREVISION-->0;
		if (val < $0102) rfalse;
	#Endif; ! TARGET_ZCODE
	rtrue;
];

[ Vp_IsJS val ;
	! Checking for eval() stream support
	if ( Vp_IsZ12() == false || Gestalt($30, 0, 0) == 0 ) rfalse;
	rtrue;
];

Global Vp_vorpleSupported; 

-) after "Definitions.i6t".

To open JavaScript channel: (- @output_stream 5 streambuf; -).
To close JavaScript channel: (- @output_stream( -5 ); -).

To open HTML tag (name - text) called (classes - text):
	execute JavaScript command "vorple.parser.openTag('[name]','[classes]')".
	
To open HTML tag (name - text):
	open HTML tag name called "".
	
To close HTML tag:
	execute JavaScript command "vorple.parser.closeTag()".
	
To execute JavaScript code/command (JavaScript code - text):
	if Vorple is supported:
		open JavaScript channel;
		say JavaScript code;
		close JavaScript channel.
		
To queue JavaScript code/command (javascript code - text):
	if Vorple is supported:
		execute JavaScript command "vorple.parser.queueExpression(function(){[javascript code]})".


Section 2 - Vorple support detection

To set Vorple support status:
	(- Vp_vorpleSupported = ( Vp_IsJs() ); -);

First startup rule (this is the set a flag for whether Vorple is supported rule):
	[first tell the story file that we're Vorple-capable...]
	set Vorple support status;
	[...then tell the same to the interpreter.]
	execute JavaScript command "vorple.parser.setVorpleStory()".

To decide whether Vorple/JavaScript is supported/available: 
	(- (Vp_vorpleSupported) -).

To decide whether Vorple/JavaScript is not supported/available:
	if Vorple is supported, decide no;
	decide yes.

To decide whether Vorple/JavaScript is unsupported/unavailable:
	decide on whether or not Vorple is not supported.


Chapter 2 - Placing elements and displaying content

To place a/an/-- (element - text) element called (classes - text) reading (content - text):
	open HTML tag element called classes;
	say content;
	close HTML tag.
		
To place a/an/-- (tag - text) element called (classes - text):
	place tag element called classes reading "".
		
To place a/an/-- (tag - text) element reading (content - text):
	place tag element called "" reading content.
	
To place a/an/-- (tag - text) element:
	place tag element called "" reading "".
	
To place an/-- inline/-- element called (classes - text) reading (content - text):
	place "span" element called classes reading content.
	
To place an/-- inline/-- element called (classes - text):
	place inline element called classes reading "". 

To place an/-- inline/-- element reading (content - text):
	place inline element called "" reading content. 

To place a/-- block level/-- element called (classes - text) reading (content - text):
	place "div" element called classes reading content.
	
To place a/-- block level/-- element called (classes - text):
	place block level element called classes reading "". 

To place a/-- block level/-- element reading (content - text):
	place block level element called "" reading content.


To display (content - text) in all the/-- (classes - text) elements:
	let print-safe content be escaped content using "\n" as line breaks;
	execute JavaScript command "$('.[classes]').text('[print-safe content]')".

To display (content - text) in the/-- element called/-- (classes - text):
	display content in all "[classes]:last" elements.


Chapter 3 - Unique identifiers
	
To decide which text is unique identifier:
	let id be "id";
	repeat with X running from 1 to 3:
		let rnd be a random number from 1000 to 9999;
		now id is "[id][rnd]";
	decide on id.

	
Chapter 4 - Turn types

To mark the/-- current action (type - text):
	execute JavaScript command "vorple.parser.setTurnType('[type]')".

Before printing a parser error (this is the mark parser errors for Vorple rule):
	mark the current action "error";
	make no decision.

Include (-
[ Perform_Undo;
#ifdef PREVENT_UNDO; IMMEDIATELY_UNDO_RM('A'); new_line; return; #endif;
if (turns == 1) { IMMEDIATELY_UNDO_RM('B'); new_line; return; }
if (undo_flag == 0) { IMMEDIATELY_UNDO_RM('C'); new_line; return; }
if (undo_flag == 1) { IMMEDIATELY_UNDO_RM('D'); new_line; return; }
if( Vp_IsJS() ) {
	@output_stream 5 streambuf;
	print "vorple.parser.setTurnType('undo')";
	@output_stream( -5 );
}
if (VM_Undo() == 0) { IMMEDIATELY_UNDO_RM('A'); new_line; }
];
-) instead of "Perform Undo" in "OutOfWorld.i6t".
	
To decide whether the/-- current action is out of world:
	 (- meta -)
	
First specific action-processing rule (this is the mark out of world actions for Vorple rule):
	if current action is out of world:
		mark the current action "meta".


Chapter 5 - Escaping

To decide which text is escaped (string - text):
	decide on escaped string using "" as line breaks.

To decide which text is escaped (string - text) using (lb - text) as line breaks:
	let safe-string be text;
	repeat with X running from 1 to number of characters in string:
		let char be character number X in string;
		if char is "'" or char is "[apostrophe]" or char is "\":
			now safe-string is "[safe-string]\";
		if char is "[line break]":
			now safe-string is "[safe-string][lb]";
		otherwise:
			now safe-string is "[safe-string][char]";
	decide on safe-string.


Chapter 6 - Interpreter communication

Section 1 - Queueing parser commands

To queue a/the/-- parser command (cmd - text), showing the command:
	let hideCommand be "true";
	if showing the command:
		now hideCommand is "false";
	execute JavaScript command "vorple.parser.sendCommand([cmd],{hideCommand:[hideCommand]})".

To queue a/the/-- silent parser command (cmd - text):
	execute JavaScript command "vorple.parser.sendSilentCommand([cmd])".

To queue a/the/-- primary parser command (cmd - text), showing the command:
	let hideCommand be "true";
	if showing the command:
		now hideCommand is "false";
	execute JavaScript command "vorple.parser.sendPrimaryCommand([cmd],{hideCommand:[hideCommand]})".

To queue a/the/-- silent primary parser command (cmd - text):
	execute JavaScript command "vorple.parser.sendSilentPrimaryCommand([cmd])".


Section 2 - Vorple startup rulebook

[Code for basic mechanism provided by Graham Nelson]

During Vorple startup is a rulebook.

The Vorple startup stage rule is listed before the when play begins stage rule in the startup rulebook.

This is the Vorple startup stage rule:
	if Vorple is supported:
		follow the during Vorple startup rules.

To permit out-of-sequence commands:
	(- EarlyInTurnSequence = true; -).

Vorple pre-story communication finished is a truth state that varies. Vorple pre-story communication finished is false.

Last during Vorple startup (this is the loop pre-start prompt rule):
	permit out-of-sequence commands;
	follow parse command rule;
	follow generate action rule;
	if Vorple pre-story communication finished is false:
		follow the loop pre-start prompt rule.

Starting the story is an action out of world.
Understand "__start_story" as starting the story.

Carry out starting the story (this is the end pre-story communication rule):
	now Vorple pre-story communication finished is true.

This is the undo marking intro as meta rule:
	mark the current action "normal".

The undo marking intro as meta rule is listed after the when play begins stage rule in the startup rulebook.


Chapter 7 - Element positions

[This value is used by other extensions.]
An element position is a kind of value. Element positions are top left, top center, top right, left top, right top, left center, center left, screen center, right center, center right, left bottom, right bottom, bottom left, bottom center, bottom right, top banner, and bottom banner.


Chapter 8 - Restart fix

[Replaces the restart confirmation prompt with a browser's native prompt]
Carry out restarting the game (this is the Vorple restart prompt rule):
	if Vorple is supported:
		let question be "Are you sure you want to restart?" (A);
		execute JavaScript command "if(confirm('[escaped question]'))window.location.reload();";
	otherwise:
		follow the restart the game rule.

The restart the game rule is not listed in the carry out restarting the game rulebook.

			
Chapter 9 - Credits

First after printing the banner text (this is the display Vorple credits rule):
	if Vorple is supported:
		say "Vorple version " (A);
		place inline element called "vorple-version";
		execute JavaScript command "$('.vorple-version').html(vorple.core.getVersion())";
		say "[paragraph break]" (B).
	
	
Vorple ends here.


---- DOCUMENTATION ----

The Vorple core extension defines some of the basic structure that's needed for Vorple to communicate with the story file.

Authors who are not familiar with JavaScript or who wish to just use the basic Vorple features can read only the first two chapters (Vorple setup and compatibility with offline interpreters). The rest of this documentation handles more advanced usage. For more practical usage of Vorple, see other Vorple extensions that implement features like multimedia support and hyperlinks.


Chapter: Vorple setup

Every Vorple story must include at least one Vorple extension and the custom web interpreter. The Vorple web interpreter template is included with the standard installation of Inform 7.

	*: Include Vorple by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

All standard Vorple extensions already have the "Include Vorple" line, so it's not necessary to add it to the story project if at least one of the other extensions are used.

At the moment Vorple supports Z-machine only.

For more detailed instructions on how to get started, see the documentation at the vorple-if.com web site.


Chapter: Compatibility with offline interpreters

Even though Vorple can accomplish many things that are plain impossible to do with traditional interpreters, it's always a good idea to make the story playable text-only as well if at all possible. There are many players to whom a web interpreter or Vorple's features aren't accessible, and it's the Right Thing To Do to not exclude people if it's possible to include them.

A story file can detect if it's being run on an interpreter that supports Vorple. The same story file can therefore be run on both the Vorple web interpreter and other interpreters that have text-only features and display substitute content if necessary. We can test for Vorple's presence with "if Vorple is supported":

	Instead of going north:
		if Vorple is supported:
			play sound file "marching_band.mp3";
		otherwise:
			say "A marching band crossing the street blocks your way."

(The above example uses the Vorple Multimedia extension.)

The say phrase in the above example is called a "fallback" and it's displayed only in normal non-Vorple interpreters.

All Vorple features do nothing by default if they're not supported by the interpreter, unless otherwise stated in the extension's documentation. If substitute content is not necessary, we don't need to specifically check for Vorple compatibility:

	Instead of going north:
		play sound file "marching_band.mp3".


Chapter: Embedding HTML elements

We can embed simple HTML elements into story text with some helper phrases.

	place an "article" element;
	place a "h1" element called "title";
	place a block level element called "inventory";
	place an inline element called "name";

The previous example generates this markup:

	<article></article>
	<h1 class="title"></h1>
	<div class="inventory"></div>
	<span class="name"></span>
	
The element's name should be one word only and a valid CSS class name. It's safest to only use letters, numbers, underscores and dashes. The name "transient" is special: all elements called "transient" will fade out at the start of the next turn.

Contents can be added on creation:

	place a "h1" element called "title" reading "An exciting story";
	place a "h2" element reading "Story so far:";

...or after the elements have been created:
	
	say "You shall be known as ";
	place an inline element called "name";
	display "Anonymous Adventurer" in the element called "name";
	
This technique can be used to modify the story output later (see example "Scrambled Eggs").

In the above examples the element contents should be plain text only. Trying to add nested tags or text styles will lead to erratic behavior. For longer and more complex contents the tags can be opened and closed manually:

	Report reading the letter:
		open HTML tag "div" called "letter";
		place "h2" element reading "Dear Esther,";
		say "I'm writing to tell you...";
		close HTML tag.


Chapter: Turn types

The Vorple interpreter has multiple ways to display content, based on its type. Parser errors fade out the next turn, out of world actions are shown in a separate notification and so on.

Sometimes we want to change that behavior. The turn type can be overridden manually:

	mark the current turn "normal";
	
The turn types are "normal", "meta" (out of world actions), "error" and "dialog". The "dialog" turn type shows the turn contents in a dialog box with an "ok" button that has to be clicked for the story to resume.


Chapter: Evaluating JavaScript expressions

The story file breaks out of the Z-Machine sandbox by having the web browser evaluate JavaScript expressions. An "execute JavaScript command" phrase is provided to do just this:

	execute JavaScript command "alert('Hello World!')";

At the moment there are no safeguards against invalid or potentially malicious JavaScript. If an illegal JavaScript expression is evaluated, the browser will show an error message in the console and the interpreter will halt.

JavaScript expressions can also be postponed to be evaluated only after the turn has completed and all the text has been displayed to the reader.

	queue JavaScript command "alert('Hello World!')";

The expressions are evaluated in the same order they were added to the queue and the queue is emptied right after evaluation.


Chapter: Escaping strings

When evaluating JavaScript expressions, quotation marks must often be exactly right. Inform formats quotes according to literary standards which doesn't necessarily work together with JavaScript. Consider the following example:

	To greet (name - text):
		execute JavaScript command "alert( 'Hello [name]!' )".

	When play begins:
		greet "William 'Bill' O'Malley".

This leads to a JavaScript error because all single quotes (except the one in "O'Malley") are converted to double quotes, which in turn leads to a JavaScript syntax error. Changing the string delimiters to single quotes wouldn't help because there's an unescaped single quote as well inside the string.

To escape text we can preface it with "escaped":

	To greet (name - text):
		execute JavaScript command "alert( 'Hello [escaped name]!' )".

Now the string can be safely used in the JavaScript expression.

By default newlines are removed. If we want to preserve them, or turn them into for example HTML line breaks:

	To greet (name - text):
		let safe name be escaped name using "\n" as line breaks;
		execute JavaScript command "alert( 'Hello [safe name]!' )".


Chapter: Hidden parser commands

Instructing the interpreter from the story file is easy with "execute JavaScript command" phrases, but passing information to the other direction (from interpreter to story file) is not as simple. The interpreter/story file model wasn't designed for it and the only tool we have in our use is to have the interpreter 'type' commands to the prompt hidden from the user.

There are some limitations to this method. The most important one is that you have to wait for the prompt to become available (a turn to end) to be able to pass these hidden commands. Therefore you need to plan for the communication to happen in between turns. This is why the phrase is called "queue parser command", which is what it does: all command instructions are placed in the queue which is resolved at the end of a turn.

	queue parser command "'__set_name '+username";

(The above example assumes there's a global JavaScript variable "username" set at some point.)

Notice that the parameter is a JavaScript expression, so plain commands must be enclosed in quotes.

On Inform's side the counterpart is an action that handles the sent information.

	Setting the username is an action out of world applying to one topic.
	Understand "__set_name [text]" as setting the username.

	Carry out setting the username:
		...

By convention hidden commands are prefixed with two underscores. The interpreter strips the underscores if the reader uses them in their commands so they can't trigger hidden commands deliberately or accidentally.

The response is displayed as it would if the player gave the command normally, except that the command itself is not shown in the transcript. That can be changed with the "showing the command" modifier:

	queue parser command "'x me'", showing the command;

To suppress the response as well, use "queue silent parser command".

	queue silent parser command "'__do_whatever'";

There's also a "primary" queue that is handled before the "normal" queue. In other regards it acts exactly like described above.

	queue primary parser command "'x me'";
	queue silent primary parser command "'__do_whatever'";

The purpose of the primary queue is to make sure commands that are related to the current action are handled immediately after this turn. If they're put into the normal queue there's no guarantee how many other commands there might already be in the queue.

Sometimes we need to communicate with the interpreter before the story has properly started. Using the "when play begins" rulebook is too late -- the command would be executed only after the rulebook has run and printed the intro, the banner, and the starting room description. For this purpose we can use the "Vorple startup" rulebook:

	Vorple startup:
		queue silent parser command "'__local_time '+(new Date()).toString()".

The Vorple startup rulebook is run only in the Vorple interpreter. Only Vorple-specific commands should go there, and only those that can't be placed in the When play begins rulebook.

Passing commands to the story file can be a powerful tool, but it should be used only when absolutely necessary. One reason is performance: the story file has to process the command as a separate turn, even when it isn't displayed to the user. It's much faster to use for example I7's 'try' phrases to initiate actions. The other reason is that the method won't work in offline interpreters.

Another drawback of this method is that the length of the command is limited. Any command that has more than 119 characters will be silently truncated.

A more practical way of communication between the story file and the interpreter will be introduced in later versions of Vorple.

		
Example: ** Convenience Store - Displaying the inventory styled as a HTML list.

We'll display the inventory listing using HTML unordered lists ("ul"). It might not be immediately obvious why one would want to do this, but if the items are displayed in a proper HTML structure it's possible to use CSS to style them further.
		
	*: "Convenience Store"
	
	Include Vorple by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

	Carry out taking inventory (this is the print inventory using HTML lists rule):
		if Vorple is supported:
			say "[We] [are] carrying:[line break]" (A);
			open HTML tag "ul";
			repeat with item running through things carried by the player:
				place "li" element reading "[item]";
				if the item contains something:
					open HTML tag "ul";
					repeat with content running through things contained by the item:
						place "li" element reading "[content]";
					close HTML tag;
			close HTML tag;
		otherwise:
			follow the print standard inventory rule.
				
	The print inventory using HTML lists rule is listed instead of the print standard inventory rule in the carry out taking inventory rules.  

	The Convenience store is a room. The eggs, the milk, the jar of pickles, the magazine, and the can opener are in the Convenience store. The paper bag is an open container in the Convenience store.
	
	Test me with "take all / i / put all in paper bag / i".


Example: ** Scrambled Eggs - Hints that are initially shown obscured and revealed on request.

The hint system works by wrapping scrambled hints in named elements. Their contents can then be later replaced with unscrambled text.

	
	*: "Scrambled Eggs"
	
	Include Vorple by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	
	Chapter 1 - World
	
	Kitchen is a room. "Your task is to find a frying pan!"
	The table is a fixed in place supporter in the kitchen.
	The frying pan is on the table. 
	
	After taking the frying pan:
		end the story finally saying "You found the pan!"
	
	After looking for the first time:
		say "(Type HINTS to get help.)".
	
	
	Chapter 2 - Hints
	
	Table of Hints
	hint	revealed (truth state)
	"The table is relevant."	false
	"Have you looked on the table?"	false 
	"The pan is on the table."	false
	
	Requesting hints is an action out of world.
	Understand "hint" and "hints" as requesting hints.
	 
	Carry out requesting hints (this is the un-meta hint requesting rule):
		mark the current action "normal".
		
	Carry out requesting hints (this is the scramble hints rule):
		let the alphabet be { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" };
		let row number be 1;
		repeat through table of hints:
			let scrambled hint be "";
			say "[row number]) ";
			if revealed entry is true:
				now scrambled hint is hint entry;
			otherwise:
				repeat with index running from 1 to the number of characters in hint entry:
					if character number index in hint entry is " ":
						now scrambled hint is "[scrambled hint] ";
					otherwise:
						let rnd be a random number between 1 and the number of entries in the alphabet;
						now scrambled hint is "[scrambled hint][entry rnd in the alphabet]";
			place an element called "hint-[row number]" reading "[scrambled hint]";
			say line break;
			increment row number;
		say "[line break](Type REVEAL # where # is the number of the hint you want to unscramble.)".
		
	Revealing hint is an action out of world applying to one number.
	Understand "reveal [number]" as revealing hint.
	
	Check revealing hint (this is the check boundaries rule):
		if the number understood is less than 1 or the number understood is greater than the number of rows in the table of hints:
			say "Please choose a number between 1 and [number of rows in table of hints]." instead.
	
	Carry out revealing hint when Vorple is not supported (this is the unscrambling fallback rule):
		choose row number understood in the table of hints;
		say "[hint entry][line break]".
		
	Carry out revealing hint (this is the change past transcript rule):
		choose row number understood in the table of hints;
		display hint entry in the element "hint-[number understood]".
		
	Test me with "hints / reveal 1 / reveal 2 / reveal 3".


Example: *** Spy Games - Setting the story time to match the real-world time.

The story file doesn't have access to the system time, but we can use Vorple to send the time from the web browser to the story file.

The (new Date).getHours() and (new Date).getMinutes() methods we use to pull the real-world time are not Vorple-specific, but built-in to browsers as part of the standard JavaScript implementation.

Once set, the story time will soon drop out of sync and will advance one minute per turn by default. Maintaining the synchronization would mean sending the current time every turn to the story file.

	*: "Spy Games"

	Include Vorple by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

	Secret base is a room.
	
	During Vorple startup (this is the synchronize watches rule):
		queue silent parser command "'__set_time '+(new Date).getHours()+':'+(new Date).getMinutes()".

	Setting the time to is an action out of world applying to time.
	Understand "__set_time [time]" as setting the time.
	
	Carry out setting the time to:
		now the time of day is the time understood.
	
	When play begins:
		say "It is [time of day] and you're about to infiltrate the villain's lair."


Example: **** The Sum of Human Knowledge - Retrieving and displaying data from a third party service.

Here we set up an encyclopedia that can be used to query articles from Wikipedia. The actual querying code is a bit longer so it's placed in an external encyclopedia.js file, which can be downloaded from http://vorple-if.com/vorple/doc/inform7/examples/resources/javascript/encyclopedia.js .

	*: "The Sum of Human Knowledge"
	
	Include Vorple by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	Release along with JavaScript "encyclopedia.js".
	
	Library is a room. "The shelves are filled with volumes of an encyclopedia. You can look up any topic you want."
	
	Looking up is an action applying to one topic.
	Understand "look up [text]" as looking up.
	
	Carry out looking up when Vorple is supported:
		place a block level element called "dictionary-entry";
		execute JavaScript command "wikipedia_query('[escaped topic understood]')".
		
	Report looking up when Vorple is not supported:
		say "You find the correct volume and learn about [topic understood].".
	 	
	Test me with "look up ducks / look up mars / look up interactive fiction".
	
	