Version 1 of Verbal Commands by Zed Lopez begins here.

"Provides a 'verbs' command to output known verbs, a 'conjugate' command to
demonstrate the conjugation of a given verb, and a 'meaning' command to
report what relationship it means. Whole extension is marked Not for Release.
For 6M62."

Use authorial modesty.

Include Verbs by Zed Lopez.

Volume 1 - Informational commands (Not for release)

The verb understood is a verb that varies.

Book 0 - Meaning command

Understand "meaning [text]" as meaning.

Meaning is an action out of world applying to one topic.
The meaning action has a verb called meaning-verb-understood.

Check meaning (this is the check meaning rule):
    let t be the substituted form of "[the topic understood]";
    now meaning-verb-understood is t as a verb;
    if meaning-verb-understood is the null verb, instead say "I don't know the meaning of [t].";

Carry out meaning (this is the carry out meaning rule):
    if meaning-verb-understood is meaningful begin;
      showme the meaning of meaning-verb-understood;
      say "";
    else;
      if "[verb meaning-verb-understood]" is "be", say "Relation of objects: equality relation.";
      else say "For saying only.";
    end if;

Book 1 - Verbs command

Part 1 - Understanding verbing

Understand "verbs" as verbing.
Understand the command "verb" as "verbs".

Part 2 - Verbing

All-verb-texts is a list of texts variable.
Verbing is an action out of world.

to decide what text is the infinitized (V - a verb) (this is infinitization):
    decide on "[infinitive of V]".

Carry out verbing (this is the carry out verbing rule):
  if all-verb-texts is empty begin;
    let l be infinitization applied to all-verbs;
    now all-verb-texts is l;
    sort all-verb-texts;
  end if;
    say "[all-verb-texts][line break]".

Book 2 - Conjugating

Part Rufus Xavier Sarsaparilla

Pronoun-list is initially { "I", "You", "She/he/it", "We", "You", "They" }.

Part Conjugational understandings

Understand "conjugate [text]" as conjugating.

Part Conjugating action

Conjugating is an action out of world applying to one topic.
The conjugating action has a verb called conjugating-verb-understood.

Chapter Check conjugating

Check conjugating (this is the check conjugating rule):
    let t be the substituted form of "[the topic understood]";
    now conjugating-verb-understood is t as a verb;
    if conjugating-verb-understood is the null verb, instead say "I don't know how to conjugate [t]";

Chapter Carry out conjugating

Section Maximizing

To decide what number is the larger of (N - number) and (M - number)
    (this is maximizing):
    if N > M, decide on N;
    decide on M. 

Section Know your place

To decide what number is the place for (N - a number) and (T - a grammatical tense):
    (- (({T}-1)*3 + {N}) -)

Section Carry Out Conjugating rule

To decide what text is the-verb-space of (T - a text):
  let c be character number 1 in T;
  if c is " " or c is "[']", decide on "";
  decide on " ".

Carry out conjugating (this is the carry out conjugating rule):
  let L be a list of texts;
  let lens be a list of numbers;
  let max-length be 0;
  repeat with g-num running through grammatical-numbers begin;
    if g-num is plural, now max-length is the maximizing reduction of lens;
    repeat with tense running through the grammatical tenses begin;
      let tense-text be "[tense]";
      if g-num is plural, say "[line break][tense-text in sentence case]:[line break]";
      repeat with g-person running from 1 to 3 begin;
        let the-viewpoint be the viewpoint corresponding to g-person and g-num;
        let n be the-viewpoint cast as a number;
        let p be entry n of pronoun-list;
        if g-num is singular begin;
           let c-v be the substituted form of "[adapt conjugating-verb-understood in tense from the-viewpoint]";
          let c-text be the substituted form of "   [p][the-verb-space of c-v][c-v]";
          add c-text to L;
          add the number of characters in c-text to lens;
         else;
           let entry_no be the place for g-person and tense;
           let c-v be the substituted form of "[adapt conjugating-verb-understood in tense from the-viewpoint]";
           say "[entry entry_no of L][(max-length - entry entry_no of lens) spaces]   [p][the-verb-space of c-v][c-v][line break]";
         end if;  
      end repeat;
    end repeat;
  end repeat;

Book 3 - Helper functions

Chapter 0 (For use without Central Typecasting by Zed Lopez)

To decide which K is the/a/an/-- (unknown - a value) cast as the/a/an/-- (name of kind of value K):
    (- {unknown} -).

Chapter 1 (For use without Grammar Tests by Zed Lopez)

Grammatical-number is a kind of value. The grammatical-numbers are singular and plural.

To decide what narrative viewpoint is the viewpoint corresponding to (N - a number) and (G - a grammatical-number):
    (- (({G}-1)*3 + {N}) -)

Chapter 2 (for use without Textile by Zed Lopez)

To say (N - a number) copies of (T - a text):
    repeat with i running from 1 to N begin;
      say T;
    end repeat.

To decide what text is (N - a number) spaces:
    let T be " ";
    decide on "[N copies of T]";

Verbal Commands ends here.

---- Documentation ----

Note that these verbs are what your game knows how to manipulate in adaptive text. They don't necessarily correspond to commands available to the player, to verbsb available to verb phrases to form sentences in your Inform 7 source, or to anything else!

Example: * Verbs

	*: "Verbs"
	
	Include Verbs by Zed Lopez.
	
	Lab is a room.
	
	[To bring is a verb. To get is a verb. To creep is a verb. To lay is a verb. lesnerize is a verb.]
	Test me with "verbs / conjugate bring / conjugate get / conjugate creep / conjugate lay / conjugate lesnerize".

Section but what about to lie, where it's lied if we're talking about a mistruth and lay if we're taking about lying down?

We do not talk about lie!


Verbs that mean properties just get: "meaning of meaning-verb-understood" = relation of objects:  relation
