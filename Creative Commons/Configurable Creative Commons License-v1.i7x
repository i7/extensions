Version 1.2 of Configurable Creative Commons License by Creative Commons begins here.

"Allows easy implementation of a Creative Commons Public License of the author's choice."

Section 0 - Implement various Creative Commons license types

CC license type is a kind of value. The CC license types are undefined, by-nc-nd, by-nc-sa, by-nc, by-nd, by-sa, and by.

A CC license type has a text called CC license name.

The CC license name of undefined is "<Undefined>".
The CC license name of by-nc-nd is "Attribution-NonCommercial-NoDerivs [CC license variant]".
The CC license name of by-nc-sa is "Attribution-NonCommercial-ShareAlike [CC license variant]".
The CC license name of by-nc is "Attribution-NonCommercial [CC license variant]".
The CC license name of by-nd is "Attribution-NoDerivs [CC license variant]".
The CC license name of by-sa is "Attribution-ShareAlike [CC license variant]".
The CC license name of by is "Attribution [CC license variant]".

A CC license type has a text called expanded CC license name.

The expanded CC license name of undefined is "<Undefined>".
The expanded CC license name of by-nc-nd is "Attribution-Noncommercial-No Derivative Works [CC license variant]".
The expanded CC license name of by-nc-sa is "Attribution-Noncommercial-Share Alike [CC license variant]".
The expanded CC license name of by-nc is "Attribution-Noncommercial [CC license variant]".
The expanded CC license name of by-nd is "Attribution-No Derivative Works [CC license variant]".
The expanded CC license name of by-sa is "Attribution-Share Alike [CC license variant]".
The expanded CC license name of by is "Attribution [CC license variant]".

CC license variant is a text that varies. CC license variant is "3.0 Unported".

To decide whether (variant - a CC license type) specifies NoDerivs:
	if variant is by-nc-nd, decide yes;
	if variant is by-nd, decide yes;
	decide no.

Definition: a CC license type is ND if it specifies NoDerivs.

To decide whether (variant - a CC license type) specifies NonCommercial:
	if variant is by-nc-nd, decide yes;
	if variant is by-nc-sa, decide yes;
	if variant is by-nc, decide yes;
	decide no.

Definition: a CC license type is NC if it specifies NonCommercial.

To decide whether (variant - a CC license type) specifies ShareAlike:
	if variant is by-nc-sa, decide yes;
	if variant is by-sa, decide yes;
	decide no.

Definition: a CC license type is SA if it specifies ShareAlike.

To decide whether (variant - a CC license type) specifies Attribution:
	decide yes.

[Definition: a CC license type is BY if it specifies Attribution.] [Compiler didn't like this -- interferes with license types enumeration.]

Default CC license type is a CC license type that varies. Default CC license type is by-nc-sa.

CC license chosen is a CC license type that varies.

When play begins while CC license chosen is undefined (this is the apply default license if no type specified by author rule):
	now CC license chosen is the default CC license type.

Section 1G (for Glulx only)

[Look at first two characters in serial number array and kludgily convert to a YYYY year.]

Include (-

[ DeriveSerialNumberYear;
	return 2000+(ROM_GAMESERIAL->0-48)*10+(ROM_GAMESERIAL->1-48);
];

-)

Section 1Z (for Z-machine only)

[Look at first two characters in serial number array and kludgily convert to a YYYY year.]

Include (-

[ DeriveSerialNumberYear;
	return 2000+(HDR_GAMESERIAL->0-48)*10+(HDR_GAMESERIAL->1-48);
];

-)

Section - Special Characters

to say emdash:
	say "--";

to say list bullet:
	say "*";

to say copyright sign:
	say "(c)"

Section - Special Characters (for use with Unicode Full Character Names by Graham Nelson)

to say emdash:
	say "[unicode em dash]"

to say list bullet:
	say "[unicode bullet]"

to say copyright sign:
	say "[unicode copyright sign]"

Section 2a -Flag to allow suppression of extension warnings in non-release builds

Suppress CC license warnings is a truth state that varies. 

Section 2b - Warnings for values not defined that affect behavior - not for release

When play begins while CC license chosen is undefined and suppress CC license warnings is not true (this is the notify authors about autoset for license type rule):
	say "[bold type]*** NON-RELEASE VERSION WARNING ***[line break][italic type]You have not specified
	a Creative Commons license type in your source code. The Configurable Creative Commons License
	extension is assuming you wish to use the [CC license name of default CC license type] ([default CC license type])
	license. To change the type of license used by your work, set the [']CC license chosen['] CC license type
	provided by this extension to the desired license code in your source code, for example:[paragraph break]
	[fixed letter spacing][roman type]CC license chosen is by-nc.[italic type][bold type][variable letter spacing]
	[paragraph break]Additional information on CC license types can be found
	at:[paragraph break]          http://creativecommons.org/about/licenses/meet-the-licenses.[roman type][paragraph break]"

[ Resetting the story creation year is disabled as of 6E59, so the following block is no longer useful...
When play begins while suppress CC story creation year autoset is not true and story creation year is 0 and suppress CC license warnings is not true (this is the notify authors about autoset for story creation year rule):
	say "[bold type]*** NON-RELEASE VERSION WARNING ***[line break][italic type]The Configurable Creative Commons License
	extension is assuming the compilation year is equivalent to the story creation year, and is setting the
	story creation year accordingly. To suppress this behavior, set the [']suppress CC story creation year
	autoset['] truth value provided by this extension to true in your source code. If you explicitly set the
	story creation year in your source code, this warning will not be shown.[roman type][paragraph break]"
]

When play begins while copyright year string is empty and story creation year is 0 and suppress CC license warnings is not true (this is the warn authors if story creation year is not set rule):
	say "[bold type]*** NON-RELEASE VERSION WARNING ***[line break][italic type]The story creation
	year for this work has not been set. The copyright notice generated by the Configurable Creative Commons License extension
	will default to compilation year as the copyright year unless the author explicitly sets the story creation
	year in the source code, or the author explicitly sets the [']copyright year string['] text value provided
	by this extension in the source code.[roman type][paragraph break]"

When play begins while copyright holder is empty and suppress CC license warnings is not true (this is the warn authors if copyright holder is not set rule):
	say "[bold type]*** NON-RELEASE VERSION WARNING ***[line break][italic type]The author has not
	provided an explicit value for the copyright holder of this work, so the Configurable Creative Commons License extension is
	using the story author as a default value.[roman type][paragraph break]"

The apply default license if no type specified by author rule is listed after the notify authors about autoset for license type rule in the when play begins rules.

The copyright holder defaults to story author rule is listed after the warn authors if copyright holder is not set rule in the when play begins rules.

[ Resetting the story creation year is disabled as of 6E59, so the following block is no longer useful...
The automatically set story creation year if not suppressed rule is listed after the notify authors about autoset for story creation year rule in the when play begins rules.

The automatically set story creation year if not suppressed rule is listed before the warn authors if story creation year is not set rule in the when play begins rules.
]

The print CC deed on startup rule is listed after the warn authors if story creation year is not set rule in the when play begins rules.

The print CC deed on startup rule is listed after the warn authors if copyright holder is not set rule in the when play begins rules.

Section 3 - Set copyright holder as story author if not explicitly provided

Copyright holder is a text that varies.

When play begins while copyright holder is empty (this is the copyright holder defaults to story author rule), now copyright holder is the story author.

Section 4 - Set copyright year as compilation year if not explicitly provided

Assumed copyright year is a number that varies.

To decide what number is serial number year: (- DeriveSerialNumberYear(); -).

[ Resetting the story creation year is disabled as of 6E59, so the following block is no longer useful...
Suppress CC story creation year autoset is a truth state that varies.

When play begins (this is the automatically set story creation year if not suppressed rule):
	change assumed copyright year to serial number year;
	if suppress CC story creation year autoset is not true and story creation year is 0, change story creation year to assumed copyright year.
]

When play begins (this is the automatically set assumed copyright year rule):
	now assumed copyright year is serial number year.

Section 5 - Saying the copyright notice

Copyright year string is a text that varies. [deliberately left blank, author may set in story file if desired]

To say copyright notice:
	say "Copyright [copyright sign] [if copyright year string is not empty][copyright year string] [else if story creation year is not 0][story creation year] [else][assumed copyright year] [end if][copyright holder]".

Section 6 - Automated announcement at start of game

Suppress CC license banner is a truth state that varies.

Suppress CC deed on startup is a truth state that varies.

When play begins while suppress CC license banner is not true (this is the print CC deed on startup rule):
	say copyright notice;
	say "[line break]";
	if suppress CC deed on startup is true, say "This work is licensed under a Creative Commons
	[expanded CC license name of CC license chosen] License. For information about the Creative Commons
	Public License governing this work, type 'deed' at command prompt.";
	otherwise display the deed.

The print CC deed on startup rule is listed after the automatically set assumed copyright year rule in the when play begins rules.

Section 7 - License command

Requesting the license is an action out of world applying to nothing. Understand "license" as requesting the license.

Carry out requesting the license (this is the display CC license on request rule): display the license.

To display the license preface:
	say "[italic type]CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE LEGAL SERVICES.
	DISTRIBUTION OF THIS LICENSE DOES NOT CREATE AN ATTORNEY-CLIENT RELATIONSHIP. CREATIVE
	COMMONS PROVIDES THIS INFORMATION ON AN 'AS-IS' BASIS. CREATIVE COMMONS MAKES NO
	WARRANTIES REGARDING THE INFORMATION PROVIDED, AND DISCLAIMS LIABILITY FOR DAMAGES
	RESULTING FROM ITS USE.[roman type]"

To display the license header:
	say "[bold type][italic type]License[roman type]";
	say "[paragraph break]";
	say "THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
	('CCPL' OR 'LICENSE'). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF
	THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.";
	say "BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS
	OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS
	YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS."

To display the license section 1 common:
	say "[bold type]1. Definitions[roman type]";
	say "[paragraph break]";
	say "a. [bold type]'Adaptation'[roman type] means a work based upon the Work, or upon the Work and other pre-existing
	works, such as a translation, adaptation, derivative work, arrangement of music or other alterations of a literary or artistic
	work, or phonogram or performance and includes cinematographic adaptations or any other form in which the Work
	may be recast, transformed, or adapted including in any form recognizably derived from the original, except that a
	work that constitutes a Collection will not be considered an Adaptation for the purpose of this License. For the avoidance
	of doubt, where the Work is a musical work, performance or phonogram, the synchronization of the Work in timed-relation
	with a moving image ('synching') will be considered an Adaptation for the purpose of this License."

To display the license section 1 specific to (variant - a CC license type):
	say "[bold type][italic type]<ERROR: No section 1 portion specific to the Creative Commons license type currently in
	use ([CC license chosen]) has been provided.>[roman type]"

To display the license section 1 specific to (variant - by):
	say "b. [bold type]'Collection'[roman type] means a collection of literary or artistic works, such as encyclopedias and
	anthologies, or performances, phonograms or broadcasts, or other works or subject matter other than works listed in
	Section 1(f) below, which, by reason of the selection and arrangement of their contents, constitute intellectual creations,
	in which the Work is included in its entirety in unmodified form along with one or more other contributions, each constituting
	separate and independent works in themselves, which together are assembled into a collective whole. A work that constitutes
	a Collection will not be considered an Adaptation (as defined above) for the purposes of this License.";
	say "c. [bold type]'Distribute'[roman type] means to make available to the public the original and copies of the Work or Adaptation,
	as appropriate, through sale or other transfer of ownership.";
	say "d. [bold type]'Licensor'[roman type] means the individual, individuals, entity or entities that offer(s) the Work under the terms
	of this License.";
	say "e. [bold type]'Original Author'[roman type] means, in the case of a literary or artistic work, the individual, individuals, entity or
	entities who created the Work or if no individual or entity can be identified, the publisher; and in addition (i) in the case of a
	performance the actors, singers, musicians, dancers, and other persons who act, sing, deliver, declaim, play in, interpret or
	otherwise perform literary or artistic works or expressions of folklore; (ii) in the case of a phonogram the producer being the
	person or legal entity who first fixes the sounds of a performance or other sounds; and, (iii) in the case of broadcasts, the
	organization that transmits the broadcast.";
	say "f. [bold type]'Work'[roman type] means the literary and/or artistic work offered under the terms of this License including
	without limitation any production in the literary, scientific and artistic domain, whatever may be the mode or form of its
	expression including digital form, such as a book, pamphlet and other writing; a lecture, address, sermon or other work
	of the same nature; a dramatic or dramatico-musical work; a choreographic work or entertainment in dumb show; a musical
	composition with or without words; a cinematographic work to which are assimilated works expressed by a process analogous
	to cinematography; a work of drawing, painting, architecture, sculpture, engraving or lithography; a photographic work to which
	are assimilated works expressed by a process analogous to photography; a work of applied art; an illustration, map, plan, sketch
	or three-dimensional work relative to geography, topography, architecture or science; a performance; a broadcast; a phonogram;
	a compilation of data to the extent it is protected as a copyrightable work; or a work performed by a variety or circus performer
	to the extent it is not otherwise considered a literary or artistic work.";
	say "g. [bold type]'You'[roman type] means an individual or entity exercising rights under this License who has not previously violated
	the terms of this License with respect to the Work, or who has received express permission from the Licensor to exercise rights
	under this License despite a previous violation.";
	say "h. [bold type]'Publicly Perform'[roman type] means to perform public recitations of the Work and to communicate to the public
	those public recitations, by any means or process, including by wire or wireless means or public digital performances; to make
	available to the public Works in such a way that members of the public may access these Works from a place and at a place
	individually chosen by them; to perform the Work to the public by any means or process and the communication to the public of
	the performances of the Work, including by public digital performance; to broadcast and rebroadcast the Work by any means
	including signs, sounds or images.";
	say "i. [bold type]'Reproduce'[roman type] means to make copies of the Work by any means including without limitation by sound or
	visual recordings and the right of fixation and reproducing fixations of the Work, including storage of a protected performance or
	phonogram in digital form or other electronic medium."

To display the license section 1 specific to (variant - by-nc):
	say "b. [bold type]'Collection'[roman type] means a collection of literary or artistic works, such as encyclopedias and anthologies, or
	performances, phonograms or broadcasts, or other works or subject matter other than works listed in Section 1(f) below, which, by
	reason of the selection and arrangement of their contents, constitute intellectual creations, in which the Work is included in its entirety
	in unmodified form along with one or more other contributions, each constituting separate and independent works in themselves, which
	together are assembled into a collective whole. A work that constitutes a Collection will not be considered an Adaptation (as defined above)
	for the purposes of this License.";
	say "c. [bold type]'Distribute'[roman type] means to make available to the public the original and copies of the Work or Adaptation, as
	appropriate, through sale or other transfer of ownership.";
	say "d. [bold type]'Licensor'[roman type] means the individual, individuals, entity or entities that offer(s) the Work under the terms of this
	License.";
	say "e. [bold type]'Original Author'[roman type] means, in the case of a literary or artistic work, the individual, individuals, entity or entities
	who created the Work or if no individual or entity can be identified, the publisher; and in addition (i) in the case of a performance the actors,
	singers, musicians, dancers, and other persons who act, sing, deliver, declaim, play in, interpret or otherwise perform literary or artistic works
	or expressions of folklore; (ii) in the case of a phonogram the producer being the person or legal entity who first fixes the sounds of a
	performance or other sounds; and, (iii) in the case of broadcasts, the organization that transmits the broadcast.";
	say "f. [bold type]'Work'[roman type] means the literary and/or artistic work offered under the terms of this License including without limitation
	any production in the literary, scientific and artistic domain, whatever may be the mode or form of its expression including digital form, such as a
	book, pamphlet and other writing; a lecture, address, sermon or other work of the same nature; a dramatic or dramatico-musical work; a
	choreographic work or entertainment in dumb show; a musical composition with or without words; a cinematographic work to which are
	assimilated works expressed by a process analogous to cinematography; a work of drawing, painting, architecture, sculpture, engraving or
	lithography; a photographic work to which are assimilated works expressed by a process analogous to photography; a work of applied art; an
	illustration, map, plan, sketch or three-dimensional work relative to geography, topography, architecture or science; a performance; a broadcast;
	a phonogram; a compilation of data to the extent it is protected as a copyrightable work; or a work performed by a variety or circus performer to
	the extent it is not otherwise considered a literary or artistic work.";
	say "g. [bold type]'You'[roman type] means an individual or entity exercising rights under this License who has not previously violated the terms
	of this License with respect to the Work, or who has received express permission from the Licensor to exercise rights under this License despite a
	previous violation.";
	say "h. [bold type]'Publicly Perform'[roman type] means to perform public recitations of the Work and to communicate to the public those public
	recitations, by any means or process, including by wire or wireless means or public digital performances; to make available to the public Works in
	such a way that members of the public may access these Works from a place and at a place individually chosen by them; to perform the Work to
	the public by any means or process and the communication to the public of the performances of the Work, including by public digital performance;
	to broadcast and rebroadcast the Work by any means including signs, sounds or images.";
	say "i. [bold type]'Reproduce'[roman type] means to make copies of the Work by any means including without limitation by sound or visual
	recordings and the right of fixation and reproducing fixations of the Work, including storage of a protected performance or phonogram in digital
	form or other electronic medium."

To display the license section 1 specific to (variant - by-nd):
	say "b. [bold type]'Collection'[roman type] means a collection of literary or artistic works, such as encyclopedias and anthologies, or performances,
	phonograms or broadcasts, or other works or subject matter other than works listed in Section 1(f) below, which, by reason of the selection and
	arrangement of their contents, constitute intellectual creations, in which the Work is included in its entirety in unmodified form along with one or
	more other contributions, each constituting separate and independent works in themselves, which together are assembled into a collective whole.
	A work that constitutes a Collection will not be considered an Adaptation (as defined above) for the purposes of this License.";
	say "c. [bold type]'Distribute'[roman type] means to make available to the public the original and copies of the Work through sale or other transfer
	of ownership.";
	say "d. [bold type]'Licensor'[roman type] means the individual, individuals, entity or entities that offer(s) the Work under the terms of this License.";
	say "e. [bold type]'Original Author'[roman type] means, in the case of a literary or artistic work, the individual, individuals, entity or entities who
	created the Work or if no individual or entity can be identified, the publisher; and in addition (i) in the case of a performance the actors, singers,
	musicians, dancers, and other persons who act, sing, deliver, declaim, play in, interpret or otherwise perform literary or artistic works or expressions of
	folklore; (ii) in the case of a phonogram the producer being the person or legal entity who first fixes the sounds of a performance or other sounds; and,
	(iii) in the case of broadcasts, the organization that transmits the broadcast.";
	say "f. [bold type]'Work'[roman type] means the literary and/or artistic work offered under the terms of this License including without limitation any
	production in the literary, scientific and artistic domain, whatever may be the mode or form of its expression including digital form, such as a book,
	pamphlet and other writing; a lecture, address, sermon or other work of the same nature; a dramatic or dramatico-musical work; a choreographic work
	or entertainment in dumb show; a musical composition with or without words; a cinematographic work to which are assimilated works expressed by a
	process analogous to cinematography; a work of drawing, painting, architecture, sculpture, engraving or lithography; a photographic work to which are
	assimilated works expressed by a process analogous to photography; a work of applied art; an illustration, map, plan, sketch or three-dimensional work
	relative to geography, topography, architecture or science; a performance; a broadcast; a phonogram; a compilation of data to the extent it is protected
	as a copyrightable work; or a work performed by a variety or circus performer to the extent it is not otherwise considered a literary or artistic work.";
	say "g. [bold type]'You'[roman type] means an individual or entity exercising rights under this License who has not previously violated the terms of this
	License with respect to the Work, or who has received express permission from the Licensor to exercise rights under this License despite a previous violation.";
	say "h. [bold type]'Publicly Perform'[roman type] means to perform public recitations of the Work and to communicate to the public those public
	recitations, by any means or process, including by wire or wireless means or public digital performances; to make available to the public Works in such a
	way that members of the public may access these Works from a place and at a place individually chosen by them; to perform the Work to the public by any
	means or process and the communication to the public of the performances of the Work, including by public digital performance; to broadcast and
	rebroadcast the Work by any means including signs, sounds or images.";
	say "i. [bold type]'Reproduce'[roman type] means to make copies of the Work by any means including without limitation by sound or visual recordings
	and the right of fixation and reproducing fixations of the Work, including storage of a protected performance or phonogram in digital form or other
	electronic medium."

To display the license section 1 specific to (variant - by-sa):
	say "b. [bold type]'Collection'[roman type] means a collection of literary or artistic works, such as encyclopedias and anthologies, or performances,
	phonograms or broadcasts, or other works or subject matter other than works listed in Section 1(f) below, which, by reason of the selection and
	arrangement of their contents, constitute intellectual creations, in which the Work is included in its entirety in unmodified form along with one or
	more other contributions, each constituting separate and independent works in themselves, which together are assembled into a collective whole.
	A work that constitutes a Collection will not be considered an Adaptation (as defined below) for the purposes of this License.";
	say "c. [bold type]'Creative Commons Compatible License'[roman type] means a license that is listed at http://creativecommons.org/compatiblelicenses
	that has been approved by Creative Commons as being essentially equivalent to this License, including, at a minimum, because that license: (i) contains
	terms that have the same purpose, meaning and effect as the License Elements of this License; and, (ii) explicitly permits the relicensing of adaptations
	of works made available under that license under this License or a Creative Commons jurisdiction license with the same License Elements as this License.";
	say "d. [bold type]'Distribute'[roman type] means to make available to the public the original and copies of the Work or Adaptation, as appropriate,
	through sale or other transfer of ownership.";
	say "e. [bold type]'License Elements'[roman type] means the following high-level license attributes as selected by Licensor and indicated in the title
	of this License: Attribution, ShareAlike.";
	say "f. [bold type]'Licensor'[roman type] means the individual, individuals, entity or entities that offer(s) the Work under the terms of this License.";
	say "g. [bold type]'Original Author'[roman type] means, in the case of a literary or artistic work, the individual, individuals, entity or entities who created
	the Work or if no individual or entity can be identified, the publisher; and in addition (i) in the case of a performance the actors, singers, musicians, dancers,
	and other persons who act, sing, deliver, declaim, play in, interpret or otherwise perform literary or artistic works or expressions of folklore; (ii) in the case of
	a phonogram the producer being the person or legal entity who first fixes the sounds of a performance or other sounds; and, (iii) in the case of broadcasts,
	the organization that transmits the broadcast.";
	say "h. [bold type]'Work'[roman type] means the literary and/or artistic work offered under the terms of this License including without limitation any
	production in the literary, scientific and artistic domain, whatever may be the mode or form of its expression including digital form, such as a book,
	pamphlet and other writing; a lecture, address, sermon or other work of the same nature; a dramatic or dramatico-musical work; a choreographic work
	or entertainment in dumb show; a musical composition with or without words; a cinematographic work to which are assimilated works expressed by a
	process analogous to cinematography; a work of drawing, painting, architecture, sculpture, engraving or lithography; a photographic work to which are
	assimilated works expressed by a process analogous to photography; a work of applied art; an illustration, map, plan, sketch or three-dimensional work
	relative to geography, topography, architecture or science; a performance; a broadcast; a phonogram; a compilation of data to the extent it is protected
	as a copyrightable work; or a work performed by a variety or circus performer to the extent it is not otherwise considered a literary or artistic work.";
	say "i. [bold type]'You'[roman type] means an individual or entity exercising rights under this License who has not previously violated the terms of this
	License with respect to the Work, or who has received express permission from the Licensor to exercise rights under this License despite a previous violation.";
	say "j. [bold type]'Publicly Perform'[roman type] means to perform public recitations of the Work and to communicate to the public those public recitations,
	by any means or process, including by wire or wireless means or public digital performances; to make available to the public Works in such a way that
	members of the public may access these Works from a place and at a place individually chosen by them; to perform the Work to the public by any means
	or process and the communication to the public of the performances of the Work, including by public digital performance; to broadcast and rebroadcast
	the Work by any means including signs, sounds or images.";
	say "k. [bold type]'Reproduce'[roman type] means to make copies of the Work by any means including without limitation by sound or visual recordings
	and the right of fixation and reproducing fixations of the Work, including storage of a protected performance or phonogram in digital form or other
	electronic medium."

To display the license section 1 specific to (variant - by-nc-nd):
	say "b. [bold type]'Collection'[roman type] means a collection of literary or artistic works, such as encyclopedias and anthologies, or performances,
	phonograms or broadcasts, or other works or subject matter other than works listed in Section 1(f) below, which, by reason of the selection and
	arrangement of their contents, constitute intellectual creations, in which the Work is included in its entirety in unmodified form along with one or
	more other contributions, each constituting separate and independent works in themselves, which together are assembled into a collective whole.
	A work that constitutes a Collection will not be considered an Adaptation (as defined above) for the purposes of this License.";
	say "c. [bold type]'Distribute'[roman type] means to make available to the public the original and copies of the Work through sale or other transfer
	of ownership.";
	say "d. [bold type]'Licensor'[roman type] means the individual, individuals, entity or entities that offer(s) the Work under the terms of this License.";
	say "e. [bold type]'Original Author'[roman type] means, in the case of a literary or artistic work, the individual, individuals, entity or entities who created
	the Work or if no individual or entity can be identified, the publisher; and in addition (i) in the case of a performance the actors, singers, musicians,
	dancers, and other persons who act, sing, deliver, declaim, play in, interpret or otherwise perform literary or artistic works or expressions of folklore; (ii)
	in the case of a phonogram the producer being the person or legal entity who first fixes the sounds of a performance or other sounds; and, (iii) in the
	case of broadcasts, the organization that transmits the broadcast.";
	say "f. [bold type]'Work'[roman type] means the literary and/or artistic work offered under the terms of this License including without limitation any
	production in the literary, scientific and artistic domain, whatever may be the mode or form of its expression including digital form, such as a book,
	pamphlet and other writing; a lecture, address, sermon or other work of the same nature; a dramatic or dramatico-musical work; a choreographic
	work or entertainment in dumb show; a musical composition with or without words; a cinematographic work to which are assimilated works expressed
	by a process analogous to cinematography; a work of drawing, painting, architecture, sculpture, engraving or lithography; a photographic work to which
	are assimilated works expressed by a process analogous to photography; a work of applied art; an illustration, map, plan, sketch or three-dimensional work
	relative to geography, topography, architecture or science; a performance; a broadcast; a phonogram; a compilation of data to the extent it is protected
	as a copyrightable work; or a work performed by a variety or circus performer to the extent it is not otherwise considered a literary or artistic work.";
	say "g. [bold type]'You'[roman type] means an individual or entity exercising rights under this License who has not previously violated the terms of this
	License with respect to the Work, or who has received express permission from the Licensor to exercise rights under this License despite a previous
	violation.";
	say "h. [bold type]'Publicly Perform'[roman type] means to perform public recitations of the Work and to communicate to the public those public
	recitations, by any means or process, including by wire or wireless means or public digital performances; to make available to the public Works in such a
	way that members of the public may access these Works from a place and at a place individually chosen by them; to perform the Work to the public by any
	means or process and the communication to the public of the performances of the Work, including by public digital performance; to broadcast and
	rebroadcast the Work by any means including signs, sounds or images.";
	say "i. [bold type]'Reproduce'[roman type] means to make copies of the Work by any means including without limitation by sound or visual recordings
	and the right of fixation and reproducing fixations of the Work, including storage of a protected performance or phonogram in digital form or other
	electronic medium."

To display the license section 1 specific to (variant - by-nc-sa):
	say "b. [bold type]'Collection'[roman type] means a collection of literary or artistic works, such as encyclopedias and anthologies, or performances,
	phonograms or broadcasts, or other works or subject matter other than works listed in Section 1(g) below, which, by reason of the selection and
	arrangement of their contents, constitute intellectual creations, in which the Work is included in its entirety in unmodified form along with one or
	more other contributions, each constituting separate and independent works in themselves, which together are assembled into a collective whole.
	A work that constitutes a Collection will not be considered an Adaptation (as defined above) for the purposes of this License.";
	say "c. [bold type]'Distribute'[roman type] means to make available to the public the original and copies of the Work or Adaptation, as appropriate,
	through sale or other transfer of ownership.";
	say "d. [bold type]'License Elements'[roman type] means the following high-level license attributes as selected by Licensor and indicated in the title
	of this License: Attribution, Noncommercial, ShareAlike.";
	say "e. [bold type]'Licensor'[roman type] means the individual, individuals, entity or entities that offer(s) the Work under the terms of this License.";
	say "f. [bold type]'Original Author'[roman type] means, in the case of a literary or artistic work, the individual, individuals, entity or entities who
	created the Work or if no individual or entity can be identified, the publisher; and in addition (i) in the case of a performance the actors, singers,
	musicians, dancers, and other persons who act, sing, deliver, declaim, play in, interpret or otherwise perform literary or artistic works or expressions of
	folklore; (ii) in the case of a phonogram the producer being the person or legal entity who first fixes the sounds of a performance or other sounds; and,
	(iii) in the case of broadcasts, the organization that transmits the broadcast.";
	say "g. [bold type]'Work'[roman type] means the literary and/or artistic work offered under the terms of this License including without limitation any
	production in the literary, scientific and artistic domain, whatever may be the mode or form of its expression including digital form, such as a book,
	pamphlet and other writing; a lecture, address, sermon or other work of the same nature; a dramatic or dramatico-musical work; a choreographic work
	or entertainment in dumb show; a musical composition with or without words; a cinematographic work to which are assimilated works expressed by a
	process analogous to cinematography; a work of drawing, painting, architecture, sculpture, engraving or lithography; a photographic work to which are
	assimilated works expressed by a process analogous to photography; a work of applied art; an illustration, map, plan, sketch or three-dimensional work
	relative to geography, topography, architecture or science; a performance; a broadcast; a phonogram; a compilation of data to the extent it is protected
	as a copyrightable work; or a work performed by a variety or circus performer to the extent it is not otherwise considered a literary or artistic work.";
	say "h. [bold type]'You'[roman type] means an individual or entity exercising rights under this License who has not previously violated the terms of this
	License with respect to the Work, or who has received express permission from the Licensor to exercise rights under this License despite a previous
	violation.";
	say "i. [bold type]'Publicly Perform'[roman type] means to perform public recitations of the Work and to communicate to the public those public
	recitations, by any means or process, including by wire or wireless means or public digital performances; to make available to the public Works in such a
	way that members of the public may access these Works from a place and at a place individually chosen by them; to perform the Work to the public
	by any means or process and the communication to the public of the performances of the Work, including by public digital performance; to broadcast
	and rebroadcast the Work by any means including signs, sounds or images.";
	say "j. [bold type]'Reproduce'[roman type] means to make copies of the Work by any means including without limitation by sound or visual recordings
	and the right of fixation and reproducing fixations of the Work, including storage of a protected performance or phonogram in digital form or other
	electronic medium."

To display the license section 2 common:
	say "[bold type]2. Fair Dealing Rights.[roman type] Nothing in this License is intended to reduce, limit, or restrict any uses free from copyright or rights
	arising from limitations or exceptions that are provided for in connection with the copyright protection under copyright law or other applicable laws.";

To display the license section 3 common:
	say "[bold type]3. License Grant.[roman type] Subject to the terms and conditions of this License, Licensor hereby grants You a worldwide, royalty-free,
	non-exclusive, perpetual (for the duration of the applicable copyright) license to exercise the rights in the Work as stated below:"

To display the license section 3 specific to (variant - a CC license type):
	say "[bold type][italic type]<ERROR: No section 3 portion specific to the Creative Commons license type currently in
	use ([CC license chosen]) has been provided.>[roman type]"

To display the license section 3 specific to (variant - by):
	say "a.  to Reproduce the Work, to incorporate the Work into one or more Collections, and to Reproduce the Work as incorporated in the Collections;";
	say "[line break]";
	say "b. to create and Reproduce Adaptations provided that any such Adaptation, including any translation in any medium, takes reasonable steps to
	clearly label, demarcate or otherwise identify that changes were made to the original Work. For example, a translation could be marked 'The original
	work was translated from English to Spanish,' or a modification could indicate 'The original work has been modified.';";
	say "[line break]";
	say "c. to Distribute and Publicly Perform the Work including as incorporated in Collections; and,";
	say "[line break]";
	say "d. to Distribute and Publicly Perform Adaptations.";
	say "[line break]";
	say "e. For the avoidance of doubt:";
	say "[paragraph break]";
	say "i. [bold type]Non-waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any
	statutory or compulsory licensing scheme cannot be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by
	You of the rights granted under this License;";
	say "[line break]";
	say "ii. [bold type]Waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any
	statutory or compulsory licensing scheme can be waived, the Licensor waives the exclusive right to collect such royalties for any exercise by You
	of the rights granted under this License; and,";
	say "[line break]";
	say "iii. [bold type]Voluntary License Schemes.[roman type] The Licensor waives the right to collect royalties, whether individually or, in the event
	that the Licensor is a member of a collecting society that administers voluntary licensing schemes, via that society, from any exercise by You of the
	rights granted under this License.";
	say "[line break]";
	say "The above rights may be exercised in all media and formats whether now known or hereafter devised. The above rights include the right to make
	such modifications as are technically necessary to exercise the rights in other media and formats. Subject to Section 8(f), all rights not expressly
	granted by Licensor are hereby reserved."

To display the license section 3 specific to (variant - by-nc):
	say "a.  to Reproduce the Work, to incorporate the Work into one or more Collections, and to Reproduce the Work as incorporated in the Collections;";
	say "[line break]";
	say "b. to create and Reproduce Adaptations provided that any such Adaptation, including any translation in any medium, takes reasonable steps to
	clearly label, demarcate or otherwise identify that changes were made to the original Work. For example, a translation could be marked 'The original
	work was translated from English to Spanish,' or a modification could indicate 'The original work has been modified.';";
	say "[line break]";
	say "c. to Distribute and Publicly Perform the Work including as incorporated in Collections; and,";
	say "[line break]";
	say "d. to Distribute and Publicly Perform Adaptations.";
	say "[line break]";
	say "The above rights may be exercised in all media and formats whether now known or hereafter devised. The above rights include the right to make
	such modifications as are technically necessary to exercise the rights in other media and formats. Subject to Section 8(f), all rights not expressly granted
	by Licensor are hereby reserved, including but not limited to the rights set forth in Section 4(d)."

To display the license section 3 specific to (variant - by-nd):
	say "a.  to Reproduce the Work, to incorporate the Work into one or more Collections, and to Reproduce the Work as incorporated in the Collections;
	and,";
	say "[line break]";
	say "b. to Distribute and Publicly Perform the Work including as incorporated in Collections.";
	say "[line break]";
	say "c. For the avoidance of doubt:";
	say "[paragraph break]";
	say "i. [bold type]Non-waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any
	statutory or compulsory licensing scheme cannot be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You
	of the rights granted under this License;";
	say "[line break]";
	say "ii. [bold type]Waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory
	or compulsory licensing scheme can be waived, the Licensor waives the exclusive right to collect such royalties for any exercise by You of the rights
	granted under this License; and,";
	say "[line break]";
	say "iii. [bold type]Voluntary License Schemes.[roman type] The Licensor waives the right to collect royalties, whether individually or, in the event that
	the Licensor is a member of a collecting society that administers voluntary licensing schemes, via that society, from any exercise by You of the rights
	granted under this License.";
	say "[line break]";
	say "The above rights may be exercised in all media and formats whether now known or hereafter devised. The above rights include the right to make
	such modifications as are technically necessary to exercise the rights in other media and formats, but otherwise you have no rights to make Adaptations.
	Subject to Section 8(f), all rights not expressly granted by Licensor are hereby reserved."

To display the license section 3 specific to (variant - by-sa):
	display the license section 3 specific to by. [These are identical in version 3.0 Unported.]

To display the license section 3 specific to (variant - by-nc-nd):
	say "a.  to Reproduce the Work, to incorporate the Work into one or more Collections, and to Reproduce the Work as incorporated in the Collections;
	and,";
	say "[line break]";
	say "b. to Distribute and Publicly Perform the Work including as incorporated in Collections.";
	say "[line break]";
	say "The above rights may be exercised in all media and formats whether now known or hereafter devised. The above rights include the right to make
	such modifications as are technically necessary to exercise the rights in other media and formats, but otherwise you have no rights to make Adaptations.
	Subject to 8(f), all rights not expressly granted by Licensor are hereby reserved, including but not limited to the rights set forth in Section 4(d)."

To display the license section 3 specific to (variant - by-nc-sa):
	say "a.  to Reproduce the Work, to incorporate the Work into one or more Collections, and to Reproduce the Work as incorporated in the Collections;";
	say "[line break]";
	say "b. to create and Reproduce Adaptations provided that any such Adaptation, including any translation in any medium, takes reasonable steps to
	clearly label, demarcate or otherwise identify that changes were made to the original Work. For example, a translation could be marked 'The original
	work was translated from English to Spanish,' or a modification could indicate 'The original work has been modified.';";
	say "[line break]";
	say "c. to Distribute and Publicly Perform the Work including as incorporated in Collections; and,";
	say "[line break]";
	say "d. to Distribute and Publicly Perform Adaptations.";
	say "[line break]";
	say "The above rights may be exercised in all media and formats whether now known or hereafter devised. The above rights include the right to make
	such modifications as are technically necessary to exercise the rights in other media and formats. Subject to Section 8(f), all rights not expressly granted
	by Licensor are hereby reserved, including but not limited to the rights set forth in Section 4(e)." [Note 4e at end, only difference from by-nc variant in 3.0 Unported.]

To display the license section 4 common:
	say "[bold type]4. Restrictions.[roman type] The license granted in Section 3 above is expressly made subject to and limited by the following restrictions:"


To display the license section 4 specific to (variant - a CC license type):
	say "[bold type][italic type]<ERROR: No section 4 portion specific to the Creative Commons license type currently in
	use ([CC license chosen]) has been provided.>[roman type]"

To display the license section 4 specific to (variant - by):
	say "a. You may Distribute or Publicly Perform the Work only under the terms of this License. You must include a copy of, or the Uniform Resource Identifier
	(URI) for, this License with every copy of the Work You Distribute or Publicly Perform. You may not offer or impose any terms on the Work that restrict the
	terms of this License or the ability of the recipient of the Work to exercise the rights granted to that recipient under the terms of the License. You may not
	sublicense the Work. You must keep intact all notices that refer to this License and to the disclaimer of warranties with every copy of the Work You Distribute
	or Publicly Perform. When You Distribute or Publicly Perform the Work, You may not impose any effective technological measures on the Work that restrict
	the ability of a recipient of the Work from You to exercise the rights granted to that recipient under the terms of the License. This Section 4(a) applies to the
	Work as incorporated in a Collection, but this does not require the Collection apart from the Work itself to be made subject to the terms of this License. If
	You create a Collection, upon notice from any Licensor You must, to the extent practicable, remove from the Collection any credit as required by Section
	4(b), as requested. If You create an Adaptation, upon notice from any Licensor You must, to the extent practicable, remove from the Adaptation any credit
	as required by Section 4(b), as requested.";
	say "b. If You Distribute, or Publicly Perform the Work or any Adaptations or Collections, You must, unless a request has been made pursuant to Section 4(a),
	keep intact all copyright notices for the Work and provide, reasonable to the medium or means You are utilizing: (i) the name of the Original Author (or
	pseudonym, if applicable) if supplied, and/or if the Original Author and/or Licensor designate another party or parties (e.g., a sponsor institute, publishing
	entity, journal) for attribution ('Attribution Parties') in Licensor's copyright notice, terms of service or by other reasonable means, the name of such party or
	parties; (ii) the title of the Work if supplied; (iii) to the extent reasonably practicable, the URI, if any, that Licensor specifies to be associated with the Work,
	unless such URI does not refer to the copyright notice or licensing information for the Work; and (iv) , consistent with Section 3(b), in the case of an Adaptation,
	a credit identifying the use of the Work in the Adaptation (e.g., 'French translation of the Work by Original Author,' or 'Screenplay based on original Work by
	Original Author'). The credit required by this Section 4 (b) may be implemented in any reasonable manner; provided, however, that in the case of a Adaptation
	or Collection, at a minimum such credit will appear, if a credit for all contributing authors of the Adaptation or Collection appears, then as part of these credits
	and in a manner at least as prominent as the credits for the other contributing authors. For the avoidance of doubt, You may only use the credit required by
	this Section for the purpose of attribution in the manner set out above and, by exercising Your rights under this License, You may not implicitly or explicitly
	assert or imply any connection with, sponsorship or endorsement by the Original Author, Licensor and/or Attribution Parties, as appropriate, of You or Your
	use of the Work, without the separate, express prior written permission of the Original Author, Licensor and/or Attribution Parties.";
	say "c. Except as otherwise agreed in writing by the Licensor or as may be otherwise permitted by applicable law, if You Reproduce, Distribute or Publicly
	Perform the Work either by itself or as part of any Adaptations or Collections, You must not distort, mutilate, modify or take other derogatory action in
	relation to the Work which would be prejudicial to the Original Author's honor or reputation. Licensor agrees that in those jurisdictions (e.g. Japan), in which
	any exercise of the right granted in Section 3(b) of this License (the right to make Adaptations) would be deemed to be a distortion, mutilation, modification
	or other derogatory action prejudicial to the Original Author's honor and reputation, the Licensor will waive or not assert, as appropriate, this Section, to the
	fullest extent permitted by the applicable national law, to enable You to reasonably exercise Your right under Section 3(b) of this License (right to make
	Adaptations) but not otherwise."

To display the license section 4 specific to (variant - by-nc):
	say "a.  You may Distribute or Publicly Perform the Work only under the terms of this License. You must include a copy of, or the Uniform Resource Identifier
	(URI) for, this License with every copy of the Work You Distribute or Publicly Perform. You may not offer or impose any terms on the Work that restrict the
	terms of this License or the ability of the recipient of the Work to exercise the rights granted to that recipient under the terms of the License. You may not
	sublicense the Work. You must keep intact all notices that refer to this License and to the disclaimer of warranties with every copy of the Work You Distribute
	or Publicly Perform. When You Distribute or Publicly Perform the Work, You may not impose any effective technological measures on the Work that restrict
	the ability of a recipient of the Work from You to exercise the rights granted to that recipient under the terms of the License. This Section 4(a) applies to the
	Work as incorporated in a Collection, but this does not require the Collection apart from the Work itself to be made subject to the terms of this License. If You
	create a Collection, upon notice from any Licensor You must, to the extent practicable, remove from the Collection any credit as required by Section 4(c), as
	requested. If You create an Adaptation, upon notice from any Licensor You must, to the extent practicable, remove from the Adaptation any credit as required
	by Section 4(c), as requested.";
	say "b. You may not exercise any of the rights granted to You in Section 3 above in any manner that is primarily intended for or directed toward commercial
	advantage or private monetary compensation. The exchange of the Work for other copyrighted works by means of digital file-sharing or otherwise shall not
	be considered to be intended for or directed toward commercial advantage or private monetary compensation, provided there is no payment of any monetary
	compensation in connection with the exchange of copyrighted works.";
	say "c. If You Distribute, or Publicly Perform the Work or any Adaptations or Collections, You must, unless a request has been made pursuant to Section 4(a),
	keep intact all copyright notices for the Work and provide, reasonable to the medium or means You are utilizing: (i) the name of the Original Author (or
	pseudonym, if applicable) if supplied, and/or if the Original Author and/or Licensor designate another party or parties (e.g., a sponsor institute, publishing
	entity, journal) for attribution ('Attribution Parties') in Licensor's copyright notice, terms of service or by other reasonable means, the name of such party or
	parties; (ii) the title of the Work if supplied; (iii) to the extent reasonably practicable, the URI, if any, that Licensor specifies to be associated with the Work, unless
	such URI does not refer to the copyright notice or licensing information for the Work; and, (iv) consistent with Section 3(b), in the case of an Adaptation, a credit
	identifying the use of the Work in the Adaptation (e.g., 'French translation of the Work by Original Author,' or 'Screenplay based on original Work by Original
	Author'). The credit required by this Section 4(c) may be implemented in any reasonable manner; provided, however, that in the case of a Adaptation or
	Collection, at a minimum such credit will appear, if a credit for all contributing authors of the Adaptation or Collection appears, then as part of these credits
	and in a manner at least as prominent as the credits for the other contributing authors. For the avoidance of doubt, You may only use the credit required by
	this Section for the purpose of attribution in the manner set out above and, by exercising Your rights under this License, You may not implicitly or explicitly
	assert or imply any connection with, sponsorship or endorsement by the Original Author, Licensor and/or Attribution Parties, as appropriate, of You or Your
	use of the Work, without the separate, express prior written permission of the Original Author, Licensor and/or Attribution Parties.";
	say "[line break]";
	say "d. For the avoidance of doubt:";
	say "[paragraph break]";
	say "i. [bold type]Non-waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory
	or compulsory licensing scheme cannot be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You of the rights granted
	under this License;";
	say "[line break]";
	say "ii. [bold type]Waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory or
	compulsory licensing scheme can be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You of the rights granted
	under this License if Your exercise of such rights is for a purpose or use which is otherwise than noncommercial as permitted under Section 4(b) and otherwise
	waives the right to collect royalties through any statutory or compulsory licensing scheme; and,";
	say "[line break]";
	say "iii. [bold type]Voluntary License Schemes.[roman type] The Licensor reserves the right to collect royalties, whether individually or, in the event that the
	Licensor is a member of a collecting society that administers voluntary licensing schemes, via that society, from any exercise by You of the rights granted under
	this License that is for a purpose or use which is otherwise than noncommercial as permitted under Section 4(c).";
	say "[line break]";
	say "e. Except as otherwise agreed in writing by the Licensor or as may be otherwise permitted by applicable law, if You Reproduce, Distribute or Publicly Perform
	the Work either by itself or as part of any Adaptations or Collections, You must not distort, mutilate, modify or take other derogatory action in relation to the Work
	which would be prejudicial to the Original Author's honor or reputation. Licensor agrees that in those jurisdictions (e.g. Japan), in which any exercise of the right
	granted in Section 3(b) of this License (the right to make Adaptations) would be deemed to be a distortion, mutilation, modification or other derogatory action
	prejudicial to the Original Author's honor and reputation, the Licensor will waive or not assert, as appropriate, this Section, to the fullest extent permitted by the
	applicable national law, to enable You to reasonably exercise Your right under Section 3(b) of this License (right to make Adaptations) but not otherwise."

To display the license section 4 specific to (variant - by-nd):
	say "a.  You may Distribute or Publicly Perform the Work only under the terms of this License. You must include a copy of, or the Uniform Resource Identifier
	(URI) for, this License with every copy of the Work You Distribute or Publicly Perform. You may not offer or impose any terms on the Work that restrict the terms
	of this License or the ability of the recipient of the Work to exercise the rights granted to that recipient under the terms of the License. You may not sublicense
	the Work. You must keep intact all notices that refer to this License and to the disclaimer of warranties with every copy of the Work You Distribute or Publicly
	Perform. When You Distribute or Publicly Perform the Work, You may not impose any effective technological measures on the Work that restrict the ability of
	a recipient of the Work from You to exercise the rights granted to that recipient under the terms of the License. This Section 4(a) applies to the Work as incorporated
	in a Collection, but this does not require the Collection apart from the Work itself to be made subject to the terms of this License. If You create a Collection, upon
	notice from any Licensor You must, to the extent practicable, remove from the Collection any credit as required by Section 4(b), as requested.";
	say "b. If You Distribute, or Publicly Perform the Work or Collections, You must, unless a request has been made pursuant to Section 4(a), keep intact all copyright
	notices for the Work and provide, reasonable to the medium or means You are utilizing: (i) the name of the Original Author (or pseudonym, if applicable) if supplied,
	and/or if the Original Author and/or Licensor designate another party or parties (e.g., a sponsor institute, publishing entity, journal) for attribution ('Attribution Parties')
	in Licensor's copyright notice, terms of service or by other reasonable means, the name of such party or parties; (ii) the title of the Work if supplied; (iii) to the extent
	reasonably practicable, the URI, if any, that Licensor specifies to be associated with the Work, unless such URI does not refer to the copyright notice or licensing
	information for the Work. The credit required by this Section 4(b) may be implemented in any reasonable manner; provided, however, that in the case of a Collection,
	at a minimum such credit will appear, if a credit for all contributing authors of the Collection appears, then as part of these credits and in a manner at least as
	prominent as the credits for the other contributing authors. For the avoidance of doubt, You may only use the credit required by this Section for the purpose of
	attribution in the manner set out above and, by exercising Your rights under this License, You may not implicitly or explicitly assert or imply any connection with,
	sponsorship or endorsement by the Original Author, Licensor and/or Attribution Parties, as appropriate, of You or Your use of the Work, without the separate, express
	prior written permission of the Original Author, Licensor and/or Attribution Parties.";
	say "c. Except as otherwise agreed in writing by the Licensor or as may be otherwise permitted by applicable law, if You Reproduce, Distribute or Publicly Perform the
	Work either by itself or as part of any Collections, You must not distort, mutilate, modify or take other derogatory action in relation to the Work which would be
	prejudicial to the Original Author's honor or reputation."

To display the license section 4 specific to (variant - by-sa):
	say "a.  You may Distribute or Publicly Perform the Work only under the terms of this License. You must include a copy of, or the Uniform Resource Identifier
	(URI) for, this License with every copy of the Work You Distribute or Publicly Perform. You may not offer or impose any terms on the Work that restrict the
	terms of this License or the ability of the recipient of the Work to exercise the rights granted to that recipient under the terms of the License. You may not
	sublicense the Work. You must keep intact all notices that refer to this License and to the disclaimer of warranties with every copy of the Work You Distribute
	or Publicly Perform. When You Distribute or Publicly Perform the Work, You may not impose any effective technological measures on the Work that restrict
	the ability of a recipient of the Work from You to exercise the rights granted to that recipient under the terms of the License. This Section 4(a) applies to the
	Work as incorporated in a Collection, but this does not require the Collection apart from the Work itself to be made subject to the terms of this License. If
	You create a Collection, upon notice from any Licensor You must, to the extent practicable, remove from the Collection any credit as required by Section 4(c),
	as requested. If You create an Adaptation, upon notice from any Licensor You must, to the extent practicable, remove from the Adaptation any credit as
	required by Section 4(c), as requested.";
	say "b. You may Distribute or Publicly Perform an Adaptation only under the terms of: (i) this License; (ii) a later version of this License with the same License
	Elements as this License; (iii) a Creative Commons jurisdiction license (either this or a later license version) that contains the same License Elements as this
	License (e.g., Attribution-ShareAlike 3.0 US)); (iv) a Creative Commons Compatible License. If you license the Adaptation under one of the licenses mentioned
	in (iv), you must comply with the terms of that license. If you license the Adaptation under the terms of any of the licenses mentioned in (i), (ii) or (iii) (the
	'Applicable License'), you must comply with the terms of the Applicable License generally and the following provisions: (I) You must include a copy of, or the
	URI for, the Applicable License with every copy of each Adaptation You Distribute or Publicly Perform; (II) You may not offer or impose any terms on the
	Adaptation that restrict the terms of the Applicable License or the ability of the recipient of the Adaptation to exercise the rights granted to that recipient under
	the terms of the Applicable License; (III) You must keep intact all notices that refer to the Applicable License and to the disclaimer of warranties with every
	copy of the Work as included in the Adaptation You Distribute or Publicly Perform; (IV) when You Distribute or Publicly Perform the Adaptation, You may not
	impose any effective technological measures on the Adaptation that restrict the ability of a recipient of the Adaptation from You to exercise the rights granted
	to that recipient under the terms of the Applicable License. This Section 4(b) applies to the Adaptation as incorporated in a Collection, but this does not require
	the Collection apart from the Adaptation itself to be made subject to the terms of the Applicable License.";
	say "c. If You Distribute, or Publicly Perform the Work or any Adaptations or Collections, You must, unless a request has been made pursuant to Section 4(a),
	keep intact all copyright notices for the Work and provide, reasonable to the medium or means You are utilizing: (i) the name of the Original Author (or
	pseudonym, if applicable) if supplied, and/or if the Original Author and/or Licensor designate another party or parties (e.g., a sponsor institute, publishing entity,
	journal) for attribution ('Attribution Parties') in Licensor's copyright notice, terms of service or by other reasonable means, the name of such party or parties; (ii)
	the title of the Work if supplied; (iii) to the extent reasonably practicable, the URI, if any, that Licensor specifies to be associated with the Work, unless such URI
	does not refer to the copyright notice or licensing information for the Work; and (iv) , consistent with Ssection 3(b), in the case of an Adaptation, a credit
	identifying the use of the Work in the Adaptation (e.g., 'French translation of the Work by Original Author,' or 'Screenplay based on original Work by Original
	Author'). The credit required by this Section 4(c) may be implemented in any reasonable manner; provided, however, that in the case of a Adaptation or
	Collection, at a minimum such credit will appear, if a credit for all contributing authors of the Adaptation or Collection appears, then as part of these credits
	and in a manner at least as prominent as the credits for the other contributing authors. For the avoidance of doubt, You may only use the credit required by
	this Section for the purpose of attribution in the manner set out above and, by exercising Your rights under this License, You may not implicitly or explicitly
	assert or imply any connection with, sponsorship or endorsement by the Original Author, Licensor and/or Attribution Parties, as appropriate, of You or Your
	use of the Work, without the separate, express prior written permission of the Original Author, Licensor and/or Attribution Parties.";
	say "d. Except as otherwise agreed in writing by the Licensor or as may be otherwise permitted by applicable law, if You Reproduce, Distribute or Publicly
	Perform the Work either by itself or as part of any Adaptations or Collections, You must not distort, mutilate, modify or take other derogatory action in relation
	to the Work which would be prejudicial to the Original Author's honor or reputation. Licensor agrees that in those jurisdictions (e.g. Japan), in which any exercise
	of the right granted in Section 3(b) of this License (the right to make Adaptations) would be deemed to be a distortion, mutilation, modification or other
	derogatory action prejudicial to the Original Author's honor and reputation, the Licensor will waive or not assert, as appropriate, this Section, to the fullest extent
	permitted by the applicable national law, to enable You to reasonably exercise Your right under Section 3(b) of this License (right to make Adaptations) but not
	otherwise."

To display the license section 4 specific to (variant - by-nc-nd):
	say "a.  You may Distribute or Publicly Perform the Work only under the terms of this License. You must include a copy of, or the Uniform Resource Identifier
	(URI) for, this License with every copy of the Work You Distribute or Publicly Perform. You may not offer or impose any terms on the Work that restrict the
	terms of this License or the ability of the recipient of the Work to exercise the rights granted to that recipient under the terms of the License. You may not
	sublicense the Work. You must keep intact all notices that refer to this License and to the disclaimer of warranties with every copy of the Work You Distribute
	or Publicly Perform. When You Distribute or Publicly Perform the Work, You may not impose any effective technological measures on the Work that restrict
	the ability of a recipient of the Work from You to exercise the rights granted to that recipient under the terms of the License. This Section 4(a) applies to the
	Work as incorporated in a Collection, but this does not require the Collection apart from the Work itself to be made subject to the terms of this License. If You
	create a Collection, upon notice from any Licensor You must, to the extent practicable, remove from the Collection any credit as required by Section 4(c), as
	requested.";
	say "b. You may not exercise any of the rights granted to You in Section 3 above in any manner that is primarily intended for or directed toward commercial
	advantage or private monetary compensation. The exchange of the Work for other copyrighted works by means of digital file-sharing or otherwise shall not be
	considered to be intended for or directed toward commercial advantage or private monetary compensation, provided there is no payment of any monetary
	compensation in connection with the exchange of copyrighted works.";
	say "c. If You Distribute, or Publicly Perform the Work or Collections, You must, unless a request has been made pursuant to Section 4(a), keep intact all
	copyright notices for the Work and provide, reasonable to the medium or means You are utilizing: (i) the name of the Original Author (or pseudonym, if
	applicable) if supplied, and/or if the Original Author and/or Licensor designate another party or parties (e.g., a sponsor institute, publishing entity, journal)
	for attribution ('Attribution Parties') in Licensor's copyright notice, terms of service or by other reasonable means, the name of such party or parties; (ii) the
	title of the Work if supplied; (iii) to the extent reasonably practicable, the URI, if any, that Licensor specifies to be associated with the Work, unless such URI
	does not refer to the copyright notice or licensing information for the Work. The credit required by this Section 4(c) may be implemented in any reasonable
	manner; provided, however, that in the case of a Collection, at a minimum such credit will appear, if a credit for all contributing authors of Collection appears,
	then as part of these credits and in a manner at least as prominent as the credits for the other contributing authors. For the avoidance of doubt, You may only
	use the credit required by this Section for the purpose of attribution in the manner set out above and, by exercising Your rights under this License, You may
	not implicitly or explicitly assert or imply any connection with, sponsorship or endorsement by the Original Author, Licensor and/or Attribution Parties, as
	appropriate, of You or Your use of the Work, without the separate, express prior written permission of the Original Author, Licensor and/or Attribution Parties.";
	say "[line break]";
	say "d. For the avoidance of doubt:";
	say "[paragraph break]";
	say "i. [bold type]Non-waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory
	or compulsory licensing scheme cannot be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You of the rights granted
	under this License;";
	say "[line break]";
	say "ii. [bold type]Waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory or
	compulsory licensing scheme can be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You of the rights granted
	under this License if Your exercise of such rights is for a purpose or use which is otherwise than noncommercial as permitted under Section 4(b) and otherwise
	waives the right to collect royalties through any statutory or compulsory licensing scheme; and,";
	say "[line break]";
	say "iii. [bold type]Voluntary License Schemes.[roman type] The Licensor reserves the right to collect royalties, whether individually or, in the event that the
	Licensor is a member of a collecting society that administers voluntary licensing schemes, via that society, from any exercise by You of the rights granted
	under this License that is for a purpose or use which is otherwise than noncommercial as permitted under Section 4(b).";
	say "[line break]";
	say "e. Except as otherwise agreed in writing by the Licensor or as may be otherwise permitted by applicable law, if You Reproduce, Distribute or Publicly
	Perform the Work either by itself or as part of any Collections, You must not distort, mutilate, modify or take other derogatory action in relation to the Work
	which would be prejudicial to the Original Author's honor or reputation."

To display the license section 4 specific to (variant - by-nc-sa):
	say "a.  You may Distribute or Publicly Perform the Work only under the terms of this License. You must include a copy of, or the Uniform Resource Identifier
	(URI) for, this License with every copy of the Work You Distribute or Publicly Perform. You may not offer or impose any terms on the Work that restrict the terms
	of this License or the ability of the recipient of the Work to exercise the rights granted to that recipient under the terms of the License. You may not sublicense the
	Work. You must keep intact all notices that refer to this License and to the disclaimer of warranties with every copy of the Work You Distribute or Publicly Perform.
	When You Distribute or Publicly Perform the Work, You may not impose any effective technological measures on the Work that restrict the ability of a recipient of
	the Work from You to exercise the rights granted to that recipient under the terms of the License. This Section 4(a) applies to the Work as incorporated in a
	Collection, but this does not require the Collection apart from the Work itself to be made subject to the terms of this License. If You create a Collection, upon
	notice from any Licensor You must, to the extent practicable, remove from the Collection any credit as required by Section 4(d), as requested. If You create an
	Adaptation, upon notice from any Licensor You must, to the extent practicable, remove from the Adaptation any credit as required by Section 4(d), as requested.";
	say "b. You may Distribute or Publicly Perform an Adaptation only under: (i) the terms of this License; (ii) a later version of this License with the same License
	Elements as this License; (iii) a Creative Commons jurisdiction license (either this or a later license version) that contains the same License Elements as this
	License (e.g., Attribution-NonCommercial-ShareAlike 3.0 US) ('Applicable License'). You must include a copy of, or the URI, for Applicable License with every
	copy of each Adaptation You Distribute or Publicly Perform. You may not offer or impose any terms on the Adaptation that restrict the terms of the Applicable
	License or the ability of the recipient of the Adaptation to exercise the rights granted to that recipient under the terms of the Applicable License. You must keep
	intact all notices that refer to the Applicable License and to the disclaimer of warranties with every copy of the Work as included in the Adaptation You Distribute
	or Publicly Perform. When You Distribute or Publicly Perform the Adaptation, You may not impose any effective technological measures on the Adaptation that
	restrict the ability of a recipient of the Adaptation from You to exercise the rights granted to that recipient under the terms of the Applicable License. This Section
	4(b) applies to the Adaptation as incorporated in a Collection, but this does not require the Collection apart from the Adaptation itself to be made subject to the
	terms of the Applicable License.";
	say "c. You may not exercise any of the rights granted to You in Section 3 above in any manner that is primarily intended for or directed toward commercial
	advantage or private monetary compensation. The exchange of the Work for other copyrighted works by means of digital file-sharing or otherwise shall not be
	considered to be intended for or directed toward commercial advantage or private monetary compensation, provided there is no payment of any monetary
	compensation in con-nection with the exchange of copyrighted works.";
	say "d. If You Distribute, or Publicly Perform the Work or any Adaptations or Collections, You must, unless a request has been made pursuant to Section 4(a),
	keep intact all copyright notices for the Work and provide, reasonable to the medium or means You are utilizing: (i) the name of the Original Author (or
	pseudonym, if applicable) if supplied, and/or if the Original Author and/or Licensor designate another party or parties (e.g., a sponsor institute, publishing entity,
	journal) for attribution ('Attribution Parties') in Licensor's copyright notice, terms of service or by other reasonable means, the name of such party or parties; (ii)
	the title of the Work if supplied; (iii) to the extent reasonably practicable, the URI, if any, that Licensor specifies to be associated with the Work, unless such URI
	does not refer to the copyright notice or licensing information for the Work; and, (iv) consistent with Section 3(b), in the case of an Adaptation, a credit identifying
	the use of the Work in the Adaptation (e.g., 'French translation of the Work by Original Author,' or 'Screenplay based on original Work by Original Author'). The
	credit required by this Section 4(d) may be implemented in any reasonable manner; provided, however, that in the case of a Adaptation or Collection, at a minimum
	such credit will appear, if a credit for all contributing authors of the Adaptation or Collection appears, then as part of these credits and in a manner at least as
	prominent as the credits for the other contributing authors. For the avoidance of doubt, You may only use the credit required by this Section for the purpose of
	attribution in the manner set out above and, by exercising Your rights under this License, You may not implicitly or explicitly assert or imply any connection with,
	sponsorship or endorsement by the Original Author, Licensor and/or Attribution Parties, as appropriate, of You or Your use of the Work, without the separate, express
	prior written permission of the Original Author, Licensor and/or Attribution Parties.";
	say "[line break]";
	say "e. For the avoidance of doubt:";
	say "[paragraph break]";
	say "i. [bold type]Non-waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory or
	compulsory licensing scheme cannot be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You of the rights granted under
	this License;";
	say "[line break]";
	say "ii. [bold type]Waivable Compulsory License Schemes.[roman type] In those jurisdictions in which the right to collect royalties through any statutory or
	compulsory licensing scheme can be waived, the Licensor reserves the exclusive right to collect such royalties for any exercise by You of the rights granted under this
	License if Your exercise of such rights is for a purpose or use which is otherwise than noncommercial as permitted under Section 4(c) and otherwise waives the right to
	collect royalties through any statutory or compulsory licensing scheme; and,";
	say "[line break]";
	say "iii. [bold type]Voluntary License Schemes.[roman type] The Licensor reserves the right to collect royalties, whether individually or, in the event that the Licensor
	is a member of a collecting society that administers voluntary licensing schemes, via that society, from any exercise by You of the rights granted under this License
	that is for a purpose or use which is otherwise than noncommercial as permitted under Section 4(c).";
	say "[line break]";
	say "f. Except as otherwise agreed in writing by the Licensor or as may be otherwise permitted by applicable law, if You Reproduce, Distribute or Publicly Perform
	the Work either by itself or as part of any Adaptations or Collections, You must not distort, mutilate, modify or take other derogatory action in relation to the Work
	which would be prejudicial to the Original Author's honor or reputation. Licensor agrees that in those jurisdictions (e.g. Japan), in which any exercise of the right
	granted in Section 3(b) of this License (the right to make Adaptations) would be deemed to be a distortion, mutilation, modification or other derogatory action
	prejudicial to the Original Author's honor and reputation, the Licensor will waive or not assert, as appropriate, this Section, to the fullest extent permitted by the
	applicable national law, to enable You to reasonably exercise Your right under Section 3(b) of this License (right to make Adaptations) but not otherwise."

To display the license section 5 common:
	say "[bold type]5. Representations, Warranties and Disclaimer[roman type]";

To display the license section 5 specific to (variant - a CC license type):
	say "[bold type][italic type]<ERROR: No section 5 portion specific to the Creative Commons license type currently in
	use ([CC license chosen]) has been provided.>[roman type]"

To display the license section 5 specific to (variant - by):
	say "UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING, LICENSOR OFFERS THE WORK AS-IS AND MAKES NO REPRESENTATIONS OR
	WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES OF
	TITLE, MERCHANTIBILITY, FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY, OR
	THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES,
	SO SUCH EXCLUSION MAY NOT APPLY TO YOU."

To display the license section 5 specific to (variant - by-nc):
	display the license section 5 specific to by. [This text block is identical in version 3.0 Unported.]

To display the license section 5 specific to (variant - by-nd):
	display the license section 5 specific to by. [This text block is identical in version 3.0 Unported.]

To display the license section 5 specific to (variant - by-sa):
	display the license section 5 specific to by. [This text block is identical in version 3.0 Unported.]

To display the license section 5 specific to (variant - by-nc-nd):
	[Note the very minor deviation from 'by' template in phrasing "agreed by" vs. "agreed TO by". Probably a typo but just in case...]
	say "UNLESS OTHERWISE MUTUALLY AGREED BY THE PARTIES IN WRITING, LICENSOR OFFERS THE WORK AS-IS AND MAKES NO REPRESENTATIONS OR
	WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES
	OF TITLE, MERCHANTIBILITY, FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY,
	OR THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED
	WARRANTIES, SO SUCH EXCLUSION MAY NOT APPLY TO YOU."

To display the license section 5 specific to (variant - by-nc-sa):
	[note differences from 'by' template in "fullest extent permitted" phrase and also "this exclusion" vs. "such exclusion".]
	say "UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING AND TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, LICENSOR
	OFFERS THE WORK AS-IS AND MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR
	OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES OF TITLE, MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT,
	OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY, OR THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME
	JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES, SO THIS EXCLUSION MAY NOT APPLY TO YOU."

To display the license section 6 common:
	say "[bold type]6. Limitation on Liability.[roman type] EXCEPT TO THE EXTENT REQUIRED BY APPLICABLE LAW, IN NO EVENT WILL LICENSOR BE LIABLE TO
	YOU ON ANY LEGAL THEORY FOR ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL, PUNITIVE OR EXEMPLARY DAMAGES ARISING OUT OF THIS LICENSE OR
	THE USE OF THE WORK, EVEN IF LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."

To display the license section 7 common:
	say "[bold type]7. Termination[roman type]";
	say "[paragraph break]";
	say "a. This License and the rights granted hereunder will terminate automatically upon any breach by You of the terms of this License. Individuals or entities
	who have received [if CC license chosen is ND][else]Adaptations or [end if]Collections from You under this License, however, will not have their licenses
	terminated provided such individuals or entities remain in full compliance with those licenses. Sections 1, 2, 5, 6, 7, and 8 will survive any termination of
	this License.";
	say "b. Subject to the above terms and conditions, the license granted here is perpetual (for the duration of the applicable copyright in the Work).
	Notwithstanding the above, Licensor reserves the right to release the Work under different license terms or to stop distributing the Work at any time; provided,
	however that any such election will not serve to withdraw this License (or any other license that has been, or is required to be, granted under the terms of this
	License), and this License will continue in full force and effect unless terminated as stated above."

To display the license section 8 common:
	say "[bold type]8. Miscellaneous[roman type]";
	say "[paragraph break]";
	say "a. Each time You Distribute or Publicly Perform the Work or a Collection, the Licensor offers to the recipient a license to the Work on the same terms
	and conditions as the license granted to You under this License."

To display the license section 8 specific to (variant - a CC license type):
	say "[bold type][italic type]<ERROR: No section 8 portion specific to the Creative Commons license type currently in
	use ([CC license chosen]) has been provided.>[roman type]"

To display the license section 8 specific to (variant - by):
	say "b. Each time You Distribute or Publicly Perform an Adaptation, Licensor offers to the recipient a license to the original Work on the same terms and
	conditions as the license granted to You under this License.";
	say "c. If any provision of this License is invalid or unenforceable under applicable law, it shall not affect the validity or enforceability of the remainder of
	the terms of this License, and without further action by the parties to this agreement, such provision shall be reformed to the minimum extent necessary
	to make such provision valid and enforceable.";
	say "d. No term or provision of this License shall be deemed waived and no breach consented to unless such waiver or consent shall be in writing and
	signed by the party to be charged with such waiver or consent.";
	say "e. This License constitutes the entire agreement between the parties with respect to the Work licensed here. There are no understandings, agreements
	or representations with respect to the Work not specified here. Licensor shall not be bound by any additional provisions that may appear in any
	communication from You. This License may not be modified without the mutual written agreement of the Licensor and You.";
	say "f. The rights granted under, and the subject matter referenced, in this License were drafted utilizing the terminology of the Berne Convention for the
	Protection of Literary and Artistic Works (as amended on September 28, 1979), the Rome Convention of 1961, the WIPO Copyright Treaty of 1996, the WIPO
	Performances and Phonograms Treaty of 1996 and the Universal Copyright Convention (as revised on July 24, 1971). These rights and subject matter take
	effect in the relevant jurisdiction in which the License terms are sought to be enforced according to the corresponding provisions of the implementation
	of those treaty provisions in the applicable national law. If the standard suite of rights granted under applicable copyright law includes additional rights
	not granted under this License, such additional rights are deemed to be included in the License; this License is not intended to restrict the license of any
	rights under applicable law."

To display the license section 8 specific to (variant - by-nc):
	display the license section 8 specific to by. [These are identical in version 3.0 Unported.]

To display the license section 8 specific to (variant - by-nd):
	say "b. If any provision of this License is invalid or unenforceable under applicable law, it shall not affect the validity or enforceability of the remainder of
	the terms of this License, and without further action by the parties to this agreement, such provision shall be reformed to the minimum extent necessary
	to make such provision valid and enforceable.";
	say "c. No term or provision of this License shall be deemed waived and no breach consented to unless such waiver or consent shall be in writing and
	signed by the party to be charged with such waiver or consent.";
	say "d. This License constitutes the entire agreement between the parties with respect to the Work licensed here. There are no understandings, agreements
	or representations with respect to the Work not specified here. Licensor shall not be bound by any additional provisions that may appear in any
	communication from You. This License may not be modified without the mutual written agreement of the Licensor and You.";
	say "e. The rights granted under, and the subject matter referenced, in this License were drafted utilizing the terminology of the Berne Convention for the
	Protection of Literary and Artistic Works (as amended on September 28, 1979), the Rome Convention of 1961, the WIPO Copyright Treaty of 1996, the WIPO
	Performances and Phonograms Treaty of 1996 and the Universal Copyright Convention (as revised on July 24, 1971). These rights and subject matter take
	effect in the relevant jurisdiction in which the License terms are sought to be enforced according to the corresponding provisions of the implementation
	of those treaty provisions in the applicable national law. If the standard suite of rights granted under applicable copyright law includes additional rights
	not granted under this License, such additional rights are deemed to be included in the License; this License is not intended to restrict the license of any
	rights under applicable law."

To display the license section 8 specific to (variant - by-sa):
	display the license section 8 specific to by. [These are identical in version 3.0 Unported.]

To display the license section 8 specific to (variant - by-nc-nd):
	display the license section 8 specific to by-nd. [These are identical in version 3.0 Unported.]

To display the license section 8 specific to (variant - by-nc-sa):
	display the license section 8 specific to by. [These are identical in version 3.0 Unported.]

To display the license notice:
	say "[bold type][italic type]Creative Commons Notice[roman type]";
	say "[paragraph break]";
	say "[italic type]Creative Commons is not a party to this License, and makes no warranty whatsoever in connection with the Work. Creative Commons will
	not be liable to You or any party on any legal theory for any damages whatsoever, including without limitation any general, special, incidental or
	consequential damages arising in connection to this license. Notwithstanding the foregoing two (2) sentences, if Creative Commons has expressly identified
	itself as the Licensor hereunder, it shall have all rights and obligations of Licensor.";
	say "[line break]";
	say "Except for the limited purpose of indicating to the public that the Work is licensed under the CCPL, Creative Commons does not authorize the use by
	either party of the trademark 'Creative Commons' or any related trademark or logo of Creative Commons without the prior written consent of Creative
	Commons. Any permitted use will be in compliance with Creative Commons' then-current trademark usage guidelines, as may be published on its website
	or otherwise made available upon request from time to time. For the avoidance of doubt, this trademark restriction does not form part of this License.";
	say "[line break]";
	say "Creative Commons may be contacted at http://creativecommons.org/."


To display the license:
	display the license preface;
	say "[paragraph break]";
	display the license header;
	say "[line break]";
	display the license section 1 common;
	display the license section 1 specific to CC license chosen;
	say "[line break]";
	display the license section 2 common;
	say "[line break]";
	display the license section 3 common;
	say "[paragraph break]";
	display the license section 3 specific to CC license chosen;
	say "[line break]";
	display the license section 4 common;
	say "[paragraph break]";
	display the license section 4 specific to CC license chosen;
	say "[line break]";
	display the license section 5 common;
	say "[paragraph break]";
	display the license section 5 specific to CC license chosen;
	say "[line break]";
	display the license section 6 common;
	say "[line break]";
	display the license section 7 common;
	say "[line break]";
	display the license section 8 common;
	display the license section 8 specific to CC license chosen;
	say "[line break]";
	display the license notice.

Section 8 - Warranty command

Requesting the warranty is an action out of world applying to nothing. Understand "warranty" as requesting the warranty.

Carry out requesting the warranty (this is the display CC warranty on request rule): display the warranty.

To display the warranty:
	display the license section 5 specific to CC license chosen;
	say "[line break]";
	say "[italic type]The above warranty notice is from section 5 of the Creative Commons public license governing
	this work. You may view the entire license by typing the command 'license' at the prompt.[roman type]";
	say "[line break]".

Section 9 - Deed command

Requesting the deed is an action out of world applying to nothing. Understand "deed" as requesting the deed.

Carry out requesting the deed (this is the display CC deed on request rule): display the deed.

To display the deed:
	display the deed specific to CC license chosen.

To display the deed specific to (variant - a CC license type):
	say "This work is licensed under a Creative Commons [expanded CC license name of CC license chosen]
	License.";
	say "[line break]";
	say "[bold type]You are free:[roman type]";
	say "[paragraph break]";
	say "      [bold type]to Share[roman type] [emdash] to copy, distribute, and transmit the work";
	if variant is not ND
	begin;
		say "[paragraph break]";
		say "      [bold type]to Remix[roman type] [emdash] to adapt the work";
	end if;
	say "[paragraph break]";
	say "[bold type]Under the following conditions:[roman type]";
	say "[paragraph break]";
	say "      [bold type]Attribution[roman type] [emdash] You must attribute the work in the manner specified by the author
	or licensor (but not in any way that suggests that they endorse you or your use of the work).";
	if variant is NC
	begin;
		say "[line break]";
		say "      [bold type]Noncommercial[roman type] [emdash] You may not use this work for commercial purposes.";
	end if;
	if variant is ND
	begin;
		say "[line break]";
		say "      [bold type]No Derivative Works[roman type] [emdash] You may not alter, transform, or build upon this work.";
	end if;
	if variant is SA
	begin;
		say "[line break]";
		say "      [bold type]Share Alike[roman type] [emdash] If you alter, transform, or build upon this work, you may distribute
		the resulting work only under the [if variant is NC]same or similar license to this one[else]same, similar or a compatible license[end if].";
	end if;
	say "[line break]";
	say "[bold type]With the understanding that:[roman type]";
	say "[paragraph break]";
	say "      [bold type]Waiver[roman type] [emdash] Any of the above conditions can be [bold type]waived[roman type] if you get
	permission from the copyright holder.";
	say "[line break]";
	say "      [bold type]Public Domain[roman type] [emdash] Where the work or any of its elements is in the [bold type]public
	domain[roman type] under applicable law, that status is in no way affected by the license.";
	say "[line break]";
	say "      [bold type]Other Rights[roman type] [emdash] In no way are any of the following rights affected by the license:";
	say "[paragraph break]";
	say "            [list bullet] Your fair dealing or [bold type]fair use[roman type] rights, or other applicable copyright exceptions and
	limitations;";
	say "[paragraph break]";
	say "            [list bullet] The author's [bold type]moral[roman type] rights;";
	say "[paragraph break]";
	say "            [list bullet] Rights other persons may have either in the work itself or in how the work is used, such as
	[bold type]publicity[roman type] or privacy rights.";
	say "[line break]";
	say "      [bold type]Notice[roman type] [emdash] For any reuse or distribution, you must make clear to others the license terms
	of this work. The best way to do this is with a link to http://creativecommons.org/licenses/[CC license chosen]/3.0/";
	say "[paragraph break]";
	say "[italic type]The above 'deed' is a plain English outline of the rights
	and restrictions provided by the Creative Commons Public License governing this work. You may see it at any time
	by typing the command 'deed' at the prompt. To see the official license, type the command 'license' at the prompt.
	For warranty information, type the command 'warranty'.[roman type]";
	say "[line break]".

Section 10 - Self test - not for release

Test CC-License with "deed / license / warranty".


Configurable Creative Commons License ends here.

---- DOCUMENTATION ---- 

This extension is designed to make it easy to release your Inform 7 work under one of the several types of Creative
Commons Public License (CCPL). It is based on the information found at:

	http://creativecommons.org/about/licenses/meet-the-licenses

as of May 27, 2010.

This extension implements three commands:

	"license" - which displays the terms of the Creative Commons license you have selected
	"deed" - which displays a plain English outline of terms and conditions of the selected license
	"warranty" - which displays only the warranty portions of the terms

It also includes rules to display a copyright notice and a display of the "deed" on startup. The display of the deed
on startup may be suppressed by setting the 'suppress CC deed on startup' truth state provided by this extension
in your source code. If this flag is set, only the copyright notice and a note about how to display the deed will be
shown.

This extension offers customization of its function as follows:

	* The copyright notice displayed automatically includes the copyright year based on either the I7 'story creation
	year' variable (defined as part of bibliographic data) or the 'copyright year string' text provided in this extension.
	If both of these variables are left undefined, the compilation year will be used as the basis for determining the
	copyright year, and a warning will be printed at the start of a non-release build using this extension to notify the
	author. If both variables are defined, the 'copyright year string' will be displayed.

	* The copyright holder of a work may not be the same as the author. This extension includes a variable called
	'copyright holder' that the author may set explicitly, to have entities other than the author shown as the
	copyright holder in the copyright notice. If this variable is left undefined, a rule in the extension will set it to
	the story author by default, and a warning will be printed at the start of a non-release build using this extension
	to remind the author.

	* For authors who don't want to set the above variables but also don't want to see the warnings, a truth state
	variable called 'suppress CC license warnings' is provided by the extension. If the author sets this to true in
	the story source, these warnings will not be shown even in a non-release build.

	* The author may specify what type of CCPL is desired by setting the 'CC license chosen' variable to one of
	six predefined codes: by, by-nc, by-nd, by-sa, by-nc-nd, or by-nc-sa. See the URL at the start of this
	documentation for more information about the terms associated with each license type. If the author does
	not specify a license type, the Attribution-Noncommercial-ShareAlike (by-nc-sa) license will be used, and a
	warning will be printed at the start of a non-release build.

Before using, PLEASE NOTE: Creative Commons does not recommend the use of the CCPL for software.
However, although he is NOT A LAWYER, the writer of this extension believes a work of interactive fiction is
readily distinguishable from typical software due to the creative narrative elements that are essential to the
form. The CCPL is readily applicable to written fiction, and, at the very least, this extension's writer suspects
the license would be interpreted as being appropriate for these narrative elements. This extension's writer
also suspects that authors can extend this license to the programming art component of their work by
choosing to release the source code in a work incorporating the CCPL.