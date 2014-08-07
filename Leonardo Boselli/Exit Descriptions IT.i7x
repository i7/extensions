Version 2 of Exit Descriptions IT by Leonardo Boselli begins here.

"Basato sull'espansione Version 2 of Exit Descriptions by Matthew Fletcher."

"Appends a list of exit directions and names any previously visited rooms at the end of a room description."

The amount is a number variable.
The amount is 0.

The num is a number variable.
The num is 0.

After looking:
    Now the amount is the number of adjacent rooms;
    repeat with destination running through adjacent rooms begin;
        if the num is 0, say "Da [qui] [regarding the player][puoi] andare";
        let the way be the best route from the location to the destination, using even locked doors;
        if the way is a direction, say " a [way]";
        if the destination is visited, say " verso [the destination]";
        Decrease the amount by 1;
        Increase the num by 1;
        if the amount is 0, say ".";
        if the amount is 1, say " e";
        if the amount is greater than 1, say ",";
    end repeat;
    Now the amount is 0;
    Now the num is 0.

Exit Descriptions IT ends here.

---- DOCUMENTATION ----

Leggi la documentazione originale di Exit Descriptions di Matthew Fletcher.
