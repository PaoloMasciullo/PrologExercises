template([cd1/_, cd2/_, cd3/_, cd4/_, cd5/_, cd6/_]).

old_positions([cd1/1, cd2/2, cd3/3, cd4/4, cd5/5, cd6/6]).
             
domain(_, [1, 2, 3, 4, 5, 6]).

search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domain(Var, Domain),
    member2(Val, Domain),
    var_constraint(Var/Val, Other),
    global_constraint(Var/Val, Other).

csp(Solution):-
    template(Solution),
    search(Solution).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

length_list([], 0).
length_list([_|T], Length):-
    length_list(T, Tmp),
    Length is Tmp + 1.

var_in_list(Var, [Var/Val|_], Val):- !.
var_in_list(Var, [_|T], Val):-
    var_in_list(Var, T, Val).

% variable constraints

is_odd_position(OldVal):-
    1 is mod(OldVal, 2).

new_position(Var/Val):-  % caso posizione dispari
    old_positions(OldPositions),
    var_in_list(Var, OldPositions, OldVal),
    is_odd_position(OldVal), !,
    Val > OldVal.
new_position(Var/Val):-  % caso posizione pari
    old_positions(OldPositions),
    var_in_list(Var, OldPositions, OldVal),
    not(is_odd_position(OldVal)), !,
    Val < OldVal.   

better_position(_/Val, Var2, State):-
    var_in_list(Var2, State, Val2),
    !,
    Val < Val2.
better_position(_/_, _, _).

worst_position(_/Val, Var2, State):-
    var_in_list(Var2, State, Val2),
    !,
    Val > Val2.
worst_position(_/_, _, _).

var_constraint(cd1/Val, State):-
    !,
    new_position(cd1/Val),
    better_position(cd1/Val, cd4, State),
    better_position(cd1/Val, cd6, State).
var_constraint(cd2/Val, _):-
    !,
    new_position(cd2/Val).
var_constraint(cd3/Val, State):-
    !,
    new_position(cd3/Val),
    worst_position(cd3/Val, cd6, State).
var_constraint(cd4/Val, State):-
    !,
    new_position(cd4/Val),
    worst_position(cd4/Val, cd1, State).
var_constraint(cd5/Val, _):-
    !,
    new_position(cd5/Val).
var_constraint(cd6/Val, State):-
    !,
    new_position(cd6/Val),
    better_position(cd6/Val, cd3, State),
    worst_position(cd6/Val, cd1, State).

var_constraint(_/_, _).

% global constraints
all_diff([]).
all_diff([_/Val|T]):-
    not(var_in_list(_, T, Val)),
    all_diff(T).

global_constraint(Var/Val, State):-
    all_diff([Var/Val|State]).