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

destination_cost(barcellona, 1000).
destination_cost(hongkong, 2000).
destination_cost(roma, 500).
destination_cost(bali, 1500).
destination_cost(londra, 1000).
destination_cost(parigi, 1000).
destination_cost(montecarlo, 1500).
destination_cost(berlino, 800).
destination_cost(varsavia, 500).
destination_cost(rosamaria, 1000).
destination_cost(mykonos, 2000).
destination_cost(sardegna, 1500).
destination_cost(dublino, 1000).
destination_cost(newyork, 2000).

template([padre/_, madre/_, figlio/_, figlia/_]).

search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domain(Var, Domain),
    member2(Val, Domain),
    global_constraint(Var/Val, Other).

csp(Solution, TotalSatisfaction, TotalCost):-
    template(Solution),
    search(Solution),
    total_sat_idx(Solution, TotalSatisfaction),
    total_cost(Solution, TotalCost).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

number_var_assigned([], 0).
number_var_assigned([_|T], Count):-
    number_var_assigned(T, CountTail),
    Count is CountTail + 1.

sum_costs([], 0).
sum_costs([_/Dest|T], Sum):-
    sum_costs(T, SumTail),
    destination_cost(Dest, Cost),
    Sum is SumTail + Cost.

% spesa totale sia inferiore ai 2500 euro
total_cost(State, TotalCost):-
    number_var_assigned(State, 4),
    !,
    sum_costs(State, TotalCost).
total_cost(_, _).

% L'indice di soddisfazione finale della famiglia NON deve essere inferiore a 10 punti su 20 totali.
satisfaction_index(Destination, [Destination|_], 5):- !.
satisfaction_index(Destination, [_|T], Satisfaction):-
    satisfaction_index(Destination, T, Satisfaction2),
    Satisfaction is Satisfaction2 - 1.

total_sat_idx([], 0).
total_sat_idx([Var/Dest|T], TotSat):-
    total_sat_idx(T, TotSat2),
    domain(Var, Domain),
    satisfaction_index(Dest, Domain, Sat),
    TotSat is TotSat2 + Sat.

tot_sat_constraint(State, Limit):-
    number_var_assigned(State, 4),
    !,
    total_sat_idx(State, TotSat),
    TotSat >= Limit.
tot_sat_constraint(_, _).

% esattamente due elementi della famiglia viaggino insieme
count_dest(Destination, [_/Destination|T], Count):-
    count_dest(Destination, T, Count2),
    !,
    Count is Count2 + 1.
count_dest(Destination, [_/_|T], Count):-
    count_dest(Destination, T, Count).   
count_dest(_, [], 0).
                  
two_dest_equal([Var/Val|State]):-
    number_var_assigned([Var/Val|State], 4),
    !,
    count_dest(Val, State, 1).                  
two_dest_equal(_).                  

global_constraint(Var/Val, State):-
    total_cost([Var/Val|State], 2500),
    tot_sat_constraint([Var/Val|State], 10),
    two_dest_equal([Var/Val|State]).
