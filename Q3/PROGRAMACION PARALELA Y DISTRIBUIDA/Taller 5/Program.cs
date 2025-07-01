using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;

namespace Taller_5
{
    class Program
    {
        class Pedido
        {
            public int Id { get; }
            public string Entrenador { get; }
            public string Pokebola { get; }

            public Pedido(int id, string entrenador, string pokebola)
            {
                Id = id;
                Entrenador = entrenador;
                Pokebola = pokebola;
            }
        }

        static void Main(string[] args)
        {
            var colaPedidos = new BlockingCollection<Pedido>();
            string[] tiposPokebolas = { "Poké Ball", "Great Ball", "Ultra Ball", "Master Ball" };
            string[] entrenadores = { "Ash", "Misty", "Brock", "May", "Serena" };
            int totalPedidos = 20;
            int pedidosProcesados = 0;
            int idPedido = 0;
            object idLock = new object();


            Task[] productores = new Task[2];
            for (int i = 0; i < productores.Length; i++)
            {
                productores[i] = Task.Run(() =>
                {
                    Random rnd = new Random();
                    while (true)
                    {
                        int idActual;
                        lock (idLock)
                        {
                            if (idPedido >= totalPedidos)
                                break;
                            idActual = idPedido++;
                        }

                        string entrenador = entrenadores[rnd.Next(entrenadores.Length)];
                        string pokebola = tiposPokebolas[rnd.Next(tiposPokebolas.Length)];

                        Pedido nuevoPedido = new Pedido(idActual, entrenador, pokebola);
                        colaPedidos.Add(nuevoPedido);
                        Console.WriteLine($"{entrenador} hizo un pedido de {pokebola} (ID: {idActual})");
                        Thread.Sleep(rnd.Next(300, 800));
                    }
                });
            }

            // CONSUMIDORES: NPCs
            Task[] consumidores = new Task[2];
            for (int i = 0; i < consumidores.Length; i++)
            {
                int npcId = i + 1;
                consumidores[i] = Task.Run(() =>
                {
                    while (!colaPedidos.IsCompleted)
                    {
                        Pedido pedido;
                        try
                        {
                            pedido = colaPedidos.Take();
                        }
                        catch (InvalidOperationException)
                        {
                            break; 
                        }

                        Console.WriteLine($"NPC{npcId} procesando pedido {pedido.Id} de {pedido.Entrenador} ({pedido.Pokebola})");
                        Thread.Sleep(1000);
                        int total = Interlocked.Increment(ref pedidosProcesados);
                        Console.WriteLine($"Pedido {pedido.Id} completado por NPC{npcId}. Total procesados: {total}");
                    }
                });
            }


            Task.WaitAll(productores);
            colaPedidos.CompleteAdding(); 


            Task.WaitAll(consumidores);

            Console.WriteLine("\nTodos los pedidos han sido procesados. ¡Gracias por usar PokéStore!");
        }
    }
}
