/*
 * Definire un programma Prolog checkLists(List1, N) in cui List1 è una lista di liste di valori interi
 * e che risulti vero se List1 contiene tutte liste che NON contengono il valore N.
 * checkLists risulta sempre vero se la lista List1 è vuota
*/

checkLists([], _).

checkLists([H|T], N):-
    checkListsHelper(H, N),
    checkLists(T, N).

checkListsHelper([], _).
checkListsHelper([H|T], N):-
    H =\= N,
    checkListsHelper(T, N).

/*
 * Query1:
 * ?- checkLists([[7, 4], [6], []], 3).
 * 
 * Result1:
 * true
 * 
 * Query2:
 * ?- checkLists([], 3).
 * 
 * Result2:
 * true
 * 
 * Query3:
 * ?- checkLists([[7, 4], [2], []], 2).
 * 
 * Result3:
 * false
*/