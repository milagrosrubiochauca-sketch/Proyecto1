public class Transaccion {
    private String tipo;
    private double monto;

    public Transaccion(String tipo, double monto) {
        this.tipo = tipo;
        this.monto = monto;
    }

    public void mostrarTransaccion() {
        System.out.println("Transacción: " + tipo + " | Monto: S/." + monto);
    }

    public double getMonto() {
        return monto;
    }

    public String getTipo() {
        return tipo;
    }
}
