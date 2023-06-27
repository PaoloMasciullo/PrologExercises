% date due liste A e B, restituire come output due liste C e D
% tali che:
% - C contenga gli elementi di A che appartengono anche a B
% - D contenga gli elementi di A che non appartengono a B

intersection([Ha|Ta], B, [Ha|Tc]):-  % elemento selezionato di A è anche in B
    member2(Ha, B), !,
    intersection(Ta, B, Tc).
intersection([_|Ta], B, C):-
    intersection(Ta, B, C).
intersection([], _, []).

member2(El, [El|_]):- !.
member2(El, [_|T]):-
    member2(El, T).

subtraction([Ha|Ta], B, C):-
    member2(Ha, B), !,
    subtraction(Ta, B, C).
subtraction([Ha|Ta], B, [Ha|Tc]):-
    subtraction(Ta, B, Tc).
subtraction([], _, []).

prd(A, B, C, D):-
    intersection(A, B, C),
    subtraction(A, B, D).

/* 
 * Query:
 * ?- prd([1, 2, 3, 4], [5, 6, 2, 3, 7], C, D).
 *
 * Result:
 * C = [2, 3],
 * D = [1, 4]
*/