:- use_module(library(clpfd)).

sudoku(Rows) :-
        length(Rows, 9), maplist(same_length(Rows), Rows),
        append(Rows, Vs), Vs ins 1..9,
        maplist(all_distinct, Rows),
        transpose(Rows, Columns), maplist(all_distinct, Columns),
        Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
        blocks(As, Bs, Cs), blocks(Ds, Es, Fs), blocks(Gs, Hs, Is).


blocks([], [], []).
blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
        all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
        blocks(Ns1, Ns2, Ns3).


f(_,[],[],_,_).
f(A,[[_|Xs]|Ys],[[A|Xc]|Yc],1,1) :- !,f(A,[Xs|Ys],[Xc|Yc],0,0).
f(A,[[X]|Xs],[[X]|Xc],0,0) :- f(A,Xs,Xc,0,0),!.
f(E,[[X|Xs]|Ys],[[X|Xs1]|Ys1],0,0) :- f(E,[Xs|Ys],[Xs1|Ys1],0,0).
f(E,[[X|Xs]|Ys],[[X|Xs1]|Ys1],N,1) :- N1 #= N-1, f(E,[Xs|Ys],[Xs1|Ys1],N1,1).
f(E,[Xs|Ys],[Xs|Ys1],N,M) :-  M1 #= M-1, f(E,Ys,Ys1,N,M1),!.


mod(X):-
    Rows=[[_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_]],
    f(3,Rows, Rows1, 2,6),
    f(8,Rows1, Rows2, 2,8),
    f(5,Rows2, Rows3, 2,9),
    f(1,Rows3, Rows4, 3,3),
    f(2,Rows4, Rows5, 3,5),
    f(5,Rows5, Rows6, 4,4),
    f(7,Rows6, Rows7, 4,6),
    f(4,Rows7, Rows8, 5,3),
    f(1,Rows8, Rows9, 5,7),
    f(9,Rows9, Rows10, 6,2),
    f(5,Rows10, Rows11, 7,1),
    f(2,Rows11, Rows12, 8,3),
    f(1,Rows12, Rows13, 8,5),
    f(4,Rows13, Rows14, 9,5),
    f(9,Rows14, X, 9,9).


solve(Rows):- mod(Rows), sudoku(Rows).
















