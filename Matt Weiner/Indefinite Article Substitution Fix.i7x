Version 1/161126 of Indefinite Article Substitution Fix (for Glulx only) by Matt Weiner begins here.

Section 1 - Caching the name in PrefaceByArticle

[The PrefaceByArticle routine is copied from Printing.i6t and modified to cache the result of the printing the name of rules in the buffer cached_name. We also set a global flag name_cached which will tell us when we have cached the name]

Include (- 
Global short_name_case;

[ PrefaceByArticle obj acode pluralise capitalise  i artform findout artval buflen;
	!if ( name_cached = true ) { ! prevent reentrant calls from also attempting to choose an article, thereby disrupting article-choosing for the original object. (This is okay -- they will get their turn to print as requested later on, during the name-printing stage for the original object.)
	!	print (PSN__) obj; return;
	!}
	if (obj provides articles) {
		artval=(obj.&articles)-->(acode+short_name_case*LanguageCases);
		if (capitalise)
			print (Cap) artval, " ";
		else
			print (string) artval, " ";
		if (pluralise) return;
		print (PSN__) obj; return;
	}

	i = GetGNAOfObject(obj);
	if (pluralise) {
		if (i < 3 || (i >= 6 && i < 9)) i = i + 3;
	}
	i = LanguageGNAsToArticles-->i;

	artform = LanguageArticles
		+ 3*WORDSIZE*LanguageContractionForms*(short_name_case + i*LanguageCases);

	#Iftrue (LanguageContractionForms == 2);
	if (artform-->acode ~= artform-->(acode+3)) findout = true;
	#Endif; ! LanguageContractionForms
	#Iftrue (LanguageContractionForms == 3);
	if (artform-->acode ~= artform-->(acode+3)) findout = true;
	if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
	#Endif; ! LanguageContractionForms
	#Iftrue (LanguageContractionForms == 4);
	if (artform-->acode ~= artform-->(acode+3)) findout = true;
	if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
	if (artform-->(acode+6) ~= artform-->(acode+9)) findout = true;
	#Endif; ! LanguageContractionForms
	#Iftrue (LanguageContractionForms > 4);
	findout = true;
	#Endif; ! LanguageContractionForms

	#Ifdef TARGET_ZCODE;
	if (standard_interpreter ~= 0 && findout) {
		StorageForShortName-->0 = 160;
		@output_stream 3 StorageForShortName;
		name_cached = true;
		if (pluralise) print (number) pluralise; else print (PSN__) obj;
		@output_stream -3;
		acode = acode + 3*LanguageContraction(StorageForShortName + 2);
	}
	#Ifnot; ! TARGET_GLULX
	if (findout) {
		if (pluralise)
			buflen = Glulx_PrintAnyToArray(StorageForShortName, 160, EnglishNumber, pluralise); ! This prints to StorageForShortName and also sets buflen to the length of what we've printed
		else
			buflen = Glulx_PrintAnyToArray(StorageForShortName, 160, PSN__, obj); ! This prints to StorageForShortName and also sets buflen to the length of what we've printed
		cached_name->0 = buflen;
		for (i=0:i<buflen+1:i++) cached_name->(i+1) = StorageForShortName->i; ! copy StorageForShortName into cached_name, with the copied length stored in buflen
		name_cached = true; ! flag that we've cached the name
		acode = acode + 3*LanguageContraction(StorageForShortName);
	}
	#Endif; ! TARGET_

	Cap (artform-->acode, ~~capitalise); ! print article
	if (pluralise) return;
	print (PSN__) obj;
]; -) instead of "Object Names II" in "Printing.i6t";

Include (- Global name_cached = false; ! flag to signal we have cached the name while calculating the article
Array cached_name buffer 250; ! where we cache the name -) after "Definitions.i6t". 

Section 2 - Printing the Cached Name in PSN__

Include (- [ PrintCachedName len i; ! Prints CachedName out; depends on the fact that CachedName stores its length in entry 0
	len = cached_name->0;
	for ( i = 0 : i < len : i++ )
	{
		glk_put_char(cached_name->(i + 1));
	}
]; -)

Include (-
[ PSN__ o i;
    if (o == 0) { LIST_WRITER_INTERNAL_RM('Y'); rtrue; }
    switch (metaclass(o)) {
		Routine:  print "<routine ", o, ">"; rtrue;
		String:   print "<string ~", (string) o, "~>"; rtrue;
		nothing:  print "<illegal object number ", o, ">"; rtrue;
    }
    RegardingSingleObject(o);
	if (name_cached == true) !if we cached the name, we print it and reset the name_cached flag
	{
		PrintCachedName(); 
		name_cached = false;
	}
	else !otherwise we carry out the standard printing the name activity
		CarryOutActivity(PRINTING_THE_NAME_ACT, o);
];
-) instead of "Object Names I" in "Printing.i6t". 

Indefinite Article Substitution Fix ends here.

---- DOCUMENTATION ----

Indefinite Article Substitution Fix (for Glulx only, at present) is intended to fix a bug in the interaction of indefinite articles with text substitutions. 

When an improper-named object does not have a defined indefinite article, Inform by default supplies the article "a" or "an." In order to figure out whether "a" or "an" is needed, 
Inform carries out the printing the name of activity for the object, redirecting the output to the buffer StorageForShortName rather than the screen. It then checks whether the first character in StorageForShortName is a vowel, prints the appropriate article; and carries out the printing the name of activity for the object again, this time with the output directed to the screen.

The problem is that this runs the printing the name of activity twice, which can have undesirable side effects. For instance, if any of the rules before/for/after printing the name of the object involve a cycling or random subsitution, the substitution will be evaluated once when deciding what article to print and again when printing the name of the object. This will cause cycling substitutions to cycle twice rather than once, and can cause mismatches between the article chosen and the text that winds up getting printed. 

Indefinite Article Substitution Fix addresses this problem by caching the text that is printed to StorageForShortName to the cached_name buffer when the I6 routine PrefaceByArticle carries out the printing the name of activity in order to determine which article to use. PSN__, the routine that prints the name of the object, then checks to see whether the name has been cached. If so, PSN__ prints the contents of the cached_name buffer rather than carrying out the printing the name of activity again.

You don't need to worry about any of those internals, though; Indefinite Article Substitution Fix is a plug-and-play extension. Simply including it should repair the interaction of indefinite articles with substitutions.

Known limitations (as of Nov. 26, 2016):

This extension is incompatible with Print Stage Detection by Taryn Michelle, and any other extension that directly modifies Object Names II or Object Names I in "Printing.i6t". 

This extension is currently Glulx only. It may be possible to do the work to make it work with the z-machine as well, although working with StorageForShortName seems to be trickier in the z-machine than in Glulx.

Since the name that is printed first gets shuffled through StorageForShortName, and StorageForShortName is a byte array rather than a word array, this extension will not be able to print any characters that cannot be used outside quoted text in the source code, per Writing with Inform §5.10. Those who want to have a book with printed name "œnology text" will have to look elsewhere.

As with the standard Inform template, the algorithm for checking which form of the indefinite article should be used is simply "Does it start with a vowel?" So if we do not directly specify articles, we will get "a hourglass" and "an one-hour photo booth." If you are interested in my code for trying to address this, or in anything else about the extension, contact me at myfirstname@myfirstnamemylastname.net.

Thanks to Taryn Michelle, whose Print Stage Detection extension was a very helpful gude; Hugo Labrande, for reminding me of Print Stage Detection; and Daniel Fremont, for invaluable I6 assistance.

Example A demonstrates that the traffic signal's name properly cycles through "a green traffic signal"/"an amber traffic signal"/"a red traffic signal". Without the extension it would be "a amber traffic signal"/"an red traffic signal"/"a green traffic signal". Various other things are included to demonstrate that nested indefinite articles, proper-named things, plural-named things, and things with custom indefinite articles still appear to print properly.

Example: * Although My Name's Not Bamber - Demonstrating use of an indefinite article with a cycling substitution.

	*:Include Indefinite Article Substitution Fix by Matt Weiner.

	Crossroads is a room. 

	A traffic signal is in the Crossroads. 

	Before printing the name of the traffic signal, say "[one of]green[or]amber[or]red[cycling] ".

	An Opel is a vehicle in Crossroads. A dashboard is in the Opel. A book is on the dashboard. 

	The book can be open. The book is open. Before printing the name of the open book: say "open ".

	Some sand is in Crossroads. A lollipop lady is a woman in the crossroads. The indefinite article of the lollipop lady is "that old reliable". Mr Gascoigne is a man in the crossroads.

	Test me with "l/l/l/l/l".
