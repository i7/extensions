Version 2/150201 of Flexible Logger by Peter Orme begins here.

"A logging tool for I7 that lets you log to transcript and/or file (for Glulx)"

Include Developer Framework by Peter Orme.
Use Authorial modesty.

Section 1 - Logging for all

Console log level is a severity that varies. Console log level is usually every level.

to console log (msg - an indexed text) at (level - a severity) :
	unless level is less than console log level:
		say "([level] turn [turn count]) [msg][line break]"

Section 2 - Shortcuts 

to debug (msg - indexed text):
	log msg at debug level;

to info (msg - indexed text):
	log msg at info level;
	
to warn (msg - indexed text):
	log msg at warning level;

to error (msg - indexed text):
	log msg at error level;

Section 3 - File Logging (for Glulx only)

The logging file is an external file that varies. 

The File of Logging is called "informlog". 

The logging file is the File of logging.

File log level is a severity that varies. File log level is usually warning level.

To file log (msg - indexed text) at (level - a severity) :
	unless level is less than file log level:
		append "([level] turn [turn count]) [msg][line break]" to the logging file;

To log (msg - indexed text) at (chosen level - a severity):
	file log msg at chosen level;
	console log msg at chosen level;

Section 4 - Fallback Logging (for Z-machine only) 
[With Z-machine, all the logging is just console logging]

To log (msg - indexed text) at  (chosen level - a severity):
	console log msg at chosen level.

Flexible Logger ends here.

---- DOCUMENTATION ----

This extension lets you log messages from any point in your Inform7 code by just doing "debug 'Whatever message';". 

The message will then appear in the transcript as 
"(debug level turn 14) Whatever message"

For some more control, you can use predefined log levels. These use the severity kind defined in the extension Developer Framework. You can use those to log something at a specified severity:

	log "this is logged as information." at info level.

You can do this:

	debug "This is a debug message.";

That's really just a shortcut for doing this:

	log message "This is a debug message." at debug level.

There are such shortcuts for all four log levels, so you can just do this:

	error "This is an error message";

You can control the minimum level at which log messages are shown using two settings:

	now console log level is warning level.

That line means that only warnings and errors are displayed, while debug and info messages are silently ignored. For this purpose there are actually two extra log levels, one at each end, log.off and log.all.

	now console log control is off level.

These work as expected: setting the log level to off level turns all logging off, every level turns all logging on. 

There's a reason the log level is called "console log level": there are two logs, one to console, and one to file. This only works for Glulx, if you are using z-machine you only get console logging. 

The filename used for logging is by default informlog.glkdata, in the folder where glulx decides to put it, probably where the main file is. You can change it like this:

	The File of Custom Logging is "myCustomLog";

	when play begins:
		now the logging file is the File of Custom Logging. 

Of course you can just switch file logging off:

	now file log level is off level;
	

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

	when play begins:
		now file log level is every level;
		info "Play begins";

