6M62 Patches by Friends of I7 begins here.

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

6M62 Patches ends here.
