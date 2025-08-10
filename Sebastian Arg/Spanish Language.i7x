Version 2 of Spanish Language by Sebastian Arg begins here.

"To make Spanish the language of play. Release 230724"

"basada en InformATE! de Zak, con la contribución de toda la comunidad"

[Use authorial modesty.]

Volume 1 - Settings

[A language extension is required to set the following variable correctly:]

The language of play is the Spanish language.

[The following only needs to be done for inflected languages which distinguish
the genders -- which is why English doesn't do it.]

An object has a grammatical gender. [todo: revisar que esto haga falta]

[Inform initialises this property sensibly. We can easily check the results:

	When play begins:
		repeat with T running through things:
			say "[T] has [grammatical gender of T]."

By default, if Inform can't see any reason to choose a particular gender,
it will use neuter. We want to change that for French, since French doesn't
have neuter nouns:]


The grammatical gender of an object is usually masculine gender.
The grammatical gender of a woman is usually feminine gender.

A thing can be female. [for spanish: Habilita genero a inanimados, como containers, supporters, etc. Caracteristica necesaria en espanol]
A room can be female. [for spanish: Habilita genero a habitaciones. Caracteristica necesaria (a veces) en espanol, sobre todo al listar las habitaciones.]
A room can be plural-named or singular-named. [for spanish: al listar rooms como 'las Escaleras']

Section 1 SR Hack - Spanish Bibliographical Data (in place of Section 7 - Unindexed Standard Rules variables -  in Standard Rules by Graham Nelson)
[el 'is usually' no deja redefinir de nuevo por defecto las constantes, por lo que hay que hackearlo]

The story title, the story author, the story headline, the story genre
and the story description are text variables. [*****]
The release number and the story creation year are number variables. [**]

The release number is usually 1.
The story headline is usually "Un relato interactivo".
The story genre is usually "Ficción".

The story title variable translates into Inter as "Story".

Section 2 SR Hack - Others Hackings

[Para poner siempre el nombre de la habitaci?n con primera letra en mayuscula (johan mode):]

Carry out looking (this is the spanish room description heading rule):
	say bold type;
	if the visibility level count is 0:
		begin the printing the name of a dark room activity;
		if handling the printing the name of a dark room activity:
			say "Oscuridad" (A);
		end the printing the name of a dark room activity;
	otherwise if the visibility ceiling is the location:
		johan mode "[visibility ceiling]";
	otherwise:
		say "[The visibility ceiling]";
	say roman type;
	let intermediate level be the visibility-holder of the actor;
	repeat with intermediate level count running from 2 to the visibility level count:
		if the intermediate level is a supporter or the intermediate level is an animal:
			say " (sobre [the intermediate level])" (B);
		otherwise:
			say " (en [the intermediate level])" (C);
		let the intermediate level be the visibility-holder of the intermediate level;
	say line break;
	say run paragraph on with special look spacing.

The spanish room description heading rule is listed instead of the room description heading rule in the carry out looking rules. 

To johan mode (T - text):
	let X be the number of words in T;
	say word number 1 in T in sentence case;
	repeat with counter running from 2 to X:
		say " [word number counter in T]".


Section 3 SR Hack - Spanish People (in place of Section 11 - People in Standard Rules by Graham Nelson)
[el 'is usually' no deja redefinir las constantes, por lo que hay que hackearlo]

The specification of person is "A pesar de su nombre, no necesariamente se trata de un ser humano, sino de cualquier ente con las funciones necesarias como para interactuar con él."


A person can be female or male. A person is usually male.
A person can be neuter. A person is usually not neuter.

A person has a number called carrying capacity.
The carrying capacity of a person is usually 100.

A person can be transparent. A person is always transparent.

The yourself is an undescribed person. The yourself is proper-named.

The yourself is privately-named.
Understand "your former self" or "my former self" or "former self" or
	"former" as yourself when the player is not yourself.

[The description of yourself is usually "As good-looking as ever."]

Understand "tu antiguo yo" or "mi antiguo yo" or "antiguo yo" as yourself when the player is not yourself.

The description of yourself is usually "Tan buen aspecto como siempre."[infsp hacking]

The yourself object translates into Inter as "selfobj".

Volume 2 - Language

Part 2.1 - Determiners

Chapter 2.1.1 - Articles


To say el (O - object):
	say "[the O]".

To say un (O - object):
	say "[a O]".

To say El (O - object):
	say "[The O]".

To say Un (O - object):
	say "[A O]".


Part 2.2 - Nouns

Chapter 2.2.2 - Pronouns and possessives for the player 

[The adaptive text viewpoint is the viewpoint of the player when we are
writing response texts which need to work in any tense, person or number.
For example, English uses first person plural, so we write "[We] [look] up."
as a message which could come out as "I look up", "you look up", "he looks up",
and so on. It's "[We]" not "[You]" because the adaptive text viewpoint is
first person plural, not second person singular.

The reason for choosing this in English was that all the pronouns and
possessive adjectives we needed happened to be different for first person
plural: we, us, ours, ourselves, our. We also need these pronouns to be
other than third-person, so that we can define [they], [them] and so on
to refer to objects and not the player. So in practice there are only four
possible choices a language extension can make:

	first person singular (in English: I, me, mine, myself, my)
	second person plural (in English: you, you, yours, yourself, your)
	first person singular (in English: we, us, ours, ourselves, our)
	second person plural (in English: you, you, yours, yourself, your)

What shall we choose for French? We may as well use second person singular,
giving us tu, te, le tien/la tienne, te, ton. There are two complications.
Firstly we need indirect objects as well as direct objects, and although these
are the same in second person (te and te), they're different in third person
(le and lui). We'll call this "[te-lui]" for the same of this demonstration,
which is a bit awkward, but it'll do. Secondly, the reflexive pronoun is also
te, so we'll write that one "[te-se]".
Spanish: We use 2PS.
]

The adaptive text viewpoint of the Spanish language is second person singular.

[So now we define the following text substitutions:

French:[tu], [te], [te-lui], [te-se], [le tien], [ton]

Spanish: [tu], [ti], [tuyo], [le tien], [ton]

and their capitalised forms, which start with "T" not "t".]

[en general Poca gente menciona los sujetos expl?citamente en segunda persona.Al-K]

[Include Text Capture by Eric Eve.]

to say plm:[primera letra en may?scula]
	stop capturing text;
	say "[captured text]" in sentence case.

To say tu:
	now the prior named object is the player;[ object's identity is a value stored in "prior named object"]
	if the story viewpoint is third person singular:
		if the player is male:
			say " él";
		otherwise:
			say " ella";
	if the story viewpoint is third person plural:
		if the player is male:
			say " ellos";
		otherwise:
			say " ellas".
			

To say Tu:
	now the prior named object is the player;[ object's identity is a value stored in "prior named object"]
	if the story viewpoint is first person singular:
		start capturing text;
	if the story viewpoint is second person singular:
		start capturing text;
	if the story viewpoint is third person singular:
		if the player is male:
			say "Él";
		otherwise:
			say "Ella";
	if the story viewpoint is first person plural:
		start capturing text;
	if the story viewpoint is second person plural:
		start capturing text;	
	if the story viewpoint is third person plural:
		if the player is male:
			say "Ellos";
		otherwise:
			say "Ellas".



To say él:
	now the prior named object is the player;[ object's identity is a value stored in "prior named object"]
	if the story viewpoint is third person singular:
		if the player is male:
			say " él";
		otherwise:
			say " ella";
	if the story viewpoint is third person plural:
		if the player is male:
			say " ellos";
		otherwise:
			say " ellas".
			

To say Él:
	now the prior named object is the player;[ object's identity is a value stored in "prior named object"]
	if the story viewpoint is first person singular:
		start capturing text;
	if the story viewpoint is second person singular:
		start capturing text;
	if the story viewpoint is third person singular:
		if the player is male:
			say "Él";
		otherwise:
			say "Ella";
	if the story viewpoint is first person plural:
		start capturing text;
	if the story viewpoint is second person plural:
		start capturing text;	
	if the story viewpoint is third person plural:
		if the player is male:
			say "Ellos";
		otherwise:
			say "Ellas".


To say sí:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		say "mí";
	if the story viewpoint is second person singular:
		say "ti";
	if the story viewpoint is third person singular:
		say "sí";
	if the story viewpoint is first person plural:
		if the player is male:
			say "nosotros";
		otherwise:
			say "nosotras";
	if the story viewpoint is second person plural:
		say "vosotros";
	if the story viewpoint is third person plural:
		say "sí".

To say su:
	if the story viewpoint is third person singular:[ or the prior named object is singular:]
		say "su";
	otherwise if the story viewpoint is third person plural:[ plural or prior named object is plural:]
		say "su";
	otherwise if the story viewpoint is second person singular:
		say "tu";
	otherwise if the story viewpoint is second person plural:
		say "vuestro";
	otherwise if the story viewpoint is first person singular:
		say "mi";
	otherwise if the story viewpoint is first person plural:
		if prior named object is male:
			say "nuestro";
		otherwise:
			say "nuestra".

To say tuyo:
	if the story viewpoint is third person singular:[ or prior named object is singular:]
		if the prior named object is male:
			say "suyo";
		otherwise:
			say "suya";
	otherwise if the story viewpoint is third person plural:[ or prior named object is plural:]
		if the prior named object is male:
			say "suyos";
		otherwise:
			say "suyas";
	otherwise if the story viewpoint is second person singular:
		if the prior named object is male:
			say "tuyo";
		otherwise:
			say "tuya";
	otherwise if the story viewpoint is second person plural:
		if the prior named object is male:
			say "vuestro";
		otherwise:
			say "tuyas";
	otherwise if the story viewpoint is first person singular:
		if the prior named object is male:
			say "mío";
		otherwise:
			say "mía";
	otherwise if the story viewpoint is first person plural:
		if the prior named object is male:
			say "míos";
		otherwise:
			say "mías".

To say se:
	if the story viewpoint is third person singular:[ or prior named object is singular:]
		say "se";
	otherwise if the story viewpoint is third person plural:[ or prior named object is plural:]
		say "se";
	otherwise if the story viewpoint is second person singular:
		say "te";
	otherwise if the story viewpoint is second person plural:
		say "se";
	otherwise if the story viewpoint is first person singular:
		say "me";
	otherwise if the story viewpoint is first person plural:
		say "nos".

To say te:
	if the story viewpoint is third person singular:[ or prior named object is singular:]
		say "le";
	otherwise if the story viewpoint is third person plural:[ or prior named object is plural:]
		say "les";
	otherwise if the story viewpoint is second person singular:
		say "te";
	otherwise if the story viewpoint is second person plural:
		say "se";
	otherwise if the story viewpoint is first person singular:
		say "me";
	otherwise if the story viewpoint is first person plural:
		say "nos".

[para casos como:
>frotame
Frotas yourselfy.
]

To say ourselves:
	now the prior named object is the player;
	if the story viewpoint is first person singular:
		if the player is male:
			say "mi mismo";
		otherwise:
			say "mi misma";
	if the story viewpoint is second person singular:
		if the player is male:
			say "ti mismo";
		otherwise:
			say "ti misma";
	if the story viewpoint is third person singular:
		if the player is male:
			say "si mismo";
		otherwise:
			say "si misma";
	if the story viewpoint is first person plural:
		if the player is male:
			say "nosotros mismos";
		otherwise:
			say "nosotras mismas";
	if the story viewpoint is second person plural:
		if the player is male:
			say "ustedes mismos";
		otherwise:
			say "ustedes mismas";
	if the story viewpoint is third person plural:
		if the player is male:
			say "ellos mismos";
		otherwise:
			say "ellas mismas".


Section TC - Special functions extracted from Text Capture by Eric Eve (for use without Text Capture by Eric Eve) 

[according CC BY license]

Use maximum capture buffer length of at least 256 translates as (- Constant CAPTURE_BUFFER_LEN = {N}; -). 

To start capturing text:
	(- StartCapture(); -).

To stop capturing text:
	(- EndCapture(); -).

To say the/-- captured text:
	(- PrintCapture(); -).

Chapter 2.2.4 - Directions

[North translates into Spanish as el norte.
South translates into Spanish as el sur.
East translates into Spanish as el este.
West translates into Spanish as el oeste.
Northeast translates into Spanish as el noreste.
Southwest translates into Spanish as el suroeste.
Southeast translates into Spanish as el sureste.
Northwest translates into Spanish as el noroeste.
Inside translates into Spanish as dentro.
Outside translates into Spanish as fuera.
Up translates into Spanish as arriba.
Down translates into Spanish as abajo.][TODO: esto no compila]

The printed name of the south is "sur".
The printed name of the north is "norte".
The printed name of the east is "este".
The printed name of the west is "oeste".
The printed name of the northeast is "noreste".
The printed name of the northwest is "noroeste".
The printed name of the southeast is "sureste".
The printed name of the southwest is "suroeste".
The printed name of the inside is "dentro".
The printed name of the outside is "fuera".
The printed name of the up is "arriba".
The printed name of the down is "abajo".

Understand "norte" as north.
Understand "sur" as south.
Understand "este" as east.
Understand "o" , "oeste" as west.

Understand "no" , "noroeste" as northwest.
Understand "so" , "suroeste" as southwest.
Understand "sureste" as southeast.
Understand  "noreste" as northeast.
	
Understand "sube/techo/lado/cielo/asciende" as up.
Understand "b/baja/suelo/desciende" as down.
Understand "adentro" as inside. ['entra' no funciona aqui pues se superpone con verbo 'entra..']
Understand "afuera" as outside.

Up is proper-named.
Down is proper-named.
Inside is proper-named.
Outside is proper-named.

Volume 3 - Responses

Part 3.1 - Responses

Chapter 3.1.1 - Responses in the Standard Rules

[And now the responses from this extension. You can get a full set of these by
trying out any English source text, e.g.,

	The Amphitheatre is a room.

and then typing the command:

	RESPONSES SET 1

This produces text which can be pasted in here before being translated. I'm
only going to translate two, just for example's sake.]

[Verbos sin significados, solo para el texto adaptativo]
[In Spanish  llevar is a verb.
In Spanish  tener is a verb.
In Spanish  quitar is a verb.
In Spanish  poder is a verb.] [6m62: comentariado para hacerlo compilable. bug Mantis1817]


[TERMINACIONES SEGUN OBJETO]


To say o:
	say "[regarding the noun]";
	if prior named object is plural-named or the player is plural-named:
		if prior named object is female:
			say "as";
		otherwise:
			say "os";
	otherwise:
		if prior named object is female:
			say "a";
		otherwise:
			say "o".

To say o_jugador:
	say "[regarding the player]";
	if prior named object is plural-named or the player is plural-named:
		if prior named object is female:
			say "as";
		otherwise:
			say "os";
	otherwise:
		if prior named object is female:
			say "a";
		otherwise:
			say "o".


To say lo:
	say "[regarding the noun]";
	if prior named object is plural-named or the player is plural-named:
		if prior named object is female:
			say "las";
		otherwise:
			say "los";
	otherwise:
		if prior named object is female:
			say "la";
		otherwise:
			say "lo".

To say n:
	say "[regarding the noun]";
	if prior named object is the player:
		if the story viewpoint is first person singular or the story viewpoint is third person singular:
			say nothing;
		if the story viewpoint is second person singular:
			say "s";
		if the story viewpoint is first person plural:
			say "mos";
		if the story viewpoint is second person plural or the story viewpoint is third person plural:
			say "n";
	otherwise:
		if prior named object is plural-named:
			say "n".

To say s:
	say "[regarding the noun]";
	if prior named object is the player:
		if the story viewpoint is first person singular or the story viewpoint is third person singular:
			say nothing;
		if the story viewpoint is second person singular:
			say "s";
		if the story viewpoint is first person plural:
			say "mos";
		if the story viewpoint is second person plural or the story viewpoint is third person plural:
			say "n";
	otherwise:
		if prior named object is plural-named:
			say "s".

[DIALECTO SUDAMERICANO]

Use Dialecto Castellano translates as (- Global dialecto_sudamericano = 0; Constant DIALECTO_SPANISH; !Set to Castellano -).
Use Dialecto Sudamericano translates as (- Global dialecto_sudamericano = 1; Constant DIALECTO_SPANISH; !Set to Sudamericano -).

To decide if Dialecto Sudamericano: (- dialecto_sudamericano -).
To decide if Dialecto Castellano: (- dialecto_sudamericano==0 -).

[PreguntaCualExactamente]
To say set pregunta exacta: (- PreguntaCualExactamente=1; -).

[IniciarPregunta]
[en casos de comandos incompletos, para ajustar correctamente la preposicion usada]

To decide if no se inicia pregunta con preprosicion: (- IniciarPregunta()==0 -).

Section 3.1.1.1 - Standard actions concerning the actor's possessions

[Taking inventory , Taking , Removing it from , Dropping , Putting it on , Inserting it into , Eating ]


[ Taking inventory ]

    print empty inventory rule response (A) is "No llevas nada.". [6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
    print standard inventory rule response (A) is "[Tu] llevas[plm]:[line break]".[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
    report other people taking inventory rule response (A) is "[The actor] consulta su inventario.".

[ Taking ]

    can't take yourself rule response (A) is "Siempre te tienes a ti mism[o].".
    can't take other people rule response (A) is "No creo que [al noun] le[s] gustara[n].".
    can't take component parts rule response (A) is "[regarding the noun]Parece que es parte [del whole].".
    can't take people's possessions rule response (A) is "[regarding the noun]Parece que pertenece [al owner].".
    can't take items out of play rule response (A) is "[regarding the noun]No está[n] disponible[s].".
    can't take what you're inside rule response (A) is "[Tu] tienes que [if noun is a supporter]bajarte[otherwise]salirte[end if] primero.[plm]".[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
    can't take what's already taken rule response (A) is "Ya tienes [the noun].".[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
    can't take scenery rule response (A) is "Difícilmente puedes llevarte eso.".[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
    can only take things rule response (A) is "No puedes llevarte eso.".
    can't take what's fixed in place rule response (A) is "[The noun] está fij[o] en el sitio.".
    use player's holdall to avoid exceeding carrying capacity rule response (A) is "(colocas [the transferred item] en [the current working sack] para hacer sitio)[command clarification break]".
    can't exceed carrying capacity rule response (A) is "Ya llevas demasiadas cosas.".
    standard report taking rule response (A) is "[regarding the noun][if dialecto sudamericano]Tomad[o].[otherwise]Cogid[o].[end if]".
    standard report taking rule response (B) is "[The actor] [if dialecto sudamericano]toma[otherwise]coge[end if] [the noun].".


[ Removing it from ]

    can't remove what's not inside rule response (A) is "[regarding the noun]¡Pero si no está[n] ahí ahora!".
    can't remove from people rule response (A) is "[regarding the noun]Parece que pertenece [al owner].".


[ Dropping ]

    can't drop yourself rule response (A) is "No puedes hacer algo así.".
    can't drop body parts rule response (A) is "No puedes dejar una parte de ti.".
    can't drop what's already dropped rule response (A) is "[The noun] ya está[n] allí.".
    can't drop what's not held rule response (A) is "Para dejarl[o] deberías tenerl[o].".
    can't drop clothes being worn rule response (A) is "(primero te quitas [the noun])[command clarification break]".
    can't drop if this exceeds carrying capacity rule response (A) is "No hay más lugar sobre [the receptacle].".
    can't drop if this exceeds carrying capacity rule response (B) is "No hay más lugar en [the receptacle].".
    standard report dropping rule response (A) is "[regarding the noun]Dejad[o].".
    standard report dropping rule response (B) is "[The actor] deja [the noun].".


[ Putting it on ]

[    can't put what's not held rule response (A) is "Necesitas tener [the noun] para poder ponerl[o] donde sea.".][deprecated]
    can't put something on itself rule response (A) is "No puedes poner un objeto sobre sí mismo.".
    can't put onto what's not a supporter rule response (A) is "Poner cosas sobre [the second noun] no servirá de nada.".
    can't put clothes being worn rule response (A) is "(primero te [lo] quitas)[command clarification break]".
    can't put if this exceeds carrying capacity rule response (A) is "No queda sitio en [the second noun].".
    concise report putting rule response (A) is "Hecho.".
    standard report putting rule response (A) is "[if the actor is the player]Pones[otherwise][The actor] pone[end if] [the noun] sobre [the second noun].".


[ Inserting it into ]

    can't insert something into itself rule response (A) is "No puedes poner un objeto dentro de sí mismo.".
    can't insert into closed containers rule response (A) is "[The second noun] está[n] cerrad[o second noun].".
    can't insert into what's not a container rule response (A) is "No se pueden meter cosas dentro [del second noun].".
    can't insert clothes being worn rule response (A) is "(primero te [lo] quitas)[command clarification break]".
    can't insert if this exceeds carrying capacity rule response (A) is "No queda sitio en [the second noun].".
    concise report inserting rule response (A) is "Hecho.".
    standard report inserting rule response (A) is "[if the actor is the player]Pones[otherwise][The actor] pone[end if] [the noun] dentro [del second noun].".


[ Eating ]

    can't eat unless edible rule response (A) is "Eso es simplemente incomestible.".
    can't eat clothing without removing it first rule response (A) is "(primero te quitas [the noun])[command clarification break]".
    can't eat other people's food rule response (A) is "[Al owner] puede que no le guste.".
    standard report eating rule response (A) is "Te comes [the noun]. No está[n] mal.".
    standard report eating rule response (B) is "[The actor] se come [the noun].".

Section 3.1.1.2 - Standard actions which move the actor

[Going , Entering , Exiting , Getting off]


[ Going ]

    stand up before going rule response (A) is "(saliendo primero de [the chaise])[command clarification break]".
    can't travel in what's not a vehicle rule response (A) is "Tienes que bajarte [del nonvehicle] primero.".
    can't travel in what's not a vehicle rule response (B) is "Tienes que salirte [del nonvehicle] primero.".
    can't go through undescribed doors rule response (A) is "No puedes ir por ahí.".
    can't go through closed doors rule response (A) is "(abriendo primero [the door gone through])[command clarification break]".
    can't go that way rule response (A) is "No puedes ir por ahí.".
    can't go that way rule response (B) is "No puedes ir porque [the door gone through] no lleva a ningún sitio.".
    describe room gone into rule response (A) is "[The actor] se va hacia arriba".
    describe room gone into rule response (B) is "[The actor] se va hacia abajo".
    describe room gone into rule response (C) is "[The actor] se va hacia [the noun]".
    describe room gone into rule response (D) is "[The actor] llega desde arriba".
    describe room gone into rule response (E) is "[The actor] llega desde abajo".
    describe room gone into rule response (F) is "[The actor] llega desde [the opposite of the noun]".
    describe room gone into rule response (G) is "[The actor] llega".
    describe room gone into rule response (H) is "[The actor] llega a [the room gone to] desde arriba".
    describe room gone into rule response (I) is "[The actor] llega a [the room gone to] desde abajo".
    describe room gone into rule response (J) is "[The actor] llega a [the room gone to] desde [the opposite of the noun]".
    describe room gone into rule response (K) is "[The actor]  se va por [the noun]".
    describe room gone into rule response (L) is "[The actor] llega desde [the noun]".
    describe room gone into rule response (M) is "sobre [the vehicle gone by]".
    describe room gone into rule response (N) is "en [the vehicle gone by]".
    describe room gone into rule response (O) is ", llevando [the thing gone with] en frente, y a ti también".
    describe room gone into rule response (P) is ", llevando [the thing gone with] en frente".
    describe room gone into rule response (Q) is ", llevando [the thing gone with] ".
    describe room gone into rule response (R) is ", llevando [the thing gone with] en".
    describe room gone into rule response (S) is ", llevándote a ti también".


[ Entering ]

    can't enter what's already entered rule response (A) is "Pero si ya estás sobre [the noun].".
    can't enter what's already entered rule response (B) is "Pero si ya estás en [the noun].".
[    can't enter what's not enterable rule response (A) is "No es algo donde puedas stand on.".
    can't enter what's not enterable rule response (B) is "[regarding the noun][They're] not something [we] [can] sit down on.".
    can't enter what's not enterable rule response (C) is "[regarding the noun][They're] not something [we] [can] lie down on.".]
    can't enter what's not enterable rule response (D) is "No es algo donde puedas entrar.".
    can't enter closed containers rule response (A) is "No puedes entrar en [the noun] porque está[n] cerrad[o].".
    can't enter something carried rule response (A) is "No puedes entrar ahí mientras no lo sueltes.".
    implicitly pass through other barriers rule response (A) is "(te bajas [del holder of the actor])[command clarification break]".
    implicitly pass through other barriers rule response (B) is "(sales [del holder of the actor])[command clarification break]".
    implicitly pass through other barriers rule response (C) is "(te subes [al target])[command clarification break]".
    implicitly pass through other barriers rule response (D) is "(te metes en [the target])[command clarification break]".
    implicitly pass through other barriers rule response (E) is "(entras en [the target])[command clarification break]".
    standard report entering rule response (A) is "Te subes [al noun].".
    standard report entering rule response (B) is "Entras en [the noun].".
    standard report entering rule response (C) is "[if the actor is the player]Entras[otherwise][The actor] entra[end if] en [the noun].".
    standard report entering rule response (D) is "[if the actor is the player]Subes[otherwise][The actor] sube[end if] [al noun].".
    

[ Exiting ]

    can't exit when not inside anything rule response (A) is "No estás en ningún sitio del que debas salir.".
    can't exit closed containers rule response (A) is "No puedes salir [del cage] porque está cerrad[o cage].".
    standard report exiting rule response (A) is "Bajas [del container exited from].".
    standard report exiting rule response (B) is "Sales [del container exited from].".
    standard report exiting rule response (C) is "[if the actor is the player]Sales[otherwise][The actor] sale[end if] [del container exited from].".


[ Getting off ]

    can't get off things rule response (A) is "Pero si no estás en [the noun].".
    standard report getting off rule response (A) is "[if the actor is the player]Sales[otherwise][The actor] sale[end if] [del noun].".




Section 3.1.1.3 - Standard actions concerning the actor's vision

[Looking , Examining , Looking under , Searching , Consulting it about ]


[ Looking ]

    room description heading rule response (A) is "Oscuridad".
    room description heading rule response (B) is " (sobre [the intermediate level])".
    room description heading rule response (C) is " (en [the intermediate level])".
    room description body text rule response (A) is "Está muy oscuro y no puedes ver nada.".
    other people looking rule response (A) is "[The actor] mira alrededor.".


[ Examining ]

    examine directions rule response (A) is "No ves nada en especial al mirar en esa dirección.".
    examine containers rule response (A) is "En [the noun] ".
    examine containers rule response (B) is "[The noun] está[n] vací[o].".
    examine supporters rule response (A) is "Sobre [the noun] ".
    examine devices rule response (A) is "[The noun] está[n] [if the noun is switched on]encendid[o][otherwise]apagad[o][end if].".
    examine undescribed things rule response (A) is "No observas nada especial en [the noun].".
    report other people examining rule response (A) is "[The actor] mira de cerca [al noun].".


[ Looking under ]

    standard looking under rule response (A) is "No ves nada interesante.".
    report other people looking under rule response (A) is "[The actor] mira debajo [del noun].".


[ Searching ]

    can't search unless container or supporter rule response (A) is "No encuentras nada interesante.".
    can't search closed opaque containers rule response (A) is "No puedes ver lo que hay dentro [del noun] porque está[n] cerrado[s noun].".
    standard search containers rule response (A) is "En [the noun] ".
    standard search containers rule response (B) is "[The noun] está[n] vací[o].".
    standard search supporters rule response (A) is "Sobre [the noun] ".
    standard search supporters rule response (B) is "No hay nada sobre [the noun].".
    report other people searching rule response (A) is "[The actor] busca [al noun].".


[ Consulting it about ]

    block consulting rule response (A) is "No descubres nada interesante en [the noun] sobre este tema.".
    block consulting rule response (B) is "[The actor] consulta [the noun].".





Section 3.1.1.4 - Standard actions which change the state of things

[Locking it with , Unlocking it with , Switching on , Switching off , Opening , Closing , Wearing , Taking off ]

[------------------------------------------------------]
[Hasta aquí no se tuvo en cuenta texto adaptativo, (y despues tampoco)]


[ Locking it with ]

    can't lock without a lock rule response (A) is "[regarding the noun]No parece[n] tener ningún tipo de cerrojo.".
    can't lock what's already locked rule response (A) is "[regarding the noun][The noun] ya estaba cerrad[o].".
    can't lock what's open rule response (A) is "Primero [tu] tienes que cerrar [the noun].".[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
    can't lock without the correct key rule response (A) is "[regarding the second noun]No parece[n], encajar en la cerradura.".
    standard report locking rule response (A) is "Cierras [the noun].".
    standard report locking rule response (B) is "[The actor] cierra [the noun].".


[ Unlocking it with ]

can't unlock without a lock rule response (A) is "No [regarding the noun]parece[n] tener ningún tipo de cerrojo.".
can't unlock what's already unlocked rule response (A) is "[El noun] ya tenía abierto el cerrojo.".
can't unlock without the correct key rule response (A) is "No [regarding the second noun]parece[n] encajar en la cerradura.".
standard report unlocking rule response (A) is "[Tu] quitas el cerrojo [al noun].[plm]".[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
standard report unlocking rule response (B) is "[El actor] quita el cerrojo [al noun].".


[ Switching on ]

can't switch on unless switchable rule response (A) is "No es algo que pueda encenderse.".
can't switch on what's already on rule response (A) is "Ya [regarding the noun]estaba[n] encendid[o].".
standard report switching on rule response (A) is "[El actor] enciendes [el noun].".


[ Switching off ]

can't switch off unless switchable rule response (A) is "No es algo pueda apagarse.".
can't switch off what's already off rule response (A) is "Ya [regarding the noun] estaba apagad[o].".
standard report switching off rule response (A) is "[El actor] apaga [el noun].".


[ Opening ]

can't open unless openable rule response (A) is "No es algo que pueda abrirse.".
can't open what's locked rule response (A) is "[regarding the noun]Está[n] cerrad[o] con llave.".
can't open what's already open rule response (A) is "Ya [regarding the noun]esta[n] abiert[o].".
reveal any newly visible interior rule response (A) is "Abres [el noun], descubriendo ".
standard report opening rule response (A) is "Abres [el noun].".
standard report opening rule response (B) is "[El actor] abre [el noun].".
standard report opening rule response (C) is "[El noun] se abre.".


[ Closing ]

can't close unless openable rule response (A) is "No es algo que pueda cerrarse.".
can't close what's already closed rule response (A) is "Ya [regarding the noun]esta[n] cerrad[o].".
standard report closing rule response (A) is "Cierras [el noun].".
standard report closing rule response (B) is "[El actor] cierra [el noun].".
standard report closing rule response (C) is "[El noun] se cierra.".

[ Wearing ]

can't wear what's not clothing rule response (A) is "¡No puedes ponerte eso!".
can't wear what's not held rule response (A) is "¡No [regarding the noun]l[o] tienes!".
can't wear what's already worn rule response (A) is "¡Ya [regarding the noun]l[o] llevas puest[o]!".
standard report wearing rule response (A) is "Te pones [el noun].".
standard report wearing rule response (B) is "[El actor] se pone [el noun].".

[ Taking off ] [i6 Disrobe]

can't take off what's not worn rule response (A) is "No llevas puesto eso.".
can't exceed carrying capacity when taking off rule response (A) is "Llevas demasiadas cosas.".
standard report taking off rule response (A) is "Te quitas [el noun].".
standard report taking off rule response (B) is "[El actor] se quita [el noun].".




Section 3.1.1.5 - Standard actions concerning other people

[Giving it to , Showing it to , Waking , Throwing it at , Attacking , Kissing , Answering it that ,
Telling it about , Asking it about , Asking it for]

[ Giving it to ]

can't give what you haven't got rule response (A) is "No tienes [el noun].".
can't give to yourself rule response (A) is "No puedes darte [el noun] a tí mismo.".
can't give to a non-person rule response (A) is "[El second noun] no puede recibir cosas.".
can't give clothes being worn rule response (A) is "(primero te quitas [el noun])[command clarification break]".
block giving rule response (A) is "[El second noun] no parece[n second noun] interesad[o second noun].".
can't exceed carrying capacity when giving rule response (A) is "[El second noun] está[n] llevando demasiadas cosas.".
standard report giving rule response (A) is "Le das [el noun] [al second noun].".
standard report giving rule response (B) is "[El actor] te da [el second noun].".
standard report giving rule response (C) is "[El actor] da [el noun] [al second noun].".


[ Showing it to ]

can't show what you haven't got rule response (A) is "No tienes [el noun].".
block showing rule response (A) is "[El second noun] no muestra interés.".


[ Waking ]

block waking rule response (A) is "Eso parece innecesario.".


[ Throwing it at ]

implicitly remove thrown clothing rule response (A) is "(primero te quitas [el noun])[command clarification break]".
futile to throw things at inanimate objects rule response (A) is "No serviría de nada.".
block throwing at rule response (A) is "En el último momento te echas atrás.".


[ Attacking ]

block attacking rule response (A) is "La violencia no es la solución.".


[ Kissing ]

kissing yourself rule response (A) is "No conseguirás mucho con eso.".
block kissing rule response (A) is "[Al noun] podría no gustarle[s] eso.".


[ Answering it that ]

block answering rule response (A) is "No hay respuesta.".


[ Telling it about ]

telling yourself rule response (A) is "Hablas sol[o] durante un rato.".
block telling rule response (A) is "No has provocado ninguna reacción."


[ Asking it about ]
block asking rule response (A) is "No hay respuesta.".


[ Asking it for ]
[no tiene]




Section 3.1.1.6 - Standard actions which are checked but then do nothing unless rules intervene

[Waiting , Touching , Waving , Pulling , Pushing , Turning , Pushing it to , Squeezing ]

[ Waiting ]

standard report waiting rule response (A) is "El tiempo pasa...". [Pasa el tiempo...]
standard report waiting rule response (B) is "[El actor] deja pasar el tiempo.".


[ Touching ]

report touching yourself rule response (A) is "No logras nada con eso.". [?Las manos quietas!]
report touching yourself rule response (B) is "[El actor] se toca[n] a si mism[o].". [[El actor] se toca imp?dicamente.]
report touching other people rule response (A) is "[Al noun] podría no gustarle[s] eso.".
report touching other people rule response (B) is "[El actor] te toca[n].". [[El actor] no puede[n] reprimir el deseo de tocarte.]
report touching other people rule response (C) is "[El actor] toca[n] [el noun].".
report touching things rule response (A) is "No notas nada extraño al tacto.".
report touching things rule response (B) is "[El actor] toca[n] [el noun].".


[ Waving ]

can't wave what's not held rule response (A) is "Pero no [regarding the noun]l[o] tienes.". [No [regarding the noun]l[o] tienes.]
report waving things rule response (A) is "Agitas [el noun].". [Te sientes [regarding the noun]ridícul[o] agitando [el noun].]
report waving things rule response (B) is "[El actor] agita[n] [el noun].".


[ Pulling ]

can't pull what's fixed in place rule response (A) is "[regarding the noun]Está[n] firmemente sujet[o].".
can't pull scenery rule response (A) is "No eres capaz.".
can't pull people rule response (A) is "[Al noun] podría no gustarle[s] eso.". [Eso ser?a como poco maleducado.]
report pulling rule response (A) is "No ocurre nada, aparentemente.".
report pulling rule response (B) is "[El actor] tira[n] [del noun].".


[ Pushing ]

can't push what's fixed in place rule response (A) is "[regarding the noun]Está[n] firmemente sujet[o].".
can't push scenery rule response (A) is "No eres capaz.".
can't push people rule response (A) is "[Al noun] podría no gustarle[s] eso.".
report pushing rule response (A) is "No ocurre nada, aparentemente.".
report pushing rule response (B) is "[El actor] empuja[n] [el noun].".


[ Turning ]

can't turn what's fixed in place rule response (A) is "[regarding the noun]Está[n] firmemente sujet[o].".
can't turn scenery rule response (A) is "No eres capaz.".
can't turn people rule response (A) is "[Al noun] podría no gustarle[s] eso.".
report turning rule response (A) is "No ocurre nada, aparentemente.".
report turning rule response (B) is "[El actor] gira[n] [el noun].".


[ Pushing it to ]

can't push unpushable things rule response (A) is "[El noun] no puede[n] ser empujad[o] de un lugar a otro.". [No creo que empujar [el noun] sirva para nada.]
can't push to non-directions rule response (A) is "Eso no es una dirección.".
can't push vertically rule response (A) is "[El noun] no puede[n] ser empujad[o] hacia arriba o hacia abajo.". [?Ser?a lo mismo que levantar/bajar?]
can't push from within rule response (A) is "[El noun] no puede ser empujado desde aquí.".
block pushing in directions rule response (A) is "[El noun] no puede[n] ser empujad[o] de un lugar a otro.".


[ Squeezing ]

innuendo about squeezing people rule response (A) is "[Al noun] podría no gustarle[s] eso.".
report squeezing rule response (A) is "No logras nada con eso.".
report squeezing rule response (B) is "[El actor] retuerce[n] [el noun].".




Section 3.1.1.7 - Standard actions which always do nothing unless rules intervene

[Saying yes , Saying no , Burning , Waking up , Thinking , Smelling , Listening to , Tasting ,
Cutting , Jumping , Tying it to , Drinking , Saying sorry , Swinging , Rubbing , Setting it to ,
Waving hands , Buying , Climbing , Sleeping]

[ Saying yes ]
block saying yes rule response (A) is "Sólo era una pregunta retórica.".

[ Saying no ]
block saying no rule response (A) is "Sólo era una pregunta retórica.".

[ Burning ]
block burning rule response (A) is "Con esa peligrosa acción no lograrás nada.".

[ Waking up ]
block waking up rule response (A) is "La cruda realidad es que esto no es un sueño.".

[ Thinking ]
block thinking rule response (A) is "Vaya. Qué buena idea.".

[ Smelling ]
report smelling rule response (A) is "No hueles nada extraño.".
report smelling rule response (B) is "[El actor] huele el ambiente.".

[ Listening to ]
report listening rule response (A) is "No escuchas nada fuera de lo común.".
report listening rule response (B) is "[El actor] presta[n] atención a lo que escucha[n].".

[ Tasting ]
report tasting rule response (A) is "No saboreas nada raro.".
report tasting rule response (B) is "[El actor] saborea[n] [el noun].".

[ Cutting ]
block cutting rule response (A) is "[regarding the noun]Cortándol[o] no lograrás gran cosa.".

[ Jumping ]
report jumping rule response (A) is "Saltas en el sitio.". [Saltas en el sitio, sin ningún resultado.]
report jumping rule response (B) is "[El actor] salta[n] en el sitio".

[ Tying it to ]
block tying rule response (A) is "No lograrás nada con eso.".

[ Drinking ]
block drinking rule response (A) is "Eso no parece potable.". [?O es "No hay nada potable para beber aquí"?]

[ Saying sorry ]
block saying sorry rule response (A) is "Oh, no es necesario que te disculpes.".

[ Swinging ]
block swinging rule response (A) is "No [if noun is plural-named]son[otherwise]es[end if] [regarding the noun]adecuad[o] para columpiarse.".

[ Rubbing ]
can't rub another person rule response (A) is "[Al noun] podría[n] no gustarle[s] eso.".
report rubbing rule response (A) is "[if the noun is the actor]Te frotas[otherwise]Frotas[end if] [al noun].".
report rubbing rule response (B) is "[El actor] frota[n] [al noun].".

[ Setting it to ]
block setting it to rule response (A) is "Eso no puede setearse a ningún valor.".

[ Waving hands ]
report waving hands rule response (A) is "Ondeas las manos.".
report waving hands rule response (B) is "[El actor] ondea[n] las manos.".

[ Buying ]
block buying rule response (A) is "No hay nada en venta.".

[ Climbing ]
block climbing rule response (A) is "No creo que vayas a lograr nada así.".

[ Sleeping ]
block sleeping rule response (A) is "No estás especialmente somnolient[o_jugador].".
[block sleeping rule response (A) is "No estás especialmente somnolient[o].".]



Section 3.1.1.8 - Standard actions which happen out of world

[Quitting the game , Saving the game , Restoring the game , Restarting the game , Verifying the story file , Switching the story transcript on , Switching the story transcript off , Requesting the story file version , Requesting the score , Preferring abbreviated room descriptions , Preferring unabbreviated room descriptions , Preferring sometimes abbreviated room descriptions , Switching score notification on , Switching score notification off , Requesting the pronoun meanings ]


[Quitting the game ]
	quit the game rule response (A) is "¿Seguro que quieres abandonar el juego? ".
	

[ Saving the game ]
	save the game rule response (A) is "Error. No se pudo guardar.".
	save the game rule response (B) is "Ok.".


[ Restoring the game ]
	restore the game rule response (A) is "Error. No se pudo recuperar la partida.".
	restore the game rule response (B) is "Ok.".


[ Restarting the game ]
	restart the game rule response (A) is "¿Seguro que quieres reiniciar el juego? ".
	restart the game rule response (B) is "Error.".


[ Verifying the story file ]

	verify the story file rule response (A) is "Fichero de juego verificado e intacto.".
	verify the story file rule response (B) is "El fichero de juego no parece intacto, puede estar corrompido (a menos que estás jugando con un intérprete muy primitivo que no sea capaz de realizar la comprobación).".


[ Switching the story transcript off ]

switch the story transcript off rule response (A) is "La transcripción ya estaba desactivada.".
switch the story transcript off rule response (B) is "[line break]Fin de la transcripción.".
switch the story transcript off rule response (C) is "Intento fallido de finalización de transcripción.".

[ Requesting the story file version ]
[ ]


[ Requesting the score ]

announce the score rule response (A) is "[if the story has ended]En este relato, tu puntuación ha sido[otherwise]Hasta el momento tu puntuación es[end if] [score] de un total de [maximum score], en [turn count] turno[s]". [?Juego o historia? A veces es juego, otras veces historia (como la (c) abajo). No entiendo. Me decanto por 'relato']
announce the score rule response (B) is ", logrando el rango de ".
announce the score rule response (C) is "No hay puntuación en esta historia.". [Este juego no tiene conteo de puntuación.]
announce the score rule response (D) is "[bracket]Tu puntuación ha aumentado en [number understood in words] punto[s].[close bracket]".
announce the score rule response (E) is "[bracket]Tu puntuación ha disminuido en [number understood in words] punto[s].[close bracket]".


[ Preferring abbreviated room descriptions ]

standard report preferring abbreviated room descriptions rule response (A) is " está ahora en su modo 'superbreve', que siempre da descripciones cortas de los lugares (incluso si nunca habías estado antes).".


[ Preferring unabbreviated room descriptions ]

standard report preferring unabbreviated room descriptions rule response (A) is " está ahora en su modo 'largo', que siempre da descripciones largas de los lugares (incluso si ya habías estado antes).".


[ Preferring sometimes abbreviated room descriptions ]

standard report preferring sometimes abbreviated room descriptions rule response (A) is " está ahora en su modo normal 'breve', que da sólo descripciones largas de los lugares la primera vez que son visitados, y descripciones cortas en otro caso.".


[ Switching score notification on ]

standard report switching score notification on rule response (A) is "Notificación de puntuación activada.".


[ Switching score notification off ]

standard report switching score notification off rule response (A) is "Notificación de puntuación desactivada.".


[ Requesting the pronoun meanings ]

announce the pronoun meanings rule response (A) is "En este momento, ".
announce the pronoun meanings rule response (B) is "es ".
announce the pronoun meanings rule response (C) is "no está definido".
announce the pronoun meanings rule response (D) is "esta historia no conoce ningún pronombre.".


Chapter 3.1.2 - Responses in Basic Screen Effects (for use with Basic Screen Effects by Emily Short)

	Standard pausing the game rule response (A) is "[paragraph break]Presiona ESPACIO para continuar.".

Chapter 3.1.3 - Responses in Inanimate Listeners (for use with Inanimate Listeners by Emily Short)

	Unsuccessful persuasion of inanimate objects rule response (A) is "[The target] no puedes hacer todo lo que hace una persona.".




Part 3.2 - The Final Question

Table of Final Question Options (replaced)
final question wording	only if victorious	topic		final response rule		final response activity
"REINICIAR"				false				"reiniciar"	immediately restart the VM rule	--
"RECUPERAR un juego guardado"	false				"recuperar"	immediately restore saved game rule	--
"ver algunas CURIOSIDADES"	true	"curiosidades"	--	amusing a victorious player
"TERMINAR"					false				"terminar"		immediately quit rule	--
"hacer UNDO del último comando"		false				"undo"		immediately undo rule	--


Part 3.3 - Activities Rules Spanish Replacement
[Spanish-output replacement for some Activities from Standar Rules]

[Chapter 1 How commands are understood]

[ supplying a missing noun ]
block vaguely going rule response (A) is "Debes especificar en qué dirección ir.".

[ implicitly taking]
standard implicit taking rule response (A) is "(primero coges [the noun])[command clarification break]".
standard implicit taking rule response (B) is "([the second noun] primero coge [the noun])[command clarification break]".


[Chapter 2 How things are described]

[ printing the locale description]
you-can-also-see rule response (A) is "Puedes ".
you-can-also-see rule response (B) is "Sobre [the domain] puedes ".
you-can-also-see rule response (C) is "En [the domain] puedes ".
you-can-also-see rule response (D) is "ver también ".
you-can-also-see rule response (E) is "ver ".
you-can-also-see rule response (F) is "".

[ printing a locale paragraph about]
use initial appearance in room descriptions rule response (A) is "Sobre [the item] ".
describe what's on scenery supporters in room descriptions rule response (A) is "Sobre [the item] ".



[chapter 3 How accessibility is judged]

[ reaching inside]
can't reach inside rooms rule response (A) is "No llegas a [the noun].".
can't reach inside closed containers rule response (A) is "[The noun] no está abierto.".
can't reach outside closed containers rule response (A) is "[The noun] no está abierto.". 



[Chapter 4 The top level]

[ turn sequence rules]
generate action rule response (A) is "(solo considero los primeros dieciséis objetos)[command clarification break]".
generate action rule response (B) is "¡Nada para hacer!".
adjust light rule response (A) is "¡Está muy oscuro aquí!".

[ printing the player's obituary ]
print obituary headline rule response (A) is " Has muerto ".
print obituary headline rule response (B) is " Has ganado ".
print obituary headline rule response (C) is " Fin ".


[ handling the final question ]
print the final question rule response (A) is "¿Quieres ".
print the final question rule response (B) is " o ".
standard respond to final question rule response (A) is "por favor, responde a alguna de arriba.".



[Chapter 5 How actions are processed  ]

[ action-processing rules ]
basic visibility rule response (A) is "Está demasiado oscuro, no puedes ver nada.".
basic accessibility rule response (A) is "Debes decir algo más... concreto.".
requested actions require persuasion rule response (A) is "[The noun] tiene mejores cosas que hacer.".
carry out requested actions rule response (A) is "[The noun] no puede hace eso.".


[Chapter 6  List writer internal rule	]
    list writer internal rule response (A) is " (".
    list writer internal rule response (B) is ")".
    list writer internal rule response (C) is " y ".
    list writer internal rule response (D) is "alumbrando".
    list writer internal rule response (E) is "cerrad[o]".
    list writer internal rule response (F) is "[regarding the noun]vací[o]".
    list writer internal rule response (G) is "cerrad[o] y vací[o]".
    list writer internal rule response (H) is "cerrad[o] y alumbrando".
    list writer internal rule response (I) is "vací[o] y alumbrando".
    list writer internal rule response (J) is "cerrad[o], vací[o][if serial comma option is active],[end if] y alumbrando".
    list writer internal rule response (K) is "(alumbrando y que llevas puest[o]".
    list writer internal rule response (L) is "que llevas puest[o]".
    list writer internal rule response (M) is "abiert[o]".
    list writer internal rule response (N) is "abiert[o] y vací[o]".
    list writer internal rule response (O) is "cerrad[o]".
    list writer internal rule response (P) is "cerrad[o] con llave".
    list writer internal rule response (Q) is "que contiene".
    list writer internal rule response (R) is "[if the noun is a person]encima [del_ noun][otherwise]sobre[end if] [el_ noun]cual[s noun] ".
    list writer internal rule response (S) is ", [if the noun is a person]encima[otherwise]sobre[end if] [el_ noun]cual ".
    list writer internal rule response (T) is "[if the noun is a person]encima[otherwise]en[end if] [el_ noun]cual ".
    list writer internal rule response (U) is ", dentro ".
    list writer internal rule response (V) is "[es-ves]".
    list writer internal rule response (W) is "es nada".[todo:si se refiere a personas deberia decir 'es nadie']
    list writer internal rule response (X) is "Nada".
    list writer internal rule response (Y) is "nada".

To say es-ves:
	if the noun is a person:[la clase 'person' abarca man, women and animal]
		say "[regarding list writer internals]eres";[6m62: quitado el [verbo]para hacerlo compilable. bug Mantis1817]
	otherwise:
		say "ves".
    
[[regarding list writer internals]: (usado en list writer internal rule response (V) )
	*llama internamente a RegardingLWI() (ListWriter.i6t), que actualiza prior_named_list / prior_named_list_gender / prior_named_noun, utilizados luego por la sustituci?n [verbo] .
]

    

[Chapter 7 - Action processing internal rule]
    action processing internal rule response (A) is "[bracket]Esa orden se aplica fuera del juego, por lo que solo tiene sentido para el parser, no para [the noun].[close bracket]".
    action processing internal rule response (B) is "Debes mencionar un objeto en concreto".
    action processing internal rule response (C) is "No es necesario mencionar un objeto.".
    action processing internal rule response (D) is "Debes mencionar un objeto en concreto".
    action processing internal rule response (E) is "No es necesario mencionar un objeto.".
    action processing internal rule response (F) is "Debes mencionar el segundo objeto en concreto.".
    action processing internal rule response (G) is "Puedes no mencionar el segundo objeto.".
    action processing internal rule response (H) is "Debes mencionar el segundo objeto en concreto.".
    action processing internal rule response (I) is "Puedes no mencionar el segundo objeto.".
    action processing internal rule response (J) is "(Ya que ha ocurrido algo dramático, se ha recortado la lista de objetos sobre los que actuabas)".
    action processing internal rule response (K) is "Instrucción no comprendida.".
    
    
[Chapter 8 - Parser error internal rule]
    parser error internal rule response (A) is "No entendí esa frase.".
    parser error internal rule response (B) is "Intenta de nuevo, porque sólo te pude entender: ".
    parser error internal rule response (C) is "Intenta de nuevo, porque sólo te pude entender: (IR) ".    
    parser error internal rule response (D) is "No comprendí ese número.".
    parser error internal rule response (E) is "No veo eso que dices.".
    parser error internal rule response (F) is "¡Pareces haber dicho muy poca cosa!".
    parser error internal rule response (G) is "¡No tienes eso!".    
    parser error internal rule response (H) is "No puedes especificar objetos múltiples con ese verbo.".
    parser error internal rule response (I) is "Sólo puedes especificar objetos múltiples una vez en cada línea.".
    parser error internal rule response (J) is "No estoy seguro de a qué se refiere ['][pronoun i6 dictionary word]['].".
    parser error internal rule response (K) is "Ahora mismo no puedes ver lo que representa el pronombre ['][pronoun i6 dictionary word]['] ([the noun]).".    
    parser error internal rule response (L) is "Has exceptuado algo que no estaba incluido.".
    parser error internal rule response (M) is "Sólo puedes hacer eso con seres animados.".
    parser error internal rule response (N) is "No conozco ese verbo.".
    parser error internal rule response (O) is "Eso no es importante.".
    parser error internal rule response (P) is "No entendí la última parte de la orden.".
	parser error internal rule response (Q) is "[if number understood is 0]No hay suficientes [otherwise]Aquí sólo hay [number understood in words] [end if]disponibles.".
    parser error internal rule response (R) is "Ese objeto no tiene sentido en este contexto.".
    parser error internal rule response (S) is "Para repetir un comando como 'rana, salta', escribe 'repite', en lugar de 'rana, repite'.".
    parser error internal rule response (T) is "No puedes empezar la frase con una coma.".
    parser error internal rule response (U) is "Parece que quieres hablar con alguien, pero no veo con quién.".
    parser error internal rule response (V) is "No puedes hablar con [the noun].".
    parser error internal rule response (W) is "Para hablar con alguien intenta 'alguien, hola' o algo así.".
    parser error internal rule response (X) is "¿Perdón?".


    parser nothing error internal rule response (A) is "¡No encuentro nada para hacer eso!".
    parser nothing error internal rule response (B) is "No hay ninguno disponible.".
    parser nothing error internal rule response (C) is "Eso parece partenecer a [the noun].".
    parser nothing error internal rule response (D) is "Eso no puede contener cosas.".
    parser nothing error internal rule response (E) is "[The noun] está cerrado.".
    parser nothing error internal rule response (F) is "[The noun] está vacío.".

 
[Section  13 - Darkness name internal rule]
    darkness name internal rule response (A) is "Oscuridad".


[Section  14 - Parser command internal rule]
    parser command internal rule response (A) is "Lo siento, eso no puede corregirse.".
    parser command internal rule response (B) is "No te preocupes.".
    parser command internal rule response (C) is "'eepa' sólo puede corregir una palabra.".
    parser command internal rule response (D) is "No hay commando que repetir.".
    

[Section  15 - Parser clarification internal rule]
    parser clarification internal rule response (A) is "¿Quién concretamente [set pregunta exacta]".
    parser clarification internal rule response (B) is "¿Cuál concretamente, [set pregunta exacta]".
    parser clarification internal rule response (C) is "Lo siento, sólo puedes referirte a un objeto aquí. ¿Cuál exactamente?".
    parser clarification internal rule response (D) is "[if no se inicia pregunta con preprosicion]¿Qué[end if] [if the noun is not the player][the noun] tiene que[otherwise]quieres[end if] [parser command so far]?[set pregunta exacta]".
    parser clarification internal rule response (E) is "[if no se inicia pregunta con preprosicion]¿Qué[end if] [if the noun is not the player][the noun] tiene que[otherwise]quieres[end if] [parser command so far]?[set pregunta exacta]".
    parser clarification internal rule response (F) is "esas cosas".
    parser clarification internal rule response (G) is "eso".
    parser clarification internal rule response (H) is " o ".


[Section  16 - Yes or no question internal rule]
    yes or no question internal rule response (A) is "Por favor responde sí o no.".

[Section  17 - Print protagonist internal rule]
    print protagonist internal rule response (A) is "[We]".
    print protagonist internal rule response (B) is "[ourselves]".
    print protagonist internal rule response (C) is "[our] anterior tú".

[Section  18 - Standard implicit taking rule]
    standard implicit taking rule response (A) is "(primero coges [the noun])[command clarification break]".
    standard implicit taking rule response (B) is "([the second noun] primero coge [the noun])[command clarification break]".

[Section  20 - Immediately undo rule]
    immediately undo rule response (A) is "El uso de 'deshacer' no está permitido en esta historia.".
    immediately undo rule response (B) is "No puedes 'deshacer' lo que no has hecho.".
    immediately undo rule response (C) is "Tu intérprete no puede 'deshacer' acciones, ¡lo siento!".
    immediately undo rule response (D) is "No puedes 'deshacer' más.".
    immediately undo rule response (E) is "[bracket]Retrocediendo al turno anterior.[close bracket]".
    immediately undo rule response (F) is "'Deshacer' agotado. Lo siento.".


Volume 4 - Grammar

Part 4.1 - Replacing English verbs

[ Prop?sito: Para no incluir el bloque de gramaticas (y verbos) ingleses en el fuente (optimiza memoria)]


Understand nothing as answering it that.
Understand nothing as asking it about.
Understand nothing as asking it for.
Understand nothing as attacking.
Understand nothing as burning.
Understand nothing as buying.
Understand nothing as climbing.
Understand nothing as closing.
Understand nothing as consulting it about.
Understand nothing as cutting.
Understand nothing as drinking.
Understand nothing as dropping.
Understand nothing as eating.
Understand nothing as entering.
Understand nothing as examining.
Understand nothing as exiting.
Understand nothing as getting off.
Understand nothing as giving it to.
Understand nothing as going.
Understand nothing as inserting it into.
Understand nothing as jumping.
Understand nothing as kissing.
Understand nothing as listening to.
Understand nothing as locking it with.
Understand nothing as looking under.
Understand nothing as looking.
Understand nothing as opening.
Understand nothing as preferring abbreviated room descriptions.
Understand nothing as preferring sometimes abbreviated room descriptions.
Understand nothing as preferring unabbreviated room descriptions.
Understand nothing as pulling.
Understand nothing as pushing it to.
Understand nothing as pushing.
Understand nothing as putting it on.
Understand nothing as quitting the game.
Understand nothing as removing it from.
Understand nothing as requesting the pronoun meanings.
Understand nothing as requesting the score.
Understand nothing as requesting the story file version.
Understand nothing as restarting the game.
Understand nothing as restoring the game.
Understand nothing as rubbing.
Understand nothing as saving the game.
Understand nothing as saying no.
Understand nothing as saying sorry.
Understand nothing as saying yes.
Understand nothing as searching.
Understand nothing as setting it to.
Understand nothing as showing it to.
Understand nothing as sleeping.
Understand nothing as smelling.
Understand nothing as squeezing.
Understand nothing as swinging.
Understand nothing as switching off.
Understand nothing as switching off.
Understand nothing as switching on.
Understand nothing as switching score notification off.
Understand nothing as switching score notification on.
Understand nothing as switching the story transcript off.
Understand nothing as switching the story transcript on.
Understand nothing as taking inventory.
Understand nothing as taking off.
Understand nothing as taking.
Understand nothing as tasting.
Understand nothing as telling it about.
Understand nothing as thinking.
Understand nothing as throwing it at.
Understand nothing as touching.
Understand nothing as turning.
Understand nothing as tying it to.
Understand nothing as unlocking it with.
Understand nothing as verifying the story file.
Understand nothing as waiting.
Understand nothing as waking up.
Understand nothing as waving hands.
Understand nothing as waving.
Understand nothing as wearing.


[ Gramatica basada en InformATE! (I6) (by Zak)]
[ Verbos irregulares: filosofia usada en informATE!]
[ Para algunas acciones no estan permitidas ciertas variantes de la gramatica de informATE, como el uso de second noun como token.Esto hace la respuesta del parser mucho mas tonta: Ej, corta el pan o corta el pan con el cuchillo. ToDo: podrá resolverse esto?]

Part 4.2 - Grammar for Actions in the Game World

Understand "toma [things]" as taking. Understand the commands "coge" and "recoge" as "toma".
Understand "toma a [someone]" as taking.
Understand "toma [things inside] de [something]" as removing it from.

Understand "saca [things inside] de [something]" as removing it from.
Understand "saca a [someone] de [something]" as removing it from.

Understand "quita [things inside] de [something]" as removing it from.
Understand "quita a [someone] de [something]" as removing it from.
Understand "quita [things inside] a [something]" as removing it from.
Understand the command "quitale" as "quita".


[Understand "quita cerrojo/pestillo/cierre a [something]" as unlocking it with.] [TODO Unlock no soporta call sin segundo argumento 'second noun' y dice: 'You must supply a second noun.'] 
[Understand "quita el cerrojo/pestillo/cierre a [something]" as unlocking it with.]
Understand "quita cerrojo/pestillo/cierre a [something] con [something preferably held]" as unlocking it with. 
Understand "quita el cerrojo/pestillo/cierre a [something] con [something preferably held]" as unlocking it with.

Understand "sacate [something preferably held]" as taking off. Understand the commands "quitate","sacarse","quitarse","quitarte","sacarte","sacarme","quitarme","quitame" and "sacame" as "sacate".

Understand "ponte [something preferably held]" as wearing.
Understand "ponte con [something preferably held]" as wearing.
Understand the commands  "viste","vistete","ponerse","vestirse","ponerte","vestirte","ponerme","vestirme","ponme" and "visteme" as "ponte".

[inserting it into]
Understand "pon [other things] en [container]" as inserting it into. 

Understand the commands  "echa","inserta" and "coloca"  as "pon".

Understand "pon [other things] dentro de [something]" as inserting it into.
Understand "pon a [someone] en [container]" as inserting it into.
Understand "pon a [someone] dentro de [something]" as inserting it into.[todo no seria [container]?]

Understand "deja [other things] en [container]" as inserting it into.
Understand "deja [other things] dentro de [something]" as inserting it into.

Understand "tira [other things] en [container]" as inserting it into.
Understand "tira [other things] dentro de [something]" as inserting it into.
Understand "tira [things preferably held] por [something]" as inserting it into. 

[....con verbo 'meter']
Understand "mete [other things] dentro de [something]" as inserting it into.
Understand "mete a [someone] dentro de [something]" as inserting it into.

Understand "mete [other things] en [something]" as inserting it into.
Understand "mete a [someone] en [something]" as inserting it into.

[Understand "mete [other things] en [container]" as inserting it into.
Understand "mete a [someone] en [container]" as inserting it into.]

Understand "mete [things preferably held] por [something]" as inserting it into. 

[putting it to]
Understand "pon [other things] en/sobre [something]" as putting it on. 
Understand "pon a [someone] en [something]" as putting it on.
Understand "pon a [someone] sobre [something]" as putting it on. 
Understand "pon [other things] encima de [something]" as putting it on.
Understand "pon a [someone] encima de [something]" as putting it on.

Understand "deja [other things] en/sobre [something]" as putting it on.
Understand "deja [other things] encima de [something]" as putting it on.

Understand "tira [other things] en/sobre [something]" as putting it on.
Understand "tira [other things] encima de [something]" as putting it on.

[others]

Understand "pon [something] a [text]" as setting it to.


Understand "pon cerrojo/pestillo/cierre a [something]" as locking it with.
Understand "pon el cerrojo/pestillo/cierre a [something]" as locking it with.
Understand "pon cerrojo/pestillo/cierre a [something] con [something preferably held]" as locking it with.
Understand "pon el cerrojo/pestillo/cierre a [something] con [something preferably held]" as locking it with.

Understand "deja [things preferably held]" as dropping. Understand the command "suelta" as "deja".
Understand "deja a [someone]" as dropping.

Understand "lanza [something preferably held] a/por/contra [something]" as throwing it at. Understand the command "arroja" as "lanza". 
Understand "lanza a [someone] por/contra [something]" as throwing it at.

Understand "tira de [something]" as pulling.
Understand "tira [things preferably held]" as dropping.
Understand "tira a [things preferably held]" as dropping. [added]
Understand "tira [something preferably held] a/contra [something]" as throwing it at.

Understand "da [something preferably held] a [someone]" as giving it to.
Understand "da a [someone] [something preferably held]" as giving it to (with nouns reversed).
Understand "da [someone] [something preferably held]" as giving it to (with nouns reversed).
Understand "da una patada a [something]" as attacking.
Understand "da un punetazo a [something]" as attacking.
Understand "da un golpe a [something]" as attacking.
Understand the commands   "regala","dale","dase","ofrece" and "darse" as "da".

Understand "muestra [someone] [something preferably held]" as showing it to (with nouns reversed). Understand the command "ensena" as "muestra".
Understand "muestra a [someone] [something preferably held]" as showing it to (with nouns reversed).
Understand "muestra [something preferably held] a [someone]" as showing it to.

Understand "vete" as going. [TODO produce texto: You'll have to say which compass direction to go in. Esto reemplazaria la accion VagueGo. Traducir]
Understand "vete [direction]" as going. Understand the commands  "ve","camina","anda","corre","vuelve" and "ir" as "vete".
Understand "vete a/hacia [direction]" as going.
Understand "vete [something]" as entering.
Understand "vete a/hacia/por [something]" as entering.

Understand "pasa por [something]" as entering.

Understand "inventario" as taking inventory. Understand the commands "inv" and "i" as "inventario". [todo: falta el 'breve'/'estrecho'] 

Understand "mira" as looking. Understand the commands "m", "l", "look" and "ver" as "mira".
Understand "look a [someone]" as examining.
Understand "look [something]" as examining.
Understand "look a/hacia [something]" as examining. [for compass]
Understand "look en/sobre/por [something]" as searching.
Understand "look dentro de [something]" as searching.
Understand "look bajo [something]" as looking under.
Understand "look debajo de [something]" as looking under.
Understand "look a traves de [something]" as searching.

Understand "consulta [someone] sobre [text]" as asking it about.
Understand "consulta a [someone] sobre [text]" as asking it about.
Understand "consulta sobre [text] a [someone]" as asking it about (with nouns reversed).
Understand "consulta [something] sobre [text]" as consulting it about.
Understand "consulta [something] acerca de [text]" as consulting it about.
Understand "consulta [text] en [something]" as consulting it about (with nouns reversed).

Understand "abre [something]" as opening.
Understand "abre a [someone]" as opening.
Understand "abre [something] con [something preferably held]" as unlocking it with.

Understand "cierra [something]" as closing.
Understand "cierra [something] con pestillo" as locking it with.
Understand "cierra [something] con [something preferably held]" as locking it with.

Understand "destapa [something]" as opening. Understand the command "descubre" as "destapa".

Understand "tapa [something]" as closing. Understand the command "cubre" as "tapa".

Entering to room is an action applying to nothing.
The specification of the entering to room action is "Esta acción se ejecuta con el comando
'entra', asumiendo que en realidad se quiere entrar a alguna localidad que se tenga enfrente, y que en
el juego está correctamente mapeada de manera que corresponda al 'inside' de la localidad actual.".
Carry out entering to room (this is the intentar entrar rule): try going inside.

Understand "entra" as entering to room.

Understand "entra en/por/a [something]" as entering. Understand the command "cruza" as "entra".
Understand "entra [something]" as entering.
Understand "entra dentro de [something]" as entering.

Understand "metete en/por [something]" as entering. Understand the commands "meterse","meterte","meterme" and "meteme" as "metete".

Understand "atraviesa [something]" as entering.

Understand "sienta en [something]" as entering. Understand the commands "echate","sientate","echarse","sentarse","echarte" and "sentarte" as "sienta".

Understand "sal" as exiting.
Understand "sal de [something]" as getting off.
[Understand "sal por [something]" as entering.] [comentariado en informate]
Understand "sal fuera/afuera" as exiting. Understand the commands "fuera","afuera","salte","bajate","levantate","bajarse","levantarse","salirse","bajarte","levantarte" and "salirte" as "sal".

Understand "examina [something]" as examining.
Understand "examina a [something]" as examining.
Understand "examina a [someone]" as examining. Understand the commands  "describe","inspecciona","observa","ex","x" as "examina".

Understand "lee [something]" as examining.
Understand "lee sobre [text] en [something]" as consulting it about (with nouns reversed).
Understand "lee [text] en [something]" as consulting it about (with nouns reversed).

Understand "si" or "sí" as saying yes. [TODO: arreglar unicode]
Understand "nx" as saying no.

Understand "sorry" as saying sorry. Understand the commands "perdon","perdona","siento","lamento", "disculparte" and "disculpa" as "sorry". [TODO no permite argumento 'topic']
Understand "lo siento/lamento" as saying sorry.
Understand "lo siento/lamento mucho" as saying sorry.

Understand "busca en [something]" as searching.
Understand "busca [text] en [something]" as consulting it about (with nouns reversed).
Understand "busca en [something] sobre [text]" as consulting it about.
Understand "busca en [something] [text]" as consulting it about.
Understand "busca en [something] acerca de [text]" as consulting it about.

Understand "registra a [someone]" as searching. Understand the command "rebusca" as "registra".
Understand "registra [something]" as searching.
Understand "registra en [something]" as searching.

Understand "ondea [someone]" as attacking. Understand the command "sacude" and "agita" as "ondea".
Understand "ondea a [someone]" as attacking.
Understand "ondea la mano" as waving hands.
Understand "ondea las manos" as waving hands.
Understand "ondea [something]" as waving.
Understand "gesticula" as waving hands.
Understand "saluda con la mano" as waving hands.
Understand "saluda" as waving hands. [new]

Understand "ajusta [something] en/a [text]" as setting it to. Understand the command "fija" and "set" as "ajusta".

Understand "pulsa [something]" as pushing.

Understand "empuja [something]" as pushing. Understand the command "mueve","desplaza" and "menea" as "empuja".
Understand "empuja a [someone]" as pushing.
Understand "empuja [something] hacia [direction]" or "empuja [something] [direction]" as pushing it to.

Understand "gira [something]" as turning. Understand the command  "atornilla" and "desatornilla" as "gira".

Understand "conecta [something]" as switching on.
Understand "conecta [something] a/con [something]" as tying it to.

Understand "enciende [a device]" as switching on. Understand the command "prende" as "enciende".
Understand "enciende [something]" as burning.

Understand "desconecta [something]" as switching off. Understand the command "apaga" as "desconecta".
Understand "desconecta a [someone]" as switching off.

Understand "rompe [something]" as attacking.
Understand "rompe a [someone]" as attacking.
Understand the commands "aplasta","golpea","destruye","patea" and "pisotea" as "rompe".

Understand "ataca a [someone]" as attacking.
Understand "ataca [something]" as attacking.
Understand the commands  "mata","asesina","tortura" and "noquea" as "ataca".
Understand "lucha con [someone]" as attacking.
Understand "lucha [someone]" as attacking.

Understand "espera" or "z" as waiting.

Understand "responde a [someone] [text]" as answering it that.
Understand "responde [text] a [someone]" as answering it that (with nouns reversed). [TODO ?como es el orden correcto?]
Understand "responde [someone] [text]" as answering it that.
Understand the commands "di","grita" and "dile" as "responde".


[Understand "cuenta con [someone]" as a mistake ("Debes mencionar el tema de que quieres hablar.").][quitado, por un conflicto con Quip-Based Conversation SP]

Understand "cuenta [someone] de/sobre [text]" as telling it about.
Understand "cuenta [someone] [text]" as telling it about.
Understand "cuenta a [someone] de/sobre [text]" as telling it about.
Understand "cuenta a [someone] [text]" as telling it about.
Understand "cuenta con [someone] sobre/de [text]" as telling it about.
Understand "cuenta con [someone] acerca de [text]" as telling it about.
Understand "cuenta sobre [text] con [someone]" as telling it about (with nouns reversed).
Understand "cuenta acerca de [text] con [someone]" as telling it about (with nouns reversed).
Understand "cuenta de [text] con/a [someone]" as telling it about (with nouns reversed).
Understand "cuenta [text] a [someone]" as telling it about (with nouns reversed).
Understand the commands "narra","explica" and "habla" as "cuenta".
	
Understand "pregunta [someone] sobre/por [text]" as asking it about. Understand the command "interroga" as "pregunta".
Understand "pregunta a [someone] sobre/por [text]" as asking it about.
Understand "pregunta sobre/por [text] a [someone]" as asking it about (with nouns reversed).
Understand "pregunta [text] a [someone]" as asking it about (with nouns reversed).
Understand "pregunta a [someone] acerca de [text]" as asking it about.

Understand "pide a [someone] [something]" as asking it for. Understand the command "pidele" as "pide".
Understand "pide [something] a [someone]" as asking it for (with nouns reversed).

Understand "come [something preferably held]" as eating.
Understand the commands  "comete","traga","ingiere","mastica","comerse" and "comerte" as "come".	

Understand "duerme" or "ronca" or "descansa" as sleeping.

[Understand "canta" as singing.]

Understand "escala a [something]" as climbing. Understand the command "trepa" as "escala".
Understand "escala [something]" as climbing.
Understand "escala por [something]" as climbing.

Understand "baja [something]" as getting off.
Understand "baja de [something]" as getting off.

Understand "baja" as bajando.

Bajando is an action applying to nothing.
The specification of the bajando action is "Esta acción se ejecuta con el comando
'baja', asumiendo que en realidad se quiere bajar a alguna localidad que se tenga debajo, y que en
el juego está correctamente mapeada de manera que corresponda al 'down' de la localidad actual.".
Carry out bajando: try going down.

Understand "subete a/en [something]" as entering. Understand the command "subirse" and "subirte" as "subete".

Subiendo is an action applying to nothing.
The specification of the subiendo action is "Esta acción se ejecuta con el comando
'sube', asumiendo que en realidad se quiere subir a alguna localidad que se tenga arriba, y que en
el juego está correctamente mapeada de manera que corresponda al 'up' de la localidad actual.".
Carry out subiendo: try going up.

Understand "sube" as subiendo.
Understand "sube arriba" as subiendo.

Understand "sube [something]" as entering.
Understand "sube a/en/por [something]" as entering.
Understand "baja a/en/por [something]" as entering.

Understand "compra [something]" or "adquiere [something]" as buying.

Understand "retuerce [something]" as squeezing.
Understand "retuerce a [someone]" as squeezing.
Understand the commands "aprieta","estruja" and "tuerce" as "retuerce".

[Understand "nada" as swimming.] [Actions withdrawn]

Understand "balanceate en [something]" as swinging.
Understand the commands "columpiate","meneate","balancearse","columpiarse","menearse","balancearte","columpiarte" and "menearte" as "balanceate".

[Understand "sopla [something]" as blowing.] [Actions withdrawn]

[Understand "rezar" as praying.][ action withdrawn]

Understand "despierta" as waking up.
Understand "despierta [someone]" or "despierta a [someone]" as waking. Understand the command "espabila" as "despierta".

Understand "espabilate" or "espabilarse" or "espabilarte" as waking up.

Understand "besa [someone]" as kissing. Understand the command "abraza" as "besa".
Understand "besa a [someone]" as kissing.

Understand "piensa" as thinking.

Understand "huele" as smelling. Understand the command "olfatea" as "huele".
Understand "huele a [something]" as smelling.
Understand "huele [something]" as smelling.

Understand "escucha" as listening. Understand the command "oye" as "escucha".
Understand "escucha a [something]" as listening.
Understand "escucha [something]" as listening.

Understand "saborea [something]" as tasting. Understand the commands  "paladea","prueba" and "lame" as "saborea".
Understand "saborea a [something]" as tasting.

Understand "toca [something]" as touching. Understand the command "palpa" as "toca".
Understand "toca a [someone]" as touching.

Understand "lava a/-- [something]" as rubbing. Understand the commands "limpia","pule","abrillanta","friega" and "frota" as "lava".
Understand "lava a [someone]" as rubbing.

Understand "ata [something]" as tying it to. Understand the commands  "enlaza","enchufa" and "une" as "ata".
Understand "ata a [someone]" as tying it to.
Understand "ata a [someone] a [something]" as tying it to.
Understand "ata [something] a [something]" as tying it to.

Understand "quema [something]" as burning.
Understand "quema a [someone]" as burning.
[Understand "quema a [someone] con [something preferably held]" as burning.]
[Understand "quema [something] con [something preferably held]" as burning.] [TODO La accion Burn no contempla second noun]

Understand "bebe [something]" as drinking.

[Understand "llena [something]" as filling. Understand the command "rellena" as "llena".] [Actions withdrawn]

Understand "corta [something]" as cutting. Understand the command "rasga" as "corta".
[Understand "corta [something] con [something preferably held]" as cutting.] [TODO no contempla second noun]

Understand "salta" as jumping.
[Understand "salta [something]" as jumping over.] [Actions withdrawn]
Understand "salta a [something]" as entering.Understand the command "brinca" as "salta".
[Understand "salta sobre [something]" as jumping over.]
[Understand "salta por encima de [something]" as jumping over.]

[Understand "cava en [something]" as digging. Understand the command "excava" as "cava".] [Actions withdrawn]
[Understand "cava [something]" as digging.
Understand "cava [something] con [something preferably held]" as digging.
Understand "cava en [something] con [something preferably held]" as digging.]



Part 4.3 - Grammar for Actions which happen out of world

Understand "score" or "puntos" or "puntuacion" as requesting the score.
Understand "quit" or "q" or "terminar" or "fin" or "acabar" or "abandonar" as quitting the game.
Understand "save" or "guardar" or "salvar" as saving the game.
Understand "restart" or "reiniciar" as restarting the game.
Understand "restore" or "recuperar" or "cargar" or "load" or "restaurar" as restoring the game.
Understand "verify" or "verificar" as verifying the story file.
Understand "version" as requesting the story file version.
Understand "script" or "script on/si" as switching the story transcript on. Understand the command "transcripcion" as "script".
Understand "script off/no" as switching the story transcript off.
Understand  "noscript" or "unscript" or "notranscripcion" as switching the story transcript off.
Understand "superbreve" or "corto" as preferring abbreviated room descriptions.
Understand "verbose" or "largo" as preferring unabbreviated room descriptions.
Understand "breve" or "normal" as preferring sometimes abbreviated room descriptions.
Understand "pronombres" or "p" as requesting the pronoun meanings.
Understand "notify" or "notify on/si" as switching score notification on. Understand the commands "notificar" and "notificacion" as "notify".
Understand "notify off/no" as switching score notification off.

Part 4.4 - Other Actions

Requesting which dialect is an action out of world.
The show actual dialect rule translates into Inter as "DialectoSub".
Report Requesting which dialect rule:
	follow the show actual dialect rule.

Understand "dialecto" as Requesting which dialect.

Switching to sudamerican dialect is an action out of world.
The switch to sudamerican dialect rule translates into Inter as "DialectoSudSub".
Report Switching to sudamerican dialect rule:
	follow the switch to sudamerican dialect rule.

Understand "dialecto sudamericano" as switching to sudamerican dialect.

Switching to castilian dialect is an action out of world.
The switch to castilian dialect rule translates into Inter as "DialectoCastSub".
Report Switching to castilian dialect rule:
	follow the switch to castilian dialect rule.

Understand "dialecto castellano" as switching to castilian dialect.

Part SL5 - Spanish Phrasebook

Section SL4/0 - Spanish Saying, basados en la rutinas de impresión de InformATE!
[ Documentacion de esta seccion: DocumentATE: Descripciones y Parsing: Descripcion de objetos y lugares ]

[Articulos ]
[To say el (something - object):	(- print (the) {something}; -).
To say El (something - object):	(- print (The) {something}; -).
To say un (something - object):	(- print (un) {something}; -).
To say Un (something - object):	(- print (_Un) {something}; -).] [se usan similares en Chapter 2.1.1 - Articles]

To say del (something - object): (- print (del) {something}; -).
To say al (something - object):	(- print (al) {something}; -).
To say Al (something - object):	(- print (_Al) {something}; -).

To say el_ (something - object):	(- print (el_) {something}; -). [imprime "el" o "la"]
To say del_ (something - object):	(- print (del_) {something}; -). [imprime "del" o "de la"]

[ Terminaciones para adjetivos ]
To say o (something - object): (- print (o) {something}; -).[say "Cogid[o noun]".]
To say s (something - object): (- print (s) {something}; -). [say "Ya no está[n noun] tan negro[s noun].".]
To say _s (something - object): (- print (_s) {something}; -).


[ Terminaciones para verbos ]
To say es (something - object): (- print (es) {something}; -).
To say Es (something - object): (- print (_Es) {something}; -).
To say n (something - object): (- print (n) {something}; -). [say "Ya no está[n noun] allí.".]
To say lo (something - object): (- print (lo) {something}; -). [say "C?ge[lo noun]".]
	

[ Verbo COGER/TOMAR segun dialecto ]
To say coge: (- coge(0); -).
To say Coge: (- Mcoge(0); -).
To say MMcoge: (- MMcoge(0); -).

[Misc]
To say (something - time) in spanish:			[decir la hora en espa?ol]
	(- print (PrintTimeOfDayEnglish) {something}; -).

[To say (something - time) con palabras:	            	[decir la hora en espa?ol] [vamos a dejar esto por un tiempo]
	(- print (PrintTimeOfDaySpanish) {something}; -).]

To say esta (something - object): (- print (esta) {something}; -).[ "está" / "están" ]


Part SL6 - Spanish Hackings


Include (-
[ LanguageNumber n;
    LanguageNumberSpanish (n);
];
-) replacing "LanguageNumber". 


Include (-
[ Banner;
    SpanishBanner();
];
-) replacing "Banner".

Include (-
[ PrintTimeOfDayEnglish t;
    PrintTimeOfDaySpanish(t);
];
-) replacing "PrintTimeOfDayEnglish".

Include (-
[ PrintCommand from;
    PrintCommandSpanish (from);
];
-) replacing "PrintCommand". 

Include (-
[ IndefArt obj;
    SpanishIndefArt (obj);
];
-) replacing "IndefArt". 

Include (-
[ PrefaceByArticle obj acode pluralise capitalise;
    SpanishPrefaceByArticle (obj,acode,pluralise,capitalise);
];
-) replacing "PrefaceByArticle". 


Part SL7 - Spanish Irregular Verbs

[Thanx to otistdog user @ intfiction phorum]
[https://intfiction.org/t/calling-a-rule-from-i6-code-with-params/61797]

Include (- 

Array tmpbuf buffer INPUT_BUFFER_LEN;
Array tmpparse --> PARSE_BUFFER_LEN;

Array tknbuf buffer INPUT_BUFFER_LEN;
Array tknparse --> PARSE_BUFFER_LEN;

! DictionaryWordFromText: Convert a text into a dictonary word. 
[ DictionaryWordFromText txt len i ;
	if (len < 1) rfalse;
	i = 0;
	while (i < len) {
		tknbuf->(WORDSIZE+i) = BlkValueRead(txt, i);
		i++;
	}
	tknbuf-->0 = len;
	VM_Tokenise(tknbuf, tknparse);
	return tknparse-->1; ! only first word of interest
];

[ LanguageIsIrregularVerb buf prs word_in_buf bufsnp rv;	
	if (word_in_buf == 0) return 0;
	
	! special case if buf is buffer2; we need to backup main buffer and
	!	and parse vars
	if (buf == buffer2) {
		VM_CopyBuffer(tmpbuf, buffer);
		VM_CopyBuffer(buffer, buffer2);
	}
	if (prs == parse2) {
		Arrcpy(tmpparse, WORDSIZE, parse, WORDSIZE, PARSE_BUFFER_LEN);
		Arrcpy(parse, WORDSIZE, parse2, WORDSIZE, PARSE_BUFFER_LEN);
	}

	bufsnp = (word_in_buf*100)+1;! set a snnipet, using formula. it is pointing to main 'buffer' var 
	
	FollowRulebook( (+ SearchingFor rules +), bufsnp, true);
	
	if (buf == buffer2) {
		VM_CopyBuffer(buffer2, buffer);
		VM_CopyBuffer(buffer, tmpbuf);
	}
	if (prs == parse2) {
		Arrcpy(parse2, WORDSIZE, parse, WORDSIZE, PARSE_BUFFER_LEN);
		Arrcpy(parse, WORDSIZE, tmpparse, WORDSIZE, PARSE_BUFFER_LEN);
	}

	return latest_rule_result-->2;
];

Array auxbuf buffer INPUT_BUFFER_LEN;
Array auxparse --> PARSE_BUFFER_LEN;

! ImprimirIrregular: si el verbo está en la Table of Irregular Verbs, imprime
!	el infinitivo y duelve su dict address, si no, no imprime nada y devuelve false.
[ ImprimirIrregular word k bufsnp;

    !print "[ImprimirIrregular...", (address) word, "^";
    k = VM_PrintToBuffer (auxbuf,INPUT_BUFFER_LEN,word);
!    print " | Buffer creado: ";
!    ImprimeTodoElBuffer(auxbuf);

    VM_Tokenise(auxbuf, auxparse);

    ! backup global buffer var
    VM_CopyBuffer(tmpbuf, buffer);
	VM_CopyBuffer(buffer, auxbuf);

    ! backup global parse var
	Arrcpy(tmpparse, WORDSIZE, parse, WORDSIZE, PARSE_BUFFER_LEN);
	Arrcpy(parse, WORDSIZE, auxparse, WORDSIZE, PARSE_BUFFER_LEN);
	
	bufsnp = 101; !snippet value for the first token, the only

	FollowRulebook( (+ SearchingForImperative rules +), bufsnp, true);

	!restore global buf and parse vars
	VM_CopyBuffer(buffer, tmpbuf);
	Arrcpy(parse, WORDSIZE, tmpparse, WORDSIZE, PARSE_BUFFER_LEN);

	return latest_rule_result-->2;

];

-) before "Parser.i6t".


To decide which number is wdnum of (T - text) with length (N - number):
	(- DictionaryWordFromText({T}, {N}) -).

To decide which snippet is the invalid snippet:
	(- 0 -).

SearchingFor is a snippet based rulebook producing a number.

SearchingFor a snippet (called W):
	if W is the invalid snippet, rule fails;
	let converted text be the substituted form of "[W]";
	let auxiliary response be "";
	repeat through the Table of Irregular Verbs:[search in a table for replace the player`s command]
		if converted text exactly matches the text "[command entry]":
			now the auxiliary response is "[imperative entry]";
	if auxiliary response is empty, rule fails;
	[say "<replacing '[converted text]' with '[auxiliary response]'>";]
	let rv be wdnum of auxiliary response with length (number of characters in auxiliary response);
	rule succeeds with result rv.


SearchingForImperative is a snippet based rulebook producing a number.

SearchingForImperative a snippet (called W):
	if W is the invalid snippet, rule fails;
	let converted text be the substituted form of "[W]";
	let auxiliary response be "";
	repeat through the Table of Irregular Verbs:[search in a table for replace the player`s command]
		[say W;]
		[say "[imperative entry]";]
		[say line break;]
		if converted text matches the text "[imperative entry]":
			now the auxiliary response is "[command entry]";
	if auxiliary response is empty, rule fails;
	let rv be wdnum of auxiliary response with length (number of characters in auxiliary response);
	if rv is 0, rule fails;
	[say "<replacing '[converted text]' with '[auxiliary response]'>";]
	say "[auxiliary response]";
	rule succeeds with result rv.

Table of Irregular Verbs
command (text)	imperative (text)
"abrir"	"abre"
"adquirir"	"adquiere"
"apretar"	"aprieta"
"atravesar"	"atraviesa"
"bajar"	"bajate"
"balancear"	"balanceate"
"cerrar"	"cierra"
"columpiar"	"columpiate"
"comer"	"comete"
"ingerir"	"ingiere"
"contar"	"cuenta"
"cubrir"	"cubre"
"darle"	"dale"
"decir"	"di"
"descubrir"	"descubre"
"despertar"	"despierta"
"destruir"	"destruye"
"dormir"	"duerme"
"echar"	"echate"
"encender"	"enciende"
"esperar"	"z"
"fregar"	"friega"
"ir"	"ve"
"volver"	"vuelve"
"levantar"	"levantate"
"mostrar"	"muestra"
"mover"	"mueve"
"oir"	"oye"
"oler"	"huele"
"pedir"	"pide"
"pensar"	"pensar"
"poner"	"pon"
"probar"	"prueba"
"pulir"	"pule"
"quitar"	"sacate"
"quitarle"	"quitale"
"sacudir"	"sacude"
"salir"	"sal"
"sentar"	"sienta"
"soltar"	"suelta"
"subir"	"sube"
"torcer"	"tuerce"
"retorcer"	"retuerce"
"transferir"	"transfiere"
"unir"	"une"
"disculpar"	"disculpa"
"transcripcion"	"transcripcion"




Spanish Language ends here.
