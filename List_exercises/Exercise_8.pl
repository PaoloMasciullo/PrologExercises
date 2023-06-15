% Data una lista L1 e un numero intero N, scrivere un predicato Prolog prd(L1,N,L2)
% che restituisca in L2 la lista degli elementi di L1 che sono liste contenenti solo due valori interi positivi fra 1 e 9 la cui somma valga N.

length_list([], 0).
length_list([_|T], Length):-
    length_list(T, LengthTail),
    Length is LengthTail + 1.

all_between_ab([H|T], A, B):-
    all_between_ab(T, A, B),
    H >= A,
    H =< B, !.
all_between_ab([], _, _).

sum_list([], 0).
sum_list([H|T], Sum):-
    sum_list(T, SumTail),
    Sum is SumTail + H.

constraints(List, N):-
    length_list(List, 2),
    all_between_ab(List, 1, 9),
    sum_list(List, N).

prd([H|T1], N, [H|T2]):-
    constraints(H, N), !,
    prd(T1, N, T2).
prd([_|T1], N, L2):-
    prd(T1, N, L2).
prd([], _, []).

/*
 * Query:
 * ?- prd([[3,1],5,[2,1,1],[3],[1,1,1],a,[2,2]],4,L2).
 * 
 * Result:
 * L2 = [[3,1], [2,2]]
*/