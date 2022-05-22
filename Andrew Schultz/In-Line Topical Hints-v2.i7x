Version 2.3 of In-Line Topical Hints by Andrew Schultz begins here.

"Lets the author offer the player in-line hints, with options for presentation. This extension requires Inform 6M62 or higher to run."

Include Basic Screen Effects by Emily Short.

Part 1 - definitions and globals

chapter defining a hint-topic

a hint-topic is a kind of object.

[hint topics should always be given a printed name.]

a hint-topic can be active, inactive or rule-dependent. a hint-topic is usually inactive.

a hint-topic can be unfinished, paged-through or all-seen. a hint-topic is usually unfinished.

a hint-topic has a rule called the avail-rule. avail-rule of a hint-topic is usually the never-hint rule.

a hint-topic has a table-name called the hint-list.

a hint-topic has a number called table-row.

a hint-topic has a number called reference-number.

a hint-topic can be critical or noncritical. a hint-topic is usually critical.

section hint styles

hint-style is a kind of value. the hint-styles are all-hint, flex-hint, and one-hint. [The three styles work as follows: all-hint shows all previous hints in a topic, all the time, when the player types H. One-hint shows only the most recent hint topic. Flex-hint is a combination of the two: it will show the most recent hint if the player asked for a hint the turn before, but it will show them all otherwise. The player can switch among these styles, but flexible hinting is recommended as a default and is set below.

The author may change this with a "when play begins" rule. For instance, if they have relatively small hint topics, then all-hint is reasonable, or if they want to use very minimal text space, one-hint is reasonable, though it would be polite to notify the player of the HA command.]

current-hint-style is a hint-style that varies. current-hint-style is usually flex-hint.

temp-hint-style is a hint-style that varies. temp-hint-style is usually flex-hint. [this variable should not be changed! It is used with HL and HA, which are commands that give the player the last hint and all hints in a topic, respectively, for one turn only, hence the "temp" prefix.]

chapter stubs

to say h-bold:
	say "[bold type]H[roman type]";

to say ha-b:
	say "[bold type]HA[roman type]";

to say hl-b:
	say "[bold type]HL[roman type]";

to say hi-b:
	say "[bold type]HINT[roman type]";

to say hu-b:
	say "[bold type]HINT USAGE[roman type]";

to say hb-b:
	say "[bold type]HINT BLOCK[roman type]";

To skip upcoming rulebook break: (- say__pc = say__pc | PARA_NORULEBOOKBREAKS; -).

this is the always-hint rule:
	the rule succeeds;

this is the never-hint rule:
	the rule fails;

definition: a hint-topic (called ht) is available:
	if hint-crit-only is true and ht is noncritical, decide no;
	if ht is active, decide yes;
	if ht is inactive, decide no;
	if ht is rule-dependent:
		skip upcoming rulebook break;
		follow the avail-rule of ht;
		if the rule succeeded, decide yes;
		decide no;

to activate (ht - a hint-topic):
	now ht is active;

to deactivate (ht - a hint-topic):
	now ht is inactive;

section debugging stubs

[these can't quite go in part 6, because we need some way to determine if hint debug is turned on, and there are debug-print commands in some major functions. Hint-debug should never be altered except in not-for-release sections.]

to debug-say (x - text):
	if hint-debug is true:
		say "[x][line break]";

hint-debug is a truth state that varies.

chapter globals

hint-block is a truth state that varies.

hint-local-block is a truth state that varies.

hint-crit-only is a truth state that varies. [The default is false, which means we print all hint topics, even non-critical ones. However, it is okay to change this. It can be changed with HINT CRIT.]

in-hint is a truth state that varies.

null-topic is a hint-topic. null-topic is inactive. [this is so that last-topic-hinted does not point to the first hint topic the programmer describes. That would cause bugs.] printed name is "the null topic".

section Variables the Programmer can Change

hint-topic-end-note is a truth state that varies. [This toggles whether or not we give the player a note when they hit the end. While the (8/8) clues are adequate, it can be useful if the player forgets.]

mention-critical-hints is a truth state that varies. [This has no effect on which hint topics are displayed. It merely determines whether HINT VERBOSE prompts the player to try HINT CRIT. It's potentially fiddly, but it can be set to true when
1. there are optional hint-topics
2. the author wants to make sure the player knows they can shut hints off
It should be left false if there are no optional hint-topics, because then HINT CRIT has no effect.
You can either disable the rule below or force mention-critical-hints to false in your main program if you want to. However, it is probably polite to let the player know about non-critical hints if you use them.
]

when play begins (this is the mention existing noncritical hints in verbose hinting rule):
	if number of noncritical hint-topics > 0:
		now mention-critical-hints is true;
	continue the action;

hide-auto is a truth state that varies. hide-auto is usually false. [This is another fine-tuning boolean that toggles HINT VERBOSE behavior. It determines whether the user sees the "HINT AUTO" documentation and should probably be set to false in most cases. However, if the programmer is confident there will be more than one hint topic at all times, then it can be set to true. If activated, it gives a warning that HINT AUTO is likely useless, since auto-hinting can occur when there is only one topic available.]

confirm-hint-block is a truth state that varies. confirm-hint-block is usually true; [this has the player confirm HINT BLOCK for a session. It's polite to keep it true, though the player can still undo.]

Part 2 - hinting

chapter displaying hint topics

hinting is an action out of world.

understand the commands "hint" and "hints" and "topics" and "topic" as something new.

understand "hint" and "hints" and "topics" and "topic" as hinting.

init-hint is a truth state that varies.

hint-auto is a truth state that varies.

hint-auto-warn is a truth state that varies.

understand "topics [text]" as a mistake ("[if hint-block is true][all-blocked][else if hint-local-block is true][temp-blocked][else]To choose a hint topic, type [bold type]TOPIC #[roman type]. For available hint topics, type [hi-b]. For usage, type [hu-b][end if].")

to say hint-block-total:
	say "Hints are now completely blocked for this session. However, after you restore any saved game, [bold type]HINT ON[roman type] will recover them";

to decide whether (nu - a number) is irrelevant:
	if nu is 66 or nu is 98, decide no;
	if nu is 78 or nu is 110, decide no;
	if nu is 89 or nu is 121, decide no;
	decide yes;

carry out hinting (this is the top level hint request rule) :
	let cholet be 0;
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	if init-hint is false:
		say "Using [hi-b] can be tempting and ruin a puzzle. So this is a one-time nag[if last-topic-hinted is not null-topic], though you've used [h-bold] on the only available topic[end if].[paragraph break]Type Y to continue to the hint topics, N to return to play, or B to block hints for this session. >";
		now init-hint is true;
		now cholet is the chosen letter;
		while cholet is irrelevant:
			say "[line break]Y for the hint topics, N to decline, or B to block hints fully. >";
			now cholet is the chosen letter;
		if cholet is 66 or cholet is 98:
			say "[hint-block-total].";
			now hint-block is true instead;
		if cholet is 78 or cholet is 110:
			say "[paragraph break]OK. You can turn hints temporarily off with [bold type]HINT OFF[roman type] or block them for this session with [hb-b], and [hu-b] gives options." instead;
		say "[paragraph break]";
	let naht be number of available hint-topics;
	if naht is 0:
		say "There are no hint topics available right now." instead;
	now topics-sorted-yet is true;
	if naht is 1:
		let raht be a random available hint-topic;
		now reference-number of raht is 1;
		if hint-auto is true:
			if hint-auto-warn is false:
				say "Since there is only one hint topic, and automatic hints are on, you will get the first hint from the topic.";
				now hint-auto-warn is true;
				say "[raht].";
			try expounding raht instead;
		if hint-auto-warn is false:
			say "Currently, there is only one hint topic, so if you type [h-bold], you will see the next hint.";
			now hint-auto-warn is true;
	else:
		say "Type a number to choose a topic[if last-topic-hinted is available], [h-bold] to show the next hint in the active topic[else if naht is 1], [h-bold] to look at the only topic available[end if], or [hu-b] for other hint commands:[line break]";
	let count be 0;
	repeat with HT running through hint-topics:
		if HT is not available:
			now reference-number of HT is 0;
		else:
			increment count;
			now reference-number of HT is count;
			say "[if naht > 1][count]) [else]* [end if][ht] ([table-row of ht] of [number of rows in hint-list of ht] hints seen[if last-topic-hinted is HT], current active topic[end if])[line break]";

chapter hint blocking

hintblocking is an action out of world.

understand "hint block" as hintblocking.

carry out hintblocking (this is the block hints but verify first rule):
	if hint-block is true:
		say "Hints are already blocked. You will need to restore a saved game or restart to undo this." instead;
	if confirm-hint-block is true:
		say "Blocking hints can be a drastic step. For instance, if undo is disabled, you'll need to restore a saved game. Would you like to confirm hint blocking?";
		if the player consents:
			say "[hint-block-total].";
			now hint-block is true;
		else:
			say "OK.";
	else:
		say "Hints are now blocked until you restore.";
		now hint-block is true;
	the rule succeeds;

chapter turning hints on

turning hints on is an action out of world.

understand "hint on" as turning hints on.
understand "hints on" as turning hints on.

carry out turning hints on (this is the turn hints on rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is false:
		say "Hints are already on." instead;
	now hint-local-block is false;
	say "Hints are now on. You can turn them off with [bold type]HINT OFF[roman type].";
	the rule succeeds;

chapter turning hints off

turning hints off is an action out of world.

understand "hint off" as turning hints off.
understand "hints off" as turning hints off.

carry out turning hints off (this is the turn hints off rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "Hints are already off." instead;
	now hint-local-block is true;
	say "Hints are now off, but not permanently blocked. You can restore them with [bold type]HINT ON[roman type].";
	the rule succeeds;

Part 3 - topics and expounding

accessing hint topics by number is an action out of world applying to one number.

understand the command "t" as something new.

understand "t" as a mistake ("[if hint-block is true][all-blocked][else if hint-local-block is true][temp-blocked][else][bold type]T[roman type] alone doesn't work. You need to give a number. If you wish to access the topic's next hint, you can just type H[end if].")

understand "t [text]" and "topic [text]" as a mistake ("[if hint-block is true][all-blocked][else if hint-local-block is true][temp-blocked][else]You can only use a number when accessing a topic. So TOPIC 2, T 2 and even T2 work, but TOPIC TWO does not[end if].").

understand "t [number]" and "topic [number]" and "topics [number]" as accessing hint topics by number.

after reading a command (this is the avoid odd errors but allow numbers rule):
	if the player's command matches the regular expression "^<0-9>":
		let XX be indexed text;
		let XX be the player's command in lower case;
		change the text of the player's command to "t [xx]";
	continue the action;

after reading a command (this is the zap out of world actions for in-hint rule) :
	unless the player's command matches the regular expression "^(h|ha|hl)\b":
		now in-hint is false; [this may not be perfect; if HINT goes to [h-bold], then we have an odd test case. ??]
	continue the action;

topics-sorted-yet is a truth state that varies.

last-topic-hinted is a hint-topic that varies.

carry out accessing hint topics by number (this is the check for topic rule) :
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	if topics-sorted-yet is false:
		say "You can't choose a hint topic until you've accessed the list of topics. Type [hi-b] to see the available hint topics." instead;
	let naht be number of available hint-topics;
	if number understood < 1 or number understood > naht:
		if naht is 1:
			say "There's only one hint topic available." instead;
		say "You need a number from 1 to [naht]." instead;
	repeat with Q running through hint-topics:
		if reference-number of Q is number understood:
			try expounding Q instead;
	say "There should be something with that number, but there isn't." instead;

expounding is an action out of world applying to one visible thing.

definition: a hint-topic (called my-top) is repeat-viewed: [this is so a paged-through hint topic can be printed all the way through without "you saw this before."]
	if table-row of my-top is 1, decide no;
	if my-top is unfinished, decide no;
	if my-top is all-seen, decide yes;
	if my-top is paged-through and temp-hint-style is all-hint, decide yes; [the first statement should be trivially true, since it's the only state of three remaining, but just for posterity, if we add another state]
	if my-top is paged-through and current-hint-style is all-hint, decide yes; [the first statement should be trivially true, since it's the only state of three remaining, but just for posterity, if we add another state]
	decide no;

to decide whether show-all-hints:
	if temp-hint-style is all-hint, decide yes;
	if temp-hint-style is one-hint, decide no; [temp-hint-style is very local and thus trumps current-hint-style]
	if current-hint-style is all-hint, decide yes;
	if current-hint-style is one-hint, decide no;
	if current-hint-style is flex-hint and in-hint is true, decide no; [in other words, you've been going through hints, so you will only see the last one]
	decide yes. [the final case is flex-hint current style and in-hint is false]

carry out expounding (this is the look for topic's next available hint rule) :
	if noun is not a hint-topic:
		say "Oops! You should not be expounding a non-hint-topic." instead;
	if noun is not available:
		say "The hint topic '[noun]' is not available. You've likely solved everything. You may wish to [hi-b] for a new list of topics, instead." instead;
	if in-hint is false:
		say "[bold type][noun][if noun is not unfinished] (all hints shown)[end if][roman type][line break]";
	else if noun is repeat-viewed and noun is not last-topic-hinted:
		say "[italic type][bracket]NOTE: you requested a hint topic you've already gone through[still-stuck].[close bracket][roman type][line break]";
	if table-row of noun < number of rows in hint-list of noun:
		increment table-row of noun;
	let numrows be number of rows in hint-list of noun;
	debug-say "current-hint-style [current-hint-style].";
	debug-say "temp-hint-style [temp-hint-style].";
	debug-say "in-hint [in-hint].";
	if show-all-hints:
		repeat with Q running from 1 to table-row of noun:
			choose row Q in hint-list of noun;
			if there is a show-rule entry:
				skip upcoming rulebook break;
				follow the show-rule entry;
				if the rule succeeded:
					say "[head-num of Q and numrows][hint-text entry][if q is numrows][else if q is 1 and table-row of noun is 1] (H for next hint)[else if in-hint is false and q is table-row of noun] (H for next hint)[end if][line break]";
			else:
				say "[head-num of Q and numrows][hint-text entry][if q is numrows][else if q is 1 and table-row of noun is 1] (H for next hint)[else if in-hint is false and q is table-row of noun] (H for next hint)[end if][line break]";
	else:
		choose row table-row of noun in hint-list of noun;
		if there is a show-rule entry:
			skip upcoming rulebook break;
			follow the show-rule entry;
			if the rule succeeded:
				say "[head-num of table-row of noun and numrows][hint-text entry][if table-row of noun is numrows][else if table-row of noun is 1 or in-hint is false] (H for next hint)[end if][line break]";
			else if table-row of noun is less than numrows:
				try expounding the noun instead;	[try skipping to the next hint]
		else:
			say "[head-num of table-row of noun and numrows][hint-text entry][if table-row of noun is numrows][else if table-row of noun is 1 or in-hint is false] (H for next hint)[end if][line break]";
	now in-hint is true;
	now last-topic-hinted is noun;
	if table-row of noun is numrows:
		if noun is unfinished:
			if show-all-hints:
				now noun is all-seen;
			else:
				now noun is paged-through;
			if hint-topic-end-note is true:
				say "[bracket]NOTE: [if numrows is 1]this was the only hint in the list[else if numrows is 0]this hint list is empty, which is probably a bug[else]these are all the hints in this topic[end if][still-stuck].[close bracket][line break]";

to say still-stuck:
	if not show-all-hints or number of available hint-topics > 1:
		say ". If you'd like to look around more, [unless show-all-hints]HA will show all this topic's hints[end if]";
		if not show-all-hints and number of available hint-topics > 1:
			say ", and ";
		if number of available hint-topics > 1:
			say "HINT will show other topics";

seeing the next hint is an action out of world.

understand the command "h" as something new.

understand "h" as seeing the next hint.

to say try-hint-instead:
	say "The last hint topic you tried is no longer available, so let's try to list the available topics, instead";

to say ok-use-hint:
	say "OK. Use [hi-b] to see a list of hint topics"

carry out seeing the next hint (this is the show next hint rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	if number of available hint-topics is 0:
		say "No topics are available for hinting right now, so [h-bold] doesn't work." instead;
	if last-topic-hinted is null-topic:
		if topics-sorted-yet is false:
			if number of available hint-topics > 1:
				say "[h-bold] is for paging through a hint topic, but you haven't seen a list, yet. Do you wish to?";
				if the player consents:
					try hinting instead;
				else:
					say "[ok-use-hint]." instead;
			if number of available hint-topics is 1:
				say "You haven't chosen a hint topic with [hi-b] yet, but there is only one. Would you like to see it?";
				if the player consents:
					try expounding a random available hint-topic instead;
				else:
					say "[ok-use-hint]." instead;
		if number of available hint-topics is 1:
			try expounding a random available hint-topic instead; [this is a problem if last-topic-hinted is nothing]
		say "You haven't chosen a hint topic yet, so [h-bold] can't process through one." instead;
	if last-topic-hinted is not available:
		say "[try-hint-instead].";
		try hinting instead;
	if number of available hint-topics is 1:
		try expounding a random available hint-topic instead; [this is a problem if last-topic-hinted is nothing]
	try expounding last-topic-hinted;
	now in-hint is true instead;

section temporarily showing all hints

temporarily showing all hints is an action out of world.

understand the command "ha" as something new.

understand "ha" as temporarily showing all hints.

carry out temporarily showing all hints (this is the show all hints in a topic once rule) :
	follow the check if hints are viable rule;
	now temp-hint-style is all-hint;
	follow the show hints differently just once rule;
	the rule succeeds;

section temporarily showing one hint

temporarily showing one hint is an action out of world.

understand the command "hl" as something new.

understand "hl" as temporarily showing one hint.

carry out temporarily showing one hint (this is the show one hint in a topic once rule) :
	follow the check if hints are viable rule;
	now temp-hint-style is one-hint;
	follow the show hints differently just once rule;
	the rule succeeds;

section hl and ha stubs

to say no-topic-yet:
	say "Since you haven't looked up a topic yet, let's try to look for a list of topics, instead";

this is the show hints differently just once rule:
	try expounding last-topic-hinted;
	now temp-hint-style is current-hint-style; [go back to flexible hinting]
	now in-hint is true;
	the rule succeeds;

this is the check if hints are viable rule:
	if hint-block is true:
		say "[all-blocked].";
		the rule fails;
	if hint-local-block is true:
		say "[temp-blocked].";
		the rule fails;
	if last-topic-hinted is null-topic:
		say "[no-topic-yet].";
		the rule fails;
	if last-topic-hinted is not available:
		say "[try-hint-instead].";
		try hinting instead;
		the rule fails;
	if last-topic-hinted is nothing:
		say "You need to request a hint before looking into a hint topic.";
		the rule fails;
	else:
		the rule succeeds;
	the rule fails;
	the rule succeeds;

section flexibly hinting

flexibly hinting is an action out of world.

understand "hint flexible/flex/f" as flexibly hinting.

carry out flexibly hinting (this is the see flexible hints in a topic rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	say "[if current-hint-style is flex-hint]You're already using[else]You're now using[end if] flexible hints. When [h-bold] is used twice in a row, you see only the new hint. Otherwise, you see all previous hints as well.";
	now current-hint-style is flex-hint;

section forcing all hints

forcing all hints is an action out of world.

understand "hint all/review" as forcing all hints.

carry out forcing all hints (this is the see all hints in a topic rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	say "[if current-hint-style is all-hint][h-bold] already shows[else]Now [h-bold] will always show[end if] all previous hints in a hint topic, in addition to the new hint.";
	now current-hint-style is all-hint;

section forcing one hint

understand "hint one/latest" as forcing one hint.

forcing one hint is an action out of world.

carry out forcing one hint (this is the see one hint at a time rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	say "[if current-hint-style is one-hint][h-bold] already shows[else]Now [h-bold] will always show[end if] only the next hint in a topic.";
	now current-hint-style is one-hint;

chapter jumping to sole available topic

jumping to sole available topic is an action out of world.

understand the command "hintauto" as something new.

understand "hint auto" as jumping to sole available topic.

carry out jumping to sole available topic (this is the automatic hints rule) :
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	now hint-auto is whether or not hint-auto is false;
	if hide-auto is true:
		say "Auto-hinting turned [if hint-auto is true]on[else]off[end if]--although the author has noted there will never be only one hint topic, so this command is not useful.";
	else:
		say "Auto-hinting turned [if hint-auto is true]on[else]off[end if]--if there's only one topic, you [if hint-auto is true]won't[else]will[end if] need to type [h-bold] to see the first hint.";
	the rule succeeds;

chapter toggling critical hints

toggling critical hints is an action out of world.

understand "hint crit" as toggling critical hints.

carry out toggling critical hints (this is the toggle critical hints rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	if hint-crit-only is true:
		now hint-crit-only is false;
	else:
		now hint-crit-only is true;
	say "[if number of noncritical hint-topics is 0]There aren't currently any noncritical hints, but when available, they[else]Noncritical hints[end if] will now be [if hint-crit-only is true]hidden[else]shown[end if].";
	the rule succeeds;

chapter displaying verbose hint options

displaying verbose hint options is an action out of world.

understand "hint verbose" and "hint v" as displaying verbose hint options.

to eq-say (eqtxt - text):
	say "[line break][italic type][eqtxt][roman type][line break]";

carry out displaying verbose hint options (this is the display verbose hint help rule):
	if hint-block is true:
		say "[all-blocked]." instead;
	if hint-local-block is true:
		say "[temp-blocked]." instead;
	eq-say "BASIC USAGE";
	say "  [hi-b] gives a list of hint topics.";
	say "  Typing a [bold type]number[roman type] (or [bold type]TOPIC #[roman type]/[bold type]T #[roman type]/[bold type]T#[roman type]) chooses a topic to peruse. Then [h-bold] reveals the next hint. Depending on your settings, [h-bold] may show the previous hints, too. Currently you [if current-hint-style is all-hint]always [else if current-hint-style is one-hint]don't [end if]see them[if current-hint-style is flex-hint] sometimes[end if]. [hi-b] can also take arguments, as listed below.";
	eq-say "ADJUSTING WHICH HINTS ARE SEEN";
	say "  [bold type]HINT FLEXIBLE[roman type]/[bold type]FLEX[roman type]/[bold type]F[roman type] makes [h-bold] show all the revealed hints in a topic unless you type [h-bold] two times in a row. This is the default, and it is recommended. [if current-hint-style is flex-hint](current setting)[end if][line break]";
	say "  [bold type]HINT ALL[roman type]/[bold type]REVIEW[roman type] makes [h-bold] show the next available hint in a topic as well as all previous ones. [if current-hint-style is all-hint](current setting)[end if][line break]";
	say "  [bold type]HINT ONE[roman type]/[bold type]LATEST[roman type] makes [h-bold] show only the next available hint in a topic. [if current-hint-style is one-hint] (current setting)[end if][line break]";
	say "  As alternatives to [h-bold], [ha-b] and [hl-b] override the options above. [hl-b] only shows the next hint, but [ha-b] shows all previous hints in the topic before the next hint.";
	if hide-auto is false:
		say "  [bold type]HINT AUTO[roman type] toggles behavior when you type [hi-b] and there's only one hint topic. Currently the game [unless hint-auto is true]does not expose[else]exposes[end if] the first hint without you typing [h-bold].";
	eq-say "AVOIDING SPOILERS";
	say "  [hb-b] blocks hints for the remainder of the session[if hint-block is true]. This is currently ON, so the options below won't mean much[end if].";
	say "  [bold type]HINT OFF[roman type] is a more temporary form of hint-blocking. It disables hints until you type [bold type]HINT ON[roman type]. Currently hints are [if hint-local-block is true]disabled[else]available[end if].";
	if number of noncritical hint-topics > 0:
		eq-say "SEEING ALL CLUES";
		say "  [bold type]HINT CRIT[roman type] toggles whether you see only critical topics, or you see them all (including side quests). Currently you see [if hint-crit-only is true]only critical hints[else]all hints[end if].";
	else if mention-critical-hints is true:
		eq-say "SEEING ALL CLUES";
		say "  [bold type]HINT CRIT[roman type], while part of In-Line Topical Hints, is not useful, since this game contains no side-quest hints. Otherwise, it would toggle whether you saw all hint topics (including side quests) or only critical ones.";
	say "[line break]In-Line Topical Hints is in Beta, so usage documentation and hint mechanics may have mistakes. This is likely the fault of the extension author (Andrew Schultz) and not the game author. Suggestions and bugs are welcomed. You can report issues at https://bitbucket.org/andrewschultz/in-line-topical-hints/ (no need to register) or email Andrew Schultz at blurglecruncheon@gmail.com.";
	the rule succeeds;

Part 4 - hint formatting

to say slashof:
  say "[if slash-not-of is true]/[else] of [end if]";

to say head-num of (a - a number) and (b - a number):
  say "[if hint-punc is paren]([else if hint-punc is brackets][bracket][end if]";
  say "[a][slashof][b]";
  say "[if hint-punc is paren]) [else if hint-punc is brackets][close bracket] [else if hint-punc is period-end]. [else if hint-punc is colon-end]: [end if]";

a num-punc is a kind of thing. num-punc can be paren, brackets, period-end or colon-end. a num-punc is usually paren.

section Variables the Programmer can Change

hint-punc is a num-punc. hint-punc is brackets. [this can be changed to any of the four above]

slash-not-of is a truth state that varies. slash-not-of is usually false. [these two lines make the default (1/2). You can change this with a when play begins rule.]

Part 5 - stubs

to say all-blocked:
	say "Hints are completely blocked for this session, along with hint operations. You will need to restore a saved game, or restart, to recover them";

to say temp-blocked:
	say "Hints are turned off currently, so you'll need to type [bold type]HINT ON[roman type] for this to have effect";

after reading a command (this is the t1 to t 1 rule) :
	let XX be indexed text;
	let XX be the player's command;
	if XX matches the regular expression "^t<0-9>", case insensitively:
		replace the regular expression "^(t)(.*)" in XX with "\1 \2";
		change the text of the player's command to XX;
	if XX matches the regular expression " $":
		replace the regular expression " *$" in XX with "";
		change the text of the player's command to XX;

understand "hint [text]" as a mistake ("[if hint-block is true][all-blocked][else][hint-usage][end if].").

The restore the game rule response (B) is "[if hint-block is true]You had hints blocked completely in your previous session, but now they are temporarily turned off instead. You can type HINT ON to reactivate them[true-it].[else][end if]"

to say true-it:
	now hint-local-block is true;
	now hint-block is false;

to say hint-usage:
	say "Below is basic usage for hint-related commands. Type [bold type]HINT VERBOSE[roman type] for the full list, which includes shortcuts and current settings.";
	say "[hi-b] gives the list of currently available hint topics, which may change as you complete certain tasks.";
	say "Once you have a list of hints, a [bold type]number[roman type] (or [bold type]T #[roman type] or [bold type]TOPIC #[roman type]) chooses a topic number. Then [h-bold] reveals the topic's next hint[if current-hint-style is flex-hint]. Currently hinting is flexible, so you will not see previous hints if you repeat [h-bold][else if current-hint-style is all-hint]. Currently you'll always see the whole topic with [h-bold][else]. Currently you'll only see the latest hint with [h-bold][end if].";
	say "[bold type]HINT OFF[roman type] switches hints off for the moment, in case you don't want to be tempted too easily. [bold type]HINT ON[roman type] turns them back on.";
	say "[hb-b] blocks [hi-b] functionality for the remainder of the session. It trumps the commands above until you restore a saved game, which reverts play to [bold type]HINT OFF[roman type] behavior";

understand "#" as a mistake ("The hint instructions saying # mean an actual number[one of]. Sorry for any confusion[or][stopping].")

table of hints you should ignore
hint-text	done-yet	show-rule
""	false	a rule

when play begins (this is the last topic is null topic to start rule):
	now last-topic-hinted is null-topic;

every turn (this is the check if we're in hints rule):
	debug-say "check in hints before: [in-hint].";
	if current action is temporarily showing all hints or current action is seeing the next hint or current action is accessing hint topics by number or current action is hinting:
		do nothing;
	else:
		now in-hint is false;

Part 6  - debugging - not for release

section toggling in-game hint debugging

toggling in-game hint debugging is an action out of world.

understand the command "hintdebug" as something new.

understand "hintdebug" as toggling in-game hint debugging.

carry out toggling in-game hint debugging (this is the hint debugging for programmers rule):
	now hint-debug is whether or not hint-debug is false;
	say "Now hint debugging every turn is [if hint-debug is true]on[else]off[end if].";
	the rule succeeds;

every turn when hint-debug is true (this is the list topics every turn rule) : [you may wish to change the text here to make it more useer friendly.]
	say "[bold type]START TOPIC DEBUG DUMP[roman type].[line break]Currently available hint topics: [list of available hint-topics in brace notation]. [if last-topic-hinted is not null-topic]Last topic hinted = [last-topic-hinted][else]No topic hinted yet[end if].[line break][bold type]END TOPIC DEBUG DUMP[roman type].";

section showing all active full hint topics

fully showing all active hint topics is an action out of world.

understand the command "taa" as something new.

understand "taa" as fully showing all active hint topics.

carry out fully showing all active hint topics (this is the fully show all active topics rule):
	let curtop be 0;
	let alltop be the number of available hint-topics;
	repeat with my-topic running through all available hint-topics:
		increment curtop;
		say "[curtop] of [alltop]:[my-topic]:[line break]";
		try fully revealing my-topic;
		if curtop < alltop:
			follow the continue-listing rule;
			if the rule failed:
				the rule succeeds;

this is the continue-listing rule:
	say "Q to exit or any key to continue>";
	let thiskey be the chosen letter;
	if thiskey is 80 or thiskey is 112:
		the rule succeeds;
	say "[line break]";

section showing all full hint topics

fully showing all hint topics is an action out of world.

understand the command "ta" as something new.

understand "ta" as fully showing all hint topics.

definition: a hint-topic (called ht) is meaningful:
	if ht is null-topic, decide no;
	decide yes;

carry out fully showing all hint topics (this is the fully show all topics rule):
	let curtop be 0;
	let alltop be the number of meaningful hint-topics;
	repeat with my-topic running through all meaningful hint-topics:
		increment curtop;
		say "[curtop] of [alltop]:[my-topic] ([unless my-topic is available]un[end if]available) :[line break]";
		try fully revealing my-topic;
		if curtop < alltop:
			follow the continue-listing rule;
			if the rule failed:
				the rule succeeds;

section showing one full hint topic

[!! not documented yet]

showing one full hint topic is an action out of world applying to one number.

understand the command "tx" as something new.

understand "tx [number]" as showing one full hint topic.

carry out showing one full hint topic (this is the debug a full hint topic rule) :
	let naht be number of available hint-topics;
	if number understood < 1 or number understood > naht:
		if naht is 1:
			say "There's only one hint topic available." instead;
		say "You need a number from 1 to [naht]." instead;
	repeat with Q running through hint-topics:
		if reference-number of Q is number understood:
			try fully revealing Q;

fully revealing is an action out of world applying to one visible thing.

carry out fully revealing:
	let Z be the hint-list of noun;
	repeat through Z:
		if there is a show-rule entry:
			follow the show-rule entry;
			if the rule failed:
				say "[italic type]****NOT SHOWN: [roman type]";
		say "[hint-text entry][line break]";

section showing every hint name

[this is a simple debug command so the programmer can make sure their hint names make sense, don't clash, etc.]

showing every hint name is an action out of world.

understand the command "allhintnames" as something new.

understand "allhintnames" as showing every hint name.

carry out showing every hint name:
	say "You have [number of meaningful hint-topics] total hints. Here are their names.";
	repeat with xxx running through meaningful hint-topics:
		say "[xxx][line break]";
	the rule succeeds;

section resetting hint topics

resetting hint topics is an action out of world.

understand the command "hintreset" as something new.

understand "hintreset" as resetting hint topics.

carry out resetting hint topics:
	repeat with QQ running through hint-topics:
		now table-row of QQ is 0;
		now QQ is unfinished;
	the rule succeeds;

Part 7 - Recording testers' potential hints (for glulx only)

chapter debug tests - not for release

[The programmer may want to see what hint topics a player's run-through would give every turn, just to make sure nothing goes wrong. The problem with this is that 1) it would spoil puzzles for the tester and 2) it would take up a lot of space in a transcript. So the solution is to pipe the text to a transcript every turn.]

record-hints is a truth state that varies.

the file of potential hint topics is called "hinttopics".

every turn when record-hints is true (this is the dump hint topics to file rule):
	append ">>[the player's command]: [list of available hint-topics in brace notation].[line break]" to the file of potential hint topics;

section toggling recording hints to file

toggling recording hints to file is an action out of world.

understand the command "recordhints" as something new.

understand "recordhints" as toggling recording hints to file.

carry out toggling recording hints to file (this is the hint record toggle rule):
	now record-hints is whether or not record-hints is false;
	say "Now recording hints is [if record-hints is true]on. Remember to search for hinttopics as a file. On the Mac, it won't have an extension. On Windows, it will have a GLKDATA extension[else]off[end if].";
	the rule succeeds;

hint-on-start is a truth state that varies. [this line can be changed to force hinting immediately so players don't forget]

when play begins (this is the note if recording hints was forced rule):
	if record-hints is true:
		say "The author has opted to force hints on to start. This should not happen in a release version. To turn them off, type RECORDHINTS.";
	continue the action;

In-Line Topical Hints ends here.

---- DOCUMENTATION ----

PURPOSE

In-Line Topical Hints is meant to circumnavigate hint menus, which can break immersion for the player. Also, it tries to keep unwieldy hint menus under control. While it offers progressive hinting, it also tries not to overwhelm the reader with text. The basic use case is that a player asks for hints and is given a list of potential topics. Then he types the topic number, and he can type H to see the next hint. By default, hints are shown one at a time if the player requests them continually, but if the player performs a few actions and comes back, the whole list is shown again. This is what the extension terms flexible hinting. The programmer can also force the default to showing all hints in a topic or only the last one, but the player can override these with special commands.

There are two ways for a programmer to decide whether to display a specific hint topics. You can either label it active to inactive, or you can make it rule-based and create a rule whether you can display them. If you are comfortable with rules, it may be smoother for you to establish a rule (e.g. if escape hatch is visited and typed-security-code is false).

One special case worth mentioning is if there is only one available hint topic. HINT AUTO lets the player toggle whether to skip to the hint in the topic or to avoid spoilers. The default is to avoid spoilers, but the programmer can change this by setting the hint-auto flag to true.

So if hint-auto is set to true, and a player tries hints, and there is only one available hint topic, the game chooses that. If not, the player is offered an option from one to the available number of hint topics. Whichever number they choose, they see the next hint they haven't seen yet. Once they choose that option, H goes to the next clue in the topic. It also, by default, only shows the next clue. The player can change this behavior if they want, but the point is to make the hints as unintrusive as possible.

One fine-tuning feature is that you are able to create a show-rule in a hint table. If this is left blank, the hint will always be shown. However, it can be changed to eliminate a hint the player should already know about. Let's take potential hints from a formerly popular RPG. While conditional text is possible, the player may appreciate having longer hint topics cut down as much as possible.

	"You still need the bell, book and candle before continuing. That hint topic should be available."	--	need-all-three rule [this hint only appears if you're missing one of the three items]
	"You still need a party of eight players for the journey through the abyss. That hint topic should be available."	--	need-all-eight rule [similarly, this only appears if your party is less than 8 people]
	"You still need the mystic weapons and mystic armor. That hint topic should be available."	--	need-weapons-and-armor rule [finally, a check to make sure # of equipped weapons/armor + # in pool each > 8]
	"[if have-everything]Okay, you're ready to enter the Abyss and get the Codex of Ultimate Wisdom[else]It's a long way down, and you'll be frustrated if you get to level 8 without auto-save and get rejected. Still, let's go ahead[end if]." [have-everything is checking the first three rules all fail. I'm eliminating the pseudocode because that gets nitpicky.]

Another fine-tuning feature is to label certain hints topics noncritical. If the player just wants to win the game, they may not want to be distracted by a side quest this time around. By default, no hint topics are noncritical, but adjusting the hint-crit-only flag (default false) can change the default behavior, which is showing all hints. HINT CRIT will let the player toggle this at any time.

Also, feel free to modify the hint-usage and HINT VERBOSE documentation. I'd be interested how it could be tweaked.

Second of all, there are things you may wish to change and variables you may wish to set in a When Play Begins rule. These variables are listed below. There doesn't seem to be much reason to change them afterwards.

DEFAULTS POTENTIALLY WORTH CHANGING

See "Section Variables the player can change" in the source for this.

DEBUGGING WHICH HINTS APPEAR WHEN

One of the big problems with a hint system is that your testers can't tell you what's being hinted, when. Or if they do, it sort of spoils the game.

Some basic debugging is provided with In-Line Topical Hints so that you are able to verify a test walkthrough works. HINTDEBUG is a not-for-release command that prints out all the topics available every move. This is probably more useful for the programmer than a player, who may get overwhelmed with the text.

RECORDHINTS is available for the tester if they wish to create a text file of topics they would've seen. It is Glulx-only, since it requires output to a file. The format is >>(command): (List of topics).

ALLHINTNAMES simply shows all the hint names, so you can see if there are any egregious duplicates, or if one sticks out as out-of-place.

CREDITS

I'd like to thank Alice Grove, who tested this extension for inclusion in Delphina's House, which you should play, even if you ignore the hinting. Her suggestions and bug reports (technical and aesthetic) helped me focus on the big picture and also reminded me of scattered features I'd written up for myself but never written out formally.

PREVIOUS VERSIONS

1/150214 was part of Delphina's House and featured basic debugging, HA/HL and the basic commands.
2/150418 added debugging exported to a file.
2/200530 includes small tweaks by Gavin Lambert to fix some code that didn't compile in 6M62; also changed the hint-topic to be a kind of object rather than a thing so that it cannot possibly be confused with in-world things.

EXAMPLE

Example: ** Fetch Quest - A minimal game with hints, rule-dependent and not

	*: "Fetch Quest" by Andrew Schultz

	the story headline is "a minimal example".

	there is no score in this story.

	the print final score rule is not listed in any rulebook.

	include In-Line Topical Hints by Andrew Schultz.

	the bronze coin is a thing.
	the silver coin is a thing.
	the gold coin is a thing.

	the description of a room is usually "[if number of viable directions is 1]The only exit leads[else]Exits lead[end if] [list of viable directions]."

	definition: a direction (called di) is viable:
		if the room di of the location of the player is nothing, decide no;
		decide yes;

	description of the player is "As good-looking as ever, but someone or something wrote something on you: N.GET ALL.S.E.GET ALL.W.W.GET ALL.E.S.".

	check dropping:
		say "No way! The coin is too valuable, or something." instead;

	Center Room is a room. "You can go north to the bronze room, east to the silver room, west to the gold room, or south to the glass room."

	Bronze Room is north of Center Room.

	check going nowhere:
		say "[if player is in center room]You can go any of the four directions[else]Only one way out[end if]."

	Silver Room is east of Center Room. "You can go back west."

	Gold Room is west of Center Room. "You can go back east."

	Glass Room is south of Center Room. "You can go back north."

	The bronze coin is in Bronze Room.

	when play begins:
		now hint-crit-only is true;
		activate bronzy;

	after taking the bronze coin:
		now the silver coin is in Silver Room;
		activate silvery; [you can deactivate bronzy here if you want, but I deliberately avoided this to show topic disambiguation]
		continue the action;
		
	after taking the silver coin:
		now the gold coin is in Gold Room;
		activate goldy; [you can deactivate silvery here if you want, but I deliberately avoided this to show topic disambiguation]
		continue the action;

	after going to Glass Room:
		if player has gold coin:
			end the story saying "YOU GOT ALL THE LOOT, AND YOU ESCAPED!";
		continue the action;

	bronzy is a hint-topic. printed name is "Finding the bronze coin".

	hint-list of bronzy is table of bronzy hints.

	table of bronzy hints
	hint-text	done-yet	show-rule
	"The bronze coin is not in the Center Room."	false	a rule
	"It's in the bronze room."
	"North of the Center Room."

	silvery is a hint-topic. printed name is "Finding the silver coin".

	hint-list of silvery is table of silvery hints.

	table of silvery hints
	hint-text	done-yet	show-rule
	"The silver coin is somewhere in the maze."	false	a rule
	"It's in the silver room."
	"The silver room is east of the Center Room."

	goldy is a hint-topic. printed name is "Finding the gold coin.".

	hint-list of goldy is table of goldy hints.

	table of goldy hints
	hint-text	done-yet	show-rule
	"The gold coin is somewhere in the maze."	false	a rule
	"It's in the Gold Room."
	"Gold Room is west of the Center Room."
	"Once you get the gold coin, you can get out of the maze back at the Glass Room, south of the Center Room."

	get-out is a rule-dependent hint-topic. printed name is "Getting out.".

	hint-list of get-out is table of get-out hints.

	table of get-out hints
	hint-text	done-yet	show-rule
	"There's one room left where nothing's turned up. Well, other than the center."	false	a rule
	"Go south from the center."

	avail-rule of get-out is the can-win rule.

	this is the can-win rule:
		if the player has the gold coin, the rule succeeds;
		the rule fails.

	is-this-easy is a noncritical active hint-topic.  hint-list is table of is-easy hints. printed name is "Isn't this example too easy for a real game?"

	table of is-easy hints
	hint-text	done-yet	show-rule
	"Yes, it is, but I was going for practicality."	false	a rule
	"It didn't make sense to get too fancy."
	"However, having good test cases is important, so here I'm making a semi-long hint topic to test that."
	"There is nothing of value from here on out."
	"I basically want a topic where I can test various behaviors in a long table, so I am sure nothing in my extension is broken."
	"One more random hint should do it."
	"There we go."

	volume testing - not for release

	test win with "n/get all/s/e/get all/w/w/get all/e/s"

	test hprod with "hintdebug/n/get all/hint/topic 1/x me/topic 1"

	test hintchange with "n/get all/s/hint/n/topic 1/topic 2"

	test block with "hint block/hint/hint all/h/t/topic/topic 1/t 1/t1/1/hint block/hint all/hint review/hint one/hint recent/hint on/hint off/"
	
	[end example]

Example: *** Gems - a small game with strictly rule-based hints

	*: "Gems" by Andrew

	include In-Line Topical Hints by Andrew Schultz.

	use scoring.

	the maximum score is 6.

	chapter define gems

	a gem is a kind of thing. a gem has a direction called open-dir. a gem has a direction called start-dir. a gem has an object called in-item.

	check dropping a gem:
		say "No. The gem is probably valuable[if score > 0]. Especially since you already did something with another gem[end if]." instead;

	chapter which gems

	chapter Branching Room

	a room can be gemmish. a room is usually gemmish.

	Branching Room is a not gemmish room.

	the gaudy hatch is a supporter in Branching room. "A gaudy hatch blocks the way south. It seems to be indented. You can go any other way from west clockwise to east."

	the blue hole is a container. the blue hole is part of the gaudy hatch.
	the green hole is a container. the green hole is part of the gaudy hatch.
	the white hole is a container. the white hole is part of the gaudy hatch.
	the red hole is a container. the red hole is part of the gaudy hatch.
	the yellow hole is a container. the yellow hole is part of the gaudy hatch.
	the black hole is a container. the black hole is part of the gaudy hatch.

	description of gaudy hatch is "The gaudy hatch has holes positioned in a half-circle: yellow[filled of yellow] on the left, then clockwise: blue[filled of blue], green[filled of green hole], red[filled of red hole], white[filled of white], and finally black[filled of black hole] below them all, opposite the red."

	to say filled of (c - a container):
		if number of things in c is 1:
			say " (filled by the [random thing in c])";

	chapter forest room

	Forest Room is northwest of Branching Room.

	chapter big sky room

	Big Sky Room is north of Branching Room.

	chapter lava room

	Lava Room is west of Branching Room.

	chapter snow room

	Snow Room is east of Branching Room.

	chapter sunlight room

	Sunlight Room is northeast of Branching Room.

	chapter going

	check going when player is in Branching Room:
		if the room noun of Branching Room is nowhere:
			say "You can go south, or any direction clockwise from west to east." instead;
		repeat with Q running through gems:
			if open-dir of Q is noun:
				if in-item of Q encloses Q:
					continue the action;
		say "An invisible force repels you." instead;

	check going south when player is in Branching Room:
		if gaudy hatch is visible:
			say "The hatch blocks you." instead;
		say "You walk through the hatch to some place that grants you ultimate wisdom, or something.";
		end the story saying "YOU WIN";

	chapter gems

	check inserting a gem into:
		if second noun is gaudy hatch:
			if noun is onyx:
				say "There's only one hole left, so...";
				try inserting onyx into black hole instead;	
			say "You may want to specify which hole." instead;
		if second noun is not in-item of noun:
			say "The [noun] doesn't fit there." instead;
		else:
			say "The [noun] fits in naturally.";
			increment the score;
			if score is 6:
				say "The hatch clicks open, revealing a way down.";
				now gaudy hatch is off-stage;

	report inserting a gem into:
		do nothing instead;

	check taking a gem:
		if noun is enclosed by in-item of noun:
			say "You can't pull it out." instead;

	the sapphire is a gem. open-dir of sapphire is north. start-dir of sapphire is northwest. in-item of sapphire is blue hole.
	the emerald is a gem. open-dir of emerald is northwest. start-dir of emerald is west. in-item of emerald is green hole.
	the ruby is a gem. open-dir of ruby is west. start-dir of ruby is east. in-item of ruby is red hole.
	the diamond is a gem. open-dir of diamond is east. start-dir of diamond is northeast. in-item of diamond is white hole.
	the amethyst is a gem. open-dir of amethyst is northeast. start-dir of amethyst is north. in-item of amethyst is yellow hole.

	the onyx is a gem. open-dir of onyx is south. in-item of onyx is black hole.

	when play begins:
		move onyx to a random gemmish room;
		repeat with Q running through gems:
			if Q is not onyx:
				let J be the room start-dir of Q from Branching Room;
				if onyx is not in J:
					now Q is in the room start-dir of Q from Branching Room;
				else:
					now player carries Q;

	volume hintsies

	chapter emerald

	emerald-hint is a rule-dependent hint-topic. printed name is "using the emerald"

	avail-rule of emerald-hint is emerald-hint rule.

	this is the emerald-hint rule:
		if emerald is in green hole:
			the rule fails;
		if player has emerald or location of emerald is visited:
			the rule succeeds;
		the rule fails;

	hint-list of emerald-hint is table of emerald hints.

	table of emerald hints
	hint-text	done-yet	show-rule
	"The emerald is a nice treasure, but you have no treasure horde."	false	a rule
	"You can put the emerald in the green hole."

	chapter amethyst

	amethyst-hint is a rule-dependent hint-topic. printed name is "using the amethyst"

	avail-rule of amethyst-hint is amethyst-hint rule.

	this is the amethyst-hint rule:
		if amethyst is in yellow hole:
			the rule fails;
		if player has amethyst or location of amethyst is visited:
			the rule succeeds;

	hint-list of amethyst-hint is table of amethyst hints.

	table of amethyst hints
	hint-text	done-yet	show-rule
	"The amethyst is a nice treasure, but you have no treasure horde."	false	a rule
	"You can put the amethyst in the yellow hole."

	chapter sapphire

	sapphire-hint is a rule-dependent hint-topic. printed name is "using the sapphire"

	avail-rule of sapphire-hint is sapphire-hint rule.

	this is the sapphire-hint rule:
		if sapphire is in blue hole:
			the rule fails;
		if player has sapphire or location of sapphire is visited:
			the rule succeeds;

	hint-list of sapphire-hint is table of sapphire hints.

	table of sapphire hints
	hint-text	done-yet	show-rule
	"The sapphire is a nice treasure, but you have no treasure horde."	false	a rule
	"You can put the sapphire in the blue hole."

	chapter diamond

	diamond-hint is a rule-dependent hint-topic. printed name is "using the diamond"

	avail-rule of diamond-hint is diamond-hint rule.

	this is the diamond-hint rule:
		if diamond is in white hole:
			the rule fails;
		if player has diamond or location of diamond is visited:
			the rule succeeds;

	hint-list of diamond-hint is table of diamond hints.

	table of diamond hints
	hint-text	done-yet	show-rule
	"The diamond is a nice treasure, but you have no treasure horde."	false	a rule
	"You can put the diamond in the white hole."

	chapter ruby

	ruby-hint is a rule-dependent hint-topic. printed name is "using the ruby"

	avail-rule of ruby-hint is ruby-hint rule.

	this is the ruby-hint rule:
		if ruby is in red hole:
			the rule fails;
		if player has ruby or location of ruby is visited:
			the rule succeeds;

	hint-list of ruby-hint is table of ruby hints.

	table of ruby hints
	hint-text	done-yet	show-rule
	"The ruby is a nice treasure, but you have no treasure horde."	false	a rule
	"You can put the ruby in the red hole."

	chapter onyx

	onyx-hint is a rule-dependent hint-topic. printed name is "using the onyx"

	avail-rule of onyx-hint is onyx-hint rule.

	this is the onyx-hint rule:
		if onyx is in black hole:
			the rule fails;
		if player has onyx or location of onyx is visited:
			the rule succeeds;

	hint-list of onyx-hint is table of onyx hints.

	table of onyx hints
	hint-text	done-yet	show-rule
	"The onyx is a nice treasure, but you have no treasure horde."	false	a rule
	"You can put the onyx in the black hole."

	chapter hatch

	hatch-opening is a hint-topic. hatch-opening is active. printed name of hatch-opening is "opening the hatch".

	check opening the gaudy hatch:
		if onyx is in the black hole:
			say "Already is.";
		else:
			say "The hatch won't budge. You have no way to grip it.";
		the rule succeeds;

	check closing the gaudy hatch:
		if onyx is in the black hole:
			say "You don't want to risk it locking again.";
		else:
			say "Already is.";
		the rule succeeds;

	hint-list of hatch-opening is table of hatch hints.

	table of hatch hints
	hint-text	done-yet	show-rule
	"The hatch's holes provide a clue what to do."
	"Each one requires a different gem."
	"Once you've put all the gems in the hatch, just go south."

	chapter tests

	test win-di with "put diamond in white/e/get ruby/w/put ruby in red/w/get emerald/e/put emerald in green/nw/get sapphire/se/put sapphire in blue/n/get amethyst/s/put amethyst in yellow/ne/get onyx/sw/put onyx in hatch/s"

	test win-ru with "put ruby in red/w/get emerald/e/put emerald in green/nw/get sapphire/se/put sapphire in blue/n/get amethyst/s/put amethyst in yellow/ne/get diamond/sw/put diamond in white/e/get onyx/w/put onyx in black/s"

	test win-am with "put amethyst in yellow/ne/get diamond/sw/put diamond in white/e/get ruby/w/put ruby in red/w/get emerald/e/put emerald in green/nw/get sapphire/se/put sapphire in blue/n/get onyx/s/put onyx in black/s"

	test win-em with "e/put emerald in green/nw/get sapphire/se/put sapphire in blue/n/get amethyst/s/put amethyst in yellow/ne/get diamond/sw/put diamond in white/e/get ruby/w/put ruby in red/w/get onyx/e/put onyx in hatch/s"

	test win-sa with "put sapphire in blue/n/get amethyst/s/put amethyst in yellow/ne/get diamond/sw/put diamond in white/e/get ruby/w/put ruby in red/w/get emerald/e/put emerald in green/nw/get onyx/se/put onyx in hatch/s"

	test win-1 with "i/test win-di/test win-ru/test win-am/test win-em/test win-sa"
	
	[end example]
