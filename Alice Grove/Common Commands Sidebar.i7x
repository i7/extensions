Version 2/161024 of Common Commands Sidebar (for Glulx only) by Alice Grove begins here.

"Displays a list of common parser commands in a sidebar as a reference for novice players. Includes actions to turn the sidebar off and on. Story author can tailor the command list and the appearance of the sidebar, or just plug and play. For version 6L or 6M of Inform 7."


Part - Required Extensions

Include version 15/161003 of Flexible Windows by Jon Ingold. [See documentation about where to find this version.]
Include Basic Screen Effects by Emily Short.


Part - Inform 6

[The glk version is used in determining whether the player is using Spatterlight:]

To decide what number is the glk version:
	(- glk_gestalt( gestalt_Version, 0 ) -).
	

[Story authors may create their own tables of commands, so we need to guard against a run-time error in case a required column is missing or mislabled:]

To decide whether the/-- column (C - table column) exists in (T - table name):
	(- (TableFindCol({T}, {C}) ~= 0) -).


Part - Glk Window Attributes

[Type, position, and the other values here are defined by the Flexible Windows extension.]

The sidebar is a g-window.
The type of the sidebar is usually g-text-buffer. [G-text-grid is also possible, but gives us less control over formatting.]
The main window spawns the sidebar.
The position of the sidebar is usually g-placeleft.
The scale method of the sidebar is g-fixed-size.
The measurement of the sidebar is usually 30.
The rock number of the sidebar is 225.  [For use in a CSS stylesheet.]
The background color of the sidebar is usually "#F0E2C7". [beige]


Part - Debug Settings

[In a non-release version of the story, debug messages can be turned on or off, but they are disabled in the release version.]

The sidebar can be either disabling debugging in the not-for-release version or enabling debugging in the not-for-release version. [The sequence here makes "enabling" the default.]

Chapter - Enabling Debugging - Not For Release

To decide if CCS debugging is on:
	if the sidebar is enabling debugging in the not-for-release version:
		decide yes;
	decide no.


Chapter - Disabling Debugging - For Release Only

To decide if CCS debugging is on:
	decide no.

Part - Showing and Hiding the Sidebar

Chapter - Showing the Sidebar

The sidebar has a number called minimum window width for opening. The minimum window width for opening of the sidebar is usually 50.

The sidebar has a number called minimum window height for opening. The minimum window height for opening of the sidebar is usually 15.

To decide if the main window is large enough to show the sidebar:
	if the width of the main window >= minimum window width for opening of the sidebar:
		if the height of the main window >= minimum window height for opening of the sidebar:
			decide yes;
	decide no.
	
This is the can't open the sidebar for unknown reason rule:
	say "The commands sidebar could not be opened. To list the commands in the main window instead, type COMMANDS." (A).
	
This is the can't open the sidebar when the main window is too small rule:
[Also catches Parchment, which seems to fail the minimum size tests no matter what]
	say "The commands sidebar could not be opened. Either your interpreter does not support this feature, or the window is not large enough to conveniently display the sidebar. To list the commands in the main window instead, type COMMANDS." (A).
	
To show the command sidebar window:
	if the sidebar is not finished setting the attributes:
		set the final sidebar attributes;
	if the main window is large enough to show the sidebar:
		open the sidebar;
		unless the sidebar is g-present:
			follow the can't open the sidebar for unknown reason rule;
	otherwise:
		follow the can't open the sidebar when the main window is too small rule.


Chapter - Introducing the Sidebar

The sidebar can be prompted automatically, shown automatically, or shown manually (this is the sidebar introduction method). The sidebar is prompted automatically.

[Keep track of whether we've introduced the sidebar so it doesn't get introduced again after the VERSION command:]

The sidebar can be introduced already. The sidebar is not introduced already.


[Intoduce the sidebar commands as a list if for some reason the sidebar can't be shown:]

This is the introduce the sidebar commands as a list rule:
	say  "[italic type]This story offers a list of commands you may find useful. You can see this list at any time by typing COMMANDS." (A);
	say "[roman type][line break]" (B);
	now the sidebar is introduced already.
	

After printing the banner text when (the sidebar is prompted automatically) and (the sidebar is not introduced already) (this is the ask the player whether to show the command sidebar rule):
	if the main window is large enough to show the sidebar:
		say "[line break][italic type]This story offers a sidebar that shows some useful commands. Would you like to see the sidebar? (Y/N)[roman type]>[run paragraph on]" (A);
		if player consents:
			show the command sidebar window;
			if sidebar is g-present:
				Say "[line break][italic type]The commands sidebar is now displayed[if the sidebar is allowing toggling]. You can turn the sidebar off and on by typing SIDEBAR OFF and SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (B);
				say "[roman type]" (C);
			[if it's not present, the show phrase will print a message]
		otherwise:
			say "[line break][italic type]The commands sidebar is currently hidden[if the sidebar is allowing toggling]. You can turn the sidebar on and off by typing SIDEBAR ON and SIDEBAR OFF[end if]. To list the commands in the main window, type COMMANDS." (D);
			say "[roman type]" (E);
		now the sidebar is introduced already;
	otherwise:
		follow the introduce the sidebar commands as a list rule.
	
After printing the banner text when (the sidebar is shown automatically) and (the sidebar is not introduced already) (this is the automatically show the command sidebar rule):
	if the main window is large enough to show the sidebar:
		show the command sidebar window;
		if the sidebar is g-present:
			say "[italic type]This story offers a sidebar that shows some useful commands[if the sidebar is allowing toggling]. You can turn the sidebar off and on by typing SIDEBAR OFF and SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (A);
			say "[roman type]" (B);
			now the sidebar is introduced already;
		[if it's not present, the show phrase will print a message]
	otherwise:
		follow the introduce the sidebar commands as a list rule.
	

Chapter - Temporarily Hiding the Sidebar When a Full-Screen Menu is Displayed

[To avoid conflicts, we temporarily hide the sidebar when we open a full-screen menu with Dannii Willis's Menus extension, Emily Short's Menus extension, or Wade Clarke's Menus extension.]


Section - Phrases for Temporarily Hiding the Sidebar

The sidebar can be flagged to appear later. The sidebar is not flagged to appear later.
		
To temporarily hide the sidebar if necessary:
	if the sidebar is g-present:
		now the sidebar is flagged to appear later;
		close the sidebar.
	
To show the hidden sidebar if necessary:
	If the sidebar is flagged to appear later:
		show the command sidebar window;
		now the sidebar is not flagged to appear later.


Section - Compatibility with Dannii Willis's Menus (for use with Menus by Dannii Willis)

Before displaying (This is the hide the sidebar before opening a menu with Dannii Willis's Menus rule):
	temporarily hide the sidebar if necessary.
	
After displaying (This is the show the hidden sidebar after closing a menu with Dannii Willis's Menus rule):
	show the hidden sidebar if necessary.


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
		
		
Chapter - Actions for Turning the Sidebar On and Off

The sidebar can be either allowing toggling or disallowing toggling. The sidebar is allowing toggling.


Turning on the commands sidebar is an action out of world.
Understand "sidebar on" as turning on the commands sidebar when the sidebar is allowing toggling.
Understand "sidebar" as turning on the commands sidebar when the sidebar is allowing toggling and the sidebar is g-unpresent.


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
Understand "sidebar" as turning off the commands sidebar when the sidebar is allowing toggling and the sidebar is g-present.

Carry out turning off the commands sidebar (this is the turn off the commands sidebar rule):
	if sidebar is g-present:
		close the sidebar;
		Say "The commands sidebar is now hidden[if the sidebar is allowing toggling]. To show it again, type SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (A);
	otherwise:
		say "The commands sidebar is already hidden[if the sidebar is allowing toggling]. To show it, type SIDEBAR ON[end if]. To list the commands in the main window, type COMMANDS." (B).
		
		
The sidebar has some text called the sidebar instructions. The sidebar instructions of the sidebar are usually "Use SIDEBAR ON and SIDEBAR OFF to turn the sidebar on and off, or SIDEBAR to toggle it. To list the commands in the main window, type COMMANDS.".
Understand "sidebar [text]" as a mistake ("[SIDEBAR instructions of the sidebar]") when the sidebar is allowing toggling.


Part - Sidebar Text

Chapter - Text Appearance

The sidebar has a text called the text color. The text color of the sidebar is usually "#363025". [dark brown]


[The relative text size is set to 0 to reduce disparity between the results in Gargoyle and other interpreters. Otherwise a bold title may barely fit into the width of the sidebar in WinGluxe, while it looks relatively small in Gargoyle.]

Table of User Styles (continued)
window (a g-window)	relative size
sidebar	0


[The "set the sidebar text color rule" rule is invoked in the "Phrases to Prepare the Commands Sidebar" section.]

This is the set the sidebar text color rule:
	if there is a window of sidebar in the Table of User Styles: [should always be the case; a safeguard against run-time errors]
		now the color corresponding to a window of sidebar in the Table of User Styles is the text color of the sidebar.


The sidebar has some text called the indent. The indent of the sidebar is usually "  ".

The sidebar has some text called the lettering style. The lettering style of the sidebar is usually "[roman type]". 

The sidebar can be space-divided, star-divided, undivided, or custom-divided (this is the sidebar divider type property). The sidebar is space-divided.

The sidebar has some text called the custom divider. The custom divider of the sidebar is usually "".


Chapter - Command Tables

Table of Default Sidebar Commands
Displayed Command (a text)	Listed Command (a text)	Command Label (a command-label)	Command Visibility (a command-visibility)
"[bold type]Useful Commands"	--	--	--
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
with 30 blank rows


Table of Custom Sidebar Commands
Displayed Command (a text)	Listed Command (a text)	Command Label (a command-label)	Command Visibility (a command-visibility)
--	--	--	--


Table of Extension-Provided Sidebar Commands
Displayed Command (a text)	Listed Command (a text)	Command Label (a command-label)	Command Visibility (a command-visibility)
"?"	--	--	--


Chapter - Choosing a Table of Commands

The sidebar has a table name called the chosen table. The chosen table of the sidebar is usually the Table of Default Sidebar Commands.

The sidebar can be finished choosing a command table.

When play begins (this is the choose the appropriate table of commands at the start of play rule):
	if the sidebar is not finished choosing a command table: [i.e. if the story author has not already swapped in a table]
		if the Table of Custom Sidebar Commands is not empty:
			now the chosen table of the sidebar is the Table of Custom Sidebar Commands;
		otherwise if the Table of Custom Sidebar Commands is empty:
			now the chosen table of the sidebar is the Table of Default Sidebar Commands;
		now the sidebar is finished choosing a command table.


[A phrase for the use of story authors when they want to swap tables.]
		
To swap (T - a table name) into the/-- sidebar:
	now the chosen table of the sidebar is T;
	if the sidebar is g-present:
		refresh the sidebar;
	now the sidebar is finished choosing a command table.
		
		
Chapter - Showing and Hiding Individual Commands

 To decide if (given table - a table name) has the necessary columns for hidden commands:
	if the column Command Visibility exists in the given table:
		if the column Command Label exists in the given table:
			if the column Displayed Command exists in the given table:
				decide yes;
			otherwise if CCS debugging is on:
				say "CCS Debug Message # 10: The [Given Table] does not have a Displayed Command column.";
		otherwise if CCS debugging is on:
			say "CCS Debug Message #12: The [Given Table] does not have a Command Label column.";
	otherwise if CCS debugging is on:
		say "CCS Debug Message #14: The [Given Table] does not have a Command Visibility column.";
	decide no.
 
 

 The sidebar can be either using phrases to control command visibility or not using phrases to control command visibility. [This sequence makes "not using" the default.]
 
 command-visibility is a kind of value. The command-visibilities are c-shown, c-blank, c-hidden, and c-table-error.
 
  A command-label is a kind of object.
	
To decide which command-visibility is the/-- command-visibility of (specified command - a command-label) in (given table - a table name):
	if the sidebar is using phrases to control command visibility:
		if the given table has the necessary columns for hidden commands:
			if the specified command is a Command Label listed in the given table: 
				if there is a Command Visibility entry:
					decide on the Command Visibility entry;
				otherwise:
					decide on c-shown; [the default]
			otherwise if CCS Debugging is on:
				say "CCS Debug Message #20: Tried to determine the command-visibility of [specified command] in the [Given Table], but [specified command] was not found in the Command Label column.";
				decide on c-table-error;
		otherwise if CCS Debugging is on:
			say "CCS Debug Message #22: Tried to determine the command visibility of [specified command] in the [Given Table], but the [Given Table] was missing a necessary column.";
			decide on c-table-error;
	decide on c-shown.
		
	
To decide which command-visibility is the/-- command-visibility of (the specified command - a command-label):
	decide on the command-visibility of the specified command in the chosen table of the sidebar.

To mark the/-- (designated command - a command-label) command/commands as (specified visibility - a command-visibility) in (given table - a table name):
	if the sidebar is using phrases to control command visibility:
		if the given table has the necessary columns for hidden commands:
			if the designated command is a Command Label listed in the given table:
				repeat through the given table: [to show all of them; there may be more than one]
					if (there is a Command Label entry) and (the Command Label entry is the designated command):
						now the Command Visibility entry is the specified visibility;
			otherwise if CCS debugging is on:
				say "CCS Debug Message #30: Tried to mark the [designated command] command(s) as [specified visibility] in the [Given Table], but [designated command] was not found in the Command Label column.";
		otherwise if CCS debugging is on:
			say "CCS Debug Message #32: Tried to mark the [designated command] command(s) as [specified visibility] in the [Given Table], but the [Given Table] was missing a necessary column.".
			
To show the/-- (C - a command-label) command/commands in (given table - a table name):
	mark the C command as c-shown in the given table.
	
To show the/-- (C - a command-label) command/commands:
	show the C command in the chosen table of the sidebar.	

To hide the/-- (C - a command-label) command/commands in (given table - a table name):
	mark the C command as c-hidden in the given table.
	
To hide the/-- (C - a command-label) command/commands:
	hide the C command in the chosen table of the sidebar.
	
To blank the/-- (C - a command-label) command/commands in (given table - a table name):
	mark the C command as c-blank in the given table.
	
To blank the/-- (C - a command-label) command/commands:
	blank the C command in the chosen table of the sidebar.	


	
Chapter - Printing the Text in the Sidebar
		
To decide if (current entry - a text) designates a/-- divider in the sidebar:
	if the current entry is "?":
		decide yes;
	decide no.
	
To decide if (current entry - a text) designates an/-- empty space in the sidebar:
	if the current entry is " ":
		decide yes;
	decide no.
	
To decide if (current entry - a text) designates an/-- ignorable entry in the sidebar:
	if the current entry is "":
		decide yes;
	decide no.

To decide if (current entry - a text) designates an/-- actual command in the sidebar:
	unless (the current entry designates a divider in the sidebar) or
		   (the current entry designates an empty space in the sidebar) or
	           (the current entry designates an ignorable entry in the sidebar):
		decide yes;
	decide no.
	
To decide if row (N - a number) of (given table - a table name) is effectively marked hidden or marked blank:
	unless the sidebar is using phrases to control command visibility:
		decide no;
	if the column Command Visibility exists in the given table:
		if there is a Command Visibility in row N of the given table:
			if (the Command Visibility in row N of the given table is c-hidden) or
			   (the Command Visibility in row N of the given table is c-blank):
				decide yes;
	decide no.
	
To indent the/-- upcoming sidebar entry:
	say fixed letter spacing;
	say the indent of the sidebar;
	say lettering style of the sidebar.

To print the/-- command (current command - a text) in the sidebar:
	say line break; [prints blank line before the first line of text as well]
	indent the upcoming sidebar entry;
	say current command.

To print an/-- appropriate sidebar divider:
	if the sidebar is space-divided:
		say line break;
	otherwise if the sidebar is undivided:
		do nothing;
	otherwise:
		say paragraph break;
		indent the upcoming sidebar entry;
		if the sidebar is star-divided:
			say "* * *";
		otherwise if the sidebar is custom-divided:
			say custom divider of the sidebar;
		say line break. [leave a blank line below divider symbols]


populating the sidebar using something is an activity on table names.

Rule for populating the sidebar using a table name (called the current table) (this is the print commands in the sidebar from a single table rule): 
	if the column Displayed Command exists in the current table:
		repeat with N running from 1 to the number of rows in the current table:
			choose row N in the current table;
			if there is a Displayed Command entry:
				unless row N of the current table is effectively marked hidden or marked blank:
					if the Displayed Command entry designates an actual command in the sidebar:
						print the command Displayed Command Entry in the sidebar;
					otherwise if the Displayed Command entry designates a divider in the sidebar:
						print an appropriate sidebar divider;
					otherwise if the Displayed Command entry designates an empty space in the sidebar:
						say line break;
					otherwise: [if the Displayed Command entry designates an ignorable entry in the sidebar]
						next;
				otherwise if the Command Visibility entry is c-hidden:
					next;
				otherwise if the Command Visibility entry is c-blank:
					say line break.

					
The sidebar can be including extension-provided commands.			

[Print commands from the author's chosen table and, if applicable, commands provided by other extension authors:]

Rule for refreshing the sidebar (This is the print commands in the sidebar from the relevant tables rule):
	carry out the Populating The Sidebar Using activity with the chosen table of the sidebar;
	if the sidebar is including extension-provided commands:
		carry out the Populating The Sidebar Using activity with the Table of Extension-Provided Sidebar Commands.
		
		
Chapter - Action for Listing the Sidebar Commands in the Main Window

[Listing the sidebar commands in the main window serves as an alternative to the sidebar when players use screenreaders or interpreters that don't support extra windows. The commands are converted into list form. Under certain conditions, the default compass rose, if present, is automatically converted into words.]

To decide if a Listed Command has been provided in row (N - a number) of (given table - a table name):	
	unless (the column Listed Command exists in the given table) and (there is a Listed Command in row N of the given table):
		decide no;
	decide yes.

The sidebar has a list of texts called default compass rose entries.
The default compass rose entries of the sidebar are  {"     N",
											"  NW   NE",
											"W    *    E", 
											"  SW   SE", 
											"     S"
											}.

	
To decide if (given table - a table name) uses the default compass rose:
	unless the sidebar is using phrases to control command visibility:
		if the column Displayed Command exists in the given table:
			repeat with compass-entry running through the default compass rose entries of the sidebar:
				if the compass-entry is a Displayed Command listed in the given table:
					unless ((the column Listed Command exists in the given table) and (there is a Listed Command entry)):
						next;
					[if there's a corresponding Listed Command entry, don't try to automatically translate the compass rose into words:]
					otherwise: 
						decide no;
				otherwise:
					decide no;
			decide yes;
		otherwise: 
			decide no;
	[if the sidebar is using phrases to control command visibility, don't try to automatically translate the compass rose into words:]
	otherwise:
		decide no.
		
		
To decide if (given entry - a text) counts as a compass rose entry when the compass rose's presence is (relevant truth state - a truth state):
	if the relevant truth state is false:
		decide no;
	otherwise if the given entry is listed in the default compass rose entries of the sidebar:
		decide yes;
	decide no.
		

printing a list of commands from something is an activity on table names.	

Rule for printing a list of commands from a table name (called the current table) (this is the list commands in the main window from a single table rule):
	if the column Displayed Command exists in the current table:
		let compass_rose_present be whether or not the current table uses the default compass rose;
		let compass_rose_already_listed be false;
		repeat with N running from 1 to the number of rows in the current table:
			choose row N in the current table;
			if there is a Displayed Command entry:
				unless row N of the current table is effectively marked hidden or marked blank:
					unless a Listed Command has been provided in row N of the current table:
						unless the Displayed Command entry counts as a compass rose entry when the compass rose's presence is compass_rose_present:
							if the Displayed Command entry designates an actual command in the sidebar:
								say "[lettering style of the sidebar][Displayed Command entry]. " (A);
							otherwise: [if it designates a divider, empty space, or ignorable entry]
								next;
						otherwise: [if we're treating the Displayed Command as a compass rose entry]
							if compass_rose_already_listed is false:
								say "[lettering style of the sidebar]North (N). South (S). East (E). West (W). Northeast (NE). Southeast (SE). Northwest (NW). Southwest (SW). " (B);
								now compass_rose_already_listed is true;
							otherwise: [if compass_rose_already_listed is true]
								next;
					otherwise: [if a Listed Command has been provided]
						say "[lettering style of the sidebar][Listed Command entry]. " (C).


Listing the sidebar commands in the main window is an action out of world.
Understand "commands" as listing the sidebar commands in the main window.

The sidebar has some text called the COMMANDS instructions. The COMMANDS instructions of the sidebar are usually "To list useful commands in the main window, type just COMMANDS[if the sidebar is allowing toggling].  Use SIDEBAR ON and SIDEBAR OFF to turn the sidebar on and off, or SIDEBAR to toggle it[end if].".
Understand "commands [text]" as a mistake ("[COMMANDS instructions of the sidebar]").

Check listing the sidebar commands in the main window when the sidebar is not finished choosing a command table (this is the select the appropriate table of commands before listing the commands in the main window rule):
	follow the choose the appropriate table of commands at the start of play rule.
	
The sidebar has a text called the custom command list. The custom command list of the sidebar is usually "".

Carry out listing the sidebar commands in the main window (this is the list commands in the main window from the relevant tables rule):
	if the custom command list of the sidebar is "":
		carry out the Printing A List Of Commands From activity with the chosen table of the sidebar;
		if the sidebar is including extension-provided commands:
			say run paragraph on; [to avoid extra break between command tables]
			carry out the Printing A List Of Commands From activity with the Table of Extension-Provided Sidebar Commands;
	otherwise:
		say the custom command list of the sidebar.
				
			
Part - Adjusting the Status Line

[Under most circumstances, the status line text is centered when the sidebar is shown. This is done to avoid inconsistent alignment between the status line text (which appears at the left edge) and the sidebar text (which is slightly indented), and to prevent the status line text from looking like part of the sidebar text when the status bar and sidebar are the same color.]

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



Part - Information for Players

Chapter - Spatterlight Warning

[Flexible Windows and Spatterlight are, as far as I can tell, incompatible. If Spatterlight is detected, the player is warned to use another interpreter:]

When play begins (this is the detect whether we're using Spatterlight rule):	
	if the glk version is 1792:
		unless Glulx character input is supported:
			if Glulx mouse input is supported:
				unless Glulx hyperlinks are supported:
				[Spatterlight characteristics not shared by Zoom and Mac IDE end here; the rest is merely to minimize false positives]
					if Glulx timekeeping is supported:
						unless Glulx sound notification is supported:
							if Glulx graphic-window mouse input is supported:
								say "[bold type]Warning:[roman type] This story is not compatible with the Spatterlight interpreter. If you are using Spatterlight, please switch to a different interpreter to avoid crashing." (A);
								wait for any key.


Chapter - Suggesting the Sidebar after a Blank Command

The sidebar can be suggested following blank commands.

Rule for printing a parser error when ((the latest parser error is the I beg your pardon error) and (the sidebar is suggested following blank commands) and (the sidebar is g-unpresent)) (this is the suggest the sidebar when the player enters a blank command rule):
	say "If you're not sure what to do, type [if (the sidebar is allowing toggling) and (the main window is large enough to show the sidebar)]SIDEBAR ON[otherwise]COMMANDS[end if] to see some commands you can try." (A) instead.
	
	
Chapter - Attribution

[The Creative Commons license of the play IF postcard requires that it be attributed. Please do not remove.]

Report requesting the story file version (this is the attribute the play IF postcard rule):
	say "'How To Play Interactive Fiction: An entire strategy guide on a single postcard,' written by Andrew Plotkin and designed by Lea Albaugh, was the inspiration for the Common Commands Sidebar extension. The postcard, available at <http://pr-if.org/doc/play-if-card/>, is licensed under a CC BY SA 3.0 United States licen[if the American dialect option is active]s[otherwise]c[end if]e, available at <http://creativecommons.org/licenses/by-sa/3.0/us/>.  Content was adapted with permission. Please see the extension documentation for details." (A).


Part - Setting the Built-in Options

Chapter - Sidebar Preparation Bugs

[If the "prepare the command sidebar" phrase appears more than once in the source, the earlier settings are reset to their defaults before the later settings take effect, so we don't get a mix of old and new settings:]

The sidebar can be either prepared already or not prepared already. The sidebar is not prepared already.

To reset the sidebar settings: 
	now the sidebar is prompted automatically ;
	now the position of the sidebar is g-placeleft;
	now the lettering style of the sidebar is "[roman type]";
	now the sidebar is space-divided;
	now the sidebar is not suggested following blank commands;
	now the sidebar is allowing toggling;
	now the sidebar is auto-adjusting the status bar.	


[Debug messages will warn us if we've invoked "prepare the commands sidebar"  more than once, or if we've chosen mutually exclusive options in a single "prepare the commands sidebar" line. The story will compile regardless.]

The sidebar has a number called the intro setting count.
The sidebar has a number called the position setting count.
The sidebar has a number called the lettering setting count.
The sidebar has a number called the divider setting count.

To reset the sidebar setting counters:
	now the intro setting count of the sidebar is 0;
	now the position setting count of the sidebar is 0;
	now the lettering setting count of the sidebar is 0;
	now the divider setting count of the sidebar is 0.
	
	
To mention sidebar preparation bugs:
	if the sidebar is prepared already:
		say "CCS Debug Message #40: 'Prepare the command sidebar' has been invoked more than once in the code. This may result in unexpected sidebar settings, since later invocations will override earlier ones.[line break]";
	if the intro setting count of the sidebar > 1:
		say "CCS Debug Message #42: The sidebar introduction method (available choices are 'prompted automatically,' 'shown automatically,' and 'shown manually') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one of these options can take effect.[line break]";
	if the position setting count of the sidebar > 1:
		say "CCS Debug Message #44: The sidebar position (available choices are 'on the left' and 'on the right') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one of these options can take effect.[line break]";
	if the lettering setting count of the sidebar > 1:
		say "CCS Debug Message #46: The text style setting for the sidebar (available choices are 'with roman type,' 'with fixed letter spacing,' 'with italic type,' and 'with bold type') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one text style option can take effect.[line break]";
	if the divider setting count of the sidebar > 1:
		say "CCS Debug Message #48: The divider setting for the sidebar (built-in choices are 'divided with space,' 'divided with stars,' and 'not divided') has been set multiple times in one 'Prepare the command sidebar' line. This may have unexpected results, since only one divider option can take effect.[line break]";
	if (the divider setting count of the sidebar > 0) and (custom divider of the sidebar is not ""):
		say "CCS Debug Message #50: The divider setting for the sidebar (available built-in choices are 'divided with space,' 'divided with stars,' and 'not divided') has been set in a 'Prepare the command sidebar' line, but a 'custom sidebar divider' has also been specified elsewhere. This may have unexpected results, since only one divider option can take effect.[line break]".
		
		
Chapter - Phrases to Prepare the Commands Sidebar

[The "To prepare..." phrase is provided solely for the conveniece of story authors, allowing them to set most of the sidebar options in a single line instead of setting the variables one by one.]

To prepare the/-- command/commands sidebar, prompted automatically, shown automatically, shown manually, on the left, on the right, with roman type, with fixed letter spacing, with italic type, with bold type, divided with space, divided with stars, not divided, including extension commands, suggested after blank commands, with toggling disabled, and/or without changing the status line:
	[Resets:]
	if the sidebar is prepared already:
		reset the sidebar settings;
		reset the sidebar setting counters;
	[Introduction methods:]
	if prompted automatically:
		now the sidebar is prompted automatically;
		increment the intro setting count of the sidebar;
	if shown automatically:
		now the sidebar is shown automatically;
		increment the intro setting count of the sidebar;
	if shown manually:
		now the sidebar is shown manually;
		increment the intro setting count of the sidebar;
	[Positions:]
	if on the left:
		now the position of the sidebar is g-placeleft;
		increment the position setting count of the sidebar;
	if on the right:
		now the position of the sidebar is g-placeright;	
		increment the position setting count of the sidebar;
	[Lettering styles:]
	if with roman type:
		now lettering style of the sidebar is "[roman type]";
		increment the lettering setting count of the sidebar;
	if with fixed letter spacing:
		now the lettering style of the sidebar is "[fixed letter spacing]";
		increment the lettering setting count of the sidebar;
	if with italic type:
		now the lettering style of the sidebar is "[italic type]";
		increment the lettering setting count of the sidebar;
	if with bold type:
		now the lettering style of the sidebar is "[bold type]";
		increment the lettering setting count of the sidebar;
	[Dividers:]
	if divided with space:
		now the sidebar is space-divided;
		increment the divider setting count of the sidebar;
	if divided with stars:
		now the sidebar is star-divided;
		increment the divider setting count of the sidebar;
	if not divided:
		now the sidebar is undivided;
		increment the divider setting count of the sidebar;
	[Extension commands:]
	if including extension commands:
		now the sidebar is including extension-provided commands;
	[Suggestion:]
	if suggested after blank commands:
		now the sidebar is suggested following blank commands;
	[Toggling:]
	if with toggling disabled:
		now the sidebar is disallowing toggling;
	[Status bar:]
	if without changing the status line:
		now the sidebar is leaving the status bar alone;
	if CCS debugging is on:
		mention sidebar preparation bugs;
	now the sidebar is prepared already.
		

[A few attributes depend on values set previously by the story author. These attributes are set just before opening the sidebar for the first time, to make sure the story author's relevant code runs first:]

The sidebar can be finished setting the attributes. The sidebar is not finished setting the attributes.

To set the/-- final sidebar attributes:
	follow the set the sidebar text color rule; [This rule is in the "Text Appearance" section.]
	if the custom divider of the sidebar is not "":
		now the sidebar is custom-divided;
	now the sidebar is finished setting the attributes.


Common Commands Sidebar ends here.


---- DOCUMENTATION ---- 

Chapter: Acknowledgements

Thanks to Joseph Geipel, Andrew Schultz, and Nick Turner for testing, to Björn Paulsen for code feedback, and to Björn Paulsen, Daniel Stelzer, Dannii Willis, Erik Temple, Hanon Ondricek, Joseph Geipel, Juhana, Matt Weiner, Peter Piers, and zarf for responding to my questions.

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

	Version 15/161003 of Flexible Windows (for Glulx only) by Jon Ingold
	
	http://raw.githubusercontent.com/i7/extensions/master/Jon%20Ingold/Flexible%20Windows.i7x

which in turn requires various other extensions that can be found at https://github.com/i7/extensions. See Flexible Windows for the version numbers required.
	
(Basic Screen Effects is also required, but any relatively recent version will do.)

Note that Flexible Windows uses the container relation for windows, so we'll need to be cautious about iterating through all containers. Also note that Spatterlight is liable to crash when Flexible Windows is used. If Common Commands Sidebar detects Spatterlight, the player will be warned to switch interpreters.


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

"Prompted automatically," the default setting, prompts the player to choose whether or not to show the sidebar. "Shown automatically" displays the sidebar without giving the player a choice. "Shown manually" keeps the sidebar hidden until it is shown manually (for instance, if the player types SIDEBAR ON).

The "prompted automatically" and "shown automatically" options include a brief explanation of the sidebar. But if we choose "shown manually," it will be up to us to inform the player that the sidebar is available. We may want to give instructions in our help text for turning the sidebar on and off (SIDEBAR ON and SIDEBAR OFF), and for listing the commands in the main window (COMMANDS) if a player's interpreter or screenreader doesn't support the sidebar. See also the section on toggling the sidebar from a menu.
	
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

To add, at the bottom of the sidebar, any additional commands that have been provided by compatible extensions (this option is off by default):

	with extension commands
	
For example, a swimming extension might add a "Swim" command, and an invisibility extension might add a "Turn invisible" command. If the extension authors have made their extensions compatible with Common Commands Sidebar, and if we've included both these extensions in our source after Common Commands Sidebar,  the "with extension commands" option will add the commands "Swim" and "Turn invisible" to the end of the sidebar, after a divider. (If we want to fine-tune the sequence of commands, we should skip this option and arrange them by hand instead. See the "cut and paste method" in the chapter on changing the text in the sidebar.)

To suggest to players who enter a blank command, and who do not have the sidebar visible, that they type SIDEBAR ON or COMMANDS to see some commands to try (this suggestion is disabled by default):

	suggested after blank commands

To prevent the typed commands SIDEBAR ON, SIDEBAR OFF, and SIDEBAR (which normally turn the sidebar on and off) from being understood:
	
	with toggling disabled
	
To leave the status line untouched, instead of automatically adjusting it when the sidebar is visible:

	without changing the status line
	
This extension assumes we are using Inform's default status line, with the player's surroundings on the left and (if we are using scoring) the score and turn count on the right. To avoid inconsistent text alignment between the status line and the sidebar, and to avoid ambiguity (especially if the sidebar and status line are similar in color), this extension by default centers the standard status text whenever it would otherwise appear directly above the sidebar. If we have a custom status bar, we'll likely want to disable or adjust this behavior.


Section: Debugging

A built-in debugging feature will warn us if 'prepare the command sidebar' is invoked more than once in the code (in which case a later invocation will override an earlier one) or if mutually exclusive sidebar options have been chosen (in which case only one of the options will take effect). The debugging messages are disabled in the release version of the story. We can also turn off debugging in the not-for-release version by including

	The sidebar is disabling debugging in the not-for-release version.
	
in our code.
	

Section: Colors, Margin, and Measurements

To change the sidebar colors from the default brown text on a beige background, we can use hex color codes (the 6-digit variety). A web search for "hex color codes" will bring up helpful sites that give the codes. For a black background with white text, we could say
	
	*:
	The background color of the sidebar is "#000000".
	The text color of the sidebar is "#ffffff".

Since not all interpreters support indentation, the left margin of the sidebar is created by printing fixed-width blank spaces at the beginning of each line. We can override this default indentation with our own, putting the desired number of spaces between the quotation marks:

	*: The indent of the sidebar is "   ".


To set the sidebar width (in characters, not pixels), we could say
	
	*: The measurement of the sidebar is 28.	
	
The units used to measure text windows vary in size from one interpreter to another--width in characters is an approximation. We'll want to check the results in interpreters that are used by players, because the sidebar may look very different in the Inform IDE.
 
 
 To set the minimum size that we want the main window to be (in approximate characters, rather than pixels) in order to allow the sidebar to be displayed, we can say, for instance,

	*:
	The minimum window width for opening of the sidebar is 60.
	The minimum window height for opening of the sidebar is 20.

If, at the start of play, the main window does not meet these minimums, and if the sidebar is set to be shown automatically or to show an opening prompt, the player will instead see an opening message about how to list the commands in the main window.


Section: Colors, etc. in Quixe

The Quixe interpreter will not automatically display the colors we have set in the source. To customize the colors, presence/absence of scroll bars, and various other elements as they appear in the Quixe interpreter, we can "Release along with an interpreter" (see "25.11. A playable web page" in the Inform manual) and modify the glkote.css file found in the interpreter folder. Glkote.css is automatically generated on each release, so we'll want to keep a copy of the modified file where it won't be overwritten. (There's a bit about this in "25.13. Website templates" in the Inform manual.)

The glkote.css file is written in a language called CSS. In glkote.css we should use ".WindowRock_225" to identify the sidebar.

An example: to set the sidebar's background color ("background") to light blue and its text color ("color") to dark blue using hex color codes, we could add the following to the CSS file. (Despite how the spacing may appear in this documentation, there should be no space between the period and the W.)

	.WindowRock_225 {
	  background: #BAF7F4;
	  color: #070833;
	}

More information about CSS is available with a web search. There are also some explanatory comments in the glkote.css file, available in the interpreter folder, as mentioned, or at <http://github.com/erkyrath/quixe/blob/master/media/i7-glkote.css>. Further information can be found at <http://eblong.com/zarf/glk/glkote/docs.html#css>.

  
Chapter: Using Different Commands in the Sidebar

If we don't want to use the default set of commands in the sidebar, there are several ways we can go about adjusting the commands. We can paste in and edit a provided template with the "Cut and Paste" method, or alter the default table using code with the "Add or Remove Rows in the Default Table" method, or swap entire sets of commands in and out during play with the "Swap in a Different Table" method.

Note that when we tailor the commands in the sidebar, we are also affecting the list printed by the "listing the sidebar commands in the main window" action. After we've made changes to the sidebar commands, we should type COMMANDS to see how they look in list form. See also "Adjusting the Commands Listed in the Main Window."


Section: The "Cut and Paste" Method

The "Cut and Paste" method of tailoring the sidebar commands gives the most control for the least effort. If we paste one of the templates below into our code to continue the (initially blank) Table of Custom Sidebar Commands, we can edit, cut, and paste rows to arrange the commands exactly how we want them. What you see is basically what you get. If we continue the Table of Custom Sidebar Commands in our code, our custom table will automatically be substituted for the default table in the sidebar (unless we specify otherwise).

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

If we'd rather write traditional code than paste in a template, we can use code to add or remove rows in the Table of Default Sidebar Commands, which is found in the extension source. Or we could continue this table to add new commands at the end, perhaps starting with a divider ("?") if we want to separate the new commands from the default meta commands:

	*:	
	Table of Default Sidebar Commands (continued)
	Displayed Command
	"?"
	"New Command 1"
	"New Command 2"
	
For more information, see "16.9. Blank rows," "16.10: Adding and removing rows," and  "16.18: Table continuations" in the Inform manual.


Section: The "Swap in a Different Table" Method

Still another approach to adjusting the commands in the sidebar is to designate a specific table (an additional table we have created, or one from an extension) as the table from which the sidebar commands should be drawn. To do this we use the phrase "swap Table Name into the/-- sidebar": 

	*:
	When play begins:
		swap the Table of Aquatic Commands into the sidebar.

We can swap in any table so long as it includes a column with the following heading:
		
	*:
	Displayed Command (a text)
	
If we don't include this column, the commands will not show up in the sidebar.
	
The "swap Table Name into the/-- sidebar" phrase can also be used to switch from one set of commands to another mid-story.

	
Chapter: Adjusting the Commands Listed in the Main Window

When the player types COMMANDS, the "listing the sidebar commands in the main window" action prints the sidebar commands in the main window. This feature is intended for players using screenreader software, or devices with small screens, or interpreters that won't display the sidebar (e.g. Parchment).

 The list is automatically generated from our table of commands, so we'll probably want to check that the results look reasonable, especially if we've changed the sidebar text or if we're controlling command visibility with phrases.

If we want to adjust the results, and if the commands will not change during play, we can create our own list as a string called the "custom command list of the sidebar", for instance

	*:
	The custom command list of the sidebar is "Useful Commands. North (N). South (S). East (E). West (W). Talk to someone. Help. Quit (Q)."
	
Our custom list will automatically be used instead of the auto-generated list.

If we instead want to modify listed commands individually (for instance, if we're using phrases to show or hide commands during play, and so the list needs to change during play), we can use the column "Listed Command" in our command table to show how we want each command to appear in the list. When the commands are printed as a list in the main window, the Listed Command entry, if present, will automatically be printed instead of the Displayed Command entry. Each entry will be followed by a period when it's printed in the list, but if we need additional periods within an entry, we'll need to include those ourselves, as in the "West (W). East (E)" entry below.

	Displayed Command	Listed Command
	" N"	"North (N)"
	"W E"	"West (W). East (E)"
	" S"	"South (S)"
	"In (I)/Out (O)"	--

The commands in the above table will look like ths in listed form:

North (N). West (W). East (E). South (S). In (I)/Out (O).


Chapter: Showing and Hiding Individual Commands During Play

If we want to hide or show individual commands during play, we can use conditions or phrases. Either way, we'll want to make sure to update the sidebar.


Section: Updating the Sidebar During Play

If the contents of the sidebar change during play, we can use the phrase "refresh the sidebar" inside a rule to keep the sidebar up to date, for instance:
	
	*:
	Every turn:
		refresh the sidebar.
		
Note that if we refresh often, we'll want to be extra careful about whether our sidebar commands fit into the height of the window.  If the list of commands is too long to fit in the window, an interpreter may show a "More" message at the bottom of the sidebar and require the player to press a key before continuing. This will happen every time the sidebar refreshes. To avoid making the player press an extra key every turn, we'll want to make sure our list of commands isn't overlong, and set the minimum window height to an adequate number. (See the "measurements" section.)


Section: Showing and Hiding Using Conditions

We can include conditions in the text of the displayed command entries to specify when to show them.
	
For example:
	
	Displayed Command (a text)
	"[if the player wears the duck costume]Quack[end if]"
	
If we do this in such a way that the entry evaluates to "" when the command is hidden, subsequent commands in the sidebar will move up to close the gap.

But if we want a blank line in the sidebar where the absent command belongs, we should instead arrange for the entry to evaluate to " ". (That's a single space. Using more than one space may lead to extra punctuation in the "listing the sidebar commands" action.)

For example:
	
	Displayed Command (a text)
	"[if the player wears the duck costume]Quack[end if] "
	
		
For more complicated conditions, we can make the table more readable by putting the conditions in "to decide" phrases outside of the table:

	To decide if quack is displayed:
		if the player wears the duck costume, decide yes;
		if the player is a duck, decide yes;
		decide no.
		
	Displayed Command (a text)
	"[if quack is displayed]Quack[end if]"
	
For more on "to decide" phrases, see "11.16. New conditions, new adjectives" in the Inform 7 manual.


Section: Showing and Hiding Using Phrases

If we want to use phrases to show or hide commands, we need to opt in by including the following line in our code:

	*:
	The sidebar is using phrases to control command visibility.

We also need to declare a "command-label" for each command or group of commands that we want to show or hide during play. For instance:

	turn_invisible is a command-label.
	compass_direction is a command-label.
	
In our table of commands, we include the columns "Command Label" and "Command Visibility":

	*:
	Displayed Command (a text)	Command Label (a command-label)	Command Visibility (a command-visibility)

In the "Command Label" column, we enter the command-label we want to use for the command in that row. If we have multiple commands that we want to treat as a single unit for showing and hiding purposes, we can list the same command-label in all the relevant rows.

In the Command Visibility column, we can enter one of these options in each row:

	c-shown
	c-blank
	c-hidden

"C-shown" means the relevant command entry is displayed normally. "C-blank" means the relevant command entry is not visible, but a blank line appears in the sidebar where the command belongs. "C-hidden" means the relevant command entry is not visible, and subsequent commands in the sidebar are moved up to close the gap.

Strictly speaking, we need only specify "c-blank" and "c-hidden," because any entries missing from the Command Visibility column will be treated as "c-shown".

An example:

	*:
	Displayed Command (a text)	Command Label (a command-label)	Command Visibility (a command-visibility)
	"North (N)"	compass_direction	c-blank
	"South (S)"	compass_direction	c-blank
	"East (E)"	compass_direction	c-blank
	"West (W)"	compass_direction	c-blank
	"Quack"	quack	c-hidden
	"Turn invisible"	turn_invisible	c-shown
	
	

To show, hide, or blank (that is, leave a blank space for the command in the sidebar) commands during play, we can use the following phrases, where X is the command-label:

	*:
	show the/--  X command/commands in Table Name
	show the/--  X command/commands
	hide the/-- X command/commands in Table Name
	hide the/-- X command/commands
	blank the/-- X command/commands in Table Name
	blank the/-- X command/commands
	
The above phrases will show, hide, or blank all instances of X in the given table.  The choices "command" and "commands" are provided only so that the code can read naturally regardless of whether the command-label applies to one command, or several.
		
If we don't mention the table name, the extension will look for X in whichever table is currently designated as the source of sidebar commands. (That table name is held in the property "chosen table of the sidebar").

If we are trying to show, hide, or blank a command, and the command-label is not found in the table, the attempt will either generate a debug message (if debugging is on) or be ignored (if debugging is off).

Some examples:
	
	After wearing the duck costume:
		show the quack command in the Table of Special Commands;
		continue the action.
		
	After taking the ancient compass:
		show the compass_direction commands;
		continue the action.

To find the Command Visibility entry for for a given command label, we can use the following phrases, where C is the command-label:

	the/-- command-visibility of C in Table Name
	the/-- command-visibility of C
	
These will check only the first instance of C in the table. And if we don't mention a table name, the extension will assume we mean the "chosen table of the sidebar." 

If there a Command Visibility column but no Command Visibility entry in the given row, the command is treated as shown, and so these phrases will return the value "c-shown".

But if there's something wrong with the table (for instance, if the command-label is not found in the given table), these phrases will return the value "c-table-error". If debugging is on, a debug message will be shown.
		
Chapter: A Note to Extension Authors

If we've written an extension that creates a new command for the player, we can, in a section marked "(for use with Common Commands Sidebar by Alice Grove)," include the following table continuation:

	*:
	Table of Extension-Provided Sidebar Commands (continued)
	Displayed Command
	"New command goes here"
	
By using this table, we make our extension compatible with other extensions adding their own sidebar commands. This way the story author can automatically add commands to the sidebar from multiple extensions at once, just by adding "with extension commands" to the "prepare the commands sidebar" line.

If we want to provide a complete list of commands that can replace the default commands (for instance, if we're translating Common Commands Sidebar into another language), we can write a new extension to be used in place of Common Commands Sidebar, or we can write a compatible extension that provides a new table with a unique name. In the new table, the commands should be listed in a column entitled "Displayed Command (a text)". The story author can then swap in the new table if desired.

Most of the responses visible to players can be changed according to "14.11. Changing the text of responses" in the Inform manual, but there are two exceptions: the responses shown when players mistakenly type "sidebar [text]" or "commands [text]." These can be changed as follows:

	*:
	The SIDEBAR instructions of the sidebar are "New response here.".
	The COMMANDS instructions of the sidebar are "New response here.".

Extensions intended to be compatible with Common Commands Sidebar should not modify the Table of Default Sidebar Commands or the Table of Custom Sidebar Commands, as this would create obstacles for story authors who want to include only the original commands, or who want to create a custom list from scratch. Compatible extensions should also avoid setting any of the built-in sidebar options without good reason, because if both the extension author and the story author include "Prepare the Commands Sidebar" lines, the extension will detect both lines and generate error messages.



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
	The custom divider of the sidebar is "+ + +".
		
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
	"Commands Sidebar (currently [if the sidebar is not flagged to appear later]off[otherwise]on[end if])"	--	--	toggle sidebar from menu rule

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
	


Example: *** Dropping the Compass - Using phrases to blank out compass directions in the sidebar when the player drops the compass.

	*: "Dropping the Compass"

	Include Common Commands Sidebar by Alice Grove.

	compass_direction is a command-label.

	Table of Custom Sidebar Commands (continued)
	Displayed Command	Command Label (a command-label)	Command visibility (a command-visibility)
	"[bold type]Useful Commands"	--	--
	" "	--	--
	"[fixed letter spacing]     N"	compass_direction	c-shown
	"[fixed letter spacing]  NW   NE"	compass_direction	c-shown
	"[fixed letter spacing]W    *    E"	compass_direction	c-shown
	"[fixed letter spacing]  SW   SE"	compass_direction	c-shown
	"[fixed letter spacing]     S"	compass_direction	c-shown
	" "
	"Look (L)"
	"Inventory (I)"
	"Take/Drop something"
	"Examine (X) it"
	"Quit (Q)"

	Shifting Cavern is a room. "Your usually excellect sense of direction fails you in this strange cavern. You feel vaguely dizzy."

	A compass is a thing. The description of the compass is "They insisted that you bring it."
	
	The player carries the compass.

	When play begins:
		prepare the command sidebar, shown automatically.
	
	The sidebar is using phrases to control command visibility.
	
	Every turn:
		refresh the sidebar.
	
	Every turn when the turn count is 1:
		now the compass is in the location of the player;
		blank the compass_direction commands;
		say "Gravity shifts in the cave, sweeping the compass out of your grip. The instrument meanders sideways through the air, then loops overhead before crashing to the ground.[paragraph break]You no longer know which way is which."
	
	Instead of going a direction when the player does not carry the compass:
		say "Without the compass you have no idea which way is which."	
	
	After taking the compass:
		show the compass_direction commands;
		say "Phew! Now you can orient yourself."
	
	After dropping the compass:
		blank the compass_direction commands;
		say "You drop the compass...and now you don't know which way is which."
	
	Test me with "commands / inventory / x compass / commands".
