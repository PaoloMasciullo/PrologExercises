/*
Si scriva in Prolog un predicato listSplit(L, B, L1, L2) che, data la lista di interi L,
e il numero intero B, produca in uscita due liste L1 e L2 costituite rispettivamente dagli
elementi Y di L tali che Y<B in L1 e Y>=B in L2
*/

listSplit([], _, [], []):-!.
listSplit([H|T], B, [H|T1], L2):-
    H < B,
    !,
    listSplit(T, B, T1, L2).
listSplit([H|T], B, L1, [H|T2]):-
    listSplit(T, B, L1, T2).

/*
 * Query:
 * ?- listSplit([4, 2, 3, 6], 4, L1, L2).
 * 
 * Result:
 * L1 = [2, 3]
 * L2 = [4, 6]
*/