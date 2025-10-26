public class FinanzasService {

    public void calcularBalance(Usuario usuario, Transaccion[] transacciones) {
        double total = usuario.getPresupuestoMensual();
        for (Transaccion t : transacciones) {
            if (t.getTipo().equalsIgnoreCase("gasto")) {
                total -= t.getMonto();
            } else if (t.getTipo().equalsIgnoreCase("ingreso")) {
                total += t.getMonto();
            }
        }
        System.out.println("Balance final de " + usuario.getNombre() + ": S/." + total);
    }

    public static void main(String[] args) {
        Usuario usuario = new Usuario("Alejandra", 21, 800);
        Transaccion[] movimientos = {
            new Transaccion("gasto", 150),
            new Transaccion("ingreso", 200),
            new Transaccion("gasto", 50)
        };

        FinanzasService app = new FinanzasService();
        usuario.mostrarInfo();
        for (Transaccion t : movimientos) {
            t.mostrarTransaccion();
        }
        app.calcularBalance(usuario, movimientos);
    }
}
