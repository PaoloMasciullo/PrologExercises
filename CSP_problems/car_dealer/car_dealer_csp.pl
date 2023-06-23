/*
 * CSP 5 - Concessionaria d'auto
Una concessionaria sta vendendo 7 auto a 4 potenziali acquirenti. Le auto presentano i seguenti costi:

a1 3000
a2 5000
a3 3500
a4 4000
a5 7000
a6 2700
a7 9000
Gli acquirenti in questione, dispongono dei seguenti budget di spesa:

marco 5000
paolo 16000
giuseppe 8000
francesco 12000
L'obiettivo è trovare una giusta assegnazione che consenta alla concessionaria di vendere tutte le auto, rispettando i seguenti vincoli:

c1: Nessun acquirente può spendere più del proprio budget
c2: Marco può comprare massimo un auto
c3: Paolo deve comprare più auto di francesco
c4: a3 ed a7 devono essere acquistate dallo stesso acquirente
c5: a1 non può essere acquistata da giuseppe
*/

template([a1/_, a2/_, a3/_, a4/_, a5/_, a6/_, a7/_]).

car(a1, 3000).
car(a2, 5000).
car(a3, 3500).
car(a4, 4000).
car(a5, 7000).
car(a6, 2700).
car(a7, 9000).

buyer(marco, 5000).
buyer(paolo, 16000).
buyer(giuseppe, 8000).
buyer(francesco, 12000).

domain(_, [marco, paolo, giuseppe, francesco]).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

search([]).
search([H|Other]):-
    search(Other),
    H = Car/Buyer,
    domain(Car, Domain),
    member2(Buyer, Domain),
    var_constraint(Car/Buyer, Other),
    global_constraint(Car/Buyer, Other).

csp(Solution):-
    template(Solution),
    search(Solution).

var_in_state(Var, [Var/Val|_], Val).
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).

% c1: Nessun acquirente può spendere più del proprio budget
sum_costs(_, [], 0):-!.
sum_costs(Buyer, [Car/Buyer|T], TotalCosts):-
    !,
    sum_costs(Buyer, T, Tmp),
    car(Car, Cost),
    TotalCosts is Tmp + Cost.
sum_costs(Buyer, [_|T], TotalCosts):-
    sum_costs(Buyer, T, TotalCosts).

c1(Buyer, State):-
    sum_costs(Buyer, State, Costs),
    buyer(Buyer, Budget),
    Budget >= Costs.

% c2: Marco può comprare massimo un auto
count_cars(_, [], 0):-!.
count_cars(Buyer, [_/Buyer|T], Count):-
    !,
    count_cars(Buyer, T, Tmp),
    Count is Tmp + 1.
count_cars(Buyer, [_|T], Count):-
    count_cars(Buyer, T, Count).

c2(Buyer, N, State):-
    count_cars(Buyer, State, Count),
    Count =< N.

% c3: Paolo deve comprare più auto di francesco
c3(Buyer1, Buyer2, State):-
    var_in_state(_, State, Buyer2), !,
    count_cars(Buyer1, State, Count1),
    count_cars(Buyer2, State, Count2),
    Count1 > Count2.
c3(_, _, _).

c3_(Buyer1, Buyer2, State):-
    var_in_state(_, State, Buyer2), !,
    count_cars(Buyer1, State, Count1),
    count_cars(Buyer2, State, Count2),
    Count1 < Count2.
c3_(_, _, _).

% c4: a3 ed a7 devono essere acquistate dallo stesso acquirente
c4(Buyer1, Car2, State):-
    var_in_state(Car2, State, Buyer2), !,
    Buyer1 == Buyer2.
c4(_, _, _).

% c5: a1 non può essere acquistata da giuseppe
c5(Buyer, Val):-
    Buyer \= Val.

% assegno i vincoli alle variabili
var_constraint(a1/Buyer, _):-
    !,
    c5(Buyer, giuseppe).
var_constraint(a3/Buyer, State):-
    !,
    c4(Buyer, a7, State).
var_constraint(a7/Buyer, State):-
    !,
    c4(Buyer, a3, State).
var_constraint(_/_, _).

% assegno i vincoli globali
global_constraint(Car/Buyer, State):-
    c1(Buyer, [Car/Buyer|State]),
    c2(marco, 1, [Car/Buyer|State]),
    c3(paolo, francesco, [Car/Buyer|State]).




