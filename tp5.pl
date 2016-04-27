:-dynamic vrai/1,faux/1,marque/1,changement/0.

/*Question 1*/
regle(r1):-si([a,b]),alors([c]).
regle(r2):-si([c,d]),alors([f]).
regle(r3):-si([f,b]),alors([e]).
regle(r4):-si([f,a]),alors([g]).
regle(r5):-si([g,f]),alors([b]).
regle(r6):-si([a,h]),alors([l]).
regle(r7):-si([e,l]),alors([m]).

regle(Regle,Premisses,Conclusion):-clause(regle(Regle),(si(Premisses),alors(Conclusion))).

/*Question 2*/
fait([]).
fait([Y|X]):-retractall(vrai(Y)),assert(vrai(Y)),fait(X).

/*Question 3*/
raz:-retractall(vrai(_)),retractall(faux(_)),retractall(marque(_)),assert(changement).

si([]).
si([X|Y]):-vrai(X),si(Y).

alors([]).
alors([X|Y]):-not(si([X])),fait([X]),write(X),write(" est prouvé par "),alors(Y).


/*Question 4*/
test(R):-regle(R,_,_),not(marque(R)),regle(R),write(R),write("\n"),assert(changement),assert(marque(R)).

saturer:-test(_),fail.
saturer:-changement,retractall(changement),saturer,!.
saturer:-not(changement).

/*Question 5*/
regle(R,P1,P2,C):-clause(regle(R),(si([P1,P2]),alors([C]))).

satisfait(X):-si([X]),write(X),write(" est dans la base \n"),!.
satisfait(X):-regle(R,P1,P2,X),write("parcourir règle "),write(R), write(" : \n"),satisfait(P1),satisfait(P2),fait([X]),write(X), write(" est ajouté dans la base \n"),write("fin de parcours "),write(R),write("\n").

/*Question 6*/
terminal(F):-not(gauche(F)).
gauche(F):-regle(_,_,F,_),!.
gauche(F):-regle(_,F,_,_).

observable(F):-not(droite(F)).
droite(F):-regle(_,_,_,F).

/*Question 7*/

defait([]).
defait([Y|X]):-retractall(faux(Y)),assert(faux(Y)),defait(X).

go:-saturer,regle(R,P1,P2,_),not(marque(R)),uninconnu(P1,P2).

uninconnu(P1,P2):-vrai(P1),not(vrai(P2)),arriere(P2),!.
uninconnu(P1,P2):-vrai(P2),not(vrai(P1)),arriere(P1),!.

arriere(X):-not(vrai(X)),observable(X),not(faux(X)),write(X),write(" à prouver !\n"),write("Est ce que "),write(X),write(" ? (o/n/i) \n"),read(Y),traiter(Y,X),!.
arriere(X):-regle(_,P1,P2,X),arriere(P1),arriere(P2).

traiter(Y,X):-Y==o,write(X), write(" car observé \n"),fait([X]),go,!.
traiter(Y,X):-Y==n,write(X),write(" faux \n"),defait([X]),go,!.
traiter(Y,_):-Y==i,write("fin \n").


