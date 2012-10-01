Version 1/120610 of Benchmarking (for Glulx only) by Dannii Willis begins here.

"A general purpose benchmarking test framework that produces statistically significant results."

"based on benchmark.js http://benchmarkjs.com"

Include Basic Screen Effects by Emily Short.
Include Glulx Text Effects by Emily Short.
Include Real-Time Delays by Erik Temple.
Include Flexible Windows by Jon Ingold.

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

Section - Real numbers unindexed

Include (-

[ numtof a b;
	@numtof a b;
	return b;
];

[ ftonumn a b;
	@ftonumn a b;
	return b;
];

[ fadd a b c;
	@fadd a b c;
	return c;
];

[ fsub a b c;
	@fsub a b c;
	return c;
];

[ fmul a b c;
	@fmul a b c;
	return c;
];

[ fdiv a b c;
	@fdiv a b c;
	return c;
];

[ ceil a b;
	@ceil a b;
	return b;
];

[ sqrt a b;
	@sqrt a b;
	return b;
];

[ pow a b c;
	@pow a b c;
	return c;
];

[ fabs a;
	@jflt a 0 ?negval;
	return a;
	.negval;
	return fsub(0, a);
];

[ jfgt a b;
	@jfgt a b ?isgreater;
	return 0;
	.isgreater;
	return 1;
];

Array PowersOfTen --> 1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000;

! FloatDec is taken from Glulxercise by Andrew Plotkin
! Print a float in decimal notation: "[-]NNN.NNNNN".
! The precision is the number of digits after the decimal point
! (at least one, no more than eight). The default is five, because
! beyond that rounding errors creep in, and even exactly-represented
! float values are printed with trailing fudgy digits.
[ FloatDec val prec   log10val int fint extra0 frac idig ix pow10;
	if (prec == 0)
		prec = 5;
	if (prec > 8)
		prec = 8;
	pow10 = PowersOfTen --> prec;
	
	! Knock off the sign bit first.
	if (val & $80000000) {
		@streamchar '-';
		val = val & $7FFFFFFF;
	}
	
	@jisnan val ?IsNan;
	@jisinf val ?IsInf;

	! Take as an example val=123.5, with precision=6. The desired result
	! is "123.50000".
	
	extra0 = 0;
	@fmod val $3F800000 frac fint; ! $3F800000 is 1.0.
	@ftonumz fint int;
	! This converts the integer part of the value to an integer value;
	! in our example, 123.
	
	if (int == $7FFFFFFF) {
		! Looks like the integer part of the value is bigger than
		! we can store in an int variable. (It could be as large
		! as 3e+38.) We're going to have to use a log function to
		! reduce it by some number of factors of 10, and then pad
		! with zeroes.
		@log fint sp;
		@fdiv sp $40135D8E log10val; ! $40135D8E is log(10)
		@ftonumz log10val extra0;
		@sub extra0 8 extra0;
		! extra0 is the number of zeroes we'll be padding with.
		@numtof extra0 sp;
		@fsub log10val sp sp;
		@fmul sp $40135D8E sp;
		@exp sp sp;
		! The stack value is now exp((log10val - extra0) * log(10)).
		! We've shifted the decimal point far enough left to leave
		! about eight digits, which is all we can print as an integer.
		@ftonumz sp int;
	}

	! Print the integer part.
	@streamnum int;
	for (ix=0 : ix<extra0 : ix++)
		@streamchar '0';

	@streamchar '.';

	! Now we need to print the frac part, which is .5.
	
	@log frac sp;
	@fdiv sp $40135D8E log10val; ! $40135D8E is log(10)
	@numtof prec sp;
	@fadd log10val sp sp;
	@fmul sp $40135D8E sp;
	@exp sp sp;
	! The stack value is now exp((frac + prec) * log(10)).
	! We've shifted the decimal point right by prec
	! digits. In our example, that would be 50000.0.
	@ftonumn sp idig;
	! Round to an integer, and we have 50000. Notice that this is
	! exactly the (post-decimal-point) digits we want to print.

	.DoPrint;
	
	if (idig >= pow10) {
		! Rounding errors have left us outside the decimal range of
		! [0.0, 1.0) where we should be. I'm not sure this is possible,
		! actually, but we'll just adjust downward.
		idig = pow10 - 1;
	}
	
	@div pow10 10 pow10;
	for (ix=0 : ix<prec : ix++) {
		@div idig pow10 sp;
		@mod sp 10 sp;
		@streamnum sp;
		@div pow10 10 pow10;
	}
	rtrue;

	.IsNan;
	@streamstr "NaN";
	rtrue;

	.IsInf;
	@streamstr "Inf";
	rtrue;
];

-).

A real number is a kind of value. R1 specifies a real number.
The specification of a real number is "Real numbers used for benchmark statistics. Is only minimally implemented and is not suitable for reuse."

To decide which real number is (a - number) as a real number:
	(- numtof({a}) -).

To decide which number is (a - real number) as a number:
	(- ftonumn({a}) -).

To decide which real number is (a - real number) plus (b - real number):
	(- fadd({a}, {b}) -).
To decide which real number is (a - real number) plus (b - real number) named (this is real number addition):
	decide on a plus b.

To decide which real number is (a - real number) minus (b - real number):
	(- fsub({a}, {b}) -).

To decide which real number is (a - real number) times (b - real number):
	(- fmul({a}, {b}) -).

To decide which real number is (a - real number) divided by (b - real number):
	(- fdiv({a}, {b}) -).

To decide which real number is (a - real number) rounded up:
	(- ceil({a}) -).

To decide which real number is the square root of (a - real number):
	(- sqrt({a}) -).
	
To decide which real number is (a - real number) to the power of (b - real number):
	(- pow({a}, {b}) -).

To decide which real number is the absolute value of (a - real number):
	(- fabs({a}) -).

To decide whether (a - real number) is more than (b - real number):
	(- jfgt({a}, {b}) -).

To say (a - real number):
	(- FloatDec({a}, 2); -).
To say (a - real number) with precision (b - a number):
	(- FloatDec({a}, {b}); -).

Section - Test cases

A test case is a kind of thing.
The specification of a test case is "A performance test case. Must be provided with a run phrase, which is what will actually be benchmarked."

[ These properties should be set by test case authors. ]
A test case has some text called the author.
[A test case has some text called the description.]

[ Test cases must provide a run function. For a test case called "example test" the run function should be defined as follows:
	To run test one (this is run test one): ...
	The run phrase of test one is run test one. ]
A test case has a phrase nothing -> nothing called the run phrase.

[ Test cases may provide a rule to check whether VM features they need are provided. If they are not they can set the disabled property. Add rules to the initialising rules rulebook. ]
A test case can be disabled.

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
A test case has a real number called the mean time. The mean time is usually R2139095040. [ +Infinity, so that sorting test cases works as we want, with disabled test cases last. ]
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
To time (test case - a test case) running it (iterations - a number) times/--:
	now iterations is iterations * the iteration multiplier of the test case;
	now the elapsed time of the test case is how long the run phrase of the test case takes to run iterations times;
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

Section - Statistics

[ We must customise LIST_OF_TY_Sort in order to compare real number properties. ]
To sort (L - a list of objects) in (P - real number valued property) order:
	(- LIST_OF_TY_Sort_Real_Number_Prop({-pointer-to:L}, 1, {P}, {-block-value:P}); -).
To sort (L - a list of objects) in reverse (P - real number valued property) order:
	(- LIST_OF_TY_Sort_Real_Number_Prop({-pointer-to:L}, -1, {P}, {-block-value:P}); -).
Include (-
Global LIST_OF_TY_Sort_cf;
[ LIST_OF_TY_Sort_Real_Number_Prop list dir prop cf  i j no_items v;
	no_items = BlkValueRead(list, LIST_LENGTH_F);
	if (dir == 2) {
		if (no_items < 2) return;
		for (i=1:i<no_items:i++) {
			j = random(i+1) - 1;
			v = BlkValueRead(list, LIST_ITEM_BASE+i);
			BlkValueWrite(list, LIST_ITEM_BASE+i, BlkValueRead(list, LIST_ITEM_BASE+j));
			BlkValueWrite(list, LIST_ITEM_BASE+j, v);
		}
		return;
	}
	SetSortDomain(ListSwapEntries, ListCompareEntries);
	!if (cf) { LIST_OF_TY_Sort_cf = BlkValueCompare; ! dir = -dir;
	!}
	!else LIST_OF_TY_Sort_cf = 0;
	LIST_OF_TY_Sort_cf = fsub;
	SortArray(list, prop, dir, no_items, false, 0);
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
	if the absolute value of (the t value for a and b) is more than the critical value for (the sample size of a + the sample size of b - 2):
		decide no;
	decide yes;

Section - Activities and rulebooks

[ We create several new activities, so that the framework can be decoupled from the interface. ]

Running the benchmark framework is an activity.
The initialising rules are a test case based rulebook.
Benchmarking something is an activity on test cases.
Timing something is an activity on test cases.

[ Go through all the test cases running them in turn. ]
Rule for running the benchmark framework (this is the main running the benchmark framework rule):
	let count be a number;
	repeat with a test case running through the list of test cases:
		follow the initialising rules for the test case;
		carry out the benchmarking activity with the test case;

[ Initialise a test case by running it once and calculating the iteration multiplier. This initial running won't be counted for the statistics, because an interpreter might need to spend extra time JITing. ]
A last initialising rule for a test case (called test case) (this is the initialising a test case rule):
	let count be 1;
	unless the test case is initialised or the test case is disabled:
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
Rule for benchmarking a test case (called test case) (this is the benchmarking a test case rule):
	let sample size be a number;
	let samples be a list of real numbers;
	let period be a real number;
	let mean be a real number;
	let variance be a real number;
	let standard deviation be a real number;
	let standard mean error be a real number;
	let error margin be a real number;
	let relative error be a real number;
	if the test case is disabled:
		stop;
	now the total time of the test case is 0;
	now the total count of the test case is 0;
	[ Get 5 samples, and then keep going until we have 100 samples or we've been timing for 5 seconds. ]
	while sample size < 5 or (the total time of the test case < 5000000 and sample size < 100):
		increment sample size;
		carry out the timing activity with the test case;
		now period is
			the iteration time of the test case as a real number
			divided by (the iteration count of the test case times the iteration multiplier of the test case) as a real number;
		add period to samples;
	[ Now for our stats. Taken from benchmark.js's evaluate() ]
	now mean is (the real number addition reduction of samples) divided by sample size as a real number;
	repeat with sample running through samples:
		now variance is variance plus ((sample minus mean) to the power of 2 as a real number);
	now variance is variance divided by (sample size - 1 as a real number);
	now standard deviation is the square root of variance;
	now standard mean error is standard deviation divided by the square root of sample size as a real number;
	now error margin is standard mean error times the critical value for (sample size - 1);
	now relative error is (error margin divided by mean) times 100 as a real number;
	[ Update the test case with these stats. ]
	now the mean time of the test case is mean;
	now the variance of the test case is variance;
	now the relative error of the test case is relative error;
	now the sample size of the test case is sample size;

[ Time a test case, by running it for at least the minimum sample time. ]
Rule for timing a test case (called test case) (this is the running a test case once rule):
	let remaining time be the minimum sample time;
	let count be the predicted sample count of the test case;
	[ Reset these totals. ]
	now the iteration time of the test case is 0;
	now the iteration count of the test case is 0;
	while remaining time > 0:
		time the test case running it count times;
		[ Check for 0 times. The iteration multiplier should stop these from occuring, but just in case... ]
		if the elapsed time of the test case < 1:
			say "Error: Test time was 0!";
			next;
		increase the iteration time of the test case by the elapsed time of the test case;
		increase the total time of the test case by the elapsed time of the test case;
		increase the iteration count of the test case by count;
		increase the total count of the test case by count;
		now remaining time is the minimum sample time - the iteration time of the test case;
		[ Unless we have a positive remaining time the following calculations will be ignored. ]
		[ Estimate how long it will take to reach the minimum sample time. ]
		now count is
			(remaining time as a real number divided by (
				the elapsed time of the test case as a real number 
				divided by count as a real number)
			) rounded up
			as a number;
		[ Ensure we will run at least once more. ]
		if count < 1:
			now count is 1;
	[ Update the predicted sample count. ]
	now the predicted sample count of the test case is
		(the iteration count of the test case as a real number 
		times the minimum sample time as a real number
		divided by the iteration time of the test case) 
		rounded up 
		as a number;

Part 2 - The interface unindexed

[ We need a room to stop Inform from complaining. ]
There is a room.

[ Extra styles for the results table. ]
Table of User Styles (continued)
style name	glulx color 
bold-style	g-green

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
	say "[fixed letter spacing]  [variable letter spacing]";

[ Scale the results so that tests that take a second are shown as microseconds. ]
The scale is a real number that varies.
The scale precision is a number that varies.
The scale label is a text that varies.

To adjust the scale for (n - a number):
	now the scale precision is 2;
	if n > 99999:
		now the scale is R1232348160; [1000000]
		now the scale label is "s";
		if n < 1000000:
			now the scale precision is 3;
	otherwise if n > 99:
		now the scale is R1148846080; [1000]
		now the scale label is "ms";
		if n < 1000:
			now the scale precision is 3;
	otherwise:
		now the scale is R1065353216; [1]
		now the scale label is "[microseconds]";

To say (test case - a test case) results:
	let the scaled mean time be the mean time of the test case divided by the scale;
	say "[indent][scaled mean time with precision scale precision][the scale label] [unicode 177][relative error of the test case]%[line break]";
	say "[indent]([sample size of the test case] samples, [total count of the test case * iteration multiplier of the test case] total runs)";

To reset the main window:
	[ This first line break is to make transcripts play nicely. ]
	say "[line break]";
	clear the main-window;
	say "[line break][run paragraph on]";

[ The stats will show up in a side window. ]
The menu window is a g-window.
The main-window spawns the menu window. The position of the menu window is g-placeleft.
The scale method of the menu window is g-proportional. The measurement of the menu window is 33.

[ Show some information on each test case. ]
To show the test case information:
	reset the main window;
	repeat with a test case running through the list of test cases:
		say "[bold type][The test case][roman type]";
		if the author of the test case is not "":
			say " by [the author of the test case]";
		say "[line break]";
		if the description of the test case is not "":
			say the description of the test case;
		otherwise:
			say "[italic type](No description)[roman type]";
		[ Silly hacks to make it print nicely. ]
		if the test case is not entry (number of entries in the list of test cases) in the list of test cases:
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

Before benchmarking a test case (called test case) (this is the showing a test case's info rule):
	now the current test case is the test case;
	now the current phase is "";
	now the current sample number is 0;
	say "[The test case]:[run paragraph on]";
	pause briefly;

Before timing a test case (this is the update the phase rule):
	increment the current sample number;
	now the current phase is "Sample #[the current sample number]";
	pause briefly;

After benchmarking a test case (called test case) (this is the say a test case's benchmark results rule):
	say "[line break]";
	if the test case is disabled:
		say "[indent][italic type](Disabled)[roman type]";
	otherwise:
		say the test case results;
	say "[line break]";

[ A use option to disable test comparisons. ]
Use nonequivalent tests translates as (- Constant NONEQUALTESTS; -).

[ Update the stats window with the results. The test cases will be sorted by ascending mean times, and those that are statistically the fastest will be coloured green. ]
After running the benchmark framework (this is the show the final results rule):
	let total time be a number;
	let sorted test cases be the list of test cases;
	now the left hand status line is "";
	now the right hand status line is "";
	update the status line;
	reset the main window;
	sort sorted test cases in mean time order;
	adjust the scale for the mean time of entry 1 of sorted test cases as a number;
	[ Reset the order if we're not comparing tests. ]
	if the nonequivalent tests option is active:
		now sorted test cases is the list of test cases;
	say the test header;
	repeat with a test case running through sorted test cases:
		if test case is disabled:
			say "[The test case]:[line break][indent][italic type](Disabled)[roman type][line break]";
		otherwise:
			increase total time by the total time of the test case;
			if the nonequivalent tests option is inactive and the test case and entry 1 of sorted test cases are statistically indistinguishable:
				say "[bold type][The test case]:[roman type][line break]";
			otherwise:
				say "[The test case]:[line break]";
			say the test case results;
			say "[line break]";
	let real total time be total time as a real number divided by R1232348160; [1000000]
	say "[line break]Total running time: [real total time]s";
	if the nonequivalent tests option is inactive:
		say "[paragraph break]The fastest test case is bold and green. If more than one test case is green then they are statistically indistinguishable.[run paragraph on]";

Section - The new order of play

[ Our new control sequence. ]
To run the benchmark framework:
	unless the interpreter can run the benchmark framework:
		say "A modern interpreter which supports Glulx version 3.1.2 and Glk version 0.7.2 is required.";
		stop;
	if the minimum timer resolution is 0:
		calculate the minimum timer resolution;
	open up menu window;
	run the control loop;

[ Accept commands. ]
To run the control loop:
	let key be a number;
	clear the menu window;
	move focus to menu window;
	say "[line break]";
	say the banner text;
	say "[paragraph break]You can:[line break][command]Enter[end command] Run the benchmark[line break][command]D[end command] Show test descriptions[line break][command]V[end command] Show version infomation[line break][command]T[end command] Start a transcript[line break][command]X[end command] Exit[run paragraph on]";
	move focus to main-window;
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

1. Story and extension authors can use Benchmarking to compare alternatives for some slow programming task. The example below shows how you might use Benchmarking to compare alternative ways to match texts.

2. Interpreter authors can use Benchmarking to compare their interpreter with others, as well as to compare interpreter updates to see whether they have a performance benefit or deficit.

The most accurate results will be obtained with a release build, as Inform's debug code will slow down some algorithms considerably, so be aware that simply using the Go! button will give different results than a release build would. (And if you want to run the tests with Inform's built-in interpreter on Windows you will need to install the 2012 6G60 re-release, as the original 6G60 release did not have all the necessarily functionality.)

Benchmarking is based on the Javascript library Benchmark.js. http://benchmarkjs.com

Benchmarking depends on Real-Time Delays by Erik Temple and Flexible Windows by Jon Ingold.

The latest version of this extension can be found at <https://github.com/i7/extensions>. This extension is released under the Creative Commons Attribution licence. Contact the author at <curiousdannii@gmail.com>

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
			now my test case is disabled.

Benchmarking is currently only designed for testing Glulx functionality, and it may not work well for testing Glk functionality. If you have potential Glk test cases please contact the author.

Section: Change log

Version 1/120610:
	Added a version action
	Added a nonequivalent tests use option
	The final results are now scaled

Version 1/120218:
	Initial (non-beta) release

Example: * Text matching - Avoiding slow Regular Expressions.

	*: "Text matching"
	
	Include Benchmarking by Dannii Willis.

	Search text is a text variable. Search text is "pineapple".
	Test text is a text variable. Test text is "apple banana grape orange pineapple starfruit".

	[ First we test what the standard rules give us. ]
	I7 default is a test case.
	The author of I7 default is "Graham Nelson".
	The description of I7 default is "The standard rules will use regular expressions to test if texts match, even though this is slow and inefficient."
	To run I7 default (this is running I7 default):
		if test text matches the text search text:
			do nothing.
	The run phrase of I7 default is running I7 default.

	[ Now check the texts directly, without using regular expressions.]
	To decide if (txb - indexed text) matches the text (ftxb - indexed text) without regex:
		(- check_for_matches({-pointer-to:txb}, {-pointer-to:ftxb}) -).
	Include (- [ check_for_matches text search   textsize searchsize i j k; textsize = BlkValueExtent(text); searchsize = BlkValueExtent(search); for (i=0 : i<textsize - searchsize + 1 : i++) { k = 0; for (j=0 : j < searchsize: j++) { if (BlkValueRead(text, i+j) ~= BlkValueRead(search, j)) { k = 1; break; } } if (k == 0) { return 1; } } return 0; ]; -).

	Direct comparison is a test case.
	The author of Direct comparison is "Dannii Willis".
	The description of Direct comparison is "We can instead check directly whether the texts match."
	To run Direct comparison (this is running Direct comparison):
		if test text matches the text search text without regex:
			do nothing.
	The run phrase of Direct comparison is running Direct comparison.