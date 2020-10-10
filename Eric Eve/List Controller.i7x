Version 4 of List Controller by Eric Eve begins here.

"Provides a means of using tables as shuffled, cyclic or stoping lists. This is an alternative to List Control that uses list controller objects instead of a Table of Table Types."

A list controller is a kind of thing.
A list controller can be stopping, cyclic, or shuffled.
A list controller has a number called cur_state.
A list controller has a table-name called associated list.

To show the next response of/in/from (lc - a list controller), with newlines, with paragraph break or with run on:
  let cur be the next row to use in lc; 
  choose row cur in the associated list of lc;
  if there is an event entry, follow the event entry;
  if there is an response entry, say "[response entry][if with newlines][line break][end if][if with run on][run paragraph on][end if][if with paragraph break][paragraph break][end if]".


To decide which number is the next row to use in/of/from (lc - a list controller):
  let cur be the cur_state of lc plus 1;
   let tab be the associated list of lc;
   let len be the number of rows in tab;
   if cur > len begin;
      if lc is shuffled, sort tab in random order;
      if lc is shuffled or lc is cyclic, now cur is 1;
      otherwise now cur is len;
  end if;
  now the cur_state of lc is cur;
  decide on cur.



[The following is needed to allow a game including this file to compile even without any defining any tables containing an response or event column]

Table of DummyXYZ
response		event (a rule)
"dummy"	       --


List Controller ends here.

---- DOCUMENTATION ----

Chapter: Overview

List Controller provides much the same functionality as the older List Control extension (with some enhancements), but does away with the need to define a Table of Table Types. Instead, you need to define a number of list controller objects, but some authors may find this slightly less messy.

First, the story in brief: List Controller provides three ways of traversing a list contained in a table: stopping, cyclic, or shuffled. To define which type applies to a given table, we define a corresponding list controller and associate a Table with it:

	my list is a stopping list controller.
	the associated list is the Table of My Stuff.

	Table of My Stuff
	response
	"Boo!"
	"Whee"
	"Foo!"
	"Bar!"
	
To display the next response entry from such a table, we use the phrase:

	show the next response from my list.

We can also use 'in' or 'of' instead of 'from' (to allow for whichever phrasing seems most natural without having to remember which is the only correct one).
	

If we want to use a table other than one with a single column called 'response' containing text, we can instead obtain the next row number in our chosen sequence with the value:

Chapter: Detail

Section: Random Responses
		
Now for the longer explanation:

We may often want to use a table to provide a list of responses for use, say, as a series of atmospheric messages, or as a series of responses by the NPC on the same topic. Sometimes we may want to work through these responses in sequence (e.g. a succession of answers by the NPC to the same question from the player), and sometimes we may want the responses to appear more random (e.g. a succession of atmospheric messages, or default responses from an NPC when the player asks about a topic not specifically covered). One can, of course, readily obtain a random response from a table with code like:

	Instead of Jumping:
	  choose a random row in the Table of Jumps;
              say "[jump entry]."


	Table of Jumps
	jump
	"Wow!"
	"You bang your head on the ceiling."
	"Whee!"
	"Ouch"

But this can easily produce a sequence like "Wow", "Wow", "Whee", "Ouch", "Wow", "Whee", "You bang your head on the ceiling", that is a sequence where one or more of the messages appear several times before every message has been seen. Often the effect would be better if we saw every message once, and then every message again in a different order, like dealing from a pack of cards and then shuffling the pack again after every card has been dealt once to obtain a new sequence.

On other occasions, for example when asking an NPC repeatedly about the same subject, we may want to show a series of responses in sequences, and then keep repeating the final one (which might be along the lines of "You've already asked me that, and the answer was...").

List Controller provides a means of doing this. To set up a shuffled list, we would define:

	The Test Place is a room.

	jump list is a shufled list controller.
	The associated list is the Table of Jumps.
	
	Table of Jumps
	response
	"Wow!"
	"You bang your head on the ceiling."
	"Whee!"
	"Ouch"
	

	Instead of jumping:
		show the next response from the jump list, with newlines. 	

Section: Phrase options: with newlines, with run on, with paragraph break

The 'with newlines' option adds a newline to the text that's displayed, which is often useful if it's meant to be a complete response in itself. If, however, you're using a list controller to provide part of a response to something, you might not want the newline, in which case you can omit the option, or use the "with run on" option to ensure than any ensuing text is part of the same paragraph. There is also a "with paragraph break" option to force a parargraph break (as opposed to the line break you get with "with newlines").


Section: Stopping, cyclic and shuffled list controllers

A list controller can be in one of three conditions: stopping, cyclic or shuffled.

A shuffled list controller runs through each row of its associated table in turn, then sorts the table in random order before starting again at the beginning. 
A stopping list controller runs through each row in turn, then keeps repeating the final row of the table.
A cyclic list controller runs through each row in turn until it reaches the final row of the table, and then returns to the first row and repeats the rows in the same sequence as before.

Hence we might also define:

	Instead of Smelling the Test Place:
		show the next response from the smell list.

	smell list is a cyclic list controller.
	The associated list is the Table of Smells.

	Table of Smells
	response
	"Poo!"
	"What a pong!"
	"Smells like rotten eggs"
	"Powerful whiff!"

	

	Instead of Listening to the Test Place:
		show the next response from the sound list.	

	sound list is a stopping list controller.
	The associated list is the Table of Sounds.	

	Table of Sounds
	response
	"There's a lound ringing sound."
	"The ringing is fading."
	"Just a faint echo."
	"Silence."
  
Section: Event lists	

In addition to an response column, a Table associated with a list controller may also (or instead) have an event column which can contain rules (which will then be executed iin place of or as well as displaying the string in the response column). If there is an event entry and an response entry in the same row, the event rule will be executed before the response string is displayed (for an example, see Example A below). 

Section: Alternative table structures

Finally, if you want to use list controller in conjuction with a Table with a different structure (e.g. a table containing a list of objects from which you want to select one), you can use the phrase "the next row to use from my list controller" to get at the next row number to use. For example:

	to notice a piece of fruit:
		let r be the next row to use in the fruit list;
                        choose row r in the Table of Fruit;
                        let response be the fruit entry;                 
		move the response to the bowl;       
		"For some reason, you suddenly notice [the response] in the bowl."

	The fruit list is a shuffled list controller.
	The associated list is the Table of Fruit.

	Table of Fruit
	fruit
	apple
	orange
	banana
	pear
	plumb



Example: * Magic Jumping - Mixing Events and responses in a list controller table	

	 *: "Magic Jumping" 

	Include List Controller by Eric Eve.
	
	The Magic Chamber is a Room.
	  "The chamber is quite bare, but you've heard it pays to jump here. "
	
	Instead of Jumping:
  	 	say "You jump vigorously.";
  		show the next response in the jump list, with newlines.
	
	The jump list is a stopping list controller.
	The associated list is the Table of Jumps.
	
	Table of Jumps
	event		response
	magic rule 	--
	boring rule	--
	--		"Nothing else happens."
		
	This is the magic rule:
	   move the gold bar to the Magic Chamber;
	   say "A gold bar suddenly appears!"
	
	This is the boring rule:
	  move the wooden spoon to the Magic Chamber;
	  say "A wooden spoon appears."
	
	The gold bar is a thing.
	The wooden spoon is a thing.
	
	Test me with "jump/look/jump/look/jump/look"


Example: * Family Reunion - Using Tables to give successions of responses to questions and NPC fidgets

	*: "Family Reunion"

	Part 1 - Setup

	Include List Controller by Eric Eve.

	When play begins:
	Now the description of yourself is "Trim and upright, with a proud Prussian bearing - too bad about the withered arm, though."

	Part 2 - Scenario

	The Royal Lounge is a room. "Opulent in its way, to your eye this room nevertheless has a slightly dingy, old-fashioned look, no doubt because the Queen is so opposed to the idea of change, but also perhaps because England is so backward-looking compared with your new dynamic Germany."

	The window is scenery in the lounge. "It affords an excellent view of Windsor Great Park - or rather it would if the view were not largely obscured by the Prince of Wales."

	Bertie is a man in the Lounge. "Bertie is standing with his back to the window."
	Understand "prince" or "edward" or "of" or "wales" or "uncle" as Bertie.

	Queen Victoria is a woman in the Lounge. "Queen Victoria is sitting glowering sternly at her oldest son." The description is "She's still dressed in the black mourning weeds she's worn ever since the Prince Consort died."

	Part 3 - Queen Victoria's Conversation

	Instead of asking Queen Victoria about a topic listed in the Table of Queen Conversation:
		if there is a List Control entry, 
		    show the next response from the List Control entry, with newlines;
		otherwise say "[Response entry][paragraph break]".
	
	After asking Queen Victoria about something:
	 	show the next response from Queen-Default, with newlines;
	 	stop the action.

	Understand "bertie" or "uncle" or "prince" as "[prince]".

	Table of Queen Conversation
	Topic		List Control	Response
	"[prince]"	Queen-Bertie	--
	"germany"	Queen-Germany	--
	"weather"	--		"'What do you think of the weather today, grandma?' you ask.[paragraph break]'It is tolerable,' she replies."

	Queen-Bertie is a stopping list controller.
	The associated list is the Table of Queen's Bertie Responses.

	Table of Queen's Bertie Responses
	response
	"'Isn't Uncle Bertie looking well?' you gush.

	'He's put on too much weight,' the Queen demurs critically."
	"'Are you keeping Bertie busy, grandma?' you enquire.

	'Bertie spends far too much time gallivanting,' the Queen disapproves."
	"'Don't you think Bertie will make a fine king one day, grandma?' you ask.

	'Over my dead body!' she replies fiercely."
	"Perhaps you have exhausted that topic for now."

	Queen-Germany is a stopping list controller.
	The associated list is the Table of Queen's Germany Responses

	Table of Queen's Germany Responses
	response
	"'You should come and visit us in Germany, grandma,' you suggest.

	'Yes, I am sure Vicky would be pleased to see me,' she nods."
	"'Our two countries should become better friends, don't you think, grandma?' you propose.

	'That was always my dear Albert's dearest wish,' she smiles."
	"'Between us, Britain and Germany could rule the world!' you declare enthusiastically, 'What do you say, grandma?'

	'Well!' she frowns, looking slightly alarmed."
	"Bertie frowns and motions to you to keep quiet."

	Queen-Default is a shuffled list controller.
	The associated list is the Table of Queen's Default Responses

	Table of Queen's Default Responses
	response
	"'We are not amused, Willi,' she replies sternly."
	"'That is not something we are prepared to discuss,' she answers stiffly."
	"'I am surprised you should raise such a matter at such a time!' she rebukes you."
	"'No, we shall not discuss that!' she rules."

	Part 4 - Bertie's Fidgeting
	
	Bertie-Fidget is a cyclic list controller.
	The associated list is the Table of Bertie's Fidgets.

	Table of Bertie's Fidgets
	response
	"Uncle Bertie clears his throat."
	"Uncle Bertie shuffles from one foot to the other."
	"The Prince of Wales manfully stifles a yawn."
	"Bertie scratches his right ear."
	"Bertie pats his jacket as if looking for a cigar, but then remembers himself just in time."
	
	Every turn when a random chance of 1 in 3 succeeds:
		  show the next response of Bertie-Fidget, with newlines.	

	Part 5 - Test

	Test me with "x bertie/x queen/x window/ask queen about bertie/g/g/g/ask queen about weather/ask queen about love/ask queen about war/ask queen about germany/g/g/g/ask queen about William Gladstone/ask queen about Disraeli/ask queen about germany"




