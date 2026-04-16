Version 2.1 of Print Stage Detection by Taryn Michelle begins here.

"'Printing the name' rules make TWO passes over the same object when Inform needs to determine the appropriate article to print. This is a non-issue for many rules, but 'printing the name' rules with side effects may need to know which stage is currently being processed (article-choosing or name-printing), so that they can avoid double-execution of any side effects.  Updated for compatability with Inform version 10.1.2"

Section - I6 Code

[I6 Code moved to kit "PSDKit"]

[Place global here in case any I7 rule tries to directly test "if name-printing is choosing articles"; otherwise an I6 compilation error occurs.]

[! flag to signal when printing to array for article determination]

[ Include (- Global article_choosing  =  false;  -). ]

Section - Adding pass-detection to the printing the name activity

To decide whether name-printing is choosing articles:  (- ( article_choosing  ~= 0 ) -).

A printing-stage is a kind of value.  The printing-stages are article-choosing and name-printing.
To decide what printing-stage is the print-stage:
	if name-printing is choosing articles:
		decide on article-choosing;
	decide on name-printing.

Print Stage Detection ends here.
