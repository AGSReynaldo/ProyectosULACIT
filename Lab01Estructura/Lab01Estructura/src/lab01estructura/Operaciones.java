/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package lab01estructura;

import java.util.ArrayList;
import java.util.Scanner;
import java.util.InputMismatchException;

public class Operaciones {
    private final Scanner scanner = new Scanner(System.in);
    private final Pila pila = new Pila();

    // === CLASE INTERNA PILA ===
    static class Pila {
        private final ArrayList<Integer> elementos = new ArrayList<>();

        public void push(int elemento) {
            elementos.add(elemento);
        }

        public Integer pop() {
            return isEmpty() ? null : elementos.remove(elementos.size() - 1);
        }

        public Integer peek() {
            return isEmpty() ? null : elementos.get(elementos.size() - 1);
        }

        public boolean isEmpty() {
            return elementos.isEmpty();
        }

        public void mostrar() {
            System.out.println("Pila actual: " + elementos);
        }
    }

    // === OPCIÓN 1: FIBONACCI ===
    public void calcularFibonacci() {
        try {
        System.out.println("Por favor selecciona cual funcion deseas realizar: \n1. Funcion de Fibonnaci Recursiva. \n2. Funcion Fibonnaci Iterativa. \n3. Volver al menu principal.");
        int r = scanner.nextInt();
        
        switch (r) {
                    case 1:
                        FibonnaciRecursivo();
                        break;
                    case 2:
                        FibonnaciIterativo();
                        break;
                    case 3:
                        break;
                    default:
                        System.out.println("Opción no válida.");
        }
        } catch (InputMismatchException e) {
            System.out.println("Entrada inválida. Debe ingresar un número entero.");
        }
    }

    public void FibonnaciRecursivo(){
          System.out.print("Introduce el número de elementos a mostrar de la serie: ");
          int limite = scanner.nextInt();

 
          for(int i = 0; i<limite; i++){
               System.out.print(funcionFibonacci(i) + ", ");
          }
     }
     private static int funcionFibonacci(int num){
          if(num == 0 || num==1)
               return num;
          else
               return funcionFibonacci(num-1) + funcionFibonacci(num-2);
     }
     public void FibonnaciIterativo(){
                int n1 = 0;
		int n2 = 1;
		System.out.print("Introduce el número de elementos a mostrar de la serie: ");
		int limite = scanner.nextInt();	

		System.out.print(n1 + ", ");
		System.out.print(n2 + ", ");

		for(int i = 0; i<limite-2; i++){
			n2 = n1 + n2;
			n1 = n2 - n1;
			System.out.print(n2 + ", ");
		}
     }

    // === OPCIÓN 2: PILA ===
    public void operarConPila() {
        int opcion = 0;
        do {
            try {
                System.out.println("\n--- OPERACIONES CON PILA ---");
                System.out.println("1. Push");
                System.out.println("2. Pop");
                System.out.println("3. Peek");
                System.out.println("4. isEmpty");
                System.out.println("5. Volver al menú principal");
                System.out.print("Seleccione una opción: ");
                opcion = Integer.parseInt(scanner.nextLine());

                switch (opcion) {
                    case 1:
                        System.out.print("Ingrese valor a insertar: ");
                        int valor = Integer.parseInt(scanner.nextLine());
                        pila.push(valor);
                        pila.mostrar();
                        break;
                    case 2:
                        Integer eliminado = pila.pop();
                        System.out.println(eliminado != null ? "Elemento eliminado: " + eliminado : "La pila está vacía.");
                        pila.mostrar();
                        break;
                    case 3:
                        Integer tope = pila.peek();
                        System.out.println(tope != null ? "Elemento superior: " + tope : "La pila está vacía.");
                        break;
                    case 4:
                        System.out.println("¿Está vacía la pila? " + pila.isEmpty());
                        break;
                    case 5:
                        break;
                    default:
                        System.out.println("Opción no válida.");
                }
            } catch (InputMismatchException e) {
                System.out.println("Entrada inválida. Ingrese un número.");
            }
        } while (opcion != 5);
    }

    // === OPCIÓN 3: TORRES DE HANOI ===
    public void resolverTorresDeHanoi() {
        try {
            System.out.print("Ingrese el número de discos: ");
            int discos = Integer.parseInt(scanner.nextLine());
            if (discos <= 0) {
                System.out.println("Debe ingresar un número mayor que 0.");
                return;
            }
            System.out.println("Movimientos para " + discos + " discos:");
            hanoi(discos, 'A', 'B', 'C');
        } catch (InputMismatchException e) {
            System.out.println("Entrada inválida. Debe ser un número entero.");
        }
    }

    private void hanoi(int n, char origen, char auxiliar, char destino) {
        if (n == 1) {
            System.out.println("Mover disco 1 de " + origen + " a " + destino);
        } else {
            hanoi(n - 1, origen, destino, auxiliar);
            System.out.println("Mover disco " + n + " de " + origen + " a " + destino);
            hanoi(n - 1, auxiliar, origen, destino);
        }
    }
}

