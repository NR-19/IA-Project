%predicados auxiliares


sum([],0).
sum([X|T],R) :- sum(T,R1), R is X+R1.


%cálculo do custoDistancia
calculaCusto([_],0,0).
calculaCusto([A,B|Tail],C,T):- aresta(A,B,Custo,Tempo),
							   calculaCusto([B|Tail],C1,T1),
							   C is C1 + Custo,
							   T is T1 + Tempo.


%cálculo do peso e do volume que uma lista de encomendas ocupa num transporte
calculaPesoVolume([],0/0).
calculaPesoVolume([encomenda(Peso,Volume,_,_,_)|T],X/V) :-
	
	calculaPesoVolume(T,Y/Z),
	X is Peso+Y,
	V is Volume+Z.


%escolha do transporte mais ecológico
escolheTransporteEco(Peso,Volume,T) :- 

	escolheBicicleta(Peso,Volume,T);
	escolheMota(Peso,Volume,T);
	escolheCarro(Peso,Volume,T);
	nl,write("Encomenda impossível\n"),!,fail.



escolheBicicleta(Peso,Volume,T) :- (Peso=<5),(Volume=<20),T=bicicleta.
escolheMota(Peso,Volume,T) :- (Peso=<20),(Volume=<75),T=mota.
escolheCarro(Peso,Volume,T) :- (Peso=<100),(Volume=<300),T=carro.


%cálculo da velocidade do transporte escolhido, tendo em conta o peso que carrega
calculaVelocidade(bicicleta,Peso,VelFinal) :- VelFinal is (10-(0.7*Peso)).
calculaVelocidade(mota,Peso,VelFinal) :- VelFinal is (35-(0.5*Peso)).
calculaVelocidade(carro,Peso,VelFinal) :- VelFinal is (25-(0.1*Peso)).


%Cálculo do tempo em minutos a partir da distância e velocidade
calculaTempoReal(CustoDist,Vel,CustoT) :- CustoT is ((CustoDist/Vel)*60).


concatL([],L,L).
concatL([H|T],L,[H|Z]):- concatL(T,L,Z).

head([],[]).
head([H|_],H).

%predicado que permite fazer arredondamento para 'D' casas decimais
round(X,Y,D) :- Z is X * 10^D, round(Z, ZA), Y is ZA / 10^D.


seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

escrever([]).
escrever([X|L]):- write(X), nl, escrever(L).

%escolha do caminho
escolheCaminho(dfs,Orig,Dest,Cam,Dist,Tempo) :- dfs(Orig,Dest,Cam,Dist,Tempo).
escolheCaminho(bfs,Orig,Dest,Cam,Dist,Tempo) :- bfs(Orig,Dest,Cam,Dist,Tempo).
escolheCaminho(ldis,Orig,Dest,Max,Cam,Dist,Tempo) :- ldis(Orig,Dest,Max,Cam,Dist,Tempo).
escolheCaminho(gulosa,Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :- resolve_gulosa(Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo).
escolheCaminho(estrela,Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :- resolve_aestrela(Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo).