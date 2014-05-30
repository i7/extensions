Version 1/130821 of Checkpoints by Peter Orme begins here.

"Checkpoints is a developer tool that lets us us define 'checkpoints' in our stories, used for verifying game state or fast-forwarding to points in a story."

"includes code by Jesse McGrew"


Section - Checkpoint verbosity setting 

[
This is a setting which controls whether or not all tests (failed and successful) are listed by the checkpoint assert command
]

checkpoint-asserting verbose is a truth state that varies. checkpoint-asserting verbose is false.

checkpoint verbosity toggling is an action out of world applying to nothing.
Understand "checkpoint verbose" as checkpoint verbosity toggling. 

carry out checkpoint verbosity toggling (this is the checkpoint verbosity toggling rule):
	if checkpoint-asserting verbose is true:
		now checkpoint-asserting verbose is false;
	otherwise:
		now checkpoint-asserting verbose is true;
	say "Toggled checkpoint asserting verbosity. It is now [checkpoint-asserting verbose].";

Section - matching text to a topic

[This is  a helpful snippet that that lets us match text against topic entries in a table. 
By Jesse McGrew, aka vaporware: http://www.intfiction.org/forum/viewtopic.php?f=7&t=1279]

To decide whether (chosen text - indexed text) matches (chosen topic - topic):
   let tmp be indexed text;
   let tmp be the player's command;
   change the text of the player's command to chosen text;
   let result be whether or not the player's command matches chosen topic;
   change the text of the player's command to tmp;
   decide on result.

Section - checkpoint-asserting

[
Checkpoint-asserting is for checking game state at a given point in our stories. 
]

checkpoint-asserting is an action out of world applying to one topic. Understand "checkpoint assert [text]" or "cpa [text]" as checkpoint-asserting.

[this bit goes through the table and checks each line that matches the topic. If the assertion string comes back as anything longer than 0 characters, it is considered to have failed:]

carry out checkpoint-asserting a topic (this is the checkpoint asserting rule):
	let failed checkpoint assert count be 0;
	let successful checkpoint assert count be 0;
	repeat through the Table of Checkpoints:
		let X be indexed text;
		let X be the topic understood;
		if X matches the topic entry:
			let N be the number of characters in "[assertions entry]";
			unless N is 0:
				say "[message entry] - FAILED.";
				increment failed checkpoint assert count;
			otherwise:
				increment successful checkpoint assert count;
				if checkpoint-asserting verbose is true:
					say "[message entry] - OK.";
	if the successful checkpoint assert count is 0 and the failed checkpoint assert count is 0:
		say "There are no checkpoint assertions for '[the topic understood]'.";
	otherwise:
		say "Checkpoint summary: OK:[successful checkpoint assert count] Failed:[failed checkpoint assert count].";
	if the failed checkpoint assert count is greater than 0, say "[bold type]There were failures.[roman type]";

Table of Checkpoints
topic	assertions	message
a topic	a text	a text

[
We need to define a table like this for the assertions:

Table of checkpoints (continued)
topic	assertions	message	
"airlock"	"[unless the outer door is closed]fail[end if]"	"The outer door should be closed"
"airlock"	"[unless the player is in decontamination zone]fail[end if]"	"You should be in the decontamination zone"

]

Section - checkpoint-going

[
	This is for the other use case, where we want to define a checkpoint that we can fast-forward to. The player types "checkpoint go shipwreck" (where 'shipwreck' is the name of a checkpoint) and is magically transported there. 
]

checkpoint-going to is an action out of world applying to one topic.
understand "checkpoint go [text]" as checkpoint-going to.
understand "cpg [text]" as checkpoint-going to.

carry out checkpoint-going to the topic understood (this is the checkpoint going rule):
	let found-checkpoint be false;
	repeat through the Table of checkpoint scripts:
		if topic understood matches the topic entry:
			follow the rule entry;
			now found-checkpoint is true;
	if found-checkpoint is true:
		say "Followed the checkpoint script for [topic understood].";
	otherwise:
		say "There is no checkpoint script for [topic understood].";
	
Table of Checkpoint Scripts
topic	name	rule
a topic	a text	a rule

[
We need to define this table and fill it up with named rules for the script we want to be able 
to fast-forward to.

Table of Checkpoint scripts (continued)
topic	name	rule
"airlock"	"airlock"	checkpoint airlock rule

The rules can be existing ones or those we just create on the fly, using the "this is the checkpoint airlock rule:" syntax.
]


Section - Checkpoint listing

checkpoint-listing is an action out of world applying to nothing. Understand "checkpoint list" or "cpl" as checkpoint-listing.

carry out checkpoint-listing (this is the checkpoint listing rule):
	say "This is the list of named checkpoints you can go to with 'checkpoint go [italic type]name[roman type]':[line break]";
	repeat through Table of checkpoint scripts:
		say "[name entry][line break]";
		

Checkpoints ends here.

---- DOCUMENTATION ----


There are two distinct (and complimentary) usages for checkpoints: checkpoints for assertions and checkpoints for fast-forwarding. 


CHECKPOINTS FOR ASSERTIONS lets us check the state of the game at a defined point, to check that everything is progressing the way we thought it would be. Inform7 already has the ability to write test scripts, but they only carry out scripted actions, and we need to verify that everything really works the way it should manually. With checkpoint assertions, we can add a "checkpoint assert xxx" last in the test script to verify the game state at that point, and it will tell us if there is something we misse. This is at least an attempt to allow us to use test-driven development when writing Inform 7 games. 

We write assertions in a table, as we can see in the example. Each line contains a test we want to run. These are say phrases which should not say anything unless there is a problem. To run it, we use "checkpoint assert topic", or just "cpa topic", where topic is the topic in the topic column of the Table of Checkpoints. Note that we can (and probably should) have more than line matching a topic. (And if we insist we can also have lines that match multiple labels, using a topic entry like "alpha/beta" - although the point of doing this seems less obvious).


By default only failed tests are shown. This behavior is controlled by the checkpoint-assertion verbosity setting, which can be toggled using the command "checkpoint verbosity".


CHECKPOINT SCRIPTS are also useful, but maybe not in the same way. A checkpoint script is just a script that lets us (or our beta-testers!) fast-forward to a given point in the story. In reality all we do is write a custom rule that carries out twhat's needed. The difference from a standard test script is that this allows us to change game state in ways that can't be done by issuing player commands.

There's a basic "checkpoint list" command that lists the checkpoint scripts.

	
Example: ** How to Fix an airlock - an example of using checkpoint assertions, a checkpoint script, and a standard test script that performs the checkpoint assertion. 

This example starts with some code that sets up a simple puzzle to get in through a broken air lock. We've placed the stuff that relates to this extension in a separate section and marked it as "not for release". 

There are three things there: the checkpoint assertion (which we can run using 'checkpoint assert airlock' or 'cpa airlock'), the checkpoint script (which we run with the command 'checkpoint go airlock' or 'cpg airlock'), and a normal test script ('test airlock'). To illustrate the idea of test-driven development, the checkpoint script works as intended, but the normal test script does not. If we type 'test airlock' we'll see a message saying THERE WERE FAILURES. In this case the problem is not with the world but with the test script, which is missing an action. Can we fix it? Yes we can! 

	*: "How to Fix an Airlock"

	Include version 1 of Checkpoints by Peter Orme.

	Chapter - Example airlock

	Section - World

	Planetside is a room. "Nothing but bare rock under a darkening sky.[first time] You'd better get inside before dark falls. It gets cold on this planet. Colder than your what suit can protect you from.[only]".

	The player is wearing a space suit. The description of the space suit is "It's just like any other space suit you've worn."; Understand "spacesuit" as the space suit.

	check taking off the space suit:
		unless the air is breathable:
			say "Not until you're safely inside.";
			stop the action.

	To decide whether the air is breathable:
		if the player is in Planetside, no;
		if the player is in the Airlock and the outer door is open, no;
		yes;

	Airlock is a room.

	The outer door is a door. It is inside from Planetside and outside from Airlock. The description is "The outer door is solid and sturdy, made to isolate from cold and wind. You pull the door down to close it. There's a large spring that makes sure it opens and closes automatically as it should. The door is currently [if the outer door is open]open[otherwise]closed[end if].";

	The spring is a fixed in place thing in the airlock. It is scenery. The spring can be fixed. The description of the spring is "It's a large and slightly rusty spring, clearly not part of the original design of the door, but something somebody added as a quick fix.[if the spring is fixed] It looks straighter now that you gave it a whack.[otherwise] It looks a bit crooked. Nothing a good blow won't fix.[end if]";

	instead of pulling the outer door: try closing the noun.
	instead of pushing the outer door: try opening the noun.

	instead of attacking the fixed spring:
		say "You've already done that.";

	instead of attacking the spring:
		say "You give the spring a good blow.";
		now the spring is fixed.

	after going inside from Planetside:
		unless the spring is fixed:
			say "The outer door closes automatically behind you with a hiss. And then it opens again. That's not supposed to happen!";
		otherwise:
			say "The door closes behind you, as it should.";
			now the outer door is closed.

	The inner door is a door. It is inside from Airlock and outside from Decontamination Zone.

	check opening the inner door:
		if the outer door is open:
			say "You can't open the inner door while the outer door is open. That's how an airlock works, you know.";
			stop the action;

	after closing the outer door when the spring is not fixed:
		say "You pull the door down, but it just hisses and opens again. How annyoing!";
		now the outer door is open.

	Section - Checkpoints - Not for release

	Table of checkpoints (continued)
	topic	assertions	message
	"airlock"	"[unless the outer door is closed]fail[end if]"	"The outer door should be closed"
	"airlock"	"[unless the player is in decontamination zone]fail[end if]"	"You should be in the decontamination zone"
	"airlock"	"[if the player is wearing the space suit]fail[end if]"	"You should have taken off the space suit"
	"airlock"	"[unless the spring is fixed]fail[end if]"	"You need to fix the spring"

	test airlock with "open outer / in / close outer / in / take off space suit / checkpoint assert airlock";
	test me with "test airlock".

	Table of Checkpoint scripts (continued)
	topic	name	rule
	"airlock"	"airlock"	checkpoint airlock rule

	this is the checkpoint airlock rule:
		now the outer door is closed;
		now the inner door is closed;
		now the spring is fixed;
		now the player is in the Decontamination zone;
		now the player is carrying the space suit;
		say "You figured out that you need to hit the spring to fix the outer door. After that you just needed to close the outer door, open the inner door, walk inside and take off the space suit.";
		try checkpoint-asserting "airlock";

