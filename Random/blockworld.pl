transform(State1, State2, Plan) :- transform(State1, State2, [State1], Plan).
transform(State, State, _Visited, []).
transform(State1, State2, Visited, [Action|Actions]) :-
                       choose_action(Action, State1, State2),
                       update(Action, State1, State),
                       \+ member(State, Visited),
                       transform(State, State2, [State|Visited], Actions).

update(to_block(X, Y, Z), State, State1) :-
             substitute(on(X, Y), on(X, Z), State, State1).

update(to_place(X, Y, Z), State, State1) :-
             substitute(on(X, Y), on(X, Z), State, State1).

substitute(_, _, [], []).
substitute(X, Y, [X|Xs], [Y|Ys]) :- substitute(X, Y, Xs, Ys).
substitute(X, Y, [Z|Xs], [Z|Ys]) :- X \= Z, substitute(X, Y, Xs, Ys).

choose_action(Action, State1, State2) :- suggest(Action, State2),
                                         legal_action(Action, State1).
choose_action(Action, State1, _State2) :- legal_action(Action, State1).

suggest(to_place(X, _Y, Z), State) :- member(on(X, Z), State), location(Z).
suggest(to_block(X, _Y, Z), State) :- member(on(X, Z), State), location(Z).

legal_action(to_place(Block, Y, Place), State) :-
                            on(Block, Y, State), clear(Block, State),
                            location(Place), clear(Place, State).

legal_action(to_block(Block1, Y, Block2), State) :-
                            on(Block1, Y, State), clear(Block1, State),
                            block(Block2), Block1 \= Block2, clear(Block2, State).

clear(X, State) :- \+ member(on(_A, X), State).
on(X, Y, State) :- member(on(X, Y), State).

%testing_data

block(a).
block(b).
block(c).
block(d).
block(e).

location(p).
location(q).
location(r).

test_plan(Name, Plan) :-
    initial_state(Name, I), final_state(Name, F), transform(I, F, Plan).

initial_state(test,[on(b, a), on(a, p), on(c, q),on(e, d), on(d, r)]).
final_state(test, [on(e, d), on(d, p), on(b, q), on(a, c), on(c, r)]).