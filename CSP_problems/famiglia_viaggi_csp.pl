/*
Una famiglia di 4 individui (padre, madre, figlio, figlia) deve organizzare le proprie vacanze. La famiglia dispone di un budget totale di 2500€.
Ogni elemento della famiglia ha proposto le sue 5 mete preferite riportando il costo per persona ed ordinandole per preferenza (5 punti alla prima-> 1 punto all’ultima).
Le proposte sono le seguenti (meta, costo, la preferenza è sotto intesa nell’ordine in cui sono scritte):

#### PADRE:
- Barcellona 1000
- Hong Kong  2000
- Roma       500
- Bali       1500
- Londra     1000

#### MADRE:
- Parigi      1000
- Montecarlo  1500
- Berlino     800
- Roma        500
- Varsavia    500

#### FIGLIO:
- Rosamarina  1000
- Mykonos     2000
- Roma        500
- Sardegna    1500
- Barcellona  1000

#### Figlia:
- Londra      1000
- Dublino     1000
- New York    2000
- Mykonos     2000
- Parigi      1000

Assegna a ciascun elemento della famiglia una meta, facendo si che la spesa totale sia inferiore ai 2500 euro e che esattamente due elementi della famiglia viaggino insieme (la coppia può essere una qualsiasi tra le combinazioni possibili).
L'indice di soddisfazione finale della famiglia NON deve essere inferiore a 10 punti su 20 totali.
*/

domain(padre, [barcellona, hongkong, roma, bali, londra]).
domain(madre, [parigi, montecarlo, berlino, roma, varsavia]).
domain(figlio, [rosamaria, mykonos, roma, sardegna, barcellona]).
domain(figlia, [londra, dublino, newyork, mykonos, parigi]).

costs([barcellona/1000, hongkong/2000, roma/500, bali/1500, londra/1000,
       parigi/1000, montecarlo/1500, berlino/800, varsavia/500, rosamaria/1000,
       mykonos/2000, sardegna/1500, dublino/1000, newyork/2000]).

cost(Val, Cost):-
    costs(Costs),
    find_cost(Val, Costs, Cost).

find_cost(Val, [Val/Cost|_], Cost):-!.
find_cost(Val, [_|T], Cost):-
    find_cost(Val, T, Cost).

template([padre/_, madre/_, figlio/_, figlia/_]).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

length2([], 0).
length2([_|T], Length):-
    length2(T, Tmp),
    Length is Tmp + 1.

var_in_state(Var, [Var/Val|_], Val):-!.
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).

search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domain(Var, Domain),
    member2(Val, Domain),
    global_constraint([Var/Val|Other]).

csp(Solution, TotalCost, TotalSatIdx):-
    template(Solution),
    search(Solution),
    total_cost(Solution, TotalCost),
    total_sat_idx(Solution, TotalSatIdx).

% spesa totale sia inferiore ai 2500 euro
total_cost([], 0).
total_cost([_/Val|T], TotalCost):-
    total_cost(T, Tmp),
    cost(Val, Cost),
    TotalCost is Tmp + Cost.

%esattamente due elementi della famiglia viaggino insieme
list_to_set([], []).
list_to_set([_/Val|T], Set):-
    var_in_state(_, T, Val),
    !,
    list_to_set(T, Set).
list_to_set([Var/Val|T], [Var/Val|Ts]):-
    list_to_set(T, Ts).

two_el_together(State):-
    list_to_set(State, Set),
    length2(State, L1),
    length2(Set, L2),
    L2 is L1 - 1.

% L'indice di soddisfazione finale della famiglia NON deve essere inferiore a 10 punti
sat_idx(Val, [Val|_], 5):-!.
sat_idx(Val, [_|T], SatIdx):-
    sat_idx(Val, T, Tmp),
    SatIdx is Tmp - 1.

total_sat_idx([], 0).
total_sat_idx([Var/Val|T], TotSat):-
    total_sat_idx(T, Tmp),
    domain(Var, Domain),
    sat_idx(Val, Domain, SatIdx),
    TotSat is Tmp + SatIdx.

sat_constraint(State):-
    total_sat_idx(State, TotalSat),
    TotalSat >= 10.

global_constraint(State):-
    length2(State, 4),
    !,
    total_cost(State, 2500),
    two_el_together(State),
    sat_constraint(State).
global_constraint(_).
