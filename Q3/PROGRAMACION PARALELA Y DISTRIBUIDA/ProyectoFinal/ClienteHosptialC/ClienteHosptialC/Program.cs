using System;
using System.IO;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

class TcpTurnClient
{
    /*
    Cada vez que enviamos un comando, creamos una nueva conexión TCP, el servidor se encarga de cerrarlas cada vez que recibe un comando,
    interpretando que cada solicitud es una transacción independiente.
    */
    static async Task<string> SendAsync(string host, int port, string command)
    {
        using var client = new TcpClient();
        //Se crea una nueva conexión TCP al servidor especificado, la cual se cierra automaticamente cuando se termina de usar el objeto `TcpClient`.

        await client.ConnectAsync(host, port);
        //Se intenta la conexion al servidor TCP
        using NetworkStream stream = client.GetStream();
        //Stream se encarga de enviar y recibir datos a traves de la conexion

        byte[] outBytes = Encoding.UTF8.GetBytes(command);
        await stream.WriteAsync(outBytes, 0, outBytes.Length);
        //Se obtienen los datos y se convierten en bytes, para luego ser enviados al servidor

        using var ms = new MemoryStream();
        var buffer = new byte[2048];
        int read;
        while ((read = await stream.ReadAsync(buffer, 0, buffer.Length)) > 0)
            ms.Write(buffer, 0, read);
        /*
        Este bloque se encarga de leer indefinidamente los datos que reciba el cliente
        hasta que obtenga finalmente su respuesta, la cual se almacena en el ms.Write
        */

        return Encoding.UTF8.GetString(ms.ToArray()).Trim();
        //Finalmente se convierte el resultado de la respuesta del servidor a texto y se imprime mas adelante
    }

    // Construcción de comandos
    static string BuildSolicitar(string cliente, bool emergencia, string descripcion)
        => $"SOLICITAR|{cliente}|{emergencia}|{descripcion}";
    static string BuildPosicion(int id)
        => $"POSICION|{id}";

    //Estos dos se encargan de construir los comandos de la manera que el servidor espera recibirlos.

    static async Task Main()
    {
        string host = "127.0.0.1"; 
        int port = 9000;

        Console.WriteLine($"Cliente TCP — {host}:{port}");

        while (true)
        {
            Console.WriteLine("Bienvenido al cliente principal del hospital a traves de TCP! a continuacion estan los comandos disponibles:");
            Console.WriteLine("  1) Crear tiquete");
            Console.WriteLine("  2) Consultar posición");
            Console.WriteLine("  0) Salir");
            Console.Write("Opción: ");
            var opt = Console.ReadLine();

            if (opt == "0" || opt?.Equals("salir", StringComparison.OrdinalIgnoreCase) == true)
                break;

            try
            {
                switch (opt)
                {
                    case "1":
                        Console.Write("Nombre del cliente: ");
                        var cliente = Console.ReadLine() ?? "";
                        Console.Write("Descripción/motivo: ");
                        var desc = Console.ReadLine() ?? "";
                        Console.Write("¿Emergencia? (s/n): ");
                        var emerg = Console.ReadLine();
                        bool isEmerg = emerg != null && emerg.Trim().StartsWith("s", StringComparison.OrdinalIgnoreCase);

                        var cmd1 = BuildSolicitar(cliente, isEmerg, desc);
                        var resp1 = await SendAsync(host, port, cmd1);
                        Console.WriteLine("> " + resp1);
                        break;

                    case "2":
                        Console.Write("ID del tiquete: ");
                        var idtxt = Console.ReadLine();
                        if (!int.TryParse(idtxt, out int id2))
                        {
                            Console.WriteLine("ID inválido.\n");
                            break;
                        }
                        var cmd2 = BuildPosicion(id2);
                        var resp2 = await SendAsync(host, port, cmd2);
                        Console.WriteLine("> " + resp2);
                        break;

                    default:
                        Console.WriteLine("Opción no válida.\n");
                        break;
                }
            }
            catch (SocketException ex)
            {
                Console.WriteLine("No se pudo conectar al servidor TCP: " + ex.Message + "\n");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message + "\n");
            }
        }
    }
}
