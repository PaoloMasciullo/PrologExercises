% calcola la frequenza relativa (numero di occorrenze diviso numero totale)
% di una parola in una lista di parole.
% se lunghezza della lista maggiore di 100 o minore di 10,
% la frequenza relativa è 0.1

% conto numero di occorrenze della parola unificata da W nella lista
occurrences(_, [], 0).

occurrences(W, [W|T], C):-
    occurrences(W, T, C1),
    C is C1 + 1, !.

occurrences(W, [_|T], C):-
    occurrences(W, T, C), !.

% conto il numero totale di parole nella lista
total_words([], 0).

total_words([_|T], C):-
    total_words(T, C1),
    C is C1 + 1, !.

% caso in cui il numero di parole nella lista è < 10
frequency(_, List, F):-
    total_words(List, Total_w),
    Total_w < 10,
    F = 0.1, !.

% caso in cui il numero di parole nella lista è > 100
frequency(_, List, F):-
    total_words(List, Total_w),
    Total_w > 100,
    F = 0.1, !.

% calcolo la frequenza della parola unificata da W nella lista
frequency(W, List, F):-
    total_words(List, Total_w),
    occurrences(W, List, Occ),
    F is Occ/Total_w.