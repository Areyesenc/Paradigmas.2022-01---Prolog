:- use_module(library(random)).

% Elementos (lista) X numE(int) X maxC(int) X seed (int) X CS (CardSet)
/*
El predicado cardsSet/5 toma cinco argumentos:
- Cards es una lista de valores de cartas (enteros en el rango 1-12)
- Elementos es una lista de símbolos de elementos (por ejemplo, 'Fuego', 'Agua', 'Tierra', 'Aire')
- NumE es el número de elementos del conjunto (debe ser mayor que cero)
- MaxC es el número máximo de cartas por elemento (debe ser mayor o igual que cero)
- Seed es un entero positivo, utilizada para inicializar el generador de números aleatorios

Este predicado tiene éxito si la lista de valores de las cartas satisface las siguientes condiciones
- Hay 12 elementos en el conjunto
- El número de elementos es mayor que cero
*/

cardsSett(Cards, Elements, NumE, MaxC, Seed) :-
    length(Cards, 12),
    NumE > 0,
    foreach(member(Card, Cards), cardsInSet(Card, Elements, NumE, MaxC)),
    initRand(Seed).

%cardsSet([1,2,3,4,5,6,7,8,9,10,11,12], ['Fuego', 'Agua', 'Tierra', 'Aire'], 4, 2, 1). 

cardsInSet(_, [], _, _).
cardsInSet(Card, [Element|Elements], NumE, MaxC) :-
    cardsOfElement(Element, NumE, Cards),
    member(Card, Cards),
    length(Cards, NumC),
    NumC =< MaxC,
    cardsInSet(Card, Elements, NumE, MaxC).


cardsOfElement(_, 0, []).
cardsOfElement(Element, NumE, [Element|Cards]) :-
    NumE > 0,
    NewNumE is NumE - 1,
    cardsOfElement(Element, NewNumE, Cards).



cardsSet(Cards, Elements, NumE, MaxC, Seed) :-
    length(Cards, 12),
    length(Elements, 12),
    NumE > 0,
    MaxC >= 0,
    Seed > 0.

%cardsSet([1,2,3,4,5,6,7,8,9,10,11,12], [a,b,c,d,e,f,g,h,i,j,k,l], 3, 6, 7).
%cardsSet([1,2,3,4,5,6,7,8,9,10,11,12], ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'], 12, 12, 1).
/*
El predicado sample/7 toma seis argumentos:
- List, es la lista de la que se extrae la muestra
- Sample, es la lista resultante de los elementos muestreados
- N es el número de elementos a muestrear (debe ser mayor que cero)
- M es el número máximo de elementos por lista (debe ser mayor o igual que cero)
- Seed, es una entero positivo utilizada para inicializar el generador de números aleatorios
- Acc es una lista de acumuladores utilizada para llevar la cuenta de los elementos muestreados (debe estar inicialmente vacía)

Este predicado tiene éxito si la lista de valores de la carta satisface las siguientes condiciones:
- Hay 12 elementos en el conjunto
- El número de elementos es mayor que cero
- El número máximo de cartas por
*/
sample(List, Sample, N, M, Seed) :-
    length(List, L),
    N > 0,
    M >= 0,
    Seed > 0,
    random_member(X, List, Seed),
    sample(List, Sample, N, M, 1, L, [X]).

sample(_, [], _, M, K, _, _) :-
    K =:= M+1.

sample(List, Sample, N, M, K, L, [X|Acc]) :-
    K < M+1,
    K1 is K+1,
    %random_member(X, List, Seed),
    sample(List, Sample, N, M, K1, L, [X|Acc]).

 random_member(X, List, Seed) :-
    length(List, L),
    Seed > 0,
    random(0, L, I),
    nth0(I, List, X).


/*
El predicado cardsSetIsDobble/1 toma un argumento:
- Cards es una lista de valores de cartas (enteros en el rango 1-12)

Este predicado tiene éxito si la lista de valores de las cartas satisface la siguiente condición:
- Cada elemento de la lista aparece exactamente dos veces
*/

cardsSetIsDobble(Cards) :-
    length(Cards, 12),
    foreach(member(Card, Cards), cardsSetIsDobble(Card, Cards)).

cardsSetIsDobble(_, []).
cardsSetIsDobble(Card, [Card|Cards]) :-
    delete(Cards, Card, NewCards),
    cardsSetIsDobble(Card, NewCards).

%cardsSetIsDobble([1,2,3,4,5,6,7,8,9,10,11,12]).
%cardsSetIsDobble([1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12]).


/*
El predicado elemento_diferente/2 toma dos argumentos:
- Elemento es un símbolo de elemento (por ejemplo, 'Fuego', 'Agua', 'Tierra', 'Aire')
- Card es una lista de valores de la carta (enteros en el rango 1-12)

Este predicado tiene éxito si el elemento no aparece en la lista de cartas.
*/

different_element(Element, Card) :-
    maplist(different_element_helper(Element), Card).

different_element_helper(_, []).
different_element_helper(Element, [H|T]) :-
    dif(Element, H),
    different_element_helper(Element, T).


/*
El predicado cardsSetNthCard/3 toma tres argumentos:
- N es el índice de la carta a recuperar (debe ser mayor o igual que cero y menor que la longitud de la lista de Cards)
- Cards es una lista de valores de Cards (enteros en el rango 1-12)
- card es el valor de la carta resultante (entero en el rango 1-12)

Este predicado tiene éxito si Card es el elemento N de la lista Cards.
*/

cardsSetNthCard(N, Cards, Card) :-
    length(Cards, L),
    N >= 0,
    N < L,
    nth0(N, Cards, Card).


/*
El predicado cardsSetFindTotalCards/2 toma dos argumentos:
- Card es una lista de valores de Cards (enteros en el rango 1-12)
- Total es el número resultante de cartas en el conjunto (debe ser mayor o igual que cero)

Este predicado tiene éxito si el Total es el número de cartas del conjunto que puede formarse con la lista Card.
*/

cardsSetFindTotalCards(Card, Total) :-
    length(Card, L),
    Total is (2^L)-1.


/*
El predicado cardsSetMissingCards/2 toma dos argumentos:
- Cards es una lista de valores de cartas (enteros en el rango 1-12)
- Missing es una lista de cartas que no están en el conjunto (debe estar inicialmente vacía)

Este predicado tiene éxito si la lista Missing contiene todas las cartas que no están en el conjunto.
*/

cardsSetMissingCards(Cards, Missing) :-
    findall(Card, (member(Card, Cards), not(cardsSetIsDobble([Card|Cards]))), Missing).


/*
El predicado cardsSetToString/2 toma dos argumentos:
- Cards es una lista de valores de cartas (enteros en el rango 1-12)
- String es la cadena resultante de valores de Card separados por comas

Este predicado tiene éxito si la cadena es la lista de valores de cartas separada por comas.
*/

cardsSetToString(Cards, String) :-
    maplist(card_to_string, Cards, Strings),
    atomic_list_concat(Strings, ',', String).

%cardsSet([1,2,3,4,5,6,7,8,9,10,11,12], [a,b,c,d,e,f,g,h,i,j,k,l], 3, 6, 7), cardsSetToString(  CS, CS_STR). 

/*
El predicado card_a_cadena/2 toma dos argumentos:
- Card es un número entero en el rango 1-12
- String es la representación de cadena resultante del valor de la carta

Este predicado tiene éxito si la cadena es la representación en cadena de la carta.
*/
card_to_string(Card, String) :-
    atomic_list_concat(Card, '', String).


/*
El predicado dobbleGame/5 toma cinco argumentos:
- Players es una lista de nombres de jugadores
- Cards es una lista de valores de cartas (enteros en el rango 1-12)
- Mode es el modo de juego ('aleatorio' o 'secuencial')
- Seed es un entero positivo utilizado para inicializar el generador de números aleatorios
- Game es el estado del juego resultante

Este predicado tiene éxito si el juego se inicializa con los parámetros dados.
*/

dobbleGame(Players, Cards, Mode, Seed, Game) :-
    length(Players, P),
    P > 0,
    cardsSetIsDobble(Cards),
    member(Mode, ['aleatorio', 'secuencial']),
    game_init(Players, Cards, Mode, Seed, Game).

%cardsSet([1,2,3,4,5,6,7,8,9,10,11,12], 3, 3, 92175, CS),  dobbleGame( 4, CS, “modoX”, 4222221, G).

El predicado game_init/5 toma cinco argumentos:
- Players es una lista de nombres de jugadores
- Cards es una lista de valores de cartas (enteros en el rango 1-12)
- Mode es el modo de juego ('aleatorio' o 'secuencial')
- Seed es una semilla entera positiva utilizada para inicializar el generador de números aleatorios
- game es el estado del juego resultante, luego es tomado por una lista.

Este predicado tiene éxito si el juego se inicializa con los parámetros dados.
*/
game_init(Players, Cards, Mode, Seed, game(Players, Cards, Mode, Seed, [], 0)).


/*
El predicado dobbleGameRegister/3 toma tres argumentos:
- Usuario es el nombre del jugador a registrar
- game(Players, Cards, Mode, Seed, Acc, N) es el estado del juego antes del registro
- game(Players, Cards, Mode, Seed, [user(User)|Acc], N1) es el estado del juego resultante después del registro

Este predicado tiene éxito si el usuario está registrado y el estado del juego se actualiza en consecuencia.
*/

dobbleGameRegister(User, game(Players, Cards, Mode, Seed, Acc, N), game(Players, Cards, Mode, Seed, [user(User)|Acc], N1)) :-
    not(member(user(_), Acc)),
    length(Players, P),
    P > N,
    N1 is N+1.

%cardsSet([1,2,3,4,5,6,7,8,9,10,11,12], [a,b,c,d,e,f,g,h,i,j,k,l], 3, 6, 7),  dobbleGame( 4, CS, 'modoX' 4222221, G), dobbleGameRegister( 'user1', G_orig, G).

/*
El predicado dobbleGameWhoseTurnIsIt/2 toma dos argumentos:
- game(Players, Cards, Mode, Seed, Users, N) es el estado del juego
- user(User) es el nombre del jugador resultante

Este predicado tiene éxito si es el turno del jugador con el nombre dado.
*/

dobbleGameWhoseTurnIsIt(game(_, _, _, _, Users, N), user(User)) :-
    nth0(N, Users, user(User)).

dobbleGameWhoseTurnIsIt(game(Players, _, _, _, _, N), user(User)) :-
    nth0(N, Players, user(User)).