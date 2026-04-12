Version 2.11 of Print Stage Detection by Taryn Michelle begins here.

"'Printing the name' rules make TWO passes over the same object when Inform needs to determine the appropriate article to print. This is a non-issue for many rules, but 'printing the name' rules with side effects may need to know which stage is currently being processed (article-choosing or name-printing), so that they can avoid double-execution of any side effects.  Updated for compatability with Inform version 10.1.2"

Section - I6 Code

[Place global here in case any I7 rule tries to directly test "if name-printing is choosing articles"; otherwise an I6 compilation error occurs.]

[! flag to signal when printing to array for article determination]
Include (- Global article_choosing  =  false;  -) [after "Definitions.i6t"]. 

[The PrefaceByArticle routine is copied from Printing.i6t and modified to set a global flag which will tell us when PSN__ (the routine that ends up invoking the 'printing the name' activity) is printing to a buffer (to determine what article to choose) or displaying output.]

Include (- 

[ PrefaceByArticle obj acode pluralise capitalise  i artform findout artval;
	!print "*We're Alive*";
	if ( article_choosing ) { ! prevent reentrant calls from also attempting to choose an article, thereby disrupting article-choosing for the original object. (This is okay -- they will get their turn to print as requested later on, during the name-printing stage for the original object.)
		print (PSN__) obj; return;
	}
	if (obj provides articles) {
		artval=(obj.&articles)-->(acode+short_name_case*LanguageCases);
		if (capitalise)
			print (Cap) artval;
		else
			print (string) artval;
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

	switch (LanguageContractionForms) {
		2: 	if (artform-->acode ~= artform-->(acode+3)) findout = true;
		3: 	
			if (artform-->acode ~= artform-->(acode+3)) findout = true;
			if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
		4: 	
			if (artform-->acode ~= artform-->(acode+3)) findout = true;
			if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
			if (artform-->(acode+6) ~= artform-->(acode+9)) findout = true;
		default: 
			findout = true;
	}

	#Ifdef TARGET_ZCODE;
	if (standard_interpreter ~= 0 && findout) {
		StorageForShortName-->0 = 160;
		@output_stream 3 StorageForShortName;
		article_choosing = true;
		if (pluralise) print (number) pluralise; else print (PSN__) obj;
		article_choosing = false;
		@output_stream -3;
		acode = acode + 3*LanguageContraction(StorageForShortName + 2);
	}
	#Ifnot; ! TARGET_GLULX
	if (findout) {
		!print "*article_choosing*";
		article_choosing = true;
		if (pluralise)
			Glulx_PrintAnyToArray(StorageForShortName, 160, EnglishNumber, pluralise);
		else {
			!print "*PrintAnyToArray*";
			Glulx_PrintAnyToArray(StorageForShortName, 160, PSN__, obj);
			! print StorageForShortName;
			! we don't need findout anymore
			! We so need to generalize this
			!for ( i = 0 : i < StorageForShortName->0 : i++ )
			!{
			!	print (char) StorageForShortName->(i + 1);
			!}
		}	
		article_choosing = false;
		acode = acode + 3*LanguageContraction(StorageForShortName);
	}
	else {
		!print "*no findout*";
	}
	#Endif; ! TARGET_

	Cap (artform-->acode, ~~capitalise); ! print article
	if (pluralise) return;
	print (PSN__) obj;
]; -) replacing "PrefaceByArticle";

Section - Adding pass-detection to the printing the name activity

To decide whether name-printing is choosing articles:  (- ( article_choosing  ~= 0 ) -).

A printing-stage is a kind of value.  The printing-stages are article-choosing and name-printing.
To decide what printing-stage is the print-stage:
	if name-printing is choosing articles:
		decide on article-choosing;
	decide on name-printing.

Print Stage Detection ends here.
