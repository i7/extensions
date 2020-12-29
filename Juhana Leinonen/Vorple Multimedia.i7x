Version 3/191119 of Vorple Multimedia (for Glulx only) by Juhana Leinonen begins here.

"Displaying images and playing sounds and music."

Include version 3 of Vorple by Juhana Leinonen.

Use authorial modesty.


Chapter 1 - Images

To place an/the/-- image (file - text) called (classes - text) with the/-- description (desc - text):
	if Vorple is supported:
		let id be unique identifier;
		place a block level element called "[id] vorple-image [classes]";
		execute JavaScript command "$('<img>', {src: vorple.file.resourceUrl('[escaped file]'), alt: '[escaped desc]'}).appendTo('.[id]')";
	otherwise:
		say desc;
		say line break.

To place an/the/-- image (file - text) called (classes - text) with the/-- description (desc - text), centered, aligned left, aligned right, floating left or floating right:
	let the alignment class be "";
	if centered, now the alignment class is "centered";
	if aligned left, now the alignment class is "left-aligned";
	if aligned right, now the alignment class is "right-aligned";
	if floating left, now the alignment class is "left-floating";
	if floating right, now the alignment class is "right-floating";
	place the image file called "[alignment class] [classes]" with description desc.

To place an/the/-- image (file - text) with the/-- description (desc - text), centered, aligned left, aligned right, floating left or floating right:
	let the alignment class be "";
	if centered, now the alignment class is "centered";
	if aligned left, now the alignment class is "left-aligned";
	if aligned right, now the alignment class is "right-aligned";
	if floating left, now the alignment class is "left-floating";
	if floating right, now the alignment class is "right-floating";
	place the image file called alignment class with description desc.

To preload an/the/-- image (file - text):
	execute JavaScript command "new Image().src=vorple.file.resourceUrl('[escaped file]');".
	
To preload the/-- images (image-list - list of text):
	repeat with X running through image-list:
		preload image X.


Chapter 2 - Audio

To play a/the/-- sound effect file/-- (file - text), looping:
	let loop-attr be "false";
	if looping:	
		now loop-attr is "true";
	execute JavaScript command "vorple.audio.playSound('[escaped file]', {looping: [loop-attr]})".

To play a/the/-- music file/-- (file - text), looping and/or always from the start:
	let loop-attr be "false";
	let restart-attr be "false";
	if looping:	
		now loop-attr is "true";
	if always from the start:
		now restart-attr is "true";
	execute JavaScript command "vorple.audio.playMusic('[escaped file]', {looping: [loop-attr], restart: [restart-attr]})";

To start a/the/-- playlist (playlist - list of text), looping and/or shuffled and/or always from the start:
	let files be playlist;
	let array be "[bracket]";
	let loop-attr be "false";
	let restart-attr be "false";
	let shuffled-attr be "false";
	if looping:
		now loop-attr is "true";
	if always from the start:
		now restart-attr is "true";
	if shuffled:
		now shuffled-attr is "true";
	repeat with filename running through files:
		now array is "[array]'[escaped filename]',";
	now array is "[array]''[close bracket]";
	execute JavaScript command "var pl=[array];pl.pop();vorple.audio.setPlaylist(pl, {looping: [loop-attr], restart: [restart-attr], shuffled: [shuffled-attr]})".

To clear the/-- playlist:
	execute JavaScript command "vorple.audio.clearPlaylist()".
	
To stop the/-- music:
	execute JavaScript command "vorple.audio.stopMusic()".

To stop all/-- sound effects:
	execute JavaScript command "$('.vorple-sound').remove()".

To stop all audio:
	execute JavaScript command "$('.vorple-sound').remove();vorple.audio.stopMusic()".

To decide whether music is playing:
	execute JavaScript command "return vorple.audio.isMusicPlaying()";
	if the JavaScript command returned true:
		decide on true;
	decide on false.

To decide whether a/any/-- sound effect/effects is/are playing:
	execute JavaScript command "return vorple.audio.isEffectPlaying()";
	if the JavaScript command returned true:
		decide on true;
	decide on false.

To decide whether an/any/-- audio is playing:
	execute JavaScript command "return vorple.audio.isAudioPlaying()";
	if the JavaScript command returned true:
		decide on true;
	decide on false.

To decide whether an/the/-- audio file called/-- (filename - text) is playing:
	execute JavaScript command "return vorple.audio.isElementPlaying('.vorple-audio[bracket]src=\'[escaped filename]\'[close bracket]')";
	if the JavaScript command returned true:
		decide on true;
	decide on false.
	
To decide which text is the/-- currently playing music file/--:
	execute JavaScript command "return vorple.audio.currentMusicPlaying()||''";
	decide on the text returned by the JavaScript command.

Vorple Multimedia ends here.


---- DOCUMENTATION ----


Chapter: Including media files

Media files (images and audio) should be declared in the story source so that Inform knows to include them in the release version.

	Release along with the file "whatever.png".

The files should be placed in the Materials directory, as per chapter 23.7. in Writing with Inform.

Note that we shouldn't use the "Figure of ..." or "Sound of ..." directives described in chapter 22 of Writing with Inform. Files declared this way won't be included correctly in the release folder.


Chapter: Images

Images can be displayed with the "place an image" phrase:

	place an image "pic.jpg" with the description "Example image";

The description is shown in standard interpreters instead of the picture and read aloud by screen readers, so it should be a compact but accurate description of what the image depicts. Especially if seeing the image is relevant to the story or to solving a puzzle, the description should give the same information to those who can't see the image.

By default the image is displayed left-aligned. The position can be changed by giving it as a parameter:

	place an image "pic.jpg" with the description "Example image", centered;

The possible values are centered, aligned left, aligned right, floating left or floating right. Floating means that the image is set to the left or to the right and the text is wrapped around it, in contrast to left or right aligned where the remaining space is left blank.

Images should be in jpg, png or gif format.

The images can be named by adding 'called "something"':

	place an image "pic.jpg" called "example" with the description "Example image";

Note that in HTML the image is wrapped in a div that receives the image's name as a class. The above code produces the following HTML:

	<div class="vorple-image example">
		<img src="pic.jpg" alt="Example image">
	</div>

Tip: When releasing the project, the file "Cover.jpg" or "Cover.png" is automatically included in the same place where other project files are. Therefore we can always show the cover image with:
	
	place an image "Cover.jpg" with the description "Cover image";


Section: Images from the Internet

The "place an image" phrase accepts direct web addresses of images as well:
	
	place an image "http://example.com/image.jpg";
	
Some important caveats:
	
- Things on the Internet tend to disappear over time: they get removed, moved, or the web site just ceases to exists. If you don't have control over the image source, it's better to just download the image and include it with other story resources - within the limits of copyright permissions, of course.

- Don't include an image as a link if you don't have a permission to do so! It's called 'hotlinking' and is generally frowned upon as it causes sometimes expensive traffic to the original web site. Furthermore the owner of the hotlinked web site might change the image to something else, which might be more than awkward to the author. This obviously doesn't include image sharing web sites that are explicitly meant for this kind of use.


Section: Preloading images

Images can be preloaded either individually or as a list:

	When play begins:
		preload image "pic.jpg";
		preload images { "pic1.jpg", "pic2.png" }.

Preloading images makes them appear immediately when they are later included on the page. Otherwise the images are loaded only when they are first displayed which may take some time with slower connections, resulting in a noticeable delay between when they should be shown and when they have loaded and actually appear.

Images must be preloaded inside a rule, most commonly in a When play begins rule. We can save bandwidth by preloading in later stages when the story is closer to the point when it should display the image, but note that starting to preload at the same time when the image is displayed is too late and preloading images that are shown right when the story begins is not useful.


Chapter: Audio

There are two types of audio: sound effects and music. The main difference is that multiple sound effects can be played at the same time, and at the same time as background music is playing. With music only one track can be playing at the same time, and starting to play another music file the previous one will stop.

Audio files should be in either mp3 or ogg format.

	play sound effect file "bang.mp3";
	play music file "horns.mp3";

By default the files are played once and then stopped. They can also be set to loop:

	play music file "background.mp3", looping;

Starting to play a music file that's already playing doesn't do anything other than set the looping status. In other words, if the file "mozart.mp3" is already playing and we try to play it again:

	play music file "mozart.mp3", looping;
	
...then nothing happens, except that when the music ends it starts to loop. Conversely, if we leave out the 'looping' option then the music will not loop when it ends, even if it was originally set to loop.

If we do want the music to always start playing from the beginning even when it's already playing, we can command:

	play music file "mozart.mp3", always from the start;

Starting a new music track while a different track is playing will fade out the old track before starting the new one. The old track fades out during one second and then waits another second to play the next one.

Once playing the sounds can be stopped with the following phrases:

	stop sound effects;
	stop music;
	stop all audio;

(Naturally stopping just the sound effects won't affect music, and vice versa.) Stopping music or all audio also clears the playlist (see the next chapter.)

Whether audio is currently playing can be tested with these phrases:
	
	if music is playing: ...
	if a sound effect is playing: ...
	if any audio is playing: ...
	if the audio file called "bigband.mp3" is playing: ...
	
An audio file is considered 'playing' even when it's still loading and hasn't actually started to play yet. 'If ... is playing' only checks for audio that is initiated by Vorple.

The currently playing music file can be retrieved with 'the currently playing music file':
	
	if the currently playing music file is "elvis.mp3": ...


Section: Audio restrictions in browsers

Due to restrictions set by most modern browsers, audio will not play unless the user has interacted with the page in some way, be it clicking or tapping on something or typing on the keyboard. This is to prevent ads and autoplaying videos from annoying the user, and mobile devices to preserve device battery.

This becomes an issue if we wish to start playing music immediately when the story starts. A workaround is to start playing only after the player has typed their first command, which works for most browsers and mobile devices.

	After reading a command when the turn count is 1:
		play music file "intro.mp3".

Another option is to make an intro screen (possibly with the Modal Windows extension) that forces the player to click a button or type a command to start the game and start playing the music.

The Safari browser on desktop Macs is extremely protective when it comes to playing sounds: it requires that the user initiates the sound directly (e.g. by pushing a button.) In Safari the above mentioned 'tricks' to get the music playing won't work and there is currently no workaround. 


Chapter: Playlists

Playlists are collections of music that automatically play one after another. Playlists can be started with the following phrase:
	
	start the playlist { "one.mp3", "two.mp3", "three.mp3" };
	
The file "one.mp3" starts to play, when it finishes "two.mp3" starts automatically, and finally after that "three.mp3" plays. If we want the playlist to repeat from the start after it has played the last track:

	start the playlist { "one.mp3", "two.mp3", "three.mp3" }, looping;
	
We can also play the list in a random order:

	start the playlist { "one.mp3", "two.mp3", "three.mp3" }, shuffled;
	
Both options can be used together, but a looping playlist is shuffled only once. When the playlist finishes and restarts again, it replays in the same order as the first time.

If the first track in the playlist is already playing at the same time when the playlist is started, the track will keep playing normally to the end and then continue from the second track in the playlist. Otherwise any music track that's playing will stop and the playlist will start immediately from the first item.

If a music file is played manually with the "play music file..." phrase while the playlist is running, the playlist will continue from the next track after the manually started music ends. Starting a new playlist while the previous one is playing will replace the old playlist with the new one.

The playlist can be cleared with:
	
	clear the playlist;
	
Clearing the playlist doesn't immediately stop the currently playing track. Unless instructed otherwise, the track will continue but doesn't start a new track when it ends. Stopping music with "stop the music" or "stop all audio" phrases clears the playlist automatically.

Note that the music system uses the playlist internally for queueing songs, so remember to clear the playlist before playing a new track or starting a new playlist.

In other words, don't do this as it won't work:

	play the music file called "new.mp3";
	clear the playlist;
	
Do this instead:

	clear the playlist;
	play the music file called "new.mp3";


Example: * Serinette - Basic example of playing music and sound effects.

The serinette (a type of music box) plays music when it opens and a sound effect when it's wound. We'll also show its picture when it's examined.

The example media files can be downloaded from https://vorple-if.com/resources.zip

	*: "Serinette"
	
	Include Vorple Multimedia by Juhana Leinonen.
	Release along with the "Vorple" interpreter.

	Release along with the file "winding.mp3".
	Release along with the file "musicbox.mp3".
	Release along with the file "serinette.jpg".

	Drawing room is a room. "The drawing room is tastefully decorated."

	The serinette is an openable closed container in the drawing room. "A beautiful music box sits on a table." The description is "There's a winding key behind the box."
	Understand "music" and "box" as the serinette.

	Before examining the serinette:
		place an image "serinette.jpg" with the description "A beautiful music box.", centered.

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
		if the serinette is open:
			say "(first closing the serinette)[command clarification break]";
			silently try closing the serinette;
		now the serinette is wound;
		play sound effect "winding.mp3".

	Report winding:
		say "You turn the winding key until it turns no more.";

	Instead of turning or winding the winding key:
		try winding the serinette.

	Instead of inserting something into the serinette:
		say "It's not the kind of box that can contain anything other than its own mechanism."

	Carry out opening the serinette when the serinette is wound:
		play music file "musicbox.mp3".

	After opening the serinette:
		if the serinette is unwound:
			say "Nothing happens. Looks like it must be wound first.";
		otherwise:
			now the serinette is unwound;
			continue the action.

	Carry out closing the serinette:
		stop the music.

	Test me with "x serinette / wind serinette / open serinette".



Example: ** Port Royal Reggae - Applying background music to different regions.

We'll spice up the Port Royal example from Writing with Inform with some background music.

When the player moves around the map the music will change according to the region they're in. We'll assign each region a music file, and the music changes only if the new room is in a different region than the one we just came from so that the same sound file won't start over when the player moves inside the same region. 

With small modifications the code could be used with individual rooms or scenes.

The first part is identical with the Port Royal 3 example in the Writing with Inform manual. Vorple-specific code starts from chapter 2 at the end.

The audio files used here can be downloaded from https://vorple-if.com/resources.zip

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
	Release along with the file "wind.mp3".
	Release along with the file "tavern.mp3".
	
	A region has some text called the background audio.
	The current region is a region that varies.
	
	The background audio of Inland is "inland.mp3".
	The background audio of Waterfront is "waterfront.mp3".
	The background audio of Military Holdings is "wind.mp3".
	The background audio of Tavern is "tavern.mp3".
	
	Every turn when the map region of the location is not nothing and the map region of the location is not the current region and the background audio of the map region of the location is not "" (this is the play background audio rule):
		play music file background audio of the map region of the location, looping;
		now the current region is the map region of the location.
		
	[Every turn rules aren't run on the first turn so we'll run it manually.]
	When play begins (this is the start initial background audio rule):
		if the map region of the location is not nothing and the background audio of the map region of the location is not "":
			follow the play background audio rule.		

	Test me with "s / s / n / e / e / s / in".
	
We could also set up playlists for each region instead of just one track.

	A region has a list of text called the background playlist.
	The current region is a region that varies.
	
	The background playlist of Inland is {"inland.mp3", "market.mp3"}.
	The background playlist of Waterfront is {"waterfront.mp3", "seagulls.mp3", "fishermen.mp3"}.
	The background playlist of Military Holdings is {"wind.mp3", "cannons.mp3"}.
	The background playlist of Tavern is {"tavern.mp3"}.
	
	Every turn when the map region of the location is not nothing and the map region of the location is not the current region and the background playlist of the map region of the location is not empty (this is the play background audio rule):
		start the playlist background playlist of the map region of the location, looping and shuffled;
		now the current region is the map region of the location.
		
	[Every turn rules aren't run on the first turn so we'll run it manually.]
	When play begins (this is the start initial background audio rule):
		if the map region of the location is not nothing and the background playlist of the map region of the location is not empty:
			follow the play background audio rule.		

(The tracks in the playlists are made up so unfortunately they're not included in the example resource package like the other tracks.)
