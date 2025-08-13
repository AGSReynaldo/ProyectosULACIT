using System;
using System.Net;
using System.Net.Sockets;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Concurrent;

enum TurnType { General, Emergencia }

sealed record Turn(int Id, string Cliente, TurnType Tipo, string Descripcion);
// sealed record lo que hace es almacenar datos que no cambien, es util para casos como
//este programa donde una solicitud de tiquete no se desea cambiar o alterar una vez creada.
class Program
{
    static readonly BlockingCollection<Turn> normalQueue = new(new ConcurrentQueue<Turn>());
    static readonly BlockingCollection<Turn> emergencyQueue = new(new ConcurrentQueue<Turn>());
    //se utiliza blocking collection y concurrent queue para manejar colas en 
    //multiples hilos de manera segura, evitando problemas de concurrencia
    static readonly ConcurrentDictionary<int, Turn> pendingTurns = new();
    //El diccionario almacena los turnos pendientes a partir de su ID.
    static int nextTurnId = 0;
    //Es el numero contador que se utiliza para asignar ID a cada turno.

    static readonly ConcurrentQueue<Turn> attendedTurns = new ConcurrentQueue<Turn>();
    //Aqui se almacenan los turnos que ya han sido atendidos, para poder revisarlos en el historial

    // Puertos
    const int TcpPort = 9000;
    //El puerto TCP para hacer uso del codigo desde un codigo C#
    const int WsPort = 9001;
    //Puerto WebSocket para poder usar el codigo desde un codigo para HTML en un navegador

    static async Task HandleTcpClientAsync(TcpClient client)
    {
        using var c = client;
        var stream = c.GetStream();
        var buffer = new byte[2048];
        int read = await stream.ReadAsync(buffer, 0, buffer.Length);
        if (read <= 0) return;

        string req = Encoding.UTF8.GetString(buffer, 0, read).Trim();
        string resp = ProcessCommand(req);

        var bytes = Encoding.UTF8.GetBytes(resp);
        await stream.WriteAsync(bytes, 0, bytes.Length);
        /*
        Todo este metodo se encarga de leer la informacion del cliente,
        recibiendola como bytes, y despues decodifica dichos bytes y los convierte 
        en texto, para finalmente enviar la respuesta
        */
    }
    /* 
    este metodo es necesario porque es el que maneja toda la logica de las conexiones TCP, de no existir, no se podrian recibir
    correctamente las conexiones TCP, y nunca se podrian responder, todos los clientes quedarian colgados.
    */

    static async Task AcceptWebSocketsAsync(HttpListener http)
    {
        while (true)
        {
            var ctx = await http.GetContextAsync();
            if (!ctx.Request.IsWebSocketRequest)
            {
                ctx.Response.StatusCode = 400;
                ctx.Response.Close();
                continue;
            }

            var wsCtx = await ctx.AcceptWebSocketAsync(null);
            _ = HandleWebSocketAsync(wsCtx.WebSocket);
            //Este metodo lo unico que hace es aceptar conexiones, y los envia
            //al metodo de abajo para decodificarlos
        }
    }
    /*
    Este metodo tiene el papel de aceptar las conexiones Web Socket, de no ser por si mismo, los clientes de Web Socket no podrian 
    enviar su informacion al servidor.
    */

    static async Task HandleWebSocketAsync(WebSocket ws)
    {
        var buffer = new byte[2048];
        var seg = new ArraySegment<byte>(buffer);

        while (ws.State == WebSocketState.Open)
        {
            var result = await ws.ReceiveAsync(seg, CancellationToken.None);
            if (result.MessageType == WebSocketMessageType.Close)
            {
                await ws.CloseAsync(WebSocketCloseStatus.NormalClosure, "Cierre by client", CancellationToken.None);
                break;
            }

            string req = Encoding.UTF8.GetString(buffer, 0, result.Count).Trim();
            string resp = ProcessCommand(req);

            var respBytes = Encoding.UTF8.GetBytes(resp);
            await ws.SendAsync(new ArraySegment<byte>(respBytes), WebSocketMessageType.Text, true, CancellationToken.None);
            //Este metodo se encarga de recibir mensajes del cliente WebSocket, y responderlos debidamente
        }
    }
    /*
    Tiene una funcion similar al metodo de TCP, por lo que si no estuviera, se aceptarian las conexiones del Web Socket, mas no 
    Se recibirian sus respuestas.
    */

    static string ProcessCommand(string raw)
    {
        var parts = raw.Split('|', StringSplitOptions.None);
        return parts[0] switch
        {
            "SOLICITAR" => CmdSolicitar(parts),
            "POSICION" => CmdPosicion(parts),
            _ => "ERROR|Comando desconocido"
        };
    }
    //Este metodo es el encargado de procesar los comandos que recibe el servidor, y
    //elegir la funcion correcta segun sea el comando

    static string CmdSolicitar(string[] p)
    //Todo este metodo es el encargado de interpretar los comandos del cliente de solicitar un turno
    {
        if (p.Length < 4) return "ERROR|Faltan parámetros";

        string cliente = p[1];
        bool isEmergency = bool.TryParse(p[2], out var em) && em;
        var tipo = isEmergency ? TurnType.Emergencia : TurnType.General;
        string desc = p[3];
        //Aqui el servidor recibe el parametro del cliente, donde si el resultado
        // es verdadero, se interpreta como una solicitud de emergencia, sino una situacion general

        int id = Interlocked.Increment(ref nextTurnId);
        //Se genera el ID del turno 
        var turno = new Turn(id, cliente, tipo, desc);
        pendingTurns[id] = turno;
        //Se crea un nuevo turno con el ID generado y se almacena en el diccionario que creamos anteriormente

        (isEmergency ? emergencyQueue : normalQueue).Add(turno);
        //Si es un turno de emergencia, se agrega a la cola de emergencia, de ser lo contrario lo agrega a la cola normal

        Console.WriteLine($"Se ha generado un nuevo turno! ID:{id} | Cliente:{cliente} | Tipo:{tipo} | Desc:{desc}");
        //Se imprime en la consola del servidor el turno que se ha solicitado
        int pos = GetQueuePosition(id);
        return $"El nuevo turno fue solicitado!: ID: {id} | Posición:{pos}";
        //Se calcula la posicion del turno y se devuelve la respuesta al cliente.
    }

    static string CmdPosicion(string[] p)
    {
        if (p.Length != 2 || !int.TryParse(p[1], out int id)) return "ERROR, Parámetros inválidos";
        if (!pendingTurns.ContainsKey(id)) return "ERROR, Turno no encontrado";

        int pos = GetQueuePosition(id);
        return $"El turno con ID: {id}   Se encuentra en la posición:{pos}";
        //Metodo que recibe el ID del turno y si lo encuentra, entrega su posicion, 
        //en caso contrario, devuelve un error.
    }

    static int GetQueuePosition(int id)
    {
        var emerg = emergencyQueue.ToArray();
        var norm = normalQueue.ToArray();

        int i = Array.FindIndex(emerg, t => t.Id == id);
        if (i >= 0) return i + 1;

        int j = Array.FindIndex(norm, t => t.Id == id);
        if (j >= 0) return emerg.Length + j + 1;

        return -1;
    }
    /*
    El metodo es el que realiza como tal la accion de contar en que posicion de la cola
    esta cada turno, Si esta en la cola de emergencia, devuelve su posicion segun la cola de emergencia,
    de ser de la cola general, lo que se hace es sumar la cantidad de turnos de emergencia
    Y luego se empieza a contar cual es la posicion del turno en la cola general
    */

    static Turn? DequeueNextTurn()
    {
        if (emergencyQueue.TryTake(out var t, TimeSpan.Zero))
        {
            pendingTurns.TryRemove(t.Id, out _);
            attendedTurns.Enqueue(t); 
            return t;
        }
        if (normalQueue.TryTake(out t, TimeSpan.Zero))
        {
            pendingTurns.TryRemove(t.Id, out _);
            attendedTurns.Enqueue(t); 
            return t;
        }
        return null;
    }
    /*
    El metodo es el que se enecarga de hacer la funcion "atender", donde primero intenta 
    atender al primer turno que haya en la cola de emergencia, y si no hay turnos en esa cola,
    intenta atender al primer turno de la cola normal, y si no hay turnos en ninguna de las dos colas,
    devuelve valor nulo significando que ya no hay turnos pendientes. No solo eso, sino que tambien
    al atender a un paciente, lo agrega a la lista de turnos atendidos, para que luego se pueda consultar
    */

    static void HandleServerCommands()
    {
        while (true)
        {
            var cmd = Console.ReadLine();
            if (cmd == null) continue;

            if (cmd.Equals("atender", StringComparison.OrdinalIgnoreCase))
            {
                var next = DequeueNextTurn();
                Console.WriteLine(next is not null
                    ? $"[Atendiendo] Turno con ID: {next.Id} de {next.Cliente} ({next.Tipo}) - {next.Descripcion}"
                    : "[Atender] No hay turnos pendientes.");
            }
            else if (cmd.Equals("historial", StringComparison.OrdinalIgnoreCase)) 
            {
                var list = attendedTurns.ToArray();
                if (list.Length == 0)
                {
                    Console.WriteLine("[Historial] No hay turnos atendidos aún.");
                }
                else
                {
                    Console.WriteLine($"[Historial] Total atendidos: {list.Length}");
                    foreach (var t in list)
                        Console.WriteLine($"  - ID:{t.Id} | Cliente:{t.Cliente} | Tipo:{t.Tipo} | Desc:{t.Descripcion}");
                }
                /*
                Aqui es donde el servidor analiza los comandos que se escriben, y ejecutan las funciones 
                mencionadas anteriormente, en este caso, se encuentra la funcion de atender
                que como menciona su nombre, atiende el siguiente turno pendiente, y la funcion historial,
                la cual nos mostrara un historial de todos los turnos que han sido atendidos.
                */
            }
        }
    }

    static async Task Main()
    {
        var tcp = new TcpListener(IPAddress.Any, TcpPort);
        tcp.Start();
        Console.WriteLine($"[Servidor] TCP en {TcpPort}…");
        //Se inicializa el servidor en el puerto TCP 

        _ = Task.Run(async () =>
        {
            while (true)
            {
                var client = await tcp.AcceptTcpClientAsync();
                _ = HandleTcpClientAsync(client);
            }
        });
        //se inicia un bucle que acepta conexiones entrantes y las envia al manejador de clientes TCP
        //en un hilo separado, permitiendo que mas clientes se conecten aun cuando hay clientes en espera


        var http = new HttpListener();
        http.Prefixes.Add($"http://*:{WsPort}/ws/");
        http.Start();
        Console.WriteLine($"[Servidor] WebSocket en http://*:{WsPort}/ws/ …");
        _ = Task.Run(() => AcceptWebSocketsAsync(http));
        //Se inicializa el servidor HTTP para WebSockets, asi podremos escuchar
        //las conexiones que nos entren desde el cliente creado con HTML/en el navegador

        Console.WriteLine("\n Bienvenido al servidor principal del hospital, a continuacion estan los comandos disponibles:");
        Console.WriteLine("\n Escribir: 'atender'  >  Atiende el siguiente turno");
        Console.WriteLine("Escribir: 'historial'  >  Ver todos los turnos atendidos");
        Console.WriteLine("'Ctrl + C'  >  Cierra el servidor");

        _ = Task.Run(HandleServerCommands);
        //Esta tarea se encarga de recibir y manejar los comandos que s escriban en el servidor,
        //como el comando que designamos de atender turnos

        await Task.Delay(Timeout.Infinite);
    }//Hace que el servidor se mantenga en ejecución indefinidamente, hasta que el usuario lo cierre

    /*
    Este main configurado asi es necesario debido a que es el que organiza el arranque de los servidores, y sus hilos,
    ademas de amntenerse en un bucle inifnito, de no estar configurado asi, el servidor no escucharia
    conexiones o se cerraria solo
    */
}
