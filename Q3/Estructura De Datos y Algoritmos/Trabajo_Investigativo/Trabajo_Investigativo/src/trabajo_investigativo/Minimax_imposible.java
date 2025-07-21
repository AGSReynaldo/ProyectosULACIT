/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package trabajo_investigativo;

import java.util.InputMismatchException;
import java.util.Scanner;

/**
 * Juego simple de Tres en Raya (Tic-Tac-Toe) usando Minimax.
 * - Tablero 3x3.
 * - Usuario juega con 'X'.
 * - IA juega con 'O'.
 * - Entrada sencilla por consola (fila y columna).
 */
public class Minimax_imposible {

    static final char HUMAN = 'X';
    static final char AI = 'O';
    static final char EMPTY = ' ';

    static char[][] board = new char[3][3];

    public static void jugar() {
        Scanner sc = new Scanner(System.in);
        inicializarTablero();

        while (true) {
            imprimirTablero();

            if (finDelJuego()) {
                break;
            }

            // Turno humano
            boolean jugadaValida = false;
            while (!jugadaValida) {
                try {
                    System.out.print("Tu jugada - fila (0-2): ");
                    int fila = sc.nextInt();
                    System.out.print("Tu jugada - columna (0-2): ");
                    int col = sc.nextInt();

                    if (fila >= 0 && fila < 3 && col >= 0 && col < 3) {
                        if (board[fila][col] == EMPTY) {
                            board[fila][col] = HUMAN;
                            jugadaValida = true;
                        } else {
                            System.out.println("Esa casilla ya está ocupada. Intenta otra.");
                        }
                    } else {
                        System.out.println("Fila y columna deben estar entre 0 y 2.");
                    }
                } catch (InputMismatchException e) {
                    System.out.println("Por favor, ingresa números válidos.");
                    sc.nextLine(); // limpiar buffer
                }
            }

            if (finDelJuego()) {
                imprimirTablero();
                break;
            }

            // Turno IA
            System.out.println("Turno de la IA...");
            int[] mejorJugada = mejorMovimiento();
            board[mejorJugada[0]][mejorJugada[1]] = AI;
        }
    }

    static void inicializarTablero() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                board[i][j] = EMPTY;
            }
        }
    }

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

    static boolean gano(char jugador) {
        // Revisar filas, columnas y diagonales
        for (int i = 0; i < 3; i++) {
            if ((board[i][0] == jugador && board[i][1] == jugador && board[i][2] == jugador) ||
                (board[0][i] == jugador && board[1][i] == jugador && board[2][i] == jugador)) {
                return true;
            }
        }
        if ((board[0][0] == jugador && board[1][1] == jugador && board[2][2] == jugador) ||
            (board[0][2] == jugador && board[1][1] == jugador && board[2][0] == jugador)) {
            return true;
        }
        return false;
    }

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

    // Minimax básico que evalúa el tablero y devuelve el puntaje
    static int minimax(char[][] tablero, boolean esMaximizador) {
        if (gano(AI)) return 1;
        if (gano(HUMAN)) return -1;
        if (tableroLleno()) return 0;

        if (esMaximizador) {
            int mejorPuntaje = Integer.MIN_VALUE;
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    if (tablero[i][j] == EMPTY) {
                        tablero[i][j] = AI;
                        int puntaje = minimax(tablero, false);
                        tablero[i][j] = EMPTY;
                        mejorPuntaje = Math.max(puntaje, mejorPuntaje);
                    }
                }
            }
            return mejorPuntaje;
        } else {
            int mejorPuntaje = Integer.MAX_VALUE;
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    if (tablero[i][j] == EMPTY) {
                        tablero[i][j] = HUMAN;
                        int puntaje = minimax(tablero, true);
                        tablero[i][j] = EMPTY;
                        mejorPuntaje = Math.min(puntaje, mejorPuntaje);
                    }
                }
            }
            return mejorPuntaje;
        }
    }

    // Encuentra la mejor jugada para la IA
    static int[] mejorMovimiento() {
        int mejorPuntaje = Integer.MIN_VALUE;
        int[] movimiento = new int[2];
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == EMPTY) {
                    board[i][j] = AI;
                    int puntaje = minimax(board, false);
                    board[i][j] = EMPTY;
                    if (puntaje > mejorPuntaje) {
                        mejorPuntaje = puntaje;
                        movimiento[0] = i;
                        movimiento[1] = j;
                    }
                }
            }
        }
        return movimiento;
    }
}