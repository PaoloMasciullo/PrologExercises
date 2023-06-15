% Si scriva un programma Prolog che data in ingresso una lista di liste con 2 elementi ciascuna ed una costante c1
% restituisca in uscita due liste DX ed SX, la prima contenente gli elementi che nelle coppie compaiono a destra di c1, la seconda a sinistra.

% caso in cui la coppia sia formata da entrambi gli elementi uguali a c1
prd([[X,X]|T], X, [X|Tsx], [X|Tdx]):-
    !,
    prd(T, X, Tsx, Tdx).

% caso in cui la coppia contenga la costante c1 ed un elemento a sinistra di c1
prd([[El,X]|T], X, [El|Tsx], Dx):-
    !,
    prd(T, X, Tsx, Dx).

% caso in cui la coppia contenga la costante c1 ed un elemento a destra di c1
prd([[X,El]|T], X, Sx, [El|Tdx]):-
    !,
    prd(T, X, Sx, Tdx).

% caso in cui la coppia non contenga c1
prd([_|T], X, Sx, Dx):-
    prd(T, X, Sx, Dx).
    
prd([], _, [], []):- !.

/*
 * Query:
 * prd([[1, 2], [2, 4], [5, 6], [4, 3], [4, 4], [6, 4], [4, 9]], 4, Sx, Dx).
 * 
 * Result:
 * Dx = [3, 4, 9],
 * Sx = [2, 4, 6]
*/