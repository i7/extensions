Version 1.2 of Nested Text Capture by Taryn Michelle begins here.

"Builds on Eric Eve's text capture extension (with contributions from Dannii Willis) to allow for re-entrance."

[Defer to Text Capture low-level routines for the actual capturing of output text to a string buffer]
Include version 8 of Text Capture by Eric Eve. 

Book 1 - Making Text Capture Re-Entrant

Part 0 - Instrumentation

[Don't force dependency on the entire Text Basics extension]

Section - Text Concatenation (for use without Text Basics by Taryn Michelle)

To decide which text is (V1 - value of kind K) & (V2 - Value of kind L):
	decide on "[V1][V2]";
	
To decide which K is (T - truth state) ? (V1 - Value of kind K) ! ( V2 - K ):
	if T is true:
		decide on V1;
	decide on V2;

[Externally include Trace Output extension to enable debugging messages from Nested Text Capture]
	
Part - Re-Entrant Functionality

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

Section - Set larger default capture buffer length (for Glulx Only)

[ // TMV 12 Oct 2024 - When using Glulx, we increase the default capture buffer minimum length to a significantly larger size;
  // TODO: See commented out bit below; per documentation syntax is supposed to support redefinition but this seems to fail in Inform 10.x]
Use maximum capture buffer length of at least 2048; [ translates as (- Constant CAPTURE_BUFFER_LEN = {N}; -). ]

Section - Create the capture buffer stack

[Avoid public use of these globals, preferring the phrases in Sections 3 (and only if absolutely necessary, Section 4)]
text_capture_context is a list of texts that varies. text_capture_context is {""}.
text_capture_level is a number that varies. 

Section - Nested Text capture

To decide whether we're capturing text: decide on whether or not text_capture_level > 0;

To begin text capture:
	if text-capture-suspended is true: [Neither begin nor end any sort of text capture while suspended]
		stop;
	if text_capture_level < 0:
		say_immediate "WARNING: Internal Error: text_capture_level < 0 (which should never happen)";
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
	if text-capture-suspended is true: [Neither begin nor end any text capture while suspended]
		stop; 
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
		say_immediate "WARNING: Mismatched call to end text capture (capture is not active)";
		
[To say the/-- captured text:
	let N be text_capture_level + 1;
	say "[entry N of text_capture_context]";]
	
To decide which text is the/-- captured text:
	let N be text_capture_level + 1;
	decide on entry N of text_capture_context;
	
Section - Phrases to micro-manage capture contexts

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

Section - Bypassing text capture 

[Internally used to print an immediate WARNING message to the console in the event of error conditions that SHOULD not occur, and not meant for general usage. If you decide to use the feature anyway, see the important caveats below.]

To say_immediate (T - text):
	suspend text capture;
	push "OUTPUT IMMEDIATE: [T]" to debug_tc;
	say T;
	resume text capture;

[For when we want to ensure some text is immediately printed to the console regardless of the state of text capture (such as critical debugging or warning messages). Code executed while text capture is suspended should ideally be self-contained and invoke nothing that might itself trigger additional calls to the text capture machinery. 

The capability exists primarily to support debugging problems related to the use (or misue) of the nested text capture feature itself. That said, suspending text capture WILL prevent starting/stopping new capture contexts until "resume" is called. IF the suspend/resume calls are properly placed, then we might be able to get away with invoking other code even if it does normally rely on capturing text. Provided all begin/end capture calls are properly paired, and occur entirely between the suspend/resume calls, things should behave (as in not crash). 

There are NO GUARANTEES other code that epends on the (temporarily suspended) ability to capture text will behave properly, of course. Attempt at your own risk, and reserve ONLY for the rare case it's truly critical to push a message to the console immediately, without waiting for any pending text capture to complete.]

text-capture-suspended is a truth state that varies. 

debug_tc is a thing.
the description of debug_tc is "Put errors and warnings and important debug trace stuff here, so we can look at it afterward with 'SHOWME debug_tc'".

To push (T - text) to (debug - a thing):
	now the description of debug_tc is the description of debug_tc & "[line break][T]";

To suspend text capture: 
	push "SUSPEND CAPTURE: " & ( whether or not we're low-level capturing text ? "(capture is active with context [current text capture context])" ! "(capture inactive)" ) to debug_tc;
	if we're capturing text: [ technically we don't really have to test this, but WHY ISN'T THE TEST WORKING HERE?!]
		begin text capture; [Unintuitive at first, but starting a NEW NESTED CONTEXT does exactly what we need]
		push "NEW TEMP CAP CTX OPENED ([current text capture context])" & (whether or not we're low-level capturing text ? "(capture is active)" ! "(capture inactive)" ) to debug_tc;
		end low-level text capture; [Stop capturing text in the NEW context -- note that there is no captured text to worry about saving here, and no need to finagle with any higher-level context(s) on the stack]
		push "CAPTURE SUSPENDED: " & (whether or not we're low-level capturing text ? "(capture is active)" ! "(capture inactive)" ) to debug_tc;
		now text-capture-suspended is true; 
				
To resume text capture: 
	push "RESUME CAPTURE: " & ( whether or not we're low-level capturing text ? "(capture is active - AN ERROR)" ! "(capture inactive)" ) to debug_tc;
	if text-capture-suspended is true:
		begin low-level text capture; [We are still sitting in our newly nested, EMPTY capture context. Turn the machinery on ... ]
		push "CAPTURE RESUMED: " & (whether or not we're low-level capturing text ? "(capture is active with context [current text capture context])" ! "(capture inactive)" ) to debug_tc;
		now text-capture-suspended is false;
		end text capture; [... only to immediately end the nested capture (the right way, not at the low-level). Capture will now pick up where it left off at the previous context]
		push "TEMP CAP CTX CLOSED (context reverted to [current text capture context])" & (whether or not we're low-level capturing text ? "(capture is active)" ! "(capture inactive)" ) to debug_tc;
			
Section - Safely close out any text capturing still active at end of turn

[ Safe, but not necessarily elegant. If this rule kicks in, we've done something wrong elsewhere. Text capture will be stopped, and any captured output will be flushed to the console, but the results may well not be as desired. ]

[ NB: We cannot ensure this is THE last every turn rule, just A last rule. If you make use of capturing text in your own "Last every turn" rule(s), and are concerned about this rule possibly causing conflicts, then simply unlist this rule. If you do unlist it, then for absolute safety, once you're all done capturing text (and have closed the capture context(s) properly, by calling "end text capture"), you should add a line of code to "follow the safely close open text capturing contexts rule" yourself. ]
Last Every turn (this is the safely close text capture contexts left open rule):
	[We should NOT be capturing text at this point. If we are, it's an error -- we force all capture contexts closed and flush the buffer(s)]
	if we're capturing text or we're low-level capturing text:
		say_immediate "[bold type][line break]WARNING: End of turn reached with text capture still active ( [current text capture context]) - forcing capture closed and flushing buffered text. (Check for mismatched begin/end capture statements in your code)[line break][roman type]" (A);
		end text capture for 1; [close all capture out]
		say captured text;
		if captured text > "":
			say "[bold type][line break]// END of flushed text capture buffers. Again, this should not have occurred. Check for mismatched begin/end capture statements in your code. //[roman type][line break]" (B);

		
Section - Remap original Text Capture calls

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
