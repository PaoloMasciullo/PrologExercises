% scrivere un predicato list_to_set/2 che 
% data una lista di liste come primo argomento
% restituisca una lista nella quale sono state eliminate le liste ripetute
% e le loro permutazioni.

% predicato che dato un elemento e una lista, elimina la prima occorrenza di quell'elemento nella lista se presente,
% ritorna false se l'elemento non è presente nella lista
delete_el(El, [El|T], T):- !.
delete_el(El, [H|T], [H|T1]):-
    delete_el(El, T, T1).

% predicato che date due liste, elimina gli elementi della prima lista che sono presenti anche nella seconda,
% se alla fine della ricorsione la seconda lista è vuota, allora vuol dire che è una permutazione della prima
is_perm([], []).
is_perm([H|T], List):-
    delete_el(H, List, Result),
    is_perm(T, Result).

% helper che data una lista e una lista di liste, restituisce vero se nella lista di liste è presente almeno una permutazione della prima lista
list_to_set_helper(List, [H|_]):-
    is_perm(List, H), !.
list_to_set_helper(List, [_|T]):-
    list_to_set_helper(List, T).

list_to_set([], []).
list_to_set([H|T], Set):-
    list_to_set_helper(H, T),
    !,
    list_to_set(T, Set).
list_to_set([H|T], [H|Ts]):-
    list_to_set(T, Ts).

/* 
 * Query:
 * ?- list_to_set([[1, 2, 3], [1, 2, 3, 1], [2, 1, 3], [4, 5, 6], [7, 8, 9]], Set).
 *
 * Result:
 * Set = [[1, 2, 3, 1], [2, 1, 3], [4, 5, 6], [7, 8, 9]]
*/