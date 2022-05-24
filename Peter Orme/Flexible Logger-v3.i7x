Version 3.3 of Flexible Logger by Peter Orme begins here.

"A logging tool for I7 that lets you log to transcript and (with Glulx) to file"

[levels and verbosity comes from Developer Framework]
Include Developer Framework by Peter Orme.

Use Authorial modesty.

Section 1 - The Logger Kind

[
	Since version 3 there is a Logger kind, so we can use more than one and configure them differently. 
 	But don't worry, there's also a default one we can use.
]

A logger is a kind of object. 

[severity is defined in Developer Framework]
A logger has a severity called level.
A logger can be logging to file or not logging to file.
A logger can be logging to console or not logging to console.

The level of a logger is usually debug level.
A logger is usually logging to console.
A logger is usually not logging to file.

Default logger is a logger.
The level of the default logger is debug level.

Section 2 - who logs the loggers? 

[ Verbosity is defined in Developer Framework. ]

logger configuration reporting is a verbosity that varies. 
logger configuration reporting is usually normal verbosity.

Section 3 - Console logging for all 

to console log (message - a text) at (chosen level - a severity) to (chosen logger - a logger):
	unless the chosen level is less than the level of the chosen logger:
		say "([chosen logger], [chosen level], turn [turn count]): [message][line break]";

Section 4 - File Logging (for Glulx only)

The logging file is an external file that varies. 

The File of logging is called "informlog". 

The logging file is the File of logging.

To file log (message - a text) at (chosen level - a severity) to (chosen logger - a logger):
	unless the chosen level is less than the level of the chosen logger:
		append "([chosen logger], [chosen level], turn [turn count]): [message][line break]" to the logging file;
		
Section 5 - Warn about trying to use unavailable file logging (for Z-machine only) 

[
	File logging is not supported for Z-machine, so this prints a warning.
	If we are really bent on trying to log to file with z-machine, but we don't want to be reminded it does not work, 
	we can also mute the warnings: 'now the logger configuration reporting is low verbosity'.
]

To file log (message - a text) at (chosen level - a severity) to (chosen logger - a logger):
	unless the logger configuration reporting is less than normal verbosity:
		say "File logging is not available with z-machine. Disable it with 'now [the chosen logger] is not logging to file.'";

Section 6 - routing the logging to console and/or file

[ Each logger can log to file, or console, or both, or neither. ]

to log (message - a text) at (chosen level - a severity) to (chosen logger - a logger): 
	if the chosen logger is logging to console:
		console log the message at chosen level to the chosen logger;
	if the chosen logger is logging to file:
		file log the message at the chosen level to the chosen logger;
	
Section 8 - shortcuts for logging to a specific logger

[ to make the code a little shorter we can use these shorter versions ]

to debug to (chosen logger - a logger) saying (message - a text): 
	log message at debug level to the chosen logger;

to info to (chosen logger - a logger) saying (message - a text): 
	log message at info level to the chosen logger;

to warn to (chosen logger - a logger) saying (message - a text): 
	log message at warning level to the chosen logger;
	
to error to (chosen logger - a logger) saying (message - a text): 
	log message at error level to the chosen logger;

Section 7 - Shortcuts for logging to default logger 

[ the shortest and simplest way to log is to use these methods which log to the default logger ]

to debug (message - a text):
	log the message at debug level to the default logger;

to info (message - a text):
	log message at info level to default logger;
		
to warn (message - a text):
	log message at warning level to default logger;

to error (message - a text):
	log message at error level to default logger;

to log (message - a text) at (chosen level - a severity): 
	log message at the chosen level to the default logger;


Flexible Logger ends here.


---- DOCUMENTATION ----

This extension lets us log messages from any point in your Inform7 code by doing something as simple as "debug 'Whatever message';".

The message will then appear in the transcript as 
"(Default logger, turn 1, debug level): Whatever message"

For some more control, you can use different predefined log levels. These use the severity kind defined in the extension Developer Framework. You can use those to log something at a specified severity:

	log "this is logged as information." at info level.

When you do this:

	debug "This is a debug message.";

That is really just a shortcut for doing this:

	log message "This is a debug message." at debug level to the default logger;

There are such shortcuts for all four log levels, so you can just do any of these:

	debug "This is a message";	
	info "This is a message";	
	warn "This is a message";	
	error "This is a message";

There are some different ways we can control what gets logged where: defining levels, and deciding whether to log to console or file, and setting up different
loggers with different configurations. 

Section: Controlling the log level 

You can control the minimum level at which log messages are shown:

	now the level of the default logger is warning level.

That line means that only warnings and errors are displayed, while debug and info messages are silently ignored (because we are logging anything that is at least as severe as a warning). 

We can log at four different levels of increasing severity: debug level, info level, warning level and error level. 

For the completist, there are two additional severities: off level and every level. We can't log messages at "off" or "every" level, but we can use those for setting the levels of the loggers.

	now the level of the default logger is every level.
	
Although in practice it doesn't matter whether we use "every level" or "debug level" (since there is no lower level), and the same for "error level" and "every level" - there is no higher level than error, so it's the same thing. 

These work as expected: setting the log level to off level turns all logging off, every level turns all logging on. 

Section: Logging to console

Logging to console just means that we "say" the log messages (with a bit of preamble that makes it clear that this is a log message). 

We can turn console logging on and off:
	
	now the default logger does not log to console
	
or 

	now the default logger logs to console
	

The difference between setting the level to off level and turning off console logging is that, well, they're different things. For example, if we set the level to warning level, turn on file logging, and turn off console logging, we are going to get warnings and errors in the file log, but nothing in the console. 

Section: Logging to file 

Logging to file only works if we are using Glulx - not Z-machine. 

By default, nothing is logged to file, so we need to turn it on:
	
	now the default logger is logging to file.

By default, the logs will end up in a file in the root of our project (where the projectname.inform and projectname.materials folders live). The default file name is informlog.glkdata. If we wish to rename it 
we can do that like this: 

	The File of Custom Logging is "myCustomLog";
	when play begins:
		now the logging file is the File of Custom Logging. 

On a linux system like Mac, in a terminal, we can do 

	tail -f informlog.glkdata 
	
and see the file logs appearing in the terminal window while we play in the Inform app. 

Allegedly we can do something similar on Windows using PowerShell:
	
	Get-Content .\informlog.glkdata -Tail
	
There is no need to create this file manually, it should be done by Inform, but if we're using it for 
a long time, eventually the file will become large. Then we can just delete it, or rename it, etc. 

Section: Using multiple loggers 

We can create different loggers for different parts of your code, or different things in the game world. 

Creating a new logger is simple: 

	The laser log is a logger. 

We can then configure that just like the default logger: 

	The level of the laser log is warning level.
	The laser log is not logging to file.

And when something happens in the game that relates to that feature, we log to it:
	
	info to laser log saying "The user is in [the location of the player] fiddling with a laser."

Section: updating to version 3

Before version 3, there were two different levels for console and log. You would then say 

	now file log level is every level
	
If we really just want to log everything to file, the version 3 equivalent is setting the level and turning on and off file and console logging (and perhaps using multiple loggers). 

	now the default logger is logging to file;
	now the level of the default logger is every level;

If you were using that feature to have different log levels (e.g. only getting warnings and errors on file, but getting everything in console), we either need to rethink the strategy or do something creative. 

If anybody needs that feature, or has any other problems or feedback, please let the author (peterorme6@gmail.com) know. 


Example: * Hello log - A minimal example. Just include and "debug", "warn" etc.

	*: "Hello logger"

	Include Flexible Logger by Peter Orme.

	There is a room. 

	When play begins: 
		debug "Hello log!";
		warn "This is a warning.";

Example: ** Controlled Logging - an example with some more features.

	*: "Don't forget the fridge!"

	Include Flexible Logger by Peter Orme.

	The Kitchen is a room. 

	The Fridge is a fixed in place openable closed container in the Kitchen.

	The temperature logger is a logger.

	The Living Room is room. It is south from the Kitchen.

	After going to the Living Room when the fridge is open:
		debug to the temperature logger saying "Leaving the kitchen with the door open.";
	
	Test me with "open fridge / go south"

When we test this, we should see the debug log about leaving the fridge door open. Let's pretend we have a big project with lots of logging going on, and we have been following this pattern of using different loggers for different things. In this case, it's not specific to the fridge, but there's some sort of temperature puzzle going on, and we have all the log messages related to that going to the "temperature logger". Ok, let's say we're not done with that, but there's something else wrong with the cat control puzzle. OK, easy: we just mute the low-severity logging about the temperature:
	
	The level of the temperature logger is error level.


