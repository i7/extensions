Version 1 of Third Noun by Daniel Stelzer begins here.

The third noun is an object that varies. The third noun variable translates into I6 as "third".

The understand token third something translates into I6 as "THIRD_NOUN_TOKEN".

[cf. DM4, p. 489]

Include (-
Global third;
-) after "Definitions.i6t".

Include (-
[ THIRD_NOUN_TOKEN  x;
    x  =  ParseToken(ELEMENTARY_TT,  NOUN_TOKEN);
    if  (x  ==  GPR_FAIL  or  GPR_REPARSE)  return  x;
    third  =  x;  return  GPR_PREPOSITION;
];
-).

Third Noun ends here.
