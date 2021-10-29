# Práctica de Generador de Código Intermedio

> Sentencias Básicas

1. Suponga una sentencia que calcula el promedio de una lista de expresiones y se lo asigna a un identificador. La sintaxis está representada con las  siguientes reglas gramaticales:

A → id := P

P → prom ( L )

L → L , E | E

E → E + T | E – T | T

T → T * F | T / F | F

F → id | cte | ( E )

Representar la sentencia `a:= prom ( a+b, 3, c*(d-a) )`

a) En polaca inversa

b) En árbol sintáctico

c) En tercetos

d) Escribir las acciones semánticas en cada regla para generar código en cada una de las notaciones

Toda la semántica debe sea resuelta en cada intermedia.

2. Sea la gramática del ejercicio de la [práctica 2](https://github.com/luvitale/lyc_p2_syntactic_analyzer) que resuelve la asignación múltiple.
Representar la sentencia `actual := promedio := contador := promedio/342 + (contador*contador);`

a) En polaca inversa

b) En árbol sintáctico

c) En tercetos

d) Escribir las acciones semánticas en cada regla para generar código en cada una de las notaciones

Toda la semántica debe sea resuelta en cada intermedia.