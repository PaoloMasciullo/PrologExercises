/*
 * Si scriva in Prolog: listaMeno(L, B, L1) che, data la lista di numeri interi L,
 * e il numero intero B, produca in uscita la lista L1 in cui
 * per ogni elemento Y di L è inserito in L1 un elemento Y1 che vale Y-B se B<Y
 * oppure B-Y se B>=Y
*/

listaMeno([], _, []).
listaMeno([H|T], B, [H1|T1]):-  % se B<H
    B<H, !,
    H1 is H - B,
    listaMeno(T, B, T1).
listaMeno([H|T], B, [H1|T1]):-  % se B>=H
    H1 is B - H,
    listaMeno(T, B, T1).

/*
 * Query:
 * ?- listaMeno([4, 2, 3, 7], 4, Z).
 * 
 * Result:
 * Z = [0, 2, 1, 3]
*/
