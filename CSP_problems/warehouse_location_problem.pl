/* WAREHOUSE LOCATION PROBLEM
 * there are 4 stores to supply in 4 fixed locations that are 
 * S1 : (2,1)
 * S2 : (4,5)
 * S3 : (6,3)
 * S4 : (8,7)
 * 
 * we have 3 possible warehouse to place in 6 possible positions that are
 *
 * W1 : (2,5)
 * W2 : (4,3)
 * W3 : (4,7)
 * W4 : (6,1)
 * W5 : (6,5)
 * W6 : (8,3)
 * 
 * The task is to assign at each store a warehouse and a warehouse can supply more than one store
 * 
 * Each warehouse has certain cost to supply each store related to the distance,
 * sum of the cost (ABSOLUTE DISTANCE) must be less than 12
 * 
 * Store 2 and 3 can't be supplied by the same warehouse
 * 
 * Store 1 must be supplied by a warehouse which supplies at least one other store
 */

template([s1/_, s2/_, s3/_, s4/_]).

domain(_, [w1, w2, w3, w4, w5, w6]). % coordinates X/Y

store(s1, 2/1).
store(s2, 4/5).
store(s3, 6/3).
store(s4, 8/7).

warehouse(w1, 2/5).
warehouse(w2, 4/3).
warehouse(w3, 4/7).
warehouse(w4, 6/1).
warehouse(w5, 6/5).
warehouse(w6, 8/3).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

% controlla se la variabile è già stata assegnata, se vero restituisce il suo valore
var_in_state(Var, [Var/Val|_], Val):-!.
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).

length2([], 0).
length2([_|T], Length):-
    length2(T, Tmp),
    Length is Tmp + 1.

search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domain(Var, Domain),
    member2(Val, Domain),
    variable_constraint(Var/Val, Other),
    global_constraint([Var/Val|Other]).

csp(Solution, Cost):-
    template(Solution),
    search(Solution),
    total_cost(Solution, Cost).

% sum of the cost (ABSOLUTE DISTANCE) must be less than 12

absolute_diff(X, Y, AbsDiff):-
    X < Y, !,
    AbsDiff is Y - X.
absolute_diff(X, Y, AbsDiff):-
    AbsDiff is X - Y.

cost(S, W, Cost):-
    warehouse(W, Xw/Yw),
    store(S, Xs/Ys),
    absolute_diff(Xw, Xs, X_diff),
    absolute_diff(Yw, Ys, Y_diff),
    Cost is X_diff + Y_diff.

total_cost([], 0).
total_cost([S/W|T], TotalCost):-
    total_cost(T, Tmp),
    cost(S, W, Cost),
    TotalCost is Tmp + Cost.

global_constraint(State):-
    length2(State, 4),
    !,
    total_cost(State, 12).
global_constraint(_).
% Store 2 and 3 can't be supplied by the same warehouse
different_values(W1, S2, State):-
    var_in_state(S2, State, W2),
    !,
    W1 \= W2.
different_values(_, _, _).
    
% Store 1 must be supplied by a warehouse which supplies at least one other store
supply_a_store(W, State):-
    var_in_state(_, State, W).
        
variable_constraint(s2/Val, State):-
    !,
    different_values(Val, s3, State).
variable_constraint(s1/Val, State):-
    !,
    supply_a_store(Val, State).
variable_constraint(_/_, _).
