Command Casing by Daniel Stelzer begins here.

"A simple fix to preserve casing when the player's command is altered."

Include (-
[ SetPlayersCommand from_txt i len at p cp;
	cp = from_txt-->0; p = TEXT_TY_Temporarily_Transmute(from_txt);
	len = TEXT_TY_CharacterLength(from_txt);
	if (len > 118) len = 118;
	#ifdef TARGET_ZCODE;
	buffer->1 = len; at = 2;
	for (i=0:i<len:i++) buffer->(i+at) = CharToCase(BlkValueRead(from_txt, i), 0);
	#ifnot;
	buffer-->0 = len; at = 4;
	for (i=0:i<len:i++) buffer->(i+at) = BlkValueRead(from_txt, i);
	#endif;
	for (:at+i<120:i++) buffer->(at+i) = ' ';
	VM_Tokenise(buffer, parse);
	players_command = 100 + WordCount(); ! The snippet variable "player's command"
	TEXT_TY_Untransmute(from_txt, p, cp);
];
-) instead of "Setting the Player's Command" in "Text.i6t".

Command Casing ends here.
