Chapter: Basic cloning

This extension allows new objects to be created by cloning existing objects. Once we've defined a suitable prototype object, we can refer to "a new object cloned from" it, like so:

	let the copy be a new object cloned from the prototype;

That line will create the new object and assign it to the variable called "copy". The copy will be the same kind as the prototype, and have all the same property values.

By default, the new object will not be participating in any of the relationships of the prototype object. To clone the relationships as well, use the "preserving relations" option:

	let the copy be a new object cloned from the prototype, preserving relations;

Note that even with this option, one-to-various (or various-to-one) relationships are only preserved when the cloned object is on the "various" side, and one-to-one relationships are never preserved.

If memory runs out and the new object cannot be created, the phrase will return "nothing".

Chapter: The "cloning a new object from" activity

The cloning process is implemented as an activity called "cloning a new object from". We can write "before cloning a new object from" rules to intervene before the object is cloned, and in those rules we can refer to "preserving relations" as a truth state which is true if the process is going to preserve object relationships.

We can also write "after cloning a new object from" rules to intervene after the object is cloned, and in those we can also refer to the clone as "the new object":

	A thing has a number called the clone generation.
	
	After cloning a new object from something:
		increase the clone generation of the new object by 1.

In this example, we change the behavior of "preserving relations" so that when the original object relates to itself, the clone also relates to itself (and not to the original object):

	Love relates various people to various people. The verb to love (he loves, they love, he is loving, he is loved) implies the love relation.
	
	After cloning a new object from a person (called the original):
		if preserving relations is true and the original loves the original:
			now the new object does not love the original;
			now the original does not love the new object;
			now the new object loves the new object.

Section: Handling block value properties

When cloning objects that have properties containing block values (text*, stored actions, lists, or dynamic relations), we must indicate which properties those are so the extension can copy their values correctly; otherwise we may encounter unexpected behavior or runtime problem messages if the property values are changed. Use the "fix the cloned _ property" phrase in an "after cloning a new object from" rule:

	A person has a list of numbers called the favorite numbers.
	
	After cloning a new object from a person:
		fix the cloned favorite numbers property.

Chapter: Caveats

If we plan to clone any rooms or doors, we must disable fast route-finding (which is enabled by default on Glulx):

	Use slow route-finding.

Chapter: Known Issues

*Fixing the cloned ... property, for "block" value properties, which now includes ALL text properties:

Those familiar with older versions of Inform (prior to the Inform 7 6L02 release) likely recall the need to differentiate between dynamic "indexed text" and static "text" types. That distinction no longer exists (a good thing), but that means ALL text is now (potentially) dynamic. Therefore, it's necessary to "fix the cloned ... property" for EVERY TEXT property of any object we clone. Failure to do so will results in cloned objects pointing to the same exact property value as the original object, so that changing that value in any one of the objects in question changes it FOR ALL of the objects.  

This means that, while previously, having to write "after cloning a new object" rules to fix block properties was likely to be rare, it's an absolute necessity now. 

For example, the default "thing" kind alone features the following text properties: description, initial appearance, printed name, printed plural name, indefinite article, list grouping key.

At the moment, this extension does nothing to address this. Rather, at a minimum, if you intend to clone any "things" (or object kinds derived from the "thing" kind) you MUST write an "After cloning a new object from a thing" rule, as well as a similar rule for each derived kind that adds one or more text or other "block" type  properties of its own. 

If there were a straightforward way in either Inform 7 or Inform 6 to iterate over all the properties of an object (or kind) at runtime, this extension could attempt to automatically "fix" any cloned "block"  properties automatically. Unfortunately, there seems to be no straightforward way to accomplish that, and it's beyond the scope of this extension to attempt to resolve that particular problem. 

**Counting objects of a kind 

The standard way to determine how many objects match any sort of description in Inform is just to use

	the number of <description of objects>

This currently works fine with Dynamic Objects *unless the description of objects is just the name of a kind*. Where "widget" is a kind, the expression ...

	the number of widgets

returns ONLY the number of statically defined widgets. If any dynamic objects of the widget kind are created, they are not inlcuded in the count. 

As time permits, I may try to track down a resolution for this. In the meantime, the following "hack" works:

	Definition: A thing is total if: decide yes. 

	let N be the number of total widgets; [Returns a count of ALL widgets, including any that were dynamically created]

I expect this forces Inform to walk through the list of widgets, as will be the case with most descriptions of objects, testing the (in this case always trivially true) condition for each one. Whereas the former almost certain relies either on querying an I6 variable (in which case a simple enough fix should be possible) or else a compile-time constant (in which case any resolution is probably beyond the scope of this extension). 

Chapter: Change log

Version 2 uses Dynamic Tables (by the same author) to avoid replacing the standard locale description rules, and allows cloned objects to participate in all relations.

Version 3 works with Inform 7 version 5U92.

Version 4 fixes a bug with relations.

Version 5 works with Inform 7 version 6E59. It also adds the "cloning a new object from" activity and the "fix the cloned _ property" phrase to allow block-type properties to be cloned correctly. It also changes the behavior (and specification) of "preserving relations" with regard to one-to-one relations: now they are never preserved, since that would result in removing the original object from the relation.

Version 6 works with Inform 7 version 6G60.

Version 7 fixes another bug with relations and a bug that prevented the "new object cloned from" phrase from being used in certain contexts.

Version 8 works with (and requires) Inform 7 version 6L02.

Version 8/220204 patch to DO_UnlinkProp in a stab toward 6M62 compatibility

Version 9 works with Inform 7 version 10.1.2.

Version 10 works with Inform 7 version 10.2 (though note, with version 10.2 being in active development, this may change - the extension was successfully tested with a build of the current master branch as of March 24, 2026 at 22:24 GMT) Note that version 10 is NOT backward compatible with Inform 10.1.x when compiled for Glulx.

