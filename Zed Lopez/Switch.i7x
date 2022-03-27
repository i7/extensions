Version 1 of Switch by Zed Lopez begins here.

"A switch statement. Tested with 6M62."

Include (-
Global switch_var;
Global switch_var_kind;
Global switch_state;
Global switch_cmp_fn;
-) after "Definitions.i6t".

Include (-
[ SignedCompare x y;
if (x > y) return 1;
if (x < y) return -1;
return 0;
];

-)

default is a truth state that varies.
The default variable translates into I6 as "switch_state".

To if switch (v - a value of kind K) begin -- end loop:
  (- @push switch_state;
     @push switch_var;
     @push switch_var_kind;
     @push switch_cmp_fn;
     switch_state = 1;
     switch_var = {v};
     switch_var_kind = {-strong-kind:K};
     if (switch_var_kind == NUMBER_TY) switch_cmp_fn = SignedCompare;
     else switch_cmp_fn = KOVComparisonFunction(switch_var_kind);
     if (1) {-block}
     @pull switch_cmp_fn;
     @pull switch_var_kind;
     @pull switch_var;
     @pull switch_state;
   -)

To if == (v2 - a value) begin -- end loop:
  (- 
     if (switch_state && (switch_cmp_fn(switch_var, {v2}) == 0)) {
       switch_state = 0;
       if (1) {-block}
     }
   -);

To if < (v2 - a value) begin -- end loop:
  (- 
     if (switch_state && (switch_cmp_fn(switch_var, {v2}) < 0)) {
       switch_state = 0;
       if (1) {-block}
     }
   -);
  

To if <= (v2 - a value) begin -- end loop:
  (- 
     if (switch_state && (switch_cmp_fn(switch_var, {v2}) <= 0)) {
       switch_state = 0;
       if (1) {-block}
     }
   -);
  

To if >= (v2 - a value) begin -- end loop:
  (- 
     if (switch_state && (switch_cmp_fn(switch_var, {v2}) >= 0)) {
       switch_state = 0;
       if (1) {-block}
     }
   -);
  
To if > (v2 - a value) begin -- end loop:
  (- 
     if (switch_state && (switch_cmp_fn(switch_var, {v2}) > 0)) {
       switch_state = 0;
       if (1) {-block}
     }
   -);

To if / (R - a text) / begin -- end loop:
  (- if (switch_state && TEXT_TY_Replace_RE(REGEXP_BLOB,switch_var,{-by-reference:R},0,{phrase options})) {
  switch_state = 0;
  if (1) {-block}
  }
  -).

Switch ends here.

---- Documentation ----

Example: * Switch

	*: "Switch"
	
	Include If True by Zed Lopez.
	Include Switch by Zed Lopez.
	
	Lab is a room.
	
	when play begins:
	if switch 2 begin;
	  if == 1, say "yow!";
	  if < 3, say "less than 3";
	  if default, say "nothing";
	end if;
	if switch "cat" begin;
	  if / "dog" /, say "woof";
	  if == "cat", say "meow first";  
	  if / "c.t?" /, say "meow";
	  if default, say "?";
	end if;
