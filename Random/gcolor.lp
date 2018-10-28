node(a).
node(b).
node(c).
node(d).

edge(a,b).
edge(b,a).

edge(a,c).
edge(c,a).

edge(b,d).
edge(d,b).

edge(b,c).
edge(c,b).


c(X, red) :- node(X), not c(X, blue), not c(X, green).
c(X, blue) :- node(X), not c(X, red), not c(X, green).
c(X, green) :- node(X), not c(X, red), not c(X, blue).


:- edge(X, Y),c(X, C), c(Y, C).

?- c(a, A), c(b, B), c(c, C), c(d, D).