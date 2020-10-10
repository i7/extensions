Version 4 of List Control by Eric Eve begins here.

"Provides a means of using tables as shuffled, cyclic or stop lists."

A table-type is a kind of value. The table-types are stop-list, cyclic-list, and shuffled-list


Table of Table Types
tabname (a table-name)		index (a number)	tabtype (a table-type)
with 1 blank row
	

To decide which number is the relevant row of (tab - a table-name):
  choose row with a tabname of tab in the Table of Table Types;
  let idx be the index entry;
  let ttype be the tabtype entry;
  increase idx by 1;
  if idx > the number of rows in tab begin;
    if ttype is shuffled-list, sort tab in random order;
    if ttype is stop-list, now idx is the number of rows in tab;
    otherwise now idx is 1;
  end if;
  now the index entry is idx;
  decide on idx.

To show the next response from  (tab - a table-name):
  let r be the relevant row of tab;
  choose row r in tab;
  say "[response entry][paragraph break]"

[The following is needed to allow a game including this file to compile even without any defining any tables containing a response column]

Table of Dummy
response
"dummy"


List Control ends here.

---- DOCUMENTATION ----
First, the story in brief: List Control provides three ways of traversing a list contained in a table: stop-list, cyclic-list and shuffled-list. To define which type applies to a given table, we define the corresponding row in the Table of Table Types:

	Table of Table Types (continued)
	tabname		index	tabtype
	Table of My Stuff		0	shuffled-list

	Table of My Stuff
	response
	"Boo!"
	"Whee"
	"Foo!"
	"Bar!"
	
To display the next response entry from such a table, we use the phrase:

	show the next response from the Table of My Stuff.

If we want to use a table other than one with a single column called 'response' containing text, we can instead obtain the next row number in our chosen sequence with the value:

	the relevant row in the Table of My Rules

For example

	let r be the relevant row of the Table of My Rules;
	choose row r in the Table of My Rules;
	follow the singing rule entry.
	
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

List Control provides a means of doing this. To set up a shuffled list, we would define:

	The Test Place is a room.

	Table of Jumps
	jump
	"Wow!"
	"You bang your head on the ceiling."
	"Whee!"
	"Ouch"

	Table of Table Types (continued)
	tabname		index	tabtype
	Table of Smells		0	cyclic-list

	Instead of jumping:
	 	let r be the relevant row of the Table of Jumps;
	 	choose row r in the Table of Jumps;
             	say "[jump entry]."

If we create a table with a single column called response which contains only text values, we can simplify this code even further:

	Table of Jumps
	response
	"Wow!"
	"You bang your head on the ceiling."
	"Whee!"
	"Ouch"

	Table of Table Types (continued)
	tabname		index	tabtype
	Table of Jumps		0	shuffled-list

	Instead of jumping:
		show the next response from the Table of Jumps.

Note that for this to work, we also have to define a continuation to the Table of Table Types. The first column must contain the name of the table we are defining, the second a number (normally zero), and the third the type of table we want it to be, which must be one of shuffled-list, stop-list or cyclic-list. 

The shuffled-list type runs through each row of the table in turn, then sorts the table in random order before starting again at the beginning. 
The stop-list type runs through each row in turn, then keeps repeating the final row of the table.
The cyclic-list type runs through each row in turn until it reaches the final row of the table, and then returns to the first row and repeats the rows in the same sequence as before.

Hence we might also define:

	Instead of Smelling the Test Place:
		show the next response from the Table of Smells.

	Table of Smells
	response
	"Poo!"
	"What a pong!"
	"Smells like rotten eggs"
	"Powerful whiff!"

	Table of Table Types (continued)
	tabname		index	tabtype
	Table of Smells		0	cyclic-list


	Instead of Listening to the Test Place:
		show the next response from the Table of Sounds.	

	Table of Sounds
	response
	"There's a lound ringing sound."
	"The ringing is fading."
	"Just a faint echo."
	"Silence."
  
	Table of Table Types (continued)
	tabname		index	tabtype
	Table of Sounds		0	stop-list

In the above examples we have defined each fragment of the continued Table of Table Types immediately after the table to which it refers. It may often be more convenient to do it that way, but we can of course collect this continued table all in one place if we prefer:

	Table of Table Types (continued)
	tabname		index	tabtype
	Table of Jumps		0	shuffled-list
	Table of Smells		0	cyclic-list
	Table of Sounds		0	stop-list

Note that the index value is normally 0, but it may sometimes be useful to define it as some other value. In particular, defining an index value of some number greater than the number of rows in a shuffled-list table will cause the table to be sorted in random order before choosing the first value from it (otherwise on the first pass through the rows will be displayed in the order in which they are listed in the table as defined, which may or may not be what we want).

Example: * Family Reunion - Using Tables to give successions of responses to questions and NPC fidgets

	*: "Family Reunion"

	Part 1 - Setup

	Include List Control by Eric Eve.

	The description of yourself is "Trim and upright, with a proud Prussian bearing - too bad about the withered arm, though."


	Part 2 - Scenario

	The Royal Lounge is a room. "Opulent in its way, to your eye this room nevertheless has a slightly dingy, old-fashioned look, no doubt because the Queen is so opposed to the idea of change, but also perhaps because England is so backward-looking compared with your new dynamic Germany."

	The window is scenery in the lounge. "It affords an excellent view of Windsor Great Park - or rather it would if the view were not largely obscured by the Prince of Wales."

	Bertie is a man in the Lounge. "Bertie is standing with his back to the window."
	Understand "prince" or "edward" or "of" or "wales" or "uncle" as Bertie.

	Queen Victoria is a woman in the Lounge. "Queen Victoria is sitting glowering sternly at her oldest son." The description is "She's still dressed in the black mourning weeds she's worn ever since the Prince Consort died."


	Part 3 - Queen Victoria's Conversation

	Instead of asking Queen Victoria about a topic listed in the Table of Queen Conversation:
		if there is a List Table entry, show the next response from the List Table entry;
		otherwise say "[Response entry][paragraph break]".
	
	After asking Queen Victoria about something:
	 	show the next response from the Table of Queen's Default Responses;
	 	stop the action.

	Understand "bertie" or "uncle" or "prince" as "[prince]".

	Table of Queen Conversation
	Topic		List Table				Response
	"[prince]"	Table of Queen's Bertie Responses		--
	"germany"	Table of Queen's Germany Responses	--
	"weather"	--					"'What do you think of the weather today, grandma?' you ask.[paragraph break]'It is tolerable,' she replies."


	Table of Queen's Bertie Responses
	response
	"'Isn't Uncle Bertie looking well?' you gush.

	'He's put on too much weight,' the Queen demurs critically."
	"'Are you keeping Bertie busy, grandma?' you enquire.

	'Bertie spends far too much time gallivanting,' the Queen disapproves."
	"'Don't you think Bertie will make a fine king one day, grandma?' you ask.

	'Over my dead body!' she replies fiercely."
	"Perhaps you have exhausted that topic for now."

	Table of Queen's Germany Responses
	response
	"'You should come and visit us in Germany, grandma,' you suggest.

	'Yes, I am sure Vicky would be pleased to see me,' she nods."
	"'Our two countries should become better friends, don't you think, grandma?' you propose.

	'That was always my dear Albert's dearest wish,' she smiles."
	"'Between us, Britain and Germany could rule the world!' you declare enthusiastically, 'What do you say, grandma?'

	'Well!' she frowns, looking slightly alarmed."
	"Bertie frowns and motions to you to keep quiet."


	Table of Queen's Default Responses
	response
	"'We are not amused, Willi,' she replies sternly."
	"'That is not something we are prepared to discuss,' she answers stiffly."
	"'I am surprised you should raise such a matter at such a time!' she rebukes you."
	"'No, we shall not discuss that!' she rules."


	Table of Table Types (continued)
	tabname				index	tabtype
	Table of Queen's Bertie Responses		0	stop-list
	Table of Queen's Germany Responses	0	stop-list
	Table of Queen's Default Responses	0	shuffled-list


	Part 4 - Bertie's Fidgeting
	
	Table of Bertie's Fidgets
	response
	"Uncle Bertie clears his throat."
	"Uncle Bertie shuffles from one foot to the other."
	"The Prince of Wales manfully stifles a yawn."
	"Bertie scratches his right ear."
	"Bertie pats his jacket as if looking for a cigar, but then remembers himself just in time."

	Table of Table Types (continued)
	tabname				index	tabtype
	Table of Bertie's Fidgets			0	cyclic-list

	Every turn when a random chance of 1 in 3 succeeds:
		  show the next response from the Table of Bertie's Fidgets.

	Part 5 - Test

	Test me with "x bertie/x queen/x window/ask queen about bertie/g/g/g/ask queen about weather/ask queen about love/ask queen about war/ask queen about germany/g/g/g/ask queen about William Gladstone/ask queen about Disraeli/ask queen about germany"



