using System.Net.WebSockets;
using System.Text;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseWebSockets();

var webSocketConnections = new List<WebSocket>();

app.Map("/", async context =>
{
    if (context.WebSockets.IsWebSocketRequest)
    {
        using var webSocket = await context.WebSockets.AcceptWebSocketAsync();
        webSocketConnections.Add(webSocket);

        var buffer = new byte[1024 * 4];

        while (webSocket.State == WebSocketState.Open)
        {
            var result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);

            if (result.MessageType == WebSocketMessageType.Text)
            {
                var message = Encoding.UTF8.GetString(buffer, 0, result.Count);
                var split = message.Split(':', 2);
                var clientId = split.Length > 1 ? split[0].Trim() : "Desconocido";
                var content = split.Length > 1 ? split[1].Trim() : message;

                Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] Mensaje de {clientId}: {content}");


                foreach (var socket in webSocketConnections.Where(s => s.State == WebSocketState.Open))
                {
                    var outgoing = Encoding.UTF8.GetBytes(message);
                    await socket.SendAsync(new ArraySegment<byte>(outgoing), WebSocketMessageType.Text, true, CancellationToken.None);
                }
            }
            else if (result.MessageType == WebSocketMessageType.Close)
            {
                webSocketConnections.Remove(webSocket);
                await webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Cerrado", CancellationToken.None);
            }
        }
    }
    else
    {
        context.Response.StatusCode = 400;
    }
});

app.Run();