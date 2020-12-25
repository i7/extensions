Version 3/181103 of Vorple Element Manipulation (for Glulx only) by Juhana Leinonen begins here.

"Adding, removing, hiding, moving and other basic manipulation of HTML document elements."

Include version 3 of Vorple by Juhana Leinonen.

Use authorial modesty.

To clear the/-- element called/-- (classes - text):
	execute JavaScript command "$('.[classes]').last().empty()".

To clear all the/-- elements called/-- (classes - text):
	execute JavaScript command "$('.[classes]').empty()".

To remove the/-- element called/-- (classes - text):
	execute JavaScript command "$('.[classes]').last().remove()".

To remove all the/-- elements called/-- (classes - text):
	execute JavaScript command "$('.[classes]').remove()".
	
To hide the/-- element called/-- (classes - text):
	execute JavaScript command "$('.[classes]').last().hide()".

To hide all the/-- elements called/-- (classes - text):
	execute JavaScript command "$('.[classes]').hide()".

To show the/-- element called/-- (classes - text):
	execute JavaScript command "$('.[classes]').last().show()".

To show all the/-- elements called/-- (classes - text):
	execute JavaScript command "$('.[classes]').show()".

To move the/-- element called/-- (classes - text) under (target - text):
	execute JavaScript command "$('.[classes]').last().appendTo('.[target]')".

To move all the/-- elements called/-- (classes - text) under (target - text):
	execute JavaScript command "$('.[classes]').appendTo('.[target]')".

To move the/-- element called/-- (classes - text) at the start of (target - text):
	execute JavaScript command "$('.[classes]').last().prependTo('.[target]')".

To move all the/-- elements called/-- (classes - text) at the start of (target - text):
	execute JavaScript command "$('.[classes]').prependTo('.[target]')".

To move the/-- element called/-- (classes - text) before (target - text):
	execute JavaScript command "$('.[classes]').last().insertBefore($('.[target]:last'))".

To move all the/-- elements called/-- (classes - text) before (target - text):
	execute JavaScript command "$('.[classes]').insertBefore($('.[target]:last'))".

To move the/-- element called/-- (classes - text) after (target - text):
	execute JavaScript command "$('.[classes]').last().insertAfter($('.[target]:last'))".

To move all the/-- elements called/-- (classes - text) after (target - text):
	execute JavaScript command "$('.[classes]').insertAfter($('.[target]:last'))".

To add name (new name - text) to the/-- element called (classes - text):
	execute JavaScript command "$('.[classes]').last().addClass('[new name]')".

To add name (new name - text) to all the/-- elements called (classes - text):
	execute JavaScript command "$('.[classes]').addClass('[new name]')".

To remove name (old name - text) from the/-- element called (classes - text):
	execute JavaScript command "$('.[classes]').last().removeClass('[old name]')".

To remove name (old name - text) from all the/-- elements called (classes - text):
	execute JavaScript command "$('.[classes]').removeClass('[old name]')".
	
To rename the/-- element called (old name - text) to (new name - text):
	execute JavaScript command "$('.[old name]').last().removeClass('[old name]').addClass('[new name]')".

To rename all the/-- elements called (old name - text) to (new name - text):
	execute JavaScript command "$('.[old name]').removeClass('[old name]').addClass('[new name]')".

Vorple Element Manipulation ends here.


---- DOCUMENTATION ----

Vorple Element Manipulation includes some convenience phrases to manipulate DOM elements on the web interpreter page.

This extension is mainly a low-level helper extension for other extensions, and provides some tools for authors who want the Inform code to interact with their own JavaScript code. It isn't directly useful to most other authors.


Chapter: Clearing, removing, hiding and moving elements

	clear the element called "myElem";
	remove the element called "myElem";
	hide the element called "myElem";
	show the element called "myElem";
	move the element called "myElem" under "target";
	move the element called "myElem" at the start of "target";
	move the element called "myElem" after "target";
	move the element called "myElem" before "target";

The difference between "clear" and "remove" is that clearing empties the element but leaves it in place, whereas removing takes it out completely. "Move the element under" puts the element at the end of the target element.

The "called" specifier is a class of the element. All phrases target only the last element on the page with the given class, and they all have an "all elements" counterpart that targets all elements with that class.

	clear all elements called "myElem";
	remove all elements called "myElem";

and so on.


Chapter: Adding and removing names

These phrases add and remove names (classes) of elements.

	add name "newName" to the element called "myElem";
	remove name "oldName" from the element called "myElem";
	rename the element called "oldName" to "newName";

Names are HTML classes, so if we have an element that looks like this:
	
	<div class="myElem"></div>
	
...and we 

	add name "newName" to the element called "myElem";

...it will then look like this:
	
	<div class="myElem newName"></div>
	
The "rename" phrase only changes the name of the one class it targets, so it doesn't clear all class names from the element.
	
Similar to other phrases, these too target only the last element with that name. To target all elements:

	add name "newName" to all the elements called "myElem";
	remove name "oldName" from all the elements called "myElem";
	rename all the elements called "oldName" to "newName";
	

Example: **** Sonnet Carousel - Showing poems one at a time by showing and hiding elements

In the grand tradition of hammering in a nail with a wrecking ball, this example creates a "carousel" of a selection of Shakespeare's sonnets. Everything else is removed, including the command prompt, except two links that show next and previous sonnets. When the links are clicked, the previously shown sonnet is hidden and the next one is show instead.

We're including some other Vorple extensions as well to handle the clickable links, font effects, and hiding the command prompt.

	
	*: "Sonnet Carousel"
	
	Include Vorple Element Manipulation by Juhana Leinonen.
	Include Vorple Hyperlinks by Juhana Leinonen.
	Include Vorple Command Prompt Control by Juhana Leinonen.
	Include Vorple Screen Effects by Juhana Leinonen.
	
	Release along with the "Vorple" interpreter.
	
	There is a room.
	
	Chapter 1 - Setup
	
	When play begins:
		if Vorple is supported:
			repeat through Table of Sonnets:
				open HTML tag "div" called "sonnet-[num entry]";
				place a level 2 header reading "[num entry]";
				say sonnet entry;
				close HTML tag;
				hide the element called "sonnet-[num entry]";
			center "[navigation links]";
		try showing next sonnet; [shows the first sonnet]
		if Vorple is not supported:
			say "[line break]Command PREVIOUS and NEXT to show more sonnets."
	
	To say navigation links:
		say line break;
		place a link to the command "previous", without showing the command;
		say "   -   ";
		place a link to the command "next", without showing the command.
		
	Current sonnet is a number that varies. Current sonnet is 0.
		
	Showing next sonnet is an action applying to nothing.
	Understand "next" as showing next sonnet.
	
	Carry out showing next sonnet:
		hide the element called "sonnet-[current sonnet]";
		increment current sonnet;
		if current sonnet is the number of rows in the Table of Sonnets + 1:
			now current sonnet is 1;
		show the element called "sonnet-[current sonnet]";
		if Vorple is not supported:
			show non-Vorple version of a sonnet.
	
	Showing previous sonnet is an action applying to nothing.
	Understand "previous" as showing previous sonnet.
	
	Carry out showing previous sonnet:
		hide the element called "sonnet-[current sonnet]";
		decrement current sonnet;
		if current sonnet is 0:
			now current sonnet is the number of rows in the Table of Sonnets;
		show the element called "sonnet-[current sonnet]";
		if Vorple is not supported:
			show non-Vorple version of a sonnet.
	
	[This provides a fallback for standard interpreters]
	To show non-Vorple version of a sonnet:
		say "[bold type][current sonnet][roman type][paragraph break]";
		say the sonnet in row current sonnet of the Table of Sonnets;
		say line break.
	
	[These rules remove everything else except the sonnets and the navigation links]
	The display banner rule is not listed in any rulebook.
	The initial room description rule is not listed in any rulebook.
	
	When play begins:
		hide the prompt.
	
	
	Chapter 2 - Sonnets
	
	Table of Sonnets
	num	sonnet
	1	"From fairest creatures we desire increase,
	[line break]That thereby beauty's rose might never die,
	[line break]But as the riper should by time decease,
	[line break]His tender heir might bear his memory:
	[line break]But thou contracted to thine own bright eyes,
	[line break]Feed'st thy light's flame with self-substantial fuel,
	[line break]Making a famine where abundance lies,
	[line break]Thy self thy foe, to thy sweet self too cruel:
	[line break]Thou that art now the world's fresh ornament,
	[line break]And only herald to the gaudy spring,
	[line break]Within thine own bud buriest thy content,
	[line break]And, tender churl, mak'st waste in niggarding:
	[line break]   Pity the world, or else this glutton be,
	[line break]   To eat the world's due, by the grave and thee."
	2	"When forty winters shall besiege thy brow,
	[line break]And dig deep trenches in thy beauty's field,
	[line break]Thy youth's proud livery so gazed on now,
	[line break]Will be a totter'd weed of small worth held: 
	[line break]Then being asked, where all thy beauty lies,
	[line break]Where all the treasure of thy lusty days; 
	[line break]To say, within thine own deep sunken eyes,
	[line break]Were an all-eating shame, and thriftless praise.
	[line break]How much more praise deserv'd thy beauty's use,
	[line break]If thou couldst answer 'This fair child of mine
	[line break]Shall sum my count, and make my old excuse,'
	[line break]Proving his beauty by succession thine!
	[line break]   This were to be new made when thou art old,
	[line break]   And see thy blood warm when thou feel'st it cold."
	3	"Look in thy glass and tell the face thou viewest
	[line break]Now is the time that face should form another;
	[line break]Whose fresh repair if now thou not renewest,
	[line break]Thou dost beguile the world, unbless some mother.
	[line break]For where is she so fair whose uneared womb
	[line break]Disdains the tillage of thy husbandry?
	[line break]Or who is he so fond will be the tomb
	[line break]Of his self-love, to stop posterity? 
	[line break]Thou art thy mother's glass and she in thee
	[line break]Calls back the lovely April of her prime;
	[line break]So thou through windows of thine age shalt see,
	[line break]Despite of wrinkles, this thy golden time.
	[line break]   But if thou live, remembered not to be,
	[line break]   Die single and thine image dies with thee."
	4	"Unthrifty loveliness, why dost thou spend
	[line break]Upon thy self thy beauty's legacy?
	[line break]Nature's bequest gives nothing, but doth lend,
	[line break]And being frank she lends to those are free:
	[line break]Then, beauteous niggard, why dost thou abuse
	[line break]The bounteous largess given thee to give?
	[line break]Profitless usurer, why dost thou use
	[line break]So great a sum of sums, yet canst not live?
	[line break]For having traffic with thy self alone,
	[line break]Thou of thy self thy sweet self dost deceive:
	[line break]Then how when nature calls thee to be gone,
	[line break]What acceptable audit canst thou leave?
	[line break]   Thy unused beauty must be tombed with thee,
	[line break]   Which, used, lives th['] executor to be."
	5	"Those hours, that with gentle work did frame
	[line break]The lovely gaze where every eye doth dwell,
	[line break]Will play the tyrants to the very same
	[line break]And that unfair which fairly doth excel;
	[line break]For never-resting time leads summer on
	[line break]To hideous winter, and confounds him there;
	[line break]Sap checked with frost, and lusty leaves quite gone,
	[line break]Beauty o'er-snowed and bareness every where:
	[line break]Then were not summer's distillation left,
	[line break]A liquid prisoner pent in walls of glass,
	[line break]Beauty's effect with beauty were bereft,
	[line break]Nor it, nor no remembrance what it was:
	[line break]   But flowers distilled, though they with winter meet,
	[line break]   Leese but their show; their substance still lives sweet."

