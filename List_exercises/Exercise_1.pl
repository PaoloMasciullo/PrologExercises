% Data una lista di liste di interi 
% ritornare la lista degli elementi minimi di ogni lista

% controllo se X è minore di tutti gli elementi della lista
min([], _).
min([H|T], X):-
    X =< H,
    min(T, X).

% trovo il minimo in una lista
findmin([], _).

% caso in cui il primo elemento è il più piccolo
findmin([H|T], H):-
    min(T, H), !.

findmin([H|T], X):-
    not(min(T, H)),
    findmin(T, X), !.

% caso base con lista vuota
minlist([], Tm):-
    Tm = [].

minlist([H|T], [Hm|Tm]):-
    findmin(H, Hm),
    minlist(T, Tm).


/*
 * Query:
 * ?- minlist([[1, 2, 3], [6, 7], [9, 1]], X)
 *
 * Result:
 * X = [1, 6, 1]
*/