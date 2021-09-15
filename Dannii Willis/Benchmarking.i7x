Version 2/210914 of Benchmarking (for Glulx only) by Dannii Willis begins here.

"A general purpose benchmarking test framework that produces statistically significant results. Version 2 works with 6M62."

"based on benchmark.js http://benchmarkjs.com"

Include Basic Screen Effects by Emily Short.
Include Glulx Text Effects by Emily Short.
Include Real-Time Delays by Erik Temple.
Include Version 10 of Flexible Windows by Jon Ingold.

Part 1 - The framework

[ I am greatly indebted to benchmark.js for the maths and logic of this framework. http://benchmarkjs.com/ ]

Section - I6 essentials

Include (-

[ check_float_gestalt temp;
	@gestalt 11 0 temp;
	return temp;
];

! Arrays for use with glk_current_time() (not that we actually use that function)
Array current_time --> 3;
Array current_time2 --> 3;

-).

[ We can't run the tests if our terp is too old. ]
To decide whether the interpreter can run the benchmark framework:
	(- (check_float_gestalt() && glk_gestalt(20, 0)) -).

To decide which number is (a - real number) as a number:
    (- REAL_NUMBER_TY_to_NUMBER_TY({a}) -).

To decide what real number is (N - a number) as a real number: decide on N.

To decide which real number is (a - real number) plus (b - real number) named (this is real number addition):
  decide on a plus b;

Section - Test cases

A test case is a kind of thing.
The specification of a test case is "A performance test case. Must be provided with a run phrase, which is what will actually be benchmarked."

[ These properties should be set by test case authors. ]
A test case has some text called the author.

[ Test cases must provide a run function. For a test case called "example test" the run function should be defined as follows:
	To run test one (this is run test one): ...
	The run phrase of test one is run test one. ]
A test case has a phrase nothing -> nothing called the run phrase.

[ Test cases may provide a rule to check whether VM features they need are provided. If they are not they can set the deactivated property. Add rules to the initialising rules rulebook. ]
A test case can be deactivated.

[ These properties are needed for the framework and should be ignored by authors. ]
A test case can be initialised.
A test case has a number called the elapsed time.
A test case has a number called the iteration time.
A test case has a number called the total time.
A test case has a number called the predicted sample count. The predicted sample count is usually 1.
A test case has a number called the iteration count.
A test case has a number called the total count.
A test case has a number called the iteration multiplier. The iteration multiplier is usually 1.
A test case has a number called the sample size.
A test case has a real number called the mean time. The mean time is usually plus infinity. [ +Infinity, so that sorting test cases works as we want, with deactivated test cases last. ]
A test case has a real number called the variance.
A test case has a real number called the relative error.

Section - Low level timing functions

[ We need to know the minimum timer resolution so that our results will be meaningful. Not all terps can provide a full microsecond timer, and even those that do might might cache its value. ]
The minimum timer resolution is a number variable.
The minimum sample time is a number variable.
To calculate the minimum timer resolution:
	(- get_timer_resolution(); -).
Include (-
[ get_timer_resolution sample begin measured i;
	! Take 30 samples
	for (i=0 : i<30 : i++)
	{
		@copy current_time sp;
		@glk 352 1 0;
		do
		{
			@copy current_time2 sp;
			@glk 352 1 0;
		}
		until (current_time-->2 ~= current_time2-->2 || current_time-->1 ~= current_time2-->1);
		sample = sample
			+ (current_time2-->1 - current_time-->1) * 1000000
			+ (current_time2-->2 - current_time-->2);
	}
	(+ the minimum timer resolution +) = sample / 30;
	
	! The minimum time each test case must be run for to achieve a percent uncertainty of at most 1%.
	(+ the minimum sample time +) = (+ the minimum timer resolution +) * 50;
];
-).

[ Run a test case a certain number of times, timing the total time. ]
To time (test-case - a test case) running it (iterations - a number) times/--:
	now iterations is iterations * the iteration multiplier of test-case;
	now the elapsed time of test-case is how long the run phrase of the test-case takes to run iterations times;
To decide which number is how long (func - phrase nothing -> nothing) takes to run (iterations - a number) times/--:
	(- time_function({func}-->1, {iterations}) -).
Include (-
[ time_function func iterations i;
	@copy current_time2 sp;
	@copy current_time sp;
	@glk 352 1 0;
	while (i < iterations)
	{
		func();
		i++;
	}
	@glk 352 1 0;
	return (current_time2-->1 - current_time-->1) * 1000000
		+ (current_time2-->2 - current_time-->2);
];
-).

[ T-test! ]
To decide which real number is the t value for (a - test case) and (b - test case):
	let pooled be
		( ((the sample size of a - 1) as a real number times the variance of a) plus ((the sample size of b - 1) as a real number times the variance of b) )
		divided by (the sample size of a + the sample size of b - 2) as a real number;
	decide on
		(mean time of a minus mean time of b)
		divided by the square root of ((pooled divided by the sample size of a as a real number) plus (pooled divided by the sample size of b as a real number));

[ Critical values ]
To decide which real number is the critical value for (df - number):
	(- get_critical_value({df}) -).
Include (-
! Taken from http://www.itl.nist.gov/div898/handbook/eda/section3/eda3672.htm
Array critical_values_table -->
	$+12.706 $+4.303 $+3.182 $+2.776 $+2.571 $+2.447 $+2.365 $+2.306 $+2.262 $+2.228
	$+2.201 $+2.179 $+2.16 $+2.145 $+2.131 $+2.12 $+2.11 $+2.101 $+2.093 $+2.086
	$+2.08 $+2.074 $+2.069 $+2.064 $+2.06 $+2.056 $+2.052 $+2.048 $+2.045 $+2.042;
Constant critical_value_infinity = $+1.96;

[ get_critical_value df;
	if (df > 30)
	{
		return critical_value_infinity;
	}
	return critical_values_table-->(df - 1);
];
-);

[ Significance ]
To decide whether (a - test case) and (b - test case) are statistically indistinguishable:
	if the absolute value of (the t value for a and b) > the critical value for (the sample size of a + the sample size of b - 2):
		decide no;
	decide yes;

Section - Activities and rulebooks

Test-case-list is a list of test cases variable.

[this is the initialize test case list rule:]
    
Last after starting the virtual machine rule:
    now test-case-list is the list of test cases;


[ We create several new activities, so that the framework can be decoupled from the interface. ]

Running the benchmark framework is an activity.
The initialising rules are a test case based rulebook.
Benchmarking something is an activity on test cases.
Timing something is an activity on test cases.

[ Go through all the test cases running them in turn. ]
Rule for running the benchmark framework (this is the main running the benchmark framework rule):
	let count be a number;
	repeat with test-case running through test-case-list:
		follow the initialising rules for test-case;
		carry out the benchmarking activity with test-case;

[ Initialise a test case by running it once and calculating the iteration multiplier. This initial running won't be counted for the statistics, because an interpreter might need to spend extra time JITing. ]
A last initialising rule for a test case (called test case) (this is the initialising a test case rule):
	let count be 1;
	unless the test case is initialised or the test case is deactivated:
		now the test case is initialised;
		[ Run the test case once in order to check it takes longer than the minimum timer resolution. Compare with three times the minimum timer resolution to ensure that we are definitely timing at least two whole resolution periods. Running only twice didn't seem enough to stop the test case from timing 0. ]
		time the test case running it count times;
		while the elapsed time of the test case < the minimum timer resolution * 3:
			[ If we're too quick, then keep doubling count until we reach the resolution. ]
			now count is count * 2;
			time the test case running it count times;
		[ From now on we will be treating this test case as if using the iteration multiplier consistutes running the test case just once, though we'll use the multiplier right at the end when we calculate the stats. ]
		now the iteration multiplier of the test case is count;

[ Benchmark a test case by timing at least 5 samples. ]
Rule for benchmarking a test case (called test-case) (this is the benchmarking a test case rule):
	let sample size be a number;
	let samples be a list of real numbers;
	let period be a real number;
	let mean be a real number;
	let variance be a real number;
	let standard deviation be a real number;
	let standard mean error be a real number;
	let error margin be a real number;
	let relative error be a real number;
	if test-case is deactivated:
		stop;
	now the total time of test-case is 0;
	now the total count of test-case is 0;
	[ Get 5 samples, and then keep going until we have 100 samples or we've been timing for 5 seconds. ]
	while sample size < 5 or (the total time of test-case < 5000000 and sample size < 100):
		increment sample size;
		carry out the timing activity with test-case;
		now period is
			the iteration time of test-case as a real number
			divided by (the iteration count of test-case times the iteration multiplier of test-case) as a real number;
		add period to samples;
	[ Now for our stats. Taken from benchmark.js's evaluate() ]
	now mean is (the real number addition reduction of samples) divided by sample size as a real number;
	repeat with sample running through samples:
		now variance is variance plus ((sample minus mean) to the power 2 as a real number);
	now variance is variance divided by (sample size - 1 as a real number);
	now standard deviation is the square root of variance;
	now standard mean error is standard deviation divided by the square root of sample size as a real number;
	now error margin is standard mean error times the critical value for (sample size - 1);
	now relative error is (error margin divided by mean) times 100 as a real number;
	[ Update test-case with these stats. ]
	now the mean time of test-case is mean;
	now the variance of test-case is variance;
	now the relative error of test-case is relative error;
	now the sample size of test-case is sample size;

[ Time a test case, by running it for at least the minimum sample time. ]
Rule for timing a test case (called test-case) (this is the running a test case once rule):
	let remaining time be the minimum sample time;
	let count be the predicted sample count of test-case;
	[ Reset these totals. ]
	now the iteration time of test-case is 0;
	now the iteration count of test-case is 0;
	while remaining time > 0:
		time test-case running it count times;
		[ Check for 0 times. The iteration multiplier should stop these from occuring, but just in case... ]
		if the elapsed time of test-case < 1:
			say "Error: Test time was 0!";
			next;
		increase the iteration time of test-case by the elapsed time of test-case;
		increase the total time of test-case by the elapsed time of test-case;
		increase the iteration count of test-case by count;
		increase the total count of test-case by count;
		now remaining time is the minimum sample time - the iteration time of test-case;
		[ Unless we have a positive remaining time the following calculations will be ignored. ]
		[ Estimate how long it will take to reach the minimum sample time. ]
		now count is the ceiling of
			(remaining time as a real number divided by (
				the elapsed time of test-case as a real number 
				divided by count as a real number)
			) as a number;
		[ Ensure we will run at least once more. ]
		if count < 1:
			now count is 1;
	[ Update the predicted sample count. ]
	now the predicted sample count of test-case is the ceiling of
		(the iteration count of test-case as a real number 
		times the minimum sample time as a real number
		divided by the iteration time of test-case) 
		as a number;

Part 2 - The interface unindexed

[ We need a room to stop Inform from complaining. ]
There is a room.


[ Extra styles for the results table. ]
Table of User Styles (continued)
style name (a glulx text style)	background color (a text)	color (a text)	first line indentation (a number)	fixed width (a truth state)	font weight (a font weight)	indentation (a number)	italic (a truth state)	justification (a text justification)	relative size (a number)	reversed (a truth state)
bold-style	"#000000"	"#0000FF"	0	false	bold-weight

[ Status line variables. ]
The current test case is a test case that varies.
The current phase is a text that varies.
The current sample number is a number that varies.

To update the status line:
	(- DrawStatusLine(); -);
To pause briefly:
	update the status line;
	wait 1 ms before continuing;

To show the version info:
	(- VersionSub(); -).

To say the test header:
	say "[header type]Test results[roman type][line break]Timer resolution: [the minimum timer resolution][microseconds][paragraph break]";

To say microseconds:
	say "[unicode 181]s".

To say header type -- running on:
	(- VM_Style(HEADER_VMSTY); -).

To say command:
	say "[bold type][bracket]".
To say end command:
	say "[close bracket][roman type]".

To say indent:
	say "[fixed letter spacing]    [variable letter spacing]";

[ Scale the results so that tests that take a second are shown as microseconds. ]
The scale is a real number that varies.
The scale precision is a number that varies.
The scale label is a text that varies.

To adjust the scale for (n - a number):
	now the scale precision is 2;
	if n > 99999:
		now the scale is 1000000; [R1232348160]
		now the scale label is "s";
		if n < 1000000:
			now the scale precision is 3;
	otherwise if n > 99:
		now the scale is 1000; [R1148846080]
		now the scale label is "ms";
		if n < 1000:
			now the scale precision is 3;
	otherwise:
		now the scale is 1; [R1065353216]
		now the scale label is "[microseconds]";

To say (test-case - a test case) results:
	let the scaled mean time be the mean time of test-case divided by the scale;
	say "[indent][scaled mean time to scale precision decimal places][the scale label] [unicode 177][relative error of test-case]%[line break]";
	say "[indent]([sample size of test-case] samples, [total count of test-case * iteration multiplier of test-case] total runs)";

To reset the main window:
	[ This first line break is to make transcripts play nicely. ]
	say "[line break]";
	clear the main window;
	say "[line break][run paragraph on]";

[ The stats will show up in a side window. ]
The menu window is a g-window.
The main window spawns the menu window. The position of the menu window is g-placeleft.
The scale method of the menu window is g-proportional. The measurement of the menu window is 33.

[ Show some information on each test case. ]
To show the test case information:
	reset the main window;
	repeat with test-case running through test-case-list:
		say "  [bold type][test-case][roman type]";
		if the author of test-case is not "":
			say " by [the author of test-case]";
		say "[line break]";
		if the description of test-case is not "":
			say the description of test-case;
		otherwise:
			say "  [italic type](No description)[roman type]";
		[ Silly hacks to make it print nicely. ]
		if test-case is not entry (number of entries in test-case-list) in test-case-list:
			say paragraph break;
		say "[run paragraph on]";

Section - Rules to show the benchmark framework's progress

Before running the benchmark framework (this is the resetting the interface rule):
	now the left hand status line is "[The current test case]";
	now the right hand status line is "[The current phase]";
	reset the main window;
	say the test header;
	adjust the scale for 0;

A first initialising rule (this is the set the phase to initialising rule):
	now the current phase is "Initialising".

Before benchmarking a test case (called test-case) (this is the showing a test case's info rule):
	now the current test case is test-case;
	now the current phase is "";
	now the current sample number is 0;
	say "[test-case]:[run paragraph on]";
	pause briefly;

Before timing a test case (this is the update the phase rule):
	increment the current sample number;
	now the current phase is "Sample #[the current sample number]";
	pause briefly;

After benchmarking a test case (called test-case) (this is the say a test case's benchmark results rule):
	say "[line break]";
	if test-case is deactivated:
		say "[indent][italic type](Deactivated)[roman type]";
	otherwise:
		say test-case results;
	say "[line break]";

[ A use option to disable test comparisons. ]
Use nonequivalent tests translates as (- Constant NONEQUALTESTS; -).

[ Update the stats window with the results. The test cases will be sorted by ascending mean times, and those that are statistically the fastest will be marked with a * ]
After running the benchmark framework (this is the show the final results rule):
	let total time be a number;
	let sorted-test-cases be test-case-list;
	now the left hand status line is "";
	now the right hand status line is "";
	update the status line;
	reset the main window;
	sort sorted-test-cases in mean time order;
	let wc be entry 1 of sorted-test-cases;
	let mt be the mean time of wc;
	let intmt be mt as a number;
	adjust the scale for intmt;
[	adjust the scale for ((the mean time of (entry 1 of sorted-test-cases)) as a number);]
	[ Reset the order if we're not comparing tests. ]
	if the nonequivalent tests option is active:
		now sorted-test-cases is test-case-list;
	say the test header;
	repeat with test-case running through sorted-test-cases:
		if test-case is deactivated:
			say "[test-case]:[line break][indent][italic type](Deactivated)[roman type][line break]";
		otherwise:
			increase total time by the total time of test-case;
			if the nonequivalent tests option is inactive and test-case and entry 1 of sorted-test-cases are statistically indistinguishable:
				say "* [bold type][test-case]:[roman type][line break]";
			otherwise:
				say "  [test-case]:[line break]";
			say test-case results;
			say "[line break]";
	let real total time be a real number;
	now real total time is total time;
	now real total time is real total time divided by 1000000; [R1232348160]
	say "[line break]Total running time: [real total time]s";
	if the nonequivalent tests option is inactive:
		say "[paragraph break]The fastest test case is bold and marked with a *. If more than one test case is marked then they are statistically indistinguishable.[run paragraph on]";

Section - The new order of play

[ Our new control sequence. ]
To run the benchmark framework:
	unless the interpreter can run the benchmark framework:
		say "A modern interpreter which supports Glulx version of at least 3.1.2 and Glk version of at least 0.7.2 is required.";
		stop;
	if the minimum timer resolution is 0:
		calculate the minimum timer resolution;
	open up menu window;
	run the control loop;

[ Accept commands. ]
To run the control loop:
	let key be a number;
	clear the menu window;
	focus menu window;
	say "[line break]";
	say the banner text;
	say "[paragraph break]You can:[line break][command]Enter[end command] Run the benchmark[line break][command]D[end command] Show test descriptions[line break][command]V[end command] Show version infomation[line break][command]T[end command] Start a transcript[line break][command]X[end command] Exit[run paragraph on]";
	focus main window;
	while 1 is 1:
		now key is the chosen letter;
		[ Run on Enter or Space ]
		if key is -6 or key is 32:
			carry out the running the benchmark framework activity;
		[ Test case info on D ]
		if key is 68 or key is 100:
			show the test case information;
		[ Version on V ]
		if key is 86 or key is 118:
			reset the main window;
			show the version info;
		[ Transcript on T ]
		if key is 84 or key is 116:
			reset the main window;
			try switching the story transcript on;
		[ Exit on X or Escape ]
		if key is -8 or key is 88 or key is 120:
			stop;

[ We don't want to follow the regular turn sequence, so highjack the game when play begins. Unlist this if you want to control when it runs yourself. ]
A last when play begins rule (this is the benchmark framework is taking over rule):
	run the benchmark framework;
	stop the game abruptly;

Benchmarking ends here.

---- DOCUMENTATION ---- 

Section: Introduction

Benchmarking provides a general purpose benchmarking test framework which produces statistically significant results. Benchmarking refers to carefully timing how long some task takes to run. This extension has two types of users in mind:

1. Story and extension authors can use Benchmarking to compare alternatives for some slow programming task. The examples below shows how you might use Benchmarking to compare alternative ways to test for a container's emptiness.

2. Interpreter authors can use Benchmarking to compare their interpreter with others, as well as to compare interpreter updates to see whether they have a performance benefit or deficit.

The most accurate results will be obtained with a release build, as Inform's debug code will slow down some algorithms considerably, so be aware that simply using the Go! button will give different results than a release build would. (And if you want to run the tests with Inform's built-in interpreter on Windows you will need to install the 2012 6G60 re-release, as the original 6G60 release did not have all the necessarily functionality.)

Benchmarking is based on the Javascript library Benchmark.js. http://benchmarkjs.com

Benchmarking depends on Real-Time Delays by Erik Temple and Flexible Windows by Jon Ingold.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.

Section: Writing test cases

A test case should be added for each task or algorithm you wish to test. Each test case must be provided with a run phrase, which is what will be benchmarked. Unfortunately the Inform 7 syntax for attaching the run phrase is a little clunky. You must first give the phrase a name, and then attach it to the test case.

	My test case is a test case.
	To run my test case (this is running my test case):
		...
	The run phrase of my test case is running my test case.

If you are comparing algorithms for the same task it is important that they all do actually do the same thing. This extension does not and cannot compare whether test case algorithms are equivalent, so you should first test your algorithms thoroughly. If you are not comparing equivalent algorithms, use this option to prevent the final test comparisons:

	Use nonequivalent tests.

It is also important that test cases run the same each time through, so if your test case changes the world state in some way you must reset what it changes as part of your run phrase.

Test cases are a kind of thing, so like all things they can have descriptions. They can also be given an author, as shown in the example.

Some test cases might require recent or optional interpreter features. If so then you can add an initialisation rule, in which you can check if that interpreter feature is supported, and disable the test case if not.

	To decide whether unicode is supported: (- (unicode_gestalt_ok) -).
	Rule for initialising my test case:
		unless unicode is supported:
			now my test case is deactivated.

Benchmarking is currently only designed for testing Glulx functionality, and it may not work well for testing Glk functionality. If you have potential Glk test cases please contact the author.

Section: Change log

Version 2/210914:
	Updated for 6M62 by Zed Lopez:
	- ripped out the homebrew real number implementation, replacing with I7 native reals
	- updated appropriately for Flexible Windows 10.    
	- the previous example no longer compiles; replaced it with When One Stares into the Void

Version 1/120610:
	Added a version action
	Added a nonequivalent tests use option
	The final results are now scaled

Version 1/120218:
	Initial (non-beta) release

Section: Example

Example: * When one stares into the void -- testing for emptiness

	*: "When one stares into the void"

	Include Benchmarking by Dannii Willis.
	
	The table is a supporter. The box is a container on the table. The action figure is in the box. There are 5 toy soldiers. There are 7 coins. There are 99 luftballoons.
	
	There-is-nothing is a test case.
	The author is "Zed Lopez".
	The description is "Testing container emptiness with ``there is nothing``".
	
	To run there-is-nothing (this is running there-is-nothing):
	let x be 0;
	if there is nothing in the box, increment x.
	
	The run phrase is running there-is-nothing.
	
	[ ... ]
	
	Looking for first thing held nothing is a test case.
	The author is "Zed Lopez".
	The description is "Testing container emptiness with ``the first thing held by the box is nothing``".
	
	To run looking for first thing held nothing (this is running Looking for first thing held nothing):
	let x be 0;
	if the first thing held by the box is nothing, increment x.
	
	The run phrase is running Looking for first thing held nothing.
	
	[ ... ]
	
	Include (-
	[ CountHoldingsExceptParts obj;
	  return children(obj);
	];
	-)
	
	To decide what number is the/a/-- count of the/-- contents of the/a/an/-- (C - a container):
	  (- CountHoldingsExceptParts({C}) -)
	
	Looking for count of things contained is a test case.
	The author is "Zed Lopez".
	The description is "Testing container emptiness with ``I6 child -> sibling for loop``".
	To run looking for count of contents (this is running Looking for count of contents):
	let x be 0;
	if the count of the contents of the box is zero, increment x.
	
	The run phrase is running Looking for count of contents.
	
	[ ... ]
	
	Include (-
	[ HoldsNothing obj;
	  if (child(obj)) rfalse;
	  rtrue;
	];
	-);
	
	Definition: a container is xempty rather than non-xempty if the first thing held by it is nothing.
	
	Empty-by-definition is a test case.
	To run Empty-by-definition (this is running Empty-by-definition):
	let x be 0;
	if the box is xempty, increment x.
	
	The run phrase is running Empty-by-definition.
	
	[ ... ]
	
	Definition: a container is devoid-of-content rather than non-devoid-of-content if I6 routine "HoldsNothing" says so (it has nothing in it).
	
	HoldsNothing-by-definition is a test case.
	To run HoldsNothing-by-definition (this is running HoldsNothing-by-definition):
	let x be 0;
	if the box is devoid-of-content, increment x.
	
	The run phrase is running HoldsNothing-by-definition.
	
	[ ... ]
	
	To decide whether (C - a container) is void-like:
	    (- HoldsNothing({C}) -)
	
	HoldsNothing is a test case.
	To run HoldsNothing (this is running HoldsNothing):
	let x be 0;
	if the box is void-like, increment x.
	
	The run phrase is running HoldsNothing. 

	Nothing-in is a test case.
	To run Nothing-in (this is running Nothing-in):
	let x be 0;
	if nothing is in the box, increment x.
	
	The run phrase is running Nothing-in. 

	unless-something is a test case.
	The author is "Zed Lopez".
	The description is "Testing container emptiness with ``there is not something in it``".
	
	To run unless-something (this is running unless-something):
	let x be 0;
	unless there is something in the box, increment x.
	
	The run phrase is running unless-something.
