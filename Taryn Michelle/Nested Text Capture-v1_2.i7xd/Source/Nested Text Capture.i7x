Version 1.2 of Nested Text Capture by Taryn Michelle begins here.

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
	------------------------		-----------------------------------
	start capturing text			begin text capture
	stop capturing text				end text capture
	text capturing is active		we're capturing text
	
We now also have two separate pieces of text of possible interest: captured text (everything captured so far) and captured snippet (everything captured by the current, possibly nested invocation of "begin text capture").]
[ // TMV 11 Apr 2025 - Inform 10.2/11.0 Compatabililty. 
	 Also Converted to new "directory" format for extensions. 
	 Resolved non-working suspend/resume text capture (required for trace_immedate calls to bypass text capture)
	 Commented out most trace messages, as they are no longer needed, and incur a (small) cost for passing the text around, whether printed out or not ]

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
	[trace_immediate "Starting text capture ([text_capture_level])" as nested_text_capture;]
	let N be text_capture_level;
	truncate text_capture_context to N entries; [clear out any more deeply-nested prior buffers]
	extend text_capture_context to N + 1 entries; [add back the next-level buffer, initialized to the empty string ("")]
	if we're capturing text: [will be true iff N > 0]
		end low-level text capture;
		let T be "[captured snippet]";
		now entry N of text_capture_context is entry N of text_capture_context & "[T]";
		[trace_immediate "Capture context [text_capture_level] saved as: [entry N of text_capture_context]" as nested_text_capture;]
		begin low-level text capture;
	increment text_capture_level;
	begin low-level text capture. 
	
To end text capture:
	if we're capturing text: 
		let N be text_capture_level; 
		end low-level text capture;
		[trace_immediate "Stopping text capture ([N - 1]) with captured snippet: [captured snippet]" as nested_text_capture;]
		now entry N of text_capture_context is entry N of text_capture_context & "[captured snippet]";
		decrement text_capture_level;
		[trace_immediate "Text Capture ([text_capture_level]) ended with buffer status: [text_capture_context]" as nested_text_capture;]
		if text_capture_level > 0:
			[trace_immediate "Resuming text capture ([N]) - with buffer data: [text_capture_context]" as nested_text_capture;]
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

Last Every turn (this is the safely close open text capturing contexts rule):
	if we're capturing text or we're low-level capturing text:
		[trace_immediate "End of turn reached with text capture still active ( [current text capture context]) - forcing capture closed and flushing buffered text" as nested_text_capture;]
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
	
[Part 2B (in place of Part 2F - FyreVM phrases in Text Capture by Eric Eve) [ // TMV - FyreVM support removed from 11.0 version of Text Capture by Eric Eve ]

Section 2.2 - Low-Level FyreVM phrases  (for Glulx only) (for use with FyreVM Support by TextFyre)

To begin low-level text capture:
	(- FyreVMStartCapture(); -).

To end low-level text capture:
	(- FyreVMEndCapture(); -).

To say the/-- captured snippet:
	(- FyreVMPrintCapture(); -).]
	
[[ //* TMV 01 Nov 2024 - None of these options work to remove the "To say captured text:" definition from Eric Eve's extension. Redefining the expression within each of these SHOULD technically work, but something else is obviously not right here]

Section 2.3 - Remove Text Capture's version of the FyreVM calls (replaces Part 2F - FyreVM phrases in Text Capture by Eric Eve)

[No Content, this section just exists to remove phrases we've redefined in section 2.2 above from Eric Even's Text Capture extension.] 
[NOTE: Ideally, this seems like it should have been possible in one go, but tacking on the (replaces ...) clause above to Section 2.2 did not work as expected.]

Section 2.4 - Remove Text Capture's version of the non-FyreVM calls (replaces Part 2 - Define Our Four Phrases in Text Capture by Eric Eve)

[Again, though the above section 2.1 APPEARS to work, it actually doesn't, and the To say captured text phrase from the original extension remains alive without this]

*// ]
  
Nested Text Capture ends here.
