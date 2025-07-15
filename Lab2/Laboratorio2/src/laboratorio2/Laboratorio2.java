package laboratorio2;
// Importamos la clase Scanner del paquete java.util para poder leer datos desde el teclado.
import java.util.Scanner;
// Declaramos la clase principal del programa, llamada Laboratorio2.
public class Laboratorio2 {
    // Método principal donde inicia la ejecución del programa.
    public static void main(String[] args) {
        // Creamos un objeto Scanner para leer la entrada del usuario desde la consola.
        Scanner sc = new Scanner(System.in);
        // Variable que usaremos para guardar la opción seleccionada por el usuario en el menú.
        int opcion = 0;
        // Estructura do-while que se repetirá hasta que el usuario elija salir (opción 4).
        do {
            // Mostramos el menú principal con las distintas opciones disponibles.
            System.out.println("\n--- MENÚ PRINCIPAL ---");
            System.out.println("1. Gestión de Pacientes (Cola)");
            System.out.println("2. Gestión de Historial Médico (Pila)");
            System.out.println("3. Gestión de Inventario de Suministros (Lista doblemente enlazada)");
            System.out.println("4. Salir");
            System.out.print("Seleccione una opción: ");
            
            try {
                // Leemos la opción del usuario como String y la convertimos a entero.
            opcion = Integer.parseInt(sc.nextLine());
            // Este nextLine adicional sirve para limpiar el buffer (aunque aquí puede estar duplicado innecesariamente, si ya usaste sc.nextLine arriba).
            sc.nextLine(); //limpiar el buffer
            // Usamos una estructura switch para ejecutar una acción según la opción seleccionada.
            switch (opcion) {
                case 1:
                    // Llama al método que maneja el menú de gestión de pacientes.
                    // Se asume que usa una estructura tipo Cola (Queue).
                    GestionCentroMedico.menuPacientes(sc);
                    break;
                case 2:
                    // Llama al método para gestionar el historial médico.
                    // Este menú probablemente usa una estructura tipo Pila (Stack).
                    GestionCentroMedico.menuHistorial(sc);
                    break;
                case 3:
                    // Llama al menú para gestionar el inventario de suministros médicos.
                    // Aquí se trabaja con una Lista Doblemente Enlazada.
                    GestionCentroMedico.menuInventario(sc);
                    break;
                case 4:
                    // Mensaje cuando el usuario decide salir del programa.
                    System.out.println("Saliendo del sistema...");
                    break;
                default:
                    // Mensaje de error si el usuario ingresa un número fuera del rango 1-4.
                    System.out.println("Opción inválida.");
            }
             } catch (NumberFormatException e) {
                // Captura el error si el usuario ingresa un valor que no es un número.
                System.out.println("Entrada inválida. Por favor, ingrese un número.");
                }
        // El ciclo se repite mientras la opción seleccionada no sea 4 (salir).
        } while (opcion != 4);
        // Cerramos el objeto Scanner para liberar recursos.
        sc.close();
    }
    
}
