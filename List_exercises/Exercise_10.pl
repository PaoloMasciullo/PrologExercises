% Si scriva un predicato Prolog che data una lista ed un elemento El appartenente alla lista,
% restituisca in uscita il successore di El nella lista.

consec(El, [El, Succ|_], Succ):-!.
consec(El, [_|T], Succ):-
    consec(El, T, Succ).

/*
 * Query:
 * ?- consec(3, [1,7,3,9,11],X).
 * 
 * Solution:
 * X=9
*/