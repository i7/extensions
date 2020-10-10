Version 2/110202 of Rewrite the Command Line (for Glulx only) by Ron Newcomb begins here.

"Allows us to erase then rewrite the commands our player types in."

A Glulx command line echo mode is a kind of value. The Glulx command line echo modes are echoed by the story, echoed by the library, and always echoed per the interpreter.

To decide which Glulx command line echo mode is the command line echo mode: (- echo_mode -).
To change the/-- command line echo mode to (tr - a Glulx command line echo mode): (- set_line_echo({tr}); -).

Include (- Global echo_mode = (+ echoed by the library +); -) after "Definitions.i6t".
Include (-
[ set_line_echo val;
	if (~~(glk($0004, 17, 0)))  {     ! gestalt(gestalt_LineInputEcho)
		echo_mode = (+ always echoed per the interpreter +); 
		return;            ! interpreter needs Glk version 0.7.1 or later
	}
	if (val == (+ always echoed per the interpreter +)) 
		val = (+ echoed by the library +);
	echo_mode = val;
	glk($0150, gg_mainwin, echo_mode - 1); ! glk_set_echo_line_event
];-).

First when play begins (this is the initialize command line echo mode rule): change the command line echo mode to echoed by the story.

To say input type:  (- glk_set_style(style_Input); -).

To decide if input type differs from roman type: (- (glk_style_distinguish(gg_mainwin, style_Normal, style_Input)) -).

Rewrite the Command Line ends here.

---- DOCUMENTATION ----

This extension erases the command the player typed in so the author may rewrite it. For example, if the player entered X MARKS we can rewrite the command as DECIPHER HIEROGLYPHS, or rewrite ASK GATSBY ABOUT DAISY as "So you know my cousin?".  We need only a say statement, probably in the After Reading a Command rules.  For example, this puts quote marks around the command, as if the player's character were speaking.

	*: After reading a command, say "[input type]'[the player's command],' you ask. [roman type]".

The "[input type]" phrase is a style command like that of bold and italic.  It will match whatever style the interpreter uses for the player's typing, so what we say will match what the player expects.  This also means that its exact appearance will vary depending upon the interpreter used and upon the player's preference settings.

	*: When play begins, say "> [input type]START GAME[roman type]"

The extension can be turned on and off.  We check to see whether it's on with this.

	*: if the command line echo mode is echoed by the story...

If the interpreter the player uses does not support this feature, it will instead be set to "always echoed per the interpreter". We might check this at startup. 

	*: When play begins, if the command line echo mode is always echoed per the interpreter, say "(Your interpreter does not support some features this game uses.)"

We can turn the extension off with the following phrase.

	*: change the command line echo mode to echoed by the library.

And then, back on again.  
	
	*: change the command line echo mode to echoed by the story.
	
The line break from the player pressing the enter key is part of the command, so we occasionally need manage line break issues.  We can use this for various effects, such as using "[run paragraph on]" to incorporate the player's typing into a larger paragraph, or "[line break]" so parser errors are not similarly incorporated.

	*: Before printing a parser error when the command line echo mode is echoed by the story, say line break.

We can ask if the way the interpreter renders "[input type]" is different than normal.  Since we'll be rewriting the player's command presumably to improve the flow of prose, it may become extra difficult for the player to determine where to begin reading again after pressing the ENTER key.  This is especially true if we change the command prompt so it, too, blends into the prose.  If the styling of the input text is the same as the output's styling, we might wish to make them different for that reason.  Although not all interpreters report this faithfully, most tend to err conservatively, saying the two styles are identical and still need to be differentiated even when they do not.

	*: unless input type differs from roman type, say bold type.
	
Example: * Unabbreviate - Expands four common player abbreviations to full words.
	
	*: "Unabbreviate"
	
	Include Rewrite the Command Line by Ron Newcomb.
	
	There is a room. "Testing commands bypass this feature.  Try L for look, Z for wait, I for inventory, or X for examine."

	After reading a command when the player's command includes "x", replace the matched text with "Examine".
	
	After reading a command when the player's command includes "l", replace the matched text with "Look".
	
	After reading a command when the player's command includes "z", replace the matched text with "Wait".
	
	After reading a command when the player's command includes "i", replace the matched text with "Take inventory".
	
	After reading a command, if the command line echo mode is echoed by the story, say "[input type][the player's command][roman type]".
	
	When play begins, if the command line echo mode is always echoed per the interpreter, say "Your interpreter does not support this feature.  Try the Quixe interpreter from http://eblong.com/zarf/glulx/quixe/ either online, or, downloaded and installed using the following line of code.[paragraph break]Release along with the 'Quixe' interpreter."
	
	Before printing a parser error when the command line echo mode is echoed by the story, say line break.
