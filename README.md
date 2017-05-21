# topdowncar
1er TP de Desarrollo de Videojuegos 2D en iPhone OS

## Source code
El funcionamiento del auto fue tomado de la siguiente implementacion:
* [top-down-car](http://www.iforce2d.net/b2dtut/top-down-car) - code

## Comentarios

* El auto esta formado por lo que se llama Tire en la implementacion antes mencionada.
* Sobre la superficie Grass el auto reduce su velocidad. Sobre el resto del camino, su velocidad retorna a la normal.
* Para poder calcular las vueltas sobre el circuito, se utilizaron checkpoints, los cuales no son visibles y estan en distintas partes del camino. El auto debe pasar por todos ellos para completar una vuelta.
* La camara siempre toma la posicion del auto.
* El timer, el contador de vueltas y los botones actualizan su posicion en base a la posicion de la camara.
* Una vez completadas las 3 vueltas, se muestra en pantalla la palabra "WINNER!!!".
