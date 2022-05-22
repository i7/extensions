Version 1.2 of Developer Framework by Peter Orme begins here.

"Common definitions useful for Inform7 authors and extension developers."

Chapter 1 - Definitions

Section 1 - Halting behavior

Halting behavior is a kind of value. 

The halting behaviors are halt on failure, halt on summary, and halt never. 

The specification of halting behavior is "Determines if we should halt execution on errors, or keep going. The 'halt on summary' behavior should be used to postpone the halting to some 'summary' stage, while 'halt on failure' means we should stop as soon as we detect a failure. The last one, 'halt never', is of course the setting to not halt at all.".

Section 2 - Verbosity

Verbosity is a kind of value. 

The verbosities are low verbosity, normal verbosity, and high verbosity. 

The specification of verbosity is "Used to set the verbosity of things (how talkative they should be). The settings are, from least talkative to most: low verbosity, normal verbosity, and high verbosity.";

Section 3 - Severity

Severity is a kind of value. 

The severities are every level, debug level, info level, warning level, error level, and off level. 

Developer Framework ends here.

---- Documentation ----

In this extension we find some definitions that we can use in other extensions or directly in Inform 7 code. 

Chapter: Kinds (enums)

In the chapter we find some new kinds of values.

Section: verbosity

Verbosity is used to set the verbosity of things (how talkative they should be). The settings are, from least talkative to most: low verbosity, normal verbosity, and high verbosity.

Section: Halting Behavior

A halting behavior is used to determine if we should halt execution on errors, or keep going. The 'halt on summary' behavior should be used to postpone the halting to some 'summary' stage (the definition of which is left to the author to determine), while 'halt on failure' means we should stop as soon as we detect a failure. The last one, 'halt never', is of course the setting to not halt at all.

Section: Severity

Severities are perhaps most useful for logging applications, where the message levels would be one of debug level, info level, warning level or error level, and the two extremes every level and off level would only be used for setting the levels of the logger itself. The extension Flexible Logger does precisely that, but the severity level is included here to make it generally available. 

Chapter: Version history

Version 1. First version.

Version 2. Changing "normal verbosity" to conversational. 

Version 3. Changing to more specific value names to avoid collisions, since values are not properly namespaced.
