% data una lista di liste di interi calcolare la somma degli elementi per ogni lista
% e dia come risultato la somma minima

% minSumList([[1, 2, 3], [6, 7], [9, 1]], X).
% X = 6.

min([], _).

min([H|T], X):-
    X =< H,
    min(T, X).

findmin([], _).

findmin([H|T], H):-
    min(T, H).

findmin([H|T], Min):-
    not(min(T, H)),
    findmin(T, Min).

sum([], 0).

sum([H|T], Sum):-
    sum(T, Sum2),
    Sum is Sum2 + H.

sumList([], Ts):-
    Ts = [].

sumList([H|T], [Hs|Ts]):-
    sum(H, Hs),
    sumList(T, Ts).
	
minSumList([H|T], X):-
    sumList([H|T], SumList),
    findmin(SumList, X), !.