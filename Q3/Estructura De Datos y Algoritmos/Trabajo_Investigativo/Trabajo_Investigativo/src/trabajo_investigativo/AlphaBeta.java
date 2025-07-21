package trabajo_investigativo;

import java.util.*;

public class AlphaBeta {
    static Scanner scanner = new Scanner(System.in);
    static final int MAX_MOVIMIENTO = 2; // Cambiado a 2 para más dificultad

    public static void jugar() {
        int fichas = 0;
        while (fichas <= 0) {
            try {
                System.out.print("Ingrese cuántas fichas desea usar para el juego de Nim: ");
                fichas = scanner.nextInt();
                if (fichas <= 0) System.out.println(" Debe ingresar un número mayor a 0.");
            } catch (InputMismatchException e) {
                System.out.println("Entrada inválida. Por favor ingrese un número entero.");
            }
        }

        boolean turnoHumano = true;

        while (fichas > 0) {
            mostrarEstrellas(fichas);
            if (turnoHumano) {
                int quitar = 0;
                while (true) {
                    try {
                        System.out.print("\nTu turno. Elige cuántas fichas quitar (1-" + MAX_MOVIMIENTO + "): ");
                        quitar = scanner.nextInt();
                        if (quitar >= 1 && quitar <= MAX_MOVIMIENTO && quitar <= fichas) break;
                        System.out.println("Movimiento inválido. Intenta de nuevo.");
                    } catch (InputMismatchException e) {
                        System.out.println("Entrada inválida. Por favor ingrese un número entero.");
                        scanner.nextLine();
                    }
                }
                fichas -= quitar;
            } else {
                int quitar = mejorMovimiento(fichas);
                System.out.println("\nIA quita " + quitar + " ficha(s).");
                fichas -= quitar;
            }
            turnoHumano = !turnoHumano;
        }

        if (turnoHumano) {
            System.out.println("\nLa IA gana. Mejor suerte la próxima vez!");
        } else {
            System.out.println("\n¡Ganaste! Eres más listo que la IA.");
        }
    }

    static void mostrarEstrellas(int total) {
        System.out.println("\nEstado actual:");
        int nivel = 1;
        int colocadas = 0;
        while (colocadas < total) {
            int enNivel = Math.min(nivel, total - colocadas);
            for (int i = 0; i < (10 - enNivel); i++) System.out.print(" "); // centrado
            for (int i = 0; i < enNivel; i++) System.out.print("# ");
            System.out.println();
            colocadas += enNivel;
            nivel++;
        }
    }

    static int mejorMovimiento(int fichas) {
        int mejor = -1;
        int mejorValor = Integer.MIN_VALUE;
        for (int i = 1; i <= MAX_MOVIMIENTO; i++) {
            if (i > fichas) break;
            int valor = -alphaBeta(fichas - i, Integer.MIN_VALUE, Integer.MAX_VALUE, false);
            if (valor > mejorValor) {
                mejorValor = valor;
                mejor = i;
            }
        }
        return mejor;
    }

    static int alphaBeta(int fichas, int alpha, int beta, boolean maximizando) {
        if (fichas == 0) return maximizando ? -1 : 1;

        if (maximizando) {
            int valor = Integer.MIN_VALUE;
            for (int i = 1; i <= MAX_MOVIMIENTO; i++) {
                if (i > fichas) break;
                valor = Math.max(valor, alphaBeta(fichas - i, alpha, beta, false));
                alpha = Math.max(alpha, valor);
                if (beta <= alpha) break;
            }
            return valor;
        } else {
            int valor = Integer.MAX_VALUE;
            for (int i = 1; i <= MAX_MOVIMIENTO; i++) {
                if (i > fichas) break;
                valor = Math.min(valor, alphaBeta(fichas - i, alpha, beta, true));
                beta = Math.min(beta, valor);
                if (beta <= alpha) break;
            }
            return valor;
        }
    }
}
