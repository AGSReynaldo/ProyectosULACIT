/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package trabajo_investigativo;


import java.util.InputMismatchException;
import java.util.Scanner;

/**
 * Clase principal Trabajo_Investigativo.
 * Muestra un menú en consola para que el usuario elija
 * entre ejecutar el algoritmo Minimax o Alpha-Beta Pruning.
 */
public class Trabajo_Investigativo {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int opcion = -1; // Variable para almacenar la opción elegida por el usuario

        // Ciclo que muestra el menú hasta que el usuario decida salir
        do {
            System.out.println("=== MENU DE ALGORITMOS ===");
            System.out.println("1. Ejecutar Minimax");
            System.out.println("2. Ejecutar Minimax IMPOSIBLE");
            System.out.println("3. Ejecutar Alpha-Beta Pruning");
            System.out.println("4. Salir");
            System.out.print("Ingrese una opción: ");

            try {
                opcion = sc.nextInt(); // Lee la opción ingresada

                switch (opcion) {
                    case 1 -> {
                        System.out.println("Ejecutando Minimax...");
                        Minimax.jugar();
                    }
                    case 2 -> {
                        System.out.println("Ejecutando Minimax Nivel IMPOSIBLE...");
                        Minimax_imposible.jugar();
                    }
                    case 3 -> {
                        System.out.println("Ejecutando Alpha-Beta Pruning...");
                        AlphaBeta.jugar();
                    }
                    case 4 -> System.out.println("Saliendo del programa.");
                    default -> System.out.println("Opción inválida. Intente de nuevo.");
                }
            } catch (InputMismatchException e) {
                System.out.println("Entrada inválida. Por favor ingrese un número.");
                sc.nextLine(); // Limpiar el buffer de entrada
            }

        } while (opcion != 4); // Repite hasta que el usuario ingrese 4 para salir

        sc.close(); // Cierra el scanner al terminar
    }
}
