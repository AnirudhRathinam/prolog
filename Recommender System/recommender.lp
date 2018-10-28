
/* -------------------------------- DATABASE INFO -------------------------------- */

% data fields - person table

/*
sex: sex of person
lives: current residence
born: ethnicity
bday: year of birth
partner: spouse (if any)
children: children (if any)
likes: interests of person
*/


% data fields - item table

/*
type: Item Category
target_eth: Ethnicity item is targeted towards
target_age: Age group item is targeted towards
c_item: Other items that compliment this item
r_eth: Ethnicities that may not be interested in product
r_age: Age groups that may not be interested in product
t_sex: Sex that the item is targeted towards
r_sex: Sex that may not be interested in the product
reject: Product is unavailable where person lives hence reject recommendation
allages: Is the item suitable for children
*/


/* -------------------------------- HELPER FUNCTIONS  -------------------------------- */

%append list

append(X,X).
append([],X,X).                            
append([X|Y],Z,[X|W]) :- append(Y,Z,W).    

%flatten list

flatten([],[]).
flatten([H|T],R):-append(H,R1), flatten(T,R2), append(R1,R2,R).


%search list for element return 1 if present

is_element(X,[X],1).
is_element(X,[X|T],1).
is_element(X,[],0).
is_element(X,[H|T],Y):-is_element(X,T,Y).

%search 2 lists for a common element return 1 if present

l_com1([],[],0).
l_com1(L,[],0).
l_com1([],L,0).
l_com1([H|T],L,X):-is_element(H,L,V1),l_com1(T,L,V2), X is V1+V2.

l_com(L1,L2,1):- l_com1(L1,L2,Y), Y>0.
l_com(L1,L2,0):- l_com1(L1,L2,Y), Y =<0.


%clear blanks from a list

removeAll(_, [], []).
removeAll(X, [X|T], L):- removeAll(X, T, L).
removeAll(X, [H|T], [H|L]):- removeAll(X, T, L ).

%See if person is adult, senior citizen or child: get_cat(Person, Category)

get_age(P,B,senior):- 2018-B>60.
get_age(P,B,adult):- 2018-B>=18.
get_age(P,B,child):- 2018-B<18.
get_cat(P,A):- bday(P,B), get_age(P,B,A).

%Get list of age categories from list of people: age_list(Person_List, Age_category_list)

age_list([],[]).
age_list([H|T],[X|Y]):-get_cat(H,X),age_list(T,Y).

%Get list of ethnicity from list of people

eth_list([],[]).
eth_list([A|T1],[B|T2]):- born(A,B), eth_list(T1,T2).
eth(X,L):- eth_list(X,R),flatten(R,L).

%Get list of sex from list of people

sex_list([],[]).
sex_list([H|T],[X|Y]):- sex(H,X), sex_list(T,Y).

%get list of parents of a person

getmother(X,M):- sex(M,female), children(M,C), is_element(X,C,1).
getmother(X,[]):- sex(M,female), children(M,C), is_element(X,C,0).
getfather(X,F):- sex(F,male), children(F,C), is_element(X,C,1).
getfather(X,[]).
get_p(X,[M,F]):- getmother(X,M),getfather(X,F).
parents(X,L):- get_p(X,L1), removeAll([],L1,L).


%get list of likes from list of people

likeslist([],[]).
likeslist([A|T1],[B|T2]):- likes(A,B),likeslist(T1,T2).
lol(L1,L2):- likeslist(L1,L3), flatten(L3,L2).

%convert likes to categories

int([],[]).
int([kitchen101], [cooking]).
int([comp101], [electronics]).
int([toys101], [toys]).
int([H|T], [X|Y]):- int([H],[X]), int(T,Y).

%get list of categories people are interested in from list of people

interests(People,Interests):- lol(People,Likes), int(Likes, Interests).

%age checker return 1 if child and product is age restricted

agecheck(child,false,1).
agecheck(child,true,0).
agecheck(adult,_,0).
agecheck(senior,_,0).

%compares values If x is 0 return 0 else return 1

checkb(X,1):- X > 0.
checkb(X,0):- X =< 0.

/* -------------------------------- RULES -------------------------------- */
% Categories are:
%
% 1. Product Personal: Does product match/clash with person attributes
% 2. Product Family: Does product match/clash with child/partner/parent
% 3. Interests: Personal interests, Family members interests
% 4. Rejects: Based on age and location
% 5. Other: Rules to assist in evaluating weights
% 6. Weights: Rules that assign weights
/* ----------------------------------------------------------------------- */

/* -------------------------------- PRODUCT PERSONAL -------------------------------- */

/* -------------------------------- MATCH -------------------------------- */

%rule 1: does persons age match product
r_1(Person,Product,X):- get_cat(Person,C), target_age(Product,T),
						is_element(C,T,X).

%rule 2: does persons ethnicity match product
r_2(Person,Product,X):- born(Person,E), target_eth(Product,T),
						l_com(E,T,X).

%rule 3: does persons sex match product
r_3(Person,Product,X):- sex(Person,S), t_sex(Product,T),
						is_element(S,T,X).

%rule 4: does persons living area match with target ethnicity
r_4(Person,Product,X):- lives(Person,L), target_eth(Product,T),
						is_element(L,T,X).


/* -------------------------------- CLASH -------------------------------- */

%rule 5: does persons age clash with product
r_5(Person, Product,X):- get_cat(Person,C), r_age(Product, T),
						is_element(C,T,X).

%rule 6: does persons ethnicity clash with product
r_6(Person, Product,X):- born(Person,E), r_eth(Product,T),
						l_com(E,T,X).

%rule 7: does persons sex clash with product
r_7(Person, Product,X):- sex(Person,S), r_sex(Product,T),
						is_element(S,T,X).


/* -------------------------------- PRODUCT FAMILY -------------------------------- */

/* -------------------------------- CHILDREN -------------------------------- */

%rule 8: Does person have child which matches products target age
r_8(Person, Product,X):- children(Person,C), target_age(Product,T),
						age_list(C,L), l_com(L,T,X).

%rule 9: Does person have child which matches products target ethnicity
r_9(Person, Product,X):- children(Person,C), target_eth(Product,T),
						eth(C,L), l_com(L,T,X).

%rule 10: Does person have child which matches products target sex 
r_10(Person, Product,X):- children(Person,C), t_sex(Product,T),
						sex_list(C,L), l_com(L,T,X).


/* -------------------------------- PARTNER -------------------------------- */

%rule 11: Does person have partner which matches products target age
r_11(Person, Product,X):- partner(Person,C), target_age(Product,T),
						age_list(C,L), l_com(L,T,X).

%rule 12: Does person have partner which matches products target ethnicity
r_12(Person, Product,X):- partner(Person,C), target_eth(Product,T),
						eth(C,L), l_com(L,T,X).

%rule 13: Does person have partner which matches products target sex
r_13(Person, Product,X):- partner(Person,C), t_sex(Product,T),
						sex_list(C,L), l_com(L,T,X).


/* -------------------------------- PARENTS -------------------------------- */

%rule 14: Does person have parent which matches products target age
r_14(Person, Product,X):- parents(Person,C), target_age(Product,T),
						age_list(C,L), l_com(L,T,X).

%rule 15: Does person have parent which matches products target ethnicity
r_15(Person, Product,X):- parents(Person,C), target_eth(Product,T),
						eth(C,L), l_com(L,T,X).

%rule 16: Does person have parent which matches products target sex
r_16(Person, Product,X):- parents(Person,C), t_sex(Product,T),
						sex_list(C,L), l_com(L,T,X).


/* -------------------------------- INTERESTS -------------------------------- */


/* -------------------------------- PERSONAL -------------------------------- */

%rule 17: Is person interested in product category
r_17(Person, Product, X):- interests([Person], I), type(Product,T),
							is_element(T,I,X).

/* -------------------------------- FAMILY -------------------------------- */

%rule 18: Is the persons children interested in product category
r_18(Person, Product, X):- children(Person,C), interests(C,I), type(Product,T),
							is_element(T,I,X).

%rule 19: Is the persons partner interested in product category
r_19(Person, Product, X):- partner(Person,C), interests(C,I), type(Product,T),
							is_element(T,I,X).

%rule 20: Is the persons parents interested in product category
r_20(Person, Product, X):- parents(Person,C), interests(C,I), type(Product,T),
							is_element(T,I,X).

/* -------------------------------- REJECT -------------------------------- */

%rule 21: reject based on location
r_21(Person, Product, X):- lives(Person,P), reject(Product,T),
							is_element(P,T,X).

%rule 22: reject because of age limit
r_22(Person, Product, X):- get_cat(Person,Age), allages(Product, B),
							agecheck(Age,B,X).

%rule 23: is item rejected because of rule 22 OR rule 23
r_23(Person, Product, X):- r_21(Person, Product, X1), r_22(Person, Product, X2),
							X3 is X1+X2, checkb(X3,X).


/* -------------------------------- OTHER -------------------------------- */

%rule 24: number of matches for person with product personal
r_24(Person, Product, X):- r_1(Person, Product, X1), r_2(Person, Product, X2),
							r_3(Person, Product, X3), r_4(Person, Product, X4),
							X is X1+X2+X3+X4.

%rule 25: number of clashes for person with product personal
r_25(Person, Product, X):- r_5(Person, Product, X1), r_6(Person, Product, X2),
							r_7(Person, Product, X3), X is X1+X2+X3.

%rule 26: number of matches for persons child with product family
r_26(Person, Product, X):- r_8(Person, Product, X1), r_9(Person, Product, X2),
							r_10(Person, Product, X3), X is X1+X2+X3.

%rule 27: number of matches for persons partner with product family
r_27(Person, Product, X):- r_11(Person, Product, X1), r_12(Person, Product, X2),
							r_13(Person, Product, X3), X is X1+X2+X3.

%rule 28: number of matches for persons parents with product family 
r_28(Person, Product, X):- r_14(Person, Product, X1), r_15(Person, Product, X2),
							r_16(Person, Product, X3), X is X1+X2+X3.


/* -------------------------------- WEIGHTS -------------------------------- */


/* -------------------------------- PRODUCT PERSONAL WT -------------------------------- */
/*
Weights are as follows:

1. Product personal
	a. Match
		age r_1: 10
		eth r_2: 5
		sex r_3: 10
		loc r_4: 5
	b. Clash
		age r_5: 10
		eth r_6: 5
		sex r_7: 10
	c. Totals
		n matches r_24: n*10 
		n clashes r_25: n*-10
	d. Final value
		W = match_weight - clash_weight + n_match - n_clash
*/
/* -------------------------------------------------------------------------------------- */

%rule 29: Set match weight
r_29(Person,Product,X):- r_1(Person, Product, X1), r_2(Person, Product, X2),
						r_3(Person, Product, X3), r_4(Person, Product, X4),
						W1 is X1 * 10, 
						W2 is X2 * 5, 
						W3 is X3 * 10, 
						W4 is X4 * 5,
						X is W1 + W2 + W3 + W4.

%rule 30: Set clash weight
r_30(Person,Product,X):- r_5(Person, Product, X1), r_6(Person, Product, X2),
						r_7(Person, Product, X3),
						W1 is X1 * 10, 
						W2 is X2 * 5, 
						W3 is X3 * 10,
						X is W1 + W2 + W3.

%rule 31: Set extra weight depending on n attribute matches
r_31(Person,Product,X):- r_24(Person, Product, X1),
						X is X1 * 10.

%rule 32: Set extra weight depending on n attribute clashes
r_32(Person,Product,X):- r_25(Person, Product, X1),
						X is X1 * 10.

%rule 33: Set product personal weight
r_33(Person,Product,X):- r_29(Person,Product,X1), r_30(Person,Product,X2),
						r_31(Person,Product,X3), r_32(Person,Product,X4),
						A is X1 - X2, 
						B is X3 - X4, 
						X is A + B.


/* -------------------------------- PRODUCT FAMILY WT -------------------------------- */
/*
Weights are as follows:

2. Product family
	a. Children
		age r_8: 10
		eth r_9: 5
		sex r_10: 10
		total (t1): 6*(10*r_8 + 5*r_9 + 10*r_10)
	b. Partner
		age r_11: 10
		eth r_12: 5
		sex r_13: 10
		total (t2): 3* (10*r_11 + 5*r_12 + 10*r_13)
	c. Parents
		age r_14: 10
		eth r_15: 5
		sex r_16: 10
		total (t3): 10*r_14 + 5*r_15 + 10*r_16
	d. Final value
		W = 0.1*(t1+t2+t3)
*/
/* -------------------------------------------------------------------------------------- */

%rule 34: Set product family children weight
r_34(Person,Product,X):- r_8(Person,Product,X1), r_9(Person,Product,X2),
						r_10(Person,Product,X3),
						W1 is X1 * 10,
						W2 is X2 * 5,
						W3 is X3 * 10,
						T is X1 + X2 + X3,
						X is T * 6.

%rule 35: Set product family partner weight
r_35(Person,Product,X):- r_11(Person,Product,X1), r_12(Person,Product,X2),
						r_13(Person,Product,X3),
						W1 is X1 * 10,
						W2 is X2 * 5,
						W3 is X3 * 10,
						T is X1 + X2 + X3,
						X is T * 3.

%rule 36: Set product family parent weight
r_36(Person,Product,X):- r_14(Person,Product,X1), r_15(Person,Product,X2),
						r_16(Person,Product,X3),
						W1 is X1 * 10,
						W2 is X2 * 5,
						W3 is X3 * 10,
						X is X1 + X2 + X3.

%rule 37: Set product family weight
r_37(Person,Product,X):- r_34(Person,Product,X1), r_35(Person,Product,X2),
						r_36(Person,Product,X3),
						T is X1 + X2 + X3,
						X is 0.1 * T.

/* -------------------------------- Interests WT -------------------------------- */
/*
Weights are as follows:

3. Interests
	a. Personal
		total (t1): r_17*20
	b. Family
		children r_18: 10
		partner r_19: 8
		parent r_20: 5
		total (t2): 10*r_18 + 8*r_19 + 5*r_20
	c. Final Value
		W = 10*(t1+t2).
*/
/* -------------------------------------------------------------------------------------- */

%rule 38: Personal interest weight
r_38(Person,Product,X):- r_17(Person, Product, X1),
						X is X1*20.

%rule 39: Family interest weight
r_39(Person,Product,X):- r_18(Person,Product,X1), r_19(Person,Product,X2),
						r_20(Person,Product,X3),
						W1 is X1 * 10,
						W2 is X2 * 8,
						W3 is X3 * 5,
						X is W1 + W2 + W3.

%rule 40: Interest based weight
r_40(Person,Product,X):- r_38(Person,Product,X1), r_39(Person,Product,X2),
						W is X1 + X2,
						X is W * 10.

/* -------------------------------- PRODUCT WEIGHT -------------------------------- */

%rule 41: Product weight = W_Personal (33) + W_Family (37) + W_Interest (40)
r_41(Person,Product,X):- r_33(Person,Product,X1), r_37(Person,Product,X2),
						r_40(Person,Product,X3), r_23(Person, Product, X4),
						A is X1 + X2 + X3,
						B is X4 * 10000,
						X is A - B.


/* -------------------------------- RECOMMENDER SYSTEM -------------------------------- */


/*
Item list = [italian_cookbook, spice_box, laptop, mouse, gun_manual, chopsticks, tea, bat, ball, skates, doll].
*/

%Get item weights for person
get_w(P, [], []).
get_w(P, [X|T1], [[X,Y]|T2]):- r_41(P,X,Y), get_w(P,T1,T2).

% get list of weights for person

getl(P,X):- get_w(P, [italian_cookbook, spice_box, laptop, mouse, gun_manual, chopsticks, tea, bat, ball, skates, doll],X).