%person database - we assume complete data as it is taken from facebook


%person ids

id(dave,id_1).
id(mary,id_2).
id(jun,id_3).
id(sue,id_4).
id(joe,id_5).
id(raj,id_6).
id(priya, id_7).
id(jill, id_8).

%dave

sex(id_1,male).
lives(id_1, america).
born(id_1, [america]).
bday(id_1,1993).
partner(id_1, [id_2]).
children(id_1,[]).

%mary

sex(id_2,female).
lives(id_2, america).
born(id_2, [italy]).
bday(id_2,1993).
partner(id_2, [id_1]).
children(id_2,[]).

%jun

sex(id_3,male).
lives(id_3, japan).
born(id_3, [japan]).
bday(id_3,1980).
partner(id_3, [id_4]).
children(id_3,[id_5,id_8]).

%sue

sex(id_4, female),
lives(id_4, japan).
born(id_4, [italy]).
bday(id_4,1980).
partner(id_4, [id_3]).
children(id_4,[id_5,id_8]).

%joe

sex(id_5,male).
lives(id_5, japan).
born(id_5, [japan,italy]).
bday(id_5,2010).
partner(id_5,[]).
children(id_5,[]).

%raj

sex(id_6,male).
lives(id_6, india).
born(id_6, [india]).
bday(id_6,1950).
partner(id_6,[]).
children(id_6,[id_7]).

%priya

sex(id_7, female),
lives(id_7, america).
born(id_7, [india]).
bday(id_7,1980).
partner(id_7,[]).
children(id_7,[]).

%jill

sex(id_8,female).
lives(id_8, japan).
born(id_8, [japan,italy]).
bday(id_8, 2010).
partner(id_5,[]).
children(id_5,[]).


%item database

%item ids

id(italian_cookbook, n1).
id(spice_box, n2).
id(laptop, n3).
id(mouse, n4).
id(gun_manual, n5).
id(chopsticks, n6).
id(tea, n7).
id(bat, n8).
id(ball, n9).
id(skates, n10).
id(doll, n11).



%italian_cookbook

type(n1, cooking).
target_eth(n1,[italy]).
target_age(n1,[adult, senior]).
c_item(n1,[]).
r_eth(n1,[india]).
r_age(n1,[child]).
t_sex(n1, [female]).
r_sex(n1,[]).
reject(n1, []).

%spice_box

type(n2, cooking).
target_eth(n2,[india,italy]).
target_age(n2,[adult, senior]).
c_item(n2,[]).
r_eth(n2,[america]).
r_age(n2,[child]).
t_sex(n2, [female]).
r_sex(n2,[male]).
reject(n2, []).

%laptop

type(n3, electronics).
target_eth(n3,[]).
target_age(n3,[adult, child]).
c_item(n3,[n4]).
r_eth(n3,[]).
r_age(n3,[senior]).
t_sex(n3, []).
r_sex(n3,[]).
reject(n3, []).

%mouse

type(n4, electronics).
target_eth(n4,[]).
target_age(n4,[adult, child]).
c_item(n4,[]).
r_eth(n4,[]).
r_age(n4,[senior]).
t_sex(n4, []).
r_sex(n4,[]).
reject(n4, []).


%gun_manual

type(n5, general).
target_eth(n5,[america]).
target_age(n5,[adult]).
c_item(n5,[]).
r_eth(n5,[india,japan]).
r_age(n5,[senior]).
t_sex(n5, [male]).
r_sex(n5,[female]).
reject(n5, [child]).


%chopsticks

type(n6, general).
target_eth(n6,[japan]).
target_age(n6,[adult, senior, child]).
c_item(n6,[]).
r_eth(n6,[india]).
r_age(n6,[]).
t_sex(n6, []).
r_sex(n6,[]).
reject(n6, []).

%tea

type(n7, consumables).
target_eth(n7,[india,japan]).
target_age(n7,[adult, senior]).
c_item(n7,[]).
r_eth(n7,[]).
r_age(n7,[child]).
t_sex(n7, []).
r_sex(n7,[]).
reject(n7, []).

%bat

type(n8, toys).
target_eth(n8,[]).
target_age(n8,[child]).
c_item(n8,[n9]).
r_eth(n8,[]).
r_age(n8,[senior]).
t_sex(n8, [male]).
r_sex(n8,[]).
reject(n8, []).

%ball

type(n9, toys).
target_eth(n9,[]).
target_age(n9,[child]).
c_item(n9,[n8]).
r_eth(n9,[]).
r_age(n9,[senior]).
t_sex(n9,[male]).
r_sex(n9,[]).
reject(n9, []).

%skates

type(n10, toys).
target_eth(n10,[]).
target_age(n10,[child]).
c_item(n10,[]).
r_eth(n10,[]).
r_age(n10,[]).
t_sex(n10,[]).
r_sex(n10,[]).
reject(n10, [senior]).

%doll

type(n11, toys).
target_eth(n11,[]).
target_age(n11,[child]).
c_item(n11,[]).
r_eth(n11,[]).
r_age(n11,[]).
t_sex(n11, [female]).
r_sex(n11,[male]).
reject(n11, [adult, senior]).


%helper functions

%See if person is adult, senior citizen or child

get_age(P,B,A):-2018-B>60->A = senior;
				2018-B>18->A = adult;
				A=child.
get_cat(P,A):- bday(P,B), get_age(P,B,A).

%search list for element

is_element(X,[X|T]).
is_element(X,[H|T]):-is_element(X,T).

%Check if list is empty

list_empty([], true).
list_empty([_|_], false).

%check if lists have common elements

l_com([H|T1],[H|T2]).
l_com([A|T1],[B|T2]):-l_com([A|T1],T2).
l_com([A|T1],[B|T2]):-l_com(T1,[B|T2]).

%Get list of ages from list of people

age_list([],[]).
age_list([H|T],[X|Y]):-get_cat(H,X),age_list(T,Y).


%Get list of ethnicity from list of people

eth_list1([],[]).
eth_list1([H|T],[X|Y]):-born(H,X), eth_list1(T,Y).
eth_list(L1,L2):-eth_list1(L1,X), append(X,L2).


%rules

%rule 1: does persons age match product

assign_1(L,Cat,V):-is_element(Cat,L)->V=10;V=5.
r_1(Person,Product,Value):- get_cat(Person,Cat), target_age(Product,L), assign_1(L,Cat,Value).



%rule 2: does the persons ethnicity match the product

assign_2(L1,L2,V):-l_com(L1,L2)->V=10;V=5.
r_2(Person,Product,Value):- born(Person,L1), target_eth(Product,L2), assign_2(L1,L2,Value).


%rule 3: does the persons age clash with the product

assign_3(L,Cat,V):-is_element(Cat,L)->V=0;V=5.
r_3(Person,Product,Value):- get_cat(Person,Cat), r_age(Product,L), assign_3(L,Cat,Value).


%rule 4: does the persons ethnicity clash with product

assign_4(L1,L2,V):-l_com(L1,L2)->V=0;V=5.
r_4(Person,Product,Value):- born(Person,L1), r_eth(Product,L2), assign_4(L1,L2,Value).


%rule 5: does the persons sex match the product

assign_5(L,Cat,V):-is_element(Cat,L)->V=10;V=5.
r_5(Person,Product,Value):-sex(Person,S), t_sex(Product,L), assigh_5(L,S,Value).


%rule 6: does the persons sex clash with the product

assign_6(L,Cat,V):-is_element(Cat,L)->V=0;V=5.
r_6(Person,Product,Value):-sex(Person,S), r_sex(Product,L), assigh_5(L,S,Value).


%rule 7: does the person have a child that matches the product in terms of age

a_7_1(L3,L2,V):-l_com(L3,L2)->V=8;V=5.
assign_7(L1,L2,V):-age_list(L1,L3), a_7_1(L3,L2,V).
r_7(Person,Product,Value):- children(Person,L1), target_age(Product,L2), assign_7(L1,L2,Value).


%rule 8: does the person have a child that matches the product in terms of ethnicity

a_8_1(L3,L2,V):-l_com(L3,L2)->V=8;V=5.
assign_8(L1,L2,V) :- eth_list(L1,L3), a_8_1(L3,L2,V).
r_8(Person,Product,Value):- children(Person,L1), target_eth(Product,L2), assigh_8(L1,L2,Value).
rule1(Person,Product,Value):-r_8(Person,Product,Value);Value=0.












