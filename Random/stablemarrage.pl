/* solve([elazar, avraham, david, binyamin, chaim], [chana, tamar, zvia, ruth, sarah], X).*/


preferences(avraham, [chana, tamar, zvia, ruth, sarah]).
preferences(binyamin, [zvia, chana, ruth, sarah, tamar]).
preferences(chaim, [chana, ruth, tamar, sarah, zvia]).
preferences(david, [zvia, ruth, chana, sarah, tamar]).
preferences(elazar, [tamar, ruth, chana, zvia, sarah]).

preferences(zvia, [elazar, avraham, david, binyamin, chaim]).
preferences(chana, [david, elazar, binyamin, avraham, chaim]).
preferences(ruth, [avraham, david, binyamin, chaim, elazar]).
preferences(sarah, [chaim, binyamin, david, avraham, elazar]).
preferences(tamar, [david, binyamin, chaim, elazar, avraham]).


stable_m([], _, _).
stable_m([M|Ms], W, Mar):- stable_w(W, M, Mar), stable_m(Ms, W, Mar).

stable_w([], _, _).
stable_w([W|Ws], M, Mar):- not(unstable(M, W, Mar)), stable_w(Ws, M, Mar).


unstable(M, W, Mar):- mar(M, Wife, Mar), mar(H, W, Mar), pref(M, W, Wife), pref(W, M, H).
  
mar(M, W, Mar):- x(m(M, W), Mar, _).  

pref(X, Y, P):- preferences(X, Pref), x(Y, Pref, Oth), x(P, Oth, _).
  

x(X, [X|Ys], Ys) :- !.
x(X, [_|Ys], Zs) :- x(X, Ys, Zs).


get(X, [X|Ys], Ys).
get(X, [Y|Ys], [Y|Zs]) :- get(X, Ys, Zs).


solve(M, W, Mar):- solve1(M, W, Mar), stable_m(M, W, Mar).


solve1([], [], []).
solve1([M|Ms], Ws, [m(M,W)|Mar]):- get(W, Ws, Wx), solve1(Ms, Wx, Mar).

