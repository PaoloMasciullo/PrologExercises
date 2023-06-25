/*
The animals chosen are a LION, ANTELOPE, HYENA, EVIL LION, HORNBILL, MEERKAT, and BOAR.
They have given you the plans of the zoo layout.
									|c1||c2||c3||c4|
Each numbered area is a zoo enclosure. Multiple animals can go into the same enclosure, and not all enclosures have to be filled.
Each animal has restrictions about where it can be placed.
1. The LION and the EVIL LION hate each other, and do not want to be in the same enclosure.
2. The MEERKAT and BOAR are best friends, and have to be in the same enclosure.
3. The HYENA smells bad. Only the EVIL LION will share his enclosure.
4. The EVIL LION wants to eat the MEERKAT, BOAR, and HORNBILL.
5. The LION and the EVIL LION want to eat the ANTELOPE so badly that the ANTELOPE cannot be in either the same enclosure or in an enclosure adjacent to the LION or EVIL LION.
6. The LION annoys the HORNBILL, so the HORNBILL doesn't want to be in the LION's enclosure.
7. The LION is king, so he wants to be in enclosure 1.
*/

adjacent(c1, [c2]).
adjacent(c2, [c1, c3]).
adjacent(c3, [c2, c4]).
adjacent(c4, [c3]).

template([lion/_, antelope/_, hyena/_, evil_lion/_, hornbill/_, meerkat/_, boar/_]).

domain(_, [c1, c2, c3, c4]).

% utility predicates
member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

var_in_state(Var, [Var/Val|_], Val):-!.
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).

length2([], 0).
length2([_|T], L):-
    length2(T, Tmp),
    L is Tmp + 1.

% search predicate to do backtracking
search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val, 
    domain(Var, Domain),
    member2(Val, Domain),
    variable_constraint(Var/Val, Other).

csp(Solution):-
    template(Solution),
    search(Solution).

% define constraints:

different_enclosure(Val1, Var2, State):-
    var_in_state(Var2, State, Val2),
    !,
    Val1 \= Val2.
different_enclosure(_, _, _).

same_enclosure(Val1, Var2, State):-
    var_in_state(Var2, State, Val2),
    !,
    Val1 == Val2.
same_enclosure(_, _, _).

not_adjacent_enclosure(Val1, Var2, State):-
    var_in_state(Var2, State, Val2),
    !,
    adjacent(Val2, Adjacents),
    not(member2(Val1, Adjacents)).
not_adjacent_enclosure(_, _, _).

value_constraint(Val, Val).

variable_constraint(lion/Val, State):-
    !,
    different_enclosure(Val, evil_lion, State),
    different_enclosure(Val, antelope, State),
    not_adjacent_enclosure(Val, antelope, State),
    value_constraint(Val, c1).

variable_constraint(evil_lion/Val, State):-
    !,
    different_enclosure(Val, lion, State),
    same_enclosure(Val, hyena, State),
    different_enclosure(Val, meerkat, State),
    different_enclosure(Val, boar, State),
    different_enclosure(Val, hornbill, State),
    different_enclosure(Val, antelope, State),
    not_adjacent_enclosure(Val, meerkat, State),
    not_adjacent_enclosure(Val, boar, State),
    not_adjacent_enclosure(Val, hornbill, State),
    not_adjacent_enclosure(Val, antelope, State).

variable_constraint(meerkat/Val, State):-
    !,
    same_enclosure(Val, boar, State),
    different_enclosure(Val, evil_lion, State),
    not_adjacent_enclosure(Val, evil_lion, State).

variable_constraint(boar/Val, State):-
    !,
    same_enclosure(Val, meerkat, State),
    different_enclosure(Val, evil_lion, State),
    not_adjacent_enclosure(Val, evil_lion, State).

variable_constraint(hyena/Val, State):-
    !,
    same_enclosure(Val, evil_lion, State).

variable_constraint(hornbill/Val, State):-
    !,
    different_enclosure(Val, evil_lion, State),
    not_adjacent_enclosure(Val, evil_lion, State),
    different_enclosure(Val, lion, State).

variable_constraint(antelope/Val, State):-
    !,
    different_enclosure(Val, evil_lion, State),
    different_enclosure(Val, lion, State),
    not_adjacent_enclosure(Val, evil_lion, State),
    not_adjacent_enclosure(Val, lion, State).
variable_constraint(_/_, _).
