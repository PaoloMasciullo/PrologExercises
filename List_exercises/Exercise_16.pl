/* Si scriva in Prolog un predicato nuovaLista(L1, Start, End) che, dati due valori interi
 * Start e End, restituisca una lista L contenente i valori interi a partire da Start fino ad End.
 * Se Start > End restituisce una lista vuota.
*/

nuovaLista([H|T], Start, End):-
    Start =< End,
    H = Start,
    NewStart is Start + 1, !,
    nuovaLista(T, NewStart, End).
nuovaLista([], _, _).

/*
 * Query1:
 * ?- nuovaLista(L, 3, 6).
 * 
 * Result1:
 * L = [3, 4, 5, 6]
 * 
 * Query2:
 * ?- nuovaLista(L, 6, 3).
 * 
 * Result2:
 * L = []
 * 
 * Query3:
 * ?- nuovaLista(L, 6, 6).
 * 
 * Result3:
 * L = [6]
*/