Version 2/220329 of Switch by Zed Lopez begins here.

"A switch statement. Tested with 6M62."

Include (-
Constant SWITCH_ARRAY_WIDTH = 3;
Constant SWITCH_VAR = 1;
Constant SWITCH_CMP = 2;
Constant SWITCH_STATE = 3;
Global switch_stack_pointer = 0;
-) after "Definitions.i6t".

Use switch stack size of at least 250 translates as (- Constant SWITCH_STACK_SIZE = {N}; -).

default is always true.

Include (-
Array SwitchStack table SWITCH_ARRAY_WIDTH * SWITCH_STACK_SIZE;

[ pushSwitchStack s_var s_cmp s_state;
  switch_stack_pointer++;
  if (switch_stack_pointer == SWITCH_STACK_SIZE) {
    print "^*** Out of switch stack space of ", SWITCH_STACK_SIZE, "^";
    rfalse;
  }
  SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR) = s_var;
  SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP) = s_cmp;
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
  pushSwitchStack({v}, cmpFn({-strong-kind:K}), 1);
  if (1) {-block}
  switch_stack_pointer--;
   -)

To if == (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  if ({-my:2}({-my:1},{v2}) == 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if < (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);

  if ({-my:2}({-my:1},{v2}) < 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if > (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);

  if ({-my:2}({-my:1},{v2}) > 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if <= (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);

  if ({-my:2}({-my:1},{v2}) <= 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if >= (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  if ({-my:2}({-my:1},{v2}) >= 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if <>/!- (v2 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  if ({-my:2}({-my:1},{v2}) =~ 0) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if range (v2 - a value) to (v3 - a value) begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  if (({-my:2}({-my:1},{v2}) >= 0) && ({-my:2}({-my:1},{v3}) <= 0)) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
    }
  }
-)

To if / (R - a text) / begin -- end loop:
  (-
  if (SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_STATE)) {
  {-my:1} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_VAR);
  {-my:2} = SwitchStack-->(switch_stack_pointer * SWITCH_ARRAY_WIDTH + SWITCH_CMP);
  if (TEXT_TY_Replace_RE(REGEXP_BLOB,{-my:1},{-by-reference:R},0,{phrase options})) {
    switch_stack_pointer--;
    if (1) {-block};
    pushSwitchStack({-my:1},{-my:2},0);
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

Chapter Changelog

2/220329 cleanup, no longer track kind in state array, use fewer temp vars

Example: * Switch

	*: "switch"
	
	Include Switch by Zed Lopez.
	
	Lab is a room.
	
	xyz is initially 3.
	
	To decide what text is switchcat (T - a text):
	if switch T begin;
	  if / "dog" /, decide on switchcat "cat";
	  if == "cat" begin;
	    if switch xyz begin;
	      if range 4 to 8, decide on "blue";
	      if range 2 to 3, decide on "red";
	      if > 5, decide on "moo";
	      if < 4, decide on "baa";
	      if == 3, decide on "yow";
	      if default case, decide on "blah";
	    end if;
	  end if;
	  if / "c.t?" /, decide on "meow.";
	end if;
	decide on "?";
	
	when play begins:
	if switch 2 begin;
	  if == 1, say "yow!";
	  if < 3, say switchcat "dog";
	  if default case, say "nothing.";
	end if;
