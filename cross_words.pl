% word/3
word(o, s, o).

% word/4
word(c, i, a, o).
word(i, n ,n, i).

% word/5
word(a, g, e, n, t).
word(z, a, i, n, o).
word(p, u, l, s, a).
word(s, a, l, v, ò).

% word/6
word(a, r, m, a, t, a).
word(p, r, o, l, o, g).

% word/7
word(s, t, r, e, g, u, e).

% word/8
word(c, i, a, b, a, t, t, a).

% word/9
word(p, a, p, e, r, e, l, l, a).
word(r, u, z, z, o, l, a, t, i).

% fare attenzione, le clause con la stessa arity devono essere raggruppate

solution(L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16, L17, L18, L19, L20, L21, L22, L23, L24, L25, L26, L27, L28, L29) :-
    word(L1, L2, L3, L4, L5, L6),  % W1
	word(L7, L5, L8, L9, L10, L11, L12),  % W2
    word(L13, L11, L14, L15, L16, L17, L18, L19, L20),  % W3
    word(L21, L22, L17, L23, L24),  % W4
    word(L25, L21, L26),  % W5
    word(L20, L27, L28, L29).  % W6