
write_elements([]).
write_elements([X|R]) :- write(X), write_elements(R).

snake(P,Cols,Rows) :- i(P,S1,S1), p(Rows,Cols,S1,S), c(S,odd).

i([],S,S).
i([A|R],[A|T],S) :- i(R,T,S).

p([],_,_,[]).
p([_|Rows],Cols,S1,[H|T]) :- sp(Cols,S1,S2,H), p(Rows,Cols,S2,T).

sp([],S,S,[]).
sp([_|R],[X|Y],S,[X|Z]) :- sp(R,Y,S,Z).


c([],_).
c([X|Xs],odd) :- write_elements(X), nl, c(Xs,even).
c([X|Xs],even) :- reverse(X,X1), write_elements(X1), nl, c(Xs,odd).