% scrivere un predicato list_to_set/2 che 
% data una lista di liste come primo argomento
% restituisca una lista nella quale sono state eliminate le liste ripetute
% e le loro permutazioni.

is_member(El, [El|_]).

is_member(El, [_|T]):-
    is_member(El, T).

same_elements([], _).

same_elements([H|T], List):-
    is_member(H, List),
    same_elements(T, List).

is_permutation(List, [H|_]):-
    same_elements(List, H), !.

is_permutation(List, [_|T]):-
    is_permutation(List, T).

list_to_set([H|T], Set):-
    is_permutation(H, T), !,
    list_to_set(T, Set).

list_to_set([H|T], [H|Tr]):-
    list_to_set(T, Tr).

list_to_set([], []).

/* 
 * Query:
 * ?- list_to_set([[1, 2, 3], [1, 2, 3], [2, 1, 3], [4, 5, 6], [7, 8, 9]], Set).
 *
 * Result:
 * Set = [[2, 1, 3], [4, 5, 6], [7, 8, 9]]
*/