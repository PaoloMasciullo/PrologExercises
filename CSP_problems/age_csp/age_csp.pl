% owns(child(Var1), dog(Var2)) says that Var 1 is a child, Var 2 is a dog, and Var 1 is the owner of Var2
owns(child(alice), dog(rococò)).
owns(child(barbara), dog(sibilo)).
owns(child(carla), dog(tocco)).
owns(child(daria), dog(uguccione)).

% dog(dog(Var1), child(Var2)) says that Var2 is a child and Var 1 is the dog of Var1
dog_of(dog(rococò), child(alice)).
dog_of(dog(sibilo), child(barbara)).
dog_of(dog(tocco), child(carla)).
dog_of(dog(uguccione), child(daria)).

% rule that define the structure of the csp. Var/Value is a tuple
template([alice/_, barbara/_, carla/_, daria/_, rococò/_,
           sibilo/_, tocco/_, uguccione/_]).

% define the domain of each variable, in this case all the variables have the same domain
domain(_, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).

% rule that, given a template, apply the search rule in order to find a solution
csp(Solution):-
    template(Solution),
    search(Solution).

% rule that assigns each variable recursively so that, using backtracking behaviour of Prolog, it can
% first assign a variable,
% then check whether the assignment satisfies all active constraints on that variable,
% if so, assign the next variable, otherwise go back and try another assignment.
search([]).
search([H|Other]):-
    search(Other),
    H = Var/Val,
    domain(Var, Domain),
    member2(Val, Domain),
    variable_constraint(Var/Val, Other).

% checks if the element (first input argument) is present in the list (second input argument)
member2(H, [H|_]).
member2(El, [_|T]):-
    member2(El, T).

% constraint which imposes that alice must have the same age of the dog of barbara
same_age(alice/Age1, barbara, State):-
    owns(child(barbara), dog(BarbaraDog)),
    var_in_state(BarbaraDog/Age2, State, Age2), !,
    Age1 = Age2.
same_age(_/_, _, _).

% constraint on the age of each children w.r.t. the age of its dog
double_age(Child/AgeChild, State):-
    owns(child(Child), dog(Dog)),
    var_in_state(Dog/AgeDog, State, AgeDog), !,
    AgeChild is AgeDog * 2.
double_age(_/_, _).

% rule that imposes the constraints on the variables
variable_constraint(alice/Age, State):-
    !,
    same_age(alice/Age, barbara, State),
    double_age(alice/Age, State).
variable_constraint(Var/Age, State):-
    !,
    double_age(Var/Age, State).
variable_constraint(_/_, _).

% rule that checks if a variable is already assigned
var_in_state(Var/Value, [Var/Value|_], Value):- !.
var_in_state(Var/Value, [_|T], Value):-
    var_in_state(Var/Value, T, Value).
    