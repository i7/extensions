Version 1/120431 of Freezing Time on Rejects by Andrew Schultz begins here.

"An extension to make sure that rejected actions do not take a move. It is recommended that users modify this file if they do want an action to take a move."

Include (- Global freezetime = 0;

[ frz;
  freezetime = 1;

];

-) after "ICL Commands" in "Output.i6t".

to decide whether time-froze:
	(- freezetime -)

to freeze-time:
	(- freezetime = 1; -)

to unfreeze-time:
	(- freezetime = 0; -)

to say freeze-time:
	freeze-time;

include (-

[ LanguageLM n x1 x2;
  say__p = 1;
  Answer,Ask:
			"There is no reply.";
! Ask:      see Answer
  Attack:   frz(); "Violence isn't the answer to this one.";
  Burn:     frz(); "This dangerous act would achieve little.";
  Buy:      frz(); "Nothing is on sale.";
  Climb:    "I don't think much is to be achieved by that.";
  Close: switch (n) {
		1:  frz(); print_ret (ctheyreorthats) x1, " not something you can close.";
		2:  frz(); print_ret (ctheyreorthats) x1, " already closed.";
		3:  "You close ", (the) x1, ".";
		4:	print (The) actor, " closes ", (the) x1, ".^";
		5:	print (The) x1, " close"; if (x1 hasnt pluralname) print "s";
			print ".^";
	}
  Consult: switch (n) {
  		1:	"You discover nothing of interest in ", (the) x1, ".";
  		2:	print (The) actor, " looks at ", (the) x1, ".^";
	}
  Cut:      frz(); "Cutting ", (thatorthose) x1, " up would achieve little.";
  Disrobe: switch (n) {
		1:  frz(); "You're not wearing ", (thatorthose) x1, ".";
		2:  "You take off ", (the) x1, ".";
		3:	print (The) actor, " takes off ", (the) x1, ".^";
	}
  Drink:    frz(); "There's nothing suitable to drink here.";
  Drop: switch (n) {
		1:  frz(); if (x1 has pluralname) print (The) x1, " are "; else print (The) x1, " is ";
			"already here.";
		2:  frz(); "You haven't got ", (thatorthose) x1, ".";
		3:  print "(first taking ", (the) x1, " off)^"; say__p = 0; return;
		4:  "Dropped.";
		5:	frz(); "There is no more room on ", (the) x1, ".";
		6:	frz(); "There is no more room in ", (the) x1, ".";
		7:	print (The) actor, " puts down ", (the) x1, ".^";
	}
  Eat: switch (n) {
		1:  frz(); print_ret (ctheyreorthats) x1, " plainly inedible.";
		2:  frz(); "You eat ", (the) x1, ". Not bad.";
		3:	print (The) actor, " eats ", (the) x1, ".^";
	}
  Enter: switch (n) {
		1:  frz(); print "But you're already ";
			if (x1 has supporter) print "on "; else print "in ";
			print_ret (the) x1, ".";
		2:  frz(); if (x1 has pluralname) print "They're"; else print "That's";
			print " not something you can ";
			switch (verb_word) {
			  'stand':  "stand on.";
			  'sit':    "sit down on.";
			  'lie':    "lie down on.";
			  default:  "enter.";
			}
		3:  frz(); "You can't get into the closed ", (name) x1, ".";
		4:  frz(); "You can only get into something free-standing.";
		5:  print "You get ";
			if (x1 has supporter) print "onto "; else print "into ";
			print_ret (the) x1, ".";
		6:  print "(getting ";
			if (x1 has supporter) print "off "; else print "out of ";
			print (the) x1; print ")^"; say__p = 0; return;
		7:  ! say__p = 0;
			if (x1 has supporter) "(getting onto ", (the) x1, ")";
			if (x1 has container) "(getting into ", (the) x1, ")";
			"(entering ", (the) x1, ")";
		8:	print (The) actor, " gets into ", (the) x1, ".^";
		9:  print (The) actor, " gets onto ", (the) x1, ".^";
	}
  Examine: switch (n) {
		1:  frz(); "Darkness, noun.  An absence of light to see by.";
		2:  frz(); "You see nothing special about ", (the) x1, ".";
		3:  print (The) x1, " ", (isorare) x1, " currently switched ";
			if (x1 has on) "on."; else "off.";
		4:	print (The) actor, " looks closely at ", (the) x1, ".^";
		5:	frz(); "You see nothing unexpected in that direction.";
	}
  Exit: switch (n) {
		1:  frz(); "But you aren't in anything at the moment.";
		2:  frz(); "You can't get out of the closed ", (name) x1, ".";
		3:  print "You get ";
			if (x1 has supporter) print "off "; else print "out of ";
			print_ret (the) x1, ".";
		4:  frz(); print "But you aren't ";
			if (x1 has supporter) print "on "; else print "in ";
			print_ret (the) x1, ".";
		5:	print (The) actor, " gets off ", (the) x1, ".^";
		6:	print (The) actor, " gets out of ", (the) x1, ".^";
	}
  GetOff:   "But you aren't on ", (the) x1, " at the moment.";
  Give: switch (n) {
		1:  frz(); "You aren't holding ", (the) x1, ".";
		2:  frz(); "You juggle ", (the) x1, " for a while, but don't achieve much.";
		3:  frz(); print (The) x1;
			if (x1 has pluralname) print " don't"; else print " doesn't";
			" seem interested.";
		4:  frz(); print (The) x1;
			if (x1 has pluralname) print " aren't";
			else print " isn't";
			" able to receive things.";
		5:	"You give ", (the) x1, " to ", (the) second, ".";
		6: print (The) actor, " gives ", (the) x1, " to you.^";
		7: print (The) actor, " gives ", (the) x1, " to ", (the) second, ".^";
	}
  Go: switch (n) {
		1:  frz(); print "You'll have to get ";
			if (x1 has supporter) print "off "; else print "out of ";
			print_ret (the) x1, " first.";
		2:  frz(); print_ret (string) CANTGO__TX;   ! "You can't go that way."
		6:  frz(); print "You can't, since ", (the) x1;
			if (x1 has pluralname) " lead nowhere."; else " leads nowhere.";
		7:	frz(); "You'll have to say which compass direction to go in.";
		8:	print (The) actor, " goes up";
		9:	print (The) actor, " goes down";
		10:	print (The) actor, " goes ", (name) x1;
		11:	print (The) actor, " arrives from above";
		12:	print (The) actor, " arrives from below";
		13:	print (The) actor, " arrives from the ", (name) x1;
		14:	print (The) actor, " arrives";
		15:	print (The) actor, " arrives at ", (the) x1, " from above";
		16:	print (The) actor, " arrives at ", (the) x1, " from below";
		17:	print (The) actor, " arrives at ", (the) x1, " from the ", (name) x2;
		18:	print (The) actor, " goes through ", (the) x1;
		19:	print (The) actor, " arrives from ", (the) x1;
		20:	print "on ", (the) x1;
		21:	print "in ", (the) x1;
		22:	print ", pushing ", (the) x1, " in front, and you along too";
		23:	print ", pushing ", (the) x1, " in front";
		24:	print ", pushing ", (the) x1, " away";
		25:	print ", pushing ", (the) x1, " in";
		26:	print ", taking you along";
		27: print "(first getting off ", (the) x1, ")^"; say__p = 0; return;
		28: print "(first opening ", (the) x1, ")^"; say__p = 0; return;
	}
  Insert: switch (n) {
		1:  frz(); "You need to be holding ", (the) x1, " before you can put ", (itorthem) x1,
			" into something else.";
		2:  frz(); print_ret (Cthatorthose) x1, " can't contain things.";
		3:  frz(); print_ret (The) x1, " ", (isorare) x1, " closed.";
		4:  frz(); "You'll need to take ", (itorthem) x1, " off first.";
		5:  frz(); "You can't put something inside itself.";
		6:  print "(first taking ", (itorthem) x1, " off)^"; say__p = 0; return;
		7:  frz(); "There is no more room in ", (the) x1, ".";
		8:  "Done.";
		9:  "You put ", (the) x1, " into ", (the) second, ".";
	   10:  print (The) actor, " puts ", (the) x1, " into ", (the) second, ".^";
	}
  Inv: switch (n) {
		1:  frz(); "You are carrying nothing.";
		2:  frz(); print "You are carrying";
		3:  print ":^";
		4:  print ".^";
		5:	print (The) x1, " looks through ", (HisHerTheir) x1, " possessions.^";
	}
  Jump:     frz(); "You jump on the spot, fruitlessly.";
  Kiss:     frz(); "Keep your mind on the game.";
  Listen:   frz(); "You hear nothing unexpected.";
  ListMiscellany: switch (n) {
		1:  print " (providing light)";
		2:  print " (closed)";
		4:  print " (empty)";
		6:  print " (closed and empty)";
		3:  print " (closed and providing light)";
		5:  print " (empty and providing light)";
		7:  #ifdef SERIAL_COMMA;
			print " (closed, empty, and providing light)";
			#ifnot;
			print " (closed, empty and providing light)";
			#endif;
		8:  print " (providing light and being worn";
		9:  print " (providing light";
		10: print " (being worn";
		11: print " (";
		12: print "open";
		13: print "open but empty";
		14: print "closed";
		15: print "closed and locked";
		16: print " and empty";
		17: print " (empty)";
		18: print " containing ";
		19: print " (on ";
		20: print ", on top of ";
		21: print " (in ";
		22: print ", inside ";
	}
  LMode1:   " is now in its ~brief~ printing mode, which gives long descriptions
			 of places never before visited and short descriptions otherwise.";
  LMode2:   " is now in its ~verbose~ mode, which always gives long descriptions
			 of locations (even if you've been there before).";
  LMode3:   " is now in its ~superbrief~ mode, which always gives short descriptions
			 of locations (even if you haven't been there before).";
  Lock: switch (n) {
		1:  if (x1 has pluralname) print "They don't "; else print "That doesn't ";
			"seem to be something you can lock.";
		2:  print_ret (ctheyreorthats) x1, " locked at the moment.";
		3:  "First you'll have to close ", (the) x1, ".";
		4:  if (x1 has pluralname) print "Those don't "; else print "That doesn't ";
			"seem to fit the lock.";
		5:  "You lock ", (the) x1, ".";
		6:	print (The) actor, " locks ", (the) x1, ".^";
	}
  Look: switch (n) {
		1:  print " (on ", (the) x1, ")";
		2:  print " (in ", (the) x1, ")";
		3:  print " (as ", (object) x1, ")";
		4:  print "On ", (the) x1, " ";
			WriteListFrom(child(x1),
			  ENGLISH_BIT+RECURSE_BIT+PARTINV_BIT+TERSE_BIT+CONCEAL_BIT+ISARE_BIT);
			".";
		5,6:
			if (x1 ~= location) {
				if (x1 has supporter) print "On "; else print "In ";
				print (the) x1, " you";
			}
			else print "You";
			print " can ";
			if (n == 5) print "also ";
			print "see ";
			WriteListFrom(child(x1),
			  ENGLISH_BIT+RECURSE_BIT+PARTINV_BIT+TERSE_BIT+CONCEAL_BIT+WORKFLAG_BIT);
			if (x1 ~= location) "."; else " here.";
		7:  frz(); "You see nothing unexpected in that direction.";
		8:  if (x1 has supporter) print " (on "; else print " (in ";
			print (the) x1, ")";
		9:	print (The) actor, " looks around.^";
	}
  LookUnder: switch (n) {
		1:  frz(); "But it's dark.";
		2:  frz(); "You find nothing of interest.";
		3:	print (The) actor, " looks under ", (the) x1, ".^";
	}
  Mild:     frz(); "Quite.";
  Miscellany: switch (n) {
		1:  "(considering the first sixteen objects only)^";
		2:  "Nothing to do!";
		3:  print " You have died ";
		4:  print " You have won ";
		5:  print "^Would you like to RESTART, RESTORE a saved game";
			#Ifdef DEATH_MENTION_UNDO;
			print ", UNDO your last move";
			#Endif;
			#ifdef SERIAL_COMMA;
			print ",";
			#endif;
			" or QUIT?";
		6:  "[Your interpreter does not provide ~undo~.  Sorry!]";
			#Ifdef TARGET_ZCODE;
		7:  "~Undo~ failed.  [Not all interpreters provide it.]";
			#Ifnot; ! TARGET_GLULX
		7:  "[You cannot ~undo~ any further.]";
			#Endif; ! TARGET_
		8:  "Please give one of the answers above.";
		9:  "It is now pitch dark in here!";
		10: "I beg your pardon?";
		11: "[You can't ~undo~ what hasn't been done!]";
		12: "[Can't ~undo~ twice in succession. Sorry!]";
		13: "[Previous turn undone.]";
		14: "Sorry, that can't be corrected.";
		15: "Think nothing of it.";
		16: "~Oops~ can only correct a single word.";
		17: "It is pitch dark, and you can't see a thing.";
		18: print "yourself";
		19: "As good-looking as ever.";
		20: "To repeat a command like ~frog, jump~, just say ~again~, not ~frog, again~.";
		21: "You can hardly repeat that.";
		22: "You can't begin with a comma.";
		23: "You seem to want to talk to someone, but I can't see whom.";
		24: "You can't talk to ", (the) x1, ".";
		25: "To talk to someone, try ~someone, hello~ or some such.";
		26: "(first taking ", (the) x1, ")";
		27: "I didn't understand that sentence.";
		28: print "I only understood you as far as wanting to ";
		29: "I didn't understand that number.";
		30: "You can't see any such thing.";
		31: "You seem to have said too little!";
		32: "You aren't holding that!";
		33: "You can't use multiple objects with that verb.";
		34: "You can only use multiple objects once on a line.";
		35: "I'm not sure what ~", (address) pronoun_word, "~ refers to.";
		36: "You excepted something not included anyway!";
		37: "You can only do that to something animate.";
			#Ifdef DIALECT_US;
		38: "That's not a verb I recognize.";
			#Ifnot;
		38: "That's not a verb I recognise.";
			#Endif;
		39: "That's not something you need to refer to in the course of this game.";
		40: "You can't see ~", (address) pronoun_word, "~ (", (the) pronoun_obj,
			") at the moment.";
		41: "I didn't understand the way that finished.";
		42: if (x1 == 0) print "None"; else print "Only ", (number) x1;
			print " of those ";
			if (x1 == 1) print "is"; else print "are";
			" available.";
		43: "Nothing to do!";
		44: "There are none at all available!";
		45: print "Who do you mean, ";
		46: print "Which do you mean, ";
		47: "Sorry, you can only have one item here. Which exactly?";
		48: print "Whom do you want";
			if (actor ~= player) print " ", (the) actor;
			print " to "; PrintCommand(); print "?^";
		49: print "What do you want";
			if (actor ~= player) print " ", (the) actor;
			print " to "; PrintCommand(); print "?^";
		50: print "Your score has just gone ";
			if (x1 > 0) print "up"; else { x1 = -x1; print "down"; }
			print " by ", (number) x1, " point";
			if (x1 > 1) print "s";
		51: "(Since something dramatic has happened, your list of commands has been cut short.)";
		52: "^Type a number from 1 to ", x1, ", 0 to redisplay or press ENTER.";
		53: "^[Please press SPACE.]";
		54: "[Comment recorded.]";
		55: "[Comment NOT recorded.]";
		56: print ".^";
		57: print "?^";
		58: print (The) actor, " ", (IsOrAre) actor, " unable to do that.^";
		59:	"You must supply a noun.";
		60:	"You may not supply a noun.";
		61:	"You must name an object.";
		62:	"You may not name an object.";
		63:	"You must name a second object.";
		64:	"You may not name a second object.";
		65:	"You must supply a second noun.";
		66:	"You may not supply a second noun.";
		67:	"You must name something more substantial.";
		68:	print "(", (The) actor, " first taking ", (the) x1, ")^";
		69: "(first taking ", (the) x1, ")";
		70: "The use of UNDO is forbidden in this game.";
		71: print (string) DARKNESS__TX;
  		72: print (The) x1;
			if (x1 has pluralname) print " have"; else print " has";
			" better things to do.";
		73: "That noun did not make sense in this context.";
		74: print "[That command asks to do something outside of play, so it can
			only make sense from you to me. ", (The) x1, " cannot be asked to do this.]^";
		75:  print " The End ";
	}
  No,Yes:   frz(); "That was a rhetorical question.";
  NotifyOff:
			"Score notification off.";
  NotifyOn: "Score notification on.";
  Open: switch (n) {
		1:  frz(); print_ret (ctheyreorthats) x1, " not something you can open.";
		2:  frz(); if (x1 has pluralname) print "They seem "; else print "It seems ";
			"to be locked.";
		3:  frz(); print_ret (ctheyreorthats) x1, " already open.";
		4:  print "You open ", (the) x1, ", revealing ";
			if (WriteListFrom(child(x1), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT) == 0) "nothing.";
			".";
		5:  "You open ", (the) x1, ".";
		6:	print (The) actor, " opens ", (the) x1, ".^";
		7:	print (The) x1, " open";
			if (x1 hasnt pluralname) print "s";
			print ".^";
	}
  Pronouns: switch (n) {
		1:  print "At the moment, ";
		2:  print "means ";
		3:  print "is unset";
		4:  "no pronouns are known to the game.";
		5:  ".";
	}
  Pull,Push,Turn: switch (n) {
		1:  frz(); if (x1 has pluralname) print "Those are "; else print "It is ";
			"fixed in place.";
		2:  frz(); "You are unable to.";
		3:  frz(); "Nothing obvious happens.";
		4:  frz(); "That would be less than courteous.";
		5:	print (The) actor, " pulls ", (the) x1, ".^";
		6:	print (The) actor, " pushes ", (the) x1, ".^";
		7:	print (The) actor, " turns ", (the) x1, ".^";
	}
! Push: see Pull
  PushDir: switch (n) {
		1:  frz(); print (The) x1, " cannot be pushed from place to place.^";
		2:  frz(); "That's not a direction.";
		3:  frz(); "Not that way you can't.";
	}
  PutOn: switch (n) {
		1:  frz(); "You need to be holding ", (the) x1, " before you can put ",
				(itorthem) x1, " on top of something else.";
		2:  frz(); "You can't put something on top of itself.";
		3:  frz(); "Putting things on ", (the) x1, " would achieve nothing.";
		4:  frz(); "You lack the dexterity.";
		5:  print "(first taking ", (itorthem) x1, " off)^"; say__p = 0; return;
		6:  frz(); "There is no more room on ", (the) x1, ".";
		7:  "Done.";
		8:  "You put ", (the) x1, " on ", (the) second, ".";
		9:  print (The) actor, " puts ", (the) x1, " on ", (the) second, ".^";
	}
  Quit: switch (n) {
		1:  print "Please answer yes or no.";
		2:  print "Are you sure you want to quit? ";
	}
  Remove: switch (n) {
		1:  frz(); if (x1 has pluralname) print "They are"; else print "It is";
			" unfortunately closed.";
		2:  frz(); if (x1 has pluralname) print "But they aren't"; else print "But it isn't";
			" there now.";
		3:  "Removed.";
	}
  Restart: switch (n) {
		1:  print "Are you sure you want to restart? ";
		2:  "Failed.";
	}
  Restore: switch (n) {
		1:  "Restore failed.";
		2:  "Ok.";
	}
  Rub:      frz(); "You achieve nothing by this.";
  Save: switch (n) {
		1:  "Save failed.";
		2:  "Ok.";
	}
  Score: switch (n) {
		1:  if (deadflag) print "In that game you scored "; else print "You have so far scored ";
			print score, " out of a possible ", MAX_SCORE, ", in ", turns, " turn";
			if (turns ~= 1) print "s";
			return;
		2:  "There is no score in this story.";
		3:	print ", earning you the rank of ";
	}
  ScriptOff: switch (n) {
		1:  "Transcripting is already off.";
		2:  "^End of transcript.";
		3:  "Attempt to end transcript failed.";
	}
  ScriptOn: switch (n) {
		1:  "Transcripting is already on.";
		2:  "Start of a transcript of";
		3:  "Attempt to begin transcript failed.";
	}
  Search: switch (n) {
		1:  frz(); "But it's dark.";
		2:  frz(); "There is nothing on ", (the) x1, ".";
		3:  print "On ", (the) x1, " ";
			WriteListFrom(child(x1), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT+ISARE_BIT);
			".";
		4:  frz(); "You find nothing of interest.";
		5:  frz(); "You can't see inside, since ", (the) x1, " ", (isorare) x1, " closed.";
		6:  print_ret (The) x1, " ", (isorare) x1, " empty.";
		7:  print "In ", (the) x1, " ";
			WriteListFrom(child(x1), ENGLISH_BIT+TERSE_BIT+CONCEAL_BIT+ISARE_BIT);
			".";
		8:	print (The) actor, " searches ", (the) x1, ".^";
	}
  SetTo:    frz(); "No, you can't set ", (thatorthose) x1, " to anything.";
  Show: switch (n) {
		1:  frz(); "You aren't holding ", (the) x1, ".";
		2:  frz(); print_ret (The) x1, " ", (isorare) x1, " unimpressed.";
	}
  Sing:     frz(); "Your singing is abominable.";
  Sleep:    frz(); "You aren't feeling especially drowsy.";
  Smell:    "You smell nothing unexpected.";
			#Ifdef DIALECT_US;
  Sorry:    frz(); "Oh, don't apologize.";
			#Ifnot;
  Sorry:    frz(); "Oh, don't apologise.";
			#Endif;
  Squeeze: switch (n) {
		1:  frz(); "Keep your hands to yourself.";
		2:  frz(); "You achieve nothing by this.";
		3:	print (The) actor, " squeezes ", (the) x1, ".^";
	}
  Strong:   frz(); "Real adventurers do not use such language.";
  Swing:    frz(); "There's nothing sensible to swing here.";
  SwitchOff: switch (n) {
		1:  frz(); print_ret (ctheyreorthats) x1, " not something you can switch.";
		2:  frz(); print_ret (ctheyreorthats) x1, " already off.";
		3:  "You switch ", (the) x1, " off.";
		4:	print (The) actor, " switches ", (the) x1, " off.^";
	}
  SwitchOn: switch (n) {
		1:  frz(); print_ret (ctheyreorthats) x1, " not something you can switch.";
		2:  frz(); print_ret (ctheyreorthats) x1, " already on.";
		3:  "You switch ", (the) x1, " on.";
		4:	print (The) actor, " switches ", (the) x1, " on.^";
	}
  Take: switch (n) {
		1:  "Taken.";
		2:  frz(); "You are always self-possessed.";
		3:  frz(); "I don't suppose ", (the) x1, " would care for that.";
		4:  print "You'd have to get ";
			if (x1 has supporter) print "off "; else print "out of ";
			print_ret (the) x1, " first.";
		5:  "You already have ", (thatorthose) x1, ".";
		6:  if (noun has pluralname) print "Those seem "; else print "That seems ";
			"to belong to ", (the) x1, ".";
		7:  if (noun has pluralname) print "Those seem "; else print "That seems ";
			"to be a part of ", (the) x1, ".";
		8:  print_ret (Cthatorthose) x1, " ", (isorare) x1,
			"n't available.";
		9:  print_ret (The) x1, " ", (isorare) x1, "n't open.";
		10: if (x1 has pluralname) print "They're "; else print "That's ";
			"hardly portable.";
		11: if (x1 has pluralname) print "They're "; else print "That's ";
			"fixed in place.";
		12: "You're carrying too many things already.";
		13: print "(putting ", (the) x1, " into ", (the) x2,
			" to make room)^"; say__p = 0; return;
		14: "You can't reach into ", (the) x1, ".";
		15: "You cannot carry ", (the) x1, ".";
		16: print (The) actor, " picks up ", (the) x1, ".^";
	}
  Taste:    frz(); "You taste nothing unexpected.";
  Tell: switch (n) {
		1:  frz(); "You talk to yourself a while.";
		2:  frz(); "This provokes no reaction.";
	}
  Think:    "What a good idea.";
  ThrowAt: switch (n) {
		1:  frz(); "Futile.";
		2:  frz(); "You lack the nerve when it comes to the crucial moment.";
	}
  Tie:		frz(); "You would achieve nothing by this.";
  Touch: switch (n) {
		1:  frz(); "Keep your hands to yourself!";
		2:  frz(); "You feel nothing unexpected.";
		3:  frz(); "If you think that'll help.";
		4:	print (The) actor, " touches ", (himheritself) x1, ".^";
		5:	print (The) actor, " touches you.^";
		6:	print (The) actor, " touches ", (the) x1, ".^";
	}
! Turn: see Pull.
  Unlock:  switch (n) {
		1:  frz(); if (x1 has pluralname) print "They don't "; else print "That doesn't ";
			"seem to be something you can unlock.";
		2:  frz(); print_ret (ctheyreorthats) x1, " unlocked at the moment.";
		3:  frz(); if (x1 has pluralname) print "Those don't "; else print "That doesn't ";
			"seem to fit the lock.";
		4:  "You unlock ", (the) x1, ".";
		5:	print (The) actor, " unlocks ", (the) x1, ".^";
	}
  Verify: switch (n) {
		1:  "The game file has verified as intact.";
		2:  "The game file did not verify as intact, and may be corrupt.";
	}
  Wait: switch (n) {
		1:  "Time passes.";
		2:	print (The) actor, " waits.^";
	}
  Wake:     frz(); "The dreadful truth is, this is not a dream.";
  WakeOther:"That seems unnecessary.";
  Wave: switch (n) {
		1:  frz(); "But you aren't holding ", (thatorthose) x1, ".";
		2:  frz(); "You look ridiculous waving ", (the) x1, ".";
		3:	print (The) actor, " waves ", (the) x1, ".^";
	}
  WaveHands: frz(); "You wave, feeling foolish.";
  Wear: switch (n) {
		1:  frz(); "You can't wear ", (thatorthose) x1, "!";
		2:  frz(); "You're not holding ", (thatorthose) x1, "!";
		3:  frz(); "You're already wearing ", (thatorthose) x1, "!";
		4:  "You put on ", (the) x1, ".";
		5:	print (The) actor, " puts on ", (the) x1, ".^";
	}
! Yes:  see No.
];

-) instead of "Long Texts" in "Language.i6t"

To decide whether the current action is no-timely: 
	 (- meta -) [this is a trick to flag out of world actions, if you want to]

to decide whether the action is instantaneous:
	if the current action is no-timely, yes;
	if looking, yes;
	if examining, yes; ["nothing special" already takes zero time. But many people want to take zero time, period.]
	if taking inventory, yes;
	no;
	[Note: this is largely redundant if you keep what's above. Still, it can't hurt, and it's more logically laid out. For instance, if you're able to take something quickly, you might want to put it here.]

---- DOCUMENTATION ----

This only works in 6G so far. The syntax of 6L is so different that Language.i6t is far different and probably better. But for us 6G fans, this will work.

It is recommended that you eliminate frz() as needed in order to make sure time does pass in certain cases.

This extension can also double as a way to modify various error texts, if you so choose.
	
Example: *** Taking time - a small game that tests basic "mistakes"

	room 1 is a room.

	the trinket is a thing in room 1.

	every turn (this is the check if time elapsed rule):
		if action is instantaneous:
			freeze-time;
		say "Debug check: ";
		if time-froze:
			say "time froze.";
			unfreeze-time;
			continue the action;
		else:
			say "time went ahead.";
			continue the action;

	test timing with "wear trinket/wave/z/z/wear trinket/wave"

Freezing Time on Rejects ends here.
