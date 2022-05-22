Version 1.2 of Achievements by Juhana Leinonen begins here.

"A simple but flexible rule-based achievement system. Awarded achievements can optionally persist in external files after a restart."


Chapter 1 - Awarding achievements

Use persistent achievements translates as (- Constant PERSISTENT_ACHIEVEMENTS; -).

The file of Persistent Achievements is called "achievementdata".

Loadingstate is a truth state that varies.  LoadingState is true.


This is the check for achievements rule:
	repeat through the Table of Achievements:
		if (there is no awarded entry or the awarded entry is false) and there is a validation entry:
			follow the validation entry;
			if the rule succeeded:
				award the achievement entry achievement.
	
The check for achievements rule is listed last in the turn sequence rules.

To award the/-- (name - text) achievement, silently:
	if there is an achievement of name in the Table of Achievements:
		choose the row with achievement of name in the Table of Achievements;
		if there is no awarded entry or the awarded entry is false:
			if the number of awarded achievements is 0:
				now print achievement command hint is true;
			now the awarded entry is true;
			If the persistent achievements option is active:
				if loadingstate is false:
					write achievement name to an external file;
			if not silently:
				carry out the printing the achievement activity with the achievement entry.
			
Printing the achievement something is an activity on text.

Rule for printing the achievement text (called name) (this is the print achievement unlocked rule):
	say "[italic type][bracket]" (A);
	say "Achievement unlocked: " (B);
	say "[name]" (C);
	say "[close bracket][roman type]" (D);
	say "[line break]" (E).


Chapter 2 - Helper phrases

To decide which number is the number of awarded achievements:
	let the count be 0;
	repeat through the Table of Achievements:
		if there is an awarded entry and the awarded entry is true:
			increment the count;
	decide on count.
	
To decide which number is the total number of achievements:
	decide on the number of rows in the Table of Achievements.
	
To decide whether all the/-- achievements are awarded:
	if the number of awarded achievements is the total number of achievements:
		decide yes;
	decide no.

To decide whether all the/-- achievements are not awarded:
	if all achievements are awarded:
		decide no;
	decide yes.
	

Chapter 3 - ACHIEVEMENTS command

Listing achievements is an action out of world.

Understand "achievements" as listing achievements.

Carry out listing achievements when the number of awarded achievements is 0 (this is the no achievements so far rule):
	say "You haven't unlocked any achievements so far." (A).

Carry out listing achievements when the number of awarded achievements is greater than 0 (this is the list achievements so far rule):
	say "You have unlocked the following achievement[if the number of awarded achievements is not 1]s[end if]:[paragraph break]" (A);
	repeat through the Table of Achievements:
		if there is an awarded entry and the awarded entry is true:
			say "[bold type][the achievement entry]:[roman type] [the description entry][line break]" (B).
			
Print achievement command hint is a truth state that varies. Print achievement command hint is false.

This is the hint about the achievement command rule:
	if the print achievement command hint is true:
		say "(Command ACHIEVEMENTS to see a list of your achievements.)[line break]" (A);
		now the print achievement command hint is false.

The hint about the achievement command rule is listed after the check for achievements rule in the turn sequence rules.


Chapter 4 - When play ends

After printing the player's obituary (this is the tell how many achievements the player unlocked rule):
	say "You unlocked [number of awarded achievements] achievement[if the number of awarded achievements is not 1]s[end if] out of [total number of achievements]." (A).

Table of Final Question Options (continued)
final question wording	only if victorious	topic	final response rule	final response activity
"list your ACHIEVEMENTS"	false	"achievements"	--	listing final achievements

Listing final achievements is an activity.

Rule for listing final achievements when the number of awarded achievements is 0 (this is the story ended without achievements rule):
	say "You did not unlock any achievements." (A);
	
Rule for listing final achievements when the number of awarded achievements is not 0 (this is the story ended with achievements rule):
	follow the list achievements so far rule.

After listing final achievements when the number of awarded achievements is not the total number of achievements (this is the list unlocked achievements rule):
	say "[line break]These achievements are still locked:[paragraph break]" (A);
	repeat through the Table of Achievements:
		if there is no awarded entry or the awarded entry is false:
			say " - [the achievement entry][line break]" (B);
	say "[line break]" (C).	
	

Chapter 5 - Persistent achievements (for Glulx only)

[This is not cryptographically secure -- it's only meant to prevent casual tampering.]
To decide which number is the checksum for (name - text):
	let checksum be 0;
	repeat with C running from 1 to the number of characters in name:
		if character number C in name is listed in {"a","e","i","o","u"}:
			decrease checksum by C;
		otherwise:
			increase checksum by C;
	decide on checksum.

To write achievement (name - text) to an external file:
	append "[name]|[checksum for name]|" to the file of Persistent Achievements.
	
First when play begins when the persistent achievements option is active (this is the read achievement data from an external file rule):
	let data be text;
	let name be text;
	let checksum be text;
	let mode be "name";
	if the file of Persistent Achievements exists:
		now data is "[text of the file of Persistent Achievements]";
		repeat with C running from 1 to the number of characters in data:
			if character number C in data is "|":
				if mode is "checksum":
					if checksum is "[checksum for name]":
						[the checksum was correct, award the achievement]
						award the name achievement, silently;
					now mode is "name";
					now name is "";
					now checksum is "";
				otherwise if mode is "name":
					now mode is "checksum";
			otherwise if mode is "name":
				now name is "[name][character number C in data]";
			otherwise if mode is "checksum":
				now checksum is "[checksum][character number C in data]";
	now loadingstate is false.


Chapter 6 - Persistent achievements Z-code dummy (for Z-machine only)

To write achievement (name - text) to an external file:
	do nothing.

Section 1 - Warning for persistent achievements being impossible (not for release)

First when play begins when the persistent achievements option is active (this is the warn for persistent achievements being impossible rule):
	say "[italic type]WARNING: The 'use persistent achievements' option is set, but the option is not supported on Z-machine. Change the story file type to Glulx or disable this warning with 'The warn for persistent achievements being impossible rule is not listed in any rulebook.'[paragraph break][roman type]" (A).


Achievements ends here.


---- DOCUMENTATION ----

Chapter: Setting up

We must define the following table in the story source:

	Table of Achievements
	achievement	description	validation	awarded
	"Example"	"You've unlocked the example achievement"	example achievement rule	false

The "achievement" column is the name of the achievement, and the "description" column is the longer explanation of the achievement, usually the reason for why the achievement was awarded.

The validation column should contain a rule that succeeds when the achievement should be awarded.

	This is the example achievement rule:
		if the player is carrying the MacGuffin:
			rule succeeds.
			
The rule doesn't need to check if the condition is true for the first time, the extension awards each achievement only once.

The validation entry can also be left blank. In that case the achievement must be awarded manually (see the next chapter).

The last column, "awarded", tracks whether the achievement has already been awarded. It should start out as false (unless for some reason we want the player to start the story with achievements already awarded).


Chapter: Awarding achievements

The rules in the validation column are checked at the very end of every turn and any new achievements are awarded. Achievements can also be awarded manually at any time:
	
	award the "Example" achievement;
	
Adding the "silently" modifier to the phrase suppresses the achievement notification:
	
	award the "Example" achievement, silently;
	
The rule responsible for achievement notifications is the print achievement unlocked rule, so unlisting it will remove notifications altogether.

Printing achievement text is an activity and rules can be attached to it like to any other activity:
	
	Before printing the achievement text:
		say "Drumroll please..."
		

Chapter: Persistent achievements

The achievements can optionally persist between playthroughs by applying a use option:

	Use persistent achievements.

Any unlocked achievements are then saved to a file and restored from there when play begins.

Persistent achievements works only in Glulx.


Example: * Another Day at the Office - Rule-based and manually awarded achievements

	*: "Another Day at the Office"
	
	Include Achievements by Juhana Leinonen.

	Office is a room. "It's another boring afternoon in the office."

	The desk is in the office. The inbox is on the desk. The memo is in the inbox.

	A piece of gum is a thing.

	The time of day is 4:57 PM.

	Instead of looking under the desk for the first time:
		say "Hey, someone stuck a piece of gum under the desk!";
		now the player is carrying the piece of gum.
		
	After examining the memo:
		say "It's from the boss. You forget it as soon as you've read it.";
		award the "Diligent Employee" achievement.
		
	Table of Achievements
	achievement	description	validation	awarded
	"Desk Treasure"	"You found the piece of gum."	gum achievement rule	false
	"Diligent Employee"	"You read the memo."	--	false
	"Overtime"	"Stayed at work past 5 pm."	overtime achievement rule

	This is the gum achievement rule:
		if the player is carrying the piece of gum:
			rule succeeds.
			
	This is the overtime achievement rule:
		if the time of day is greater than 5:00 PM:
			rule succeeds.

	Instead of exiting:
		say "Ok, that's enough for today.";
		end the story finally.
		
	Test me with "read memo/look under desk/z/z/exit".



