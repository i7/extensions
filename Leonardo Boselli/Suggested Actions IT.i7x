Version 1/140802 of Suggested Actions IT by Leonardo Boselli begins here.

"After examining a thing, this extension lists the possible actions. The commands are written in italian."

Chapter - Suggested Actions

Definition: a thing is takeable if it is not scenery and it is not a person and it is not part of something and it is not an enterable container.

After examining a thing (called the object):
	say "[fixed letter spacing]";
	if the object is worn by the player:
		now HI hyperlink text is "togli [the object]";
		print HI hyperlink;
	otherwise:
		if the object is wearable:
			now HI hyperlink text is "indossa [the object]";
			print HI hyperlink;
		if the object is carried by the player:
			now HI hyperlink text is "lascia [the object]";
			print HI hyperlink;
			if the nearest-person is not no-person and the nearest-person is visible:
				now HI hyperlink text is "dai [the object] [ap the nearest-person]";
				print HI hyperlink;
			if the object is edible:
				now HI hyperlink text is "annusa [the object]";
				print HI hyperlink;
				now HI hyperlink text is "assaggia [the object]";
				print HI hyperlink;
				now HI hyperlink text is "mangia [the object]";
				print HI hyperlink;
			if the nearest-supporter is not no-supporter and the nearest-supporter is visible:
				if the nearest-supporter is not the object:
					now HI hyperlink text is "metti [the object] [sup the nearest-supporter]";
					print HI hyperlink;
			otherwise:
				repeat with C running through supporters worn by the player:
					if C is not the object:
						now HI hyperlink text is "metti [the object] [inp the C]";
						print HI hyperlink;
				repeat with C running through supporters carried by the player:
					if C is not the object:
						now HI hyperlink text is "metti [the object] [inp the C]";
						print HI hyperlink;
				repeat with S running through supporters in the location:
					if S is not the object:
						now HI hyperlink text is "metti [the object] [sup the S]";
						print HI hyperlink;
			if the nearest-container is not no-container and the nearest-container is visible:
				if the nearest-container is not the object:
					now HI hyperlink text is "metti [the object] [inp the nearest-container]";
					print HI hyperlink;
			otherwise:
				repeat with C running through open containers worn by the player:
					if C is not the object:
						now HI hyperlink text is "metti [the object] [inp the C]";
						print HI hyperlink;
				repeat with C running through open containers carried by the player:
					if C is not the object:
						now HI hyperlink text is "metti [the object] [inp the C]";
						print HI hyperlink;
				repeat with C running through open containers in the location:
					if C is not the object:
						now HI hyperlink text is "metti [the object] [inp the C]";
						print HI hyperlink;
		otherwise if the object is takeable:
			now HI hyperlink text is "prendi [the object]";
			print HI hyperlink;
		if the object is a container:
			if the object is open:
				if the object is openable:
					now HI hyperlink text is "chiudi [the object]";
					print HI hyperlink;
				repeat with Obj running through the things carried by the player:
					if Obj is not the object:
						now HI hyperlink text is "metti [the Obj] [inp the object]";
						print HI hyperlink; 
			otherwise:
				now HI hyperlink text is "apri [the object]";
				print HI hyperlink;
		otherwise if the object is a supporter:
			repeat with Obj running through the things carried by the player:
				if Obj is not the object:
					now HI hyperlink text is "metti [the Obj] [sup the object]";
					print HI hyperlink; 
		if the object is enterable:
			if the object is a supporter:
				if the player is on the object:
					now HI hyperlink text is "scendi";
					print HI hyperlink;
				otherwise:
					now HI hyperlink text is "sali [sup the object]";
					print HI hyperlink;
			otherwise if the object is a container:
				if the player is in the object:
					now HI hyperlink text is "esci";
					print HI hyperlink;
				otherwise:
					now HI hyperlink text is "entra [inp the object]";
					print HI hyperlink;
		otherwise if the object is a person:
			repeat with S running through the things carried by the player:
				now HI hyperlink text is "dai [the S] [ap the object]";
				print HI hyperlink;
	say "[variable letter spacing][run paragraph on]";
	continue the action.

Chapter END

Suggested Actions IT ends here.

---- Documentation ----

Dopo aver esaminato un oggetto, vengono elencate le azioni che è possibile applicargli.
