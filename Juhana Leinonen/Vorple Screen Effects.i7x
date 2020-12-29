Version 3/181103 of Vorple Screen Effects by Juhana Leinonen begins here.

"Vorple equivalent of Basic Screen Effects by Emily Short. Waiting for a keypress, clearing the screen, aligning, styling and coloring text."

Include version 3 of Vorple by Juhana Leinonen.
Include version 7 of Basic Screen Effects by Emily Short.

Use authorial modesty.


Section 1 - Centering text in Glulx (in place of Section - Centering text on-screen in Basic Screen Effects by Emily Short)

To center (quote - text) in Glulx:
	(- CenterPrintComplex({quote}); -).

To center (quote - text) at the/-- row (depth - a number):
	(- CenterPrint({quote}, {depth}); -).

Include (-

[ CenterPrint str depth i j len;
	font off;
	i = VM_ScreenWidth();
	len = TEXT_TY_CharacterLength(str);
	if (len > 63) len = 63;
	j = (i-len)/2 - 1;
	VM_MoveCursorInStatusLine(depth, j);
	print (I7_string) str; 
	font on;
];

[ CenterPrintComplex str i j len;
	font off;
	print "^"; 
	i = VM_ScreenWidth();
	len = TEXT_TY_CharacterLength(str);
	if (len > 63) len = 63;
	j = (i-len)/2 - 1;
	spaces j;
	print (I7_string) str; 
	font on;
];

-).

To decide what number is screen width in Glulx:
	(- VM_ScreenWidth() -).

To decide what number is screen height in Glulx:
	(- I7ScreenHeight() -).

[TODO: come up with reasonable values in Vorple, or throw an error]
To decide what number is screen width:
	if Vorple is supported:
		decide on 80;
	decide on screen width in Glulx.

To decide what number is screen height:
	if Vorple is supported:
		decide on 24;
	decide on screen height in Glulx.

Include (-

[ I7ScreenHeight i screen_height;
	i = 0->32;
	if (screen_height == 0 or 255) screen_height = 18;
	screen_height = screen_height - 7;
	return screen_height;
];

-).


Section 2 - Text with alignment

To center (quote - text):
	if Vorple is supported:
		place a block level element called "center-align" reading quote;
	otherwise:
		center quote in Glulx.	

To right align (quote - text):
	place a block level element called "right-align" reading quote.


Section 3 - Displaying boxed quotations (in place of Section SR5/1/7 - Saying - Fonts and visual effects in Standard Rules by Graham Nelson)

To say bold type -- running on
	(documented at phs_bold):
	(- style bold; -).
To say italic type -- running on
	(documented at phs_italic):
	(- style underline; -).
To say roman type -- running on
	(documented at phs_roman):
	(- style roman; -).
To say fixed letter spacing -- running on
	(documented at phs_fixedspacing):
	(- font off; -).
To say variable letter spacing -- running on
	(documented at phs_varspacing):
	(- font on; -).
To display the boxed quotation (Q - text) in Glulx
	(documented at ph_boxed):
	(- DisplayBoxedQuotation({-box-quotation-text:Q}); -).
	
To display the boxed quotation (Q - text):
	if Vorple is supported:
		place a "blockquote" element reading Q;
	otherwise:
		display the boxed quotation "[Q]" in Glulx.
		

Section 4 - Showing the current quotation (in place of Section - Showing the current quotation in Basic Screen Effects by Emily Short)

To show the/-- current quotation in Glulx:
	(- ClearBoxedText(); -);

[This rule does nothing in Vorple by design. Boxed quotations in Vorple are always displayed immediately so this helper phrase is unnecessary.]
To show the/-- current quotation:
	if Vorple is not supported:
		show the current quotation in Glulx.


Section 5 - Styles

Vorple style is a kind of value.

cursive font,
emphasized font,
fantasy font,
monospace font,
nowrap font,
strikethrough font,
strong font,
underlined font,
xx-small font,
x-small font,
small font,
large font,
x-large font,
xx-large font
are Vorple styles.

To say (style - Vorple style) style -- running on:
	execute JavaScript command "vorple.layout.openTag('span', '[style]'.split(' ').join('-').toLowerCase())".
	
To say end style -- running on:
	close HTML tag.


Section 6 - Colors

white letters,
black letters,
blue letters,
green letters,
cyan letters,
red letters,
magenta letters,
brown letters,
yellow letters,
dark gray letters,
light gray letters,
light blue letters,
light green letters,
light cyan letters,
light red letters,
light magenta letters,
white background,
black background,
blue background,
green background,
cyan background,
red background,
magenta background,
brown background,
yellow background,
dark gray background,
light gray background,
light blue background,
light green background,
light cyan background,
light red background,
light magenta background
are Vorple styles.

[
 -- not ready yet --

To apply (style - Vorple style) style to the/-- entire/whole/-- page:
	execute JavaScript command "$('#vorpleContainer')[bracket]0[close bracket].className=$('#vorpleContainer')[bracket]0[close bracket].className.replace(/\b[bracket]a-z[close bracket]+\-foreground/,'');$('#vorpleContainer').addClass('[color]-foreground')".

To set the/-- text color/colour of an/the/-- element called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number) with (alpha - number) percent/-- opacity:
	do nothing.


To set the/-- text color/colour of an/the/-- element called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number):
	set the text color of the element called classes to red r green g blue b with 100 percent opacity.

To set the/-- text color/colour of all the/-- elements called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number) with (alpha - number) percent/-- opacity:
	set the text color of the element called "[classes]:last" to red r green g blue b with alpha percent opacity.
	
To set the/-- text color/colour of all the/-- elements called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number):
	set the text color of all the elements called classes to red r green g blue b with 100 percent opacity.

To set the/-- background color/colour of an/the/-- element called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number) with (alpha - number) percent/-- opacity:
	do nothing.
	
To set the/-- background color/colour of an/the/-- element called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number):
	set the background color of the element called classes to red r green g blue b with 100 percent opacity.

To set the/-- background color/colour of all the/-- elements called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number) with (alpha - number) percent/-- opacity:
	set the background color of the element called "[classes]:last" to red r green g blue b with alpha percent opacity.
	
To set the/-- background color/colour of all the/-- elements called (classes - text) to red (r - number) green (g - number) and/-- blue (b - number):
	set the background color of all the elements called classes to red r green g blue b with 100 percent opacity.
]


Section 7 - Headers

To place a/-- level (level - number) header called (classes - text) reading (txt - text):
	place a "h[level]" element called classes reading txt.
	
To place a/-- level (level - number) header reading (txt - text):
	place a "h[level]" element called "" reading txt.


Section 8 - Lists

To display an/-- ordered list (source - list of text) called (classes - text):
	open HTML tag "ol" called classes;
	repeat with X running through source:
		place a "li" element reading X;
	close HTML tag.
	
To display an/-- ordered list (source - list of text):
	display an ordered list source called "".

To display an/-- unordered list (source - list of text) called (classes - text):
	open HTML tag "ul" called classes;
	repeat with X running through source:
		place a "li" element reading X;
	close HTML tag.

To display an/-- unordered list (source - list of text):
	display an unordered list source called "".


Vorple Screen Effects ends here.


---- DOCUMENTATION ----

Vorple Screen Effects duplicates in Vorple the effects provided by Basic Screen Effects by Emily Short and adds a couple of new ones.

Vorple Screen Effects includes Basic Screen Effects and uses its definitions when the game is played in a non-Vorple interpreter.


Chapter: Differences with Basic Screen Effects

The following phrases work identically in both Vorple and non-Vorple interpreters. See the documentation of Basic Screen Effects for more information.

	clear the screen;
	wait for any key;
	wait for the SPACE key;
	pause the game;
	stop game abruptly;
	
The following phrase from Standard Rules is modified to display a boxed quote in Vorple:
	
	display the boxed quotation (text);
	
The phrase "show the current quotation" in Basic Screen Effects is unnecessary in Vorple so it doesn't do anything, except when the game is played in a non-Vorple interpreter.
	
The following phrases are available but behave slightly differently in Vorple:

	center (text);

Vorple doesn't have a status line by default so any phrases related to changing or displaying the status line do not do anything (except in offline interpreters). The phrase "clear only the main screen" does the same as "clear the screen". To include a status line in Vorple, see the Vorple Status Line extension.

These phrases not found in Basic Screen Effects have been added:

	right-align (text);
	turn the foreground (color);
	(color) background;
	
Vorple is Glulx-only, but an equivalent mechanism to Basic Screen Effect's Z-machine specific text and background color changing is included, as well as a phrase to choose any arbitrary color for text or background.

And finally, there are some helper phrases that let create header and list elements.


Chapter: A note about Glulx Text Effects

Vorple Screen Effects is compatible with Glulx Text Effects in that the Glulx text effects are ignored in the Vorple interpreter, but they can be used to provide fallback styles for non-Vorple interpreters.


Chapter: Text styles

The following styles are provided with the extension:

	cursive font
	emphasized font
	fantasy font
	monospace font
	nowrap font
	strikethrough font
	strong font
	underlined font
	
The "cursive font" style displays text in a font resembling cursive writing, "fantasy font" uses a decorative font resembling handwriting and "monospace font" is a fixed width font (corresponding to Inform's "[fixed letter spacing]"). The actual font used depends on the web browser, operating system, user preferences and any custom CSS directives. 

"Emphasized font" and "strong font" are usually (but not guaranteed to be) italic and bold text respectively.

The "nowrap font" style does not allow line breaks inside the style. It's mostly used when displaying numbers that use space as a separator. For example, we don't want the text "The suitcase contains a statue worth 100 000 dollars" to be split between "100" and "000":

	The suitcase contains a statue worth 100
	000 dollars.
	
If we add the "nowrap font" style ("The suitcase contains a statue worth [nowrap font style]100 000[end style] dollars.") the number is guaranteed to stay on the same line:

	The suitcase contains a statue worth 
	100 000 dollars. 

We should take care not to apply the nowrap style to very long pieces of text. If the text is longer than the normal line width it overflows beyond the normal text area. 

The following styles can be used to change the font size, proportional to the default font, from smallest to largest:

	xx-small font
	x-small font
	small font
	large font
	x-large font
	xx-large font
	
New styles can be added if a CSS file with corresponding style instructions is supplied with the story.

	Release along with style sheet "emotions.css".
	Angry is a Vorple style.
	
	When play begins:
		say "You are feeling [angry style]especially furious[end style] today!".
		
The "emotions.css" file:

	.angry {
		color: red;
		font-size: larger;
		font-weight: bold;
	}
	
The style's name is applied to the text as a class. Uppercase characters are converted to lowercase and spaces are replaced with dashes, e.g. "My Custom Font" style in Inform becomes a class called "my-custom-font". Style names should only contain alphanumeric characters (a-z, 0-9), dashes, underscores and spaces.


Chapter: Colors

16 colors are provided to be used as foreground and background colors:

	white 
	black 
	blue 
	green 
	cyan 
	red 
	magenta 
	brown 
	yellow 
	dark gray 
	light gray 
	light blue 
	light green 
	light cyan 
	light red 
	light magenta 

Text colors are called "<color> letters" and background colors are "<color> background", e.g. "blue letters" and "green background".

This basic set of colors can be used like font styles described in the previous chapter:

	say "A [green letters style]frog[end style] jumps into the [white letters style][blue background style]pond[end style][end style].";

The entire page's colors can be changed with these phrases:
	
	apply (Vorple style) style to the entire page;
	remove (Vorple style) from the entire page;


Chapter: Centering and aligning text

Offline interpreters can't center variable width text, but for Vorple it's not a problem. 

	center "I'm centered!";
	
In non-Vorple interpreters the text is displayed in a fixed width font, but in Vorple it uses whatever the page's default font style is. To mimic the standard behavior we can apply style instructions in the text that's printed:

	center "[monospace font style]I'm centered![end style]";

We can also display text aligned right:

	right align "Over here!";

This will only work in Vorple. In other interpreters the text will be shown left-aligned.


Chapter: Headers and lists

The extension provides helper phrases for creating headers and lists ("helpers" because they're just shortcuts to phrases in the core Vorple extension.)

Headers come in six different sizes, from level 1 to 6 where 1 is the largest and 6 is the smallest. In the default Vorple theme level 1 header is about 4 times larger than the normal text size.

	place a level 3 header called "myheader" reading "Meanwhile...";
	place a level 3 header reading "":

(The "called" part is again for naming the element.)

Lists come in two different variations: ordered and unordered. Items in an ordered list are numbered, and items in an unordered list have bullet points. These phrases turn an Inform list of text into HTML lists.

	display an ordered list { "One", "Two", "Three" } called "mylist";
	display an unordered list { "One", "Two", "Three" };


Example: * Letters from a Madman - Example of all different styles available in the extension.

The letter in this example story has all the styles defined in the extension, plus a couple of combinations and colors.

	*: "Letters from a Madman"

	Include Vorple Screen Effects by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	The Front lawn is a room. The mailbox is an openable, closed, fixed in place container in the Front lawn. A letter is in the mailbox.
	
	The description of the letter is "[cursive font style][xx-large font style]Dear [red letters style]recipient[end style],[end style][end style]
	
	[strikethrough font style]Why[end style] I [emphasized font style]know[end style].
	[strong font style]I have not forgotten.[end style]
	[monospace font style]He is not [underlined font style]the one[end style].[end style]
	There are [nowrap font style]10 000 000 000[end style] beetles in my head.
	
	[end is nigh]
	
	[fantasy font style][x-large font style]We are [yellow background style]alone[end style][end style][end style]
	
	He comes. [small font style]He comes.[end style] [x-small font style]He comes.[end style] [xx-small font style]He comes.[end style]"
	
	To say end is nigh:
		right align "The end is nigh."
	
	Test me with "open mailbox / read letter".


Example: *** Monty Hall - A game show where the result is displayed with fancy font effects.

Imagine a game show where you are presented with three doors. Behind one of them is a brand new car, and behind the rest are goats. You get to choose one of the doors. Then the game host opens one of the other doors revealing a goat, and you are given a chance to either switch to the one remaining door or open the one you picked originally. The Monty Hall paradox is a counterintuitive statistical fact that switching the door gives a much higher chance at finding a car behind it.

We'll display the game's result using a custom-made CSS style file. It also styles the room header and uses a font from Google Fonts (http://www.google.com/fonts/).

The CSS file can be downloaded from https://vorple-if.com/resources.zip

	*: "Monty Hall"
	
	Include Vorple Screen Effects by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	Release along with style sheet "montyhall.css".

	Let's Make a Deal is a room.	

	Chapter 1 - Game rules

	A gamedoor is a kind of container.
	
	door A, door B and door C are fixed in place closed gamedoors in Let's Make a Deal.
	
	A goat is a kind of thing. There are 2 goats. A car is a thing.
	
	Definition: a gamedoor is unused if nothing is in it.
	Definition: a gamedoor is wrong if a goat is in it.
	Definition: a gamedoor is correct if the car is in it.
	
	To decide which gamedoor is the remaining gamedoor which is not (first - a gamedoor) or (second - a gamedoor):
		repeat with X running through gamedoors:
			if X is not the first and X is not the second:
				decide on X.
	
	When play begins:
		now the car is in a random gamedoor;
		repeat with G running through goats:
			now G is in a random unused gamedoor.
			
	Instead of opening a gamedoor when every gamedoor is closed:
		let host-chosen door be a random wrong gamedoor which is not the noun;
		let optional door be the remaining gamedoor which is not the host-chosen door or the noun;
		say "'But wait!' the host says. 'You still have a chance to change your mind.' He opens [host-chosen door] which reveals a goat.
	
'You can still open [noun], or you can switch and open [optional door] instead. Which one will you choose?'";
		now the host-chosen door is open.
		
	Instead of opening a closed gamedoor:
		say "'Congratulations!'";
		end the story saying "You win [a random thing in the noun]!".


	Chapter 2 - Room header style

	Room header is a Vorple style.

	Rule for printing the name of a room (called the place) while looking:
		say "[room header style][printed name of place][end style]".


	Chapter 3 - Epitaph style

	Prize is a Vorple style.
	
	Before printing the player's obituary:
		say prize style;

	After printing the player's obituary:
		say end style.

    Test me with "open A / open A".