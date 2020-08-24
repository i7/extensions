Version 1/200807 of Hyperlinks (for Glulx only) by Gavin Lambert begins here.

"Provides a core processing loop for hyperlinks.  This is a basic interface intended to be used by other extensions rather than directly in stories."

Include Glk Input Suspending by Gavin Lambert.

Use authorial modesty.

Section - Link Declaration

To say set link (N - number) -- beginning say_set_link -- running on:
	(- if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_set_hyperlink({N}); -).
	
To say clear link -- ending say_set_link -- running on:
	(- if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_set_hyperlink(0); -).

Section - Link Processing

The hyperlink id processing rules are a number based rulebook producing text.

Section - Event Handling

A glulx input handling rule for a hyperlink-event (this is the default hyperlink handling rule):
	let window be glk event window ref;
	let index be glk event value 1;
	suspend the current glk input event;
	let command be the text produced by the hyperlink id processing rules for index;
	replace the current glk input event with text input command;
	request hyperlink events for window ref window.

Section - Window Management (for use without Flexible Windows by Jon Ingold)

To decide which number is the ref number of the main window:
	(- gg_mainwin -).

To decide which number is the ref number of the status window:
	(- gg_statuswin -).

First when play begins rule (this is the startup hyperlink event requests rule):
	request hyperlink events for window ref (ref number of the main window);
	request hyperlink events for window ref (ref number of the status window).
	
Section - Window Management (for use with Flexible Windows by Jon Ingold)

After constructing a textual g-window (called win) (this is the startup hyperlink event requests rule):
	request hyperlink events for window ref (ref number of win).
	
[It should not be needed to explicitly cancel this when the window is destroyed; Glk will do that itself.]

Section - Low Level -- unindexed

To request hyperlink events for window ref (W - number):
	(- if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event({W}); -).

Hyperlinks ends here.

---- DOCUMENTATION ----

This is primarily a utility extension intended for other extensions to use, rather than for direct use in stories.

A hyperlink can be created with an arbitrary ID in the output text by saying "[set link 1]displayed text[clear link]".

To handle processing when that link is clicked, you can declare a rule:
	
	Hyperlink id processing rule for 1:
		(do something interesting);
		rule succeeds with result "go north".
		
Where a rule provides command input as above, this will be entered as the full player command if the story is currently waiting for line input, or only the first character will be input if the story is currently waiting for char input.  If the story isn't currently waiting for either kind of input then the command is ignored.

If you don't want to input any commands but do still want to consider this rule a success (and not process any other hyperlink rules), then you can simply do one of these:
	
		rule succeeds with result "".
		stop the action.
		
If you don't want to make any decision but continue to run other rules, simply:
	
		continue the action.
		
(Or don't say anything at all, as this is the default.)

If you want to handle a range of link IDs from a single rule, you can do this by turning it into a parameter:
	
	Hyperlink id processing rule for number (called id):
		if id >= 20 and id < 100:
			(do a thing).
			
Note that this extension does not define any mechanism for "reserving" IDs or otherwise ensuring that different usages don't clash with each other; for that, it is strongly recommended to use the "Inline Hyperlinks by Gavin Lambert" extension instead, which builds on this.

Section: Compatibility with Flexible Windows

This extension can be used with or without Flexible Windows, but if you are using it then it's recommended that you include that before including this.  Without any further changes, this will enable hyperlinks to be accepted in any window.  (By default, only hyperlinks in the main window and status windows are recognised.)


Example: * Lab Session

	*: "Lab Session"
	
	Include Hyperlinks by Gavin Lambert.
	
	Laboratory is a room.  "A curious assortment of odds and ends line the [set link 1]workbench[clear link]."
	A workbench is a scenery supporter in Laboratory.  The description is "The workbench itself is made of plain unpainted wood, with a lacquered coating to make it immune to most chemical spills -- apart from one corner, after an encounter with an especially frisky acid."
	The describe what's on scenery supporters in room descriptions rule does nothing when the item described is the workbench.
	
	A beaker is on workbench. The printed name is "[set link 2]beaker[clear link]". The description is "A fragile glass beaker, currently empty.  One part of the rim is slightly chipped."
	A bunsen burner is on workbench. The printed name is "[set link 3]bunsen burner[clear link]". The description is "A small, lightly charred, Bunsen burner."
	A horrifying monstrosity is on workbench. The printed name is "[set link 4]horrifying monstrosity[clear link]".  The description is "Best not described.  Even though this is apparently the subject your professor wants you to dissect later today."
	
	Hyperlink id processing rule for 1: rule succeeds with result "x workbench".
	Hyperlink id processing rule for 2: rule succeeds with result "x beaker".
	Hyperlink id processing rule for 3: rule succeeds with result "x burner".
	Hyperlink id processing rule for 4: rule succeeds with result "x monstrosity".


Example: * Window Management

	*: "Window Management"
	
	Include Flexible Windows by Jon Ingold.
	Include Hyperlinks by Gavin Lambert.
	
	Office is a room.  "Finally, a corner office all to yourself.  This is the good life.  Or at least it would be, if the air conditioner were working.  Currently it's more of a muggy life."

	A large window is fixed in place in Office.  The printed name is "[set link 1]large window[clear link]".  "[A window] is set into one wall."
	The description is "On one wall a large window [if open]is slowly breathing life back into the office[otherwise]might just be your ticket to getting things bearable -- except that it's [set link 2]closed[clear link][end if]."
	The window can be openable.  The window can be open.  The window can be lockable.  The window can be locked.  The window is openable, lockable, locked.

	Instead of opening the locked window: say "You strain at the window for a few minutes, but it won't budge.  It seems [set link 3]security[clear link] electronically sealed all the windows at some point."
	
	After opening the unlocked window for the first time, say "After more straining, the window eventually cracks open a smidgen, then finally enough to allow a cool [set link 1]breeze[clear link] into the office."

	Calling security about is an action applying to one topic.  Understand "call security about [text]" as calling security about.
	
	Carry out calling security about "window":
		start a call;
		focus the main window;
		stop the action.
		
	Carry out calling security about "past events":
		start a call;
		say "You spend a few minutes in meandering conversation, but you don't think it's getting you anywhere.[paragraph break]";
		focus the main window;
		stop the action.
		
	Carry out calling security about "weather":
		start a call;
		say "You explain about the hot and muggy weather, and that the air conditioning isn't working properly.[paragraph break]";
		say "'I feel for ya, mate, I really do, but the policy clearly states that all the windows have to remain sealed.'[paragraph break]";
		say "After a few moments, he adds, 'Don't worry, there's a repair ticket in for the A/C.  Shouldn't be more'n a few days.  Week, tops.'[paragraph break]";
		say "You quail internally.[paragraph break]";
		focus the main window;
		stop the action.
		
	Carry out calling security about "sealed":
		start a call;
		say "You ask why the window was sealed in the first place.[paragraph break]";
		say "There's a moment of pause at the other end of the line, and then the worker responds, 'Well... let's just say that the former owner of your office... he... he had a [italic type]really[roman type] bad week.'[paragraph break]";
		focus the main window;
		stop the action.
		
	Carry out calling security about "escalate":
		start a call;
		say "You threaten to bring this up with his manager on your next lunch break.[paragraph break]";
		if the window is locked:
			say "In a slightly darker tone of voice, he responds, 'Now, now, there's no need for any of that, [italic type]Karen[roman type].'[paragraph break]";
			say "Sighing, 'Fine, fine, it's only policy after all, who am I to argue with [italic type]management[roman type].'[paragraph break]";
			focus the main window;
			say "You hear a quiet buzzing and clicking noise coming from [the window].";
			now the window is unlocked;
		otherwise:
			say "Somewhat defensively, he replies, 'Come on, that Karen thing was just a joke, you know I didn't really mean that.  I unlocked the window, didn't I?'";
			focus the main window;
		stop the action.
		
	Carry out calling security about:
		start a call;
		say "You try asking the security worker about [topic understood], but he doesn't seem interested.";
		focus the main window.
	
	The phone window is a text buffer g-window spawned by the main window.
	The background color of the phone window is "#FFFFE0".
	The position of the phone window is g-placebelow.
	The measurement of the phone window is 40.
		
	To start a call:
		open the phone window;
		clear the phone window;
		focus the phone window;
		say "You reach for the phone on your desk and call security.[paragraph break]";
		say "Eventually a grumpy voice responds.[paragraph break]";
		say "You ask about unsealing the window.[paragraph break]";
		say "The voice laughs dismissively, and you spend the next several minutes arguing about [set link 4]past events[clear link], the [set link 5]weather[clear link], why the window was [set link 6]sealed[clear link] in the first place, that you'll [set link 7]escalate[clear link] it to his manager, and so forth.[paragraph break]";
			
	Before doing anything except calling security about when the phone window is g-present:
		close the phone window;
		say "Sensing your distraction, the security worker hangs up on you."
	
	Hyperlink id processing rule for 1: rule succeeds with result "x window".
	Hyperlink id processing rule for 2: rule succeeds with result "open window".
	Hyperlink id processing rule for 3: rule succeeds with result "call security about window".
	Hyperlink id processing rule for 4: rule succeeds with result "call security about past events".
	Hyperlink id processing rule for 5: rule succeeds with result "call security about weather".
	Hyperlink id processing rule for 6: rule succeeds with result "call security about sealed".
	Hyperlink id processing rule for 7: rule succeeds with result "call security about escalate".


Example: ** I'll have a Side of Inventory, Please

In this example, we present the inventory as a sidebar (using the same example as given in Flexible Windows), but we assign each object a unique id that's used as a link to examine the object when shown in the sidebar.

	*: "I'll have a Side of Inventory, Please"
	
	Include Flexible Windows by Jon Ingold.
	Include Hyperlinks by Gavin Lambert.

	A thing has a number called link number.
	For printing the name of something (called item) when the current focus window is the side window:
		let id be the link number of item;
		if id is zero, continue the action;
		say "[set link id][printed name of item][clear link]".
		
	Hyperlink id processing rule for number (called id):
		repeat with item running through things:
			if id is the link number of item, rule succeeds with result "x [item]".

	The side window is a text buffer g-window spawned by the main window.
	The position of the side window is g-placeright.
	The measurement of the side window is 30.

	Rule for refreshing the side window:
		try taking inventory.
	
	When play begins:
		open the side window.
	
	Every turn:
		refresh the side window;
		focus the main window.
	
	The Study is a room. In the study is an old oak desk. On the desk is a Parker pen, a letter, an envelope and twenty dollars.
	The description of pen is "Metallic, with a stainless tip and other trimmings, but otherwise the body is all matte black.  [if carried]You feel fancier just holding it."
	The description of letter is "You've read this letter so many times that you can't stand to read it again.  And yet, you know you will, eventually."
	The description of envelope is "This is the envelope that the letter came in, on that fateful night just a few days ago."
	The description of twenty dollars is "A creased twenty dollar bill.  It was in the envelope along with the letter."
	The link number of pen is 1.
	The link number of letter is 2.
	The link number of envelope is 3.
	The link number of twenty dollars is 4.
	
	Test me with "take pen/take letter/i/take all".
