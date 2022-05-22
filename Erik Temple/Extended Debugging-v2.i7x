Version 2.2 of Extended Debugging by Erik Temple begins here.

"Provides a way for the author to release a build of a game while retaining both custom and built-in debugging commands. Also wraps Inform's debug tracing routines in phrases that authors can use to trigger rule-tracing from the source text rather than from the command prompt and provides other debugging features."


Use authorial modesty.

Include (- constant DEBUG; constant STRICT_MODE; -) after "Definitions.i6t".

Section - Phrases for immediate tracing

Use initial intensive debug tracing translates as (- Constant INIT_ALL_TRACE; -).
Use initial brief debug tracing translates as (- Constant INIT_RULE_TRACE; -).

Before starting the virtual machine:
	If the initial intensive debug tracing option is active:
		turn on intensive rule-tracing;
		turn on actions-tracing;
		turn on scenes-tracing;
	otherwise if the initial brief debug tracing option is active:
		turn on brief rule-tracing;
		turn on actions-tracing;
		turn on scenes-tracing.


Section - Wrappers for actions commands

To turn on actions-tracing:
	(- ActionsOnSub(); -)

To turn off actions-tracing:
	(- ActionsOffSub(); -)


Section - Wrappers for rule-tracing commands

To turn on intensive rule-tracing:
	(- RulesAllSub(); -)
	
To turn on brief rule-tracing:
	(- RulesOnSub(); -)
	
To turn off rule-tracing:
	(- RulesOffSub(); -)


Section - Wrappers for scene-tracing commands

To turn on scenes-tracing:
	(- ScenesOnSub(); -)

To turn off scenes-tracing:
	(- ScenesOffSub(); -)


Section - Wrapper for the glklist command

To show the/-- glk/glklist list/--:
	(- GlkListSub(); -)


Chapter - Custom rule-tracing (Ron Newcomb)

[Thanks to Ron Newcomb for providing the custom rule-tracing code.]

To enable brief/-- rule-tracing for (R - a rule):
	(- if (debug_rules) DB_Rule({R}, {R}); -).

To enable intensive rule-tracing only/-- for (R - a rule):
	(- if (debug_rules >= 2) DB_Rule({R}, {R}); -).

Include (- Global save_debug_rules; -) after "Definitions.i6t".

To suspend rule-tracing:
	(- save_debug_rules = debug_rules; debug_rules = 0; -).

To re-enable rule-tracing:
	(- debug_rules = save_debug_rules; -).


Extended Debugging ends here.


---- DOCUMENTATION ----

Extended Debugging is a very simple extension that provides for an alternative means of controlling code that is not for release. It is intended as a workaround for Inform's inability to "release" (that is, save for distribution or testing outside the IDE) a blorbed debugging build. 

Extended Debugging also includes I7 wrappers that allow the author to turn Inform's standard rule-tracing debug commands on and off from the source code, rather than entering "rules on/all/off" at the command prompt. This is intended primarily to allow for the debugging of rules that run before the first command prompt appears; these are impossible to debug using Inform's default setup. Also included is the ability to ensure that a rule is displayed when rule-tracing is on, since Inform does not always report all rules. Finally, we can set text to be printed only when the extension is installed.

Extended Debugging is compatible with both the Z-machine and with Glulx.


Section: Basic Usage 

Simply including Extended Debugging in a project will enable Inform's built-in debugging commands in a released file. Note that we should use the standard Release option in the IDE, not the Save Debug Build option; the latter does not include multimedia resources. 

If we also want our own debugging code/commands to be available in the released file, we need to go one step further. Rather than marking sections that contain debugging code as "(not for release)", we mark them as follows:

	(for use with Extended Debugging by Erik Temple)

If we place the directive to include Extended Debugging in its own section:

	Section - Extended Debugging

	Include Extended Debugging by Erik Temple.

we can then mark just this section as "not for release," and released builds will then be free of both the built-in debugging commands as well as our own:

	Section - Extended Debugging (not for release)

	Include Extended Debugging by Erik Temple.


Section: Additional Rules Tracing Functionality

Inform's built-in debugging commands "rules on/all/off", "actions", and "scenes" are quite useful, but since they must be entered at the command prompt, they cannot be used to trace events that fire before the first command prompt appears. Especially in multimedia games, where we may want to track the setup of windows or other elements, this can be inconvenient.

Extended Debugging provides a number of phrases that can be used to issue the debug tracing commands from our source code rather than from the command prompt:

	Turn on actions-tracing
	Turn off actions-tracing
	Turn on brief rule-tracing
	Turn on intensive rule-tracing
	Turn off rule-tracing
	Turn on scenes-tracing
	Turn off scenes-tracing

Brief rule-tracing corresponds to the command "rules on" and prints only the rules that apply. Intensive rule tracing refers to "rules all" and prints all rules considered, whether they were followed or not. It is probably best to use these phrases within a section that can be marked as "for use with Extended Debugging" so that they are easily turned off; that is, so that we need not manually delete them from the source once we wish to release a build without them.

We can also suspend and then reinstate rules-tracing  (code via Ron Newcomb):

	Suspend rule-tracing;
	Reinstate rule-tracing;

When we suspend rule-tracing, the game saves the level of rule-tracing we were at (brief or intensive) and restores that when we use the reinstate rule-tracing command. Otherwise, the options are not distinct from the options to turn rules-tracing on and off.


Section: Custom rule-tracing callout (code courtesy of Ron Newcomb)

In some situations, Inform does not announce certain rules during rule-tracing. To force Inform to notice a rule during rule-tracing, use one of the following phrases:

	Enable rule-tracing for my recalcitrant rule
	Enable intensive rule-tracing only for my recalcitrant rule

Usage example:

	This is the custom reporting rule:
		enable rule-tracing for the custom reporting rule;
		....


Section: Summary use options

In the interest of such easy compartmentalization, Extended Debugging provides two use mutually exclusive use options that turn on Inform's debug tracing during the "before starting the virtual machine" activity so that actions tracing, scene tracing, and rules tracing can all be initiated before any windows are opened. These options are:

	Use initial brief debug tracing
	Use initial intensive debug tracing

The former starts the game with brief rule-tracing on, while the latter uses intensive rule-tracing (as defined above). These options are mutually exclusive, but if you happen to define both accidentally, the extension will use the intensive option. Example of use:

	Section - Debugging Control

	Include Extended Debugging by Erik Temple.
	Use initial intensive debug tracing.

Placing these directives in the same section allows all functionality provided by the extension to be turned off by simply marking the section as "(not for release)". 


Chapter: Version history

Version 2 (30 May 2010): Name changed to Extended Debugging. Added the ability to control the glk list debugging command, and custom rule-tracing reporting (thanks to Ron Newcomb for the latter!) 

Version 1 (22 June 2009): Initial public release (as Permanent Debugging)







