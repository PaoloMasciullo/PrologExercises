/*
Consider the 8 squares positioned as follows:
					s1 s2
                 s3 s4 s5 s6
                    s7 s8
The task is to label the boxes above with the numbers 1-8
such that the labels of any pair of adjacent squares
(i.e. horizontal, vertical or diagonal) differ by at least 2 (i.e. 2 or more).
*/

adjacents(s1, [s2, s3, s4, s5]).
adjacents(s2, [s1, s4, s5, s6]).
adjacents(s3, [s1, s4, s7]).
adjacents(s4, [s1, s2, s3, s5, s7, s8]).
adjacents(s5, [s1, s2, s4, s6, s7, s8]).
adjacents(s6, [s2, s5, s8]).
adjacents(s7, [s3, s4, s5, s8]).
adjacents(s8, [s4, s5, s6, s7]).

template([s1/_, s2/_, s3/_, s4/_, s5/_, s6/_, s7/_, s8/_]).

domain(_, [1, 2, 3, 4, 5, 6, 7, 8]).

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

% predicate for apply the search with backtracking
search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val, 
    domain(Var, Domain),
    member2(Val, Domain),
    var_constraint(Var/Val, Other),
    global_constraint([Var/Val|Other]).

csp(Solution):-
    template(Solution),
    search(Solution).

% built constraints
abs_diff(A, B, Result):-
    A > B,
    !,
    Result is A - B.
abs_diff(A, B, Result):-
    Result is B - A.

adjacent_constr(_, [], _).
adjacent_constr(Val, [Var2|T], State):-
    adjacent_constr_helper(Val, Var2, State),
    adjacent_constr(Val, T, State).

adjacent_constr_helper(Val, Var2, State):-
  var_in_state(Var2, State, Val2),
      !,
      abs_diff(Val, Val2, Diff),
      Diff >= 2.
adjacent_constr_helper(_, _, _).

all_diff([]).
all_diff([_/Val|T]):-
    not(var_in_state(_, T, Val)),
    all_diff(T).

var_constraint(s1/Val, State):-
    !,
    adjacents(s1, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s2/Val, State):-
    !,
    adjacents(s2, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s3/Val, State):-
    !,
    adjacents(s3, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s4/Val, State):-
    !,
    adjacents(s4, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s5/Val, State):-
    !,
    adjacents(s5, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s6/Val, State):-
    !,
    adjacents(s6, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s7/Val, State):-
    !,
    adjacents(s7, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(s8/Val, State):-
    !,
    adjacents(s8, Adjacents),
    adjacent_constr(Val, Adjacents, State).
var_constraint(_/_, _).
    
global_constraint(State):-
    length2(State, 8),
    !,
    all_diff(State).
global_constraint(_).
    