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

	{*}Include Print Stage Detection by Taryn Michelle.
	Use the American dialect.
	Kitchen is a room.
	An olive oil blend is a thing in the kitchen.
	The olive oil blend can be herb-infused; it is herb-infused.
	Before printing the name of the herb-infused olive oil blend:
		if the print-stage is article-choosing and the American dialect option is active:
			say "erb-infused "; [Americans don't pronounce the 'h', so choose the article accordingly.]
		otherwise:
			say "herb-infused ".

