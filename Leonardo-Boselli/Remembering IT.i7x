Version 9/140531 of Remembering IT by Leonardo Boselli begins here.

"Translation in italian of Version 9/140430 of Remembering by Aaron Reed.

Replaces 'You can't see any such thing' for a seen but out-of-scope noun with a message acknowledging that the parser recognizes the object. With Glulx, also keeps track of where the player last saw that object."

Include Remembering by Aaron Reed.


Chapter - Remembering Main

Section - Grammar Line

[Future: any way to make this work for any reference to an object?]

Understand
"esamina [any seen thing]" or
"esamina il/lo/la/i/gli/le/l [any seen thing]" or
"x [any seen thing]" or
"guarda [any seen thing]" or
"guarda il/lo/la/i/gli/le/l [any seen thing]" or
"prendi [any seen thing]" or
"prendi il/lo/la/i/gli/le/l [any seen thing]" or
"raccogli [any seen thing]" or
"raccogli il/lo/la/i/gli/le/l [any seen thing]" or
"lascia [any seen thing]" or
"lascia il/lo/la/i/gli/le/l [any seen thing]" or
"getta [any seen thing]" or
"getta il/lo/la/i/gli/le/l [any seen thing]" or
"trova [any seen thing]" or
"trova il/lo/la/i/gli/le/l [any seen thing]" or
"dov è [any seen thing]" or
"dov è il/lo/la/i/gli/le/l [any seen thing]" or
"dove è/sono [any seen thing]" or
"dove è/sono il/lo/la/i/gli/le/l [any seen thing]" as remembering.

Chapter - Responses

Remembering generic report remembering rule response (A) is "[as the parser]Non [regarding the player][puoi] più vedere [the noun].[as normal][line break]".
Remembering don't disambiguate while remembering rule response (A) is "[as the parser][if the noun is nothing]Non si [regarding nothing][vedi] nulla del genere[otherwise]Non si [vedi] alcun [noun][end if].[as normal][line break]".

Chapter - Responses II (for Glulx only)

Remembering specific report remembering rule response (A) is "[as the parser]L[']ultima volta che [regarding the player][hai] visto [the noun], [sei] stato [at the remembered location of noun].[as normal][line break]".
Remembering saying room name rule response (A) is "ne '[the place]'".
Remembering saying current location name rule response (A) is "proprio [qui]".
Remembering saying person name rule response (A) is "in possesso [dip the subject]".
Remembering saying player name rule response (A) is "in [tuo] possesso".
Remembering saying container name rule response (A) is "[inp the holder]".
Remembering saying supporter name rule response (A) is "[sup the holder]".


Remembering IT ends here.

---- DOCUMENTATION ----

Read the original documentation of Version 9/140430 of Remembering by Aaron Reed.
