/*
Si consideri il seguente problema: si devono allocare 6 task t1, ..., t6 le cui durate sono rispettivamente 3,4,5,4,7,6 su due risorse m1 e m2.
• Ad ogni task è associata la risorsa su cui viene eseguito:
(t1, m2), (t2,m1), (t3,m2), (t4,m1), (t5,m1) (t6,m2).
• Su ogni risorsa può essere in esecuzione un solo task alla volta.
• Esistono dei vincoli di precedenza tra le seguenti coppie di task (t2,t4), (t1,t3), (t4,t5), (t1,t6), in cui il secondo task deve iniziare dopo o nello stesso istante in cui il primo finisce su una qualunque risorsa.
• Le risorse sono disponibili dall'istante 1. E' infine necessario che tutti i task terminino entro l'istante di tempo 16,
• Si modelli il problema come un problema di soddisfacimento di vincoli.
*/

task(t1,m2,3).
task(t2,m1,4).
task(t3,m2,5).
task(t4,m1,4).
task(t5,m1,7).
task(t6,m2,6).

template([t1/_, t2/_, t3/_, t4/_, t5/_, t6/_]).

domain(Task, Domain):-
    task(Task, _, Duration),
    Start = 1,
    End is 16 - Duration,
    define_domain(Start, End, Domain).

define_domain(End, End, [End]):-!.
define_domain(Start, End, [H|T]):-
    Start =< End,
    H = Start,
    NewStart is Start + 1,
    define_domain(NewStart, End, T).

member2(El, [El|_]).
member2(El, [_|T]):-
    member2(El, T).

var_in_state(Var, [Var/Val|_], Val):-!.
var_in_state(Var, [_|T], Val):-
    var_in_state(Var, T, Val).

search([]).
search([H|Other]):-
    search(Other),
    H = Task/Time,
    domain(Task, Domain),
    member2(Time, Domain),
    var_constraint(Task/Time, Other),
    global_constraint(Task/Time, Other).

csp(Solution):-
    template(Solution),
    search(Solution).

% Su ogni risorsa può essere in esecuzione un solo task alla volta
% controllo se il task che sto assegnando occupa una risorsa occupata da un task già assegnato,
% se vero, controllo che gli intervalli di tempo non si sovrappongano.

prd(_/_, []).
prd(Task1/Start1, [Task2/_|T]):-  % non risulta assegnato nessun task con la stessa risorsa
    task(Task1, Resource1, _),
    task(Task2, Resource2, _),
    Resource1 \= Resource2, !,
    prd(Task1/Start1, T).
prd(Task1/Start1, [Task2/Start2|T]):-
    task(Task1, Resource, Duration1),
    task(Task2, Resource, Duration2), !,
    End1 is Start1 + Duration1,
    End2 is Start2 + Duration2,
    (End1 =< Start2;
    Start1 >= End2), !,
    prd(Task1/Start1, T).
    
global_constraint(Task/StartTime, State):-
    prd(Task/StartTime, State).
 
 
% vincoli di precedenza tra coppie di task (t2,t4), (t1,t3), (t4,t5), (t1,t6), in cui il secondo task deve iniziare dopo o nello stesso istante in cui il primo finisce su una qualunque risorsa.

precedence(Start1, Task2, State):-
    var_in_state(Task2, State, Start2),
    !,
    Start1 =< Start2.
precedence(_, _, _).

var_constraint(t2/Start, State):-
    !,
    precedence(Start, t4, State).
var_constraint(t1/Start, State):-
    !,
    precedence(Start, t3, State),
    precedence(Start, t6, State).
var_constraint(t4/Start, State):-
    !,
    precedence(Start, t5, State).
var_constraint(_/_, _).
