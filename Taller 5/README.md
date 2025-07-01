**Explicacion del código:**
El programa simula la estructura solicitada, con el detalle de que la tienda y clientes son ambientados en el juego pokemon, 
debido a que personalmente tengo un mejor entendimiento del codio que creo al asociarlo a videojuegos o series, es un pasatiempo propio.

La clase pedido almacena la informacion del cliente, su nombre, ID y el pedido solicitado.
En el main se crea una cola de pedidos utilizando blocking collection basada en los datos obtenidos de la clase pedido de tal manera que varios hilos puedan acceder sin problemas.
Para esa clase, utilizando arrays se rellenan los datos. En una se guardan los tipos de productos, y en otra los entrenadores.
Se define un total de pedidos maximo que sera 20, u se inizializan las variables de los pedidos que se han procesado y los ids de los pedidos.

Se crea un task el cual, utilizando un for, definimos cuantos npcs pueden atender a los entrenadores, los cuales definimos como unicamente 2 npcs. 
Utilizando take, los diferentes entrenadores que sean generados seran tomados por uno de los npcs para ser atendidos. 
Si los npcs estan ocupados, los entrenadores se bloquean en espera hasta que sean atendidos, para que no hayan choques o "entrenadores de mas en un unico NPC". 
Finalmente, una vez se cumplen los 20 pedidos, los cuales se van expresando a traves de mensajes, se imprime un mensaje final que confirma que se ha ealizado el total de 20 pedidos que permitimos



**Justificacion del uso de colecciones concurrentes y atomicos**
Las colecciones concurrentes y atomicas son utilizadas en este programa para garantizar que los datos compartidos entre múltiples hilos se manejen de manera segura y eficiente. 
En un entorno multihilo, es crucial evitar condiciones de carrera y asegurar que las operaciones sobre los datos sean atómicas, es decir, que se completen sin interrupciones.
Estas se pueden ver en el uso de la clase BlockingCollection, que permite que múltiples hilos puedan agregar y quitar elementos de manera segura sin necesidad de bloqueos manuales.



**Posibles problemas evitados gracias a la sincronizacion implicita**
Gracias a la sincronización implícita proporcionada por las colecciones concurrentes, se evitan varios problemas comunes en programación multihilo.
Por ejemplo se evitan condiciones de carrera, donde dos o más hilos intentan modificar el mismo dato al mismo tiempo, lo que podría llevar a resultados inconsistentes.
Tambien evitamos que sucedan los deadlocks, donde dos o más hilos se bloquean mutuamente esperando recursos que nunca se liberan.
Y finalmente, se evita la sobrecarga de gestión de bloqueos manuales, lo que simplifica el código y reduce la posibilidad de errores.
