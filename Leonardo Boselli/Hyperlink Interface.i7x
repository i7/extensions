Version 1 of Hyperlink Interface (for Glulx only) by Leonardo Boselli begins here.

"This extension modifies the emulation of Blue Lacuna's emphasized keyword system for simplifying common IF input (by Aaron Reed) substituting emphasis with hyperlinks. Objects, directions, and topics can be clicked directly to examine, go, or discuss. Works with Glulx. Requires Basic Hyperlinks by Emily Short and Text Capture by Eric Eve."

"heavily based on Keyword Interface by Aaron Reed"

Include Basic Screen Effects by Emily Short.

Hyperlinks required is a truth state that varies. Hyperlinks required is false.

Chapter - Menus

Menu hyperlink shown is a truth state that varies. Menu hyperlink shown is false.

Showing hyperlinks menu is an action applying to nothing.
Understand "menu" as  showing hyperlinks menu.
Carry out showing hyperlinks menu:
	let CT be HI max hyperlinks;
	say "[line break][fixed letter spacing] [set link  2]look[end link] [set link 3]inventory[end link]";
	if topic hyperlink highlighting is true:
		say " [set link 4]topics[end link]";
	if object hyperlink highlighting is true:
		say " [set link 5]things[end link]";
	if direction hyperlink highlighting is true:
		say " [set link 6]exits[end link]";
	say "[roman type][line break]".

Chapter - Things

Section - Definitions

Object hyperlink highlighting is a truth state that varies. Object hyperlink highlighting is true. [Global activation of object hyperlinks.]

Understand "[a thing]" as examining.

Every thing has a text called the keyword. The keyword of a thing is usually "". [which word of a multi-word noun should be highlighted. In practice, the player can type any word with the same effect, but for presentation purposes it's best to have a single word highlighted.]

A thing is either hyperlinked or hyperlinkless. A thing is usually hyperlinked. [Hyperlinkless things are not automatically highlighed in room descriptions.]

Object hyperlinking something is an activity.

Rule for printing the name of a thing (called item) while looking (this is the Hyperlink Interface highlight objects when looking rule):
	carry out the object hyperlinking activity with item.

Rule for printing the name of a thing (called item) while taking inventory (this is the Hyperlink Interface highlight objects when taking inventory rule):
	carry out the object hyperlinking activity with item.

Section - Hyperlinks management

The HI max hyperlinks is a number that varies.
The HI max hyperlinks is 50.
The HI min hyperlinks is a number that varies.
The HI min hyperlinks is 7.

The HI hyperlinks counter is a number that varies.
The HI hyperlinks counter is 6.

Include Basic Hyperlinks by Emily Short.

List of Hyperlink Glulx Replacement Commands is a list of indexed texts that varies.
List of Hyperlink Glulx Replacement Commands is {}.

First when play begins:
	let T be an indexed text;
	let T be "menu";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "look";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "inventory";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "topics";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "things";
	add T to List of Hyperlink Glulx Replacement Commands;
	let T be "exits";
	add T to List of Hyperlink Glulx Replacement Commands;
	change the command prompt to "[set link 2] l [end link]|[set link 3] i [end link]| [set link 1]menu[end link]>";
	repeat with CT running from (HI min hyperlinks) to (HI max hyperlinks):
		let T be "";
		add T to List of Hyperlink Glulx Replacement Commands.

A clicking hyperlink rule (this is the HI default command replacement by hyperlinks rule):
	let N be the number of entries in the List of Hyperlink Glulx Replacement Commands;
	if the current link number is less than N plus 1:
		change the glulx replacement command to the entry current link number of the List of Hyperlink Glulx Replacement Commands.

The HI default command replacement by hyperlinks rule is listed instead of the the default command replacement by hyperlinks rule in the clicking hyperlink rules.

Include Text Capture by Eric Eve.

To start HI hyperlink capture:
	if the active style is not hyperlink-no-style:
		increment HI hyperlinks counter by 1;
		if HI hyperlinks counter greater than HI max hyperlinks,
			change HI hyperlinks counter to HI min hyperlinks;
		say "[set link HI hyperlinks counter]";
		start capturing text.

To end HI hyperlink capture:
	if the active style is not hyperlink-no-style:
		stop capturing text;
		say "[captured text][end link]";
		change entry HI hyperlinks counter of List of Hyperlink Glulx Replacement Commands to "[captured text]".

The HI hyperlink text is an indexed text that varies.
To print HI hyperlink:
	increment HI hyperlinks counter by 1;
	if HI hyperlinks counter greater than HI max hyperlinks,
		change HI hyperlinks counter to HI min hyperlinks;
	say " [set link HI hyperlinks counter][HI hyperlink text][end link][line break]";
	change entry HI hyperlinks counter of List of Hyperlink Glulx Replacement Commands to "[HI hyperlink text]".

Section - Rule for object hyperlinking something

Rule for object hyperlinking something (called item) (this is the Hyperlink Interface object hyperlinking rule):
	if object hyperlink highlighting is false or item is hyperlinkless:
		say the printed name of item;
		continue the action;
	let output be indexed text;
	now output is the printed name of item;
	let hl be indexed text;
	now hl is the keyword of item;
	if hl is "", change hl to word number ( the number of words in output ) in output;
	repeat with wordcounter running from 1 to the number of words in output:
		say "[if wordcounter > 1] [end if]";
		if word number wordcounter in output matches the regular expression "\b(?i)[hl]":
			if the item is scenery:
				say "[s][word number wordcounter in output][x]";
			otherwise:
				say "[o][word number wordcounter in output][x]";
		else:
			say "[word number wordcounter in output]".


Chapter - Exits

Section - Definitions

Direction hyperlink highlighting is a truth state that varies. Direction hyperlink highlighting is true.

Understand "[a direction]" as going. Understand "[an open door]" as entering.

Direction hyperlinking something is an activity.

Every direction has a text called printed name. The printed name of a direction is usually "that way". The printed name of north is "north". The printed name of northeast is "northeast". The printed name of east is "east". The printed name of southeast is "southeast". The printed name of south is "south". The printed name of southwest is "southwest". The printed name of west is "west". The printed name of northwest is "northwest". The printed name of up is "up". The printed name of down is "down". The printed name of inside is "in". The printed name of outside is "out".

The saved direction is a direction that varies.

Rule for printing the name of a direction (called dir) while looking (this is the Hyperlink Interface highlight directions while looking rule):
	now the saved direction is dir;
	carry out the direction hyperlinking activity.

Rule for printing the name of a direction (called dir) while exits listing (this is the Hyperlink Interface highlight directions while exits listing rule):
	now the saved direction is dir;
	carry out the direction hyperlinking activity.

Section - Rule for direction hyperlinking something

Rule for direction hyperlinking (this is the Hyperlink Interface direction hyperlinking rule):
	if direction hyperlink highlighting is false:
		say the printed name of the saved direction;
		continue the action;
	say "[d][the printed name of the saved direction][x]".


Chapter - Topics

Topic hyperlink highlighting is a truth state that varies. Topic hyperlink highlighting is false.

Topic hyperlink something is an activity.


Chapter - Hyperlink Types

A hyperlink type is a kind of thing. object-word is a hyperlink type. direction-word is a hyperlink type. topic-word is a hyperlink type.
scenery-word is a hyperlink type.

A hyperlink emphasis is a kind of value. The plural of hyperlink emphasis is hyperlink emphases. 

A hyperlink type has a hyperlink emphasis called style. 

The active style is a hyperlink emphasis that varies. 

To say o:
	if object hyperlink highlighting is true:
		set the text style for the style of object-word; 
		now the active style is the style of object-word;
		start HI hyperlink capture.
	
To say s:
	if object hyperlink highlighting is true:
		set the text style for the style of scenery-word; 
		now the active style is the style of scenery-word;
		start HI hyperlink capture.
	
To say t:
	if topic hyperlink highlighting is true:
		set the text style for the style of topic-word; 
		now the active style is the style of topic-word;
		start HI hyperlink capture.
 
To say d: 
	if direction hyperlink highlighting is true:
		set the text style for the style of direction-word;
		now the active style is the style of direction-word;
		start HI hyperlink capture.
	 
To say x:
	end HI hyperlink capture;
	reset styles with active style.
	         
Section - Glulx Style Definitions

Include Glulx Text Effects by Emily Short. 

The hyperlink emphases are hyperlink-bold-style, hyperlink-italics-style, hyperlink-fixedwidth-style, hyperlink-normal-style and hyperlink-no-style.

The style of object-word is hyperlink-fixedwidth-style. The style of direction-word is hyperlink-italics-style. The style of topic-word is hyperlink-bold-style.
The style of scenery-word is hyperlink-normal-style.

To set the text style for (val - a hyperlink emphasis):
	if val is hyperlink-bold-style:
		say bold type;
	else if val is hyperlink-italics-style:
		say italic type;
	else if val is hyperlink-fixedwidth-style:
		say fixed letter spacing;
	else if val is hyperlink-normal-style:
		do nothing;
	else if val is hyperlink-no-style:
		do nothing.

To reset styles with (val - a hyperlink emphasis):
	if val is hyperlink-fixedwidth-style:
		say variable letter spacing;
	else:
		say roman type;


Chapter - Changing Style

Setting the hyperlink emphasis is an action out of world applying to nothing. Understand "link" or "links" as setting the hyperlink emphasis. 
 
tempstyles is a list of hyperlink emphases that varies.

Carry out setting the hyperlink emphasis (this is the Hyperlink Interface carry out setting hyperlink emphasis rule): 
	run the hyperlinks routine.

To run the hyperlinks routine:
	let mychar be 1;   
	while mychar is not 0:
		clear the screen;  
		let num be 0; 
		show HI message for hyperlink-setting-instructions;
		say line break;
		if object hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let object-number be num;
			show HI message for hyperlink-instructions-object;
		if object hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let scenery-number be num;
			show HI message for hyperlink-instructions-scenery;
		if direction hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let direction-number be num;
			show HI message for hyperlink-instructions-direction;
		if topic hyperlink highlighting is true:
			increase num by 1;
			say "[num]) ";
			let topic-number be num;
			show HI message for hyperlink-instructions-topic;
		[Print a warning if emphasis is disabled in a game where hyperlinks are required; note that the player is still allowed to do so, however.]
		if hyperlinks required is true:
			if ( object hyperlink highlighting is true and style of object-word is hyperlink-no-style ) or ( object hyperlink highlighting is true and style of scenery-word is hyperlink-no-style ) or ( direction hyperlink highlighting is true and  style of direction-word is hyperlink-no-style ) or ( topic hyperlink highlighting is true and style of topic-word is hyperlink-no-style ) :
				say line break;
				show HI message for hyperlink-instructions-disabled;
		[Print a warning if any two active hyperlink styles are the same.]
		truncate tempstyles to 0 entries;
		let dupe be false;
		if object hyperlink highlighting is true:
			add style of object-word to tempstyles;
			add style of scenery-word to tempstyles;
		if direction hyperlink highlighting is true:
			if style of direction-word is listed in tempstyles:
				now dupe is true;
			else:
				add style of direction-word to tempstyles;
		if topic hyperlink highlighting is true:
			if style of topic-word is listed in tempstyles:
				now dupe is true;
		if dupe is true:
			say line break;
			show HI message for hyperlink-instructions-distinct;
		say line break;
		show HI message for hyperlink-instructions-end;
		now mychar is single-character - 48; [Converts ASCII to actual number typed.]
		if mychar is object-number:
			advance style with object-word;
		otherwise if mychar is scenery-number:
			advance style with scenery-word;
		otherwise if mychar is direction-number:
			advance style with direction-word;
		otherwise if mychar is topic-number:
			advance style with topic-word;
	clear the screen;
	if pre-game hyperlink setting is true:
		now pre-game hyperlink setting is false;
		do nothing;
	otherwise:
		try looking. 
	  
To advance style with (hltype - a hyperlink type):
	now the style of hltype is the hyperlink emphasis after the style of hltype.

To decide which number is single-character: (- (VM_KeyChar()) -).

Section - Exits

[This routine is lifted straight from the example in the Inform 7 docs.]

Understand "exits" as exits listing. Exits listing is an action out of world applying to nothing.

Definition: a direction (called thataway) is viable if the room thataway from the location is a room.

Carry out exits listing (this is the Hyperlink Interface carry out exits listing rule):
	let count of exits be the number of viable directions; 
	if the count of exits is 0, say "You appear to be trapped in here." instead;
	if the count of exits is 1, say "From here, the only way out is to [a list of viable directions].";
	otherwise say "From here, the viable exits are to [a list of viable directions]."

Section - Things

Understand "things" as thing listing. Thing listing is an action out of world applying to nothing.

Carry out thing listing (this is the Hyperlink Interface carry out thing listing rule):
	say "Nearby [is-are the list of visible other things].".

Definition: a thing is other if it is not the player.

Rule for printing the name of a thing (called item) while thing listing:
	carry out the object hyperlinking activity with item.


Chapter - Beginning Play
	 
Section - Hyperlink Interface setup rule

pre-game hyperlink setting is a truth state that varies. pre-game hyperlink setting is true.

When play begins (this is the Hyperlink Interface setup trigger rule):
	if hyperlinks required is false:
		continue the action;
	clear the screen;
	let mychar be 1; 
	show HI message for welcome-message;
	while mychar is not 0:
		now mychar is single-character; 
		if mychar is 82 or mychar is 114: [ r or R: restore ]
			restore the game;  
		if mychar is 72 or mychar is 104: [ h or H: hyperlink ]
			run the hyperlinks routine;
			now mychar is 0;
		if mychar is 78 or mychar is 110: [ n or N: new game ]
			now mychar is 0;
	clear the screen;
	say "[line break][line break][line break]";
	now pre-game hyperlink setting is false.    
 
To restore the game: (- RESTORE_THE_GAME_R(); -).


Chapter - Error Reporting

Section - Not a verb I recognise

Rule for printing a parser error when parser error is not a verb I recognise (this is the Hyperlink Interface not a verb I recognise rule) : show HI message for not-a-verb-I-recognise. [Acknowledge that the player may be trying to type a hyperlink, not just a verb.]


Chapter - Messages

A HI message is a kind of value. Some HI messages are defined by the Table of Hyperlink Interface messages.

To show HI message for (whichmsg - a HI message):
	choose row with a HI message of whichmsg in Table of Hyperlink Interface messages;
	say HI output entry;
	say line break.

Table of Hyperlink Interface messages
HI message	HI output
not-a-verb-I-recognise	"That's neither a verb I [if using the American dialect option]recognize[else]recognise[end if] nor a hyperlink you can use right now."
hyperlink-introduction	"As you read [story title], you'll see certain emphasized hyperlinks in the prose. Click on any hyperlink to advance the story. [if object hyperlink highlighting is true]You can click an emphasized [o]object[x] or [s]scenery[x] to examine that item more closely. [end if][if direction hyperlink highlighting is true]An emphasized [d]direction[x] indicates that clicking that word will move you that direction or towards that distant scenery. [end if][if topic hyperlink highlighting is true]An emphasized word in [t]conversation[x] means clicking that word will steer the conversation towards that topic. [end if]If the hyperlink[if the number of active hyperlink systems > 1]s are[else] is[end if] not distinct, type LINKS to adjust them for your system."
welcome-message	"Welcome to [o][story title][x], release [release number].[paragraph break]If no words above were underlined or emphasized, press H now.[paragraph break]Press [t]N[x] to begin from the beginning or [t]R[x] to restore an existing story."
hyperlink-setting-instructions	"[story title] makes use of emphasized hyperlinks. It is [if hyperlinks required is true]necessary[else]recommended[end if] that your interpreter program correctly displays them with some form of emphasis. Type a number below to cycle through display options until you find one that shows clearly on your system."
hyperlink-instructions-object	"Emphasized [o]object[x] hyperlinks currently look like [o]this[x]."
hyperlink-instructions-scenery	"Emphasized [s]scenery[x] hyperlinks currently look like [s]this[x]."
hyperlink-instructions-direction	"Emphasized [d]exit[x] hyperlinks currently look like [d]this[x]."
hyperlink-instructions-topic	"Emphasized [t]topic[x] hyperlinks currently look like [t]this[x]."
hyperlink-instructions-disabled	"**A warning: The emphasized hyperlinks are integral to [story title]'s design. It may be difficult or impossible to know how to continue if emphasis is not visible.**"
hyperlink-instructions-distinct	"**A warning: it may at times be useful to be able to differentiate between the various kinds of hyperlinks.**"
hyperlink-instructions-end	"Press 0 when you're finished here.[run paragraph on]"


To decide what number is the number of active hyperlink systems:
	let ctr be 0;
	if object hyperlink highlighting is true, increase ctr by 1;
	if direction hyperlink highlighting is true, increase ctr by 1;
	if topic hyperlink highlighting is true, increase ctr by 1;
	decide on ctr.



Hyperlink Interface ends here.

---- DOCUMENTATION ----

(This documentation is copied directly from the extension "Keyword Interface" by Aaron Reed. The main modifications in the text are: "Keyword" replaced by "Hyperlink", "typed" replaced by "clicked", removed the color customization and so on)

This extension emulates the emphasized keyword system for streamlining common IF input, as seen in "Blue Lacuna" and substitutes color emphasis with hyperlinks. Nouns, directions, and topics are highlighted, underlined and can be clicked to examine, move, or discuss, respectively. Topics are implemented only in skeletal form to allow for integration with any conversation sytem. A full system for letting the player select his own preferred style scheme is also included. The extension is compatible with Glulx only.

Section: Basic Usage

Hyperlink Interface allows an emphasis style to be set for one of three possible categories. Each of these can be enabled or disabled independently by the author or player. By default, they are set as follows:

	Object hyperlink highlighting is true.
	Direction hyperlink highlighting is true.
	Topic hyperlink highlighting is false.

These can be enabled or disabled at any time during play, or globally with a "first when play begins" rule:

	First when play begins: now object hyperlink highlighting is false.


Section: Objects

When object hyperlink highlighting is set to true, the extension will automatically highlight and underline objects listed in bulk when looking or taking inventory, as well as objects manually invoked in room descriptions if their names are bracketed.

	The Office is a room. "Only a single [lamp] illuminates this dim office, bare except for a solitary [desk].". A metal lamp and a desk are scenery in the office. A telephone book is on the desk.

This produces output like the following (where emphasis is marked with asterisks):

	The Office
	Only a simple metal *lamp* illuminates this dim office, bare except for a solitary *desk*.

	On the *desk* is a telephone *book*.

The emphasized word will be the final word of the object's printed name. To change this, you can use the object's "hyperlink" property, which should be one of the other words in the printed name. You can also define an object as "hyperlinkless," in which case it will not be emphasized. Finally, you can manually mark an "[o]object[x]" with the o and x tags or a "[o]scenery[x]" with the s and x tags to emphasize it in object or scenery style.

	A telephone of Swedish origin with hyperlink "telephone" is in the Office. The description of the telephone is "You notice a faint [o]smudge[x] of lipstick on the receiver.". Some scattered cigarettes are a hyperlinkless thing in the Office.

Produces:

	"You can also see a *telephone* of Swedish origin and some scattered cigarettes here."

Object highlighting, when activated, highlights hyperlinks when looking or taking inventory. If you want to disable one of these you can use code like the following:

	The Hyperlink Interface highlight objects when looking rule is not listed in any rulebook.

Conversely, if you want object highlighting during other times, you can use code like this:
	
	Rule for printing the name of a thing (called item) while asking which do you mean:
		carry out the object hyperlinking activity with item.

In certain cases, the same object may be highlighted twice in a room description. This is due to a limitation of Inform's rules for printing the name of an object wherein there's no easy way to tell whether it's being printed to memory or the screen; anyone who knows a workaround for this, please let Aaron Reed know.

Section: Directions

When direction hyperlink highlighting is set to true and cardinal directions are wrapped in brackets in room descriptions, these will be emphasized as they are printed.

	"Gloomy passages depart to the [south] and [east]."

Compassless navigation as seen in Blue Lacuna is also available by simply adding the directional keyword you'd like as a synonym for the relative direction, limiting this to the specific room that keyword works for, and wrapping the relevant word in "d" and "x" tags.

	"Gloomy passages depart down a dusty set of [d]stairs[x] and through a wide [d]passage[x]." Understand "stairs" as south when location is Gloomy Tunnel. Understand "passage" as east when location is Gloomy Tunnel.

An "exits" verb is included with Hyperlink Interface to assist blind users or those without color interpreters (who in the above example would have no way of knowing what words would move them about). The "exits" verb lists all of the cardinal exits from the current location. If your game uses compassless navigation, you may want to extend this verb to print your keywords instead (see the example below for one way to do this).

If your game defines custom directions, you will need to explicitly set their printed names, but should then be able to use them like any other direction.

	Starboard is a direction. The opposite of starboard is port. The printed name of starboard is "starboard". Port is a direction. The opposite of port is starboard.  The printed name of port is "port". Upper deck is starboard of Captain's Cabin and port of Base of the Rigging. The description of Upper Deck is "The deck is crawling with pirates. The only free exits are to [port] and [starboard].". 

Section: Topics

Since there are so many vastly different conversation systems, support for highlighting conversation topics is only vestigial. You can turn it on via "topic hyperlink highlighting" and invoke it with the "[t]topic[x]" wrappers, but everything else will have to be done by hand to match your own conversation system.

Section: Control

As noted above, authors can enable or disable hyperlink highlighting for any component. Players also have control over hyperlinking by using the HYPERLINKS verb, which brings up a menu with flexible options, customised to which hyperlinks are enabled.

If hyperlinks are a crucial component of your game, you can add the following:

	First when play begins: now hyperlinks required is true.

This will bring up a message before your game begins ensuring that players can see the hyperlink highlighting, and giving them an option to adjust styles.

You can print some stock explanatory text (customized to which hyperlinks are enabled) by using the following line, perhaps in the carry out rule for an "about" command:

	show HI message for hyperlink-introduction

The three modes are object-word, direction-word, topic-word. For Glulx games, possible styles are hyperlink-bold-style, hyperlink-italics-style, hyperlink-fixedwidth-style, and hyperlink-no-style.

All of the messages the extension prints are customizeable by amending the Table of Hyperlink Interface messages, eg:

	Table of Hyperlink Interface messages (amended)
	HI message			HI output
	hyperlink-setting-instructions		"[story title] makes use of emphasized hyperlinks. It is important that your interpreter program correctly displays them with some form of emphasis. Type a number below to cycle through display options until you find one that shows clearly on your system."

The messages and how they currently begin are as follows:

	not-a-verb-I-recognise	"That's neither a verb I [if using the American dialect option]recognize[else]recognise[end if] nor a hyperlink you can use right now."
	hyperlink-introduction	"As you read [story title], you'll see certain emphasized hyperlinks in the prose. Click on any hyperlink to advance the story. [if object hyperlink highlighting is true]You can click an emphasized [o]object[x] to examine that item more closely. [end if][if direction hyperlink highlighting is true]An emphasized [d]direction[x] indicates that clicking that word will move you that direction or towards that distant scenery. [end if][if topic hyperlink highlighting is true]An emphasized word in [t]conversation[x] means clicking that word will steer the conversation towards that topic. [end if]If the hyperlink[if the number of active hyperlink systems > 1]s are[else] is[end if] not distinct, type LINKS to adjust them for your system."
	welcome-message	"Welcome to [o][story title][x], release [release number].[paragraph break]If no words above were underlined or emphasized, press H now.[paragraph break]Press [t]N[x] to begin from the beginning or [t]R[x] to restore an existing story."
	hyperlink-setting-instructions	"[story title] makes use of emphasized hyperlinks. It is [if hyperlinks required is true]necessary[else]recommended[end if] that your interpreter program correctly displays them with some form of emphasis. Type a number below to cycle through display options until you find one that shows clearly on your system."
	hyperlink-instructions-object	"Emphasized [o]object[x] hyperlinks currently look like [o]this[x]."
	hyperlink-instructions-scenery	"Emphasized [s]scenery[x] hyperlinks currently look like [s]this[x]."
	hyperlink-instructions-direction	"Emphasized [d]exit[x] hyperlinks currently look like [d]this[x]."
	hyperlink-instructions-topic	"Emphasized [t]topic[x] hyperlinks currently look like [t]this[x]."
	hyperlink-instructions-disabled	"**A warning: The emphasized hyperlinks are integral to [story title]'s design. It may be difficult or impossible to know how to continue if emphasis is not visible.**"
	hyperlink-instructions-distinct	"**A warning: it may at times be useful to be able to differentiate between the various kinds of hyperlinks.**"
	hyperlink-instructions-end	"Press 0 when you're finished here.[run paragraph on]"


Section: Disambiguation

Inform's normal disambiguation is designed around the notion that every command begins with a verb, which means conflicts between keywords, and between keywords and verbs, are hard or impossible to control. The best solution is to make sure your object, direction, and topic keywords have no overlap.

*If an object and direction keyword* are in the same scope, the parser silently assumes the player means the direction keyword, and will print a seemingly useless "(the object)" clarification if the player manually examines that object instead.

*If a highlighted keyword matches a verb*, the verb will take precedence. For example, typing "set" to reference a chess set would instead produce the message "What do you want to set?" The best way to avoid this is to change the keyword and description of the object to avoid mentioning the verb word-- in this case "chessboard" might be a good substitute.

*Conversation systems should take precedence over objects* since this is what players will expect. See the example below for one implementation of this.


Example: * Sense of Direction - A simple usage of the extension to print bold compass directions.

The flexibility of Hyperlink  Interface means it can be used for multiple purposes. Here we strip away and focus some of its functionality to simply print compass directions in bold.

	*: "Sense of Direction"

	Include Hyperlink Interface by Leonardo Boselli.

	First when play begins: now object hyperlink highlighting is false; now the style of direction-word is hyperlink-bold-style.

	Labyrinth is south of Passage and west of Halls. Halls is south of Dungeon and west of Pit. Pit is south of Harrows. Harrows is east of Dungeon and south of Caverns. Dungeon is east of Passage and south of Abyss. Passage is south of Abattoir. Abbatoir is west of Abyss and north of Passage. Abyss is west of Caverns.   

	After looking: try exits listing.

Example: ** The Gnome's Holiday - A full example of emphasized objects, compassless directions, and conversation topics.

We'll create a slightly longer scenario with several locations and a simple puzzle, to demonstrate the full potential of Hyperlink Interface. This game has "hyperlinks required" set to true, so it begins with a menu that helps players calibrate hyperlinks.

We implement an extremely simple conversation system to demonstrate emphasized topic words. Note that a real conversation system would need to be much more robust and elaborate. We'll also create a variation on the exits verb to show our compassless exits

	*: "The Gnome's Holiday"

	Include Hyperlink Interface by Leonardo Boselli.    

	First when play begins: now topic hyperlink highlighting is true; now hyperlinks required is true.  

	After printing the banner text: say "First time players type ABOUT for more instructions.".

	Section - Conversation

	hyperlink-asking is an action applying to one thing. Understand "[a speakable]" as hyperlink-asking when the number of other people in location > 0.

	Carry out hyperlink-asking:
		let subject be a random other person in the location;
		say "[response of noun][paragraph break]".	
 
	A speakable is a kind of thing. A speakable has some text called the response. Instead of doing anything other than hyperlink-asking to a speakable: say "That's merely a topic of conversation.". Does the player mean doing something other than hyperlink-asking to a speakable: it is very unlikely.  

	Section - Exits

	Every room has some text called the exits text.

	First carry out exits listing: 
		unless the exits text of location is "":
			say the exits text of location;
			say line break;
		stop the action.

	After looking: try exits listing. 

	Section - Instructions

	Understand "about" as requesting the about text. Requesting the about text is an action out of world applying to nothing. Carry out requesting the about text: show HI message for hyperlink-introduction.  
  
	Section - Game

	Gnome's Garden is a room with description "Brightly pastel flowers dot this well-kept garden, bordering a [button-cute shack] with whimsical stylings on the edge of the river, which is spanned here by a [drawbridge]." and exits text "A [d]path[x] of cherry-colored bricks winds off towards some distant hills, while the [if shack door is open][d]door[x] to the gnome's shack stands open[else]door to the gnome's shack is closed[end if][if drawbridge is open]. The lowered drawbridge spans the river to a treasure-strewn [d]wonderland[x][end if].". Understand "path" as west when location is Gnome's Garden. 

	A stone table is a hyperlinkless fixed in place supporter in Gnome's Garden. On the table is a copy of the Daily Gnomon with description "You can't read gnomish, but you can make a great gnocchi." The hyperlink of the Daily Gnomon is "copy". The button-cute shack is scenery in Gnome's Garden. Instead of entering shack, try going north.

	The shack door is a closed locked undescribed door with hyperlink "door". It is north of Gnome's Garden and south of Cozy Shack. The can't go through undescribed doors rule is not listed in any rulebook. Instead of going inside in Gnome's Garden, try going north.

	The drawbridge is a closed unopenable door. "[if closed]The drawbridge is raised, allowing passage by a steady stream of tiny steamboats, but preventing access to the treasure-strewn wonderland on the other side of the river[else]Wee steamboats queue impatiently behind the lowered drawbridge[end if].". It is east of Gnome's Garden and west of the Treasure-Strewn Wonderland. The description of drawbridge is "[if closed]If only you could find a way to lower it and cross the river![else]The treasure-strewn wonderland across the river awaits![end if]".

	The cherry-brick path is a backdrop. It is everywhere. Understand "cherry/cherry-colored/colored" as path. 

	Golden Pasture is a room with description "The grass here is thick and heavy, sparkling with gold and amber hues." and exits text "Only the [d]path[x] back to the garden is clear." Golden Pasture is west of Gnome's Garden. Understand "path" as east when location is Golden Pasture.

	The gnome is a person in Golden Pasture. "A [gnome] perches on a checkered toadstool here, stroking his beard in relaxed contentment." The description is "Dressed in brightly colored clothes, he has the cheerful air of someone on holiday.".

	After examining the gnome, say "You could ask him about his [t]dragon[x], the [t]weather[x], or the [t]drawbridge[x].". 

	A pet dragon creature is a female animal in Golden Pasture. "Clinging anxiously to the gnome's cap is a tiny bronze [o]creature[x].". The description is "Looking closer, you see she is a beautiful baby dragon. She regards you [if we have hyperlink-asked the personality topic]with a friendly twinkle in her eye[else]fearfully, clutching the gnome's hat with an almost comically tight grip[end if]."  

	The dragon topic is a speakable with response "'You like her?' the gnome says fondly, petting the dragon which watches you nervously. 'She's named [t]Quinnabel[x].'". 

	The Quinnabel topic is a speakable with response "'Found her in an old mushroom mine,' the gnome says, warming to his subject. The dragon sniffs you tentatively. 'She's got quite a [t]personality[x].'".

	The personality topic is a speakable with response "'Oh, she's shy at first, but she'll warm up to you right away if you let her.' And sure enough, the dragon finally seems to take a liking to you, and purrs contentedly as you scratch it behind the ears.". After hyperlink-asking the personality topic for the first time: say "'See, you're not such a bad sort,' the gnome says. 'Why don't you take this key and see to that drawbridge yourself.' And he hands you a scuffed silver key (oversized even for you)."; move silver key to player. The silver key unlocks the shack door. 

	The drawbridge topic is a speakable with response "'Hrmph,' the gnome mutters, crossing his arms defiantly, 'I'm supposed to be on vacation.'".  

	The weather topic is a speakable with response "'Looks like another day of beautiful sunshine again,' he grumbles.".

	The gnome carries dragon topic, Quinnabel topic, personality topic, drawbridge topic, and weather topic.  

	The description of Cozy Shack is "Strewn with bric-a-brac; your eyes are drawn immediately to the prominent [lever] on the riverward wall.". The exits text of Cozy Shack is "The only place to go is back [outside].". Instead of going outside in Cozy Shack, try going south. Instead of exiting in Cozy Shack, try going south.

	A lever is an undescribed device in Cozy Shack. Instead of pushing or pulling the lever, try switching on the lever. After switching on the lever: now drawbridge is open; say "You hear a splash and a creak from outside the shack.".

	After going to Treasure-Strewn Wonderland for the first time: say "You enter the land of treasure. Congratulations!"; end the game in victory. Understand "wonderland" as east when location is Gnome's Garden.

	Test me with "copy / drawbridge / door / open door / path / x path / gnome / drawbridge / dragon / Quinnabel / personality / path / unlock door / open it / exits / door / pull lever / out / wonderland".

