Version 2.2 of Unknown Word Error by Mike Ciul begins here.

"Provides Infocom-style parser messages such as 'I don't know the word 'kludge'.'"

"updated from the original by Neil Cerutti"

Include (-
[ FindUnknownWordToken wordnum 
 w twn numwds;
#ifdef TARGET_GLULX;
 numwds = parse-->0;
#ifnot;
 numwds = parse->1;
#endif; ! TARGET_GLULX;
 ! Throw out invalid word numbers
 if (wordnum <= 0 || wordnum > numwds) rfalse;
 twn=wn; ! save the value of wn so it can be restored
 wn=wordnum;
 while (1)
 { w=NextWordStopped();
   if (w == -1) { wn=twn; rfalse; }
   if (w == 0 && TryNumber(wn-1) == -1000) 
   { wordnum=wn-1;
     wn=twn;
     return wordnum; 
   }
 }
];
-)

To decide what number is the/-- position of non-dictionary word: (- FindUnknownWordToken(2) -)

Include (-
[ PrintToken wordnum 
 k l m numwds;
#ifdef TARGET_GLULX;
 numwds = parse-->0;
#ifnot;
 numwds = parse->1;
#endif; ! TARGET_GLULX;
 if (wordnum <= 0 || wordnum > numwds) return;
 k=WordAddress(wordnum); 
 l=WordLength(wordnum); 
 for (m=0: m < l: m++) 
   print (char) k->m; 
];
-)

To say the/-- word at position/-- (N - a number): (-
	PrintToken({N});
-)

[ The default error message printing for this in Parser.i6t does this. ]
To restore oops from: (-
	oops_from=saved_oops;
-)

Rule for printing a parser error when the latest parser error is the can't see any such thing error (this is the don't know that word rule):
	Let N be the position of non-dictionary word;
	if N is zero:
		make no decision;
	say "I don't know the word '[word at position N]'.";
	restore oops from;

Unknown Word Error ends here.

---- DOCUMENTATION ----

This is an update of Neil Cerruti's Unknown Word Error, which is a wrapper of Neil Cerutti's Dunno extension for Inform 6:  

	Dunno - A Library Extension by Neil Cerutti (cerutti@together.net)
	Version 1.0 - 25 Jun 1999
		Initial release
	Version 1.1 - 2 Apr 2001
		Modified by Andrew Plotkin for Glulx compatibility.

If, for some reason, you always wanted the Infocom-style error messages that say:

	I don't know the word "kludge".

instead of the generic message:

	You can't see any such thing.

which is the default in Inform 7.

To get this behavior, simply include this extension in your story.

To customize the message, you must replace the "don't know that word rule":

	Rule for printing a parser error when the latest parser error is the can't see any such thing error (this is the don't know that word rule):
		Let N be the position of non-dictionary word;
		if N is zero:
			make no decision;
		say "I don't know the word '[word at position N]'.";

Example: * Ignorance is Bliss - A brief test of this extension.
	
	*: "Ignorance is Bliss"

	Include Unknown Word Error by Mike Ciul.

	The Conference Chamber is a room. In the Conference Chamber is a table. On the table is a treaty.

	Test me with "examine non-proliferation treaty".

Example: ** Oops - Regression test for interaction between this extension and parser oops.

	*: "Oops"

	Include Unknown Word Error by Mike Ciul.

	The Conference Chamber is a room. In the Conference Chamber is a table. On the table is a treaty.

	Understand "put [something preferably held] on top of [something]" as putting it on.

	[ Without "restore oops from" above, this oops would result in "put table on tabl" and get the same error message a second time because of some parsing weirdness. ]
	Test me with "put treaty on tabl / oops table".

