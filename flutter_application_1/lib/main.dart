import 'package:flutter/material.dart';
import 'package:flutter_application_1/presupuesto.dart';
import 'metas_ahorro.dart';
import 'reportes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Finanz App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceNavegacion = 0;

  // Datos de ejemplo (luego vendrán del backend)
  final double presupuestoTotal = 2500.0;
  final double gastadoTotal = 1850.0;
  final List<CategoriaGasto> categorias = [
    CategoriaGasto(nombre: 'Comida', monto: 750.0, color: Colors.blue),
    CategoriaGasto(nombre: 'Transporte', monto: 300.0, color: Colors.green),
    CategoriaGasto(nombre: 'Ocio', monto: 450.0, color: Colors.orange),
    CategoriaGasto(nombre: 'Otros', monto: 350.0, color: Colors.purple),
  ];

  double get porcentajeGastado => (gastadoTotal / presupuestoTotal) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Finanz App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _construirCuerpo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceNavegacion,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _indiceNavegacion = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Metas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Presupuesto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }

  Widget _construirCuerpo() {
    switch (_indiceNavegacion) {
      case 0: // Inicio
        return _construirPantallaInicio();
      case 1: // Metas
        return const MetasAhorroScreen();
      case 2: // Presupuesto
        return const Presupuesto();
      case 3: // Reportes
        return const ReportesScreen();
      default:
        return _construirPantallaInicio();
    }
  }

  Widget _construirPantallaInicio() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de resumen presupuesto
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Tabla de presupuesto vs gastado
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Presupuesto',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Gastado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'S/ $presupuestoTotal',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'S/ $gastadoTotal',
                              style: TextStyle(
                                fontSize: 18,
                                color: porcentajeGastado > 80
                                    ? Colors.red
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Barra de progreso
                  LinearProgressIndicator(
                    value: gastadoTotal / presupuestoTotal,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      porcentajeGastado > 100
                          ? Colors.red
                          : porcentajeGastado > 80
                          ? Colors.orange
                          : Colors.green,
                    ),
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 8),

                  // Texto de gastado
                  Text(
                    'Gastado: S/ $gastadoTotal de S/ $presupuestoTotal',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${porcentajeGastado.toStringAsFixed(1)}% del presupuesto',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Título de categorías
          const Text(
            'Gastos por Categoría',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Lista de categorías (NO CLICKEABLES - solo visual)
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                final porcentajeCategoria =
                    (categoria.monto / gastadoTotal) * 100;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: categoria.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _obtenerIconoCategoria(categoria.nombre),
                        color: categoria.color,
                      ),
                    ),
                    title: Text(categoria.nombre),
                    subtitle: LinearProgressIndicator(
                      value: categoria.monto / gastadoTotal,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        categoria.color,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'S/ ${categoria.monto.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${porcentajeCategoria.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para obtener iconos según categoría
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

// Modelo para categorías de gasto
class CategoriaGasto {
  final String nombre;
  final double monto;
  final Color color;

  CategoriaGasto({
    required this.nombre,
    required this.monto,
    required this.color,
  });
}
