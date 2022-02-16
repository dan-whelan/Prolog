astar(Node,Path,Cost,KB) :-
    search([[Node,[],0]],RPath,Cost,KB),
    reverse(RPath,Path).

search([[Node,Path,Cost]|_],[Node|Path],Cost,_) :- goal(Node).
search([[Node,PastPath,PastCost]|Rest],TotPath,TotCost,KB) :-
    findall([X,[Node|PastPath],NewCost],(arc(Node,X,Cost,KB),NewCost is PastCost+Cost), Children),
    add2Frontier(Children,Rest,New),
    search(New,TotPath,TotCost,KB).
   
arc([H|T],Node,Cost,KB) :- 
    member([H|B],KB), 
    append(B,T,Node),
    length(B,L), 
    Cost is 1+L/(L+1).

heuristic(Node, H) :- length(Node, H).

goal([]).

lessThan([[Node1|_],Cost1],[[Node2|_],Cost2]) :-
    heuristic(Node1,Hvalue1), heuristic(Node2,Hvalue2),
    F1 is Cost1+Hvalue1, 
    F2 is Cost2+Hvalue2,
    F1 =< F2.

add2Frontier(Children,Frontier,NewFrontier):-
    append(Children,Frontier,Temp),
    minSort(Temp,NewFrontier).

minSort(UnSort,Sort) :- minSort(UnSort,[],Sort).
minSort([],Sort,Sort).
minSort([H|T],Sorted,Sort) :-
    insertionSort(H,Sorted,ToSort),
    minSort(T,ToSort,Sort).

insertionSort(X,[],[X]).
insertionSort(X,[H|T],[X,H|T]) :- lessThan(X,H).
insertionSort(X,[H|T],[H|T1]) :- \+lessThan(X,H), insertionSort(X,T,T1).