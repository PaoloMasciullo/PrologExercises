/*
 * variabili: A, B, C, D, E tutte con dominio [1, 2, 3, 4]
 * 
 * Vincoli:
 * 1. B \= 3
 * 2. C \= 2
 * 3. A \= B
 * 4. B \= C
 * 5. C < D
 * A = D
 * E < A, B, C, D
 * B \= D
*/

template([a/_, b/_, c/_, d/_, e/_]).

domains(_, [1, 2, 3, 4]).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domains(Var, Domain),
    member2(Val, Domain),
    variable_constraint(Var/Val, Other).

csp(Solution):-
    template(Solution),
    search(Solution).

var_in_state(Var, [Var/Val|_], Val):-!.
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).

different_val(_/Val, Val2):-
    Val =\= Val2.

different(_/Val1, Var2, State):-
    var_in_state(Var2, State, Val2), !,
    Val1 =\= Val2.
different(_/_, _, _).

equal(_/Val1, Var2, State):-
    var_in_state(Var2, State, Val2), !,
    Val1 == Val2.
equal(_/_, _, _).

less(_/Val1, Var2, State):-
    var_in_state(Var2, State, Val2), !,
    Val1 < Val2.
less(_/_, _, _).

greather(_/Val1, Var2, State):-
    var_in_state(Var2, State, Val2), !,
    Val1 > Val2.
greather(_/_, _, _).

variable_constraint(a/Val, State):-
    !,
    different(a/Val, b, State),
    equal(a/Val, d, State),
    greather(a/Val, e, State).

variable_constraint(b/Val, State):-
    !,
    different_val(b/Val, 3),
    different(b/Val, a, State),
    different(b/Val, c, State),
    different(b/Val, d, State),
    greather(b/Val, e, State).

variable_constraint(c/Val, State):-
    !,
    different_val(c/Val, 2),
    different(c/Val, b, State),
    less(c/Val, d, State),
    greather(c/Val, e, State).

variable_constraint(d/Val, State):-
    !,
    greather(d/Val, c, State),
    different(a/Val, b, State),
    equal(d/Val, a, State),
    greather(d/Val, e, State).

variable_constraint(e/Val, State):-
    !,
    less(e/Val, a, State),
    less(e/Val, b, State),
    less(e/Val, c, State),
    less(e/Val, d, State).
variable_constraint(_/_, _).
