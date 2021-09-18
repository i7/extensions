Version 1 of Tabulate by Zed Lopez begins here.

"Provides a phrase to go from a text to a table name, and a not-for-release
tabulate action to show the contents of a table. For 6M62."

Use authorial modesty.

Part Text to Table Name

To decide what table name is the null table: (- nothing -).

To decide what table name is (T - a text) as a table name:
    let t be T in lower case;
    repeat with tbl running through table names begin;
      let tbl-text be "[tbl]";
      let tbl-name be "[tbl-text in lower case]";
      if "[t]" is tbl-name or "table of [t]" is tbl-name, decide on tbl;
    end repeat;
    decide on the null table.

Part Tabulate Action (not for release)

The table understood is a table name that varies.

Tabulating is an action out of world applying to one topic.
Understand "tabulate [text]" as tabulating.

Check tabulating:
    let t be "[the topic understood]";
    now the table understood is t as a table name;
    if the table understood is the null table, instead say "I can't find a table named [the topic understood]."

Carry out tabulating:
  showme the contents of the table understood.

Tabulate ends here.

---- Documentation ----

Adds a not-for-release "tabulate" command to show table contents.

Example: * Table of Stats

	*: "Table of Stats"
	
	Include Tabulate by Zed Lopez.
	
	Lab is a room.
	
	Table of Stats
	name	x	y
	"foo"	1	2
	"bar"	5	9
	
	Test me with "tabulate table of stats / tabulate stats".
