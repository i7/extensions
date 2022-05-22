Version 2.3 of Planner by Nate Cull begins here.

"A universal goal planner for self-directed NPCs."

Section - Definitions and Globals


Planning-token is a kind.

Planning-relation is a kind of planning-token.

Planning-action is a kind of planning-token.

No-action is a planning-action.
Success-action is a planning-action.

Planning-marker is a kind of planning-token.

No-plan is a planning-marker.
No-step is a planning-marker.
Plan-pending is a planning-marker.

No-object is a thing.

Table of Goals
Parent	Plan	Step	Token	Param1	Param2
0	0	0	no-plan	no-object	no-object
with 20 blank rows

The planning actor is a person that varies.

The requested relation is a planning-relation that varies.
The requested param1 is an object that varies.
The requested param2 is an object that varies.

The planned action is a planning-action that varies.
The planned param1 is an object that varies.
The planned param2 is an object that varies.

The desired plan is a number that varies.
The desired step is a number that varies.
The desired relation is a planning-relation that varies.
The desired param1 is an object that varies.
The desired param2 is an object that varies.

The suggested token is a planning-token that varies.
The suggested param1 is an object that varies.
The suggested param2 is an object that varies.

The working plan is a number that varies.
The working step is a number that varies.

Planner verbosity is a number that varies. Planner verbosity is 0.

The action success flag is a number that varies. 



Section - Main Routines

[This is the main entry point for calling Planner. It will find an action that satisfies the desired relation/object/object triad, and then attempt to execute that action.]

To have (A - a person) plan an action for (C - a planning-relation) with (P1 - an object) and (P2 - an object):
	if debugging planner, say "Planner: starting planning for [A].";
	if debugging planner, say "Planner: testing goal 1: [C] [P1] [P2]: [run paragraph on]";
	now the planning actor is A;
	now the requested relation is C;
	now the requested param1 is P1;
	now the requested param2 is P2;
	now the planned action is no-action;
	now the planned param1 is no-object;
	now the planned param2 is no-object;
	if goal C with P1 and P2 is true:
		now the planned action is success-action;
		if debugging planner, say "true, no work to do[line break]";
	otherwise:
		if debugging planner, say "false, generating plans [run paragraph on]";
		clear the goal table;
		choose row 1 in the Table of Goals;
		now the Token entry is the requested relation;
		now the Param1 entry is the requested param1;
		now the Param2 entry is the requested param2;
		now the Parent entry is 0;
		now the Plan entry is 0;
		now the Step entry is 0;
		expand goal 1;
		advance all goals;
	if debugging planner:
		if the planned action is no-action, say "Planner: no action chosen";
		otherwise say "Planner: choosing [the planned action] [the planned param1] [the planned param2]";
		say "[paragraph break]";
	execute the planned action;

[The core loop. Fill up the goal table line by line, reading goals as we come to them, considering each one, and if we can't satisfy it then spawning new subgoals and adding them to the end of the table. If we can fully satisfy a goal, then we end and return the action of that one as our chosen action.

My terminology is a little confusing as I sometimes use the words 'plan' and 'goal' apparently interchangeably. That's because of the way the data is stored. Let's have some definitions:

A Goal is a triad of Relation, Object, Object. (The Cat Is-on The Mat). It represents a piece of world state that we are actively trying to make true. Goals are related to one another in a tree structure. There is a top-level Goal which may have multiple child goals, and so on.

A Plan is a set of (Goal, Goal, Goal... Action). If every goal, evaluated in sequence from left to right, is true, then the actor should take the suggested Action.

So every Goal can have multiple Plans, and every Plan can have multiple Goals.

You'd think the best way to store this would be with a tree structure: Goals spawning Plans spawning Goals and so on. And you'd probably be right. But since we don't have dynamic memory allocation and can't easily do trees, we use a table instead. And each row of that table indicates *both* a Goal *and* a Plan, depending on context. Somewhat confusing. That is to say: 

* The top row indicates the top-level Goal.
* All new rows added to the table indicate separate Plans which are suggested as ways of satisfying outstanding Goals.
* We examine each Plan, checking each of its Goals, and eventually we either return an Action, or stop at a Goal which is blocking us. When that happens, we mark up the table row to now indicate a *Goal*, and continue on.

So as we go on, each line in the table that we've visited consists of a Goal. Lines that we've added but not yet visited indicate unevaluated Plans.

Each row has:
* Parent -the Goalrow which this is a plan or goal for
* Plan - the Plan number of the Parent goal which this is a plan for
* Step - (once we've turned from a Plan to a Goal) the Step number of this Plan at which we stopped evaluating because we found a not-currently-true Goal or an Action
* Token - either an Action or a Relation, or else a Marker (a kind of note-to-self used for internal communication between the Planner routines)
* Param1 - the first Object of the Action or Relation - only set once we have a Goal or Action
* Param2 - the second Object of the Action or Relation - only set once we have a Goal or Action

Adding new Plans for a Goal I have called Expanding. 
Scanning a Plan, checking each of its subgoals, I have called Advancing.

]

To advance all goals:
	repeat with G running from 2 to the number of filled rows in the Table of Goals begin;
		advance goal G;
		if an action was planned, now G is 9999;
	end repeat;



[Advancing a Goal: Here we're scanning through each item in the current plan, checking what we've got, and if it's a subgoal, testing if it's true or not. If it's false, then we check if it's unique (ie, not listed as one of our prior goals). This prevents endless recursive loops - we deal with each goal once and only once, regardless of how many parent goals need it. If it's an action, we return that as our choice - this means we pick the first action that we find, ie, the action with the smallest number of goal-expansion steps. This should generally mean we take the shortest path toward getting our way.

To read each Step, we call the 'planning' rulebook, passing the desired relation/object/object and the desired Plan and Step through the 'desired...' global variable block. We increment Step each time. We stop once we don't get a response from the rulebook. This means that plans need to use consecutive Step numbers starting from 1. The rulebook will be hit once for every Step, plus once for counting Steps, of every Plan, plus one more for counting Plans. So if a plan requires expensive calculations, it is a good idea to test that 'desired plan' is set to the plan number before you run the calculation, or you'll be running it lots of times and throwing the result away.

]

To advance goal (G - a number):
	choose row G in the Table of Goals;
	let our parent be the Parent entry;
	let our plan be the Plan entry;
	now the suggested token is the Token entry;
	now the suggested param1 is the Param1 entry;
	now the suggested param2 is the Param2 entry;
	choose row our parent in the Table of Goals;
	let our relation be the Token entry;
	let our param1 be the Param1 entry;
	let our param2 be the Param2 entry;
	let the final step be 0;
	if debugging planner, say "Planner: reading goal [G] (plan [our plan] for goal [our parent])[line break]";
	repeat with Sx running from 1 to 9 begin;
		suggest a goal for our relation with our param1 and our param2 for plan our plan at step Sx;
		if the suggested token is a planning-marker begin; 
			now Sx is 9999;
			choose row G in the Table of Goals;
			now the Token entry is no-plan;
			now the Param1 entry is no-object;
			now the Param2 entry is no-object;
		end if;
		if the suggested token is a planning-relation begin;
			if debugging planner, say "Planner: testing step [Sx]: [suggested token] [suggested param1] [suggested param2]: [run paragraph on]"; 
			if goal suggested token with suggested param1 and suggested param2 is false begin;
				if debugging planner, say "false ";
				if goal the suggested token with the suggested param1 and the suggested param2 is unique begin;
					if debugging planner, say "and unique, generating plans [run paragraph on]";
					choose row G in the Table of Goals;
					now the Token entry is the suggested token;
					now the Param1 entry is the suggested param1;	
					now the Param2 entry is the suggested param2;
					now the Step entry is Sx;
					now the final step is Sx;
					now Sx is 9999;
					expand goal G;						
				otherwise;
					if debugging planner, say "but duplicate, cancelling plan[line break]";
					choose row G in the Table of Goals;
					now the Token entry is no-plan;
					now the Param1 entry is no-object;	
					now the Param2 entry is no-object;
					now the Step entry is Sx;
					now the final step is Sx;
					now Sx is 9999;
				end if;
			otherwise;
				if debugging planner, say "true";
			end if;
		end if;
		if the suggested token is a planning-action begin;
			if debugging planner, say "Planner: testing step [Sx]: [the suggested token] [the suggested param1] [the suggested param2]: action[line break]";
			now the planned action is the suggested token;
			now the planned param1 is the suggested param1;
			now the planned param2 is the suggested param2;
			choose row G in the Table of Goals;
			now the Token entry is the suggested token;
			now the Param1 entry is the suggested param1;
			now the Param2 entry is the suggested param2;
			now the Step entry is Sx;
			now the final step is Sx;
			now Sx is 9999;
		end if; 
	end repeat;


[Expanding a Goal: Here we are just dropping new empty lines onto the goal table to indicate Plans we have yet to explore. About all the information we need is the Parent and Plan entries. The rest we will look up in the Parent row once we get there.]


To expand goal (G - a number):
	choose row G in the Table of Goals;
	let our relation be the Token entry;
	let our param1 be the Param1 entry;
	let our param2 be the Param2 entry;
	repeat with P running from 1 to 9 begin;
		suggest a goal for our relation with our param1 and our param2 for plan P at step 1;
		if the suggested token is no-plan begin;
			[we've run out of plans]
			now P is 9999;
		otherwise;
			[add new goal, checking for out of space]
			if the number of blank rows in the Table of Goals is greater than 0 begin;
				[add a new goal, as just a parent/plan/step entry]
				let the last row be the number of filled rows in the Table of Goals;
				increase the last row by 1;
				choose row the last row in the Table of Goals;
				now the Parent entry is G;
				now the Plan entry is P;
				now the Step entry is 1;
				now the Token entry is plan-pending;
				now the Param1 entry is no-object;
				now the Param2 entry is no-object;
				if debugging planner, say "[P] [run paragraph on]";
			otherwise;
				if debugging planner, say "Planner: goal table is full, ignoring new goal.";
			end if;
		end if;
	end repeat;
	if debugging planner, say "[line break]";




Section - Rulebooks


[This is where you put rules to generate plans. Sample rules for general situations are defined in 'Basic Plans'. You may need to use procedural rules to override basic rules with more specific ones for your game. IE, if there are particular objects that can only be obtained through solving a puzzle or manipulating a machine, you may need a specific plan for 'being-in' or 'being-touchable' for that object.]

Planning rules is a rulebook.


[This is where you put rules to test goals. Normally this would be a simple check against an I7 relation or property, and does not often need to be overridden.]

Planning-testing rules is a rulebook.


[This is where you put rules to execute actions. Normally this would be a simple call of 'try the planning actor trying <action>'. Then you would create 'report <actor> trying <action>' rules to have custom descriptions of what your particular actor is doing.]

Planning-acting rules is a rulebook.


[If the top-level goal tests as true, a 'success-action' action gets returned and this rulebook gets called. There is no more work for Planner to do, the actor has succeeded in their longest term goal. This might mean an actor needs to change their condition, or a scene change happens.]

Planning-success rules is a rulebook.


[If no action can be suggested toward the top-level goal, a 'no-action' action gets returned and this rulebook gets called. The actor is currently frustrated, blocked or baffled somehow. Generally this indicates that something the author didn't expect happened, and a new plan needs to be written to cover this situation.]

Planning-failure rules is a rulebook.


[If Planner returned an action, but when the actor tried to execute it (usually with 'trying...'), the I7 action failed. (Currently this condition happens if no 'Carry Out' rule ran.) This also generally indicates an incomplete set of plans, or an unexpected situation. ]

Planning-acting-failure rules is a rulebook.




Section - Planning Routines


To suggest a goal for (C - a planning-relation) with (P1 - an object) and (P2 - an object) for plan (P - a number) at step (Sx - a number):
	now the desired relation is C;
	now the desired param1 is P1;
	now the desired param2 is P2;
	now the desired plan is P;
	now the desired step is Sx;
	now the suggested token is no-plan;
	now the suggested param1 is no-object;
	now the suggested param2 is no-object;
	follow the planning rulebook;

To really suggest (T - a planning-token) with (P1 - an object) and (P2 - an object):
	now the suggested token is T;
	now the suggested param1 is P1;
	now the suggested param2 is P2;

To plan (P - a number):
	now the working plan is P;
	now the working step is 0;
	if the desired plan is the working plan, now the suggested token is no-step;

To suggest (T - a planning-token) with (P1 - an object) and (P2 - an object):
	increase the working step by 1;
	if the desired plan is the working plan and the desired step is the working step, really suggest T with P1 and P2;

To suggest (T - a planning-token) with (P1 - an object):
	suggest T with P1 and no-object;

To suggest (T - a planning-token):
	suggest T with no-object and no-object;




Section - Executing Actions

[Carry out someone trying doing something:
	now the action success flag is 1;]

The successful-action rule is listed after the check stage rule in the specific action-processing rules.

This is the successful-action rule: 
	if the actor is not the player, now the action success flag is 1.

To execute the planned action:
	if the planned action is no-action begin;
		follow the planning-failure rules;
	otherwise;
		if the planned action is success-action begin;
			follow the planning-success rules;
		otherwise;	
			now the action success flag is 0;
			follow the planning-acting rules;
			if the action success flag is 0, follow the planning-acting-failure rules;
		end if;
	end if;


Section - Utility Routines

		
To decide whether goal (C - a planning-relation) with (P1 - an object) and (P2 - an object) is unique:
	repeat through the Table of Goals begin;
		if the Token entry is C and the Param1 entry is P1 and the Param2 entry is P2, decide no;
	end repeat;
	decide yes;

To decide whether an action was planned:
	if the planned action is no-action, decide no;
	decide yes;

To decide whether a goal was suggested:
	if the suggested token is a planning-marker, decide no;
	decide yes;

To clear the goal table:
	repeat through the Table of Goals begin;
		blank out the whole row;
	end repeat;

To decide whether goal (C - a planning-relation) with (P1 - an object) and (P2 - an object) is true:
	now the desired relation is C;
	now the desired param1 is P1;
	now the desired param2 is P2;
	follow the planning-testing rules;
	if rule succeeded begin;
		decide yes;
	end if;
	decide no;

To decide whether goal (C - a planning-relation) with (P1 - an object) and (P2 - an object) is false:
	if goal C with P1 and P2 is true, decide no;
	decide yes;



Section - Debugging Verbs - Not for release

To decide if debugging planner:
	if planner verbosity is 1, decide yes;
	decide no;

Enabling the planner verbosity is an action out of world.
Understand "plans on" as enabling the planner verbosity.
Understand "plans" as enabling the planner verbosity.
Carry out enabling the planner verbosity:
	say "Planner will now show debugging messages. Type 'plans off' to run silently, or 'plans list' to show the current planning table.";
	now the planner verbosity is 1;

Disabling the planner verbosity is an action out of world.
Understand "plans off" as disabling the planner verbosity.
Carry out disabling the planner verbosity:
	say "Planner will now run silently.";
	now the planner verbosity is 0;

Dumping the planner table is an action out of world.
Understand "plans list" as dumping the planner table.
Carry out dumping the planner table:
	let G be 0;
	repeat through the Table of Goals begin;
		increase G by 1;
		say "Goal [G] (parent [the Parent entry] plan [the Plan entry] step [the Step entry]): [the Token entry] / [the Param1 entry] / [the Param2 entry][line break]";
	end repeat;

Planner ends here.

---- DOCUMENTATION ----

Section: Introduction

The short version: Planner is a stateless goal-planning engine for IF actors. It is an Inform 7 
reimplementation of the library formerly known as RAP (Reactive Agent Planner) for Inform 6 and TADS.

Note: A more full version of documentation with usage details is in the works. For now, look at the included demo game 'Alchemy' and at 'Basic Plans' to see how to use and define plans, relations and actions.

What is Planner, and why would you want one?

Planner gives your actors the ability to take charge of their own destiny and make their own way in the world. Instead of spelling out a series of actions in order, or responses to situations as they arise, you give the actor a goal to achieve, and - if it knows how - it chains together a series of actions that it thinks will make that goal happen. Then it takes the first step toward the goal. Then, next move, it does the whole thing again, starting from a blank slate, but hopefully one step closer to achieving its dream. This means that a Planner-guided actor can 
be both scripted *and* react to events that change the state of the world.

What kind of goals can Planner handle?

Literally anything. It's that powerful! Okay, a few qualifications. 

1) You have to be able to describe the goal as a yes/no question - 'am I in the lounge? Is the red ball in the blue box? Does Belboz have the Flubar spell memorised?' 

2) The goal has to be made up of only three parts: two objects and a relation between them (the cat, is-on, the mat). 

3) The relation has to have two things defined for it, using rules: 
   a) How to test if it's true or not
   b) One or more plans for making it come true, if it's not already.

4) It's in those plans that the real magic lies. You have to be able to write a fairly short, clear set of answers to the question 'given this goal that I want to achieve, what is the best next step toward that goal?' 

5) The 'next action to do' can have any number of subgoals attached to it, which Planner will attempt to make true in the order in which you give them. 'To have the rabbit, first: have the Flubar spell memorised. Next: have the hat. next: have the wand. finally: wave the wand.' If the actor doesn't have the spell, it will first make sure it does before even considering the rest of the goal. Then, if it has the spell, it will make sure it has the hat. And so on.

6) It's okay to have multiple ways of getting to a goal! Planner will explore all the options in parallel until it finds the first one that seems like it would work. And if it comes across a goal that it has already looked at, it won't add it twice. 

7) There are a few built-in relations that Planner knows how to handle (basic movement, possession and containment, locking and unlocking), and you can custom-write as many as you need for the special features of your story.

8) One of the most important limitations of Planner is that it has no memory between moves. This makes it react instantly to anything that changes, so it never gets sidetracked into trying to follow plans that are already out of date. But it won't know even what it was doing in the last move unless you track that yourself. It could get stuck in loops. For this reason it is important to give some thought to the exact sequence of goals in any given plan, and which ones it makes sense to do first. For example: if you're trying to get through a locked door, you probably want 
to find the key, and find the the door, and make sure the door is open. But you'll want to find the key *first*, otherwise you'll get stuck. 

9) Planner also assumes that it has access to perfect knowledge about everything in the world. This is because this is the simplest and least memory-consuming way to program it - it simply checks the 'real' story state rather than giving each actor its own model of the world. This is fine for modelling actors who are at home in an environment they know very well. But if you want your actors to make guesses and have false or imperfect knowledge, you'll need to find a way of storing that information and dealing with it yourself. There's a whole barrel of complications that that raises, the limitations of memory in the Z-machine only one of them. (Dealing sensibly with false information is also probably a problem that requires major artificial intelligence... but you're welcome to give it a go.)

10) Calculating a goal tree every move can be a very expensive process in terms of CPU usage (more so than memory - another reason Planner is written to recalculate everything on the fly rather than storing state between moves). The exact number of calculations Planner has to do each move will vary wildly depending on what goal it's trying to achieve, how big the story is, and just what kind of relations and plans for making them true have been programmed into the system.

So that's it. Planner lets you give IF actors their own mind - of a fairly mechanical, goal-focused, efficiency-driven sort. You may want to dress up their actions a bit, or use Planner only in the parts of your game where it makes sense. With Inform 7, you've got a lot of freedom to mix and match libraries and rules, so give it a go, explore the possibilities, and most importantly, have fun!

Section: Extension

How to extend Planner:

1. If you are defining a new relation type: 
   a) define a new 'planning-relation'
   b) create a 'planning-testing rule when the desired relation is <relation>'
  
2. If you are defining a new action type:
   a) define a new 'planning-action'
   b) create a 'planning-acting rule when the planned action is <action>'

3. If you are defining a new plan:

   a) create a 'planning rule when the planning actor is <actor> and the desired relation is <relation> and the desired param1 is <object> and the desired param2 is <object>' (and whatever other 'when' clauses you may need to narrow down the exact conditions under which this plan applies
   
   b) To avoid having to use a whole lot of 'if' statements to check the 'desired plan' and 'desired step', there are a couple of phrases you can use for shorthand.
   
    'plan 1;'  (this sets the current plan number for 'suggest')
    'suggest <token> with <object 1> and <object 2>;' (you can omit the 'with <object 1>...' and 'and <object 2>' if there is no sensible first or second parameter)
    
    And just continue with 'suggest...' lines until you're done.
    
    Each time you call 'suggest...' it will increment an internal step number, and compare this against 'desired step', ignoring the line for all the cases that don't match. This is a bit of a kludge but it's the simplest syntax I've come up with so far. 
    
    Be aware that rules may interact in unexpected ways unless you put an explicit 'rule succeeds' on the end of yours. Also, the 'Basic Plans' rules may take precedence over more specific rules you write unless you use a procedural rule to make them go away. This may change as I7's rule precedence ordering evolves.
    
    Check 'Basic Plans' and the demo game 'Alchemy' to see examples of writing plans.

Section: Design Notes
	
Some notes on the design:

Planner (and its predecessor, RAP) was influenced by a paper [1] describing the architecture of the Carnegie Mellon University 'Oz' interactive storytelling system. I have never seen Oz running, but the paper described a goal-planning framework called Hap. Like the rest of Oz, it was built in Lisp, a dynamic language which is well-suited to building complicated data structures in memory and manipulating them efficiently. Interactive Fiction systems, however, tend to deal much better with static data and routines. There were also a few design decisions in Hap that I just plain didn't understand, so when I tried to build a planner myself, I simplified the design down to 
the point that I could at least fit it in my head. 

One feature of Hap, for instance, was that it appeared to store plans as sequences of actions to be carried out, but not dynamically recalculate them each move. I couldn't understand how that could work in a dynamic gameworld where no world state could be relied upon to remain constant from move to move, so I made mine only plan one action ahead at a time. Hap also had two types of plans: ones with goals to be satisfied sequentially (like Planner), but also ones where the goals could be satisfied in parallel. Again, I had no idea how such a thing could be implemented in a small machine or even what it would look like if it did. I suspect that parallel goal-solving would require vastly more complicated machinery to weigh up competing goals and avoid nasty causality loops. So I cut that out too. 

Finally, Hap appeared to have the ability to evaluate plans that had run and reward or punish them based on whether they seemed to work. Not only did that seem hard to implement, it also sounded like overkill for the IF environment, where generally the actors know more than the player does, and the author tends to lovingly hand-script everything anyway. And I just didn't understand how an AI actor could possibly evaluate highly specific plans without a sense of context - if I try to open a door and it fails, should I gather from that that the 'open door by turning doorknob' 
plan is wrong in all cases, or is it just this one door that's stuck? So I made the decision early on that RAP (as it was then) would not care at all about machine learning, or in fact any kind of feedback from the environment, but would simply and blissfully assume that The Author Knows Best and that every plan hard-coded into the actor's memory could be treated as the pure gold of Absolute Truth dripping from the heavens.

This is a huge assumption, but it made the problem manageable enough to fit both into an Interactive Fiction engine and into my bear-of-small-brain head, and at the same time. I recommend radical oversimplification for any other problems you may face in life.

(It may well be possible to layer some kind of feedback / learning / knowledge management layer over top of Planner's fairly stripped-down kernel. Or you might have better luck throwing it completely out and starting from scratch. Either way I suspect you will need a more powerful virtual machine than the Z-machine, and a language more meta-programmable than Inform 7, in order to start reinventing symbolic AI of the kind that was cutting edge in the 1970s. But the history of the Interactive Fiction community so far has been full of surprises, and the children of 
SHRDLU may yet surpass their elders. We've come a long way from Blocks World as it is.)

Section References

[1] "Hap: A Reactive, Adaptive Architecture for Agents". A. Bryan Loyall and Joseph Bates. Technical Report CMU-CS-91-147, School of Computer Science, Carnegie Mellon University, Pittsburgh, PA, June 1991. Downloadable postscript version available as of 2006-05-28 from http://www.cs.cmu.edu/afs/cs.cmu.edu/project/oz/web/papers.html

Section Changelog

Version 2/211124: bug fixes per Version 3/211124: Bug fixes per [Planner/Basic Plans, NPC actions are invisible IntFiction thread](https://intfiction.org/t/planner-basic-plans-npc-actions-are-invisible/10034/)

This extension differs from the author's original version. The latest version of this extension can be found at <https://github.com/i7/extensions>. 

This extension is released under the Creative Commons Attribution licence. Bug reports, feature requests or questions should be made at <https://github.com/i7/extensions/issues>.
