All credit goes to Text Capture by Eric Eve (with contributions from Dannii Willis)  for the low-level platform-specific Inform 6 code underpinning this extension.

Section 1 - About Text Capture by Eric Eve

Many Inform authors have made use of Eric Eve's extension, either directly or indirectly (by including other extensions that rely on it).

See that extension's documentation -- which we avoid repeating here -- for some typical use cases for capturing and (potentially) manipulating output text.

If you have written code for that extension, provided your code uses only the main four phrases:
	
	start capturing text
	stop capturing text
	print captured text
	if text capturing is active
	
and does not rely on any other internals of that extension, no changes are necessary to begin using Nested Text Capture instead. Simply add the following line to your project:
	
	Include Nested Text Capture by Taryn Michelle.
	
Nested Text Capture calls the low-level routines defined in Text Capture to do the actual work of capturing text output, replacing only those sections that define the above four main phrases (for each supported target platform) so that the necessary bookkeeping to handle re-entrance can occur in-between the call to the top-level phrase and invocation of the low-level capture machinery itself.

There are a couple of caveats:
	
(1) This extension was originally written for personal use in some Glulx-only projects. Because this extension changes nothing about the platform-specific code in the original Text Capture extension, no problems are expected on other supported platforms, however as of this release, it has not been extensively tested on the Z-machine and has not been tested at all with FyreVM.

(2) This extension assumes most use cases involving (potentially) nested capture of text output are likely to require more than Text Capture's default maximum buffer size of 256. For glulx projects (where memory space is generally not an issue) we redefine the default minimum buffer size to be a moderately generous 2kb. Regardless of platform, it's advisable to consider setting this value explicitly in your own code:
	
	{*}Use maximum text capture buffer length of at least 8192 translates as (- Constant TXT_CAPTURE_BUFFER_LEN = {N}; -).  [for example, this sets the buffer maximum length to 8kb]

Section 2 - Using Nested Text Capture

Basic usage is fundamentally the same as for Eric Eve's extension.  To start and end text capturing, Nested Text Capture implements the phrases shown below:

	Begin text capture 	--	Starts capturing printed text (supresses the output and places the text in a buffer instead)
	End text capture 	-- 	Closes the current capture context (and makes the buffer accessible for examination, manipulation, and optionally printing back out)

(Of course, as noted earlier, the original phrases from Eric Eve's extension can also be used, and will work identically. The primary motivation for implementing new phrases was so that a work that relies on Nested Text Capture but accidentally forgets to include the extension will fail to compile. Otherwise, if only the original phrases are used, and Eric Eve's extension is included -- either directly or by way of another extension that uses it -- then the code will compile fine and may even appear to work, right up until some part of the code introduces a reentrant call to the text capture routines.)
	
To access the captured text after an "end text capture" call:
	
	say the/-- captured text		- 	prints out captured text
	let T = "[captured text]"	-	assigns the captured text to a variable, where it can be examined, manipulated, or otherwise used, and (if desired) printed out.

Note that captured text (for any given context) can only be reliably accessed once text capture for that context has been ended (this is also true of the original extension). The phrase "say captured text" prints (or saves to a variable) all the text (and only the text) that was captured between the most recently closed "begin/end text capture" block. If other (outer) text capture contexts remain active, any text that was captured outside of the nested block is not seen or touched. And just as in the case of the original non-reentrant text capture, the captured text (or if desired, a manipulated version of it) can only be seen (either by the next outermost capture context or else on the player's screen, if we are at the top-level capture context) if it is explicitly printed out. Otherwise, it will be ignored (which is sometimes precisely the point).

All of the above may take a moment or two to think through, but in fact THIS IS ALWAYS GOING TO BE THE BEHAVIOR WE WANT. Nested calls to begin/end text capture should never require awareness of whether or not text capturing was already active when they were invoked, nor should they ever need to be concerned with whether another call to begin/end text capture might happen while they are busy capturing text.

The paramount rule is that every call to "begin text capture" has a matching "end text capture" call.

Section 3 - Testing and Manipulating a specific nested context

These phrases should be used with significant caution, if at all.

To begin with, you can test whether text is being captured at any given time with the phrase:
	
	if we're capturing text
	
For compatibility, this may also be phrased: if text capturing is active.

While at first glance this appears to be the same as in the original extension, the above condition will be true as long as ANY open capture contexts exist, not simply in regard to the capture context initated by a specific "begin text capture" call.  In particular then, it can't be used within a begin/end text capture block to tell whether any other nested invocations of text capture have started up.

As already noted in section 2, our code should be written to be largely, if not entirely, blissfully unaware of such details. But if it is ever important to check whether or not a specific capture context initiated by a particular "begin text capture" call has been closed by a matching "end text capture" call, that can be achieved by the following:
	
	begin text capture;
	let ctx be the current text capture context; [When examined immediately after a begin text capture call, this will return the specific context of the current capture]
	...
	if text capture is active for ctx:
		...

There is also a phrase to force a specific nested capture context closed (forcing any open nested contexts below it closed as well):
	
	end text capture for (ctx - a number)  [where ctx is the context value as illustrated above]
	
This extension makes use of such a call exactly once, in a "last every Turn rule", meant solely to catch situations in which an author has inadvertantly left one or more calls to "begin text capture" open. If we did not force closed any capture left often at this point, the next command prompt -- along with anything the player tryed to type -- would be swallowed up (and thus essentially "invisible").

Even at that, results may not be as intended. Such a situation should in fact never occur by design, and the rule that catches this by default reports it as a likely coding error.

Section - A Use Case for Nested Text Capture

As noted earlier, even if we as author's haven't explicitly made use of text capturing in our own code, a number of extensions may already use Text Capture interally to store and manipulate bits of text before they are printed out.

If we include such an extension in our project, and subsequently come up with a reason to capture and store, manipulate and/or later print out text of our own, unless we make very sure one capture can never be started while the other is active, or else we write (fairly tricky) code -- much along the lines of this extension, in fact -- to handle such nesting if it ever does occur, one capture is going to step on the other and produce incorrect results.

The example, "Comments by Gump, illustrates how two independent, if somewhat contrived, reasons for capturing text might occur, and need to be made safely re-entrant (i.e., nestable). 

	
