Chapter: A quirk of how "printing the name" rules work

While not usually noticeable to either the author or player, 'Printing the name' rules can potentially be invoked TWICE while printing up the name of any given object. The reason for this is that when Inform has to try to deduce the appropriate indefinite article to print, it does so by doing an initial throwaway (as in never output to the console) "test" write into a buffer. 

Since "printing the name" rules can and often do alter the way an object name is printed up, they obviously need to be consulted on this "article-choosing" pass. Now, why Inform doesn't just then print out what it wrote to that buffer isn't clear, but it doesn't. Instead, it runs the rules a second time, "for real", once it's settled on what it thinks is the appropriate article. 

This is a non-issue for many rules, but 'printing the name' rules with side effects that are not idempotent (i.e., side effects that will yield a different result if performed twice in a row) will cause unexpected results. 

For example, here's a simple rule that tries to count how many times the player has "seen" any given object by counting each time the name of the object has been printed up:

	A thing has a number called the times-printed. 
	After printing the name of something (called the item):
		increment the times-printed of the item.

If you try this, for most objects (proper-named and plural-named objects will be exceptions here), you'll find that the reported number of times printed will start to far exceed the number of times we've actually printed out the names of those objects. (The results will be roughly double the correct value. I say roughly, because sometimes, such as when use of the definite article is specified or implied, the extra "test" pass won't happen.)

There are other nuanced issues that can arise as well.  

Let's say, for example. that we want to put some rudimentary html-style markup around object names, like so:

	Before printing the name of something: say "<b>".
	After printing the name of something: say "</b>".

And now let's say there is an animal called an "angry aardvark" in the current location. 

In this case, the default room description will unfortunately  print up, "You see a <b>angry aardvark</b> here."

Section: How the extension works

This extension adds a kind of value called printing-stage. The values are either "article-choosing" (nothing is printed up during the article-choosing stage; all print output goes to an internal array buffer) or "name-printing", which is when the results get printed out.

When writing any 'printing the name' rules with side effects, it's now trivially easy to make sure those side effects happen only once, regardless of whether Inform decides it needs to do a "test" pass through the printing the name rules to decide on an indefinite article. 

	Every thing has a number called times-printed.
	Before printing the name of something (called the target):
		if print-stage is name-printing:
			increase times-printed of the target by 1.
		
As before, we keep count of the number of times an object is printed, but now that count will always be accurate. 

If a rule is going to print up a name, then it must do so in both stages, and obviously, most of the time, it should print up the same name in both stages. There are exceptions, as several examples here illustrate. The good news is, for the vast majority of cases, this just means writing 'printing the name' rules the way we always have, without concern for what print stage is happening under the covers:

	For printing the name of the gorgeous flower during allergy attack: [assume the gorgeous flower is something defined and allergy attack is a scene]
		say "awful, allergen-spewing flower".
		
An ordinary 'printing the name' rule like this one this will correctly produce output such as "You can see an awful, allergen-spewing flower here." during the allergy attack scene, as opposed to "a gorgeous flower" elsewhere.

In actuality, a rule only needs to print the same *beginning* of the name in both stages for article-chosing to work properly. It's a fine point of detail, but the following would also work just fine:
	
	For printing the name of the gorgeous flower during allergy attack:
		say "awful, ";
		if print-stage is name-printing:
			say "allergen-spewing flower".
			
Obviously for this trivial example, the original straightforward rule will do. However, if we had instead written a rule to follow up the name of a container, say, with its contents, then it could be reasonable to defer doing anything at all with the contents until the name-printing stage. While not strictly necessary (the included fix for reentrance is included precisely to address this sort of situation) it is arguably cleaner to print only what needs to be printed during article-choosing, and defer any significant extra work to the name-printing stage.

Section: Placing non-alphabetic markup around object names

If a rule is going to print anything IN FRONT of the object name that SHOULD NOT be considered by the article-choosing rules, then such output needs to be omitted from the article-choosing pass. For example:

	Before printing the name of something (called the target) (this is the begin markup around printed objects rule):
		if print-stage is name-printing:
			begin markup.
	
	After printing the name of something (called the target) (this is the end markup around printed objects rule):
		if print-stage is name-printing: [Version 2.1 does away with the need for this check in "after printing the name ..." rules, but there is no harm done keeping it in]
			end markup.

where it's assumed "begin markup" and "end markup" are defined elsewhere, and result in output that SHOULD NOT change the indefinite article. The example project (relocated as of version 2.1 to the documentation/examples directory) places "-->" and "<--" around printed object names for illustrative purposes, but the markup could in fact be anything, such as HTML, for example. The point is, allowing anything else to be printed in front of the object name during the article-choosing stage can cause an incorrect article to be chosen ("a -->apple<--", instead of "an -->apple<--").  Deferring any such markup to the name-printing stage prevents the problem.

Section: Special consideration for "After printing the name ..." rules

Starting with version 2.1 of this extension, "Ater printing the name ..." rules will ONLY RUN during the name-printing stage. It accomplishes this by taking over "manual" control of the "printing the name" activity, and when the activity is running during the "article-choosing", employs the rarely used technique of ABANDONING THE ACTIVITY once the before rules and the for rules have finished, thereby completely circumventing the after rules. 

Nothing we could reasonably be doing in an "after" rule during the article-choosing stage (the output of which, remember, is going to simply be thrown away once an article is selected) should have any effect on Inform's choice of indefinite article. If someone comes up with a valid use case that contradicts this assumption, the change is easily enough undone, but my suspicion is that for any scheme sufficiently complex that some "after printing the name" rules actually COULD have such an effect is likely to have a better way of going about it. 

The upside of this change is that "after printing the name ..." rules tend to be where the bulk of activity with possible problematic side effects can be expected to occur, in both our own rules and those of extension-writers. This change neatly eliminates the concern of having to manually check, and potentially modify every such "after printing the name" rule to be print-stage conscious just to avoid the potential for quirky problems cropping up down the road. 

Another observation is that "after printing the name" rules are sometimes written to kick off a good bit of additional output. (Think, for example, of a rule that automatically prints up a list of the contents of something, or perhaps runs through a number of relations to see what helpful clarifying details it may want to print up.) All of that work is unnecessary, wasted overhead during the "throwaway" article-choosing pass. We could control this in our own rules by way of testing the print-stage, but in other extensions, not so easily.

Section: Rules cannot depend on the "article-choosing" stage running

Finally, while this is not a change, it's still important to note that for all rules (before, for, and after) ONLY the name-printing stage is guaranteed to occur. The article-choosing stage occurs only for improper-named objects which do not already explicitly specify an indefinite article, and only if we haven't explicitly called for either the definite article or no article be printed.

Section: Tweaking article determination in other situations

The previous sections mainly discussed various pitfalls to avoid in the article-choosing stage, but we can also take advantage of knowing when article-choosing is happening to deal with some special cases. Here is an example (again, courtesy of Brady Garvin) that Inform, by default, doesn't get quite right:

	{*}Include Print Stage Detection by Taryn Michelle.
	Use the American dialect.
	Kitchen is a room.
	An olive oil blend is a thing in the kitchen.
	The olive oil blend can be herb-infused; it is herb-infused.
	Before printing the name of the herb-infused olive oil blend:
		if the print-stage is article-choosing and the American dialect option is active:
			say "erb-infused "; [Americans don't pronounce the 'h', so we help Inform to choose the article "an" accordingly.]
		otherwise:
			say "herb-infused ". [Whereas this will result in the article "a" being selected]

Section - Version History

Version 1 - developed for version 9.3 of Inform, with credit to Daniel Stelzer and Brady Garvin for their helpful input.

Thanks to Daniel Stelzer, This version also addresses another issue with reentrance, whereby printing the name of a second object from within a 'printing the name' rule could end up causing an incorrect indefinite article to be chosen for the first object. (Thanks to Brady Garvin for pointing this out! The modified I6 PrefaceByArticle routine included here incorporates the same fix as that previously packaged up by Daniel Steltzer at https://dl.dropboxusercontent.com/u/20455422/Article%20Bug%20Fix.i7x.)

Version 2.0 - for compatibility with version 10.1 of Inform (not released)

After creating the 2.1 update, I tried to retrofit the solution to 10.1, but as yet, have not worked out how to get the Inform 6 Include and/or kit mechanics to work properly there. 

Version 2.1 - 10.2 / 11.0 compatible 

Files are separated out into the new "directory format" for extensions. The more significant change it completely unnecessary to check the printing-stage in "after printing the name of ..." rules, as such rules will now ONLY be invoked when actually printing the name up, and not during the process of choosing articles. Before rules still can, and may occasionally need to, test the print-stage and alter their behavior accordingly. 

The most recent Inform7 development version I have compiled and tested with (so far) was built from a clone of the 10.2 development repository as of 23 Mar 2026 as 22:23 GMT.