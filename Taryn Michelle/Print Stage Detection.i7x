Version 1 of Print Stage Detection by Taryn Michelle begins here.

"'Printing the name' rules make TWO passes over the same object when Inform needs to determine the appropriate article to print. This is a non-issue for many rules, but 'printing the name' rules with side effects may need to know which stage is currently being processed (article-choosing or name-printing), so that they can avoid double-execution of any side effects."

Section - I6 Code

[The PrefaceByArticle routine is copied from Printing.i6t and modified to set a global flag which will tell us when PSN__ (the routine that ends up invoking the 'printing the name' activity) is printing to a buffer (to determine what article to choose) or displaying output.]

Include (- 

[ PrefaceByArticle obj acode pluralise capitalise  i artform findout artval;
	if ( article_choosing ) { ! prevent reentrant calls from also attempting to choose an article, thereby disrupting article-choosing for the original object. (This is okay -- they will get their turn to print as requested later on, during the name-printing stage for the original object.)
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
		article_choosing = true;
		if (pluralise)
			Glulx_PrintAnyToArray(StorageForShortName, 160, EnglishNumber, pluralise);
		else
			Glulx_PrintAnyToArray(StorageForShortName, 160, PSN__, obj);
		article_choosing = false;
		acode = acode + 3*LanguageContraction(StorageForShortName);
	}
	#Endif; ! TARGET_

	Cap (artform-->acode, ~~capitalise); ! print article
	if (pluralise) return;
	! Shouldn't there be some way to just output the buffered result we obtained above? One would think, but I have yet to find it...thus the article_choosing flag approach implemented above.
	print (PSN__) obj;
]; -) instead of "Object Names II" in "Printing.i6t";

Include (- Global short_name_case; -) before "Object Names II" in "Printing.i6t";
Include (- Global article_choosing; ! flag to signal printing the name activity when printing to array for article determination -) after "Definitions.i6t";

Section - Adding pass-detection to the printing the name activity

To decide whether name-printing is choosing articles:  (- ( article_choosing ) -).

printing-the-name-stage is a kind of value. the printing-the-name-stages are article-choosing and name-printing.
The printing the name activity has a printing-the-name-stage called the print-stage.

First before printing the name (this is the detect name-printing stage rule):
	if name-printing is choosing articles:
		now the print-stage is article-choosing;
	otherwise:
		now the print-stage is name-printing;

Print Stage Detection ends here.

---- Documentation ----

'Printing the name' rules make TWO passes over the same object when Inform needs to determine the appropriate article to print. This is a non-issue for many rules, but 'printing the name' rules with side effects may need to know which stage is currently being processed (article-choosing or name-printing), so that they can avoid double-execution of any side effects.

This extension also addresses a potential issue with reentrance, whereby printing the name of a second object from within a 'printing the name' rule could end up causing an incorrect indefinite article to be chosen for the first object. (Thanks to Brady Garvin for pointing this issue out!)

The two 'printing the name' passes are non-obvious, since the first pass quietly redirects all printing to an internal buffer, where it examines the result to decide what article should be selected.  If you're surprised by this (I certainly was when I first encountered it), run the example code to see that printing the name rules do indeed get fired off TWICE each time an object is printed up with an article. 

Section: New printing the name activity variable: print-stage

This extension adds an activity variable called "print-stage" to the printing the name activity. Print-stage will be either "article-choosing" (nothing is printed up during article choosing, all print output goes to an internal array buffer) or "name-printing" which is when the results get printed out.

When writing any 'printing the name' rules with side effects, it's usually important to make sure those side effects happen only once, most likely during the name-printing stage. That can be accomplished as follows:

	every thing has a number called times-printed.
	for printing the name of something (called the target):
	if print-stage is name-printing:
		increase times-printed of the target by 1.
			
In this simple example, we count the number of times an object is printed. Without the check for which stage the rules are in, the times-printed would end up being incorrectly doubled.

If a rule is going to print up a name, then it must do so in both stages, and obviously it should print up the same name in both stages. The good news is, for the vast majority of cases, this just means writing 'printing the name' rules the way we always have -- without concern for what print stage is happening under the covers:

	for printing the name of the gorgeous flower during allergy attack: [assume the flower are an object and allergy attack is a scene]
		say "awful, allergen-spewing flower";
		
As expected an ordinary 'printing the name' rule like this one this will correctly produce output such as "You can see an awful, allergen-spewing flower here." as opposed to "a gorgeous flower" elsewhere.

In actuality, a rule only needs to print the same *beginning* of the name in both stages for article-chosing to work properly. It's a fine point of detail, but the following would also work just fine:
	
	for printing the name of the gorgeous flower during allergy attack:
		say "awful, ";
		if print-stage is name-printing:
			say "allergen-spewing flower";
			
Obviously there's no reason to do this -- for this trivial example, the original straightforward rule will do. However, if we had instead written a rule to follow up the name of a container, say, with its contents, then it could be reasonable to defer doing anything with the contents until the name-printing stage. While not strictly necessary (the included fix for reentrance is included largely to address this sort of situation) it is arguably cleaner to print only what needs to be printed during article-choosing, and defer any 'extras' to the name-printing stage.

If a rule is going to print anything in front of the object name that we do not want to be considered by the article-choosing rules, then such output should be omitted from the article-choosing pass. For example:

	before printing the name of something (called the target) (this is the begin markup around printed objects rule):
		if print-stage is name-printing:
			begin markup;
	
	after printing the name of something (called the target) (this is the end markup around printed objects rule):
		if print-stage is name-printing:
			end markup;

where it's assumed "begin markup" and "end markup" are defined elsewhere. The example below does this by placing "-->" and "<--" around printed object names for illustrative purposes, but the markup could in fact be anything, such as HTML, for example. The point is, allowing anything else to be printed in front of the object name during the article-choosing stage can cause an incorrect article to be chosen.  Deferring such markup to the name-printing stage prevents the problem.

Finally, note that only the name-printing stage is always guaranteed to occur. The article-choosing stage occurs only for improper-named objects which do not already explicitly specify the article property, and then only if we asked for an article to be printed (i.e., a phrase such as say "[an item]" or "[the item]" was used, as opposed to say "[item]" without any article). 

Section: On placement of before printing the name rules

Internally, this extension creates the following rule and places it first in the list of before printing the name rules:

	First before printing the name (this is the detect name-printing stage rule):
		if name-printing is choosing articles:
			now the print-stage is article-choosing;
		otherwise:
			now the print-stage is name-printing;

Be careful of accidentally placing other 'printing the name' rules ahead of this one, as the print-stage variable will not be properly initialized. If writing a before printing the name rule that relies on this extension, either place it after the detect name-printing stage rule, or else include the initialization of the print-stage variable (as above) in that rule.
		
Example: ** Print Stage Demo - A simple demonstration of the two passes the printing the name activity makes when printing an object with an article, and the use of Print Stage Detection to deal with some issues that arise.

	*: "Print Stage Demo" 

	Include Print Stage Detection by Taryn Michelle.

	[First, a place to track the times we hit a rule for an object]
	A rule-counter is a kind of object.
	A rule-counter has a number called before-count. before-count of a rule-counter is usually 0.
	A rule-counter has a number called for-count. for-count of a rule-counter is usually 0.
	A rule-counter has a number called after-count. after-count of a rule-counter is usually 0.

	null-counter is a rule-counter.

	A thing has a number called the look-examine-count. The look-examine-count of a thing is usually 0.
	A thing has a number called the times-printed. The times-printed of a thing is usually 0.
	A thing has a number called the examine-count. The examine-count of a thing is usually 0.
	A thing has a number called the rule-count. The rule-count of a thing is usually 0.
	A thing can be tracked. A thing is usually not tracked.

	[Simple before-after printing rules with stage-checking]
	before printing the name of something (called the target):
		if the print-stage is name-printing:
			say "-->";
		
	after printing the name of something (called the target):
		increase rule-count of the target by 1;
		if the print-stage is name-printing:
			say "<--";
			increase times-printed of the target by 1.

	[Don't apply stage-checking to one of our objects, to illustrate the difference]
	before printing the name of the awful quirkiness:
		say "-->";
		rule succeeds;

	after printing the name of the awful quirkiness:
		say "<--";
		increase rule-count of the quirkiness by 1;
		increase times-printed of the quirkiness by 1;
		rule succeeds.

	the Chamber of Demonstration is a room. "[chamber-description]";

	To say chamber-description:
		say "Wherein we shall demonstrate [an awful quirkiness] that can happen when Inform runs TWO printing-the-name passes for a single object. Besides causing side effects to happen TWICE each time the object is printed (see the counts below), it can also cause a WRONG ARTICLE to be printed (as is the case here), depending on what we do in our name-printing rules.[paragraph break]";
		say "Whereas, notice that [an articulated thing] prints with the proper article, and also that it's times-printed count, below, is correct, because we used print-stage checking for this object."; 

	The articulated thing is scenery in the chamber. The articulated thing is tracked.
	The awful quirkiness is scenery in the chamber. The quirkiness is tracked.

	To say rule count of (target - a thing):
		say "<[printed name of target]>"; [use printed name so as not to invoke 'printing the name' rules here and throw off our tracking counts]
		if the target is not tracked:
			say " is not being tracked";
		otherwise:
			say "has been printed (by looking or examining) a total of [look-examine-count of the target] time(s). It has triggered the printing the name activity [rule-count of the target] times. Within that activity we've counted the times it has been printed as [times-printed of the target][if times-printed of target > look-examine-count of target] (this last value is INCORRECTLY DOUBLED, demonstrating the side effect problem that can happen without print-stage checking)[end if].";

	after looking:
		repeat with item running through tracked things in the chamber:
			increase look-examine-count of the item by 1;
			say "[rule count of item][line break]";

	after examining a tracked thing (called the item):
		increase the look-examine-count of the item by 1;
		say "[rule count of item][line break]";
		
	test me with "x articulated /  x quirkiness / look".