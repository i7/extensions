Version 1/210825 of Spanish Language by Sebastian Arg begins here.

"To make Spanish the language of play."

"basada en InformATE! de Zak, con la contribución de toda la comunidad"

Volume 0 - Previous Hackings - Fixing linux problem

[ En algunos sistemas linux, la cadena de compilación de I7 carga primero esta extensión (Spanish) y no la English Language,
por lo que algunas definiciones de variables (hechas en la extension English) no existen aún. Eso rompe la compilación.
 Solución temporal: traer esas definiciones a la extensión Spanish.
]

Section 1 Ph1 Hack

The language of play is a natural language that varies. The language of play
is usually the English language.

A grammatical tense is a kind of value. The grammatical tenses are present tense,
past tense, perfect tense, past perfect tense and future tense.

A narrative viewpoint is a kind of value. The narrative viewpoints are first
person singular, second person singular, third person singular, first person
plural, second person plural, and third person plural.

A natural language has a narrative viewpoint called the adaptive text viewpoint.

The adaptive text viewpoint of the English language is first person plural.

A grammatical case is a kind of value. The grammatical cases are nominative
and accusative.

A grammatical gender is a kind of value. The grammatical genders are
neuter gender, masculine gender, feminine gender.

The story tense is a grammatical tense that varies.
The story tense variable translates into I6 as "story_tense".
The story viewpoint is a narrative viewpoint that varies.
The story viewpoint variable translates into I6 as "story_viewpoint".


Section 2 Ph2 Hack (in place of Section 1 - Grammatical definitions in English Language by Graham Nelson)

To say regarding (item - an object): (- RegardingSingleObject({item}); -).

To say regarding (N - a number): (- RegardingNumber({N}); -).

To say regarding list writer internals: (- RegardingLWI(); -).

To say regarding (D - a description of objects): (-
	 	objectloop({-my:1} ofclass Object)
			if ({-matches-description:1:D}) 
				give {-my:1} workflag2;
			else
				give {-my:1} ~workflag2;
		RegardingMarkedObjects();
	-).

To decide if the prior naming context is plural:
	(- ((prior_named_list >= 2) || (prior_named_noun && prior_named_noun has pluralname)) -).
	



Volume 1 - Settings

[A language extension is required to set the following variable correctly:]

The language of play is the Spanish language.

[The following only needs to be done for inflected languages which distinguish
the genders -- which is why English doesn't do it.]

An object has a grammatical gender.

[Inform initialises this property sensibly. We can easily check the results:

	When play begins:
		repeat with T running through things:
			say "[T] has [grammatical gender of T]."

By default, if Inform can't see any reason to choose a particular gender,
it will use neuter. We want to change that for French, since French doesn't
have neuter nouns:]


The grammatical gender of an object is usually masculine gender.
The grammatical gender of a woman is usually feminine gender.

A thing can be female. [Habilita genero a inanimados, como containers, supporters, etc. Caracteristica necesaria en espanol]
A room can be female. [Habilita genero a habitaciones. Caracteristica necesaria (a veces) en espanol, sobre todo al listar las habitaciones.]
A room can be plural-named or singular-named. [spanish need: al listar rooms como 'las Escaleras']

Section 1 SR Hack - Spanish Bibliographical Data (in place of Section SR2/6a - Unindexed Standard Rules variables - Unindexed in Standard Rules by Graham Nelson)
[el 'is usually' no deja redefinir las constantes, por lo que hay que hackearlo]

The story title, the story author, the story headline, the story genre
and the story description are text variables. [*****]
The release number and the story creation year are number variables. [**]

The release number is usually 1.
The story headline is usually "Un relato interactivo".
The story genre is usually "Ficción".

The story title variable translates into I6 as "Story".

Section 2 SR Hack - Others Hackings

[Para poner siempre el nombre de la habitación con primera letra en mayuscula:]

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

Section 3 SR Hack - Spanish People (in place of Section SR1/11 - People in Standard Rules by Graham Nelson)
[el 'is usually' no deja redefinir las constantes, por lo que hay que hackearlo]

The specification of person is "A pesar de su nombre, no necesariamente se trata de un ser humano, sino de cualquier ente con las funciones necesarias como para interactuar con él."

A person can be female or male. A person is usually male.
A person can be neuter. A person is usually not neuter.

A person has a number called carrying capacity.
The carrying capacity of a person is usually 100.

Include (-
	has transparent animate
	with before NULL,
-) when defining a person.

The yourself is an undescribed person. The yourself is proper-named.

The yourself is privately-named.
Understand "your former self" or "my former self" or "former self" or
	"former" as yourself when the player is not yourself.

Understand "tu antiguo yo" or "mi antiguo yo" or "antiguo yo" as yourself when the player is not yourself.

The description of yourself is usually "Tan buen aspecto como siempre."

The yourself object translates into I6 as "selfobj".
Include (-
!	with saved_short_name (+ "yourself" +),
	with saved_short_name [;
				print "ti mism", (o) player;
	],

 -) when defining yourself.


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

Include (-
language Spanish
[ver 9/pro.5 p94]

<indefinite-article> ::=
	/b/ un    |			[singular, masculine]
	/c/ una   |			[singular, feminine]
	/e/ unos  |     [plural, masculine (by default)]
	/f/ unas        [plural, feminine]

<definite-article> ::=
	/b/ el  |				[singular, masculine]
	/c/ la  |				[singular, feminine]
	/e/ los |		  	[plural, masculine (by default)]
	/f/ las					[plural, femenine]

[6/noun.15 p29]
<np-relative-phrase-implicit> ::=
	/a/ vestido por |     [replacing "worn" in English]
	/b/ llevado por |     ["carried"]
	/c/ llevado inicialmente por | ["initial carried"]
	/d/ aquí              ["here"]

[19/play.10 p148]
<implicit-player-relationship> ::=
	/a/ vestido |
	/b/ llevado |
	/c/ llevado inicialmente por ["initial carried" deprecated for the future]

[19/play.4] [todo: lo siguiente parece no funcionar]
<notable-player-variables>  ::=
  /a/ jugador |       [player]
  /b/ puntuación |    [score]
  /c/ hora            [time of day]


-) in the Preform grammar.

Include (-
language Spanish

[todo : lo siguiente no anda]
<heading> ::=
    /a/ volumen ... |						
		/b/ libro ... |							
		/c/ parte ... |							
		/d/ capítulo/capitulo ... |						
		/e/ sección/seccion ...							

-) in the Preform grammar.

Include (-
Constant LanguageAnimateGender   = male;
Constant LanguageInanimateGender = male;

Constant LanguageContractionForms = 1;     ! Para el español
! No se produce contracción del artículo. Sólo de las preposiciones
! como en "del" y "al", pero eso no está contemplado por el manual
! del traductor, por lo que es necesario otro tipo de truco

[ LanguageContraction ;
    return 0;
];

Array LanguageArticles -->
    ! Forma de contracción 0:
    ! Cdef   Def  Indef  
    "El " "el " "un "    
    "La " "la " "una "   
    "Los " "los " "unos "  
    "Las " "las " "unas ";

                   !             a           i
                   !             s     p     s     p
                   !             m f n m f n m f n m f n                 
Array LanguageGNAsToArticles --> 0 1 0 2 3 2 0 1 0 2 3 2;
-) instead of "Articles" in "Language.i6t".


Chapter 2.1.2 - Numbers

Include (-
language Spanish

<cardinal-number-in-words> ::=
	cero |
	uno/una |
	dos |
	tres |
	cuatro |
	cinco |
	seis |
	siete |
	ocho |
	nueve |
	diez |
	once |
	doce

<ordinal-number-in-words> ::=
	cero |			[¿Existe esta palabra en español?]
	primero |
	segundo |
	tercero |
	cuarto |
	quinto |
	sexto |
	séptimo |
	octavo |
	noveno |
	décimo |
	undécimo |
	duodécimo

-) in the Preform grammar.

Include (-
Array LanguageNumbers table
    'un' 1 'uno' 1 'una' 1 'dos' 2 'tres' 3 'cuatro' 4 'cinco' 5
    'seis' 6 'siete' 7 'ocho' 8 'nueve' 9 'diez' 10
    'once' 11 'doce' 12 'trece' 13 'catorce' 14 'quince' 15
    'dieciséis' 16 'diecisiete' 17 'dieciocho' 18 'diecinueve' 19
    'veinte' 20;

[ LanguageNumber n venti m f;
    if (n==0) { print "cero"; rfalse; }
    if (n<0) { print "menos "; n=-n; }
#Iftrue (WORDSIZE == 4);
    if (n >= 1000000000) {
        !if (f == 1) print ", ";
    	!print (LanguageNumber) n/1000000000, " billón"; n = n%1000000000; f = 1;
		if (n<2000000000) print "mil";
        else { LanguageNumber(n/1000000000,1); print " mil";} 
        n=n%1000000000; f = 1;
        if (n~=0) print " ";
    }
    if (n >= 1000000) {
    	print (LanguageNumber) n/1000000;
		if ((n<2000000) && (f==0)) print " millón";
        else { print " millones";} 
        n = n%1000000;
        if (n~=0) print " ";
    }
#Endif;
    if (n>=1000) { 
		if (n<2000) print "mil";
        else { LanguageNumber(n/1000,1); print " mil";} 
        n=n%1000; 
        if (n~=0) print " ";
    }
    if (n>=100)  { 
		CientosEspanol(n/100); 
        if (n%100~=0) print " ";
		n=n%100; 
    }
    if (n==0) rfalse;

    if (n<10) {
		DigitoEspanol(n); rfalse;
    }
    if (n>=20)
	{	m=n/10;
        if (n%10~=0) {
				if (m==2) print "veinti";
            } else {
				if (m==2) print "veinte";
            }
            if (m==3) print "treinta";
			if (m==4) print "cuarenta";
            if (m==5) print "cincuenta";
            if (m==6) print "sesenta";
            if (m==7) print "setenta";
            if (m==8) print "ochenta";
            if (m==9) print "noventa";
            if (n%10==0) rfalse;
            if (m>2) print " y "; 
            DigitoEspanol(n%10, (m==2)&&(venti==0)); rfalse;
        }
    if (n==10) { print "diez"; rfalse; }
    if (n==11) { print "once"; rfalse; }
    if (n==12) { print "doce"; rfalse; }
    if (n==13) { print "trece"; rfalse; }
    if (n==14) { print "catorce"; rfalse; }
    if (n==15) { print "quince"; rfalse; }
    if (n==16) { print "dieciséis"; rfalse; }
    if (n==17) { print "diecisiete"; rfalse; }
    if (n==18) { print "dieciocho"; rfalse; }
    print "diecinueve";
];

[ DigitoEspanol n venti;
    if (n==1) { print "un"; rfalse; }
    if (n==2) { 
         if (venti) {print "dós";} else {print "dos"; };
         rfalse; }
    if (n==3) { 
         if (venti) {print "trés";} else {print "tres"; };
         rfalse; }
    if (n==4) { print "cuatro"; rfalse; }
    if (n==5) { print "cinco"; rfalse; }
    if (n==6) { 
         if (venti) {print "séis";} else {print "seis"; };
         rfalse; }
    if (n==7) { print "siete"; rfalse; }
    if (n==8) { print "ocho"; rfalse; }
    if (n==9) { print "nueve"; rfalse; }
];

[ CientosEspanol n;
	if (n==1) { print "ciento"; rfalse; }
	if (n==2) { print "dos";}
	if (n==3) { print "tres";}
	if (n==4) { print "cuatro";}
	if (n==5) { print "quinientos"; rfalse;}
	if (n==6) { print "seis";}
	if (n==7) { print "sete";}
	if (n==8) { print "ocho";}
	if (n==9) { print "nove";}
	print "cientos"; rfalse;
];
-) instead of "Numbers" in "Language.i6t".


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

[en general Poca gente menciona los sujetos explícitamente en segunda persona.Al-K]

[Include Text Capture by Eric Eve.] [Ver al final, Section 19 ]

to say plm:[primera letra en mayúscula]
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


Chapter 2.2.3 - Pronouns and possessives for other objects

[These are similar, but easier. They are named from the third-person viewpoint
with the same number as the adaptive text viewpoint; so in the case of French,
we'll go with third person singular. We define:

	[celui] = that
	[il] = it as subject
	[le] = it as object
	[lui] = it as indirect object
	[son] = its as adjective, e.g., "its temperature"
	[le sien] = its as possessive pronoun, e.g., "that label is its"

Spanish: 3PS
	[eso] = that
	[il] = it as subject
	[le] = it as object
	[lui] = it as indirect object
	[son] = its as adjective, e.g., "its temperature"
	[le sien] = its as possessive pronoun, e.g., "that label is its"

and similarly for its capitalised forms.]

To say eso:
	let the item be the prior named object;
	if the item is the player:
		say "[tu]";
	otherwise:
		if the item is plural-named:
			if the item is male:
				say "esos";
			otherwise:
				say "esas";
		otherwise:
			if the item is male:
				say "eso";
			otherwise:
				say "esa".

To say Eso:
	let the item be the prior named object;
	if the item is the player:
		say "[Tu]";
	otherwise:
		if the item is plural-named:
			if the item is male:
				say "Esos";
			otherwise:
				say "Esas";
		otherwise:
			if the item is male:
				say "Eso";
			otherwise:
				say "Esa".

Chapter 2.2.4 - Directions

North translates into Spanish as el norte.
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
Down translates into Spanish as abajo.


Understand "o" as west.
Understand "no" as northwest.
Understand "so" as southwest.
Understand "sube/techo/lado/cielo/asciende" as up.
Understand "b/baja/suelo/desciende" as down.
Understand "adentro" as inside. ['entra' no funciona aqui pues se superpone con verbo 'entra..']
Understand "afuera" as outside.

Up is proper-named.
Down is proper-named.
Inside is proper-named.
Outside is proper-named.


Chapter 2.2.5 - Kinds

Section 2.2.5.1 - In the Standard Rules

[One day we will also want to translate the names of more abstract kinds, but
for now, we'll just translate kinds of objects. This ensures that if we write:

	Quatre hommes sont dans la Théâtre.

then (a) Inform will recognise these as instances of the kind "man", and (b)
it will give them each the printed name "homme" (not "man").

I'm not sure I've chosen the best equivalents here. Should a room be "chamber",
or "pièce"?]

A room translates into Spanish as una habitación.
A thing translates into Spanish as un objeto.
A door translates into Spanish as una puerta.
A container translates into Spanish as un contenedor.
A vehicle translates into Spanish as un vehículo.
A player's holdall translates into Spanish as una bolsa.
A supporter translates into Spanish as un soporte.
A backdrop translates into Spanish as un decorado.
A person translates into Spanish as una persona.
A man translates into Spanish as un hombre.
A woman translates into Spanish as una mujer.
A animal translates into Spanish as un animal.
A device translates into Spanish as un dispositivo.
A direction translates into Spanish as una dirección.
A region translates into Spanish as una región.

A number translates into Spanish as un número.

Section 2.2.5.2 - In Rideable Vehicles (for use with Rideable Vehicles by Graham Nelson)

A rideable animal translates into Spanish as un animal montable.
A rideable vehicle translates into Spanish as un vehículo montable.

Section 2.2.5.3 - In Locksmith (for use with Locksmith by Emily Short)

[A passkey translates into Spanish as una llave maestra.
A keychain translates into Spanish as un llavero.
]
Chapter 2.2.6 - Plurals

Include (-
language Spanish

[We define a trie to construct the plural of a French noun. This is fairly
regular in French:]

<singular-noun-to-its-plural> ::=
	<es-plural-exceptions> |
	...	<es-plural-by-ending> |
	... <es-plural-default>

<es-plural-exceptions> ::=
	a	            aes |
	faralá	      faralaes |
	albalá	      albalaes |
	club	        clubes |
	sí	          síes |
	albúm	        albumes |
	imam	        imames |
	espécimen	    especímenes |
	régimen	      regímenes |
	volumen	      volúmenes |
	hipérbaton	  hipérbatos |
	cárdigan	    cárdigan |
	trávelin	    trávelin |
	o	            oes |
	no	          noes |
	yo	          yos |
	carácter	    caracteres |
	mánager	      mánager |
	dux	          dux |
	jersey	      jerséis |
	espray	      espráis |
	bíceps        bíceps |
	fórceps       fórceps |
	afrikáans	    afrikáans |
	valses	      valses |
	cualquiera	  cualesquiera |
	quienquiera	  quienesquiera

<es-plural-by-ending> ::=
	*s			0			|		[tas -> tas]
	*ón     2ones |		[camión->camiones]
	*or     0es 	|		[contenedor->contenedores]
	*er     0es 	|		[mujer->mujeres]
  *<aeiou>y 0es			[ley -> leyes]
  
<es-plural-default> ::=
	*		0s


-) in the Preform grammar.


Chapter 2.2.7 - Cases

[This will be significant for languages like German, but for French there's
nothing to do.]

Chapter 2.2.8 - Times of day

Include (-
! Spanish Version of the saying 'time of day in words'
![ PrintTimeOfDaySpanish t h m dir aop say_minutes quad;
[ PrintTimeOfDayEnglish t h m dir aop say_minutes quad;

!   t store the minutes from 0am until now
!  se tiene en cuenta: 8:40 nueve menos veinte
!                               8:15 ocho y cuarto
!                               8:53 7 minutos para las nueve
!	                    8:14 ocho horas y catorce minutos
!           		        1:20 una y veinte (y todas las variantes con 'una')

    quad = 1; ! =1 es la primera media hora, =2 es la segunda
    h = (t/60) % 12; m = t%60; if (h==0) h=12;
	if (m==0) { if(h==1) print "una"; else print (number) h;print " en punto"; return; } !infsp hack
	dir = "y";! infsp hack
	if (m > 30) { m = 60-m; h = (h+1)%12; if (h==0) h=12; dir = "menos"; quad=2;} !infsp hack
	switch(m) {
        5: say_minutes = "cinco";
        10:say_minutes = "diez";
		15: say_minutes = "cuarto";
        20: say_minutes = "veinte";
        25: say_minutes = "veinticinco";
        30: say_minutes = "media";
		default: 
            if (quad == 2){
              print (number) m;
		      if (m%5 ~= 0) {
					if (m == 1) print " minuto"; else print " minutos"; ! infsp hack
		      }
              if(h==1) print " para la una"; else print " ", "para las ", (number) h;!infsp hack

            }
            if (quad == 1){
              if(h==1) print "una y "; else print (number) h," horas "; print (number) m;
		      if (m%5 ~= 0) {
					if (m == 1) print " minuto"; else print " minutos"; ! infsp hack
		      }
            }
        	return;
	}
	if(h==1) print "una"; else print (number) h; print " ",(string) dir, " ",(string) say_minutes;!infsp hack
]; 
-) instead of "Analogue Printing" in  "Time.i6t".

[spanish version: minuto, hora, de, etc]
Include (-
[ RELATIVE_TIME_TOKEN first_word second_word offhour mult mn original_wn;
	original_wn = wn;
	wn = original_wn;
	
	first_word = NextWordStopped(); wn--;
!	if (first_word == 'an' or 'a//') mn=1; else mn=TryNumber(wn);
	if (first_word == 'una' or 'un') mn=1; else mn=TryNumber(wn);
	
    if (mn == -1000) {
		first_word = NextWordStopped();
		if (first_word == 'media') offhour = HALF_HOUR;
		if (first_word == 'cuarto') offhour = QUARTER_HOUR;
		if (offhour > 0) {
			second_word = NextWordStopped();
			if (second_word == 'de') second_word = NextWordStopped();
!			if (second_word == 'an') second_word = NextWordStopped();
			if (second_word == 'hora') {
				parsed_number = offhour;
				return GPR_NUMBER;
			}
		}
		return GPR_FAIL;
    }
	wn++;
	
	first_word = NextWordStopped();
	switch (first_word) {
		'minutos', 'minuto': mult = 1;
		'hora', 'horas': mult = 60;
		default: return GPR_FAIL;
	}
	parsed_number = mn*mult;
	if (mult == 60) {
		mn=TryNumber(wn);
		if (mn ~= -1000) {
			wn++;
			first_word = NextWordStopped();
			if (first_word == 'minutos' or 'minuto')
				parsed_number = parsed_number + mn;
			else wn = wn - 2;
		}
	}
	return GPR_NUMBER;
];
-) instead of "Relative Time Token" in  "Time.i6t".


Part 2.3 - Adjectives

[Adjectives have six forms: neuter singular, neuter plural, masculine singular,
masculine plural, feminine singular, feminine plural. They're constructed
using tries:

	n.s.		(base text unchanged)
	n.p.		base modified by <adjective-to-plural>
	m.s.		base modified by <adjective-to-masculine-singular>
	m.p.		base modified by <adjective-to-masculine-singular>
				then further by <adjective-to-masculine-plural>
	f.s.		base modified by <adjective-to-feminine-singular>
	f.p.		base modified by <adjective-to-feminine-singular>
				then further by <adjective-to-feminine-plural>

For French, of course, there's no neuter, so the following are easy:]

Include (-
language Spanish

<adjective-to-plural> ::=
	*		0s

<adjective-to-masculine-singular> ::=
	*		0


[So the real work starts here: blanc to blancs, and so on.]

<adjective-to-masculine-plural> ::=
	... <adjective-to-plural>

<adjective-to-feminine-singular> ::=
	... <es-adjective-to-feminine-default>

<es-adjective-to-feminine-default> ::=
	*			1a

<adjective-to-feminine-plural> ::=
	... <adjective-to-plural>

-) in the Preform grammar.


[---------------------------------------------------------------------------------------------]
[---------------------------------------------------------------------------------------------]
[---------------------------------------------------------------------------------------------]
Part 2.4 - Verbs

Chapter 2.4.1 - Verb conjugations

[Now we need to give instructions on how to conjugate verbs. See also the
published guide to Inform syntax, which goes through the English case; but
the French case below shows off features not needed for English, so it's a
better example to follow for other languages.]

[The specification below is not bad, but it does ignore a few grammatical
difficulties. Harmlessly, it constructs now obsolete forms for defective
verbs with some parts missing: French doesn't have many of these, but for
example, "poindre" lacks a past tense form in modern French. We'll construct
it anyway. Other gaps in our coverage will be marked >--> below; they might
need improving later.]

Include (-
language Spanish

[Mucho del código aquí deriva del trabajo de Matias Biato, incluyendo su investigación y tabulación de cada verbo]

<verb-conjugation-instructions> ::=
["PRINCIPALES Y SINGULARES"]
  ser				<es-ser-conjugation> |
  estar			<es-estar-conjugation> |
	ir				<es-ir-conjugation> |
[														]
[---------- "-AR"---------]
[VERBOS "ACERTAR"]
	acertar			<es-acertar-conjugation> |
	acrecentar	<es-acertar-conjugation> |
	alentar		<es-acertar-conjugation> |
	apacentar	<es-acertar-conjugation> |
	apretar		<es-acertar-conjugation> |
	arrendar	<es-acertar-conjugation> |
	asentar	<es-acertar-conjugation> |
	aserrar	<es-acertar-conjugation> |
	aterrar	<es-acertar-conjugation> |
	atestar	<es-acertar-conjugation> |
	atravesar	<es-acertar-conjugation> |
	aventar		<es-acertar-conjugation> |
	beldar		<es-acertar-conjugation> |
	calentar	<es-acertar-conjugation> |
	cerrar		<es-acertar-conjugation> |
	cimentar	<es-acertar-conjugation> |
	concertar	<es-acertar-conjugation> |
	confesar	<es-acertar-conjugation> |
	dentar		<es-acertar-conjugation> |
	desacertar	<es-acertar-conjugation> |
	desalentar	<es-acertar-conjugation> |
	desaterrar	<es-acertar-conjugation> |
	desconcertar	<es-acertar-conjugation> |
	desenterrar	<es-acertar-conjugation> |
	desgobernar	<es-acertar-conjugation> |
	deshelar		<es-acertar-conjugation> |
	desmembrar	<es-acertar-conjugation> |
	despertar		<es-acertar-conjugation> |
	desterrar		<es-acertar-conjugation> |
	emparentar	<es-acertar-conjugation> |
	empedrar		<es-acertar-conjugation> |
	encerrar		<es-acertar-conjugation> |
	encomendar	<es-acertar-conjugation> |
	enmelar		<es-acertar-conjugation> |
	enmendar	<es-acertar-conjugation> |
	ensangrentar	<es-acertar-conjugation> |
	enterrar		<es-acertar-conjugation> |
	entrecerrar	<es-acertar-conjugation> |
	escarmentar	<es-acertar-conjugation> |
	gobernar		<es-acertar-conjugation> |
	helar		<es-acertar-conjugation> |
	herrar	<es-acertar-conjugation> |
	incensar		<es-acertar-conjugation> |
	invernar		<es-acertar-conjugation> |
	manifestar	<es-acertar-conjugation> |
	melar		<es-acertar-conjugation> |
	mentar	<es-acertar-conjugation> |
	merendar	<es-acertar-conjugation> |
	nevar		<es-acertar-conjugation> |
	pensar	<es-acertar-conjugation> |
	quebrar	<es-acertar-conjugation> |
	recalentar	<es-acertar-conjugation> |
	recomendar	<es-acertar-conjugation> |
	remendar	<es-acertar-conjugation> |
	repensar	<es-acertar-conjugation> |
	requebrar	<es-acertar-conjugation> |
	reventar	<es-acertar-conjugation> |
	salpimentar	<es-acertar-conjugation> |
	sembrar	<es-acertar-conjugation> |
	sentar	<es-acertar-conjugation> |
	serrar	<es-acertar-conjugation> |
	sobrecalentar	<es-acertar-conjugation> |
	soterrar		<es-acertar-conjugation> |
	subarrendar	<es-acertar-conjugation> |
	temblar	<es-acertar-conjugation> |
	tentar	<es-acertar-conjugation> |
	aislar	<es-acertar-conjugation> |
	ahijar	<es-acertar-conjugation> |
	ahitar	<es-acertar-conjugation> |
	airar		<es-acertar-conjugation> |
	amohinar		<es-acertar-conjugation> |
	desahijar		<es-acertar-conjugation> |
	descafeinar	<es-acertar-conjugation> |
	prohijar		<es-acertar-conjugation> |
	rehilar			<es-acertar-conjugation> |
	sobrehilar	<es-acertar-conjugation> |
	acordar <es-acertar-conjugation> |
	acostar	<es-acertar-conjugation> |
	afollar	<es-acertar-conjugation> |
	aforar	<es-acertar-conjugation> |
	amoblar	<es-acertar-conjugation> |
	amolar	<es-acertar-conjugation> |
	apostar	<es-acertar-conjugation> |
	aprobar	<es-acertar-conjugation> |
	asolar	<es-acertar-conjugation> |
	asonar	<es-acertar-conjugation> |
	atronar	<es-acertar-conjugation> |
	colar		<es-acertar-conjugation> |
	comprobar	<es-acertar-conjugation> |
	concordar	<es-acertar-conjugation> |
	consolar	<es-acertar-conjugation> |
	costar		<es-acertar-conjugation> |
	demostrar	<es-acertar-conjugation> |
	denostar	<es-acertar-conjugation> |
	desacordar	<es-acertar-conjugation> |
	desaforar		<es-acertar-conjugation> |
	desaprobar	<es-acertar-conjugation> |
	descollar		<es-acertar-conjugation> |
	desconsolar	<es-acertar-conjugation> |
	descontar	<es-acertar-conjugation> |
	descornar	<es-acertar-conjugation> |
	desencontrar	<es-acertar-conjugation> |
	desolar		<es-acertar-conjugation> |
	desollar	<es-acertar-conjugation> |
	despoblar	<es-acertar-conjugation> |
	discordar	<es-acertar-conjugation> |
	disonar		<es-acertar-conjugation> |
	encontrar	<es-acertar-conjugation> |
	engrosar	<es-acertar-conjugation> |
	escornar	<es-acertar-conjugation> |
	hollar		<es-acertar-conjugation> |
	mancornar	<es-acertar-conjugation> |
	mostrar	<es-acertar-conjugation> |
	poblar	<es-acertar-conjugation> |
	probar	<es-acertar-conjugation> |
	recontar	<es-acertar-conjugation> |
	recordar	<es-acertar-conjugation> |
	recostar	<es-acertar-conjugation> |
	reencontrar	<es-acertar-conjugation> |
	renovar		<es-acertar-conjugation> |
	repoblar	<es-acertar-conjugation> |
	reprobar	<es-acertar-conjugation> |
	resollar	<es-acertar-conjugation> |
	resonar		<es-acertar-conjugation> |
	rodar			<es-acertar-conjugation> |
	sobrevolar	<es-acertar-conjugation> |
	solar		<es-acertar-conjugation> |
	soldar	<es-acertar-conjugation> |
	soltar	<es-acertar-conjugation> |
	sonar		<es-acertar-conjugation> |
	soñar		<es-acertar-conjugation> |
	superpoblar	<es-acertar-conjugation> |
	tostar	<es-acertar-conjugation> |
	tronar	<es-acertar-conjugation> |
	volar		<es-acertar-conjugation> |
	ahumar	<es-acertar-conjugation> |
	ahusar	<es-acertar-conjugation> |
	aunar		<es-acertar-conjugation> |
	aupar		<es-acertar-conjugation> |
	maullar	<es-acertar-conjugation> |
	rehusar	<es-acertar-conjugation> |
	sahumar	<es-acertar-conjugation> |
	contar	<es-acertar-conjugation> |
	aullar		<es-acertar-conjugation> |
	vaciar		<es-acertar-conjugation> |
	aliar			<es-acertar-conjugation> |
	amnistiar	<es-acertar-conjugation> |
	ampliar	<es-acertar-conjugation> |
	ansiar	<es-acertar-conjugation> |
	arriar	<es-acertar-conjugation> |
	ataviar	<es-acertar-conjugation> |
	averiar	<es-acertar-conjugation> |
	aviar		<es-acertar-conjugation> |
	biografiar		<es-acertar-conjugation> |
	cablegrafiar	<es-acertar-conjugation> |
	calcografiar	<es-acertar-conjugation> |
	caligrafiar		<es-acertar-conjugation> |
	chirriar	<es-acertar-conjugation> |
	ciar			<es-acertar-conjugation> |
	confiar		<es-acertar-conjugation> |
	contrariar	<es-acertar-conjugation> |
	criar				<es-acertar-conjugation> |
	desafiar		<es-acertar-conjugation> |
	descarriar	<es-acertar-conjugation> |
	desconfiar	<es-acertar-conjugation> |
	desliar		<es-acertar-conjugation> |
	desvariar	<es-acertar-conjugation> |
	desviar	<es-acertar-conjugation> |
	enfriar	<es-acertar-conjugation> |
	enviar	<es-acertar-conjugation> |
	escalofriar	<es-acertar-conjugation> |
	espiar	<es-acertar-conjugation> |
	esquiar	<es-acertar-conjugation> |
	estriar	<es-acertar-conjugation> |
	expatriar	<es-acertar-conjugation> |
	expiar		<es-acertar-conjugation> |
	extasiar	<es-acertar-conjugation> |
	extraviar	<es-acertar-conjugation> |
	fiar		<es-acertar-conjugation> |
	fotografiar	<es-acertar-conjugation> |
	guiar		<es-acertar-conjugation> |
	hastiar	<es-acertar-conjugation> |
	inventariar	<es-acertar-conjugation> |
	liar		<es-acertar-conjugation> |
	malcriar	<es-acertar-conjugation> |
	mecanografiar	<es-acertar-conjugation> |
	piar		<es-acertar-conjugation> |
	porfiar	<es-acertar-conjugation> |
	radiografiar	<es-acertar-conjugation> |
	recriar		<es-acertar-conjugation> |
	reenviar	<es-acertar-conjugation> |
	resfriar	<es-acertar-conjugation> |
	rociar		<es-acertar-conjugation> |
	sumariar	<es-acertar-conjugation> |
	taquigrafiar	<es-acertar-conjugation> |
	telegrafiar		<es-acertar-conjugation> |
	variar	<es-acertar-conjugation> |
	vidriar	<es-acertar-conjugation> |
	xerografiar	<es-acertar-conjugation> |
	actuar		<es-acertar-conjugation> |
	acentuar	<es-acertar-conjugation> |
	atenuar		<es-acertar-conjugation> |
	conceptuar	<es-acertar-conjugation> |
	consensuar	<es-acertar-conjugation> |
	continuar		<es-acertar-conjugation> |
	desconceptuar	<es-acertar-conjugation> |
	deshabituar	<es-acertar-conjugation> |
	desvirtuar	<es-acertar-conjugation> |
	devaluar	<es-acertar-conjugation> |
	efectuar	<es-acertar-conjugation> |
	evaluar		<es-acertar-conjugation> |
	exceptuar	<es-acertar-conjugation> |
	extenuar	<es-acertar-conjugation> |
	fluctuar	<es-acertar-conjugation> |
	graduar		<es-acertar-conjugation> |
	habituar	<es-acertar-conjugation> |
	insinuar	<es-acertar-conjugation> |
	interactuar	<es-acertar-conjugation> |
	licuar		<es-acertar-conjugation> |
	perpetuar	<es-acertar-conjugation> |
	puntuar		<es-acertar-conjugation> |
	redituar	<es-acertar-conjugation> |
	revaluar	<es-acertar-conjugation> |
	situar	<es-acertar-conjugation> |
	tatuar	<es-acertar-conjugation> |
	valuar	<es-acertar-conjugation> |
[VERBOS - "DEGOLLAR"]
	degollar	<es-degollar-conjugation> |
	regoldar	<es-degollar-conjugation> |
[VERBOS - "AVERGONZAR"]
	avergonzar	<es-avergonzar-conjugation> |
	-aizar	<es-avergonzar-conjugation> |[VERBOS - "ENRAIZAR"]
	-eizar	<es-avergonzar-conjugation> |
	orzar		<es-regular-ar-conjugation> |[VERBOS - "FORZAR"]
	-orzar	<es-avergonzar-conjugation> |
	-pezar	<es-avergonzar-conjugation> |[VERBOS - "TROPEZAR"]
	-menzar	<es-avergonzar-conjugation> |
[VERBOS - "NEGAR"]
	negar		<es-negar-conjugation> |
	anegar	<es-negar-conjugation> |
	cegar		<es-negar-conjugation> |
	denegar	<es-negar-conjugation> |
	desasosegar	<es-negar-conjugation> |
	desplegar		<es-negar-conjugation> |
	estregar		<es-negar-conjugation> |
	fregar		<es-negar-conjugation> |
	plegar		<es-negar-conjugation> |
	refregar	<es-negar-conjugation> |
	regar			<es-negar-conjugation> |
	renegar		<es-negar-conjugation> |
	replegar	<es-negar-conjugation> |
	restregar	<es-negar-conjugation> |
	segar			<es-negar-conjugation> |
	sosegar		<es-negar-conjugation> |
	trasegar	<es-negar-conjugation> |
	jugar			<es-negar-conjugation> |
	rogar			<es-negar-conjugation> |
	-olgar		<es-negar-conjugation> |
[VERBOS - "VOLCAR"]
	volcar		<es-volcar-conjugation> |
	emporcar	<es-volcar-conjugation> |
	revolcar	<es-volcar-conjugation> |
	trastrocar	<es-volcar-conjugation> |
	trocar		<es-volcar-conjugation> |
[VERBOS - "CAZAR"]
	-zar		<es-cazar-conjugation> |
	menguar	<es-cazar-conjugation> |
	achiguar	<es-cazar-conjugation> |
	aguar			<es-cazar-conjugation> |
	amortiguar	<es-cazar-conjugation> |
	apaciguar		<es-cazar-conjugation> |
	atestiguar	<es-cazar-conjugation> |
	averiguar		<es-cazar-conjugation> |
	desaguar		<es-cazar-conjugation> |
	deslenguarse	<es-cazar-conjugation> |
	fraguar		<es-cazar-conjugation> |
	santiguar	<es-cazar-conjugation> |
	-car			<es-cazar-conjugation> |	[VERBOS - "SACAR"]
[VERBOS - "LLEGAR"]
	-gar	<es-llegar-conjugation> |
[VERBOS - "ANDAR"]
	andar			<es-andar-conjugation> |
	desandar	<es-andar-conjugation> |
[VERBOS - "DAR"]
	dar	<es-dar-conjugation> |
[														]
[---------- "-ER"---------]
[VERBOS "HABER"]
	haber	<es-haber-conjugation> |
[VERBOS "CABER"]
	caber	<es-caber-conjugation> |	
[VERBOS - "TENER"]
	tener	<es-tener-conjugation> |
	-tener	<es-tener-conjugation> |
[VERBOS - "ESCOCER"]
	escocer		<es-escocer-conjugation> |
	cocer			<es-escocer-conjugation> |
	-cocer		<es-escocer-conjugation> |
	torcer		<es-escocer-conjugation> |
	-torcer		<es-escocer-conjugation> |
[VERBOS - "ENTENDER"]
	entender	<es-entender-conjugation> |
	-ender	<es-entender-conjugation> |
	cerner		<es-entender-conjugation> |
	heder			<es-entender-conjugation> |
	perder			<es-entender-conjugation> |
	reverter		<es-entender-conjugation> |
	verter			<es-entender-conjugation> |
	mover				<es-entender-conjugation> |[VERBOS - "MOVER"]
	condolerse	<es-entender-conjugation> |
	conmover		<es-entender-conjugation> |
	demoler			<es-entender-conjugation> |
	doler				<es-entender-conjugation> |
	llover			<es-entender-conjugation> |
	moler				<es-entender-conjugation> |
	soler				<es-entender-conjugation> |
	morder			<es-entender-conjugation> |
	promover		<es-entender-conjugation> |
	remorder		<es-entender-conjugation> |
	remover			<es-entender-conjugation> |
[VERBOS - "ENTENDER" PARTICIPIO IRREGULAR]
	absolver		<es-entender2-conjugation> |
	desenvolver	<es-entender2-conjugation> |
	devolver		<es-entender2-conjugation> |
	disolver		<es-entender2-conjugation> |
	envolver		<es-entender2-conjugation> |
	resolver		<es-entender2-conjugation> |
	revolver		<es-entender2-conjugation> |
	volver			<es-entender2-conjugation> |
[VERBOS - "MECER"]
	mecer			<es-mecer-conjugation> |
	coercer		<es-mecer-conjugation> |
	convercer	<es-mecer-conjugation> |
	ejercer		<es-mecer-conjugation> |
	vencer		<es-mecer-conjugation> |
[VERBOS - "PREVER"]
	prever		<es-prever-conjugation> |
	entrever	<es-prever-conjugation> |
[VERBOS - "VER"]
	ver				<es-ver-conjugation> |
[VERBOS - "PONER"]
	poner		<es-poner-conjugation> |
	-poner	<es-poner-conjugation> |
[VERBOS - "PODER"]
	poder	<es-poder-conjugation> |
[VERBOS - "HACER"]
	hacer				<es-hacer-conjugation> |
	-hacer			<es-hacer-conjugation> |
	satisfacer	<es-hacer-conjugation> |
[VERBOS - "TRAER"]
	traer				<es-traer-conjugation> |
	-traer			<es-traer-conjugation> |
[VERBOS - "CAER"]
	caer	<es-caer-conjugation> |
	-caer	<es-caer-conjugation> |
	-eer	<es-caer-conjugation> |[VERBOS - "LEER", para "proveer" se toma participio regular "proveído"]
[VERBOS - "AGRADECER"]
	-cer	<es-agradecer-conjugation> |
	-ger	<es-agradecer-conjugation> |[VERBOS - "COGER"]
[VERBOS - "OLER"]
	oler	<es-oler-conjugation> |
[VERBOS - "QUERER"]
	-querer	<es-querer-conjugation> |
[VERBOS - "ROER"]
	-roer	<es-roer-conjugation> |
[VERBOS - "SABER"]
	saber	<es-saber-conjugation> |
[VERBOS - "VALER"]
	-valer	<es-valer-conjugation> |
[OTROS REGULARES CON EXCEPCIONES]
	romper		<es-romper-conjugation>	| [excepcion en su participio "roto"]
	tañer			<es-tañer-conjugation> | [excepcion en su participio "tañendo"]
[														]
[---------- "-IR"---------]
[VERBOS - "ADQUIRIR"]
	adquirir	<es-adquirir-conjugation> |
	-quirir		<es-adquirir-conjugation> |
[VERBOS - "ASIR"]
	asir			<es-asir-conjugation> | [excepcion en 1PS "azgo"]
[VERBOS - "BENDECIR"]
	bendecir	<es-bendecir-conjugation> | 
	maldecir	<es-bendecir-conjugation> | 
[VERBOS - "PREDECIR"]
	predecir		<es-predecir-conjugation> | 
	contradecir	<es-predecir-conjugation> | 
	desdecir		<es-predecir-conjugation> | 
[VERBOS - "DECIR"]
	decir				<es-decir-conjugation> | 
	-decir			<es-decir-conjugation> | 
[VERBOS - "VENIR"]
	-venir			<es-venir-conjugation> | 
[VERBOS - "CEÑIR"]
	ceñir			<es-ceñir-conjugation> | 
	-eñir			<es-ceñir-conjugation> | 
[VERBOS - "CONDUCIR"]
	conducir	<es-conducir-conjugation> | 
	-ucir			<es-conducir-conjugation> | 
[VERBOS - "ERGUIR"]
	erguir		<es-erguir-conjugation> |
[VERBOS - "CONSTRUIR"]
	construir	<es-construir-conjugation> | 
	-uir			<es-construir-conjugation> | 
	argüir		<es-construir-conjugation> | 
[VERBOS - "DISCERNIR"]
	discernir	<es-discernir-conjugation> | 
	-ernir		<es-discernir-conjugation> | 
	hendir		<es-discernir-conjugation> | 
[VERBOS - "DORMIR"]
	dormir		<es-dormir-conjugation> | 
[VERBOS - "MORIR"  - excpecion en participio "muerto"]
	morir			<es-morir-conjugation> | 
[VERBOS - "OIR"]
	-oír		<es-oir-conjugation> | 
	-oir		<es-oir-conjugation> | 
[VERBOS - "SENTIR"]
	-entir	<es-sentir-conjugation> |
	-erir		<es-sentir-conjugation> |
	-ertir	<es-sentir-conjugation> |
	-ervir	<es-sentir-conjugation> |
[VERBOS - "PEDIR"]
	-dir		<es-pedir-conjugation> | [pedir]
	-bir		<es-pedir-conjugation> | [concebir]
	-tir		<es-pedir-conjugation> | [derretir]
	-mir		<es-pedir-conjugation> | [gemir]
	-chir		<es-pedir-conjugation> | [henchir]
[VERBOS - "SALIR"]
	-salir	<es-salir-conjugation> |
[VERBOS - "MULLIR"]
	-ullir	<es-mullir-conjugation> |
	-ñir		<es-mullir-conjugation> |
[VERBOS - "PUDRIR"	-	excepcion en su participio]
	-udrir	<es-pudrir-conjugation> |
[VERBOS - "REIR"]
	-reír	<es-reir-conjugation> |
	-reir	<es-reir-conjugation> |
[														]
[														]
[REGULARES]
	-ar 			<es-regular-ar-conjugation> 	| ["cantar"]
	-er				<es-regular-er-conjugation>		|	["temer"]
	-ir				<es-regular-ir-conjugation>			["partir"]


[-----------------------------------------------------------------------------]

[-----------------------------------------------------------------------------]

[-----------------------------------------------------------------------------]


[ESQUEMA REFERENCIA:
<es-verbo-conjugation> ::=
	5		particula base
	2		present participle / gerundio
	3		past participle / participio


<es-verbo-tabulation> ::=
  a1  presente |
  a2	pasado	|
	a3	pasado perfecto "he estado" | (ingles 'perfect')
	a4	pasado pluscuamperfecto "había estado" | (ingles 'past perfect')
  a5  futuro |
	a6	pasado imperfecto| (exclusivo infsp)
	p*	voz pasiva "cambiado por"

]


[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]

[VERBO "SER"]
<es-ser-conjugation> ::=
  2		siendo |
  3		sido |	
  <es-ser-tabulation>

<es-ser-tabulation> ::=
  a1+  <es-ser-present> |
  a1-  no <es-ser-present> |
  a2+  <es-ser-past> |
  a2-  no <es-ser-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
  a5+  <es-ser-future> |
  a5-  no <es-ser-future> |
	a6+	<es-ser-past-imperfect> |
	a6-	no <es-ser-past-imperfect> |
	p*	3 por
  
<es-ser-present> ::=
  soy | eres | es | somos | sois | son
  
<es-ser-past> ::=
  fui | fuiste | fue | fuimos | fuisteis | fueron

<es-ser-future> ::=
  seré | serás | será | seremos | seréis	|	serán

<es-ser-past-imperfect> ::=
	era | eras | era | éramos | erais | eran
  
 

[VERBO "ESTAR"]
<es-estar-conjugation> ::=
	5 	<es-trie-regular-stem> |	[slot 5 we use for the stem of the verb]
  2		estando |
  3		estado |	
  <es-estar-tabulation>

<es-estar-tabulation> ::=
  a1+  <es-estar-present> |
  a1-  no <es-estar-present> |
  a2+  <es-estar-past> |
  a2-  no <es-estar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
  a5+  <es-estar-future> |
  a5-  no <es-estar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por
  
<es-estar-present> ::=
  estoy | estás | está | estamos | estáis | están
  
<es-estar-past> ::=
  estuve | estuviste | estuvo | estuvimos | estuvisteis | estuvieron
  
<es-estar-future> ::=
  estará | estarás | estará | estaremos | estaréis	|	estarán


[VERBO "IR"]
<es-ir-conjugation> ::=
	2	<es-trie-irregular-ir-present-participle> |
	3	<es-trie-irregular-ir-past-participle> |
	5	<es-trie-irregular-ir-present-verb-form> |
	6	<es-trie-irregular-ir-past> |
	<es-irregular-ir-tabulation>

<es-trie-irregular-ir-present-participle> ::=
	*	yendo

<es-trie-irregular-ir-past-participle> ::=
	*	ido

<es-trie-irregular-ir-present-verb-form> ::=
	*	voy

<es-trie-irregular-ir-past> ::=
	*	iba

<es-irregular-ir-tabulation> ::=
	a1+	<es-irregular-ir-present> |
	a1-	no <es-irregular-ir-present> |
	a2+	<es-irregular-ir-past> |
	a2-	no <es-irregular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-ir-future> |
	a5-	no <es-irregular-ir-future> |
	a6+	<es-irregular-ir-past-imperfect> |
	a6-	no <es-irregular-ir-past-imperfect> |
	p*	3 por

<es-irregular-ir-present> ::=
	voy | vas | va | vamos | vais | van

<es-irregular-ir-past> ::=
	fui | fuiste | fue	|	fuimos	| fuisteis | fueron

<es-irregular-ir-future> ::=
	iré | irás | irá | iremos | iréis | irán

<es-irregular-ir-past-imperfect> ::=
	iba | ibas | iba | ibamos | ibais | iban


[														]
[---------- "-AR"---------]

[VERBOS - "ACERTAR"]
<es-acertar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-acertar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-acertar-tabulation>

<es-trie-irregular-acertar-stem> ::=
	*ebrar	5iebr |
	*edrar	5iedr |
	*elar		4iel |
	*eldar	5ield |
	*emblar	6iembl |
	*embrar	6iembr |
	*endar	5iend |
	*ensar	5iens |
	*entar	5ient |
	*ernar	5iern |
	*errar	5ierr |
	*esar		4ies |
	*estar	5iest |
	*etar		4iet |
	*evar		4iev |
	*ertar	5iert |
	*ijar	4íj |
	*ijar	4íj |
	*ilar	4íl |
	*inar	4ín |
	*irar	4ír |
	*islar	5ísl |
	*itar	4ít |
	*obar	4ueb |
	*oblar	5uebl |
	*odar	4ued |
	*olar	4uel |
	*oldar	5ueld |
	*ollar	5uell |
	*oltar	5uelt |
	*onar	4uen |
	*ontar	5uent |
	*ontrar	6uentr |
	*orar	4uer |
	*ordar	5uerd |
	*ornar	5uern |
	*osar	4ues |
	*ostar	5uest |
	*ostrar	6uestr |
	*ovar	4uev |
	*oñar	4ueñ |
	*ullar	5úll |
	*umar	4úm |
	*unar	4ún |
	*upar	4úp |
	*usar	4ús |
	*uar 3ú	|	[terminados en -uar]
	*iar	3í

<es-irregular-acertar-tabulation> ::=
	a1+	<es-irregular-acertar-present> |
	a1-	no <es-irregular-acertar-present> |
	a2+	<es-regular-ar-past> |
	a2-	no <es-regular-ar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ar-future> |
	a5-	no <es-regular-ar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por

<es-irregular-acertar-present> ::=
	6+o | 6+as | 6+a | 5+amos | 5+áis | 6+an



[VERBOS - "DEGOLLAR"]
<es-degollar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-degollar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-acertar-tabulation>

<es-trie-irregular-degollar-stem> ::=
	*oldar	5üeld |
	*ollar	5üell


[VERBOS - "CAZAR"]
<es-cazar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-cazar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-cazar-tabulation>

<es-trie-irregular-cazar-stem> ::=
	*zar 3c |
	*guar	3ü |
	*car	3qu ["SACAR"]

<es-irregular-cazar-tabulation> ::=
	a1+	<es-regular-ar-present> |
	a1-	no <es-regular-ar-present> |
	a2+	<es-irregular-cazar-past> |
	a2-	no <es-irregular-cazar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ar-future> |
	a5-	no <es-regular-ar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por

<es-irregular-cazar-past> ::=
	6+é | 5+aste | 5+ó | 5+amos | 5+asteis | 5+aron

[VERBOS - "AVERGONZAR"]
<es-avergonzar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-avergonzar-stem> |
	7	<es-trie-irregular-cazar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-avergonzar-tabulation>

<es-trie-irregular-avergonzar-stem> ::=
	*onzar	5üenz |
	*izar	4íz | [ENRAIZAR]
	*orzar	5uerz | [FORZAR]
	*enzar	5ienz | [TROPEZAR]
	*ezar	4iez


<es-irregular-avergonzar-tabulation> ::=
	a1+	<es-irregular-acertar-present> |
	a1-	no <es-irregular-acertar-present> |
	a2+	<es-irregular-avergonzar-past> |
	a2-	no <es-irregular-avergonzar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ar-future> |
	a5-	no <es-regular-ar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por

<es-irregular-avergonzar-past> ::=
	7+é | 5+aste | 5+ó | 5+amos | 5+asteis | 5+aron


[VERBOS - "NEGAR"]
<es-negar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-negar-stem> |
	7	<es-trie-irregular-llegar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-avergonzar-tabulation>

<es-trie-irregular-negar-stem> ::=
	*egar	4ieg |
	*ugar	4ueg | ["JUGAR"]
	*ogar	4ueg | ["ROGAR"]
	*olgar	5uelg



[VERBOS - "VOLCAR"]
<es-volcar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-volcar-stem> |
	7	<es-trie-irregular-sacar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-avergonzar-tabulation>

<es-trie-irregular-volcar-stem> ::=
	*olcar	5uelc |
	*orcar	5uerc |
	*rocar	5ruec

[VERBOS - "LLEGAR"]
<es-llegar-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-llegar-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-cazar-tabulation>

<es-trie-irregular-llegar-stem> ::=
	*gar 2u


[VERBOS - "ANDAR"]
<es-andar-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-andar-tabulation>

<es-irregular-andar-tabulation> ::=
	a1+	<es-regular-ar-present> |
	a1-	no <es-regular-ar-present> |
	a2+	<es-irregular-andar-past> |
	a2-	no <es-irregular-andar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ar-future> |
	a5-	no <es-regular-ar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por

<es-irregular-andar-past> ::=
	5+uve | 5+uviste | 5+uvo | 5+uvimos | 5+uvisteis | 5+uvieron


[VERBOS - "DAR"]
<es-dar-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-regular-ar-present-participle> |
	3	<es-trie-regular-ar-past-participle> |
	<es-irregular-dar-tabulation>

<es-irregular-dar-tabulation> ::=
	a1+	<es-irregular-dar-present> |
	a1-	no <es-irregular-dar-present> |
	a2+	<es-irregular-dar-past> |
	a2-	no <es-irregular-dar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ar-future> |
	a5-	no <es-regular-ar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por

<es-irregular-dar-present> ::=
	5+oy | 5+as | 5+a | 5+amos | 5+ais | 5+an

<es-irregular-dar-past> ::=
	5+i | 5+iste | 5+io | 5+imos | 5+isteis | 5+ieron


[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]
[														]
[---------- "-ER"---------]


[VERBO "TENER"]
<es-tener-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-tener-stem-gral> |
	2		6+eniendo	|	[present participle]
	3		6+enido		|	[past participle] [todo:probar inflexión femenina]
	<es-tener-tabulation>

<es-tener-stem-gral> ::=
	*	4			[drop the last x letters]

<es-tener-tabulation> ::=
  a1+  <es-tener-present> |
  a1-  no <es-tener-present> |
  a2+  <es-tener-past> |
  a2-  no <es-tener-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
  a5+  <es-tener-future> |
  a5-  no <es-tener-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por
  
<es-tener-present> ::=
	6+engo | 6+ienes | 6+iene | 6+enemos | 6+enéis | 6+ienen
  
<es-tener-past> ::=
  6+uve | 6+uviste | 6+uvo | 6+uvimos | 6+uvisteis | 6+uvieron
  
<es-tener-future> ::=
	6+endré | 6+endrás | 6+endrá | 6+endremos | 6+endréis | 6+endrán


[VERBO "CABER"]
<es-caber-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-caber-stem> | [CUP- usado en past (cupe, cupiste...)]
	7	<es-trie-irregular-caber-2-stem> | [quepo]
	8	<es-trie-regular-stem> |
	2	<es-trie-regular-er-present-participle> | 	[cabiendo]
	3	<es-trie-regular-er-past-participle> | 		[cabido]
	<es-irregular-caber-tabulation>

<es-trie-irregular-caber-stem> ::=
	caber	cup

<es-trie-irregular-caber-2-stem> ::=
	caber	quep

<es-irregular-caber-tabulation> ::=
	a1+	<es-irregular-caber-present> |
	a1-	no <es-irregular-caber-present> |
	a2+	<es-irregular-caber-past> |
	a2-	no <es-irregular-caber-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-caber-future> |
	a5-	no <es-irregular-caber-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-caber-present> ::=
	7+o	| 5+es | 5+e | 5+emos | 5+éis | 5+en

<es-irregular-caber-past> ::=
	6+e | 6+iste | 6+o | 6+imos | 6+isteis | 6+ieron

<es-irregular-caber-future> ::=
	8+ré | 8+rás | 8+rá | 8+remos | 8+réis | 8+rán

<es-irregular-caber-past-imperfect> ::=
	5+ía | 5+ías | 5+ía | 5+íamos | 5+íais | 5+ían



[VERBO - "HABER"]
<es-haber-conjugation> ::=
	5	<es-trie-regular-stem> | [hab-]
	2	<es-trie-regular-er-present-participle> | [habiendo]
	3	<es-trie-regular-er-past-participle> | [habido]
	<es-haber-tabulation>

<es-trie-irregular-haber-stem> ::=
	haber	hub

<es-haber-tabulation> ::=
	a1+	<es-irregular-haber-present> |
	a1-	no <es-irregular-haber-present> |
	a2+	<es-irregular-haber-past> |
	a2-	no <es-irregular-haber-past> |
	a3	( t1 haber ) 3 | [he habido / has habido..]
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-haber-future> |
	a5-	no <es-irregular-haber-future> |
	a6+	<es-irregular-caber-past-imperfect> |
	a6-	no <es-irregular-caber-past-imperfect> |
	p*	3 por

<es-irregular-haber-present> ::=
	he | has | ha | hemos | habéis | han

<es-irregular-haber-past> ::=
	hube | hubiste | hubo | hubimos | hubisteis | hubieron

<es-irregular-haber-future> ::=
	5+ré | 5+rás | 5+rá | 5+remos | 5+réis | 5+rán



[VERBO - "ENTENDER"]
<es-entender-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-entender-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-entender-tabulation>

<es-trie-irregular-entender-stem> ::=
	*ender	5iend |	[encender]
	*erner	5iern |	[cerner]
	*eder		4ied 	|	[heder]	
	*erder	5ierd | [perder]
	*erter	5iert |	[verter]
	*over		4uev 	| [mover]
	*olver	5uelv |
	*oler		4uel 	|
	*order	5ued

<es-irregular-entender-tabulation> ::=
	a1+	<es-irregular-entender-present> |
	a1-	no <es-irregular-entender-present> |
	a2+	<es-regular-er-past> |
	a2-	no <es-regular-er-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-entender-present> ::=
	6+o | 6+es | 6+e | 5+emos | 5+éis | 6+en


[VERBO - "ENTENDER" PARTICIPIO IRREGULAR]
<es-entender2-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-entender-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-iregular-enteder2-past-participle> |
	<es-irregular-entender-tabulation>

<es-trie-iregular-enteder2-past-participle> ::=
 *	5uelto


[VERBOS - "PONER"]
<es-poner-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-poner-stem> |
	7	<es-trie-irregular-poner-2-stem> |
	8	<es-trie-poner-stem2> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-poner-past-participle> |
	<es-irregular-caber-tabulation>

<es-trie-poner-stem2> ::=
	*	2d

<es-trie-irregular-poner-stem> ::=
	*poner	4us

<es-trie-irregular-poner-2-stem> ::=
	*poner	2g

<es-trie-poner-past-participle> ::=
	* 4uesto


[VERBOS - "PODER"]
<es-poder-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-poder-stem> |
	7	<es-trie-irregular-poder-2-stem> |
	8	<es-trie-regular-stem> |
	2	<es-trie-irregular-poder-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-poder-tabulation>

<es-trie-irregular-poder-stem> ::=
	poder	pued

<es-trie-irregular-poder-2-stem> ::=
	poder	pud

<es-trie-irregular-poder-present-participle> ::=
	poder	pudiendo

<es-irregular-poder-tabulation> ::=
	a1+	<es-irregular-entender-present> |
	a1-	no <es-irregular-entender-present> |
	a2+	<es-irregular-poder-past> |
	a2-	no <es-irregular-poder-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-caber-future> |
	a5-	no <es-irregular-caber-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-poder-past> ::=
	7+e | 7+iste | 7+o | 7+imos | 7+ieron | 7+ieron

[VERBOS - "AGRADECER"]
<es-agradecer-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-agradecer-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-agradecer-tabulation>

<es-trie-irregular-agradecer-stem> ::=
	*cer	3zc |
	*ger	3j 	["coger"]

<es-irregular-agradecer-tabulation> ::=
	a1+	<es-irregular-agradecer-present> |
	a1-	no <es-irregular-agradecer-present> |
	a2+	<es-regular-er-past> |
	a2-	no <es-regular-er-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-agradecer-present> ::=
	6+o | 5+es | 5+e | 5+emos | 5+éis | 5+en


[VERBOS - "HACER"]
<es-hacer-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-hacer-stem> |
	7	<es-trie-irregular-hacer-2-stem> |
	8	<es-trie-irregular-hacer-3-stem> |
	9	<es-trie-irregular-hacer-4-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-irregular-hacer-past-participle> |
	<es-irregular-hacer-tabulation>

<es-trie-irregular-hacer-stem> ::=
	*acer	4ic

<es-trie-irregular-hacer-2-stem> ::=
	*cer	3g

<es-trie-irregular-hacer-3-stem> ::=
	*acer	4iz

<es-trie-irregular-hacer-4-stem> ::=
	*cer	3

<es-trie-irregular-hacer-past-participle> ::=
	*acer	4echo

<es-irregular-hacer-tabulation> ::=
	a1+	<es-irregular-caber-present> |
	a1-	no <es-irregular-caber-present> |
	a2+	<es-irregular-hacer-past> |
	a2-	no <es-irregular-hacer-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-hacer-future> |
	a5-	no <es-irregular-hacer-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-hacer-past> ::=
	6+e | 6+iste | 8+o | 6+imos | 6+istéis | 6+ieron

<es-irregular-hacer-future> ::=
	9+ré | 9+rás | 9+rá | 9+remos | 9+réis | 9+rán


[VERBOS - "TRAER"]
<es-traer-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-irregular-traer-present-participle> |
	3	<es-trie-irregular-traer-past-participle> |
	<es-irregular-traer-tabulation>

<es-trie-irregular-traer-present-participle> ::=
	*	2yendo

<es-trie-irregular-traer-past-participle> ::=
	*	2ído

<es-irregular-traer-tabulation> ::=
	a1+	<es-irregular-traer-present> |
	a1-	no <es-irregular-traer-present> |
	a2+	<es-irregular-traer-past> |
	a2-	no <es-irregular-traer-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-traer-present> ::=
	5+igo | 5+es | 5+e | 5+emos | 5+éis | 5+en

<es-irregular-traer-past> ::=
	5+je | 5+jiste | 5+jo | 5+jimos | 5+jisteis | 5+jeron




[VERBOS - "CAER"]
<es-caer-conjugation> ::=
	5	<es-trie-regular-stem> |
	7	<es-trie-irregular-caer-stem> |
	2	<es-trie-irregular-traer-present-participle> |
	3	<es-trie-irregular-traer-past-participle> |
	<es-irregular-caer-tabulation>

<es-trie-irregular-caer-stem> ::=
	*eer 2 | [leer]
	*er	2ig
	

<es-irregular-caer-tabulation> ::=
	a1+	<es-irregular-caber-present> |
	a1-	no <es-irregular-caber-present> |
	a2+	<es-irregular-caer-past> |
	a2-	no <es-irregular-caer-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-caer-past> ::=
	5+í | 5+íste | 5+yó | 5+ímos | 5+ísteis | 5+yeron


[VERBOS - "ESCOCER"]
<es-escocer-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-escocer-stem> |
	7	<es-trie-irregular-escocer-2-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-escocer-tabulation>

<es-trie-irregular-escocer-stem> ::=
	*ocer		4uez |
	*orcer	5uerz

<es-trie-irregular-escocer-2-stem> ::=
	*ocer		4uec |
	*orcer	5uerc

<es-irregular-escocer-tabulation> ::=
	a1+	<es-irregular-escocer-present> |
	a1-	no <es-irregular-escocer-present> |
	a2+	<es-regular-er-past> |
	a2-	no <es-regular-er-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-escocer-present> ::=
	6+o | 7+es | 7+e | 5+emos | 5+éis | 7+en


[VERBOS - "OLER"]
<es-oler-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-oler-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-entender-tabulation>

<es-trie-irregular-oler-stem> ::=
	oler	huel


[VERBOS - "MECER"]
<es-mecer-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-mecer-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-agradecer-tabulation>

<es-trie-irregular-mecer-stem> ::=
	*cer	3z


[VERBOS - "PREVER"]
<es-prever-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-prever-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-irregular-prever-past-participle> |
	<es-irregular-prever-tabulation>

<es-trie-irregular-prever-stem> ::=
	*	1

<es-trie-irregular-prever-past-participle> ::=
	*	2isto

<es-irregular-prever-tabulation> ::=
	a1+	<es-irregular-prever-present> |
	a1-	no <es-irregular-prever-present> |
	a2+	<es-regular-er-past> |
	a2-	no <es-regular-er-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-irregular-prever-past-imperfect> |
	a6-	no <es-irregular-prever-past-imperfect> |
	p*	3 por

<es-irregular-prever-present> ::=
	5+eo | 5+és | 5+é | 5+emos | 5+éis | 5+én

<es-irregular-prever-past-imperfect> ::=
	6+ía | 6+ías | 6+ía | 6+íamos | 6+ían | 6+ían


[VERBOS - "VER"]
<es-ver-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-prever-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-irregular-prever-past-participle> |
	<es-irregular-ver-tabulation>

<es-irregular-ver-tabulation> ::=
	a1+	<es-irregular-ver-present> |
	a1-	no <es-irregular-ver-present> |
	a2+	<es-regular-ver-past> |
	a2-	no <es-regular-ver-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-irregular-prever-past-imperfect> |
	a6-	no <es-irregular-prever-past-imperfect> |
	p*	3 por

<es-irregular-ver-present> ::=
	5+eo | 5+es | 5+e | 5+emos | 5+éis | 5+en

<es-regular-ver-past> ::=
	5+i | 5+iste | 5+io | 5+imos | 5+isteis | 5+ieron


[VERBOS - "QUERER"]
<es-querer-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-querer-stem> |
	7	<es-trie-irregular-querer-stem2> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-querer-tabulation>

<es-trie-irregular-querer-stem>	::=
	*	4ier

<es-trie-irregular-querer-stem2>	::=
	*	4is

<es-irregular-querer-tabulation> ::=
	a1+	<es-irregular-querer-present> |
	a1-	no <es-irregular-querer-present> |
	a2+	<es-irregular-querer-past> |
	a2-	no <es-irregular-querer-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-querer-future> |
	a5-	no <es-irregular-querer-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-querer-present> ::=
	6+o | 6+es | 6+e | 5+emos | 5+éis | 6+en

<es-irregular-querer-past> ::=
	7+e | 7+iste | 7+o | 7+imos | 7+isteis | 7+ieron

<es-irregular-querer-future> ::=
	5+ré | 5+rás | 5+rá | 5+remos | 5+réis | 5+rán


[VERBOS - "ROER"]
<es-roer-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-irregular-roer-present-participle> |
	3	<es-trie-irregular-roer-past-participle> |
	<es-irregular-roer-tabulation>

<es-trie-irregular-roer-present-participle>	::=
	*oer	2yendo

<es-trie-irregular-roer-past-participle>	::=
	*oer	2ído


<es-irregular-roer-tabulation> ::=
	a1+	<es-regular-er-present> |
	a1-	no <es-regular-er-present> |
	a2+	<es-irregular-roer-past> |
	a2-	no <es-irregular-roer-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-roer-past> ::=
	5+í | 5+íste | 5+yó	| 5+ímos | 5+ísteis | 5+yeron


[VERBOS - "SABER"]
<es-saber-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-saber-stem> |
	7	<es-trie-irregular-saber-stem2> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-saber-tabulation>

<es-trie-irregular-saber-stem>	::=
	*	4up

<es-trie-irregular-saber-stem2>	::=
	*	4is

<es-irregular-saber-tabulation> ::=
	a1+	<es-irregular-saber-present> |
	a1-	no <es-irregular-saber-present> |
	a2+	<es-irregular-saber-past> |
	a2-	no <es-irregular-saber-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-querer-future> |
	a5-	no <es-irregular-querer-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-saber-present> ::=
	sé | 5+es | 5+e | 5+emos | 5+éis | 5+en

<es-irregular-saber-past> ::=
	6+e | 6+iste | 6+o | 6+imos | 6+isteis | 6+ieron


[VERBOS - "VALER"]
<es-valer-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-valer-stem> |
	7	<es-trie-irregular-valer-stem2> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-irregular-valer-tabulation>

<es-trie-irregular-valer-stem>	::=
	*	2g

<es-trie-irregular-valer-stem2>	::=
	*	2d

<es-irregular-valer-tabulation> ::=
	a1+	<es-irregular-valer-present> |
	a1-	no <es-irregular-valer-present> |
	a2+	<es-regular-ir-past> |
	a2-	no <es-regular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-valer-future> |
	a5-	no <es-irregular-valer-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-irregular-valer-present> ::=
	6+o | 5+es | 5+e | 5+emos | 5+éis | 5+en

<es-irregular-valer-future> ::=
	7+ré | 7+rás | 7+rá | 7+remos | 7+réis | 7+rán


[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]
[														]
[---------- "-IR"---------]


[VERBOS - "ADQUIRIR"]
<es-adquirir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-adquirir-stem> |
	2	<es-trie-regular-ir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-adquirir-tabulation>

<es-trie-irregular-adquirir-stem> ::=
	*	3er

<es-irregular-adquirir-tabulation> ::=
	a1+	<es-adquirir-present> |
	a1-	no <es-adquirir-present> |
	a2+	<es-regular-ir-past> |
	a2-	no <es-regular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-adquirir-present> ::=
	6+o | 6+es | 6+e | 5+imos | 5+ís | 6+en

[VERBOS "ASIR"]
<es-asir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-asir-stem> |
	2	<es-trie-regular-ir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-asir-tabulation>

<es-trie-irregular-asir-stem> ::=
	*	2g

<es-irregular-asir-tabulation> ::=
	a1+	<es-irregular-asir-present> |
	a1-	no <es-irregular-asir-present> |
	a2+	<es-regular-ir-past> |
	a2-	no <es-regular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-asir-present> ::=
	6+o | 5+es | 5+e | 5+imos | 5+ís | 5+en


[VERBOS "CONDUCIR"]
<es-conducir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-conducir-stem> |
	8	<es-trie-irregular-conducir-stem2> |
	2	<es-trie-regular-ir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-conducir-tabulation>

<es-trie-irregular-conducir-stem> ::=
	*	3zc

<es-trie-irregular-conducir-stem2> ::=
	*	3j

<es-irregular-conducir-tabulation> ::=
	a1+	<es-irregular-asir-present> |
	a1-	no <es-irregular-asir-present> |
	a2+	<es-irregular-bendecir-past> |
	a2-	no <es-irregular-bendecir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por


[VERBOS "BENDECIR"]
<es-bendecir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-bendecir-stem> |
	7	<es-trie-irregular-bendecir-stem2> |
	8	<es-trie-irregular-bendecir-stem3> |
	2	<es-trie-irregular-bendecir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-bendecir-tabulation>

<es-trie-irregular-bendecir-stem> ::=
	*	4ig

<es-trie-irregular-bendecir-stem2> ::=
	*	4ic

<es-trie-irregular-bendecir-stem3> ::=
	*	4ij

<es-trie-irregular-bendecir-present-participle> ::=
	*	4iciendo


<es-irregular-bendecir-tabulation> ::=
	a1+	<es-irregular-bendecir-present> |
	a1-	no <es-irregular-bendecir-present> |
	a2+	<es-irregular-bendecir-past> |
	a2-	no <es-irregular-bendecir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-bendecir-present> ::=
	6+o | 7+es | 7+e | 5+imos | 5+ís | 7+en

<es-irregular-bendecir-past> ::=
	8+e | 8+iste | 8+o | 8+imos | 8+isteis | 8+eron


[VERBOS "DECIR"]
<es-decir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-bendecir-stem> |
	7	<es-trie-irregular-bendecir-stem2> |
	8	<es-trie-irregular-bendecir-stem3> |
	2	<es-trie-irregular-bendecir-present-participle> |
	3	<es-trie-irregular-decir-present-participle> |
	<es-irregular-decir-tabulation>

<es-trie-irregular-decir-present-participle> ::=
	*	4icho

<es-irregular-decir-tabulation> ::=
	a1+	<es-irregular-bendecir-present> |
	a1-	no <es-irregular-bendecir-present> |
	a2+	<es-irregular-bendecir-past> |
	a2-	no <es-irregular-bendecir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-decir-future> |
	a5-	no <es-irregular-decir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-decir-future> ::=
	diré | dirás	| dirá | diremos | diréis | dirán

[VERBOS "VENIR"]
<es-venir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-venir-stem> |
	7	<es-trie-irregular-venir-stem2> |
	8	<es-trie-irregular-venir-stem3> |
	2	<es-trie-irregular-venir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-venir-tabulation>

<es-trie-irregular-venir-present-participle> ::=
	*	viniendo

<es-trie-irregular-venir-stem>	::=
	*	4eng

<es-trie-irregular-venir-stem2>	::=
	*	4ien

<es-trie-irregular-venir-stem3>	::=
	*	4in

<es-irregular-venir-tabulation> ::=
	a1+	<es-irregular-bendecir-present> |
	a1-	no <es-irregular-bendecir-present> |
	a2+	<es-irregular-bendecir-past> |
	a2-	no <es-irregular-bendecir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-venir-future> |
	a5-	no <es-irregular-venir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-venir-future> ::=
	vendré | vendrás	| vendrá | vendremos | vendréis | vendrán

[VERBOS "PREDECIR"]
<es-predecir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-bendecir-stem> |
	7	<es-trie-irregular-bendecir-stem2> |
	8	<es-trie-irregular-bendecir-stem3> |
	2	<es-trie-irregular-bendecir-present-participle> |
	3	<es-trie-irregular-decir-present-participle> |
	<es-irregular-predecir-tabulation>

<es-irregular-predecir-tabulation> ::=
	a1+	<es-irregular-bendecir-present> |
	a1-	no <es-irregular-bendecir-present> |
	a2+	<es-irregular-bendecir-past> |
	a2-	no <es-irregular-bendecir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por


[VERBOS "CEÑIR"]
<es-ceñir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-ceñir-stem> |
	2	<es-trie-irregular-ceñir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-ceñir-tabulation>

<es-trie-irregular-ceñir-stem> ::=
	*	4iñ

<es-trie-irregular-ceñir-present-participle> ::=
	*	4iñendo


<es-irregular-ceñir-tabulation> ::=
	a1+	<es-irregular-ceñir-present> |
	a1-	no <es-irregular-ceñir-present> |
	a2+	<es-irregular-ceñir-past> |
	a2-	no <es-irregular-ceñir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-ceñir-present> ::=
	6+o | 6+es | 6+e | 5+imos | 5+ís | 6+en

<es-irregular-ceñir-past> ::=
	5+í | 5+iste | 6+ó | 5+imos | 5+isteis | 6+eron

[VERBOS "CONSTRUIR"]
<es-construir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-construir-stem> |
	2	<es-trie-irregular-construir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-ceñir-tabulation>

<es-trie-irregular-construir-present-participle> ::=
	*	2yendo 

<es-trie-irregular-construir-stem> ::=
	*	2y	


[VERBOS "DISCERNIR"]
<es-discernir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-discernir-stem> |
	2	<es-trie-regular-ir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-discernir-tabulation>

<es-trie-irregular-discernir-stem> ::=
	*	5iern

<es-irregular-discernir-tabulation> ::=
	a1+	<es-irregular-ceñir-present> |
	a1-	no <es-irregular-ceñir-present> |
	a2+	<es-regular-ir-past> |
	a2-	no <es-regular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por


[VERBOS "DORMIR"]
<es-dormir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-dormir-stem> |
	7	<es-trie-irregular-dormir-stem2> |
	2	<es-trie-irregular-dormir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-dormir-tabulation>

<es-trie-irregular-dormir-present-participle> ::=
	*mir	5urmiendo	|
	*rir	4uriendo

<es-trie-irregular-dormir-stem> ::=
	*mir	5uerm	|
	*rir	4uer

<es-trie-irregular-dormir-stem2> ::=
	*mir	5urm	|
	*rir	4ur

<es-irregular-dormir-tabulation> ::=
	a1+	<es-irregular-ceñir-present> |
	a1-	no <es-irregular-ceñir-present> |
	a2+	<es-irregular-dormir-past> |
	a2-	no <es-irregular-dormir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-dormir-past> ::=
	5+í | 5+iste | 7+ió | 5+imos | 5+isteis | 7+ieron


[VERBOS "MORIR"  - excpecion en participio "muerto"]
<es-morir-conjugation> ::=
	5	<es-trie-regular-stem>	|
	6	<es-trie-irregular-dormir-stem>	|
	7	<es-trie-irregular-dormir-stem2>	|
	2	<es-trie-irregular-dormir-present-participle> |
	3	muerto |
	<es-irregular-dormir-tabulation>


[VERBOS "OIR"]
<es-oir-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-irregular-oir-present-participle> |
	3	<es-trie-irregular-oir-past-participle> |
	<es-irregular-oir-tabulation>

<es-trie-irregular-oir-present-participle> ::=
	*	2yendo


<es-trie-irregular-oir-past-participle> ::=
	*	2ído

<es-irregular-oir-tabulation> ::=
	a1+	<es-irregular-oir-present> |
	a1-	no <es-irregular-oir-present> |
	a2+	<es-irregular-oir-past> |
	a2-	no <es-irregular-oir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-oir-present> ::=
	5+igo | 5+yes | 5+ye | 5+ímos | 5+ís | 5+yen

<es-irregular-oir-past> ::=
	5+í | 5+íste | 5+yó | 5+ímos | 5+ísteis | 5+yeron


[VERBOS "PEDIR"]
<es-pedir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-pedir-stem> |
	2	6+iendo | [gerundio o present-participle]
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-pedir-tabulation>

<es-trie-irregular-pedir-stem> ::=
	*dir	4id	|
	*stir 5ist	|
	*tir	4it	|
	*bir	4ib	| [consebir]
	*mir	4im	|	[gemir]
	*chir	6inch		[gemir]

<es-irregular-pedir-tabulation> ::=
	a1+	<es-irregular-pedir-present> |
	a1-	no <es-irregular-pedir-present> |
	a2+	<es-irregular-pedir-past> |
	a2-	no <es-irregular-pedir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-pedir-present> ::=
	6+o | 6+es | 6+e | 5+imos | 5+ís | 6+en

<es-irregular-pedir-past> ::=
	5+í | 5+iste | 6+ió | 5+imos | 5+isteis | 6+ieron


[VERBOS "SALIR"]
<es-salir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-salir-stem> |
	7	<es-trie-irregular-salir-stem2> |
	2	<es-trie-regular-ir-present-participle> | 
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-salir-tabulation>

<es-trie-irregular-salir-stem> ::=
	*	2dr	

<es-trie-irregular-salir-stem2> ::=
	*	2g

<es-irregular-salir-tabulation> ::=
	a1+	<es-irregular-salir-present> |
	a1-	no <es-irregular-salir-present> |
	a2+	<es-regular-ir-past> |
	a2-	no <es-regular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-irregular-salir-future> |
	a5-	no <es-irregular-salir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-salir-present> ::=
	7+o | 5+es | 5+e | 5+imos | 5+ís | 5+en

<es-irregular-salir-future> ::=
	6+é | 6+ás | 6+á | 6+emos | 6+éis | 6+án


[VERBOS "ERGUIR"]
<es-erguir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-erguir-stem> |
	7	<es-trie-irregular-erguir-stem2> |
	2	7+iendo | [gerundio o present-participle]
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-erguir-tabulation>

<es-trie-irregular-erguir-stem> ::=
	*	yerg	

<es-trie-irregular-erguir-stem2> ::=
	*	irgu	

<es-irregular-erguir-tabulation> ::=
	a1+	<es-irregular-erguir-present> |
	a1-	no <es-irregular-erguir-present> |
	a2+	<es-irregular-sentir-past> |
	a2-	no <es-irregular-sentir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-erguir-present> ::=
	6+o | 6+ues | 6+ue | 5+imos | 5+ís | 6+uen



[VERBOS "SENTIR"]
<es-sentir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-sentir-stem> |
	7	<es-trie-irregular-sentir-stem2> |
	2	7+iendo | [gerundio o present-participle]
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-sentir-tabulation>

<es-trie-irregular-sentir-stem> ::=
	*entir	5ient	| [sentir]
	*erir		4ier	|	[herir]
	*ertir	5iert	|	[advertir]
	*ervir	5ierv		[hervir]

<es-trie-irregular-sentir-stem2> ::=
	*entir	5int	|
	*erir		4ir		|
	*ertir	5irt	|
	*ervir	5irv

<es-irregular-sentir-tabulation> ::=
	a1+	<es-irregular-sentir-present> |
	a1-	no <es-irregular-sentir-present> |
	a2+	<es-irregular-sentir-past> |
	a2-	no <es-irregular-sentir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-sentir-present> ::=
	6+o | 6+es | 6+e | 5+imos | 5+ís | 6+en

<es-irregular-sentir-past> ::=
	5+í | 5+iste | 7+ió | 5+imos | 5+isteis | 7+ieron


[VERBOS "MULLIR"]
<es-mullir-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	5+endo | [gerundio o present-participle]
	3	<es-trie-regular-ir-past-participle> |
	<es-irregular-mullir-tabulation>


<es-irregular-mullir-tabulation> ::=
	a1+	<es-regular-ir-present> |
	a1-	no <es-regular-ir-present> |
	a2+	<es-irregular-mullir-past> |
	a2-	no <es-irregular-mullir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-mullir-past> ::=
	5+í | 5+iste | 5+ó | 5+imos | 5+isteis | 5+eron

[VERBOS "PUDRIR" - excepcion en su participio "podrido"]
<es-pudrir-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-regular-ir-present-participle> |
	3	<es-trie-regular-pudrir-past-participle> |
	<es-regular-ir-tabulation>

<es-trie-regular-pudrir-past-participle> ::=
	*	5odrido

[VERBOS "REIR"]
<es-reir-conjugation> ::=
	5	<es-trie-regular-stem> |
	6	<es-trie-irregular-reir-stem> |
	7	<es-trie-irregular-reir-stem2> |
	2	<es-trie-irregular-reir-present-participle> | [gerundio o present-participle]
	3	<es-trie-irregular-reir-past-participle> |
	<es-irregular-reir-tabulation>

<es-trie-irregular-reir-present-participle> ::=
	*	3iendo

<es-trie-irregular-reir-past-participle> ::=
	*	2ído

<es-trie-irregular-reir-stem> ::=
	*	3í	 [reir]

<es-trie-irregular-reir-stem2> ::=
	*	3	

<es-irregular-reir-tabulation> ::=
	a1+	<es-irregular-reir-present> |
	a1-	no <es-irregular-reir-present> |
	a2+	<es-irregular-reir-past> |
	a2-	no <es-irregular-reir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-irregular-reir-present> ::=
	6+o | 6+es | 6+e | 5+ímos | 5+ís | 6+en

<es-irregular-reir-past> ::=
	5+í | 5+iste | 7+ió | 5+imos | 5+isteis | 7+ieron



[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]
[-----------------------------------------------------------------------------]

[VERBOS REGULARES "-AR"  AMAR SALTAR CANTAR CORTAR ETC]
<es-regular-ar-conjugation> ::=
	5 <es-trie-regular-stem> |	[slot 5 we use for the stem of the verb]
	2 5+ando |			[present participle: stem + -ando, e.g., saltando]
	3 5+ado |				[past participle: stem + -i, e.g., cortado]
	<es-regular-ar-conjugation-tabulation>

<es-trie-regular-ar-present-participle> ::=
	*	2ando

<es-trie-regular-ar-past-participle> ::=
	*	2ado

<es-regular-ar-conjugation-tabulation> ::=
  a1+		<es-regular-ar-present> |
	a1-		no <es-regular-ar-present>  |
	a2+		<es-regular-ar-past> |
	a2-		no <es-regular-ar-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+		<es-regular-ar-future> |
	a5-		no <es-regular-ar-future> |
	a6+	<es-regular-ar-past-imperfect> |
	a6-	no <es-regular-ar-past-imperfect> |
	p*	3 por
	
<es-regular-ar-present> ::=
	5+o | 5+as | 5+a | 5+amos | 5+áis | 5+an
	
<es-regular-ar-past> ::=
	5+é | 5+aste | 5+ó | 5+amos | 5+asteis | 5+aron	

<es-regular-ar-future> ::=
	5+aré | 5+arás | 5+ará | 5+aremos | 5+aréis | 5+arán

<es-regular-ar-past-imperfect> ::=
	5+aba | 5+abas | 5+aba | 5+ábamos | 5+abais | 5+aban

["-------------------------------------------------------------------------------"]


[VERBOS REGULARES "- ER"		TEMER]
<es-regular-er-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	<es-trie-regular-er-past-participle> |
	<es-regular-er-tabulation>

<es-trie-regular-er-present-participle> ::=
	*	2iendo

<es-trie-regular-er-past-participle> ::=
	*	2ido

<es-regular-er-tabulation> ::=
	a1+	<es-regular-er-present> |
	a1-	no <es-regular-er-present> |
	a2+	<es-regular-er-past> |
	a2-	no <es-regular-er-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-er-future> |
	a5-	no <es-regular-er-future> |
	a6+	<es-regular-er-past-imperfect> |
	a6-	no <es-regular-er-past-imperfect> |
	p*	3 por

<es-regular-er-present> ::=
	5+o | 5+es | 5+e | 5+emos | 5+éis | 5+en

<es-regular-er-past> ::=
	5+í | 5+iste | 5+ió | 5+imos | 5+isteis | 5+ieron

<es-regular-er-future> ::=
	5+eré | 5+erás | 5+erá | 5+eremos | 5+eréis | 5+erán

<es-regular-er-past-imperfect> ::=
	5+ía | 5+ías | 5+ía | 5+íamos | 5+íais | 5+ían

[VERBOS REGULARES "- ER" - EXCEPCIONES]
<es-romper-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-regular-er-present-participle> |
	3	roto |
	<es-regular-er-tabulation>

<es-tañer-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-irregular-tañer-present-participle> |
	3	tañendo	|
	<es-regular-er-tabulation>

["-------------------------------------------------------------------------------"]


[VERBOS REGULARES "- IR"    PARTIR]
<es-regular-ir-conjugation> ::=
	5	<es-trie-regular-stem> |
	2	<es-trie-regular-ir-present-participle> |
	3	<es-trie-regular-ir-past-participle> |
	<es-regular-ir-tabulation>

<es-trie-regular-ir-present-participle> ::=
	*	2iendo

<es-trie-regular-ir-past-participle> ::=
	*	2ido

<es-regular-ir-tabulation> ::=
	a1+	<es-regular-ir-present> |
	a1-	no <es-regular-ir-present> |
	a2+	<es-regular-ir-past> |
	a2-	no <es-regular-ir-past> |
	a3	( t1 haber ) 3 |
	a4	( t6 haber ) 3 |
	a5+	<es-regular-ir-future> |
	a5-	no <es-regular-ir-future> |
	a6+	<es-regular-ir-past-imperfect> |
	a6-	no <es-regular-ir-past-imperfect> |
	p*	3 por

<es-regular-ir-present> ::=
	5+o | 5+es | 5+e | 5+imos | 5+ís | 5+en

<es-regular-ir-past> ::=
	5+í | 5+iste | 5+ió | 5+ímos | 5+isteis | 5+ieron

<es-regular-ir-future> ::=
	5+iré | 5+irás | 5+irá | 5+iremos | 5+iréis | 5+irán

<es-regular-ir-past-imperfect> ::=
	5+ía | 5+ías | 5+ía | 5+íamos | 5+íais | 5+ían




[VERBO BASIS]

<es-trie-regular-stem> ::=
	*	2					[drop the last two letters: donner -> donn]


-) in the Preform grammar.


Chapter 2.4.2 - Meaningful verbs

Section 2.4.2.1 - In the Standard Rules

[We declare French equivalents of all meaningful verbs built into the
Standard Rules. This is mostly easy, but it's awkward that "porter" is
French both for "to carry" and "to wear", so that "Elle porte une robe"
could mean either "she carries a dress" or "she wears a dress"; I've
guessed that "porter" ought to mean "carry" here, and then provided
"elle est vétue de..." for "she is wearing...".]

[In Spanish ser is a verb meaning to be.
In Spanish estar is a verb meaning to be.] [6m62: comentariado para hacerlo compilable. bug Mantis1817]

[In Spanish tener is a verb meaning to have.
In Spanish estar relacionado is a verb meaning to relate.
In Spanish proveer is a verb meaning to provide.
In Spanish contener is a verb meaning to contain.
In Spanish suportar is a verb meaning to support.
In Spanish sostener is a verb meaning to support.
In Spanish incorporar is a verb meaning to incorporate.
In Spanish adjuntar is a verb meaning to enclose.
In Spanish llevar is a verb meaning to carry.
In Spanish porter is a verb meaning to wear.
In Spanish sostener is a verb meaning to hold.
In Spanish ocultar is a verb meaning to conceal.
In Spanish destrabar is a verb meaning to unlock.]



Section 2.4.2.2 - In Rideable Vehicles (for use with Rideable Vehicles by Graham Nelson)

[In Spanish montar sobre is a verb meaning to mount.
In Spanish desmontar is a verb meaning to dismount.] [6m62: comentariado para hacerlo compilable. bug Mantis1817]

Section 2.4.2.3 - In Locksmith (for use with Locksmith by Emily Short)

[In Spanish destrancar is a verb meaning to unbolt.]


Chapter 2.4.3 - Prepositions




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


[parser command so far, hackeado, usado en Parser clarification internal rule]
[
To say parser command so far:
	(- IdiomaImprimirComando(); -).
[	(- PrintCommand(); -).]
]


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
    can't insert into closed containers rule response (A) is "[The second noun] está[n] cerrad[o].".
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
block giving rule response (A) is "[El second noun] no parece[n] interesad[o].".
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

report touching yourself rule response (A) is "No logras nada con eso.". [¡Las manos quietas!]
report touching yourself rule response (B) is "[El actor] se toca[n] a si mism[o].". [[El actor] se toca impúdicamente.]
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
can't pull people rule response (A) is "[Al noun] podría no gustarle[s] eso.". [Eso sería como poco maleducado.]
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
can't push vertically rule response (A) is "[El noun] no puede[n] ser empujad[o] hacia arriba o hacia abajo.". [¿Sería lo mismo que levantar/bajar?]
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
block burning rule response (A) is "Con esa peligrosa acción no lograrías nada.".

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
block drinking rule response (A) is "Eso no parece potable.". [¿O es "No hay nada potable para beber aquí"?]

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
	verify the story file rule response (B) is "El fichero de juego no parece intacto, puede estar corrompido (a menos que estés jugando con un intérprete muy primitivo que no sea capaz de realizar la comprobación).".


[ Switching the story transcript off ]

switch the story transcript off rule response (A) is "La transcripción ya estaba desactivada.".
switch the story transcript off rule response (B) is "[line break]Fin de la transcripción.".
switch the story transcript off rule response (C) is "Intento fallido de finalización de transcripción.".

[ Requesting the story file version ]
[ ]


[ Requesting the score ]

announce the score rule response (A) is "[if the story has ended]En este relato, tu puntuación ha sido[otherwise]Hasta el momento tu puntuación es[end if] [score] de un total de [maximum score], en [turn count] turno[s]". [¿Juego o historia? A veces es juego, otras veces historia (como la (c) abajo). No entiendo. Me decanto por 'relato']
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
	*llama internamente a RegardingLWI() (ListWriter.i6t), que actualiza prior_named_list / prior_named_list_gender / prior_named_noun, utilizados luego por la sustitución [verbo] .
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
    parser clarification internal rule response (E) is "¿Qué [if the noun is not the player][the noun] tiene que[otherwise]quieres[end if] [parser command so far]?[set pregunta exacta]".
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

[Section  21 - Misc]

Volume 4 - Command parsing

Part 4.1 - Pronouns and possessives in commands

[This is taken straight from Eric Fourgeot's "French"; nothing has changed.]

Include (-
Array LanguagePronouns table

!   palabra  GNAs que pueden                conectado
!            seguirle:                      a:
!              a     i
!              s  p  s  p
!              mfnmfnmfnmfn

    '-lo'	$$101000100001                    NULL
    '-los'	$$000101000101                    NULL
    '-la'	$$010000010000                    NULL
    '-las'	$$000010000010                    NULL
    '-le'	$$110000110000                    NULL
    '-les'	$$000110000110                    NULL
    'él'		$$100000100000                    NULL
    'ella'	$$010000010000                    NULL
    'ellos'	$$000100000100                    NULL
    'ellas'	$$000010000010                    NULL;
-) instead of "Pronouns" in "Language.i6t".

Include (-
Array LanguageDescriptors table

    !palabra  GNAs que pueden     tipo de   conectado
    !              seguirles:	  descriptor:       con:
    !          a     i
    !          s  p  s  p
    !          mfnmfnmfnmfn                 
    
    'mi'	$$110110110110    POSSESS_PK      0
!    'este'	$$100000100000    POSSESS_PK      0 ! Mel Hython: para evitar problemas con direccion 'este'
    'estos'	$$000100000100    POSSESS_PK      0
    'esta'	$$010000010000    POSSESS_PK      0
    'estas'	$$000010000010    POSSESS_PK      0
    'ese'	$$100000100000    POSSESS_PK      1
    'esa'	$$010000010000    POSSESS_PK      1
    'esos'	$$000100000100    POSSESS_PK      1
    'esas'	$$000010000010    POSSESS_PK      1
    'su'	$$110000110000    POSSESS_PK      '-le'
    'sus'	$$000110000110    POSSESS_PK      '-le'
    'el'	$$100000100000    DEFART_PK       NULL
    'la'	$$010000010000    DEFART_PK       NULL
    'los'	$$000100000100    DEFART_PK       NULL
    'las'	$$000010000010    DEFART_PK       NULL
    'un'	$$100000100000    INDEFART_PK     NULL
    'una'	$$010000010000    INDEFART_PK     NULL
    'unos'	$$000100000100    INDEFART_PK     NULL
    'unas'	$$000010000010    INDEFART_PK     NULL
    'algún'	$$100000100000    INDEFART_PK     NULL
   'algunos' $$000100000100    INDEFART_PK     NULL
   'algunas' $$000010000010    INDEFART_PK     NULL
 'encendido' $$100000100000    light             NULL
 'encendida' $$010000010000    light             NULL
'encendidos' $$000100000100    light             NULL
'encendidas' $$000010000010    light             NULL
   'apagado' $$100000100000    (-light)          NULL
   'apagada' $$010000010000    (-light)          NULL
  'apagados' $$000100000100    (-light)          NULL
  'apagadas' $$000010000010    (-light)          NULL;
-) instead of "Descriptors" in "Language.i6t".

Part 4.2 - Understand grammar

Part 4.2.1 - Replacing English verbs

[ Propósito: Para no incluir el bloque de gramaticas (y verbos) ingleses en el fuente (optimiza memoria)]


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

Part 4.2.2 - Actions

[ Gramatica basada en InformATE! (I6) (by Zak)]
[ Verbos irregulares: filosofia usada en informATE!]
[ Para algunas acciones no estan permitidas ciertas variantes de la gramatica de informATE, como el uso de second noun como token.Esto hace la respuesta del parser mucho mas tonta: Ej, corta el pan o corta el pan con el cuchillo. ToDo: podrá resolverse esto?]

Part 4.2.2.1 - Grammar for Actions in the Game World

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
el juego esté correctamente mapeada de manera que corresponda al 'inside' de la localidad actual.".
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

Understand "sorry" as saying sorry. Understand the commands "perdon","perdona","siento","lamento" and "disculpa" as "sorry". [TODO no permite argumento 'topic']
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
Understand "responde [text] a [someone]" as answering it that (with nouns reversed). [TODO ¿como es el orden correcto?]
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
el juego esté correctamente mapeada de manera que corresponda al 'down' de la localidad actual.".
Carry out bajando: try going down.

Understand "subete a/en [something]" as entering. Understand the command "subirse" and "subirte" as "subete".

Subiendo is an action applying to nothing.
The specification of the subiendo action is "Esta acción se ejecuta con el comando
'sube', asumiendo que en realidad se quiere subir a alguna localidad que se tenga arriba, y que en
el juego esté correctamente mapeada de manera que corresponda al 'up' de la localidad actual.".
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

Understand "lava [something]" as rubbing. Understand the commands "limpia","pule","abrillanta","friega" and "frota" as "lava".
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



Part 4.2.2.2 - Grammar for Actions which happen out of world

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


Part 4.2 - Additional language-specific actions

[Section SL3/11 - Declaraciones VerboIrregular]
[Hay problemas con los Unicode y los acentos. Tener cuidado al editar esto con editores no UTF-8]
[todo: sigue haciendo falta esto?]

Include (-
! Objetos VerboIrregular, necesarios para el parseo de verbos irregulares en espanol (Added by SL)
VerboIrregular "abandonar el juego" with imperativo 'q//' 'quit' 'terminar' 'fin' 'acabar' 'abandonar';
VerboIrregular "abrir" with imperativo 'abre';
VerboIrregular "activar la transcripcin a disco" with imperativo 'script' 'transcripcion';
VerboIrregular "adquirir" with imperativo 'adquiere';
VerboIrregular "ajustar" with imperativo 'set';
VerboIrregular "apretar" with imperativo 'aprieta';
VerboIrregular "atravesar" with imperativo 'atraviesa';
VerboIrregular "bajar" with imperativo 'bajate' 'bajarse' 'irte';
VerboIrregular "balancear" with imperativo 'balanceate' 'meneate' 'balancearse' 'menearse' 'balancearse' 'menearse';
VerboIrregular "cambiar a modo LARGO" with imperativo 'verbose' 'largo';
VerboIrregular "cambiar a modo NORMAL" with imperativo 'breve' 'normal';
VerboIrregular "cambiar a modo SUPERBREVE" with imperativo 'superbreve' 'corto';
VerboIrregular "cambiar el dialecto del juego" with imperativo 'dialecto';
VerboIrregular "cambiar el estado de la NOTIFICACION de PUNTOS" with imperativo 'notificar' 'notify';
VerboIrregular "cargar un juego previamente guardado en disco" with imperativo 'cargar' 'recuperar' 'load' 'restaurar' 'restore';
VerboIrregular "cerrar" with imperativo 'cierra';
VerboIrregular "columpiar" with imperativo 'columpiate' 'columpiarse' 'columpiarse';
VerboIrregular "comer" with imperativo 'comete' 'comerse' 'comerte';
VerboIrregular "ingerir" with imperativo 'ingiere';
VerboIrregular "conocer el número de VERSION del juego" with imperativo 'version';
VerboIrregular "conocer la puntuación" with imperativo 'score' 'puntos' 'puntuacion';
VerboIrregular "conocer la puntuación detallada" with imperativo 'total' 'pt';
VerboIrregular "contar" with imperativo 'cuenta';
VerboIrregular "cubrir" with imperativo 'cubre';
VerboIrregular "darle" with imperativo 'dale' 'dase' 'darse';
VerboIrregular "decir" with imperativo 'di' 'dile';
VerboIrregular "desactivar la transcripción a disco" with imperativo 'unscript' 'noscript' 'notranscripcion';
VerboIrregular "descubrir" with imperativo 'descubre';
VerboIrregular "despertar" with imperativo 'despierta' 'espabilate' 'espabilarse' 'espabilarte';
VerboIrregular "destruir" with imperativo 'destruye';
VerboIrregular "disculparte" with imperativo 'sorry' 'perdon';
VerboIrregular "dormir" with imperativo 'duerme';
VerboIrregular "echar" with imperativo 'echate' 'echarse';
VerboIrregular "encender" with imperativo 'enciende';
VerboIrregular "esperar" with imperativo 'z//';
VerboIrregular "examinar" with imperativo 'x//' 'describe' 'ex';
VerboIrregular "fregar" with imperativo 'friega';
VerboIrregular "guardar en disco el estado del juego" with imperativo 'save' 'guardar' 'salvar';
VerboIrregular "ir" with imperativo 've' 'vete';
VerboIrregular "volver" with imperativo 'vuelve';
VerboIrregular "levantar" with imperativo 'levantate' 'levantarse' 'levantarte';
VerboIrregular "listar los lugares visitados" with imperativo 'places' 'lugares';
VerboIrregular "listar los objetos que se han tenido" with imperativo 'objects' 'objetos';
VerboIrregular "meter" with imperativo 'metete' 'meterse' 'meterte' 'meterme' 'meteme';
VerboIrregular "mirar" with imperativo 'l//' 'look' 'm//';
VerboIrregular "mostrar" with imperativo 'muestra';
VerboIrregular "mostrar inventario" with imperativo 'i//' 'inv' 'inventario';
VerboIrregular "mover" with imperativo 'mueve';
VerboIrregular "oir" with imperativo 'oye';
VerboIrregular "oler" with imperativo 'huele';
VerboIrregular "pedir" with imperativo 'pide' 'pidele';
VerboIrregular "pensar" with imperativo 'piensa';
VerboIrregular "poner" with imperativo 'pon' 'ponte' 'viste' 'vistete' 'ponerse' 'vestirse' 'ponerte' 'vestirte' 'ponerme' 'vestirme' 'ponme' 'visteme';
VerboIrregular "probar" with imperativo 'prueba';
VerboIrregular "pulir" with imperativo 'pule';
VerboIrregular "quitar" with imperativo 'sacate' 'quitate' 'sacarse' 'quitarse' 'quitarte' 'sacarte' 'sacarme' 'quitarme' 'quitame' 'sacame';
VerboIrregular "quitarle" with imperativo 'quitale';
VerboIrregular "reiniciar el juego" with imperativo 'reiniciar';
VerboIrregular "responder ~no~" with imperativo 'nx';
VerboIrregular "responder ~sí~" with imperativo 'si' 'y//';
VerboIrregular "sacudir" with imperativo 'sacude';
VerboIrregular "salir" with imperativo 'sal' 'fuera' 'afuera' 'salte' 'salirse' 'salirte';
VerboIrregular "sentar" with imperativo 'sienta' 'sientate' 'sentarse' 'echarte' 'sentarte';
VerboIrregular "soltar" with imperativo 'suelta';
VerboIrregular "subir" with imperativo 'sube' 'subete' 'subirse' 'subirte';
VerboIrregular "torcer" with imperativo 'tuerce';
VerboIrregular "retorcer" with imperativo 'retuerce';
VerboIrregular "transferir" with imperativo 'transfiere';
VerboIrregular "unir" with imperativo 'une';
VerboIrregular "ver el estado de los pronombres" with imperativo 'pronombres';
VerboIrregular "verificar la corrección del juego" with imperativo 'verificar';
VerboIrregular "mostrar las salidas" with imperativo 'salidas'; ! Urba touch
#ifdef DEBUG;
VerboIrregular "purloin" with imperativo 'purloin';
VerboIrregular "hacer con abstract" with imperativo 'abstract' 'xmueve';
VerboIrregular "hacer con gonear (indica lugar)" with imperativo 'gonear' 'xmueve';
#endif;
-).

Part SL4 - Spanish Phrasebook

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
To say lo (something - object): (- print (lo) {something}; -). [say "Cóge[lo noun]".]
	

[ Verbo COGER/TOMAR segun dialecto ]
To say coge: (- coge(0); -).
To say Coge: (- Mcoge(0); -).
To say MMcoge: (- MMcoge(0); -).

[Misc]
To say (something - time) in spanish:			[decir la hora en español]
	(- print (PrintTimeOfDayEnglish) {something}; -).

[To say (something - time) con palabras:	            	[decir la hora en español] [vamos a dejar esto por un tiempo]
	(- print (PrintTimeOfDaySpanish) {something}; -).]

To say esta (something - object): (- print (esta) {something}; -).[ "está" / "están" ]

Part 4.3 - Command parser internals

Section 1 - Asuntos preliminares

Include (-

! =====================================================================
! INFSP (Spanish Inform Library)
! =====================================================================
!        Author: INFSP Task Team
!       Version: 0.97
!      Revision: 08 - Mayo - 2014
! Serial Number: 14005.08

Message "^Compilando con Spanish: Mensajes y rutinas de idioma [INFSP 0.97 MAYO 2014]";
Message "   Asegurate de estar corriendo I7 Build 6M62^";

! ---------------------------------------------------------------------------
!   Parte I.   Asuntos preliminares
! ---------------------------------------------------------------------------

Constant LanguageVersion = "  - Librería I6 Española 1010.29, basada en InformATE!";

! Definición de caractéres "baratos". Esto permite que estas letras
! ocupen menos bits en la máquina Z. No funciona si se intenta la
! compilación por módulos (viejo método)

#ifdef TARGET_ZCODE;
  Zcharacter 'á';                    ! a con acento
  Zcharacter 'é';                    ! e con acento
  Zcharacter 'í';                    ! i con acento
  Zcharacter 'ó';                    ! o con acento
  Zcharacter 'ú';                    ! u con acento
  Zcharacter 'ñ';                    ! n con virguilla
  Zcharacter 'Ñ';                    ! N con virguilla
  Zcharacter 'ü';                    ! u con dieresis
  Zcharacter '¿';                    ! abrir interrogación
  Zcharacter '¡';                    ! abrir exclamación
#endif;

!----------------------------------------------
! CONSTANTES Y CLASES ESPECIFICAS DE INFORMATE
!---------------------------------------------- 

Class VerboIrregular;

!------------------------------------
! Globales específicas de InformatE!
!------------------------------------

global PreguntaCualExactamente = 0;
	! Esta variable se pone a 1 cuando se le pregunta al jugador ¿Cuál
	! exactamente...? esto indica que puede ser necesario re-traducir la
	! respuesta que el jugador dé, ya que puede que simplemente el jugador
	! cambie de idea y en lugar de responder a nuestra pregunta introduzca
	! un comando completamente nuevo.

global PreguntaSiNo = 0;
	! Esta variable debe ponerse a 1 manualmente si queremos que el verbo
	! 'no' sea accesible como respuesta (y no como punto cardinal). La
	! variable sólo afecta a la siguiente respuesta del jugador y vuelve a
	! hacerse cero automáticamente.

Global quitacentos = 1;

Array  texto_impreso --> 52;

#ifndef NI_BUILD_COUNT;
Global dialecto_sudamericano = 0;
#ifnot;
    #ifndef DIALECTO_SPANISH; ! seteado desde el I7 environment
       Global dialecto_sudamericano = 0;
    #endif;
#endif;

!---------------------------------------------------------------------------
! Atributos y propiedades específicas de InformatE!, tambien usados en INFSP
!---------------------------------------------------------------------------

Property imperativo alias name;
Property irrelevante alias name;

-) after "Definitions.i6t". 


Include (-
! Definicion de bufferaux y parseraux, usados en DictionaryLookup [001115]
#ifdef TARGET_ZCODE;
  Array bufferaux -> 123;
  Array parseaux  buffer 63;
#ifnot; ! TARGET_GLULX
  Array  bufferaux    buffer INPUT_BUFFER_LEN;
  Array parseaux  --> PARSE_BUFFER_LEN;
#endif; ! TARGET_



! Tremendo bug corregido. Antes usaba el buffer buf2, el cual usa
! tambien el parser para leer commandos incompletos del estilo de "¿a
! cual te refieres exactamente?"
! Este bug estaba en la libreria original, pero nunca aparecia porque
! apenas se usa DictionaryLookup. En cambio InformATE lo usa para
! comprobar si quitando la R a un verbo se obtiene una palabra válida.
!
! [Gracias a Presi por detectarlo] 
[ DictionaryLookup texto longitud
    i;

	! copiar texto a bufferaux (copiado especial)
	for (i=0:i<longitud:i++) bufferaux->(WORDSIZE+i) = texto->i;
	! completar correctamente cabeceras de los buffers
	!	para la rutina Tokenise.
#ifdef TARGET_ZCODE;
	bufferaux->1 = longitud;
	bufferaux->0 = 120;
	parseaux-> 0 = 1;
#ifnot; ! TARGET_GLULX
	bufferaux-->0 = longitud;
#endif; ! TARGET_
#ifdef DEBUG;
    if (parser_trace>=9) { ! infsp debug
		print "    DictionaryLookup: texto a procesar: |";
        ImprimeTodoElBuffer(bufferaux);
        print "|^";
    }
#endif;
	VM_Tokenise(bufferaux,parseaux); ! procesar texto de bufferaux, el resultado está en parseaux-->1
	return parseaux-->1; ! retornar address del token encontrado (-1 si falla)
];

-) before "Vocabulary" in "Language.i6t".

Section 3 - Vocabulary

Include (-
Constant AGAIN1__WD = 'repetir';
Constant AGAIN2__WD = 're';
Constant AGAIN3__WD = 'g//';
Constant OOPS1__WD    = 'oops';
Constant OOPS2__WD    = 'epa';
Constant OOPS3__WD    = 'eepa';
Constant UNDO1__WD  = 'undo';
Constant UNDO2__WD  = 'deshacer';
Constant UNDO3__WD  = 'anular';

Constant ALL1__WD    = 'todos';
Constant ALL2__WD    = 'todas';
Constant ALL3__WD    = 'todo';
Constant ALL4__WD    = 'ambos';
Constant ALL5__WD    = 'ambas';
Constant AND1__WD    = 'y//';
Constant AND2__WD    = 'y//';
Constant AND3__WD    = 'e//';
Constant BUT1__WD   = 'excepto';
Constant BUT2__WD   = 'menos';
Constant BUT3__WD   = 'salvo';
Constant ME1__WD      = '-me';
Constant ME2__WD      = '-te';
Constant ME3__WD      = '-se';
Constant OF1__WD      = '.de';       ! no usados nunca, pues provocan
Constant OF2__WD      = '.de';       ! interferencia con la preposición "de"
Constant OF3__WD      = '.de';       ! usada por algunos verbos, como en
Constant OF4__WD      = '.de';       ! "saca objeto de la caja"
Constant OTHER1__WD    = 'otro';
Constant OTHER2__WD    = 'otra';
Constant OTHER3__WD    = 'otro';
Constant THEN1__WD = 'ydespues';
Constant DESPUES11_WD = 'despues';
Constant THEN2__WD = 'yluego';
Constant DESPUES21_WD = 'luego';
Constant THEN3__WD = 'yentonces';
Constant DESPUES31_WD = 'entonces';

Constant NO1__WD      = 'n//';
Constant NO2__WD      = 'no';
Constant NO3__WD      = 'no';
Constant YES1__WD      = 's//';
Constant YES2__WD      = 'si';
Constant YES3__WD      = 'sí';

Constant AMUSING__WD = 'curiosidades';
Constant FULLSCORE1__WD  = 'puntuacion';
Constant FULLSCORE2__WD  = 'punt';
Constant QUIT1__WD    = 'q//';
Constant QUIT2__WD    = 'terminar';
Constant RESTART__WD    = 'reiniciar';
Constant RESTORE__WD    = 'recuperar';
-) instead of "Vocabulary" in "Language.i6t".


Part 4.4 - Informese translation of commands

Section 6 - Translation

Include (-
! ---------------------------------------------------------------------------
!   Parte III.   Traducción
! ---------------------------------------------------------------------------

!------------------------------------
! Funciones de ayuda a la depuración
!------------------------------------

#ifdef DEBUG;
[ ImprimeBuffer b desde l i;
    for (i=desde:i<desde+l:i++)
    print (char) b->i;
];

[ ImprimeTodoElBuffer b;
#ifdef TARGET_ZCODE;
   ImprimeBuffer(b, 2, b->1);
#ifnot; !TARGET_GLULX
   ImprimeBuffer(b, WORDSIZE, b-->0);
#endif;
];

#endif; !DEBUG

#ifdef TARGET_GLULX; ! TARGET_GLULX
[ PasarAMinuscula buffer   ! [INFSP] Necesario en EspanolAInformes (en modo Glulx), para q el buffer
        i;                 !         sea reconocido (al usar infinitivo en mayuscula (EXAMINAR) o verbos pronominales (EXAMINALA)
    for (i=WORDSIZE:i<(WORDSIZE+(buffer-->0)):i++)
        buffer->i = VM_UpperToLowerCase (buffer->i);
    return buffer;
];
#endif; !TARGET_

!----------------------------------------------------------------
! [010515] Rutina nueva, que recibe una palabra de diccionario y un
! lugar donde buscar, y retorna "true" si alguno de los objetos de ese
! lugar tiene esa palabra en su campo nombre, name_f...
!
! Es usada por la rutina ArreglarLosY, pues se mira si la palabra que
! viene detrás de la Y es un nombre, y si lo es, si es aplicable a algún
! objeto cercano. Observar que fallará en los objetos que proporcionen
! su propio parse_name. 
!----------------------------------------------------------------
[ EncajeSimplon w donde i;
  objectloop(i in donde) {
    if (WordInProperty(w, i, name)) rtrue;

    if (children(i) && EncajeSimplon(w, i)) rtrue;
  }
  rfalse;
];


!----------------------------------------------------------------
! QuitarAcentos
!
! La siguiente función prueba a quitar los acentos de las palabras que
! no hayan podido ser interpretadas. De este modo, el jugador puede usar
! o no los acentos. Para ello el juego debe definir las palabras sin acentos
! por ejemplo:
! object sillon "sillón confortable"
! with name 'sillon' 'confortable'
!
! Si el jugador pone: "mira sillon", la palabra encaja directamente y es
! comprendida. Si pone "mira sillón", no es comprendida, de modo que se
! le quita el acento y se reintenta el parsing.
!
! Este caso no es especialmente importante, pues el programador
! siempre puede definir 'sillon' y 'sillón', ambos como nombres para
! el objeto. Pero el asunto es más importante para el caso de los
! verbos, ya que si el jugador teclea "cógelo" este es separado en
! "cóge" y "-lo" y el verbo "cóge" (con acento) no sería
! comprendido.
!
! La llamada a esta función puede desactivarse con el comando de
! debugging "acentos sí" de modo que los acentos que teclee el jugador
! no serán eliminados (con propósitos de depuración)

[ QuitarAcentos buf pars x i word at len;

#ifdef DEBUG;
    if (parser_trace >= 7) ! imprimir el buffer recibido
    {
          print "^[ QuitarAcentos:  ";
          print "Buffer recibido: |";
             ImprimeTodoElBuffer(buf);
          print "|^";
    } 
#endif;
    VM_Tokenise(buf, pars); 
    for (x=1:x<=tokenCount(pars):x++) ! para cada token
    {
	word = tokenDict (pars,x); !dictionary value of token 1,2,3...
	at = tokenPos (pars,x); ! position in buffer of token 1,2,3... 
	len = WordLength (x);! length in chars of token 1,2,3...

	if (word==0) ! no comprendida
       {
#ifdef DEBUG;
		if (parser_trace>=7)
		{
		    print "    QuitarAcentos:NO COMPRENDIDO: |";
			ImprimeBuffer(buf, at, len);
		    print "|^";
		}
#endif;
		for (i=at:i<at+len:i++)
		   switch(buf->i)
		  {
			'á': buf->i='a';
			'é': buf->i='e';
			'ë': buf->i='e';
			'í': buf->i='i';
			'ó': buf->i='o';
			'ú': buf->i='u';
			'ü': buf->i='u';
			'ñ': buf->i='n'; 
		!             '?': buf->i=' ';
		!             '¿': buf->i=' ';
		!             '!': buf->i=' ';
		!         '¡': buf->i=' ' ;    
		   }
        VM_Tokenise(buf, pars); 
        }
    }

#ifdef DEBUG;
    if (parser_trace>=7){
        print "    Buffer sin acentos: |";
        ImprimeTodoElBuffer(buf);
        print "|^";
    }
#endif;
];

! funciones de soporte para gestionar parse y buffer
!  From InformFAQ - Roger Firth

[ tokenDict pars w; ! dictionary value of token 1,2,3...
#Ifdef TARGET_ZCODE;
	return pars-->(2*w - 1);
#Ifnot; ! TARGET_GLULX
	return pars-->(3*w - 2);
#Endif; ! TARGET_
];
[ tokenLen pars w; ! length in chars of token 1,2,3...
#Ifdef TARGET_ZCODE;
	return pars->(4*w);
#Ifnot; ! TARGET_GLULX
	return pars-->(3*w - 1);
#Endif; ! TARGET_
];
[ tokenPos pars w; ! position in buffer of token 1,2,3...
#Ifdef TARGET_ZCODE;
	return pars->(4*w + 1);
#Ifnot; ! TARGET_GLULX
	return pars-->(3*w);
#Endif; ! TARGET_
]; 

[ tokenCount pars;
#Ifdef TARGET_ZCODE;
	return pars->1;
#Ifnot; ! TARGET_GLULX
	return pars-->0;
#Endif; ! TARGET_
];

!-----------------------------------------------------
! LanguageToInformese
!
! Esta parte es interesante. Debe separar los sufijos pronominales
! como en "cogela" "mirale", claro que no basta con ver si las dos
! últimas letras del verbo son "la" "le", etc, pues el verbo podría
! terminar de forma "natural" en esas letras (como en "habla"). Así
! que hay que separar el sufijo sólo si el verbo no ha sido hallado en
! el diccionario.
!
[ LanguageToInformese ;
    EspanolAInformes(buffer, parse);
];

! La función que verdaderamente hace la traducción es la siguiente. Ha
! sido separada de LanguageToInformese porque es llamada también desde
! LanguageIsVerb, pero recibe un buffer diferente para procesar. 

[ EspanolAInformes buf pars x i word at len romper_en siguiente retokenise at2; !    print "   EspanolAInformes called^"; ! infsp debug

   #ifdef TARGET_GLULX; ! TARGET_GLULX
    buf = PasarAMinuscula (buf); ![INFSP] Necesario para q no cazque al procesar infinitivos
   #endif;

    VM_Tokenise( buf, pars);     retokenise=0;
#ifdef DEBUG;
    if (parser_trace>=7) !imprimir el buf recibido
    {
          print "^[ EspanolAInformes:  ";
          print "Buffer recibido: |";
		ImprimeTodoElBuffer(buf);
          print "|^  ";
    } 
#endif;
    if (quitacentos) QuitarAcentos(buf, pars);

     for (x=1:x<=tokenCount(pars):x++) ! para cada token
    {
	word = tokenDict (pars,x); !dictionary value of token 1,2,3...
	at = tokenPos (pars,x); ! position in buffer of token 1,2,3... 
	len = tokenLen (pars,x);! length in chars of token 1,2,3...

#ifdef DEBUG;
	if (parser_trace>=7){
          print "Palabra ",x," : ";
          if (word==0)
            print "<no comprendida>";
          else 
            print (address) word," ^";
          print " ^";
        }        
#endif;

	if (dialecto_sudamericano && (word == 'coge'))
	{
	  ! Un poco bestia, pero funciona. En caso de dialecto sudamericano,
	  ! cambiar un par de letras convierte "coge" en "jode"
	  buf->(at)     = 'j';
	  buf->(at + 2) = 'd';
	  retokenise    = 1;
	  if (dialecto_sudamericano == 1)  ! [071030_git]
	  {
	    print "[Este juego utiliza por defecto el dialecto sudamericano,
		    por lo que aquí COGER es entendido como una palabra
		    malsonante. Por favor, utiliza TOMAR en su lugar, o bien
		    elige el dialecto castellano con DIALECTO CASTELLANO.]^";
	    dialecto_sudamericano = 2;
	  }
	}
    
    if (word=='del' or 'al')
    {
        buf->(at+len-1)=' ';    ! convertir "del" "al" en "de"
                                       ! "a" respectivamente
        retokenise=1;
    }
    

    ! Si el jugador ha escrito "no", y previamente el programador
    ! había puesto a 1 el flag "PreguntaSiNo" (que indica que
    ! acaba de hacerse una pregunta que podría admitir NO como
    ! respuesta), en ese caso cambiamos "no" por "xo". La
    ! gramática define el verbo "xo" para generar la acción NO
    ! (negar), y así lo distinguimos de la acción "Ir noroeste"
    if ((word=='no')&&(PreguntaSiNo==1))
    {
        buf->(at+len-1)='x';
        PreguntaSiNo=0;
        retokenise=1;
    }
        
        ! "pegar" las expresiones "y luego" "y despues" "y entonces"
        ! para que queden "yluego" "ydespues" "yentonces"
        ! que es como las reconoce el parser
     if (word=='y//')
    {
       siguiente= tokenDict (pars,x+1); ! palabra siguiente

	if (siguiente==DESPUES11_WD or DESPUES21_WD or DESPUES31_WD)
       {
	   at2 = tokenPos (pars,x+1); ! position in buffer of token 1,2,3... 
           for (i=0:i<tokenLen(pars,x+1):i++){
                   buf->(at2+i) = ' '; ! borrar palabra 'entonces' (pisándola con espacios)
	   }
           buf->(at+len)='l'; ! agregar 'luego' inmediatamente despues de 'y', formando 'yluego'
           buf->(at+len+1)='u';
           buf->(at+len+2)='e';
           buf->(at+len+3)='g';
           buf->(at+len+4)='o';
           retokenise=1;
#ifdef DEBUG;
           if (parser_trace>=7) !imprimir el buf recibido
	   {
		print "^[   YLUEGO:  ";
		print "Buffer recibido: |";
		ImprimeTodoElBuffer(buf);
		print "|^  ";
	    } 
#endif;
       }
    }     

    if (word==0) ! no comprendida
    {
#ifdef DEBUG;
        if (parser_trace>=7)
        {
            print "NO COMPRENDIDO: |";
            ImprimeBuffer(buf, at, len);
            print "|^";
        }
#endif;        
        if (len > 2) !sólo si tiene más de tres letras
        {
           romper_en=0;
           if ((buf->(at+len-1)=='s') &&
            (buf->(at+len-2)=='a' or 'o' or 'e') &&
            (buf->(at+len-3)=='l'))
            romper_en=3;
           if ((buf->(at+len-1)=='a' or 'o' or 'e') &&
            (buf->(at+len-2)=='l'))
            romper_en=2;
           if ((buf->(at+len-1)=='e') &&
            (buf->(at+len-2)=='m' or 't' or 's'))
            romper_en=2;  ! [001108] Antes ponía == ¡seré burro!
           if (romper_en) 
           {
            ! [990524]
            ! Antes de modificar el buffer, comprobemos si
            ! servirá para algo, es decir, si la palabra que
            ! queda una vez separado el sufijo existe en el
            ! diccionario y es un verbo
            i=DictionaryLookup(buf+at, len-romper_en);
            
              if (i) if ((i->#dict_par1)&1)
              {
                LTI_Insert(at+len-romper_en, '-', buf);
                LTI_Insert(at+len-romper_en, ' ', buf);
                VM_Tokenise(buf,pars);
               }
              if (QuitandoRFinal(buf+at, len-romper_en)||
                  BuscarEntreVerbosIrregulares(buf+at, len-romper_en))
              {
                LTI_Insert(at+len-romper_en, '-', buf);
                LTI_Insert(at+len-romper_en, ' ', buf);
                VM_Tokenise(buf,pars);
               }
             } ! if (romper_en
        } ! if (len > 2
    } ! if (word==0
    } ! for (x=0:

    if (retokenise==1) ! [INFSP] Agregado if, como en la seccion Glulx
       VM_Tokenise(buf, pars);

    ArreglarLosY(buf, pars);
    
    ! Como paso final, quitamos las palabras que aparezcan dos veces
    ! seguidas. Esto puede ocurrir si el jugador teclea un comando
    ! incompleto, como "MIRA HACIA", y el parser le pregunta "¿Hacia
    ! donde quieres mirar?" y el jugador responde "HACIA EL NORTE". En
    ! este caso se construiría la orden concatenada: "MIRA HACIA HACIA
    ! EL NORTE".
    if (PreguntaCualExactamente==1){
        !print "PreguntaCualExactamente:",PreguntaCualExactamente;!debug
        PreguntaCualExactamente=0;
        EliminarDuplicados(buf, pars);
    }
    
#ifdef DEBUG;
    if (parser_trace>=7){
       print "Buffer traducido a informese: ^|";
        ImprimeTodoElBuffer(buf);
       print "| (", pars->1," palabras) ^";
    }
#endif;
];


[ ArreglarLosY buf pars
    word at len x i retoke;

    for (x=1:x<=tokenCount(pars):x++) ! para cada token
    {
 	word = tokenDict (pars,x); !dictionary value of token 1,2,3...
        if (word=='y//')
	{
		i = tokenDict (pars,x+1); ! palabra siguiente
        ! [010515] arreglado bug. at y len no apuntaban a la
        ! palabra siguiente, sino a la propia 'y', por lo que no
        ! eran reconocidos los verbos en infinitivo
		at = tokenPos (pars,x+1); ! position in buffer of token siguiente 
		len = tokenLen (pars,x+1);! length in chars of token siguiente

        ! [010515] Añadido. Si la palabra es noun, se retorna
        ! (aunque pueda ser también un verbo) de este modo, en
        ! COGE VINO Y CAVA, si el juego tiene un objeto llamado
        ! "cava", la frase será parseada como tratando de coger
        ! dos objetos, llamados "vino" y "cava". Si el juego no
        ! define el sustantivo "cava", la frase será parseada como
        ! dos acciones en secuencia <<Coger vino>> y <<Excavar>>
		if (i && (i->#dict_par1)&128) {
			if (EncajeSimplon(i, location)) continue;
		}
		if (i && ((i->#dict_par1)&1)||QuitandoRFinal(buf+at,len)||
			BuscarEntreVerbosIrregulares(buf+at, len))
		{
			at = tokenPos (pars,x); ! position in buffer of token siguiente 
			buf->(at)='.';
			retoke=true;
		}
	}
    }
    if (retoke) VM_Tokenise(buf, pars);
];

[ EliminarDuplicados buf pars
    word at len x i siguiente retokenise;

!    VM_Tokenise(buf, pars);
#ifdef DEBUG;
    if (parser_trace>=8) !imprimir el buffer recibido
    {
          print "^[ EliminarDuplicados:  ";
          print "Buffer recibido: |";
              ImprimeTodoElBuffer(buf);
          print "| (", pars->1, " palabras)^";
    } 
#endif;
    for (x=1:x<=tokenCount(pars):x++) ! para cada token
    {
	word = tokenDict (pars,x); !dictionary value of token 1,2,3...
	siguiente = tokenDict (pars,x+1); !dictionary value of token 1,2,3...
	at = tokenPos (pars,x); ! position in buffer of token 1,2,3... 
	len = tokenLen (pars,x);! length in chars of token 1,2,3...
    if ((word==siguiente) && (word~=0))
    {
#ifdef DEBUG;
        if (parser_trace>=8) print "Encontrados duplicados!:",
		(address) word, "=", (address) siguiente, ".^";
#endif;
        for (i=at:i<at+len:i++) buf->i=' ';
        retokenise=1;
    }
    }
    if (retokenise) 
    VM_Tokenise(buf, pars);

#ifdef DEBUG;
    if (parser_trace>=8) !imprimir el buffer recibido
    {
          print "Buffer resultante: |";
        ImprimeTodoElBuffer(buf);
          print "| (", pars->1, " palabras)^";
    } 
#endif;
];


! La siguiente función debe devolver si el verbo recibido es
! reconocido o no. Se recibe el buffer completo y "pos" indica qué
! palabra dentro del buffer "pars" es el supuesto verbo.
! Hay que devolver la dirección de diccionario del verbo en cuestión.
!
! Lo usamos para admitir infinitivos. El método es:
!   Si la palabra corresponde a una palabra de diccionario, no hacemos
!   nada (retornamos esa palabra, sin molestarnos en comprobar que sea
!   un verbo. Ya lo hará el parser).
!
!   Si la palabra no está en el diccionario, miramos si termina en
!   'r', y de ser así se la quitamos y re-tokenizamos. Si de este modo
!   se obtiene una palabra en el diccionario, retornamos su valor (sin
!   comprobar que sea un verbo, ya lo hará el parser).
!
!   Si tampoco de este modo se reconoce, comparamos la palabra dada
!   con todos los verbos irregulares conocidos. Si en uno de ellos
!   encontramos coincidencia, retornamos el primer elemento de la
!   propiedad "imperativo" del verbo en cuestión.
!
!   En el caso de la desambiguacion, puede darse que el jugador responda
!   con un verbo nuevo, pero con sufijo pronominal la/le/lo/me/te/se (ej. examinala)
!   Por ello se hace una llamada a EspanolAInformes

[ LanguageIsVerb buf pars pos
    i word at len;
    
#ifdef DEBUG;
    if (parser_trace>=7) !imprimir el buffer recibido
    {
	print "^[ LanguageIsVerb:  ";
	print "Buffer recibido: |";
		ImprimeTodoElBuffer(buf);
	print "|, pos=", pos, "^  ";
    } 
#endif;
    if (PreguntaCualExactamente) ! caso de desambiguación
	EspanolAInformes(buf, pars); ! revisar la existencia de sufijos pronominales la/le/lo/me/te/se
    word = tokenDict (pars,pos); !dictionary value of token 1,2,3...
    at = tokenPos (pars,pos); ! position in buffer of token 1,2,3... 
    len = tokenLen (pars,pos);! length in chars of token 1,2,3...

    ! Si la palabra se reconoce, devolverla sin más
     if (word~=0 && word->#dict_par1 & 1 ~= 0)
    {
#ifdef DEBUG;
	if (parser_trace>=7) print " la palabra ~", (address)
		word, "~ está en el diccionario.^";
#endif;
	return    (word);
    }

   
    ! Si no, probar a ver si se reconoce sin la 'r' final
    i=QuitandoRFinal(buf + at,len);

    ! Si no la ha reconocido, intentamos ver si es un verbo irregular
    if (i~=0)
    {
	if (parser_trace>=7) print "^ Verbo reconocido
		al quitarle la 'r' final.^";
    }
    else 
    {
	if (parser_trace>=7) print "^ Verbo no reconocido sin la
		'r'. ^Probando irregulares...";
 	i=BuscarEntreVerbosIrregulares(buf + at,len);
#ifdef DEBUG;
	if (parser_trace>=7) 
	{
		if (i==0) print "No reconocido como irregular.^";
		else print "      Reconocido como el verbo ", (address) i, "^";
	}
#endif;
    }     
       if (parser_trace>=7) 
        print " ^                   -- end LanguageIsVerb ]^";
    return i;    
];

[ QuitandoRFinal texto longitud
    i;

#ifdef DEBUG;
    if (parser_trace>=9) {
	print "^[ QuitandoRFinal: buffer recibido |";
		ImprimeBuffer(texto, 0, longitud);
	print "|^";
    }
#endif;	
	if (texto->(longitud-1)~='r')
    {
	if (parser_trace>=9) print "No termina en 'r'^";
	return 0;
    }
    
    i=DictionaryLookup(texto, longitud-1);     
    if (dialecto_sudamericano && (i == 'coge'))
    {
      if (dialecto_sudamericano == 1)  ! [071030] git
      {
        print "[Este juego utiliza por defecto el dialecto sudamericano,
                por lo que aquí COGER es entendido como una palabra
                malsonante. Por favor, utiliza TOMAR en su lugar, o bien
                elige el dialecto castellano con DIALECTO CASTELLANO.]^";
        dialecto_sudamericano = 2;
      }
      return 'jode';
    }     
     if ((i->#dict_par1)&1) return i;
    else 
    {
    if (parser_trace>=9) print "Está en el diccionario, pero no es verbo.^";
    return 0;
    }
];


[ BuscarEntreVerbosIrregulares texto longitud
    verbo i k;

    objectloop (verbo ofclass VerboIrregular)
    {
#ifdef DEBUG;
	if (parser_trace>=8) print "^[Bucando irregulares. Probando
		con ~", (name) verbo, "~.-->"; 	
#endif;
		k = VM_PrintToBuffer (texto_impreso,46,verbo);

    
        !Si sus longitudes no coinciden no es necesario seguir comparando
        if (k~=longitud) jump NoCoincide;
    
        !Si sus longitudes coinciden, miramos letra a letra
        for (i=0:i<k:i++)
            if ((texto->i)~=(texto_impreso->(i+WORDSIZE)))
        
	jump NoCoincide; ! si una sola letra no coincide,
	! Si ha pasado los test anteriores, hemos hallado una
	! coincidencia
	#ifdef DEBUG;if (parser_trace>=8) print "¡coincide!^";#endif;
	return (verbo.&imperativo-->0);

	.NoCoincide;
	#ifdef DEBUG;if (parser_trace>=8) print "no coincide^";#endif;
    }
    return 0;
];
-) instead of "Translation" in "Language.i6t".

Section 8 - Commands

Include (-
!LanguageVerb: imprime el verbo, usado en pregunta para esclarecer comando
[ LanguageVerb i aux;

    if (ImprimirIrregular(i)==0){
        !print "^   LanguageVerb: Verbo no es irregular.^"; ! infsp debug
      
      ! Tatar de matchear con la brújula - 807.7 infsp
      objectloop (aux in Compass){
        if (WordInProperty(i, aux, name)) {
          print "ir hacia algún lado";
          rtrue; ! no avanzar más en la rutina
        }    
       }
       
       ! Un ultimo intento, con una rutina stub a proveer por el autor
       if (PrintVerb(i)==0){
         print (address) i; print "r";
        }
    }

    if (i=='mete') rtrue;
    
#ifdef TARGET_ZCODE;
    ! Comprobemos si era un verbo reflexivo (-te)
    texto_impreso-->0 = 50;
    @output_stream 3 texto_impreso;
    print (address) i;
    @output_stream -3;
    aux=2;
!    print "^   LanguageVerb: i : ",(address) i,"^"; ! infsp debug
    if (texto_impreso->(texto_impreso->1+1)=='e')
     if (texto_impreso->(texto_impreso->1) == 't' or 's' or 'm')
     {
!     print "^   LanguageVerb:Verbo reflexivo."; ! infsp debug
       if (actor ~= player) print "se";
        else print (string) PARTICULA_TE; ! "te"
     }
#endif;
#ifdef TARGET_GLULX;
    aux=Glulx_PrintAnyToArray(texto_impreso, 50, i);
    if ((texto_impreso->(aux-1)=='e')&&
        (texto_impreso->(aux-2) == 't' or 's' or 'm')) 
    {
       if (actor ~= player) print "se";
        else print (string) PARTICULA_TE;
    }
#endif;
    rtrue;

];

[ ImprimirIrregular v i;
  ! Imprime los verbos irregulares (es decir, aquellos en los que no basta
  ! añadir una "r" al imperativo). Por ejemplo, si el jugador teclea "friega"
  ! la respuesta por defecto sería "¿Qué quieres friegar?"
  ! Para evitar esto, el programador debe definir un objeto de la clase
  ! VerboIrregular, con nombre "fregar" y propiedad name = "friega"
  ! Esta rutina busca entre los verbos así definidos, en el campo name
  ! y si encuentra una coincidencia imprime el nombre del objeto para
  ! el cual se halló.

  ! Para mayor flexibilidad aún, se permite que el programador incluya
  ! una rutina en la propiedad nombre_corto del verbo, por si el nombre
  ! del verbo a imprimir es variable según el momento en que se llame.
  ! Si existe nombre_corto para el verbo en cuestión, se ejecuta dicha rutina
  ! de lo contrario se imprime el nombre de ese verbo sin más.

  ! Ver SpanishG.h para ejemplos de declaración de verbos irregulares.

  objectloop (i ofclass VerboIrregular)
   if (WordInProperty(v, i, imperativo)) {
     if (i.&short_name~=0) return(PrintOrRun(i, short_name, 1));
     else { print (name) i; rtrue;}}
  rfalse;
];

!  LanguageVerbLikesAdverb is called by PrintCommand when printing an UPTO_PE
!  error or an inference message.  Words which are intransitive verbs, i.e.,
!  which require a direction name as an adverb ('walk west'), not a noun
!  ('I only understood you as far as wanting to touch /the/ ground'), should
!  cause the routine to return true.

[ LanguageVerbLikesAdverb w;
    if (w == 'vete' or 've' or 'camina' or
        'anda' or 'corre' or 'vuelve' or 'ir')
        rtrue;
    rfalse;
]; 

!  LanguageVerbMayBeName is called by NounDomain when dealing with the 
!  player's reply to a "Which do you mean, the short stick or the long
!  stick?" prompt from the parser. If the reply is another verb (for example,
!  LOOK) then then previous ambiguous command is discarded /unless/
!  it is one of these words which could be both a verb /and/ an
!  adjective in a 'name' property.

[ LanguageVerbMayBeName w;
    if (w == 'long' or 'short' or 'normal'
                    or 'brief' or 'full' or 'verbose')
        rtrue;
    rfalse;
];
-) instead of "Commands" in "Language.i6t".


Section 10 - Printed Inflections

Include (-
! Definimos una función para imprimir el verbo coger. Esto hace más fácil
! la adaptación de los juegos a los dialectos sudamericanos, en los
! que debe usarse "tomar" en lugar de "coger"
! 
! La variable global que elige el dialecto se fija en tiempo de
! ejecución con el meta-verbo "dialecto". También puede fijarse en
! Initialize para que su valor por defecto sea 1.
!
[ coge sufijo;
    if (dialecto_sudamericano)
      print "toma";
    else print "coge";
    if (sufijo ~= 0)
       print (string) sufijo;
!    #ifndef NI_BUILD_COUNT; print (string) sufijo;#endif; !desde I7 no puede usarse 'sufijo'
];

! La siguiente es la versión con la primera letra mayúscula

[ MCoge sufijo;
    if (dialecto_sudamericano)
    print "Toma";
    else print "Coge";
    if (sufijo ~= 0)
       print (string) sufijo;
!    #ifndef NI_BUILD_COUNT; print (string) sufijo;#endif; !desde I7 no puede usarse 'sufijo'
];

! Y finalmente una versión con todo mayúsculas

[ MMCoge sufijo;
    if (dialecto_sudamericano)
    print "TOMA";
    else print "COGE";
    if (sufijo ~= 0)
       print (string) sufijo;
!    #ifndef NI_BUILD_COUNT; print (string) sufijo;#endif; !desde I7 no puede usarse 'sufijo'
];
-) before "Commands" in "Language.i6t".

Include (-
! Funciones para manejar concordancias de género y número en los
! mensajes de respuesta genéricos.
!
! o -> escribe la terminación -o -a -os -as según el género y número
! del objeto recibido, para hacer concordar los adjetivos.
!
! n -> escribe la terminación -"" -n según el número del objeto, para
! hacer concordar el verbo en plural.
!
! esta -> escribe "está" o "están" según el número del objeto.
!
! del -> escribe "del" "de la" "de los" "de las" según el género y
! número del objeto. En realidad, determina qué artículo habría de ir
! y si éste es "el" realiza la contracción "del".
!
! al -> como del, pero con "al" "a la" "a los" "a las".
!
! lo -> Escribe "lo" "la" "le" "los" "las" "les" (proname) según el
! género y número del objeto y según sea animate o no.
!

Constant PARTICULA_TE       = "te";
Constant THOSET__TX      = "esas cosas";
Constant THAT__TX        = "eso";

[ o obj gna;

    gna=GetGNAOfObject(obj);
    switch(gna)
    {
     0,6: print "o";
     1,7: print "a";
     3,9: print "os";
     4,10: print "as";
    }
];    

[ e obj gna;

    gna=GetGNAOfObject(obj);
    switch(gna)
    {
     0,6: print "e";
     1,7: print "a";
     3,9: print "es";
     4,10: print "as";
    }
];


[ n obj;
    if (obj == player) print "s";
    else if (obj has pluralname) print "n";
];

[ s obj;
    if (obj has pluralname) print "s";
];

[ esta obj;
    print "está", (n) obj;
];

[ es obj;
    if (obj has pluralname) print "son";
    else print "es";
];

[ _Es obj;
    if (obj has pluralname) print "Son";
    else print "Es";
];

[ _s obj;
    if (obj has pluralname) print "es";
];

[ el_ obj;
    if (obj hasnt proper) PrefaceByArticle(obj,1,-1);
];

[ un_ obj;
    if (obj hasnt proper) PrefaceByArticle(obj,2,-1);
];


[ el obj;
    print (the) obj;
];

[ _El obj;
    print (The) obj;
];

![ un obj;
!    if (un_(obj)) print " ";
!    print (name) obj;
!];

[ un obj;
!  if (obj has proper) print "a "; ![infsp] ya se incluyó esta linea en el hackeo de Indefart.
  print (a) obj;
];

[ _Un obj; ! indefinido con la primera letra en mayuscula. -Eliuk Blau
  print (A) obj;
];


[ _nombre_ obj;
    print (name) obj;
];

[ numero obj;
    print (number) obj;
];


! "al" y "del" plantean un bonito problema. La contracción debe
! producirse si el artículo es "el", pero esto no se sabe consultando
! el GNA, pues hay palabras como "aguila" que son femeninas y no
! obstante usan "el" como artículo.
! El truquillo consiste en llamar a (the) para averiguar qué artículo
! se imprimiría (pero capturando la salida de ese print y guardándola
! en una variable). Si el artículo en cuestión empieza por 'e', se
! produce la contracción.
!
! Para capturar la salida a una variable, es necesario descender al
! lenguaje ensamblador de la Z machine. Este truco lo aprendí del
! Designers manual (respuesta al ejercicio 96, página 249)
!
[ del_ obj;
    if (obj has proper) {        ! 030305
            print "de ";
            rtrue;
    }
!print " (del) "; ! infsp debug
                
#ifdef TARGET_ZCODE;
    texto_impreso-->0 = 50;
    @output_stream 3 texto_impreso;
    print (the)obj;
    @output_stream -3;
    if (texto_impreso->2 == 'e') print "d";
    else print "de ";
#ifnot; !TARGET_GLULX
    Glulx_PrintAnyToArray(texto_impreso, 50, PrefaceByArticle, obj, 1, -1);
    if (texto_impreso->0 == 'e') print "d";
    else print "de ";
#endif;    
    if (obj hasnt proper) PrefaceByArticle(obj, 1, -1);
];

! Con "al" el truco es más complejo, ya que si el artículo impreso por
! el_ empieza por "e", hay que cambiar esta "e" por una "a". Y si no
! empieza por "e" hay que poner una "a" delante.
! Además debemos capturar el caso de que no se imprima artículo alguno
! (si el objeto proporciona una propiedad "articulos" con cadenas
! vacías).
!------------------------------------------------------------------------------
! ELIUK BLAU: He re-implementado la rutina para permitir que la primera letra
! se imprima en mayuscula si se activa el argumento 'flag' durante la llamada.
[ al_ obj flag; ! ELIUK: 'flag' es usado solo por rutina de impresion (_Al)
    #ifdef TARGET_ZCODE;
      texto_impreso-->0 = 50;
      @output_stream 3 texto_impreso;
      print (the) obj;
      @output_stream -3;
      ! print "^  ";for (i=2:i<50:i++) print (char)texto_impreso->i;print "   "; ! infsp debug
    #ifnot; !TARGET_GLULX
      ! PrintAnyToArray(texto_impreso, 50, PrefaceByArticle, obj, 1, -1);
      Glulx_PrintAnyToArray(texto_impreso, 50, Defart, obj);! 070809 infsp fix: corrige mal funcionamiento con Propios - gracias Eliuk
      ! print "^  ";for (i=0:i<2:i++) print (char)texto_impreso->i;print "   "; ! infsp debug
    #endif; !TARGET_
    
    ! ELIUK: aqui se decide si se pone mayuscula o no
    if (flag) { print "A"; } ! 'flag' activado
    else { print "a"; }      ! 'flag' desactivado

    ! ELIUK: completamos el resto del texto que se imprimira finalmente
    #ifdef TARGET_ZCODE;
      if (texto_impreso->2 == 'e') { print "l "; }
      else {
        print " ";
        if (obj hasnt proper) { PrefaceByArticle(obj, 1, -1); }
      }
    #ifnot; !TARGET_GLULX
      if (texto_impreso->0 == 'e') { print "l "; }
      else {
        print " ";
        if (obj hasnt proper) { PrefaceByArticle(obj, 1, -1); }
      }
    #endif; !TARGET_
];

[ del obj;
    print (del_) obj;
    print (name) obj;
];

[ al obj;
    print (al_) obj;
    print (name) obj;
];

! ELIUK BLAU: Rutina de impresion "A", "Al", "A la", "A los", "A las" con la primera
! letra en mayuscula. Se usa como base el funcionamiento de la rutina al_() de INFSP.
[ _Al obj;
    al_(obj,1); ! con 1 se activa 'flag' para imprimir primera letra en mayuscula
    print (name) obj;
    ! NOTA: SI POSTERIORMENTE SE INTENTA MEJORAR ESTA RUTINA, JUNTO CON al_(),
    ! LA SOLUCION JAMAS DEBE SER IMPRIMIR A UN BUFFER PORQUE LOS RESULTADOS
    ! PUEDEN SER INESPERADOS. LA PROPIA al_() YA IMPRIME A UN BUFFER, ASI QUE
    ! OTRO TRABAJO DEL MISMO TIPO IMPLICARIA TENER QUE CREAR UN NUEVO ARRAY
    ! CON EL QUE TRABAJAR O USAR EL ARRAY COMUN StorageForShortName DE LA
    ! PROPIA LIBRERIA INFORM. EN ESTE ULTIMO CASO ES CUANDO SE PRODUCEN LOS
    ! PROBLEMAS... POR OTRO LADO: CREAR UN NUEVO ARRAY SOLO PARA QUE LO USE
    ! ESTA RUTINA NO TIENE SENTIDO. POR ESO LA NECESIDAD DEL 'flag' EN al_()
];

[ lo obj gna;
    gna=GetGNAOfObject(obj);
    switch(gna)
    {
     0,6: print "lo";
     1,7: print "la";
     3,9: print "los";
     4,10: print "las";
    }
];

! deprecated
![ IsOrAre obj;  !I7 stuffs, in Verbs.i6/GenericVerbSub
!    if (obj == player)             { print "Eres"; return; }
!    if (obj has pluralname)        { print "Son"; return; }
!    print "Es";
!];

-) before "Commands" in "Language.i6t".


Section 12 - Otras rutinas

Include (-
Replace PrintCommand;
-) after "Definitions.i6t". [ver seccion i6 que sigue]


Include (-
! Cuando el usuario teclea un comando incompleto, es necesario que
! el parser genere un mensaje preguntando por lo que falta,
! pero la forma de preguntarlo depende del verbo. Por ej.:
!
! > coge
! ¿Qué quieres coger?
!
! > mete llave
! ¿Dónde quieres meter la llave?
!
! > orco, saca la botella
! ¿De dónde tiene que sacar el orco la botella?
!
! Cuando el parser tiene que imprimir una respuesta de estas,
! simplemente llama a MLIdioma con el número de mensaje Misc, 48 o
! 49. En esta versión de la librería (6/7) es responsabilidad de
! LanguageLM generar el mensaje completo.
!
! En nuestro caso hemos implementado estos mensajes de forma que
! llaman a IniciarPregunta para que escriba una partícula interrogativa
! como "Donde" "De donde", etc. Si no escribe nada, MLIdioma pone
! "Qué" o "A quién" según el tipo de error, a continuación se escribe
! "quieres" o "tiene que" según quién sea el actor. Se llama a
! LanguageVerb para que escriba el verbo, y finalmente se añade el
! name del objeto directo si lo había, para terminar la pregunta
! cerrando la interrogación.
!
! IniciarPregunta, lo que hace es: 
!
! 1) busca preposiciones en el patrón que ha encajado, si las
! encuentra, la pregunta debe comenzar por alguna partícula
! interrogativa. Por ejemplo, si la línea de gramática hallada era
! "saca" noun "de" noun, se hallará la preposición "de" que nos indica
! que la pregunta ha de comenzar con "¿De dónde ...".
!
! 2) Llama a la función "IdiomaPreguntarPrep" que recibe como
! parámetros la preposición y la acción en curso, para que imprima la
! partícula interrogativa adecuada. Esta función tan sólo debe
! escribir esa partícula.
!
! IdiomaPreguntarPrep llama a su vez a PreguntarPreposicion por si el
! programador añade verbos raros con preposiciones raras que no son
! correctamente manejados por esta rutina. Si PreguntarPreposicion
! existe y retorna distinto de cero, IdiomaPreguntarPrep asumirá
! que la partícula interrogativa ya ha sido escrita por
! PreguntarPreposicion y no hará nada más.
!
[ IdiomaPreguntarPrep prepos action;

    if (PreguntarPreposicion(prepos, action)) return;
    !print "^IPPrep: action: ", (DebugAction)action, "  Prepos: ",(address)prepos,"^"; ! infsp debug 
    switch (prepos)
    {
     'de':			print "De dónde";
     'en', 'dentro', 'encima': 	print "Dónde";
     'bajo','debajo':			print "Debajo de qué";
     'sobre', 'acerca':		print "Sobre qué";
     'contra':	print "Contra qué";
     'hacia':		print "Hacia dónde";
     'con':if (action==##Tell or ##Attack)  print "Con quién";
              else print "Con qué";
     'por':if (action==##Ask) 	print "Por qué";
              else print "Por dónde";
     'una', 'un' :				print "A quién";
     'a//':  switch(action){
           ##Go:			print "Hacia dónde";
           ##Climb:		print "Dónde";
           ##ThrowAt, ##Give, ##Show, ##Answer, ##Tell, ##Ask:	print "A quién";
           ##Search:	print "A través de qué";
           ##Tie:			print "A qué"; 
           ##Enter:		print "A dónde";
           default:		print "A quién";
       };
    }
];


! A partir del patrón que ha construido el parser, se determina cuál
! es la primera preposición usada detrás del verbo.
! Esto será usado por la función IniciarPregunta y por LanguageIsVerb
! [INFSP] Recoding para un mejor comportamiento en caso de lineas de gramaticas complejas
! Ej: 'pon' noun 'en/sobre' noun . Antes usando 'sobre' (segundo token) no andaba.
! (devolvia NULL)

[ AveriguarPreposicion 
    i k p ;

!		pattern: array que contiene las palabras reconocidas
!		pcount: contador dentro de pattern
!    print " ",pattern-->(pcount-1)," ^"; ![infsp] debug
!    print "pcount:",pcount," ^"; ![infsp] debug

    p = NULL;
    ! recorrido hacia atrás; apartir de pcount, posicion reconocida
    for (k=pcount:k>=1:k=k-1){ !infsp tunnig, para evitar el menos menos que quiebra la sintaxis de Include
       i=pattern-->k;
!        print "^AP: k:",k," i:",i," (i):",(address)VM_NumberToDictionaryAddress(i-REPARSE_CODE),"^"; ! infsp debug 
       if ( i == PATTERN_NULL) continue;
       if ( i >= REPARSE_CODE)
           p=VM_NumberToDictionaryAddress(i-REPARSE_CODE);!asignar particula, será la conectada a tipo de pregunta segun contexto
    }
    return p;

];


[ AveriguarPrimeraPreposicion
    i k p found;
    p=NULL;
    for (k=pcount:k>=1:k=k-1) ! infsp tunnig, para evitar el menos menos que quiebra la sintaxis de Include
    { 
!     print "^AP: k:",k; ! infsp debug
     i=pattern-->k;
!    print "^ i:",i; ! infsp debug 
   if (pattern-->k == PATTERN_NULL) continue;
!    i=pattern-->k;
        if (i>=REPARSE_CODE)
        {
        i=VM_NumberToDictionaryAddress(i-REPARSE_CODE);
        p=i;    ! nos quedamos con la primera
        found=k;
        }
    }
!    print "APP: Primera prep: ",(address) p; ! infsp debug
!    print " / found :",found; ! infsp debug
!    print " / pcount :",pcount,"^"; ! infsp debug
    
    if (found==(pcount -1)) return NULL;
    else return p;
];


! Averigua si es necesaria una partícula interrogativa. Llama a
! IdiomaPreguntarPrep para que la imprima.
!
! Retorna 1 si ha sido impresa la partícula interrogativa, y 0 en caso
! contrario, (y entonces la función que la llamó "LanguageLM", sabe
! que es necesario escribir "Qué" o "A quién" ya que en este caso lo
! que faltaba era el objeto directo en lugar del complemento.
!
[ IniciarPregunta
    p;

    print "¿";
    p=AveriguarPreposicion();
    if (p~=NULL) {
      IdiomaPreguntarPrep(p, action_to_be);
      return 1;
    }
    return 0;
    
];

!|PrintCommand| reconstructs the command as it presently reads, from the
!pattern which has been built up.

!If |from| is 0, it starts with the verb: then it goes through the pattern.

!The other parameter is |emptyf| -- a flag: if 0, it goes up to |pcount|:
!if 1, it goes up to |pcount|-1.

!Note that verbs and prepositions are printed out of the dictionary:
!and that since the dictionary may only preserve the first six characters
!of a word (in a V3 game), we have to hand-code the longer words needed.
!At present, I7 doesn't do this, but it probably should.

!(Recall that pattern entries are 0 for "multiple object", 1 for "special
!word", 2 to |REPARSE_CODE-1| are object numbers and |REPARSE_CODE+n| means
!the preposition |n|.)

!IdiomaImprimirComando: hackeo spanish de PrintCommand(Parser.i6t)
!												adicion inteligente de preposiciones en la deduccion impresa

[ PrintCommand from i k spacing_flag prep;

    if (from == 0) {
        i = verb_word;
        LanguageVerb(i); !check si uso abreviatura de comando ("i, z, l") e imprime verbo completo
        from++; spacing_flag = true;
    }
  
! print "^Valor de from: ",from,"^"; ! infsp debug
! print "Valor de pcount: ",pcount,"^"; ! infsp debug
  
  for (k=from:k<pcount:k++){
     i=pattern-->k;
     !print "^IIC: i: ",  i, "^"; ! infsp debug
      if (i == PATTERN_NULL) continue;
      if (spacing_flag) print (char) ' ';
      if (i == 0) { PARSER_CLARIF_INTERNAL_RM('F'); jump TokenPrinted; }!viejo THOSET__TX
      if (i == 1) { PARSER_CLARIF_INTERNAL_RM('G'); jump TokenPrinted; }!viejo THAT__TX
      if (i >= REPARSE_CODE) continue;
      else {
            if (i in compass && LanguageVerbLikesAdverb(verb_word))
                LanguageDirection (i.door_dir); ! the direction name as adverb
            if (i==player) print "te";
            else  {
               prep=AveriguarPrimeraPreposicion();
               switch(prep){
                 'a//': print (al) i;
                 'de': print (del) i;
                 NULL: print (the) i;
                 default: !print " ", (address) prep;
                           print (the) i;
               }
            }
      continue;
      }
      .TokenPrinted;
      spacing_flag = true;
  } ! for
];



! ---------------------------------------------------------------------------
! Otras rutinas de soporte para el AUTOR de Aventuras 

[ TextoLlamativo txt;
    ! Imprime un texto rodeado de asteriscos y en negrita. 
    ! Puedes cambiarlo si quieres que aparezcan en otros formatos.
     VM_Style(ALERT_VMSTY);
!     print "***", (string) txt, "***"; ! [010508] Corregido bug (string)
     print (string) txt; ! infsp fix, los asteriscos ya se ponian en parserm.h
     VM_Style(NORMAL_VMSTY);
];


Constant LIBRARY_SPANISH;       ! for dependency checking.
-)

Section 13 - Otras Acciones


Include (-
! Esto era parte de SpanishG.h (Gramatica.h) GRAMATICA: Gramática española

#Stub PreguntarPreposicion 0;

#ifdef DEBUG;
  [ ActivarAcentosSub;
    quitacentos = 0;
    "Los acentos no serán eliminados del comando recibido.";
  ];

  [ DesactivarAcentosSub;
    quitacentos = 1;
    "Los acentos serán eliminados del comando recibido, pero sólo en
      las palabras que de otro modo no serían comprendidas.";
  ];
#endif; ! DEBUG

! Elección del dialecto (afecta a la interpretación del
! verbo COGER únicamente)

[ DialectoSub;
  print "Actualmente estás jugando en el dialecto ";
  if (dialecto_sudamericano)
    print "sudamericano";
  else
    print "castellano";
  ". Puedes elegir dialecto usando el comando DIALECTO SUDAMERICANO \
    o bien DIALECTO CASTELLANO.";
];

[ DialectoSudSub;
  dialecto_sudamericano = 2; ! git
  "Elegido dialecto SUDAMERICANO.";
];    

[ DialectoCastSub;
  dialecto_sudamericano = 0;
  "Elegido dialecto CASTELLANO.";
];


[ QuitarSub;
    if (second) <<Remove noun second>>;
    if (noun in player) <<Disrobe noun>>;
    <<Take noun>>;
];

! Algunas lineas de gramatica no incluidas en las SR (lineas que son propias de InformATE)
! [TODO]: a la espera de ser 'transferidas' a SL (Spanish Localization I7 Extension)
! Actualizacion, ahora si andan las Extend, porque se cambio de lugar la inclusion de SpanishG
!   en el codigo de auto.inf (usando Foreign Language en SL y main.i6)

Verb meta 'dialecto'
  *                                   -> Dialecto
  * 'sudamericano'               -> DialectoSud
  * 'castellano'                    -> DialectoCast;

! GotoRoomSub: algunos momios de informATE estaban acotumbrados a hacer >xir 'nombre_habitacion'
! pero, despues de la Build 4S08 no fue posible sino la forma oficial
! >xir 'numero_habitacion' . Ese numero_habitacion se ve haciendo >tree
! Aqui agregamos una variante para poder seguir usando nuestro >xir 'nombre_habitacion'
! (de puro caprichosos que somos) 

#ifdef DEBUG;

[ GotoRoomSub x;  ! para funciones de debug
    x = noun;
    while (parent(x) ~= 0) x = parent(x);
!    print "   Moviendo a ",(the) x,"^";!infsp debug
    PlayerTo(x);
];   
  
 Verb meta 'acentos'
    *                                 -> ActivarAcentos
    * 'on'/'si'                          -> ActivarAcentos
    * 'off'/'no'                      -> DesactivarAcentos;

  Verb 'traza' = 'trace';

  Verb 'acciones' = 'actions';

  Verb 'aleatorio' 'predecible' = 'random' ;

  Verb 'xroba' = 'purloin';

  Verb meta 'xmueve'
	* scope=testcommandnoun ’a//’ scope=testcommandnoun -> XAbstract;

  Verb 'arboljuego' 'xarbol' = 'tree';

  Verb meta 'xir'
    * scope=testcommandnoun  -> GotoRoom;

  Verb 'irdonde' = 'gonear';

  Verb 'alcance' = 'scope' ;

  Verb 'xverbo' = 'showverb';

  Verb 'xobjeto' =  'showme';

  Verb 'relaciones'= 'relations';
  
  Verb 'reglas' = 'rules';
  
  Verb 'escenas' =  'scenes';
  
#endif;  ! DEBUG

-) after "Grammar" in "Output.i6t".


Section 14 - Hora en palabras





Section 15 - Spanish Banner

[just replacement "by" --> "por"]

Include (-

[ Banner;
		!print (string) Story;!deprecated
		!print " / Inform 7 build ", (string) NI_BUILD_COUNT, " ";!deprecated
   BeginActivity(PRINTING_BANNER_TEXT_ACT);
   if (ForActivity(PRINTING_BANNER_TEXT_ACT) == false) {
	   	VM_Style(HEADER_VMSTY);
		TEXT_TY_Say(Story);
		VM_Style(NORMAL_VMSTY);
		new_line;
		TEXT_TY_Say(Headline);
		#ifdef Story_Author;
		!print " by "; TEXT_TY_Say(Story_Author);
    print " por "; TEXT_TY_Say(Story_Author);! infsp hack 'by'
		#endif; ! Story_Author
		new_line;
		VM_Describe_Release();
		print " / Inform 7 build ", (PrintI6Text) NI_BUILD_COUNT, " ";
		print "(I6/v"; inversion;
		print " lib ", (PrintI6Text) LibRelease, ") ";
		#Ifdef STRICT_MODE;
		print "S";
		#Endif; ! STRICT_MODE
		#Ifdef DEBUG;
		print "D";
		#Endif; ! DEBUG
		new_line;
    }
    EndActivity(PRINTING_BANNER_TEXT_ACT);

];
-) instead of "Banner" in  "Printing.i6t". 


Section 16 - PrefaceByArticle Hacked

[for use of rutines [el_], [un_] ]

Include (-

Global short_name_case;

!para q funcione con (el_):
[ PrefaceByArticle obj acode pluralise capitalise  i artform findout artval;
    if (obj provides articles) {
        artval=(obj.&articles)-->(acode+short_name_case*LanguageCases);
        if (capitalise)
            print (Cap) artval, " ";
        else
            print (string) artval, " ";
        if (pluralise) return;
        print (PSN__) obj; return;
    }

    i = GetGNAOfObject(obj);


!    if (pluralise) {
! [infsp]: para q funcione con (el_), se agrego '>0' para el correcto funcionamiento (sino al final imprime el nombre de objeto cuando yo solo quiero imprimir su articulo)
    if (pluralise>0) { ![INFSP] ej, en ListMiscellany 19,[TODO] esto podria resolverse como los italianos
        if (i < 3 || (i >= 6 && i < 9)) i = i + 3;
    }
    i = LanguageGNAsToArticles-->i;

    artform = LanguageArticles
        + 3*WORDSIZE*LanguageContractionForms*(short_name_case + i*LanguageCases);

    #Iftrue (LanguageContractionForms == 2);
    if (artform-->acode ~= artform-->(acode+3)) findout = true;
    #Endif; ! LanguageContractionForms
    #Iftrue (LanguageContractionForms == 3);
    if (artform-->acode ~= artform-->(acode+3)) findout = true;
    if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
    #Endif; ! LanguageContractionForms
    #Iftrue (LanguageContractionForms == 4);
    if (artform-->acode ~= artform-->(acode+3)) findout = true;
    if (artform-->(acode+3) ~= artform-->(acode+6)) findout = true;
    if (artform-->(acode+6) ~= artform-->(acode+9)) findout = true;
    #Endif; ! LanguageContractionForms
    #Iftrue (LanguageContractionForms > 4);
    findout = true;
    #Endif; ! LanguageContractionForms

    #Ifdef TARGET_ZCODE;
    if (standard_interpreter ~= 0 && findout) {
        StorageForShortName-->0 = 160;
        @output_stream 3 StorageForShortName;
        if (pluralise) print (number) pluralise; else print (PSN__) obj;
        @output_stream -3;
        acode = acode + 3*LanguageContraction(StorageForShortName + 2);
    }
    #Ifnot; ! TARGET_GLULX
    if (findout) {
        if (pluralise)
            Glulx_PrintAnyToArray(StorageForShortName, 160, EnglishNumber, pluralise);
        else
            Glulx_PrintAnyToArray(StorageForShortName, 160, PSN__, obj);
        acode = acode + 3*LanguageContraction(StorageForShortName);
    }
    #Endif; ! TARGET_

    Cap (artform-->acode, ~~capitalise); ! print article
    if (pluralise) return;
    print (PSN__) obj;
];

-) instead of "Object Names II" in  "Printing.i6t".

Section 17 - IndefArt Hacked

[! [infsp] Indefart: se agregó el "a " en caso de nombre propio " a Mamá"]

Include (-
Replace IndefArt;
-) after "Definitions.i6t". 

Include (-
[ IndefArt obj i;
	if (obj == 0) { LIST_WRITER_INTERNAL_RM('Y'); rtrue; }
    i = indef_mode; indef_mode = true;
    if (obj has proper) { indef_mode = NULL; print "a ",(PSN__) obj; indef_mode = i; return; }!infsp
    if ((obj provides article) && (TEXT_TY_Compare(obj.article, EMPTY_TEXT_VALUE) ~= 0)) {
        PrintOrRun(obj, article, true); print " ", (PSN__) obj; indef_mode = i;
        return;
    }
    PrefaceByArticle(obj, 2); indef_mode = i;

];
-) after "Object Names III" in "Printing.i6t".

Section 18 - Checkin I7 Build version - Not for release 

A startup rule:
	Check I7 Version.

To Check I7 Version: (- chkI7V(); -).

Include (-
#ifdef DEBUG;
Array  buffer_nversion string 7;    ! infsp debug: Buffers for cheking I7 IDE correct version
Array  buffer_bversion string 7;    ! See LanguageInitialise, below.

Constant NI_NEEDED_VERSION "6M62";
! LanguageInitialise: ojo que aqui aun no se seteo el I/O para Glulx (no andarian los prints y demás).

[ chkI7V;				!infsp debug : check correct I7 Build Version
!     print "LanguageInitialise^^"; 
   if ( ~~CheckI7version() ){
     print "^^^ INFSP ATENCION : Este juego fue compilado con una version distinta de
        Inform (distinta a la soportada por la extensión Spanish).^Asegurate de compilar con la ";
     ImprimeTodoElBuffer(buffer_nversion);
     print ". ^^^"; 
   }

];

[ CheckI7version	l i;
	l = VM_PrintToBuffer(buffer_nversion, 4, NI_NEEDED_VERSION);
	l = VM_PrintToBuffer(buffer_bversion, 4, NI_BUILD_COUNT);    
	for (i=WORDSIZE:i<WORDSIZE+4:i++)	! comparar caracter x caracter:
		if (buffer_bversion->i ~= buffer_nversion->i) rfalse;
		rtrue;
];
#endif; ! DEBUG
-) after "Definitions.i6t".


Part TC - Special functions extracted from Text Capture by Eric Eve (for use without Text Capture by Eric Eve) 

[according CC BY license]

Use maximum capture buffer length of at least 256 translates as (- Constant CAPTURE_BUFFER_LEN = {N}; -). 

To start capturing text:
	(- StartCapture(); -).

To stop capturing text:
	(- EndCapture(); -).

To say the/-- captured text:
	(- PrintCapture(); -).


[Part 3 - I6 Code]

Include (-	Global capture_active = 0;	-) after "Definitions.i6t".

Chapter Z - Z-Machine Version (for Z-Machine Only)

Include (-

Array captured_text -> CAPTURE_BUFFER_LEN + 3;

[ StartCapture;
	if (capture_active ==1)
		return;
	capture_active = 1;
	@output_stream 3 captured_text;
];


[ EndCapture;
	if (capture_active == 0)
		return;
	capture_active = 0;
	@output_stream -3;
	if (captured_text-->0 > CAPTURE_BUFFER_LEN)
	{
		print "Error: Overflow in EndCapture.^";
	}
];

[ PrintCapture len i;
	len = captured_text-->0;
	for ( i = 0 : i < len : i++ )
	{
		print (char) captured_text->(i + 2);
	}
];

-) after "Definitions.i6t".

Chapter G - Glulx (for Glulx Only)

Include (-

Array captured_text --> CAPTURE_BUFFER_LEN + 1;

Global text_capture_old_stream = 0;
Global text_capture_new_stream = 0;

[ StartCapture i;   
	if (capture_active ==1)
		return;
	capture_active = 1;
	text_capture_old_stream = glk_stream_get_current();
	text_capture_new_stream = glk_stream_open_memory_uni(captured_text + WORDSIZE, CAPTURE_BUFFER_LEN, 1, 0);
	glk_stream_set_current(text_capture_new_stream);
];

[ EndCapture len;
	if ( capture_active == 0 )
		return;
	capture_active = 0;
	glk_stream_set_current(text_capture_old_stream);
	@copy $ffffffff sp;
	@copy text_capture_new_stream sp;
	@glk $0044 2 0; ! stream_close
	@copy sp len;
	@copy sp 0;
	captured_text-->0 = len;
	if (len > CAPTURE_BUFFER_LEN)
	{
		captured_text-->0 = CAPTURE_BUFFER_LEN;
	}
];

[ PrintCapture len i;
	len = captured_text-->0;
	for ( i = 0 : i < len : i++ )
	{
		glk_put_char_uni(captured_text-->(i + 1));
	}
];

-) after "Definitions.i6t".


Spanish Language ends here.

---- DOCUMENTATION ----

Chapter: Texto Adaptativo: Verbos

ATENCIÓN: La actual Build 6M62 de I7 tiene un bug por el que fue necesario desactivar el asunto del texto adaptativo en el caso de los verbos (al cambiar de persona). Por favor, no lo utilices hasta tanto se corrija. O sea, lo siguiente no funciona:

La phrase:

	say "[Tu] [saltas] en el sitio.[plm]".
    
Produce:

	1PS: Salto en el sitio.
    
	2PS: Saltas en el sitio.
    
	3PS: Él salta en el sitio.
    
    
Es importante terminar el texto con el token "[plm]" (primera letra en mayúscula), así Spanish puede imprimir "Salta".
Cuando la sustitución se utiliza en medio de una frase, no es necesario el token "[plm]".

	say "El portón se cierra de un golpe y [tu] [saltas] en el sitio.".


Chapter: Terminaciones nuevas

Género del jugador: La partícula [o_player] imprime sufijo segun género del jugador actual.

block sleeping rule response (A) is "No estás especialmente somnolient[o_jugador].".

>duerme
No estás especialmente somnolienta.


Chapter: Extenciones de fábrica: traducciones

La Spanish Language también traduce las extensiones:

Basic Screen Effects

Inanimate Listeners


