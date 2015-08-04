Version 1 of Game Ending Reloaded by Shin begins here.

"Game Ending as defined in Version 2/090402 of the Standard Rules by Graham Nelson."

To end the game in death:
	(- deadflag=1; story_complete=false; -).

To end the game in victory:
	(- deadflag=2; story_complete=true; -).

To end the game saying (finale - text):
	(- deadflag={finale}; story_complete=false; -).

To resume the game:
	(- resurrect_please = true; -).

To decide whether the game is in progress:
	(- (deadflag==0) -).

To decide whether the game is over:
	(- (deadflag~=0) -).

To decide whether the game ended in death:
	(- (deadflag==1) -).

To decide whether the game ended in victory:
	(- (deadflag==2) -).

Game Ending Reloaded ends here.

---- DOCUMENTATION ----

Game Ending as defined in Version 2/090402 of the Standard Rules by Graham Nelson.
