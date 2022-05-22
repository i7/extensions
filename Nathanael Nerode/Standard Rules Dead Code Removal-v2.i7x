Version 2.0.220521 of Standard Rules Dead Code Removal by Nathanael Nerode begins here.

"Reduce the size of games using Room Description Control by removing unused Standard Rules material.  This version tested with Inform v10.1."

Volume - Strip locale apparatus (for use with Room Description Control by Emily Short)

Section 7 - Response Texts and Vestigial Locale Activities (in place of Section 7 - Locale descriptions - Unindexed in Standard Rules by Graham Nelson)

[ The stub for "to describe locale" is needed because it's hooked by:
	(a) two rules in Standard Rules which are deleted from rulebooks by Room Description Control;
	(b) a rule in Rideable Vehicles, to describe the contents of the animal just after the player gets on the animal.  We handle this issue the simple way: we don't do it.  Story author can override this.
]

To describe locale for (O - object):
	do nothing.

[ Deleting *any one* of these three lines will blank out a lot of response lines and cause 'quit' to fail in Inform 6M62. Even though they appear unused.  They are presumably referenced internally by NI. ]
Printing the locale description of something (documented at act_pld) is an activity. [30]
The locale paragraph count is a number that varies.
Choosing notable locale objects of something (documented at act_cnlo) is an activity. [31]
[ Deleting this line will throw "Programming errors" and cause 'quit' to fail in Inform 6M62. Even though it appears unused.  It is presumably referenced internally by NI.]
Printing a locale paragraph about something (documented at act_plp) is an activity. [32]

Standard Rules Dead Code Removal ends here.

---- DOCUMENTATION ----

Section - What This Is

This is an experimental extension for those who would like their generated code to be a little smaller.

Room Description Control replaces a large hunk of Standard Rules code, but it doesn't actually remove any of the code, or the gigantic table (8K in Counterfeit Monkey) associated with it.  This attempts to remove that.

Note that this will subtly change the behavior of Rideable Vehicles: no description of contents of the animal will be printed after mounting a rideable animal.  Authors can always override this.

On the first successful test, this stripped 31KB out of Counterfeit Monkey.  Not a huge amount in an 8.4MB game, but not nothing either.

Section - Changelog

	2.0.220521: Update to Inform v10.1, which renamed sections of the Standard Rules, largely for the better.
	1: First version.
