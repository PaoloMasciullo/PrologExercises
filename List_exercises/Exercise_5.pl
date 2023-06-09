% data una lista di elementi e un numero intero N,
% restituire il prefisso di lunghezza N (primi N elementi)
% Successivamente eliminare i duplicati dal prefisso

% prd([1, 1, 2, 3], 3, O).
% O = [1, 2]

% concatenate(L1, L2, L3) concatena L1 e L2 formando L3 
concatenate([], [], []).  % concatenazione tra liste vuote è una lista vuota

concatenate([], L, L).

concatenate([H|T1], L2, [H|T3]):-
    concatenate(T1, L2, T3).

% prefix/3 estrae un prefisso di lunghezza N da L2
prefix(L2, N, L1):-  % L1 è un prefisso di lunghezza N di L2
    concatenate(L1, _, L2), % impongo che la lunghezza di L1 sia N
    length_list(L1, Length),
    Length =:= N.

% length_list/2 calcola la lunghezza di una lista
length_list([], 0).

length_list([_|T], Length):-
    length_list(T, TailLength),
    Length is TailLength + 1.

% member/2 controlla se El fa parte della lista
member(El, [El|_]).

member(El, [_|T]):-
    member(El,T).

% remove_duplicates/2 rimuove i duplicati dalla lista
remove_duplicates([], _).  % caso di una lista vuota

remove_duplicates([H|T], [H, _]):-
    not(member(H, T)).

remove_duplicates([H|T], T):-
    member(H, T).

prd(L2, N, L1):-
    prefix(L2, N, Temp),
    remove_duplicates(Temp, L1).

/*
 * Query:
 * ?- prd([1, 1, 2, 3], 3, O).
 * 
 * Result:
 * O = [1, 2]
*/
