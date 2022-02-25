%pesquisa em profundidade

dfs(Orig,Dest,Cam,Dist,Tempo):- dfs2(Orig,Dest,[Orig],Cam,Dist,Tempo).

dfs2(Dest,Dest,LA,Cam,0,0):- reverse(LA,Cam).
dfs2(Act,Dest,LA,Cam,C,T):- aresta(Act,X,C1,T1),
			\+ member(X,LA),
			dfs2(X,Dest,[X|LA],Cam,C2,T2),
			C is C1+C2,
			T is T1+T2.

%------------------------------------------------------------------------------------

%pesquisa largura primeiro

bfs(Orig, Dest, Cam,C,T):- bfs2(Dest,[[Orig]],Cam),
					   calculaCusto(Cam,C,T).

bfs2(Dest,[[Dest|T]|_],Cam):- reverse([Dest|T],Cam). %o caminho aparece pela ordem inversa
bfs2(Dest,[LA|Outros],Cam):- LA=[Act|_],
                             findall([X|LA],
                             (Dest\==Act,aresta(Act,X,_,_),\+member(X,LA)),Novos),
                             append(Outros,Novos,Todos),
                             bfs2(Dest,Todos,Cam).


%------------------------------------------------------------------------------------
%pesquisa iterativa limitada em profundidade

ldis(Orig,Dest,Max,Cam,Dist,Tempo):- dfs(Orig,Dest,Cam,Dist,Tempo),
										length(Cam, Length),
										(Length =< Max).
						

%------------------------------------------------------------------------------------
%pesquisa a estrela 

resolve_aestrela(Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-

	estima(Nodo, EstimaD, EstimaT),
	aestrela_distancia([[Nodo]/0/EstimaD], CaminhoDistancia/CustoDist/_),
	aestrela_tempo([[Nodo]/0/EstimaT], CaminhoTempo/CustoTempo/_).

aestrela_distancia(Caminhos, Caminho) :-%

	obtem_melhor_distancia(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,localizacaoEmpresa(Nodo).

aestrela_distancia(Caminhos, SolucaoCaminho) :-

	obtem_melhor_distancia(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela_distancia(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela_distancia(NovoCaminhos, SolucaoCaminho).	

obtem_melhor_distancia([Caminho], Caminho) :- !.
obtem_melhor_distancia([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-

	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor_distancia([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 

obtem_melhor_distancia([_|Caminhos], MelhorCaminho) :- 

	obtem_melhor_distancia(Caminhos, MelhorCaminho).
	



expande_aestrela_distancia(Caminho, ExpCaminhos) :-

	findall(NovoCaminho, adjacente_distancia(Caminho,NovoCaminho), ExpCaminhos).
	
% --- tempo 

aestrela_tempo(Caminhos, Caminho) :-

	obtem_melhor_tempo(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	localizacaoEmpresa(Nodo).

aestrela_tempo(Caminhos, SolucaoCaminho) :-

	obtem_melhor_tempo(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela_tempo(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela_tempo(NovoCaminhos, SolucaoCaminho).
	
obtem_melhor_tempo([Caminho], Caminho) :- !.
obtem_melhor_tempo([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-

	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor_tempo([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 

obtem_melhor_tempo([_|Caminhos], MelhorCaminho) :- 

	obtem_melhor_tempo(Caminhos, MelhorCaminho).
	

expande_aestrela_tempo(Caminho, ExpCaminhos) :-

	findall(NovoCaminho, adjacente_tempo(Caminho,NovoCaminho), ExpCaminhos).
	
	
%------------------------------------------------------------------------------------

%pesquisa Gulosa


resolve_gulosa(Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-

	estima(Nodo, EstimaD, EstimaT),
	agulosa_distancia_g([[Nodo]/0/EstimaD], CaminhoDistancia/CustoDist/_),
	agulosa_tempo_g([[Nodo]/0/EstimaT], CaminhoTempo/CustoTempo/_).


agulosa_distancia_g(Caminhos, Caminho) :-

	obtem_melhor_distancia_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	localizacaoEmpresa(Nodo).


agulosa_distancia_g(Caminhos, SolucaoCaminho) :-
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_distancia_g(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_distancia_g(NovoCaminhos, SolucaoCaminho).	


obtem_melhor_distancia_g([Caminho], Caminho) :- !.
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-

	Est1 =< Est2, !,
	obtem_melhor_distancia_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 

obtem_melhor_distancia_g([_|Caminhos], MelhorCaminho) :- 

	obtem_melhor_distancia_g(Caminhos, MelhorCaminho).
	


expande_agulosa_distancia_g(Caminho, ExpCaminhos) :-

	findall(NovoCaminho, adjacente_distancia(Caminho,NovoCaminho), ExpCaminhos).
	
% --- tempo 

agulosa_tempo_g(Caminhos, Caminho) :-

	obtem_melhor_tempo_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	localizacaoEmpresa(Nodo).


agulosa_tempo_g(Caminhos, SolucaoCaminho) :-

	obtem_melhor_tempo_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_tempo_g(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_tempo_g(NovoCaminhos, SolucaoCaminho).
	
obtem_melhor_tempo_g([Caminho], Caminho) :- !.
obtem_melhor_tempo_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-

	Est1 =< Est2, !,
	obtem_melhor_tempo_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 

obtem_melhor_tempo_g([_|Caminhos], MelhorCaminho) :- 

	obtem_melhor_tempo_g(Caminhos, MelhorCaminho).
	

expande_agulosa_tempo_g(Caminho, ExpCaminhos) :-

	findall(NovoCaminho, adjacente_tempo(Caminho,NovoCaminho), ExpCaminhos).


adjacente_distancia([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist) :-

	aresta(Nodo, ProxNodo, PassoCustoDist, _),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estima(ProxNodo, EstDist, _).


adjacente_tempo([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstimaTempo) :-

	aresta(Nodo, ProxNodo, _, PassoTempo),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoTempo,
	estima(ProxNodo, _ , EstimaTempo).
