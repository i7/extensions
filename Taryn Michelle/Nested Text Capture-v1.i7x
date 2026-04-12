Version 1.1.241018 of Nested Text Capture by Taryn Michelle begins here.

"Builds on Eric Eve's text capture extension (with contributions from Dannii Willis) to allow for re-entrance."

[Defer to Text Capture low-level routines for the actual capturing of output text to a string buffer]
Include version 8 of Text Capture by Eric Eve. 

Book 1 - Making Text Capture Re-Entrant

Part 0 - Instrumentation

[Don't force dependency on the entire Text Basics extension]

Section - Text Concatenation (for use without Text Basics by Taryn Michelle)

To decide which text is (T1 - text) & (T2 - text): 
	decide on "[T1][T2]";

[Externally include Trace Output extension to enable debugging messages from Nested Text Capture]
	
Section - Debugging (for use with Trace Output by Taryn Michelle)

nested_text_capture is a trace-token. the trace-tag is "Text Capture". The description is "DBG Messages for Nested Text Capture". 

to trace_immediate (T - text) as (subject - trace-token):
	suspend text capture;
	trace T as subject;
	resume text capture;

Section - No Debugging (for use without Trace Output by Taryn Michelle)

to trace (T - text) as nested_text_capture: do nothing. 
to trace_immediate (T - text) as nested_text_capture: do nothing. 
to decide whether we're tracing nested_text_capture: do nothing. 

Part 1 - Re-Entrant Functionality

[ // TMV 18 Sep 2024 - Inform 10 Compatability ]
[ // TMV 12 Oct 2024 - Change capture phrase names so code written for this extension cannot accidentally be run with only Eric Eve's original Text Capture extension included. Old and new names are as follows:
	Original phrase					New phrase
	start capturing text				begin text capture
	stop capturing text				end text capture
	text capturing is active			we're capturing text
	
We now also have two separate pieces of text of possible interest: captured text (everything captured so far) and captured snippet (everything captured by the current, possibly nested invocation of "begin text capture").

]

Section 1 - Set larger default capture buffer length (for Glulx Only)

[ // TMV 12 Oct 2024 - When using Glulx, we increase the default capture buffer minimum length to a significantly larger size;
  // TODO: See commented out bit below; per documentation syntax is supposed to support redefinition but this seems to fail in Inform 10.x]
Use maximum capture buffer length of at least 2048; [ translates as (- Constant CAPTURE_BUFFER_LEN = {N}; -). ]

Section 2 - Create the capture buffer stack

[Avoid public use of these globals, preferring the phrases in Sections 3 (and only if absolutely necessary, Section 4)]
text_capture_context is a list of texts that varies. text_capture_context is {""}.
text_capture_level is a number that varies. 

Section 3 - Nested Text capture

To decide whether we're capturing text: decide on whether or not text_capture_level > 0;

To begin text capture:
	if text_capture_level < 0:
		trace_immediate "WARNING: text_capture_level < 0 (which should never happen)" as nested_text_capture;
		now text_capture_level is 0; [This SHOULD never happen. If it does, avert disaster.]
	trace_immediate "Starting text capture ([text_capture_level])" as nested_text_capture;
	let N be text_capture_level;
	truncate text_capture_context to N entries; [clear out any more deeply-nested prior buffers]
	extend text_capture_context to N + 1 entries; [add back the next-level buffer, initialized to the empty string ("")]
	if we're capturing text: [will be true iff N > 0]
		end low-level text capture;
		let T be "[captured snippet]";
		now entry N of text_capture_context is entry N of text_capture_context & "[T]";
		trace_immediate "Capture context [text_capture_level] saved as: [entry N of text_capture_context]" as nested_text_capture;
		begin low-level text capture;
	increment text_capture_level;
	begin low-level text capture. 
	
To end text capture:
	if we're capturing text: 
		let N be text_capture_level; 
		end low-level text capture;
		trace_immediate "Stopping text capture ([N - 1]) with captured snippet: [captured snippet]" as nested_text_capture;
		now entry N of text_capture_context is entry N of text_capture_context & "[captured snippet]";
		decrement text_capture_level;
		[trace_immediate "Text Capture ([text_capture_level]) ended with buffer status: [text_capture_context]" as nested_text_capture;]
		if text_capture_level > 0:
			trace_immediate "Resuming text capture ([N]) - with buffer data: [text_capture_context]" as nested_text_capture;
			begin low-level text capture;
	otherwise:
		trace_immediate "WARNING: Mismatched call to end text capture (capture is not active)" as nested_text_capture;
		
[To say the/-- captured text:
	let N be text_capture_level + 1;
	say "[entry N of text_capture_context]";]
	
To decide which text is the/-- captured text:
	let N be text_capture_level + 1;
	decide on entry N of text_capture_context;
	
Section 4 - Phrases to micro-manage capture contexts

[Use with caution. Internally used to close out any capture contexts left open at the end of a turn.]
To decide what number is the/-- current text capture context: decide on the text_capture_level.
To decide whether text capture is active for context (N - a number): 
	decide on whether or not the text_capture_level > N. 
	
To end text capture for (context - a number):
	if context < 1:
		now context is 1;
	while text_capture_level >= context: 
		end text capture;
		end low-level text capture;
		if text_capture_level > context: 
			begin low-level text capture;
			say captured text; [print it to the next lower-level context]

[Low-level check to see if the underlying Text Capture mechanism is active or not. Use with care.]			
To decide whether we're low-level capturing text: (- (capture_active > 0) -).

[For when we want to ensure some text is printed to the screen regardless of the state of text capture (such as debug trace messages). This is NOT re-entrant, i.e., any text output while capture is (potentially) suspended should be self-contained and invoke nothing that might itself trigger calls to the text capture machinery. It exists here primarily to support debugging the nested text capture extension itself. ]

text-capture-suspended is a truth state that varies. 

To suspend text capture: do nothing.
[	if we're capturing text:
		let N be text_capture_level;
		end low-level text capture;
		now text-capture-suspended is true;
		now entry N of text_capture_context is entry N of text_capture_context & "[captured snippet]". ]
		
To resume text capture: do nothing.
[	if text-capture-suspended is true:
		let N be text_capture_level;
		begin low-level text capture;
		now text-capture-suspended is false.]
	
Section 5 - Every turn rule to safely close out any text capturing left active

Every turn (this is the safely close open text capturing contexts rule):
	if we're capturing text or we're low-level capturing text:
		trace_immediate "End of turn reached with text capture still active ( [current text capture context]) - forcing capture closed and flushing buffered text" as nested_text_capture;
		end text capture for 1; [close all capture out]
		if we're tracing nested_text_capture:
			SAY "[bold type]           *** WARNING: Text Capture still active at end of turn ***[line break]      (check for mismatched begin/end capture statements in your code)[line break][roman type]" (A);
		say captured text.

		
Section 6 - Remap original Text Capture calls

[Testing the internal global "capture_active" only detects low-level capturing; we remap the test accordingly]
To decide whether text capturing [of any level] is active: decide on whether or not we're capturing text;

[Originally left these alone, but I habitually found myself writing begin/end rather than start/stop (even before creating this extension) and having to fix it -- so now both versions work]
To start capturing text: begin text capture.
To stop capturing text: end text capture.

Book 2 - Platform-specific Code 

[ //* This section replaces the (top-level) platform-specific code in Eric Eve's (unnested) text capture extension *//]

[Note that the Book/Part/Section heirarchy implemented here might seem like overkill, but was necessary, due to the way the "in place of ..." mechanic for replacing sections of another included extension is currently implemented.
Trying to combine an (in place of ...) directive with a (for use with/without ...) directive failed at compile time (the compiler misinterprets the intended extension in the second such directive); hence the need for nested headings. Because replacement of named sections is also evidently restricted to headings of the same level (logically speaking, an unnecessary restriction, as far as I can tell), Parts had to be used for that purpose, with the platform-specific restrictions placed beneath them at the Section level]

Part 2A (in place of Part 2 - Define Our Four Phrases in Text Capture by Eric Eve) 

Section 2.1 - Low-Level Phrases (for use without FyreVM Support by TextFyre)

To begin low-level text capture:
	(- StartCapture(); -).

To end low-level text capture:
	(- EndCapture(); -);

To say the/-- captured snippet:
	(- PrintCapture(); -).
	
Part 2B (in place of Part 2F - FyreVM phrases in Text Capture by Eric Eve)

Section 2.2 - Low-Level FyreVM phrases  (for Glulx only) (for use with FyreVM Support by TextFyre)

To begin low-level text capture:
	(- FyreVMStartCapture(); -).

To end low-level text capture:
	(- FyreVMEndCapture(); -).

To say the/-- captured snippet:
	(- FyreVMPrintCapture(); -).
	
[[ //* TMV 01 Nov 2024 - None of these options work to remove the "To say captured text:" definition from Eric Eve's extension. Redefining the expression within each of these SHOULD technically work, but something else is obviously not right here]

Section 2.3 - Remove Text Capture's version of the FyreVM calls (replaces Part 2F - FyreVM phrases in Text Capture by Eric Eve)

[No Content, this section just exists to remove phrases we've redefined in section 2.2 above from Eric Even's Text Capture extension.] 
[NOTE: Ideally, this seems like it should have been possible in one go, but tacking on the (replaces ...) clause above to Section 2.2 did not work as expected.]

Section 2.4 - Remove Text Capture's version of the non-FyreVM calls (replaces Part 2 - Define Our Four Phrases in Text Capture by Eric Eve)

[Again, though the above section 2.1 APPEARS to work, it actually doesn't, and the To say captured text phrase from the original extension remains alive without this]

*// ]
  
Nested Text Capture ends here.

---- DOCUMENTATION ----

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
	
	*: Use maximum text capture buffer length of at least 8192 translates as (- Constant TXT_CAPTURE_BUFFER_LEN = {N}; -).  [for example, this sets the buffer maximum length to 8kb]

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

The only paramount rule is that every call to "begin text capture" has a matching "end text capture" call. 

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

There is also a phrase to force a specific nested capture context closed (closing any open nested contexts below it closed as well):
	
	end text capture for (ctx - a number)  [where ctx is the context value as illustrated above]
	
In fact, to avoid any potential confusion, this extension makes use of such a call exactly once, in an Every Turn rule, meant to catch situations in which an author has inadvertantly left one or more calls to "begin text capture" open. If we did not force closed any capture left often at this point, the command prompt -- along with anything the player typed -- would be swallowed up (and thus essentially "invisible"). 

Even at that, results may not be as intended. Such a situation should in fact never occur by design, and the rule that catches this by default reports it as a likely mistake. 

Section - A Use Case for Nested Text Capture


As noted earlier, even if we as author's haven't explicitly made use of text capturing in our own code, a number of extensions make use of Text Capture interally to store and manipulate bits of text before they are printed out. 

If we include such an extension in our project, and subsequently come up with a reason to capture and store, manipulate and/or later print out text of our own, unless we make very sure one capture can never be started while the other is active, or else we write (fairly tricky) code -- much along the lines of this extension, in fact -- to handle such nesting if it ever does occur, one capture is going to step on the other and produce incorrect results.

The following simple example illustrates how two independent reasons for capturing text might occur, and might in fact need to be made safely re-entrant (i.e., nestable)

	
Example: ** Commentary by Gump - Demonstrating Nested Text Capture in Action

	[The ability to place comments inline with text would be a great feature to see added to the Inform language.]
	[The following say statements allow us to accomplish that]
	
	Include Nested Text Capture by Taryn Michelle.
	
	To say /* -- beginning say_slash_slash -- running on: start capturing text.
	To say */ -- ending say_slash_slash -- running on: stop capturing text. 	

	To say series of elaborations:
		say "[one of]Text substitutions in Inform are almost like [xyzzy][/*] (Here we mean to say that they are like magic! ) [*/] But they can sometimes be inscrutable. To begin with, the ability to place comments directly inline with our text allows us to document otherwise obscure substitutions right where they are written.[or][/*]

		[*/]When each alternative text of a series is short, of course, this is accomplished easily enough with regular comments. But if many of the texts span multiple lines, especially if there are many such choices, the large [alakazam] [/*] (prints up as 'blob') [*/] of sentences and paragraphs all mashed together can make it very difficult to see what's going on at a glance.[or][/*]

		[*/]That's at least in part because each alternative can normally be separated from the next only by a substitution such as '[bracket]or[close bracket]', with no extraneous whitespace such as tabs or newlines permitted.[or][/*]

		[*/]Technically speaking, in alternative text substitutions like this one, extra whitespace CAN be included in the text, but of course, that means it will also get printed out - a result we probably aren't going to like.[or][/*]

		[*/]And when texts are stored in Tables, the limitations are even more pronounced. Tables are frequently useful for holding things like speaker dialogue, responses to 'consulting' a reference source about various topics, and the like. But as anyone who has ever constructed such an Inform table of any size well knows, they quickly become difficult to read. With the ability to introduce blocking, and even explanatory comments as necessary, directly into any table text column, tables can be made substantially more readable, and therefore more easily maintainable.[or][/*]

		[*/]In a nutshell, those are the arguments for inline text comments, implented here by way of the pair of segmented substitutions '[bracket]/*[close bracket]' and '[bracket]*/[close bracket]'.[or][/*]

		[*/]Now, it would be even nicer if Inform implented such a feature directly, and the IDE supported syntax coloring of inline text comments to make them stand out even more clearly. And with the present implementation, even though none of the text between the comment braces will get printed up at runtime, it still occupies space in the code and takes up processing cycles at runtime to deal with. The memory space factor is more likely to be an issue for Z-machine builds than for Glulx, and the processing cycles to essentially skip over an inline comments at runtime are minimal, but still, native support would be all the better. For now, though, this approach is workable, and results in immediately more readable code.[or][/*]

		[*/]Of course, since these comments can appear anywhere, in any text, then other code that relies on capturing text output has no way of knowing if or when the output it's capturing might include text with such comments in it, and therefore text that itself relies on the ability to capture text to print up properly. In short, in order for these in-line text comments to be safe to use anywhere, Text Capture needed to be made safely re-entrant.[or][/*]

		[*/]Our very last paragraph (the following one) illustrates an admittedly contrived case of this. We quote Forrest Gump in perhaps the most obtuse way possible, using a segmented substitution that itself makes use of text capture to do so.[or][*/]

		[*/][gump] [/*] (Finally, quoting Forrest Gump here.) [*/][stopping]";
		
	To say xyzzy: say "magic".
	To say alakazam: say "blob". 
	To say gump:
		say "[begin forrest]That's all I've got to say about that.[end forrest]".
	
	[And now, a ridiculously obtuse way to accomplish something via replacing bits of captured text. The example here is admittedly contrived, but more realistic situations can easily arise.]
	number of times gump quoted is a number that varies. 

	To say begin forrest -- beginning say_forrest_gump_quote -- running on: 
		begin text capture;
		
	To say end forrest -- ending say_forrest_gump_quote -- running on:
		end text capture;
		let T be "[the captured text]";
		increment the number of times gump quoted;
		if number of times gump quoted < 2:
			if character number 1 in T is "T":
				replace character number 1 in T with "t";
			say "And ";
		say T. 


The above example is intentionally written such that it will compile with or without inclusion of the Nested Text Capture extension. To see why this is potentially problematic, try running it without Nested Text Capture included and see the havoc that results. Thus in code written with the use of this extension in mind, it's suggested to exclusively use the newly-introduced phrases for starting and ending text capture, namely "begin text capture" and "end text capture".  In that way, accidentally omitting inclusion of the Nested Text Capture extension will produce immediate compiler errors, rather than potentially mysterious misbehavior down the road at runtime. 
	
		
		
		
		
	








