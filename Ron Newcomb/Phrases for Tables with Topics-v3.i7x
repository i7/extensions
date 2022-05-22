Version 3 of Phrases for Tables with Topics by Ron Newcomb begins here.

"This grants five new phrases regarding the player's command, the matched text, and the topic understood: if one is a topic listed in a table, if one includes or matches a topic listed in a table, what corresponds to one within a table, and the last phrase corrects a bug so the topic understood may be used within an understand-as-mistake line." 


[There's 3 snippets:  the player's command, the topic understood ("[text]"), and the matched text ("matches/includes") ]

To decide whether (player's topic - a snippet) is a/the/any/-- topic listed in (tab - a table name):
	repeat through tab:
		if the player's topic includes the topic entry, decide yes;
	decide no.

To decide whether (snip - a snippet) includes (col - a table column) listed in (tab - a table name):
(- (IfSnippetIncludesTableColumn({snip}, {col}, {tab})) -).

Include (-
[ IfSnippetIncludesTableColumn   snip col tab     row;
   if (snip < 101) rfalse; 
   for (row=1  :  row<=TableRows(tab) :  row++)
      if ((TableRowIsBlank(tab, row)==false)  && (( (matched_text=SnippetIncludes(TableLookUpEntry(tab, col, row), snip)) )) )
            rtrue;   
   rfalse;
];
-).

To decide whether (snip - a snippet) matches (col - a table column) listed in (tab - a table name):
(- (IfSnippetMatchesTableColumn({snip}, {col}, {tab})) -).

Include (-
[ IfSnippetMatchesTableColumn   snip col tab     row;
   if (snip < 101) rfalse; 
   for (row=1  :  row<=TableRows(tab) :  row++)
      if ((TableRowIsBlank(tab, row)==false)  && (( (matched_text=SnippetMatches(snip, TableLookUpEntry(tab, col, row))) )) )
            rtrue;   
   rfalse;
];
-).

To decide which K is (col - a value of kind K valued table column) corresponding to a/the/-- topic of (player's topic - a snippet) in/from (tab - a table name):
	repeat through tab:
		if the player's topic includes the topic entry, decide on the contents of col;
	decide on the default value of K.

To decide which K is the contents of (col - a value of kind K valued table column): (- (TableLookUpEntry(ct_0, {col}, ct_1)) -).

Include (- 
[ CorrespondingTopic   snip col tab     row foo;
   if (snip < 101) rfalse; 
   for (row=1  :  row<=TableRows(tab) :  row++)
     if (TableRowIsBlank(tab, row)==false) 
     {
	foo =  TableLookUpEntry(tab, col, row);
	if (matched_text=SnippetIncludes(foo, snip))  return foo;
     }
   rfalse;
];
-).

To decide which K is (col - a value of kind K valued table column) corresponding to row (N - a number) in/from/of (tab - a table name):
	choose row N in tab;
	decide on the contents of col.
	


To say fix the/-- topic understood: now the parsed number is (consult_from multiplied by 100) + consult_words.
[use like: 
	Understand "[text]" as a mistake ("[fix the topic understood]About [the topic understood]...").
]

Section - exposing I6 - unindexed

Parsed number is a number that varies. Parsed number variable translates into I6 as "parsed_number". 
consult_from is a number that varies. consult_from variable translates into I6 as "consult_from". 
consult_words is a number that varies. consult_words variable translates into I6 as "consult_words". 


Phrases for Tables with Topics ends here.

---- DOCUMENTATION ----

The player's command, the topic understood (known as "[text]" in an Understand line), and the matched text (usually used in an After Reading A Command rule) are all of a kind called a "snippet".  This extension grants four new phrases to be used with them, and one phrase that corrects a bug in Inform.

First:
	*: if (a snippet) is a topic listed in (a table)

For use like:
	Understand "[text]" as a mistake ("(No, that's not quite right.)") when the player's command is not a topic listed in the table of magic words.

Second:
	*: if (a snippet) includes (a 'topic' column) listed in (a table)

For use like:
	The Spanish Inquisition ends when the player's command includes a topic listed in the table of magic words.

Third:
	*: if (a snippet) matches (a 'topic' column) listed in (a table)

For use like:
	After reading a command when the player's command matches a topic listed in the table of magic words: ...

Fourth:
	*: which K is (a K-valued table column) corresponding to a topic of (a snippet) in (a table)

For use like:
	When the Spanish Inquisition ends, say the response corresponding to a topic of the player's command from the table of magic words.

And finally:
	*: "[fix the topic understood]"
	
For use like:
	Understand "[text]" as a mistake ("'[fix topic understood]We know that [topic understood] is not a magic word! You cannot fool us, witch!'").
	
JUST ADDED:
	*: which K is (a K valued table column) corresponding to row (a number) in (a table)
	
For use like:
	say the response corresponding to row 2 in the table of magic words.
	

Example: * Fear and Surprise - A brief demonstration of power.

	*: "Fear and Surprise"

	Include Phrases for Tables with Topics by Ron Newcomb.

	The cathedral is a room.  There is a woman called witch. The player is a witch. 

	The Spanish Inquisition is a scene. "'All witches know magic words!  Tell us, witch, what they are!'"
	The Spanish Inquisition begins when play begins.
	The Spanish Inquisition ends when the player's command includes a topic listed in the table of magic words.
	When the Spanish Inquisition ends, say the response corresponding to a topic of the player's command from the table of magic words.

	Table of magic words
	topic		response
	"xyzzy"	"Suddenly you pop out of existence!"
	"plugh"	"In a swirl of feathers, you disappear!"

	Understand "[text]" as a mistake ("'[fix topic understood]We know that [topic understood] is not a magic word! You cannot fool us, witch!'") when the Spanish Inquisition is happening and the player's command is not a topic listed in the table of magic words.

	After reading a command when the player's command matches a topic listed in the table of magic words:
		follow the scene changing rules;
		replace the player's command with "x me";
		move the player to the forest.

	The forest is a room.

	Test me with "no / foo / plugh / foo".

