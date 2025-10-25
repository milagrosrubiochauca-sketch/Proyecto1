import 'package:flutter/material.dart';

class CrearPresupuesto extends StatefulWidget {
  const CrearPresupuesto({super.key});

  @override
  State<CrearPresupuesto> createState() => _CrearPresupuestoState();
}

class _CrearPresupuestoState extends State<CrearPresupuesto> {
  String? categoriaSeleccionada;
  double limiteGasto = 0.0;
  double metaAhorro = 0.0;

  final List<String> categorias = [
    'Comida',
    'Transporte',
    'Ocio',
    'Estudios',
    'Salud',
    'Ropa',
    'Hogar',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear presupuesto',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Subtítulo
            const Text(
              '¿Qué categoría de gasto quieres presupuestar?',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            // Campo de categoría
            _buildCampoCategoria(),

            const SizedBox(height: 20),

            // Campo de límite de gasto
            _buildCampoLimiteGasto(),

            const SizedBox(height: 20),

            // Campo de meta de ahorro
            _buildCampoMetaAhorro(),

            const Spacer(),

            // Botón Siguiente
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _puedeContinuar()
                    ? () {
                        _guardarPresupuesto();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _puedeContinuar()
                      ? Colors.blue
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoCategoria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: categoriaSeleccionada,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Selecciona una categoría'),
              ),
              items: categorias.map((String categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(categoria),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  categoriaSeleccionada = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoLimiteGasto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Límite de gasto',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'S/ 0.00',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.attach_money),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              limiteGasto = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCampoMetaAhorro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meta de ahorro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'S/ 0.00',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.savings),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              metaAhorro = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  bool _puedeContinuar() {
    return categoriaSeleccionada != null &&
        categoriaSeleccionada!.isNotEmpty &&
        limiteGasto > 0;
  }

  void _guardarPresupuesto() {
    // Aquí guardaremos el presupuesto (luego se conectará con el backend)
    print('Presupuesto guardado:');
    print('Categoría: $categoriaSeleccionada');
    print('Límite de gasto: S/ $limiteGasto');
    print('Meta de ahorro: S/ $metaAhorro');

    // Mostrar mensaje de éxito y regresar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Presupuesto creado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}
