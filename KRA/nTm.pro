/**
*   nTm/6
*       Steps through the transitions until a state reached that matches a state in the HaltList
*       Reverses LeftOutput as it would be reversed in operation
*       Appends reversed LeftOutput to RightOutput and removes the blanks from Output 
*   @params:
*       MoveRight, MoveLeft, WriteList - Transtions that are stepped through
*       HaltList - The list of acceptable states that the Turing Machine will end at
*       Input - The input tape into the Turing Machine
*       Output - The tape after computation in the Machine
*/

nTm(MoveRight, MoveLeft, WriteList, HaltList, Input, Output) :-
    step([[], Input, q0], MoveRight, MoveLeft, WriteList, HaltList, LeftOutput, RightOutput),
    reverse(LeftOutput, ReversedLeft),
    append(ReversedLeft, RightOutput, OutputWithBlanks),
    clearLeadingBlanks(OutputWithBlanks, OutputWithBlanksAtEnd),
    reverse(OutputWithBlanksAtEnd, OutputWithBlanksAtStart),
    clearLeadingBlanks(OutputWithBlanksAtStart, ReversedOutput),
    reverse(ReversedOutput, Output).

/**
*   step/7
*       A recursive predicate that acts as one step of the Turing Machine computation
*       Given the current state and input it:
*           - Determines the action to perform 
*           - Changes the current state or writes to the Output tape
*       Recursion ends when the current state is equal to a state on the HaltList
*   @params
*       MoveRight, MoveLeft, WriteList, HaltList - same as above
*       Left - List on the left of current state
*       Symbol - Symbol on the input list at the current state
*       Right - List on the right of current state 
*/
step([Left, [Symbol|Right], State], MoveRight, MoveLeft, WriteList, HaltList, Left, [Symbol|Right]) :- member([State, Symbol], HaltList).
step([Left, [Symbol|Right], State], MoveRight, MoveLeft, WriteList, HaltList, LeftOutput, RightOutput) :-
    rule(State, Symbol, NewState, NewSymbol, MoveRight, MoveLeft, WriteList, Rule),
    move(Rule, Left, NewLeft, [Symbol|Right], NewRight, NewSymbol),
    step([NewLeft, NewRight, NewState], MoveRight, MoveLeft, WriteList, HaltList, LeftOutput, RightOutput).

/**
*   rule/8
*       Determines an acceptable rule to move to depending on the current state of the machine
*       Can move the machine left, right or write to tape using the transition lists
*   @params
*       MoveRight, MoveLeft, WriteList -  same as previous
*       State - current state of the machine
*       Symbol - current symbol on display on the machine
*       NewState - the new state that the machine will move to next
*       NewSymbol - The new symbol that will be written (if write operation)
*       left, right, write - the action to take in the move that follows the rule definition
*/
rule(State, Symbol, NewState, _, _, MoveLeft, _, left) :-
    member([State, Symbol, NewState], MoveLeft).
rule(State, Symbol, NewState, NewSymbol, _, _, WriteList, write) :-
    member([State, Symbol, NewSymbol, NewState], WriteList).
rule(State, Symbol, NewState, _, MoveRight, _, _, right) :-
    member([State, Symbol, NewState], MoveRight).

/**
*   move/6
*       Changes the current state or writes to tape depending on the rules 'left','right' or 'write'
*   @params
*       Left, Right - current contents of the tape to the left and right
*       NewLeft, NewRight - Updated contents of the tape to the left and right
*       OldSymbol - Symbol currently on tape
*       NewSymbol - Symbol to be written on tape (on write operation)  
*/
move(left, Left, NewLeft, Right, NewRight, _) :- leftMove(Left, NewLeft, Right, NewRight).
move(write, Left, Left, [OldSymbol|Right], [NewSymbol|Right], NewSymbol).
move(right, Left, NewLeft, Right, NewRight, _) :- rightMove(Left, NewLeft, Right, NewRight).


/**
*   leftMove/4, rightMove/4
*       Utility predicates for performing left and right move operations
*   @params
*       All Same as above
*       b-k - representation of blank space in turing machine
*/
leftMove([], [], Right, [b-k|Right]).
leftMove([Left|NewLeft], NewLeft, NewRight, [Left|NewRight]).

rightMove(Left, [Symbol|Left], [Symbol], b-k).
rightMove(Left, [Symbol|Left], [Symbol|NewRight], NewRight).

/**
*   clearLeadingBlanks/2
*       Utility predicate that is used to clear all leading blanks from the tape
*       (i.e. all blanks to left of a valid symbol)
*   @params
*       b-k - same as above
*       Tail - Remainder of tape that follows blank
*       Out - Output of the predicate
*/
clearLeadingBlanks([b-k|Tail], Out) :- clearLeadingBlanks(Tail, Out), !.
clearLeadingBlanks(Out, Out).
