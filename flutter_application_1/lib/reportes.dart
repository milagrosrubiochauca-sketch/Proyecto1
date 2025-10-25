import 'package:flutter/material.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para categorías
    final List<CategoriaReporte> categorias = [
      CategoriaReporte(
        nombre: 'Comida',
        totalGastado: 1250.0,
        subcategorias: [
          Subcategoria(
            nombre: 'Restaurantes',
            monto: 1000.0,
            color: Colors.blue,
          ),
          Subcategoria(
            nombre: 'Supermercados',
            monto: 150.0,
            color: Colors.green,
          ),
          Subcategoria(nombre: 'Cafeterías', monto: 75.0, color: Colors.orange),
          Subcategoria(
            nombre: 'Para llevar',
            monto: 25.0,
            color: Colors.purple,
          ),
        ],
        color: Colors.blue,
      ),
      CategoriaReporte(
        nombre: 'Transporte',
        totalGastado: 800.0,
        subcategorias: [
          Subcategoria(nombre: 'Taxi/Uber', monto: 400.0, color: Colors.red),
          Subcategoria(
            nombre: 'Combustible',
            monto: 300.0,
            color: Colors.orange,
          ),
          Subcategoria(
            nombre: 'Transporte público',
            monto: 100.0,
            color: Colors.green,
          ),
        ],
        color: Colors.green,
      ),
      CategoriaReporte(
        nombre: 'Ocio',
        totalGastado: 450.0,
        subcategorias: [
          Subcategoria(nombre: 'Cine', monto: 200.0, color: Colors.purple),
          Subcategoria(
            nombre: 'Restaurantes',
            monto: 150.0,
            color: Colors.blue,
          ),
          Subcategoria(nombre: 'Eventos', monto: 100.0, color: Colors.orange),
        ],
        color: Colors.orange,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reportes Detallados',
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
            const Text(
              'Resumen de Gastos por Categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Lista de categorías para reportes (CLICKEABLES)
            Expanded(
              child: ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
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
                      subtitle: Text(
                        'S/ ${categoria.totalGastado.toStringAsFixed(0)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _mostrarDetalleCategoria(context, categoria);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalleCategoria(
    BuildContext context,
    CategoriaReporte categoria,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoria.nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'S/ ${categoria.totalGastado.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Desglose de Gastos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: categoria.subcategorias.length,
                  itemBuilder: (context, index) {
                    final subcategoria = categoria.subcategorias[index];
                    final porcentaje =
                        (subcategoria.monto / categoria.totalGastado) * 100;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: subcategoria.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _obtenerIconoSubcategoria(subcategoria.nombre),
                            color: subcategoria.color,
                          ),
                        ),
                        title: Text(subcategoria.nombre),
                        subtitle: LinearProgressIndicator(
                          value: subcategoria.monto / categoria.totalGastado,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            subcategoria.color,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'S/ ${subcategoria.monto.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${porcentaje.toStringAsFixed(1)}%',
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
      },
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

  IconData _obtenerIconoSubcategoria(String subcategoria) {
    switch (subcategoria.toLowerCase()) {
      case 'restaurantes':
        return Icons.restaurant;
      case 'supermercados':
        return Icons.shopping_cart;
      case 'cafeterías':
        return Icons.coffee;
      case 'para llevar':
        return Icons.takeout_dining;
      case 'taxi/uber':
        return Icons.local_taxi;
      case 'combustible':
        return Icons.local_gas_station;
      case 'transporte público':
        return Icons.directions_bus;
      case 'cine':
        return Icons.movie;
      case 'eventos':
        return Icons.event;
      default:
        return Icons.more_horiz;
    }
  }
}

class CategoriaReporte {
  final String nombre;
  final double totalGastado;
  final List<Subcategoria> subcategorias;
  final Color color;

  CategoriaReporte({
    required this.nombre,
    required this.totalGastado,
    required this.subcategorias,
    required this.color,
  });
}

class Subcategoria {
  final String nombre;
  final double monto;
  final Color color;

  Subcategoria({
    required this.nombre,
    required this.monto,
    required this.color,
  });
}
