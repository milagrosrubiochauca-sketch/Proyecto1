public class Usuario {
    private String nombre;
    private int edad;
    private double presupuestoMensual;

    public Usuario(String nombre, int edad, double presupuestoMensual) {
        this.nombre = nombre;
        this.edad = edad;
        this.presupuestoMensual = presupuestoMensual;
    }

    public String getNombre() {
        return nombre;
    }

    public int getEdad() {
        return edad;
    }

    public double getPresupuestoMensual() {
        return presupuestoMensual;
    }

    public void mostrarInfo() {
        System.out.println("Usuario: " + nombre + " | Edad: " + edad + " | Presupuesto: S/." + presupuestoMensual);
    }
}
