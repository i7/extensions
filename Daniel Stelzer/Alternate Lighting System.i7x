Alternate Lighting System by Daniel Stelzer begins here.

An object can be specially lighted or not specially lighted. An object is usually specially lighted. [This can be changed for individual objects for performance reasons.]

The special light calculation rules are an object based rulebook. The special light calculation rulebook has an object called the light-calculation object.
The first special light calculation for an object (called the item):
	now the light-calculation object is the item.
The last special light calculation for an object (this is the default lighting rule):
	if the light-calculation object is lit, rule succeeds;
	rule fails.

Include (-
[ IsLightSource obj;
	if (~~GetEitherOrProperty(obj, (+ specially lighted +))) {
		if (obj has light) rtrue;
		rfalse;
	}
	FollowRulebook( (+ special light calculation rules +), obj, true );
	if(RulebookSucceeded()) rtrue;
	rfalse;
];

[ OffersLight obj j;
    while (obj) {
		if (IsLightSource(obj)) rtrue;
		objectloop (j in obj) if (HasLightSource(j)) rtrue;
		if ((obj has container) && (obj hasnt open) && (obj hasnt transparent)) rfalse;
		if ((obj provides component_parent) && (obj.component_parent))
			obj = obj.component_parent;
		else
			obj = parent(obj);
	}
    rfalse;
];

[ HasLightSource i j ad sr po;
	if (i == 0) rfalse;
    if (IsLightSource(i)) rtrue;
    if ((IsSeeThrough(i)) && (~~(HidesLightSource(i))))
        objectloop (j in i)
            if (HasLightSource(j)) rtrue;
    ad = i.&add_to_scope;
    if (parent(i) ~= 0 && ad ~= 0) {
        if (metaclass(ad-->0) == Routine) {
            ats_hls = 0; ats_flag = 1;
            sr = scope_reason; po = parser_one;
            scope_reason = LOOPOVERSCOPE_REASON; parser_one = 0;
            RunRoutines(i, add_to_scope);
            scope_reason = sr; parser_one = po;
            ats_flag = 0; if (ats_hls == 1) rtrue;
        }
        else {
            for (j=0 : (WORDSIZE*j)<i.#add_to_scope : j++)
                if ((ad-->j) && (HasLightSource(ad-->j) == 1)) rtrue;
        }
    }
    if (ComponentHasLight(i)) rtrue;
    rfalse;
];

[ ComponentHasLight o obj next_obj;
	if (o provides component_child) {
		obj = o.component_child;
		while (obj) {
			next_obj = obj.component_sibling;
			if (IsLightSource(obj)) rtrue;
			if (HasLightSource(obj)) rtrue;
			if ((obj provides component_child) && (ComponentHasLight(obj))) rtrue;
			obj = next_obj;
		}
	}
	rfalse;
];

[ HidesLightSource obj;
    if (obj == player) rfalse;
    if (obj has transparent or supporter) rfalse;
    if (obj has animate) rfalse;
    if (obj has container) return (obj hasnt open);
    return (obj hasnt enterable);
];
-) instead of "Light Measurement" in "Light.i6t".

Alternate Lighting System ends here.

---- DOCUMENTATION ----

This extension replaces the Inform 6 lighting code with an Inform 7 version. In essence, it replaces the condition "object has light" in the Inform 6 templates with a call to an Inform 7 rulebook. If you don't want the overhead for a particular object, you can declare it to be "not specially lighted".

By default, the "special light calculation" rules merely check the "light" flag (and thus you won't see any real difference when you include the extension). But additional rules can be added to give finer control over when something is lit or not. For example, if your game includes a "frotz" spell, a can of phosphorescent paint, and a brass lantern which can be switched on or off, you could write the following rules:

	Special light calculation:
		if the light-calculation object is affected by frotz, rule succeeds.
	
	Special light calculation:
		if the light-calculation object is phosphor-coated, rule succeeds.
	
	Special light calculation for the brass lantern:
		if the lantern is switched on, rule succeeds;
		rule fails.

This has a great advantage over changing the lantern's "lit" property when these other properties change: you can add new ones with relative ease. Let's say you decide to add a supporter which prevents light from escaping it.

	Special light calculation for something on the Pedestal of Darkness:
		rule fails.

Now you don't need to worry about resetting the light property when the lantern is removed from the pedestal based on the other conditions: the rulebook takes care of all that for you.
