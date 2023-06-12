% Domains
% D(X) = [5, ..., 10]
% D(Y) = [2, ..., 15]
% D(Z) = [4, ..., 35]
% D(K) = [7, ..., 28]
% Constraits
% X<=Y
% Z>X
% K=Z

template([x/_, y/_, z/_, k/_]).

% domains
define_domain(End, End, [End|[]]).
define_domain(Start, End, [H|T]):-
    H = Start,
    Start2 is Start + 1,
    Start2 =< End,
    define_domain(Start2, End, T).

domain(x, Domain):-
    define_domain(5, 10, Domain).
domain(y, Domain):-
    define_domain(2, 15, Domain).
domain(z, Domain):-
    define_domain(4, 35, Domain).
domain(k, Domain):-
    define_domain(7, 28, Domain).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domain(Var, Domain),
    member2(Val, Domain),
    var_constraint(Var/Val, Other).

csp(Solution):-
    template(Solution),
    search(Solution).

var_in_state(Var, [Var/Val|_], Val).
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).
   
x_less_equal_y(x/Valx, State):-
    var_in_state(y, State, Valy), !,
    Valx =< Valy.
x_less_equal_y(_/_, _).

x_less_z(x/Valx, State):-
    var_in_state(z, State, Valz), !,
    Valz > Valx.
x_less_z(_/_, _).

y_greather_equal_x(y/Valy, State):-
    var_in_state(x, State, Valx), !,
    Valx =< Valy.
y_greather_equal_x(_/_, _).

z_greather_x(z/Valz, State):-
    var_in_state(x, State, Valx), !,
    Valz > Valx.
z_greather_x(_/_, _).

z_equal_k(z/Valz, State):-
    var_in_state(k, State, Valk), !,
    Valz =:= Valk.
z_equal_k(_/_, _).

k_equal_z(k/Valk, State):-
    var_in_state(z, State, Valz), !,
    Valz =:= Valk.
k_equal_z(_/_, _).

var_constraint(x/Val, State):-
    !,
    x_less_equal_y(x/Val, State),
    x_less_z(x/Val, State).

var_constraint(y/Val, State):-
    !,
    y_greather_equal_x(y/Val, State).
    
var_constraint(z/Val, State):-
    !,
    z_greather_x(z/Val, State),
    z_equal_k(z/Val, State).
    
var_constraint(k/Val, State):-
    !,
    k_equal_z(k/Val, State).

var_constraint(_/_, _).