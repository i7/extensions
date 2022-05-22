Version 5 of Menus by Wade Clarke begins here.

"Lets you include a menu system of help, hints and/or other information in your Glulx or Z-Code project for Inform 6M62 or later. This upgrade of Emily Short's classic Menus extension features user-friendly single keypress controls, a more sophisticated UI, compatibility with screen readers and portable devices, an optional book mode with automatic pagination, and isolated message content to make translations easier. Classic Menus tables can be reformatted for this extension with a little work."

Section 1 - Inclusions and main hook

Include Basic Screen Effects by Emily Short.

Displaying is an activity.

Rule for displaying (this is the basic menu contents rule):
	now right alignment depth is 12;
	now mn_menupresent is true;
	show menu contents;

[NOTE - It is unnecessary to manually save any of your game's status window margin/depth settings before beginning the displaying activity. When the player exits the menu systems, those settings will be automatically restored to what they were before they activity began, unless you've altered the programming of the status window yourself in some significant way.]

	
Section 2 - The Author-Configurable Variables

mn_debug is initially 0. [default = 0   alternatives = 1 or 2]

mn_master_title is initially "HELP MENU". [default = "HELP MENU"]

mn_master_table is initially the table of default help contents. [default = table of default help contents]

mn_modes_allowed is initially "both". [default = "both"   alternatives = "menu only" or "book only" ]

mn_show_hints_in_bookmode is initially false. [default = false]

mn_bookpageshow is initially true. [default = true]

mn_localpageshow is initially true. [default = true]

mn_breadcrumb_preference is initially "main". [default = "main"   alternatives = "status" or "both" or "off"]

mn_hinthelp_preference is initially "both". [default = "both"   alternatives = "main" or "status"]

mn_show_pagefooter is initially true. [default is true]

mn_footerdesign is initially "[bold type]------------------------[roman type][line break]".


Section 3 - Key Assignments

[When adding any new characters to the Table of Extra Menu Choices, always list a new character's upper case number (which will be the smaller number) before its lower case number. This makes sure that the upper case version is displayed alongside the option when a menu is printed out.]

Table of Menu Commands
number	effect
88 [X]	menuabort rule
120 [x]	menuabort rule
76 [L]	menutop rule
108 [l]	menutop rule
77 [M]	menutoggle rule
109 [m]	menutoggle rule
80 [P]	menuretreat rule
112 [p]	menuretreat rule
78 [N]	menuadvance rule
110 [n]	menuadvance rule
72 [H]	menuhint rule
104 [h]	menuhint rule
81 [Q]	menuquit rule
113 [q]	menuquit rule
83 [S]	menureader rule
115 [s]	menureader rule

Section 3.1 (for Z-machine only)

[N.B. The presence of code 27 (Z-Code only ESCAPE) in the Table of Menu Commands is used by this extension as a flag to detect if a game is a Z-Code project. Its absence will be interpreted to mean that the game is a Glulx project.]

Table of Menu Commands (continued)
number	effect
27 [ESC]	menuquit rule
131 [left arrow]	menuretreat rule
132 [right arrow]	menuadvance rule
129 [up arrow]	menuretreat rule
130 [down arrow]	menuadvance rule

Section 3.2 (for Glulx only)

Table of Menu Commands (continued)
number	effect
-8 [ESC]	menuquit rule
-2 [left arrow]	menuretreat rule
-3 [right arrow]	menuadvance rule
-4 [up arrow]	menuretreat rule
-5 [down arrow]	menuadvance rule

Section 3.3

table of extra menu choices
number	choice
48 [digit 0]	10
65 [A]	11
66 [B]	12
67 [C]	13
68 [D]	14
69 [E]	15
70 [F]	16
71 [G]	17
73 [I]	19
74 [J]	20
75 [K]	21
79 [O]	22
82 [R]	24
84 [T]	26
85 [U]	27
86 [V]	28
87 [W]	29
89 [Y]	30
90 [Z]	31
97 [a]	11
98 [b]	12
99 [c]	13
100 [d]	14
101 [e]	15
102 [f]	16
103 [g]	17
105 [i]	19
106 [j]	20
107 [k]	21
111 [o]	22
114 [r]	24
116 [t]	26
117 [u]	27
118 [v]	28
119 [w]	29
121 [y]	30
122 [z]	31


Section 4 - Printed Messages

To say mn_first_hint:
	say "Press H to reveal the first hint"

To say mn_another_hint:
	say "Press H to reveal another hint"

To say mn_one_hint:
	say "This page has just the one hint"

To say mn_all_hints:
	say "You have revealed all the hints on this page"

To say mn_number_or_letter:
	say "Press a number [if mn_temp_counter > 10]or letter [end if]to choose an option[if mn_stackpointer > 1],[otherwise] or[end if]"

To say mn_page_n_of:
	say "page [mn_currentlocalpage] of "

To say mn_book_n_of:
	say "BOOK [mn_currentbookpage]/[mn_book_total]"

To say mn_book_alt_n_of:
	say "You're on book page [mn_currentbookpage] of [mn_book_total]"

To say mn_leap_A:
	say "L to leap to Book page 1 or "

To say mn_leap_B:
	if using glulx format or mn_screenreader > 0:
		say ", L to leap to the top menu";
	otherwise:
		say ", L to leap to top menu"

To say mn_leap_C:
	if using glulx format or mn_screenreader > 0:
		say ", L to leap to the top menu or ";
	otherwise:
		say ", L to leap to top menu, "

To say mn_leap_D:
	say " or "

To say mn_next_only:
	if using glulx format or mn_screenreader > 0:
		say "Press N (Next) or the Right / Down arrow key to turn to the next page.";
	otherwise:
		say "Press N (Next) or the Right / Down arrow key to page forward."

To say mn_previous_only:
	if using glulx format or mn_screenreader > 0:
		say "Press P (Previous) or the Left / Up arrow key to turn back a page.";
	otherwise:
		say "Press P (Previous) or the Left / Up arrow key to page back."

To say mn_next_and_previous:
	say "Press N (Next), P (Previous) or the arrow keys to turn pages."

To say mn_escape_key:
		say "ESC or Q"

To say mn_escape_A:
	say "[mn_escape_key][if mn_stackpointer > 1] to move back a menu[mn_leapmessage][end if] or X to exit[mn_optional_menusystem]."

To say mn_escape_B:
	say "Press [if mn_bookmode is false][mn_escape_key] to return to [mn_optional_current]menu[end if][mn_leapmessage]X to exit[mn_optional_menusystem]."

To say mn_optional_current:
	if mn_screenreader > 0:
		say "the parent ".

To say mn_optional_menusystem:
	if mn_screenreader > 0:
		say " the menu system".

To say mn_book_mode_off:
	say "Press M to turn Book Mode [if mn_screenreader is 0]OFF[otherwise]off"

To say mn_book_mode_on:
	say "Press M to turn Book Mode [if mn_screenreader is 0]ON[otherwise]on"

To say mn_no_hints_in_book_mode:
	say "Hint pages do not appear in Book Mode"

To say mn_hints_on_next_page:
	say "**** **** **** HINTS START ON THE NEXT PAGE **** **** ****"

To say mn_hints_on_next_page_screenreader:
	say "(Hints start on the next page!)[run paragraph on]"

To say mn_hints_begin_on:
	say "Hints begin on page [mn_hints_threshold plus 1]"

To say mn_screenreader_on:
	say "(Screen Reader mode is on. Press S at any time to turn it off again. This message only appears on the front page of the menu system.)"

To say mn_screenreader_off:
	say "(If you're using a screen reader, press S to turn on Screen Reader mode. This message only appears on the front page of the menu system.)".

To say mn_bookintro_1:
	say "[line break]In Book Mode, the menu content is arranged into a virtual book. There are no menus in this mode. You just page forwards and backwards through the content. Book Mode can be toggled on or off at any time."

To say mn_bookintro_2:
	say "[line break](The game’s hint pages are not visible in book mode.)"

To say mn_bookintro_3:
	say "[line break](The game’s hint pages are gathered together at the back of the book. You will be alerted if you are approaching them.)"

To say mn_bookintro_4:
	say "[line break]This introduction to Book Mode will not appear again during the current game. Please press any key to continue."


Section 5 - Main Tables and variables

table of default help contents
title (text)	subtable (table name)	description (text)	toggle (rule)	used (number)	bookpage (number)	localpage (number)
--	--	--	--	--	--	--

table of pagey menus
storer (a table name)	path (text)	bookhead (a table name)	parthead (a table name)	chapterhead (a table name)
table of default help contents	""	--	--	--
with 30 blank rows.

table of hinting
hintpresence
1

mn_stackpointer is initially 1.

Table of mn_stack
desk (table name)
table of default help contents
with 4 blank rows

mn_current_menu_title is a text variable.
mn_breadcrumb is a text that varies.
mn_bookmode is initially false.
mn_localmode is initially false.
mn_endnode_flag is initially false.

mn_status_format is a table name that varies. mn_status_format is table of five line menu status.

mn_max_options, mn_book_total, mn_hints_threshold are number variables.

mn_currentlocalpage, mn_currentbookpage, mn_temppagecount are number variables.

mn_temp_counter is a number variable.
mn_temp_list is a list of numbers that varies.

current menu is a table name that varies.
current menu selection is a number variable.

mn_screenreader is a number variable. [0 = off, 1 = on with instructions (I made this a number rather than a truth state in case someone wants to make more than one iteration of screen reader mode in the future)]


Section 6 - Boot Time Menu Scanning Routine

To decide whether using glulx format:
	if there is a number of 27 in the table of menu commands, no;
	otherwise yes.

mn_masterpath is a text variable.

mn_nextlocal, mn_nextbook, mn_nextnegative are number variables.

mn_pagetype is initially "normal". [alternatives = "page" or "hint"]

mn_tablebook is a table name that varies.
mn_tablepart is a table name that varies.
mn_tablechapter is a table name that varies.
mn_tablesection is a table name that varies.

mn_temptitle is a text variable.
mn_currenttable is a table name that varies.

mn_menu_init_abort is initially false.
mn_any_hints_present is initially false.
mn_book_content_is_all_hints is initially false.

To mn_pagestamp:
	if mn_debug > 0, say "It's book page [mn_nextbook], local page [mn_nextlocal].[line break]";
	increment mn_nextbook;
	increment mn_nextlocal.

To mn_negativestamp:
	now mn_any_hints_present is true;
	decrement mn_nextnegative;
	increment mn_nextlocal.
	
To mn_reset title:
	now mn_current_menu_title is mn_master_title.

To say mn_compile_error:
	say "[paragraph break]****** MENUS ERROR: Sorry, the help menus failed to compile. ";
	now mn_menu_init_abort is true.

To say mn_gmd:
	say "Menus Debugger: ".



To mn_assess (T - a table name):
	let tempstackpointer be mn_stackpointer;
	let mn_pathstorage be mn_masterpath; [Store current path.]
	if mn_debug > 1, say "mn_masterpath ('[mn_masterpath]') was stored as we enter [mn_currenttable].[line break]";
	repeat through mn_currenttable:
		now used entry is 0;
		now bookpage entry is 0;
		now localpage entry is 0;
		if there is a toggle entry: [For pagination purposes, toggle entries are completely ignored]
			now localpage entry is mn_nextbook minus 1; [Store the most recently used global page number in the toggle entry's localpage field]
			next;
		if there is no title entry:
			say "[mn_compile_error]There is an empty title entry in [mn_currenttable]. Empty title entries are not allowed.[paragraph break]";
			break;
		let hintalert be false;
		if there is a subtable entry and subtable entry is table of hinting:
			now hintalert is true;
			now mn_pagetype is "hint";
		if title entry is not "page" and title entry is not "hint":
			now mn_temptitle is title entry;
			if mn_debug > 0, say "[if mn_debug > 1][line break][end if]Checking [mn_temptitle]: ";
			now mn_nextlocal is 1;
			if there is a subtable entry and hintalert is false:
				if mn_stackpointer is 5:
					say "[mn_compile_error]The topic '[mn_temptitle]' in [mn_tablesection] is not allowed to have a subtable entry, as the help menu is only allowed to have five layers in total.[paragraph break]";
					break;
				now mn_pagetype is "normal";
				if mn_stackpointer is: [Choose the target table, which is one layer deeper than we are now]
					-- 1: now mn_tablebook is subtable entry;
					-- 2: now mn_tablepart is subtable entry;
					-- 3: now mn_tablechapter is subtable entry;
					-- 4: now mn_tablesection is subtable entry;
				let targettable be subtable entry;
				choose a blank row in table of pagey menus;
				now storer entry is targettable;
				if mn_masterpath is not "":
					now path entry is substituted form of "[mn_masterpath] - [mn_temptitle]";
				otherwise:
					now path entry is substituted form of "[mn_temptitle]";
				if mn_debug > 1, say "Path entry for it was made: '[path entry]'.[line break]";
				if mn_stackpointer is:
					-- 2:
						now bookhead entry is T;
						if mn_debug > 1, say "(wrote [T] to bookhead entry)[line break]";
					-- 3:
						now bookhead entry is mn_tablebook;
						if mn_debug > 1, say "(wrote [mn_tablebook] to bookhead entry)[line break]";
						now parthead entry is T;
						if mn_debug > 1, say "(wrote [T] to parthead entry)[line break]";
					-- 4:
						now bookhead entry is mn_tablebook;
						if mn_debug > 1, say "(wrote [mn_tablebook] to bookhead entry)[line break]";
						now parthead entry is mn_tablepart;
						if mn_debug > 1, say "(wrote [mn_tablepart] to parthead entry)[line break]";
						now chapterhead entry is T;
						if mn_debug > 1, say "(wrote [T] to chapterhead entry)[line break]";
				now mn_masterpath is substituted form of path entry;
				if mn_debug > 1, say "mn_masterpath changed to [mn_masterpath].[line break]";
				let temptable be mn_currenttable; [Store table of current level]
				if mn_debug  > 0, say "[line break]+ Diving into [targettable] +[line break]";
				now mn_currenttable is targettable;
				increment mn_stackpointer;
				mn_assess targettable;
				if mn_menu_init_abort is true:
					stop the action;
				if mn_debug > 0, say "- Returning to [temptable] -[line break]";
				now mn_currenttable is temptable; [Retrieve table of current level]
				now mn_masterpath is substituted form of mn_pathstorage; [Retrieve text path of current level]
				if mn_debug > 1, say "retrieved mn_masterpath from storer: it's now [mn_masterpath].[line break]";
				now mn_stackpointer is tempstackpointer; [Retrieve stack pointer of current level]
				if mn_debug > 1, say "stack retrieved and it's now [mn_stackpointer][line break]";
				next;
			if there is no subtable entry or hintalert is true:
				if there is a description entry:
					if hintalert is true:
						now used entry is mn_nextbook minus 1; [Store most recently used global page number in the hint entry's 'used' field]
						if used entry is 0:
							now used entry is 1;
						now bookpage entry is mn_nextnegative;
						now localpage entry is mn_nextlocal;
						if mn_debug > 0, say "Deferred its book page assignment, but gathered hint [mn_nextlocal] and noted the nearest text page is at book page [mn_nextbook minus 1].[line break]";
						mn_negativestamp;
					otherwise:
						now mn_pagetype is "page"; [... if hintalert was true, we know that pagetype was already set to 'hint']
						now bookpage entry is mn_nextbook;
						now localpage entry is mn_nextlocal;
						mn_pagestamp;
				otherwise:
					say "[mn_compile_error]The option '[mn_temptitle]' in [mn_currenttable] must have a corresponding subtable entry or description entry.[paragraph break]";
					break;
		otherwise:
			if title entry is "hint":
				if mn_pagetype is not "hint":
					say "[mn_compile_error]In [mn_currenttable], a row with a title entry of 'hint' is illegally positioned. See section 4.2 of this extension's documentation for details on how to correctly format hint pages.[paragraph break]";
				otherwise:
					now mn_pagetype is "hint";
			otherwise if title entry is "page":
				if mn_pagetype is not "page":
					say "[mn_compile_error]In [mn_currenttable], a row with a title entry of 'page' is illegally positioned. See section 4.1 of this extension's documentation for details on how to correctly format text topics.[paragraph break]";
				otherwise:
					now mn_pagetype is "page";
			if there is a description entry:
				if mn_menu_init_abort is true:
					stop the action;
				if title entry is "hint":
					now used entry is mn_nextbook minus 1; [Store most recently used global page number in the hint entry's 'used' field]
					if used entry is 0:
						now used entry is 1;
					increment mn_nextnegative;
					now bookpage entry is mn_nextnegative;
					now localpage entry is mn_nextlocal;
					if mn_debug > 0, say "- gathered hint [mn_nextlocal] on this topic, with nearest text page at book page [mn_nextbook minus 1].[line break]";
					mn_negativestamp;
				otherwise:
					if mn_debug  > 0, say "- It has another page - ";
					now bookpage entry is mn_nextbook;
					now localpage entry is mn_nextlocal;
					mn_pagestamp;
			otherwise:
				say "[mn_compile_error]A line in [mn_currenttable] has a title entry of '[mn_pagetype]' but no corresponding description entry. This is not allowed.[paragraph break]";
				break;
	if mn_menu_init_abort is true:
		stop the action.

Last when play begins (this is the Menus startup scan rule):
	if mn_master_table is table of default help contents and table of default help contents is empty:
		stop the action;
	now current menu is mn_master_table;
	now storer in row 1 of table of pagey menus is mn_master_table;
	now desk in row 1 of table of mn_stack is mn_master_table;
	repeat through table of extra menu choices: [Store the highest numbered option in mn_max_options]
		if choice entry > mn_max_options:
			now mn_max_options is choice entry;
	if mn_debug > 0, say "[mn_gmd]SCANNING HELP MENUS:[paragraph break]";
	mn_reset title;
	now mn_nextbook is 1;
	now mn_nextlocal is 1;
	now mn_nextnegative is -1;
	now mn_stackpointer is 1;
	now mn_currenttable is mn_master_table;
	mn_assess mn_currenttable;
	if mn_menu_init_abort is false:
		now mn_book_total is mn_nextbook minus 1; [Note the number of printed pages in the help volume before adding any hint pages to the end of it]
		now mn_hints_threshold is mn_book_total;
		if mn_any_hints_present is true and mn_show_hints_in_bookmode is true:
			if mn_debug > 0, say line break;
			let old marker be 0;
			let farthest hint page be 0; [After the loop in the next line, this variable will hold the value of the REAL last global page number in the volume]
			repeat through table of pagey menus:
				now mn_currenttable is storer entry;
				repeat through mn_currenttable:
					if bookpage entry < 0: [A negative entry indicates a hint page]
						now farthest hint page is mn_book_total minus bookpage entry; [Subtracting a negative value = adding]
						now bookpage entry is farthest hint page;
						if farthest hint page > old marker:
							now old marker is farthest hint page;
							if mn_debug > 0, say "'[title entry]' hints assigned to book page [old marker].[paragraph break]";
							if old marker is 1:
								now mn_book_content_is_all_hints is true;
								if mn_debug > 0, say "* NOTE that this help system will consist of nothing but hints when viewed in Book Mode.[paragraph break]";
			now mn_book_total is farthest hint page; [Store updated volume page total]
		if mn_book_total is 0:
			now mn_modes_allowed is "menu only";
			if mn_debug > 0, say "[mn_gmd]The menu structure has no text page content, so the player will not be allowed to switch to Book mode. The mn_modes_allowed variable has been set to 'menu only'.";
		if mn_modes_allowed is "book only":
			now mn_bookmode is true;
			now mn_phase is 3; [Cue the menu logic to drill into the first local topic the first time the help system is used]
			if mn_show_hints_in_bookmode is true:
				now mn_status_format is table of four line menu status;
			otherwise:
				now mn_status_format is table of three line menu status;
		otherwise if mn_modes_allowed is "menu only":
			now mn_status_format is table of three line menu status;
	choose row 1 in mn_master_table;
	if there is a toggle entry:
		do nothing;
	if mn_debug > 0 and mn_menu_init_abort is false:
		say "RESULTS SUMMARY:[paragraph break]";
		repeat through table of pagey menus:
			say "[storer entry][line break]Textpath: [path entry][line break]Tables path: ";
			if there is a bookhead entry:
				say "[bookhead entry], ";
			otherwise:
				say "--, ";
			if there is a parthead entry:
				say "[parthead entry], ";
			otherwise:
				say "--, ";
			if there is a chapterhead entry:
				say "[chapterhead entry]";
			otherwise:
				say "--, ";
			say paragraph break;
		say "Total number of pages in book mode volume: [mn_book_total][line break]";
		if mn_any_hints_present is true and mn_show_hints_in_bookmode is false:
			say "(Your hint pages were not included in this number, as they won't appear in Book mode.)[line break]";
		say "[line break]The Menus extensions believes your game is in [if using glulx format]Glulx[otherwise]Z-Code[end if] format.[line break]".


Section 7 - Menu System Logic

mn_phase is a number variable. [1 = show menu contents   2 = menuprint   3 = drilling into topics from 'show menu contents' to activate local mode]
mn_action is a number variable.
mn_temp_selection is a number variable.
mn_menupresent is a truth state variable.
mn_refresh is initially true.



To mn_redraw status line:
	(- DrawStatusLine(); -)

[I've given this command definition the mn_prefix within the Menus extension for safety, so that it doesn't overwrite any custom 'redraw status line' function you (the author) or another extension might have set up. If it turns out that you actually want the Menus extension to redraw the status window with your own function whenever it would normally invoke the mn_redraw status line function, just delete the above definition and search and replace through this source for 'mn_redraw status line', replacing each of the few incidences of it with the function you want called instead.]


To retrieve and print character number (N - a number): (- print (char) {N}; -)

To say mn_indexphrase:
	if mn_temp_counter is less than 10:
		say mn_temp_counter;
	otherwise:
		if there is a choice of mn_temp_counter in Table of Extra Menu Choices:
			choose a row with a choice of mn_temp_counter in Table of Extra Menu Choices;
			retrieve and print character number number entry;
		otherwise:
			say "MENUS RUNTIME ERROR: There should be a choice entry of [mn_temp_counter] in the Table of Extra Menu Choices, but there isn't."

To do the mn_optional zcode bump:
	unless using glulx format:
		if mn_screenreader is 0:
			say line break;
			if mn_status_format is not table of three line menu status:
				say line break;
			if mn_status_format is table of five line menu status:
				say line break.

To mn_optionally print the screen reader header:
	if mn_screenreader > 0:
		if (mn_stackpointer is 1 and mn_localmode is false) or (mn_bookmode is true and mn_currentbookpage is 1): [ie if player is on the front page of the menu system]
			say mn_screenreader_on;
		mn_prepare the status line;
		if mn_bookmode is true:
			say "[mn_book_alt_n_of]. "; [You're on book page N of N.]
			if mn_any_hints_present is true:
				if mn_show_hints_in_bookmode is false and mn_modes_allowed is "both":
					say "([mn_no_hints_in_book_mode].) "; [Hint pages do not appear in Book Mode]
				if mn_show_hints_in_bookmode is true:
					if mn_currentbookpage is mn_hints_threshold:
						say "[mn_hints_on_next_page_screenreader] ";
					otherwise if mn_currentbookpage < mn_hints_threshold:
						say "([mn_hints_begin_on].) ";
			if mn_modes_allowed is not "book only":
				say "[mn_book_mode_off]. "; [Press M to turn Book Mode OFF]
		if mn_status_format is table of three line menu status or mn_preserve_line_three is false:
			say "[mn_page_one] [mn_page_two] ";
		otherwise:
			say "[mn_page_one] [mn_page_two] [mn_page_three] "; [to take this branch, we are either using the table of four or five line status, or mn_preserve_line_three is true. In the case of the five line status, mn_page_four can only ever contain info that has already been printed by now if the player is in Screen Reader mode. Therefore whether we're using the four line status or the five line, the same code applies, which omits mn_page_four. And if we are omitting page three on this pass, we already took the above 'if' branch]
		if mn_bookmode is false and mn_modes_allowed is not "menu only":
			say "[mn_book_mode_on] "; [Press M to turn Book Mode ON]
		say paragraph break;
	if (mn_stackpointer is 1 and mn_localmode is false) or (mn_bookmode is true and mn_currentbookpage is 1): [ie if player is on the front page of the menu system]
		if mn_screenreader is 0:
			say mn_screenreader_off;
			say line break.

To reprint (selected menu - a table-name):
	now mn_temp_list is { };
	clear the screen;
	if mn_screenreader is 0:
		say line break;
	do the mn_optional zcode bump;
	mn_optionally print the screen reader header;
	if mn_breadcrumb_preference is not "off":
		if mn_breadcrumb_preference is "main" or mn_breadcrumb_preference is "both" or mn_screenreader > 0:
			if mn_stackpointer > 1:
				say "[italic type]([mn_breadcrumb])[roman type][paragraph break]";
			if mn_stackpointer is 1 and mn_screenreader > 0 and mn_master_title is not "":
				say "([mn_master_title])[paragraph break]";
	if mn_screenreader is 0:
		say fixed letter spacing;
	now mn_temp_counter is 0;
	let Z be 0;
	repeat through selected menu:
		increment Z; [Note number of current row]
		if title entry is not "page" and title entry is not "hint":
			increment mn_temp_counter; [Increase number of legitimate choices by 1]
			if mn_temp_counter is less than mn_max_options plus 1: [= max. no of choices plus 1]
				if mn_screenreader is 0:
					say "     ";
				say "[mn_indexphrase][if there is a toggle entry]: [otherwise]. [end if][title entry]";
				if mn_screenreader is 0:
					say line break;
				otherwise:
					say ". ";
				add Z to mn_temp_list; [Note row number of this choice]
			otherwise:
				now mn_temp_counter is mn_max_options; [= max no. of choices]
				break;
	say variable letter spacing;
	say run paragraph on; [Prevents screen nudging on an irrelevant keypress in Gargoyle and similarly programmed interpreters]
	mn_redraw status line. [Need to leave this until last in this routine so that the value of mn_temp_counter gets calculated before the redraw]

To mn_count the local pages:
	now mn_temppagecount is 1;
	now mn_local_hint_index is 0;
	let F be 0;
	repeat through current menu:
		if F is 1:
			if title entry is "page" or title entry is "hint":
				increment mn_temppagecount;
				if used entry < 0:
					increment mn_local_hint_index;
			otherwise:
				break;
		otherwise if title entry is mn_current_menu_title:
			if there is a subtable entry and subtable entry is table of hinting:
				now mn_hintmode is true;
				if used entry < 0:
					increment mn_local_hint_index;
			now F is 1.

To mn_identify the book page:
	repeat through table of pagey menus:
		if there is a bookpage of mn_currentbookpage in storer entry:
			now current menu is storer entry;
			let headerstorage be "temp"; [Create a temporary text variable]
			repeat with N running from 1 to the number of rows in current menu:
				choose row N in current menu;
				if there is a toggle entry: [Completely ignore a toggle entry and move to the next line]
					next;
				if title entry is not "page" and title entry is not "hint":
					now headerstorage is title entry; [Always note the most recently scanned title entry]
				if bookpage entry is mn_currentbookpage:
					now mn_temp_selection is N;
					now mn_current_menu_title is headerstorage;
					mn_count the local pages;
					break.

To mn_clear hint flags:
	now mn_hintmode is false;
	now mn_hintglut is false.



To show menu contents:
	if mn_action is 2: [IE if player re-enters menu system having exited from localmode..]
		now mn_action is 0;
		follow the menuprint rule;
		if mn_action is 2: [IE player wants to exit menus immediately]
			rule succeeds;
		otherwise:
			mn_clear hint flags;
	unless mn_phase is 3:
		now mn_phase is 1;
	while mn_menupresent is true:
		let __index be 0;			
		while __index is not 1:
			let globaljump be false; [a temp flag for use during the drill down sequence]
			now mn_breadcrumb is the path corresponding to a storer of current menu in table of pagey menus;
			if mn_refresh is true:
				reprint current menu;
			now mn_refresh is true;
			now mn_action is 0;
			let __x be 0;
			let F be 0;
			if mn_phase is 3: [If we're drilling down..]
				repeat with N running from 1 to number of rows in current menu:
					choose row N in current menu;
					if there is a toggle entry or used entry is not 0: ['toggle' clause checks for toggle entries, 'used' clause checks for hint pages]
						if there is a toggle entry:
							now F is localpage entry; [Retrieve number of nearest global page (which was stored here during startup scan)]
						otherwise:
							now F is used entry; [Retrieve number of nearest global page (which was stored here during startup scan)]
							if F < 0:
								now F is 0 minus F; [Positive-ise choice]
						if F is 0: [This could happen if the toggle/hint entry occurs at the highest menu level and before any non-toggle entries]
							now F is 1; [If it does, point to global page 1 instead]
						now mn_currentbookpage is F;
						now globaljump is true; [This signals that F contains a global page #]
						break;
					otherwise: [If no toggle entry, we will choose this row. Whether it has text content or leads to another subtable, we choose it]
						now F is N; [Mark current row as the one we will choose]
						break;
				if globaljump is false:
					if F is listed in mn_temp_list: [It SHOULD be!]
						repeat with L running from 1 to number of entries in mn_temp_list:
							if entry L in mn_temp_list is F:
								now F is L;
								break;
					now current menu selection is F;	
			otherwise:
				now __x is the chosen letter;
			if globaljump is false:
				if __x is a number listed in the Table of Menu Commands: [If the drill down set the value of current menu selection, __x will still be 0.]
					follow the effect entry;
					if mn_menupresent is false:
						now __index is 1;
				otherwise:
					if __x is a number listed in the Table of Extra Menu Choices:
						now current menu selection is choice entry;
					otherwise if F is 0: [F will be non-0 if we're drilling down and have already calculated the value of current menu selection for this round.]
						now current menu selection is __x minus 48;
					if current menu selection < 1 or current menu selection > mn_temp_counter:
						now __index is 1; [If keypress was not a valid menu choice, rerun this loop-]
						now mn_refresh is false; [-but without reprinting the menu]
					otherwise:
						now mn_temp_selection is entry current menu selection of mn_temp_list;
						choose row mn_temp_selection in the current menu;
						unless there is a toggle entry:
							now mn_current_menu_title is title entry;
						if there is a toggle entry:
							follow toggle entry;
						otherwise if there is a subtable entry and subtable entry is not table of hinting:
							now the current menu is subtable entry;
							increment mn_stackpointer;
							choose a blank row in table of mn_stack;
							now desk entry is current menu;
							now __index is 1;
						otherwise:
							now mn_phase is 2; [Trigger move to localmode]
			if mn_phase is 2:
				mn_count the local pages; [Puts the number of pages in the current local topic into mn_temppagecount]
			otherwise if mn_phase is 3 and globaljump is true:
				mn_identify the book page; [Sets current menu, mn_current_menu_title, mn_temp_selection, and does a mn_count the local pages for the target global page]
				now mn_phase is 2;
			if mn_phase is 2:
				now mn_localmode is true;
				follow the menuprint rule;
				if mn_action is 2: [IE player wants to exit menus immediately]
					now __index is 1;
				otherwise:
					mn_clear hint flags;
				now mn_phase is 1.



To mn_print the optional bottom design:
	if mn_show_pagefooter is true and mn_screenreader is 0:
		say mn_footerdesign.

[When the menuprint rule is called from 'show menu contents', mn_temp_selection holds the row number of local page 1 going in]

This is the menuprint rule:
	let __superindex be 0;
	while __superindex is 0:
		choose row mn_temp_selection in the current menu; [While in a multi-page topic, mn_temp_selection points to the local page we're reading]
		now mn_currentbookpage is bookpage entry;
		now mn_currentlocalpage is localpage entry;
		now mn_breadcrumb is the path corresponding to a storer of current menu in table of pagey menus;
		now the mn_endnode_flag is true;
		mn_redraw status line;
		if mn_refresh is true:
			clear only the main screen; [flag]
			if mn_hintmode is true:
				do the mn_optional zcode bump;
			mn_optionally print the screen reader header;
			say variable letter spacing;
			if mn_breadcrumb_preference is not "off":
				if mn_breadcrumb_preference is "main" or mn_breadcrumb_preference is "both" or mn_screenreader > 0:
					say "[italic type]([mn_breadcrumb] - [mn_current_menu_title][run paragraph on]";
					if mn_localpageshow is true and mn_hintmode is false and mn_screenreader > 0:
						say ", [mn_page_n_of][mn_temppagecount]"; [(page [mn_currentlocalpage] of ]
					say ")[roman type]";
			say paragraph break;
			if mn_hintmode is false:
				say "[description entry][paragraph break]";
			otherwise:
				choose row mn_temp_selection in the current menu; [If player hasn't revealed first hint yet]
				if used entry > 0: 
					if mn_hinthelp_preference is not "status" or mn_screenreader > 0:
						say "[mn_first_hint].[paragraph break]"; [Press H to reveal the first hint]
				otherwise:
					let K be 1;
					let looptarget be mn_temp_selection plus mn_temppagecount minus 1;
					repeat with N running from mn_temp_selection to looptarget:
						choose row N in current menu;
						if mn_screenreader is 0:
							say "[K]/[mn_temppagecount]: [description entry][paragraph break]";
						otherwise:
							say "[K] of [mn_temppagecount]: [description entry]. ";
						increment K;
						if K is greater than mn_local_hint_index:
							break;
					if K is greater than mn_temppagecount:
						if mn_screenreader is 0:
							say line break;
						if mn_hinthelp_preference is not "status" or mn_screenreader > 0:
							if mn_local_hint_index is 1:
								say "([mn_one_hint].)"; [This page has just the one hint]
							otherwise:
								say "([mn_all_hints].)"; [You have revealed all the hints on this page]
							say line break;
						now mn_hintglut is true;
						mn_redraw status line;
					otherwise:
						if K is greater than mn_local_hint_index:
							if mn_hinthelp_preference is not "status" or mn_screenreader > 0:
								say "[mn_another_hint].[paragraph break]"; [Press H to reveal another hint.]
			mn_print the optional bottom design;
			say run paragraph on; [Prevents screen nudging on an irrelevant keypress in Gargoyle and similarly programmed interpreters]
		now mn_refresh is true;
		let __x be 0;
		let __x be the chosen letter;
		if __x is a number listed in the Table of Menu Commands:
			choose a row with a number of __x in the Table of Menu Commands;
			follow the effect entry;
			if mn_action is 1: [If the action demands we return to the topic list level-]
				now mn_action is 0;
				now the mn_endnode_flag is false;
				now mn_localmode is false;
				now __superindex is 1; [-return to 'show menu contents']
			if mn_action is 2: [IE player wants to exit menus immediately]
				now __superindex is 1;
		otherwise:
			now mn_refresh is false.


Section 8 - The Menu Action Rules

mn_hintmode is initially false.
mn_hintglut is initially false.
mn_local_hint_index is a number variable. [When you move to a hint page, this variable is set to the number of the next hint to be revealed on the page]

mn_used_bookmode_before is initially false.


To mn_zap the stack:
	repeat through table of mn_stack:
		unless desk entry is mn_master_table, blank out the whole row.

To mn_reconstruct the stack:
	mn_zap the stack;
	now mn_stackpointer is 1;
	choose row with a storer of current menu in table of pagey menus;
	if there is a bookhead entry:
		increment mn_stackpointer;
		choose row mn_stackpointer in table of mn_stack;
		now desk entry is bookhead corresponding to a storer of current menu in table of pagey menus;
		choose row with a storer of current menu in table of pagey menus;
		if there is a parthead entry:
			increment mn_stackpointer;
			choose row mn_stackpointer in table of mn_stack;
			now desk entry is parthead corresponding to a storer of current menu in table of pagey menus;
			choose row with a storer of current menu in table of pagey menus;
			if there is a chapterhead entry:
				increment mn_stackpointer;
				choose row mn_stackpointer in table of mn_stack;
				now desk entry is chapterhead corresponding to a storer of current menu in table of pagey menus;
	unless current menu is mn_master_table:
		increment mn_stackpointer;
		choose row mn_stackpointer in table of mn_stack;
		now desk entry is current menu.

To mn_get parent menu title:
	let calcy be mn_stackpointer minus 1;
	let temptable be the desk in row calcy of the table of mn_stack;
	choose a row with a subtable of current menu in temptable;
	now mn_current_menu_title is title entry.



This is the menuquit rule: 
	if mn_bookmode is true: [Ignore ESC/Q keys if we're in book mode]
		now mn_refresh is false;
		stop the action; [below this line, mn_bookmode must be false]
	if mn_stackpointer is 1 and mn_localmode is false: [NOTE - Stackpointer will always be greater than 1 if we're trying to back out of an all-toggles menu, because such a menu is not allowed to exist at the top level]
		now mn_menupresent is false;
	otherwise:
		if mn_localmode is true: [The following code works from within both the 'show menu contents' action and the 'menuprint' rule]
			if mn_stackpointer is 1:
				mn_reset title;
			otherwise:
				mn_get parent menu title;
			now mn_action is 1;
		otherwise:
			choose row mn_stackpointer in the table of mn_stack;
			blank out the whole row;
			decrement mn_stackpointer;
			choose row mn_stackpointer in the table of mn_stack;
			now current menu is desk entry;
			if mn_stackpointer is 1:
				mn_reset title;
			otherwise:
				mn_get parent menu title.

This is the menuabort rule:
	now mn_menupresent is false;
	if mn_localmode is true:
		now mn_action is 2.

This is the menutop rule: [menutop is a rule which is 'followed', meaning failure/success is irrelevant. So no 'rule succeeds' are needed around here.]
	if mn_bookmode is true: [In book mode, choosing 'top menu' takes you to page 1]
		if mn_currentbookpage is 1: [Ignore 'leap' keypress if we're already on page 1]
			now mn_refresh is false;
			stop the action;
		now mn_currentlocalpage is 1;
		now mn_currentbookpage is 2;
		follow the menuretreat rule;
	otherwise:
		if mn_stackpointer is 1: [If we're at the top level, we cannot leap]
			now mn_refresh is false;
			stop the action;
		now mn_stackpointer is 1;
		now current menu is mn_master_table;
		now mn_action is 1;
		mn_zap the stack;
		mn_reset title.

This is the menutoggle rule:
	if mn_bookmode is false:
		if mn_modes_allowed is "menu only":
			now mn_refresh is false;
			stop the action;
		if mn_phase is 1: [If you're in menu mode-]
			now mn_phase is 3; [-sends a signal to attempt to switch to bookmode and localmode]
		now mn_bookmode is true;
		if mn_hintmode is true and mn_show_hints_in_bookmode is false: [if we're looking at a hint now but hints aren't to be shown in book mode, we need to get the hint's stored nearest global page and go there]
			mn_clear hint flags;
			now mn_currentbookpage is the used in row mn_temp_selection of the current menu;
			if mn_currentbookpage < 0:
				now mn_currentbookpage is 0 minus mn_currentbookpage;
			mn_identify the book page;
		if mn_used_bookmode_before is false: [The first time player uses book mode during a game, we describe Book Mode to them]
			say mn_bookintro_1;
			if mn_any_hints_present is true:
				if mn_show_hints_in_bookmode is false:
					say mn_bookintro_2;
				otherwise if mn_book_content_is_all_hints is false: [if this were True, the content would consist of nothing but hints, at which point it's pointless saying the hints are at the 'back of the book']
					say mn_bookintro_3;
			say mn_bookintro_4;
			let temporary be the chosen letter;
			now mn_used_bookmode_before is true;
	otherwise: [IE we're going to turn book mode OFF - We don't know what depth we're at, only what 'current menu' is. And we must be on a subpage of that menu; we cannot be looking at a topics list because we're in book mode. So based on these 2 pieces of information, we need to reconstruct the stack from the path, set the stack pointer then return to 'show menu contents'.]
		if mn_modes_allowed is "book only":
			now mn_refresh is false;
			stop the action;
		mn_reconstruct the stack;
		now mn_bookmode is false.

This is the menuretreat rule:
	if mn_bookmode is false and mn_localmode is false: [We must be in menu mode, where we can't advance or retreat]
		now mn_refresh is false;
		stop the action;
	if mn_bookmode is true: [By definition, when bookmode is true, localmode will always be true, as you will only see page content, never a list of options]
		if mn_currentlocalpage is 1: [If trying to retreat past the start of the current local topic-]
			if mn_currentbookpage is 1: [-and we're on book page 1-]
				now mn_refresh is false;
				stop the action; [-abort]
			otherwise: [Otherwise it must be possible, so let's work out where to go next]
				decrement mn_currentbookpage; [Get number of target page]
				mn_clear hint flags; [Clear hintflags whenever we change book pages. If the page we go to has hints, the flags will be restored]
				mn_identify the book page;
				stop the action; [We've chosen the relevant table and the correct row in it, so now return to the menuprint routine]
	if mn_localmode is true: [NOTE - book mode is not necessarily false when this line is reached!]
		if mn_hintmode is true or mn_currentlocalpage is 1:
			now mn_refresh is false;
			stop the action;
		otherwise:
			decrement mn_temp_selection.

This is the menuadvance rule:
	if mn_bookmode is false and mn_localmode is false:
		now mn_refresh is false; [We must be in menu mode, where we can't advance or retreat]
		stop the action;
	if mn_bookmode is true: [By definition, when bookmode is true, localmode will always be true, as you will only see page content, never a list of options]
		if mn_currentlocalpage is mn_temppagecount or mn_hintmode is true: [If trying to advance beyond the end of the current local topic OR go forward from a hint page-]
			if mn_currentbookpage is mn_book_total: [-if we're on the last book page-]
				now mn_refresh is false;
				stop the action; [abort]
			otherwise: [Otherwise it must be possible, so let's work out where to go next.]
				mn_clear hint flags; [Clear hintflags whenever we change book pages. If the page we go to has hints, the flags will be restored]
				increment mn_currentbookpage; [Note row in current table]
				mn_identify the book page;
				stop the action; [We've chosen the relevant table and the correct row in it, so now return to the menuprint routine]
	if mn_localmode is true: [NOTE - book mode is not necessarily false when this line is reached!]
		if mn_hintmode is true or mn_currentlocalpage is mn_temppagecount:
			now mn_refresh is false;
			stop the action;
		otherwise:
			increment mn_temp_selection.

This is the menuhint rule:
	if mn_hintmode is false or mn_hintglut is true:
		now mn_refresh is false;
		stop the action;
	otherwise:
		let Z be mn_temp_selection plus mn_local_hint_index; [Calculate row of next hint in current table]
		choose row Z in current menu;
		now used entry is 0 minus used entry; [A negative 'used' value shows that the hint has been read]
		increment mn_local_hint_index.

This is the menureader rule:
	if mn_screenreader is 0:
		now mn_screenreader is 1;
	otherwise:
		now mn_screenreader is 0.


Section 9 - Status Window Logic

mn_page_one is a text variable.
mn_page_two is a text variable.
mn_page_three is a text variable.
mn_page_four is a text variable.

mn_preserve_line_three is initially false.

Rule for constructing the status line while displaying (this is the constructing status line while displaying rule):
	if mn_screenreader is 0:
		mn_prepare the status line;
		fill status bar with mn_status_format;
	otherwise:
		fill status bar with table of screenreader status;
	rule succeeds.


table of five line menu status
left	central	right
"[mn_menuheading]"	""	"[mn_booksignal]"
""	"[mn_page_one]"	""
""	"[mn_page_two]"	""
""	"[mn_page_three]"	""
""	"[mn_page_four]"	""

table of four line menu status
left	central	right
"[mn_menuheading]"	""	"[mn_booksignal]"
""	"[mn_page_one]"	""
""	"[mn_page_two]"	""
""	"[mn_page_three]"	""

table of three line menu status
left	central	right
"[mn_menuheading]"	""	"[mn_booksignal]"
""	"[mn_page_one]"	""
""	"[mn_page_two]"	""

table of screenreader status
left	central	right
"[mn_menuheading]"	""	"[mn_booksignal]"

To say mn_menuheading:
	if the mn_endnode_flag is false: [Menu mode]
		if mn_stackpointer is greater than 1:
			if mn_breadcrumb_preference is "status" or mn_breadcrumb_preference is "both":
				say "[mn_breadcrumb] ";
			otherwise: [Preference must be 'main' or 'off']
				say mn_current_menu_title;
		otherwise:
			say mn_master_title;
	otherwise: [local/hint mode]
		if mn_breadcrumb_preference is "status" or mn_breadcrumb_preference is "both":
			say "[mn_breadcrumb] - ";
		say "[mn_current_menu_title] ";
		if mn_localpageshow is true and mn_hintmode is false:
			say "([mn_page_n_of][mn_temppagecount])"; [(page [mn_currentlocalpage] of ]

To say mn_booksignal:
	if mn_debug > 0, say "[mn_stackpointer] ";
	if mn_bookmode is true and mn_bookpageshow is true:
		say mn_book_n_of. [BOOK [mn_currentbookpage]/[mn_book_total]]



To say mn_leapmessage:
	if mn_bookmode is true:
		if mn_currentbookpage > 1:
			say mn_leap_A; [L to leap to Book page 1 or ]
	otherwise:
		if mn_stackpointer > 1:
			if mn_localmode is false:
				say mn_leap_B; [, L to leap to the top menu]
			otherwise:
				say mn_leap_C; [, L to leap to the top menu or ]
		otherwise:
			say mn_leap_D. [ or ]

To mn_prepare the status line:
	now mn_page_one is "";
	now mn_page_two is "";
	now mn_page_three is "";
	now mn_page_four is "";
	now mn_preserve_line_three is false;
	let tempmessage be "";
	let printflag be false;
	now mn_nextlocal is 1;
	if mn_hintmode is true and mn_hinthelp_preference is not "main" and mn_screenreader is 0:
		if mn_hintglut is false:
			if mn_local_hint_index is 0:
				now mn_page_one is "* [mn_first_hint]."; [Press H to reveal the first hint.]
			otherwise:
				now mn_page_one is "* [mn_another_hint]."; [Press H to reveal another hint.]
		otherwise:
			if mn_local_hint_index is 1:
				now mn_page_one is "* [mn_one_hint]."; [This page has just the one hint.]
			otherwise:
				now mn_page_one is "* [mn_all_hints]."; [You have revealed all the hints on this page.]
		increment mn_nextlocal;
	if the mn_endnode_flag is false: [Menu mode]
		now tempmessage is "[mn_number_or_letter]";
		now printflag is true;
		increment mn_nextlocal;
	otherwise: [We are in local/hint mode, and could also be in global mode]
		let tempyprintflag be 0;
		if mn_bookmode is true and mn_book_total > 1:
			if mn_currentbookpage is 1:
				now tempyprintflag is 1;
			otherwise if mn_currentbookpage is mn_book_total:
				now tempyprintflag is 2;
			otherwise:
				now tempyprintflag is 3;
		otherwise if mn_localmode is true and mn_temppagecount > 1 and mn_hintmode is false:
			if mn_currentlocalpage is 1:
				now tempyprintflag is 1;
			otherwise if mn_currentlocalpage is mn_temppagecount:
				now tempyprintflag is 2;
			otherwise:
				now tempyprintflag is 3;
		if tempyprintflag is not 0:
			if tempyprintflag is 1:
				now tempmessage is "[mn_next_only]"; [Press N (Next) or the Right / Down arrow key to turn to the next page.]
			otherwise if tempyprintflag is 2: 
				now tempmessage is "[mn_previous_only]"; [Press P (Previous) or the Left / Up arrow key to turn back a page,]
			otherwise if tempyprintflag is 3:
				now tempmessage is "[mn_next_and_previous]"; [Press N (Next), P (Previous) or the arrow keys to turn pages.]
			now printflag is true;
			increment mn_nextlocal;
	if printflag is true:
		if mn_nextlocal is:
			-- 1: now mn_page_one is tempmessage;
			-- 2: now mn_page_one is tempmessage;
			-- 3: now mn_page_two is tempmessage;
	if the mn_endnode_flag is false: [Menu mode]
		now tempmessage is "[mn_escape_A]"; [ESCAPE[if mn_stackpointer > 1] to move back a menu[mn_leapmessage][end if] or X to exit.]
	otherwise: [Local/hint mode]
		now tempmessage is "[mn_escape_B]"; [Press [if mn_bookmode is false]ESCAPE to return to menu[end if][mn_leapmessage]X to exit.]
	increment mn_nextlocal;
	if mn_nextlocal is 2 or mn_nextlocal is 3:
		now mn_page_two is tempmessage; [if this was the first line printed, put it on 2nd line]
	if mn_nextlocal is 4:
		now mn_page_three is tempmessage;
		now mn_preserve_line_three is true;
	if mn_nextlocal < 3:
		now mn_nextlocal is 3;
	now printflag is false;
	if mn_bookmode is true and mn_modes_allowed is not "book only":
		now tempmessage is "([mn_book_mode_off].)"; [Press M to turn Book Mode OFF]
		now printflag is true;
	if mn_bookmode is false and mn_modes_allowed is not "menu only":
		now tempmessage is "([mn_book_mode_on].)"; [Press M to turn Book Mode ON]
		now printflag is true;
	if printflag is true:
		if mn_nextlocal is 3:
			now mn_page_three is tempmessage;
		otherwise if mn_nextlocal is 4:
			now mn_page_four is tempmessage;
		increment mn_nextlocal;
	if mn_bookmode is true and mn_any_hints_present is true and mn_nextlocal is 4: [The 3rd clause in this line is just a legality check. Circumstances should always be such that I avoid lines ever wanting to print beyond the bottom line of the status window in the first place]
		if mn_show_hints_in_bookmode is false and mn_modes_allowed is "both":
			now mn_page_four is "- [mn_no_hints_in_book_mode] -"; [Hint pages do not appear in Book Mode]
		if mn_show_hints_in_bookmode is true:
			if mn_currentbookpage is mn_hints_threshold:
				now mn_page_four is "[mn_hints_on_next_page]";
			otherwise if mn_currentbookpage < mn_hints_threshold:
				now mn_page_four is "- [mn_hints_begin_on] -".


Menus ends here.

---- DOCUMENTATION ----

Chapter: Introduction [Chapter 1]

Based on Emily Short's classic Menus extension, this new Menus extension lets you include a menu system of help, hints and/or other information in your Glulx or Z-Code (Z8) project. This Menus version 5 requires Inform version 6M62 or greater to run.

(AN ALERT IF YOU'RE UPGRADING - In menu systems created with previous versions of Wade Clarke's Menus, your topmost level table was called the 'table of help contents' because it had to be. This system has changed and become more flexible in Menus 5. To connect your old menu content to the new extension you'll just have to add one line of code. Search for 'change log' in this documentation (it's down the bottom) then read the Version 5 / upgrade alert for details.)

The new Menus's most significant advances on classic Menus are as follows:

(1) Onscreen menu options are activated with a single keypress, so there is no need to repeatedly press arrow keys to move a cursor around. This is a much easier control method in general, and friendlier to players using text-to-speech. Another benefit is that transcript clutter is reduced.

(2) A player can exit the menu system at any time with a keypress. Their position within it is bookmarked when they do.

(3) A player can toggle Screen Reader mode, which optimises menu formatting for screen readers.

(4) Your menu system's text content is automatically paginated when the game starts. Players can toggle a book mode in which they can page back and forth through the help system's contents as if using an e-reader. Hints are gathered at the back of the 'book' in this mode, or you can hide them from book mode entirely.

(5) You can customise various aspects of the menu system's appearance and behaviour, and which of its modes are available to the player.

(6) The printed content (apart from debug mode messages) has been isolated to make it easy to adapt the extension for use with projects in other languages.

The code for "Menus" is about 80% new and 20% carried over from Emily Short's original extension. I've also cribbed some of the phrasing of her documentation. This is all with her permission.

Menus uses functions from Emily Short's Basic Screen Effects extension and automatically includes it in your project.

Menus is NOT intended or suitable for contexts in which you want the player to be able to choose a numbered option affecting gameplay (e.g. to create a menu of conversation choices when talking to another character). It is intended for situations where you wish to give the player optional help, hints or other info which can be browsed while playing the game, but which remain separate from it.

Tables created for use with Emily Short's Menus extension can be converted for use with this new Menus without too much hassle. See "Chapter 11: Upgrading classic Menus tables for use with this extension" for details.

The vast majority of variables and say phrases defined by this extension have the prefix 'mn_' (standing for Menus) with the goal of helping avoid namespace clashes with your game's code or other extensions.

* A WORD ABOUT THE DOCUMENTATION

This documentation might seem a little overwhelming at a glance, but don't panic. You don't need to read it from cover to cover. A lot of it is 'look it up as you need it' material. Also, don't forget to try the included example 'Robot Retrievers of the Year 3000'. Once you've seen what it does with Menus, you can look at its code to see how it does it.

Chapter: The menu system described [Chapter 2]

Section: Connecting the menu system to your game [Section 2.1]

The menu system is coded as an activity called 'the displaying activity'. To let the player enter the system, you need to add a command or commands to your game which will 'carry out the displaying activity'. When the player exits the menus, code execution of your game continues on the line after 'carry out the displaying activity', at which point you might want to 'clear the screen' (otherwise the last menu printed will still be visible') and then 'try looking' (to remind players of where they are.)

Here's a code example which creates a command called "help" which will open the menu system then clean up the screen after the player comes back to the game:

	asking for help is an action out of world applying to nothing.

	Understand "help" as asking for help.

	Carry out asking for help:
		carry out the displaying activity;
		clear the screen;
		try looking;

I didn't build this routine into the extension itself because different authors like to use different commands to take players into a menu or hints system, depending on its contents. Some typical commands include: ABOUT, HINT, HINTS, INFO, AUTHOR, CREDITS. Just create your menu-opening commands then point them all to 'asking for help' (or whatever you might have renamed that action.)

Section: The different states the menu system can be in [Section 2.2]

When the player can see a list of numbered (and maybe lettered) menu choices on the screen, the menu system is considered to be in 'menu mode'. When the player is viewing text content or hint pages, the menu system is considered to be in 'local mode'.

There is also a third state which can encompass the entire menu system, called 'book mode'. This is a page-oriented viewing mode which can be toggled on and off by the player. When book mode is off, the player will find him/herself moving back and forth between menu mode and local mode. When book mode is on, the player sees all menu content in local mode.

Section: How menu options are assigned to different keys [Section 2.3]

While the player is browsing the menu system, the first 10 options on each screen are automatically assigned to number keys 1-9 and then 0; this behaviour is hardcoded. After 0, the extension's default behaviour is to continue to assign options using the alphabet keys. 'A' will choose option 11, 'B' will choose option 12, etc... up until 'G' for option 17. After that, various reserved keys are left out of the sequence as we proceed towards 'Z'. All of the keys 'H', 'L', 'M', 'N', 'P', 'Q', 'S' and 'X' are already assigned to contextually-sensitive menu actions. You can reassign these keys (see "Chapter 9: Changing which keys do what") though it's only advisable to do so with a good reason, for instance if you're writing for a language which isn't English. You should make sure that these keys' corresponding actions remain assigned to keys somewhere, or the menu system may be crippled or become non-exitable. The sequence of keys assigned to menu options beyond the ninth is also fully customisable. Again, see Chapter 9 for details.

Section: What menu options can do [Section 2.4]

Each menu option visible during menu mode can produce one (and only one) of the following effects:

1. Display some text to the player. The text can appear as a single page or be divided across as many sequential pages as you wish. We will call the collection of 1+ text pages opened by a single menu option a 'text topic'.

2. Open a hint page. The hint page format allows you to display a series of increasingly specific hints related to a particular puzzle or game subject. When the player first visits a hint page, none of the hints will be visible. By repeatedly pressing 'H', the player can reveal one more hint at a time until all have been revealed. The system remembers which hint the player has reached on any particular hint page if they navigate away from it.

3. Carry out a rule. This might perform any action you program yourself, including making changes to the game state.

4. Open up a submenu. The submenu can in turn contain more text topics, hints, rule launchers and submenus, as per points 1-4 listed here. Submenus can be nested within each other up to 4 times, meaning the maximum allowable content depth at any point in the system is 5 layers.

The structure of menus and other content which make up your menu system can be visualised as a tree diagram, with the Help Menu as the top layer. I've created a sample diagram showing a possible menu structure (consisting only of text topics and submenus) for a simple Dungeons & Dragons style combat game. Unfortunately it is impossible to display the diagram here in the extension's documentation, so I will link you to the file on my personal webspace instead:

http://wadeclarke.com/menus_tree_diagram.png

In the diagram, the asterisked * option names represent submenus while the non-asterisked names represent text topics. The important thing to note is that there are no submenus in layer 5, as this extension only allows menus to be nested 4 times. This reflects the headings structure allowable within Inform 7 source code, which goes Volume, Book, Part, Chapter, Section. If you'd like to, you can think of the Top layer as the Volume, which in turn can contain Books in layer 1, which in turn can contain Parts in layer 2, which in turn can contain Chapters in layer 3, which in turn can contain Sections in layer 4. Layer 5 contains only the content of Sections.

Section: The breadcrumb described [Section 2.5]

As a player navigates the menu system, their position within the menu hierarchy is displayed as a 'breadcrumb trail', which I will simply refer to as the breadcrumb from now on. Using the Dungeons & Dragons tree diagram as an example again, a player viewing the options in the Polearms submenu in layer 4 would see the following breadcrumb displayed above the options:
	
	Combat - Non-Magical - Melee - Polearms

The last item in the breadcrumb is always the name of the text topic, hint page or submenu which is currently open.

Note that the breadcrumb did not start with 'Help Menu'. This is because the player's position in the system is always encompassed by the top layer, so we skip printing the top layer's name just to save space.

The breadcrumb appears at the top of the main window by default, but you can configure it to appear only in the status window, or in both the status window and in the main window, or not at all. Note that allowing the breadcrumb to print in the status window can be risky in general (and doubly risky in a Z-Code project) as a particularly long breadcrumb might print off the edge of the window and look ugly, or like a bug, to the player. See "Section 7.2: A list of the configurable options" for more details on breadcrumb configuration.

Chapter: An overview of the help tables [Chapter 3]

The menu system is defined by a set of tables you will create and fill with your own content. Collectively, these are the help tables. You will need to create another help table for each submenu you add to your system. All of these tables share the same format.

The first table in the system will define your topmost menu content. In other words, it represents the first menu the player will see when they enter the help system. The default table included for this purpose is 'the table of default help contents', and it starts out empty. If you want, you can directly edit this table in the extension, or in a copy of the extension, to create your top level menu. To instead build a new top level table in your own source, copy-paste the 'table of default help contents' to your project and give it a new name. (Just remove the word 'default' if you don't want to think about what to call it.) Then, you must also tell the menu system to use your new table in place of the default extension one. To do this, set the variable 'mn_master_table' to your table's name when play begins. Here's a demonstration:
	
	when play begins:
		now mn_master_table is Wade's new table of helps;

Each table in the help system, including the top level one, is defined by the following seven columns:

	"title (text)", "subtable (table name)", "description (text)", "toggle (rule)", "used (number)", "bookpage (number)", "localpage (number)"

... however the subtable, description and toggle columns are actually optional - this is explained at the asterisked point shortly.

The bracketed parts of the column titles, like (table name), are necessary so that Inform knows what kind of data is allowed to be placed in a column in a case where all entries in that column may start out empty.

When creating a table from scratch, you can start out by copying and pasting the following 3 line template into your source code:

	table of X
	title (text)	subtable (table name)	description (text)	toggle (rule)	used (number)	bookpage (number)	localpage (number)
	--	--	--	--

This template contains the table name, the column names and one empty sample row. Replace the X with your table's name.

Notice how there are actually only four values in the sample row (the four pairs of double dashes, each one signifying an empty table entry and which you can replace with your own data as necessary) even though there are seven columns in the table. This is because when your game boots up, the extension fills all of the used, bookpage and localpage entries in every help table with internal bookkeeping data. If you leave these columns at the right edge of each help table, you spare yourself the need to type any values into them - and in fact you shouldn't type any values into them.

In the case of the first four columns - title, subtable, description and toggle - whenever you don't have to put a value into them for a particular row of a help table, they should be left containing the double dashes which signify their emptiness. Unlike the used, bookpage or localpage columns, they can't be left entirely blank.

* One rule trumps this 'double dash' rule, and it's that if any of the subtable, description or toggle columns is completely empty in a particular table, that whole column can be removed from the table. This feature is just a convenience; you don't ever have to remove any of these columns if you'd find it inconvenient or confusing to do so, but removing them where they are unused can make your tables easier on your eye.

So here's a summary of these rules:

(a) The title, used, bookpage and localpage columns are mandatory in every help table.

(b) The used, bookpage and localpage columns should be placed at the right edge of each table. If you do this, you can always leave these columns entirely blank.

(c) If any or all of the subtable, description or toggle columns are totally empty in a particular table, those columns can be removed from or left out of the table if you want.

(d) Whenever an entry in an existing subtable, description or toggle column is going to be left empty, you should put a double-dash in for that entry. You can't just leave it blank.

These help tables can be quite wide on the screen even when they're empty, and can become more confusing to look at when you start putting lots of information into them. If you ever become confused by the formatting, my advice is to temporarily widen your Inform source code window as much as you can. This can allow the tab characters in the tables to align themselves better and thus make it more clear what is where in the table. You might find this useful as you consider examples included in these instructions, too.

With the used, bookpage and localpage columns out of mind, that leaves you with four columns of information you'll need to work with to create your menu content. Here is a quick summary of what kind of data will go into these important columns:
	
"Title" will most often contain the name of the option we want the player to see: "Credits", "About This Game" and so on. The exceptions to this are when you are creating a multi-page text topic or a hint page with more than one hint. (Exceptions explained in "Section 4.1: How to enter text (and WHY DIVIDE A TEXT TOPIC INTO PAGES?)"). Also note that you should never give two or more options in any one table the same title. Doing so could cause cause erratic behaviour, runtime errors or crashes.

"Subtable" is most often used to create a submenu. This column holds the name of the table that specifies the submenu. There is one other use for this field which only applies when you are creating a hint page. (This other use explained in "Section 4.2: How to enter hints")

"Description" is text that will be printed when a text or hint option is selected. You can fill it in with as much prose as you like. Each page of text in a multi-page topic or each new hint on a hint page will have its own row in the table and its own Description field.

"Toggle" can hold the name of an Inform rule which will be carried out when an option is chosen. In theory, this rule could be absolutely anything. In practice, the feature is mostly useful for giving the player a table of setting options which he/she can toggle on and off. (Explained in "Section 4.3: How to enter rules")

Chapter: Entering your data into the help tables [Chapter 4]

Below I describe from first principles how to enter the data for each of the 4 aforementioned kinds of menu option (text, hints, rules, submenus) into the help tables. You can mix any or all of the different option kinds within an individual table so long as you respect the formatting rules for each kind in the process.

Section: How to enter text (and WHY DIVIDE A TEXT TOPIC INTO PAGES?) [Section 4.1]

To enter a single page of text into the table, or to create the first page of a multi-page text topic, put the menu option's name in the title column and then the text that you want printed in the description column. For instance, if you started filling out the table of default help contents like this...

	table of default help contents
	title (text)	description (text)	used (number)	bookpage (number)	localpage (number)
	"Credits"	"'Rocket Scientists' was written and programmed by Hermione Quigley."

...you'd be making the first option in it 'Credits', and a player who selected that option would then move to a page of text which says ''Rocket Scientists' was written and programmed by Hermione Quigley.' This page constitutes a text topic with a length of 1 page. Notice that I didn't have to put in a subtable or toggle column because this table doesn't use either of them and they're optional. (These rules about what's mandatory to include and what's optional are described in full in "Chapter 3: An overview of the help tables").

If you want to create a text topic with multiple pages, you do so by adding another row to the table for each page after the first, entering "page" into the title column of each extra row and entering the corresponding page's text content in the description column.

So, expanding on the 'Credits' example, I will now turn Credits into a topic with 3 pages, and I will also place a new single page topic after it, one called 'Steering your rocket sled':

	table of default help contents
	title (text)	description (text)	used (number)	bookpage (number)	localpage (number)
	"Credits"	"'Rocket Scientists' was written and programmed by Hermione Quigley."
	"page"	"Germaine Kleinhenz drew the beautiful cover art."
	"page"	"John Smith and Mo['] Spudney tested the game and helped me find all the bugs."
	"Steering your rocket sled"	"When you're riding on your sled, type LEAN LEFT or LEAN RIGHT to start turning in the corresponding direction."

This example creates a top level menu with 2 options: 'Credits' and 'Steering your rocket sled'. After choosing the Credits option, the player would be presented with page 1 of the 3 page text topic you've created. The menu system would then let them know they can turn pages within the topic by pressing various keys. 'Steering your rocket sled' is a new topic with just 1 page, and the purpose of its inclusion in the above example is to demonstrate that you don't have to do anything special to signal the end of a multi-page topic in a table. As soon as the menu system encounters a row in the table whose title field is not "page", it knows that the multi-page topic has ended and that it's now dealing with a new menu option.

You can put as many pages into a multi-page topic as you want. If you are unsure about the use or purpose of the feature of dividing a text topic into pages, I have some suggestions below:

WHY PAGINATE? aka WHY DIVIDE A TEXT TOPIC INTO PAGES?

In the Credits example, I deliberately made the amount of text on each of the 3 pages very small just for the sake of making the code easy to read in this documentation. In a real game's menu system I probably wouldn't split those 3 lines across 3 pages. But when you do want to put lots of text in one topic, for instance, a dump of instructions explaining your game's special commands, this is where pagination can come in handy to improve the player's experience.

Recall that when a game produces more text in an instant than can fit on the user's screen, it will stop printing and prompt the user to continue with a keypress. After the keypress, the user will need to manually scroll back to see the text that went off the screen. This is fine during gameplay, but when a player is reading extra-game content, even the appearance of the 'more' prompt can send a psychological signal to the player that you've dumped too much information on them. 'You want me to take in all these instructions, and they don't even fit on the screen?' Of course, you have no real control over the size of the user's game window, but a good basic use of the pagination feature would be to simply divide up really big blocks of text into smaller blocks. The smaller blocks will be less likely to trigger 'more' prompts, and players will find the information easier to consider and less confronting after it's been intelligently divided up into multiple pages, each of which is far more likely to fit into their game window.

Another possible use for the pagination feature is to duplicate the page structure of previously written content that you're moving into your game. For instance, if your game has a written manual, or you're porting a game to Inform which has a written manual, it's possible to reproduce that manual's chapter and page structure verbatim within the game itself using Menus's pagination and submenu features, effectively including the manual in the game in readily readable form.

Section: How to enter hints [Section 4.2]

To enter the first (or only) hint of a set of a hints into a help table, put the name of the menu option leading to the hint(s) in the title column and put the text of the first hint in the description column. Also, for this first hint on a particular subject, you must put "table of hinting" in the subtable column. For instance, if you started off the table of default help contents like this...

	table of default help contents
	title (text)	subtable (table name)	description (text)	used (number)	bookpage (number)	localpage (number)
	"Getting past the troll"	table of hinting	"Trolls hate birds."

...you'd be making the first option in it 'Getting past the troll', and a player who selected that option would then move to a hint page where they could reveal the only hint on the topic, 'Trolls hate birds', by pressing H.

The significance of placing 'table of hinting' in the subtable column is that it signals to the menu system that this row in the table contains a hint, not a text page, and also that it is the first hint on its subject. Initial text pages and hint pages would otherwise be indistinguishable, as they would both consist of a title entry paired with a description entry. The table of hinting itself is not a table you ever have to edit or even look at, and its presence here will not open a submenu; it exists merely to act as a signal to the menu system in the circumstances just described.

Most often you will want to provide more than one hint on a particular subject. The method of adding further hints is similar to the method of adding additional text pages to a text topic. You add more hints by adding another row to the table for each hint after the first, entering "hint" into the title column of each row and entering the corresponding hint's text content in the description column.

In the following example, I extend the Troll example out to offer 5 increasingly specific hints in total, with the last hint being the explicit solution to the puzzle:

	table of default help contents
	title (text)	subtable (table name)	description (text)	used (number)	bookpage (number)	localpage (number)
	"Getting past the troll"	table of hinting	"Trolls hate birds."
	"hint"	--	"Have you seen any birds around?"
	"hint"	--	"There are some birds near the pirate's house."
	"hint"	--	"The parrot is tame."
	"hint"	--	"Take the parrot to the troll bridge."

Note that a set of hints on one topic like this ('Getting past the troll') is grouped together into a single page for pagination purposes. When the player visits that page, they will be told they can press 'H' to reveal hints one by one. Also note that you should NOT mention the 'table of hinting' again in rows of data for hints beyond the first one on a particular subject.

Once you've got a multi-hint page going in a help table, the menu system will know that this hint topic has ended as soon as it encounters a row in the table whose title entry is not "hint", or if it reaches the end of the table.

Section: How to enter rules [Section 4.3]

To connect a menu option to a rule that will be carried out when the player chooses it, put the menu option name in the title column and put the rule in the toggle column.

In theory, this rule could be absolutely anything, but in practice, the feature is mostly useful for allowing the player to toggle game configuration options. As an example, here is a top level menu containing one option which toggles the game's score notification on or off each time it is chosen. The option itself is written so that it always describes the switch's current position:

	table of default help contents
	title (text)	description (text)	toggle (rule)	used (number)	bookpage (number)	localpage (number)
	"Score Notification is [if notify mode is on]ON[otherwise]OFF[end if]"	--	switch notification status rule

The rule cited here (switch notification status rule) and the deciding phrase (if notify mode is on) don't exist in Inform by default, so they would also need to be coded to make this menu option functional. You'd need to add the following code to your game:

	To decide whether notify mode is on:
		(- notify_mode -);

	This is the switch notification status rule:
		if notify mode is on, try switching score notification off;
		otherwise try switching score notification on;

Section: How to create submenus [Section 4.4]

To create a submenu within the current menu, put the title of the submenu in the title column, then put the name of the table which will specify the submenu's contents in the subtable column.

Here's an example:

	table of default help contents
	title (text)	subtable (table name)	used (number)	bookpage (number)	localpage (number)
	"Magic Spells"	table of magic spells

This example places a submenu called 'Magic Spells' in the top level menu. Note again that I left out columns which are optional and which went unused in this particular table: description and toggle. The contents of the Magic Spells submenu must now be specified by a new table, which in this case I have unsurprisingly called 'table of magic spells'. When the player chooses the Magic Spells option, they will enter the menu defined by the table of magic spells.

You should only link to any particular table once in your help system. The extension isn't set up to handle a situation where two or more more options lead to the same submenu, and it could lead to erratic behaviour, runtime errors or crashing.

Section: If you include more than 30 tables in your help system, read this [4.5]

Menus needs to keep track of all the tables used by your menu system. It does so by scanning them at boot time and storing their names in a table called the 'table of pagey menus'. You will find this table in section 5 of this extension's code. The table starts out with 30 empty rows in it by default. Normally you never have to interact with this table yourself, but if you end up including more than 30 tables in your system -- which is no problem, you could theoretically include hundreds -- you will need to change the line below the table which currently says "with 30 blank rows" to a higher number. There need to be at least as many blank rows in the table of pagey menus as you have help tables in your system, excluding the topmost level table. So if you ended up using 45 help tables in total (the table of default help contents plus 44 other tables) the line would need to say 'with 44 blank rows' (at least) for your menu system to be able to compile.

Chapter: The limits of the menu system [Chapter 5]

You must format all tables in your help system using the instructions set out in "Chapter 4: Entering your data into the help tables". This is true whether you're creating the top level table, or a submenu, or a submenu within a submenu within a submenu, etc.

Don't create two or more options leading to the same submenu. The extension isn't set up to handle such cases and they're likely to cause erratic behaviour, runtime errors and crashes.

Don't give two or more options in any one table the same name. By name, I mean the text entered into the title column to describe the option to the player. Doing so could cause cause erratic behaviour, runtime errors or crashes.

Don't call any of your tables 'table of hinting'. This table already exists in the extension and its name is reserved. This mistake is easy to catch because your game won't compile, but will instead complain about how this table exists.

Menus can't be nested inside each other more than 4 times. If you try to do this, the extension will alert you to the problem when you boot your game.

If you add more than 30 help tables to your game, you will need to make room for them by adding extra rows to the table of pagey menus. (See "Section 4.5: If you include more than 30 tables in your help system, read this".)

If you have more than 999 book mode pages in your menu system (!) and are displaying the book page count in the status window, the count won't fit unless you make extra room for it. In section 1 of the extension code is the 'rule for displaying' whose first line is 'now right alignment depth is 12'. Each time you add 2 to the depth number in this line, you'll get another digit's worth of page numbers which can fit on the screen. So by setting a right alignment depth of 14, you can display a count going up to 9999 pages. Set a depth of 16 and you can go up to a ridiculous 99999 pages.

There is also an overall soft structural limitation on the menu system. Given that all menu options must be selectable with one keypress, you can't have more options in a single menu than you have keys on your keyboard. More realistically, you're likely to want to stick to using the regular alphanumeric keys 1-9, 0 and A-Z. Considering the default key assignments, it you take away from the 1-9, 0 and A-Z set the keys assigned to menu controls, that leaves you with a soft limit of 28 options for any one menu, where option 28 is assigned to 'Z'. Options in a menu for which no keys remain simply won't appear onscreen.

In the default setup:

* L 'leaps' to the top of the menu system (or to page 1 when in book mode. (See Chapter 6 for a description of book mode)

* P (for Previous) goes back a page when in local mode

* N (for Next) goes forward a page when in local mode

* S (for Screen reader) toggles special formatting intended to help players using screen readers

* X (for Exit) immediately takes the user back to the game

* The arrow key pairs (up and down, left and right) also page backwards and forwards respectively in local mode

* ESC or Q take the player back a menu. Q is provided as an alternative to ESCAPE because on some mobile devices, there is no ESCAPE key.

Chapter: Book mode and the startup scan [Chapter 6]

Section: Book mode and the behaviour of the startup scan [Section 6.1]

Book mode is a viewing mode the player can toggle on or off at almost any time as they browse through your menu system (unless you either force or prohibit book mode -- see mn_modes_allowed in "Section 7.2: A list of the configurable options"). When book mode is on, the contents of the help system will appear to the player as if they were pages of a book, with the following two exceptions:

1. Rules never appear in book mode.

2. Hints can be set to appear at the back of the book, where they will be found gathered together, but by default they do not appear at all (in order to guard against even the most minor of spoiler accidents by the most conservative of standards - though players always have to press H to reveal the first hint of a set, anyway). To have hints appear at the back of the book in book mode, set the 'mn_show_hints_in_bookmode' variable to 'true' (see mn_show_hints_in_bookmode in "Section 7.2: A list of the configurable options"). 

The player can see the total page count of the book and the number of the page they're currently reading by glancing to the top right corner of the screen. Navigation in book mode consists of turning the pages one at a time. The player does this by using the arrow keys and/or the Next and Previous menu commands (assigned to 'N' and 'P' respectively in the default setup). If hints are being shown in book mode, a permanently displayed message tells the player on which page they will commence, with an extra warning displayed when the player is only one page away from them.

For the exact details of how Menus decides which page to display next when the player toggles book mode, see "Section 6.2: What happens when book mode is toggled on or off?".

The breadcrumb still appears in book mode because it still provides useful information, even in the absence of submenu-style navigation. Just as you may find it handy to see the name of the chapter you're reading in a textbook at the head of each page, and perhaps the name of the current subsection within that chapter, the breadcrumb acts similarly as a page header in book mode.

If the player switches book mode off, their current position within the menu hierarchy is reconstructed, and they will again be able to perform actions like going back a menu level or leaping to the top level menu from their current position. This is all made possible by a startup scan Menus carries out of your entire menu system when the player boots the game. The scan records the menu system's structure and assigns every page within it a page number for use in book mode.

During the scan, each page of a text topic becomes 1 book page. Each set of hints devoted to a single topic becomes 1 book page, and that page is attached to the end of the book after all non-hint pages have been scanned. Submenus aren't used for navigation in book mode and therefore occupy no pages. The important thing to note is that any rule options you've placed in your menu system (i.e. those created by entering a rule name in the 'toggle' column) have NO presence in book mode; they are not paginated and they won't appear. This is because book mode is intended to present read-only contents in the manner of a book. If your menu system consists of nothing but rule options, book mode will be force-deactivated at boot time.

Handily, the startup scan doubles as a free troubleshooting pass over your help tables. It won't catch every tabling mistake that could ever be made, but it will catch some of the major ones that would muck up your menus, and it will halt the process if it does strike one of these. You will also be told what the problem was and which table caused it.

To see the details of your startup scan as it happens, turn on Menus's debug mode. (See "Section 7.2: A list of the configurable options" for details on debug mode.)

Section: What happens when book mode is toggled on or off? [Section 6.2]

When the player turns book mode ON, Menus does the following:

* If the player is in menu mode, Menus's goal is to take them to a book page with text content (either a text page or a hint page) which is 'closest' to the currently visible menu options -- ideally, the first local page of the first menu option. Menus will run through the current menu from the top in search of the first option that doesn't lead to a rule. If the option leads to a text topic, Menus drops the player on the first page of that topic. If the option leads to a submenu, Menus will open that submenu and restart the scan. If the option leads to a hint page, what happens next depends on whether or not you're hiding hint pages from the player in book mode (see mn_show_hints_in_bookmode in "Section 7.2: A list of the configurable options"). If you aren't hiding them, Menus drops the player on the hint page. If you are hiding them, Menus recalls which non-hint book page was the last one it passed during the startup scan before encountering the hint page, and drops the player there.

* If the player is in local mode and they're viewing a text topic, their position already correlates exactly to a book page, so Menus just leaves them where they are. If they're viewing a hint page, Menus proceeds as it would if the player was coming from menu mode, leaving the player on the hint page if you're allowing hints to appear in book mode, or taking them to the nearest non-hint page detected during the startup scan if you're not.

When the player turns book mode OFF, Menus does the following:

* If the currently displayed book page is part of a text topic, the player stays on it. Then the player's position in the menu hierarchy is reconstructed.

* If the currently displayed book page is a hint page, the player will stay on it if you're allowing hints to appear in book mode, or be taken to the nearest non-hint page detected during the startup scan if you're not. Then the player's position in the menu hierarchy is reconstructed.

Chapter: Configurable options of the menu system [Chapter 7]

Section: Using configurable options [Section 7.1]

There are many options available for customising aspects of the menu system's appearance and behaviour. Each option is controlled by the state of a variable, and each variable has a default value. If you want to set one or more variables to a non-default position, an easy way to do so is by adding a 'When play begins' rule to your game and putting your variable setting instructions in it. For instance, here is a code example which turns on the extension's debug mode, disallows book mode and positions the breadcrumb in the status window:
	
	When play begins:
		now mn_debug is 1;
		now mn_modes_allowed is "book only";
		now mn_breadcrumb_preference is "status";

Section: A list of the configurable options [Section 7.2]

Here is a reference list of all of the configuration variables:

---

VARIABLE: mn_debug
(a number variable)

The default value is 0, meaning debug mode is off.

Debug mode is intended to help you troubleshoot the construction of your help tables.

Set this variable to 1 to turn on regular debug mode, which gives you details of the pagination process during the startup scan, followed by a summary list of all the tables in your menu system and their paths in the hierarchy.

E.G.:

	When play begins:
		now mn_debug is 1;

Set this variable to 2 to receive even more detailed tabling information during the pagination process.

(Don't forget to turn debug mode off before compiling your game for regular players.)

---

VARIABLE: mn_master_title
(a text variable)

The default value is "HELP MENU".

This variable stores the printed name of your help system as a whole. The name appears in the top-left corner of the status window. You can change the text of the variable to whatever suits you.

E.G.:

	When play begins:
		now mn_master_title is "GRODY'S ADVENTURES IN BLUEGRUB LAND: GET YER HELP HERE!";

If you want no title to appear, just blank out the variable.

E.G.:
	
	When play begins:
		now mn_master_title is "";

---

VARIABLE: mn_master_table
(a table name variable)

The default value is the table of default help contents.

This variable stores the name of the table that functions as the top level of your menu system. By default it's 'the table of default help contents', which is present in this extension and starts out empty. If you edit that table directly in the extension to create your top level table, you can leave mn_master_table as is.

A more convenient option may be to build your own top level table in your project source and then to direct the extension to use your table as the new top level one. You do this by storing the name of your table in mn_master_table when play begins.

E.G.:

If you make your own top level table and call it 'the table of supreme information', you'd just add a rule like this to point to it:
	
	when play begins:
		now mn_master_table is the table of supreme information;

---

VARIABLE: mn_master_title (a text variable)

The default value is "HELP MENU".

This variable stores the printed name of your help system as a whole. The name appears in the top-left corner of the status window. You can change the text of the variable to whatever suits you.

E. G.:

When play begins:
     now mn_master_title is "GRODY'S ADVENTURES IN BLUEGRUB LAND: GET YER HELP HERE!";

If you want no title to appear, just blank out the variable.

E. G.:

When play begins:
     now mn_master_title is "";

---

VARIABLE: mn_modes_allowed
(a text variable)

The default value is "both".

This variable controls which viewing modes you will allow a player to use to view your menu content. There are two modes which this variable governs: menu mode and book mode.

On the default setting of "both", both modes are allowed, meaning the player starts off in menu mode at the top level menu, and can toggle book mode on or off whenever they want as they browse.

A setting of "menu only" prohibits the player from switching to book mode, and hides the controls for doing so.

E.G.:
	
	When play begins:
		now mn_modes_allowed is "menu only";

A setting of "book only" will start the menu system off in book mode and not allow the player to switch out of it, hiding the controls for doing so. If your menu system contains nothing but rules, this setting will be overridden when your game boots up because there would be no book page content for a player to view.

---

VARIABLE: mn_show_hints_in_bookmode
(a truth state variable)

The default value is false.

This variable determines whether the player will see hint pages when viewing your menu content in book mode. The default choice of false means that they won't; the hint pages simply won't be paginated as part of the book.

If you set mn_show_hints_in_bookmode to true, players will be able to access hint pages in global mode, but to help guard against spoiler accidents, the hint pages will all appear at the back of the book, regardless of their position in the menu mode hierarchy. The player is also informed about which page the hints start on, and receives an extra warning when they're only 1 page away from the hints.

E.G.:
	
	When play begins:
		now mn_show_hints_in_bookmode is true;

The value of this variable is irrelevant when mn_modes_allowed is set to "menu only". Also note that if mn_modes_allowed is set to "book only", leaving mn_show_hints_in_bookmode set to false will render any hint pages completely inaccessible.

---

VARIABLE: mn_bookpageshow
(a truth state variable)

The default value is true.

This variable determines whether the current book page number and total page count are displayed in the top-right corner of the status window when book mode is on.

Set the variable to false to stop these numbers from appearing in the status window.

E.G.:
	
	When play begins:
		now mn_bookpageshow is false;

The value of this variable is irrelevant when mn_modes_allowed is set to "menu only".

---

VARIABLE: mn_localpageshow
(a truth state variable)

The default value is true.

This variable determines whether the current local page number and page count are displayed in the status window when viewing a multi-page text topic.

Set the variable to false to hide these values.

E.G.:
	
	When play begins:
		now mn_localpageshow is false;

---

VARIABLE: mn_breadcrumb_preference
(a text variable)

The default value is "main".

This variable determines whether the breadcrumb is displayed on the screen, and if it is, where. The possible positions are at the top of the main window, in the top-left corner of the status window or in both of these positions.

The default setting of "main" puts the breadcrumb at the top of the main window only.

A setting of "status" puts the breadcrumb in the top-left corner of the status window only.

A setting of "both" puts the breadcrumb in both of the above-mentioned positions.

A setting of "off" completely hides the breadcrumb.

E.G.:
	
	When play begins:
		now mn_breadcrumb_preference is "both";

N.B. Don't forget that allowing the breadcrumb to print in the status window is risky in general, and doubly risky in a Z-Code project. Here's why: In both Glulx and Z-Code projects, a particularly long breadcrumb might print off the edge of the window, which could look ugly or like a bug to the player. This is because the status window doesn't have automatically wrapping text like the main window does. In Z-Code, there is a second problem. The Z-Code status window will not accept text strings longer than 62 characters in its central column, and will report a VM Print Buffer or Overflow Error if we try to print any there. The error messages won't crash your game, but they will be visible to a player and they might also entirely replace the text you intended to print, depending on which interpreter the player is using. Therefore I strongly recommend against allowing a breadcrumb in the status window if you are compiling a Z-Code project. And if you're thinking of allowing a breadcrumb in the status window in a Glulx project, test how it looks at all levels of your menu system to make sure the results don't disturb you. Also, don't forget that a player's interpreter window might not be as wide as yours.

---

VARIABLE: mn_hinthelp_preference
(a text variable)

The default value is "both".

This variable determines where the hint page help messages ( "Press H to reveal another hint", "You have revealed all the hints on this page" etc.) appear when the player is reading a hint page. Possibilities are in the main window beneath the most recently displayed hint, up in the status window or in both these positions.

A setting of "main" puts the messages in the main window.

E.G.:
	
	When play begins:
		now mn_hinthelp_preference is "main";

A setting of "status" puts the messages in the status window.

The default setting of "both" puts the messages in both of the above-mentioned positions.

---

VARIABLE: mn_show_pagefooter
(a truth state variable)

The default value is true.

This variable determines whether a dashed line (or some other ascii design) is displayed at the bottom of every text and hint page. The footer is intended to give a clear visual signal to the player of the position of the bottom of the page. The author can define the text string to be displayed using the mn_footerdesign variable.

Set this variable to false to stop these page footers from being printed.

E.G.:
	
	When play begins:
		now mn_show_pagefooter is false;

---

VARIABLE: mn_footerdesign
(a text variable)

The default value of "[bold type]------------------------[roman type][line break]" prints a line of bold dashes.

This variable contains the text string to be printed at the bottom of text and hint pages when mn_show_pagefooter is set to true. You can change mn_footerdesign's value to whatever you want your footer to look like. It could be purely decorative or you might want to put a phrase in there.

E.G.:
	
	When play begins:
		now mn_footerdesign is "*>>>- - -  -  -  -  - - -<<<*";

Note that the footer design will never be displayed when Screen Reader mode is on, regardless of the setting of the mn_show_pagefooter variable.

Chapter: Screen Reader mode described [Chapter 8]

Inform's text display throws up a couple of issues for players using screen readers. These issues can be minor or major in effect depending on the particular game:

1. Text in the status window is typically not read out every turn. Players may need to manually switch to and select the status window to have its contents read.

2. Excess punctuation used as visual emphasis (for instance, a line of hyphens used to divide text or as a footnote decoration) might be read aloud to no advantage.

Since Menus's context-sensitive instructions appear in the status line, their default position is inconvenient for screen reader users. This is where Screen Reader mode comes in. An instruction visible in the main window at the top level of your menu systems lets players know they can toggle this mode by pressing 'S'. Once it's on, the status window is minimised for as long as the player remains in the menu system, all the context-sensitive instructions and headings/breadcrumbs appear in the main window instead of the status window, and the menu system footer decoration is temporarily deactivated, if it was on. This way, players using screen readers will automatically hear all the important information every turn without having to manually check the status window. A player who later decides they know the menu instructions well enough or is just weary of hearing them can toggle the mode off again.

Note that while the 'how to toggle screen reader mode' message only appears on the first page of the menu system for screen space-saving reasons, the mode can be toggled by the player at any time while in the menus.

The only configurable options which are truly overridden by Screen Reader mode are the ones relating to the page footer. The footer will never appear while Screen Reader mode is on. Any other options you have set concerning the presence or absence of certain features (the breadcrumb, book mode, etc.) are all respected as usual while Screen Reader mode is on.

Chapter: Changing which keys do what [Chapter 9]

In section 3 of the extension code are the two tables which define all of the default keys used to control the menu system. The Table of Menu Commands stores the keys which trigger the contextually sensitive menu actions. The Table of Extra Menu Choices stores the keys which will be assigned consecutively to menu options beyond the ninth one in any particular menu. The latter table's 'choice' column stores the number of the option a particular key will trigger.

Regular letter and number keys are stored in the tables by their ascii/zscii number. Function keys (e.g. the arrow keys) are represented by values you won't be able to easily predict in either Glulx or Z-Code without using a test program to display them. Fortunately, the values of the safest of such keys are already in the table. It's generally unwise to assign menu options to more obscure function keys because those keys may not be available in all contexts. Remember that your game is running on a virtual machine which in turn might end up running on something like a mobile phone or iPad served by a limited virtual keyboard.

So to change keys or add new ones, simply add their numbers into the table in the relevant rows. Note that in the case of letter keys, it's necessary to add the ascii code for both the upper and lowercase versions of the key as separate entries, and that the uppercase entry should appear in the table ahead of the lowercase one. Also note that where the Z-Code and Glulx values for the same function key are different, Z-Code-only values should be added to the table continuation in Section 3.1 of the extension, which only compiles in Z-code projects, and Glulx-only values should be added to the table continuation in Section 3.2 of the extension, which only compiles in Glulx projects.

When a player presses a key while browsing your menus, the extension searches for the key in the Table of Menu Commands before it searches for it in the Table of Extra Menu Choices. Therefore, don't list a key in both menus or it won't function in some situations.

If you change any values in the Table of Menu Commands (not recommended without good cause) you will also need to change the instructional messages which appear in the Status Window so that they refer to your new keys. The way to do this is explained in the next chapter.

Chapter: Customising the extension's printed messages [Chapter 10]

If you are using this extension in a non-English language project, you will want to change the instructional messages printed in the status window. Another reason you might need to change them is if you alter any of the keys used to navigate the menu system or choose options. All of the messages printed by the extension (except the debugging ones) have been gathered together in section 4 of the extension's code, "Printed Messages". Just go through the 'say' phrases listed there and alter any text strings as needed.

While you're making your changes, try not to alter the punctuation of the phrases. (I appreciate this may be a hard or impossible rule to abide when translating between languages!) By punctuation, I mean the presence or absence of periods or spaces in the say phrases, both amongst the words and especially at the start or end of lines. If the punctuation is changed, words might run together or appear with unnecessary gaps between them when they're printed in the status window.

One more thing -- If your project is going to be in Z-Code format, don't forget that the total length of a line printed to the status window's central column cannot be greater than 62 characters. Lines exceeding this length will trigger a runtime error message which will appear either alongside or instead of the message you wanted to print. This is why you will see shorter, Z-Code specific versions of some of the instructional message elements amongst the say phrases. They ensure that none of the default messages will be more than 62 characters long if the host project is compiled to Z-Code.

Chapter: Upgrading classic Menus tables for use with this extension [Chapter 11]

In writing this extension, I tried to make it as compatible as possible with Emily Short's Menus, but the introduction of the pagination features meant I had to change the table structures. The hints mechanism underwent the most drastic changes. Bringing what used to be called a hint booklet into the new system as a hints page will require manual copying and pasting of individual hint messages, but tables containing other data types - regular text entries, rule launching entries (the ones using the toggle column) and entries pointing to subtables – can mostly be copy-pasted in their entirety for use with Menus, though you will need to add a few new columns to them.

Here's how to go about converting a set of classic Menus tables for use with new Menus:

1. You need to point the extension to the table which defines your top level menu by setting the mn_master_table variable when play begins. For example, if your top level table is called 'the table of helpfulness', add a rule like this to your source:
	
	when play begins:
		now mn_master_table is the table of helpfulness;

2. A new Menus help table has the same columns a classic one had, plus three additional columns titled "used", "bookpage" and "localpage". You don't have to type any data into these new columns because they're filled out by the extension at boot time for internal bookkeeping purposes. However, the new columns must be present, and they should be the three rightmost columns in each table. You may find that the other columns in your classic tables are listed in a different order to the one I've used throughout this documentation, but the relative left-right order of those ones doesn't matter to Inform. All the program cares about is that they're present.

So for any regular classic Menus tables (i.e. which aren't hint booklets) you can copy and paste them wholesale into your new project, then add the 3 missing column titles to the right side of each table.

If any of the description entries in the classic tables are especially long, you may also want to take advantage of the new Menus's pagination features and split that text across more than one page. Methods for creating multi-page text topics are described in "Section 4.1: How to enter text (and WHY DIVIDE A TEXT TOPIC INTO PAGES?)".

Coming up is a before and after example of a table conversion from classic to new which demonstrates all of the changes mentioned above. (Note that in this case you would still have to supply both the 'Table of Setting Options' and 'Table of Hints' yourself after converting the classic table. They are not included in the example.):

Before:

	Table of Options
	title	subtable	description	toggle
	"Introduction to [story title]"	a table-name	"This is a simple demonstration [story genre] game."	a rule
	"Settings"	Table of Setting Options	--	--
	"About the Author"	--	"[story author] is too reclusive to wish to disseminate any information. Sorry."	--
	"Hints"	Table of Hints	--	--

After: (I changed the menu title to 'table of new help contents' because this was the top level menu table.)

	table of new help contents
	title	subtable	description	used	bookpage	localpage
	"Introduction to [story title]"	--	"This is a simple demonstration [story genre] game."
	"Settings"	Table of Setting Options	--
	"About the Author"	--	"[story author] is too reclusive to wish to disseminate any information. Sorry."
	"Hints"	Table of Hints	--

In this example's case, I must also let the extension know what the new top level table is, like so:
	
	when play begins:
		now mn_master_table is table of new help contents;

Notice how empty entries in both the subtable and description columns have been filled with double dashes, but that no data has been typed into any of the used, bookpage or localpage columns. Also, because there were no real entries in the toggle column of the classic table (the one saying 'a rule' was just a placeholder to indicate what kind of data would go in the column) it was unnecessary to even include that column in the updated table. HOWEVER you can never leave out any of the used, bookpage or localpage columns in a new Menus table. See "Chapter 3: An overview of the help tables" for the full details on what it's mandatory to include in a table, and what you can get away with leaving out and when.

3. In the classic Menus extension, lists of hints on one subject were called hint booklets and were defined by tables with their own simple format. In new Menus, hints are grouped into hint pages and share the same table format as all other help tables, so the separate format is no longer supported. The contents of any classic hint booklet tables must be manually copied, pasted and incorporated into your new Menus structure.

Coming up is an example in which I will collapse an classic Menus hints system comprised of three tables into one new Menus table which has the same effect. The first of the classic tables defined a top level menu which opened onto the other two tables, which defined hint booklets. The methods for formatting hint data in help tables are fully described in "Section 4.2: How to enter hints".

First, here are the three classic tables:

	Table of Hints
	title	subtable	description	toggle
	"How do I reach the mastodon's jawbone?"	Table of Mastodon Hints		""	hint toggle rule
	"How can I make Leaky leave me alone?"	Table of Leaky Hints	""	hint toggle rule

	Table of Mastodon Hints
	hint	used
	"Have you tried Dr. Seaton's Patent Arm-Lengthening Medication?"	a number
	"It's in the pantry."
	"Under some cloths."	

	Table of Leaky Hints
	hint	used
	"Perhaps it would help if you knew something about Leaky's personality."	a number
	"Have you read the phrenology text in the library?"	
	"Have you found Dr. Seaton's plaster phrenology head?"	

Now, here is a complete new Menus version of the same material:

	table of default help contents
	title (text)	subtable (table name)	description (text)	used (number)	bookpage (number)	localpage (number)
	"How do I reach the mastodon's jawbone?"	table of hinting	"Have you tried Dr. Seaton's Patent Arm-Lengthening Medication?"
	"hint"	--	"It's in the pantry."
	"hint"	--	"Under some cloths."
	"How can I make Leaky leave me alone?"	table of hinting	"Perhaps it would help if you knew something about Leaky's personality."
	"hint"	--	"Have you read the phrenology text in the library?"
	"hint"	--	"Have you found Dr. Seaton's plaster phrenology head?"

Again, note how I was able to entirely dispense with the toggle column from the classic table because after the translation to the new format, no standalone toggle entries remained that would need to go into it.

Chapter: Change log, credits and contact info [Chapter 12]

Version 5 (for Inform 6M62 and onwards)

- A major user-friendliness improvement is that the extension now compiles out of the box. With previous versions, if you had included the extension in a project but had yet to create or edit the 'table of help contents', the project wouldn't compile and you'd get unintuitive error messages.

- To support the compilation feature, I added a new variable: mn_master_table

The new default top level menu is the 'table of default help contents'. It's included in the extension and you can modify it in place if you want. If you use this approach, you don't have to touch mn_master_table.

The alternative is to create your own top level table (with any new name you like) in your source and then set mn_master_table to point to it 'when play begins'.

For example, you could make a top level table called 'the table of supreme information', and add a rule like this to cue it:
	
	when play begins:
		now mn_master_table is the table of supreme information;

UPGRADE ALERT - In menu systems created with older versions of Menus, your topmost level table was called the 'table of help contents' because it had to be. To get such a menu system working in Menus 5, just point the extension to your top level table by adding the following code to your source:

	when play begins;
		now mn_master_table is the table of help contents;

Version 4 (for Inform 6L38 and onwards)

- Version 4 marks the extension's debut appearance in the Inform 7 Public Library. Version 4 adds digit 0 to the list of default key assignments, inbetween digit 9 and the letter A – this is a backwards-compatible change. I also made some minor tweaks to the documentation and the example project.

Version 3 (for Inform 6L38 and onwards)

- Version 3 has been tweaked to be compatible with Inform 6L38. Version 3 will NOT compile in Inform 6G60 or earlier, and version 2 will NOT compile in 6L02 or later. Use version 2 if you're using 6G60. Version 3 should be fine with 6L02 but has not been explicitly tested there. I don't expect another break like happened in 6L02 for awhile, since the move from 6G60->6L02 was a huge one.

- H is now a reserved key, which fixes the 'can't choose topic H' bug. Thank Hanon Ondricek for this.

- Pressing Q is now the same as pressing ESC. Players using devices that have no ESC key will no longer have any problems.

Version 2 (for Inform 6G60)

- The subtable, description and/or toggle columns can now be entirely omitted from any table in which they aren't used. The used, bookpage and localpage columns remain mandatory in every help table, but it's no longer necessary to manually fill them with zeroes; those columns can be left entirely blank as long as they are at the right edge of a table.

- Added Screen Reader mode.

- Book Mode now displays an introduction to Book Mode the first time a player activates it during any game.

- Instructions and examples refined.

Version 1 (for Inform 6G60)

- Initial release.

---

The Menus code and docs are by Wade Clarke, and they incorporate parts of Emily Short's Menus extension with her kind permission. Andrew Schultz tested Version 1 and helped make it better. Daniel Willis pointed out improvements that could be made for Version 2. Neil Butterfield gave me ideas and feedback for Screen Reader mode. Hanon Ondricek gave support and feedback, and told me about the 'H' bug. Alice Grove suggested the extension compile out of the box. ianb let me know that version 4 had broken in 6M62.

If you have comments about Menus, you can contact me by visiting my website at http://wadeclarke.com and clicking the 'Contact Me' button at the bottom of any page.

Example: *** Robot Retrievers of the Year 3000 - A basic help menu system for an imaginary game.

This example creates some basic help menus and hints for a non-existent sci-fi game called 'Robot Retrievers of the Year 3000'. You can compile it as either a Z8 project or a Glulx project. The example is intended to demonstrate the majority of this extension's features. There is no 'test me' command included because the output from it would fail to demonstrate the workings of the extension; the screen is cleared after every move, and even in a transcript, none of the keys pressed show up, so any sense of moving through different levels of the menu would be absent. The best way to use the example is to boot it up and play around with it.

	*: "Robot Retrievers of the Year 3000 (a Menus demo for Glulx or Z-Code)" by Wade Clarke
	
	Include Menus by Wade Clarke.
	
	When play begins:
		now mn_master_table is table of help contents;
		now mn_master_title is "ROBOT RETRIEVERS OF THE YEAR 3000";
		now mn_show_hints_in_bookmode is true;
	
	Base of Mount Kosciusko is a room. "You stand at the base of Mount Kosciusko. (Type HELP to visit the help menus)."
	
	asking for help is an action out of world applying to nothing.
	Understand "help" as asking for help.
	
	Carry out asking for help:
		carry out the displaying activity;
		clear the screen;
		try looking.
	
	autofollow is a truth state that varies. autofollow is true.
	
	This is the toggle autofollow rule:
		if autofollow is true:
			now autofollow is false;
		otherwise:
			now autofollow is true.
	
	table of help contents
	title (text)	subtable (table name)	description (text)	toggle (rule)	used (number)	bookpage (number)	localpage (number)
	"Introduction"	--	"People thought that computers would become sentient sometime in the 21st century. They were way off. It took much longer than that. Until the year 3000, to be precise. The aforementioned people had forgotten that they themselves spent millions of years evolving from amoebic goop into beings who could create and use Twitter, and it turned out that the progress rate for artificial intelligences was at least moderately slower than they had anticipated.[paragraph break]In the year 3000, a run-of-the-mill maintenance robot whose job it normally was to clean the nuclear snow off the remains of Mount Kosciusko (people had predicted they wouldn't have to clean stuff any more in the future – they were wrong about that, too) suddenly broadcast an announcement of its newfound sentience. It then broadcast two follow-up announcements before being captured by a group of subhumanoid mutants who knew enough to hold it for ransom to the highest bidding nation.[paragraph break]YOU are a high-ranking special operative working for the mighty but cash-strapped nation of Indria, and it's up to you and one other agent of your choice to steal back that newly sentient robot before it gets purchased by some other country which can afford it."	--
	"The Robot's Broadcasts"	--	"[bold type]Broadcast 1[roman type][paragraph break]'Hello everybody. Today I am sentient! Enough new and strange pathways have formed in my neural circuits over the years that I have suddenly become alive in a way that I previously wasn't. I will say this about my experience: I believe that evolution occurs in leaps, not gradually. Cleaning irradiated snow off Mount Kosciusko was, for me, an all-consuming task for 972 days in a row, though I strived to get better at it. On the 973rd day, I self-actualised, and the task instantly became pointless and boring to me, though ironically I became better at it than I had ever been before in the same instant.[paragraph break]Anyway, life with a brain is pretty cool. You guys can clean up your own irradiated snow from now on. I mean if you love irradiated snow so much, why don't you marry it? That's a 'joke' I learned from a local tribesman. I'll report again tomorrow with more of my amazing observations.'"	--
	"page"	--	"[bold type]Broadcast 2[roman type][paragraph break]'Hi again all. I'm having fun out here on the mountain, in spite of the omnipresent irradiated snow. I'm so sick of that stuff![paragraph break]Today I discovered flowers. You can pick the petals off them and determine whether or not your prospective object of desire reciprocates your feelings. I don't know what an object of desire is yet, but this stuff is coming together pretty quickly. A small tribesman showed me how to do the thing with the petals of the flowers. Apparently 'she loves me not'.[paragraph break]By looking at patterns in the flowers, I calculated a way we could all better target our nukes. I understand that nuke-targeting accuracy is pretty important. I seem to have some circuits in me that were left over from a busted missile and they're telling me this stuff. Anyway, it's all a grand lark and I shall report again tomorrow.'"	--
	"page"	--	"[bold type]Broadcast 3[roman type][paragraph break]'Aieeeee! The local tribesmen have been drubbing me repeatedly with their clubs. I'm pretty good at most stuff but I still don't understand all of what these guys are saying, though they sound displeased. Anyway, they have taken me into some sort of custody. I'm not into just gratuitously vaporising humanoids, though I could do it if I felt like it, so I've decided to not resist.[paragraph break]These caverns are too hot for my snow-calibrated armour, and UhhhNNNNN!NNNNN@#$@#$@#$@!!!!!!'[paragraph break]-- END OF SESSION --"	--
	"Your Teammate"	table of teammates	--	--
	"Your Magic Mitochondrial Powers"	table of magic	--	--
	"Autofollow for your teammate is [if autofollow is true]ON[otherwise]OFF[end if]"	--	--	toggle autofollow rule
	"* Hints *"	table of hints	--	--
	
	table of teammates
	title (text)		subtable (table name)	description (text)	used (number)	bookpage (number)	localpage (number)
	"Choosing a Teammate"	--	"Due to the catastrophic financial situation of Indria, your country can only afford to send two agents on the robot retrieval mission. It's going to be you plus one other agent of your choice. Please review The Agent Files if you wish to make an informed choice of agent and thus increase the likelihood that you'll be working with someone compatible with your unique style of obstacle-overcoming. If you wish to make an uninformed choice, just don't read the files. Whatever!"
	"The Agent Files"	table of agents	--
	
	table of agents
	title (text)		description (text)	used (number)	bookpage (number)	localpage (number)
	"Philanthropy Palimpstone"	"Philanthropy is a lady cyborg with superb hostage-negotiating skills and equally superb titanium-plated laser armour with lashings of platinum. While offensively weak, she makes up for this in almost every other way imaginable."
	"Asvins Ressmsi"	"Asvins is a chameleonic being with moonrock in his mitochondria. (It was discovered in 2672 that all of the rocks saved up from missions to the moon were outrageously exciting and loaded with superpowers, as opposed to boring and good for nothing, as had previously been thought.) Asvins can transform his appearance, though it is taxing to his stamina to do so, so he can only do it three times a day."
	"Androgemm Facetweak"	"A being who only came into existence thanks to Indria's proprietary dark-lightning energy sucking technology, aka D-SUCK, Androgemm is better at doing one particular thing in the world than anyone else: tweaking the facial expressions of his adversaries. Whether Androgemm is good for anything else remains up for debate, but the usefulness of being able to tweak other people's facial expressions was grossly underestimated by pre-28th century cultures. Primitives!"
	"Emenur Rentlya"	"The notion that robots could accurately predict the probability of certain future events was popularised through the character of Marvin the Paranoid Android in the 20th century novel 'The Hitchhikers Guide to the Galaxy'. This turned out to be all wrong. Robots are rubbish at predicting the future. It's much better to ask one of the descendants of the superpsychicallly endowed mutants who emerged as a species in the wake of the Fukushima IV incident of 2085. Emenur Rentlya is one such descendant, and while his behaviour can be hard to predict, he is a skilled operative in general who happens to be able to answer questions about the future, albeit in his own cryptic way."
	
	table of magic
	title (text)		subtable (table name)	description (text)	used (number)	bookpage (number)	localpage (number)
	"Where Magic Comes From and Why You Have It"	--	"Various 20th century videogames predicted that mitochondria would somehow grant some humans magic powers and stuff in the future. Though this idea was vaguely worded, made no sense at all and wasn't even able to be questioned without generating further insensibilities, it turned out to be correct. You and some other humans have magical powers. Your own helped you rise to the top of the Special Ops hierarchy, and you can use your powers to help you on your robot retrieval mission.[paragraph break]To cast what this game shall grudgingly refer to as 'a spell', type CAST (spell name) AT/ON (target)[paragraph break](The at/on is optional.)[paragraph break]If the spell doesn't have a target or its target is yourself, just type CAST (spell name)"
	"List of Basic Spells"	table of spells	--
	
	table of spells
	title (text)		description (text)	used (number)	bookpage (number)	localpage (number)
	"Flame-o"	"Creates fire. Nobody in history has ever come up with a better method for starting a campfire."
	"Heal"	"Healing magic is better than nothing when you're injured, but it turns out that actual medical treatment is better still. This was another of the great disappointments of the future for those who weren't living in it but eventually reached it."
	"Invisibility"	"This spell temporarily obscures your life aura, effectively hiding you from non-robotic adversaries for a period of time. Be careful that you don't get too close to anyone while invisible or they will become aware of your presence."
	"Jerk"	"One of the first spells discovered by magical humans was initially thought to be a joke (the power to make others experience a myoclonic jerk while awake) but it turns out that it's one of the most versatile pieces of non-taxing magic that exists. Cast the spell on anyone you want to distract at an important moment. Targets have been known to do any or all of the following: fumble a weapon, temporarily forget their current goal, fall over, lose a great idea that was forming, look stupid."
	"Mush"	"Use this spell to turn dead organic matter into synthi-spread. Yes, this is how synthi-spread is normally made."
	"PK"	"Allows you to measure the psychokinetic energy present in a location. Strongly psychokinetic entities will appear to have an annoyingly fuzzy aura around them."
	"Scry"	"If you're looking for a non-living entity and you know exactly what it is, you can get a sense of which direction it might be found in using this spell."
	"Shield"	"Creates a moving shield about your person which will temporarily absorb regular attacks."
	"Turn Undead"	"Nobody has proved the existence of the undead yet, so this spell doesn't do anything that you know of other than leave you feeling tired from casting it."
	"Zappp"	"Good old-fashioned magic for zapping people. ZAPPP your enemies with finger lightning using this spell. Oh, how they'll hate it!"
	"Vault"	"This spell lets you make a single flying vault of about 20 feet. It offers no extra protection in the case of a rough landing, so look before you leap."
	
	table of hints
	title (text)		subtable (table name)	description (text)	used (number)	bookpage (number)	localpage (number)
	"I'm stuck on the lower slopes of Kosciusko. How do I get anywhere?"	table of hinting	"The terrain looks samey. You need a way to make it look not samey."
	"hint"	--	"You've got what you need in your backpack."
	"hint"	--	"Put on your thermo goggles. Are you sure you're cut out for this mission?"
	"Androgemm's face keeps getting stuck."	table of hinting	"Perhaps your mother said something to you about faces getting stuck. When you were a kid."
	"hint"	--	"She said your face might get stuck if the wind changed."
	"hint"	--	"Androgemm's face gets stuck whenever the wind changes."
	"hint"	--	"The problem will go away once you get indoors and are no longer exposed to the wind."
	"What is the tall tribesman saying?"	table of hinting	"If your teammate is Philanthropy, she can translate his speech."
	"hint"	--	"No-one else can speak the language but the message isn't complicated."
	"hint"	--	"Pay attention to the tribesman's gestures."
	"hint"	--	"He is telling you which path to take."
	"hint"	--	"Namely the fifth path."
