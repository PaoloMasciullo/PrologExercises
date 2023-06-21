% Scrivere un predicato flatten che “appiattisce” una lista di liste.

% concatena le due liste
concat([], List2, List2).
concat([H|T], List2, [H|To]):-
    concat(T, List2, To).

% controllo se l'argomento passato in input è una lista
is_list2(El):-
    El == [_|_].

flatten_helper([], Flattened, Flattened).  % alla fine, l'accumulatore sarà uguale alla lista appiattita

flatten_helper([[]|T], Acc, Flattened):-
    !,% rimuovo eventuali liste vuote nella lista
    flatten_helper(T, Acc, Flattened).

flatten_helper([H|T], Acc, Flattened):-
    is_list2(H), !,  % controllo se H è una lista, in quel caso concateno i suoi elementi ricorsivamente ad Acc
    flatten_helper(H, Acc, Acc2),
    flatten_helper(T, Acc2, Flattened).

flatten_helper([H|T], Acc, Flattened):-  % concateno tutti gli elementi della prima lista in Acc
    concat(Acc, [H], Acc2),
    flatten_helper(T, Acc2, Flattened).

flatten(List, Flattened):-
    flatten_helper(List, [], Flattened).  % la lista accumulatore inizialmente è vuota

/*
 * Query:
 * ?- flatten([1,a,[2,3],[],h,f(3),[c,[d,[e]]]],L).
 * 
 * Result:
 * L=[1,a,2,3,h,f(3),c,d,e]
*/