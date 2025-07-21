package trabajo_investigativo;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Scanner;

/**
 * Juego simple de Tres en Raya (Tic-Tac-Toe) usando Minimax con profundidad limitada y aleatoriedad.
 * - Tablero 3x3.
 * - Usuario juega con 'X'.
 * - IA juega con 'O'.
 * - Entrada sencilla por consola (fila y columna).
 * - Minimax limitado a profundidad 4 para hacerlo menos perfecto.
 * - Aleatoriedad para que la IA no siempre haga la misma jugada.
 */
public class Minimax {

    // Constantes para representar jugadores y casillas vacías
    static final char HUMAN = 'X';    // Jugador humano
    static final char AI = 'O';       // IA
    static final char EMPTY = ' ';    // Casilla vacía

    // Tablero de 3x3 que usaremos en el juego
    static char[][] board = new char[3][3];

    // Límite de profundidad para Minimax (reduce la "visión" de la IA)
    static final int PROFUNDIDAD_MAX = 4;

    // Generador de números aleatorios para variar jugadas con igual puntuación
    static Random rand = new Random();

    /**
     * Método principal para jugar al Tres en Raya.
     * Controla el flujo del juego: mostrar tablero, leer jugadas y ejecutar Minimax.
     */
    public static void jugar() {
        Scanner sc = new Scanner(System.in);  // Scanner para entrada del usuario
        inicializarTablero();                  // Prepara el tablero vacío

        while (true) {
            imprimirTablero();                 // Muestra el tablero actual

            if (finDelJuego()) {               // Verifica si alguien ganó o hay empate
                break;                        // Sale del ciclo para terminar juego
            }

            // Turno humano: leer jugada con validación
            boolean jugadaValida = false;
            while (!jugadaValida) {
                try {
                    System.out.print("Tu jugada - fila (0-2): ");
                    int fila = sc.nextInt();
                    System.out.print("Tu jugada - columna (0-2): ");
                    int col = sc.nextInt();

                    // Verifica que la casilla esté dentro del tablero y vacía
                    if (fila >= 0 && fila < 3 && col >= 0 && col < 3) {
                        if (board[fila][col] == EMPTY) {
                            board[fila][col] = HUMAN;  // Marca la jugada humana
                            jugadaValida = true;       // Sale del ciclo
                        } else {
                            System.out.println("Esa casilla ya está ocupada. Intenta otra.");
                        }
                    } else {
                        System.out.println("Fila y columna deben estar entre 0 y 2.");
                    }
                } catch (Exception e) {
                    System.out.println("Por favor, ingresa números válidos.");
                    sc.nextLine(); // Limpia buffer de entrada por error
                }
            }

            if (finDelJuego()) {               // Verifica fin del juego tras jugada humana
                imprimirTablero();             // Muestra resultado final
                break;
            }

            // Turno de la IA: calcula la mejor jugada usando minimax limitado
            System.out.println("Turno de la IA...");
            int[] mejorJugada = mejorMovimiento();  // Obtiene la jugada óptima (con aleatoriedad)
            board[mejorJugada[0]][mejorJugada[1]] = AI;  // Marca la jugada IA
        }

        // No cerramos Scanner para evitar error al volver a usar System.in
    }

    /**
     * Inicializa el tablero con espacios vacíos.
     */
    static void inicializarTablero() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                board[i][j] = EMPTY;
            }
        }
    }

    /**
     * Imprime el tablero actual en consola.
     */
    static void imprimirTablero() {
        System.out.println("\nTablero:");
        for (int i = 0; i < 3; i++) {
            System.out.print(" ");
            for (int j = 0; j < 3; j++) {
                System.out.print(board[i][j]);
                if (j < 2) System.out.print(" | ");
            }
            System.out.println();
            if (i < 2) System.out.println("---+---+---");
        }
        System.out.println();
    }

    /**
     * Verifica si el juego terminó por victoria o empate.
     * @return true si ganó alguien o empate, false si continúa.
     */
    static boolean finDelJuego() {
        if (gano(HUMAN)) {
            System.out.println("¡Felicidades! Ganaste.");
            return true;
        }
        if (gano(AI)) {
            System.out.println("La IA ha ganado. Mejor suerte la próxima vez.");
            return true;
        }
        if (tableroLleno()) {
            System.out.println("Empate. No quedan movimientos.");
            return true;
        }
        return false;
    }

    /**
     * Verifica si un jugador ganó (3 en línea).
     * @param jugador El carácter que representa al jugador ('X' o 'O').
     * @return true si el jugador ganó, false si no.
     */
    static boolean gano(char jugador) {
        // Revisar filas y columnas
        for (int i = 0; i < 3; i++) {
            if ((board[i][0] == jugador && board[i][1] == jugador && board[i][2] == jugador) ||
                (board[0][i] == jugador && board[1][i] == jugador && board[2][i] == jugador)) {
                return true;
            }
        }
        // Revisar diagonales
        if ((board[0][0] == jugador && board[1][1] == jugador && board[2][2] == jugador) ||
            (board[0][2] == jugador && board[1][1] == jugador && board[2][0] == jugador)) {
            return true;
        }
        return false;
    }

    /**
     * Verifica si el tablero está completamente lleno.
     * @return true si no hay casillas vacías, false si hay al menos una vacía.
     */
    static boolean tableroLleno() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == EMPTY) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Algoritmo Minimax con límite de profundidad.
     * Evalúa el tablero para encontrar el mejor puntaje posible.
     * @param tablero El estado actual del tablero.
     * @param profundidad Nivel actual en el árbol de búsqueda.
     * @param esMaximizador True si es turno de la IA (maximizar puntaje), false si es turno humano (minimizar).
     * @return Puntaje evaluado para el tablero dado.
     */
    static int minimax(char[][] tablero, int profundidad, boolean esMaximizador) {
        // Caso base: verificar si alguien ganó o empate o profundidad máxima
        if (gano(AI)) return 10 - profundidad;    // Mejor cuanto antes gane la IA
        if (gano(HUMAN)) return profundidad - 10; // Peor para la IA si gana humano
        if (tableroLleno() || profundidad >= PROFUNDIDAD_MAX) return 0; // Empate o límite de búsqueda

        if (esMaximizador) {
            int mejorPuntaje = Integer.MIN_VALUE;

            // Probar cada movimiento posible para IA
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    if (tablero[i][j] == EMPTY) {
                        tablero[i][j] = AI;   // Simular jugada IA
                        int puntaje = minimax(tablero, profundidad + 1, false); // Siguiente turno humano
                        tablero[i][j] = EMPTY; // Deshacer jugada
                        mejorPuntaje = Math.max(puntaje, mejorPuntaje);
                    }
                }
            }
            return mejorPuntaje;
        } else {
            int mejorPuntaje = Integer.MAX_VALUE;

            // Probar cada movimiento posible para humano
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    if (tablero[i][j] == EMPTY) {
                        tablero[i][j] = HUMAN;  // Simular jugada humano
                        int puntaje = minimax(tablero, profundidad + 1, true);  // Siguiente turno IA
                        tablero[i][j] = EMPTY;  // Deshacer jugada
                        mejorPuntaje = Math.min(puntaje, mejorPuntaje);
                    }
                }
            }
            return mejorPuntaje;
        }
    }

    /**
     * Busca la mejor jugada para la IA usando minimax con profundidad limitada y elige aleatoriamente entre igual puntaje.
     * @return Arreglo con fila y columna de la mejor jugada.
     */
    static int[] mejorMovimiento() {
        int mejorPuntaje = Integer.MIN_VALUE;
        List<int[]> mejoresMovimientos = new ArrayList<>(); // Lista para guardar movimientos igual de buenos

        // Evaluar cada casilla vacía
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == EMPTY) {
                    board[i][j] = AI;   // Simular jugada IA
                    int puntaje = minimax(board, 0, false); // Evaluar con minimax
                    board[i][j] = EMPTY; // Deshacer jugada

                    if (puntaje > mejorPuntaje) {
                        mejorPuntaje = puntaje;
                        mejoresMovimientos.clear();           // Limpiar lista
                        mejoresMovimientos.add(new int[]{i, j}); // Guardar nuevo mejor movimiento
                    } else if (puntaje == mejorPuntaje) {
                        mejoresMovimientos.add(new int[]{i, j}); // Agregar si igual puntaje
                    }
                }
            }
        }

        // Elegir al azar uno de los mejores movimientos para hacer juego menos predecible
        return mejoresMovimientos.get(rand.nextInt(mejoresMovimientos.size()));
    }
}

