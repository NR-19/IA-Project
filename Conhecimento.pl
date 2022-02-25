
%aresta(Rua1,Rua2,CustoDistancia,CustoTempo).

aresta("Rua dos Alecrins", "Rua de Santa Rita", 1.4, 4 ).
aresta("Rua dos Alecrins", "Caminho de Santo Amaro", 1.3 , 3).
aresta("Rua dos Alecrins", "Estrada Comandante Camacho de Freitas", 2.2 , 6).
aresta("Rua de Santa Rita", "Rua do Arieiro", 1.3 , 2).
aresta("Rua de Santa Rita", "Rua Padre Pita Ferreira", 2.2, 3).
aresta("Rua de Santa Rita", "Estrada João Gonçalves Zarco", 2.5 , 3).
aresta("Estrada João Gonçalves Zarco", "Rua Padre Pita Ferreira", 1.4, 3).
aresta("Rua Padre Pita Ferreira", "Rua Manuel França", 2.8, 5).
aresta("Caminho do Ernesto", "Rua Padre Pita Ferreira", 2.9, 6).
aresta("Rua Manuel França", "Caminho do Ernesto", 4, 8).
aresta("Estrada José Ângelo Pestana de Barros", "Caminho do Ernesto",1.6, 3).
aresta("Rua do Arieiro", "Estrada Monumental",2, 3).
aresta("Estrada Monumental","Caminho de São Martinho", 2.6, 5).
aresta("Caminho de São Martinho", "Caminho de Santo Amaro", 1.8, 3).
aresta("Rua da Ponte São Lázaro", "Caminho de São Martinho", 3.1, 5).
aresta("Caminho de Santo Amaro", "Avenida da Madalena", 1.9, 4).
aresta("Caminho do Lombo Segundo", "Estrada Comandante Camacho de Freitas", 3.5, 7).
aresta("Caminho do Lombo Segundo", "Avenida da Madalena", 3.2, 6).
aresta("Avenida da Madalena", "Rua Álvaro Justino de Matos", 3.5, 7).
aresta("Caminho da Ribeira Grande", "Caminho do Lombo Segundo", 2.8, 5).
aresta("Estrada Comandante Camacho de Freitas", "Caminho da Ribeira Grande", 2.1, 4).
aresta("Rua Álvaro Justino de Matos", "Caminho do Lombo Segundo", 2.8, 5).
aresta("Rua Álvaro Justino de Matos", "Rua da Ponte São Lázaro", 3.3, 6).
aresta("Rua da Ponte São Lázaro", "Estrada Monumental", 3.7, 6).
aresta("Caminho de Santo Amaro", "Caminho do Lombo Segundo", 3.7, 7).
aresta("Avenida da Madalena","Rua da Ponte São Lázaro",3,5).
aresta("Rua Manuel França","Estrada José Ângelo Pestana de Barros",4.8,10).

aresta(R1,R2,C,T) :- aresta(R2,R1,C,T),!.


%------------------------------------------------------------------------------------


%estima(Rua,EstimativaCustoDistancia,EstimativaCustoTempo).

estima("Rua dos Alecrins", 0, 0).
estima("Rua de Santa Rita", 0.9, 2.2).
estima("Caminho de Santo Amaro", 0.7, 1.7).
estima("Estrada Comandante Camacho de Freitas", 1.3, 3.2).
estima("Rua do Arieiro", 1.7, 4.2). 
estima("Estrada João Gonçalves Zarco", 2.5, 6.0).
estima("Rua Padre Pita Ferreira", 1.7 , 4.1).
estima("Caminho do Ernesto", 1.8, 4.4).
estima("Rua Manuel França", 2.6, 6.2).
estima("Estrada José Ângelo Pestana de Barros", 2.7, 6.5).
estima("Estrada Monumental", 2.8, 6.7).
estima("Caminho de São Martinho", 1.7, 4.1).
estima("Rua da Ponte São Lázaro", 3.8, 9.1).
estima("Avenida da Madalena", 1.9 , 4.5).
estima("Rua Álvaro Justino de Matos", 3.6, 8.7).
estima("Caminho do Lombo Segundo", 2.8, 6.7). 
estima("Caminho da Ribeira Grande", 2.5, 6.0).


%------------------------------------------------------------------------------------

localizacaoEmpresa("Rua dos Alecrins").

%pontoDeEntrega(Rua).
%Pontos de entrega válidos.

pontoDeEntrega("Rua de Santa Rita").
pontoDeEntrega("Caminho de Santo Amaro").
pontoDeEntrega("Estrada Comandante Camacho de Freitas").
pontoDeEntrega("Rua do Arieiro").
pontoDeEntrega("Estrada João Gonçalves Zarco").
pontoDeEntrega("Rua Padre Pita Ferreira").
pontoDeEntrega("Caminho do Ernesto").
pontoDeEntrega("Rua Manuel França").
pontoDeEntrega("Estrada José Ângelo Pestana de Barros").
pontoDeEntrega("Estrada Monumental").
pontoDeEntrega("Caminho de São Martinho").
pontoDeEntrega("Rua da Ponte São Lázaro").
pontoDeEntrega("Avenida da Madalena").
pontoDeEntrega("Rua Álvaro Justino de Matos").
pontoDeEntrega("Caminho do Lombo Segundo").
pontoDeEntrega("Caminho da Ribeira Grande").

%------------------------------------------------------------------------------------

%transporte(peso,velocidade media,volume,ecologia).

transporte(bicicleta,5,10,20,10).
transporte(mota,20,35,75,4).
transporte(carro,100,25,300,1).

%------------------------------------------------------------------------------------

%estafeta(ID,Nome).

estafeta(1,"Gervásio Motoboy").
estafeta(2,"Mario Visente").
estafeta(3,"Mariano Diaz").
estafeta(4,"Amélio Cardoso").
estafeta(5,"Capelo Rego").

%------------------------------------------------------------------------------------

%cliente(Nome,ID,[(EstafetaID/EncomendaID/Rating)]).

cliente("Tomas Pina",1,[(4/1/2),(1/5/4)]).
cliente("Graciano Nunes",2,[(1,8,5)]).
cliente("Lídio Pereira",3,[(4/7/3),(5/9/5)]).
cliente("Tomas Pontes",4,[(2/2/2),(1/4/5)]).
cliente("Romario Faria",5,[(5/3/4),(5/6/4)]).
cliente("Faustino Silva",6,[]).
cliente("Ramiro Calcifo",7,[]).
cliente("Jorge Fluído",8,[]).
cliente("Cândido Faísca",9,[]).
cliente("Teresa Pinto",10,[]).
cliente("Maria Ribas",11,[]).
cliente("Maria Joana",12,[]).
cliente("Ana Cacho",13,[]).
cliente("Susana Antunes",14,[]).
cliente("Carolina Lima",15,[]).
cliente("Rafaela Ferreira",16,[]).

%------------------------------------------------------------------------------------

%entrega(DataDeEntrega,Rua,EconmendaID,Transporte,EstafetaID,IDCliente).

entrega(27/11/2021,"Rua Manuel França",1,mota,4,1). 
entrega(27/11/2021,"Estrada Comandante Camacho de Freitas",2,carro,4,4).
entrega(11/11/2021,"Rua de Santa Rita",3,bicicleta,5,5).
entrega(2/11/2021,"Estrada Comandante Camacho de Freitas",4,carro,1,4).
entrega(27/10/2021,"Rua do Arieiro",5,carro,1,1).
entrega(31/10/2021,"Caminho do Ernesto",6,bicicleta,5,5).
entrega(6/10/2021,"Estrada José Ângelo Pestana de Barros",7,carro,4,3).
entrega(15/10/2021,"Estrada Comandante Camacho de Freitas",8,mota,1,2).
entrega(10/10/2021,"Caminho da Ribeira Grande",9,bicicleta,5,3).

%------------------------------------------------------------------------------------

%Encomendas entregues
%encomenda(Peso,Volume,EconmendaID).

encomenda(10,20,1).
encomenda(42,10,2).
encomenda(2,1,3).
encomenda(100,40,4).
encomenda(220,100,5).
encomenda(3,4,6).
encomenda(20,40,7).
encomenda(15,20,8).
encomenda(4,2,9).

%Encomendas por entregar
%encomenda(Peso,Volume,EconmendaID,Rua,IDCliente).

encomenda(10,10,10,"Rua Manuel França",6).
encomenda(4,9,11,"Rua de Santa Rita",7). 
encomenda(15,30,12,"Estrada Comandante Camacho de Freitas",8).
encomenda(80,250,13,"Rua do Arieiro",9).
encomenda(1,2,14,"Estrada João Gonçalves Zarco",10). 
encomenda(5,5,15,"Rua Padre Pita Ferreira",11).
encomenda(40,120,16,"Caminho do Ernesto",12).
encomenda(2,4,17,"Estrada José Ângelo Pestana de Barros",13). 
encomenda(15,50,18,"Estrada Monumental",14).
encomenda(60,200,19,"Caminho de São Martinho",15). 
encomenda(1,12,20,"Avenida da Madalena",16). 
encomenda(10,70,21,"Rua Álvaro Justino de Matos",9).
encomenda(30,10,22,"Caminho do Lombo Segundo",11).
encomenda(5,5,23,"Caminho da Ribeira Grande",7). 
encomenda(18,42,24,"Caminho de São Martinho",6).
encomenda(3,3,25,"Estrada João Gonçalves Zarco",13).
encomenda(130,47,26,"Estrada Comandante Camacho de Freitas",16). %pesoImp
encomenda(10,500,27,"Rua da Ponte São Lázaro",16). %volumeImp
encomenda(5,20,28,"Caminho do Lombo Segundo",10). %bikeE
encomenda(20,75,29,"Estrada João Gonçalves Zarco",11). %motaE
encomenda(100,300,30,"Rua da Ponte São Lázaro",14). %carroE

%------------------------------------------------------------------------------------