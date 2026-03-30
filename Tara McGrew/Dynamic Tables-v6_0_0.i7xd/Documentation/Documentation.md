This extension allows the number of rows in a table to be changed at runtime. For example:

	change the Table of Ice Cream Flavors to have 31 rows;

Using that phrase, we may change the size of any table to any non-negative number of rows at any time. After resizing the table, the data that was stored in the table will still be there, the usual table phrases like "the number of rows in Table of Ice Cream Flavors" will reflect the new size, and in general the table will behave exactly as if we had defined it with 31 rows in the source code.

The only way to tell that the table has been resized at all is to use the new phrase "the original number of rows in Table of Ice Cream Flavors", which will return the number of rows that were defined in the source code. If the table hasn't been resized, the original number of rows will be the same as the number of rows.

When we make a table larger, new blank rows are added at the end of the table.

When we make a table smaller, rows are deleted from the end of the table. If the deleted rows aren't blank, the data stored there will be lost. To avoid losing data unnecessarily, we might want to sort the table before making it smaller, since sorting will push all the blank rows to the end.

We can even change a table to have fewer rows than it was defined with. This probably isn't useful, though, since it will use more memory than if we had left the table at its original size.

Changing the size of a table will allocate memory from Inform's heap, the space that's also used for indexed text, lists, and stored actions. The operation might fail if the heap is too full, leaving the table at its old size; this extension won't print an error message, but we can check the number of rows afterward to be sure it succeeded. If we change a table back to its original size, the memory will be reclaimed and the table will go back into the space it originally occupied.

If the game doesn't use indexed text, lists, or stored actions at all, Inform won't normally create a heap, so this extension forces it to create a small heap in that situation (half the normal minimum size). If that isn't big enough, we should add a stored action variable somewhere to make Inform create the heap itself, and then the usual settings like "Use dynamic memory allocation of at least 16384" will work if we need even more space.

Section: Creating New Tables

This extension also allows us to create new tables at runtime, which can be referred to with table-name variables or properties. For example:

	let T be a new table with columns {speaker, quip} and 10 blank rows;

After that phrase, "T" is now a table-name variable pointing to a new table, containing two columns and ten rows. Despite the variable's type being called "table-name", the new table has no actual name, and "say T" will show "** Dynamically created table **" instead.

Note that we have two obligations if we use this syntax. First, we must define the columns ("speaker" and "quip" in this example) in another table in the source code somewhere, so that Inform knows what kinds of value are supposed to go there. We can reuse columns from another table we're already using, or we can define a new table just for this purpose; once the columns have been defined, we can create as many new tables using them as we need.

Second, we must not lose the value of "T", since it's the only way to refer to the new table. If the table is going to stay in use until the end of the game, we should store it in a global variable or a property. If we only need the table temporarily, we should return its memory when we're done with it by writing:

	deallocate T;

(Note that "T" will no longer be a valid table-name once it's been deallocated, so it must not be used afterward.)

To see whether a particular table-name value points to a table that was created this way, we can write:

	if T was dynamically created, [...]

This syntax is useful when we have a table-name variable that might point to a table defined in the source, or maybe a new table, and so we aren't sure whether it needs to be deallocated when we're done with it. It can also be used to check whether the table was created successfully -- if there wasn't enough memory to create the new table, the phrase will return false.

Section: Change Log

Version 2 adds the "new table" and "deallocate table" features.

Version 3 works with Inform 7 version 6E59.

Version 4 fixes a bug where dynamically created tables couldn't be resized.

Version 5 works with (and requires) version 6L38.

Version 5.1 works with (and requires) version 10.1.2.

Version 6 currently works with (and requires) version 10.2. Be aware that 10.2 is in active development, so there is always a chance something may break down the line. The extension was successfully tested with a build of the current Inform master branch from March 24, 2026 at 22:24 GMT.

