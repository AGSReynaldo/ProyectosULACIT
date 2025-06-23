/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package lab01estructura;

import java.util.Scanner;


public class Lab01Estructura {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
        Operaciones operaciones = new Operaciones();
        Scanner scanner = new Scanner(System.in);
        int opcion = 0;

        do {
            System.out.println("\n====== MENÚ PRINCIPAL ======");
            System.out.println("1. Calcular Fibonacci (Recursivo e Iterativo)");
            System.out.println("2. Operar con Pila (push, pop, peek, isEmpty)");
            System.out.println("3. Resolver Torres de Hanoi");
            System.out.println("4. Salir");
            System.out.print("Seleccione una opción: ");

            try {
                opcion = Integer.parseInt(scanner.nextLine());

                switch (opcion) {
                    case 1:
                        operaciones.calcularFibonacci();
                        break;
                    case 2:
                        operaciones.operarConPila();
                        break;
                    case 3:
                        operaciones.resolverTorresDeHanoi();
                        break;
                    case 4:
                        System.out.println("Saliendo del programa...");
                        break;
                    default:
                        System.out.println("Opción no válida. Intente de nuevo.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Entrada inválida. Por favor, ingrese un número.");
            }

        } while (opcion != 4);

        scanner.close();
    }
    
}
