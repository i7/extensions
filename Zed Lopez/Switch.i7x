Version 2 of Switch by Zed Lopez begins here.

"A switch statement. Tested with 6M62."

Include (-
Constant SWITCH_ARRAY_WIDTH = 4;
Constant SWITCH_VAR = 1;
Constant SWITCH_KIND = 2;
Constant SWITCH_CMP = 3;
Constant SWITCH_STATE = 4;
Global switch_stack_pointer = 0;
-) after "Definitions.i6t".

Use switch stack size of at least 250 translates as (- Constant SWITCH_STACK_SIZE = {N}; -).

default is always true.

Include (-
Array SwitchStack table SWITCH_ARRAY_WIDTH * SWITCH_STACK_SIZE;

[ pushSwitchStack s_var s_kind s_cmp s_state;
  switch_stack_pointer++;
  SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR) = s_var;
  SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND) = s_kind;
  if (s_cmp) SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP) = s_cmp;
  else SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP) = cmpFn(s_kind);
  SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE) = s_state;
];

[ cmpFn kind;
  if (kind == NUMBER_TY) return SwSignedCompare;
  return KOVComparisonFunction(kind);
];

[ SwSignedCompare x y;
if (x > y) return 1;
if (x < y) return -1;
return 0;
];

-);

To if switch (v - a value of kind K) begin -- end loop:
  (-
  pushSwitchStack({v}, {-strong-kind:K}, cmpFn({-strong-kind:K}), 1);
  if (1) {-block}
  switch_stack_pointer--;
   -)

To if == (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND);
  {-my:3} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  {-my:4} = switch_stack_pointer; 
  {-my:5} = (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP))(SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR),{v2}); 
  if ({-my:5} == 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},{-my:3},0);
    }
  }
-)
    
To if < (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND);
  {-my:3} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  {-my:4} = switch_stack_pointer; 
  {-my:5} = (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP))(SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR),{v2}); 
  if ({-my:5} < 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},{-my:3},0);
    }
  }
-)

To if <= (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND);
  {-my:3} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  {-my:4} = switch_stack_pointer; 
  {-my:5} = (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP))(SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR),{v2}); 
  if ({-my:5} <= 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},{-my:3},0);
    }
  }
-)

To if >= (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND);
  {-my:3} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  {-my:4} = switch_stack_pointer; 
  {-my:5} = (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP))(SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR),{v2}); 
  if ({-my:5} >= 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},{-my:3},0);
    }
  }
-)
  
To if > (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND);
  {-my:3} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  {-my:4} = switch_stack_pointer; 
  {-my:5} = (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP))(SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR),{v2}); 
  if ({-my:5} > 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},{-my:3},0);
    }
  }
-)

To if / (R - a text) / begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_KIND);
  {-my:3} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  {-my:4} = switch_stack_pointer;
  if (TEXT_TY_Replace_RE(REGEXP_BLOB,{-my:1},{-by-reference:R},0,{phrase options})) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},{-my:3},0);
    }
  }
-).

To if (v - a value) case begin -- end loop: (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
    switch_stack_pointer--;
    if (1) {-block}
    switch_stack_pointer++; ! don't bother maintaining values, we're done
}

-)

Switch ends here.

---- Documentation ----

Doesn't fall through. Sorry, Duff's Device fans.

If you include a default case, it must be the last thing.

Example: * Switch

	*: "switch"
	
	Include Switch by Zed Lopez.
	
	Lab is a room.
	
	To decide what text is switchcat (T - a text):
	if switch T begin;
	  if / "dog" /, decide on "woof.";
	  if == "cat", decide on switchcat "doggoneit";
	  if / "c.t?" /, decide on "meow.";
	end if;
	decide on "?";
	
	when play begins:
	if switch 2 begin;
	  if == 1, say "yow!";
	  if < 3, say switchcat "cat";
	  if default case, say "nothing.";
	end if;
