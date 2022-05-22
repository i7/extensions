Version 1 of Serial And Fix by Andrew Plotkin begins here.

"Allows commands of the form GET X, Y, AND Z to be parsed."

Include (- 
[ SquashSerialAnd
	ix jx lastwd wd addr len changedany;
	
	for (ix=1 : ix<= num_words : ix++) {
		wd = WordFrom(ix, parse);
		
		if (lastwd == comma_word && wd == AND1__WD) {
			addr = WordAddress(ix);
			len = WordLength(ix);
			for (jx=0 : jx<len : jx++) {
				addr->jx = ' ';
			}
			
			changedany++;
		}
		lastwd = wd;
	}
	
	return changedany;
];
-).

To squash serial ands:
	(- if (SquashSerialAnd()) { 
		VM_Tokenise(buffer,parse);
		num_words = WordCount();
		players_command = 100 + WordCount();
	}; -)

After reading a command:
	squash serial ands.

Serial And Fix ends here.
