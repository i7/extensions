Version 2/140430 of Vorple Multimedia (for Z-Machine only) by Juhana Leinonen begins here.

"Displaying images, playing sounds and music, and showing videos from YouTube."

Include Vorple by Juhana Leinonen.
Use authorial modesty.


Chapter 1 - Images

To display image (file - text) in a/an/-- element called (classes - text):
	let id be unique identifier;
	place a block level element called "[id] [classes] vorple-image";
	execute JavaScript command "$('.[id]').html(vorple.media.image('[file]'))".

To display image (file - text), centered, aligned left, aligned right, floating left or floating right:
	let the alignment class be "";
	if centered, let the alignment class be "centered";
	if aligned left, let the alignment class be "left-aligned";
	if aligned right, let the alignment class be "right-aligned";
	if floating left, let the alignment class be "left-floating";
	if floating right, let the alignment class be "right-floating";
	display image file in an element called alignment class.

To preload image (file - text):
	execute JavaScript command "vorple.media.preloadImage('[file]');".
	
To preload images (image-list - list of text):
	repeat with X running through image-list:
		preload image "[X]".


Chapter 2 - Audio

To play sound file/-- (file - text), looping:
	if looping:
		execute JavaScript command "vorple.media.playSound('[escaped file]',{loop:true})";
	otherwise:
		execute JavaScript command "vorple.media.playSound('[escaped file]',{loop:false})".

To play music file/-- (file - text), looping:
	if looping:
		execute JavaScript command "vorple.media.playMusic('[escaped file]',{loop:true})";
	otherwise:
		execute JavaScript command "vorple.media.playMusic('[escaped file]',{loop:false})".

To stop music:
	execute JavaScript command "vorple.media.stopMusic()".

To stop sounds:
	execute JavaScript command "vorple.media.stopSounds()".

To stop all audio:
	execute JavaScript command "vorple.media.stopAll()".


Chapter 3 - Video

To play a/the/-- YouTube video (youtube-id - text):
	let container-id be unique identifier;
	place a block level element called "[container-id] youtube";
	execute JavaScript command "$('.[container-id]').html(vorple.media.youtube('[youtube-id]',{width:600}))".
	
Vorple Multimedia ends here.


---- DOCUMENTATION ----


Chapter: Including media files

Media files (images and audio) should be declared in the story source so that Inform knows to include them in the release version.

	Release along with the file "whatever.png".

The files should be placed in the Materials directory, as per chapter 23.7. in Writing with Inform.

It doesn't matter what you call the resource ("Some picture" in the above example). Only the filename ("whatever.png") is significant.

Note that we shouldn't use the "Figure of ..." or "Sound of ..." directives described in chapter 22 of Writing with Inform. Files declared this way won't be included correctly in the release folder.


Chapter: Images

Images can be displayed using the "display image" command:

	display image "pic.jpg";

By default the image is displayed left-aligned. The position can be changed by giving it as a parameter:

	display image "pic.jpg", centered;

The possible values are centered, aligned left, aligned right, floating left or floating right. Floating means that the image is set to the left or to the right and the text is wrapped around them.

Images should be in jpg, png or gif format.


Section: Preloading images

Images can be preloaded either individually or as a list:

	When play begins:
		preload image "pic.jpg";
		preload images { "pic1.jpg", "pic2.png" }.

Preloading images makes them appear immediately when they are needed. Otherwise the images are loaded only when they are first displayed which may take some time with slower connections, resulting in a noticeable delay between when they should be shown and when they have loaded and actually appear.

Images must be preloaded inside a rule, most commonly in a When play begins rule. We can save bandwidth by preloading in later stages when the story is closer to the point when it should display the image, but note that starting to preload at the same time when the image is displayed is too late and preloading images that are shown right when the story begins is not useful.


Chapter: Audio

There are two types of audio: sound effects and music. The main difference is that multiple sound effects can be played at the same time, and at the same time as background music is playing. With music only one track can be playing at the same time, and starting to play another music file the previous one will stop.

Audio files should be in either mp3 or ogg format.

	play sound file "bang.mp3";
	play music file "horns.mp3";

By default the files are played once and then stopped. They can also be set to loop:

	play music file "background.mp3", looping;

Once playing the sounds can be stopped with the following phrases:

	stop sounds;
	stop music;
	stop all audio;

(Naturally stopping just the sound effects won't affect music, and vice versa.)


Chapter: YouTube videos

We can play YouTube videos with:

	play YouTube video "9d4Fu90ubmA";

The seemingly random string of numbers and letters is the id of the video we want to show. The id can be seen in the browser's address bar when viewing the video in YouTube, for example "http://www.youtube.com/watch?v=9d4Fu90ubmA".
	

Example: * Serinette - Basic example of playing music and sound effects.

The serinette (a type of music box) plays music when it opens and a sound effect when it's wound. We'll also show its picture when it's examined.

The example media files can be downloaded from http://vorple-if.com/vorple/doc/inform7/examples/resources.

	*: "Serinette"
	
	Include Vorple Multimedia by Juhana Leinonen.
	Release along with the "Vorple" interpreter.
	
	Release along with the file "winding.mp3".
	Release along with the file "musicbox.mp3".
	Release along with the file "serinette.jpg".

	To start playing the tune:
		play music file "musicbox.mp3".

	Drawing room is a room. "The drawing room is tastefully decorated."
	
	The serinette is an openable closed container in the drawing room. "A beautiful music box sits on a table." The description is "There's a winding key behind the box."
	Understand "music" and "box" as the serinette.

	Before examining the serinette:
		display image "serinette.jpg", centered.

	When play begins:
		preload image "serinette.jpg".
	
	A winding key is part of the serinette.
	
	The serinette can be wound or unwound. The serinette is unwound.
	
	Winding is an action applying to one thing. Understand "wind [something]" as winding.
	
	Check winding when the noun is not the serinette:
		say "That's not something you can wind." instead.
	
	Check winding when the noun is wound:
		say "[The noun] is already wound." instead.
	
	Carry out winding:
		now the serinette is wound;
		play sound file "winding.mp3";
		if the serinette is open:
			start playing the tune.
	
	Report winding:
		say "You turn the winding key until it turns no more.";
	
	Instead of turning or winding the winding key:
		try winding the serinette.
	
	Instead of inserting something into the serinette:
		say "It's not the kind of box that can contain anything other than its own mechanism."

	Carry out opening the serinette when the serinette is wound:
		start playing the tune.
		
	After opening the serinette when the serinette is unwound:
		say "Nothing happens. Looks like it must be wound first."
		
	Carry out closing the serinette when the serinette is wound:
		stop music.
	
	Test me with "x serinette / wind serinette / open serinette".


Example: * The Trampoline - Rewarding the player with a YouTube video.

This example adds an option for the player to watch a video on YouTube after they've won. Vorple plays the video automatically, and other interpreters show the URL of the video.

    *: "The Trampoline"

	Include Vorple Multimedia by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

	Table of Final Question Options (continued)
	final question wording	only if victorious	topic	final response rule	final response activity
	"WATCH your prize video"	true	"watch"	watch the video rule	--

	This is the watch the video rule:
		if Vorple is supported:
			play YouTube video "GifZWBxBDn8";
		otherwise:
			say "See your prize video at https://www.youtube.com/watch?v=GifZWBxBDn8."

	There is a room called On the trampoline. "You're on a huge trampoline. You know what to do!"

	Instead of jumping:
		end the story finally saying "Whee!"

	Test me with "jump / watch".


Example: ** Port Royal Reggae - Applying background music to different regions.

We'll spice up example 9 - Port Royal 3 with some background music.

When the player moves around the map the music will change according to the region they're in. We'll assign each region a music file, and the music changes only if the new room is in a different region than the one we just came from so that the same sound file won't start over when the player moves inside the same region. 

With small modifications the code could be used with individual rooms or scenes.

The first part is identical with Port Royal 3, example 10 in the Writing with Inform manual. Vorple-specific code starts from chapter 2 at the end.

The audio files used here can be downloaded from http://vorple-if.com/vorple/doc/inform7/examples/resources/music.

	*: "1691"
		
	Chapter 1 - World
	
	Fort James is a room. "The enclosure of Fort James is a large, roughly hexagonal court walled with heavy stone.  The walls face the entrance to Port Royal Harbour, and the battery of guns is prepared to destroy any enemy ship arriving."
	
	Thames Street End is south of Fort James. "The ill-named Thames Street runs from here -- at the point of the peninsula -- all the way east among houses and shops, through the Fish Market, edging by the round front of Fort Carlisle, to the point where the town stops and there is only sandy spit beyond.  Most of that stretch is full of people at all hours.  Imported goods are moved off of ships and taken to distributors; exported goods are brought to be loaded; and there is one public house and brothel for every ten inhabitants.[paragraph break]Lime Street, wider and healthier but not as rich, runs directly south, and to the north the road opens up into the courtyard of Fort James."	
	
	Lime Street is south of Thames Street End. West of Thames Street End is north of Fisher's Row. The description of Fisher's Row is "A waterfront street that runs south towards Chocolata Hole, where the small craft are harboured. It also continues north around the tip of the peninsula from here, turning into the east-west Thames Street."
	
	Thames Street End is down from Fort James. Up from Thames Street End is nowhere.
	
	Water Lane is east of Thames Street End. "Here Thames Street -- never very straight -- goes steeply southeast for a portion before continuing more directly to the east.
	
	Water Lane runs south toward Queen Street, and facing onto it is the New Prison -- which, in the way of these things, is neither.  It did serve in that capacity for a time, and in a measure of the villainy which has been usual in Port Royal from its earliest days, it is nearly the largest building in the town."
	
	
	East of Water Lane is a room called Thames Street at the Wherry Bridge.  Thames Street at the Wherry Bridge has the description "To the southwest is the fishmarket; directly across the street is the entrance to a private alley through a brick archway."
	
	The Fishmarket is southwest of Thames Street at the Wherry Bridge.
	
	The Private Alley is south of Thames Street at the Wherry Bridge. "You're just outside the tavern the Feathers. To the north, under a pretty little archway, is the active mayhem of Thames Street, but the alley narrows down to a dead end a little distance to the south."
	
	The Feathers is inside from the Private Alley.  "Newly built with brick, replacing the older Feathers tavern that used to stand here. It sells wines in quantity, as well as serving them directly, and the goods are always of the best quality. There's a room upstairs for those wanting to stay the night." The Feathers Bedroom is above the Feathers.
	
	Thames Street by the King's House is east of Thames Street at the Wherry Bridge.  "The King's House is reserved for the use of the Governor, but he does not live in it, and it is frequently being rented out to some merchant so that the government will at least derive some value from it. It is nearly the least interesting establishment on Thames Street, and the crowd -- which, to the west, is extremely dense -- here thins out a bit."
	
	Thames Street before Fort Carlisle is east of Thames Street by the King's House. "Here Thames Street, formerly a respectable width, narrows to a footpath in order to edge around the front of Fort Carlisle, underneath the mouths of the cannon.
	
	There are no buildings on the harbour side of Thames Street at this point, which means that you have an unusually good view of the ships at dock, water beyond, and the Blue Mountains rising on the other side of the harbour."
	
	
	South of Thames Street before Fort Carlisle is a room called Fort Carlisle. The description of Fort Carlisle is "Handsomely arrayed with cannons which you could fire at any moment -- though of course there are ships at dock which might be in the way."
	
	Queen Street End is south of Lime Street.
	
	Queen Street Middle is east of Queen Street End.
	
	
	Queen Street East is east of Queen Street Middle and south of Private Alley.
	
	Queen Street at the Prison is east of Queen Street East.
		
	Inland is a region. Queen Street End, Queen Street Middle, Queen Street East, Private Alley, Lime Street, and Queen Street at the Prison are in Inland.
	
	Waterfront is a region. Thames Street before Fort Carlisle, Thames Street by the King's House, Thames Street at the Wherry Bridge, Water Lane, Fishmarket, Fisher's Row, and Thames Street End are in Waterfront.
		
	Military Holdings is a region. Fort Carlisle and Fort James are in Military Holdings.
		
	Tavern is a region. It is in Inland. Feathers and Feathers Bedroom are in Tavern.
	
	
	Chapter 2 - Background music
	
	Include Vorple Multimedia by Juhana Leinonen.
	Release along with the "Vorple" interpreter.	

	Release along with the file "inland.mp3".
	Release along with the file "waterfront.mp3".
	Release along with the file "military.mp3".
	Release along with the file "tavern.mp3".
	
	A region has some text called the background audio.
	The current audio is text that varies.
	
	The background audio of Inland is "inland.mp3".
	The background audio of Waterfront is "waterfront.mp3".
	The background audio of Military Holdings is "wind.mp3".
	The background audio of Tavern is "tavern.mp3".
	
	Every turn when the map region of the location is not nothing and the background audio of the map region of the location is not the current audio and the background audio of the map region of the location is not "" (this is the play background audio rule):
		play music file background audio of the map region of the location, looping;
		now the current audio is the background audio of the map region of the location.
		
	[Every turn rules aren't run on the first turn so we'll run it manually.]
	When play begins (this is the start initial background audio rule):
		if the map region of the location is not nothing and the background audio of the map region of the location is not "":
			follow the play background audio rule.		

	Test me with "s / s / n / e / e / s / in".
