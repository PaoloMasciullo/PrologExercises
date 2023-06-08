% date due liste,
% se la lunghezza è la stessa:
% 	calcola il numero degli elementi uguali nella stessa posizione.
% se la lunghezza è diversa:
%	verifica se la lista più corta è compresa in quella più lunga.


% conto il numero di elementi uguali nella stessa posizione
countEqualPos([], [], 0).  % caso base con due liste vuote

countEqualPos([H|T1], [H|T2], Num):-  % caso in cui le teste sono uguali
    countEqualPos(T1, T2, Num2),
    Num is Num2 + 1, !.

countEqualPos([H1|T1], [H2|T2], Num):- % caso in cui le teste sono diverse
    not(H1 = H2),
    countEqualPos(T1, T2, Num).

% calcolo la lunghezza di una lista (conto gli elementi)
length2([], 0).  % caso base di una lista vuota con lunghezza 0

length2([_|T], Length):-
    length2(T, Length2),
    Length is Length2 + 1.

% controllo se le lunghezze delle due liste sono uguali
sameLength(L1, L2):-
    length2(L1, Len), 
    length2(L2, Len).

% concatenazione di due liste
conc([], L, L).

conc([H|T1], L2, [H|T3]):-
    conc(T1, L2, T3).

% date due liste, controllo se la prima è contenuta nella seconda
containedIn(Sublist, List) :-
    conc(_, Rest, List),
    conc(Sublist, _, Rest).

fun(L1, L2, Res):-  % caso in cui le liste hanno la stessa lunghezza
    sameLength(L1, L2),
    countEqualPos(L1, L2, Res), !.

fun(L1, L2, _):-  % caso in cui lista 1 è più corta di lista 2
    length2(L1, Len1),
    length2(L2, Len2),
    Len1 < Len2,
    containedIn(L1, L2), !.

fun(L1, L2, _):-  % caso in cui lista 2 è più corta di lista 1
    length2(L1, Len1),
    length2(L2, Len2),
    Len1 > Len2,
    containedIn(L2, L1), !.
