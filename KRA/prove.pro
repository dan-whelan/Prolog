prove([], KB).
prove(Node, KB) :-
    arc(Node, Next, KB),
    prove(Next, KB).

arc([H|T], Next, KB) :-
    member([H|B], KB),
    append(B,T,Next).