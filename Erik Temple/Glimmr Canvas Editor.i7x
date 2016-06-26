Version 2/110103 of Glimmr Canvas Editor (for Glulx only) by Erik Temple begins here.

"A GUI editor that allows you to visually generate compositions for use with projects based on Glimmr Canvas-Based Drawing. Outputs valid Glimmr/I7 source code."


Part - Extensions

Include version 9 of Flexible Windows by Jon Ingold.
Include Glimmr Canvas-Based Drawing by Erik Temple.
Include Glimmr Graphic Hyperlinks by Erik Temple.
Include version 6 of Dynamic Objects by Jesse McGrew.
Include Basic Screen Effects by Emily Short.
Include Undo Output Control by Erik Temple.
Include Glulx Status Window Control by Erik Temple.
Include version 4 of Questions by Michael Callaghan.


Chapter - Fonts

[Replace this section to use alternate fonts. First, include the proper font extensions. Then, provide a decide phrase like that given here so that the source code generator will know what to write. Finally, set the associated font name for the two classes of font to the appropriate value.]

Include Glimmr Bitmap Font by Erik Temple.
Include Glimmr Image Font by Erik Temple.

To decide what text is the extension-name of (typeface - a font):
	if the typeface is Glimmr Lucidex:
		decide on "Glimmr Image Font by Erik Temple";
	if the typeface is Glimmr C&C:
		decide on "Glimmr Bitmap Font by Erik Temple";
	decide on "".
	
The associated font of a bitmap-rendered string is usually Glimmr C&C.
The associated font of an image-rendered string is usually Glimmr Lucidex.


Part - Initializations

Use asymmetrical scaling.
Use MAX_ACTIONS of 210.
Use MAX_STATIC_DATA of 1500000.
[Use MAX_PROP_TABLE_SIZE of 50000.]

Use logged sprite creation translates as (- Constant LOGGED_SPRITES; -).

The story genre is "Utility". The release number is 1. The story headline is "A tool for creating Glimmr canvas-based compositions".

Table of Common Color Values (continued)
glulx color value	assigned number
g-mylightgray	15132390
g-pear	14609052
g-lightpear	15791827
g-midlightgray	10921638
g-librarygray	12566463

[A glulx arranging rule:
	say "Window width: [width of main-window].";
	say "Window height: [height of main-window].";]


Part - "Scenario"

Fake-room_x is a room.


Part - Undo Control

Report undoing an action:
	say "[bracket]Previous action undone.[close bracket][line break]";
	rule succeeds;
	
Report undoing an action when we are asking a question:
	say "[bracket]Undone.[close bracket][paragraph break]";
	say "[current question][paragraph break]";
	rule succeeds;
	
Before undoing an action when the turn count is the first editor turn:
	say "[bracket]Undo disallowed.[close bracket][line break][introductory commands]";
	rule fails.

To decide which value is undo word #3:
   (- 'z//' -)


Part - Hacking game restore so that we can offer our own customized restore message

The output from restoring rules are a rulebook.

The last output from restoring rule (this is the default restoring the game rule):
	rule fails.
	
Output from restoring:
	say "[bracket]Saved file successfully restored.[close bracket][paragraph break]";
	print the editor startup text;
	rule succeeds.

[GL__M(##Restore, 1) = "Restore failed"]
[ GL__M(##Restore, 2) = "Ok."]

Include (-

[ RESTORE_THE_GAME_R res fref;
	if (actor ~= player) rfalse;
	fref = glk_fileref_create_by_prompt($01, $02, 0);
	if (fref == 0) jump RFailed;
	gg_savestr = glk_stream_open_file(fref, $02, GG_SAVESTR_ROCK);
	glk_fileref_destroy(fref);
	if (gg_savestr == 0) jump RFailed;
	@restore gg_savestr res;
	glk_stream_close(gg_savestr, 0);
	gg_savestr = 0;
	.RFailed;
	GL__M(##Restore, 1);
];

-) instead of "Restore The Game Rule" in "Glulx.i6t".

Include (-
[ SAVE_THE_GAME_R res fref;
	if (actor ~= player) rfalse;
	fref = glk_fileref_create_by_prompt($01, $01, 0);
	if (fref == 0) jump SFailed;
	gg_savestr = glk_stream_open_file(fref, $01, GG_SAVESTR_ROCK);
	glk_fileref_destroy(fref);
	if (gg_savestr == 0) jump SFailed;
	@save gg_savestr res;
	if (res == -1) {
		! The player actually just typed "restore". We're going to print
		!  a successful restore message; the Z-Code Inform library does this correctly
		! now. But first, we have to recover all the Glk objects; the values
		! in our global variables are all wrong.
		GGRecoverObjects();
		glk_stream_close(gg_savestr, 0); ! stream_close
		gg_savestr = 0;
		if ( FollowRulebook( (+ output from restoring rules +) ) && RulebookFailed())
		{
			return GL__M(##Restore, 2);
		}
		return;
	}
	glk_stream_close(gg_savestr, 0); ! stream_close
	gg_savestr = 0;
	if (res == 0) return GL__M(##Save, 2);
	.SFailed;
	GL__M(##Save, 1);
];

-) instead of "Save The Game Rule" in "Glulx.i6t".


Part - Extended functionality for the Questions extension

A real number question rule (this is the hack real number question parsing rule):
	now the real number understood is the current number;

The hack real number question parsing rule is listed first in the real number question rules. The invalid real number reply rule is listed first in the real number question rules.

The current cancelation message is text that varies. The current cancelation message is usually "[bracket]Operation canceled.[close bracket]".


Section - Looking back to the previous turn's input

[Most of the questions asked in GCE are generated by a command. It's convenient to be able to look back at the generating command, so we store the action as the "impelling action"]

The impelling action is a stored action variable.

Before doing something:
	now the impelling action is the current action;
	continue the action.


Section - Cancelling open questions with return

Rule for printing a parser error when the command parser error is the I beg your pardon error:
	if number question mode is true and closed question mode is false:
		say "[current cancelation message][line break]";
		deactivate number question mode;
		rule succeeds;
	if menu question mode is true and closed question mode is false:
		say "[current cancelation message][line break]";
		deactivate menu question mode;
		rule succeeds;
	[if yes/no question mode is true and closed question mode is false:
		say "[current cancelation message][line break]";
		deactivate yes/no question mode;
		rule succeeds;]
	if gender question mode is true and closed question mode is false:
		say "[current cancelation message][line break]";
		deactivate gender question mode;
		rule succeeds;
	if text question mode is true and closed question mode is false:
		say "[current cancelation message][line break]";
		deactivate text question mode;
		rule succeeds;
	if real number question mode is true and closed question mode is false:
		say "[current cancelation message][line break]";
		deactivate real number question mode;
		rule succeeds;
	continue the action.


Section - New real number question routine (in place of Section 7 - Processing real number questions in Questions by Michael Callaghan)

After reading a command when real number question mode is true:
	follow the real number question rules;
	if the outcome of the rulebook is the exit outcome:
		deactivate real number question mode;
		follow the every turn rules;
		follow the advance time rule;
		reject the player's command;
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		 if the player entered a number:
			say "Scaling ratios must be written to a precision of [precision in words] digits. For example, 0.[run paragraph on][8 times (10 to the power precision minus 1)] corresponds to 80%.[paragraph break]";
			reject the player's command;
			continue the action;
		say "[current cancelation message][line break]";
		deactivate real number question mode;
		if the player entered a number:
			follow the every turn rules;
			follow the advance time rule;
			reject the player's command;


Part - IGNORE command

Ignoring is an action applying to nothing. Understand "ignore" as ignoring.

Carry out ignoring:
	rule succeeds;
	

Part - Settings and Preferences

Punctuation removal is false. [A setting provided by the Questions extension.]

The lower scaling-limit is a real number that varies. The lower scaling-limit is usually 0.1000.
The upper scaling-limit is a real number that varies. The upper scaling-limit is usually 5.0000.

Image highlighting is a truth state that varies. Image highlighting is usually true.
Canvas-outlining is a truth state that varies. Canvas-outlining is usually true.

Highlight-color is a glulx color value that varies. Highlight-color is usually g-CornflowerBlue.
Canvas outline-color is a glulx color value that varies. Canvas outline-color is usually g-White.

The table-option is a truth state that varies. The table-option is usually true.
The targeted canvas is indexed text that varies. The targeted canvas is usually "graphics-canvas".
		

Chapter - Changing colors

A parsing-object is a kind of thing. A parsing-object can be wide-open or secreted. A parsing-object is usually wide-open.

A parsing-object has a text called the command example.

The stroke highlight color is a parsing-object in Fake-room_x. It is secreted. The command example is "CHANGE STROKE HIGHLIGHT COLOR TO <color name>".
The canvas background color is a parsing-object in Fake-room_x. It is secreted. The command example is "CHANGE CANVAS BACKGROUND COLOR TO <color name>". Understand "canvas color" as the canvas background color.
The outline color is a parsing-object in Fake-room_x. It is secreted. The command example is "CHANGE CANVAS OUTLINE COLOR TO <color name>". Understand "canvas outline color" as the outline color.
The element foreground color is a parsing-object in Fake-room_x. It is secreted. The command example is "CHANGE ELEMENT FOREGROUND COLOR TO <color name>".
The element background color is a parsing-object in Fake-room_x. It is secreted. The command example is "CHANGE ELEMENT BACKGROUND COLOR TO <color name>".

Changing the color of is an action applying to one thing and one value. Understand "change [any secreted thing] to [a glulx color value]" or "[any secreted thing] [a glulx color value]" as changing the color of.

Understand "change [any secreted thing]" as a mistake ("Please provide a color name as well, e.g. CHANGE STROKE HIGHLIGHT COLOR TO G-WHITE.").

Carry out changing the color of:
	if the noun is:
		-- stroke highlight color: change the highlight-color to the glulx color value understood;
		-- outline color: change the Canvas outline-color to the glulx color value understood;
		-- canvas background color: change the back-colour of the working window to the glulx color value understood;
		-- element foreground color: now the current element color is the glulx color value understood;
		-- element background color: now the current element background color is the glulx color value understood; 
	say "The [noun] was changed to [the glulx color value understood].";
	refresh windows.

Listing available colors is an action applying to nothing. Understand "list colors" or "colors" as listing available colors.

Carry out listing available colors:
	say "The colors of some elements of the interface can be changed. These include [the list of secreted parsing-objects]. The canvas background color will appear in the source code output; all of the others are purely UI elements. See below for color command syntax. The available colors are:[paragraph break]";
	repeat through the Table of Common Color Values:
		say "[glulx color value entry][line break]";
	say "[line break]Available color-changing commands:[paragraph break]";
	repeat with item running through secreted parsing-objects:
		say "   [command example of item][line break]"
	

Chapter - Change highlighting

Selecting highlight type is an action applying to nothing. Understand "highlight" or "select highlight" or "change highlight type" or "highlight type" or "change highlight" as selecting highlight type.

Carry out selecting highlight type:
	say "Two types of highlighting can be used to identify selected elements within the editor:[paragraph break][bracket]1[close bracket][italic type] Image highlighting:[roman type] a semitransparent overlay colors the element[line break][bracket]2[close bracket] [italic type]Stroke highlighting:[roman type] a rectangle of a given color outlines the element[paragraph break]";
	now the current question is "Please select a highlighting type.";
	now the current prompt is "Type a number: >";
	now the current cancelation message is "[bracket]Highlight change canceled.[close bracket]";
	ask an open question, in number mode.
	
A number question rule when the impelling action is selecting highlight type (this is the highlight selection rule):
	if the number understood is:
		-- 1: now image highlighting is true;
		-- 2: now image highlighting is false;
		-- otherwise:
			say "[bracket]Canceled.[close bracket][paragraph break]";
			exit;
	say "Highlighting is now by [if the number understood is 1]image[otherwise]stroke[end if].";
	update Highlight_radio using image highlighting;
	[follow the window-drawing rules for the control-window;]
	follow the window-drawing rules for the working window;
	exit;
	
Interactively selecting highlight type is an action applying to nothing. Understand "toggle highlight" as interactively selecting highlight type.

Carry out interactively selecting highlight type:
	if image highlighting is:
		-- true: now image highlighting is false;
		-- false: now image highlighting is true;
	say "Highlighting is now by [if image highlighting is true]image[otherwise]stroke[end if].";
	update Highlight_radio using image highlighting;
	[follow the window-drawing rules for the control-window;]
	follow the window-drawing rules for the working window.
		

Section - Change Highlight Image

[Changing the image highlights is a bit fussy. There are two steps:

1) Change the image files Highlight.png and Highlight_alternate.png as desired.
2) Change the standard highlight color and alternate highlight color text variables here to reflect the highlights used.]

Standard highlight color is text that varies. Standard highlight color is usually "blue".
Alternate highlight color is text that varies. Alternate highlight color is usually "red".

Toggling image highlight color is an action applying to nothing. Understand "toggle image highlight color" as toggling image highlight color.

Carry out toggling image highlight color:
	if the current highlight image is Figure of Highlight:
		change the current highlight image to Figure of Alternate Highlight;
	otherwise:
		change the current highlight image to Figure of Highlight;
	say "The image highlight overlay was changed to [if current highlight image is Figure of Highlight][standard highlight color][otherwise][alternate highlight color][end if].";
	[follow the window-drawing rules for the control-window;]
	follow the window-drawing rules for the working window.
	
An element display rule for the hilite_color_radio (this is the update highlight color radio button rule):
	let basic be 25 real times the scaling factor of the control-window real times the x-scaling factor of hilite_color_radio as an integer;
	let border be 4 real times the scaling factor of the control-window real times the x-scaling factor of hilite_color_radio as an integer;
	let x2 be win-x of the hilite_color_radio + basic + (border * 2);
	display the image Figure of Highlight in the control-window at (win-x of the hilite_color_radio) by (win-y of the hilite_color_radio) with dimensions (basic) by (basic);	
	display the image Figure of Alternate Highlight in the control-window at (x2) by (win-y of the hilite_color_radio) with dimensions (basic) by (basic);
	if the current highlight image is Figure of Highlight:
		draw a box (color g-dark-grey) in the control-window from (win-x of the hilite_color_radio) by (win-y) to (win-x + basic) by (win-y + basic) with (border) line-weight;
		draw a box (color g-mylightgray) in the control-window from (x2) by (win-y of the hilite_color_radio) to (x2 + basic) by (win-y + basic) with (border) line-weight;
	otherwise:
		draw a box (color g-mylightgray) in the control-window from (win-x of the hilite_color_radio) by (win-y) to (win-x + basic) by (win-y + basic) with (border) line-weight;
		draw a box (color g-dark-grey) in the control-window from (x2) by (win-y of the hilite_color_radio) to (x2 + basic) by (win-y + basic) with (border) line-weight;
	set a graphlink in the control-window identified as hilite_color_radio from win-x of hilite_color_radio by win-y of hilite_color_radio to (x2 + basic) by (win-y + basic) as the linked replacement-command of hilite_color_radio;
	
	
Chapter - Canvas outline

Toggling the canvas outline is an action applying to nothing. Understand "use canvas outline" or "remove canvas outline" or "outline" or "canvas outline" as toggling the canvas outline.

Carry out toggling the canvas outline:
	if canvas-outlining is false:
		now canvas-outlining is true;
		say "The canvas outline has been turned on. It is only for your reference and will not appear in the source code produced. Change the outline color by typing CHANGE OUTLINE COLOR TO G-BLACK, for example.";
	otherwise:
		now canvas-outlining is false;
		say "The canvas outline has been turned off. Type OUTLINE to turn it back on.";
	update Outline_bkgd_check using canvas-outlining;
	refresh windows.


Chapter - Oversize scaling

Toggling oversize scaling is an action applying to nothing. Understand "toggle oversize scaling" or "toggle oversize" or "oversize scaling" or "oversize" as toggling oversize scaling.

Carry out toggling oversize scaling:
	if the oversize scaling of the working window is true:
		now the oversize scaling of the working window is false;
	otherwise:
		now the oversize scaling of the working window is true;
	refresh windows;
	say "Oversize scaling for the editor window now [if the oversize scaling of the working window is true]on[otherwise]off[end if]."
	

Part - Remove standard commands

Section - Remove all but desired verbs (in place of Section SR4/10 - Grammar in Standard Rules by Graham Nelson) 

Understand "quit" or "q" as quitting the game.
Understand "save" as saving the game.
Understand "restart" as restarting the game.
Understand "restore" as restoring the game.
Understand "verify" as verifying the story file.
Understand "version" as requesting the story file version.
Understand "script" or "script on" or "transcript" or "transcript on" as switching the story
	transcript on.
Understand "script off" or "transcript off" as switching the story transcript off.

Understand the command "x" as something new.


Section - Remove direction commands

The no directions message is text that varies. The no directions message is "There is no need to use compass directions here. To move sprites, use the nudge buttons or type NUDGE <left, right, upward, downward>.".

Understand "n" or "north" as a mistake ("[No directions message]").
Understand "ne" or "northeast" as a mistake ("[No directions message]").
Understand "nw" or "northwest" as a mistake ("[No directions message]").
Understand "south" as a mistake ("[No directions message]").
Understand "se" or "southeast" as a mistake ("[No directions message]").
Understand "sw" or "southwest" as a mistake ("[No directions message]").
Understand "e" or "east" as a mistake ("[No directions message]").
Understand "w" or "west" as a mistake ("[No directions message]").
Understand "u" or "up" as a mistake ("[No directions message]").
Understand "down" as a mistake ("[No directions message]").
Understand "in" or "inside" as a mistake ("[No directions message]").
Understand "out" or "outside" as a mistake ("[No directions message]").


Section - Remove rules that generate standard behavior

First carry out looking rule:
	rule succeeds.

First does the player mean rule:
	rule succeeds.
		

Part - Initial Questionnaire

Interrogation is a kind of value. The interrogations are q-canvas, q-width, q-height, and q-complete.

Quiz-ongoing is a truth state that varies.
Skipped-intro is a truth state that varies. Skipped-intro is false.

Stage is an interrogation that varies.

The startup text is a text variable. Startup text is usually "Welcome to the Glimmr Canvas Editor. This is a utility intended to help you arrange graphical elements into a composition for use with the Glimmr library and the Flexible Windows extension. Once your composition is complete, you may export complete, compilable Inform 7 source code that will replicate your composition.[paragraph break]"

The user-specified startup text is text that varies.

This is the print the editor startup text rule:
	say "[line break][startup text][user-specified startup text][startup instructions text]";
	now quiz-ongoing is true;
	now stage is q-width;
	follow the intro quiz control rule.

The startup instructions text is a text variable. The startup instructions text is usually "To begin, maximize your window to its full size. Then, answer the following questions about the canvas you will be creating. (If you prefer, you can just type SKIP to go straight to the editor; all of these settings can be also be specified directly from the editor.)[paragraph break]".
	
The print the editor startup text rule is listed after the display banner rule in the startup rules.
	
Every turn when quiz-ongoing is true (this is the intro quiz control rule):
	if stage is q-canvas:
		now current question is "[italic type]What is the name of the canvas that you will be editing? (This is used to customize the output source code.)[roman type]";
		now current prompt is "Enter the name of a canvas (e.g., graphics-canvas): >";
		ask a closed question, in text mode;
	if stage is q-width:
		now current question is "[italic type]What is the width of your canvas? If you intend to use one of the images in the editor's library to define your canvas, you may type SKIP to go directly to the editor.[roman type]";
		now current prompt is "Enter a number: >";
		ask a closed question, in number mode;
	if stage is q-height:
		now current question is "[italic type]What is the height of your canvas?[roman type]";
		now current prompt is "Enter a number: >";
		ask a closed question, in number mode;
			
After reading a command when quiz-ongoing is true and the player's command matches "skip" or the player's command matches "no" (this is the skipping intro quiz rule):
	now skipped-intro is true;
	abide by the intro-quiz completion rule;
	rule succeeds;
	
The skipping intro quiz rule is listed first in the after reading a command rules.	
	
A text question rule when the stage is q-canvas (this is the window-prompting rule):
	now targeted canvas is the current answer;
	if targeted canvas is "":
		now the targeted canvas is "graphics-canvas";
	say "Thank you. The canvas will be called the [i]targeted canvas[/i]. The output source code will assign this canvas to a window called the 'graphics-window', but you may easily replace this with a window of your choosing.";
	now stage is q-width;
	exit.
		
A number question rule when the stage is q-width (this is the width-prompting rule):
	if the number understood is less than 1:
		say "Please enter a number greater than 0.[line break]";
		retry;
	say "Thank you. The canvas will be [the number understood] units wide.";
	now the canvas-width of the working canvas is the number understood;
	now stage is q-height;
	exit.
   
A number question rule when the stage is q-height (this is the height-prompting rule):
	if the number understood is less than 1:
		say "Please enter a number greater than 0.[line break]";
		retry;
	say "Thank you. The canvas will be [the number understood] units high.";
	now the canvas-height of the working canvas is the number understood;
	now stage is q-complete;
	abide by the intro-quiz completion rule.
	
This is the intro-quiz completion rule:
	if stage is q-complete:
		say "Thank you. Press any key to go to the editor.";
	otherwise:
		say "[line break][bracket]Input canceled.[close bracket] Press any key to go to the editor.";
	now quiz-ongoing is false;
	now stage is q-complete;
	change the command prompt to the saved prompt;
	change the current prompt to "";
	now number question mode is false;
	now text question mode is false;
	if canvas-height of working canvas > canvas-width of working canvas:
		now portrait orientation is true;
	wait for any key;
	follow the editor startup rule;
	


Part - Window Setup

Portrait orientation is a truth state that varies. Portrait orientation is false.

The back-colour of the main-window is usually g-white.

The editor-canvas is a g-canvas.
Some g-canvases are defined by the Table of Canvases.

Table of Canvases
g-canvas	canvas-width	canvas-height
library-canvas	200	768
control-canvas	572	614
paging-canvas	200	24
layers-canvas	27	461
drawing-canvas	795	24


The editor-window is a graphlink g-window. The position is g-placeabove. The back-colour is usually g-placeNULLcol. The associated canvas is usually the editor-canvas. The measurement is 60. 

Some graphlink g-windows are defined by the Table of Windows.

Table of Windows
g-window	position	measurement	back-colour	associated canvas
library-window	g-placeright	20	g-mylightgray	library-canvas
control-window	g-placeleft	35	g-mylightgray	control-canvas
paging-window	g-placeabove	24	g-librarygray	paging-canvas
layers-window	g-placeleft	3	g-mylightgray	layers-canvas
drawing-window	g-placebelow	24	g-mylightgray	drawing-canvas

The scale method of the paging-window is g-fixed-size.
The scale method of the drawing-window is g-fixed-size.

The arbitrary scaling factor of the drawing-window is 1.0000.

The help-window is a text-buffer g-window. The position is g-placebelow. The measurement is 50. The back-colour is g-pear.

To use small type in subsequently opened windows:
	(- SetSmallType(); -)

Include (-

[ SetSmallType i ;
	 for (i = 0: i < style_NUMSTYLES : i++)
 	 glk_stylehint_set(wintype_TextBuffer, i, stylehint_Size, -1);
];

-)


The main-window spawns the library-window. The library-window spawns the paging-window.
The main-window spawns the editor-window. The editor-window spawns the layers-window.
The editor-window spawns the drawing-window.
The main-window spawns the control-window.
The main-window spawns the help-window.

The working window is a g-window that varies. The working window is usually the editor-window. The working canvas is a g-canvas that varies. The working canvas is usually the editor-canvas. [The working window identifies the window into which new sprite elements created from the library should be copied. Originally, it was planned to allow multiple windows/canvases to be worked on at the same time. However, this was decided to be unnecessary and probably confusing. Should anyone want to modify the extension to allow for this, however, the working window variable has been used where possible t/o the extension, easing the pain of a conversion.]

The canvas-width of the editor-canvas is usually 795.
The canvas-height of the editor-canvas is usually 460.

A window-drawing rule for the library-window (this is the library-window drawing rule):
	if the library-window is g-present:
		[say "Drawing the library window...[line break]";]
		clear the library-window;
		page and scale the library-window sprites;
		draw library instances in the library-window;
		follow the library-paging rules;

A window-drawing rule for the paging-window (this is the paging-window drawing rule):
	if the paging-window is g-present:
		clear the paging-window;
		resize the canvas of the paging-window to the window;
		let margin be the canvas-height of the paging-canvas divided by 4;
		let nav-size be (canvas-height of the paging-canvas minus margin) minus margin;
		change entry 1 of the origin of page-left_button to margin;
		change entry 2 of the origin of page-left_button to margin;
		change entry 2 of the origin of page-right_button to margin;
		change entry 1 of the origin of page-right_button to (canvas-width of paging-canvas minus margin) minus nav-size;
		let the header-coordinates be the center-point of the paging-canvas;
		let temp-coord-x be entry 1 of the header-coordinates minus (image-width of the Figure of Library Header / 2);
		let temp-coord-y be entry 2 of the header-coordinates minus (image-height of the Figure of Library Header / 2);
		display image (Figure of Library Header) in paging-window at (temp-coord-x) by (temp-coord-y);
		prune the link-table of paging-window links;
		repeat with current-element running through display-active paging-buttons:
			let temp-coord-x be entry 1 of the origin of current-element;
			let temp-coord-y be entry 2 of the origin of current-element;
			display image (image-ID of current-element) in paging-window at (temp-coord-x) by (temp-coord-y) with dimensions (nav-size) x (nav-size);
			if current-element is graphlinked:
				set a graphlink in paging-window identified as current-element from (temp-coord-x) by (temp-coord-y) to (temp-coord-x + nav-size) by (temp-coord-y + nav-size) as the linked replacement-command of current-element;

A window-drawing rule for the editor-window (this is the editor-window drawing rule):
	if the editor-window is g-present:
		carry out the scaling activity with the editor-window;
		carry out the offset calculation activity with the editor-window;
		carry out the window-framing adjustment activity with the editor-window;
		clear the editor-window;
		carry out the drawing the canvas background activity with the editor-window;
		if canvas-outlining is true:
			draw a box (color Canvas outline-color) in the editor-window from (x-offset of the editor-window) by (y-offset of the editor-window) to (the x-offset of the editor-window plus the scaled width of the editor-canvas) by (the y-offset of the editor-window plus the scaled height of the editor-canvas) with 1 pixel line-weight, inset;
		carry out the drawing the active elements activity with the editor-window;
		draw element-selection markers;
		if layer-revelation is true:
			append layer numbers;
		if drawing mode is true:
			unless first point is {-999, -999}:
				draw a rectangle (color highlight-color) in (working window) from (current graphlink x - 1) by (current graphlink y - 1) to (current graphlink x + 1) by (current graphlink y + 1);

For window-framing adjustment of the editor-window when we are zoomed in (this is the zoomed window centering rule):[This rule recenters the framing of the editor window when we are zoomed in.]
	if zoom-center is {-1, -1}:
		center the framing of the working window on its canvas;
	otherwise:
		center the framing of the working window on the zoom-center;
	continue the action.

A window-drawing rule for the layers-window (this is the layers-window drawing rule):
	if the layers-window is g-present:
		clear the layers-window;
		unless portrait orientation is true:
			draw a rectangle (color g-librarygray) in the layers-window at (0) by (height of layers-window minus 1) with size (width of layers-window) by (1);
		[prune the link-table of layers-window links;]
		follow the layer indicator construction rules.

A window-drawing rule for the control-window (this is the control-window drawing rule):
	if the control-window is g-present:
		if zoom is available:
			now the display status of the zoom_button is g-active;
		otherwise:
			deactivate zoom_button;
		carry out the scaling activity with the control-window;
		carry out the offset calculation activity with the control-window;
		clear the control-window;
		carry out the drawing the canvas background activity with the control-window;
		carry out the drawing the active elements activity with the control-window;
		if portrait orientation is true:
			draw a rectangle (color g-librarygray) in the control-window at (width of control-window minus 1) by (0) with size (1) by (height of control-window).
			
A window-drawing rule for the drawing-window (this is the drawing-window drawing rule):
	if the drawing-window is g-present:
		now the canvas-width of the drawing-canvas is the width of the drawing-window;
		carry out the scaling activity with the drawing-window;
		carry out the offset calculation activity with the drawing-window;
		clear the drawing-window;
		if canvas-width of the drawing-canvas > 501:
			activate close drawing window button;
			change entry 1 of origin of close drawing window button to canvas-width of drawing-canvas minus 17;
		otherwise:
			deactivate close drawing window button;
		change the tint of the foreground_color_indicator to the current element color;
		change the tint of the background_color_indicator to the current element background color;
		let v-offset be 24 - current line-weight;
		if v-offset < 3, let v-offset be 1;
		let v-offset be v-offset / 2;
		draw a rectangle (color current element color) in drawing-window at (455) by (v-offset) with dimensions (20) by (current line-weight);
		draw a box (color g-librarygray) in drawing-window from 0 by 0 to (width of the drawing-window) by (height of the drawing-window) with 1 pixel line-weight, inset;
		carry out the drawing the active elements activity with the drawing-window.
		
Element display rule for the foreground_color_indicator when the current element color is g-placenullcol:
	let x be entry 1 of origin of foreground_color_indicator;
	let y be entry 2 of origin of foreground_color_indicator;
	display Figure of Null Color-Chip in drawing-window at x by y;
	
Element display rule for the background_color_indicator when the current element background color is g-placenullcol:
	let x be entry 1 of origin of background_color_indicator;
	let y be entry 2 of origin of background_color_indicator;
	display Figure of Null Color-Chip in drawing-window at x by y.


Section - Determining zoomedness of the editor window

To decide whether we are zoomed in:
	if the arbitrary scaling factor of the working window > 0.0000:
		decide yes;
	otherwise:
		decide no.
		
To decide whether we are zoomed out:
	if the arbitrary scaling factor of the working window is 0.0000 and the scaling factor of the working window is greater than 1.0000 or the scaling factor of the working window is less than 1.0000:
		decide yes;
	otherwise:
		decide no.
		
To decide whether zoom is available:
	if the arbitrary scaling factor of the working window is 0.0000 and the scaling factor of the working window is 1.0000:
		decide no;
	otherwise:
		decide yes.
			
			
Part - Editor Startup
			
The first editor turn is a number that varies. [This gives us a flag we can compare to the turn count; we use it to decide whether to allow UNDO. We don't allow undo for the turn immediately after the player has moved from the introductory quiz to the editor.]
			 
This is the editor startup rule:
	clear the main-window;
	repeat with item running through image-based fonts:
		if the number of rows in the font table of item is 1, next;
		increase the built-in resources index by the number of rows in the font table of item;
	initialize dynamic sprites;
	if portrait orientation is true:
		set windows to portrait orientation;
	update binary UI elements;
	open editor windows;
	follow the advance time rule;
	change the first editor turn to the turn count;
	print the editor startup text;
	say line break;
	say introductory commands;
	let current-tab be the current tab;
	if current-tab is:
		-- select_tab: try select-tab clicking;
		-- move_tab: try move-tab clicking;
		-- scale_tab: try scale-tab clicking;
	follow the window-drawing rules for the control-window;
	reject the player's command.

To decide whether we have custom images:
	if the number of dynamic-sprites is greater than 1, decide yes;
	decide no.

To open editor windows:
	if we have custom images:
		open up the library-window;
	otherwise if portrait orientation is false:
		now the measurement of the control-window is 27;
	open up the editor-window;
	open up the layers-window;
	open up the control-window;
	if we have custom images:
		open up the paging-window;
	open up the drawing-window;
	set the background of the status window to colored;
	set the background color of the status window to g-lightpear;
	open the status window.
	
To set windows to portrait orientation:
	now the measurement of the library-window is 18;
	now the measurement of the editor-window is 55;
	now the position of the editor-window is g-placeleft;
	now the position of the control-window is g-placebelow;
	now the measurement of the layers-window is 4;
	now the measurement of the help-window is 15.
	
To print the/-- editor startup text:
	say "Source code will be output targeting the canvas [italic type][targeted canvas][roman type], measuring [canvas-width of the working canvas] by [canvas-height of the working canvas] pixels[if we have custom images and the background image of the working canvas is Figure of Null]. If desired, you may select an image from the image library to serve as the background of the composition; simply select the image in the editor and press the Image Background button in the Settings tab[otherwise]. The image [italic type][background image of the working canvas][roman type] defines the background grid[end if]. To change the background color of the window type CHANGE CANVAS BACKGROUND COLOR TO <glulx color value>.";
		
To say introductory commands:
	say "To make changes to your responses to the introductory settings, you may use the following commands:[paragraph break]RENAME WINDOW <desired name>[line break]RESIZE CANVAS TO <width in pixels> BY <height in pixels>[line break]".
	
Every turn when library-window is g-present:
	follow the window-drawing rules for the library-window;
	
To refresh windows:
	follow the refresh windows rule;
	

Chapter - Updating binary UI elements
	
To update binary UI elements:
	update layer_reveal_modal using layer-revelation;
	update outline_bkgd_check using canvas-outlining;
	update highlight_radio using image highlighting;
	update tabular_source_radio using table-option;
		

Part - The Status Line

Glulx arranging rule:
	update the status line.

Glulx redrawing rule:
	update the status line.

Rule for constructing the status line:
	fill status bar with Table of Status.
	
To decide which text is the selected component:
	if the element-selection set is empty:
		decide on "[roman type][bracket]No element selected[close bracket]"; [the switch to roman type is required by a bug in either Inform or Basic Screen Effects that causes the first element in a table-filled status bar to print in italics]
	if the number of entries of the element-selection set is 1:
		decide on "[element-name of entry 1 of element-selection set]";
	decide on "[roman type][bracket][number of entries of the element-selection set] elements selected[close bracket]";

To decide which indexed text is the coordinates of the selected component:
	if the element-selection set is empty:
		let percentage be indexed text;
		let percentage be "[scaling factor of the working window real times 100]";
		replace the regular expression "0+$" in percentage with "";
		replace the regular expression "\.+$" in percentage with "";
		decide on "Scale: [percentage]%";
	if the number of entries of the element-selection set is 1:
		decide on "[origin of entry 1 of element-selection set in brace notation]";
	otherwise:
		decide on "".	

To decide which text is the g-kind of the selected component:
	if the element-selection set is empty:
		decide on "Canvas: [canvas-width of working canvas] x [canvas-height of working canvas]";
	if the number of entries of the element-selection set is 1:
		if the of-kind of entry 1 of the element-selection set is "":
			decide on "([kind-flag of entry 1 of element-selection set])";
		otherwise:
			decide on "([kind-flag of entry 1 of element-selection set]->[of-kind of entry 1 of element-selection set])";
	otherwise:
		decide on "multiple elements selected";
	
The current status message is indexed text that varies. The current status message is "".


Table of Status
left	central	right
"[selected component]"	"[g-kind of the selected component]"	"[coordinates of the selected component]"

	
Part - Figure definitions

[Resources that we want to exclude from the library window, e.g.. those that are used for UI elements, should be listed first]
Figure of Error is the file "image_problem.png".
Figure of Move Tab is the file "001 Move_tab.png".
Figure of Scale Tab is the file "002 Scale_tab.png".
Figure of Select Tab is the file "003 Select_tab.png".
Figure of Move Bkgd is the file "004 Move_bkgd.png".
Figure of Scale Bkgd is the file "005 Scale_bkgd.png".
Figure of Select Bkgd is the file "006 Select_bkgd.png".
Figure of Move Bkgd Inactive is the file "007 Move_bkgd_inactive.png".
Figure of Scale Bkgd Inactive is the file "008 Scale_bkgd_inactive.png".
Figure of Select Bkgd Inactive is the file "009 Select_bkgd_inactive.png".
Figure of Horizontal Scale Active is the file "010 Button_HScale_active.png".
Figure of Horizontal Scale Inactive is the file "011 Button_HScale_inactive.png".
Figure of Vertical Scale Active is the file "012 Button_VScale_active.png".
Figure of Vertical Scale Inactive is the file "013 Button_VScale_inactive.png".
Figure of Symmetrical Scale Active is the file "014 Button_SymScale_active.png".
Figure of Symmetrical Scale Inactive is the file "015 Button_SymScale_inactive.png".
Figure of Default Scale Active is the file "016 Button_Default_Scale_active.png".
Figure of Default Scale Inactive is the file "017 Button_Default_Scale_inactive.png".
Figure of Nudge Up Active is the file "018 Button_Nudge_Up_active.png".
Figure of Nudge Up Inactive is the file "019 Button_Nudge_Up_inactive.png".
Figure of Nudge Right Active is the file "020 Button_Nudge_Right_active.png".
Figure of Nudge Right Inactive is the file "021 Button_Nudge_Right_inactive.png".
Figure of Nudge Down Active is the file "022 Button_Nudge_Down_active.png".
Figure of Nudge Down Inactive is the file "023 Button_Nudge_Down_inactive.png".
Figure of Nudge Left Active is the file "024 Button_Nudge_Left_active.png".
Figure of Nudge Left Inactive is the file "025 Button_Nudge_Left_inactive.png".
Figure of Nudge Default Active is the file "026 Button_DefaultNudge_active.png".
Figure of Nudge Default Inactive is the file "027 Button_DefaultNudge_inactive.png".
Figure of Align Left Active is the file "028 Button_LAlign_active.png".
Figure of Align Left Inactive is the file "029 Button_LAlign_inactive.png".
Figure of Align Right Active is the file "030 Button_RAlign_active.png".
Figure of Align Right Inactive is the file "031 Button_RAlign_inactive.png".
Figure of Align Top Active is the file "032 Button_TAlign_active.png".
Figure of Align Top Inactive is the file "033 Button_TAlign_inactive.png".
Figure of Align Bottom Active is the file "034 Button_BAlign_active.png".
Figure of Align Bottom Inactive is the file "035 Button_BAlign_inactive.png".
Figure of Center Active is the file "036 Button_Center_active.png".
Figure of Center Inactive is the file "037 Button_Center_inactive.png".
Figure of Layer Move Active is the file "038 Button_LayerMove_active.png".
Figure of Layer Move Inactive is the file "039 Button_LayerMove_inactive.png".
Figure of Graphlink Add Active is the file "040 Button_Graphlink_active.png".
Figure of Graphlink Add Inactive is the file "041 Button_Graphlink_inactive.png".
Figure of Graphlink Delete Active is the file "042 Button_-Graphlink_active.png".
Figure of Graphlink Delete Inactive is the file "043 Button_-Graphlink_inactive.png".
Figure of Highlight Radio Image is the file "044 Radio_Highlight_image.png".
Figure of Highlight Radio Stroke is the file "045 Radio_Highlight_line.png".
Figure of HColor Radio Standard is the file "046 Radio_HColor_std.png".
Figure of HColor Radio Alternate is the file "047 Radio_HColor_alt.png".
Figure of Help Active is the file "048_Help_active.png".
Figure of Help Inactive is the file "049_Help_inactive.png".
Figure of Info Active is the file "050_Info_active.png".
Figure of Info Inactive is the file "051_Info_inactive.png".
Figure of Delete Active is the file "052_Delete_active.png".
Figure of Delete Inactive is the file "053_Delete_inactive.png".
Figure of Asymmetrical Radio Standard is the file "054_Radio_SymScaling_std.png".
Figure of Asymmetrical Radio Alternate is the file "055_Radio_SymScaling_alt.png".
Figure of Select All Active is the file "056_SelectAll_active.png".
Figure of Select All Inactive is the file "057_SelectAll_inactive.png".
Figure of Select Kind Active is the file "058_SelectKind_active.png".
Figure of Select Kind Inactive is the file "059_SelectKind_inactive.png".
Figure of Select Layer Active is the file "060_SelectLayer_active.png".
Figure of Select Layer Inactive is the file "061_SelectLayer_inactive.png".
Figure of Hide Active is the file "062_Hide_active.png".
Figure of Hide Inactive is the file "063_Hide_inactive.png".
Figure of Show Active is the file "064_Show_active.png".
Figure of Show Inactive is the file "065_Show_inactive.png".
Figure of Show All Active is the file "066_ShowAll_active.png".
Figure of Show All Inactive is the file "067_ShowAll_inactive.png".
Figure of Settings Pop Button is the file "068_Settings_pop_button.png".
Figure of Source Pop Button is the file "069_Source_pop_button.png".
Figure of Instances Pop Button is the file "070_Instances_pop_button.png".
Figure of Settings Pop-Up is the file "071_Settings_popup.png".
Figure of Source Pop-Up is the file "072_Source_popup.png".
Figure of Instances Pop-Up is the file "073_Instances_popup.png".
Figure of List Colors Active is the file "074_ListColors_active.png".
Figure of List Colors Inactive is the file "075_ListColors_inactive.png".
Figure of Image Bkgd Active is the file "076_ImgBkgd_active.png".
Figure of Image Bkgd Inactive is the file "077_ImgBkgd_inactive.png".
Figure of Grid Bkgd Active is the file "078_GridBkgd_active.png".
Figure of Grid Bkgd Inactive is the file "079_GridBkgd_inactive.png".
Figure of Outlined Background Active is the file "080_BkgdOutline_active.png".
Figure of Outlined Background Inactive is the file "081_BkgdOutline_inactive.png".
Figure of Generate Source Active is the file "082_GenerateSource_active.png".
Figure of Generate Source Inactive is the file "083_GenerateSource_inactive.png".
Figure of Preview Source Active is the file "084_PreviewSource_active.png".
Figure of Preview Source Inactive is the file "085_PreviewSource_inactive.png".
Figure of Paragraphed Source is the file "086_TabularSource_inactive.png".
Figure of Tabular Source is the file "087_TabularSource_active.png".
Figure of Target Flexible is the file "088_Target_Flexible.png".
Figure of Target Graphical is the file "089_Target_Graphical.png".
Figure of Rename Sprite Active is the file "090_Rename_active.png".
Figure of Rename Sprite Inactive is the file "091_Rename_inactive.png".
Figure of Change Kind Active is the file "092_ChangeKind_active.png".
Figure of Change Kind Inactive is the file "093_ChangeKind_inactive.png".
Figure of Change ID Active is the file "094_ChangeID_active.png".
Figure of Change ID Inactive is the file "095_ChangeID_inactive.png".
Figure of Register Instance Active is the file "096_RegisterInstance_active.png".
Figure of Register Instance Inactive is the file "097_RegisterInstance_inactive.png".
Figure of Load Instance Active is the file "098_LoadInstance_active.png".
Figure of Load Instance Inactive is the file "099_LoadInstance_inactive.png".
Figure of Reveal Instance Active is the file "100_RevealInstance_active.png".
Figure of Reveal Instance Inactive is the file "101_RevealInstance_inactive.png".
Figure of Preview Button Deactivated is the file "102_PreviewSource_deactivated.png".
Figure of Draw Line Active is the file "103_DrawLine_active.png".
Figure of Draw Line Inactive is the file "104_DrawLine_inactive.png".
Figure of Draw Box Active is the file "105_DrawBox_active.png".
Figure of Draw Box Inactive is the file "106_DrawBox_inactive.png".
Figure of Draw Stroked Rect Active is the file "107_DrawStrokedRect_active.png".
Figure of Draw Stroked Rect Inactive is the file "108_DrawStrokedRect_inactive.png".
Figure of Draw Bitmap Text Active is the file "109_DrawBitmapText_active.png".
Figure of Draw Bitmap Text Inactive is the file "110_DrawBitmapText_inactive.png".
Figure of Draw Image Text Active is the file "111_DrawImageText_active.png".
Figure of Draw Image Text Inactive is the file "112_DrawImageText_inactive.png".
Figure of Left Align Active is the file "113_LeftAlign_active.png".
Figure of Left Align Inactive is the file "114_LeftAlign_inactive.png".
Figure of Center Align Active is the file "115_CenterAlign_active.png".
Figure of Center Align Inactive is the file "116_CenterAlign_inactive.png".
Figure of Right Align Active is the file "117_RightAlign_active.png".
Figure of Right Align Inactive is the file "118_RightAlign_inactive.png".
Figure of Line Weight Active is the file "119_LineWeight_active.png".
Figure of Line Weight Inactive is the file "120_LineWeight_inactive.png".
Figure of Draw Window Close is the file "121_DrawWindowClose.png".
Figure of Draw Window Text is the file "122_DrawWindowText.png".
Figure of Draw Window Initial Slug is the file "123_DrawWindowInitialSlug.png".
Figure of Draw Active is the file "124_Draw_active.png".
Figure of Draw Inactive is the file "125_Draw_inactive.png".
Figure of Draw Rect Active is the file "126_DrawRect_active.png".
Figure of Draw Rect Inactive is the file "127_DrawRect_inactive.png".
Figure of Color-Picker Left is the file "128_Color-picker_left.png".
Figure of Color-Picker Center is the file "129_Color-picker_center.png".
Figure of Color-Picker Right is the file "130_Color-picker_right.png".
Figure of Null Color-Chip is the file "131_Null_color-chip.png".
Figure of Tag Active is the file "132_Tag_active.png".
Figure of Tag Inactive is the file "133_Tag_inactive.png".
Figure of Tag Delete Active is the file "134_TagDelete_active.png".
Figure of Tag Delete Inactive is the file "135_TagDelete_inactive.png".
Figure of Duplicate Active is the file "136_Duplicate_active.png".
Figure of Duplicate Inactive is the file "137_Duplicate_inactive.png".
Figure of Zoom In is the file "138_Zoom_in.png".
Figure of Zoom Out Active is the file "139_Zoom_out_active.png".
Figure of Zoom Out Inactive is the file "140_Zoom_out_inactive.png".

Figure of Occluder is the file "Occluder.png".
Figure of Eyeball Active is the file "Eyeball_active.png".
Figure of Eyeball Inactive is the file "Eyeball_inactive.png".
Figure of Page Left is the file "Button_Page_Left.png".
Figure of Page Right is the file "Button_Page_Right.png".
Figure of Library Header is the file "Library_Header.png".
Figure of Highlight is the file "Highlight.png".
Figure of Alternate Highlight is the file "Highlight_alternate.png".
Figure of Layer Icon is the file "Layer2 icon.png".
Figure of Layer Selected is the file "Layer2 selection.png".
Figure of Layer Occupied is the file "Layer2 presence.png".
Figure of Layer Indicated is the file "Layer2 indicator.png".
Figure of Layer Terminator Occupied is the file "Layer2 terminator presence.png".
Figure of Layer Terminator Selected is the file "Layer2 terminator selection.png".
Figure of Layer Terminator is the file "Layer2 terminator.png".
Figure of Layer 01 is the file "Layer 01.png".
Figure of Layer 02 is the file "Layer 02.png".
Figure of Layer 03 is the file "Layer 03.png".
Figure of Layer 04 is the file "Layer 04.png".
Figure of Layer 05 is the file "Layer 05.png".
Figure of Layer 06 is the file "Layer 06.png".
Figure of Layer 07 is the file "Layer 07.png".
Figure of Layer 08 is the file "Layer 08.png".
Figure of Layer 09 is the file "Layer 09.png".
Figure of Layer 10 is the file "Layer 10.png".
Figure of Layer 11 is the file "Layer 11.png".
Figure of Layer 12 is the file "Layer 12.png".
Figure of Layer 13 is the file "Layer 13.png".
Figure of Layer 14 is the file "Layer 14.png".
Figure of Layer 15 is the file "Layer 15.png".
Figure of Layer 16 is the file "Layer 16.png".
Figure of Layer 17 is the file "Layer 17.png".
Figure of Layer 18 is the file "Layer 18.png".
Figure of Layer 19 is the file "Layer 19.png".
Figure of Layer 20 is the file "Layer 20.png".
Figure of Layer 21 is the file "Layer 21.png".
Figure of Layer 22 is the file "Layer 22.png".
Figure of Layer 23 is the file "Layer 23.png".
Figure of Layer 24 is the file "Layer 24.png".

The built-in resources index is a number that varies. The built-in resources index is usually 180. [This number is the resource number of the last of the internal figures, i.e. those in the first list, which we want to exclude from the library window.]


Part - Highlighting

The current highlight image is a figure name that varies. The current highlight image is usually Figure of Highlight.

To draw element-selection markers:
	repeat with selected-element running through the element-selection set:
		if the selected-element is a linkid listed in the Table of Graphlink Glulx Replacement Commands:
			if image highlighting is true:
				display the current highlight image in g-win entry at (p-left entry) by (p-top entry) with dimensions (p-right entry minus p-left entry) by (p-bottom entry minus p-top entry);
			otherwise:
				draw a box (color highlight-color) in (g-win entry) from (p-left entry) by (p-top entry) to (p-right entry) by (p-bottom entry) with 3 pixel line-weight, outlined;
	[unless sprite-scaling set is empty:
		if entry 1 of the sprite-scaling set is a linkid listed in the Table of Graphlink Glulx Replacement Commands:
			draw a rectangle with scaling-color stroke of 3 pixels in g-win entry from p-left entry by p-top entry to p-right entry by p-bottom entry, outlining;]
			
			

Part - The Layer Indicator

Every turn when the layers-window is g-present:
	follow the window-drawing rules for the layers-window;
					
Indicated layers is a number that varies. Indicated layers is 2. [This is the number of layers in the indicator at any one time, generally the highest active layer plus 1, up to the maximum number.]

Layer indicator margin is a number that varies. Layer indicator margin is 5.
Layer indicator allowance is a number that varies. Layer indicator allowance is 2.

Indicated-icon is a figure name that varies. Indicated-icon is Figure of Layer Indicated.
Occupied-icon is a figure name that varies. Occupied-icon is Figure of Layer Occupied.
Selected-icon is a figure name that varies. Selected-icon is Figure of Layer Selected.
Layer-icon is a figure name that varies. Layer-icon is Figure of Layer Icon.
Occupied-terminator is a figure name that varies. Occupied-terminator is Figure of Layer Terminator Occupied.
Terminator-icon is a figure name that varies. Terminator-icon is Figure of Layer Terminator.
Selected-terminator is a figure name that varies. Selected-terminator is Figure of Layer Terminator Selected.
The scan-height is a number that varies. The scan-height is 36. [The layer icons are designed to overlap one another. The scan-height is the number of pixels, counting from the *bottom* of the original image, where that overlap begins. We use the bottom because the layer indicator is built from the bottom up.]

A layer-element is a kind of sprite. The associated canvas is the layers-canvas.
A layer-element has a number called the layer-index. 

Some layer-elements are defined by the Table of Layer Sprites.

Table of Layer Sprites
sprite	layer-index	linked replacement-command	image-ID
Layer_1	1	"CHANGE DEFAULT LAYER TO 1"	Figure of Layer 01
Layer_2	2	"CHANGE DEFAULT LAYER TO 2"	Figure of Layer 02
Layer_3	3	"CHANGE DEFAULT LAYER TO 3"	Figure of Layer 03
Layer_4	4	"CHANGE DEFAULT LAYER TO 4"	Figure of Layer 04
Layer_5	5	"CHANGE DEFAULT LAYER TO 5"	Figure of Layer 05
Layer_6	6	"CHANGE DEFAULT LAYER TO 6"	Figure of Layer 06
Layer_7	7	"CHANGE DEFAULT LAYER TO 7"	Figure of Layer 07
Layer_8	8	"CHANGE DEFAULT LAYER TO 8"	Figure of Layer 08
Layer_9	9	"CHANGE DEFAULT LAYER TO 9"	Figure of Layer 09
Layer_10	10	"CHANGE DEFAULT LAYER TO 10"	Figure of Layer 10
Layer_11	11	"CHANGE DEFAULT LAYER TO 11"	Figure of Layer 11
Layer_12	12	"CHANGE DEFAULT LAYER TO 12"	Figure of Layer 12
Layer_13	13	"CHANGE DEFAULT LAYER TO 13"	Figure of Layer 13
Layer_14	14	"CHANGE DEFAULT LAYER TO 14"	Figure of Layer 14
Layer_15	15	"CHANGE DEFAULT LAYER TO 15"	Figure of Layer 15
Layer_16	16	"CHANGE DEFAULT LAYER TO 16"	Figure of Layer 16
Layer_17	17	"CHANGE DEFAULT LAYER TO 17"	Figure of Layer 17
Layer_18	18	"CHANGE DEFAULT LAYER TO 18"	Figure of Layer 18
Layer_19	19	"CHANGE DEFAULT LAYER TO 19"	Figure of Layer 19
Layer_20	20	"CHANGE DEFAULT LAYER TO 20"	Figure of Layer 20
Layer_21	21	"CHANGE DEFAULT LAYER TO 21"	Figure of Layer 21
Layer_22	22	"CHANGE DEFAULT LAYER TO 22"	Figure of Layer 22
Layer_23	23	"CHANGE DEFAULT LAYER TO 23"	Figure of Layer 23
Layer_24	24	"CHANGE DEFAULT LAYER TO 24"	Figure of Layer 24

		
Layer indicator construction is a rulebook.
The layer indicator construction rulebook has a real number called the layer indicator scaling factor.
The layer indicator construction rulebook has a number called the layer icon width.
The layer indicator construction rulebook has a number called the layer icon height.
The layer indicator construction rulebook has a number called the top margin.
		
The first layer indicator construction rule (this is the place reveal icon rule):
	if the layers-window is g-present:
		let icon be the image-ID of layer_reveal_modal;
		let dim-x be the image-width of icon;
		let dim-y be the image-height of icon;
		let elem-x be the width of the layers-window minus layer indicator allowance;
		let factor be elem-x real divided by dim-x as a fixed point number;
		let elem-y be dim-y real times factor as an integer;
		display icon in layers-window at (layer indicator allowance) by (layer indicator margin) with dimensions (elem-x) by (elem-y);
		set a graphlink in layers-window identified as layer_reveal_modal from layer indicator allowance by layer indicator margin to (layer indicator allowance + elem-x) by (layer indicator margin + elem-y) as linked replacement-command of layer_reveal_modal;
		change the top margin to layer indicator margin plus layer indicator margin plus layer indicator allowance plus elem-y;
		
A layer indicator construction rule (this is the draw layer icons rule):
	if layers-window is g-present:
		let vertical-measure be the height of layers-window minus (top margin plus layer indicator margin);
		let horizontal-measure be the width of layers-window minus layer indicator allowance;
		let dim-x be the image-width of layer-icon;
		let dim-y be the image-height of layer-icon;
		if (vertical-measure divided by maximum display-layer) <= dim-y:
			now layer icon height is vertical-measure divided by maximum display-layer;
			let overlap-factor be dim-y real divided by scan-height as a fixed point number;
			change layer icon height to layer icon height real times overlap-factor as an integer;[This rescales the icons to account for the degree of overlap between them]
			now layer indicator scaling factor is layer icon height real divided by dim-y as a fixed point number;
			now layer icon width is dim-x real times layer indicator scaling factor as an integer;
			if layer icon width > horizontal-measure:
				now layer icon width is horizontal-measure;
				now layer indicator scaling factor is layer icon width real divided by dim-x as a fixed point number;
				now layer icon height is dim-y real times layer indicator scaling factor as an integer;
		let row-scan be the scan-height real times layer indicator scaling factor as an integer;[this ensures proper overlap of layer icons]
		[Create a list of the layers represented among the sprites:]
		let present-list be a list of numbers;
		repeat with current-element running through display-active in-play g-elements:
			if the associated canvas of working window is the associated canvas of current-element:
				if the display-layer of current-element is not listed in present-list:
					add display-layer of current-element to present-list;
		if present-list is empty:
			now present-list is {0};
		[Create a list of the layers with selected sprites:]
		let selected-list be a list of numbers;
		if the element-selection set is empty:
			let selected-list be {0};
		otherwise:
			repeat with current-element running through element-selection set:
				if the display-layer of current-element is not listed in selected-list:
					add display-layer of current-element to selected-list;
			if selected-list is empty:
				now selected-list is {0};
		[draw the appropriate layer images:]
		let col-offset be (horizontal-measure minus layer icon width) divided by 2;
		let col be layer indicator allowance plus col-offset;
		repeat with index running from 1 to indicated layers:
			let row be vertical-measure minus row-scan times (index minus 1);
			if index is the current display-layer:
				display indicated-icon in layers-window at (col) by (row) with dimensions (layer icon width) by (layer icon height);
		let L be the list of layer-elements;
		sort L in layer-index order;
		repeat with current-element running through L:
			let index be the layer-index of current-element;
			if index > indicated layers, break;
			let row be vertical-measure minus row-scan times (index minus 1);
			if index is listed in the selected-list:
				if index is maximum display-layer:
					display selected-terminator in layers-window at col by row with dimensions layer icon width by layer icon height;
				otherwise:
					display selected-icon in layers-window at col by row with dimensions layer icon width by layer icon height;
			otherwise if index is listed in the present-list:
				if index is maximum display-layer:
					display occupied-terminator in layers-window at col by row with dimensions layer icon width by layer icon height;
				otherwise:
					display occupied-icon in layers-window at col by row with dimensions layer icon width by layer icon height;
			otherwise:
				if index is maximum display-layer:
					display terminator-icon in layers-window at col by row with dimensions layer icon width by layer icon height;
				otherwise:
					display layer-icon in layers-window at col by row with dimensions layer icon width by layer icon height;
			set a graphlink in layers-window identified as current-element from col by row to (col + layer icon width) by (row + layer icon height) as linked replacement-command of current-element;
			
	
Part - Define dynamic sprites

[Because Inform lacks multiple inheritance, we need to create a full system of kinds parallel to those usable with Canvas-Based Drawing. We define most of the properties with the dynamic-sprite, and then apply them later to other classes. A parallel effect could probably be achieved with properties (and it likely should have been done that way), but I was never satisfied with methods that didn't use kinds--so we have this unwieldy system...]

A thing can be either real or legerdemained. A thing is usually real.

Definition: A g-element is in-play:
	if it is standard, yes;
	if it is instanced, yes;
	no.

A dynamic-sprite is a kind of sprite. The associated canvas of a dynamic-sprite is the library-canvas.

A dynamic-sprite has an indexed text called the element-name. The element-name is usually "". 

A dynamic-sprite has a number called the instance-counter. The instance-counter is usually 0.

A g-element can be deleted, standard, instanced, or parental (this is its element-status). A g-element is usually parental. [A dynamic-sprite is usually parental.]

A dynamic-sprite has some text called the kind-flag. The kind-flag of a dynamic-sprite is "sprite".
A dynamic-sprite has some indexed text called the of-kind.

A dynamic-sprite has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in 5Z71, whereby lists cannot be sorted on indexed text properties. The bug was fixed in 6Exx, but I didn't have the gumption to change everything back...]

A dynamic-sprite has some indexed text called the replacement-command. The replacement-command is "".

A dynamic-sprite has a figure name called the image-ID. The image-ID is usually Figure of Error.

A dynamic-sprite has some indexed text called the tag.

A dynamic-sprite has a number called the sprite-x. The sprite-x is 0.
A dynamic-sprite has a number called the sprite-y. The sprite-y is 0.


Chapter - The mother-sprite

The mother-sprite is a dynamic-sprite. The image-ID is Figure of Error. The element-name is "Error_1". The origin is {10, 0}. The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000.[The mother-sprite is in Fake-room_x.]

Current_row is a number that varies. Current_row is 0.

To initialize the/-- dynamic sprites:
	let L be the list of figure names;
	repeat with current-sprite running through L:
		if the resource number of current-sprite is greater than the built-in resources index:
			create a new sprite from mother-sprite using current-sprite.
		
To decide which number is the resource number of (F - a figure name):
	(- ResourceIDsOfFigures-->{F} -)

To create a new sprite from (S - a g-element) using (F - a figure name):
	let the new sprite be a new object cloned from S;
	change the image-ID of the new sprite to F;
	change the display status of new sprite to g-active;
	unlink the element-name of the new sprite;
	change the element-name of the new sprite to "[F]" stripped of "Figure of " concatenated with the instance-counter of S;
	replace the text " " in the element-name of the new sprite with "_";
	change the x-scaling factor of the new sprite to 1.0000;
	change the y-scaling factor of the new sprite to 1.0000;
	unlink the origin of the new sprite;
	unlink the tag of the new sprite;
	change entry 2 of the origin of the new sprite to current_row plus 8;
	let vertical-offset be the image-height of the image-ID of the new sprite;
	increase the current_row by the vertical-offset;
	if using the logged sprite creation option, say "New sprite [element-name of new sprite] created from [image-ID of new sprite].";

To decide which indexed text is (T - indexed text) concatenated with (N - a number):
	decide on "[T]_[N]".
	
To decide which indexed text is (T - indexed text) stripped of (R - indexed text):
	replace the text R in T with "";
	decide on "[T]".
	
To unlink (P - property) of (O - object):
	(- DO_UnlinkProp({P}, {O}); -). [see Dynamic Objects for the definition of this routine]

To say objUID of (O - an object):
	(- print {O}; -)
	

Part - Additional classes for drawing shapes and strings

Chapter - Extension to primitives

A primitive has a number called the element-width. The element-width is 0.
A primitive has a number called the element-height. The element-height is 0.


Chapter - Dynamic drawing classes
[The subsections that follow are all repetitive code that would not be necessary if Inform had multiple inheritance.]

A g-primitive is a kind of value. The g-primitives are rectangle, box, stroked rectangle, line. 

A g-string is a kind of value. The g-strings are bitmap string, and image string.

Table of Primitive Types
g-primitive	mother-element
rectangle	mother-rectangle
box	mother-box
stroked rectangle	mother-stroked-rectangle
line	mother-line


Table of String Types
g-string	mother-element
bitmap string	mother-bitmap-string
image string	mother-image-string


To decide which g-element is the progenitor of (G - a g-primitive):
	if there is a g-primitive of G in the Table of Primitive Types:
		decide on the mother-element corresponding to a g-primitive of G in the Table of Primitive Types.
		
To decide which g-element is the progenitor of (G - a g-string):
	if there is a g-string of G in the Table of String Types:
		decide on the mother-element corresponding to a g-string of G in the Table of String Types.


Section - Dynamic rectangles

A dynamic-rectangle is a kind of rectangle primitive. The display status is g-inactive. The associated canvas is usually the editor-canvas. The g-primitive is rectangle.

A dynamic-rectangle has an indexed text called the element-name. The element-name is usually "". 
A dynamic-rectangle has a number called the instance-counter. The instance-counter is usually 0.
[A dynamic-rectangle can be deleted, standard, instanced, or parental (this is its element-status). A dynamic-rectangle is usually parental.]
A dynamic-rectangle has some indexed text called the of-kind. The of-kind is usually "".
A dynamic-rectangle has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in 5Z71, whereby lists could not be sorted on indexed text properties.]
A dynamic-rectangle has some indexed text called the replacement-command. The replacement-command is "".
A dynamic-rectangle has some text called the kind-flag. The kind-flag is "rectangle primitive".
A dynamic-rectangle has some indexed text called the tag.

The mother-rectangle is a dynamic-rectangle. The element-name is "Error_Rect1". The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000.


Section - Dynamic boxes

A dynamic-box is a kind of box primitive. The display status is g-inactive. The associated canvas is usually the editor-canvas. The g-primitive is box.

A dynamic-box has an indexed text called the element-name. The element-name is usually "". 
A dynamic-box has a number called the instance-counter. The instance-counter is usually 0.
[A dynamic-box can be deleted, standard, instanced, or parental (this is its element-status). A dynamic-box is usually parental.]
A dynamic-box has some indexed text called the of-kind. The of-kind is usually "".
A dynamic-box has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in build 5Z71, whereby lists could not be sorted on indexed text properties.]
A dynamic-box has some indexed text called the replacement-command. The replacement-command is "".
A dynamic-box has some text called the kind-flag. The kind-flag is "box primitive".
A dynamic-box has some indexed text called the tag.

The mother-box is a dynamic-box. The element-name is "Error_Box1". The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000.


Section - Dynamic stroked rectangles

A dynamic-stroked-rectangle is a kind of stroked rectangle primitive. The display status is g-inactive. The associated canvas is usually the editor-canvas. The g-primitive is stroked rectangle.

A dynamic-stroked-rectangle has an indexed text called the element-name. The element-name is usually "". 
A dynamic-stroked-rectangle has a number called the instance-counter. The instance-counter is usually 0.
[A dynamic-stroked-rectangle can be deleted, standard, instanced, or parental (this is its element-status). A dynamic-stroked-rectangle is usually parental.]
A dynamic-stroked-rectangle has some indexed text called the of-kind. The of-kind is usually "".
A dynamic-stroked-rectangle has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in 5Z71, whereby lists could not be sorted on indexed text properties.]
A dynamic-stroked-rectangle has some indexed text called the replacement-command. The replacement-command is "".
A dynamic-stroked-rectangle has some text called the kind-flag. The kind-flag is "stroked rectangle primitive".
A dynamic-stroked-rectangle has some indexed text called the tag.

The mother-stroked-rectangle is a dynamic-stroked-rectangle. The element-name is "Error_StrRect1". The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000.


Section - Dynamic lines

A dynamic-line is a kind of line primitive. The display status is g-inactive. The associated canvas is usually the editor-canvas. The g-primitive is line.

A dynamic-line has an indexed text called the element-name. The element-name is usually "". 
A dynamic-line has a number called the instance-counter. The instance-counter is usually 0.
[A dynamic-line can be deleted, standard, instanced, or parental (this is its element-status). A dynamic-line is usually parental.]
A dynamic-line has some indexed text called the of-kind. The of-kind is usually "".
A dynamic-line has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in 5Z71, whereby lists could not be sorted on indexed text properties.]
A dynamic-line has some indexed text called the replacement-command. The replacement-command is "".
A dynamic-line has some text called the kind-flag. The kind-flag is "line primitive".
A dynamic-line has some indexed text called the tag.

The mother-line is a dynamic-line. The element-name is "Error_Rect1". The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000. The origin is {0, 0}. The endpoint is {0, 0}.


Section - Dynamic bitmap texts

A dynamic-bitmap-string is a kind of bitmap-rendered string. The display status is g-inactive. The associated canvas is usually the editor-canvas. The g-string is bitmap string.

A dynamic-bitmap-string has an indexed text called the element-name. The element-name is usually "". 
A dynamic-bitmap-string has a number called the instance-counter. The instance-counter is usually 0.
[A dynamic-bitmap-string can be deleted, standard, instanced, or parental (this is its element-status). A dynamic-bitmap-string is usually parental.]
A dynamic-bitmap-string has some indexed text called the of-kind. The of-kind is usually "".
A dynamic-bitmap-string has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in 5Z71, whereby lists could not be sorted on indexed text properties.]
A dynamic-bitmap-string has some indexed text called the replacement-command. The replacement-command is "".
A dynamic-bitmap-string has some text called the kind-flag. The kind-flag is "bitmap-rendered string".
A dynamic-bitmap-string has some indexed text called the tag.

The mother-bitmap-string is a dynamic-bitmap-string. The element-name is "Error_Rect1". The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000. 

Section - Dynamic image texts

A dynamic-image-string is a kind of image-rendered string. The display status is g-inactive. The associated canvas is usually the editor-canvas. The g-string is image string.

A dynamic-image-string has an indexed text called the element-name. The element-name is usually "". 
A dynamic-image-string has a number called the instance-counter. The instance-counter is usually 0.
[A dynamic-image-string can be deleted, standard, instanced, or parental (this is its element-status). A dynamic-image-string is usually parental.]
A dynamic-image-string has some indexed text called the of-kind. The of-kind is usually "".
A dynamic-image-string has a number called the kind-index. The kind-index is 0. [This is part of an elaborate workaround for a bug with list-sorting in 5Z71, whereby lists could not be sorted on indexed text properties.]
A dynamic-image-string has some indexed text called the replacement-command. The replacement-command is "".
A dynamic-image-string has some text called the kind-flag. The kind-flag is "image-rendered string".
A dynamic-image-string has some indexed text called the tag.

The mother-image-string is a dynamic-image-string. The element-name is "Error_Rect1". The display status is g-inactive. The graphlink status is g-active. The linked replacement-command is "". The x-scaling factor is 1.0000. The y-scaling factor is 1.0000.


Part - Paging and drawing the library-window

The current-page is a number that varies. The current-page is 1.

A dynamic-sprite has a number called the page-number. The page-number is 1.

Minimum library-size is a number that varies. Minimum library-size is 50.

Library-margin is a number that varies. Library-margin is 24.

Row-coord is a number that varies. Col-coord is a number that varies. [Made global only because of built-in limits on the number of temporary variables in a phrase]

Page-count is a number that varies. Page-capacity is a number that varies. Paged-rows is a number that varies. Paged-columns is a number that varies.
[Page-count is the number of "pages" in the library window. It is determined by iteration in the page and scale routine and should only be used after that routine has been called.

Page-capacity represents the number of items per page and will be derived from multipying paged-rows by paged-columns; these would be local variables except that the page and scale routine otherwise maxes out the allowable number of local variables within a single phrase.]

The library-paging rules are a rulebook.

A library-paging rule when the page-count is greater than 1 (this is the right arrow display rule):
	if page-count minus current-page is greater than 0:
		now the display status of page-right_button is g-active;
	otherwise:
		now the display status of page-right_button is g-inactive;
	continue the action;

A library-paging rule when the page-count is greater than 1 (this is the left arrow display rule):
	if current-page is greater than 1:
		now the display status of page-left_button is g-active;
	otherwise:
		now the display status of page-left_button is g-inactive;
	continue the action;
	
A library-paging rule when the page-count is less than 2 (this is the no arrows display rule):
	now the display status of page-left_button is g-inactive;
	now the display status of page-right_button is g-inactive;

Nudge-direction is a kind of value. The nudge-directions are upward, leftward, rightward, and downward.
	
Library-paging is an action applying to one value. Understand "page [nudge-direction]" as library-paging.

Carry out library-paging:
	if the nudge-direction understood is:
		-- rightward: increase current-page by 1;
		-- leftward: decrease current-page by 1;
	follow the window-drawing rules for the library-window;
	follow the window-drawing rules for the paging-window;
	rule succeeds;

To page and scale the/-- library-window sprites: 
	if the library-window is g-present:
		now the canvas-width of the library-canvas is the width of the library-window;
		now the canvas-height of the library-canvas is the height of the library-window;
		let starting-row be library-margin;
		change paged-columns to (canvas-width of the library-canvas minus library-margin) / (minimum library-size + library-margin);
		change paged-rows to (canvas-height of the library-canvas minus starting-row) / (minimum library-size + library-margin);
		[say "Paged columns: [paged-columns]; paged rows: [paged-rows][line break]";]
		let standard-width be (canvas-width of the library-canvas minus library-margin) / paged-columns as a fixed point number;
		let standard-height be (canvas-height of the library-canvas minus starting-row) / paged-rows as a fixed point number;
		[say "[grid-x of the library-window]:[grid-x of the library-window minus library-margin]:[standard-width][line break]";
		say "[grid-y of the library-window]:[grid-y of the library-window minus starting-row]:[standard-height][line break]";]
		change standard-width to standard-width real minus library-margin;
		change standard-height to standard-height real minus library-margin;
		[say "The standard width is: [standard-width]; the standard height is [standard-height][line break]";]
		change page-capacity to paged-rows times paged-columns;
		let running-count be 1;
		change page-count to 1;
		let row-scan be 1;
		let column-scan be 1;
		change row-coord to library-margin;
		change col-coord to library-margin;
		repeat with current-element running through display-active dynamic-sprites:
			[say "Row # [row-scan]; Column # [column-scan][line break]Row: [row-coord]; Column: [col-coord][line break]";]
			if the associated canvas of current-element is the library-canvas:
				let temp be the image-width of the image-ID of current-element;
				change the sprite-x of the current-element to temp;
				let temp be the image-height of the image-ID of current-element;
				change the sprite-y of the current-element to temp;
				let elem-x be the sprite-x of current-element as a fixed point number;
				let elem-y be the sprite-y of current-element as a fixed point number;
				if the standard-width real divided by elem-x is real greater than the standard-height real divided by elem-y:
					change the x-scaling factor of current-element to the standard-height real divided by elem-y;
					change the y-scaling factor of current-element to the standard-height real divided by elem-y;
				otherwise:
					change the x-scaling factor of current-element to the standard-width real divided by elem-x;
					change the y-scaling factor of current-element to the standard-width real divided by elem-x;
				if the x-scaling factor of current-element is greater than 1.0000, change the x-scaling factor of current-element to 1.0000;
				if the y-scaling factor of current-element is greater than 1.0000, change the y-scaling factor of current-element to 1.0000;
				change entry 1 of the origin of current-element to col-coord;
				change entry 2 of the origin of current-element to row-coord;
				[say "([origin of current-element]).";]
				change the page-number of current-element to page-count;
				increase running-count by 1;
				increase column-scan by 1;
				if column-scan is not greater than paged-columns:
					increase col-coord by standard-width as an integer plus library-margin;
				otherwise:
					change column-scan to 1;
					change col-coord to library-margin;
					increase row-scan by 1;
					increase row-coord by standard-height as an integer plus library-margin;
				if running-count > page-capacity:
					increase page-count by 1;
					now row-scan is 1;
					now column-scan is 1;
					now row-coord is library-margin;
					now col-coord is library-margin;
					now running-count is 1;
				[say "[element-name of current-element]: [sprite-x of current-element], [sprite-y of current-element] ([sprite-scaling factor of current-element])[line break]";]
			
To draw the/-- library instances of/in (win - a g-window):
	[say "number of pages = [page-count]";]
	prune the link-table of win links;
	repeat with current-element running through display-active dynamic-sprites assigned to win:
		if current-element is assigned to win:
			[say "[element-name of current-element]: ";]
			if the page-number of the current-element is the current-page:
				[Delete: let cur-image be image-ID of current-element;]
				let elem-x be entry 1 of the origin of the current-element;
				let elem-y be entry 2 of the origin of the current-element;
				[say "([elem-x], [elem-y]).";]
				let x-sprite be the sprite-x of current-element as a fixed point number;
				let y-sprite be the sprite-y of the current-element as a fixed point number;
				let dim-x be x-sprite real times the x-scaling factor of the current-element as an integer;
				let dim-y be y-sprite real times the y-scaling factor of the current-element as an integer;
				[say "drawing [element-name of current-element]: [dim-x], [dim-y] ([scaling factor of the current-element])[line break]";]
				display sprite current-element in win at coordinates elem-x and elem-y with dimensions dim-x and dim-y;
				if current-element is graphlinked:
					set a graphlink in win identified as current-element from elem-x by elem-y to (elem-x + dim-x) by (elem-y + dim-y) as the linked replacement-command of current-element;
					[say "Graphlinked as: [elem-x],[elem-y] - [elem-x + dim-x],[elem-y + dim-y][line break]";]


Part - Control Window tabs and buttons

Every turn when the control-window is g-present:
	follow the window-drawing rules for the control-window.

A UI-element is a kind of sprite. The graphlink status is usually g-active. The linked replacement-command is usually "". The associated canvas of a UI-element is the control-canvas. 

A UI-element has a figure name called the active-state.
A UI-element has a figure name called the inactive-state.

[This phrase allows us to peg a UI element to a boolean, and is used with checkboxes, dual-selection radio buttons, and modal buttons]
To update (M - a UI-element) using (boolean - a truth state):
	if boolean is true:
		now the image-ID of M is the active-state of M;
	otherwise:
		now the image-ID of M is the inactive-state of M;


Chapter - Tabs

A tab is a kind of sprite. The display status of a tab is usually g-active. The graphlink status of a tab is usually g-active. The associated canvas of a tab is the control-canvas. The display-layer is 3.

A tab has a list of g-elements called the members. [Used to turn all of the UI elements associated with a tab on or off at once.]

A tab-background is a kind of UI-element. The display status of a tab-background is g-active. The graphlink status is g-inactive. The origin is {22, 12}. The associated canvas is the control-canvas. The display-layer is 1.

The activated background layer is a number that varies. The activated background layer is 2. [This is a global variable containing the display layer to be used for an active tab.]
The inactivated background layer is a number that varies. The inactivated background layer is 1.

Some tab-backgrounds are defined by the Table of Tab Backgrounds.

Table of Tab Backgrounds
sprite	image-ID	active-state	inactive-state
Select_bkgd	Figure of Select Bkgd Inactive	Figure of Select Bkgd	Figure of Select Bkgd Inactive
Scale_bkgd	Figure of Scale Bkgd Inactive	Figure of Scale Bkgd	Figure of Scale Bkgd Inactive
Move_bkgd	Figure of Move Bkgd Inactive	Figure of Move Bkgd	Figure of Move Bkgd Inactive


A tab has a tab-background called the underlayment.

The activated tab layer is a number that varies. The activated tab layer is 4. [This is a global variable containing the display layer to be used for an active tab.]
The inactivated tab layer is a number that varies. The inactivated tab layer is 3.

To decide which tab is the current tab:
	repeat with item running through the list of tabs:
		if the display-layer of item is the activated tab layer, decide on item;
	decide on Select_tab.

Some tabs are defined by the Table of Tab-Sprites.

Table of Tab-Sprites
sprite	image-ID	linked replacement-command	origin	underlayment
Select_tab	Figure of Select Tab	"SELECT MODE"	{251, 558}	Select_bkgd
Scale_tab	Figure of Scale Tab	"MODE SCALE"	{411, 558}	Scale_bkgd
Move_tab	Figure of Move Tab	"MOVE MODE"	{332, 558}	Move_bkgd
[**** The "mode scale" is necessary because a bug in Inform, post-5Z71, prevents "scale mode" from being interpreted correctly.]

The display-layer of Move_tab is usually 4. [Sets the tab that will be activated on startup (must be equal to the "activated tab layer" variable.]


Chapter - Buttons

A button is a kind of UI-element. The display status of a button is usually g-inactive.

The button-layer is a number that varies. The button-layer is 4. The display-layer of a button is 4.

Some buttons are defined by the Table of Button-Sprites. [Buttons that occur outside the tabs need to be made display-active from the beginning, while buttons within tabs will be activated/deactivated by their tabs.]

Table of Button-Sprites						
sprite	image-ID	origin	active-state	inactive-state	linked replacement-command	display status
Nudge-up_button	Figure of Nudge Up Inactive	{65, 196}	Figure of Nudge Up Active	Figure of Nudge Up Inactive	"NUDGE UPWARD"	g-inactive
Nudge-right_button	Figure of Nudge Right Inactive	{96, 222}	Figure of Nudge Right Active	Figure of Nudge Right Inactive	"NUDGE RIGHTWARD"	g-inactive
Nudge-left_button	Figure of Nudge Left Inactive	{37, 222}	Figure of Nudge Left Active	Figure of Nudge Left Inactive	"NUDGE LEFTWARD"	g-inactive
Nudge-down_button	Figure of Nudge Down Inactive	{65, 252}	Figure of Nudge Down Active	Figure of Nudge Down Inactive	"NUDGE DOWNWARD"	g-inactive
Nudge_def_button	Figure of Nudge Default Inactive	{161, 219}	Figure of Nudge Default Active	Figure of Nudge Default Inactive	"CHANGE NUDGE AMOUNT"	g-inactive
Scale_sym_button	Figure of Symmetrical Scale Inactive	{38, 199}	Figure of Symmetrical Scale Active	Figure of Symmetrical Scale Inactive	"SCALE SYMMETRICALLY"	g-inactive
Scale_horiz_button	Figure of Horizontal Scale Inactive	{38, 250}	Figure of Horizontal Scale Active	Figure of Horizontal Scale Inactive	"SCALE HORIZONTALLY"	g-inactive
Scale_vert_button	Figure of Vertical Scale Inactive	{266, 250}	Figure of Vertical Scale Active	Figure of Vertical Scale Inactive	"SCALE VERTICALLY"	g-inactive
Scale_default_button	Figure of Default Scale Inactive	{38, 463}	Figure of Default Scale Active	Figure of Default Scale Inactive	"SET DEFAULT SCALE"	g-inactive
Align_left_button	Figure of Align Left Inactive	{38, 357}	Figure of Align Left Active	Figure of Align Left Inactive	"ALIGN LEFT"	g-inactive
Align_top_button	Figure of Align Top Inactive	{92, 357}	Figure of Align Top Active	Figure of Align Top Inactive	"ALIGN TOP"	g-inactive
Align_right_button	Figure of Align Right Inactive	{146, 357}	Figure of Align Right Active	Figure of Align Right Inactive	"ALIGN RIGHT"	g-inactive
Align_bottom_button	Figure of Align Bottom Inactive	{200, 357}	Figure of Align Bottom Active	Figure of Align Bottom Inactive	"ALIGN BOTTOM"	g-inactive
Center_button	Figure of Center Inactive	{298, 362}	Figure of Center Active	Figure of Center Inactive	"CENTER ON"	g-inactive
Layer_move_button	Figure of Layer Move Inactive	{39, 462}	Figure of Layer Move Active	Figure of Layer Move Inactive	"MOVE TO NEW LAYER"	g-inactive
Graphlink_add_button	Figure of Graphlink Add Inactive	{38, 329}	Figure of Graphlink Add Active	Figure of Graphlink Add Inactive	"ADD LINK"	g-inactive
Graphlink_delete_button	Figure of Graphlink Delete Inactive	{225, 329}	Figure of Graphlink Delete Active	Figure of Graphlink Delete Inactive	"REMOVE LINK"	g-inactive
Info_button	Figure of Info Inactive	{73, 563}	Figure of Info Active	Figure of Info Inactive	"INFO"	g-active
Delete_button	Figure of Delete Inactive	{34, 563}	Figure of Delete Active	Figure of Delete Inactive	"DELETE"	g-active
Zoom_button	Figure of Zoom In	{160, 563}	Figure of Zoom Out Active	Figure of Zoom In	"ZOOM"
Draw_button	Figure of Draw Inactive	{199, 563}	Figure of Draw Active	Figure of Draw Inactive	"[if drawing-window is g-present]CLOSE DRAWING TOOLS[otherwise]OPEN DRAWING TOOLS"	g-active
Select_all_button	Figure of Select All Inactive	{39, 143}	Figure of Select All Active	Figure of Select All Inactive	"SELECT ALL"	g-inactive
Select_kind_button	Figure of Select Kind Inactive	{192, 143}	Figure of Select Kind Active	Figure of Select Kind Inactive	"SELECT SAME KIND"	g-inactive
Select_layer_button	Figure of Select Layer Inactive	{364, 143}	Figure of Select Layer Active	Figure of Select Layer Inactive	"SELECT SAME LAYER"	g-inactive
Hide_button	Figure of Hide Inactive	{38, 207}	Figure of Hide Active	Figure of Hide Inactive	"HIDE"	g-inactive
Show_button	Figure of Show Inactive	{207, 207}	Figure of Show Active	Figure of Show Inactive	"SHOW"	g-inactive
Show_all_button	Figure of Show All Inactive	{375, 207}	Figure of Show All Active	Figure of Show All Inactive	"SHOW ALL"	g-inactive
List_colors_button	Figure of List Colors Inactive	{52, 110}	Figure of List Colors Active	Figure of List Colors Inactive	"LIST COLORS"	g-inactive
Image_bkgd_button	Figure of Image Bkgd Inactive	{52, 266}	Figure of Image Bkgd Active	Figure of Image Bkgd Inactive	"MAKE BACKGROUND IMAGE"	g-inactive
Grid_bkgd_button	Figure of Grid Bkgd Inactive	{52, 315}	Figure of Grid Bkgd Active	Figure of Grid Bkgd Inactive	"REMOVE BACKGROUND IMAGE"	g-inactive
Generate_source_button	Figure of Generate Source Inactive	{52, 145}	Figure of Generate Source Active	Figure of Generate Source Inactive	"GENERATE SOURCE CODE"	g-inactive
Preview_source_button	Figure of Preview Source Inactive	{52, 194}	Figure of Preview Source Active	Figure of Preview Source Inactive	"PREVIEW SOURCE CODE"	g-inactive
Rename_sprite_button	Figure of Rename Sprite Inactive	{52, 110}	Figure of Rename Sprite Active	Figure of Rename Sprite Inactive	"RENAME ELEMENT"	g-inactive
Change_kind_button	Figure of Change Kind Inactive	{221, 110}	Figure of Change Kind Active	Figure of Change Kind Inactive	"CHANGE KIND"	g-inactive
Change_ID_button	Figure of Change ID Inactive	{52, 160}	Figure of Change ID Active	Figure of Change ID Inactive	"REASSIGN SPRITE IDENTITY"	g-inactive
Register_button	Figure of Register Instance Inactive	{52, 388}	Figure of Register Instance Active	Figure of Register Instance Inactive	"REGISTER INSTANCE"	g-inactive
Load_button	Figure of Load Instance Inactive	{220, 388}	Figure of Load Instance Active	Figure of Load Instance Inactive	"LOAD INSTANCE"	g-inactive
Reveal_button	Figure of Reveal Instance Inactive	{52, 439}	Figure of Reveal Instance Active	Figure of Reveal Instance Inactive	"LIST INSTANCES"	g-inactive
Tag_button	Figure of Tag Inactive	{52, 274}	Figure of Tag Active	Figure of Tag Inactive	"TAG"	g-inactive
Tag_delete_button	Figure of Tag Delete Inactive	{221, 274}	Figure of Tag Delete Active	Figure of Tag Delete Inactive	"DELETE TAG"	g-inactive
Duplicate_button	Figure of Duplicate Inactive	{275, 461}	Figure of Duplicate Active	Figure of Duplicate Inactive	"DUPLICATE"	g-inactive


Chapter - Modal Buttons

A modal button is a kind of UI-element. The display status of a modal button is usually g-inactive. The display-layer of a modal button is 4.

Some modal buttons are defined by the Table of Modal-Buttons.

Table of Modal-Buttons
sprite	image-ID	origin	active-state	inactive-state	linked replacement-command
layer_reveal_modal	Figure of Eyeball Inactive	{0, 0}	Figure of Eyeball Active	Figure of Eyeball Inactive	"LAYERS"


Chapter - Checkboxes
[Check boxes could easily be modeled as modal buttons, but are broken out for clarity, and to ease any later code/image changes.]

A checkbox is a kind of UI-element. The display status of a checkbox is usually g-inactive. The display-layer of a checkbox is 4.

Some checkboxes are defined by the Table of Check Boxes.

Table of Check Boxes
sprite	image-ID	origin	active-state	inactive-state	linked replacement-command
Outline_bkgd_check	Figure of Outlined Background Active	{62, 395}	Figure of Outlined Background Active	Figure of Outlined Background Inactive	"OUTLINE"


Chapter - Radio Buttons

A radio button is a kind of UI-element. The display status of a radio button is usually g-inactive. The display-layer of a radio button is 4.

Some radio buttons are defined by the Table of Radio-Buttons.

Table of Radio-Buttons
sprite	image-ID	active-state	inactive-state	origin	linked replacement-command
Highlight_radio	Figure of Highlight Radio Image	Figure of Highlight Radio Image	Figure of Highlight Radio Stroke	{47, 463}	"TOGGLE HIGHLIGHT"
Hilite_color_radio	--	--	--	{344, 463}	"TOGGLE IMAGE HIGHLIGHT COLOR"
AsymScale_radio	Figure of Asymmetrical Radio Alternate	Figure of Asymmetrical Radio Standard	Figure of Asymmetrical Radio Alternate	{47, 385}	"TOGGLE SCALING"
Tabular_source_radio	Figure of Paragraphed Source	Figure of Tabular Source	Figure of Paragraphed Source	{61, 321}	"TOGGLE OUTPUT STYLE"


Chapter - Assigning UI elements to tabs and paging between them

The members of Move_tab are {Nudge-up_button, Nudge-right_button, Nudge-left_button, Nudge-down_button, Nudge_def_button, Align_left_button, Align_top_button, Align_right_button, Align_bottom_button, Center_button, Layer_move_button, Duplicate_button}.
The members of Select_tab are {Graphlink_add_button, Graphlink_delete_button, Highlight_radio, Hilite_color_radio, Select_all_button, Select_kind_button, Select_layer_button, Show_button, Hide_button, Show_all_button}.
The members of Scale_tab are {Scale_sym_button, Scale_horiz_button, Scale_vert_button, Scale_default_button, AsymScale_radio}.

To actuate (pressed - a sprite):
	repeat with current-element running through the members of the current tab:
		deactivate current-element;
	change the image-ID of the underlayment of the current tab to the inactive-state of the underlayment of the current tab;
	change the display-layer of the underlayment of the current tab to the inactivated background layer;
	change the display-layer of the current tab to the inactivated tab layer;
	change the display-layer of pressed to the activated tab layer;
	repeat with current-element running through the members of the current tab:
		activate current-element;
	let ID be the active-state of the underlayment of pressed;
	change the image-ID of the underlayment of the current tab to ID;
	change the display-layer of the underlayment of the current tab to the activated background layer.
	

Chapter - Pop-Ups

A pop-up dialogue is a kind of sprite. The display status is usually g-inactive. The graphlink status is g-inactive. The display-layer of a pop-up dialogue is 6. The associated canvas is the control-canvas.

A pop-up dialogue has a list of sprites called the member-elements.

Some pop-up dialogues are defined by the Table of Pop Ups.

Table of Pop Ups
sprite	image-ID	origin
Settings_popup	Figure of Settings Pop-Up	{36, 14}
Source_popup	Figure of Source Pop-Up	{36, 16}
Instances_popup	Figure of Instances Pop-Up	{36, 59}


Chapter - Pop-Up Buttons

[A pop-up button is a special type of button that "opens" a pop-up "window". They are defined separately from standard buttons for two reasons:

1) Pop-up buttons are not animated when they are depressed, unlike standard buttons;
2) Pop-up buttons do not insert a replacement command on behalf of the player. Instead, they are given special handling by the clicking graphlink rules; it is therefore useful to be able to refer to them by kind.]

A pop-up button is a kind of UI-element. The display status is usually g-active. The display-layer of a pop-up button is 4.

The pop-up layer is a number that varies. The pop-up layer is 7. [This is the layer on which buttons belonging to pop-up dialogues are drawn.]

A pop-up button has a pop-up dialogue called the associated dialogue.

Some pop-up buttons are defined by the Table of Pop Up Buttons.

Table of Pop Up Buttons
sprite	image-ID	origin	associated dialogue	linked replacement-command
Settings_popbutton	Figure of Settings Pop Button	{502, 21}	Settings_popup	""
Source_popbutton	Figure of Source Pop Button	{502, 64}	Source_popup	""
Instances_popbutton	Figure of Instances Pop Button	{502, 106}	Instances_popup	""


Section - The control window occluder

The control_occluder is a sprite. The graphlink status is g-active. The display status is g-inactive. The linked replacement-command is "". The image-ID is Figure of Occluder. The display-layer is 5. The associated canvas is the control-canvas.

An element display rule for the control_occluder:
	draw sprite control_occluder in control-window at coordinates 0 and 0 with dimensions width of control-window and height of control-window;
	set a graphlink in control-window identified as control_occluder from 0 by 0 to width of control-window by height of control-window as the linked replacement-command of control_occluder;
	

Section - Adding UI elements to and activating pop-up dialogues

The member-elements of Settings_popup are {List_colors_button, Image_bkgd_button, Grid_bkgd_button, Outline_bkgd_check}.
The member-elements of Source_popup are {Generate_source_button, Preview_source_button, Tabular_source_radio}.
The member-elements of Instances_popup are {Rename_sprite_button, Change_kind_button, Change_ID_button, Register_button, Load_button, Reveal_button, Tag_button, Tag_delete_button}.

To open the/-- (P - a pop-up dialogue):
	mark P for display;
	repeat with current-element running through the member-elements of P:
		mark current-element for display;
		now the display-layer of current-element is the pop-up layer;
	mark control_occluder for display;
	now the display-layer of the current graphlink is the pop-up layer;
	
To close the/-- (P - a pop-up dialogue):
	P is no longer marked for display;
	repeat with current-element running through the member-elements of P:
		current-element is no longer marked for display;
	control_occluder is no longer marked for display;
	now the display-layer of the current graphlink is the button-layer;
	
A clicking graphlink rule when the current graphlink window is the control-window:
	if the click hit a hot link:
		if the current graphlink is a pop-up button:
			if the associated dialogue of the current graphlink is display-inactive:
				open the associated dialogue of the current graphlink;
				follow the window-drawing rules for the control-window;
				now glulx replacement command is "";
				rule succeeds;
			otherwise:
				close the associated dialogue of the current graphlink;
				follow the window-drawing rules for the control-window;
				now glulx replacement command is "";
				rule succeeds;
		if the current graphlink is the control_occluder:
			now glulx replacement command is "";
			reject the player's command; [a hack that ensures that a line event is requested even if we've clicked on the occluder, which is designed to stop graphlinks beneath it from being clicked.]
			rule succeeds;
	now glulx replacement command is "";
	

Chapter - Button animation
[This is a customized version of the "default command replacement by graphlinks rule" from Graphic Hyperlinks for Flexible Windows extension. The only real difference is that it provides for an animation when buttons are pressed.]

The currently depressed button is a sprite that varies. The currently depressed button is info_button.

A clicking graphlink rule (this is the button-responsive command replacement by graphlinks rule):
	repeat through the Table of Graphlink Glulx Replacement Commands in reverse order:
		if the current graphlink window is g-win entry:
			if the current graphlink x >= p-left entry and the current graphlink x <= p-right entry and the current graphlink y >= p-top entry and the current graphlink y <= p-bottom entry:
				cancel input in main window;
				change the current graphlink to linkid entry;
				change the glulx replacement command to replacement entry;
				if the current graphlink is a button:
					now the currently depressed button is the current graphlink;
					now the image-ID of the currently depressed button is the active-state of the currently depressed button;
					follow the window-drawing rules for the assigned window of the currently depressed button;
					revert the button after 0.1500 seconds;
				rule succeeds;
	now glulx replacement command is "";
	rule fails.

The button-responsive command replacement by graphlinks rule is listed before the default command replacement by graphlinks rule in the clicking graphlink rules.

A glulx timed activity rule (this is the redraw button from timer rule):
	stop the timer;
	now the image-ID of the currently depressed button is the inactive-state of the currently depressed button;
	follow the window-drawing rules for the assigned window of the currently depressed button.
	
[The timer introduces a certain wild-card element into things. The upshot is that, when we undo, the events that happen after the timer fires are not "remembered"--so, the state of the button will still be active after we undo, and the timer event will not fire. The after undoing an action rule here requests the timer event immediately after undoing, so that the button will return to its initial state as needed. This has the added benefit of indicating to the player exactly what is being reconstructed after UNDO, the pressing of the button. This is rather primitive, in that the timer event is requested no matter the situation (i.e, regardless of whether the last turn involved a button press; however, things are structured so that this is harmless.]
	
After undoing an action:
	revert the button after 0.1500 seconds;
	
	
Chapter - Timer
	
To revert the/-- button/-- after (T - a real number) second/seconds:
	(- glk_request_timer_events({T}/10);  -)
	
To stop the/-- timer:
	(- glk_request_timer_events(0); -)


Chapter - Modal Restrictions

To decide whether we are in a strictly modal situation:
	if identity reassignment mode is true, decide yes;
	if center-overlay mode is true, decide yes;
	if alignment mode is true, decide yes;
	[if drawing mode is true, decide yes;]
	decide no;
	
After reading a command when we are in a strictly modal situation:
	unless the player's command matches "page [nudge-direction]":
	[allows the player to page the library in a modal situation, but any other action that generates a command will cancel the mode.]
		cancel the current strict mode[, verbosely];
						
A clicking graphlink rule when we are in a strictly modal situation and the current graphlink window is the working window (this is the strict modal mouse input rule):
	let the selected-element be entry 1 of the element-selection set;
	if center-overlay mode is true and the click hit a hot link:
		center the selected-element on the current graphlink;
		now glulx replacement command is "";
		now center-overlay mode is false;
		rule succeeds;
	if alignment mode is true and the click hit a hot link:
		let border-indicator be the border-name understood;
		align the selected-element to the current graphlink according to the border-name understood;
		now alignment mode is false;
		now glulx replacement command is "";
		rule succeeds;
	cancel the current strict mode;
	now glulx replacement command is "";
	rule fails;
			
A clicking graphlink rule when we are in a strictly modal situation and the current graphlink window is the library-window (this is the strict modal library input rule):
	if identity reassignment mode is true and the click hit a hot link:
		now glulx replacement command is "";
		let the selected-element be entry 1 of the element-selection set;
		change the image-ID of the selected-element to the image-ID of the current graphlink;
		follow the window-drawing rules for the working window;
		now identity reassignment mode is false;
		rule succeeds;
	cancel the current strict mode;
	now glulx replacement command is "";
	rule fails;
	
The strict modal library input rule is listed before the clicking in library rule in the clicking graphlink rules. The strict modal mouse input rule is listed before the strict modal library input rule in the clicking graphlink rules.
			
To cancel the current strict mode, verbosely:
	if identity reassignment mode is true:
		if verbosely, say "[bracket]Reassignment canceled.[close bracket]";
	if center-overlay mode is true:
		if verbosely, say "[bracket]Centering canceled.[close bracket]";
	if alignment mode is true:
		if verbosely, say "[bracket]Alignment canceled.[close bracket]";
	now center-overlay mode is false;
	now identity reassignment mode is false;
	now alignment mode is false;


Chapter - Paging Buttons

A paging-button is a kind of sprite. The display status is usually g-inactive. The graphlink status is g-active. The linked replacement-command is usually "". The associated canvas of a paging-button is the paging-canvas. 

Some paging-buttons are defined by the Table of Paging Button-Sprites.

Table of Paging Button-Sprites
sprite	image-ID	origin	linked replacement-command	display-layer
Page-right_button	Figure of Page Right	{4, 0}	""	1
Page-left_button	Figure of Page Left	{4, 0}	""	1


Part - New Sprite Creation from Library

A clicking graphlink rule when the current graphlink window is the paging-window (this is the clicking in pager rule):
	if the click hit a hot link:
		if the current graphlink is:
			-- Page-right_button: increase current-page by 1;
			-- Page-left_button: decrease current-page by 1;
		follow the window-drawing rules for the library-window;
		follow the window-drawing rules for the paging-window;
		rule succeeds.

A clicking graphlink rule when the current graphlink window is the library-window (this is the clicking in library rule):
	if the click hit a hot link:
		now glulx replacement command is "CREATE NEW SPRITE";
		rule succeeds;
	now glulx replacement command is "";
	
Spawning sprites is an action applying to nothing. Understand "spawn new sprite" or "create new sprite" or "create new" or "spawn new" as spawning sprites.

Check spawning sprites:
	if the command is mouse-generated:
		continue the action;
	otherwise:
		say "[bracket]That command is reserved for the editor.[close bracket][paragraph break]You may click on an image in the library window to create a new sprite from the library image.";
		rule fails;

Carry out spawning sprites:
	create a new sprite from the current graphlink in the working window;
	update the status line;
	rule succeeds;

To create a new sprite from (S - a sprite) in (win - a g-window):
	increase the instance-counter of S by 1;
	let the new sprite be a new object cloned from S;
	change the associated canvas of the new sprite to the associated canvas of win;
	unlink the element-name of the new sprite;
	replace the regular expression "_\d+$" in the element-name of the new sprite with "_[instance-counter of S]";
	replace the text " " in the element-name of the new sprite with "_";
	now the new sprite is standard;
	unlink the of-kind of the new sprite;
	unlink the tag of the new sprite;
	[now the of-kind of the new sprite is the kind-flag of S;***]
	unlink the replacement-command of the new sprite;
	change the x-scaling factor of the new sprite to the default scaling factor;
	change the y-scaling factor of the new sprite to the default scaling factor;
	change the display-layer of the new sprite to the current display-layer;
	unlink the origin of the new sprite;
	let xx be the canvas-width of the associated canvas of win;
	let yy be the canvas-height of the associated canvas of win;
	let x-img be the image-width of the image-ID of the new sprite real times the x-scaling factor of the new sprite as an integer;
	let y-img be the image-height of the image-ID of the new sprite real times the y-scaling factor of the new sprite as an integer;
	let x be (xx divided by 2) minus (x-img divided by 2);
	let y be (yy divided by 2) minus (y-img divided by 2);
	change entry 1 of the origin of the new sprite to x;
	change entry 2 of the origin of the new sprite to y; 
	say "New sprite [element-name of new sprite] created from [image-ID of S].";
	change element-selection set to {};
	add new sprite at entry 1 in the element-selection set;
	follow the window-drawing rules for win;
	[follow the window-drawing rules for the layers-window;]
	

Part - Drawing

The currently drawn element is a g-element variable.
The current element color is a glulx color value variable.
The current element background color is a glulx color value variable.
The current line-weight is a number variable. The current line-weight is 1.
Text-enjambment is a kind of value. The text-enjambments are left-jambed, centered, and right-jambed.
The current text alignment is a text-enjambment variable. The current text alignment is left-jambed.

Drawing mode is a truth state variable. Drawing mode is false.
First point is a list of numbers variable. First point is {-999, -999}.
Second point is a list of numbers variable. Second point is {-999, -999}.
	

Chapter - Suspending normal input during drawing

To suspend line input:
	now suspension flag is true;
	cancel line input in main window;
	suspend.
	
To return to normal input:
	now suspension flag is false.
	
To suspend:
	(- EscKeypress(); -)
	
Include (-

Global suspend_flag = 0;
Global manual_cancel = 0;

-) before "Glulx.i6t".


The suspension flag is a truth state variable. The suspension flag variable translates into I6 as "suspend_flag".

Include (-

[ EscKeypress key ix;
	while (suspend_flag) {
		glk_request_char_event(gg_mainwin);
		glk_select(gg_event); 
		ix = HandleGlkEvent(gg_event, 1, gg_arguments); 
		if (ix >= 0 && gg_event-->0 == 2) { 
			key = gg_event-->2;
			if (key == $fffffff8) {
				suspend_flag = 0;
				say__p=1;ParaContent();  print "[Element drawing canceled]"; ParaContent();  DivideParagraphPoint(); new_line;
				FollowRulebook( (+ cancelling drawing rules +) );
			}
		} 
	}
	glk_cancel_char_event(gg_mainwin);  
];

-)


Chapter - Control for element drawing
	
A clicking graphlink rule when drawing mode is true and the current graphlink window is the working window (this is the click to draw rule):
	now glulx replacement command is "";
	if first point is {-999, -999}:
		change first point to the canvas equivalent of the screen coordinates (current graphlink x) by (current graphlink y) of the current graphlink window;
		if the currently drawn element is a rendered string:
			follow the string creation rule;
			follow the window-drawing rules for the working window;
			rule succeeds;						
		otherwise:
			say "Now click in the editor window to set the [if the currently drawn element is a line primitive]end point[otherwise]opposite corner[end if].";
	otherwise:
		change second point to the canvas equivalent of the screen coordinates (current graphlink x) by (current graphlink y) of the current graphlink window;
		unless the currently drawn element is a line primitive:
			if entry 1 of second point < entry 1 of first point:
				let x1 be entry 1 of first point;
				change entry 1 of first point to entry 1 of second point;
				change entry 1 of second point to x1;	
			if entry 2 of second point < entry 2 of first point:
				let y1 be entry 2 of first point;
				change entry 2 of first point to entry 2 of second point;
				change entry 2 of second point to y1;
		follow the primitive creation rule;
	follow the window-drawing rules for the working window;
	rule succeeds.
	
The click to draw rule is listed before the clicking in pager rule in the clicking graphlink rules.

A clicking graphlink rule when drawing mode is true and the current graphlink window is not the working window (this is the cancel drawing mode rule):
	say "[bracket]Element drawing canceled.[close bracket][paragraph break]";
	follow the cancelling drawing rules;
	now glulx replacement command is "";
	rule succeeds.

To force-restart line input:
	(- glk_request_line_event(gg_mainwin, buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0); -)

The cancel drawing mode rule is listed before the click to draw rule in the clicking graphlink rules.

Cancelling drawing rules are a rulebook.

A cancelling drawing rule:
	now first point is {-999, -999};
	now second point is {-999, -999};
	return to normal input;
	now drawing mode is false;
	now glulx replacement command is "";
	repeat with item running through drawing tools:
		make inactive the item;
	refresh windows.	

Chapter - Spawning new element primitives
	
This is the primitive creation rule:
	create a new primitive from the currently drawn element in the working window;
	follow the cancelling drawing rules.

To create a new primitive from (X - a g-element) in (win - a g-window):
	increase the instance-counter of X by 1;
	let the new element be a new object cloned from X;
	now the new element is standard;
	change the display status of new element to g-active;
	unlink the element-name of the new element;
	change the element-name of the new element to "[kind-flag of the new element]" concatenated with the instance-counter of X;
	replace the text " " in the element-name of the new element with "_";
	replace the regular expression "\b(\w)(\w*)" in the element-name of the new element with "\u1\l2";
	[change the x-scaling factor of the new element to 1.0000;
	change the y-scaling factor of the new element to 1.0000;]
	unlink the of-kind of the new element;
	unlink the tag of the new element;
	unlink the replacement-command of the new element;
	[now the of-kind of the new element is the kind-flag of X;***]
	change the display-layer of the new element to the current display-layer;
	unlink the origin of the new element;
	unlink the endpoint of the new element;
	change the origin of the new element to first point;
	change the endpoint of the new element to second point;
	let x1 be entry 1 of the origin of the new element;
	let x2 be entry 1 of the endpoint of the new element;
	let y1 be entry 2 of the origin of the new element;
	let y2 be entry 2 of the endpoint of the new element;
	change the element-width of the new element to x2 - x1;
	change the element-height of the new element to y2 - y1;
	if the new element provides the property line-weight:
		change the line-weight of the new element to the current line-weight;
	change the tint of the new element to the current element color;
	if the new element provides the property background tint:
		change the background tint of the new element to current element background color;
	now the element-selection set is {};
	add the new element to the element-selection set;
	[follow the window-drawing rules for the layers-window;]
	say "New primitive element drawn: [element-name of new element].";


Chapter - Spawning new text elements

Rule for printing a parser error when the command parser error is the i beg your pardon error:
	if the impelling action is drawing a string:
		say "[current cancelation message][line break]";
		deactivate text question mode;
		follow the cancelling drawing rules;
		follow the window-drawing rules for the working window;
		now the impelling action is the action of waiting;[This resets the impelling action so that we don't remain in text question mode.]
		rule succeeds;
	continue the action.

This is the string creation rule:
	return to normal input;
	now current question is "Please specify the text you want this string to display. Individual strings can only occupy a single line; no line breaks.";
	now current prompt is "Enter a string: >";
	ask a closed question, in text mode.

A text question rule when drawing mode is true (this is the string element text input rule):
	replace the text "[quotation mark]" in the current answer with "_";
	[replace the regular expression "\pline break\p" in the current answer with "[left-bent-uni-arrow]";[***]]
	create a new rendered string from the currently drawn element in the working window using the current answer;
	follow the cancelling drawing rules;
	follow the window-drawing rules for the working window;
	exit;

To create a new rendered string from (X - a rendered string) in (win - a g-window) using (text input - indexed text):
	increase the instance-counter of X by 1;
	let the new element be a new object cloned from X;
	now the new element is standard;
	change the display status of new element to g-active;
	unlink the element-name of the new element;
	change the element-name of the new element to "[text input]" concatenated with the instance-counter of X;
	replace the regular expression "\p" in the element-name of the new element with "_";
	replace the text " " in the element-name of the new element with "_";
	replace the regular expression "\b(\w)(\w*)" in the element-name of the new element with "\u1\l2";
	change the x-scaling factor of the new element to the default scaling factor;
	change the y-scaling factor of the new element to the default scaling factor;
	unlink the of-kind of the new element;
	unlink the tag of the new element;
	unlink the replacement-command of the new element;
	[now the of-kind of the new element is the kind-flag of X;***]
	change the display-layer of the new element to the current display-layer;
	change the x-scaling factor of the new element to the default scaling factor;
	change the y-scaling factor of the new element to the default scaling factor;
	unlink the origin of the new element;
	change the origin of the new element to first point;
	unlink the text-string of the new element;
	change the text-string of the new element to text input;
	if the currently drawn element is a bitmap-rendered string:
		change the bit-size of the new element to the current line-weight;
	change the tint of the new element to the current element color;
	change the background tint of the new element to current element background color;
	if the current text alignment is:
		-- left-jambed: change the new element to left-aligned;
		-- centered: change the new element to center-aligned;
		-- right-jambed: change the new element to right-aligned;
	change element-selection set to {};
	add the new element at entry 1 in the element-selection set;
	[follow the window-drawing rules for the layers-window;]
	say "New rendered string element drawn: [element-name of new element].";
	

Part - The drawing window

A drawing UI is a kind of sprite. The associated canvas of a drawing UI is the drawing-canvas. The display status of a drawing UI is g-active. The display-layer of a drawing UI is 1.


Chapter - Standard buttons

Line_weight_button is a button. The associated canvas is the drawing-canvas. The origin is {389, 3}.The image-ID is Figure of Line Weight Inactive. The active-state is Figure of Line Weight Active. The inactive-state is Figure of Line Weight Inactive. The display status is g-active. The linked replacement-command is "LINE-WEIGHT". The display-layer is 1.

Chapter - Modal drawing buttons

A modal drawing button is a kind of modal button. The display status of a modal drawing button is usually g-active. The display-layer of a modal drawing button is 1. The associated canvas of a modal drawing button is the drawing-canvas.

Some modal drawing buttons are defined by the Table of Drawing Buttons.

Table of Drawing Buttons
sprite	image-ID	origin	active-state	inactive-state	linked replacement-command
draw_line_modal	Figure of Draw Line Inactive	{62, 1}	Figure of Draw Line Active	Figure of Draw Line Inactive	"DRAW LINE"
draw_rect_modal	Figure of Draw Rect Inactive	{85, 1}	Figure of Draw Rect Active	Figure of Draw Rect Inactive	"DRAW RECTANGLE"
draw_box_modal	Figure of Draw Box Inactive	{107, 1}	Figure of Draw Box Active	Figure of Draw Box Inactive	"DRAW BOX"
draw_stroked_modal	Figure of Draw Stroked Rect Inactive	{129, 1}	Figure of Draw Stroked Rect Active	Figure of Draw Stroked Rect Inactive	"DRAW STROKED RECTANGLE"
draw_bit_text_modal	Figure of Draw Bitmap Text Inactive	{151, 1}	Figure of Draw Bitmap Text Active	Figure of Draw Bitmap Text Inactive	"DRAW BITMAP STRING"
draw_img_text_modal	Figure of Draw Image Text Inactive	{173, 1}	Figure of Draw Image Text Active	Figure of Draw Image Text Inactive	"DRAW IMAGE STRING"
left_align_modal	Figure of Left Align Inactive	{213, 3}	Figure of Left Align Active	Figure of Left Align Inactive	"ALIGN STRING LEFT"
center_align_modal	Figure of Center Align Inactive	{230, 3}	Figure of Center Align Active	Figure of Center Align Inactive	"CENTER STRING"
right_align_modal	Figure of Right Align Inactive	{248, 3}	Figure of Right Align Active	Figure of Right Align Inactive	"ALIGN STRING RIGHT"

The drawing tools is a list of sprites that varies. The drawing tools are {draw_line_modal, draw_rect_modal, draw_box_modal, draw_stroked_modal, draw_bit_text_modal, draw_img_text_modal}.

To decide which g-element is the button of (G - a g-primitive):
	if G is line, decide on draw_line_modal;
	if G is rectangle, decide on draw_rect_modal;
	if G is box, decide on draw_box_modal;
	if G is stroked rectangle, decide on draw_stroked_modal;
	
To decide which g-element is the button of (G - a g-string):
	if G is bitmap string, decide on draw_bit_text_modal;
	if G is image string, decide on draw_img_text_modal;


Chapter - The window-closing button

The close drawing window button is a drawing UI. The graphlink status is g-active. The image-ID is Figure of Draw Window Close. The linked replacement-command is "CLOSE DRAWING TOOLS". The origin is {0, 6}.


Chapter - Text slugs

Colors slug is a drawing UI. The origin is {202, 3}. The image-ID is Figure of Draw Window Text.
Drawing slug is a drawing UI. The origin is {6, 4}. The image-ID is Figure of Draw Window Initial Slug.


Chapter - Opening the drawing window

Toggling the drawing window is an action applying to nothing. Understand "open drawing tools" or "close drawing tools" or "drawing tools" or "drawing window" or "open drawing window" or "close drawing window" as toggling the drawing window.

Carry out toggling the drawing window:
	if drawing-window is g-present:
		shut down the drawing-window;
		follow the window-drawing rules for the working window;
		say "Drawing tools closed.";
	otherwise:
		update drawing window buttons;
		open up the drawing-window;
		follow the window-drawing rules for the working window;
		say "Drawing tools opened.";

Understand "open drawing tools" or "open drawing window" as a mistake ("The drawing tools are already open.") when the drawing-window is g-present.
Understand "close drawing tools" or "close drawing window" as a mistake ("The drawing tools are already closed.") when the drawing-window is g-unpresent.
	
To update drawing window buttons:
	if drawing mode is false:
		repeat with item running through display-active modal drawing buttons:
			now the image-ID of item is the inactive-state of item;
	make inactive left_align_modal;
	make inactive center_align_modal;
	make inactive right_align_modal;
	if the current text alignment is:
		-- left-jambed: make active left_align_modal;
		-- centered: make active center_align_modal;
		-- right-jambed: make active right_align_modal;
	
To make active (M - a modal button):
	now the image-ID of M is the active-state of M.
	
To make inactive (M - a modal button):
	now the image-ID of M is the inactive-state of M.
	

Chapter - Command for drawing a primitive

Drawing a primitive is an action applying to one value. Understand "draw a [g-primitive]" or "draw [g-primitive]" as drawing a primitive.

Carry out drawing a primitive:
	now the element-selection set is {};
	follow the window-drawing rules for the working window;
	say "Click in the editor window to set [if the g-primitive understood is line]one end[otherwise]one corner[end if] of the [g-primitive understood].";
	now drawing mode is true;
	make active the button of the g-primitive understood;
	follow the window-drawing rules for the drawing-window;
	follow the window-drawing rules for the help-window;
	change the currently drawn element to the progenitor of the g-primitive understood;
	suspend line input.
	

Chapter - Command for drawing a text string

Drawing a string is an action applying to one value. Understand "draw a [g-string]" or "draw [g-string]" or "paint [g-string]" or "paint a [g-string]" or "text-paint [a g-string]" or "text-paint a [g-string]" as drawing a string.

Carry out drawing a string:
	now the element-selection set is {};
	follow the window-drawing rules for the working window;
	say "Click in the editor window to set the location of the [g-string understood].";
	now drawing mode is true;
	make active the button of the g-string understood;
	follow the window-drawing rules for the drawing-window;
	follow the window-drawing rules for the help-window;
	change the currently drawn element to the progenitor of the g-string understood;
	suspend line input.
	

Chapter - Left-aligning a string

Left-aligning a string is an action applying to nothing. Understand "align string left" or "align text right" as left-aligning a string.

Carry out left-aligning a string:
	now the current text alignment is left-jambed;
	if the number of entries of the element-selection set > 0:
		let count be 0;
		repeat with item running through the element-selection set:
			if item is a rendered string:
				increase count by 1;
				now the item is left-aligned;
		if count is 0:
			say "New text strings will be left-aligned. [bracket]Selected items are not text strings and were not affected.[close bracket][line break]";
		otherwise:
			say "Text alignment changed[if count > 1] for [count] items[end if].";
	otherwise:
		say "New text strings will be left-aligned.";
	update drawing window buttons;
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the drawing-window.


Chapter - Right-aligning a string

Right-aligning a string is an action applying to nothing. Understand "align string right" or "align text right" as right-aligning a string.

Carry out right-aligning a string:
	now the current text alignment is right-jambed;
	if the number of entries of the element-selection set > 0:
		let count be 0;
		repeat with item running through the element-selection set:
			if item is a rendered string:
				increase count by 1;
				now the item is right-aligned;
		if count is 0:
			say "New text strings will be right-aligned. [bracket]Selected items are not text strings and were not affected.[close bracket][line break]";
			rule fails;
		otherwise:
			say "Text alignment changed[if count > 1] for [count] items[end if].";
	otherwise:
		say "New text strings will be right-aligned.";
	update drawing window buttons;
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the drawing-window.
	

Chapter - Center-aligning a string

Center-aligning a string is an action applying to nothing. Understand "center string" or "center text" or "center-alignment" as center-aligning a string.

Carry out center-aligning a string:
	now the current text alignment is centered;
	if the number of entries of the element-selection set > 0:
		let count be 0;
		repeat with item running through the element-selection set:
			if item is a rendered string:
				increase count by 1;
				now the item is center-aligned;
		if count is 0:
			say "New text strings will be centered. [bracket]Selected items are not text strings and were not affected.[close bracket][line break]";
			rule fails;
		otherwise:
			say "Text alignment changed[if count > 1] for [count] items[end if][if count < the number of entries of the element-selection set]. Some elements are not strings and were not affected[end if].";
	otherwise:
		say "New text strings will be centered.";
	update drawing window buttons;
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the drawing-window.


Chapter - Changing the line-weight

Changing the line-weight is an action applying to one number. Understand "line-weight [a number]" or "line weight [a number]" or "bit-size [a number]" or "bit size [a number]" as changing the line-weight.

Check changing the line-weight:
	if the number understood < 1:
		say "The line-weight must be greater than 0.";

Carry out changing the line-weight (this is the line-weight changing rule):
	change the current line-weight to the number understood;
	if the number of entries of the element-selection set > 0:
		let count be 0;
		repeat with item running through the element-selection set:
			unless item is a sprite:
				increase count by 1;
				if the item is a primitive:
					change the line-weight of the item to the current line-weight;
				if the item is a rendered string:
					change the bit-size of the item to the current line-weight;
			if count is 0:
				say "Newly drawn elements will be created with a line-weight or bit-size of [the current line-weight]. [bracket]Selected items are not drawn elements and were not affected.[close bracket][line break]";
			otherwise:
				say "Line-weight changed[if count > 1] for [count] items[end if][if count < the number of entries of the element-selection set]. Some elements are not drawn elements and were not affected[end if].";
	otherwise:
		say "Newly drawn elements will be created with a line-weight or bit-size of [the current line-weight].";
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the drawing-window.


Chapter - Interactively changing the line-weight

Interactively changing the line-weight is an action applying to nothing. Understand "line-weight" or "line weight" or "bit-size" or "bit size" or "dot-size" or "dot size" as interactively changing the line-weight.

Carry out interactively changing the line-weight:
	now current question is "Enter the desired weight of the line or text bit-size, in pixels.";
	now current prompt is "Enter a number: >";
	now current cancelation message is "[bracket]Line-weight canceled.[close bracket]";
	ask an open question, in number mode.
	
A number question rule when the impelling action is interactively changing the line-weight:
	if the number understood is less than 1:
		say "The line-weight must be greater than 0.";
		retry;
	abide by the line-weight changing rule;
	exit.
	

Chapter - The color-picker

The drawing colors is a list of glulx color values that varies.

A color-chip is a kind of rectangle primitive. The associated canvas of a color-chip is the drawing-canvas. The display-layer of a color-chip is 4.  The graphlink status of a color-chip is g-active. The origin of a color-chip is {0, 5}. The endpoint of a color-chip is {0, 20}. The tint of a color-chip is g-black. The linked replacement-command of a color-chip is "". The display status of a color-chip is g-inactive.

The null color-chip is a color-chip. The tint is g-placenullcol. 

The mother color-chip is a color-chip. 

An element display rule for the null color-chip:
	let x be entry 1 of the origin of the null color-chip;
	let y be entry 2 of the origin of the null color-chip;
	display Figure of Null Color-Chip in drawing-window at x by y;
	set a graphlink in drawing-window identified as null color-chip from x by y to (x + 15) by (y + 15)  as the linked replacement-command of null color-chip.
	[let xx be entry 1 of the endpoint of the null color-chip;
	let yy be entry 2 of the endpoint of the null color-chip;
	draw a rectangle (color g-white) in drawing-window from x by y to xx by yy with 2 px line-weight (color g-red);
	draw a line (color g-red) in drawing-window from (x + 1) by (yy - 2) to (xx - 1) by y with 2 px line-weight;
	set a graphlink in drawing-window identified as null color-chip from x by y to xx by yy as the linked replacement-command of null color-chip;]

When play begins:
	if the number of entries of the drawing colors is 0:
		change the drawing colors to {g-black, g-white, g-red, g-blue, g-yellow};
	repeat with item running through the drawing colors:
		let the new element be a new object cloned from the mother color-chip;
		change the tint of the new element to item;
		unlink the origin of the new element;
		unlink the endpoint of the new element.
		

Section - The foreground and background indicators

A color indicator is a kind of stroked rectangle primitive. The associated canvas of a color indicator is the drawing-canvas. The line-weight of a color indicator is 1. The display-layer of a color indicator is 1. The background tint of a color indicator is g-black.

The foreground_color_indicator is a color indicator. The origin is {310, 4}. The endpoint is {326, 20}. 

The background_color_indicator is a color indicator. The origin is {354, 4}. The endpoint is {370, 20}.
		

Section - The drawing-window occluder
		
The drawing_occluder is a sprite. The graphlink status is g-active. The display status is g-inactive. The linked replacement-command is "". The image-ID is Figure of Occluder. The display-layer is 2. The associated canvas is the drawing-canvas.

An element display rule for the drawing_occluder:
	display image Figure of Occluder in drawing-window at 0 by 0 with dimensions (width of drawing-window) by (height of drawing-window);
	set a graphlink in drawing-window identified as drawing_occluder from 0 by 0 to width of drawing-window by height of drawing-window as the linked replacement-command of drawing_occluder;
	exit.
	
Section - Display and set-up for the color-picker
[The color_picker element display rule does double duty. It's display task is to draw the "tray" in which the color chips sit. This is constructed of three images, the middle of which needs to be stretched to fit the number of color chips. So, we figure out here where *both* the color-picker and the chips will be placed, changing the origin and endpoint of each chip based on the width of the window.]

The color_picker is a g-element. The associated canvas is the drawing-canvas. The origin is {0, 0}. The display status is g-inactive. The display-layer is 3.

An element display rule for the color_picker:
	let x be the width of drawing-window / 2;
	let left-tiles be the number of entries of drawing colors divided by 2;
	let scan be x  - (20 * left-tiles);
	let picker-width be 20 * (the number of entries of drawing colors + 1);
	display Figure of Color-Picker Left in drawing-window at (scan - 5) by 2 with dimensions 5 by 21;
	display Figure of Color-Picker Center in drawing-window at (scan) by 2 with dimensions (picker-width) by 21;
	repeat with chip running through color-chips:
		if chip is the mother color-chip:
			next;
		change entry 1 of the origin of chip to (scan + 2);
		change entry 1 of the endpoint of chip to (scan + 18);
		increase scan by 20;
	display Figure of Color-Picker Right in drawing-window at (scan) by 2;
	exit.


Section - Bringing up the color-picker

Color-picker mode is a truth state variable. Color-picker mode is false.

The current color-picking mode is text that varies. The current color-picking mode is "".

To activate color-picker mode:
	now color-picker mode is true;
	change the display status of the color_picker to g-active;
	change the display status of the drawing_occluder to g-active;
	repeat with chip running through color-chips:
		if chip is the mother color-chip:
			next;
		now the display status of chip is g-active;
	
To deactivate color-picker mode:
	now color-picker mode is false;
	change the display status of the color_picker to g-inactive;
	change the display status of the drawing_occluder to g-inactive;
	repeat with chip running through color-chips:
		if chip is the mother color-chip:
			next;
		now the display status of chip is g-inactive;
	
A clicking graphlink rule when the current graphlink window is the drawing-window and color-picker mode is false (this is the no replacement drawing window rule):
	if the current graphlink y >= 4 and the current graphlink y <= 20:
		if the current graphlink x >= 310 and the current graphlink x <= 326:
			follow the foreground color rule;
			now glulx replacement command is "";
			rule succeeds;
		if the current graphlink x >= 354 and the current graphlink x <= 370:
			follow the background color rule;
			now glulx replacement command is "";
			rule succeeds.

This is the foreground color rule:
	activate color-picker mode;
	Change the current color-picking mode to "FOREGROUND COLOR";
	follow the window-drawing rules for the drawing-window;
		
This is the background color rule:
	activate color-picker mode;
	Change the current color-picking mode to "BACKGROUND COLOR";
	follow the window-drawing rules for the drawing-window;
	

Chapter - Selecting the color

A clicking graphlink rule when the current graphlink window is the drawing-window and color-picker mode is true (this is the color-picker clicking rule):
	repeat through the Table of Graphlink Glulx Replacement Commands in reverse order:
		if the current graphlink window is g-win entry:
			if the current graphlink x >= p-left entry and the current graphlink x <= p-right entry and the current graphlink y >= p-top entry and the current graphlink y <= p-bottom entry:
				change the current graphlink to linkid entry;
				if the current graphlink is a color-chip:
					cancel input in main window;
					[The multiple-stage indexed text manipulation here is needed because a limitation in Inform does not allow us to simply say "change the glulx replacement command to "[current color-picking mode] [tint of the current graphlink in upper case]"]
					let T be indexed text;
					let T be "[tint of the current graphlink]";
					let T be T in upper case;
					change the glulx replacement command to "[current color-picking mode] [T]";
				deactivate color-picker mode;
				follow the window-drawing rules for the drawing-window;
				rule succeeds;

	
Chapter - Command for changing the foreground color

Changing the foreground color is an action applying to one value. Understand "change foreground color to [glulx color value]" or "foreground color [glulx color value]" or "color [glulx color value]" or "element color [glulx color value]" as changing the foreground color.

Carry out changing the foreground color:
	change the current element color to the glulx color value understood;
	if the number of entries of the element-selection set > 0:
		let count be 0;
		repeat with item running through the element-selection set:
			if item is not a sprite:
				increase count by 1;
				change the tint of the item to the current element color;
		if count is 0:
			say "Foreground color for drawing elements changed to [the current element color]. [bracket]Selected items are not drawing elements and were not affected.[close bracket][line break]";
		otherwise:
			say "Foreground color for drawing elements changed to [the current element color][if count > 1] for [count] items[end if].";
	otherwise:
		say "Foreground color changed to [the current element color].";
	if the glulx color value understood is g-placenullcol:
		say "Please note that the color value g-placenullcol indicates no color; in most situations, this will default to black.";
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the drawing-window.



Chapter - Command for changing the background color

Changing the background color is an action applying to one value. Understand "change background color to [glulx color value]" or "background color [glulx color value]" or "element background color [glulx color value]" as changing the background color.

Carry out changing the background color:
	change the current element background color to the glulx color value understood;
	if the number of entries of the element-selection set > 0:
		let count be 0;
		repeat with item running through the element-selection set:
			if item is a stroked rectangle primitive or item is a rendered string:
				increase count by 1;
				change the background tint of the item to the current element background color;
		if count is 0:
			say "Background color for drawing elements changed to [the current element background color]. [bracket]Selected items are not stroked rectangles or strings and were not affected.[close bracket][line break]";
		otherwise:
			say "Background color changed to [the current element background color][if count > 1] for [count] items[end if].";
	otherwise:
		say "Background color for drawing elements changed to [the current element background color].";
	if the glulx color value understood is g-placenullcol:
		say "Please note that the color value g-placenullcol indicates no color. In the case of stroked rectangles, this will cause the stroke color to default to black.";
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the drawing-window.
	
	

Part - Selection

The element-selection set is a list of g-elements that varies. The element-selection set is {}.

This is the single element selection rule:
	if element-selection set is empty:
		say "Please select an element and try again.";
		rule fails;
	if the number of entries of the element-selection set is greater than 1:
		say "Please select just one element and try again.";
		rule fails;
		
This is the select at least one element rule:
	if the element-selection set is empty:
		say "Please select at least one element and try again.";
		rule fails;
		

Chapter - Select Button

Select-tab clicking is an action applying to nothing. Understand "mode select" or "selection mode" or "select mode" or "s" as select-tab clicking.

Carry out select-tab clicking:
	actuate select_tab;
	say "The editor is now in SELECT mode. Click on a sprite to select it; click on it again to deselect. You may click on the background to deselect all sprites.";
	now glulx replacement command is "";
	[follow the window-drawing rules for the control-window.]
	

Chapter  - Selecting Elements

A clicking graphlink rule when the current graphlink window is the working window (this is the element-selection rule):
	if the current tab is select_tab:
		unless the click hit a hot link:
			change the glulx replacement command to "DESELECT ALL";
			rule succeeds;
		otherwise:
			if the current graphlink is listed in the element-selection set:
				remove current graphlink from the element-selection set;
			otherwise:
				add current graphlink at entry 1 in the element-selection set;
			now glulx replacement command is "";
			follow the window-drawing rules for the current graphlink window;
			follow the window-drawing rules for the layers-window;
			update the status line;
			rule succeeds;
	now glulx replacement command is "".
	

Section - Multiple-selection commands

Selecting all is an action applying to nothing. Understand "select all" or "all" or "a" as selecting all. [Selects all visible elements in the editor window.]

Carry out selecting all:
	now element-selection set is {};
	let selection-tally be 0;
	repeat with current-element running through the list of display-active in-play g-elements:
		if the current-element is assigned to the working window:
			add current-element to the element-selection set;
			increase selection-tally by 1;
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the layers-window;]
	if selection-tally is greater than 0:
		say "[selection-tally] element(s) selected.";
	otherwise:
		say "No sprites available to be selected.";
	
Deselecting all is an action applying to nothing. Understand "deselect all" or "deselect" or "none" or "d" as deselecting all. [Deselects all visible sprites in the editor-window.]

Carry out deselecting all:
	now element-selection set is {};
	say "Elements deselected.";
	update the status line;
	follow the window-drawing rules for the working window.
	[follow the window-drawing rules for the layers-window.]
	
Selecting by kind is an action applying to nothing. Understand "select same kind" or "same kind" or "select kind" as selecting by kind.

Check selecting by kind:
	abide by the single element selection rule.
	
Carry out selecting by kind:
	let the selected-element be entry 1 of the element-selection set;
	change the element-selection set to {};
	let count be 0;
	let the search-kind be indexed text;
	let the target-kind be indexed text;
	unless the of-kind of selected-element is "":
		let the search-kind be the of-kind of the selected-element;
	otherwise:
		let the search-kind be the kind-flag of the selected-element;
	repeat with current-element running through display-active in-play g-elements:
		if the current-element is assigned to the working window:
			unless the of-kind of selected-element is "":
				let the target-kind be the of-kind of the current-element;
			otherwise:
				let the target-kind be the kind-flag of the current-element;
			if the search-kind is the target-kind:
				add the current-element to the element-selection set;
				increase count by 1;
	if count is 0:
		say "No other elements of kind [italic type][search-kind][roman type] were found.";
		add the selected-element to the element-selection set;
	otherwise:
		say "[count] element(s) of kind [italic type][search-kind][roman type] selected.";
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the layers-window].

Selecting by layer is an action applying to nothing. Understand "select same layer" or "same layer" or "select layer" as selecting by layer.

Check selecting by layer:
	abide by the single element selection rule.
	
Carry out selecting by layer:
	let the selected-element be entry 1 of the element-selection set;
	change the element-selection set to {};
	let count be 0;
	repeat with current-element running through display-active in-play g-elements:
		if the current-element is assigned to the working window:
			if the display-layer of the current-element is the display-layer of the selected-element:
				add the current-element to the element-selection set;
				increase count by 1;
	if count is 0:
		say "No other elements were found on layer [display-layer of the selected-element].";
		add the selected-element to the element-selection set;
	otherwise:
		say "[count] element(s) were selected on layer [display-layer of the selected-element].";
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the layers-window].
	
	

Part - Moving sprites


Chapter - The Move button

Move-tab clicking is an action applying to nothing. Understand "mode move" or "movement mode" or "move mode" or "m" as move-tab clicking.

Carry out move-tab clicking:
	actuate the move_tab;
	say "The editor is now in MOVE mode. Click in the main editor window to move the origin of an element (generally its upper left corner) to that point. You may select multiple elements to move them as a unit. Elements can also be moved by using the nudge controls, or by typing MOVE HORIZONTALLY <DISTANCE IN PIXELS> or MOVE VERTICALLY <DISTANCE IN PIXELS> (negative numbers move left or up, positive down or right)[if element-selection set is empty].[paragraph break]You may use the image library or drawing controls to create an element now, or click on an existing element now to move it[otherwise if the number of entries of element-selection set is greater than 1]. [end if].";
	now glulx replacement command is "";
	[consider the window-drawing rules for the control-window.]
	

Chapter - Element moving commands

A clicking graphlink rule when the current graphlink window is the working window (this is the sprite-movement rule):
	unless current tab is move_tab:
		continue the action;[i.e., look at other clicking graphlink rules]
	if the element-selection set is empty:
		if the click hit a hot link:
			add current graphlink at entry 1 in the element-selection set;
			now glulx replacement command is "";
			consider the window-drawing rules for the working window;
			consider the window-drawing rules for the layers-window;
			update the status line;
			rule succeeds;
		otherwise:
			[actuate the select_tab;
			consider the window-drawing rules for the control-window;]
			follow the element-selection rule;
			rule succeeds;
	change the glulx replacement command to "MOVE ELEMENT";
	cancel input in main window;
	rule succeeds;
	
Element-moving is an action applying to nothing. Understand "move element" or "move sprite" or "move g-element" or "move primitive" or "move string" or "move text" or "move rendered string" as element-moving.

Check element-moving:
	unless the command is mouse-generated:
		say "[bracket]That command can only be generated by the editor; it cannot be typed. Try MOVE HORIZONTALLY <distance> or MOVE VERTICALLY <distance>.[close bracket][paragraph break]";
		rule fails;
	if the element-selection set is empty:
		rule fails.

Carry out element-moving:
	let min-x be entry 1 of the origin of entry 1 of the element-selection set;
	let min-y be entry 2 of the origin of entry 1 of the element-selection set;
	let the clicked coordinates be the canvas equivalent of the screen coordinates (current graphlink x) by (current graphlink y) of the current graphlink window;
	repeat with candidate running through the element-selection set:
		if entry 1 of the origin of the candidate < min-x:
			let min-x be entry 1 of the origin of candidate;
		if entry 2 of the origin of the candidate < min-y:
			let min-y be entry 2 of the origin of candidate;
	let delta-x be entry 1 of the clicked coordinates minus min-x;
	let delta-y be entry 2 of the clicked coordinates minus min-y;
	repeat with current-element running through the element-selection set:
		change entry 1 of the origin of the current-element to (entry 1 of the origin of the current-element + delta-x);
		change entry 2 of the origin of the current-element to (entry 2 of the origin of the current-element + delta-y);
		if the current-element is a primitive:
			let x1 be entry 1 of the origin of the current-element;
			let y1 be entry 2 of the origin of the current-element;
			change entry 1 of the endpoint of the current-element to x1 plus (the element-width of the current-element);
			change entry 2 of the endpoint of the current-element to y1 plus (the element-height of the current-element);
		say "Element [element-name of current-element] moved to [origin of the current-element in brace notation].";
	consider the window-drawing rules for the working window;
	update the status line;
	
Moving manually is an action applying to one thing and one value. Understand "move sprite [any legerdemained thing] [a number]" or "move [any legerdemained thing] [a number]" or "[any legerdemained thing] [a number]" as moving manually.

Check moving manually:
	abide by the select at least one element rule.
		
Carry out moving manually (this is the numeric movement rule):
	repeat with current-element running through the element-selection set:
		let the movement-offset be a list of numbers;
		let the movement-offset be {0, 0};
		if the noun is:
			-- horizontally: change entry 1 of the movement-offset to the number understood;
			-- vertically: change entry 2 of the movement-offset to the number understood;
		change the origin of current-element to the origin of current-element offset by the movement-offset;
		[change the origin of current-element to the origin of current-element verified against the background of the working window;]
		if the current-element is a primitive:
			let x1 be entry 1 of the origin of the current-element;
			let y1 be entry 2 of the origin of the current-element;
			change entry 1 of the endpoint of the current-element to x1 plus (the element-width of the current-element);
			change entry 2 of the endpoint of the current-element to y1 plus (the element-height of the current-element);
		say "Element [element-name of current-element] moved to [origin of the current-element in brace notation].";
	consider the window-drawing rules for the working window;
	rule succeeds;
	
Moving interactively is an action applying to one thing. Understand "move sprite [any legerdemained thing]" or "move [any legerdemained thing]" or "[any legerdemained thing]" as moving interactively.

The current movement direction is a thing that varies. 

Check moving interactively:
	abide by the select at least one element rule.
	
Carry out moving interactively:
	now the current movement direction is the noun;
	now the current question is "Indicate the distance in pixels to move the sprite(s). Positive numbers indicate [if noun is horizontally] movement to the right, negative to the left[otherwise] movement downward, negative movement upward[end if].";
	now current prompt is "Enter a number: >";
	now current cancelation message is "[bracket]Movement canceled.[close bracket]";
	ask an open question, in number mode;
	
A number question rule when the impelling action is moving interactively:
	now the noun is current movement direction;
	follow the numeric movement rule;
	

Chapter - Nudging Sprites

Sprite-nudging is an action applying to one value. Understand "nudge [nudge-direction]" as sprite-nudging.

Understand "nudge" as a mistake ("Please provide a direction (upward, rightward, downward, or leftward), e.g. NUDGE RIGHTWARD.").

The nudge factor is a number that varies. The nudge factor is usually 1.
The maximum nudge is a number that varies. The maximum nudge is usually 500.

Check sprite-nudging:
	abide by the select at least one element rule.

Carry out sprite-nudging:
	repeat with current-element running through the element-selection set:
		let the nudge-coordinates be a list of numbers;
		let the nudge-coordinates be {0, 0};
		if the nudge-direction understood is:
			-- upward: change entry 2 of the nudge-coordinates to -1 * the nudge factor;
			-- leftward: change entry 1 of the nudge-coordinates to -1 * the nudge factor;
			-- rightward: change entry 1 of the nudge-coordinates to the nudge factor;
			-- downward: change entry 2 of the nudge-coordinates to the nudge factor;
		change the origin of current-element to the origin of current-element offset by the nudge-coordinates;
		if the current-element is a primitive:
			let x1 be entry 1 of the origin of the current-element;
			let y1 be entry 2 of the origin of the current-element;
			change entry 1 of the endpoint of the current-element to x1 plus (the element-width of the current-element);
			change entry 2 of the endpoint of the current-element to y1 plus (the element-height of the current-element);
		say "Sprite [element-name of current-element] moved to [origin of the current-element in brace notation].";
	consider the window-drawing rules for the working window;
	rule succeeds;
	
Changing the nudge-factor is an action applying to one number. Understand "nudge [a number]" or "change nudge to [a number]" or "change nudge amount to [a number]" or "nudge amount [a number]" as changing the nudge-factor.

Check changing the nudge-factor (this is the nudge-factor checking rule):
	if the number understood is less than 1 or the number understood is greater than the maximum nudge:
		say "The nudge amount must be a number between 1 and [the maximum nudge].";
		rule fails;
		
Carry out changing the nudge-factor (this is the nudge-factor changing rule):
	change the nudge factor to the number understood;
	say "Nudge amount changed to [the nudge factor].";
	

Interactively changing the nudge-factor is an action applying to nothing. Understand "change nudge amount" as interactively changing the nudge-factor.

Carry out interactively changing the nudge-factor:
	now current question is "Enter the number of pixels that sprites will be moved by each press of the nudge keys.";
	now current prompt is "Enter a number: >";
	now current cancelation message is "[bracket]Nudge customization canceled.[close bracket]";
	ask an open question, in number mode.
	
A number question rule when the impelling action is interactively changing the nudge-factor:
	consider the nudge-factor checking rule;
	if the rule failed:
		retry;
	abide by the nudge-factor changing rule;
	exit.


Part - "Deleting" elements
["Deleting" in quotes here because the element objects aren't really deleted; instead, they are simply marked as display-inactive.]

Deleting elements is an action applying to nothing. Understand "delete" or "del" or "delete element" or "delete elements" as deleting elements.

Check deleting elements:
	if the element-selection set is empty:
		say "Please select one or more elements to delete.";
		rule fails;
		
Carry out deleting elements:
	repeat with current-element running through the element-selection set:
		fake-delete the current-element, iteratively;
		say "Element [element-name of current-element] deleted.";
	now the element-selection set is {};
	update the status line;
	refresh windows.
	
To fake-delete (S - a g-element), iteratively:
[The iteratively phrase option is intended for use when we are looping through the element-selection set. If that is the case, we don't delete the element from the list, because this will cause problems with the looping.]
	unless iteratively:
		remove S from the element-selection set, if present;
	change S to deleted;
	deactivate S.
	

Part - Hiding and showing elements

Chapter - Hiding elements

Hiding elements is an action applying to nothing. Understand "hide" or "hide sprite/sprites" or "mark sprite/sprites as display-inactive" or "mark sprite/sprites as inactive" or "deactivate" or "deactive sprite/sprites" as hiding elements.

Check hiding elements:
	if the element-selection set is empty:
		say "Please select one or more elements to delete.";
		rule fails;
		
Carry out hiding elements:
	let L be a list of indexed text;
	repeat with current-element running through the element-selection set:
		deactivate current-element;
		add the element-name of the current-element to L;
	say "The [if the number of entries of the element-selection set is greater than 1]elements[otherwise]element[end if] [L] [if the number of entries of the element-selection set is greater than 1]have been[otherwise]has been[end if] marked as display-inactive, and will appear as such in output source code. To remove sprites entirely from the composition, use the DELETE command.";
	now the element-selection set is {};
	update the status line;
	follow the window-drawing rules for the working window.
	

Chapter - Showing elements

The element-disambiguation list is a list of g-elements that varies.

Showing elements is an action applying to nothing. Understand "show" or "show sprite/sprites" or "mark sprite/sprites as display-active" or "mark sprite/sprites as active" or "activate" or "activate sprite/sprites" as showing elements.

Carry out showing elements:
	now the element-disambiguation list is {};
	repeat with current-element running through in-play g-elements:
		if current-element is assigned to the working window:
			if current-element is display-inactive and current-element is not deleted:
				add current-element to the element-disambiguation list;
	if the number of entries of the element-disambiguation list is less than 1:
		say "All elements are currently displayed.";
		rule fails;
	otherwise:
		say "The following elements are currently marked as display-inactive:[paragraph break]";
		let count be 0;
		repeat with current-element running through the element-disambiguation list:
			increase count by 1;
			say "[bracket][count][close bracket] [element-name of current-element] (layer [display-layer of current-element])[line break]";
		say "[line break]";
		now the current question is "Select the number of the element you wish to mark as display-active.";
		now the current prompt is "Enter a number from the list: >";
		now the current cancelation message is "[bracket]Changing element status canceled.[close bracket]";
		ask an open question, in number mode.
	
A number question rule (this is the select disambiguated sprite rule):
	if the current question is "Select the number of the element you wish to mark as display-active.":
		if the number understood is less than 1 or the number understood is greater than the number of entries of the element-disambiguation list:
			say "Please choose a number from the list.";
			retry;
		let the selected-entry be the number understood;
		let the selected-element be entry (selected-entry) of the element-disambiguation list;
		say "The element [element-name of selected-element] has been marked as display-active.";
		activate the selected-element;
		update the status line;
		follow the window-drawing rules for the working window;
		exit;
	
Showing all elements is an action applying to nothing. Understand "show all" or "show all element/elements" or "mark all element/elements as display-active" or "mark all element/elements as active" or "activate all" or "activate all element/elements" as showing all elements.

Carry out showing all elements:
	repeat with current-element running through in-play g-elements assigned to the working window:
		if current-element is assigned to the working window:
			if current-element is display-inactive and current-element is not deleted:
				activate current-element;
	update the status line;
	follow the window-drawing rules for the working window;
	say "All elements are now displayed.";


Part - Duplicating elements

Duplicating an element is an action applying to nothing. Understand "copy" or "duplicate" or "c" as duplicating an element.

Check duplicating an element:
	abide by the select just one element rule.

Carry out duplicating an element:
	let current-element be entry 1 of the element-selection set;
	if current-element is a primitive:
		create a duplicate primitive from current-element in the working window;
	otherwise if current-element is a rendered string:
		create a duplicate rendered string from current-element in the working window;
	otherwise:
		create a duplicate sprite from current-element in the working window;
	change the display-layer of entry 1 of the element-selection set to current display-layer;
	update the status line;
	follow the window-drawing rules for the working window;
	rule succeeds.	


To create a duplicate primitive from (X - a g-element) in (win - a g-window):
	increase the instance-counter of X by 1;
	let the new element be a new object cloned from X;
	now the new element is standard;
	change the display status of new element to g-active;
	unlink the element-name of the new element;
	change the element-name of the new element to "[element-name of X]_copy";
	replace the regular expression "\b(\w)(\w*)" in the element-name of the new element with "\u1\l2";
	unlink the of-kind of the new element;
	unlink the tag of the new element;
	unlink the replacement-command of the new element;
	unlink the origin of the new element;
	unlink the endpoint of the new element;
	now the element-selection set is {};
	add the new element to the element-selection set;
	say "Element primitive copied as: [element-name of new element].";


To create a duplicate rendered string from (X - a rendered string) in (win - a g-window):
	increase the instance-counter of X by 1;
	let the new element be a new object cloned from X;
	now the new element is standard;
	change the display status of new element to g-active;
	unlink the element-name of the new element;
	change the element-name of the new element to "[element-name of X]_copy";
	replace the regular expression "\b(\w)(\w*)" in the element-name of the new element with "\u1\l2";
	unlink the of-kind of the new element;
	unlink the tag of the new element;
	unlink the replacement-command of the new element;
	unlink the origin of the new element;
	unlink the text-string of the new element;
	change element-selection set to {};
	add the new element at entry 1 in the element-selection set;
	say "Rendered string copied as: [element-name of new element].";

To create a duplicate sprite from (S - a sprite) in (win - a g-window):
	increase the instance-counter of S by 1;
	let the new sprite be a new object cloned from S;
	now the new sprite is standard;
	unlink the element-name of the new sprite;
	change the element-name of the new sprite to "[element-name of S]_copy";
	now the new sprite is standard;
	unlink the of-kind of the new sprite;
	unlink the tag of the new sprite;
	unlink the replacement-command of the new sprite;
	unlink the origin of the new sprite; 
	say "Sprite duplicated as: [element-name of new sprite].";
	change element-selection set to {};
	add new sprite at entry 1 in the element-selection set;
	follow the window-drawing rules for win;

	
Part - Changing element names

Changing the name of is an action applying to one topic. Understand "rename as [text]" or "rename to [text]" or "change name to [text]" or "rename [text]" as changing the name of.

Check changing the name of (this is the select just one element rule):
	if the element-selection set is empty:
		say "Please select an element and try again.";
		rule fails;
	if the number of entries of the element-selection set is greater than 1:
		say "Please select just one element and try again.";
		rule fails;

Carry out changing the name of:
	now the current answer is the topic understood;
	replace the regular expression "\p" in the current answer with "";
	[The "current answer" is used to allow code reuse between the standard and interactive forms; the latter must use the current answer because it is provided by the Questions extension.]
	abide by the changing the name of rule.
	
This is the changing the name of rule:
	change the element-name of entry 1 of the element-selection set to the current answer;
	say "The name of the element was changed to [italic type][element-name of entry 1 of the element-selection set].[roman type][paragraph break]";
	rule succeeds;
	
Interactively changing the name of is an action applying to nothing. Understand "rename" or "change name" or "rename element" as interactively changing the name of.

Check interactively changing the name of:
	abide by the select just one element rule;

Carry out interactively changing the name of:
	now current question is "What would you like to rename the selected element?";
	now current prompt is "Enter the new name: >";
	now current cancelation message is "[bracket]Renaming canceled.[close bracket]";
	ask an open question, in text mode.

A text question rule when the impelling action is interactively changing the name of:
	follow the changing the name of rule;
	exit.

	
Part - Changing element kinds

Changing the kind of is an action applying to one topic. Understand "change kind to [text]" or "change to [text]" or "kind [text]" as changing the kind of.

Check changing the kind of:
	abide by the select at least one element rule;
	[if the element-selection set is empty:
		say "Please select at least one element and try again.";
		rule fails;]

Carry out changing the kind of:
	now the current answer is the topic understood;
	abide by the changing the kind of rule.
	
This is the changing the kind of rule:
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		change the of-kind of the current-element to the current answer;
		add the element-name of the current-element to L;
	say "The kind of the [if the number of entries of the element-selection set is greater than 1]elements[otherwise]element[end if] [L] was changed to [italic type][current answer].[roman type][paragraph break]";
	rule succeeds;
	
Interactively changing the kind of is an action applying to nothing. Understand "change kind" or "kind" or "change element kind" as interactively changing the kind of.

Check interactively changing the kind of:
	abide by the select at least one element rule.

Carry out interactively changing the kind of:
	now current question is "Please indicate the name of the kind you wish to change the element to, e.g. [italic type]room-element, item-element[roman type].";
	now current prompt is "Enter the name of the kind: >";
	now current cancelation message is "[bracket]Kind attribution canceled.[close bracket]";
	ask an open question, in text mode.

A text question rule when the impelling action is interactively changing the kind of:
	follow the changing the kind of rule;
	exit.


Part - Tags

The tag type is an indexed text variable. The tag type is usually "text".
The tag alias is a text variable. The tag alias is usually "tag".

The tag-surround is text that varies.

[We add quotation marks if the tag will be used to represent a text or indexed text property]

When play begins:
	change the tag type to the tag type in lower case;
	if the tag type exactly matches the text "text" or the tag type exactly matches the text "indexed text":
		change the tag-surround to "[quotation mark]";
	otherwise:
		change the tag-surround to "".


Chapter - Assigning tags

Tagging is an action applying to one topic. Understand "tag [text]" or "tag as [text]" or "tag element as [text]" or "t [text]" as tagging.

Check tagging:
	abide by the select at least one element rule.

Carry out tagging:
	now the current answer is the topic understood;
	[The "current answer" is used to allow code reuse between the standard and interactive forms; the latter must use the current answer because it is provided by the Questions extension.]
	abide by the tagging elements rule.
	
This is the tagging elements rule:
	repeat with current-element running through the element-selection set:
		change the tag of current-element to the current answer;
	say "The tag of the selected element(s) was changed to [italic type][current answer].[roman type][paragraph break]";
	rule succeeds;


Interactively tagging is an action applying to nothing. Understand "tag" or "tag element" or "tag sprite" or "t" as interactively tagging.

Check interactively tagging:
	abide by the select at least one element rule.

Carry out interactively tagging:
	now current question is "How would you like to tag the selected element?";
	now current prompt is "Enter the tag: >";
	now current cancelation message is "[bracket]Tagging canceled.[close bracket]";
	ask an open question, in text mode.

A text question rule when the impelling action is interactively tagging:
	follow the tagging elements rule;
	exit.


Chapter - Removing tags

Removing tags is an action applying to nothing. Understand "remove tag" or "clear tag" or "delete tag" as removing tags.

Check removing tags:
	abide by the select at least one element rule.
	
Carry out removing tags:
	repeat with current-element running through the element-selection set:
		change the tag of current-element to "";
	say "The tag of the selected element(s) was removed.";
	

Part - Adding and removing graphlinks

Graphlinking to is an action applying to one topic. Understand "link element with replacement command [text]" or "link [text]" or "link element [text]" or "link with replacement command [text]" or "link with command [text]" as graphlinking to.

Check graphlinking to:
	abide by the select at least one element rule;

Carry out graphlinking to (this is the graphlinking rule):
	let T be indexed text;
	let T be the topic understood;
	replace the text "[quotation mark]" in T with "";
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		change the replacement-command of current-element to T;
		add the element-name of the current-element to L;
	say "The selected [if the number of entries of the element-selection set is greater than 1]elements were[otherwise]element was[end if] graphlinked with the glulx replacement command set to [italic type][T].[roman type][paragraph break]";
	rule succeeds;
	
Interactive graphlinking is an action applying to nothing. Understand "link" or "add link" as interactive graphlinking.

Check interactive graphlinking:
	abide by the select at least one element rule;
		
Carry out interactive graphlinking:
	now current question is "Please type in the command that will be entered when the player clicks on [if the number of entries of the element-selection set is greater than 1]these elements[otherwise]this element[end if].";
	now current prompt is "Enter graphlinked command: >";
	now current cancelation message is "[bracket]Graphlinking canceled.[close bracket]";
	ask an open question, in text mode.
	
A text question rule when the impelling action is interactive graphlinking:
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		change the replacement-command of current-element to the current answer;
		add the element-name of the current-element to L;
	say "The selected [if the number of entries of the element-selection set is greater than 1]elements were[otherwise]element was[end if] graphlinked with the glulx replacement command set to [italic type][current answer].[roman type][paragraph break]";
	exit.
	
Delinking is an action applying to nothing. Understand "delink element" or "delink" or "remove link/links" as delinking.

Check delinking:
	if the element-selection set is empty:
		say "Please select at least one element and try again.";
		rule fails;

Carry out delinking (this is the delinking rule):
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		change the replacement-command of current-element to "";
		add the element-name of the current-element to L;
	say "The selected [if the number of entries of the element-selection set is greater than 1]elements were delinked. They[otherwise]element was delinked. It[end if] will not respond to mouse input.";
	rule succeeds;
	

Part - Getting element information

Definition: a g-element (called the-element) is g-unlinked:
	if the replacement-command of the-element is "", yes;
	no.

Element-querying is an action applying to nothing. Understand "info" or "element information" or "element info" or "information" or "i" as element-querying.

Before element-querying:
	let percentage be indexed text;
	let percentage be "[scaling factor of the working window real times 100]";
	replace the regular expression "0+$|\.$" in percentage with "";
	say "The canvas measures [canvas-width of the working canvas] by [canvas-height of the working canvas].[line break]The scaling factor of the editor window is [scaling factor of the working window] ([percentage]%)."

Check element-querying:
	if the element-selection set is empty:
		say "Select at least one element in the editor and try the command again to get specific information about that element.";
		rule fails;

To decide which number is the absolute value of (N - a number):
	if N is less than 0:
		let N be 0 minus N;
	decide on N.
	
Carry out element-querying:
	repeat with current-element running through the element-selection set:
		let dim-x be a number;
		let dim-y be a number;
		let len be a number;
		if current-element provides the property endpoint:
			let dim-x be (entry 1 of the endpoint of current-element) - (entry 1 of the origin of current-element);
			let dim-y be (entry 2 of the endpoint of current-element) - (entry 2 of the origin of current-element);
		if current-element is a line primitive:
			let dim-x be the absolute value of dim-x;
			let dim-y be the absolute value of dim-y;
		if current-element is a sprite:
			let dim-x be image-width of the image-ID of the current-element real times the x-scaling factor of the current-element as an integer;
			let dim-y be image-height of the image-ID of the current-element real times the y-scaling factor of the current-element as an integer;
		if current-element is a rendered string:
			let len be the length of the current-element;
		if current-element is an image-rendered string:
			let margin be the background-margin of the associated font of the current-element real times the x-scaling factor of the current-element as an integer;
			let vertical-size be the font-height of the associated font of the current-element real times the x-scaling factor of the current-element as an integer;
			let len be len real times the x-scaling factor of the current-element as an integer;
			let dim-x be len + margin + margin;
			let dim-y be vertical-size + margin + margin;
		if current-element is a bitmap-rendered string:
			let dot-size be bit-size of the current-element real times the x-scaling factor of the current-element as an integer;
			let dim-x be dot-size * len;
			let dim-y be dot-size * (font-height of the associated font of the current-element);
		say "[bold type][element-name of current-element][roman type][line break][kind-flag of current-element][kind descendant arrow][unless of-kind of current-element is null][of-kind of current-element][otherwise](no sub-kind defined)[end if][line break]tag: [if the tag of current-element is null]none[otherwise][tag of current-element][end if][line break]display-layer: [display-layer of current-element][line break]origin: ([entry 1 of origin of current-element],[entry 2 of origin of current-element])[if current-element is not a sprite and current-element is not a rendered string]   endpoint: ([entry 1 of endpoint of current-element],[entry 2 of endpoint of current-element])[end if][line break]dimensions: [dim-x] by [dim-y][line break]scaling: [if the x-scaling factor of current-element is the y-scaling factor of current-element][x-scaling factor of current-element][otherwise][x-scaling factor of current-element] (x) by [y-scaling factor of current-element] (y)[end if][if current-element provides the property line-weight][line break]line-weight: [line-weight of current-element][end if][if current-element is a bitmap-rendered string][line break]bit-size: [bit-size of current-element][end if][if current-element is not a sprite][line break]foreground color: [tint of current-element][end if][if current-element is a stroked rectangle primitive or current-element is a rendered string][line break]background color: [background tint of current-element][end if][line break]replacement command: [if the current-element is g-unlinked]N/A[otherwise][replacement-command of current-element][end if]";
		if the current-element is instanced:
			follow the element instances listing rule;
		say paragraph break;


To say kind descendant arrow:
	if Unicode is supported:
		say "[right-uni-arrow]";
	otherwise:
		say "->".

To decide whether Unicode is supported:
	(- unicode_gestalt_ok -)

To say left-bent-uni-arrow:
	(- glk_put_char_uni(8629); -)

To say right-uni-arrow:
	(- glk_put_char_uni(8594); -)


Part - Zooming

Zooming is an action applying to nothing. Understand "zoom" or "zoom in" or "zoom out" or "+" or "-" as zooming.

The zooming action has some text called the zoom-vector.

The zoom-center is a list of numbers variable. Zoom-center is {0, 0}.

Check zooming:
	unless zoom is available:
		say "The canvas fits in the window, so zoom is not available.";
		stop the action.

Carry out zooming when we are zoomed in:
	now the arbitrary scaling factor of the working window is 0.0000;
	now the origin of the working window is {0, 0};
	now the zoom-vector is "out";
	rule succeeds.

Carry out zooming when we are zoomed out:
	now the arbitrary scaling factor of the working window is 1.0000;
	if the element-selection set is empty:
		change the zoom-center to {-1, -1};
	otherwise:
		change the zoom-center to the center-point of (entry 1 of the element-selection set);
	now the zoom-vector is "in";
	rule succeeds.

Report zooming:
	carry out the scaling activity with the working window;[we do this to get the proper scaling factor]
	let percentage be indexed text;
	let percentage be "[scaling factor of the working window real times 100]";
	replace the regular expression "0+$" in percentage with "";
	replace the regular expression "\.+$" in percentage with "";
	say "Zooming [zoom-vector] to [scaling factor of the working window] ([percentage]%).";
	if we are zoomed out:
		now the inactive-state of the zoom_button is Figure of Zoom In;
	if we are zoomed in:
		now the inactive-state of the zoom_button is Figure of Zoom Out Inactive;
	unless the command is mouse-generated:
		now the image-ID of zoom_button is the inactive-state of the zoom_button;
	follow the window-drawing rules for the working window.
		

Part - Element scaling


Chapter - Scale tab

Scale-tab clicking is an action applying to nothing. Understand "mode scale" or "scale mode" or "scaling mode" or "x" as scale-tab clicking.

Carry out scale-tab clicking:
	actuate the scale_tab;
	unless element-selection set is empty:
		truncate the element-selection set to 1 entries;
	say "The editor is now in SCALE mode. [if asymmetric-scaling is true]Scaling will be asymmetrical. Click with the mouse where you would like the lower right corner of the element to expand or contract[otherwise]Scaling will be symmetrical. The x-axis of the mouse-click determines the extent of the element's expansion or contraction; the aspect ratio of the original image will be automatically maintained[end if].";
	[consider the window-drawing rules for the control-window;]
	consider the window-drawing rules for the working window;


Section - Scaling modes

Asymmetric-scaling is a truth state that varies. Asymmetric-scaling is false.

To decide if we are scaling asymmetrically:
	decide on asymmetric-scaling.
	
Asymmetrical scaling mode is an action applying to nothing. Understand "asymmetrical" or "asymmetrical scaling" or "scale asymmetrically" as asymmetrical scaling mode.

Understand "toggle scaling" or "scaling" as asymmetrical scaling mode when asymmetric-scaling is false.
Understand "toggle scaling" or "scaling" as symmetrical scaling mode when asymmetric-scaling is true.

Carry out asymmetrical scaling mode:
	change asymmetric-scaling to true;
	update AsymScale_radio using asymmetric-scaling;
	[follow the window-drawing rules for the control-window;]
	say "Asymmetrical scaling mode active.";
	
Symmetrical scaling mode is an action applying to nothing. Understand "symmetrical" or "symmetrical scaling" or "equivalent scaling" as symmetrical scaling mode.

Carry out symmetrical scaling mode:
	change asymmetric-scaling to false;
	update AsymScale_radio using asymmetric-scaling;
	[follow the window-drawing rules for the control-window;]
	say "Symmetrical scaling mode active.";


Section - Scaling validation rules

This is the check scaling input rule:
	abide by the select at least one element rule;
	abide by the scaling limit validation rule;

This is the scaling limit validation rule:
	if the real number understood is real less than the lower scaling-limit or the real number understood is real greater than the upper scaling-limit:
		say "The number you entered was not within the permitted range. Please enter a fixed-point number between [the lower scaling-limit] and [the upper scaling-limit].";
		if we are asking a question, retry;
		rule fails;

The scaling operation cancelation message is text that varies. The scaling operation cancelation message is "[bracket]Scaling operation canceled.[close bracket]".

To decide whether the player entered a number:
	if the player's command matches the regular expression "\d", decide yes;
	decide no.
	

Chapter - GUI scaling

A clicking graphlink rule when the current graphlink window is the working window (this is the element-scaling mouse input rule):
	unless the current tab is scale_tab:
		continue the action;
	if the element-selection set is empty:
		if the click hit a hot link:
			add current graphlink at entry 1 in the element-selection set;
			now glulx replacement command is "";
			consider the window-drawing rules for the current graphlink window;
			update the status line;
			rule succeeds;
		otherwise:
			[actuate select_tab;
			consider the window-drawing rules for the control-window;]
			follow the element-selection rule;
			rule succeeds;
	change glulx replacement command to "SCALE ELEMENT";
	cancel input in main window;
	rule succeeds;
	
element-scaling is an action applying to nothing. Understand "scale element" as element-scaling.

Check element-scaling:
	unless entry 1 of the element-selection set is a sprite or entry 1 of the element-selection set is an image-rendered string:
		say "[bracket]GUI scaling is only effective on sprites (images) and on image-based text strings.[close bracket][one of][paragraph break]Scaling of primitives affects only the  line-weight, while for bitmapped text it changes the size of the individual pixels (the bit-size). If you wish to set the scaling factor of an element other than a sprite or image-rendered string, enter SCALE AT (a real number, such as 0.[run paragraph on][8 times (10 to the power precision minus 1)]).[or][stopping][line break]";
		rule fails;
	if the command is mouse-generated:
		continue the action;
	otherwise:
		say "[bracket]That command is reserved for the editor.[close bracket][paragraph break]You may:[line break](1) Enter SCALE AT (a real number, such as 0.[run paragraph on][8 times (10 to the power precision minus 1)]) to scale symmetrically;[line break](2) Enter SCALE HORIZONTALLY/VERTICALLY AT (a real number, such as 0.[run paragraph on][8 times (10 to the power precision minus 1)]) to scale asymmetrically[if current tab is Select_tab][line break](3) Click in the main element window to scale the selected element[otherwise][line break](3) Select the [bold type]scale[roman type] tab and scale using the mouse[end if].[line break]";
		rule fails;

Carry out element-scaling:
	let width-fixe be a real number;
	let height-fixe be a real number;
	let current-element be entry 1 of the element-selection set;
	let orig-x be entry 1 of the origin of the current-element;
	let orig-y be entry 2 of the origin of the current-element;
	let the clicked coordinates be the canvas equivalent of the screen coordinates current graphlink x by current graphlink y of the current graphlink window;
	let desired-x be entry 1 of the clicked coordinates;
	let desired-y be entry 2 of the clicked coordinates;
	[say "Clicked x: [desired-x][line break]Clicked y: [desired-y][line break]";]
	if desired-x is less than orig-x or desired-y is less than orig-y:
		say "Click to the right of and below the origin point (upper left-hand corner) of the element to resize it.";
		rule succeeds;
	if current-element is an image-rendered string:
		let width-fixe be (the length of the current-element plus (2 * background-margin of the associated font of the current-element) ) as a fixed point number;
		let height-fixe be (the font-height of the associated font of the current-element plus (2 * background-margin of the associated font of the current-element) ) as a fixed point number;
	otherwise:
		let width-fixe be the image-width of the image-ID of the current-element as a fixed point number;
		let height-fixe be the image-height of the image-ID of the current-element as a fixed point number;
	[let width-fixe be width as a fixed point number;
	let height-fixe be height as a fixed point number;]
	let desired-width be desired-x minus orig-x as a fixed point number;
	let desired-height be desired-y minus orig-y as a fixed point number;
	let width-factor be desired-width real divided by width-fixe;
	let height-factor be desired-height real divided by height-fixe;
	[say "Width: [width-factor][line break]Height: [height-factor][line break]";]
	if we are scaling asymmetrically:
		change the x-scaling factor of the current-element to the width-factor;
		change the y-scaling factor of the current-element to the height-factor;
	otherwise:
		change the x-scaling factor of the current-element to the width-factor;
		change the y-scaling factor of the current-element to the width-factor;
	say "Element [element-name of current-element] [if we are scaling asymmetrically]asymmetrically scaled to [width-factor] by [height-factor][otherwise]symmetrically scaled to [width-factor] of its original size[end if].";
	follow the window-drawing rules for the working window;
	if there is a linkid of current-element in the Table of Graphlink Glulx Replacement Commands:
		choose row with linkid of current-element in the Table of Graphlink Glulx Replacement Commands;
		draw a box (color highlight-color) in the working window from (p-left entry) by (p-top entry) to (current graphlink x) by (current graphlink y) with 2 pixel line-weight, outlined;
	rule succeeds;


Chapter - Default scaling factor


Section - Setting the default scaling factor

The default scaling factor is a real number that varies. The default scaling factor is usually 1.0000.

Setting the scaling factor is an action applying to one value. Understand "set default scale at [a real number]" or "set default scale to [a real number]" or "default [real number]" or "default scale [real number]" or "set scale at [real number]" or "set scale to [real number]" or "scaling [real number]" as setting the scaling factor.

Understand "scale [real number]" or "x [real number]" as setting the scaling factor when the number of entries of the element-selection set is 0.

Check setting the scaling factor:
	abide by the scaling limit validation rule.

Carry out setting the scaling factor (this is the default scaling factor rule):
	change the default scaling factor to the real number understood;
	say "Newly created elements will be scaled at a ratio of [the real number understood].";
	

Section - Interactively setting the default scaling factor
	
Interactively setting the scaling factor is an action applying to nothing. Understand "set default scale" as interactively setting the scaling factor.

Carry out interactively setting the scaling factor:
	now the current question is "Enter the desired scaling ratio to be used as the default. Each new element created will be scaled at this ratio.";
	now the current prompt is "Enter the scaling ratio (e.g., 0.[run paragraph on][8 times (10 to the power precision minus 1)]): >";
	now the current cancelation message is "[scaling operation cancelation message]";
	ask an open question in real number mode;
	
A real number question rule when the impelling action is interactively setting the scaling factor:
	abide by the scaling limit validation rule;
	follow the default scaling factor rule;
	exit;
	

Chapter - Basic element scaling commands


Section - Symmetrical scaling

Scaling elements is an action applying to one real number. Understand "scale at [real number]" or  "scale element/elements at [real number]" or "scale to [real number]" or "scale element/elements to [real number]" or "scale [real number]" or "x [real number]" as scaling elements.

Understand "scale [real number]" or "x [real number]" as scaling elements when the number of entries of the element-selection set > 0.

Check scaling elements:
	abide by the check scaling input rule;
	
Carry out scaling elements (this is the numeric symmetrical scaling rule):
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		change the x-scaling factor of the current-element to the real number understood;
		change the y-scaling factor of the current-element to the real number understood;
		add the element-name of the current-element to L;
	say "[if the number of entries of L is greater than 1]Elements[otherwise]Element[end if] [L] [if the number of entries of L is greater than 1]were[otherwise]was[end if] scaled to [the real number understood] of [if the number of entries of L is greater than 1]their original sizes[otherwise]the original size[end if].";
	follow the window-drawing rules for the working window;
	rule succeeds;
	

Section - Interactive symmetrical scaling
	
Interactive symmetrical scaling is an action applying to nothing. Understand "scale symmetrically" as interactive symmetrical scaling.

Check interactive symmetrical scaling:
	abide by the select at least one element rule;

Carry out interactive symmetrical scaling:
	now the current question is "";
	now current prompt is "Enter the scaling ratio (e.g., 0.[run paragraph on][8 times (10 to the power precision minus 1)]): >";
	now the current cancelation message is "[scaling operation cancelation message]";
	ask an open question in real number mode.
	
A real number question rule when the impelling action is interactive symmetrical scaling:
	follow the numeric symmetrical scaling rule;
	exit.


Chapter - Asymmetrical element scaling command

horizontally is in Fake-room_x. It is legerdemained.
vertically is in Fake-room_x. It is legerdemained. [Making these values would be better practice, but Inform only allows one value to be entered in a player's command, and we need that value to be the real number for scaling.]


Section - Asymmetrical scaling

Asymmetrically scaling elements is an action applying to one thing and one real number. Understand "scale [any legerdemained thing] at [real number]" or  "scale element/elements [any legerdemained thing] at [real number]" or "scale [any legerdemained thing] to [real number]" or  "scale element/elements [any legerdemained thing] to [real number]" or "scale [any legerdemained thing] [real number]" as asymmetrically scaling elements.

Check asymmetrically scaling elements:
	Abide by the check scaling input rule.
	
Carry out asymmetrically scaling elements (this is the asymmetric scale rule):
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		if the noun is horizontally:
			change the x-scaling factor of the current-element to the real number understood;
		otherwise if the noun is vertically:
			change the y-scaling factor of the current-element to the real number understood;
		add the element-name of the current-element to L;
	follow the window-drawing rules for the working window;
	say "[if the number of entries of L is greater than 1]Elements[otherwise]Element[end if] [L] [if the number of entries of L is greater than 1]were[otherwise]was[end if] scaled [noun] to [the real number understood] of [if the number of entries of L is greater than 1]their original sizes[otherwise]the original size[end if].";
	rule succeeds;


Section - Interactive asymmetrical scaling

Interactive asymmetrical scaling is an action applying to one thing. Understand "scale [any legerdemained thing]" or  "scale element/elements [any legerdemained thing]" as interactive asymmetrical scaling.

The current scaling direction is a thing that varies. 

Carry out interactive asymmetrical scaling:
	now the current scaling direction is the noun;
	now the current question is "Indicate the ratio at which the element should be scaled [current scaling direction]. The ratio must be expressed as a decimal with [precision in words]-digit precision; e.g., 0.[run paragraph on][8 times (10 to the power precision minus 1)] represents 80%.";
	now current prompt is "Enter a scaling ratio: >";
	now the current cancelation message is "[bracket]Scaling canceled.[close bracket]"; 
	ask an open question in real number mode;
	
A real number question rule when the impelling action is interactive asymmetrical scaling:
	abide by the scaling limit validation rule;
	now the noun is current scaling direction;
	follow the asymmetric scale rule;


Part - Changing the canvas


Chapter - Changing the canvas dimensions
	
Changing the canvas width is an action applying to one value. Understand "change canvas width to [a number]" or "set canvas width to [a number]" or "canvas width [a number]" or "width [a number]" as changing the canvas width.

Carry out changing the canvas width:
	change the canvas-width of the associated canvas of the working window to the number understood;
	say "The canvas is now [canvas-width of the associated canvas of the working window] pixels wide.";
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the control-window.]
	
Changing the canvas height is an action applying to one value. Understand "change canvas height to [a number]" or "set canvas height to [a number]" or "canvas height [a number]" or "height [a number]" as changing the canvas height.

Carry out changing the canvas height:
	change the canvas-height of the associated canvas of the working window to the number understood;
	say "The canvas is now [canvas-height of the associated canvas of the working window] pixels high.";
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the control-window.]
	

Section - Resizing the canvas

The current command section is a snippet that varies.

Resizing the canvas is an action applying to one topic. Understand "resize canvas [text]" as resizing the canvas.

Carry out resizing the canvas:
	let x be a number;
	let y be a number;
	change the current command section to the topic understood;
	if the current command section includes "to [a number]":
		let x be the number understood;
	otherwise:
		say "Width measurement not detected. The proper phrasing is RESIZE CANVAS TO <width> BY <height>. Please try again.";
		rule fails;
	if the current command section includes "by [a number]" or the current command section includes "x [a number]":
		let y be the number understood;
	otherwise:
		say "Height measurement not detected. The proper phrasing is RESIZE CANVAS TO <width> BY <height>. Please try again.";
		rule fails;
	change the canvas-width of the associated canvas of the working window to x;
	change the canvas-height of the associated canvas of the working window to y;
	say "The canvas now measures [canvas-width of the associated canvas of the working window] pixels wide by [canvas-height of the associated canvas of the working window] pixels high.";
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the control-window.]
	

Chapter - Assigning the background image

Assigning the background image is an action applying to nothing. Understand "assign background image" or "assign sprite to background" or "assign sprite as background" or "make background" or "make background image" as assigning the background image.

Check assigning the background image:
	if the number of entries of the element-selection set is greater than 1:
		say "Please select just one sprite.";
		rule fails;
	if the element-selection set is empty or entry 1 of the element-selection set is not a sprite:
		say "Please select a sprite and try again.";
		rule fails;
	unless entry 1 of the element-selection set is a sprite:
		say "The background image is required to be an image. Please select an image from the Image Library and try again.";
		rule fails.
		
Carry out assigning the background image:
	let selected-image be the image-ID of entry 1 of the element-selection set;
	change the background image of the working canvas to the selected-image;
	change the canvas-width of the working canvas to the image-width of selected-image;
	change the canvas-height of the working canvas to the image-height of selected-image;
	[change the working window to image-backgrounded;]
	say "[selected-image] is now being used as the background image. The size of the canvas is determined by the size of the image, and is [canvas-width of the working canvas] pixels wide by [canvas-height of the working canvas] pixels high.[paragraph break]You may type REMOVE BACKGROUND IMAGE to remove the image, or RESIZE CANVAS TO <width> BY <height> to set the canvas dimensions independently of the image.";
	fake-delete entry 1 of the element-selection set;
	update the status line;
	consider the window-drawing rules for the working window;
	[follow the window-drawing rules for the control-window.]
	

Chapter - Removing the background image
	
Removing the background image is an action applying to nothing. Understand "delete background" or "remove background" or "delete background image" or "remove background image" or "delete canvas background image" or "remove canvas background image" or "delete canvas background" or "remove canvas background" as removing the background image.

Check removing the background image:
	if the background image of the working canvas is Figure of Null:
		say "There is currently no background picture defined. To assign one, select a sprite and type ASSIGN TO BACKGROUND.";
		rule fails.
		
Carry out removing the background image:
	now the background image of the working canvas is Figure of Null;
	refresh windows;
	say "The background image has been removed."


Chapter - Rebuilding windows

Rebuilding windows is an action applying to nothing. Understand "rebuild windows" or "rebuild" as rebuilding windows.

Carry out rebuilding windows:
	say "Closing windows...[line break]";
	close editor windows;
	if canvas-height of working canvas > canvas-width of working canvas:
		now portrait orientation is true;
		set windows to portrait orientation;
	otherwise:
		now portrait orientation is false;
		set windows to landscape orientation;
	say "Reopening windows...[line break]";
	open editor windows;
	say "Windows rebuilt."

To set windows to landscape orientation:
	now the measurement of the library-window is 20;
	now the measurement of the editor-window is 60;
	now the position of the editor-window is g-placeabove;
	now the position of the control-window is g-placeleft;
	now the measurement of the layers-window is 3;
	now the measurement of the help-window is 15.	

To close editor windows:
	if the library-window is g-present:
		shut down the library-window;
	shut down the editor-window;
	shut down the control-window.


Part - Layer Commands

The current display-layer is a number that varies. The current display-layer is 1.
Maximum display-layer is a number that varies. Maximum display-layer is 24.


Chapter - Changing the current display-layer

Changing the current display-layer is an action applying to one number. Understand "change default layer to [number]" or "default layer [number]" as changing the current display-layer.

Understand "layer [number]" or "l [number]" as changing the current display-layer when the number of entries of the element-selection set is 0.

Check changing the current display-layer:
	if the number understood is less than 1 or the number understood is greater than the maximum display-layer:
		say "Please enter a number between 1 and [maximum display-layer].";
		rule fails;

Carry out changing the current display-layer:
	change the current display-layer to the number understood;
	if the number understood is greater than indicated layers:
		now indicated layers is the number understood;
	follow the window-drawing rules for the working window;
	[follow the window-drawing rules for the control-window;]
	[follow the window-drawing rules for the layers-window];
	say "New elements will be created on display-layer [current display-layer].";
	

Chapter - Moving elements between display-layers
	
Changing the display-layer is an action applying to one number. Understand "move to layer [number]" or "move to display-layer [number]" or "change display-layer to [number]" or "change display-layer to [number]" or "display-layer [a number]" as changing the display-layer.

Understand "layer [number]" or "l [number]" as changing the display-layer when the number of entries of the element-selection set is greater than 0.

Check changing the display-layer:
	if the number of entries of the element-selection set < 1:
		say "Please select at least one element and try again.";
		rule fails;
	if the number understood is less than 1 or the number understood is greater than the maximum display-layer:
		say "Please enter a number between 1 and [maximum display-layer].";
		rule fails;
		
Carry out changing the display-layer (this is the moving between layers rule):
	let L be a list of indexed text;
	let L be {};
	repeat with current-element running through the element-selection set:
		change the display-layer of the current-element to the number understood;
		add the element-name of the current-element to L;
	if the number understood is greater than indicated layers:
		now indicated layers is the number understood;
	[follow the window-drawing rules for the layers-window];
	follow the window-drawing rules for the working window;
	say "[if the number of entries of L is greater than 1]Elements[otherwise]Element[end if] [L] [if the number of entries of L is greater than 1]were[otherwise]was[end if] moved to display-layer [the number understood].";
	rule succeeds;	

Interactively changing the display-layer is an action applying to nothing. Understand "move to new layer" as interactively changing the display-layer.

Check interactively changing the display-layer:
	if the number of entries of the element-selection set < 1:
		say "Please select at least one element and try again.";
		rule fails;

Carry out interactively changing the display-layer:
	Now current question is "Which layer do you wish to move the selected element(s) to? There are currently [indicated layers] layers in use, and up to [maximum display-layer] available.";
	Now current prompt is "Enter a number from 1 to [maximum display-layer]: >";
	Now current cancelation message is "[bracket]Layer reassignment canceled[close bracket]";
	Ask an open question, in number mode;
	
A number question rule when the impelling action is interactively changing the display-layer:
	if the number understood is less than 1 or the number understood is greater than the maximum display-layer:
		say "Please enter a number between 1 and [maximum display-layer].";
		retry;
	follow the moving between layers rule;
	exit.	


Chapter - Reveal/Conceal Layers command

Layer-revelation is a truth state that varies. Layer-revelation is false.
	
To append layer numbers:
	repeat through the Table of Graphlink Glulx Replacement Commands:
		if g-win entry is the working window:
			repeat with current-layer running through layer-elements:
				let current-element be linkid entry;
				if the display-layer of current-element is the layer-index of current-layer:
					let image-ID be image-ID of current-layer;
					let x be p-left entry;
					let y be p-top entry;
					display image-ID in the working window at x by y;

Revealing layers is an action applying to nothing. Understand "reveal layers" or "reveal" as revealing layers.

Understand "layers" as revealing layers when layer-revelation is false.
Understand "layers" as concealing layers when layer-revelation is true.

Carry out revealing layers:
	now layer-revelation is true;
	update layer_reveal_modal using layer-revelation;
	[follow the window-drawing rules for the control-window;]
	[follow the window-drawing rules for the layers-window;]
	follow the window-drawing rules for the working window;
	say "Layer-reveal mode is now active. The display-layer of each element in the editor window is identified by a number in the upper-left corner of the element.";
	
Concealing layers is an action applying to nothing. Understand "hide layers" or "conceal layers" as concealing layers.
 	
Carry out concealing layers: 
	now layer-revelation is false;
	update layer_reveal_modal using layer-revelation;
	[follow the window-drawing rules for the control-window;]
	[follow the window-drawing rules for the layers-window;]
	follow the window-drawing rules for the working window;
	say "Layer-reveal mode deactivated.";


Part - Instanced Elements

An instance is a kind of thing. An instance has a g-element called the instance-pointer. An instance has an indexed text called the instance-ref. An instance has an indexed text called the instance-kind. An instance has a list of numbers called the instance-origin. An instance has a number called the instance-layer. An instance has a real number called the instance x-scale. An instance has a real number called the instance y-scale. An instance has a figure name called the instance-identity. An instance has an indexed text called the instance-command.

An instance has a list of numbers called the instance-endpoint. An instance has a number called the instance-line-weight. An instance has a glulx color value called the instance-foreground. An instance has a glulx color value called the instance-background.

The mother-instance is an instance. The instance-pointer is the mother-sprite. The instance-ref is "". The instance-origin is {0, 0}. The instance-layer is 0. The instance x-scale is 1.0000. The instance y-scale is 1.0000. The instance-identity is Figure of Error. The instance-command is "". The instance-kind is "". The instance-endpoint is {0, 0}. The instance-line-weight is 0. The instance-foreground is g-black. The instance-background is g-black.

The current instance is an instance that varies. The current instance is the mother-instance.

Table of Current Element Instances
instance-number	instance-name
number	an instance
with 10 blank rows


Chapter - Registering an element instance

Registering an element instance is an action applying to one topic. Understand "register [text]" or "record [text]" or "register as [text]" or "record as [text]" or "r [text]" as registering an element instance.

Check registering an element instance:
	abide by the single sprite selection rule.
	
This is the single sprite selection rule:
	let sprite-count be 0;
	let sprite-presence be false;
	repeat with current-selection running through the element-selection set:
		let sprite-count be sprite-count + 1;
		if current-selection is a sprite:
			let sprite-presence be true;
			break;
	if element-selection set is empty or sprite-presence is false:
		say "Please select one sprite and try again. (Note that, currently, only sprites can be instanced.)";
		rule fails;
	if the number of entries of the element-selection set is greater than 1 and sprite-presence is true:
		say "(Only the first selected sprite will be instanced.)";
	change entry 1 of the element-selection set to entry sprite-count of the element-selection set;
	truncate the element-selection set to 1 entries;
	follow the window-drawing rules for the working window.
		
Carry out registering an element instance:
	now the current answer is the topic understood;
	replace the text "[quotation mark]" in the current answer with "";
	abide by the element instance registration rule.
	
This is the element instance registration rule:
	let the selected-element be entry 1 of the element-selection set;
	now the selected-element is instanced;
	let the new instance be a new object cloned from the mother-instance;
	unlink the instance-ref of the new instance;
	unlink the instance-command of the new instance;
	unlink the instance-origin of the new instance;
	unlink the instance-kind of the new instance;
	change the instance-pointer of the new instance to the selected-element;
	change the instance-ref of the new instance to the current answer;
	if the selected-element is a sprite:
		change the instance-identity of the new instance to the image-ID of the selected-element;
	change the instance-origin of the new instance to the origin of the selected-element;
	change the instance-layer of the new instance to the display-layer of the selected-element;
	change the instance x-scale of the new instance to the x-scaling factor of the selected-element;
	change the instance y-scale of the new instance to the y-scaling factor of the selected-element;
	change the instance-command of the new instance to the replacement-command of the selected-element;
	if the selected-element is not a sprite:
		if the selected-element is a primitive:
			unlink the instance-endpoint of the new instance;
			change the instance-endpoint of the new instance to the endpoint of the selected-element;
		unless the selected-element is an image-rendered string:
			change the instance-foreground of the new instance to the tint of the selected-element;
		unless the selected-element is a rendered string:
			change the instance-line-weight of the new instance to the line-weight of the selected-element;
		if the selected-element is a bitmap-rendered string:
			change the instance-line-weight of the new instance to the bit-size of the selected-element;
		if the selected-element is a stroked rectangle primitive or the selected-element is a bitmap-rendered string:
			change the instance-background of the new instance to the background tint of the selected-element;
	say "The element [element-name of selected-element] has been recorded at [origin of selected-element in brace notation], layer [display-layer of selected-element], scaled at [x-scaling factor of the selected-element][if we are scaling asymmetrically] x [y-scaling factor of the selected-element][end if], with the reference [italic type][the current answer][roman type]. (Note that all properties of an element are saved, not just those listed here.)";
	
Indicating an element instance is an action applying to nothing. Understand "register" or "register instance" or "register element instance"or "record" or "r" as indicating an element instance.

Check indicating an element instance:
	abide by the single sprite selection rule.
	
Carry out indicating an element instance:
	Now the current question is "Please provide a reference ID for this instance of the element. The reference ID can be a word, phrase, or number that will allow you to distinguish between instances in your source code.";
	Now the current prompt is "Reference ID: >";
	now the current cancelation message is "[bracket]Element instance registration canceled.[close bracket]";
	Ask an open question, in text mode;
	
A text question rule when the impelling action is indicating an element instance:
	abide by the element instance registration rule;
	exit.
	

Chapter - Show element instances

Listing element instances is an action applying to nothing. Understand "instances" or "list instances" as listing element instances.

Check listing element instances:
	abide by the single element selection rule.
	
Carry out listing element instances:
	abide by the element instances listing rule;
	say "[paragraph break]";
	say "To delete an element instance, type DELETE INSTANCE. To create a new element having the same characteristics as one of these instances, type LOAD INSTANCE.";
	
This is the element instances listing rule:
	let the selected-element be entry 1 of the element-selection set;
	if the selected-element is not instanced:
		say "The selected element has no recorded instances.";
		rule fails;
	say "The following instances are recorded for [element-name of the selected-element]:[line break]";
	let count be 0;
	repeat through the Table of Current Element Instances:
		blank out the whole row;
	repeat with item running through the list of instances:
		if the selected-element is the instance-pointer of item:
			increase count by 1;
			unless the instance-kind of item is the of-kind of the selected-element:
				change the instance-kind of the item to the of-kind of the selected-element;
			say "[line break][bracket][count][close bracket] [italic type][instance-ref of item]:[roman type] layer [instance-layer of item]; [instance-origin of item in brace notation]; scale [instance x-scale of item][if we are scaling asymmetrically] x [instance y-scale of item][end if]";
			if the number of blank rows in the Table of Current Element Instances < 2:
				let N be the number of rows in the Table of Current Element Instances;
				change the Table of Current Element Instances to have N + 2 rows;
			choose a blank row in the Table of Current Element Instances;
			change instance-number entry to count;
			change instance-name entry to item;
			

Chapter - Deleting an element instance

Deleting an element instance is an action applying to nothing. Understand "delete instance" or "delete element instance" as deleting an element instance.

Check deleting an element instance:
	abide by the single element selection rule.
	
Carry out deleting an element instance:
	abide by the element instances listing rule;
	say "[paragraph break]";
	now the current question is "Type the number of the instance you would like to delete.";
	now the current prompt is "Enter a number from the list: >";
	now the current cancelation message is "[bracket]Operation canceled.[close bracket]";
	ask an open question, in number mode;
	
This is the instance menu input validation rule:
	unless there is an instance-number of the number understood in the Table of Current Element Instances:
		say "Type the number corresponding to one of the instances listed above, or any other command to cancel.";
		retry;
	
A number question rule when the impelling action is deleting an element instance:
	let instanced-element be false;
	abide by the instance menu input validation rule;
	now the current instance is the instance-name corresponding to an instance-number of the number understood in the Table of Current Element Instances;
	now the instance-pointer of the current instance is the mother-sprite;
	let the selected-element be entry 1 of the element-selection set;
	repeat with item running through the list of instances:
		if the instance-pointer of item is the selected-element:
			let instanced-element be true;
			break;
		let instanced-element be false;
	if instanced-element is false:
		now the selected-element is standard;
	if instanced-element is true:
		now the selected-element is instanced;
	say "Instance deleted.";
	exit.

	

Chapter - Loading an element instance

Loading an element instance is an action applying to nothing. Understand "load instance" or "load element instance" as loading an element instance.

Check loading an element instance:
	abide by the single element selection rule.
	
Carry out loading an element instance:
	abide by the element instances listing rule;
	say "[paragraph break]";
	now the current question is "Type the number of the instance you would like to load. This will create a new element with the characteristics of the selected instance.";
	now the current prompt is "Enter a number from the list: >";
	now the current cancelation message is "[bracket]Operation canceled.[close bracket]";
	ask an open question, in number mode;
	
A number question rule when the impelling action is loading an element instance:
	abide by the instance menu input validation rule;
	now the current instance is the instance-name corresponding to an instance-number of the number understood in the Table of Current Element Instances;
	let the new element be a new object cloned from the instance-pointer of the current instance;
	now the new element is standard;
	unlink the element-name of the new element;
	now the element-name of the new element is "[element-name of the instance-pointer of the current instance]_[instance-ref of the current instance]";
	unlink the of-kind of the new element;
	unlink the replacement-command of the new element;
	change the replacement-command of the new element to the instance-command of the current instance;
	change the x-scaling factor of the new element to the instance x-scale of the current instance;
	change the y-scaling factor of the new element to the instance y-scale of the current instance;
	change the display-layer of the new element to the instance-layer of the current instance;
	unlink the origin of the new element;
	change the origin of the new element to the instance-origin of the current instance;
	change the image-ID of the new element to the instance-identity of the current instance;
	say "Loaded instance [element-name of the new element].";
	follow the window-drawing rules for the working window;
	follow the window-drawing rules for the layers-window;
	exit.


Part - Changing the image-ID

The identity reassignment mode is a truth state that varies. Identity reassignment mode is false.

Reassigning the element identity is an action applying to nothing. Understand "reassign sprite identity" or "reassign image-ID" or "change sprite ID" or "change image-ID" or "reassign" or "identity" or "image-ID" as reassigning the element identity.

Check reassigning the element identity:
	unless entry 1 of the element-selection set is a sprite:
		say "Please select a sprite and try again.";
		rule fails;
	abide by the single element selection rule.

Carry out reassigning the element identity:
	unless identity reassignment mode is true:
		say "Please click on an element in the library to change the image-ID of the sprite selected in the editor. Cancel by clicking on any other button.";
		now identity reassignment mode is true;
		rule succeeds;


Part - Alignment commands


Chapter - The center command

The center-overlay mode is a truth state that varies. Center-overlay mode is false.

Centering elements on is an action applying to nothing. Understand "center" or "center element" or "center element on" or "center on" as centering elements on.

Check centering elements on:
	abide by the single element selection rule.
	
Carry out centering elements on:
	say "Please click on a element in the editor window to center the selected element on that element. Cancel by clicking on any other button.";
	now center-overlay mode is true;
	[actuate the Select_tab;]
	[follow the window-drawing rules for the control-window;]
	
To center (A - a g-element) on (B - a g-element):
	[This phrase is called by the element select rule for clicking in the working window]
	let x be a number;
	let y be a number;
	let L be a list of numbers;
	[let AR be a number;
	let AB be a number;]
	let A-width be a number;
	let A-height be a number;
	[let BR be a number;
	let BB be a number;]
	let B-width be a number;
	let B-height be a number;
	if A is a linkid listed in the Table of Graphlink Glulx Replacement Commands:
		let L be the canvas equivalent of the screen coordinates p-right entry by p-bottom entry of the working window;
		[let AR be entry 1 of L;
		let AB be entry 2 of L;]
		let A-width be (entry 1 of L) minus (entry 1 of the origin of A);
		let A-height be (entry 2 of L) minus (entry 2 of the origin of A);
	otherwise:
		say "***Error: Selected element not found.";
		rule fails;
	if B is a linkid listed in the Table of Graphlink Glulx Replacement Commands:
		let L be the canvas equivalent of the screen coordinates p-right entry by p-bottom entry of the working window;
		[let BR be entry 1 of L;
		let BB be entry 2 of L;]
		let B-width be (entry 1 of L) minus (entry 1 of the origin of B);
		let B-height be (entry 2 of L) minus (entry 2 of the origin of B);
	otherwise:
		say "***Error: Target element not found.";
	let x be (B-width minus A-width) divided by 2;
	if A is left-aligned:
		let x be x plus entry 1 of the origin of B;
	if A is center-aligned:
		let x be entry 1 of the origin of B + (B-width / 2);
	if A is right-aligned:
		do nothing;
		[let x be BR - (B-width / 2) + (length of A / 2);]
	let y be (B-height minus A-height) divided by 2;
	let y be y plus entry 2 of the origin of B;
	change entry 1 of the origin of A to x;
	change entry 2 of the origin of A to y;
	if A is a primitive:
		let x1 be entry 1 of the origin of A;
		let y1 be entry 2 of the origin of A;
		change entry 1 of the endpoint of A to x1 plus (the element-width of A);
		change entry 2 of the endpoint of A to y1 plus (the element-height of A);
	now center-overlay mode is false;
	consider the window-drawing rules for the current graphlink window;


Chapter - The align command

A border-name is a kind of value. The border-names are top, bottom, right, and left.

The alignment mode is a truth state that varies. Alignment mode is false.

Aligning elements is an action applying to one value. Understand "align [a border-name]" or "align to [a border-name]" or "align element to [a border-name]" as aligning elements.

Check aligning elements:
	abide by the single element selection rule.

Carry out aligning elements:
	say "Please click on an element in the editor window to align the selected element to the [border-name understood] of that element. Cancel by clicking on any other button.";
	now alignment mode is true;
	[actuate the Select_tab;]
	[follow the window-drawing rules for the control-window;]

To align (A - a g-element) to the (B - a g-element) according to (target side - a border-name):
	[This phrase is called by the element select rule for clicking in the working window]
	let x be a number;
	let y be a number;
	let L be a list of numbers;
	let A-width be a number;
	let A-height be a number;
	if A is a linkid listed in the Table of Graphlink Glulx Replacement Commands:
		let L be the canvas equivalent of the screen coordinates p-right entry by p-bottom entry of the working window;
		[let AR be entry 1 of L;
		let AB be entry 2 of L;]
		let A-width be (entry 1 of L) minus (entry 1 of the origin of A);
		let A-height be (entry 2 of L) minus (entry 2 of the origin of A);
	otherwise:
		say "***Error: Selected element not found.";
		rule fails;
	if B is a linkid listed in the Table of Graphlink Glulx Replacement Commands:
		let L be the canvas equivalent of the screen coordinates p-right entry by p-bottom entry of the working window;
		let BR be entry 1 of L;
		let BB be entry 2 of L;
		let B-width be (entry 1 of L) minus (entry 1 of the origin of B);
		let B-height be (entry 2 of L) minus (entry 2 of the origin of B);
		if the target side is top:
			let y be entry 2 of the origin of B minus A-height;
			let x be (B-width minus A-width) divided by 2;
			let x be x plus entry 1 of the origin of B;
		if the target side is left:
			let x be entry 1 of the origin of B minus A-width;
			let y be (B-height minus A-height) divided by 2;
			let y be y plus entry 2 of the origin of B;
		if the target side is right:
			let x be BR;
			let y be (B-height minus A-height) divided by 2;
			let y be y plus entry 2 of the origin of B;
		if the target side is bottom:
			let y be BB;
			let x be (B-width minus A-width) divided by 2;
			let x be x plus entry 1 of the origin of B;
	otherwise:
		say "***Error: Target element not found.";
	change entry 1 of the origin of A to x;
	change entry 2 of the origin of A to y;
	if A is a primitive:
		change entry 1 of the endpoint of A to x plus (the element-width of A);
		change entry 2 of the endpoint of A to y plus (the element-height of A);
	now alignment mode is false;
	consider the window-drawing rules for the current graphlink window;


Part - Source code generation and settings


Chapter - Selecting the style of source code output

Styling the output as tabular is an action applying to nothing. Understand "tabular output" as styling the output as tabular.

Carry out styling the output as tabular (this is the tabular styling rule):
	Say "Source code output will use tables where appropriate.";
	now table-option is true;
	update tabular_source_radio using table-option;
	[follow the window-drawing rules for the control-window;]
	
Styling the output as paragraphed is an action applying to nothing. Understand "paragraph output" or "standard output" or "paragraphed output" as styling the output as paragraphed.

Carry out styling the output as paragraphed (this is the paragraphed styling rule):
	Say "Source code output will be styled using paragraphs.";
	now table-option is false;
	update tabular_source_radio using table-option;
	[follow the window-drawing rules for the control-window;]
	
Toggling the output style is an action applying to nothing. Understand "toggle output style" as toggling the output style.

Carry out toggling the output style:
	if table-option is true:
		follow the paragraphed styling rule;
	otherwise:
		follow the tabular styling rule;
	

Chapter - Changing the name of the Flexible Windows target window

Renaming the targeted canvas is an action applying to one topic. Understand "rename the target canvas [text]" or "rename canvas [text]" or "rename the canvas [text]" or "canvas [text]" or "rename target canvas [text]" as renaming the targeted canvas.
		
Carry out renaming the targeted canvas:
	let T be indexed text;
	let T be the topic understood;
	replace the text "[quotation mark]" in T with "";
	change the targeted canvas to T;
	say "Source code will be generated targeting the canvas [italic type][targeted canvas][roman type]".
	

Chapter - Generating source code

The file of Output is called "GlimmrSource".

The kind-parsed omnibus is a list of lists of objects that varies.
The numbered-kinds index is a list of numbers that varies. [This list exists as part of an elaborate workaround for a bug in 5Z71 that prevented Inform from sorting lists of objects on indexed text properties.]

The kinds-count is a number that varies.

The graphlink_active is a g-element. The graphlink_absent is a g-element. [These are dummy objects that will occupy the first position in each of the parsed lists; graphlink_present indicates that *all* of the sprites of a given kind have graphlinks.]

To say tab:
	if the current action is generating source code:
		say direct-character placement tab;
	otherwise:
		say "     ".
	

Section - The generating source code action

Generating source code is an action applying to nothing. Understand "generate source" or "generate source code" or "source code" or "source" or "generate" as generating source code.

Check generating source code (this is the check for defined elements rule):
	if the number of entries of the list of standard g-elements plus the number of entries of the list of instanced g-elements is less than 1:
		say "You have not yet defined any canvas elements. To get started, click on an image in the library window to the right to spawn a sprite in the main graphics window, or use the drawing tools to create a primitive or text element. (If the drawing toolbar is not visible, click on the pencil icon in the control panel to bring it up).";
		rule fails.
		
Carry out generating source code:
	follow the source code generation rule.
	
After generating source code:
	say "Source code output to file. Please check your hard drive for the text file, or type PREVIEW SOURCE CODE to see the source in the game window. (Inform cannot print tabs to the window, so previewed code will use spaces instead, and the code will not compile when pasted into the IDE. You should use the GENERATE SOURCE CODE command when you are ready to copy source for compilation.)";
	

Section - Generating the source
	
This is the source code generation rule:
	write "[quotation mark][story title][quotation mark][unless story author is null] by [story author][end if][paragraph break]" to the file of Output;
	append "[bracket]Source code generated automatically by Glimmr Canvas Editor.[close bracket][paragraph break]" to the file of Output;
	write preamble;
	unless the user-specified source text is "":
		append "[user-specified source text][paragraph break]" to the file of Output;
	index element-kinds for parsing;[workaround; see below]
	evaluate element-kinds;
	parse element-kinds;
	if we have asymmetrical elements, append "Use asymmetrical scaling.[paragraph break]" to the file of Output;
	unless table-option is true:
		write paragraphed source code;
	otherwise:
		write tabulated source code;
	if we have instanced elements, write listings for instances.

The user-specified source text is a text variable.
	

Section - Summarization phrases

To decide whether we have graphic links:	
	repeat with current-element running through g-elements displayed on the working canvas:
		unless the current-element is deleted:
			unless the replacement-command of the current-element is "":
				decide yes;
	decide no;

To decide whether we have instanced elements:
	if the number of entries of list of instanced g-elements is greater than 0, decide yes;
	decide no.
	
To decide whether we have asymmetrical elements:
	[asymmetrical scaling affects only sprites, so we only look at dynamic sprites.]
	repeat with current-element running through dynamic-sprites:
		if the associated canvas of the current-element is the working canvas:
			unless the current-element is deleted:
				unless the x-scaling factor of the current-element is the y-scaling factor of the current-element:
					decide yes;
	decide no;
	
To decide if (S - a g-element) is graphic-linked:
	unless the replacement-command of S is "":
		decide yes;
	decide no;
	
To decide whether we have primitives:
	repeat with item running through the list of in-play primitives assigned to the working window:
		unless item is deleted:
			decide yes;
	decide no;
	
To decide whether we have rendered strings:
	repeat with item running through the list of in-play rendered strings assigned to the working window:
		unless item is deleted:
			decide yes;
	decide no;

To decide whether we have tags:
	repeat with item running through the list of in-play g-elements assigned to the working window:
		if the tag of item is not "":
			decide yes;
	decide no.

To decide whether we have a map:
	let L be the list of rooms;
	remove fake-room_x from L;
	if the number of entries of L > 0:
		decide yes;
	decide no.

To decide whether we have customized colors:
	repeat with current-hue running through the drawing colors:
		if current-hue is not a glulx color value listed in the Table of Default Color Values:
			decide yes;
	if the back-colour of the working window is not a glulx color value listed in the Table of Default Color Values:
		decide yes;
	decide no.

	
Table of Default Color Values
glulx color value
g-black
g-dark-grey
g-medium-grey
g-light-grey
g-white
g-placenullcol
g-darkgreen
g-green
g-lime
g-midnightblue
g-steelblue
g-terracotta
g-navy
g-mediumblue
g-blue
g-indigo
g-cornflowerblue
g-mediumslateblue
g-maroon
g-red
g-deeppink
g-brown
g-darkviolet
g-khaki
g-silver
g-crimson
g-orangered
g-gold
g-darkorange
g-lavender
g-yellow
g-pink
	

Section - Writing inclusions and graphics window code to the source

To write the/-- preamble:
	append "Include Glimmr Canvas-Based Drawing by Erik Temple.[font extensions][paragraph break]" to the file of Output;
	append "Chapter - Scenario[paragraph break]" to the file of Output;
	append "[bracket]Insert code here, particularly the definition of rooms and their connections.[close bracket]" to the file of Output;
	if we have a map:
		append "The following rooms were present in the geography defined in the source for the Canvas Editor: " to the file of Output;
		let L be the list of rooms;
		remove fake-room_x from L;
		append "[L]" to the file of Output;
	otherwise:
		append "Starting Room is a room" to the file of Output;
	append ".[paragraph break]" to the file of Output;
	append "Chapter - Figure Definitions[paragraph break][bracket]Paste the list of figure definitions here (e.g., Figure of Error is the file [quotation mark]Error.png[quotation mark])[close bracket][paragraph break]Chapter - Canvas and window[paragraph break]The graphics-window is a graphics g-window spawned by the main-window. The position of the graphics-window is [position of the working window]. The measurement of the graphics-window is 50. The back-colour of the graphics-window is [back-colour of working window].[paragraph break]The [targeted canvas] is a g-canvas. The canvas-width is [canvas-width of the working canvas]. The canvas-height is [canvas-height of the working canvas]. [unless the background image of the working canvas is Figure of Null]The background image of the [targeted canvas] is [background image of the working canvas]. [end unless]The associated canvas of the graphics-window is [targeted canvas]. [paragraph break]When play begins:[line break][tab]open up the graphics-window. " to the file of Output;
	if we have customized colors:
		append "[paragraph break]Chapter - Custom colors[paragraph break][bracket]You may have used glulx color values not supplied in Glulx Text Effects or Flexible Windows. As a convenience, these color values are provided in the table below. However, please note that if you are using an extension, such as HTML colors for Glulx Text Effects, that provides these colors, you may need to delete the table below to get your game to compile.[close bracket][paragraph break]Table of Common Color Values (continued)[line break]glulx color value[tab]assigned number[line break]" to the file of Output;
		repeat with current-hue running through the drawing colors:
			if current-hue is not a glulx color value listed in the Table of Default Color Values:
				append "[current-hue][tab][assigned number of current-hue][line break]" to the file of Output;
			if the back-colour of the working window is not a glulx color value listed in the Table of Default Color Values and the back-colour of the working window is not listed in the drawing colors:
			 	append "[back-colour of working window][tab][assigned number of back-colour of working window]" to the file of Output;
	if we have tags:
		append "[paragraph break]Chapter - Special element properties[paragraph break][bracket]This property reflects the tag(s) assigned in the editor.[close bracket][paragraph break]A g-element has a [tag type] called the [tag alias]." to the file of Output;
	append "[paragraph break]" to the file of Output;

To say font extensions:
	let L be a list of texts;
	repeat with item running through in-play rendered strings:
		let X be the extension-name of the associated font of item;
		if X is not "":
			add X to L, if absent;
	repeat with item running through L:
		say "[line break]Include [item].[run paragraph on]";
	say "[line break]".


Section - Sorting and otherwise preparing kinds

To index element-kinds for parsing: [this is a workaround for a bug in 5Z71 that prevented us from sorting a list based on an indexed-text property.]
	let N be a list of indexed text;
	let L be the list of in-play g-elements;
	repeat with current-element running through L:
		now the kind-index of current-element is 0;
		if the of-kind of current-element is not "":
			add the of-kind of the current-element to N, if absent;
	unless N is {}:
		let count be 0;
		repeat with current-kind running through N:
			increase count by 1;
			repeat with current-element running through L:
				if the of-kind of current-element is the current-kind:
					change the kind-index of the current-element to count;
					[say "Indexing:[line break]";
					say "Kind index of [element-name of current-element] set to:[kind-index of current-element].";]
	change kinds-count to the number of entries of N.
	
To evaluate element-kinds:
	let L be the list of in-play g-elements;
	sort L in kind-index order;
	let kind-comparison be the kind-index of entry 1 of L;
	let type-comparison be the kind-flag of entry 1 of L;
	repeat with current-element running through L:
		if the kind-index of current-element is not 0 and the kind-index of current-element is the kind-comparison:
			if the kind-flag of current-element is not the type-comparison:
				say "[one of]****Warning: Two elements of different types have been assigned the same kind. The code output will not compile properly. The first issue was encountered with the [kind-flag of current-element] [element-name of current-element], which problematically has been assigned the kind [of-kind of current-element].[paragraph break][or][stopping]";
		let kind-comparison be the kind-index of current-element;
		let type-comparison be the kind-flag of current-element;
		increase the kind-index of the current-element by the appropriate type count for the current-element;
		[say "Evaluating:[line break]";
		say "Kind index set to:[kind-index of current-element] ([kind-flag of current-element]:[of-kind of current-element]).".]
		
To decide what number is the appropriate type count to/for (current-element - a g-element):
	if the kind-flag of current-element is "sprite", decide on 1000;
	if the kind-flag of current-element is "rectangle primitive", decide on 2000;
	if the kind-flag of current-element is "box primitive", decide on 3000;
	if the kind-flag of current-element is "stroked rectangle primitive", decide on 4000;
	if the kind-flag of current-element is "line primitive", decide on 5000;
	if the kind-flag of current-element is "bitmap-rendered string", decide on 6000;
	if the kind-flag of current-element is "image-rendered string", decide on 7000.
	
To parse element-kinds:
	now the kind-parsed omnibus is {};
	let L be the list of standard g-elements;
	add the list of instanced g-elements to L;
	sort L in kind-index order;
	[say "The list of standard elements:";
	repeat with S running through L:
		say "[of-kind of S], ";
	say "[line break]";]
	let current-kind be the kind-index of entry 1 of L;
	let graphlink_cnt be 0;
	let graphlink-kinds be 0;
	let T be a list of objects;
	let count be 0;
	let kinds-counter be 1;
	repeat with current-element running through L:
		increase count by 1;
		[say "master list number: [count][line break]";]
		unless the replacement-command of the current-element is "":
			let graphlink_cnt be graphlink_cnt + 1;
			[say "graphlink count increased to [graphlink_cnt].[line break]";]
		if count is the number of entries of L:
			[say "element of kind [current-kind][line break]";]
			add current-element to T;
			increase kinds-counter by 1;
			if the graphlink_cnt is not 0 and the graphlink_cnt is the number of entries of T:
				add graphlink_active at entry 1 in T;
				increase graphlink-kinds by 1;
				[say "adding graphlink to list.[line break]";]
			otherwise:
				add graphlink_absent at entry 1 in T;
				[say "list not graphlinked.[line break]";]
			[say "list parsed: [T][line break]";]
			add T to the kind-parsed omnibus;
		otherwise unless the kind-index of entry (count + 1) of L is the current-kind:
			[say "element of kind [current-kind][line break]";]
			add current-element to T;
			if the graphlink_cnt is not 0 and the graphlink_cnt is the number of entries of T:
				add graphlink_active at entry 1 in T;
				increase graphlink-kinds by 1;
				[say "adding graphlink to list.[line break]";]
			otherwise:
				add graphlink_absent at entry 1 in T;
				[say "list not graphlinked.[line break]";]
			add T to the kind-parsed omnibus;
			now T is {};
			let the graphlink_cnt be 0;
			increase kinds-counter by 1;
			now current-kind is the kind-index of entry (count + 1) of L;
			[say "New list detected: [current-kind][line break]";]
		otherwise:
			[say "element of kind [current-kind][line break]";]
			add the current-element to T;
	[say "[paragraph break]The kind-parsed omnibus:[line break]";
	repeat with current-list running through the kind-parsed omnibus:
		say "New list-->[line break]";
		repeat with current-element running through current-list:
			if current-element is entry 1 of current-list:
				next;
			say "[element-name of current-element]: [of-kind of current-element] ([kind-flag of current-element]): [kind-index of current-element]."]
						

Section - Writing the body of the source code

To write paragraphed source code:
	repeat with current-list running through the kind-parsed omnibus:
		let current-kind be indexed text;
		let super-kind be false;
		let kind-article be text;
		if the remainder after dividing the kind-index of entry 2 of current-list by 1000 is less than 1:[the sublist is for first-level elements (i.e., not a subkind)]
			let super-kind be true;
			let current-kind be the kind-flag of entry 2 of current-list;
		otherwise:
			let super-kind be false;
			let current-kind be the of-kind of entry 2 of current-list;
		if current-kind matches the regular expression "^<aeiou>", case insensitively:
			let kind-article be "an";
		otherwise:
			let kind-article be "a";
		append "[if super-kind is true]Chapter - [current-kind in sentence case]s[otherwise]Section - [current-kind in sentence case] [kind-flag of entry 2 of current-list]s[end if][paragraph break]" to the file of Output;
		unless super-kind is true, append "[kind-article in sentence case] [current-kind] is a kind of [kind-flag of entry 2 of current-list]. " to the file of Output;
		append "The graphlink status of [kind-article] [current-kind] is [if entry 1 of the current-list is graphlink_active]g-active[otherwise]g-inactive[end if]. " to the file of Output;
		append "The associated canvas of [kind-article] [current-kind] is [targeted canvas]. " to the file of Output;
		append "[paragraph break]" to the file of Output;
		repeat with current-element running through the current-list:
			if current-element is graphlink_active or current-element is graphlink_absent:
				next;
			append "[element-name of current-element in sentence case] is [kind-article] [current-kind]. [if current-element is a dynamic-sprite]The image-ID is [image-ID of current-element].[end if] The origin is [origin of current-element in brace notation]. [if current-element provides the property endpoint] The endpoint is [endpoint of current-element in brace notation].[end if] [if current-element provides the property line-weight]The line-weight is [line-weight of current-element].[end if][if current-element provides the property text-string] The text-string is [quotation mark][text-string of current-element][quotation mark]. The associated font is [associated font of current-element]. [element-name of current-element in sentence case] is [alignment of current-element].[end if][if current-element provides the property tint and current-element is not a dynamic-image-string] The tint is [tint of current-element]. [end if][if current-element provides the property background tint]The background tint is [background tint of current-element]. [end if]" to the file of Output;
			if the x-scaling factor of the current-element is not 1.0000 or the y-scaling factor of the current-element is not 1.0000:
				if we have asymmetrical elements:
					append "The x-scaling factor is [x-scaling factor of current-element]. The y-scaling factor is [y-scaling factor of current-element]. " to the file of Output;
				otherwise:
					append "The scaling factor is [x-scaling factor of current-element]. " to the file of Output;
			append " The display-layer is [display-layer of current-element]. " to the file of Output;
			if the current-element is display-inactive:
				append "The display status of [element-name of current-element] is g-inactive. " to the file of Output;
			unless the tag of the current-element is "":
				append "The [tag alias] of [element-name of current-element] is [tag-surround][tag of current-element][tag-surround]. " to the file of Output;
			if entry 1 of the current-list is graphlink_absent and the current-element is graphic-linked, append "The graphlink status of [element-name of current-element] is g-active. " to the file of Output;
			if the current-element is graphic-linked, append "The linked replacement-command is [quotation mark][replacement-command of current-element][quotation mark]. " to the file of Output;
			append "[paragraph break]" to the file of Output;

			
To write tabulated source code:
	repeat with current-list running through the kind-parsed omnibus:
		let super-kind be false;
		let current-kind be indexed text;
		let kind-article be text;
		if the remainder after dividing the kind-index of entry 2 of current-list by 1000 is less than 1:[the sublist is for first-level elements (i.e., not a subkind)]
			let super-kind be true;
			let current-kind be the kind-flag of entry 2 of current-list;
		otherwise:
			let super-kind be false;
			let current-kind be the of-kind of entry 2 of current-list;
		if current-kind matches the regular expression "^<aeiou>", case insensitively:
			let kind-article be "an";
		otherwise:
			let kind-article be "a";
		append "[if super-kind is true]Chapter - [current-kind in sentence case]s[otherwise]Section - [current-kind in sentence case] [kind-flag of entry 2 of current-list]s[end if][paragraph break]" to the file of Output;
		unless super-kind is true, append "[kind-article in sentence case] [current-kind] is a kind of [kind-flag of entry 2 of current-list]. " to the file of Output;
		append "The graphlink status of [kind-article] [current-kind] is [if entry 1 of the current-list is graphlink_active]g-active[otherwise]g-inactive[end if]. " to the file of Output;
		append "The associated canvas of [kind-article] [current-kind] is [targeted canvas]. " to the file of Output;
		append "[paragraph break]" to the file of Output;
		append "Some [current-kind]s are defined by the Table of [current-kind in sentence case] Elements.[paragraph break]" to the file of Output;
		append "Table of [current-kind in title case] Elements[line break][current-kind][tab]origin[if entry 2 of the current-list provides the property endpoint][tab]endpoint[end if][if entry 2 of the current-list provides the property image-ID][tab]image-ID[end if][if entry 2 of the current-list provides the property line-weight][tab]line-weight[end if]" to the file of Output;
		append "[if entry 2 of the current-list provides the property bit-size][tab]bit-size[end if][if entry 2 of the current-list provides the property text-string][tab]text-string[tab]associated font[end if][if entry 2 of the current-list provides the property tint][tab]tint[end if][if entry 2 of the current-list provides the property background tint][tab]background tint[end if][tab]display-layer[tab]display status" to the file of Output;
		if we have asymmetrical elements:
			append "[tab]x-scaling factor[tab]y-scaling factor" to the file of Output;
		otherwise:
			append "[tab]scaling factor" to the file of Output;
		if entry 1 of the current-list is graphlink_active:
			append "[tab]linked replacement-command" to the file of Output;
		if we have tags:
			append "[tab][tag alias]" to the file of Output;
		append "[line break]" to the file of Output;
		repeat with current-element running through the current-list:
			if current-element is graphlink_active or current-element is graphlink_absent:
				next;
			append "[element-name of current-element][tab][origin of current-element in brace notation][if entry 2 of the current-list provides the property endpoint][tab][endpoint of current-element in brace notation][end if][if entry 2 of the current-list provides the property image-ID][tab][image-ID of current-element][end if][if entry 2 of the current-list provides the property line-weight][tab][line-weight of current-element][end if][if entry 2 of the current-list provides the property bit-size][tab][bit-size of current-element][end if]" to the file of Output;
			append "[if entry 2 of the current-list provides the property text-string][tab][quotation mark][text-string of current-element][quotation mark][tab][associated font of current-element][end if][if entry 2 of the current-list provides the property tint][tab][tint of current-element][end if][if entry 2 of the current-list provides the property background tint][tab][background tint of current-element][end if][tab][display-layer of current-element][tab][display status of current-element]" to the file of Output;
			if we have asymmetrical elements:
				append "[tab][x-scaling factor of current-element][tab][y-scaling factor of current-element]" to the file of Output;
			otherwise:
				append "[tab][x-scaling factor of current-element]" to the file of Output;
			if entry 1 of the current-list is graphlink_active:
				append "[tab][quotation mark][replacement-command of current-element][quotation mark]" to the file of Output;
			if we have tags:
				if the tag of current-element is "":
					append "[tab]--" to the file of Output;
				otherwise:
					append "[tab][tag-surround][tag of current-element][tag-surround]" to the file of Output;
			append "[line break]" to the file of Output;
		repeat with current-element running through the current-list:
			if current-element is graphlink_active or current-element is graphlink_absent:
				next;
			if entry 1 of the current-list is graphlink_absent and the current-element is graphic-linked:
				append "[one of][paragraph break][or][stopping]" to the file of Output;
				append "The graphlink status of [element-name of current-element] is g-active. The linked replacement-command is [quotation mark][replacement-command of current-element][quotation mark]" to the file of Output;
		append "[paragraph break]" to the file of Output;
			
To decide whether (current-element - a g-element) is a primitive:
	if the kind-flag of the current-element matches the text "primitive", decide yes;
	decide no.
			

Section - Appending the list of element instances to the source code
			
To write listings for instances:
	append "[bracket]Following is a list of [quotation mark]instances[quotation mark] provided for elements that change in some tangible way--their size, scale, or the image associated with them, for example--over the course of the game. Because there are many different ways in which this information could be used, it is provided as a simple table of attributes rather than as compilable source code. You may copy and paste the table data into Excel, Numbers, or Google Spreadsheets to easily select and manipulate the attribute information.[paragraph break]" to the file of Output;
	repeat with item running through the list of instances:
		[ensures that all of the instances generated from a given element have the same kind currently held by the element.]
		let the selected-element be the instance-pointer of item;
		unless the instance-kind of item is the of-kind of the selected-element:
			change the instance-kind of the item to the of-kind of the selected-element;
	repeat with current-list running through the kind-parsed omnibus:
		[This routine take the long way around via the kind-parsed omnibus list as another workaround to the bug in 5Z71 that prevented lists being sorted on indexed text.]
		if entry 2 of current-list is not a sprite:
			next;
		unless the current-list contains an instanced element:
			next;
		let current-kind be the of-kind of entry 2 of current-list;
		let current-type be the kind-flag of entry 2 of current-list;
		append "[line break]***[current-type in sentence case] elements[unless current-kind is null] of kind [current-kind][end if]***[paragraph break]" to the file of Output;
		append "[current-type][tab]reference[tab]origin[tab]image-ID[tab]display-layer[if we are scaling asymmetrically][tab]x-scaling factor[tab]y-scaling factor[otherwise][tab]scaling factor[end if][tab]linked replacement-command[line break]" to the file of Output;
		repeat with current-element running through the current-list:
			if current-element is instanced:
				repeat with item running through the list of instances:
					if the current-element is the instance-pointer of item:
						append "[element-name of current-element][tab][instance-ref of item][tab][instance-origin of item in brace notation][tab][instance-identity of item][tab][instance-layer of item][if we are scaling asymmetrically][tab][instance x-scale of item][tab][instance y-scale of item][otherwise][tab][instance x-scale of item][end if][tab][unless instance-command of item is null][instance-command of item][otherwise][quotation mark][quotation mark][end if][line break]" to the file of Output;
	append "[close bracket][paragraph break]" to the file of Output;
	
To decide whether (T - an indexed text) is null:
	if T is "", decide yes;
	decide no.

To decide whether (L - a list of objects) contains an instanced element:
	repeat with item running through L:
		if item is instanced, decide yes;
	decide no.


Chapter - Previewing source code

Previewing source code is an action applying to nothing. Understand "preview source code" or "preview source" or "preview" as previewing source code.

Check previewing source code:
	abide by the check for defined elements rule;
		
Carry out previewing source code:
	say "[italic type]Inform cannot print tabs to the window, so previewed code will use spaces instead. A file with tabs has been written to your hard drive. (Type GENERATE SOURCE CODE to skip the preview and write the file directly.) Here is the source code:[roman type][line break]";
	follow the source code generation rule;
	say "[text of the file of Output]";


Glimmr Canvas Editor ends here.


---- DOCUMENTATION ----

Glimmr Canvas Editor (GCE) is not a standard extension. It is a self-contained project, complete with multimedia assets, that generates a GUI editor for building canvas-based compositions. The user may include a list of figures, but at minimum one need include only the extension itself. If a list of figures is included, those figures will be available to use as sprites within the editor. We can also specify various settings and, within limits, add our own code (see below). 

Glimmr Canvas Editor depends on a rather large set of extensions. These include:

	Glimmr Canvas-Based Drawing
	Glimmr Drawing Commands
	Glimmr Bitmap Font (another bitmap font extension can be substituted)
	Glimmr Image Font	(another image font extension can be substituted)
	Glimmr Graphics Hyperlinks
	Dynamic Objects
	Questions
	Fixed Point Maths
	Undo Output Control
	Glulx Text Effects
	(and also some built-in extensions)

Note that GCE also requires you to download and place in your Materials/Figures/ folder a rather large set of image assets. These assets provide the editor's graphical user interface, as well as the glyphs for the Glimmr Image Font extension. If you don't have these images in the proper place, the extension will not be usable.

GCE generates source code for use with the Glimmr Canvas-Based Drawing extension. Note that the bitmap and image-map element types cannot be created using GCE.


Chapter: Including Glimmr Canvas Editor in a project

GCE includes all of the other Glimmr extensions you will need, so usually you will need to include only GCE:

	Include Glimmr Canvas Editor by Erik Temple.

This inclusion should be the first line after the project's title.


Chapter: Overview

A project built on Glimmr Canvas Editor opens with a short description and a few questions about the canvas that is being edited, as well as the name of the window in which it will be displayed. If you are not yet familiar with Glimmr canvases, please see the documentation for Glimmr Canvas-Based Drawing. Once these questions are answered, the screen clears and the graphical user interface for the canvas editor opens. This is where you will place, draw, and resize graphic elements to build your composition. You can also record different instances of movable or changeable elements.

The GUI operates alongside the standard IF command line interface, and most commands can be entered using either the buttons in the interface, or with typed commands. When a button is pressed, the command is also printed at the command line, making it easy to learn the typed commands if you wish to.

When you have completed the composition, hit the generate source code button to write an external file with valid I7 source code that replicates your design.


Section: A note on the documentation

Glimmr Canvas Editor has a graphical user interface that it is hoped will make it more easily approachable than a largely text-based command interface would be, at least for users who are familiar with Glimmr canvas-based drawing. This documentation will not cover most of the commands available in GCE in detail, with the understanding that the user will be able to explore the GCE GUI to discover commands.

Instead, the documentation will, after providing a general introduction to the user interface, focus on elements of the editor that may be obscure or non-obvious. A later chapter details the customization options available for GCE projects.


Chapter: Glimmr Canvas Editor


Section: Introductory questionnaire

When a GCE project opens, the user is presented with a set of three questions about the canvas to be built. This questionnaire can be skipped by typing SKIP at any of the prompts, and all of the parameters set by the answers can also be set by commands within the editor.

 The first question requests the name of the canvas (e.g., "graphics-canvas" or "my canvas"). This is used solely in the output source code. To change the name of the canvas from within the editor:

	RENAME CANVAS <new name>

The default is "graphics-canvas," and this will be the name of the canvas if the question is SKIPped.

The next two questions ask for the width of the canvas and the height of the canvas. If the provided dimensions define a portrait orientation (that is, the height is greater than the width), the editor will open with the windows configured to provide a full landscape view. If instead a landscape orientation (width greater than height) is defined, the windows will be arranged to allow a landscape view. If SKIPped, the default values will produce a landscape orientation. To change the dimensions of the canvas from within the editor:

	RESIZE CANVAS TO <width> BY <height>
		or 
	CANVAS WIDTH <number>
	CANVAS HEIGHT <number>

If we have changed from a portrait to landscape canvas orientation or vice versa, we can type

	REBUILD WINDOWS

to rearrange the editor windows to better accomodate the new orientation.

After the three questions have been answered, press any key to proceed to the editor proper.


Section: Editor window

The editor window is the centerpiece of the editor, where the canvas and its elements will be built up and edited. Initially, it shows only the outline of the canvas. Elements can be placed anywhere on the screen, but only elements that appear within the bounds of the canvas are guaranteed to appear in the display.

There are three main modes for working with the editor window. These three modes are defined by the three main tabs in the control panel window (see below). They are: Moving, Selecting, and Scaling:

	Moving - When the editor is in Move mode, a click in the editor window will move any selected elements to the position indicated. If no elements are selected, clicking on an element will select it.

	Selecting - When the editor is in Select mode, clicking on any unselected element will select that element; click on multiple unselected elements in succession to select them all. Clicking on a selected element will deselect it. Clicking in the empty space between elements will deselect all elements.

	Scaling - When the editor is in Scale mode, a click in the editor window will attempt to scale the selected element. (If no elements are selected, clicking on an element will select it.) Elements can be scaled symmetrically (i.e., retaining the aspect ratio) or asymmetrically. To scale an element, click to the right and down from origin (the upper left corner) of the element to indicate where the lower right corner of the element should be. A box will appear around the element to indicate the new size and, if scaling asymmetrically, the new shape of the element. If scaling symmetrically, only the width input will be considered; a new height will be calculated for the element based on the aspect ratio. In this case, the box (ideal) will not coincide with the shape of the resized element (actual). Note that only image-based elements (sprites and image-rendered strings) can be scaled using the GUI.

The editor window is also used for drawing elements. Elements can be drawn to the window while in any of these three modes. See the section on the drawing panel for details.


	--- Canvas scaling and zoom ---

GCE will function regardless of whether there is room in the window to display the full canvas without scaling; if need be, the canvas will be scaled to fit in the window. When the canvas has been scaled down to fit the window, the ZOOM command becomes available. ZOOM toggles back and forth between 100% (unscaled) and the scaled view. Zoom is also enabled by oversize scaling.

Zoom can be invoked either by typing ZOOM or by clicking on the magnifying glass icon in the control panel (located beneath the tab area); the icon appears only when zoom is available. If an element is selected, the zoomed view will be centered on that element. If no element is selected, zoomed view will be centered on the center of the canvas.

Information on the canvas and the scaling ratio can be got by typing INFO or by clicking on the info icon I underneath the tab area in the control panel window.


	--- Hiding and deleting elements ---

Elements in the editor window can be hidden as needed. This may be useful when elements overlap. To hide elements, select the desired elements and either:

	Type HIDE
		or
	Click Control panel -> Select tab -> Hide

Hidden elements remain associated with the canvas and will appear in the source code output. To remove an element completely, DELETE it.

To reveal hidden elements, type SHOW or click Control panel -> Select tab -> Show. A menu will appear listing the hidden elements. Type the number corresponding to the hidden element to reveal it.

All hidden elements can be revealed at once by typing SHOW ALL (Control panel -> Select tab -> Show All). 


	--- Background image ---

The canvas can be defined by using a background image. To do this, be sure the image you want to use as a background is included in the project (see the chapter on Setting up a GCE project below). From the image library (see below for more on the image library), select the image you want to use. It will appear in the center of the canvas. The image should be selected. If it isn't, select it and then either:

	Type MAKE BACKGROUND
		or
	Click Control panel -> Settings -> Make Background Image

To remove the background, type REMOVE BACKGROUND or click the Remove Background Image button.

Setting a background image will change the dimensions of the canvas to match those of the image. After having set the background image, we can adjust the dimensions manually (see the Introductory Questionnaire section above for instructions on resizing the canvas from within the editor). If we do manually resize the canvas while it has a background image, there are two potential outcomes depending on whether we have allowed oversize scaling in the editor window:

	* with oversize scaling: the background image will be stretched to fit the canvas dimensions

	* without oversize scaling: the background image will remain unscaled in the upper left corner of the canvas

To toggle oversize scaling, use the typed command:
	
	TOGGLE OVERSIZE SCALING
		or
	OVERSIZE

Note that, when oversize scaling is on, the default view of the editor window may be scaled to greater than 100%, depending on the size of the window. Typing ZOOM will toggle between 100% and oversized scaling.


Section: Control panel

The control panel is located below left (landscape orientation) or below right (portrait orientation) of the editor window. It includes most of the buttons used to issue commands to the editor.

There are three main parts to the control panel:

	Tab Area - The tab area is the central portion of the control panel. There are three tabs, each associated with one of the three main editor modes: moving, selecting, and scaling. (See the editor window section above for more on editing modes.)

	Pop-Up Menus - There are three buttons that open pop-up menus. These are located along the right side of the tab area. They are, from top to bottom, the Settings menu (gear icon), Source Code menu (document icon), and Tools menu (wrench icon).

	Control Buttons - These buttons are found below the tab area, on the left side. These buttons are divided into two groups. The group on the left affect elements, while the buttons on the right affect the user interface. 

Quick descriptions of these controls follow:


	--- Tab Area ---

When a tab is selected in the control panel, the editor window will respond according to the behavior for the selected mode. In other words, when the Move tab is selected, clicking in the window will move selected elements around. While the Select tab is active, clicking in the editor window selects and deselects elements.

Different controls are shown in each of the tabs. Under the Move tab, there are four buttons for nudging an element (or elements) a certain number of pixels (canvas units) in any direction. Set the nudge amount using the button alongside the Nudge controls. There are also four buttons that allow an element to be Aligned with one edge of another element, and a button that will Center one element on another.

Under the Select tab, we can not only select elements based on certain attributes (such as kind or the display-layer) and hide or reveal them, we can also add a "graphlink" to an element. Graphlinks are "graphic hyperlinks", allowing that the element will respond to mouse input. When a graphlink is added to an element, GCE will ask you to provide a replacement command--this command will be issued on behalf of the player when she clicks on the element. There are also settings in the Select tab for the styling of hyperlinks.

The Scale tab provides controls for making scaling Symmetrical or Asymmetrical, and for scaling numerically rather than by resizing the element visually in the editor window. We can also set the default scaling factor (usually 1.0000, that is, 100%). All new elements created will be scaled by this amount (note that this will affect the size of image-based elements only; rectangle-based elements will see their line weight changed by the scaling, nothing else).


	--- Pop-Up Menus ---

The button with the gear icon brings up the Settings menu, where we can set or remove the background image for the canvas, if desired, or toggle the outline that indicates the boundaries of the canvas in the editor window (the canvas outline is not included in the output source--it is strictly a part of the GCE user interface). There is also a button to list the available color names (see section on Customizing Colors below). These color names can be used in a number of text-only commands to change both UI and elements colors; the LIST COLORS button/command provides a list of these.

The next icon, a page or document, represents the button for the Source Code menu. Here, source code can be generated--that is, written to an external file--or previewed within the editor itself. If written to an external file, that file will be called "GlimmrSource". Your interpreter may or may not append a file extension, but the file is a plain text file. Interpreters will also vary in where they save the file: some will save it to the same file as the project's gblorb, but others will save it to your home folder, or even to the root of your hard drive.

Source code can be produced in two styles, tabular or paragraphed. In tabular style, elements are defined using tables, a more succinct method that is generally to be preferred. In paragraphed style, each element is defined in its own paragraph of source code.

The final button, with an icon of a wrench, opens the Tools menu. In this menu, there are controls for renaming elements, adding or changing the sub-kind of the element, tagging elements, and instancing elements. See the Advanced Topics below for more on kinds & sub-kinds, tags, and instances.


	--- Control Buttons ---

The two buttons in the left-hand groups act on elements. The X button deletes the selected element(s), while the I button provides information about them. (When pressed without elements selected, the I button will display information about the canvas.)

The right-hand group are user interface buttons. The pencil button toggles the drawing toolbar (see below). The magnifying glass button, which appears only when zoom is available, toggles the zoom state. See the Canvas Scaling and Zoom section under the editor window above for more information about zooming.


Section: Drawing toolbar

The drawing controls are located at the bottom of the editor window. They can be removed if desired by clicking on the X on the right edge of the drawing controls toolbar, or by clicking on the drawing icon (a pencil) beneath the tab area in the control panel window. The drawing icon will also restore the toolbar if it has been removed.

The drawing controls allow for drawing any of four types of primitive (line, rectangle, box, and stroked rectangle), or for painting bitmap-based and image-based text strings. Click on the appropriate button and follow the onscreen instructions to create a drawing object.

The drawing toolbar also allows us to set the foreground and background colors for a drawn object (in the language of Canvas-Based Drawing, these are the "tint" and "background tint" properties). To set the color for an object, select the object and click on the square next to the color you wish to change. A selection of color chips appears; click to select the color. The red slash indicates no color. Element colors can also be changed using typed commands, if you know the color name:

	CHANGE ELEMENT FOREGROUND COLOR TO <color name>
	CHANGE ELEMENT BACKGROUND COLOR TO <color name>

Note that the background color only affects the stroked rectangle (it specifies the color of the stroke) and the text elements. The foreground color affects all drawn elements except the image-based string, the color of which is provided by the images that make it up. 

The drawing toolbar also allows for changing the weight of the line used to draw the line, box, and stroked rectangle primitives, as well as the bitmap-based text string. Click on the button to set the line weight.

Finally, for text strings we can set the alignment: left-aligned (the default), center-aligned, or right-aligned. Click on the appropriate icon to set the alignment.


Section: Text input window 

The text input window acts as a log of actions that have been performed, and can also be used as a command-line alternative to the control panel and drawing controls. (The SCRIPT ON command can be used to produce a more permanent log, if desired.) Nearly all commands can be entered at the command line rather than using the GUI. The exceptions are (1) the GUI selection, movement, and scaling commands, as described under the editor window section, and (2) creation of a new sprite from the image library, which requires clicking on the image in the library.


	--- Commands with no GUI counterpart ---

There are also a few commands that have no counterpart in the GUI. Here is the list of such commands:

	UNDO
	SAVE
	RESTORE
	RENAME CANVAS <text>	
	RESIZE CANVAS TO <width> BY <height>
	CANVAS WIDTH <number>
	CANVAS HEIGHT <number>
	REBUILD WINDOWS
	TOGGLE OVERSIZE SCALING
	CHANGE STROKE HIGHLIGHT COLOR TO <color name>
	CHANGE CANVAS BACKGROUND COLOR TO <color name>
	CHANGE CANVAS OUTLINE COLOR TO <color name>
	CHANGE ELEMENT FOREGROUND COLOR TO <color name>
	CHANGE ELEMENT BACKGROUND COLOR TO <color name>

These are discussed in various places through the course of this documentation. 


	--- Command abbreviations ---

Some of the more common operations have radically shortened forms for quick entry into the text input window. Here is a list:

	M : MOVE MODE
	S : SELECT MODE
	X : SCALE MODE

	A : SELECT ALL
	D : DESELECT ALL

	DEL : delete selected element

	I : INFO

	+ : ZOOM (IN)
	- : ZOOM (OUT)

	L <number> (when an element is selected) : place element on the given display:layer
	L <number> (when nothing is selected) : change current layer to number given

	C : duplicate selected element

	R <reference name> : register an element instance with the reference name provided

	T <reference name> : tag selected element with reference name provided

	G : repeat last command

	Z : undo last command
	

Section: Status line

The status line appears immediately above the text input window, as in your standard IF layout. Its function in GCE is to display basic information about the selected elements. On the left hand side, the name of the element is given, while the right side indicates the origin coordinates. The central part of the status line indicates the kind of the element and, if a sub-kind has been defined, this is also indicated. (See below for information on sub-kinds.)

When no elements are selected, the central part of the status line displays the canvas dimensions, and the right-hand part gives the scaling ratio (as a percentage to economize on space).

All of the information in the status line and more can be accessed by typing INFO or by clicking on the info icon I underneath the tab area in the control panel window.


Section: Layers window

The layers window is a narrow vertical window on the left side of the editor screen. The layers window presents a visual representation of the canvas's display-layers. The display-layer of a graphic element represents its z-coordinate: an element on layer 2 will be drawn after--and appear "on top of" an element drawn on layer 1.

GCE makes available 24 display-layers. The layers window displays as many of these as are actually in use, starting from the bottom of the window and moving up as new layers are assigned. Each layer is shown as a sphere. When there is at least one selected element on a layer, a blue dot will appear at the center of the sphere.

One of the active display-layers will be identified as the "current display-layer". This is the layer on which new elements will be created (whether using the drawing tools or by selecting an image from the image library). The current display-layer is indicated in the layers window by a gray shadow behind the layer's spherical indicator. To designate a layer as the current layer, click on that layer's sphere.

At the top of the layers window is an icon in the form of an eye. This button toggles "layer reveal mode." When activated, layers reveal mode places a badge in the upper left corner of each element in the editor window. The number on the badge indicates that element's display-layer.

To move elements between layers, select multiple elements and either:

	type MOVE TO LAYER <number>
	type LAYER <number>
	type L <number>
		or
	press the Move to Layer button under the Move tab

To change the current layer using a typed command rather than clicking as described above:

	DEFAULT LAYER <number>


Section: Image library window

The image library will only appear if the project includes custom images (see below). The image library displays a grid of all of the available custom images. If there are more images available than will fit in the window, multiple "pages" will be generated; move between these pages by clicking on the arrows that will appear (as needed) in the window header. 

Clicking on an image in the library will create a new sprite element in the editor window using that image. We can create as many sprites as we like from a single image. The new sprite will be created on the current display-layer (see the Layers Window section above), and will be named after the figure that spawned it. For example, if we have an image in the library that was defined as Figure of Bird, the second sprite created from it would be called "Bird_2". Use the Rename command to change the name as desired:

	RENAME <new name>
		or
	click Control panel > Tools pop-up menu -> Rename element 


	--- Reassigning a sprite's identity ---

The image associated with a sprite element is known as the sprite's image identity, or "image-ID". The image-ID, like any other property, can be changed during the course of a story, and it can also be changed in GCE. This is most likely to be useful when combined with instancing (see below): we may want a sprite to represent multiple images over the course of our game, perhaps in tandem with moving the element, scaling it differently, changing the associated graphlink command, etc. Any or all of these can done with instances. Use one of the following commands:

	REASSIGN IMAGE-ID
		or
	REASSIGN SPRITE IDENTITY
		or
	Control panel -> Tools menu -> Change Identity button


Chapter: Advanced topics

Section: Kinds and Sub-kinds

All elements added to the canvas in GCE are members of one of the following hierarchies of kinds:

	object -> thing -> g-element -> sprite
	object -> thing -> g-element -> primitive -> (rectangle, box, line, stroked rectangle)
	object -> thing -> g-element -> rendered string -> (image-rendered string, bitmap-rendered string)

When an element is selected, the status line identifies the most specific kind in the hierarchy, such as sprite, rectangle primitive, or bitmap-rendered string.

GCE allows us to add one additional layer to the hierarchy for any element. For example, we may want to make subsets of the sprite class:

	object -> thing -> g-element -> sprite -> room-sprite
	object -> thing -> g-element -> sprite -> person-sprite

Now we have two sub-kinds--room-sprite and person-sprite--that serve to distinguish sprites representing rooms from sprites representing people. This kind of division, which we will call the "sub-kind" for brevity's sake, is quite useful. We can, for example, write rules referring to the sub-kinds to treat different types differently, e.g.:

	Carry out exploding the atom bomb:
		repeat with vaporized running through person-sprites:
			deactivate vaporized.

When the selected element has a sub-kind, the status line will show both the sub-kind and the parent kind, e.g. "sprite -> room-sprite". In the output source code, sub-kinds are defined separately from other sub-kinds and from their parent kinds: 

	A room-sprite is a kind of sprite. The graphlink status of a room-sprite is g-inactive. The associated canvas of a room-sprite is graphics-canvas. 

	Orthogonal_room_hexagonal_1 is a room-sprite. The image-ID is ...

Only one level of sub-kind can be defined for an element within GCE. We couldn't, for example, add a second level within room-sprites. This is an arbitrary limit--selected to keep things as simple as possible--and any number of levels can be edited into the output source code if we wish. 

To add a sub-kind to an element or group of elements:

	1) Select the element(s) to be subclassed.
	2) Choose Control panel -> Tools menu -> Change Kind, or type KIND.
	3) When prompted, type the name of the sub-kind, e.g. "room-sprite".

Steps 2 and 3 can be combined by typing KIND <name>, e.g. "KIND ROOM-SPRITE".

Once a sub-kind has been assigned, it cannot be rescinded, though the name can be changed following the same steps.


Section: Tags

GCE allows us to assign a "tag" to any element. The tag is just arbitrary text, but it will be treated as a property of the element in output source code. Effectively, then, the tag allows us to add a custom property to elements and specify its value within the editor. For example, the example code below adds a tag to each sprite element that is translated in the source code as the "associated room" of the element. To activate all of the sprites associated with a given room simultaneously, we can use this property like so:

	This is the update map sprites rule:
		 repeat with current-element running through display-inactive room-elements:
			  if the associated room of current-element is the location:
				   activate current-element.

To apply a tag to an element, type TAG or select Control panel -> Tools menu -> Tag, and enter the tag text when prompted. A shorter form is simply to type TAG <name>, e.g. "TAG LOUNGE" to tag the element with "LOUNGE".

To delete the tag from an element, type DELETE TAG or select Control panel -> Tools menu -> Delete Tag.

Tags must be properly set up from within the source code of the GCE story file to function as expected. See the section on setting up tags below.


Section: Instances

One of the main reasons for the existence of Glimmr is to enable authors to create *dynamic* on-screen compositions using multiple discrete elements. GCE introduces the notion of "element instances" to make it possible to mark different values for attributes for the same element, such as different origin coordinates, scaling factors, and so on. 

Element instances are not visible in the editor. Instead, when an instance is registered, all of its major properties are saved, with a particular instance name (the "reference") provided by the user. Here, for example, is a short list of instances for the sprite "Player Avatar":

	sprite	reference	origin	image-ID	display-layer	scaling factor	linked replacement-command
	Player Avatar	Large Room	{149, 162}	Figure of Player Icon Alternate	2	1.0000	""
	Player Avatar	Round Room	{233, 263}	Figure of Player Icon Alternate	2	1.0000	""
	Player Avatar	Rough Room	{285, 227}	Figure of Player Icon Alternate	2	1.0000	""

Player Avatar is a sprite that represents the location of the player character in an onscreen map. Each instance was registered with the icon overlaid on a different room's sprite representation, and the room names were used for the instances' reference names. Notice how the origin coordinates change along with the room names.

Because there are many different ways in which this information about element dynamics could be used, it is provided as a simple table of attributes (commented out) rather than as compilable source code. The table data may be copied and pasted into Excel, Numbers, or Google Spreadsheets to easily select and manipulate the attribute information as needed.

To register an instance, select the element you want to register and type REGISTER, or just R. You will be asked to input a reference ID for the instance. This can be a name (like the room names in the example above), a number, or whatever you like. This can also be done in one command, by typing REGISTER <reference> or R <reference>, e.g.:

	REGISTER ROUND ROOM
	R ROUND ROOM

To see the list of instances recorded for an element, select that element and type INSTANCES. 

To delete an instance, select the element and type DELETE INSTANCE. A menu appears, listing all of the instances of the selected element. Enter the number of the instance you wish to delete and press return. Once deleted, an instance cannot be restored, though instance deletion can be UNDOne.

It is possible to create a new element from any instance. To do so, select the instanced element and type LOAD INSTANCE. A list of available instances is presented, and you are asked to type the number of the desired instance. Once you enter that number, a new element will appear that has all of the properties of the selected instance. Note that this is a new element, one with no instances, and that the old element--and the instance that spawned the new element--remain intact.

When an element is destroyed, all of the instances of that element are also destroyed.


Chapter: Setting up a GCE project

Minimally, all that is required to create a GCE project is the line "Include Glimmr Canvas Editor..." in an otherwise empty Inform project (with all of the required image assets must be in the project's Materials>Figures folder). This will serve to allow the user to draw basic shapes and text strings in a handful of colors.

Most users, however, will want a bit more to work with, and the following sections explore some of the customizations that are possible.

Section: Working with image files

The most commonly used elements in GCE are anticipated to be sprites (that is, image files). To include some image files that you'd like to work with, declare a list of figures as you would for any other I7 project. For example:

	Include Glimmr Canvas Editor by Erik Temple.

	Figure of Orthogonal Room Square is the file "Orthogonal Room Square.png".
	Figure of Orthogonal Room Horizontal is the file "Orthogonal Room Horizontal.png".
	(and so on...)

(These images come from the package of floor plan images that I've included with GCE. The example code below uses these images.)

Figures must be declared *after* the inclusion of the extension or problems with result.

The images you've declared here will appear in the "Image Library" window on the right side of the editor when you compile your project. You can click on an image to add a sprite based on that image to the canvas.

GCE projects can be distributed as compiled graphic toolkits, with a selection of images that work well together for a given purpose. The example provided 


Section: Setting canvas parameters

When a GCE project is first run, the user is asked to answer a short questionnaire to define the basic parameters of the canvas. If we want to avoid this, we can set these parameters directly. The canvas for the editor is called the "editor-canvas", and we can set the canvas dimensions directly:

	The canvas-width of the editor-canvas is 600.
	The canvas-height of the editor-canvas is 450.

We can also set the name of the g-window that the source code will produce:

	The targeted canvas is "graphics-canvas".

We can also set the window's background color from the source code--see the following section on colors.


Section: Customizing colors

Colors in Glimmr are used primarily for the backgrounds of windows, and for the colors of drawn elements such as rectangles, lines, and text elements. There are also a couple of UI elements within GCE that can be set using glulx color values. GCE and Glimmr Canvas-Based Drawing--which is the extension that GCE compiles its code to work with--use "glulx color values" to specify colors. The glulx color value type is defined in Emily Short's Glulx Text Effects extension, and it provides a color name to stand in for far less grok-able color numbers that Glulx understands. By convention, glulx color values are written as a single (run-together) word prefaced with "g-".

All glulx color values must be specified in advance (that is, before the project is compiled). A few colors are already available by virtue of the extensions included in GCE (see the list below). If you want to use others, you will need to add them yourself.

To add colors to GCE, we must first declare the colors. This is done by extending the Table of Common Color Values (see Glulx Text Effects for more on this), for example:

	Table of Common Color Values (continued)
	glulx color value	assigned number
	g-AliceBlue	15792383
	g-AntiqueWhite	16444375
	g-Aqua	65535
	g-Aquamarine	8388564

Once the colors have been declared, we can define how they are to be used. The most important to do in the source code of our project--since it cannot be done from within the compiled editor--is the list of drawing colors. These are the colors that are will appear as color chips in the drawing panel; for space reasons we should not choose more than perhaps 25 of them. To define the drawing colors, insert something like this in your source code:

	The drawing colors are {	g-Black, g-White, g-Red, g-Orange, g-Yellow, g-Green, g-Blue, g-Indigo, g-Violet}.

Note that any glulx color value can be used for drawing, but only those in the drawing list will appear as color chips in the GUI. To access other colors, we need to use textual commands.

If desired, we can also specify the initial foreground and background colors (these are the colors that the drawing tools will be initialized with):

	The current element color is g-White.
	The current element background color is g-Black.

To set the background color of the main editor window, which will also be reflected in the source code output by GCE:

	The back-colour of the editor-window is g-Indigo.

Finally, there are two user interface colors that we can change as desired. These are the stroke highlight color (the color used to draw a stroke highlight surrounding a selected element) and the canvas outline color, used to mark the boundaries of the canvas. To change these in the source code of our project:

	The highlight-color is g-CornflowerBlue.
	The canvas outline-color is g-Yellow.


Section: Setting editor defaults

A few other options are available, some of which can also be changed while the editor is running.

Two settings which cannot be changed in the editor are the scaling limits. These numbers indicate minimum and maximum acceptable scaling factors--how big or small we can scale an element.

	The lower scaling-limit is 0.1000.
	The upper scaling-limit is 2.0000.

We can also set the number of canvas units that each press of a nudge button will move the selected elements:

	The nudge factor is 1.

This setting can also be changed from within the editor, as can the default scaling factor for elements, which we can also set from our project's source code:

	The default scaling factor is 1.0000.


Section: Setting up tags

It is not necessary to set up tags, but it is the only way to specify in advance what you want to use them for. This saves you a little work in tweaking the output source code. There are generally just two parameters to be set.

All tags in a GCE project will represent the same thing--a property of a g-element. For example, we might want to associate elements with game locations via a property of the room type--this element is assigned to this room, e.g.:

	A g-element has a room called the associated room.

To accomplish this, we identify the name of this property using the "tag alias":

	The tag alias is "associated room".

The "tag type" identifies the Inform 7 named type of the property:

	The tag type is "room".

Now all of our tags will be written into the source code as if they were properties containing a room.

Note: If we do not set up our tags before running GCE, the output source code will use "text" for the tag type and "tag" for the tag alias, giving us:

	A g-element has a text called the tag.

(There is a third parameter, the "tag-surround," which is intended to provide a single character to be printed on either side of a tag's value in the output source code. For text or indexed text tags, this is automatically set to the quotation mark. It probably has no other use.)


Section: Customized instructions

It is possible to provide customized text at the startup of a project built with GCE. This is intended primarily for toolkits--like the Basic Floorplan toolkit, the code for which is presented as the example below--that are distributed as compiled builds. This text is called the "user-specified startup text", and will be printed after the initial paragraph that begins "Welcome to the Glimmr Canvas Editor". To add this text:

	The user-specified startup text is "This is my custom UI creation toolkit. Enjoy!".

To *replace* the standard introductory text rather than add to it, we can change the "startup text" and "startup instructions text variables". See the source code of the extension for the default content of these variables.


Section: Customized source code

We may also specify our own text to be output as source code from GCE. This is again intended for GCE toolkits, precompiled builds of GCE that include images and so on that might be useful across a range of projects. To inject our own source text, we set the "user-specified source text" variable. See the example toolkit code below.


Section: Using alternate fonts

Glimmr Canvas Editor requires exactly one bitmap font and one image font to work. By default, these are the fonts available in the Glimmr Bitmap Font and Glimmr Image Font extensions. However, you may change the fonts by replacing the Fonts chapter section of the GCE extension. Here is an example:

	Chapter - My Fonts (replaces Chapter - Fonts in Glimmr Canvas Editor by Erik Temple)

	Include Bubble Blob Bitmap Font by Erik Temple.
	Include Gloopy Glop Image Font by Erik Temple.

	To decide what text is the extension-name of (typeface - a font):
		if the typeface is Gloop Glop:
			decide on "Gloopy Glop Image Font by Erik Temple";
		if the typeface is Bubble Blob:
			decide on "Bubble Blob Bitmap Font by Erik Temple";
		decide on "".
	
	The associated font of a bitmap-rendered string is usually Bubble Blob.
	The associated font of an image-rendered string is usually Gloopy Glop.

First, include your font extensions. Then, provide a decide phrase like that given here, so that the source code generator will know what to write (Inform cannot directly access the names of extensions). Finally, set the "associated font name" of your font(s) to the appropriate value.

For information on how to create your own fonts for use with Glimmr, see the documentation for Glimmr Drawing Commands.


Chapter: Performance

GCE should be run on relatively modern hardware, using the newest available interpreters; a number of interpreters have had bug fixes and preformance enhancements in recent months and will run this and other Glimmr game files much better than older versions.

Glimmr Canvas Editor functions much better in a release build, opened with an external interpreter, than it does when run from within the Inform IDE. Running it in the IDE is not to be recommended in any case, since the window should be maximized to the fullest extent possible.

Note that, in the Mac Inform IDE, there is a *significant* delay upon entering the editor. During this delay, commands can be entered, but clicks in the GUI will appear to do nothing. These clicks are in fact being registered, however, and will generate actions after the delay is complete. It is best to make a single click when the editor loads, then wait for that click's result to appear before continuing.


Chapter: Debugging

At present, no debugging features are associated with Glimmr Canvas Editor, and the extension makes no output to the Glimmr debugging log.


Chapter: Contact info

If you have comments about the extension, please feel free to contact me directly at ek.temple@gmail.com.

Please report bugs on the Google Code project page, at http://code.google.com/p/glimmr-i7x/issues/list.

For questions about Glimmr, please consider posting to either the rec.arts.int-fiction newsgroup or at the intfiction forum (http://www.intfiction.org/forum/). This allows questions to be public, where the answers can also benefit others. If you prefer not to use either of these forums, please contact me directly via email (ek.temple@gmail.com).


Chapter: Change Log

Version 2: Updated for 6G60. Fixed a number of bugs. See Issues 7, 8, 11, 14, 15, 16, 17, 19, and 23 at http://code.google.com/p/glimmr-i7x/issues/list.

Version 1: Initial release.


Example: *** Basic Floorplan Toolkit Example - A toolkit including images for use in constructing basic floorplans for indoor maps, as well as illustrating most of the basic options available. Also illustrates user-specified source text and tags to create automatic mapping capabilities. This example is a bit different from the released Basic Floorplan Toolkit gblorb file, in that it contains a small map to be used as reference while you draw. Type MAP to see the geography.

Most of the available settings are included in the code, most just restating the defaults.


	*: "Basic Floorplan Toolkit"
	
	Include Glimmr Canvas Editor by Erik Temple.
	
	Figure of Orthogonal Room Square is the file "Orthogonal Room Square.png".
	Figure of Orthogonal Room Horizontal is the file "Orthogonal Room Horizontal.png".
	Figure of Orthogonal Room Vertical is the file "Orthogonal Room Vertical.png".
	Figure of Orthogonal Room Round is the file "Orthogonal Room Round.png".
	Figure of Orthogonal Room Hexagonal is the file "Orthogonal Room Hexagonal.png".
	Figure of Orthogonal Hall Horizontal is the file "Orthogonal Hall Horizontal.png".
	Figure of Orthogonal Hall Vertical is the file "Orthogonal Hall Vertical.png".
	Figure of Orthogonal Hall NW to SE is the file "Orthogonal Hall NW to SE.png".
	Figure of Orthogonal Hall SW to NE is the file "Orthogonal Hall SW to NE.png".
	Figure of Orthogonal Long Hall NW to SE is the file "Orthogonal Long Hall NW to SE.png".
	Figure of Orthogonal Long Hall SW to NE is the file "Orthogonal Long Hall SW to NE.png".
	Figure of Orthogonal Curve N to E is the file "Orthogonal Curve N to E.png".
	Figure of Orthogonal Curve S to E is the file "Orthogonal Curve S to E.png".
	Figure of Orthogonal Curve W to N is the file "Orthogonal Curve W to N.png".
	Figure of Orthogonal Curve W to S is the file "Orthogonal Curve W to S.png".
	Figure of Rough Room Square 01 is the file "Rough Room Square 01.png".
	Figure of Rough Room Square 02 is the file "Rough Room Square 02.png".
	Figure of Rough Room Horizontal is the file "Rough Room Horizontal.png".
	Figure of Rough Room Vertical is the file "Rough Room Vertical.png".
	Figure of Rough Room Circular is the file "Rough Room Circular.png".
	Figure of Rough Hall Horizontal is the file "Rough Hall Horizontal.png".
	Figure of Rough Hall Vertical is the file "Rough Hall Vertical.png".
	Figure of Rough Hall NW to SE is the file "Rough Hall NW to SE.png".
	Figure of Rough Hall SW to NE is the file "Rough Hall SW to NE.png".
	Figure of Rough Long Hall Horizontal is the file "Rough Long Hall Horizontal.png".
	Figure of Rough Long Hall Vertical is the file "Rough Long Hall Vertical.png".
	Figure of Rough Long Hall NW to SE is the file "Rough Long Hall NW to SE.png".
	Figure of Rough Long Hall SW to NE is the file "Rough Long Hall SW to NE.png".
	Figure of Rough Curve N to E is the file "Rough Curve N to E.png".
	Figure of Rough Curve S to E is the file "Rough Curve S to E.png".
	Figure of Rough Curve W to N is the file "Rough Curve W to N.png".
	Figure of Rough Curve W to S is the file "Rough Curve W to S.png".
	Figure of Door Horizontal is the file "Door Horizontal.png".
	Figure of Door NE to SW is the file "Door NE to SW.png".
	Figure of Door NW to SE is the file "Door NW to SE.png".
	Figure of Door Vertical is the file "Door Vertical.png".
	Figure of Stair Circular is the file "Stair Circular.png".
	Figure of Stair Horizontal is the file "Stair Horizontal.png".
	Figure of Stair Vertical is the file "Stair Vertical.png".
	Figure of Occluder Square is the file "Occluder Square.png".
	Figure of Player Icon is the file "Player Icon.png".
	Figure of Player Icon Alternate is the file "Player Icon2.png".
	
	
	Table of Common Color Values (continued)
	glulx color value	assigned number
	g-Orange	16753920
	g-Violet	15631086
	
	
	The drawing colors are {
	g-Black,
	g-White,
	g-Red,
	g-Orange,
	g-Yellow,
	g-Green,
	g-Blue,
	g-Indigo,
	g-Violet,
	g-Dark-Grey,
	g-Medium-Grey,
	g-Light-Grey
	}.
	
	The current element color is g-White.
	The current element background color is g-placeNULLcol.
	
	
	Section - Notices
	
	Definition: A figure name is room-related if it is not Figure of Player Icon and it is not Figure of Player Icon Alternate.
	
	After spawning sprites when the image-ID of the current graphlink is room-related:
		say "(Sub-kind automatically set to [italic type]room-element[roman type] to enable proper functioning of the automated revelation of the map as the player moves through it. [bold type]TAG[roman type] the sprite with the name of the room that should reveal it. If the sprite is not intended to be part of the map, you may want to change the sub-kind, by typing [bold type]KIND <new sub-kind name>[roman type].)";
		now the of-kind of entry 1 of element-selection set is "room-element".
	
	Report spawning sprites when the image-ID of the current graphlink is not room-related:
		say "You have selected an image that can be used to represent the player's position on the map. To use the built-in Basic Floorplan Toolkit functionality for automatically moving the sprite around the map, you must rename the sprite as 'PC Avatar'. Type [bold type]RENAME PC Avatar[roman type] now to do this."
	
	
	Section - Custom text and source
	
	The tag type is "room".
	The tag alias is "associated room".
	
	The user-specified startup text is "Basic Floorplan Toolkit is a special edition of Glimmr Canvas Editor optimized for the creation of simple floorplans. It includes a set of images representing rooms, hallways, and other featuers. You are welcome to use these graphics in your own games.[paragraph break]Glimmr Canvas Editor can export nearly complete I7 source code that replicates whatever your create here for use in your game. There is a block of code included that lets you tag the elements you add to the editor with room names; when the player enters a room with the same name, the graphic(s) with that tag will be activated. This allows the map to reveal itself to the player as the PC moves through the world. To add a tag, select one or more elements and type TAG <room name> at the command line to 'tag' the selected elements with that name.[paragraph break]".
	
	The user-specified source text is "Chapter - Basic Floorplan Toolkit Figures[paragraph break][figure-list A][figure-list B][line break]Chapter - Associating rooms with elements[paragraph break][bracket]This code assumes that each sprite that forms the map has been given the kind [quotation mark]room-element[quotation mark] and that each has also been tagged with the name of the room that should trigger its display. It further assumes that there exists an element that represents the avatar of the player, given the name [quotation mark]PC avatar[quotation mark], and that there is a table called the Table of Avatar Coordinates that consists of a column of room names (the locale column) and a column of the coordinates for the avatar that correspond to the avatar. These columns can easily be extracted from the instances data, provided an instance of the avatar has been recorded in advance for each room.[close bracket][paragraph break]The update map sprites rule is listed in the carry out looking rules.[line break]This is the update map sprites rule:[line break][tab]repeat with current-element running through display-inactive room-elements:[line break][tab][tab]if the associated room of current-element is the location:[line break][tab][tab][tab]activate current-element;[line break][tab]if there is a locale of the location in the Table of Avatar Coordinates:[line break][tab][tab]choose row with a locale of the location in the Table of Avatar Coordinates;[line break][tab][tab]change the origin of the PC avatar to the coord entry;[line break][tab]follow the window-drawing rules for the graphics-window.[paragraph break]"
	
	To say figure-list A:
		say "Figure of Orthogonal Room Square is the file 'Orthogonal Room Square.png'.[line break]Figure of Orthogonal Room Horizontal is the file 'Orthogonal Room Horizontal.png'.[line break]Figure of Orthogonal Room Vertical is the file 'Orthogonal Room Vertical.png'.[line break]Figure of Orthogonal Room Round is the file 'Orthogonal Room Round.png'.[line break]Figure of Orthogonal Room Hexagonal is the file 'Orthogonal Room Hexagonal.png'.[line break]Figure of Orthogonal Hall Horizontal is the file 'Orthogonal Hall Horizontal.png'.[line break]Figure of Orthogonal Hall Vertical is the file 'Orthogonal Hall Vertical.png'.[line break]Figure of Orthogonal Hall NW to SE is the file 'Orthogonal Hall NW to SE.png'.[line break]Figure of Orthogonal Hall SW to NE is the file 'Orthogonal Hall SW to NE.png'.[line break]Figure of Orthogonal Long Hall NW to SE is the file 'Orthogonal Long Hall NW to SE.png'.[line break]Figure of Orthogonal Long Hall SW to NE is the file 'Orthogonal Long Hall SW to NE.png'.[line break]Figure of Orthogonal Curve N to E is the file 'Orthogonal Curve N to E.png'.[line break]"
		
	To say figure-list B:	
		say "Figure of Orthogonal Curve S to E is the file 'Orthogonal Curve S to E.png'.[line break]Figure of Orthogonal Curve W to N is the file 'Orthogonal Curve W to N.png'.[line break]Figure of Orthogonal Curve W to S is the file 'Orthogonal Curve W to S.png'.[line break]Figure of Rough Room Square 01 is the file 'Rough Room Square 01.png'.[line break]Figure of Rough Room Square 02 is the file 'Rough Room Square 02.png'.[line break]Figure of Rough Room Horizontal is the file 'Rough Room Horizontal.png'.[line break]Figure of Rough Room Vertical is the file 'Rough Room Vertical.png'.[line break]Figure of Rough Room Circular is the file 'Rough Room Circular.png'.[line break]Figure of Rough Hall Horizontal is the file 'Rough Hall Horizontal.png'.[line break]Figure of Rough Hall Vertical is the file 'Rough Hall Vertical.png'.[line break]Figure of Rough Hall NW to SE is the file 'Rough Hall NW to SE.png'.[line break]Figure of Rough Hall SW to NE is the file 'Rough Hall SW to NE.png'.[line break]Figure of Rough Long Hall Horizontal is the file 'Rough Long Hall Horizontal.png'.[line break]Figure of Rough Long Hall Vertical is the file 'Rough Long Hall Vertical.png'.[line break]Figure of Rough Long Hall NW to SE is the file 'Rough Long Hall NW to SE.png'.[line break]Figure of Rough Long Hall SW to NE is the file 'Rough Long Hall SW to NE.png'.[line break]Figure of Rough Curve N to E is the file 'Rough Curve N to E.png'.[line break]Figure of Rough Curve S to E is the file 'Rough Curve S to E.png'.[line break]Figure of Rough Curve W to N is the file 'Rough Curve W to N.png'.[line break]Figure of Rough Curve W to S is the file 'Rough Curve W to S.png'.[line break]Figure of Door Horizontal is the file 'Door Horizontal.png'.[line break]Figure of Door NE to SW is the file 'Door NE to SW.png'.[line break]Figure of Door NW to SE is the file 'Door NW to SE.png'.[line break]Figure of Door Vertical is the file 'Door Vertical.png'.[line break]Figure of Stair Circular is the file 'Stair Circular.png'.[line break]Figure of Stair Horizontal is the file 'Stair Horizontal.png'.[line break]Figure of Stair Vertical is the file 'Stair Vertical.png'.[line break]Figure of Occluder Square is the file 'Occluder Square.png'.[line break]Figure of Player Icon is the file 'Player Icon.png'.[line break]Figure of Player Icon Alternate is the file 'Player Icon2.png'.[line break]"


If we are compiling this GCE project strictly for our own use, we may want to include the map geography itself in the project, as a reference for our drawing. To do that, we paste in the relevant code from our game:

	*: Section - Map

	Entrance Chamber is a room. The heavy door is an open door. It is south of Entrance Chamber and north of Hall. Guard Room is east of Hall.	Up from Entrance Chamber is the Shaft. Watch Room is south of the Shaft. Up from Shaft is the Upper Chamber.	Flanking Chamber is south of Upper Chamber. North of Flanking Chamber is nowhere. West of Flanking Chamber is Upper Chamber. East of Upper Chamber is nowhere.


...and, some new commands to summarize the map for us:

	*: Section - Map summary

	Listing rooms is an action applying to nothing. Understand "rooms" or "list rooms" or "map" as listing rooms.

	Carry out listing rooms:
		let L be the list of rooms;
		remove fake-room_x from L;
		if the number of entries of L > 0:
			say "The following rooms have been defined:[paragraph break]";
			repeat with current-room running through L:
				say "[bold type][current-room][roman type][line break][list exits for current-room]";

	To say list exits for (R - a room):
		let begun be false;
		say "     ";
		repeat with way running through directions:
			if the room way from R is a room:
				say "[if begun is true]; [end if][italic type][if the door way from R is a door]door [end if][way][roman type] to [the room way from R][run paragraph on]";
				let begun be true;
		say ".";

