package clienteudp_java;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Scanner;

public class ClienteUDP_Java {
    public static void main(String[] args) {
        try (
            DatagramSocket socket = new DatagramSocket(5001); 
            Scanner scanner = new Scanner(System.in)
        ) {
            InetAddress ipServidor = InetAddress.getByName("10.0.16.202");
            int puertoServidor = 5000;

            // Hilo para recibir mensajes
            Thread receptor = new Thread(() -> {
                byte[] buffer = new byte[1024];
                while (true) {
                    try {
                        DatagramPacket paquete = new DatagramPacket(buffer, buffer.length);
                        socket.receive(paquete);
                        String mensaje = new String(paquete.getData(), 0, paquete.getLength(), "UTF-8");
                        System.out.println("\n[Recibido] " + mensaje);
                        System.out.print("> ");
                    } catch (Exception e) {
                        break;
                    }
                }
            });
            receptor.start();

            System.out.println("Cliente Java iniciado. Escribe mensajes para enviar al servidor C#. Escribe 'salir' para terminar.");
            while (true) {
                System.out.print("> ");
                String mensaje = scanner.nextLine();
                if (mensaje.equalsIgnoreCase("salir")) break;

                byte[] buffer = mensaje.getBytes("UTF-8");
                DatagramPacket paquete = new DatagramPacket(buffer, buffer.length, ipServidor, puertoServidor);
                socket.send(paquete);
            }

            socket.close();
            System.out.println("Cliente finalizado.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}