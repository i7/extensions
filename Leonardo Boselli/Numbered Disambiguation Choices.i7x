Version 7/140902 of Numbered Disambiguation Choices by Leonardo Boselli begins here.

"Numbers the options in disambiguation questions, to help new players and solve the 'disambiguation loop' problem caused by indistinguishable objects. Modified to support hyperlinks."

Include Numbered Disambiguation Choices by Aaron Reed.


Chapter - Number Choices

The Numbered Disambiguation Choices preface disambiguation objects with numbers rule is not listed in any rulebook.

Before printing the name of something (called macguffin) while asking which do you mean (this is the hyperlinked preface disambiguation objects with numbers rule):
	if disambiguation-busy is false:
		now disambiguation-busy is true;
		add macguffin to the list of disambiguables, if absent;
		now the disambiguation id of macguffin is the number of entries in list of disambiguables;
		say "[italic type]([t]" (A);
		say "[the number of entries in list of disambiguables]";
		say "[x][italic type])[roman type] " (B);


Numbered Disambiguation Choices ends here.

---- DOCUMENTATION ----

Read the original documentation of Numbered Disambiguation Choices by Aaron Reed.