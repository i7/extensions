Version 2.0.241013 of Print Stage Detection by Taryn Michelle begins here.

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

---- Documentation ----

'Printing the name' rules make TWO passes over the same object when Inform needs to determine the appropriate article to print. This is a non-issue for many rules, but 'printing the name' rules with side effects may need to know which stage is currently being processed (article-choosing or name-printing), so that they can avoid double-execution of any side effects.

This extension also addresses an issue with reentrance, whereby printing the name of a second object from within a 'printing the name' rule could end up causing an incorrect indefinite article to be chosen for the first object. (Thanks to Brady Garvin for pointing this out! The modified I6 PrefaceByArticle routine included here incorporates the same fix as that previously packaged up by Daniel Steltzer at https://dl.dropboxusercontent.com/u/20455422/Article%20Bug%20Fix.i7x.) 

The two 'printing the name' passes are non-obvious, since the first pass quietly redirects all printing to an internal buffer, where it examines the result to decide what article should be selected.  If you're surprised by this (I certainly was when I first encountered it), run the example code to see that printing the name rules do indeed get fired off TWICE each time an object is printed up with an article. 

Section: Testing the print-stage:

This extension adds a kind of value called printing-stage. The values are either "article-choosing" (nothing is printed up during the article-choosing stage; all print output goes to an internal array buffer) or "name-printing" which is when the results get printed out. 

When writing any 'printing the name' rules with side effects, it's usually important to make sure those side effects happen only once, most likely during the name-printing stage.  The value "print-stage" is used to test which stage the printing the name activity is processing, as follows:

	Every thing has a number called times-printed.
	For printing the name of something (called the target):
		if print-stage is name-printing:
			increase times-printed of the target by 1.
			
In this simple example, we count the number of times an object is printed. Without the check for which stage the rules are in, the times-printed would end up being incorrectly doubled.

If a rule is going to print up a name, then it must do so in both stages, and obviously it should print up the same name in both stages. The good news is, for the vast majority of cases, this just means writing 'printing the name' rules the way we always have -- without concern for what print stage is happening under the covers:

	For printing the name of the gorgeous flower during allergy attack: [assume the gorgeous flower is something defined and allergy attack is a scene]
		say "awful, allergen-spewing flower".
		
An ordinary 'printing the name' rule like this one this will correctly produce output such as "You can see an awful, allergen-spewing flower here." during the allergy attack scene, as opposed to "a gorgeous flower" elsewhere.

In actuality, a rule only needs to print the same *beginning* of the name in both stages for article-chosing to work properly. It's a fine point of detail, but the following would also work just fine:
	
	For printing the name of the gorgeous flower during allergy attack:
		say "awful, ";
		if print-stage is name-printing:
			say "allergen-spewing flower".
			
Obviously there's no reason to do this -- for this trivial example, the original straightforward rule will do. However, if we had instead written a rule to follow up the name of a container, say, with its contents, then it could be reasonable to defer doing anything with the contents until the name-printing stage. While not strictly necessary (the included fix for reentrance is included precisely to address this sort of situation) it is arguably cleaner to print only what needs to be printed during article-choosing, and defer any significant extra work to the name-printing stage.

If a rule is going to print anything in front of the object name that we do not want to be considered by the article-choosing rules, then such output should be omitted from the article-choosing pass. For example:

	Before printing the name of something (called the target) (this is the begin markup around printed objects rule):
		if print-stage is name-printing:
			begin markup.
	
	After printing the name of something (called the target) (this is the end markup around printed objects rule):
		if print-stage is name-printing:
			end markup.

where it's assumed "begin markup" and "end markup" are defined elsewhere. The example below places "-->" and "<--" around printed object names for illustrative purposes, but the markup could in fact be anything, such as HTML, for example. The point is, allowing anything else to be printed in front of the object name during the article-choosing stage can cause an incorrect article to be chosen.  Deferring such markup to the name-printing stage prevents the problem.

Finally, note that only the name-printing stage is always guaranteed to occur. The article-choosing stage occurs only for improper-named objects which do not already explicitly specify the article property, and then only if we asked for an article to be printed (i.e., a phrase such as say "[an item]" or "[the item]" was used, as opposed to say "[item]" without any article). 

Section: Tweaking article determination

The section above mainly discussed various things to avoid in the article-choosing stage, but we can also take advantage of knowing when article-choosing is happening to deal with some tricky cases. Here is an example (again, courtesy of Brady Garvin) that Inform, by default, doesn't get quite right:

	*: Include Print Stage Detection by Taryn Michelle.
	Use the American dialect.
	Kitchen is a room.
	An olive oil blend is a thing in the kitchen.
	The olive oil blend can be herb-infused; it is herb-infused.
	Before printing the name of the herb-infused olive oil blend:
		if the print-stage is article-choosing and the American dialect option is active:
			say "erb-infused "; [Americans don't pronounce the 'h', so choose the article accordingly.]
		otherwise: 
			say "herb-infused ".

Example: ** Print Stage Demo - A simple demonstration of the two passes the printing the name activity makes when printing an object with an article, and the use of Print Stage Detection to deal with some issues that arise.

	*: "Print Stage Demo" 

	Include Print Stage Detection by Taryn Michelle.

	A thing has a number called the look-examine-count. The look-examine-count of a thing is usually 0.
	A thing has a number called the times-printed. The times-printed of a thing is usually 0.
	A thing has a number called the examine-count. The examine-count of a thing is usually 0.
	A thing has a number called the rule-count. The rule-count of a thing is usually 0.
	A thing can be tracked. A thing is usually not tracked.
	A thing can be grammatical or ungrammatical. A thing is usually grammatical. The awful quirkiness is ungrammatical.

	Before printing the name of a grammatical thing (called the target):
		if the print-stage is name-printing:
			say "-->";

	After printing the name of a grammatical  thing (called the target):
		increase rule-count of the target by 1;
		if the print-stage is name-printing:
			say "<--";
			increase times-printed of the target by 1.

	Before printing the name of the awful quirkiness:
		say "(";
	
	After printing the name of the awful quirkiness:
		say ")";
		increase rule-count of the quirkiness by 1;
		increase times-printed of the quirkiness by 1;

	The Chamber of Demonstration is a room. "[chamber-description]".

	To say chamber-description:
		say "Wherein we shall demonstrate [an awful quirkiness] that can happen when Inform runs TWO printing-the-name passes for a single object. Besides causing side effects to happen TWICE each time the object is printed (see the counts below), it can also cause a WRONG ARTICLE to be printed (as is the case here), depending on what we do in our name-printing rules.[paragraph break]";
		say "Whereas, notice that [an articulated thing] prints with the proper article, and also that its times-printed count, below, is correct, because we used print-stage checking for this object."

	The articulated thing is scenery in the chamber. The articulated thing is tracked.
	The awful quirkiness is scenery in the chamber. The quirkiness is tracked.

	To say rule count of (target - a thing):
		say "<[printed name of target]>";
		if the target is not tracked:
			say " is not being tracked";
		otherwise:
			say " has been printed (by looking or examining) a total of [look-examine-count of the target] time[s]. It has triggered the printing the name activity [rule-count of the target] time[s]. Within that activity we've counted the times it has been printed as [times-printed of the target][if times-printed of target > look-examine-count of target] (this last value is INCORRECTLY DOUBLED, demonstrating the side effect problem that can happen without print-stage checking)[end if]."

	After looking:
		repeat with item running through tracked things in the chamber:
			increase look-examine-count of the item by 1;
			say "[rule count of item][line break]".

	After examining a tracked thing (called the item):
		increase the look-examine-count of the item by 1;
		say "[rule count of item][line break]".

	Test me with "x articulated /  x quirkiness / look".
