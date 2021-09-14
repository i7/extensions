Version 2/210913 of 6M62 Patches by Friends of I7 begins here.

Use authorial modesty.

Volume intfiction.org/t/46906

[The original version of this function assumes that both sides of the relation are the same kind of value (or that
 both are objects of some kind that need not be the same kind).  The latter is reasonably common, but not guaranteed.
 This implementation actually checks.]
Include (-
[ Relation_ShowOtoO relation sym x relation_property t1 t2 N1 obj1 obj2;
	relation_property = RlnGetF(relation, RR_STORAGE);
	t1 = KindBaseTerm(RlnGetF(relation, RR_KIND), 0); ! Kind of left term
	t2 = KindBaseTerm(RlnGetF(relation, RR_KIND), 1); ! Kind of right term
	if (t1 == OBJECT_TY) {
		objectloop (obj1 provides relation_property) {
			obj2 = obj1.relation_property;
			if (sym && obj2 < obj1) continue;
			if (obj2 == 0) continue;
			if (x == 0) { print (string) RlnGetF(relation, RR_DESCRIPTION), ":^"; x=1; }
			print "  ", (The) obj1;
			if (sym) print "  ==  "; else print "  >=>  ";
			if (t2 == OBJECT_TY) {
				print (the) obj2, "^";
			} else {
				PrintKindValuePair(t2, obj2);
				print "^";
			}
		}
	} else {
		N1 = KOVDomainSize(t1);
		for (obj1=1: obj1<=N1: obj1++) {
			obj2 = GProperty(t1, obj1, relation_property);
			if (sym && obj2 < obj1) continue;
			if (obj2 == 0) continue;
			if (x == 0) { print (string) RlnGetF(relation, RR_DESCRIPTION), ":^"; x=1; }
			print "  ";
			PrintKindValuePair(t1, obj1);
			if (sym) print "  ==  "; else print "  >=>  ";
			if (t2 == OBJECT_TY) {
				print (the) obj2, "^";
			} else {
				PrintKindValuePair(t2, obj2);
				print "^";
			}
		}
	}
];
-) instead of "Show One to One" in "Relations.i6t".

Volume intfiction.org/t/50338

[Having a "rulebook producing a list of [something]" crashes the interpreter because only
the "weak kind" (e.g. "list") is passed to the template functions, when a "strong kind"
(e.g. "list of text") is expected. This replacement fixed the issue by making the compiler
pass in the "strong kind" instead.]

Section A - List Type fixes - in place of Section SR5/4/8 in Standard Rules by Graham Nelson

To make no decision
	(documented at ph_nodecision): (- rfalse; -) - in to only.
To rule succeeds
	(documented at ph_succeeds):
	(- RulebookSucceeds(); rtrue; -) - in to only.
To rule fails
	(documented at ph_fails):
	(- RulebookFails(); rtrue; -) - in to only.
[Fix here:]
To rule succeeds with result (val - a value)
	(documented at ph_succeedswith):
	(- RulebookSucceeds({-strong-kind:rule-return-kind},{-return-value-from-rule:val}); rtrue; -) - in to only.
To decide if rule succeeded
	(documented at ph_succeeded):
	(- (RulebookSucceeded()) -).
To decide if rule failed
	(documented at ph_failed):
	(- (RulebookFailed()) -).
To decide which rulebook outcome is the outcome of the rulebook
	(documented at ph_rulebookoutcome):
	(- (ResultOfRule()) -).

Volume intfiction.org/t/50840

[ A bug in TEXT_TY_BlobAccess can cause BlkValueWrite: writing to index out
  of range errors when looping through words in a line or lines in a block
  of text. Analysis and solution by Peter Bates. ]

Include (-
Replace TEXT_TY_BlobAccess;
-) after "Definitions.i6t".

Include (-

[ TEXT_TY_BlobAccess txt blobtype ctxt wanted rtxt
    p1 p2 cp1 cp2 r;
    if (txt==0) return 0;
    if (blobtype == CHR_BLOB) return TEXT_TY_CharacterLength(txt);
    cp1 = txt-->0; p1 = TEXT_TY_Temporarily_Transmute(txt);
    cp2 = rtxt-->0; p2 = TEXT_TY_Temporarily_Transmute(rtxt);
    TEXT_TY_Transmute(ctxt);
    ! ########### insertion begins ###########
    if (ctxt) BlkMakeMutable(ctxt);
    ! ########### insertion ends ###########
    r = TEXT_TY_BlobAccessI(txt, blobtype, ctxt, wanted, rtxt);
    TEXT_TY_Untransmute(txt, p1, cp1);
    TEXT_TY_Untransmute(rtxt, p2, cp2);
    return r;
];

-) after "Output.i6t".

6M62 Patches ends here.

---- Documentation ----

Changelog

v. 2/210913: Add TEXT_TY_BlobAccess fix by Peter Bates per intfiction.org/t/50840
