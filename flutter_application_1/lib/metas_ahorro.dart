import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

class MetasAhorroScreen extends StatefulWidget {
  const MetasAhorroScreen({super.key});

  @override
  State<MetasAhorroScreen> createState() => _MetasAhorroScreenState();
}

class _MetasAhorroScreenState extends State<MetasAhorroScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<MetaAhorro> _metas = [];

  @override
  void initState() {
    super.initState();
    _cargarMetas();
  }

  Future<void> _cargarMetas() async {
    try {
      final datos = await _dbHelper.getMetas();
      setState(() {
        _metas = datos.map((map) => MetaAhorro.fromMap(map)).toList();
      });
    } catch (e) {
      print('Error cargando metas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Metas de Ahorro',
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

            // Resumen de ahorro total
            _buildResumenAhorro(),

            const SizedBox(height: 24),

            // Título de metas
            const Text(
              'Tus Metas de Ahorro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Lista de metas
            Expanded(
              child: _metas.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay metas de ahorro.\n¡Presiona el botón + para crear una!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _metas.length,
                      itemBuilder: (context, index) {
                        final meta = _metas[index];
                        return _buildTarjetaMeta(meta);
                      },
                    ),
            ),
          ],
        ),
      ),

      // Botón para agregar nueva meta
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaMeta,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildResumenAhorro() {
    final totalObjetivo = _metas.fold(
      0.0,
      (sum, meta) => sum + meta.montoObjetivo,
    );
    final totalActual = _metas.fold(0.0, (sum, meta) => sum + meta.montoActual);
    final porcentajeTotal = totalObjetivo > 0
        ? (totalActual / totalObjetivo) * 100
        : 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Total Ahorrado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'S/ ${totalActual.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'de S/ ${totalObjetivo.toStringAsFixed(0)} objetivo',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: totalObjetivo > 0 ? totalActual / totalObjetivo : 0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${porcentajeTotal.toStringAsFixed(1)}% completado',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaMeta(MetaAhorro meta) {
    final porcentaje = meta.montoObjetivo > 0
        ? (meta.montoActual / meta.montoObjetivo) * 100
        : 0;
    final diasRestantes = meta.fechaObjetivo.difference(DateTime.now()).inDays;

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
                    color: meta.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(meta.icono, color: meta.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meta.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/ ${meta.montoActual.toStringAsFixed(0)} de S/ ${meta.montoObjetivo.toStringAsFixed(0)}',
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
                        color: porcentaje >= 100 ? Colors.green : Colors.blue,
                      ),
                    ),
                    Text(
                      '$diasRestantes días',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Barra de progreso
            LinearProgressIndicator(
              value: meta.montoObjetivo > 0
                  ? meta.montoActual / meta.montoObjetivo
                  : 0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(meta.color),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),

            const SizedBox(height: 8),

            // Información adicional
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Faltan: S/ ${(meta.montoObjetivo - meta.montoActual).toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _formatearFecha(meta.fechaObjetivo),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Botón para agregar ahorro
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _mostrarDialogoAgregarAhorro(meta),
                style: ElevatedButton.styleFrom(
                  backgroundColor: meta.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Agregar Ahorro',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoNuevaMeta() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Meta de Ahorro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la meta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: montoController,
                decoration: const InputDecoration(
                  labelText: 'Monto objetivo (S/)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final montoObjetivo =
                    double.tryParse(montoController.text) ?? 0.0;

                if (nombre.isNotEmpty && montoObjetivo > 0) {
                  final nuevaMeta = MetaAhorro(
                    nombre: nombre,
                    montoObjetivo: montoObjetivo,
                    montoActual: 0.0,
                    fechaObjetivo: DateTime.now().add(const Duration(days: 90)),
                    color: Colors.blue,
                    icono: Icons.savings,
                    creadoEn: DateTime.now(),
                  );

                  try {
                    await _dbHelper.insertMeta(nuevaMeta.toMap());
                    _cargarMetas();
                    Navigator.of(context).pop();

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Meta creada exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al crear meta: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor completa todos los campos correctamente',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoAgregarAhorro(MetaAhorro meta) {
    TextEditingController montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar a ${meta.nombre}'),
          content: TextField(
            controller: montoController,
            decoration: const InputDecoration(
              labelText: 'Monto a agregar (S/)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final montoAAgregar =
                    double.tryParse(montoController.text) ?? 0.0;

                if (montoAAgregar > 0) {
                  final metaActualizada = MetaAhorro(
                    id: meta.id,
                    nombre: meta.nombre,
                    montoObjetivo: meta.montoObjetivo,
                    montoActual: meta.montoActual + montoAAgregar,
                    fechaObjetivo: meta.fechaObjetivo,
                    color: meta.color,
                    icono: meta.icono,
                    creadoEn: meta.creadoEn,
                  );

                  try {
                    await _dbHelper.updateMeta(
                      meta.id!,
                      metaActualizada.toMap(),
                    );
                    _cargarMetas();
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ahorro agregado exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al agregar ahorro: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingresa un monto válido'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
