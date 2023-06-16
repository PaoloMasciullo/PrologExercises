% Scrivere un predicato Prolog per verificare se una lista è palindroma

append(El, [H|T], [Hr|Tr]):-
    append(El, T, Tr),
    Hr = H.
append(El, [], [El]).
    

reverse2([H|T], Reversed):-
    reverse2(T, Rest),
    append(H, Rest, Reversed).
reverse2([],[]):- !.    
    
palindrom(List):-
    reverse2(List, List), !.

/*
 * Query:
 * palindrom([a, n, n, a])
 * 
 * Result:
 * true
*/