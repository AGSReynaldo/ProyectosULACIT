using System;
using System.Net; //Este system es necesario para IPEndPoint y IPAddress
using System.Net.Sockets; // Este system es necesario para UdpClient
using System.Text; // Este system es necesario para Encoding
using System.Threading; // Este system es necesario para utilizar Thread

class Program
{
    static UdpClient servidor; // Se declara el servidor UDP como una variable para poder recibir mensajes en un hilo definido mas adelante
    static IPEndPoint ultimoCliente = null; // Se guarda la IP y puerto del último cliente que envió un mensaje

    static void Main()
    {

        int puerto = 5000; // en este puerto es donde se recibe la informacion del cliente, si no son iguales, no se recibira la informacion
        servidor = new UdpClient(puerto);  // Crea un servidor UDP que escucha en el puerto especificado
        Console.WriteLine($"Servidor UDP en C# escuchando en el puerto {puerto}..."); // Este mensaje muestra en cual puerto se esta escuchando
                                                                                      
        Thread hiloRecepcion = new Thread(RecibirMensajes); // Crea un hilo para recibir mensajes de los clientes
        hiloRecepcion.Start();

        // Aqui inicia un bucle para enviar mensajes, donde se espera que primero se reciba un mensaje de un cliente antes de poder enviar uno de vuelta
        while (true)
        {
            string mensajeEnviar = Console.ReadLine(); // Lee un mensaje del usuario desde la consola

            if (ultimoCliente != null) // Verifica si se ha recibido al menos un mensaje de un cliente
            {
                byte[] datosEnviar = Encoding.UTF8.GetBytes(mensajeEnviar); // Convierte el mensaje a un arreglo de bytes para enviarlo
                servidor.Send(datosEnviar, datosEnviar.Length, ultimoCliente); // Envía el mensaje al último cliente que envió un mensaje
            }
            else
            {
                Console.WriteLine("Aún no se ha recibido ningún mensaje de un cliente. No se puede enviar.");// Si no se ha recibido un mensaje de un cliente, no se puede enviar nada
            }
        }
    }



    static void RecibirMensajes()
        {
        while (true)
        {
            IPEndPoint clienteRemoto = new IPEndPoint(IPAddress.Any, 0); // Aqui se crea un punto final para el cliente remoto, que es necesario para recibir datos. Obtiene la IP del dispositivo automaticamente
            byte[] datos = servidor.Receive(ref clienteRemoto); // la funcion servidor.receive espera recibir datos del cliente remoto y los almacena en la variable datos
            string mensaje = Encoding.UTF8.GetString(datos); // convierte los datos que se recibieron en un string, ya que los datos se reciben en formato byte[]

            ultimoCliente = clienteRemoto; //Se guarda el ultimo cliente

            if (mensaje == "FIN")
            {
                servidor.Close(); // Cierra el UdpClient
                Environment.Exit(0); //Cierra por completo la consola
            }
            Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] Mensaje de {clienteRemoto}: {mensaje}"); // finalmente se imprime el mensaje recibido.
        }
    }
}

