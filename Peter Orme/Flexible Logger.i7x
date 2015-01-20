Version 1/130403 of Flexible Logger by Peter Orme begins here.

"A logging tool for I7 that lets you log to transcript and/or file (for Glulx)"

section logging for all

A log level is a kind of value. The log levels are log.all, log.debug, log.info, log.warning, log.error and log.off. 

console log control is a log level that varies. console log control is usually log.all.

to console log (level - a log level) message (msg - an indexed text):
	unless level is less than console log control:
		say "([level] turn [turn count]) [msg][line break]"

section shortcuts 

to debug (msg - indexed text):
	log log.debug message msg;

to warn (msg - indexed text):
	log log.warning message msg;

to info (msg - indexed text):
	log log.info message msg;

to error (msg - indexed text):
	log log.error message msg;

section logging (for Glulx only)

The logging file is an external file that varies. 

The File of Logging is called "informlog". 

The logging file is the File of logging.

file log control is a log level that varies. file log control is usually log.warning.

To file log (level - a log level) message (msg - indexed text):
	unless level is less than file log control:
		append "([level] turn [turn count]) [msg][line break]" to the logging file;

To log (level - a log level) message (msg - indexed text):
	file log level message msg;
	console log level message msg;

section logging (for Z-machine only) 

[TODO - finish this - you can make an alternative version here]

To log (level - a log level) message (msg - indexed text):
	console log level message msg.

Flexible Logger ends here.

---- DOCUMENTATION ----

This extension lets you log messages from any point in your Inform7 code by just doing "debug this message;". 

The message will then appear in the transcript as 
"(log.debug turn 14) this message"

For some more control, you can use predefined log levels. There's a type called log level with values log.debug, log.info, log.warning, and log.error you can use to log something:

	log log.info "this is logged as information."

You can do this:

	debug "This is a debug message.";

That's really just a shortcut for doing this:

	log log.debug message "This is a debug message.";

There are such shortcuts for all four log levels, so you can just do this:

	error "This is an error message";

You can control the minimum level at which log messages are shown using two settings:

	now console log control is log.warning

That line means that only warnings and errors are displayed, while debug and info messages are silently ignored. For this purpose there are actually two extra log levels, one at each end, log.off and log.all.

	now console log control is log.off

These work as expected: setting the log level to log.off turns all logging off, log.all turns all logging on. 

There's a reason the log level is called "console log control": there are two logs, one to console, and one to file. This only works for Glulx, if you are using z-machine you only get console logging. 

The filename used for logging is by default informlog.glkdata, in the folder where glulx decides to put it, probably where the main file is. You can change it like this:

	The File of Custom Logging is "myCustomLog";

	when play begins:
		now the logging file is the File of Custom Logging. 

Of course you can just switch file logging off:

	now file log control is log.off;
	

A corresponding file (informlog.glkdata) will be saved to file. 

Example: * Hello log - A minimal example. Just include and "debug", "warn" etc.

	*: "Hello logger"

	Include Flexible Logger by Peter Orme.

	There is a room. 

	When play begins: 
		debug "Hello log!";
		warn "This is a warning.";

Example: ** Controlled Logging - an example with some more features.

	*: "Controlled Logging"

	Include Flexible Logger by Peter Orme.

	There is a room. 

	section file log control (for glulx only)

	when play begins:
		now file log control is log.all;
		info "Play begins";

