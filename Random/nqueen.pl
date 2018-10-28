

sol(N, Q) :- length(Q, N), b(Q, Y, 0, N, _, _), sol(Y, 0, Q).

b([], [], N, N, _, _).
b([_|Q], [Cx-Vx|Y], C1, N, [_|Vrow], Vcol) :- Cx is C1+1, functor(Vx, f, N),
	c(N, Vx, Vrow, Vcol), b(Q, Y, Cx, N, Vrow, [_|Vcol]).

c(0, _, _, _) :- !.
c(N, Row, [R|Rs], [C|Cs]) :- arg(N, Row, R-C), X is N-1, c(X, Row, Rs, Cs).

sol([], _, []).
sol([C|Cs], R1, [Cx|S]) :- Row is R1+1, select(Cx-Vx, [C|Cs], Y), arg(Row, Vx, Row-Row), 
							sol(Y, Row, S).