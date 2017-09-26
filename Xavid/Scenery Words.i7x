Version 1/170913 of Scenery Words by Xavid begins here.

Use authorial modesty.

Chapter 1 - Testing unknown words in descriptions - Not for release

Include Snippetage by Dave Robinson.
Include Command Unit Testing by Xavid.
Include Object Matching by Xavid.

[When play begins:
	repeat with O running through rooms:
		say "[description of O]";
	repeat with O running through things:
		say "[description of O]";]

Wordchecking is an action out of world applying to one topic. Understand "wordcheck [text]" and "wordcheck" as wordchecking.

Carry out wordchecking:
	if the topic understood matches "here":
		add the location to the room queue;
	else if the topic understood matches "all/--":
		repeat with R running through rooms:
			add R to the room queue;
	else:
		say "Usage: [bold type]wordcheck here[roman type] or [bold type]wordcheck all[roman type]."

The room queue is a list of rooms that varies.
The word queue is a list of text that varies.
Check word is a text that varies.
Check error is a truth state that varies.

Rule for reading a command when the room queue is not empty or the word queue is not empty:
	while the word queue is empty:
		let R be entry 1 in the room queue;
		remove entry 1 from the room queue;
		let D be the description of R;
		repeat with T running through things in R:
			now D is the substituted form of "[D] [initial appearance of T]";
		replace the regular expression "(?i)\b(in front of)\b" in D with "";
		repeat with I running from 1 to number of unpunctuated words in D:
			let W be unpunctuated word number I in D in lower case;
			replace the regular expression "<,.?>$" in W with "";
			if the number of characters in W is greater than 2 and W is not listed in {"and", "let", "the", "some", "few", "has", "also", "dominated", "leads", "passes", "into", "leading", "lies", "from", "above", "this", "was", "full", "but", "now", "they're", "you", "can", "see", "gone", "are", "mostly", "emerges", "continues", "overlooks", "runs", "where", "could", "cross", "there", "through", "near", "here", "among", "surrounds", "growing", "with", "one", "lead", "sits", "it's", "there's", "sit", "possibly", "because", "only", "doesn't", "really", "look", "any", "than", "lead", "just", "going", "get", "for", "against"}:
				add W to the word queue;
		now the player is in R;
	now check word is entry 1 in the word queue;
	remove entry 1 from the word queue;
	start unit-capturing text;
	now disable clarification is true;
	change the text of the player's command to "x [check word]".

Before reading a command when check word is not empty:
	stop unit-capturing text;
	if check error is true:
		let T be "[the unit-captured text]";
		replace the regular expression "^\s+" in T with "";
		replace the regular expression "\s+$" in T with "";
		say "[check word]: [T][line break]";
	now check word is "";
	now check error is false;
	now disable clarification is false.

Rule for printing a parser error when check word is not empty:
	now check error is true;
	make no decision. 

Scenery Words ends here.

---- DOCUMENTATION ----

This extensions loops over all the rooms in your games and tries examining words in the room description to see how the game responds. This is designed to catch words players expect to be able to examine, but cannot due to author oversight.

Chapter 1 - Usage

Type wordcheck in a debugging build to loop over words. There's a blacklist of words that get ignored, but there are probably many words in your game that will pop up that aren't really something that should be examined. That's fine. It's expected that you'll go over the output manually.

Chapter 2 - Bugs and Comments

This extension is hosted in Github at https://github.com/i7/extensions/tree/master/Xavid. Feel free to email me at extensions@xavid.us with questions, comments, bug reports, suggestions, or improvements.