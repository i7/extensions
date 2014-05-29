Article Bug Fix by Daniel Stelzer begins here.

"Fixes for two small bugs with indefinite articles."

"wrapping I6 code by eu and zarf"

Include (-
Global short_name_case;
Global suppress_articles = false;

[ PrefaceByArticle obj acode pluralise capitalise  i artform findout artval;
    if (suppress_articles) {
	print (PSN__) obj; return;
    }
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
        suppress_articles = true;
        StorageForShortName-->0 = 160;
        @output_stream 3 StorageForShortName;
        if (pluralise) print (number) pluralise; else print (PSN__) obj;
        @output_stream -3;
        acode = acode + 3*LanguageContraction(StorageForShortName + 2);
        suppress_articles = false;
    }
    #Ifnot; ! TARGET_GLULX
    if (findout) {
        suppress_articles = true;
        if (pluralise)
            Glulx_PrintAnyToArray(StorageForShortName, 160, EnglishNumber, pluralise);
        else
            Glulx_PrintAnyToArray(StorageForShortName, 160, PSN__, obj);
        acode = acode + 3*LanguageContraction(StorageForShortName);
        suppress_articles = false;
    }
    #Endif; ! TARGET_

    Cap (artform-->acode, ~~capitalise); ! print article
    if (pluralise) return;
    print (PSN__) obj;
];
-) instead of "Object Names II" in "Printing.i6t".

Include (-
Replace CIndefArt;
-) before "Printing.i6t".

Include (-
[ CPrintText text  length i;
	VM_PrintToBuffer (StorageForShortName, 160, TEXT_TY_Say, text);

	length = StorageForShortName-->0;

	StorageForShortName->WORDSIZE = VM_LowerToUpperCase(StorageForShortName->WORDSIZE);
	for (i=WORDSIZE: i<length+WORDSIZE: i++) print (char) StorageForShortName->i;
	if (i>WORDSIZE) say__p = 1;

	return;
];
[ CIndefArt obj i;
	if (obj == 0) { LIST_WRITER_INTERNAL_RM('X'); rtrue; }
	i = indef_mode; indef_mode = true;
	if (obj has proper) {
		indef_mode = NULL;
		caps_mode = true;
		print (PSN__) obj;
		indef_mode = i;
		caps_mode = false;
		return;
	}
	if ((obj provides article) && (TEXT_TY_Compare(obj.article, EMPTY_TEXT_VALUE) ~= 0)) {
		CPrintText(obj.article); print " ", (PSN__) obj; indef_mode = i;
		return;
	}
	PrefaceByArticle(obj, 2, 0, 1); indef_mode = i;
];
-) after "Printing.i6t".

Article Bug Fix ends here.

---- DOCUMENTATION ----

This is a quick fix for a bug with printing the articles of containers. I made this extension as a wrapper around I6 code by eu.

EDIT: It now includes a fix by Zarf for an unrelated bug.

Example: * Lab

Lab is a room. An urn is a container in the lab. The player carries a ball.

The indefinite article of the urn is "an".

Rule for printing the name of the urn when looking:
	omit contents in listing;
	say "urn";
	if the ball is in the urn:
		say " with [a ball] in it".

Test me with "look/put ball in urn/look".
