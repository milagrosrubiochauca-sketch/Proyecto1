import 'package:flutter/material.dart';
import 'crear_presupuesto.dart';

class Presupuesto extends StatefulWidget {
  const Presupuesto({super.key});

  @override
  State<Presupuesto> createState() => _PresupuestoState();
}

class _PresupuestoState extends State<Presupuesto> {
  final List<PresupuestoCategoria> presupuestos = [
    PresupuestoCategoria(
      categoria: 'Comida',
      limite: 1500.0,
      gastado: 1200.0,
      color: Colors.blue,
    ),
    PresupuestoCategoria(
      categoria: 'Transporte',
      limite: 1000.0,
      gastado: 800.0,
      color: Colors.green,
    ),
    PresupuestoCategoria(
      categoria: 'Ocio',
      limite: 800.0,
      gastado: 450.0,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Presupuestos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Resumen de presupuestos
            _buildResumenPresupuestos(),

            const SizedBox(height: 24),

            // Título de presupuestos
            const Text(
              'Presupuestos por Categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Lista de presupuestos
            Expanded(
              child: ListView.builder(
                itemCount: presupuestos.length,
                itemBuilder: (context, index) {
                  final presupuesto = presupuestos[index];
                  return _buildTarjetaPresupuesto(presupuesto);
                },
              ),
            ),
          ],
        ),
      ),

      // Botón para crear nuevo presupuesto
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CrearPresupuesto()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildResumenPresupuestos() {
    final totalLimite = presupuestos.fold(0.0, (sum, p) => sum + p.limite);
    final totalGastado = presupuestos.fold(0.0, (sum, p) => sum + p.gastado);
    final porcentajeTotal = (totalGastado / totalLimite) * 100;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Resumen de Presupuestos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Total Límite',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'S/ ${totalLimite.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Total Gastado',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'S/ ${totalGastado.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: porcentajeTotal > 80
                            ? Colors.red
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: totalGastado / totalLimite,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                porcentajeTotal > 100
                    ? Colors.red
                    : porcentajeTotal > 80
                    ? Colors.orange
                    : Colors.green,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${porcentajeTotal.toStringAsFixed(1)}% del presupuesto total',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaPresupuesto(PresupuestoCategoria presupuesto) {
    final porcentaje = (presupuesto.gastado / presupuesto.limite) * 100;
    final estaSobregirado = presupuesto.gastado > presupuesto.limite;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: presupuesto.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _obtenerIconoCategoria(presupuesto.categoria),
                    color: presupuesto.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        presupuesto.categoria,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/ ${presupuesto.gastado.toStringAsFixed(0)} de S/ ${presupuesto.limite.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${porcentaje.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: estaSobregirado
                            ? Colors.red
                            : porcentaje > 80
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                    Text(
                      estaSobregirado ? 'Excedido' : 'Dentro del límite',
                      style: TextStyle(
                        fontSize: 12,
                        color: estaSobregirado
                            ? Colors.red
                            : porcentaje > 80
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Barra de progreso
            LinearProgressIndicator(
              value: presupuesto.gastado / presupuesto.limite,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                estaSobregirado
                    ? Colors.red
                    : porcentaje > 80
                    ? Colors.orange
                    : Colors.green,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),

            const SizedBox(height: 8),

            // Información adicional
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  estaSobregirado
                      ? 'Excedido: S/ ${(presupuesto.gastado - presupuesto.limite).toStringAsFixed(0)}'
                      : 'Disponible: S/ ${(presupuesto.limite - presupuesto.gastado).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: estaSobregirado ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (porcentaje > 80)
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Límite cercano',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _obtenerIconoCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'comida':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'ocio':
        return Icons.movie;
      default:
        return Icons.more_horiz;
    }
  }
}

class PresupuestoCategoria {
  final String categoria;
  final double limite;
  final double gastado;
  final Color color;

  PresupuestoCategoria({
    required this.categoria,
    required this.limite,
    required this.gastado,
    required this.color,
  });
}
