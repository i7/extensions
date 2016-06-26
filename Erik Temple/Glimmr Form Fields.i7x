Version 1/110103 of Glimmr Form Fields (for Glulx only) by Erik Temple begins here.

"Allows the author to define multiple fields for entering text in a graphics window. The basics of mouse and keyboard input are provided, including conversion of typed digits into numbers."


Chapter - Inclusion control

Include Glimmr Graphic Hyperlinks by Erik Temple.
Include Glimmr Canvas-Based Drawing by Erik Temple.
Include Glulx Input Loops by Erik Temple.


Chapter - Console settings
[This is a "macro" that allows the extension to identify itself in the Glimmr console window with fewer keystrokes on my part.]

To say FFs:
	say "[bracket]Glimmr FFs[close bracket]: ".


Chapter - Defining the window for char input (for use without Text Window Input-Output Control by Erik Temple)
[Char input (keystroke input) is only accepted in text windows. While it will appear that we are receiving input in our graphics window, this is illusory. We need always to have at least one open text window that can receive the player's keystroke input. We then process this input, outputting characters, via a rendered string element, to our graphics-window. The input-accepting window will almost always be the main-window, but if we are using Text Window Input-Output Control, it might be some other text window.]

The current text input window is a g-window variable. The current text input window is usually the main-window.


Chapter - Input field definition
[Any element can in principle serve as an input field. An element will be treated as an input field if it has the "form input" property set. 

To make things easier, we allow the user to, if desired, use a kind to define input fields. The input field is defined generically as a kind of g-element. The author will need to specify a more specific kind in her story text, e.g.:

	An input field is a kind of stroked rectangle primitive.

Another option, as always, is to write a custom element display rule for input fields.]

A g-element can be form input. A g-element is usually not form input.

An input field is a kind of g-element. An input field is usually form input. The graphlink status of an input field is usually g-active.

The linked replacement-command of an input field is usually "zenter zfield zinput".

A g-element has a rendered string called the input-stream.
A g-element has a number called the maximum length. The maximum length is usually 16.
A g-element has a g-element called the next-field. The next-field is usually g-null-element.

The current field is a g-element variable.


Section - Accepted control input

[The accepted control input serves as a gatekeeper for special characters, such as arrow keys. Any character code listed in this list will be allowed, and we will need special keypress-to-string conversion activity to deal with them.

It would be far better if we could set this property initially to a variable (like "current input list"), but Inform does not currently allow for the initial definition of a property to be a variable.]

A g-element has a list of numbers called the accepted control input. The accepted control input is usually {-2, -3, 3, 127, -6, -7, -8, -9}.

[-2    left arrow
 -3    right arrow
 -4	up arrow
 -5	down arrow
 -6    return
 -7	backspace/delete
 -8    escape
 -9    tab
-10   page up
-11   page down
-12   home
-13   end
   3	return/enter
127   backspace/delete ]


Section - Accepted standard input
[The accepted standard input is optional. If we include any numbers in this list, they will act, alongside the accepted control input list, as a filter. No characters outside of these lists will be passed on to the keypress-to-string conversion rules.]

A g-element has a list of numbers called the accepted standard input. The accepted standard input is usually {}.


Section - Numerical fields and filter
[A field can be identified as "numerical," in which case the typed string will automatically be converted into a number by the input interpretation rules (see below). Only numeric characters are counted—a pure text string will produce a value of 0.]

A g-element has a number called the associated value. A g-element can be numerical. A g-element is usually not numerical.

[A filter is provided that can be applied, if the author likes, to numerical fields. This filter will allow only digits and hyphen (minus sign) to be entered into the field. The filter itself can be customized as needed. Indeed, two phrases for customizing it are included; these will remove the hyphen from the allowed input—restricting the field to positive digits—or restore these characters to the filter if previously removed. To be effective, these phrases must be invoked before the numerical filter is applied to a field, e.g.:

When play begins:
	disallow negative values in numerical filter;
	repeat with item running through numerical g-elements[input fields, if using that kind]:
		now the accepted standard input of item is the numerical filter.]

The numerical filter is a list of numbers variable. The numerical filter is {45[hyphen for negative numbers], 48, 49, 50, 51, 52, 53, 54, 55, 56, 57}.

To disallow negative values in (filter - a list of numbers):
	remove 45 from the filter.

To allow negative values in (filter - a list of numbers):
	add 45 to the filter.


Chapter - Special input loop definition
[This creates an input loop especially for use with field input, using the Glulx Input Loops extension.]

The field char input is an input-loop. The focal event type is char-event.


Section - Input loop event handling rules
[These rules hook into the functionality provided by the Glulx input loops extension. They allow us to "pre-handle" input, flagging it as non-char input (which is what the field char input loop is primarily looking for), and then delay the handling of the event until we bounce back to the VM_ReadKeyboard input loop.]

First input loop event-handling rule for a mouse-event when the current input loop is field char input (this is the delay mouse handling during field input rule):
	now keystroke-code is the null char;
	delay input handling.

First input loop event-handling rule for a hyperlink-event when the current input loop is field char input (this is the delay hyperlink handling during field input rule):
	now keystroke-code is the null char;
	delay input handling.

First input loop event-handling rule for a timer-event when the current input loop is field char input (this is the delay timer handling during field input rule):
	now keystroke-code is the null char;
	delay input handling.


Chapter - Field input mode
[When we are in field-input mode, the game enters an input loop that awaits char input (single key presses). The field-input mode flag tells us when we need to prepare for, carry out, and recover from this input loop.]

The field-input mode is a truth state that varies. Field-input mode is false.


Chapter - The accepting input field action
[Field input is accepted using the "accepting field input" action—an out of world action. It can be triggered either by the player clicking, or via the "initiate field input" phrase.]

Accepting field input is an action out of world applying to nothing. Understand "zenter zfield zinput" as accepting field input.

To initiate field input in (field - a g-element):
	if the field is form input:
		now the queued field is field;
		try accepting field input;
	otherwise:
		#if utilizing Glimmr debugging;
		say "[>console][FFs]***Warning: Attempted to initiate field input in [i][field][/i], which is a non-input element. The 'initiate field input in' phrase should only be used on g-elements with the 'form input' property.[<]";
		#end if;
		do nothing.


Chapter - Focusing and defocusing
[The field focusing rules and field defocusing rules are provided as a hook for authors. If, for example, we want a field to change appearance when activated or deactivated, these rules are the most convenient place to do that.]

The field focusing rules are an object based rulebook.[This rulebook is a hook for author customization.]

To remove focus from (element - a g-element):
	unless element is g-null-element:
		if the element is not a form input:
			#if utilizing Glimmr debugging;
			say "[>console][FFs]***Warning: Attempted to remove focus from [i][element][/i], a non-input g-element. The 'remove focus from' phrase should only be used on elements with the 'form input' property.[<]";
			#end if;
			do nothing;
		now the cursor of the input-stream of the element is -99;
		follow the input interpretation rules for the element;
		follow the field defocusing rules for the element.[Hook for authors]

The field defocusing rules are an object based rulebook.[This rulebook is a hook for author customization.]


Chapter - Handling mouse input on a field

Graphlink processing rule for a form input g-element (called the field) (this is the field activation graphlink processing rule):
	now the queued field is the field;
	unless the handling field input activity is going on:[We start the accepting field input action if it's not already in motion.]
		now the glulx replacement command is "zenter zfield zinput";
		change the text of the player's command to "zenter zfield zinput";
	rule succeeds.


Section - Allow the field input action to run silently from mouse input

A command-showing rule when glulx replacement command is "zenter zfield zinput" (this is the block command-showing for fake command rule):
	rule succeeds.


Chapter - Handling field input
[The handling field input activity runs during the accepting field input action. We can test whether we are receiving field input anywhere else in our code by checking the status of this activity.]

Handling field input is an activity.

The queued field is a g-element variable.[The queued field is set when we request to move to a new field, whether by clicking on that field or by typing enter or another termination key during field input.]

The field input interrupted is a truth state variable. Field input interrupted is false.[The field input interrupted flag is set to true when we want to restart the entire field-input process, but without completing the accepting field input action—basically, when we've moved to another field via "tabbing" (e.g., the enter key)]

Carry out accepting field input:
	set JUMP POINT FieldInput;[we can test whether we arrived here by jumping using the "field input interrupted" flag, at least up until it's reset right before beginning the handling field input activity.]
	now field-input mode is true;
	if the current field is form input:
		follow the input interpretation rules for the current field;[we interpret input anytime a field is clicked on or "tabbed" away from.]
	if the current field is not the queued field and the current field is form input and keystroke-code terminates input:
		remove focus from the current field;[this also runs the input defocusing rules, a hook for authors]
	now the current field is the queued field;
	follow the field focusing rules for the current field;[hook for authors]
	follow the window-drawing rules for the assigned window of the current field;
	now field input interrupted is false;
	begin the handling field input activity;
	if handling the handling field input activity:
		now the cursor of the input-stream of the current field is the number of characters in the text-string of the input-stream of the current field;
		follow the window-drawing rules for the assigned window of the current field;
		while field-input mode is true:
			#if utilizing Glimmr debugging;
			say "[>console][FFs]Accepting keystroke input for input field [i][current field][/i] (displayed in [assigned window of the current field]). Cursor placed at position [cursor of the input-stream of the current field].[<]";
			#end if;
			process field char input loop;
			[now keystroke is the character code returned;]
			#if utilizing Glimmr debugging;
			say "[>console]Character code entered: [keystroke-code]; text-string of field: [text-string of the input-stream of the current field] (note that this character will not be added to the text-string until it has been checked by the 'for keypress-to-string conversion' rulebook).[<]";
			#end if;
			if keystroke-code is the null char and the queued field is not the current field:[The player clicked on a field rather than enter a keystroke]
				break;
			if keystroke-code is the null char:[field input was interrupted, we must abort]
				remove focus from the current field;
				follow the window-drawing rules for the assigned window of the current field;
				now field-input mode is false;
				break;
			follow the keypress-to-string conversion rules for the current field;
			if the outcome of the rulebook is the terminate conversion outcome:[failure]
				remove focus from the current field;
				follow the window-drawing rules for the assigned window of the current field;
				now field-input mode is false;
				break;
			if the outcome of the rulebook is the restart conversion outcome:[failure]
				follow the window-drawing rules for the assigned window of the current field;
				now field-input mode is false;
				now field input interrupted is true;
				break;
			follow the window-drawing rules for the assigned window of the current field;
	end the handling field input activity;
	if field input interrupted is true:
		JUMP TO FieldInput.[If we have clicked on a field rather than typing a keystroke, jump back to the beginning and restart the process with the new field.]

To set jump point FieldInput:
	(- .FieldInput; -)
	
To jump to FieldInput:
	(- jump FieldInput; -)


Chapter - Keypress-to-string conversion activity
[An object based rulebook, but objects are not used in the default rule headers; they can be utilized by authors to target particular fields or groups of fields.]

The keypress-to-string conversion rules are an object based rulebook. The keypress-to-string conversion rules have outcomes terminate conversion (failure), restart conversion (failure), and conversion complete (success). 

The keypress-to-string conversion rulebook has a number called len.


Section - Error-handling rules
[The field input error-handling rules are a hook for authors to provide behavior when an input into a field fails. This is where an error beep would be placed, for example. These rules fire when:

a) The player tries to exceed the maximum number of characters allowed in the field;
b) The player tries to enter a character that's disallowed for the field;
c) The player tries to use the horizontal arrow keys or delete key to move beyond the length of the field;
d) The player tries to enter a character not present in the font.

If we need to discover which of these issues led to the rules being run, we can test various conditions. See the keypress-to-string conversion rules themselves for the conditions that fire the error-handling rules.]

The field input error-handling rules are an object based rulebook.


Section - Set variables and check initial entry requirements

First keypress-to-string conversion rule (this is the field entry initial check rule):
	now len is the number of characters in the text-string of the input-stream of the current field;
	unless keystroke-code is a char listed in the font table of the associated font of the input-stream of the current field or keystroke-code is listed in the accepted control input of the current field:
		follow the field input error-handling rules for the field;
		rule succeeds;
	if the number of entries in the accepted standard input of the current field > 0 and keystroke-code is not listed in the accepted standard input of the current field and keystroke-code is not listed in the accepted control input of the current field:
		follow the field input error-handling rules for the field;
		rule succeeds.


Section - Termination key input

A keypress-to-string conversion rule when keystroke-code terminates input (this is the keypress terminating input rule):
	cancel character input in the current text input window;
	#if utilizing Glimmr debugging;
	say "[>console][FFs]Received termination code [keystroke-code] for input field element [i][current field][/i]. Canceling field input in the current text input window ([current text input window]).[<]";
	#end if;
	if the next-field of the current field is form input:
		if keystroke-code is not -8:[The ESC key (-8) always returns us to regular input—it does not skip to the next field.]
			now queued field is the next-field of the current field;
			restart conversion;
	now field-input mode is false;
	terminate conversion.
		
	
To decide if (keychar - a number) terminates input:
	if keychar is listed in the input-termination commands of the current field, decide yes;
	decide no.

A g-element has a list of numbers called the input-termination commands. The input-termination commands of a g-element is usually {-6, -8, -9, 3}.


Section - Standard input

A keypress-to-string conversion rule when keystroke-code is standard input (this is the keypress of standard input rule):
	if len < maximum length of the current field:
		let field-input be the input-stream of the current field;
		if the cursor of the field-input is 0:
			now the text-string of the field-input is "[keystroke][text-string of field-input]";
		otherwise:
			let temp-buffer be character number (cursor of field-input) in the text-string of field-input;
			replace character number (cursor of field-input) in the text-string of field-input with "[temp-buffer][keystroke]";
		increase the cursor of the field-input by 1;
	otherwise:
		follow the field input error-handling rules for the current field.

To decide if (keychar - a number) is standard input:
	if (keychar > 31 and keychar < 127) or (keychar > 127 and keychar < 177), decide yes;
	decide no.


Section - Delete key

A keypress-to-string conversion rule when keystroke-code is a delete key (this is the keypress deleting rule):
	if cursor of the input-stream of the current field > 0:
		let field-input be the input-stream of the current field;
		replace character number (cursor of field-input) in text-string of field-input with "";
		decrease cursor of field-input by 1;
	otherwise:
		follow the field input error-handling rules for the current field;
	continue the action.

To decide if (keychar - a number) is a delete key:
	if keychar is 127 or keychar is -7, decide yes;
	decide no.


Section - Horizontal movement key (arrow keys)

A keypress-to-string conversion rule when keystroke-code is a horizontal movement key (this is the keypress horizontal movement rule):
	if keystroke-code is -2:[left arrow]
		decrease cursor of the input-stream of the current field by 1;
	if keystroke-code is -3:[right arrow]
		increase cursor of the input-stream of the current field by 1;
	if cursor of the input-stream of the current field < 0:
		follow the field input error-handling rules for the current field;
		now cursor of the input-stream of the current field is 0;
	if cursor of the input-stream of the current field > len:
		follow the field input error-handling rules for the current field;
		now cursor of the input-stream of the current field is len.

To decide whether (keychar - a number) is a horizontal movement key:
	if keychar > -4 and keychar < -1, decide yes;
	decide no.


Chapter - Input interpretation rules
[Input interpretation is mostly provided as a hook for author-written rules, though a routine for interpreting certain input fields as numbers is included.]

The input interpretation rules are an object based rulebook.


Section - Remove leading and trailing spaces

[This rule runs by default for all fields and eliminates leading and trailing spaces.]

An input interpretation rule for a g-element (called the field) (this is the trim graceless spaces rule):
	replace the regular expression "^\s+|\s+$" in the text-string of the input-stream of the field with "".


Section - Fields that accept only numbers

An input interpretation rule for a numerical g-element (called the field) (this is the field to number conversion rule):
	if the field is not form input:
		#if utilizing Glimmr debugging;
		say "[>console][FFs]***Warning: The g-element [i][field][/i] has been given the 'numerical' property, but only elements that also have the 'form input' property can be be acted on.[<]";
		#end if;
		continue the action;
	let val be the text-string of the input-stream of the field as a number;
	now the associated value of the field is val.

To decide which number is (S - indexed text) as a number:
	let is-negative be false;
	replace the regular expression "\s" in S with "";
	replace the regular expression "^\+" in S with "";
	if character number 1 in S is "-":
		let is-negative be true;
		replace the regular expression "\-" in S with "";
	if S matches the regular expression "<^0-9>", decide on 0;
	let len be the number of characters in S;
	if len is 0, decide on 0;
	let result be 0;
	repeat with N running from 0 to (len - 1):
		let digit be character number (len - N) in S;
		let multiplier be 10 to the power N;
		if digit is "0":
			next;
		if digit is "1":
			let result be multiplier + result;
			next;
		if digit is "2":
			let result be (multiplier * 2) + result;
			next;
		if digit is "3":
			let result be (multiplier * 3) + result;
			next;
		if digit is "4":
			let result be (multiplier * 4) + result;
			next;
		if digit is "5":
			let result be (multiplier * 5) + result;
			next;
		if digit is "6":
			let result be (multiplier * 6) + result;
			next;
		if digit is "7":
			let result be (multiplier * 7) + result;
			next;
		if digit is "8":
			let result be (multiplier * 8) + result;
			next;
		if digit is "9":
			let result be (multiplier * 9) + result;
			next;
		decide on 0;
	if is-negative is true, let result be 0 - result;
	#if utilizing Glimmr debugging;
	say "[>console][FFs]The input received in numerical field element [i][current field][/i] was interpreted as the number [result].[<]";
	#end if;
	decide on result;


Section  - Helpful phrases

To decide whether glulx char input is supported:
	(- ( glk_gestalt(gestalt_CharInput, 0) ) -)



Glimmr Form Fields ends here.


---- DOCUMENTATION ---- 


Chapter: About Glimmr Form Fields

Glimmr Form Fields (GFF) is a rather odd beast, and I don't really expect many people to find it useful. But it is kind of neat even so... The extension allows you to define any g-element (graphic element, see Glimmr Canvas-Based Drawing) as a "field" for input. A graphic representation of a string of text can be associated with this field. When clicked with the mouse or triggered by a command, the field will activate, a cursor will appear, and the player will be able to type to add text to the field. The player's typed input is stored in an indexed text property, and can also be converted into a number if the input is numeric.

Glimmr Form Fields requires most of the other Glimmr extensions in order to function, including Glimmr Canvas-Based Drawing, Glimmr Drawing Commands, and Glimmr Graphic Hyperlinks. Also required are Glimmr's dependencies, including Flexible Windows by Jon Ingold and Fixed Point Maths by Michael Callaghan, as well the Glulx Input Loops extension. GFF also requires at least one font extension, such as Glimmr Bitmap Font or Glimmr Image Font.


Section: Including Glimmr Form Fields in a project

Inform remains fairly unsophisticated in its mechanisms for organizing included extensions. When we are dealing with a complex system of modular extensions such as Glimmr, it is very easy to trip it up, and the result is usually a list of unhelpful errors. For this reason, each Glimmr extension includes a section--such as this one--about how to include it, particularly in relation to other extensions.

Glimmr Form Fields must be included before any font extension, e.g.:

	Include Glimmr Form Fields by Erik Temple.
	Include Glimmr Bitmap Font by Erik Temple.

You should not include Flexible Windows, Fixed Point Maths, Glulx Input Loops, Glimmr Drawing Commands, Glimmr Canvas-Based Drawing, or Glimmr Graphic Hyperlinks in your project; these are included automatically.


Section: Brief overview of Glimmr Form Fields

Any kind of graphic element can be identified as an input field, and this field is associated via a property with the rendered string g-element that will display its text (see below). When the input field element receives a mouse click (or, alternatively, a command), the "accepting field input" action is triggered, and the game will enter a new keystroke-based input loop (the "field char input" loop--see Glulx Input Loops for more on input loops). This character input is taken in the main text window, but it will seem to the player that she is transparently typing into the field: Each time the player presses a key in this special loop, the text-string associated with the field's rendered string element will be updated with the character entered, and the graphics window refreshed so that this is reflected in the graphical representation of the text. When the player presses a key defined as terminating input, we stop the input loop and complete the accepting field input action. 

There are three main steps to implementing an input field:

	1) Declare the field itself.
	2) Declare the element that will display text in the field.
	3) Access the player's input to the field and act upon it.

The following sections elaborate on these steps and on the basic options available within them.


Chapter: Defining the input field

GFF allows you to identify any number of graphic elements as input fields. This is done by setting the form input property of the element:

	My form field is a rectangle primitive. It is form input. The graphlink status is g-active.

As shown, we also need to make the field receptive to mouse input, via the "graphlink status" property.

Any type of graphic element can be designated form input. The field is primarily a zone of the screen that is intended for mouse interaction--the player clicks on a field to activate field text entry. Note that the player needs to be able to click within the dimensions of the element to activate the field. So, a thin horizontal line would not be appropriate in most cases, because this would force the player to click on the one-pixel wide line. Better would be to use a PNG image with transparency (sprite element) to display the horizontal line, with space above the line left transparent to provide a zone for the player to touch with the mouse. (Another approach is to simply write a custom element display rule to display the field and define the clickable zone as desired; see the documentation for Glimmr Canvas-Based Drawing.)

GFF provides an optional way to define input fields, the "input field" kind. This is a subkind of g-element, and for this kind the form input and graphlink status properties are automatically set, which can save some typing. Most users will also want to declare a more specific kind for the input field (otherwise nothing will be drawn to the screen). This can be done like so:

	An input field is a kind of rectangle primitive.


Chapter: Defining the input stream

Once a form field has been declared, we must also create its "input-stream", the rendered string element that will be associated with the field. This rendered string is the element that will actually draw text to the graphics window. It is declared like any other rendered string (see Glimmr Canvas-Based Drawing), and all of the standard options apply. Here is a simple, but complete, declaration: 


	My text is a bitmap-rendered string. The origin is {8, 15}. The tint is g-black.

After (and only after) we have declared both the field and the rendered string, we must define the relationship between them, by setting the input-stream property of the field:

	The input-stream of my form field is my text.


Chapter: Alternate ways of initiating input in a field

It is expected that the player will click on a field to initiate input. However, this need not be the exclusive way to initiate input. To initiate input in a field from anywhere in your source code, use the "initiate field input in <field>" phrase:

	Instead of jumping:
		say "Impatient, are we? Just start typing now, then!";
		initiate field input in My Form Field.


Chapter: A field's accepted input

Section: Standard input

The "standard input" of a field is the characters that it is capable of displaying. By default, a field can display any character available in the font used for the rendered string (e.g., Glimmr Image Font). However, we can restrict that input by defining the "accepted standard input" of the field. The accepted standard input is a list of numbers corresponding to the characters that can be entered into the field. For example, to restrict a field to only accepting a plus or a minus sign, we would declare the accepted standard input accordingly:

	My form field is an input field. The accepted standard input is {43, 45}.

The 43 and 45 are the character codes for "+" and "-" respectively.

Note that, if we declare the accepted standard input for a field, the characters in the list will be the *only* ones that the field will accept and attempt to display.

Section: Control input

We can also set the "accepted control input" for each field in much the same way. The accepted control input is the list of keystrokes that the field will accept as control codes (such as return, enter, delete, and arrow keys); they are never displayed, but are used for other effects. Here is a nonexhaustive list of potential control keys:

	 -2	left arrow
	 -3	right arrow
	 -4	up arrow
	 -5	down arrow
	 -6	return
	 -7	backspace/delete
	 -8	escape
	 -9	tab
	-10	page up
	-11	page down
	-12	home
	-13	end
	   3	return/enter
	127	backspace/delete

By default, the accepted control input list contains the following codes:

	-2, -3, 3, 127, -6, -7, -8, -9

These correspond to the keys for which default control behavior is available: The enter and return keys terminate input in a field, the escape key cancels input, the delete key deletes the character in front of the cursor, and the left & right arrow keys move the cursor within the field.

The actual behavior for control keys is defined in the "keypress-to-string conversion rules". Authors who need to define new control keys or to change the existing behaviors are referred to this extension's source code to study the implementation of the default behaviors.


Section: Help building lists of character codes

The following code (a complete "game") can be used to create a loop for building lists of character codes. You can run this code, type each character you want in your list, and then copy and paste the list into your story text.

	*: When play begins:
		say "Press any key to see the character code.";
		let L be a list of numbers;
		while true is true:
			wait for any key;
			say "Input: [the keystroke-code cleansed for printing].";
			add keystroke-code to L;
			say "List of keystroke-codes entered:[line break]";
			repeat with N running from 1 to the number of entries of L:
				say "[if N is 1]{ [entry N of L][otherwise], [entry N of L][end if]";
			say " }.";
			say "Corresponding keystrokes:[line break]";
			say "{ ";
			repeat with N running from 1 to the number of entries of L:
				unless N is 1:
					say ", ";
				let T be entry N of L resolved to an indexed text;
				if T is "":
					say "<special>";
				if T is " ":
					say "<space>";
				otherwise:
					say "[T]";
			say " }."

	Test is a room.

Chapter: Accessing the player's input

The string typed into a field can be accessed at any time by referring to the "text-string" of the field's input stream. So, if we have a field whose rendered string element is called "My Text", we could print the contents of the field by writing:

	say "[text-string of My Text]"


Section: Input interpretation

If we wish, we can specify how GFF should interpret a given field input by using the "input interpretation" rules. This rulebook is run on a field whenever that field gains or loses focus, and is an object based rulebook, so that we can write rules of the sort:

	Input interpretation: (applies to any field)
	Input interpretation for a g-element: (applies to any field)
	Input interpretation for an input field: (applies only to the "input field" kind)
	Input interpretation for my input field: (applies to a single named field)
	Input interpretation for my input field when keypress-code terminates input:

The last preamble will function only when a control key was pressed to terminate input (effectively, this tells us that the player did not click to abandon input, but instead actively pressed a key, such as the Enter or Escape key, to complete).

The input interpretation rules can be used to clean up or otherwise alter the player's input before our game does anything with it. The input interpretation rules should either redefine the text-string of the field's input-stream, or set some other variable based on the contents of the string. The graphics window will be refreshed after the input interpretation rulebook runs, so that any change made to the text-string from within will be reflected to the player, so keep that in mind when using it. If you want to keep your changes to the text-string secret from the player, make any changes to the text-string after the field input loop is completely finished.

Here's how to write a rule that would remove all punctuation (though if you don't want any punctuation, it may be better to simply disallow it with the standard input filter):

	*: Input interpretation for a g-element (called the field):
		replace the regular expression "\p" in the text-string of the input-stream of the field with "".

GFF provides a rule that fires by default for all fields, the "trim graceless spaces rule", which trims leading and trailing spaces from the input. 
		
The only other interpretation rule provided by GFF, the "field to number conversion rule," converts the text-string into another type. This rule runs only when an input field has been declared to be "numerical," and it reinterprets the indexed text input as a number, the "associated value" of the field element (see the Numeric Input Fields section below).


Chapter: Numeric input fields

Input fields can be declared to be numerical. A numerical field has an additional property, the "associated value", which will be filled with a number after the player has completed input to the field. The associated value is not updated with each keystroke--it is only calculated when the player removes focus from the field, whether by pressing return, enter, escape (or tab, though most interpreters will not recognize the tab key); the conversion to a number is handled by the "input interpretation" rules (see below). If the player has included non-numeric input in the field, then the associated value will be 0. Otherwise, the associated value will be an appropriate numeric interpretation of the player's input. For example, if the player types "0012" into the field, the associated value will be 12. Negative numbers can be entered using a minus sign, e.g. "-22" ("+22" will also serve to indicate a positive number).

We declare a field to be numerical like so:

	My form field is a rectangle primitive. My form field is numerical.

By default, numerical fields allow any kind of input. However, we can restrict them to allow only numbers by changing the field's accepted standard input (see above) to allow only numeric characters. The "numerical filter" is provided as a shortcut, and can be used like so:

	When play begins:
		repeat with item running through numerical g-elements:
			now the accepted standard input of item is the numerical filter.

This will allow only the ten digits, as well as the plus and minus signs, to be typed into a numerical field.

It may sometimes happen that we need to disallow negative numbers as well; if that is the case, there is a special phrase that will remove the minus sign (hyphen or en dash) from the numerical filter before we apply the latter to a field: 

	When play begins:
		disallow negative values in numerical filter;
		repeat with item running through numerical g-elements:
			now the accepted standard input of item is the numerical filter.

If we later need to restore the ability to enter negative values, we can repeat the process, but allowing negative values instead:

	allow negative values in numerical filter;
	now the accepted standard input of my form field is the numerical filter.


Chapter: Customizations

GFF provides various hooks for customization. Some of these are rulebooks, others are filter lists that can be changed. Still other avenues for customization are not covered here, but can be gleaned by studying the source code.


Section: Focusing and defocusing

Whenever a field gains or loses focus--that is, when it becomes available for immediate player input--special rulebooks are checked. These are the "field focusing rules" and the "field defocusing rules". Both of these are object based rulebooks, so we can write things like:

	Field focusing: (applies to any field)
	Field focusing for a g-element: (applies to any field)
	Field defocusing for an input field: (applies to field of the "input field" type)
	Field defocusing for my input field: (applies to a single named field)
	etc.

Using these rules, we can make fields react visually to the player's input, such as a box changing color when the player clicks on it, and changing back when input is completed. (See the Color Picker example below.)


Section: Handling input errors

When the player enters a disallowed control or standard input character, this is considered to be an error. The field input loop will restart and the player's input will not be further processed. Before the loop is restarted, however, the "field input error-handling rules" will be checked. This is initially an empty rulebook, to which the author can add as needed. Perhaps the least intrusive thing to do here would be to play a sound to signify the error (see the Color Picker example). We can specialize error behavior by testing which key the player pressed.


Section: "Tab" order

In standard HTML forms, there is the concept of "tab order"; when the user hits the tab key, the cursor moves to the next field. It is possible to set up a similar tab ordering in GFF; most Glulx interpreters will not recognize the tab key as input, though, so we use the keys used to complete input in a field (e.g., return, enter) to move between fields. To set up tab order, we use a field's  "next-field" property. For example, to set up an ordering for a three-field layout:

	First Name is a field. The next-field is Last Name.
	Last Name is a field. The next-field is Gender.
	Gender is a field.

Now, when the player presses return in from the First Name field, the cursor will automatically move to Last Name, and again to Gender. Pressing return in the Gender field will complete field input.


Chapter: A note on performance and compatibility

Any of the notes on performance that appear in other Glimmr extensions apply also to Glimmr Form Fields. The extension is computation-intensive, and having lots of rendered texts and multiple fields on screen at once will likely impact performance, particularly if you are using bitmap fonts. The Gargoyle interpreter ( http://code.google.com/p/garglk/downloads/list ) has the best all-around performance; on my system, it runs without any noticeable delays at all, even when using bitmap fonts. All Glimmr games will always run slowly, sometimes much more slowly, in the Inform IDE than they will in outside interpreters, so test your game's true performance using a standalone interpreter.

Mac users: You may well be attached to using Zoom or Spatterlight, but neither of these is ideal. As of December 2010, the most recent version of Zoom (v1.1.4.1) requires that you choose Glulxe as the interpreter (in the Game tab of the Preferences) rather than Git, to avoid a fatal bug in an earlier version of Git. Zoom 1.1.4.1 also inverts colors, regardless of whether you're using Glulxe or Git. Spatterlight is no longer under development. It is slower than most other modern interpreters, and is extremely awkward for entering mouse input. It is not recommended for use with any Glimmr project. Gargoyle, again, is the best option.


Chapter: Contact info

If you have comments about the extension, please feel free to contact me directly at ek.temple@gmail.com.

Please report bugs on the Google Code project page, at http://code.google.com/p/glimmr-i7x/issues/list.

For questions about Glimmr, please consider posting to either the rec.arts.int-fiction newsgroup or at the intfiction forum (http://www.intfiction.org/forum/). This allows questions to be public, where the answers can also benefit others. If you prefer not to use either of these forums, please contact me directly via email (ek.temple@gmail.com).


Example: * Minimalist Exercise - This example illustrates the basics of usage, with a single form field in which the player is invited to type a handful of characters. The text typed is echoed back in the main window. If the player types a number (positive or negative), the input will be interpreted as a number and that too will be echoed.

You may prefer to do a release build and run this in a standalone interpreter for better performance. If you choose not to release to a standalone file, you may need to type slowly into the field.

	*: "Minimalist Exercise"

	Include Glimmr Form Fields by Erik Temple.
	Include Glimmr Bitmap Font by Erik Temple.
	Include Glimmr Simple Graphics Window by Erik Temple.
	
	[Use input loop debugging.]
	
	The graphics-window is a graphics g-window spawned by the main-window. The position is g-placeabove. The back-colour is g-steelblue. The graphics-window is g-graphlinked.
	
	The graphics-canvas is a g-canvas. The canvas-width is 51. The canvas-height is 40.
	
	The associated canvas of the graphics-window is the graphics-canvas. The associated canvas of a g-element is usually the graphics-canvas.
	
	When play begins:
		open up the graphics-window.
		
	An input field is a kind of stroked rectangle primitive. The associated canvas of an input field is the graphics-canvas. The maximum length is 5. An input field is numerical.
	
	My form field is an input field. The origin is {5, 10}. The endpoint is {46, 30}. The background tint of an input field is usually g-navy. The tint of an input field is g-white.
	
	My text is a bitmap-rendered string. The origin is {8, 15}. The tint is g-indigo. The input-stream of my form field is my text.
	
	Test is a room. "You may type up to 5 characters in the field above. Go ahead, try it. Press Enter when you've finished."
	
	Last carry out accepting field input:
		say "You typed '[text-string of my text]' (interpreted as the number [associated value of my form field]) in the field[first time]. Click in the field again to change or add to what you typed; you can delete text using the backspace key, or use the left and right arrow keys to move the cursor[only]."


Example: ** Color Picker - Inform 6/Glulx requires colors to be specified in hex format (e.g., FEFE01). However, Inform 7 does not accept hex values as numbers, so it is necessary to provide such values as a decimal; for example FEFE01 must be given as 16711169 at the I7 level. This is inconvenient, especially when we're beginning with an RGB triad, since we must first convert the RGB to hex, and then convert the hex value to a decimal. This example ameliorates this problem by creating a tool that converts instantly between RGB, hex, and decimal.

As an example of the extension's functionality, the color picker demonstrates the use of the field focusing and defocusing rules, use of tab order, and shows how to signal errors using the field input error-handling rules. Much of the code is also taken up with code to convert between RGB, hex (presented as an indexed text), and packed decimal.

You may prefer to do a release build and run this in a standalone interpreter for better performance. If you choose not to release to a standalone file, you may need to type slowly into the fields.

	*: "Color Picker" by Erik Temple
	
	Include Glimmr Form Fields by Erik Temple.
	Include Glimmr Image Font by Erik Temple.
	Include Extended Debugging by Erik Temple.
	
	Use no status line.
	
	[Use Glimmr debugging.]
	[Use input loop debugging.]
	
	Section - Graphics window
	
	The graphics-window is a graphics g-window spawned by the main-window. The position of the graphics-window is g-placeright. The measurement of the graphics-window is 200. The back-colour of the graphics-window is g-light-grey. The graphics-window is g-graphlinked.
	
	The graphics-canvas is a g-canvas. The canvas-width is 200. The canvas-height is 250. The associated canvas of the graphics-window is graphics-canvas. The associated canvas of a g-element is the graphics-canvas.
		
	 After offset calculation of a graphics g-window (called the window) (this is the place canvas at top rule):
		now y-offset of window is 0. 
		
	When play begins:
		if glulx graphics is supported:
			open up the graphics-window;
			write "RGB Hex Decimal Color-Picker[paragraph break]" to the file of tickertape;
		otherwise:
			say "This interpreter does not support graphics. Exiting...";
			abide by the immediately quit rule.
		
	
	Section - Input strings
	[Note that the parenthetical definition of the text-string column is NECESSARY in 6E72.]
	
	The tint of an image-rendered string is usually g-Black.
	
	Some image-rendered strings are defined by the Table of Image-Rendered String Elements.
	
	Table of Image-Rendered String Elements
	image-rendered string	origin	text-string (indexed text)	display-layer	scaling factor
	red_label	{45, 22}	"Red"	2	0.2500
	green_label	{45, 53}	"Green"	2	0.2500
	blue_label	{46, 84}	"Blue"	2	0.2500
	ornament_left	{127, 30}	"{"	1	1.0000
	ornament_right	{176, 28}	"}"	1	1.0000
	dec_label	{25, 193}	"Decimal"	1	0.2500
	hex_label	{25, 139}	"Hexadecimal"	1	0.2500
	red_string	{57, 22}	""	2	0.2500
	green_string	{57, 54}	""	2	0.2500
	blue_string	{57, 85}	""	2	0.2500
	hex_string	{29, 162}	""	2	0.2500
	dec_string	{29, 216}	""	2	0.2500
	 
	Red_label, green_label, blue_label, and ornament_left are right-aligned.
	
	
	Section - Input Fields
	
	An input field is a kind of stroked rectangle primitive. The background tint of an input field is usually g-medium-grey. The tint of an input field is g-white. The display-layer of an input field is usually 1. The line-weight of an input field is usually 2. The display status is usually g-active. An input field is usually numerical.
	
	Some input fields are defined by the Table of Input field Elements.
	
	Table of Input Field Elements
	input field	origin	endpoint	maximum length	input-stream	next-field
	red_input	{52, 19}	{87, 39}	3	red_string	green_input
	green_input	{52, 51}	{87, 71}	3	green_string	blue_input
	blue_input	{52, 82}	{87, 102}	3	blue_string	g-null-element
	dec_input	{23, 212}	{177, 234}	8	dec_string	g-null-element
	hex_input	{23, 158}	{177, 180}	7	hex_string	g-null-element
	
	
	Hex_input is not numerical. 
	
	When play begins (this is the apply numeric filter rule):
		disallow negative values in numerical filter;
		repeat with item running through numerical input fields:
			now the accepted standard input of item is the numerical filter.
			
	[When play begins (this is the status line setup rule):
		now the left hand status line is "Packed decimal: [associated value of dec_input]";
		now the right hand status line is "hex: [text-string of hex_string]".]
	
	
	Section - Previews
	
	A preview is a kind of stroked rectangle primitive. The graphlink status of a preview is g-inactive. The line-weight of a preview is 5. The tint of a preview is usually g-black.
	
	Some previews are defined by the Table of Preview Elements.
	
	Table of Preview Elements
	preview	origin	endpoint	background tint
	preview_2	{131, 67}	{168, 100}	g-black
	preview_1	{131, 19}	{168, 52}	g-white
	
	
	[We want to display an arbitrary RGB color, not a preexisting color term. Canvas-Based Drawing currently follows Glulx Text Effects and works only with pre-defined color terms (numbers being quite unwieldy), so we need to write a new element display rule that uses the decimal value (from the dec_input element to determine the color of the preview.]
	
	An element display rule for a preview (called the stroked rectangle):
		strectdraw (associated value of dec_input) in (current window) from (win-x) by (win-y) to (end-x) by (end-y) with (stroke) stroke of (color background tint);
	
	
	Section - Field calculations
	
	A field focusing rule for an input field (called the field):
		now the background tint of the field is g-black.
		
	A field defocusing rule for an input field (called the field):
		now the background tint of the field is g-medium-grey;
		if the field is numerical and the associated value of the field is less than 0, now the associated value of the field is 0;
		if the field is red_input or the field is green_input or the field is blue_input:
			if the associated value of the field > 255, now the associated value of the field is 255;
			change the text-string of the (input-stream of the field) to "[associated value of the field]";
			update the decimal using RGB;
			update the hex using decimal;
		if the field is hex_input:
			update the decimal using hex;
			update the hex using decimal;
			update the RGB using decimal;
		if the field is dec_input:
			if the associated value of the field > 16777215, now the associated value of the field is 16777215;
			change the text-string of the (input-stream of the field) to "[associated value of the field]";
			update the hex using decimal;
			update the RGB using decimal;
		say "[first time]Tickertape record of operations:[paragraph break][only]RGB ([associated value of red_input], [associated value of green_input], [associated value of blue_input]) :: #[text-string of hex_string] :: [associated value of dec_input].[line break][run paragraph on]";
		append "[first time]Tickertape record of operations:[paragraph break][only]RGB ([associated value of red_input], [associated value of green_input], [associated value of blue_input]) :: #[text-string of hex_string] :: [associated value of dec_input][line break]" to the file of tickertape.
		
	The file of tickertape is called "conversions".
	
	
	To update the decimal using RGB:
		now the associated value of dec_input is r = (associated value of red_input) g = (associated value of green_input) b = (associated value of blue_input);
		now the text-string of dec_string is "[associated value of dec_input]".
		
	To update the decimal using hex:
		now the associated value of dec_input is hex (text-string of hex_string);
		now the text-string of dec_string is "[associated value of dec_input]".
	
	To update the hex using decimal:
		now the text-string of hex_string is "[hex equivalent of the associated value of dec_input]".
		
	To update the RGB using decimal:
		now the associated value of red_input is the R component of the associated value of dec_input;
		now the text-string of red_string is "[the associated value of red_input]";
		now the associated value of green_input is the G component of the associated value of dec_input;
		now the text-string of green_string is "[the associated value of green_input]";
		now the associated value of blue_input is the B component of the associated value of dec_input;
		now the text-string of blue_string is "[the associated value of blue_input]";
		
	To decide which indexed text is hexadecimal/hex equivalent of (N - a number):
		let hex be indexed text;
		let hex be "";
		let target be N;
		while target > 0:
			let digit be the remainder after dividing the target by 16;
			if digit > 9:
				let digit be digit plus 55;
			otherwise:
				let digit be digit plus 48;
			let hex be "[char-code (digit)][hex]";
			let target be the target divided by 16;
		while the number of characters in hex is less than 6:
			let hex be "0[hex]";
		decide on hex.
		
	To decide which number is the R component of (N - a number):
		decide on N divided by 65536.
	
	To decide which number is the G component of (N - a number):	
		decide on (the remainder after dividing N by 65536) divided by 256.
		
	To decide which number is the B component of (N - a number):
		decide on the remainder after dividing (the remainder after dividing N by 65536) by 256.
		
	
	Section - Scenario
	
	The story headline is "Interactive Color Selection".
	
	Convert is a room. "Use fields to the right to convert between RGB values, the hexadecimal representation of a color, and the packed decimal form that I7 Glulx uses. Press Return or Enter to move to the next field, and press Escape to finish.[paragraph break]Press Q to quit (escape from field input first).[paragraph break]A tickertape record of each new color will be output in this window, and also to an external file called 'conversions'."
	
	Instead of jumping:
		initiate field input in red_input.
		
	
	Section - Input loop
	
	When play begins:
		now the command prompt is "".
	
	The focal event type of main input is char-event.
	
	Last input loop setup rule for a char-event when the current input loop is main input:
		rule succeeds.
		
	An input loop event-handling rule for a char-event when the current input loop is main input (this is the Q to quit rule):
		if keystroke is "q" or keystroke is "Q":
			say "Exiting...";
			abide by the immediately quit rule;
		rule succeeds.
			
	
	Section - Sounds
	
	Sound of error is the file "Funk.aiff".
	
	A field input error-handling rule:
		play sound of error.





