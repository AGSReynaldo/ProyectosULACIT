/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package laboratorio2;
// Importamos todas las clases del paquete java.util (Scanner, Queue, Stack, LinkedList, etc.)
import java.util.*;

/**
 *
 * @author gabriel-bermudez
 */
public class GestionCentroMedico {
    // ---------- Atributos estáticos ----------
    
    // Cola para almacenar los pacientes en orden de llegada
    private static Queue<String> colaPacientes = new LinkedList<>();
    
    // Variable booleana para saber si está abierta una estación médica temporal (si hay muchos pacientes en cola).
    private static boolean estacionTemporalAbierta = false;
    
    // Pila para guardar el historial médico, con el último paciente en la cima.
    private static Stack<String> historialMedico = new Stack<>();

    // Lista doblemente enlazada para manejar los suministros médicos (se puede insertar/quitar al inicio y al final).
    private static LinkedList<String> inventarioSuministros = new LinkedList<>();

    // ========== MENÚ PACIENTES ==========
    /*
     * Muestra el menú de gestión de pacientes usando una cola.
     * Permite agregar pacientes, atender al siguiente y mostrar el estado de la cola.
     */
    public static void menuPacientes(Scanner sc) {
        int opcion = 0;
        do {
            // Mostrar opciones al usuario
            System.out.println("\n--- GESTIÓN DE PACIENTES ---");
            System.out.println("1. Agregar un paciente a la cola");
            System.out.println("2. Atender al siguiente paciente");
            System.out.println("3. Mostrar estado de la sala de espera");
            System.out.println("4. Volver al menú principal");
            System.out.print("Seleccione una opción: ");
            
            try {
            opcion = Integer.parseInt(sc.nextLine());// Leemos opción
            sc.nextLine();// Limpiar buffer

            switch (opcion) {
                case 1:
                    // Agregar paciente a la cola
                    System.out.print("Nombre del paciente: ");
                    String nombre = sc.nextLine();
                    colaPacientes.add(nombre);
                    System.out.println(nombre + " agregado a la cola.");
                    verificarEstacionTemporal();// Verifica si se necesita abrir o cerrar la estación médica temporal
                    break;
                case 2:
                     // Atender al siguiente paciente (quitar de la cola)
                    if (!colaPacientes.isEmpty()) {
                        String atendido = colaPacientes.poll();
                        System.out.println("Atendiendo a " + atendido);
                        verificarEstacionTemporal();
                    } else {
                        System.out.println("No hay pacientes en espera.");
                    }
                    break;
                case 3:
                    // Mostrar cantidad de pacientes y estado de estación temporal
                    System.out.println("Pacientes en espera: " + colaPacientes.size());
                    System.out.println("Estación médica temporal: " + (estacionTemporalAbierta ? "Abierta" : "Cerrada"));
                    break;
                case 4:
                    System.out.println("Volviendo al menú principal...");
                    break;
                default:
                    System.out.println("Opción inválida.");
            }
            } catch (NumberFormatException e) {
                System.out.println("Entrada inválida. Por favor, ingrese un número.");
                }
        } while (opcion != 4);// Repite hasta que el usuario elija salir del submenú
    }
    /*
     * Verifica si debe abrirse o cerrarse la estación temporal, según la cantidad de pacientes en la cola.
     */
    private static void verificarEstacionTemporal() {
        if (colaPacientes.size() > 5 && !estacionTemporalAbierta) {
            estacionTemporalAbierta = true;
            System.out.println("Se abre una nueva estación médica temporal.");
        } else if (colaPacientes.size() < 3 && estacionTemporalAbierta) {
            estacionTemporalAbierta = false;
            System.out.println("Se cierra la estación médica temporal.");
        }
    }

    // ========== MENÚ HISTORIAL MÉDICO ==========
   
    /*
     * Muestra el menú de gestión del historial médico usando una pila.
     * Permite agregar pacientes, revisar el último paciente atendido y ver el historial completo.
     */
    public static void menuHistorial(Scanner sc) {
        int opcion = 0;
        do {
            // Mostrar opciones
            System.out.println("\n--- GESTIÓN DE HISTORIAL MÉDICO ---");
            System.out.println("1. Agregar paciente al historial");
            System.out.println("2. Revisar el último paciente atendido");
            System.out.println("3. Mostrar historial completo");
            System.out.println("4. Volver al menú principal");
            System.out.print("Seleccione una opción: ");
            try {
            opcion = Integer.parseInt(sc.nextLine());
            sc.nextLine();

            switch (opcion) {
                case 1:
                    // Agregar paciente a la pila (último en llegar queda en la cima)
                    System.out.print("Nombre del paciente: ");
                    String nombre = sc.nextLine();
                    historialMedico.push(nombre);
                    System.out.println(nombre + " agregado al historial.");
                    break;
                case 2:
                    // Mostrar el último paciente agregado sin eliminarlo (peek)
                    if (!historialMedico.isEmpty()) {
                        System.out.println("Último paciente atendido: " + historialMedico.peek());
                    } else {
                        System.out.println("El historial está vacío.");
                    }
                    break;
                case 3:
                    // Mostrar todos los pacientes del historial (desde el más reciente hacia abajo)
                    System.out.println("Historial completo:");
                    for (String paciente : historialMedico) {
                        System.out.println(paciente);
                    }
                    break;
                case 4:
                    System.out.println("Volviendo al menú principal...");
                    break;
                default:
                    System.out.println("Opción inválida.");
            }
            } catch (NumberFormatException e) {
                System.out.println("Entrada inválida. Por favor, ingrese un número.");
                }
        } while (opcion != 4);
    }

    // ========== MENÚ INVENTARIO ==========
    /*
     * Muestra el menú de gestión del inventario usando una lista doblemente enlazada.
     * Permite agregar suministros, usar el más antiguo y ver el inventario completo.
     */
    public static void menuInventario(Scanner sc) {
        int opcion = 0;
        do {
            // Mostrar opciones
            System.out.println("\n--- GESTIÓN DE INVENTARIO DE SUMINISTROS ---");
            System.out.println("1. Agregar nuevo suministro");
            System.out.println("2. Utilizar suministro más antiguo");
            System.out.println("3. Mostrar inventario actual");
            System.out.println("4. Volver al menú principal");
            System.out.print("Seleccione una opción: ");
            try {
            opcion = Integer.parseInt(sc.nextLine());
            sc.nextLine();

            switch (opcion) {
                case 1:
                    // Agregar al final (último en entrar)
                    System.out.print("Nombre del suministro: ");
                    String suministro = sc.nextLine();
                    inventarioSuministros.addLast(suministro);
                    System.out.println(suministro + " agregado al inventario.");
                    break;
                case 2:
                    // Usar (eliminar) el suministro más antiguo (el primero de la lista)
                    if (!inventarioSuministros.isEmpty()) {
                        String usado = inventarioSuministros.removeFirst();
                        System.out.println("Usando el suministro: " + usado);
                    } else {
                        System.out.println("Inventario vacío.");
                    }
                    break;
                case 3:
                    // Mostrar todos los elementos del inventario
                    System.out.println("Inventario actual:");
                    for (String s : inventarioSuministros) {
                        System.out.println(s);
                    }
                    break;
                case 4:
                    System.out.println("Volviendo al menú principal...");
                    break;
                default:
                    System.out.println("Opción inválida.");
            }
            } catch (NumberFormatException e) {
                System.out.println("Entrada inválida. Por favor, ingrese un número.");
                }
        } while (opcion != 4);
    }
}
