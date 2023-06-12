% define the structure of the csp
template([t/_, q/_, nsw/_, v/_, sa/_, wa/_, nt/_]).

% define the domains of the variables
domain(_, [red, green, blue]).

% define membership rule
member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

% define the search rule
search([]).  % base case, when no variable has been assigned
search([H|Other]):-
    search(Other),
    H = Var/Color,
    domain(Var, Domain),  % retrieve the domain of Var
    member2(Color, Domain),  % check if the Value assigned to Var is in the its Domain
    % constraints
    var_constraint(Var/Color, Other).

% define the adjacency between the regions
adjacent(wa, [nt, sa]).
adjacent(nt, [sa, q, wa]).
adjacent(sa, [q, nsw, v, nt, wa]).
adjacent(nsw, [q, v, sa]).
adjacent(q, [nsw, nt, sa]).
adjacent(v, [nsw, sa]).
adjacent(t, []).

% check if the Var selected has been already assigned
var_in_state(Var/Val, [Var/Val|_]).
var_in_state(Var/Val, [_|T]):-
    var_in_state(Var/Val, T).

% two adjacent regions must have different colors
diff_colors(Var/Color, State):-
    adjacent(Var, AdjacentsList),
    not(same_adjacent_color(Color, AdjacentsList, State)).

% check if the color is assigned to some region in the list given in input (list of adjacent regions)
same_adjacent_color(Color, [Adjacent|_], State):-
    var_in_state(Adjacent/Color, State), !.
same_adjacent_color(Color, [_|T], State):-
    same_adjacent_color(Color, T, State).

% define the variable constraint
var_constraint(Var/Color, State):-
    !,
    diff_colors(Var/Color, State).
    
csp(Solution):-
    template(Solution),
    search(Solution).
