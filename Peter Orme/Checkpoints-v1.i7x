Version 1.0.220524 of Checkpoints by Peter Orme begins here. 

"A method of using assertions stored in a table to verify your game works as expected."

[Version 1.0.220524: Updated for Inform v10.1 by Nathanael Nerode]

Include Unit Testing by Peter Orme.

Chapter 1 - Checkpoint Assertions 

Section 1 - Table of Checkpoints

Table of Checkpoints
topic	assertion (a text)	message (a text)
--	--	--

Section 2 - Checkpoint-asserting 

checkpoint-asserting is an action out of world applying to one topic. 

Understand "checkpoint assert [text]" or "cpa [text]" as checkpoint-asserting.

carry out checkpoint-asserting:
	reset the asserter;
	repeat through the Table of Checkpoints:
		if the topic understood includes topic entry: 
			assert "[assertion entry]" is empty saying only "[message entry]";
	report asserts using high verbosity set to halt never;


Chapter 2 - Checkpoint Scripts

Section - checkpoint-going

[
	This is for the other use case, where we want to define a checkpoint that we can fast-forward to. The player types "checkpoint go shipwreck" (where 'shipwreck' is the name of a checkpoint) and is magically transported there. 
]

checkpoint-going to is an action applying to one topic.
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
topic	name (a text)	rule (a rule)
--	--	--

[
We need to define this table and fill it up with named rules for the script we want to be able 
to fast-forward to.

Table of Checkpoint scripts (continued)
topic	name	rule
"airlock"	"airlock"	checkpoint airlock rule

The rules can be existing ones or those we just create on the fly, using the "this is the checkpoint airlock rule:" syntax.
]

Checkpoints ends here.

---- Documentation ---- 

Chapter: The idea 

One idea is that we want to write a "test me" script for our story, but also have that test script actually perform 'unit testing'-type assertions along the way. 

Another idea is to have known "checkpoints" in our story that you can get to, and you want to test that the state of the world is as you think it is at these points. 

Chapter: Using the Table of Checkpoints

To write assertions, you create a table called Table of Checkpoints (continued) which has exactly three columns: "topic", "assertion" and "message".

The first column, "topic", is a topic column. The easiest thing here is just to type in a single keyword in quotes. Consult section 16.13 in the documentation to read up on more fun you can do with topic columns. You can have the same value in multiple rows of your column, and use these as a way to group test.

The second columnt, "assertion", is a little special. It contains a double-quoted string that should be empty for the assertion to succeed. Just typing in an empty string (just two quotes) will work, but it's not really testing anything, is it. So what we typically do is use bracketed expressions like "[if the ball is red]fail[end if]"

It does not need to say "fail" on failure, it can say anything.

The third column, "message", is just any text that will be shown on failure.

Chapter: running assertions

To trigger running all the assertions that match the topic column while playing a game, type in "checkpoint assert xxx" where xxx matches the topic. See example A.


If we must, we can also make in-world games that trigger assertions using something like this: 

    The button is a thing in the football field. 
    
    instead of pushing the button: 
	    try checkpoint-asserting "baller". 



Example: * Bring your own ball - Using checkpoints assertion in a test script.

Write an assertion in a table, and use the 'checkpoint assert' command while playing or in a test script. For the sake of clarity: the "topic" does not need to match an actual object, it can be any string. When you run the test script it will first show you that the 

	*: "Bring your own ball"

	Include Checkpoints by Peter Orme.
								
	The Football field is a room. The Locker room is a room. It is north from the Football field.

	The ball is a thing in the Locker room.

	Table of Checkpoints (continued)
	topic	assertion	message
	"baller"	"[unless the player is in the Football field]fail[end if]"	"You should be in the football field."
	"baller"	"[unless the player has the ball]fail[end if]"	"You should have the ball."

	test me with "checkpoint assert baller / n / take ball / s /checkpoint assert baller".


Example: ** How to Fix an Airlock - Using both checkpoint assertions and a checkpoint script

In this example we have a very silly puzzle indeed. We have a person in a spacesuit, and he or she needs to get inside an airlock. To get inside, the solution is just to identify the part that's acting up, and hit it. Then we can close the outer door, open the inner door, walk inside, and take off the space suit. 

We can thing of this as a "checkpoint". While we're developing a game, this etensions let's us do two things: assert that the world state is as it should be, and provide a framework for writing rules that set the game state to some defined state. 

So in this case we make up a "checkpoint" and call it "airlock". Typing in "checkpoint assert airlock" (or just "cpa airlock" for short will run the assertions in the Table of Checkpoints). If everything is as it should be (the spring is fixed, the door is closed, the player is inside, and the space suit is removed) everything checks out and we get a friendly "Assertions OK" message. If any of these things are wrong, the command will tell us. This is a contrived example, but in a larger game keeping track of the state of affairs is perhaps not so obvious. 

The other thing is that maybe we just want to fast-forward to a good "checkpoint" and continue the game from there. Here we create a rule for this, just out of the blue, just declare it: "this is the checkpoint airlock rule". Remember to put that into the Table of Checkpoint scripts, and then you can just type in "checkpoint go airlock" (or "cpg airlock" for short) to execute the fast-forward script. Sure you can do this with regular "test" scripts, but then you can only enter a list of player commands, in a rule like this you can do anything you can do from Inform code. 



	*: "How to Fix an Airlock"
	
	Include Checkpoints by Peter Orme
	
	Chapter - Example airlock
	
	Section - World
	
	Planetside is a room. "Nothing but bare rock under a darkening sky.[first time] You'd better get inside before dark falls. It gets cold on this planet. Colder than your what suit can protect you from.[only]".
	
	The player is wearing a space suit. The description of the space suit is "It's just like any other space suit you've worn.". Understand "spacesuit" as the space suit.
	
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
	topic	assertion	message
	"airlock"	"[unless the outer door is closed]fail[end if]"	"The outer door should be closed"
	"airlock"	"[unless the player is in decontamination zone]fail[end if]"	"You should be in the decontamination zone"
	"airlock"	"[if the player is wearing the space suit]fail[end if]"	"You should have taken off the space suit"
	"airlock"	"[unless the spring is fixed]fail[end if]"	"You need to fix the spring"
	
	test airlock with "open outer / in / close outer / in / take off space suit / checkpoint assert airlock".
	
	test solution with "hit spring / close outer / open inner / in / close inner / remove suit".

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


