nTm(MR, ML, WL, HL, Input, Output) :-
	step([[], Input, q0], MR, ML, WL, HL, NewL, NewR),
	reverse(NewL, NewL1),
	append(NewL1, NewR, Out0),
	removeBlanks(Out0, Out1),
	reverse(Out1, ReversedOut0),
	removeBlanks(ReversedOut0, ReversedOut1),
	reverse(ReversedOut1, Output).

step([L, [Symbol|R], State], MR, ML, WL, HL, L, [Symbol|R]) :- member([State, Symbol], HL).
step([L, [Symbol|R], State], MR, ML, WL, HL, NewL, NewR) :-
	findRule(State, Symbol, NewState, NewSymbol, MR, ML, WL, Move),
	move(Move, L, Ls1, [Symbol|R], Rs1, NewSymbol),
	step([Ls1, Rs1, NewState], MR, ML, WL, HL, NewL, NewR).

move(left, L, NewL, R, NewR, _) :- left(L, NewL, R, NewR).
move(write, L, L, [OldSymbol|R], [NewSymbol|R], NewSymbol).
move(right, L, NewL, R, NewR, _) :- right(L, NewL, R, NewR).

left([], [], R, [b-k|R]).
left([L|Ls], Ls, NewR, [L|NewR]).

right(L, [Symbol|L], [Symbol], [b-k]).
right(L, [Symbol|L], [Symbol|NewR], NewR).

findRule(State, Symbol, NewState, NewSymbol, MR, ML, WL, Move) :-
	ruleR([State, Symbol, NewState], MR, Move);
	ruleL([State, Symbol, NewState], ML, Move);
	ruleW([State, Symbol, NewSymbol, NewState], WL, Move).

ruleR(Current, MR, right) :- member(Current, MR).
ruleL(Current, ML, left) :- member(Current, ML).
ruleW(Current, WL, write) :- member(Current, WL).

removeBlanks([b-k|Rest],Final) :-
	removeBlanks(Rest, Final), !.
removeBlanks(List, List).
