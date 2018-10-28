
num(0).
num(1).
num(2).
num(3).
num(4).
num(5).
num(6).
num(7).
num(8).
num(9).

solve(L):- num(S), S>0, num(E), num(N), num(D),
			num(M), M>0, num(O), num(R), num(Y),
			1000*S+100*E+10*N+D+1000*M+100*O+10*R+E 
			=:= 10000*M+1000*O+100*N+10*E+Y,
			L = [D,E,M,N,O,R,S,Y], d(L).

d([]).
d([H|T]) :- not(member(H,T)),d(T).