Este proyecto es una implementación de un servidor WebSocket usando ASP.NET Core en C# y dos clientes web (HTML) que se conectan al servidor, envían mensajes automáticamente y reciben mensajes retransmitidos entre sí.

La meta es simular una arquitectura cliente-servidor con múltiples clientes conectados por WebSocket. 
Cada cliente envía mensajes identificados y el servidor los retransmite a todos los conectados. 
El sistema está diseñado como una base para aplicaciones de chat, monitoreo en tiempo real u otros sistemas distribuidos.
Se intento utilizar replit para la configuracion del codigo, sin embargo, personalmente no fui capaz de crear un servidor en replit, cada vez que intentaba crearlo,
el asistente de replit era la unica manera en la que podia crear codigos, por lo que realmente me confundi a la hora de intentar la ejecucion, por lo que el codigo esta
trabajado mayormente desde Visual Studio y utilizando Microsoft Edge a la hora de abrir los clientes.

 El servidor recibe mensajes con identificadores como: Cliente01: Mensaje 1
para representar los mensajes automaticos solicitados en las instrucciones, igualmente el usuario puede escribir sus propios mensajes en los clientes

para correr el codigo se debe correr primero en visual studio, esto abrira la consola y un url en edge, el cual es como el que funciona como servidor, mas no lector
no se debe cerrar la pestaña que se abre en edge o sino el codigo se cerrara, luego, vamos a los archivos de los clientes y los abrimos, de ahi se abrira una
ventana que permitira enviar mensajes, y mostrara mensajes recibidos tanto en el cliente como la consola.
