nTm(MoveRight, MoveLeft, WriteList, HaltList, Input, Output) :-
    step([[], Input, q0], MoveRight, MoveLeft, WriteList, HaltList, LeftOutput, RightOutput),
    reverse(LeftOutput, ReversedLeft),
    append(ReversedLeft, RightOutput, OutputWithBlanks),
    clearLeadingBlanks(OutputWithBlanks, OutputWithBlanksAtEnd),
    reverse(OutputWithBlanksAtEnd, OutputWithBlanksAtStart),
    clearLeadingBlanks(OutputWithBlanksAtStart, ReversedOutput),
    reverse(ReversedOutput, Output).


step([Left, [Symbol|Right], State], MoveRight, MoveLeft, WriteList, HaltList, Left, [Symbol|Right]) :- member([State, Symbol], HaltList).
step([Left, [Symbol|Right], State], MoveRight, MoveLeft, WriteList, HaltList, LeftOutput, RightOutput) :-
    rule(State, Symbol, NewState, NewSymbol, MoveRight, MoveLeft, WriteList, Rule),
    move(Rule, Left, NewLeft, [Symbol|Right], NewRight, NewSymbol),
    step([NewLeft, NewRight, NewState], MoveRight, MoveLeft, WriteList, HaltList, LeftOutput, RightOutput).

rule(State, Symbol, NewState, _, _, MoveLeft, _, left) :-
    member([State, Symbol, NewState], MoveLeft).
rule(State, Symbol, NewState, NewSymbol, _, _, WriteList, write) :-
    member([State, Symbol, NewSymbol, NewState], WriteList).
rule(State, Symbol, NewState, _, MoveRight, _, _, right) :-
    member([State, Symbol, NewState], MoveRight).

move(left, Left, NewLeft, Right, NewRight, _) :- leftMove(Left, NewLeft, Right, NewRight).
move(write, Left, Left, [OldSymbol|Right], [NewSymbol|Right], NewSymbol).
move(right, Left, NewLeft, Right, NewRight, _) :- rightMove(Left, NewLeft, Right, NewRight).

leftMove([], [], Right, [b-k|Right]).
leftMove([Left|NewLeft], NewLeft, NewRight, [Left|NewRight]).

rightMove(Left, [Symbol|Left], [Symbol], b-k).
rightMove(Left, [Symbol|Left], [Symbol|NewRight], NewRight).

clearLeadingBlanks([b-k|Tail], Out) :- clearLeadingBlanks(Tail, Out), !.
clearLeadingBlanks(Out, Out).
