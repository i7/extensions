Version 3/181103 of Vorple Tooltips (for Glulx only) by Juhana Leinonen begins here.

"Tooltips that can be activated on request or when the mouse cursor is moved over an element."

Include Vorple by Juhana Leinonen.

Use authorial modesty.

Default tooltip duration is a number that varies. Default tooltip duration is usually 7.


Chapter 1 - Tooltips on mouseover

To place text (txt - text) with a/-- tooltip reading (tip - text):
	let id be unique identifier; 
	place an inline element called id reading txt;
	execute JavaScript command "$('.[id]').last().attr('title','[escaped tip]').powerTip({smartPlacement:true})".

To place text (txt - text) called (classes - text) with a/-- tooltip reading (tip - text):
	let id be unique identifier; 
	place an inline element called id reading txt;
	execute JavaScript command "$('.[id]').last().addClass('[classes]').attr('title','[escaped tip]').powerTip({smartPlacement:true})".

To attach a/-- tooltip (tip - text) on/to all the/-- elements called (classes - text):
	execute JavaScript command "$('.[classes]').last().attr('title','[escaped tip]').powerTip({smartPlacement:true})".

To attach a/-- tooltip (tip - text) on/to the/-- element called (classes - text):
	attach a tooltip tip on all the elements called "[classes]:last".


Chapter 2 - Manually triggered tooltips

To display a/-- tooltip (tip - text) on/at the/-- element called (classes - text) in/after (delay - number) second/seconds for (duration - number) seconds:
	execute JavaScript command "clearTimeout(_v_tooltip_timer);_v_tooltip_timer=setTimeout(function() {var $t=$('.[classes]').last();$.powerTip.hide();$t.attr('title','[escaped tip]').powerTip({manual:true,smartPlacement:true});$.powerTip.show($t)[if duration >= 0];_v_tooltip_timer=setTimeout(function() {$.powerTip.hide($t,true);$t.removeAttr('title')},[duration]*1000);[end if]},[delay]*1000)".
	
To display a/-- tooltip (tip - text) on/at the/-- element called (classes - text) in/after (delay - number) second/seconds indefinitely:
	display a tooltip tip on the element called classes in delay seconds for -1 seconds.

To display a/-- tooltip (tip - text) on/at the/-- element called (classes - text) in/after (delay - number) second/seconds:
	display a tooltip tip on the element called classes in delay seconds for default tooltip duration seconds.

To display a/-- tooltip (tip - text) on/at the/-- element called (classes - text) indefinitely:
	display a tooltip tip on the element called classes in 0 seconds indefinitely.

To display a/-- tooltip (tip - text) on/at the/-- element called (classes - text) for (duration - number) second/seconds:
	display a tooltip tip on the element called classes in 0 seconds for duration seconds.
	
To display a/-- tooltip (tip - text) on/at the/-- element called (classes - text):
	display a tooltip tip on the element called classes in 0 seconds.


Chapter 3 - Tooltips on the prompt

Vorple interface setup rule (this is the initialize prompt tooltip rule):
	execute JavaScript command "$(haven.prompt.get()).find('#lineinput-prefix').powerTip({manual:true,placement:'sw-alt',smartPlacement:true})".

To display a/-- tooltip (tip - text) on/at the/-- prompt in/after (delay - number) second/seconds for (duration - number) second/seconds:
	execute JavaScript command "clearTimeout(_v_tooltip_timer);_v_tooltip_timer=setTimeout(function() {var $t=$('#lineinput-prefix');$.powerTip.hide();$t.data('powertip','[escaped tip]');$.powerTip.show($t)[if duration >= 0]; _v_tooltip_timer=setTimeout(function() {$.powerTip.hide($t,true);$t.removeAttr('title')},[duration]*1000);[end if]},[delay]*1000)".

To display a/-- tooltip (tip - text) on/at the/-- prompt in/after (delay - number) second/seconds indefinitely:
	display a tooltip tip on the prompt in delay seconds for -1 seconds.

To display a/-- tooltip (tip - text) on/at the/-- prompt in/after (delay - number) second/seconds:
	display a tooltip tip on the prompt in delay seconds for default tooltip duration seconds.

To display a/-- tooltip (tip - text) on/at the/-- prompt in for (duration - number) second/seconds:
	display a tooltip tip on the prompt in 0 seconds for duration seconds.
	
To display a/-- tooltip (tip - text) on/at the/-- prompt:
	display a tooltip tip on the prompt in 0 seconds. 

To display a/-- tooltip (tip - text) on/at the/-- prompt indefinitely:
	display a tooltip tip on the prompt in 0 seconds indefinitely.


Chapter 4 - Hiding tooltips

To hide the/-- tooltip:
	execute JavaScript command "clearTimeout(_v_tooltip_timer);$.powerTip.hide()".

To hide the/-- tooltip in/after (delay - number) seconds:
	execute JavaScript command "clearTimeout(_v_tooltip_timer);_v_tooltip_timer=setTimeout(function() {$.powerTip.hide()}, [delay]*1000)".
	

Chapter 5 - Initialization

Vorple interface setup rule (this is the initialize tooltip timers rule):
	execute JavaScript command "window._v_tooltip_timer=null".

	
Vorple Tooltips ends here.


---- DOCUMENTATION ----


The Tooltips extension lets the story display small notifications above target elements. Tooltips can be activated when the mouse pointer is over them or at request.


Chapter: Tooltips on mouseover

Text with a tooltip can be created with:

	place text "examine" with a tooltip reading "You can also use the short form X";
	
The tooltip is shown when the reader puts the mouse cursor over the text and hidden when the mouse cursor is moved away.

A tooltip can be added to existing elements (see the Vorple core extension for more on how to create elements):

	place an inline element called "secret" reading "a mysterious box";
	attach a tooltip "You found me!" on the element called "secret";

If there are many elements with the same name, the tooltip is attached to the last of them. The tooltip can also be attached to all elements with the same name.

	attach a tooltip "You found me!" to all elements called "secret"; 


Chapter: Tooltips on request 

Tooltips can also be triggered manually on existing elements.

	display a tooltip "Take a look here" on the element called "important";

By default the tooltip appears immediately and is hidden in 7 seconds. The delay how long until the tooltip appears and the duration of the tooltip can be changed:

	display a tooltip "Take a look here" on the element called "important" after 3 seconds for 10 seconds;
	
The duration can also be "indefinitely" which keeps the tooltip visible until it's manually hidden.

	display a tooltip "Take a look here" on the element called "important" indefinitely;

The default duration can be changed globally. The following example makes all tooltips display for 4 seconds unless otherwise specified:

	The default tooltip duration is 4.

As with tooltips that are activated on mouseover, if there are multiple elements with the same name the tooltip is shown only on the last one. 

A tooltip can be placed on the prompt (handy for giving a hint on how to play to people who aren't familiar with interactive fiction):

	When play begins:
		display a tooltip "Type something here!" on the prompt.
		

Chapter: Hiding tooltips

The currently open tooltip can be closed immediately with:
	
	hide the tooltip;
	
An optional duration can be provided:

	hide the tooltip after 5 seconds;

Only one tooltip can be open at a time. Tooltips are automatically closed when a new tooltip is shown.
		

Example: * Medical Dictionary - Technical terms that have their definitions shown in a tooltip.


	*: "Medical Dictionary"

	Include Vorple Tooltips by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

	The Surgery is a room. 
	
	A craniotome, a tracheotome, a probang and some butterfly stitches are in the Surgery.
	
	A thing has some text called the definition.
	
	The definition of the craniotome is "A tool for drilling holes in the skull".
	The definition of the tracheotome is "A blade used to cut an hole to the trachea for a breathing tube".
	The definition of the probang is "A sponge attached to a long flexible rod, used to clear obstacles from the throat".
	The definition of butterfly stitches is "Thin adhesive strips for bandaging small wounds".
	
	Rule for printing the name of something (called the item) when the item provides the property definition and the definition of item is not empty:
		place text "[printed name of the item]" with a tooltip reading "[definition of item]".
		

Example: ** How To II - More tips to new players who might not be familiar with standard IF conventions

We'll show a tooltip on the prompt to direct the player to use the keyboard, hint about what kind of commands to use if the first command they try is an error and direct their attention to parts of items. 


	*: "How To II"
	
	Include Vorple Tooltips by Juhana Leinonen.  
	Release along with the "Vorple" interpreter.
	
	Bedroom is a room.
	
	The wardrobe is openable closed fixed in place container in the bedroom.
	
	Instead of examining the wardrobe when the wardrobe is closed:
		say "The wardrobe is ";
		place an element called "wardrobe-closed" reading "closed";
		display a tooltip "You can OPEN WARDROBE to see what's inside." on the element called "wardrobe-closed" in 2 seconds;
		say ".";
		
	The jacket is a wearable thing in the wardrobe.
	
	Rule for printing the name of the jacket when the jacket is in the wardrobe:
		place an element called "jacket-text" reading "jacket";
		display a tooltip "The jacket is something you can TAKE or WEAR." on the element called "jacket-text" in 2 seconds.
	
	When play begins (this is the show prompt hint rule):
		display tooltip "Type a command to play" on the prompt.
		
	Rule for printing a parser error (this is the show parser error hint rule):
		display tooltip "Try to, for example, EXAMINE things you see or take INVENTORY." on the prompt;
		make no decision.
	
	Test me with "x wardrobe / open wardrobe".

 
Example: ** Ibid. (2) - Footnotes that can be read by placing the mouse cursor over them.

We're modifying example 300 (Ibid.) from Writing with Inform to show the footnotes when the mouse cursor is on top of the footnote reference numbers.

	*: "Ibidem"

	Include Vorple Tooltips by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	The Ship Inn is a room. "Here you are in a lovely pub which your guidebook assures you is extremely authentic. [1 as a footnote].
	
	To your left sits a party of Italians, with their guidebook.
	
	To your right is a silent, but not unappealing, young man.".
	
	A party of Italians and a silent young man are people in the Ship Inn. The Italians and the young man are scenery.
	
	The table is a supporter in the Ship Inn. On the table is a mysterious pie. The description of the pie is "Your waitress told you it was the specialty of the day, Steak and Owl Pie. [2 as a footnote]." The pie is edible.
	
	[We'll have to drop the third footnote from the original example--footnotes in footnotes won't work now because you can't move the mouse over a tooltip.]
	
	Table of Footnotes
	assignment	note
	a number	"Francis Drake ate here, if the sign on the door is to be believed"
	--	"this is unlikely, considering that owls are protected animals in England these days"
	
	Footnotes mentioned is a number that varies.
		
	To say (footnote - a number) as a footnote:
		if footnote > number of filled rows in the Table of Footnotes:
			say "Programming error: footnote assignment out of range.";
		otherwise:
			choose row footnote in the Table of Footnotes;
			if there is an assignment entry:
				place text "([assignment entry])" with a tooltip reading "[note entry]";
			otherwise:
				increment footnotes mentioned;
				choose row footnote in the Table of Footnotes;
				now assignment entry is footnotes mentioned;
				place text "([assignment entry])" with a tooltip reading "[note entry]".

	[There should still be a way to read footnotes in offline interpreters.] 	
	
	Understand "footnote [number]" as looking up a footnote.
	
	Looking up a footnote is an action applying to one number.
	
	Check looking up a footnote:
		if the number understood > footnotes mentioned, say "You haven't seen any such footnote." instead;
		if the number understood < 1, say "Footnotes are numbered from 1." instead.
	
	Carry out looking up a footnote:
		choose row with assignment of number understood in the Table of Footnotes;
		say "([assignment entry]): [note entry]."
	
	Test me with "footnote 1 / examine pie / footnote 2 / footnote 3".


	
	
