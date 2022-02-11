member(X, [X|_]).
member(X, [_|L]) :- member(X,L).

arc([H|T],Node,Cost,KB) :- 
    member([H|B],KB), 
    append(B,T,Node),
    length(B,L), 
    Cost is 1+ L/(L+1).

heuristic(Node, H) :- length(Node, H).

goal([]).

lessThan([[Node1|_],Cost1],[[Node2|_],Cost2]) :-
    heuristic(Node1,Hvalue1), heuristic(Node2,Hvalue2),
    F1 is Cost1+Hvalue1, 
    F2 is Cost2+Hvalue2,
    F1 =< F2.

astar([Node,Path,Cost|_],[Node,Path],Cost,_) :- goal(Node).

astar([Node,P,C|Rest],Path,Cost,KB) :-
    findall([X,[Node|P],Sum],(arc(Node,X,Y,KB),Sum is Y+C), Children),
    add2Frontier(Children,Rest,Temp),
    minSort(Temp,[N1,P1,C1|T]),
    astar([N1,P1,C1|T],Path,Cost,KB).

add2Frontier(Children,Frontier,NewFrontier):-
    append(Children,Frontier,NewFrontier).

minSort([H|T],Result) :- sort(H,[],T,Result).
sort(H,S,[],[H|S]).
sort(H,S,[Head|T],Result) :-
    lessThan(H,Head), !,
    sort(H,[Head|S],T,Result),
    sort(Head,[H|S],T,Result).