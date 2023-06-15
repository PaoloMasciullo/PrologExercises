% Si definisca un predicato in PROLOG chiamato averStud che applicato a un numero di matricola di uno studente Matr
% e a una lista di esami LE dia come risultato la media AV dei suoi voti.
% Ogni esame sia rappresentato da un termine della lista LE della forma esame(Matr,Esame,Voto).

helper(Matr, [H|T], Sum, Count):-
    H = esame(Matr, _, Voto),
    helper(Matr, T, Sum2, Count2),
    Sum is Sum2 + Voto,
    Count is Count2 + 1.
helper(Matr, [_|T], Sum, Count):-
    helper(Matr, T, Sum, Count).
helper(_, [], 0, 0).

averStud(Matr, List, AV):-
    helper(Matr, List, Sum, Count), !,
    Count =\= 0,
    AV is Sum / Count.

/*
 * Query:
 * ?-averStud(s1,[esame(s2,f1,30), esame(s1,f1,27),esame(s3,f1,25), esame(s1,f2,30)], AV).
 * 
 * Result:
 * AV = 28.5
*/