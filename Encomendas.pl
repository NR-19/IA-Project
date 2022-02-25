:- dynamic encomenda/3.
:- dynamic encomenda/5.
:- dynamic entrega/6.
:- dynamic cliente/3.
:- include('Procuras.pl').
:- include('Conhecimento.pl').
:- include('PredicadosAuxiliares.pl').


%preco(Peso,Volume,Transporte,Preco).

preco(Peso,V,bicicleta,P) :- P is ((Peso+V)*0.01)+1.
preco(Peso,V,mota,P) :- P is ((Peso+V)*0.025)+5.
preco(Peso,V,carro,P) :- P is ((Peso+V)*0.035)+7.


%-----------------------------------------------------------------------------------

%identificar o estafeta que utilizou mais vezes um meio de transporte mais ecológico;

estafetaEco(estafeta(X,Nome)) :- 

	findall(ID/E,(entrega(_,_,_,T,ID,_),transporte(T,_,_,_,E)),L),
	listaID(L,[],ListaU),
	calculaTudo(ListaU,L,[],Lista),
	maiorL(Lista,X),
	estafeta(X,Nome).
				    


maiorLAux([],ID/_,ID).
maiorLAux([ID/H|T],_/A,R) :- H>A, maiorLAux(T,ID/H,R).
maiorLAux([_/H|T],_/A,R) :- H=<A, maiorLAux(T,_/A,R).

maiorL([ID/H|T],Max) :- maiorLAux(T,ID/H,Max).


igual(A,B/_) :- A==B.

snd(_/B,B).
fst(A/_,A).

calcula(ID,L,X) :- 

	include(igual(ID),L,Lista),
	maplist(snd,Lista,ListaNova),
	sum(ListaNova,X).


calculaTudo([],_,Lista,Lista).
calculaTudo([ID/_|T],L,Lista,ListaF) :- 
									calcula(ID,L,X),
									calculaTudo(T,L,[ID/X|Lista],ListaF).

listaID([],Lista,Lista).
listaID([ID/_|T],L,Lista) :-
							\+member(ID/_,L) -> listaID(T,[ID/_|L],Lista);
												listaID(T,L,Lista).



%------------------------------------------------------------------------------------
%identificar  que  estafetas  entregaram  determinada(s)  encomenda(s)  a  um determinado cliente;




encomendas(cliente(_,ID),Lista) :- 
									findall(estafeta(EstafetaID,Nome),(entrega(_,_,_,_,EstafetaID,ID),estafeta(EstafetaID,Nome)),L),
									encomendasAux(L,[],Lista).


encomendasAux([],Lista,Lista).
encomendasAux([H|T],L,Lista) :- (\+member(H,L)) -> encomendasAux(T,[H|L],Lista); encomendasAux(T,L,Lista).


%------------------------------------------------------------------------------------
%identificar os clientes servidos por um determinado estafeta; 


clientesEstafeta(estafeta(EstafetaID,_),Lista) :- findall(cliente(Nome,ID,_), (entrega(_,_,_,_,EstafetaID,ID),cliente(Nome,ID,_)),L),
												  encomendasAux(L,[],Lista).


%------------------------------------------------------------------------------------
%calcular o valor faturado pela Green Distribution num determinado dia;


faturacao(Data,X) :- 

	findall(P/V/Tr,(entrega(Data,_,ID,Tr,_,_),encomenda(P,V,ID)),L),
	faturacaoAux(L,X).

faturacaoAux([],0).
faturacaoAux([P/V/Tr|T],Z) :- 

	preco(P,V,Tr,X),
	faturacaoAux(T,Y),
	Z is X + Y.



%------------------------------------------------------------------------------------
%identificar  quais  as  zonas  (e.g.,  rua  ou  freguesia)  com  maior  volume  de entregas por parte da Green Distribution; 

ruasComMaiorVolumeEncomenda(Ans) :- 

	findall((Rua/Enc),(entrega(_,Rua,Enc,_,_,_)),L),
	listaID(L,[],ListaU),
	calculaTudoAlt(ListaU,L,[],Ans).


%------------------------------------------------------------------------------------
%calcular a classificacao media de satisfacao de cliente para um determinado estafeta;


classificacaoMedia(estafeta(ID,_), Result) :- 

	findall(Info,cliente(_,_,Info),List),
	maplist(list_tail, List, T),
	append(T, L),
	include(id(ID/_/_),L,Lista),
	length(Lista,X),
	sum3(Lista,R),
	(X=\=0)-> Result is R/X;
	Result is 0.



sum3([],0).
sum3([_/_/X|T],R) :- sum3(T,R1), R is X+R1.



id(ID/_/_,ID/_/_).

fstThr(A/_/C,A/C).

list_tail([],[]).
list_tail([_|T], T).



%------------------------------------------------------------------------------------
%identificar o número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo; 


entregasPorTransporte(Data1,Data2,Ans) :- 

	findall(entrega(D,_,_,T,_,_),(entrega(D,_,_,T,_,_),entreDatas(D,Data1,Data2)),L),
	include(isCarro,L,Carro),
	length(Carro,C),

	include(isMota,L,Mota),
	length(Mota,M),

	include(isBicicleta,L,Bicicleta),
	length(Bicicleta,B),


	append([("Carro",C)],[("Mota",M)],Temp),
	append(Temp,[("Bicicleta",B)],Ans).


isCarro(entrega(_,_,_,carro,_,_)). 
isMota(entrega(_,_,_,mota,_,_)). 
isBicicleta(entrega(_,_,_,bicicleta,_,_)). 



%------------------------------------------------------------------------------------
%identificar  o  número  total  de  entregas  pelos  estafetas,  num  determinado intervalo de tempo;

entregasPorEstafetas(Data1,Data2,Ans) :- 

	findall((ID/Enc),(entrega(D,_,Enc,_,ID,_),entreDatas(D,Data1,Data2)),L),
	listaID(L,[],ListaU),
	calculaTudoAlt(ListaU,L,[],Ans).

calculaAlt(ID,L,X) :- 
					
	include(igual(ID),L,Lista),
	maplist(snd,Lista,ListaNova),
	length(ListaNova,X).


calculaTudoAlt([],_,Lista,Lista).
calculaTudoAlt([ID/_|T],L,Lista,ListaF) :- 

	calculaAlt(ID,L,X),
	calculaTudoAlt(T,L,[ID/X|Lista],ListaF).


%------------------------------------------------------------------------------------
%calcular  o  número  de  encomendas  entregues  e  nao  entregues  pela  Green Distribution, num determinado período de tempo; 


entreDatas(D/M/A,D1/M1/A1,D2/M2/A2) :- 

	date_time_stamp(date(A,M,D),X),
	date_time_stamp(date(A1,M1,D1),Y),
	date_time_stamp(date(A2,M2,D2),Z),
	X<Z,
	X>Y.



numeroEntregasEntreDatas(Data1,Data2,Entregues/NaoEntregues) :-

	findall(D,entrega(D,_,_,_,_,_),L),
	entreguesENaoEntregues(L,Data1,Data2,[],[],Entregues/NaoEntregues).

														
entreguesENaoEntregues([],_,_,ListaX,ListaY,X/Y) :- length(ListaX,X),length(ListaY,Y).
entreguesENaoEntregues([D|T],Data1,Data2,ListaX,ListaY,X/Y) :- 

	entreDatas(D,Data1,Data2) -> 
									entreguesENaoEntregues(T,Data1,Data2,[D|ListaX],ListaY,X/Y);
									entreguesENaoEntregues(T,Data1,Data2,ListaX,[D|ListaY],X/Y).




%------------------------------------------------------------------------------------
%calcular o peso total transportado por estafeta num determinado dia.


pesoTransportado(Data,estafeta(EstafetaID,_),X) :- 
	
	findall(P,(entrega(Data,_,EncomendaID,_,EstafetaID,_),encomenda(P,_,EncomendaID)),L),
	sum(L,X).



%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%-----------------------------------FASE 2-------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------


%Cenário de Teste
%entregaUmaEncomendaEstrela(encomenda(10,10,10,"Rua Manuel França"),1,CaminhoDistanciaIda/CaminhoDistanciaVolta/CustoDistF, CaminhoTempoIda/CaminhoTempoVolta/CustoTempoF,T,E).

entregaUmaEncomenda(encomenda(Peso,Volume,ID,Morada,Clienteid),IDEstafeta,CaminhoDistanciaIda/CaminhoDistanciaVolta/CustoDistF, CaminhoTempoIda/CaminhoTempoVolta/CustoTempoF,T,E,Procura) :- 
	

	(\+ pontoDeEntrega(Morada)) -> write("Morada Inválida");% validação da Morada

	%escolha do transporte mais ecológico e do estafeta
	escolheTransporteEco(Peso,Volume,T),
	estafeta(IDEstafeta,Nome),
	E = estafeta(IDEstafeta,Nome),


	%cálculo do caminho desde a base até à morada de entrega da encomenda
	escolheCaminho(Procura,Morada,CaminhoDistanciaI/CustoDist, CaminhoTempoI/_),
	reverse(CaminhoDistanciaI,CaminhoDistanciaDeVolta),
	reverse(CaminhoTempoI,CaminhoTempoDeVolta),


	CaminhoDistanciaIda = CaminhoDistanciaI,
	CaminhoDistanciaVolta = CaminhoDistanciaDeVolta,
	CaminhoTempoIda = CaminhoTempoI,
	CaminhoTempoVolta = CaminhoTempoDeVolta,
	

	calculaVelocidade(T,Peso,Vel),
	calculaTempoReal(CustoDist,Vel,CustoT),


	CustoDistF is 2*CustoDist,
	floor(2*CustoT,CustoTempoF),

	%registo da entrega da encomenda na base de conhecimento
	registarEntrega(Peso,Volume,ID,Morada,T,IDEstafeta,Clienteid),nl.



%------------------------------------------------------------------------------------


%registo da entrega na base de conhecimento
registarEntrega(Peso,Volume,ID,Morada,T,IDEstafeta,Clienteid) :-
	
	%adição da encomenda concluída ao conhecimento
	assert(encomenda(Peso,Volume,ID)),
	
	%cálculo da data de entrega e adição da mesma na base de conhecimento
	get_time(X),
	stamp_date_time(X,date(Ano,Mes,Dia,_,_,_,_,_,_),'UTC'),
	assert(entrega(Dia/Mes/Ano,Morada,ID,T,IDEstafeta,Clienteid)),
	
	%adição da encomenda à lista de entregas do cliente
	random(1,6,Rating),
	cliente(Nome,Clienteid,Encomendas),
	retract(cliente(Nome,Clienteid,Encomendas)),
	append(Encomendas,[IDEstafeta/ID/Rating],NovasEncomendas),
	assert(cliente(Nome,Clienteid,NovasEncomendas)),
	

	retract(encomenda(Peso,Volume,ID,Morada,Clienteid)).


%------------------------------------------------------------------------------------

%entregaVariasEncomendas([encomenda(10,10,10,"Rua Manuel França")/1,encomenda(4,9,11,"Rua de Santa Rita")/1],1,CaminhoDistanciaIda/CaminhoDistanciaVolta/CustoDistF, CaminhoTempoIda/CaminhoTempoVolta/CustoTempoF,T,E).

entregaVariasEncomendas([encomenda(Peso,Volume,ID,Morada,Clienteid)|Tail],IDEstafeta,T,E,CircuitoDistancia/CustoDistancia,CircuitoTempo/CustoTempo,ProcuraNaoInf/ProcuraInf) :-


	%cálculos para a primeira entrega, com o peso inicial de todas as encomendas em questão e cálculo da velocidade resultante de peso transportado
	calculaPesoVolume([encomenda(Peso,Volume,ID,Morada,Clienteid)|Tail],X/V),
	escolheTransporteEco(X,V,T),
	estafeta(IDEstafeta,Nome),
	E = estafeta(IDEstafeta,Nome),
	
	%cálculo do caminho desde a base até à localização da primeira encomenda
	escolheCaminho(ProcuraInf,Morada,FirstCaminhoD/Dist,FirstCaminhoT/_),
	calculaVelocidade(T,X,Vel),


	%novo peso, depois da primeira encomenda
	PesoTotal is X-Peso,

	entregaVariasEncomendasAux([encomenda(Peso,Volume,ID,Morada,Clienteid)|Tail],IDEstafeta,[]/Distancia, []/Tempo,T,E,PesoTotal,CircuitoD,CircuitoT,ProcuraNaoInf/ProcuraInf),


	%organização dos caminhos obtidos no circuito de entrega
	reverse(CircuitoD,CircuitoDF),
	reverse(CircuitoT,CircuitoTF),
	append([FirstCaminhoD],CircuitoDF,CircuitoDistancia),
	append([FirstCaminhoT],CircuitoTF,CircuitoTempo),
	

	calculaTempoReal(Dist,Vel,CustoT),

	round(Dist+Distancia,CustoDistancia,1),
	CustoTempo is round(CustoT+Tempo),
	nl.



entregaVariasEncomendasAux([encomenda(Peso,Volume,ID,Morada,Clienteid)],IDEstafeta,CaminhoDistancia/CustoDist, CaminhoTempo/CustoT,T,_,_,CircuitoD,CircuitoT,_/ProcuraInf) :-


	%cálculo do caminho desde a base até à localização da encomenda
	escolheCaminho(ProcuraInf,Morada,CaminhoDistanciaI/CustoDist, CaminhoTempoI/_),
	reverse(CaminhoDistanciaI,CaminhoDistanciaDeVolta),
	reverse(CaminhoTempoI,CaminhoTempoDeVolta),

	

	%estamos aqui a voltar para a base por isso temos velocidade total
	transporte(T,Vel,_,_,_),
	calculaTempoReal(CustoDist,Vel,CustoT),


	%registo do caminho encontrado no circuito feito pelo estafeta
	CircuitoD = [CaminhoDistanciaDeVolta|CaminhoDistancia],
	CircuitoT = [CaminhoTempoDeVolta|CaminhoTempo],

	%registo da última entrega na base de conhecimento
	registarEntrega(Peso,Volume,ID,Morada,T,IDEstafeta,Clienteid).

	
	

entregaVariasEncomendasAux([encomenda(Peso,Volume,ID,Morada,Clienteid),encomenda(Peso2,Volume2,ID2,Morada2,Clienteid2)|Encomendas],IDEstafeta,CaminhoDistancia/Distancia, CaminhoTempo/Tempo,T,E,PesoTotal,CircuitoD,CircuitoT,ProcuraNaoInf/ProcuraInf) :-


	escolheCaminho(ProcuraNaoInf,Morada, Morada2 ,Cam,D,_),


	%cálculo do caminho desde a 'Morada' até à 'Morada2'
	

	calculaVelocidade(T,PesoTotal,Vel),
	calculaTempoReal(D,Vel,CustoT),


	registarEntrega(Peso,Volume,ID,Morada,T,IDEstafeta,Clienteid),

	%subtração do peso da encomenda entregue para fazer o ajuste na velocidade das entregas seguintes
	PesoTotalNovo is PesoTotal-Peso,

	entregaVariasEncomendasAux([encomenda(Peso2,Volume2,ID2,Morada2,Clienteid2)|Encomendas],IDEstafeta,[Cam|CaminhoDistancia]/Distancia1, [Cam|CaminhoTempo]/Tempo1,T,E,PesoTotalNovo,CircuitoD,CircuitoT,ProcuraNaoInf/ProcuraInf),

	Tempo is CustoT+Tempo1,
	Distancia is D+Distancia1.



