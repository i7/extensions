Version 1/151028 of Common Commands Sidebar (for Glulx only) by Alice Grove begins here.

"Displays a list of common parser commands in a sidebar as a reference for novice players. Includes actions to turn the sidebar off and on. Story author can tailor the command list and the appearance of the sidebar, or just plug and play. Requires version 6L of Inform 7."



[CCS is in beta. Known issues:
* Crashes in Spatterlight.
* In Gargoyle, the text color used in the sidebar will also be the color used for the cursor in the main window.
* Refreshing the sidebar may result in an extra line break in the main window. For the moment I've tried to keep refreshing to a minimum.]




Chapter - Required Extensions

Include version 15/150620 of Flexible Windows by Jon Ingold. [See extension documentation about where to find this version.]
Include Basic Screen Effects by Emily Short.


Chapter - Inform 6 Inclusions

To decide what number is the glk version:
	(- glk_gestalt( gestalt_Version, 0 ) -).

To decide whether a/the/-- column (TC - table column) exists in (T - table name):
	(- (TableFindCol({T}, {TC}) ~= 0) -).


Chapter - Debugging
			
Section - Enabling Debugging - Not For Release

CCS_debug is a truth state that varies. CCS_debug is usually true.

To decide if CCS debugging is on:
	if CCS_debug is true:
		decide yes;
	decide no.


Section - Disabling Debugging - For Release Only

CCS_debug is a truth state that varies.

To decide if CCS debugging is on:
	decide no.
	
Section - Debug-Specific Variables - unindexed

sidebar_prepared is a truth state that varies. sidebar_prepared is usually false.

sidebar_intro_setting_count is a number that varies.
sidebar_position_setting_count is a number that varies.
sidebar_text_setting_count is a number that varies.
sidebar_divider_setting_count is a number that varies.
prepare_sidebar_count is a number that varies.



Chapter - Setting Up the Sidebar

Section - Declaring the Window

The sidebar is a g-window.
The main window spawns the sidebar.
The position of the sidebar is usually g-placeleft.
The rock of the sidebar is 225.  [For use in a CSS stylesheet.]
The scale method of the sidebar is g-fixed-size.
The measurement of the sidebar is usually 30.



Section - Setting the Built-in Options

[If the phrase setting up the sidebar appears more than once in the source, the earlier settings will be reset to default before the later ones take effect, so we don't get a mix of old and new settings.]

To reset the sidebar settings: 
	now the sidebar is prompted automatically ;
	now the position of the sidebar is g-placeleft;
	now the sidebar lettering is "[roman type]";
	now the sidebar is space-divided;
	now the sidebar is not suggested following blank commands;
	now the sidebar is allowing toggling;
	now the sidebar is auto-adjusting the status bar.	

To reset the sidebar setting counters:
	now sidebar_intro_setting_count is 0;
	now sidebar_position_setting_count is 0;
	now sidebar_text_setting_count is 0;
	now sidebar_divider_setting_count is 0.	


To prepare the/-- command/commands sidebar, prompted automatically, shown automatically, shown manually, on the left, on the right, with roman type, with fixed letter spacing, with italic type, with bold type, divided with space, divided with stars, not divided, suggested after blank commands, with toggling disabled, and/or without changing the status line:
	if sidebar_prepared is true:
		reset the sidebar settings;	
		reset the sidebar setting counters;
	if shown manually:
		now the sidebar is shown manually;
		increment sidebar_intro_setting_count;
	if shown automatically:
		now the sidebar is shown  automatically;
		increment sidebar_intro_setting_count;
	if prompted automatically:
		now the sidebar is prompted automatically;
		increment sidebar_intro_setting_count;
	if on the right:
		now the position of the sidebar is g-placeright;	
		increment sidebar_position_setting_count;
	if on the left:
		now the position of the sidebar is g-placeleft;
		increment sidebar_position_setting_count;
	if with bold type:
		now sidebar lettering is "[bold type]";
		increment sidebar_text_setting_count;
	if with italic type:
		now sidebar lettering is "[italic type]";
		increment sidebar_text_setting_count;
	if with fixed letter spacing:
		now sidebar lettering is "[fixed letter spacing]";
		increment sidebar_text_setting_count;
	if with roman type:
		now sidebar lettering is "[roman type]";
		increment sidebar_text_setting_count;
	if not divided:
		now the sidebar is undivided;
		increment sidebar_divider_setting_count;
	if divided with stars:
		now the sidebar is star-divided;
		increment sidebar_divider_setting_count;
	if divided with space:
		now the sidebar is space-divided;
		increment sidebar_divider_setting_count;
	if suggested after blank commands:
		now the sidebar is suggested following blank commands;
	if with toggling disabled:
		now the sidebar is disallowing toggling;
	if without changing the status line:
		now the sidebar is leaving the status bar alone;
	if CCS debugging is on:
		mention sidebar preparation bugs;
	now sidebar_prepared is true.
	
	
		
To mention sidebar preparation bugs:
	if sidebar_prepared is true:
		say "CCS Debug Message #2: 'Prepare the command sidebar' has been invoked more than once in the code. This may result in unexpected sidebar settings, since later invocations will override earlier ones.[line break]";
	if sidebar_intro_setting_count > 1:
		say "CCS Debug Message #4: The sidebar introduction method (available choices are 'prompted automatically,' 'shown automatically,' and 'shown manually') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one of these options can take effect.[line break]";
	if sidebar_position_setting_count > 1:
		say "CCS Debug Message #6: The sidebar position (available choices are 'on the left,' and 'on the right') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one of these options can take effect.[line break]";
	if sidebar_text_setting_count > 1:
		say "CCS Debug Message #8: The text style setting for the sidebar (available choices are 'with roman type,' 'with fixed letter spacing,' 'with italic type,' and 'with bold type') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one text style option can take effect.[line break]";
	if sidebar_divider_setting_count > 1:
		say "CCS Debug Message #10: The divider setting for the sidebar (built-in choices are 'divided with space,' 'divided with stars,' and 'not divided') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one divider option can take effect.[line break]";
	if (sidebar_divider_setting_count > 0) and (custom sidebar divider is not ""):
		say "CCS Error Message #12: The divider setting for the sidebar (available built-in choices are 'divided with space,' 'divided with stars,' and 'not divided') has been set in a 'Prepare the command sidebar' line, but a 'custom sidebar divider' has also been specified elsewhere. This may have unexpected results, since only one divider option can take effect.[line break]";
		
	

Section - Colors

Table of User Styles (continued)
window (a g-window)	relative size
sidebar	0

[The relative text size is set to 0 to reduce disparity between the results in Gargoyle and other interpreters. Otherwise a bold title may barely fit into the width of the sidebar in WinGluxe, while it looks relatively small in Gargoyle.]
		
This is the set the sidebar text color rule:
	if there is a window of sidebar in the Table of User Styles: [should always be the case; a safeguard against run-time errors]
		now the color corresponding to a window of sidebar in the Table of User Styles is the text color of the sidebar;
		

The background color of the sidebar is usually "#F0E2C7". [beige]

The text color of the sidebar is a text that varies. The text color of the sidebar is usually "#363025". [dark brown]




Section - Sidebar Text


Table of Default Sidebar Commands
Displayed Command (a text)
"[bold type]Useful Commands"
" "
"[fixed letter spacing]     N"
"[fixed letter spacing]  NW   NE"
"[fixed letter spacing]W    *    E"
"[fixed letter spacing]  SW   SE"
"[fixed letter spacing]     S"
" "
"In/Out"
"Up (U)/Down (D)"	
"?"
"Look (L)"
"Inventory (I)"
"Take/Drop something"
"Examine (X) it"
"Open/Close it"
"Push/Pull it"
"Put it in something"
"Put it on something"
"Wait (Z)"
"?"
"About"
"Help"
"Hint"
"Again (G)"
"Undo"
"Save/Restore"
"Quit (Q)"
"[if the sidebar is allowing toggling]Sidebar on/off[end if]"
with 10 blank rows


Table of Custom Sidebar Commands
Displayed Command (a text)
--


Table of Extension-Provided Sidebar Commands
Displayed Command (a text)
--



The sidebar indent is a text that varies. The sidebar indent is usually "  ".

The sidebar lettering is some text that varies. The sidebar lettering is usually "[roman type]".

The sidebar can be space-divided, star-divided, undivided, or custom-divided (this is the sidebar divider type property). The sidebar is space-divided.

The custom sidebar divider is some text that varies. The custom sidebar divider is usually "".


This is the print the commands sidebar text rule:
	if the column Displayed Command exists in the chosen table of commands:
		repeat through the chosen table of commands:
			if there is a Displayed Command entry and the Displayed Command entry is not "": 
				if the Displayed Command entry is not "?": [if it's not a divider row]
					say "[line break][fixed letter spacing][sidebar indent][sidebar lettering][displayed command entry]" (A); [line break (prints blank line before the first line of text as well), indent and print command in chosen typeface]
				otherwise: [if it's "?"--a row for a built-in divider]
					if the sidebar is space-divided:
						say "[line break]" (B);
					otherwise if the sidebar is undivided:
						do nothing;
					otherwise: [if the divider is composed of text or symbols]
						say "[paragraph break][fixed letter spacing][sidebar indent][sidebar lettering]" (C); [blank line above the divider symbols, indent and set typeface for symbols]
						if the sidebar is star-divided:
							say "* * *" (D);
						otherwise if the sidebar is custom-divided:
							say custom sidebar divider;
						say "[line break]" (E). [blank line below divider symbols]

	
	
Section - Choosing the Appropriate Table - unindexed


The chosen table of commands is a table name that varies. The chosen table of commands is usually the Table of Default Sidebar Commands.

commands_table_chosen is a truth state that varies. commands_table_chosen is usually false.
	
When play begins (this is the choose the appropriate table of commands rule):
	if commands_table_chosen is false: [if author has not already swapped in a table]
		if the Table of Custom Sidebar Commands is not empty:
			now the chosen table of commands is the Table of Custom Sidebar Commands;
		otherwise if the Table of Custom Sidebar Commands is empty:
			now the chosen table of commands is the Table of Default Sidebar Commands;
		now commands_table_chosen is true.
		


Section - Finalizing the Window Attributes

[Optional window attributes are set just before opening the sidebar for the first time, so that the story author's "when play begins: prepare the command sidebar" rule, if there is one, will happen first.]

sidebar_attributes_finalized is a truth state that varies. sidebar_attributes_finalized is initially false.

To finalize the sidebar attributes:
	follow the set the sidebar text color rule;
	if the custom sidebar divider is not "":
		now the sidebar is custom-divided;
	now sidebar_attributes_finalized is true.
	
	

Chapter - Sidebar Behavior	


Section - Detecting Whether the Interpreter Will Support the Sidebar

[This exists to reduce the risk of crashing in Spatterlight.]

The sidebar can be awaiting interpreter detection, supported by the interpreter, or unsupported by the interpreter (this is the sidebar/interpreter compatibility property). The sidebar is awaiting interpreter detection.


To decide if the interpreter supports the sidebar:
	if the sidebar is awaiting interpreter detection:
		follow the detect whether the interpreter is compatible with the sidebar rule;
	if the sidebar is supported by the interpreter, yes;
	no.

This is the detect whether the interpreter is compatible with the sidebar rule:	
	if the glk version is 1792:
		unless Glulx character input is supported:
			if Glulx mouse input is supported:
				unless Glulx hyperlinks are supported:
				[unique Spatterlight characteristics (i.e. not shared by Zoom and Mac IDE) end here]
					if Glulx timekeeping is supported:
						unless Glulx sound notification is supported:
							if Glulx graphic-window mouse input is supported:
								now the sidebar is unsupported by the interpreter; [i.e. we're using Spatterlight]
								make no decision; [i.e. stop the rule here]
	now the sidebar is supported by the interpreter.
	
Check saving the game (this is the reset the sidebar/interpreter compatibility before saving rule):
	now the sidebar is awaiting interpreter detection.

[
 The refresh windows after arranging rule does nothing unless the interpreter supports the sidebar.
 
 The refresh windows after restoring rule does nothing unless the interpreter supports the sidebar.
]

Section - Introducing the Sidebar

The sidebar can be prompted automatically, shown automatically, or shown manually (this is the sidebar introduction method).
The sidebar is prompted automatically.

The sidebar can be introduced already. The sidebar is not introduced already.


After printing the banner text when (the sidebar is shown automatically) and (the sidebar is not introduced already) (this is the automatically show the command sidebar rule):
	if (the interpreter supports the sidebar) and (the main window is large enough to show the sidebar):
		show the command sidebar window;
		if the sidebar is g-present:
			say "[italic type]This story offers a sidebar that shows some commands commonly used in interactive fiction[if the sidebar is allowing toggling]. You can turn the sidebar off and on by typing SIDEBAR OFF and SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (A);
			say "[roman type]" (B);
			now the sidebar is introduced already;
		[if it's not present, the show phrase will print a message]
	otherwise:
		follow the introduce the sidebar commands as a list rule.
		

After printing the banner text when (the sidebar is prompted automatically ) and (the sidebar is not introduced already) (this is the ask the player whether to show the command sidebar rule):
	if (the interpreter supports the sidebar) and (the main window is large enough to show the sidebar):
		say "[italic type]This story offers a sidebar that shows some commands commonly used in interactive fiction. Would you like to see the sidebar? (Y/N)[roman type]>[run paragraph on]" (A);
		if player consents:
			show the command sidebar window;
			if sidebar is g-present:
				Say "[line break][italic type]The commands sidebar is now displayed[if the sidebar is allowing toggling]. You can turn the sidebar off and on by typing SIDEBAR OFF and SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (B);
				say "[roman type]" (C);
			[if it's not present, the show phrase will print a message]
		otherwise:
			say "[line break][italic type]The commands sidebar is currently hidden[if the sidebar is allowing toggling]. You can turn the sidebar on and off by typing SIDEBAR ON and SIDEBAR OFF[end if]. To list the commands in the main window, type COMMANDS.[roman type][paragraph break]" (D);
		now the sidebar is introduced already;
	otherwise:
		follow the introduce the sidebar commands as a list rule.
		
		
This is the introduce the sidebar commands as a list rule:
	say  "[italic type]For your reference, this story offers a list of commands commonly used in interactive fiction. You can see this list at any time by typing COMMANDS." (A);
	say "[roman type]" (B);
	now the sidebar is introduced already.



Section - Showing and Hiding the Sidebar


The minimum window width for opening the sidebar is a number that varies. The minimum window width for opening the sidebar is usually 50.

The minimum window height for opening the sidebar is a number that varies. The minimum window height for opening the sidebar is usually 15.


To decide if the main window is large enough to show the sidebar:
	if the width of the main window >= minimum window width for opening the sidebar:
		if the height of the main window >= minimum window height for opening the sidebar:
			decide yes;
	decide no.
	

To show the command sidebar window:
	if the interpreter supports the sidebar:
		if sidebar_attributes_finalized is false:
			finalize the sidebar attributes;
		if the main window is large enough to show the sidebar:
			open the sidebar;
			unless the sidebar is g-present:
				follow the can't open the sidebar for unknown reason rule;
		otherwise:
			follow the can't open the sidebar when the main window is too small rule;
	otherwise:
		follow the can't use the sidebar when the interpreter doesn't support it rule.

	

This is the can't use the sidebar when the interpreter doesn't support it rule:
	say "The commands sidebar is not supported by your interpreter[if the sidebar is allowing toggling]. To list the commands in the main window instead, type COMMANDS[end if]." (A).
	
This is the can't open the sidebar when the main window is too small rule: [Also catches Parchment, which seems to fail the minimum size tests no matter what]
	say "The commands sidebar could not be opened. Either your interpreter does not support this feature, or the window is not large enough to conveniently display the sidebar[if the sidebar is allowing toggling]. To list the commands in the main window instead, type COMMANDS[end if]." (A).
	
This is the can't open the sidebar for unknown reason rule:
	say "The commands sidebar could not be opened[if the sidebar is allowing toggling]. To list the commands in the main window instead, type COMMANDS[end if]." (A).
	
	
To hide the command sidebar window:
	if the interpreter supports the sidebar:
		close the sidebar;
	otherwise:
		follow the can't use the sidebar when the interpreter doesn't support it rule.
		
		
		
Section - Refreshing the Sidebar


[Every turn when the interpreter supports the sidebar and the sidebar is g-present (This is the Refresh the Sidebar Window Rule):
	refresh the sidebar.]
	

Rule for refreshing the sidebar (This is the Refresh the Sidebar Commands Rule):
	if the interpreter supports the sidebar:
		follow the print the commands sidebar text rule;
		say "[run paragraph on]" (A). [an attempt to compensate for the line break otherwise printed when switching back to the main window]
	
	
	
Section - Turning the Sidebar On and Off

The sidebar can be either allowing toggling or disallowing toggling. The sidebar is allowing toggling.


Toggling the commands sidebar is an action out of world.
Understand "sidebar" as toggling the commands sidebar.

Check toggling the commands sidebar:
	unless the interpreter supports the sidebar:
		follow the can't use the sidebar when the interpreter doesn't support it rule instead.

Carry out toggling the commands sidebar (this is the toggle the commands sidebar rule):
	if the sidebar is g-unpresent:
		try turning on the commands sidebar;
	otherwise if the sidebar is g-present:
		try turning off the commands sidebar.


Turning on the commands sidebar is an action out of world.
Understand "sidebar on" as turning on the commands sidebar when the sidebar is allowing toggling.
[Understand "sidebar" as turning on the commands sidebar when the sidebar is allowing toggling and the sidebar is g-unpresent.]

Check turning on the commands sidebar:
	unless the interpreter supports the sidebar:
		follow the can't use the sidebar when the interpreter doesn't support it rule instead.

Carry out turning on the commands sidebar (this is the turn on the commands sidebar rule):
	if sidebar is g-unpresent:
		show the command sidebar window;
		if the sidebar is g-present:
			Say "The commands sidebar is now displayed[if the sidebar is allowing toggling]. To hide it, type SIDEBAR OFF[end if]." (A);
		[show phrase will print message if unsuccessful]
	otherwise:
		say "The commands sidebar is already displayed[if the sidebar is allowing toggling]. To hide it, type SIDEBAR OFF[end if]. To list the commands in the main window, type COMMANDS." (B).
			
			
Turning off the commands sidebar is an action out of world.
Understand "sidebar off" as turning off the commands sidebar when the sidebar is allowing toggling.

[Understand "sidebar" as turning off the commands sidebar when the sidebar is allowing toggling and the sidebar is g-present.]
[Understand "sidebar" as turning off the commands sidebar when the sidebar is allowing toggling.]

Check turning off the commands sidebar:
	unless the interpreter supports the sidebar:
		follow the can't use the sidebar when the interpreter doesn't support it rule instead.

Carry out turning off the commands sidebar (this is the turn off the commands sidebar rule):
	if sidebar is g-present:
		hide the command sidebar window;
		Say "The commands sidebar is now hidden[if the sidebar is allowing toggling]. To show it again, type SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (A);
	otherwise:
		say "The commands sidebar is already hidden[if the sidebar is allowing toggling]. To show it, type SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (B).
		
		
		
Understand "sidebar [text]" as a mistake ("Use SIDEBAR ON and SIDEBAR OFF to turn the sidebar on and off, or SIDEBAR to toggle. To list the commands in the main window, type COMMANDS.") when the sidebar is allowing toggling.
		


Section - Swapping Tables

To swap (TN - a table name) into the/-- sidebar:
	now the chosen table of commands is TN;
	if (the interpreter supports the sidebar) and (the sidebar is g-present):
		refresh the sidebar;
	now commands_table_chosen is true.
	
	





Chapter - Compatibility with Menus Extensions

[Temporarily hide the sidebar when we open a full-screen menu with Emily Short's Menus extension or Wade Clarke's Menus extension.]



Section - Temporarily Hiding and Showing with Full Screen Menus


menu_on_display is a truth state that varies. menu_on_display is usually false. 

The sidebar can be flagged to appear later. The sidebar is not flagged to appear later.
		
		
To temporarily hide the sidebar if necessary:
	if (the interpreter supports the sidebar) and (the sidebar is g-present):
		now the sidebar is flagged to appear later;
		hide the command sidebar window;
	now menu_on_display is true.
	

To show the hidden sidebar if necessary:
	now menu_on_display is false;
	If the sidebar is flagged to appear later:
		show the command sidebar window;
		now the sidebar is not flagged to appear later.
		


Section - Compatibility with Emily Short's Menus (for use with Menus by Emily Short)


Before displaying (This is the hide the sidebar before opening a menu with Emily Short's Menus rule):
	temporarily hide the sidebar if necessary.
	
	
After displaying (This is the show the hidden sidebar after closing a menu with Emily Short's Menus rule):
	show the hidden sidebar if necessary.
	
	
	
Section - Compatibility with Wade Clarke's Menus (for use with Menus by Wade Clarke)


Before displaying (This is the hide the sidebar before opening a menu with Wade Clarke's Menus rule):
	temporarily hide the sidebar if necessary.
	
	
After displaying (This is the show the hidden sidebar after closing a menu with Wade Clarke's Menus rule):
	show the hidden sidebar if necessary.



Chapter - Adjusting the Status Line

The sidebar can be either auto-adjusting the status bar or leaving the status bar alone. The sidebar is auto-adjusting the status bar.


The sidebar can be either far from the status line text or near the status line text.

Before constructing the status line when the sidebar is auto-adjusting the status bar (this is the will the sidebar be too close to the status line text rule):
	if the sidebar is g-unpresent:
		now the sidebar is far from the status line text;
	otherwise if the no status line option is active:
		now the sidebar is far from the status line text;	
	otherwise if the position of the sidebar is g-placeleft:
		now the sidebar is near the status line text;
	otherwise if the scoring option is active:
		now the sidebar is near the status line text;
	otherwise:
		now the sidebar is far from the status line text.
		
		
Rule for constructing the status line when (the sidebar is auto-adjusting the status bar) and (the sidebar is near the status line text) (this is the center the status line text when it's too close to the sidebar rule):
	center "[Player's surroundings][if the scoring option is active] ([score]/[turn count])[end if]" (A) at row 1.
	
	
	
Chapter - Suggesting the Sidebar after a Blank Command

The sidebar can be suggested following blank commands. [default to false?]

Rule for printing a parser error when ((the latest parser error is the I beg your pardon error) and (the sidebar is suggested following blank commands) and (the sidebar is g-unpresent)) (this is the suggest the sidebar when the player enters a blank command rule):
	say "If you're not sure what to do, type [if (the sidebar is allowing toggling) and (the sidebar is supported by the interpreter) and (the main window is large enough to show the sidebar)]SIDEBAR ON[otherwise]COMMANDS[end if] to see some commands you can try." (A) instead.	
	
	
	
Chapter - Listing the Sidebar Commands in the Main Window

[The action "Listing the Sidebar Commands" lists the commands in the main window. This serves as an alternative to the sidebar for players using screenreaders or interpreters that don't support extra windows. The carry out rule converts the commands into list form and translates the default compass rose, if present, into words. We may want to check the results, especially if we've made any changes to the commands.]



Listing the sidebar commands is an action out of world.
Understand "commands" as listing the sidebar commands.
Understand "commands [text]" as a mistake ("To list useful commands in the main window, type just COMMANDS[if the sidebar is allowing toggling].  Use SIDEBAR ON and SIDEBAR OFF to turn the sidebar on and off, or SIDEBAR to toggle it[end if].").
.
Check listing the sidebar commands when commands_table_chosen is false (this is the choose the appropriate table of commands before printing the command list rule):
	follow the choose the appropriate table of commands rule.

custom command list is some text that varies. custom command list is usually "".


To decide if (TN - a table name) uses the default compass rose:
	if there is a displayed command of "     N" in TN:
		if there is a displayed command of "  NW   NE" in TN:
			if there is a displayed command of "W    *    E" in TN:
				if there is a displayed command of "  SW   SE" in TN:
					if there is a displayed command of "     S" in TN:
						decide yes;
	decide no.
	

					
To decide if (T - a text) is a default compass rose entry:
	if T is "     N", yes;
	if T is "  NW   NE", yes;
	if T is "W    *    E", yes;
	if T is "  SW   SE", yes;
	if T is "     S", yes;
	no.
	
compass_rose_already_listed is a truth state that varies. compass_rose_already_listed is usually false.


[To decide if (T - a text) should be included among the listed commands:
	if T is "", no;
	if T is " ", no;
	if T is "?", no;
	yes.]
	
To decide if (T - a text) should be included among the listed commands:
	if T is "", no;
	if T is " ", no;
	yes.
	

Carry out listing the sidebar commands (this is the print the sidebar commands in the main window rule):
	if the custom command list is not "":
		say the custom command list;
	otherwise if the column Displayed Command exists in the chosen table of commands:
		if the chosen table of commands uses the default compass rose:
			now compass_rose_already_listed is false;
			repeat through the chosen table of commands:
				if there is a Displayed Command entry:
					if the Displayed Command entry should be included among the listed commands:
						if the Displayed Command entry is "?":
							say "[paragraph break]" (A);
						otherwise if the Displayed Command entry is a default compass rose entry:
							if compass_rose_already_listed is false:
								say "[sidebar lettering]North (N). South (S). East (E). West (W). Northeast (NE). Southeast (SE). Northwest (NW). Southwest (SW). " (B);
								now compass_rose_already_listed is true;
							otherwise if compass_rose_already_listed is true:
								do nothing;
						otherwise: [if it's not a divider or a compass rose entry]
							say "[sidebar lettering][displayed command entry]. " (C);
			say "[line break]" (D);
		otherwise: [if the table does not contain the default compass rose]
			repeat through the chosen table of commands:
				if there is a Displayed Command entry:
					if the Displayed Command entry should be included among the listed commands:
						if the Displayed Command entry is "?": [if it's a divider]
							say "[paragraph break]" (E);
						otherwise:
							say "[sidebar lettering][displayed command entry]. " (F);
			say "[line break]" (G).

		

Chapter - Attribution

Report requesting the story file version (this is the attribute the play IF postcard rule):
	say "'How To Play Interactive Fiction: An entire strategy guide on a single postcard,' written by Andrew Plotkin and designed by Lea Albaugh, was the inspiration for the Common Commands Sidebar extension. The postcard, available at <http://pr-if.org/doc/play-if-card/>, is licensed under a CC BY SA 3.0 United States licen[if the American dialect option is active]s[otherwise]c[end if]e, available at <http://creativecommons.org/licenses/by-sa/3.0/us/>.  Content was adapted with permission. See the extension documentation for details." (A).




Common Commands Sidebar ends here.


---- DOCUMENTATION ---- 

Chapter: Acknowledgements

Thanks to Joseph Geipel, Andrew Schultz, and Nick Turner for testing, to BjÃ¶rn Paulsen for code feedback, and to BjÃ¶rn Paulsen, Daniel Stelzer, Dannii Willis, Erik Temple, Hanon Ondricek, Joseph Geipel, Juhana, Matt Weiner, Peter Piers, and zarf for responding to my questions.

This extension is inspired by 'How To Play Interactive Fiction: An entire strategy guide on a single postcard' written by Andrew Plotkin and designed by Lea Albaugh. The postcard, available at <http://pr-if.org/doc/play-if-card/>, is licensed under a CC BY SA 3.0 United States license, available at <http://creativecommons.org/licenses/by-sa/3.0/us/>. Content from the postcard has been adapted with permission.

Modifications from the original postcard:

	* Adapted to extension form with Inform code and documentation.
	* Layout changed to vertical window.
	* Changed colors.
	* New heading.
	* Condensed the list of commands and added extension-specific commands.
	* Changes to wording, arrangement, and text formatting of commands.
	* Explanations and other text omitted.
	* Compass rose represented in text; other graphical elements omitted.
	
Chapter: Basics


Section:  About the Required Extensions


Common Commands Sidebar requires

	Version 15/150620 of Flexible Windows (for Glulx only) by Jon Ingold
	
	http://raw.githubusercontent.com/i7/extensions/master/Jon%20Ingold/Flexible%20Windows.i7x

which in turn requires

	Version 10/150620 of Glulx Entry Points (for Glulx only) by Emily Short
	
	http://raw.githubusercontent.com/i7/extensions/master/Emily%20Short/Glulx%20Entry%20Points.i7x

and 

	Version 1/140516 of Alternative Startup Rules (for Glulx only) by Dannii Willis
	
	http://raw.githubusercontent.com/i7/extensions/master/Dannii%20Willis/Alternative%20Startup%20Rules.i7x
	
(Basic Screen Effects is also required, but any relatively recent version will do.)

Note that Flexible Windows uses the container relation for windows, so we'll need to be cautious about iterating through all containers.


Section: Bare Minimum Implementation

If we want the default appearance and behavior for the sidebar, the only thing we need to do is to include the following line in our source:

	Include Common Commands Sidebar by Alice Grove.

Everything else is optional.


Section: Toggling the Sidebar from a Full-Screen Menu

When we open a full-screen menu created with Menus by Emily Short or Menus by Wade Clarke, the sidebar, if visible, will be automatically hidden. It will also be flagged so that, once the menu closes, the sidebar will automatically be shown again. To allow toggling the sidebar from inside the menu, we can write a toggle rule to set the sidebar property
	
	flagged to appear later
			
as in the "Lost in 'Lost Igpay'" example.


Chapter: Options

Section: Built-in Options

Many of the options can be set with a single rule, for example

	When play begins:
		prepare the command sidebar, shown automatically, on the right, with italic type.
		
The first part of the rule

	*:
	When play begins:
		prepare the command sidebar,

is followed by one or more of the phrases below, separated by commas. Within each of the following code blocks, phrases are mutually exclusive--including both "prompted automatically" and "shown automatically," for instance, will result in only one of these options taking effect. (See the section on debugging.)

The sidebar can be introduced in one of three ways:
	
	prompted automatically
	shown automatically
	shown manually

"Prompted automatically" prompts the player to choose whether or not to show the sidebar. This is the default setting.
"Shown automatically" displays the sidebar without prompting the player to choose.
"Shown manually" keeps the sidebar hidden until it is shown manually (for instance, if the player types SIDEBAR ON).

The "prompted automatically" and "shown automatically" options include a brief explanation of the sidebar. But if we choose "shown manually," it will be up to us to inform the player that the sidebar is available. We may want to give instructions in our help text for turning the sidebar on and off (SIDEBAR ON and SIDEBAR OFF) and for listing the commands in the main window (COMMANDS) if a player's interpreter or screenreader doesn't support the sidebar. See also the section on toggling the sidebar from a menu.
	
To position the sidebar (left is the default):

	on the left
	on the right

To choose a style for the sidebar text ("with roman type" is the default): 

	with roman type
	with fixed letter spacing
	with italic type
	with bold type
	
To visually divide the groups of commands (the default is "divided with space," which leaves a blank line between categories):
	
	divided with space
	divided with stars
	not divided
	
(Note: For a custom divider, we can instead set the variable "custom sidebar divider" to the ornament we'd like to use, altering the typeface from our other sidebar text if desired:
	
	*: The custom sidebar divider is "[fixed letter spacing]+ + +[variable letter spacing]".
	
This is not part of the "prepare the command sidebar" line.)

To suggest to players who enter a blank command, and who do not have the sidebar visible, that they type SIDEBAR ON or COMMANDS to see some commands to try (this suggestion is disabled by default):

	suggested after blank commands

To prevent the typed commands SIDEBAR ON, SIDEBAR OFF, and SIDEBAR (which normally turn the sidebar on and off) from being understood:
	
	with toggling disabled
	
To leave the status line untouched, instead of automatically adjusting it when the sidebar is visible:

	without changing the status line
	
This extension assumes we are using Inform's default status line, with the player's surroundings on the left and (if we are using scoring) the score and turn count on the right. To avoid inconsistent text alignment between the status line and the sidebar, and to avoid ambiguity (especially if the sidebar and status line are similar in color), this extension by default centers the standard status text whenever it would otherwise appear directly above the sidebar. If we have a custom status bar, we'll likely want to disable or adjust this behavior.

Section: Debugging

A built-in debugging feature will warn us if 'prepare the command sidebar' is invoked more than once in the code (in which case a later invocation will override an earlier one) or if mutually exclusive sidebar options have been chosen (in which case only one of the options will take effect). The debugging messages are disabled in the release version of the story. We can also turn off debugging manually by including

	CCS_debug is false.
	
in our code.
	

Section: Colors, Margin, and Measurements

To change the sidebar colors from the default brown text on a beige background, we can use hex color codes (the 6-digit variety). A web search for "hex color codes" will bring up helpful sites that give the codes. For a black background with white text, we could say
	
	*:
	The background color of the sidebar is "#000000".
	The text color of the sidebar is "#ffffff".

Since not all interpreters support indentation, the left margin of the sidebar is created by printing fixed-width blank spaces at the beginning of each line. We can override this default indentation with our own, putting the desired number of spaces between the quotation marks:

	*: The sidebar indent is "   ".


To set the sidebar width (in characters, not pixels), we could say
	
	*: The measurement of the sidebar is 28.	
	
The units used to measure text windows vary from one interpreter to another. Width in characters is an approximation. We'll want to check the results in interpreters that are used by players, because the sidebar may look very different in the Inform IDE.
 
 
 To set the minimum size that we want the main window to be (in approximate characters, rather than pixels) in order to allow the sidebar to be displayed, we can say, for instance,

	*:
	The minimum window width for opening the sidebar is 60.
	The minimum window height for opening the sidebar is 20.

If, at the start of play, the main window does not meet these minimums, and if the sidebar is set to be shown automatically or to show an opening prompt, the player will instead see an opening message about how to list the commands in the main window.


Section: Colors, etc. in Quixe

The Quixe interpreter will not automatically display the colors we have set in the source. To customize the colors, presence/absence of scroll bars, and various other elements as they appear in the Quixe interpreter, we can "Release along with an interpreter" (see "§25.11. A playable web page" in the Inform manual) and modify the glkote.css file found in the interpreter folder. Glkote.css is automatically generated on each release, so we'll want to keep a copy of the modified file where it won't be overwritten. (There's a bit about this in "§25.13. Website templates" in the manual.)

The glkote.css file is written in a language called CSS. (More information about CSS is available with a web search). In glkote.css we should use ".WindowRock_225" to identify the sidebar.

An example: to set the sidebar's background color ("background") to light blue and its text color ("color") to dark blue using hex color codes, we could add the following to the CSS file. (Despite how the spacing may appear in this documentation, there should be no space between the period and the W.)

	.WindowRock_225 {
	  background: #BAF7F4;
	  color: #070833;
	}
	
There are some explanatory comments in the default glkote.css file, available at <http://eblong.com/zarf/glk/glkote/glkote.css> or in the interpreter folder, as mentioned. Further information can be found at <http://eblong.com/zarf/glk/glkote/docs.html#css>.

  
Chapter: Using Different Text in the Sidebar

If we don't want to use the default commands in the sidebar, there are several ways we can go about changing them. Note that changing the sidebar text will also change the list printed in the main window by the "listing the sidebar commands" action, so we may want to type COMMANDS to check that as well.

Section: The "Cut and Paste" Method

If we paste one of the templates below into our code to continue the (initially blank) Table of Custom Sidebar Commands, we can add, delete, cut, and paste rows to arrange the commands exactly how we want them. If we continue the Table of Custom Sidebar Commands in our code, our custom table will automatically be substituted for the default table in the sidebar (unless we specify otherwise).

The commands in this first template are identical to the commands in the default sidebar:
	
	*:	
	Table of Custom Sidebar Commands (continued)
	Displayed Command
	"[bold type]Useful Commands"
	" "
	"[fixed letter spacing]     N"
	"[fixed letter spacing]  NW   NE"
	"[fixed letter spacing]W    *    E"
	"[fixed letter spacing]  SW   SE"
	"[fixed letter spacing]	    S"
	" "
	"In/Out"
	"Up (U)/Down (D)"
	"?"
	"Look (L)"
	"Inventory (I)"
	"Take/Drop something"
	"Examine (X) it"
	"Open/Close it"
	"Push/Pull it"
	"Put it in something"
	"Put it on something"
	"Wait (Z)"
	"?"
	"About"
	"Help"
	"Hint"
	"Again (G)"
	"Undo"
	"Save/Restore"
	"Quit (Q)"
	"[if the sidebar is allowing toggling]Sidebar on/off[end if]"
	
	
This next template has the above commands plus Give, Show, Ask, and Tell, for stories with other characters:

	*:	
	Table of Custom Sidebar Commands (continued)
	Displayed Command
	"[bold type]Useful Commands"
	" "
	"[fixed letter spacing]     N"
	"[fixed letter spacing]  NW   NE"
	"[fixed letter spacing]W    *    E"
	"[fixed letter spacing]  SW   SE"
	"[fixed letter spacing]	    S"
	" "
	"In/Out"
	"Up (U)/Down (D)"
	"?"
	"Look (L)"
	"Inventory (I)"
	"Take/Drop something"
	"Examine (X) it"
	"Open/Close it"
	"Push/Pull it"
	"Put it in something"
	"Put it on something"
	"Give it to someone"
	"Show it to someone"
	"Ask someone about it"
	"Tell someone about it"
	"Wait (Z)"
	"?"
	"About"
	"Help"
	"Hint"
	"Again (G)"
	"Undo"
	"Save/Restore"
	"Quit (Q)"
	"[if the sidebar is allowing toggling]Sidebar on/off[end if]"
	
	
If we'd rather start from scratch, we can use a table continuation with the following name and column heading:
	*:
	Table of Custom Sidebar Commands (continued)
	Displayed Command (a text)
	
Below this, we list the sidebar title (if desired) and command entries in a single column in the order we'd like them displayed. Each "?" entry will automatically be replaced with the chosen divider option (which, if it's a text ornament, will include a blank line before and after). A blank line will automatically be added at the top of the sidebar. Each " " entry will result in a blank line in the sidebar. (That's a single space between quotation marks--using more than one space can lead to stray punctuation in the auto-generated list for the "listing the sidebar commands" action.)


Section: The "Add or Remove Rows in the Default Table" Method

Another way to change the sidebar text is to use code to add or remove rows in the Table of Default Sidebar Commands, which is found in the extension source. Or we could continue this table to add new commands at the end, perhaps starting with a divider ("?") if we want to separate the new commands from the default meta commands:

	*:	
	Table of Default Sidebar Commands (continued)
	Displayed Command
	"?"
	"New Command 1"
	"New Command 2"
	
For more information, see "16.9. Blank rows," "16.10: Adding and removing rows," and  "16.18: Table continuations" in the Inform manual.


Section: The "Swap in a Different Table" Method

Still another approach to changing the text in the sidebar is to designate a specific table (an additional table we have created, or one from an extension) as the table from which the sidebar commands should be drawn. To do this we use the phrase "swap Table Name into the/-- sidebar": 

	*:
	When play begins:
		swap the Table of Extension-Provided Sidebar Commands into the sidebar.
		
The Table of Extension-Provided Sidebar Commands is a table that other extensions can use to add commands to the sidebar. For example, an extension that creates a swimming action might add "Swim." to this table, and another extension might add "Turn invisible." If we've included both these extensions in our source after Common Commands Sidebar, swapping in the Table of Extension-Provided Sidebar Commands will add "Swim." and "Turn invisible." to the end of the sidebar.

We can swap in any table so long as it includes a column with the following heading:
		
	*:
	Displayed Command (a text)
	
The "swap Table Name into the/-- sidebar" phrase can also be used to switch from one set of commands to another mid-story.


	
Section: Adjusting the Commands Listed in the Main Window

When the player types COMMANDS, the "listing the sidebar commands" action prints a list of the sidebar commands in the main window. This is intended for players using screenreader software, or devices with small screens, or interpreters that won't display the sidebar (e.g. Parchment). The list is automatically generated from our table of commands, so we may want to check that the results look reasonable, particularly if we've changed the sidebar text.

If we want to adjust the results, and if we are using only one table of commands during play, we can create our own list as a string using the variable "custom command list", for instance

	*:
	The custom command list is "Useful Commands. North (N). South (S). East (E). West (W). Talk to someone. Help. Quit (Q)."
	
Our custom list will automatically be used instead of the auto-generated list. Alternatively, we can replace responses in the carry out rule for the "listing the sidebar commands" action, or we can replace the rule entirely.

If we are using more than one table of commands during play, and if at least one of these tables requires a custom list, we'll probably want to write a new carry-out rule, arranging different results based on the value of the "chosen table of commands," a variable that holds the name of the active table. For instance:

	*:
	The print the sidebar commands in the main window rule does nothing.	
	
	Carry out listing the sidebar commands (this is the brand new print the sidebar commands in the main window rule):
		if the chosen table of commands is the Table of Driving Commands:
			say "Driving Commands. Turn left. Turn right. Accelerate. Brake. Hint. Help. Quit.";
		otherwise if the chosen table of commands is the Table of Pedestrian Commands:
			say "Pedestrian Commands. Walk. Jog. Run. Hint. Help. Quit.".
		
Chapter: A Note to Extension Authors

If we've written an extension that creates a new action for the player, we can, in a section marked "(for use with Common Commands Sidebar by Alice Grove)," include the following table continuation:

	*: Table of Extension-Provided Sidebar Commands (continued)
	Displayed Command
	"New command goes here"
	
Using this table will make our extension compatible with other extensions adding their own sidebar commands, so that the story author can add commands from multiple extensions by swapping in just one table.

If we want to provide a complete list of commands that can replace the default commands (for instance, if we're translating Common Commands Sidebar into another language), we can write a new extension to be used in place of Common Commands Sidebar, or we can write a compatible extension that provides a new table with a unique name. The commands should be listed in a column entitled "Displayed Command (a text)". The story author can then swap in the new table if desired.

Extensions intended to be compatible with Common Commands Sidebar should not modify the Table of Default Sidebar Commands or the Table of Custom Sidebar Commands, as this would create obstacles for story authors who want to include only the original commands, or who want to create a custom list from scratch.




Example: * The Absolute Minimum - Including the sidebar with a minimum of code.

	*: "The Absolute Minimum"
	
	Include Common Commands Sidebar by Alice Grove.
	
	Minimal Room is a room.
	
	Test me with "sidebar / sidebar / sidebar off / sidebar on / commands".
	
	
	
	
Example: * Sidebar in Chocolate - A sidebar that makes use of presentation options and a custom command list.

	Here we have an automatically-shown sidebar with a brown background, italic off-white text, plus signs as dividers, and a custom list of commands.

	*: "Sidebar in Chocolate"
	
	Include Common Commands Sidebar by Alice Grove.
	
		
	Table of Custom Sidebar Commands (continued)
	Displayed Command (a text)
	"[bold type]Common Commands"
	" "
	"About"
	"Help"
	"Hint"
	"Again (G)"
	"Undo"
	"Save/Restore"
	"Quit (Q)"
	"?"
	"Look (L)"
	"Inventory (I)"
	"Take/Drop something"
	"Examine it (X it)"
	"Open/Close it"
	"Push/Pull it"
	"Put it in something"
	"Put it on something"
	"Wait (Z)"
	"?"
	"Give it to someone"
	"Show it to someone"
	"Ask someone about it"
	"Tell someone about it"
	
	The background color of the sidebar is "#542c03".
	The text color of the sidebar is "#faf0e6".
	The custom sidebar divider is "+ + +".
		
	When play begins:
		prepare the command sidebar, shown automatically, with italic type.
		
			
	Help Desk is a room. 
	
	A supporter called the desk is in Help Desk.
	
	Test me with "sidebar / sidebar / sidebar off / sidebar on / commands".
	
	
	
	
Example: * Lost in 'Lost Igpay' - A way to toggle the command sidebar from inside a full-screen menu using Emily Short's Menus extension.

	*: "Lost in 'Lost Igpay'"

	Include Menus by Emily Short.
	Include Common Commands Sidebar by Alice Grove.

	Asking for help is an action out of world.
	Understand "help" and "elphay" as asking for help.

	Carry out asking for help:
		now the current menu is the Table of Options;
		carry out the displaying activity;
		clear the screen;
		try looking.

	Table of Options
	title	subtable (table name)	description	toggle (a rule)
	"How to Play"	--	"[How_to_Play]"	--
	"Commands Sidebar (currently [if the sidebar is not flagged to appear later]hidden[otherwise]shown[end if])"	--	--	toggle sidebar from menu rule

	To say How_to_Play:
		say "Help Unkgray find the lost igpay! At the prompt ( > ), type short commands to tell him what to do.[paragraph break]To see a sidebar that lists the most common commands, toggle the COMMANDS SIDEBAR option on the top level of this menu. You can also type COMMANDS to list these commands in the main window.".
 
	This is the toggle sidebar from menu rule:
		if the sidebar is not flagged to appear later:
			now the sidebar is flagged to appear later;
		otherwise if the sidebar is flagged to appear later:
			now the sidebar is not flagged to appear later.
		
	When play begins:
	prepare the commands sidebar, shown manually;
	say "For two weeks you resisted the inevitable. But Gretchen's enthusiasm was unrelenting.[paragraph break]'All right,' you finally said. 'Show me this text adventure you've been telling me about.'[paragraph break]So here you are, scowling at some game called 'Lost Igpay.' And that's exactly what you are: lost. You've tried typing 'Start looking for the igpay' and 'Go find the igpay!' and 'Unkgray need find igpay now' and nothing seems to work.";
	wait for any key.
		
	At the Computer is a room. The description of At the Computer is "The screen is strewn with failures of communication."
	
	Gretchen is a woman in At the Computer. "Gretchen stands at your shoulder, clasping her hands in gleeful anticipation.[first time][paragraph break]'Don't worry!' she says. 'There's a helpful sidebar that shows all the common commands! Type HELP to go to the menu. You can turn on the sidebar from there!'[only]".
	
	Test me with "help".

