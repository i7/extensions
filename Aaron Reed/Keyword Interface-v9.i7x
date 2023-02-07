Version 9.0.1 of Keyword Interface by Aaron Reed begins here.

"This extension emulates Blue Lacuna's emphasized keyword system for simplifying common IF input. Nouns, directions, and topics can be typed without a verb to examine, go, or discuss. Works with Glulx or z-code."

[Changelog:
  -- Version 9: Updated for latest build and to be adaptive. Changes version numbering to Semantic Versioning. Includes bug fixes to resolve issues with example code and test scripts by Danya D. Smith.
  -- Version 8: Updated for compatibility with Neutral Library Messages and Player Experience Upgrade
  -- Version 7: Updated for build 6F95; simplified method for setting default state of different keyword types without needing a "when play begins" rule; expanded American Dialect checks to cover all default message appearances of "emphasize," "recognize," and "color" and their variants; changed "things" command to omit items carried by the player; fixed a bug with a post-keyword setting "look" not happening in games without required keywords; many changes to the documentation to make it more accurate and clear.
  -- Version 6: Now emphasizes objects listed after opening an opaque container; omit release number in welcome message if it is not set.
  -- Version 5: Updated to use no deprecated features
  -- Version 4: Updated for build 6859
  -- Version 3: Allowed scenery to be highlighted by default.
  -- Version 2: fixed a namespace issue (output --> KI output)
]

[Possible future improvements:
 -- Add Blue Lacuna's ability to assume the last noun if a verb is typed alone.
 -- Add Walker & Silhouette's ability to take sensible actions after examine: so BOX the first time might examine it, then BOX the next time would open it.
 -- Add ALL CAPS as another emphasis style.
]

Chapter - Compatibility

Section - Inclusions

Include Basic Screen Effects by Emily Short.

Chapter - Setup

Keywords required is initially false.


Chapter - Things

Section - Examine Grammar Line

Understand "[a thing]" as examining.

Section - Definitions

Object keyword highlighting is initially true. [Global activation of object keywords.]

Every thing has a text called the keyword. The keyword of a thing is usually "". [which word of a multi-word noun should be highlighted. In practice, the player can type any word with the same effect, but for presentation purposes it's best to have a single word highlighted.]

A thing is either keyworded or keywordless. A thing is usually keyworded. Scenery is usually keywordless. [Only keyworded things are not automatically highlighted in room descriptions.]

Object keywording something is an activity on objects.

Rule for printing the name of a thing (called item) while looking (this is the Keyword Interface highlight objects when looking rule):
	carry out the object keywording activity with item.

Rule for printing the name of a thing (called item) while taking inventory (this is the Keyword Interface highlight objects when taking inventory rule):
	carry out the object keywording activity with item.

Rule for printing the name of a thing (called item) while opening (this is the Keyword Interface highlight objects when opening rule):
	carry out the object keywording activity with item.
		

Section - Rule for object keywording something

Rule for object keywording something (called item) (this is the Keyword Interface object keywording rule):
	if object keyword highlighting is false or item is keywordless:
		say the printed name of item;
		continue the action;
	let output be indexed text;
	now output is the printed name of item;
	let kw be indexed text;
	now kw is the keyword of item;
	if kw is "", now kw is word number ( the number of words in output ) in output;
	repeat with wordcounter running from 1 to the number of words in output:
		say "[if wordcounter > 1] [end if]";
		if word number wordcounter in output matches the regular expression "\b(?i)[kw]":
			say "[o][word number wordcounter in output][x]";
		else:
			say "[word number wordcounter in output]".


Chapter - Exits

Section - Definitions

Direction keyword highlighting is initially true.

Understand "[a direction]" as going. Understand "[an open door]" as entering.

Direction keywording something is an activity. 

Rule for printing the name of a direction (called dir) while looking (this is the Keyword Interface highlight directions while looking rule):
	carry out the direction keywording activity with dir.

Rule for printing the name of a direction (called dir) while listing exits (this is the Keyword Interface highlight directions while listing exits rule):
	carry out the direction keywording activity with dir.

Section - Rule for direction keywording something

Rule for direction keywording a direction (called dir) (this is the Keyword Interface direction keywording rule):
	if direction keyword highlighting is false:
		say the printed name of dir;
		continue the action;
	say "[d][the printed name of dir][x]".


Chapter - Topics

Topic keyword highlighting is initially false.

Topic keywording something is an activity on objects.


Chapter - Parser

Parser highlighting is initially false.

To say as the parser:
	now we-are-parser-speaking is true;
	set the text style for the style of parser-word.
	 
To say as normal:
	now we-are-parser-speaking is false; 
	reset styles with the style of parser-word.


Chapter - Don't auto-convert parser messages (For use without Neutral Library Messages by Aaron Reed)

Section - Don't auto-convert parser messages (For use without Player Experience Upgrade by Aaron Reed)

Before printing a parser error when parser highlighting is true (this is the Keyword Interface before printing a parser error rule):
	say "[as the parser]".

After printing a parser error when parser highlighting is true (this is the Keyword Interface after printing a parser error rule):
	say "[as normal]". 


Chapter - Keyword Types

A keyword type is a kind of thing. object-word is a keyword type. direction-word is a keyword type. topic-word is a keyword type. parser-word is a keyword type.

A keyword emphasis is a kind of value. The plural of keyword emphasis is keyword emphases. 

A keyword type has a keyword emphasis called style. 

The active style is a keyword emphasis that varies. 

we-are-parser-speaking is initially false.  [It's possible to have, say, an emphasized object keyword within a parser error message; this variable keeps track of whether we need to return to the parser style after switching off another keyword style.]
	
To say o:
	if object keyword highlighting is true:
		set the text style for the style of object-word; 
		now the active style is the style of object-word.
	
To say t:
	if topic keyword highlighting is true:
		set the text style for the style of topic-word; 
		now the active style is the style of topic-word.  	      
 
To say d: 
	if direction keyword highlighting is true:
		set the text style for the style of direction-word;
		now the active style is the style of direction-word.  	  
	 
To say x:
	reset styles with active style;
	         
Section - Glulx Style Definitions (for Glulx only)

Include Glulx Text Effects by Emily Short. 

The keyword emphases are keyword-color1-style, keyword-color2-style, keyword-bold-style, keyword-italics-style, keyword-fixedwidth-style, and keyword-no-style.

The style of object-word is usually keyword-color1-style. The style of direction-word is usually keyword-color2-style. The style of topic-word is usually keyword-bold-style. The style of parser-word is usually keyword-italics-style.

Table of User Styles (continued)
style name	fixed width	font weight	relative size	color
special-style-1	false	bold-weight 	0	"#0000FF"	[blue]
special-style-2	false	bold-weight 	0	"#339933"	[green]

To set the text style for (val - a keyword emphasis):
	if val is keyword-color1-style:
		say first custom style;
	else if val is keyword-color2-style:
		say second custom style;
	else if val is keyword-bold-style:
		say bold type;
	else if val is keyword-italics-style:
		say italic type;
	else if val is keyword-fixedwidth-style:
		say fixed letter spacing;
	else if val is keyword-no-style:
		do nothing.

To reset styles with (val - a keyword emphasis):
	if val is keyword-fixedwidth-style:
		say variable letter spacing;
	else:
		say roman type;
	if we-are-parser-speaking is true, say as the parser. 

Section - Z-Machine Style Definitions (for Z-machine only)

The keyword emphases are keyword-red, keyword-green, keyword-yellow, keyword-blue, keyword-magenta, keyword-cyan, keyword-white, keyword-bold-style, keyword-italics-style, keyword-fixedwidth-style, and keyword-no-style.

The style of object-word is usually keyword-blue. The style of direction-word is usually keyword-magenta. The style of topic-word is usually keyword-red. [These are really the only three z-code colors that are readable on a white background.] The style of parser-word is usually keyword-italics-style.

To set the text style for (val - a keyword emphasis):
	if val is keyword-red:
		say red letters;
		say bold type;
	else if val is keyword-green:
		say green letters;
		say bold type;
	else if val is keyword-yellow:
		say yellow letters;
		say bold type;
	else if val is keyword-blue:
		say blue letters;
		say bold type;
	else if val is keyword-magenta:
		say magenta letters;
		say bold type;
	else if val is keyword-cyan:
		say cyan letters;
		say bold type;
	else if val is keyword-white:
		say white letters;
		say bold type;
	else if val is keyword-bold-style:
		say black letters;
		say bold type;
	else if val is keyword-italics-style:
		say italic type;
	else if val is keyword-fixedwidth-style:
		say fixed letter spacing;
	else if val is keyword-no-style:
		do nothing.

To reset styles with (val - a keyword emphasis):
	if val is keyword-fixedwidth-style:
		say variable letter spacing;
	else:
		say roman type;
		say default letters;
	if we-are-parser-speaking is true, say as the parser. 


Chapter - Changing Style

Setting the keyword emphasis is an action out of world applying to nothing. Understand "keyword" or "keywords" as setting the keyword emphasis. 
 
tempstyles is a list of keyword emphases that varies.

Carry out setting the keyword emphasis (this is the Keyword Interface carry out setting keyword emphasis rule): 
	carry out the setup keyword emphasis activity;

Setup keyword emphasis is an activity.

Rule for setup keyword emphasis (this is the setup keyword emphasis rule): 
	let mychar be 1;   
	[Keep track of which menu number is assigned to each of the four possible options.]
	let object-number be 0;
	let direction-number be 0;
	let topic-number be 0;
	let parser-number be 0;
	while mychar is not 0:
		clear the screen;  
		let menu-counter be 0; 
		say "[story title] makes use of [emphasiz]ed keywords. It is [if keywords required is true]necessary[else]recommended[end if] that your interpreter program correctly displays them with some form of emphasis. Type a number below to cycle through display options until you find one that shows clearly on your system." (A);
		say line break;
		if object keyword highlighting is true:
			increase menu-counter by 1;
			say "[menu-counter]) ";
			now object-number is menu-counter;
			say "[Emphasiz]ed [o]object[x] keywords currently look like [o]this[x]." (B);
		if direction keyword highlighting is true:
			increase menu-counter by 1;
			say "[menu-counter]) ";
			now direction-number is menu-counter;
			say "[Emphasiz]ed [d]exit[x] keywords currently look like [d]this[x]." (C);
		if topic keyword highlighting is true:
			increase menu-counter by 1;
			say "[menu-counter]) ";
			now topic-number is menu-counter;
			say "[Emphasiz]ed [t]topic[x] keywords currently look like [t]this[x]." (D);
		if parser highlighting is true:
			say line break;
			increase menu-counter by 1;
			say "[menu-counter]) ";
			now parser-number is menu-counter;
			say "[as the parser]Messages from the parser currently display like this[as normal]." (E);
		[Print a warning if emphasis is disabled in a game where keywords are required; note that the player is still allowed to disable emphasis, if they choose.]
		if keywords required is true:
			if ( object keyword highlighting is true and style of object-word is keyword-no-style ) or ( direction keyword highlighting is true and  style of direction-word is keyword-no-style ) or ( topic keyword highlighting is true and style of topic-word is keyword-no-style ) :
				say "[line break]**A warning: The [emphasiz]ed keywords are integral to [story title]'s design. It may be difficult or impossible to know how to continue if emphasis is not visible.**" (F);
		[Print a warning if any two active keyword styles are the same.]
		truncate tempstyles to 0 entries;
		let duplicated-style be false;
		if object keyword highlighting is true:
			add style of object-word to tempstyles;
		if direction keyword highlighting is true:
			if style of direction-word is listed in tempstyles:
				now duplicated-style is true;
			else:
				add style of direction-word to tempstyles;
		if topic keyword highlighting is true:
			if style of topic-word is listed in tempstyles:
				now duplicated-style is true;
		if duplicated-style is true:
			say "[line break]**A warning: it may be useful to distinguish one type of keyword from another.**" (G);
		[Show instruction message and get the player's single-character input.]
		say "[paragraph break]Press 0 when you're finished here, or 9 to [if screen reader mode is true]de[end if]activate screen reader mode.[run paragraph on]" (H);
		now mychar is single-character - 48; [Converts ASCII to actual number typed.]
		[Process the player's input.]
		if mychar is object-number:
			advance style with object-word;
		otherwise if mychar is direction-number:
			advance style with direction-word;
		otherwise if mychar is topic-number:
			advance style with topic-word;
		otherwise if mychar is parser-number:
			advance style with parser-word;
		otherwise if mychar is 9:
			clear the screen;
			try setting screen reader mode; 
			say "Press any key to continue." (I);
			wait for any key;
			now mychar is 0;
	[Upon quitting, clear the screen and look.]
	clear the screen;
	if pre-game keyword setting is true:
		now pre-game keyword setting is false;
		do nothing;
	otherwise:
		try looking. 
	  
To advance style with (kwtype - a keyword type):
	now the style of kwtype is the keyword emphasis after the style of kwtype.

To decide which number is single-character: (- (VM_KeyChar()) -).

Chapter - Screen Reader Mode

[Screen reader mode does not have much effect by itself; it's mainly provided as a hook for authors with games containing other visual-oriented features. For instance, Blue Lacuna's backwards messages are described in prose rather than presented literally if screen reader mode is true.]

Screen reader mode is a truth state that varies. 

Setting screen reader mode is an action out of world. Understand "screenreader" or "screen reader" as setting screen reader mode.
	
Carry out setting screen reader mode (this is the Keyword Interface carry out setting screen reader mode rule):
	if screen reader mode is true:
		now screen reader mode is false;
		say "Screen reader mode has been deactivated." (A);
	else:
		now screen reader mode is true; 
		say "Screen reader mode has been activated. [story title] uses [emphasiz]ed keywords to indicate important words you may type to advance the story. Your reader software may put a [recogniz]able vocal stress on [emphasiz]ed words like [o]this[x] one. If it doesn't, you can type [o]things[x] from any prompt for a list of nearby objects, or type [d]exits[x] for a list of nearby directions. Type [o]keywords[x] to adjust the style of keywords, or type screen reader with no space to toggle this mode on or off." (B).

Section - Exits

[This routine is lifted straight from the example in the Inform 7 docs.]

Understand "exits" as listing exits. Listing exits is an action out of world applying to nothing.

Definition: a direction (called thataway) is viable if the room thataway from the location is a room.

Carry out listing exits (this is the Keyword Interface carry out listing exits rule):
	let count of exits be the number of viable directions; 
	if the count of exits is 0, say "[It] [seem] there [are] nowhere to go." (A);
	otherwise say "From here, [if the number of viable directions is 1]the only way out [are] to[otherwise][we] [can go] to[end if] [a list of viable directions]." (B).

Section - Things

Understand "things" as thing listing. Thing listing is an action out of world applying to nothing.

Carry out thing listing (this is the Keyword Interface carry out thing listing rule):
	say "Nearby [is-are a list of visible other things which are not carried by the player][if the number of visible other things which are not carried by the player is 0] of note[end if]." (A)

Definition: a thing is other if it is not the player.

Rule for printing the name of a thing (called item) while thing listing:
	carry out the object keywording activity with item.


Chapter - Beginning Play
	 
Section - Keyword Interface setup rule

pre-game keyword setting is a truth state that varies. pre-game keyword setting is true.

When play begins (this is the Keyword Interface setup trigger rule):
	if keywords required is false:
		now pre-game keyword setting is false;
		continue the action;
	clear the screen;
	let mychar be 1; 
	say "Welcome to [o][story title][x][if release number > 0], release [release number][end if].[paragraph break]If no words above were [color]ed or [emphasiz]ed, press K now.[paragraph break]Press [t]N[x] to begin from the beginning or [t]R[x] to restore an existing story." (A);
	while mychar is not 0:
		now mychar is single-character; 
		if mychar is 82 or mychar is 114: [ r or R: restore ]
			restore the game;  
		if mychar is 75 or mychar is 107: [ k or K: keyword ]
			carry out the setup keyword emphasis activity;
			now mychar is 0;
		if mychar is 78 or mychar is 110: [ n or N: new game ]
			now mychar is 0;
	clear the screen;
	say "[line break][line break][line break]";
	now pre-game keyword setting is false.    
 
To restore the game: (- RESTORE_THE_GAME_R(); -).


Chapter - Error Reporting

Section - Not a verb I recognise

Rule for printing a parser error when the latest parser error is the not a verb I recognise error (this is the Keyword Interface not a verb I recognise rule) : say "[as the parser]That's neither a verb I [recogniz]e nor a keyword you can use right now.[as normal]" (A). [Acknowledge that the player may be trying to type a keyword, not just a verb.]


Chapter - Messages

Section - Keyword Introduction Text

Showing the keyword introduction text is an activity.

For showing the keyword introduction text (this is the Keyword Interface showing the keyword introduction text rule):
	say "As you read [story title], you'll see certain [emphasiz]ed keywords in the prose. Type any keyword to advance the story. [if object keyword highlighting is true]You can type an [emphasiz]ed [o]object[x] keyword to examine that item more closely. [end if][if direction keyword highlighting is true]An [emphasiz]ed [d]direction[x] indicates that typing that word will move you that direction or towards that distant scenery. [end if][if topic keyword highlighting is true]An [emphasiz]ed word in [t]conversation[x] means typing that word will steer the conversation towards that topic. [end if][paragraph break]If the keyword[if the number of active keyword systems > 1]s in the paragraph above are[else] in the paragraph above is[end if] not distinct from the surrounding text, type KEYWORDS to adjust the display style." (A)

[This extension uses a statistically unlikely number of words with spellings that differ in America. We define a number of text substitutions to let us easily switch between.]

To say emphasiz: if the American dialect option is active, say "emphasiz"; else say "emphasis". To say Emphasiz: if the American dialect option is active, say "Emphasiz"; else say "Emphasis".

To say color: if the American dialect option is active, say "color"; else say "colour". To say Color: if the American dialect option is active, say "Color"; else say "Colour".

To say recogniz: if the American dialect option is active, say "recogniz"; else say "recognis". To say Recogniz: if the American dialect option is active, say "Recogniz"; else say "Recognis".

To decide what number is the number of active keyword systems:
	let ctr be 0;
	if object keyword highlighting is true, increase ctr by 1;
	if direction keyword highlighting is true, increase ctr by 1;
	if topic keyword highlighting is true, increase ctr by 1;
	decide on ctr.


Keyword Interface ends here.

---- DOCUMENTATION ----

This extension emulates the emphasized keyword system for streamlining common IF input, as seen in "Blue Lacuna." Nouns, directions, and topics are highlighted and can be typed without verbs to examine, move, or discuss, respectively. (Topics are implemented only in skeletal form to allow for integration with any conversation system; Keywords for Conversation by Matt Wigdahl, for instance, will integrate it with Eric Eve's Conversation Package extensions.) A full system for letting the player select his own preferred color scheme and keeping games backwards-compatible for players on screen readers or with no color support is also included. The extension is compatible with either z-code or Glulx.

A warning: Inform authors using color have poor options on either platform. In z-code games, colors can be freely adjusted, but are limited to a palette of eight neon shades, only a few of which will be readable on any given backdrop. Glulx users can select from a palette of sixteen million colors, but can only make two of these available at a time, and these cannot be changed during play. On z-code, all eight colors are made available to the user and can be adjusted by player or author at any time; on Glulx, the two defaults are blue and green, and only authors can customize this. On both platforms, bold, italics, and fixed-width are offered as alternatives to colored keywords.

Section: Basic Usage

Keyword Interface allows an emphasis style to be set for one of four possible categories. Each of these can be enabled or disabled independently by the author or player. By default, they are set as follows:

	Object keyword highlighting is initially true.
	Direction keyword highlighting is initially true.
	Topic keyword highlighting is initially false.
	Parser highlighting is initially false.

These can be enabled or disabled at any time during play through a "now" statement, or globally by making a more definitive assertion:

	Object keyword highlighting is false.

If keywords are a crucial component of your game, you can add the following:

	Keywords required is true.

This will bring up a message before your game begins ensuring that players can see the keyword highlighting, and giving them an option to adjust styles. Alternatively, you can advertize the KEYWORD verb to players, which brings up the same menu, or show some stock explanatory text, customized to which keywords are enabled, by using the following phrase, perhaps in the carry out rule for an "about" command:

	carry out the showing the keyword introduction text activity

Section: Objects

When object keyword highlighting is set to true, the extension will automatically emphasize non-scenery objects listed by the parser. Objects in descriptive text may be manually emphasized by wrapping them in [o] and [x] substitutions.

	The Office is a room. "Only a bare [o]bulb[x] illuminates this dim office, empty except for a solitary desk.". A desk and a bare bulb are scenery in the office. On the desk is a telephone book and the lamp.

This produces output like the following (where emphasis is marked with asterisks):

	The Office
	Only a bare *bulb* illuminates this dim office, empty except for a solitary desk.

	On the desk are a telephone *book* and a *lamp*.

If you want scenery items to be automatically emphasized, you can manually set them as keyworded, or include a line like the following (which would add emphasis to "desk" in the final line above):

	When play begins: now every scenery thing is keyworded.

The emphasized word will be the final word of the object's printed name. To change this, you can use the object's "keyword" text property, which should be one of the other words in the printed name. You can also define an object as "keywordless," in which case it will never be automatically emphasized.

	A book of memories with keyword "book" is in the Office. Some scattered cigarettes are a keywordless thing in the Office.

Produces:

	"You can also see a *book* of memories and some scattered cigarettes here."

Automatic emphasis normally occurs when looking, opening or taking inventory. If you want to disable one of these you can use code like the following:

	The Keyword Interface highlight objects when looking rule is not listed in any rulebook.

Conversely, if you want object highlighting during other times, you can use code like this:
	
	Rule for printing the name of a thing (called item) while asking which do you mean:
		carry out the object keywording activity with item.

Section: Directions

When direction keyword highlighting is set to true and cardinal directions are wrapped in brackets in room descriptions, these will be emphasized as they are printed.

	"Gloomy passages depart to the [south] and [east]."

Compassless navigation as seen in Blue Lacuna can be implemented by adding a directional keyword as a synonym for the intended direction, limiting this to the specific room in which that keyword is valid, and wrapping the relevant word in "d" and "x" tags in the descriptive text.

	"Gloomy passages depart down a dusty set of [d]stairs[x] and through a wide [d]passage[x]." Understand "stairs" as south when location is Gloomy Tunnel. Understand "passage" as east when location is Gloomy Tunnel.

An "exits" verb is included with Keyword Interface to assist blind users or those without color interpreters (who in the above example would have no way of knowing which words correspond to movement). EXITS lists all of the cardinal exits from the current location. If your game uses compassless navigation, you may want to extend this verb to print your keywords instead (see the "Gnome's Holiday" example below for one way to do this).

Section: Topics

Since there are so many different conversation systems, support for highlighting conversation topics is only vestigial. It's turned on when "topic keyword highlighting" is set to true and you can invoke it with the "[t]topic[x]" wrapper, but everything else will have to be done by hand to match your own conversation system. Again, see "Gnome's Holiday" for a simple example of a keyword-based conversation system.

Section: Parser Messages

The extension can also style parser messages differently from normal game text. This may be useful to authors who wish to differentiate error messages ("I didn't understand the first part of that.") from in-game admonishments ("You wouldn't be caught dead wearing that.")

Parser error highlighting is disabled by default; you can turn it on with

	Parser highlighting is true.

If your game defines new parser error messages or rewrites existing ones, you should wrap them in the "as the parser" and "as normal" say statements:

	Understand "floop" as a mistake ("[as the parser]To cast a spell, you must cast it on something, like FLOOP THE MATTRESS.[as normal]").

Section: Control

To change the default color values at the start of play, authors can use syntax like:

	The style of object-word is keyword-cyan.

The four modes are object-word, direction-word, topic-word, and parser-word. For Glulx games, possible styles are keyword-color1-style and keyword-color2-style; for z-code games, they are keyword-red, keyword-green, keyword-yellow, keyword-blue, keyword-magenta, keyword-cyan, keyword-white, and keyword-black. Both VMs provide the additional styles keyword-bold-style, keyword-italics-style, keyword-fixedwidth-style, and keyword-no-style.

To change the Glulx colors, you can adjust g-color1 and g-color2 by amending the Table of Common Color Values-- see the documentation for "Glulx Text Effects" by Emily Short for more information.

	Table of Common Color Values (amended)
	glulx color value	assigned number   
	g-color1	15645627

All messages the extension prints are customizable responses. Use the RESPONSES testing command to view them, then adjust with a line like the following:
	
	The setup keyword emphasis rule response (B) is "This is what [o]objects[x] look like."

Section: Screen Reader Mode

By typing "screen reader" or selecting the appropriate option from the keyword customization menu, players can set the internal variable "screen reader mode" to true. Blind players and those without color interpreters can activate this mode. This might be useful to provide an alternative if your game contains other visual components such as a map, or uses color in puzzles.

The extension provides two verbs to assist color-challenged players: a "things" command which prints a list of nearby objects, and an "exits" command which summarizes the nearby directions. If you're using compassless navigation, you may want to customize the exits command to make use of your custom direction names. Additionally, if your game features conversation, strongly consider building a "topics" command to round out the set.


Section: Disambiguation

Inform's normal disambiguation assumes that every command begins with a verb, which means conflicts between keywords, and between keywords and verbs, are hard or impossible to control. The best solution is to make sure your object, direction, and topic keywords have no overlap.

*If an object and direction keyword* are in the same scope, the parser silently assumes the player means the direction keyword, and will print a seemingly useless "(the object)" clarification if the player manually examines that object instead.

*If a highlighted keyword matches a verb*, the verb will take precedence. For example, typing "set" to reference a chess set would instead produce the message "What do you want to set?" The best way to avoid this is to change the keyword and description of the object to avoid mentioning the verb word-- in this case "chessboard" might be a good substitute. You could also disable the verb if it's not one your story uses (see "Overriding existing commands" in the docs).

*Conversation systems should take precedence over objects* since this is what players will expect. See the example below for one implementation of this.


Example: * Sense of Direction - A simple usage of the extension to print bold compass directions.

The flexibility of Keyword Interface means it can be used for multiple purposes. Here we strip away and focus some of its functionality to simply print compass directions in bold.

	*: "Sense of Direction"

	Include Keyword Interface by Aaron Reed.

	Object keyword highlighting is false. The style of direction-word is keyword-bold-style.

	Labyrinth is south of Passage and west of Halls. Halls is south of Dungeon and west of Pit. Pit is south of Harrows. Harrows is east of Dungeon and south of Caverns. Dungeon is east of Passage and south of Abyss. Passage is south of Abattoir. Abattoir is west of Abyss and north of Passage. Abyss is west of Caverns.   

	After looking: try listing exits.

	[This is the correct order for test commands, but for some reason they are running in reverse]
	[Test me with "north / north / east / south / south / east / north / north / west / west / south / south".]
	[So test with this instead:]
	Test me with "south / south / west / west / north / north / east / south / south / east / north / north".

Example: ** The Gnome's Holiday - A full example of emphasized objects, compassless directions, and conversation topics.

We'll create a slightly longer scenario with several locations and a simple puzzle, to demonstrate the full potential of Keyword Interface. This story has "keywords required" set to true, so it begins with a menu that helps players calibrate keywords.

We implement an extremely simple conversation system to demonstrate emphasized topic words. Note that a real conversation system would need to be much more robust and elaborate. We'll also create a variation on the exits verb to show our compassless exits.

	*: "The Gnome's Holiday"

	Include Keyword Interface by Aaron Reed. Use American dialect.

	Topic keyword highlighting is true. Parser highlighting is true. Keywords required is true.  

	After printing the banner text: say "First time players type ABOUT for more instructions.".

	Section - Conversation

	keyword-asking is an action applying to one thing. Understand "[a speakable]" as keyword-asking when the number of other people in location > 0.

	Carry out keyword-asking:
		let subject be a random other person in the location;
		say "[message of noun][paragraph break]".	
 
	A speakable is a kind of thing. A speakable has some text called the message. Instead of doing anything other than keyword-asking to a speakable: say "That's merely a topic of conversation.". Does the player mean doing something other than keyword-asking to a speakable: it is very unlikely.  

	Section - Exits

	Every room has some text called the exits text.

	First carry out listing exits: 
		unless the exits text of location is "":
			say the exits text of location;
			say line break;
		stop the action.

	After looking: try listing exits. 

	Section - Instructions

	Understand "about" as requesting the about text. Requesting the about text is an action out of world applying to nothing. Carry out requesting the about text: carry out the showing the keyword introduction text activity.
  
	Section - Game

	Gnome's Garden is a room with description "Brightly pastel flowers dot this well-kept garden, bordering a button-cute shack with whimsical stylings on the edge of the river, which is spanned here by a [drawbridge]." and exits text "A [d]path[x] of cherry-colored bricks winds off towards some distant hills, while the [if shack door is open][d]door[x] to the gnome's shack stands open[else]door to the gnome's shack is closed[end if][if drawbridge is open]. The lowered drawbridge spans the river to a treasure-strewn [d]wonderland[x][end if].". Understand "path" as west when location is Gnome's Garden. 

	A stone table is a keywordless fixed in place supporter in Gnome's Garden. On the table is a copy of the Daily Gnomon with description "You can't read gnomish, but you can make a great gnocchi." The keyword of the Daily Gnomon is "copy". The button-cute shack is scenery in Gnome's Garden. Instead of entering shack, try going north.

	The shack door is a closed locked undescribed door with keyword "door". It is north of Gnome's Garden and south of Cozy Shack. The can't go through undescribed doors rule is not listed in any rulebook. Instead of going inside in Gnome's Garden, try going north.

	The drawbridge is a closed unopenable door. "[if closed]The drawbridge is raised, allowing passage by a steady stream of tiny steamboats, but preventing access to the treasure-strewn wonderland on the other side of the river[else]Wee steamboats queue impatiently behind the lowered drawbridge[end if].". It is east of Gnome's Garden and west of the Treasure-Strewn Wonderland. The description of drawbridge is "[if closed]If only you could find a way to lower it and cross the river![else]The treasure-strewn wonderland across the river awaits![end if]".

	The cherry-brick path is a backdrop. It is everywhere. Understand "cherry/cherry-colored/colored" as path. 

	Golden Pasture is a room with description "The grass here is thick and heavy, sparkling with gold and amber hues." and exits text "Only the [d]path[x] back to the garden is clear." Golden Pasture is west of Gnome's Garden. Understand "path" as east when location is Golden Pasture.

	The gnome is a person in Golden Pasture. "A [gnome] perches on a checkered toadstool here, stroking his beard in relaxed contentment." The description is "Dressed in brightly colored clothes, he has the cheerful air of someone on holiday.".

	After examining the gnome, say "You could ask him about his [t]dragon[x], the [t]weather[x], or the [t]drawbridge[x].". 

	A pet dragon creature is a female animal in Golden Pasture. "Clinging anxiously to the gnome's cap is a tiny bronze [o]creature[x].". The description is "Looking closer, you see she is a beautiful baby dragon. She regards you [if we have keyword-asked the personality topic]with a friendly twinkle in her eye[else]fearfully, clutching the gnome's hat with an almost comically tight grip[end if]."  

	The dragon topic is a speakable with message "'You like her?' the gnome says fondly, petting the dragon which watches you nervously. 'She's named [t]Quinnabel[x].'".

	The Quinnabel topic is a speakable with message "'Found her in an old mushroom mine,' the gnome says, warming to his subject. The dragon sniffs you tentatively. 'She's got quite a [t]personality[x].'".

	The personality topic is a speakable with message "'Oh, she's shy at first, but she'll warm up to you right away if you let her.' And sure enough, the dragon finally seems to take a liking to you, and purrs contentedly as you scratch it behind the ears.". After keyword-asking the personality topic for the first time: say "'See, you're not such a bad sort,' the gnome says. 'Why don't you take this key and see to that drawbridge yourself.' And he hands you a scuffed silver key (oversized even for you)."; move silver key to player. The silver key unlocks the shack door.

	The drawbridge topic is a speakable with message "'Hrmph,' the gnome mutters, crossing his arms defiantly, 'I'm supposed to be on vacation.'".

	The weather topic is a speakable with message "'Looks like another day of beautiful sunshine again,' he grumbles.".

	The gnome carries dragon topic, Quinnabel topic, personality topic, drawbridge topic, and weather topic.  

	The description of Cozy Shack is "Strewn with bric-a-brac; your eyes are drawn immediately to the prominent [lever] on the riverward wall.". The exits text of Cozy Shack is "The only place to go is back [outside].". Instead of going outside in Cozy Shack, try going south. Instead of exiting in Cozy Shack, try going south.

	A lever is an undescribed device in Cozy Shack. Instead of pushing or pulling the lever, try switching on the lever. After switching on the lever: now drawbridge is open; say "You hear a splash and a creak from outside the shack.".

	After going to Treasure-Strewn Wonderland for the first time: say "You enter the land of treasure. Congratulations!"; end the story saying "You have won". Understand "wonderland" as east when location is Gnome's Garden.

	[This is the correct order for test commands, but for some reason they are running in reverse]
	[Test me with "N / ABOUT / copy / path / gnome /  drawbridge / weather / dragon / Quinnabel / personality / creature / path / unlock door / open door / door / door /  lever / pull lever / out / wonderland".]
	[So test with this instead:]
	Test me with " wonderland / out / pull lever / lever / door / open door / unlock door / path / creature / personality / Quinnabel / dragon / weather / drawbridge / gnome / path / copy / ABOUT / N".
